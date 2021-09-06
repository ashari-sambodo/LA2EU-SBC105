#ifndef CLOSELOOPCONTROL_H
#define CLOSELOOPCONTROL_H

#include "../ClassManager.h"

#define LAST_ERR_COUNT_MAX             10 //Last error

enum FanEnum{
    Downflow,
    Inflow
};

class CloseLoopControl : public ClassManager
{
    Q_OBJECT
public:
    explicit CloseLoopControl(QObject *parent = nullptr);

    void routineTask(int parameter = 0) override;

    //// setting parameter
    void setControlEnable(bool value);
    void setGainProportional(float value);
    void setGainIntegral(float value);
    void setGainDerivatif(float value);

    void setMeasurementUnit(unsigned char value);
    void setSetpoint(float value);
    void setSetpointDcy(short value);
    void setProcessVariable(float value);
    void setSamplingPeriod(float value);
    void setActualFanDutyCycle(float value);

    //// Dummy
    bool getDummyStateEnable() const;
    void setDummyStateEnable(bool dummyStateEnable);

signals:
    void outputControlChanged(short value);

    void workerFinished();

private:
    void pushBackTotalLastError(float value);
    float getTotalLastError() const;
    short getOutputControl();
    float fpm2Mps(short value) const;

    bool m_controlEnable = false;
    float m_gainProportional;
    float m_gainIntegral;
    float m_gainDerivatif;
    float m_error;//current error
    float m_lastError[LAST_ERR_COUNT_MAX];//previousError
    short m_outputControl;//in duty cycle(%)
    float m_samplingPeriod;//in seconds
    //// for velocity need to always use 1 type of measurement unit
    //// we will use metric
    float m_setpoint;    //nominal velocity
    short m_setpointDcy;
    float m_actualDutyCycle;
    float m_processVariable;//velocity actual
    unsigned char m_measurementUnit;//0 metric, 1 imperial

    bool m_dummyStateEnable = false;
};
#endif // CLOSELOOPCONTROL_H
