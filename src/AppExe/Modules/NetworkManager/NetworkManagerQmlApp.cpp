#include "NetworkManagerQmlApp.h"
#include <QQmlEngine>
#include <QThread>
#include <QEventLoop>
#include <QProcess>
#include <QDir>
#include <QTimer>
#include <QVariantMap>
#include "NetworkManager.h"

/**
 * Network Manager - Exit Status
 * nmcli exits with status 0 if it succeeds, a value greater than 0 is returned if an error occurs.
 * 0 Success – indicates the operation succeeded.
 * 1 Unknown or unspecified error.
 * 2 Invalid user input, wrong nmcli invocation.
 * 3 Timeout expired (see --wait option).
 * 4 Connection activation failed.
 * 5 Connection deactivation failed.
 * 6 Disconnecting device failed.
 * 7 Connection deletion failed.
 * 8 NetworkManager is not running.
 * 10 Connection, device, or access point does not exist.
 * 65 When used with --complete-args option, a file name is expected to follow.
*/

static NetworkManagerQmlApp* s_instance = nullptr;

QObject* NetworkManagerQmlApp::singletonProvider(QQmlEngine *qmlEngine, QJSEngine *)
{
    if(!s_instance){
        s_instance = new NetworkManagerQmlApp(qmlEngine);
    }
    return s_instance;
}

void NetworkManagerQmlApp::init()
{
    if (m_pThread) return;

    m_pThread = QThread::create([&](){
        //        qDebug() << __func__ << thread();

        m_pNetworkManager.reset(new NetworkManager());

        QTimer periodicCheckConnection;
        periodicCheckConnection.setInterval(20000); /// check every 20 seconds
        QObject::connect(&periodicCheckConnection, &QTimer::timeout,
                         this, &NetworkManagerQmlApp::readStatus);
        periodicCheckConnection.start();

        /// READ STATUS
        setReadingState(true);
        bool connected      = false;
        QString typeConn    = "";
        QString connName    = "";
        QString ipv4        = "";
        m_pNetworkManager->readStatus(&connected, &typeConn, &connName, &ipv4);
        setIPv4(ipv4);
        setConnName(connName);
        setTypeConn(typeConn);
        setConnectedStatus(connected);
        setReadingState(false);

        /// listen for event requesting
        QEventLoop loop;
        loop.exec();

        ///clean up
        periodicCheckConnection.stop();
        /// once closed this scope, m_pThread will emit finished signal
        /// then that signal will tell Qt to do delete that object
    });

    /// Tells the thread's event loop to exit with return code 0 (success).
    /// Equivalent to calling QThread::exit(0).
    /// This function does nothing if the thread does not have an event loop.
    connect(this, &NetworkManagerQmlApp::destroyed, m_pThread, &QThread::quit);
    connect(m_pThread, &QThread::finished, m_pThread, &QThread::deleteLater);
    ///just for debug
#ifdef QT_DEBUG
    connect(m_pThread, &QThread::destroyed, m_pThread, [&]{
        qDebug() << "NetworkManager::m_pThread::destroyed";
    });
#endif
    m_pThread->start();
}

NetworkManagerQmlApp::NetworkManagerQmlApp(QObject *parent) : QObject(parent)
{
    qDebug() << __func__ << thread();
}

NetworkManagerQmlApp::~NetworkManagerQmlApp()
{
    qDebug() << "~NetworkManagerQmlApp()";
}

void NetworkManagerQmlApp::readStatus()
{
    //    qDebug() << __func__ << thread();
    if(!m_pThread->isRunning()) return;
    if (m_reading) return;
    setReadingState(true);

    QMetaObject::invokeMethod(m_pNetworkManager.data(), [&]{
        //        qDebug() << __func__ << thread();

        bool connected      = false;
        QString typeConn    = "";
        QString connName    = "";
        QString ipv4        = "";
        m_pNetworkManager->readStatus(&connected, &typeConn, &connName, &ipv4);

        setIPv4(ipv4);
        setConnName(connName);
        setTypeConn(typeConn);
        setConnectedStatus(connected);

        setReadingState(false);
    });
}

void NetworkManagerQmlApp::scanAccessPoint()
{
    qDebug() << __func__ << thread();
    if(!m_pThread->isRunning()) return;
    if(m_scanning) return;
    setScanningState(true);

    QMetaObject::invokeMethod(m_pNetworkManager.data(), [&]{
        QStringList apRaw;
        m_pNetworkManager->scanAccessPoint(&apRaw);

        /// Convert the result to more pretties format as a json object
        QVariantList apPretties;
        QVariantMap apItem;
        QStringList key = {"exist", "name", "signal", "security"};
        QStringList data;
        for(int i=0; i<apRaw.length(); i++){
            data = apRaw[i].split(":");
            //            qDebug() << "data" << data;
            apItem.clear();
            for (int j=0; j<key.length(); j++){
                apItem.insert(key[j], data[j]);
            }
            apPretties.push_back(apItem);
        }

        //        qDebug() << apPretties;
        setAccessPointAvailable(apPretties);

        setScanningState(false);
    });
}

