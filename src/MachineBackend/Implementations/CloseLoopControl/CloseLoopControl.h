#ifndef CLOSELOOPCONTROL_H
#define CLOSELOOPCONTROL_H

#include "../ClassManager.h"

#define CLOSE_LOOP_CONTROL_COUNT_MAX   2 //Downflow and Inflow fan
#define LAST_ERR_COUNT_MAX             10 //Last error

class CloseLoopControl : public ClassManager
{
    Q_OBJECT
public:
    explicit CloseLoopControl(QObject *parent = nullptr);

    void routineTask(int parameter = 0) override;

    //// setting parameter
    void setControlEnable(bool value);
    void setGainProportional(float value, short index);
    void setGainIntegral(float value, short index);
    void setGainDerivatif(float value, short index);

    void setMeasurementUnit(unsigned char value);
    void setSetpoint(float value, short index);
    void setProcessVariable(float value, short index);

    //// Dummy
    bool getDummyStateEnable() const;
    void setDummyStateEnable(bool dummyStateEnable);

signals:
    void outputControlChanged(short value, short index);

    void workerFinished();

private:
    bool m_controlEnable = false;
    float m_gainProportional[CLOSE_LOOP_CONTROL_COUNT_MAX];
    float m_gainIntegral[CLOSE_LOOP_CONTROL_COUNT_MAX];
    float m_gainDerivatif[CLOSE_LOOP_CONTROL_COUNT_MAX];
    float m_error[CLOSE_LOOP_CONTROL_COUNT_MAX];//current error
    float m_lastError[CLOSE_LOOP_CONTROL_COUNT_MAX][LAST_ERR_COUNT_MAX];//previousError
    short m_outputControl[CLOSE_LOOP_CONTROL_COUNT_MAX];//in duty cycle(%)
    float m_totalError[CLOSE_LOOP_CONTROL_COUNT_MAX];
    float m_sensorSamplingPeriod;//in seconds
    //// for velocity need to always use 1 type of measurement unit
    //// we will use metric
    float m_setpoint[CLOSE_LOOP_CONTROL_COUNT_MAX];//nominal velocity
    float m_processVariable[CLOSE_LOOP_CONTROL_COUNT_MAX];//velocity actual
    unsigned char m_measurementUnit;//0 metric, 1 imperial

    bool m_dummyStateEnable = false;
};
#endif // CLOSELOOPCONTROL_H
