#include "CloseLoopControl.h"

#define TEI_FOR_BOARD_IO               1500 //Timer Event Interrupt Sensor reading

CloseLoopControl::CloseLoopControl(QObject *parent)
    : ClassManager(parent)
{
    m_controlEnable = false;
    m_sensorSamplingPeriod = TEI_FOR_BOARD_IO/1000.0; //Convert to second
    m_measurementUnit = 0;//metric
    for(unsigned char i=0; i < CLOSE_LOOP_CONTROL_COUNT_MAX; i++){
        m_gainProportional[i] = 0.0;
        m_gainIntegral[i] = 0.0;
        m_gainDerivatif[i] = 0.0;
        m_error[i] = 0.0;
        m_totalError[i] = 0.0;

        for(unsigned char j=0; j < LAST_ERR_COUNT_MAX; j++)
            m_lastError[i][j] = 0.0;

        m_outputControl[i] = 0;
        m_setpoint[i] = 0.0;
        m_processVariable[i] = 0.0;
    }
}

void CloseLoopControl::setControlEnable(bool value)
{
    if(m_controlEnable == value)return;
    m_controlEnable = value;
}

void CloseLoopControl::setGainProportional(float value, short index)
{
    if(m_gainProportional[index] == value)return;
    m_gainProportional[index] = value;
}

void CloseLoopControl::setGainIntegral(float value, short index)
{
    if(m_gainIntegral[index] == value)return;
    m_gainIntegral[index] = value;
}

void CloseLoopControl::setGainDerivatif(float value, short index)
{
    if(m_gainDerivatif[index] == value)return;
    m_gainDerivatif[index] = value;
}

void CloseLoopControl::setMeasurementUnit(unsigned char value)
{
    if(m_measurementUnit == value)return;
    m_measurementUnit = value;
}

void CloseLoopControl::setSetpoint(float value, short index)
{
    if(m_setpoint[index] == value)return;
    m_setpoint[index] = value;
}

void CloseLoopControl::setProcessVariable(float value, short index)
{
    if(m_processVariable[index] == value)return;
    m_processVariable[index] = value;
}

bool CloseLoopControl::getDummyStateEnable() const
{
    return m_dummyStateEnable;
}

void CloseLoopControl::setDummyStateEnable(bool dummyStateEnable)
{
    if(m_dummyStateEnable == dummyStateEnable)return;
    m_dummyStateEnable = dummyStateEnable;
}
