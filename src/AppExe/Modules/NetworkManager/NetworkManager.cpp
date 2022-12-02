#include "NetworkManager.h"
#include <QThread>
#include <QEventLoop>
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

NetworkManager::NetworkManager(QObject *parent) : QObject(parent)
{
    qDebug() << __func__;
}//

NetworkManager::~NetworkManager()
{
    //    qDebug() << "~NetworkManager()";
}

void NetworkManager::readStatus(short *connected, QString *typeConn, QString *connName, QString *ipv4, const QString iface)
{
    //    qDebug() << __func__ << QThread::currentThreadId();
    Q_UNUSED(iface)
#ifdef __linux__
    /// Check Connection status if connected or not
    QProcess qprocess;
    qprocess.start("nmcli -t dev");
    qprocess.waitForFinished();

    /// Example output, DEVICE:TYPE:STATE:CONNECTION
    /// wlan0:wifi:connected:ESCO_AP
    /// lo:loopback:unmanaged:

    ///Parse the output
    QString output = qprocess.readAllStandardOutput();
    //    qDebug() << __func__ << output;

    QStringList devicesStatus = output.split("\n").filter(":connected");
    devicesStatus = devicesStatus.filter(iface);
    //    qDebug() << __func__ << devicesStatus;

    if (!devicesStatus.isEmpty()) {
        QStringList prof = devicesStatus.front().split(":");

        enum NSATUS_INDEX {NSTATUS_DEVICE, NSTATUS_TYPE, NSTATUS_STATE, NSTATUS_AP_CONNECTION};
        /// IF THERE IS CONNECTED NETWORK, THEN
        /// READ THE CURRENT IPv4
        QString command = QString("nmcli -g ip4.address con show \"%1\"").arg(prof[NSTATUS_AP_CONNECTION]);
        //        qDebug() << __func__ << command;
        qprocess.start(command);
        bool res = qprocess.waitForFinished();
        //        qDebug()  << __func__ << res;

        /// example ouput
        /// 192.168.1.12/24

        //        enum IPADDR {IPADDR_ADDR, IPADDR_NETMASK};
        //        QString output = qprocess.readAllStandardOutput();
        //        QStringList ipWithNetmask = output.split("/");
        //        ip = ipWithNetmask[IPADDR_ADDR];

        QString ip;
        ip = qprocess.readAllStandardOutput();
        //        qDebug() << __func__ << ip;

        *connected = 1;
        *typeConn = prof[NSTATUS_TYPE].trimmed();
        *connName = prof[NSTATUS_AP_CONNECTION].trimmed();
        *ipv4 = ip.trimmed();
    }
#else
    *connected = 1;
    *typeConn = "ethernet";
    *connName = "Wired connection 1";
    *ipv4 = "192.168.43.110";
#endif
}

void NetworkManager::scanAccessPoint(QStringList *availableAP)
{
    Q_UNUSED(availableAP)
#ifdef __linux__
    QProcess qprocess;
    qprocess.start("nmcli --fields SSID,SIGNAL,SECURITY -c no -t d wifi list --rescan yes");
    qprocess.waitForFinished();

    QStringList apsResult;
    if (qprocess.exitStatus() == QProcess::NormalExit) {
        apsResult = QString(qprocess.readAllStandardOutput()).split("\n", Qt::SkipEmptyParts);
        qDebug() << __func__ << apsResult;

        qprocess.start("nmcli -t --fields NAME con show");
        qprocess.waitForFinished();
        QStringList apsExist = QString(qprocess.readAllStandardOutput()).split("\n", Qt::SkipEmptyParts);
        qDebug() << __func__ << apsExist;

        bool exist = false;
        for(int i=0; i < apsResult.length(); i++){
            exist = false;
            for(int j=0; j < apsExist.length(); j++) {
                if (apsResult[i].contains(apsExist[j])){
                    exist = true;
                }
            }
            if(exist){
                apsResult[i].prepend("EXIST:");
            }
            else {
                apsResult[i].prepend("NEW:");
            }
        }
    }
    qDebug() << __func__ << apsResult;
    *availableAP = apsResult;
#else
    //    QStringList apresult;
    //    apresult << "AP_1:90" << "AP_2:80";
    //    QThread::sleep(2);
#endif

    //        qDebug() << apresult;
}

