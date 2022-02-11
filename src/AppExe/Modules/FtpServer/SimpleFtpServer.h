#pragma once

#include <QObject>
#include <QSharedPointer>
#include "../ThirdParty/FineFTP-Server/include/fineftp/server.h"

class SimpleFtpServer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString rootPath
               READ getRootPath
               WRITE setRootPath
               NOTIFY rootPathChanged)

    Q_PROPERTY(int permissionPath
               READ getPermissionPath
               WRITE setPermissionPath
               NOTIFY permissionPathChanged)

    Q_PROPERTY(int threadReserve
               READ getThreadReserve
               WRITE setThreadReserve
               NOTIFY threadReserveChanged)

    Q_PROPERTY(bool started
               READ getStarted
               WRITE setStarted
               NOTIFY startedChanged)

public:
    explicit SimpleFtpServer(QObject *parent = nullptr);
    ~SimpleFtpServer();

    QString getRootPath() const;
    int getPermissionPath() const;

    int getThreadReserve() const;

    bool getStarted() const;

public Q_SLOTS:
    void start();
    void stop();

    void setRootPath(QString rootPath);
    void setPermissionPath(int permissionPath);
    void setThreadReserve(int threadReserve);
    void setStarted(bool started);

signals:
    void rootPathChanged(QString rootPath);
    void permissionPathChanged(int permissionPath);
    void threadReserveChanged(int threadReserve);
    void startedChanged(bool started);

private:
    QSharedPointer<fineftp::FtpServer> m_server;
    QString m_rootPath;
    int m_permissionPath;
    int m_threadReserve;
    bool m_started;
};

