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

#ifdef QT_DEBUG
    if(m_dummyStateEnable){
        ival = m_dummyAdcState;
    }
#endif

    if(m_adc != ival){
        m_adc = ival;

        //signal
        emit adcChanged(m_adc);
    }

    short offset = 0;
    //get actual voltage
    ival = pSubModule->getmVolt(m_channelIO) + offset;

#ifdef QT_DEBUG
    if(m_dummyStateEnable){
        ival = m_dummyMVoltState;
    }
#endif

    if(m_mVolt != ival){
        m_mVolt = ival;

        //calculete celcius
        int newCelcius = voltageToTemperature(m_mVolt);

        if(m_celcius != newCelcius){
            m_celcius = newCelcius;
            emit celciusChanged(m_celcius);
        }

        if(m_precision > 0){
            double newCelciusPrecision  = voltageToTemperaturePrecision(m_mVolt);
            if(abs(m_celciusPrecision -  newCelciusPrecision) >= 0.1){
                m_celciusPrecision = newCelciusPrecision;
                qDebug() << "Temp Celsius Precision:" << m_celciusPrecision << "mVolt:" << m_mVolt;
                emit celciusPrecisionChanged(m_celciusPrecision);
            }
        }
    }//

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

    //    emit workerFinished();"
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
    return qRound((static_cast<double>(mVolt) / static_cast<double>(TEMPERATURE_LM35_GAIN)) * 100.0) / 100.0;
}

int Temperature::temperatureToVoltage(int temperature)
{
    return (temperature * TEMPERATURE_LM35_GAIN);
}

int Temperature::dummyMVoltState() const
{
    return m_dummyMVoltState;
}

void Temperature::setDummyMVoltState(int dummyMVoltState)
{
    m_dummyMVoltState = dummyMVoltState;
}

int Temperature::dummyAdcState() const
{
    return m_dummyAdcState;
}

void Temperature::setDummyAdcState(short dummyAdcState)
{
    m_dummyAdcState = dummyAdcState;
}

bool Temperature::dummyStateEnable() const
{
    return m_dummyStateEnable;
}

void Temperature::setDummyStateEnable(bool dummyStateEnable)
{
    m_dummyStateEnable = dummyStateEnable;
}
