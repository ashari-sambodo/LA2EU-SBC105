#pragma once

#include <QDebug>
#include <QScopedPointer>
#include <QSerialPort>

#include "../ClassManager.h"
#include "BoardIO/Drivers/BlowerRegalECM/BlowerRegalECM.h"

class BlowerDsiTorque : public ClassManager
{
    Q_OBJECT
public:
    explicit BlowerDsiTorque(QObject *parent = nullptr);

    int setup();

    void worker() override;

    void setInterlock(int newVal);

    void setDirection(int direction);
    void setDutyCycle(int newVal);

signals:
    void interlockChanged(int newVal);
    void dutyCycleChanged(int newVal);
    void speedRPMChanged(int newVal);
    void directionChanged(int newVal);
    void errorComCountChanged(int newVal);

private:
    QScopedPointer<QSerialPort> m_pSerialPort;
    QScopedPointer<BlowerRegalECM> m_pModuleECM;

    int m_interlocked;

    int m_dutyCycleDemand;
    int m_dutyCycle;

    int m_directionDemand;

    int m_speedRPM;
    QVector<int> m_rpmSamples;
    int          m_rpmSamplesSum;

    void updateActualDemand();
    void readActualSpeedRPM();
};