void NetworkManager::connectToNewAccessPoint(const QString connName, const QString passwd)
{
    qDebug() << __func__ << thread();
    Q_UNUSED(connName)
    Q_UNUSED(passwd)
#ifdef __linux__
    QProcess qprocess;
    ///Merge standard out put and error message to be one, so just need to read "qprocess.readAllStandardOutput();"
    qprocess.setProcessChannelMode(QProcess::ProcessChannelMode::MergedChannels);

    QString commmand;
    if (passwd.length()) {
        commmand = QString("nmcli d wifi con \"%1\" password \"%2\"").arg(connName, passwd);
    }
    else {
        commmand = QString("nmcli d wifi con \"%1\"").arg(connName);
    }
    qDebug() << __func__ << commmand;

    qprocess.start(commmand);
    qprocess.waitForFinished(-1); /// wait forever

    int exitCode = qprocess.exitCode();
    qDebug() << __func__ << exitCode;
    qDebug() << __func__ << qprocess.readAllStandardOutput();

    //        qDebug() << qprocess.exitCode();
#else

#endif
}

/// 0 "Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/10)\n"
/// 4 "Error: Connection activation failed: The Wi-Fi network could not be found\nHint: use 'journalctl -xe NM_CONNECTION=1847cac4-621d-4d25-b679-b9603a962eb0 + NM_DEVICE=wlx000f00f901e8' to get more details.\n"
void NetworkManager::connectTo(const QString connName)
{
    qDebug() << __func__ << thread();
    Q_UNUSED(connName)
#ifdef __linux__
    QProcess qprocess;
    ///Merge standard out put and error message to be one, so just need to read "qprocess.readAllStandardOutput();"
    qprocess.setProcessChannelMode(QProcess::ProcessChannelMode::MergedChannels);

    QString commmand = QString("nmcli con up \"%1\"").arg(connName);
    qDebug() << __func__ << commmand;

    qprocess.start(commmand);
    qprocess.waitForFinished(-1); /// wait forever

    int exitCode = qprocess.exitCode();
    qDebug() << __func__ << exitCode << qprocess.readAllStandardOutput();

    //        qDebug() << qprocess.exitCode();
#else

#endif
}

void NetworkManager::forgetConnection(const QString connName)
{
    Q_UNUSED(connName)
#ifdef __linux__
    QProcess qprocess;
    ///Merge standard out put and error message to be one, so just need to read "qprocess.readAllStandardOutput();"
    qprocess.setProcessChannelMode(QProcess::ProcessChannelMode::MergedChannels);

    QString commmand = QString("nmcli con del \"%1\"").arg(connName);
    qDebug() << __func__ << commmand;

    qprocess.start(commmand);
    qprocess.waitForFinished(-1); /// wait forever

    int exitCode = qprocess.exitCode();
    qDebug() << __func__ << exitCode << qprocess.readAllStandardOutput();

    //        qDebug() << qprocess.exitCode();
#else

#endif
}

bool NetworkManager::_filesAreTheSame(const QString &fileName1, const QString &fileName2)
{
    return _fileChecksum(fileName1) == _fileChecksum(fileName2);
}

// Returns empty QByteArray() on failure.
QByteArray NetworkManager::_fileChecksum(const QString &fileName, QCryptographicHash::Algorithm hashAlgorithm)
{
    QFile f(fileName);
    if (f.open(QFile::ReadOnly)) {
        QCryptographicHash hash(hashAlgorithm);
        if (hash.addData(&f)) {
            return hash.result();
        }
    }
    return QByteArray();
}
