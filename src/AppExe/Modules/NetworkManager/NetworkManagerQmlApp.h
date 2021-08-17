#pragma once

#include <QObject>
#include <QScopedPointer>
#include <QDebug>

/// Support Singleton mechanism
class QQmlEngine;
class QJSEngine;
class NetworkManager;

class NetworkManagerQmlApp : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QVariantList accessPointAvailable
               READ getAcceessPointAvailable
               //               WRITE setAccessPointAvailable
               NOTIFY acceessPointAvailableChanged)

    Q_PROPERTY(bool connected
               READ getConnectedStatus
               //               WRITE setConnectedStatus
               NOTIFY connectedStatusChanged)
    Q_PROPERTY(QString typeConn
               READ getTypeConn
               //               WRITE setTypeConn
               NOTIFY typeConnChanged)
    Q_PROPERTY(QString connName
               READ getConnName
               //               WRITE setConnName
               NOTIFY connNameChanged)
    Q_PROPERTY(QString ipv4
               READ getIPv4
               //               WRITE setIPv4
               NOTIFY ipv4Changed)

    Q_PROPERTY(bool connecting
               READ getConnectingState
               WRITE setConnectingState
               NOTIFY connectingStateChanged)

    Q_PROPERTY(bool scanning
               READ getScanningState
               WRITE setScanningState
               NOTIFY scanningStateChanged)

    Q_PROPERTY(bool reading
               READ getReadingState
               WRITE setReadingState
               NOTIFY readingStateChanged)

    Q_PROPERTY(bool forgettingConn
               READ getForgettingConnState
               WRITE setForgettingConnState
               NOTIFY forgettingConnStateChanged)

public:
    explicit NetworkManagerQmlApp(QObject *parent = nullptr);
    ~NetworkManagerQmlApp();

    static QObject* singletonProvider(QQmlEngine *qmlEngine, QJSEngine *);

    bool getConnectedStatus() const;
    QString getConnName() const;
    QString getIPv4() const;
    QString getTypeConn() const;
    QVariantList getAcceessPointAvailable() const;

    void setConnectedStatus(bool connected);
    void setConnName(QString connName);
    void setIPv4(QString ipv4);
    void setTypeConn(QString getTypeConn);
    void setAccessPointAvailable(QVariantList acceessPointListName);

    bool getConnectingState() const;
    bool getScanningState() const;
    bool getReadingState() const;
    bool getForgettingConnState() const;

    void setConnectingState(bool connecting);
    void setScanningState(bool scanning);
    void setReadingState(bool reading);
    void setForgettingConnState(bool forgettingConn);

public slots:
    void init();
    void readStatus();
    void scanAccessPoint();
    void connectToNewAccessPoint(const QString connName, const QString password = QString());
    void connectTo(const QString connName);
    void forgetConnection(const QString connName);

signals:
    void connectedStatusChanged(bool connected);
    void connNameChanged(QString connName);
    void ipv4Changed(QString ipv4);
    void typeConnChanged(QString getTypeConn);
    void acceessPointAvailableChanged(QVariantList acceessPointListName);
    void connectingStateChanged(bool connecting);
    void readingStateChanged(bool reading);
    void scanningStateChanged(bool scanning);
    void forgettingConnStateChanged(bool forgettingConn);

private:
    QThread *m_pThread = nullptr;
    QScopedPointer<NetworkManager> m_pNetworkManager;

    bool m_connected = false;
    QString m_connName;
    QString m_ipv4;
    QString m_typeConn;
    QVariantList m_acceessPointListName;
    bool m_connecting = false;
    bool m_scanning = false;
    bool m_reading = false;
    bool m_forgettingConn = false;
};
