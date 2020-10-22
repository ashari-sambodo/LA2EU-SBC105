#include "NetworkManager.h"
#include <QQmlEngine>
#include <QThread>
#include <QDebug>

#include <QProcess>
#include <QDir>

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

static NetworkManager* s_instance = nullptr;

QObject* NetworkManager::singletonProvider(QQmlEngine *qmlEngine, QJSEngine *)
{
    if(!s_instance){
        s_instance = new NetworkManager(qmlEngine);
    }
    return s_instance;
}

NetworkManager::NetworkManager(QObject *parent) : QObject(parent)
{
    m_readingStatus     = false;
    m_scanningStatus    = false;
    m_connectingStatus  = false;
    m_connectedStatus   = false;
}

NetworkManager::~NetworkManager()
{
    //    if (m_thread) {
    //        if (m_thread->isRunning()) {
    //            m_thread->terminate();
    //        }
    //    }
}

void NetworkManager::readStatusAsync(/*bool followByScan*/)
{
    //    qDebug() << __FUNCTION__ << QThread::currentThreadId();


    if(!m_thread.isNull()) if(m_thread->isRunning()) return;

    m_thread.reset(QThread::create([=]{

        //        qDebug() << __FUNCTION__ << QThread::currentThreadId();
        //        QThread::sleep(5);
#ifdef __arm__
        readStatus();
#else
        setConnectedStatus(true);
        setAccessPoint("AP_X");
        setIPv4("127.0.0.1");

        emit readStatusFinished();
#endif

    }));

    QObject::connect(m_thread.data(), &QThread::started, [=]{
        setBussy(true);
    });
    QObject::connect(m_thread.data(), &QThread::finished, [=]{
        setBussy(false);
    });
    //    QObject::connect(m_thread.data(), &QThread::finished, [=]{
    //        qDebug() << "m_thread has finished";
    //    });
    //    QObject::connect(m_thread.data(), &QThread::destroyed, [=]{
    //        qDebug() << "m_thread will destroyed";
    //    });

    m_thread->start();

}

void NetworkManager::readStatus()
{
#ifdef __arm__
    /// Check Connection status if connected or not
    QProcess qprocess;
    qprocess.start("nmcli -t dev");
    qprocess.waitForFinished();

    /// Example output, DEVICE:TYPE:STATE:CONNECTION
    /// wlan0:wifi:connected:ESCO_AP
    /// lo:loopback:unmanaged:

    enum IFACE_INDEX {IFACE_WLAN0, IFACE_LOOPBACK};
    enum NSATUS_INDEX {NSTATUS_DEVICE, NSTATUS_TYPE, NSTATUS_STATE, NSTATUS_CONNECTION};

    ///Parse the output
    QString output = qprocess.readAllStandardOutput();

    //    qDebug() << output;

    QStringList devicesStatus = output.split("\n", QString::SkipEmptyParts);

    //    qDebug() << devicesStatus;

    QStringList wlanStatus = devicesStatus[IFACE_WLAN0].split(":");
    bool wlanConnected = wlanStatus[NSTATUS_STATE] == "connected";
    QString wlanAP = wlanStatus[NSTATUS_CONNECTION];
    QString ip;
    /// IF THERE IS CONNECTED NETWORK, THEN
    /// READ THE CURRENT IPv4
    if(wlanConnected) {
        qprocess.start("nmcli -g ip4.address connection show " + wlanAP);
        qprocess.waitForFinished();

        /// example ouput
        /// 192.168.1.12/24

        enum IPADDR {IPADDR_ADDR, IPADDR_NETMASK};

        QString output = qprocess.readAllStandardOutput();
        QStringList ipWithNetmask = output.split("/");

        ip = ipWithNetmask[IPADDR_ADDR];
    }

    setConnectedStatus(wlanConnected);
    setAccessPoint(wlanAP);
    setIPv4(ip);

    emit readStatusFinished();

#endif
}

QStringList NetworkManager::getAcceessPointListName() const
{
    return m_acceessPointListName;
}

