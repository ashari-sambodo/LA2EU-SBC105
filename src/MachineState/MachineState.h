#pragma once

#include <QObject>
#include <QScopedPointer>
#include <QSerialPort>
#include <QSettings>
#include <QThread>
#include <QTimer>

#include "BoardIO/Drivers/BlowerRegalECM/BlowerRegalECM.h"
#include "Implementations/BlowerRbm/BlowerRbmDsi.h"

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
    void deallocate();

    bool m_stop;

    bool m_loopStarterTaskExecute;
    bool m_stoppingExecuted;

    ///
    QScopedPointer<QTimer>          m_timerEventForBlowerRbmDsi;
    QScopedPointer<QThread>         m_threadForBlowerRbmDsi;
    ///
    QScopedPointer<BlowerRbmDsi>    m_blowerRbmDsi;
    QScopedPointer<BlowerRegalECM>  m_blowerRegalECM;
    QScopedPointer<QSerialPort>     m_blowerSerialPort;

    QScopedPointer<QSettings> m_settings;
};

