#pragma once

/***
 * Referensces: https://topic.alibabacloud.com/a/file-transfer-using-the-tcp-protocol-in-qt-can-be-looped-in-one-direction_8_8_10249539.html
*/

#include <QObject>

#include <QtNetwork/QTcpServer>
#include <QtNetwork/QTcpSocket>
#include <QFile>
#include <QString>
#include <QSharedPointer>

class TransferFileTcpServer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool listening READ isListening WRITE setListening NOTIFY listeningChanged)
    Q_PROPERTY(int progressPercent READ getProgressPercent WRITE setProgressPercent NOTIFY progressPercentChanged)
    Q_PROPERTY(QString fileName READ getFileName WRITE setFileName NOTIFY fileNameChanged)

    Q_PROPERTY(QString targetBasePath READ getTargetBasePath WRITE setTargetBasePath NOTIFY targetBasePathChanged)

public:
    explicit TransferFileTcpServer(QObject *parent = nullptr);

    bool isListening() const;

    int getProgressPercent() const;

    QString getFileName() const;

    QString getTargetBasePath() const;

public slots:
    void setListening(bool listening);

    void setProgressPercent(int progressPercent);

    void setFileName(QString fileName);

    void setTargetBasePath(QString targetBasePath);

signals:
    void listeningChanged(bool listened);

    void progressPercentChanged(int progressPercent);

    void clientConnected();
    void clientDisconnected();

    void fileNameChanged(QString fileName);

    void targetBasePathChanged(QString targetBasePath);

private:
    QTcpServer  *m_tcpServer;
    QTcpSocket  *m_receiverSocket;
    QSharedPointer<QFile>  m_newFile;

    QByteArray  m_inblock;
    QString     m_fileNamePath;
    QString     m_fileName;

    qint64      m_totalSize;
    qint64      m_byteReceived;

    bool m_listened;

    int m_progressPercent;

    QString m_targetBasePath;

private slots:
    void onAcceptedConnection();
    void onReadSocket();
};
