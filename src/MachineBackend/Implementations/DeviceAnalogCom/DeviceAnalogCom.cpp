#include "DeviceAnalogCom.h"

DeviceAnalogCom::DeviceAnalogCom(QObject *parent) : ClassManager(parent)
{
    pBoard = nullptr;

    m_state         = 0;
    m_adc           = 0;
    m_adcRequest    = 0;

    m_interlocked   = 0;

    m_adcMin        = 0;
    m_adcMax        = 4095;  /// MCP4725_AO_RESOLUTION
    m_stateMin      = 0;
    m_stateMax      = 100;
}

void DeviceAnalogCom::routineTask(int parameter)
{
    Q_UNUSED(parameter)
    int ival;
    //actual value from board
    pBoard->getRegBufferDAC(&ival);

#ifdef QT_DEBUG
    if(m_dummyStateEnable){
        ival = stateToAdc(m_dummyState);
    }
    //conevert ADC to percent
    if(m_adc != ival){
        m_adc = ival;
        m_state = adcToState(m_adc);

        emit adcChanged(m_adc);
        emit stateChanged(m_state);

        //        qDebug() << "DeviceAnalogCom::m_adc " << m_adc;
        //        qDebug() << "DeviceAnalogCom::m_state " << m_state;
    }

    /// look the interlocked state
    if(m_adcRequest && m_interlocked) m_adcRequest = 0;

    /// send req state as a adc to board
    if(m_adcRequest != m_adc)
        m_dummyState = adcToState(m_adcRequest);
    return;

#endif

    //conevert ADC to percent
    if(m_adc != ival){
        m_adc = ival;
        m_state = adcToState(m_adc);

        emit adcChanged(m_adc);
        emit stateChanged(m_state);

        //        qDebug() << "DeviceAnalogCom::m_adc " << m_adc;
        //        qDebug() << "DeviceAnalogCom::m_state " << m_state;
    }

    /// look the interlocked state
    if(m_adcRequest && m_interlocked) m_adcRequest = 0;

    /// send req state as a adc to board
    if(m_adcRequest != m_adc){
        pBoard->setDAC(m_adcRequest, ClassDriver::I2C_OUT_BUFFER);

        //#ifdef QT_DEBUG
        //        if(m_dummyStateEnable){
        //            m_dummyState = adcToState(m_adcRequest);
        //        }
        //#endif
    }
}

void DeviceAnalogCom::setSubBoard(AOmcp4725 *board)
{
    pBoard = board;
}

void DeviceAnalogCom::setState(int state)
{
    m_adcRequest = stateToAdc(state);
}

int DeviceAnalogCom::getState() const
{
    return m_state;
}

void DeviceAnalogCom::setInterlock(short interlock)
{
    if(m_interlocked == interlock) return;
    m_interlocked = interlock;
    emit interlockChanged(m_interlocked);
}

int DeviceAnalogCom::adcMin() const
{
    return m_adcMin;
}

void DeviceAnalogCom::setAdcMin(int adcMin)
{
    m_adcMin = adcMin;
}

int DeviceAnalogCom::adcMax() const
{
    return m_adcMax;
}

void DeviceAnalogCom::setAdcMax(int adcMax)
{
    m_adcMax = adcMax;
}

int DeviceAnalogCom::stateMin() const
{
    return m_stateMin;
}

void DeviceAnalogCom::setStateMin(int stateMin)
{
    m_stateMin = stateMin;
}

int DeviceAnalogCom::stateMax() const
{
    return m_stateMax;
}

void DeviceAnalogCom::setStateMax(int stateMax)
{
    m_stateMax = stateMax;
}

int DeviceAnalogCom::adcToState(int adc)
{
    return mapToVal(adc, m_adcMin, m_adcMax, m_stateMin, m_stateMax);
}

int DeviceAnalogCom::stateToAdc(int state)
{
    return mapToVal(state, m_stateMin, m_stateMax, m_adcMin, m_adcMax);
}

int DeviceAnalogCom::mapToVal(int val, int inMin, int inMax, int outMin, int outMax)
{
    return qRound(((float)(val - inMin)) * ((float)(outMax - outMin)) / ((float)(inMax - inMin))  + outMin);
}

bool DeviceAnalogCom::dummyStateEnable() const
{
    return m_dummyStateEnable;
}

void DeviceAnalogCom::setDummyStateEnable(bool dummyStateEnable)
{
    m_dummyStateEnable = dummyStateEnable;
}

short DeviceAnalogCom::dummyState() const
{
    return m_dummyState;
}

void DeviceAnalogCom::setDummyState(short dummyState)
{
    m_dummyState = dummyState;
}
