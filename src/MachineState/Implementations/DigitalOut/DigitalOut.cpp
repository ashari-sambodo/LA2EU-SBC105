#include "DigitalOut.h"

DigitalOutManager::DigitalOutManager(QObject *parent)
    : ClassManager(parent)
{
    pSubModule      = nullptr;
    m_channelIO     = 0;
    m_state         = 0;
    m_interlock     = 0;
    m_stateRequest  = 0;
}

int DigitalOutManager::interlock() const
{
    return m_interlock;
}

int DigitalOutManager::state() const
{
    return m_state;
}

void DigitalOutManager::worker(int parameter)
{
    Q_UNUSED(parameter)
    //    qDebug() << "DigitalOutManager::worker()";
    int ival;
    ival =  pSubModule->getRegBufferPWM(m_channelIO);
    //    qDebug() << "Value: " << ival;
    ival = ival == PCA9685_PWM_VAL_FULL_DCY_ON ? 1 : 0;

    //get actual state
    if(m_state != ival){
        m_state = ival;

        //Signal
        emit stateChanged(m_state);
    }

    //override with locked state
    m_stateRequest &= ~m_interlock;

    //set sub module to expection state
    if(m_state != m_stateRequest){
        int pwmDcy = (m_stateRequest == 1) ?
                    PCA9685_PWM_VAL_FULL_DCY_ON : PCA9685_PWM_VAL_FULL_DCY_OFF;
        pSubModule->setPWM(m_channelIO, pwmDcy, PWMpca9685::I2C_OUT_BUFFER);

        //        m_stateRequest = BackendEEnums::DIGITAL_STATE_OFF;
        //        qDebug() << "m_stateRequest: " << m_stateRequest;
    }

    emit workerFinished();
}

void DigitalOutManager::setSubModule(PWMpca9685 *obj)
{
    pSubModule = obj;
}

void DigitalOutManager::setChannelIO(int channel)
{
    //    qDebug() << "DigitalOutManager::setChannelIO(): " << channel;
    if(m_channelIO != channel){
        int oldState = m_channelIO;
        m_channelIO = channel;

        emit channelIOChanged(m_channelIO, oldState);
    }
}

void DigitalOutManager::setState(int state)
{
    //    printf("DigitalOutManager::setState\n");
    //    fflush(stdout);

    if(m_state == state) return;
    if(m_stateRequest == state) return;
    m_stateRequest = state;
}

void DigitalOutManager::setInterlock(int interlock)
{
    //    qDebug() << "DigitalOutManager::setInterlock(): " << interlock;
    if(m_interlock == interlock)return;
    m_interlock = interlock;

    emit interlockChanged(m_interlock);
}
