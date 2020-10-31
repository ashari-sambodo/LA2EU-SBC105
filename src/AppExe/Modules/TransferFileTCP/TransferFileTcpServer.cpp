#include <QDataStream>
#include <QDir>
#include <QDateTime>
#include <QDebug>

#include "TransferFileTcpServer.h"

/***
 * https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
 * */
#define SOCKET_PORT 4779

TransferFileTcpServer::TransferFileTcpServer(QObject *parent) : QObject(parent)
{
    m_tcpServer = nullptr;
    m_receiverSocket = nullptr;
    m_newFile = nullptr;

    m_totalSize = 0;
    m_byteReceived = 0;

    m_progressPercent = 0;

    m_tcpServer = new QTcpServer(this);
    m_tcpServer->setMaxPendingConnections(1); //Default is 30
    connect(m_tcpServer, &QTcpServer::newConnection, this, &TransferFileTcpServer::onAcceptedConnection);
}

bool TransferFileTcpServer::isListening() const
{
    return m_tcpServer->isListening();
}

int TransferFileTcpServer::getProgressPercent() const
{
    return m_progressPercent;
}

QString TransferFileTcpServer::getFileName() const
{
    return m_fileName;
}

QString TransferFileTcpServer::getTargetBasePath() const
{
    return m_targetBasePath;
}

void TransferFileTcpServer::setListening(bool listening)
{
    //    qDebug() << __FUNCTION__ << listening;

    if (listening) m_tcpServer->listen(QHostAddress::Any, SOCKET_PORT);
    else {
        if(m_receiverSocket) m_receiverSocket->abort();

        setProgressPercent(0);
        m_inblock.clear();
        m_byteReceived = 0;
        m_totalSize = 0;

        m_tcpServer->close();
    }

    emit listeningChanged(listening);
}

void TransferFileTcpServer::setProgressPercent(int progressPercent)
{
    if (m_progressPercent == progressPercent)
        return;

    m_progressPercent = progressPercent;
    emit progressPercentChanged(m_progressPercent);
}

void TransferFileTcpServer::setFileName(QString fileName)
{
    if (m_fileName == fileName)
        return;

    m_fileName = fileName;
    emit fileNameChanged(m_fileName);
}

void TransferFileTcpServer::setTargetBasePath(QString targetBasePath)
{
    if (m_targetBasePath == targetBasePath)
        return;

    m_targetBasePath = targetBasePath;
    emit targetBasePathChanged(m_targetBasePath);
}

void TransferFileTcpServer::onAcceptedConnection()
{
    //    qDebug() << __FUNCTION__;

    QTcpSocket *newCommingSocket = m_tcpServer->nextPendingConnection();
    if(m_receiverSocket){
        //        qDebug() << m_receiverSocket;
        connect(newCommingSocket, &QTcpSocket::disconnected, newCommingSocket, &QTcpSocket::deleteLater);
        newCommingSocket->close();
        newCommingSocket->deleteLater();
        return;
    }
    m_receiverSocket = newCommingSocket;

    setProgressPercent(0);
    m_inblock.clear();
    m_byteReceived = 0;
    m_totalSize = 0;

    //    qDebug() << m_receiverSocket->peerAddress() << m_receiverSocket->peerName();

    connect(m_receiverSocket, &QTcpSocket::readyRead, this, &TransferFileTcpServer::onReadSocket);
    connect(m_receiverSocket, &QTcpSocket::disconnected, m_receiverSocket, &QTcpSocket::deleteLater);
    connect(m_receiverSocket, &QTcpSocket::destroyed, [=]{

        m_inblock.clear();
        m_byteReceived = 0;
        m_totalSize = 0;

        m_receiverSocket = nullptr;
        //        qDebug() << m_receiverSocket << "will destroyed";
    });
}

void TransferFileTcpServer::onReadSocket()
{
    if (m_byteReceived == 0) {
        //        qDebug() << "Started reeived file";

        setProgressPercent(0);

        QDataStream in(m_receiverSocket);
        //        qDebug() << "QDataStream::status" << in.status() << m_receiverSocket->isValid();

        QString fileName;
        in >> m_totalSize >> m_byteReceived >> fileName;
        //        qDebug() << in << m_totalSize << m_byteReceived << fileName;

        if(fileName.isEmpty()){
            m_receiverSocket->abort();
            return;
        }

        if(!QFileInfo::exists(m_targetBasePath)) {
            setTargetBasePath(QDir::currentPath());
        }

        QString uniq = QDateTime::currentDateTime().toString("ddMMMyyyy_hhmmss");
        QString targetDir = m_targetBasePath + "/" + uniq;
        if(!QFileInfo::exists(targetDir)){
            QDir().mkpath(targetDir);
        }
        m_fileNamePath = targetDir + "/" + fileName;
        setFileName(fileName);

        m_newFile.reset(new QFile(m_fileNamePath));
        m_newFile->open(QFile::WriteOnly);
    }
    else {
        m_inblock = m_receiverSocket->readAll();

        m_byteReceived += m_inblock.size();
        m_newFile->write(m_inblock);
        m_newFile->flush();

        //        qDebug() << "m_byteReceived:" << m_byteReceived;
    }

    int progressPercent = qRound(((double) m_byteReceived / (double) m_totalSize) * 100.0);
    //    qDebug() << "progressPercent" << progressPercent;
    setProgressPercent(progressPercent);

    if (m_byteReceived >= m_totalSize) {
        m_inblock.clear();
        m_byteReceived = 0;
        m_totalSize = 0;
    }
}
