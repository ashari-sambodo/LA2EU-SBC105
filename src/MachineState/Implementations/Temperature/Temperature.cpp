#include "Temperature.h"
#include <cmath>

#define TEMPERATURE_LM35_GAIN   10 // 10mV per degree celcius

Temperature::Temperature(QObject *parent)
    : ClassManager(parent)
{
    pSubModule      = nullptr;
    m_channelIO     = 0;
    m_adc           = 0;
    m_mVolt         = 0;
    m_celcius           = 0;
    m_celciusPrecision  = 0;
    m_precision         = 0;
}

void Temperature::routineTask(int parameter)
{
    Q_UNUSED(parameter)

    //get actual adc
    int ival = 0;
    ival = pSubModule->getADC(m_channelIO);
    if(m_adc != ival){
        m_adc = ival;

        //signal
        emit adcChanged(m_adc);
    }

    //get actual voltage
    ival = pSubModule->getmVolt(m_channelIO);

    if(m_mVolt != ival){
        m_mVolt = ival;

        //calculete celcius
        int newCelcius = voltageToTemperature(m_mVolt);

        if(m_celcius != newCelcius){
            m_celcius   =   newCelcius;
            emit celciusChanged(m_celcius);
        }

        if(m_precision > 0){
            double newCelciusPrecision  = voltageToTemperaturePrecision(m_mVolt);
            if(abs(m_celciusPrecision -  newCelciusPrecision) >= 0.1){
                m_celciusPrecision = newCelciusPrecision;
                emit celciusPrecisionChanged(m_celciusPrecision);
            }
        }
    }

    emit workerFinished();

    //    //get actual adc
    //    int ival = 0;
    //    ival = pAI->getADC(m_channel);
    //    if(m_adc != ival){
    //        m_adc = ival;

    //        //signal
    //        emit adcChanged(m_adc);
    //    }

    //    //    m_dummyTemp += 1;

    //    //get actual voltage
    //    ival = pAI->getmVolt(m_channel);
    //    //    m_dummyTemp++;
    //    if(m_dummyTempEnabled){
    //        ival = temperatureToVoltage(m_dummyTemp);
    //    }
    //    //    ival = 200;
    //    //
    //    if(m_mVolt != ival){
    //        m_mVolt = ival;

    //        //calculete celcius
    //        m_celcius = voltageToTemperature(m_mVolt);

    //        //signal
    //        emit celciusChanged(m_celcius);
    //    }

    //    emit workerFinished();'
}

void Temperature::setSubModule(AIManage *obj)
{
    pSubModule = obj;
}

void Temperature::setChannelIO(int channel)
{
    if(m_channelIO != channel){
        int oldState = m_channelIO;
        m_channelIO = channel;

        emit channelIOChanged(m_channelIO, oldState);
    }
}

void Temperature::setPrecision(int newVal)
{
    m_precision = newVal;
}

double Temperature::celciusPrecision() const
{
    return m_celciusPrecision;
}

int Temperature::celcius() const
{
    return m_celcius;
}

//ROUND_UP_TEMPERATURE_VALUE
int Temperature::voltageToTemperature(int mVolt)
{
    return std::ceil((float) mVolt / (float) TEMPERATURE_LM35_GAIN);
}

double Temperature::voltageToTemperaturePrecision(int mVolt)
{
    return qRound((mVolt / (double)TEMPERATURE_LM35_GAIN) * 100.0) / 100.0;
}

int Temperature::temperatureToVoltage(int temperature)
{
    return (temperature * TEMPERATURE_LM35_GAIN);
}
