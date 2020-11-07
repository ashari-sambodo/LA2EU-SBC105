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
#include "Implementations/SashWindow/SashWindow.h"
#include "Implementations/DigitalOut/DigitalOut.h"
#include "Implementations/MotorizeOnRelay/MotorizeOnRelay.h"
#include "Implementations/AirflowVelocity/AirflowVelocity.h"
#include "Implementations/Temperature/Temperature.h"

#include "BoardIO/Drivers/LEDpca9633/LEDpca9633.h"
#include "BoardIO/Drivers/AImcp3422x/AIManage.h"
#include "BoardIO/Drivers/PWMpca9685/PWMpca9685.h"
#include "BoardIO/Drivers/DIOpca9674/DIOpca9674.h"
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
    void setBlowerDownflowDutyCycle(short state);
    void setBlowerExhaustDutyCycle(short state);

    void setLightIntensity(short lightIntensity);

    void setLightState(short lightState);

    void setSocketState(short socketState);

    void setGasState(short gasState);

    void setUvState(short uvState);

    void setSashMotorizeState(short state);

    void setInflowAdcPointFactory(short point, int adc);
    void setInflowAdcPointField(short point, int adc);
    void setInflowVelocityPointFactory(short point, float value);
    void setInflowVelocityPointField(short point, float value);
    ///
    void setInflowConstant(int ifaConstant);
    void setInflowTemperatureFactory(double ifaTemperatureFactory);
    void setInflowTemperatureADCFactory(int ifaTemperatureADCFactory);
    void setInflowTemperatureField(double ifaTemperatureField);
    void setInflowTemperatureADCField(int ifaTemperatureADCField);
    void setInflowLowLimitVelocity(double ifaLowLimitVelocity);

    void setDownflowAdcPointFactory(short point, int adc);
    void setDownflowAdcPointField(short point, int adc);
    void setDownflowVelocityPointFactory(short point, float value);
    void setDownflowVelocityPointField(short point, float value);
    ///
    void setDownflowConstant(int dfaConstant);
    void setDownflowTemperatureFactory(double dfaTemperatureFactory);
    void setDownflowTemperatureField(double dfaTemperatureField);
    void setDownflowTemperatureADCField(int dfaTemperatureADCField);
    void setDownflowTemperatureADCFactory(int dfaTemperatureADCFactory);
    void setDownflowLowLimitVelocity(double dfaLowLimitVelocity);
    void setDownflowHigLimitVelocity(double dfaHigLimitVelocity);

    void setAirflowCalibration(short value);

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

    void _setBlowerDowndlowDutyCycle(short dutyCycle);

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

    /// Analog Output
    QScopedPointer<AOmcp4725>       m_boardAnalogOut2;
    ///
    QScopedPointer<DeviceAnalogCom> m_lightIntensity;

    /// Digital Input
    QScopedPointer<DIOpca9674>      m_boardDigitalInput1;
    //
    QScopedPointer<SashWindow>      m_sashWindow;

    /// Digital Swith / PWM
    QScopedPointer<PWMpca9685>      m_boardPwm1;
    ///
    QScopedPointer<DigitalOut>      m_light;
    QScopedPointer<DigitalOut>      m_socket;
    QScopedPointer<DigitalOut>      m_gas;
    QScopedPointer<DigitalOut>      m_uv;
    ///
    QScopedPointer<MotorizeOnRelay> m_sasWindowMotorize;

    QScopedPointer<AIManage>        m_boardAnalogInput1;
    ///
    QScopedPointer<AirflowVelocity> m_airflowDownflow;

    ///
    QScopedPointer<AIManage>        m_boardAnalogInput2;
    ///
    QScopedPointer<AirflowVelocity> m_airflowInflow;

    ///
    QScopedPointer<Temperature>     m_temperature;

    QScopedPointer<LEDpca9633>      m_boardIOExtendPca9633;

    QScopedPointer<QSettings>       m_settings;
};

