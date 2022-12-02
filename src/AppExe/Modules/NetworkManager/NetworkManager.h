#pragma once

#include <QObject>
#include <QDebug>
#include <QCryptographicHash>

class NetworkManager : public QObject
{
    Q_OBJECT
public:
    explicit NetworkManager(QObject *parent = nullptr);
    ~NetworkManager();

    //    enum NM_EXIT_CODE {
    //        NME_SUCCESS,
    //        NME_UNKNOWN_ERROR,
    //        NME_INVALID_USER_INPUT,
    //        NME_TIMEOUT,
    //        NME_CONNECTION_ACTIVATION_FAILED,
    //        NME_CONNECTION_DEACTIVATION_FAILED,
    //        NME_DISCONNECT_DEVICE_FAILED,
    //        NME_CONNECTION_DELETION_FAILED,
    //        NME_ITEM_NOT_EXIST = 10,
    //        NME_ADDITIONAL = 65
    //    };
    //    Q_ENUM(NM_EXIT_CODE)

    void readStatus(short *connected, QString *typeConn, QString *connName, QString *ipv4, const QString iface = "wifi");
    void scanAccessPoint(QStringList *availableAP);
    void connectToNewAccessPoint(const QString connName, const QString passwd = QString());
    void connectTo(const QString connName);
    void forgetConnection(const QString connName);

private:
    QThread *m_pThread = nullptr;

    bool _filesAreTheSame(const QString &fileName1, const QString &fileName2);
    QByteArray _fileChecksum(const QString &fileName,
                            QCryptographicHash::Algorithm hashAlgorithm = QCryptographicHash::Md5);
};
