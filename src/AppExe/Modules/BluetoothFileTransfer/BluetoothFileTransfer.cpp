#include "BluetoothFileTransfer.h"
#include <QFile>
#include <QEventLoop>
#include <QDebug>

BluetoothFileTransfer::BluetoothFileTransfer(QObject *parent) : QObject(parent)
{
    m_progress = 0;
    m_file = nullptr;
    reply = nullptr;

    QObject::connect(&m_localDevice, &QBluetoothLocalDevice::pairingFinished,
                     this, &BluetoothFileTransfer::_pairingFinished);
    QObject::connect(&m_localDevice, &QBluetoothLocalDevice::error,
                     this, &BluetoothFileTransfer::_pairingError);
}

int BluetoothFileTransfer::getProgress() const
{
    return m_progress;
}

bool BluetoothFileTransfer::getTransferring() const
{
    return m_transferring;
}

void BluetoothFileTransfer::initTransfer(const QString name, const QString address, const QString fileName)
{
    qDebug() << "Check if the client needs to paring first: " << address;
    m_lastTargetName = name;
    m_lastTargetAddress = address;
    m_lastTargetFile = fileName;

    m_localDevice.blockSignals(false);
    const QBluetoothAddress _address(address);
    QBluetoothLocalDevice::Pairing p = m_localDevice.pairingStatus(_address);

    if(p & QBluetoothLocalDevice::Paired) {
        doTransfer(address, fileName);
    }
    else {
        m_localDevice.requestPairing(_address, QBluetoothLocalDevice::Paired);
        emit pairingStarted(name, address);
    }
}

void BluetoothFileTransfer::doTransfer(const QString address, const QString fileName)
{
    qDebug() << __func__ << address << fileName;
    setTransferring(true);
    m_progress = 0;
    emit progressChanged(m_progress);
    emit tranferFileStarted(address, fileName);

    if (m_file) {
        if (m_file->isOpen()){
            m_file->close();
        }
        delete m_file;
    }
    m_file = new QFile(fileName, this); //ensure that mgr doesn't take reply down when leaving scope

    QBluetoothAddress btAddress = QBluetoothAddress(address);
    QBluetoothTransferRequest request(btAddress);

    reply = m_manager.put(request, m_file);
    //ensure that mgr doesn't take reply down when leaving scope
    reply->setParent(this);

    if (reply->error()) {
        qWarning() << "Failed to send file" << reply->errorString();
        setTransferring(false);
        emit tranferFileFinished(false, reply->error());
    }
    else {
        // Connect to the reply's signals to be informed about the status and do cleanups when done
        QObject::connect(reply, &QBluetoothTransferReply::transferProgress,
                         this, &BluetoothFileTransfer::updateProgress);
        QObject::connect(reply, &QBluetoothTransferReply::finished,
                         this, &BluetoothFileTransfer::_tranferFileFinished);
    }
}

void BluetoothFileTransfer::updateProgress(qint64 transferred, qint64 total)
{
    qDebug() << __func__ << transferred << total;

    m_progress = (((float)transferred)/((float)total)) * 100;
    emit progressChanged(m_progress);
}

void BluetoothFileTransfer::setTransferring(bool transferring)
{
    if (m_transferring == transferring)
        return;

    m_transferring = transferring;
    emit transferringChanged(m_transferring);
}

void BluetoothFileTransfer::_pairingFinished(const QBluetoothAddress &address, QBluetoothLocalDevice::Pairing status)
{
    qDebug() << __func__ << address.toString() << (int) status;

    bool pairedSuccess = status == QBluetoothLocalDevice::Paired;
    emit pairingFinished(pairedSuccess, m_lastTargetName, address.toString());

    if (pairedSuccess) {
        doTransfer(address.toString(), m_lastTargetFile);
    }
}

void BluetoothFileTransfer::_pairingError(QBluetoothLocalDevice::Error error)
{
    qDebug() << __func__ << (int) error;

    Q_UNUSED(error)

    const QBluetoothAddress address = QBluetoothAddress(m_lastTargetAddress);
    _pairingFinished(address, QBluetoothLocalDevice::Unpaired);
}

void BluetoothFileTransfer::_tranferFileFinished(QBluetoothTransferReply *reply)
{
    qDebug() << __func__ << reply->error();
    switch(reply->error()){
    case QBluetoothTransferReply::TransferError::HostNotFoundError:
    {
        /// the reason is target device already remove paired status but our status still paired
        /// so, for what we still remember her, forget now!!!
        QBluetoothAddress address = QBluetoothAddress(m_lastTargetAddress);
        QBluetoothLocalDevice::Pairing p = m_localDevice.pairingStatus(address);

        if(p & QBluetoothLocalDevice::Paired) {
            m_localDevice.blockSignals(true);
            m_localDevice.requestPairing(address, QBluetoothLocalDevice::Unpaired);
        }
    }// this is end of scope, address & p will be gone after this symbol, bye-bye!
        break;
    default:
        break;
    }

    bool complete = reply->error() == QBluetoothTransferReply::NoError;
    emit tranferFileFinished(complete, reply->error());
    setTransferring(false);
}
