#include "MotorizeOnRelay.h"

enum ENUM_MOTOR_STATE{
    MOTOR_STATE_OFF,
    MOTOR_STATE_UP,
    MOTOR_STATE_DOWN,
    MOTOR_STATE_UP_DOWN
};

MotorizeOnRelay::MotorizeOnRelay(QObject *parent)
    : ClassManager (parent)
{
    pSubModule      = nullptr;
    m_channelUp     = 0;
    m_channelDown   = 0;

    m_state         = 0;
    m_stateRequest  = 0;

    m_interlockUp   = 0;
    m_interlockDown = 0;
}

void MotorizeOnRelay::routineTask(int /*parameter*/)
{
    //GET ACTUAL STATE FROM SUB MODULE
    int ivalUp, ivalDown;
    short ivalActual;
    ivalUp      =  pSubModule->getRegBufferPWM(m_channelUp);
    ivalDown    =  pSubModule->getRegBufferPWM(m_channelDown);

    //    printf("ivalUp %d = %d\n", m_channelUp, ivalUp);
    //    printf("ivalDown %d = %d\n", m_channelDown, ivalDown);
    //    fflush(stdout);

    ivalUp = ivalUp ? 1 : 0;
    ivalDown = ivalDown ? 1 : 0;

    //CHECK THE STATE
    if(ivalUp && ivalDown){
        ivalActual = MOTOR_STATE_UP_DOWN;
    }
    else if(ivalUp){
        ivalActual = MOTOR_STATE_UP;
    }
    else if(ivalDown){
        ivalActual = MOTOR_STATE_DOWN;
    }
    else {
        ivalActual = MOTOR_STATE_OFF;
    }

#ifdef QT_DEBUG
    if(m_dummyStateEnable){
        ivalActual = m_dummyState;
    }
#endif

    //SAVE THE ACTUAL STATE
    if(m_state != ivalActual){
        m_state = ivalActual;

        //Signal
        emit stateChanged(m_state);
    }

    //CARE TO INTERLOCK STATE
    if((m_stateRequest == MOTOR_STATE_UP) && m_interlockUp) m_stateRequest = MOTOR_STATE_OFF;
    if((m_stateRequest == MOTOR_STATE_DOWN) && m_interlockDown) m_stateRequest = MOTOR_STATE_OFF;

    //SYNC THE REQUEST STATE TO SUB MODULE
    if(m_state != m_stateRequest){
        switch (m_stateRequest) {
        case  MOTOR_STATE_OFF:
            if(ivalUp)      pSubModule->setPWM(m_channelUp, PCA9685_PWM_VAL_FULL_DCY_OFF, ClassDriver::I2C_OUT_BUFFER);
            if(ivalDown)    pSubModule->setPWM(m_channelDown, PCA9685_PWM_VAL_FULL_DCY_OFF, ClassDriver::I2C_OUT_BUFFER);
            break;
        case  MOTOR_STATE_UP:
            if(m_protectFromDualActive) if(ivalDown) pSubModule->setPWM(m_channelDown, PCA9685_PWM_VAL_FULL_DCY_OFF, PWMpca9685::I2C_OUT_BUFFER);
            pSubModule->setPWM(m_channelUp, PCA9685_PWM_VAL_FULL_DCY_ON, ClassDriver::I2C_OUT_BUFFER);
            break;
        case  MOTOR_STATE_DOWN:
            if(m_protectFromDualActive) if(m_channelUp) pSubModule->setPWM(m_channelUp, PCA9685_PWM_VAL_FULL_DCY_OFF, PWMpca9685::I2C_OUT_BUFFER);
            pSubModule->setPWM(m_channelDown, PCA9685_PWM_VAL_FULL_DCY_ON, ClassDriver::I2C_OUT_BUFFER);
            break;
        }

#ifdef QT_DEBUG
    if(m_dummyStateEnable){
        m_dummyState = m_stateRequest;

        qDebug() << metaObject()->className() << __func__ << "m_stateRequest: " << m_stateRequest;
    }
#endif
    }

    //    //override with locked state
    //    m_stateRequest &= ~m_interlock;

    //    //set sub module to expection state
    //    if(m_state != m_stateRequest){
    //        int pwmDcy = (m_stateRequest == 1) ?
    //                    PCA9685_PWM_VAL_FULL_DCY_ON : PCA9685_PWM_VAL_FULL_DCY_OFF;
    //        pSubModule->setPWM(m_channelIO, pwmDcy, PWMpca9685::I2C_OUT_BUFFER);

    //        //        m_stateRequest = BackendEEnums::DIGITAL_STATE_OFF;
    //        //        qDebug() << "m_stateRequest: " << m_stateRequest;
    //    }

}

void MotorizeOnRelay::setSubModule(PWMpca9685 *module)
{
    pSubModule = module;
}

void MotorizeOnRelay::setState(short state)
{
    if(m_state == state) return;
    if(m_stateRequest == state) return;
    m_stateRequest = state;
}

void MotorizeOnRelay::setInterlockUp(short interlock)
{
    if(m_interlockUp == interlock) return;
    m_interlockUp = interlock;

    emit interlockUpChanged(m_interlockUp);
}

void MotorizeOnRelay::setInterlockDown(short interlock)
{
    if(m_interlockDown == interlock) return;
    m_interlockDown = interlock;

    emit interlockDownChanged(m_interlockDown);
}

int MotorizeOnRelay::interlockUp() const
{
    return m_interlockUp;
}

int MotorizeOnRelay::interlockDown() const
{
    return m_interlockDown;
}

void MotorizeOnRelay::setChannelUp(char channelUp)
{
    m_channelUp = channelUp;
}

void MotorizeOnRelay::setChannelDown(char channelDown)
{
    m_channelDown = channelDown;
}

bool MotorizeOnRelay::protectFromDualActive() const
{
    return m_protectFromDualActive;
}

void MotorizeOnRelay::setProtectFromDualActive(bool protectFromDualActive)
{
    m_protectFromDualActive = protectFromDualActive;
}

bool MotorizeOnRelay::dummyStateEnable() const
{
    return m_dummyStateEnable;
}

void MotorizeOnRelay::setDummyStateEnable(bool dummyStateEnable)
{
    qDebug() << metaObject()->className() << __func__ << dummyStateEnable;
    m_dummyStateEnable = dummyStateEnable;
}

short MotorizeOnRelay::dummyState() const
{
    return m_dummyState;
}

void MotorizeOnRelay::setDummyState(short dummyState)
{
    m_dummyState = dummyState;
}
