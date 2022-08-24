#include "DeviceDigitalOut.h"

DeviceDigitalOut::DeviceDigitalOut(QObject *parent)
    : ClassManager(parent)
{
    pSubModule      = nullptr;
    m_channelIO     = 0;
    m_state         = 0;
    m_interlock     = 0;
    m_stateRequest  = 0;
}

int DeviceDigitalOut::interlock() const
{
    return m_interlock;
}

int DeviceDigitalOut::state() const
{
    return m_state;
}

bool DeviceDigitalOut::dummyStateEnable() const
{
    return m_dummyStateEnable;
}

void DeviceDigitalOut::setDummyStateEnable(bool dummyStateEnable)
{
    m_dummyStateEnable = dummyStateEnable;
}

short DeviceDigitalOut::dummyState() const
{
    return m_dummyState;
}

void DeviceDigitalOut::setDummyState(short dummyState)
{
    if(m_interlock)return;
    m_dummyState = dummyState;
    m_stateRequest = dummyState;
}

void DeviceDigitalOut::routineTask(int parameter)
{
    Q_UNUSED(parameter)
    //    qDebug() << "DigitalOutManager::worker()";
    int ival;
    ival =  pSubModule->getRegBufferPWM(m_channelIO);

    ival = ival == PCA9685_PWM_VAL_FULL_DCY_ON ? 1 : 0;

#ifdef QT_DEBUG
    if(m_dummyStateEnable){
        ival = m_dummyState;
    }
#endif
    //get actual state
    if(m_state != ival){
        m_state = ival;

        //Signal
        qDebug() << "State changed 1" << m_state;
        emit stateChanged(m_state);
    }

    //override with locked state
    m_stateRequest &= ~m_interlock;

    //set sub module to expection state
    if(m_state != m_stateRequest){
        int pwmDcy = (m_stateRequest == 1) ?
                    PCA9685_PWM_VAL_FULL_DCY_ON : PCA9685_PWM_VAL_FULL_DCY_OFF;
        pSubModule->setPWM(m_channelIO, pwmDcy, ClassDriver::I2C_OUT_BUFFER);

        //m_state = m_stateRequest;
        //qDebug() << "State changed 2" << m_state;
        //emit stateChanged(m_state);

        //#ifdef QT_DEBUG
        //        if(m_dummyStateEnable){
        //            m_dummyState = static_cast<short>(m_stateRequest);
        //        }
        //#endif
        //        m_stateRequest = BackendEEnums::DIGITAL_STATE_OFF;
        //        qDebug() << "m_stateRequest: " << m_stateRequest;
    }

    emit workerFinished();
}

void DeviceDigitalOut::setSubModule(PWMpca9685 *obj)
{
    pSubModule = obj;
}

void DeviceDigitalOut::setChannelIO(int channel)
{
    //    qDebug() << "DigitalOutManager::setChannelIO(): " << channel;
    if(m_channelIO != channel){
        int oldState = m_channelIO;
        m_channelIO = channel;

        emit channelIOChanged(m_channelIO, oldState);
    }
}

void DeviceDigitalOut::setState(int state)
{
    //    printf("DigitalOutManager::setState\n");
    //    fflush(stdout);
    qDebug() << m_channelIO << state << m_interlock << m_state << m_stateRequest << m_dummyStateEnable << m_dummyState;
    if(state >= 1) state = 1;
    if(m_interlock && state)return;
    if(m_state == state) return;
    if(m_stateRequest == state) return;
    m_stateRequest = state;
    if(m_dummyStateEnable)m_dummyState = state;
}

void DeviceDigitalOut::setInterlock(int interlock)
{
    //    qDebug() << __func__ << interlock << thread();

    if(m_interlock == interlock)return;
    m_interlock = interlock;

    emit interlockChanged(m_interlock);
}
