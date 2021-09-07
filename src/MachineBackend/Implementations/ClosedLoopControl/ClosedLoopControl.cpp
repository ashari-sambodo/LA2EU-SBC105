#include "ClosedLoopControl.h"


ClosedLoopControl::ClosedLoopControl(QObject *parent)
    : ClassManager(parent)
{
    m_controlEnable = false;
    m_samplingPeriod = 0.0; //Convert to second
    m_measurementUnit = 0;//metric

    m_gainProportional = 0.0;
    m_gainIntegral = 0.0;
    m_gainDerivative = 0.0;
    m_error = 0.0;

    for(unsigned char j=0; j < LAST_ERR_COUNT_MAX; j++)
        m_lastError[j] = 0.0;

    m_outputControl = 0;
    m_setpoint = 0.0;
    m_processVariable = 0.0;
    m_setpointDcy = 0;
    m_actualDutyCycle = 0.0;
}


void ClosedLoopControl::routineTask(int parameter)
{
    Q_UNUSED(parameter)
    short outputControl = {0};

    if(m_controlEnable){

        /// Calculate Close Loop Controller
        outputControl = getOutputControl();

        if(outputControl != m_outputControl){
            m_outputControl = outputControl;
            emit outputControlChanged(m_outputControl);

        }
    }else{
        /// Take value from Duty cycle Setpoint
        outputControl = m_setpointDcy;

        if(outputControl != m_outputControl){
            m_outputControl = outputControl;
            emit outputControlChanged(m_outputControl);
        }
    }
    emit workerFinished();
}

void ClosedLoopControl::setControlEnable(bool value)
{
    if(m_controlEnable == value)return;
    m_controlEnable = value;
}

void ClosedLoopControl::setGainProportional(float value)
{
    m_gainProportional = value;
}

void ClosedLoopControl::setGainIntegral(float value)
{
    m_gainIntegral = value;
}

void ClosedLoopControl::setGainDerivative(float value)
{
    m_gainDerivative = value;
}

void ClosedLoopControl::setMeasurementUnit(unsigned char value)
{
    m_measurementUnit = value;
}

void ClosedLoopControl::setSetpoint(float value)
{
    value = value/static_cast<float>(100.0);
    if(m_measurementUnit)
        m_setpoint = fpm2Mps(static_cast<short>(value));
    else
        m_setpoint = value;
}

void ClosedLoopControl::setSetpointDcy(short value)
{
    m_setpointDcy = value;
}

void ClosedLoopControl::setProcessVariable(float value)
{
    if(m_measurementUnit)
        m_processVariable = fpm2Mps(static_cast<short>(value));
    else
        m_processVariable = value;
}

void ClosedLoopControl::setSamplingPeriod(float value)
{
    m_samplingPeriod = (value / static_cast<float>(1000.0));
}

void ClosedLoopControl::setActualFanDutyCycle(float value)
{
    m_actualDutyCycle = value;
}

bool ClosedLoopControl::getDummyStateEnable() const
{
    return m_dummyStateEnable;
}

void ClosedLoopControl::setDummyStateEnable(bool dummyStateEnable)
{
    m_dummyStateEnable = dummyStateEnable;
}

void ClosedLoopControl::pushBackTotalLastError(float value)
{
    for(short i=(LAST_ERR_COUNT_MAX-1); i>0; i--){
        m_lastError[i] = m_lastError[i-1];
    }
    m_lastError[0] = value;
}

float ClosedLoopControl::getTotalLastError() const
{
    float totalError = 0.0;
    for(short i=0; i<LAST_ERR_COUNT_MAX; i++)
        totalError += m_lastError[i];
    return totalError;
}

/// \brief ClosedLoopControl::getOutputControl
/// \param index
/// e(n) = SP - PV(n)
/// COp = Kp * e(n)
/// COi = Ki * Ts * (e(n) + e(n-1) + ... + e(n-LAST_ERR_COUNT_MAX))
/// COd = (Kd / Ts) (e(n) - e(n-1))
/// CO  = COp + COi + COd
/// .........................................................................................
/// e(n) = Error / Deviation between setpoint velocity and Actual velocity at current sample
/// SP = Setpoint value / Desired Output Velocity
/// PV = Process Variable / Actual velocity (feedback)
/// Kp = Gain Proportional
/// Ki = Gain Integral
/// Kd = Gain Derivative
/// Ts = Time sampling used (period between n and n-1)
/// COp = Control Output Proportional
/// COi = Control Output Integral
/// COd = Control Output Derivative
/// CO = Control Output Final
/// //////////////////////////////////////////////////////////////////////////////////////////

short ClosedLoopControl::getOutputControl()
{
    float e, le, tle, sp, pv, kp, ki, kd, ts, COp, COi, COd;
    float CO;

    sp = m_setpoint;
    pv = m_processVariable;
    e = sp - pv;
    le = m_lastError[0];
    tle = getTotalLastError();
    kp = m_gainProportional;
    ki = m_gainIntegral;
    kd = m_gainDerivative;
    ts = m_samplingPeriod;
    COp = kp * e;
    COi = ki * ts * tle;
    COd = (kd/ts) * le;
    CO = COp + COi + COd;

    m_actualDutyCycle += CO;

    //    qDebug() << "Sp: " << sp <<"Pv:"<< pv;
    //    qDebug() << "Error: " << e;
    //    qDebug() << "Kp:" << kp <<"Ki:" << ki << "Kd:" << kd;
    //    qDebug() << "CO:" << CO << "from" << COp << COi << COd;
    //    qDebug() << "Dcy nom:" << m_setpointDcy << "actual:" << m_actualDutyCycle;
    //    qDebug() << "OutputControl:" << m_actualDutyCycle;

    return static_cast<short>(qRound(m_actualDutyCycle));
}

float ClosedLoopControl::fpm2Mps(short value) const
{
    return static_cast<float>(value/196.85);
}
