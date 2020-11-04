#pragma once

#include <QObject>
#include <QScopedPointer>
#include <QSerialPort>
#include <QSettings>
#include <QThread>
#include <QTimer>

#include "BoardIO/Drivers/BlowerRegalECM/BlowerRegalECM.h"
#include "Implementations/BlowerRbm/BlowerRbmDsi.h"
#include "Implementations/DeviceAnalogCom/DeviceAnalogCom.h"

#include "BoardIO/Drivers/AOmcp4725/AOmcp4725.h"
#include "BoardIO/Drivers/i2c/I2CPort.h"
#include "BoardIO/BoardIO.h"

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

    /// API for Cabinet operational
    void setBlowerState(short state);

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

    void _setBlowerDutyCycle(short dutyCycle);

    /// Blower Primary
    QScopedPointer<QThread>         m_threadForBlowerRbmDsi;
    QScopedPointer<QTimer>          m_timerInterruptForBlowerRbmDsi;
    ///
    QScopedPointer<BlowerRbmDsi>    m_blowerDownflow;
    QScopedPointer<BlowerRegalECM>  m_boardRegalECM;
    ///
    QScopedPointer<QSerialPort>     m_serialPort1;

    /// Board IO
    QScopedPointer<QThread>         m_threadForBoardIO;
    QScopedPointer<QTimer>          m_timerInterruptForBoardIO;
    ///
    QScopedPointer<BoardIO>         m_boardIO;
    QScopedPointer<I2CPort>         m_i2cPort;

    /// Analog Output
    QScopedPointer<AOmcp4725>       m_boardAnalogOut1;
    ///
    QScopedPointer<DeviceAnalogCom> m_blowerExhaust;

    QScopedPointer<QSettings>       m_settings;
};

