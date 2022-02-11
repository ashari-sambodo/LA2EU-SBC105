#pragma once

#include <QObject>
#include <QDebug>
#include <QModbusTcpConnectionObserver>
class MachineBackend;

class QModbusTcpConnObserverImp : public QModbusTcpConnectionObserver, public QObject
{
public:
    explicit QModbusTcpConnObserverImp(QObject *parent=nullptr);
    ~QModbusTcpConnObserverImp();

    bool acceptNewConnection(QTcpSocket *newClient) override;

    MachineBackend *getPMachineBackend() const;
    void setMachineBackend(MachineBackend *value);

private:

    MachineBackend *pMachineBackend;
};