void NetworkManager::scanAsync()
{
    //    qDebug() << __FUNCTION__ << QThread::currentThreadId();

    if(!m_thread.isNull()) if(m_thread->isRunning()) return;

    m_thread.reset(QThread::create([=]{

        //        qDebug() << __FUNCTION__ << QThread::currentThreadId();

        /// CLEAR CURRENT LIST ACCESS POINT
        setAcceessPointListName(QStringList());

        setScanningStatus(true);

#ifdef __arm__
        QProcess qprocess;
        qprocess.start("nmcli --fields SSID,SIGNAL -c no -t d wifi list --rescan yes");
        qprocess.waitForFinished();

        QStringList apresult;
        if (qprocess.exitStatus() == QProcess::NormalExit) {
            apresult = QString(qprocess.readAllStandardOutput()).split("\n", QString::SkipEmptyParts);

        }
#else
        QStringList apresult;
        apresult << "AP_1:90" << "AP_2:80";
        QThread::sleep(2);
#endif

        //        qDebug() << apresult;

        setAcceessPointListName(apresult);

        setScanningStatus(false);

    }));

    QObject::connect(m_thread.data(), &QThread::started, [=]{
        setBussy(true);
    });
    QObject::connect(m_thread.data(), &QThread::finished, [=]{
        setBussy(false);
    });
    //    QObject::connect(m_thread.data(), &QThread::finished, [=]{
    //        qDebug() << "m_thread has finished";
    //    });
    //    QObject::connect(m_thread.data(), &QThread::destroyed, [=]{
    //        qDebug() << "m_thread will destroyed";
    //    });

    m_thread->start();

}

void NetworkManager::connectAsync(const QString name, const QString passwd)
{
    //    qDebug() << __FUNCTION__ << QThread::currentThreadId();

    if(!m_thread.isNull()) if(m_thread->isRunning()) return;

    m_thread.reset(QThread::create([=]{

        //        qDebug() << __FUNCTION__ << QThread::currentThreadId();

#ifdef __arm__
        QRegExp rx(QString("%1.nm*").arg(name));
        rx.setPatternSyntax(QRegExp::Wildcard);

        QString pathNetworkDir("/etc/NetworkManager/system-connections");
        QDir networkDir(pathNetworkDir);
        bool exist = networkDir.entryList().filter(rx).count();
        if (!exist && passwd.isEmpty()) {
            //            qDebug() << name << "is new registering ap need password";
            emit passwordAsked(name);
            return;
        }
        //        else {
        //            qDebug() << name << "is existing ap";
        //        }

        QProcess qprocess;

        ///Merge standard out put and error message to be one, so just need to read "qprocess.readAllStandardOutput();"
        qprocess.setProcessChannelMode(QProcess::ProcessChannelMode::MergedChannels);

        QString commmand;
        if (exist) {
            commmand = QString("nmcli d wifi con \"%1\"").arg(name);
        }
        else {
            commmand = QString("nmcli d wifi con \"%1\" password \"%2\"").arg(name, passwd);
        }
        //        qDebug() << commmand;

        qprocess.start(commmand);
        qprocess.waitForFinished();

        int exitCode = qprocess.exitCode();
        if(exitCode == 0) setConnectedStatus(true);
        else setConnectedStatus(false);

        //        qDebug() << qprocess.exitCode();
#else
        if (passwd.isEmpty()) {
            //            qDebug() << name << "is new registering ap need password";
            emit passwordAsked(name);
            return;
        }

        int exitCode = 0;
        QThread::sleep(5);
#endif
        /// Direct all read status
        readStatus();

        emit connectingFinished(exitCode, name);

    }));

    QObject::connect(m_thread.data(), &QThread::started, [=]{
        setBussy(true);
    });
    QObject::connect(m_thread.data(), &QThread::finished, [=]{
        setBussy(false);
    });
    //    QObject::connect(m_thread.data(), &QThread::finished, [=]{
    //        qDebug() << "m_thread has finished";
    //    });
    //    QObject::connect(m_thread.data(), &QThread::destroyed, [=]{
    //        qDebug() << "m_thread will destroyed";
    //    });

    m_thread->start();
}

