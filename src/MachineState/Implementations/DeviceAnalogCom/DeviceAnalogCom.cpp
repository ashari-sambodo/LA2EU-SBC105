#include "DeviceAnalogCom.h"

DeviceAnalogCom::DeviceAnalogCom(QObject *parent) : ClassManager(parent)
{
    pModule = nullptr;

    m_state         = 0;
    m_adc           = 0;
    m_adcRequest    = 0;

    m_interlocked   = 0;

    m_adcMin        = 0;
    m_adcMax        = 4095;  /// MCP4725_AO_RESOLUTION
    m_stateMin      = 0;
    m_stateMax      = 100;
}

void DeviceAnalogCom::worker()
{
    int ival;
    //actual value from board
    pModule->getRegBufferDAC(&ival);
    //    //override with dummy value
    //    if(m_dummyStateEnabled){
    //        ival = m_adcRequest;
    //    }

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
        pModule->setDAC(m_adcRequest, true);
    }
}

void DeviceAnalogCom::setSubModule(AOmcp4725 *module)
{
    pModule = module;
}

void DeviceAnalogCom::setState(int state)
{
    m_adcRequest = stateToAdc(state);
}

void DeviceAnalogCom::setInterlock(short interlock)
{
    if(m_interlocked == interlock) return;
    m_interlocked = interlock;
    emit interlockChanged(m_interlocked);
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
