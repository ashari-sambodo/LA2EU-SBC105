#pragma once

#include <QObject>
#include <QDebug>

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

    void readStatus(bool *connected, QString *typeConn, QString *connName, QString *ipv4);
    void scanAccessPoint(QStringList *availableAP);
    void connectToNewAccessPoint(const QString connName, const QString passwd = QString());
    void connectTo(const QString connName);
    void forgetConnection(const QString connName);

private:
    QThread *m_pThread = nullptr;
};
