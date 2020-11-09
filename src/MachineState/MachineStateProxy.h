#pragma once

#include <QObject>
#include <QScopedPointer>
#include <QThread>
#include <QTimer>

#include "MachineEnums.h"

class MachineState;
class MachineData;

class QQmlEngine;
class QJSEngine;

class MachineStateProxy : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int count
               READ getCount
               NOTIFY countChanged)

    Q_ENUM(MachineEnums::EnumItemState);

public:
    explicit MachineStateProxy(QObject *parent = nullptr);
    ~MachineStateProxy();

    static QObject *singletonProvider(QQmlEngine *qmlEngine, QJSEngine *);

    int getCount() const;

signals:

    void countChanged(int count);

public slots:
    void initSingleton();
    void setup(QObject *pData);
    void stop();

    /// API for Cabinet operational
    void setBlowerState(short state);
    void setBlowerDownflowDutyCycle(short state);
    void setBlowerInflowDutyCycle(short state);

    void setLightIntensity(short lightIntensity);

    void setLightState(short lightState);

    void setSocketState(short socketState);

    void setGasState(short gasState);

    void setUvState(short uvState);

    void setSashWindowMotorizeState(short sashMotorizeState);

    void setInflowAdcPointFactory(short point, int adc);
    void setInflowAdcPointField(short point, int adc);
    void setInflowVelocityPointFactory(short point, float value);
    void setInflowVelocityPointField(short point, float value);
    ///
    void setInflowConstant(int ifaConstant);
    void setInflowTemperatureFactory(float ifaTemperatureFactory);
    void setInflowTemperatureADCFactory(int ifaTemperatureADCFactory);
    void setInflowTemperatureField(float ifaTemperatureField);
    void setInflowTemperatureADCField(int ifaTemperatureADCField);
    void setInflowLowLimitVelocity(float ifaLowLimitVelocity);

    void setDownflowAdcPointFactory(short point, int adc);
    void setDownflowAdcPointField(short point, int adc);
    void setDownflowVelocityPointFactory(short point, float value);
    void setDownflowVelocityPointField(short point, float value);
    ///
    void setDownflowConstant(int dfaConstant);
    void setDownflowTemperatureFactory(float dfaTemperatureFactory);
    void setDownflowTemperatureField(float dfaTemperatureField);
    void setDownflowTemperatureADCField(int dfaTemperatureADCField);
    void setDownflowTemperatureADCFactory(int dfaTemperatureADCFactory);
    void setDownflowLowLimitVelocity(float dfaLowLimitVelocity);
    void setDownflowHigLimitVelocity(float dfaHigLimitVelocity);

    void setAirflowCalibration(short value);

private slots:
    void doStopping();

private:
    QScopedPointer<QTimer>          m_timerEventForMachineState;
    QScopedPointer<QThread>         m_threadForMachineState;
    QScopedPointer<MachineState>    m_machineState;

    MachineData*                    pMachineData;
    int m_count;
};

