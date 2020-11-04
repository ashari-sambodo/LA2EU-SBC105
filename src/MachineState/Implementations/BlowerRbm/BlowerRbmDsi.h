#pragma once

#include <QDebug>

#include "../ClassManager.h"
#include "BoardIO/Drivers/BlowerRegalECM/BlowerRegalECM.h"

class BlowerRbmDsi : public ClassManager
{
    Q_OBJECT
public:
    explicit BlowerRbmDsi(QObject *parent = nullptr);

    void routineTask(int parameter = 0) override;

    void setSubModule(BlowerRegalECM *module);

    void setInterlock(int newVal);

    void setDirection(int direction);
    void setDutyCycle(int newVal);

signals:
    void interlockChanged(short newVal);
    void dutyCycleChanged(short newVal);
    void speedRPMChanged(short newVal);
    void directionChanged(short newVal);
    void errorComCountChanged(short newVal);

private:
    BlowerRegalECM *pModule;

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

