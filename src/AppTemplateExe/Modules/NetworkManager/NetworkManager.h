#pragma once

#include <QObject>
#include <QScopedPointer>

/// Support Singleton mechanism
class QQmlEngine;
class QJSEngine;

//class AccessPointProfile : public QObject
//{
//    Q_OBJECT
//public:
//    explicit AccessPointProfile(QObject *parent = nullptr): QObject(parent) {}
//    virtual ~AccessPointProfile() {}
//};

class NetworkManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList acceessPointListName READ getAcceessPointListName WRITE setAcceessPointListName NOTIFY acceessPointListNameChanged)
    Q_PROPERTY(QString accessPoint READ getAccessPoint WRITE setAccessPoint NOTIFY accessPointChanged)

    Q_PROPERTY(QString ipv4 READ getIPv4 WRITE setIPv4 NOTIFY ipv4Changed)

    Q_PROPERTY(bool connectedStatus READ getConnectedStatus WRITE setConnectedStatus NOTIFY connectedStatusChanged)
    Q_PROPERTY(bool connectingStatus READ getConnectingStatus WRITE setConnectingStatus NOTIFY connectingStatusChanged)
    Q_PROPERTY(bool readingStatus READ getReadingStatus WRITE setReadingStatus NOTIFY readingStatusChanged)
    Q_PROPERTY(bool scanningStatus READ getScanningStatus WRITE setScanningStatus NOTIFY scanningStatusChanged)

    Q_PROPERTY(bool bussy READ getBussy WRITE setBussy NOTIFY bussyChanged)

public:
    explicit NetworkManager(QObject *parent = nullptr);
    ~NetworkManager();

    static QObject* singletonProvider(QQmlEngine *qmlEngine, QJSEngine *);

    QStringList getAcceessPointListName() const;

    int getStatus();

    QString getAccessPoint() const;

    bool getReadingStatus() const;

    bool getScanningStatus() const;

    bool getConnectingStatus() const;

    QString getIPv4() const;

    bool getConnectedStatus() const;

    enum NM_EXIT_CODE {
        NME_SUCCESS,
        NME_UNKNOWN_ERROR,
        NME_INVALID_USER_INPUT,
        NME_TIMEOUT,
        NME_CONNECTION_ACTIVATION_FAILED,
        NME_CONNECTION_DEACTIVATION_FAILED,
        NME_DISCONNECT_DEVICE_FAILED,
        NME_CONNECTION_DELETION_FAILED,
        NME_ITEM_NOT_EXIST = 10,
        NME_ADDITIONAL = 65
    };
    Q_ENUM(NM_EXIT_CODE)

    bool getBussy() const;

public slots:
    void readStatusAsync();

    void scanAsync();

    void connectAsync(const QString name, const QString passwd = QString());

    void deleteConnectionAsync(const QString apName);

    void setAcceessPointListName(QStringList acceessPointListName);

    void setAccessPoint(QString accessPoint);

    void setReadingStatus(bool readingStatus);

    void setScanningStatus(bool scanningStatus);

    void setConnectingStatus(bool connectingStatus);

    void setIPv4(QString ipv4);

    void setConnectedStatus(bool connectedStatus);

    void setBussy(bool bussy);

signals:

    void acceessPointListNameChanged(QStringList acceessPointListName);

    void passwordAsked(const QString apName);

    void connectingFinished(int status, const QString apName);

    void deletionFinished(int status, const QString apName);

    void accessPointChanged(QString accessPoint);

    void readingStatusChanged(bool readingStatus);

    void scanningStatusChanged(bool scanningStatus);

    void connectingStatusChanged(bool connectingStatus);

    void ipv4Changed(QString ipv4);

    void connectedStatusChanged(bool connectedStatus);

    void readStatusFinished();

    void bussyChanged(bool bussy);

private:
    //    QThread *m_thread;
    QScopedPointer<QThread> m_thread;

    QStringList m_acceessPointListName;
    QString m_accessPoint;
    bool m_readingStatus;
    bool m_scanningStatus;
    bool m_connectingStatus;
    bool m_connectedStatus;
    QString m_ipv4;

    void readStatus();
    bool m_bussy;
};
