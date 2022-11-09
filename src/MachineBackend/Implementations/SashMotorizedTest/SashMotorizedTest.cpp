#include "SashMotorizedTest.h"

SashMotorizedTest::SashMotorizedTest(QObject *parent) : ClassManager(parent) {

}

///
/// \brief SashMotorizedTest::routineTask
/// \param parameter
/// Triggered this function by 1 second event timer
///
void SashMotorizedTest::routineTask(int parameter) {
    Q_UNUSED(parameter)

    if((m_SashMotorizedState != MOTOR_SASH_STATE_OFF && !m_TimeoutCountDown)
        || m_SashState == SASH_ERROR_SENSOR
        || !m_SashCycleCountDown){
        _setSashMotorizedState(MOTOR_SASH_STATE_OFF);
    }else{
        switch(m_SashState){
        case SASH_FULLY_OPENED:
            if(m_SashMotorizedState == MOTOR_SASH_STATE_OFF){
                _setSashMotorizedState(MOTOR_SASH_STATE_DOWN);
            }
            if(m_SashMotorizedState == MOTOR_SASH_STATE_UP){
                _setSashMotorizedState(MOTOR_SASH_STATE_OFF);
            }
            break;
        case SASH_WORK:
            if(m_SashMotorizedState == MOTOR_SASH_STATE_OFF){
                _setSashMotorizedState(MOTOR_SASH_STATE_UP);
            }
            break;
        case SASH_UNSAFE:
            if(m_SashMotorizedState == MOTOR_SASH_STATE_OFF){
                switch(m_SashStatePrev){
                case SASH_FULLY_OPENED:
                    _setSashMotorizedState(MOTOR_SASH_STATE_DOWN);
                    break;
                case SASH_WORK:
                    _setSashMotorizedState(MOTOR_SASH_STATE_UP);
                    break;
                case SASH_STANDBY:
                    _setSashMotorizedState(MOTOR_SASH_STATE_UP);
                    break;
                case SASH_FULLY_CLOSED:
                    _setSashMotorizedState(MOTOR_SASH_STATE_UP);
                    break;
                }
            }
            break;
        case SASH_STANDBY:
            if(m_SashMotorizedState == MOTOR_SASH_STATE_OFF){
                _setSashMotorizedState(MOTOR_SASH_STATE_UP);
            }
            break;
        case SASH_FULLY_CLOSED:
            if(m_SashMotorizedState == MOTOR_SASH_STATE_OFF){
                _setSashMotorizedState(MOTOR_SASH_STATE_UP);
            }
            if(m_SashMotorizedState == MOTOR_SASH_STATE_DOWN){
                _setSashMotorizedState(MOTOR_SASH_STATE_OFF);
            }
            break;
        }
    }

    if(!m_SashMotorizedDelayBetweenRunCountDown)
        m_SashCycleCountDown = m_SashMotorizedRunCycleLimit;
    else m_SashMotorizedDelayBetweenRunCountDown--;

    if(m_TimeoutCountDown) m_TimeoutCountDown--;
    setSashMotorizedTestRunTime(m_SashMotorizedTestRunTime++);
}

void SashMotorizedTest::setSashCycle(int value)
{
    value = value/10;

    if(m_SashCycle == value) return;
    m_SashCycle = value;
    if(!m_SashCycleCountDown)
        m_SashMotorizedDelayBetweenRunCountDown = m_SashMotorizedDelayBetweenRun;
    else m_SashCycleCountDown--;
}

void SashMotorizedTest::setSashMotorizedDelayBetweenRun(int value)
{
    m_SashMotorizedDelayBetweenRun = value;
}

void SashMotorizedTest::setSashMotorizedRunCycleLimit(int value)
{
    m_SashMotorizedRunCycleLimit = value;
}

void SashMotorizedTest::setSashMotorizedTestRunTime(int value)
{
    if(m_SashMotorizedTestRunTime == value)return;

    m_SashMotorizedTestRunTime = value;
    emit sashMotorizedTestRunTimeChanged(value);
}



void SashMotorizedTest::setSashMotorizedTriggeredTimeout(int value)
{
    m_SashMotorizedTriggeredTimeout = value;
}

void SashMotorizedTest::start()
{
    setSashMotorizedTestRunTime(0);
    m_SashCycleCountDown = m_SashMotorizedRunCycleLimit;
    emit started();
}

void SashMotorizedTest::stop()
{
    m_SashCycleCountDown = 0;
    m_TimeoutCountDown = 0;
    _setSashMotorizedState(MOTOR_SASH_STATE_OFF);
    emit stopped();
}

void SashMotorizedTest::setSashState(short value)
{
    m_SashState = value;
    if(value != SASH_UNSAFE){
        m_SashStatePrev = value;
    }
}

void SashMotorizedTest::_setSashMotorizedState(short value)
{
    if(m_SashMotorizedState == value)return;
    if(value != MOTOR_SASH_STATE_OFF)
        m_TimeoutCountDown = m_SashMotorizedTriggeredTimeout;
    emit sashMotorizeStateChanged(value);
}
