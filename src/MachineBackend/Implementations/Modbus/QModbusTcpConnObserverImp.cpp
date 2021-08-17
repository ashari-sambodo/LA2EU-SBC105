#include <QTcpSocket>
#include "QModbusTcpConnObserverImp.h"
#include "./MachineBackend.h"

QModbusTcpConnObserverImp::QModbusTcpConnObserverImp(QObject *parent) : QObject(parent)
{

}

QModbusTcpConnObserverImp::~QModbusTcpConnObserverImp()
{
    qDebug() << __func__;
}

bool QModbusTcpConnObserverImp::acceptNewConnection(QTcpSocket *newClient)
{
    qDebug() << __func__;
    return pMachineBackend->_callbackOnModbusConnectionStatusChanged(newClient);
}

MachineBackend *QModbusTcpConnObserverImp::getPMachineBackend() const
{
    return pMachineBackend;
}

void QModbusTcpConnObserverImp::setMachineBackend(MachineBackend *value)
{
    pMachineBackend = value;
}
