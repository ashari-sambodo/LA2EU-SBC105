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

    Q_PROPERTY(short connected
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

    Q_PROPERTY(QString wlanMacAddress
               READ getWlanMacAddress
               //WRITE setMacAddress
               NOTIFY wlanMacAddressChanged)
    Q_PROPERTY(QString eth0MacAddress
               READ getEth0MacAddress
               //WRITE setMacAddress
               NOTIFY eth0MacAddressChanged)

    /// ETEHRNET
    Q_PROPERTY(QString connNameEth
               READ getConnNameEth
               //               WRITE setConnNameEth
               NOTIFY connNameEthChanged)
    Q_PROPERTY(QString ipv4Eth
               READ getIPv4Eth
               //               WRITE setIPv4Eth
               NOTIFY ipv4EthChanged)

public:
    explicit NetworkManagerQmlApp(QObject *parent = nullptr);
    ~NetworkManagerQmlApp();

    static QObject* singletonProvider(QQmlEngine *qmlEngine, QJSEngine *);

    short getConnectedStatus() const;
    QString getConnName() const;
    QString getIPv4() const;
    QString getTypeConn() const;
    QVariantList getAcceessPointAvailable() const;

    void setConnectedStatus(short connected);
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

    QString getConnNameEth() const;
    QString getIPv4Eth() const;

    void setWlanMacAddress(QString value);
    QString getWlanMacAddress()const;
    void setEth0MacAddress(QString value);
    QString getEth0MacAddress()const;

public slots:
    void init();
    void readStatus();
    void scanAccessPoint();
    void connectToNewAccessPoint(const QString connName, const QString password = QString());
    void connectTo(const QString connName);
    void forgetConnection(const QString connName);

    void setConnNameEth(QString connNameEth);
    void setIPv4Eth(QString ipv4Eth);

    void readWlanMacAddress();
    void readEth0MacAddress();

signals:
    void connectedStatusChanged(short connected);
    void connNameChanged(QString connName);
    void ipv4Changed(QString ipv4);
    void typeConnChanged(QString getTypeConn);
    void acceessPointAvailableChanged(QVariantList acceessPointListName);
    void connectingStateChanged(bool connecting);
    void readingStateChanged(bool reading);
    void scanningStateChanged(bool scanning);
    void forgettingConnStateChanged(bool forgettingConn);

    void connNameEthChanged(QString connNameEth);
    void ipv4EthChanged(QString ipv4Eth);

    void wlanMacAddressChanged(QString value);
    void eth0MacAddressChanged(QString value);

private:
    QThread *m_pThread = nullptr;
    QScopedPointer<NetworkManager> m_pNetworkManager;

    short m_connected = 0;
    QString m_connName;
    QString m_ipv4;
    QString m_typeConn;
    QVariantList m_acceessPointListName;
    bool m_connecting = false;
    bool m_scanning = false;
    bool m_reading = false;
    bool m_forgettingConn = false;
    QString m_connNameEth;
    QString m_ipv4Eth;
    QString m_wlanMacAddress;
    QString m_eth0MacAddress;

};