void NetworkManager::deleteConnectionAsync(const QString apName)
{
    //    qDebug() << __FUNCTION__ << apName;

    if(!m_thread.isNull()) if(m_thread->isRunning()) return;

    m_thread.reset(QThread::create([=]{

        //        qDebug() << __FUNCTION__ << QThread::currentThreadId();
#ifdef __arm__
        QProcess qprocess;

        /// Merge standard out and
        qprocess.setProcessChannelMode(QProcess::MergedChannels);

        qprocess.start("nmcli connection delete " + apName);
        qprocess.waitForFinished();

        //        QString ouput = qprocess.readAllStandardOutput();
        //        qDebug() << ouput;

        /// Remove current connection if current access point is the same which want to deleted
        /// Connection will automatically disconnected
        if(m_accessPoint == apName) {
            setConnectedStatus(false);
            setAccessPoint("");
            setIPv4("");

            /// emualation read status signal, to tell the display for update parameter as like read ststus job
            emit readStatusFinished();
        }

        int exitCode = qprocess.exitCode();
        //        qDebug() << "exitCode" << exitCode;
#else
        int exitCode = 0;
        QThread::sleep(5);
#endif

        emit deletionFinished(exitCode, apName);

    }));

    QObject::connect(m_thread.data(), &QThread::started, [=]{
        setBussy(true);
    });
    QObject::connect(m_thread.data(), &QThread::finished, [=]{
        setBussy(false);
    });
    //    QObject::connect(m_thread.data(), &QThread::finished, [=]{
    //        qDebug() << "m_thread has finished";
    //    });
    //    QObject::connect(m_thread.data(), &QThread::destroyed, [=]{
    //        qDebug() << "m_thread will destroyed";
    //    });

    m_thread->start();

}

void NetworkManager::setAcceessPointListName(QStringList acceessPointListName)
{
    if (m_acceessPointListName == acceessPointListName)
        return;

    m_acceessPointListName = acceessPointListName;
    emit acceessPointListNameChanged(m_acceessPointListName);
}

void NetworkManager::setAccessPoint(QString accessPoint)
{
    if (m_accessPoint == accessPoint)
        return;

    m_accessPoint = accessPoint;
    emit accessPointChanged(m_accessPoint);
}

void NetworkManager::setReadingStatus(bool readingStatus)
{
    if (m_readingStatus == readingStatus)
        return;

    m_readingStatus = readingStatus;
    emit readingStatusChanged(m_readingStatus);
}

void NetworkManager::setScanningStatus(bool scanningStatus)
{
    if (m_scanningStatus == scanningStatus)
        return;

    m_scanningStatus = scanningStatus;
    emit scanningStatusChanged(m_scanningStatus);
}

void NetworkManager::setConnectingStatus(bool connectingStatus)
{
    if (m_connectingStatus == connectingStatus)
        return;

    m_connectingStatus = connectingStatus;
    emit connectingStatusChanged(m_connectingStatus);
}

void NetworkManager::setIPv4(QString ipv4)
{
    if (m_ipv4 == ipv4)
        return;

    m_ipv4 = ipv4;
    emit ipv4Changed(m_ipv4);
}

void NetworkManager::setConnectedStatus(bool connectedStatus)
{
    if (m_connectedStatus == connectedStatus)
        return;

    m_connectedStatus = connectedStatus;
    emit connectedStatusChanged(m_connectedStatus);
}

void NetworkManager::setBussy(bool bussy)
{
    if (m_bussy == bussy)
        return;

    m_bussy = bussy;
    emit bussyChanged(m_bussy);
}

QString NetworkManager::getAccessPoint() const
{
    return m_accessPoint;
}

bool NetworkManager::getReadingStatus() const
{
    return m_readingStatus;
}

bool NetworkManager::getScanningStatus() const
{
    return m_scanningStatus;
}

bool NetworkManager::getConnectingStatus() const
{
    return m_connectingStatus;
}

QString NetworkManager::getIPv4() const
{
    return m_ipv4;
}

bool NetworkManager::getConnectedStatus() const
{
    return m_connectedStatus;
}

bool NetworkManager::getBussy() const
{
    return m_bussy;
}
