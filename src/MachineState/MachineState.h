#pragma once

#include <QObject>

class MachineData;

class MachineState : public QObject
{
    Q_OBJECT
public:
    explicit MachineState(QObject *parent = nullptr);
    ~MachineState();

public slots:
    void worker();

    void stop();

    void setMachineData(MachineData* data);

signals:
    void hasStopped();

    void loopStarted();
    void timerEventWorkerStarted();

private:
    MachineData*    pData;

    void setup();
    void loop();
    void stopping();

    bool m_stop;

    bool loopStarterTaskExecute;
    bool stoppingExecuted;
};

