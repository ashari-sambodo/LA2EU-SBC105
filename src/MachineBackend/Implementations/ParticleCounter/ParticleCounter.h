#pragma once

#include "../ClassManager.h"
#include "BoardIO/Drivers/ParticleCounterZH03B/ParticleCounterZH03B.h"

class ParticleCounter : public ClassManager
{
    Q_OBJECT
public:
    explicit ParticleCounter(QObject *parent = nullptr);

    void routineTask(int parameter = 0) override;

    void setSubModule(ParticleCounterZH03B *module);

    short getFanStatePaCo()const;
    void setFanStatePaCo(short state);

signals:
    void pm1_0Changed(int value);
    void pm2_5Changed(int value);
    void pm10Changed(int value);

    void fanStatePaCoChanged(int value);

private:
    ParticleCounterZH03B *pModule = nullptr;

    int m_pm2_5 = 0;
    int m_pm1_0 = 0;
    int m_pm10 = 0;

    short m_fanStatePaCoReq = 0;
    short m_fanStatePaCo = 0;

};

