#include "DevicePWMOut.h"

DevicePWMOut::DevicePWMOut(QObject *parent)
    : ClassManager(parent)
{
    pSubModule      = nullptr;
    m_channelIO     = 0;
    m_state         = 0;
    m_interlock     = 0;
    m_stateRequest  = 0;
    m_dcyMin        = 0;
}

int DevicePWMOut::interlock() const
{
    return m_interlock;
}

int DevicePWMOut::state() const
{
    return m_state;
}

bool DevicePWMOut::dummyStateEnable() const
{
    return m_dummyStateEnable;
}

void DevicePWMOut::setDummyStateEnable(bool dummyStateEnable)
{
    m_dummyStateEnable = dummyStateEnable;
}

short DevicePWMOut::dummyState() const
{
    return m_dummyState;
}

void DevicePWMOut::setDummyState(short dummyState)
{
    m_dummyState = dummyState;
}

void DevicePWMOut::routineTask(int parameter)
{
    Q_UNUSED(parameter)
    //    qDebug() << "DevicePWMOutManager::worker()";
    int ival;
    ival =  pSubModule->getRegBufferPWM(m_channelIO);


#ifdef QT_DEBUG
    if(m_dummyStateEnable){
        ival = m_dummyState;
    }
#endif
    //get actual state
    if(m_state != ival){
        m_state = ival;

        //Signal
        qDebug() << "State changed " << m_state;
        emit stateChanged(m_state);
    }

    //override with locked state
    m_stateRequest &= ~m_interlock;

    //set sub module to expection state
    if(m_state != m_stateRequest){
        int pwmDcy = m_stateRequest;
        pSubModule->setPWM(m_channelIO, pwmDcy, ClassDriver::I2C_OUT_BUFFER);

        //m_state = m_stateRequest;
        //qDebug() << "State changed 2" << m_state;
        //emit stateChanged(m_state);

#ifdef QT_DEBUG
        if(m_dummyStateEnable){
            m_dummyState = static_cast<short>(m_stateRequest);
        }
#endif
        //        m_stateRequest = BackendEEnums::DIGITAL_STATE_OFF;
        //        qDebug() << "m_stateRequest: " << m_stateRequest;
    }

    emit workerFinished();
}

void DevicePWMOut::setSubModule(PWMpca9685 *obj)
{
    pSubModule = obj;
}

void DevicePWMOut::setChannelIO(int channel)
{
    //    qDebug() << "DigitalOutManager::setChannelIO(): " << channel;
    if(m_channelIO != channel){
        int oldState = m_channelIO;
        m_channelIO = channel;

        emit channelIOChanged(m_channelIO, oldState);
    }
}

void DevicePWMOut::setState(int state)
{
    //    printf("DigitalOutManager::setState\n");
    //    fflush(stdout);

    if(m_state == state) return;
    if(m_stateRequest == state) return;
    m_stateRequest = state;
    if(m_stateRequest <= m_dcyMin)
        m_stateRequest = m_dcyMin;
}

void DevicePWMOut::setInterlock(int interlock)
{
    //    qDebug() << __func__ << interlock << thread();

    if(m_interlock == interlock)return;
    m_interlock = interlock;

    emit interlockChanged(m_interlock);
}

void DevicePWMOut::setDutyCycleMinimum(short dcyMin)
{
    m_dcyMin = dcyMin;
}
