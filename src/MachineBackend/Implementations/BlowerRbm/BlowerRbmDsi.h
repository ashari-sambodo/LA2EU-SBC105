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

    enum BlowerRbmDsiDemandMode {TORQUE_DEMMAND_BRDM, AIRVOLUME_DEMMAND_BRDM};

    void setInterlock(int newVal);

    void setDirection(int direction);
    void setDutyCycle(int newVal);

    int airVolumeScale() const;
    void setAirVolumeScale(int airVolumeScale);

    short demandMode() const;
    void setDemandMode(short demandMode);

    bool dummyStateEnable() const;
    void setDummyStateEnable(bool dummyStateEnable);

    short dummyState() const;
    void setDummyState(short dummyState);

    int dummyRpm() const;
    void setDummyRpm(int dummyRpm);

    int dutyCycle() const;

signals:
    void interlockChanged(short newVal);
    void dutyCycleChanged(short newVal);
    void rpmChanged(short newVal);
    void directionChanged(short newVal);
    void errorComCountChanged(short newVal);

private:
    BlowerRegalECM *pModule;

    int m_interlocked;

    int m_speedDemand;
    int m_dutyCycle;

    int m_directionDemand;

    int m_speedRPM;
    QVector<int> m_rpmSamples;
    int          m_rpmSamplesSum;

    void updateActualDemand();
    void readActualSpeedRPM();

    int m_airVolumeScale = 0;
    short m_demandMode = 0;

    //    bool m_dummyStateEnable = true;
    bool m_dummyStateEnable = false;
    short m_dummyState = 0;
    int m_dummyRpm = 0;
};

