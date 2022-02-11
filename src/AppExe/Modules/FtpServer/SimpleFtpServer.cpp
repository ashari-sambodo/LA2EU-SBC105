#include <QDebug>
#include <QStandardPaths>
#include "SimpleFtpServer.h"

#include "../ThirdParty/FineFTP-Server/include/fineftp/permissions.h"

SimpleFtpServer::SimpleFtpServer(QObject *parent) : QObject(parent)
{
    m_rootPath = QStandardPaths::writableLocation(QStandardPaths::HomeLocation);
    m_permissionPath = (int) fineftp::Permission::FileRead;
    m_threadReserve = 1;
}

SimpleFtpServer::~SimpleFtpServer()
{
    if(m_server.isNull()){
        return;
    }
    m_server->stop();
}

QString SimpleFtpServer::getRootPath() const
{
    return m_rootPath;
}

int SimpleFtpServer::getPermissionPath() const
{
    return m_permissionPath;
}

int SimpleFtpServer::getThreadReserve() const
{
    return m_threadReserve;
}

bool SimpleFtpServer::getStarted() const
{
    return m_started;
}

void SimpleFtpServer::start()
{
    qDebug() << __func__ ;

    if(!m_server.isNull()){
        m_server->stop();
    }
    m_server.reset(new fineftp::FtpServer(2121));
    m_server->addUserAnonymous(qPrintable(m_rootPath), (fineftp::Permission) m_permissionPath);
    m_server->addUser         ("MyUser",   "MyPassword", qPrintable(m_rootPath), fineftp::Permission::ReadOnly);

    bool running = m_server->start(m_threadReserve);
    qDebug() << __func__ << running;
    setStarted(true);
}

void SimpleFtpServer::stop()
{
    if(m_server.isNull()){
        return;
    }
    m_server->stop();
    setStarted(false);
}

void SimpleFtpServer::setRootPath(QString rootPath)
{
    if (m_rootPath == rootPath)
        return;

    m_rootPath = rootPath;
    emit rootPathChanged(m_rootPath);
}

void SimpleFtpServer::setPermissionPath(int permissionPath)
{
    if (m_permissionPath == permissionPath)
        return;

    m_permissionPath = permissionPath;
    emit permissionPathChanged(m_permissionPath);
}

void SimpleFtpServer::setThreadReserve(int threadReserve)
{
    if (m_threadReserve == threadReserve)
        return;

    m_threadReserve = threadReserve;
    emit threadReserveChanged(m_threadReserve);
}

void SimpleFtpServer::setStarted(bool started)
{
    if (m_started == started)
        return;

    m_started = started;
    emit startedChanged(m_started);
}