void NetworkManagerQmlApp::connectToNewAccessPoint(const QString connName, const QString password)
{
    qDebug() << __func__ << thread();
    if(!m_pThread->isRunning()) return;
    if(m_connecting) return;
    setConnectingState(true);
    setConnectedStatus(false);
    setConnName("");
    setIPv4("");

    QMetaObject::invokeMethod(m_pNetworkManager.data(), [&, connName, password]{
        m_pNetworkManager->connectToNewAccessPoint(connName, password);

        setConnectingState(false);
    });
}

void NetworkManagerQmlApp::connectTo(const QString connName)
{
    qDebug() << __func__ << thread();
    if(!m_pThread->isRunning()) return;
    if(m_connecting) return;
    setConnectingState(true);
    setConnectedStatus(false);
    setConnName("");
    setIPv4("");

    QMetaObject::invokeMethod(m_pNetworkManager.data(), [&, connName]{
        m_pNetworkManager->connectTo(connName);

        setConnectingState(false);
    });
}

void NetworkManagerQmlApp::forgetConnection(const QString connName)
{
    qDebug() << __func__ << thread();
    if(!m_pThread->isRunning()) return;
    if(m_forgettingConn) return;
    setForgettingConnState(true);

    QMetaObject::invokeMethod(m_pNetworkManager.data(), [&, connName]{
        m_pNetworkManager->forgetConnection(connName);

        setForgettingConnState(false);
        readStatus();
        scanAccessPoint();
    });
}

void NetworkManagerQmlApp::setForgettingConnState(bool forgettingConn)
{
    qDebug() << __func__ << thread();

    if (m_forgettingConn == forgettingConn)
        return;

    m_forgettingConn = forgettingConn;
    emit forgettingConnStateChanged(m_forgettingConn);
}

void NetworkManagerQmlApp::setConnectingState(bool connecting)
{
    qDebug() << __func__ << thread();

    if (m_connecting == connecting)
        return;

    m_connecting = connecting;
    emit connectingStateChanged(m_connecting);
}

void NetworkManagerQmlApp::setScanningState(bool scanning)
{
    qDebug() << __func__ << thread();

    if (m_scanning == scanning)
        return;

    m_scanning = scanning;
    emit scanningStateChanged(m_scanning);
}

void NetworkManagerQmlApp::setReadingState(bool reading)
{
    //    qDebug() << __func__ << thread();

    if (m_reading == reading)
        return;

    m_reading = reading;
    emit readingStateChanged(m_reading);
}

bool NetworkManagerQmlApp::getForgettingConnState() const
{
    return m_forgettingConn;
}

bool NetworkManagerQmlApp::getConnectedStatus() const
{
    return m_connected;
}

QString NetworkManagerQmlApp::getConnName() const
{
    return m_connName;
}

QString NetworkManagerQmlApp::getIPv4() const
{
    return m_ipv4;
}

QString NetworkManagerQmlApp::getTypeConn() const
{
    return m_typeConn;
}

QVariantList NetworkManagerQmlApp::getAcceessPointAvailable() const
{
    return m_acceessPointListName;
}

void NetworkManagerQmlApp::setConnectedStatus(bool connected)
{
    if (m_connected == connected)
        return;

    m_connected = connected;
    emit connectedStatusChanged(m_connected);
}

void NetworkManagerQmlApp::setConnName(QString connName)
{
    if (m_connName == connName)
        return;

    m_connName = connName;
    emit connNameChanged(m_connName);
}

void NetworkManagerQmlApp::setIPv4(QString ipv4)
{
    if (m_ipv4 == ipv4)
        return;

    m_ipv4 = ipv4;
    emit ipv4Changed(m_ipv4);
}

void NetworkManagerQmlApp::setTypeConn(QString typeConn)
{
    if (m_typeConn == typeConn)
        return;

    m_typeConn = typeConn;
    emit typeConnChanged(m_typeConn);
}

void NetworkManagerQmlApp::setAccessPointAvailable(QVariantList acceessPointListName)
{
    if (m_acceessPointListName == acceessPointListName)
        return;

    m_acceessPointListName = acceessPointListName;
    emit acceessPointAvailableChanged(m_acceessPointListName);
}

bool NetworkManagerQmlApp::getConnectingState() const
{
    return m_connecting;
}

bool NetworkManagerQmlApp::getScanningState() const
{
    return m_scanning;
}

bool NetworkManagerQmlApp::getReadingState() const
{
    return m_reading;
}
