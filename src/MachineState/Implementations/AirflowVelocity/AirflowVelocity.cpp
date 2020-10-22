#include "AirflowVelocity.h"
#include <cmath>

AirflowManager::AirflowManager(QObject *parent)
    : ClassManager(parent)
{
    m_adc               = 0;
    m_adcConpensation   = 0;
    m_velocity          = 0;
    m_constant          = 0;
    m_m1                = 0;
    m_b1                = 0;
    m_m2                = 0;
    m_b2                = 0;
    m_temperature       = 0;

    adcDummy            = 0;
    m_adcChanged        = false;
    m_velocityChanged   = false;
}

/**
 * @brief AirflowManager::worker
 * @param parameter
 * Calculate ADC Compensation, then
 * Calculate AIrflow Velocity
 */
void AirflowManager::worker(int parameter)
{
    Q_UNUSED(parameter);

    int adc = pAI->getADC(m_channel);

    //dummyADC
    //    adc = adcDummy += 10;
    //    qDebug() << "AirflowManager::workerCompensationADC() " << adc;

    bool recalculateAdcConpensation = false;
    bool recalculateVelocity        = false;

    //ADC
    int adcC = 0;
    if(m_adc != adc){
        m_adc = adc;
        recalculateAdcConpensation = true;
        emit adcChanged(m_adc);
    }

    //TEMPERATURE
    if(m_temperatureChanged){
        recalculateAdcConpensation = true;
        m_temperatureChanged = false;
    }

    //ADC CONPENSATION
    if(recalculateAdcConpensation){

        //ADC TEMPERATURE CONVESATION
        if((m_constant == 0) || (m_temperature > 50.0)){
            adcC = adc;
        }
        else{
            adcC = qRound((double)adc + (double)adc * (m_temperature - 25.0) / (double)m_constant);
            //            double result;
            //            result =  m_temperature - 25.0;
            //            result += (double)m_constant;
            //            result *= (double)(adc);
            //            result /= (double)(m_constant);
            //            adcC = qRound(result);
        }

        if(m_adcConpensation != adcC){
            m_adcConpensation   = adcC;
            recalculateVelocity = true;
            emit adcConpensationChanged(m_adcConpensation);
        }
    }

    //VELOCITY
    if(recalculateVelocity){
        double velocity = 0;
        if(m_adcConpensation <= m_adcPoint[0]){
            velocity = 0;
        }else if(m_adcConpensation <= m_adcPoint[1]){
            velocity = (double)qRound((((double)m_adcConpensation - m_b1) / m_m1) * 1000.0) / 1000.0;
        }else{
            velocity = (double)qRound((((double)m_adcConpensation - m_b2) / m_m2) * 1000.0) / 1000.0;
        }

        //nomalization, airflow value dont have negative
        if(m_velocity < 0) m_velocity = 0;

        //    printf("Velocity %.2f\n", m_velocity);
        //    fflush(stdout);

        if(fabs(velocity - m_velocity) >= 0.001){
            m_velocity = velocity;

            if(!m_velocityChanged) m_velocityChanged = true;
            emit velocityChanged(m_velocity);
        }
    }

    emit workerFinished();
}

/**
 * @brief AirflowManager::calculateCompensationADC
 * Not like worker function, this just calculte adc compensation
 */
void AirflowManager::calculateCompensationADC()
{
    int adc = pAI->getADC(m_channel);

    //dummyADC
    //    adc = adcDummy += 10;
    //    qDebug() << "AirflowManager::workerCompensationADC() " << adc;

    bool recalculateAdcConpensation = false;

    //ADC
    int adcC = 0;
    if(m_adc != adc){
        m_adc = adc;
        recalculateAdcConpensation = true;
        emit adcChanged(m_adc);
    }

    //TEMPERATURE
    if(m_temperatureChanged){
        recalculateAdcConpensation = true;
        m_temperatureChanged = false;
    }

    //ADC CONPENSATION
    if(recalculateAdcConpensation){

        //ADC TEMPERATURE CONVESATION
        if((m_constant == 0) || (m_temperature > 50.0)){
            adcC = adc;
        }
        else{
            double result;
            result =  m_temperature - 25.0;
            result += (double)m_constant;
            result *= (double)(adc);
            result /= (double)(m_constant);
            adcC = qRound(result);
        }

        if(m_adcConpensation != adcC){
            m_adcConpensation   = adcC;
            emit adcConpensationChanged(m_adcConpensation);
        }
    }
}

void AirflowManager::setAdcPoint(int point, int value)
{
    m_adcPoint[point] = value;
}

void AirflowManager::setVelocityPoint(int point, double value)
{
    m_velocityPoint[point] = value;
}

void AirflowManager::setConstant(int value)
{
    m_constant = value;
}

/**
 * @brief AirflowManager::initScope
 * Pre calculate velocity scope
 */
void AirflowManager::initScope()
{
    m_m1 = (double)(m_adcPoint[1] - m_adcPoint[0]) / (m_velocityPoint[1] - m_velocityPoint[0]);
    m_b1 = (double)(m_adcPoint[0]) - m_m1 * m_velocityPoint[0];

    //    qDebug() << "m1: "<< m_m1;
    //    qDebug() << "b1: "<< m_b1;

    m_m2 = ((double)(m_adcPoint[2] - m_adcPoint[1])) / (m_velocityPoint[2] - m_velocityPoint[1]);
    m_b2 = (double)(m_adcPoint[1]) - m_m2 * m_velocityPoint[1];

    //    qDebug() << "m2: "<< m_m2 << " == " << "ADC2: "<< m_adcPoint[2] <<" ADC1: " << m_adcPoint[1]<<" VEL2: " << m_velocityPoint[2] << " VEL1: " << m_velocityPoint[1];
    //    qDebug() << "b2: "<< m_b2;
}

void AirflowManager::setTemperature(double newVal)
{
    if(abs(m_temperature - newVal)  < 0.1) return;
    m_temperature = newVal;
    if(!m_temperatureChanged) m_temperatureChanged = true;
}

void AirflowManager::setAIN(AIManage *value)
{
    pAI = value;
}

void AirflowManager::setChannel(int channel)
{
    m_channel = channel;
}

bool AirflowManager::getVelocityChanged() const
{
    return m_velocityChanged;
}

void AirflowManager::setVelocityChanged(bool velocityChanged)
{
    m_velocityChanged = velocityChanged;
}

bool AirflowManager::getAdcChanged() const
{
    return m_adcChanged;
}

void AirflowManager::setAdcChanged(bool newVal)
{
    m_adcChanged = newVal;
}

double AirflowManager::getB1() const
{
    return m_b1;
}

double AirflowManager::getB2() const
{
    return m_b2;
}

double AirflowManager::getVelocityPoint(int point) const
{
    return m_velocityPoint[point];
}

double AirflowManager::getM2() const
{
    return m_m2;
}

double AirflowManager::getM1() const
{
    return m_m1;
}

double AirflowManager::velocity() const
{
    return m_velocity;
}

int AirflowManager::adcConpensation() const
{
    return m_adcConpensation;
}

int AirflowManager::adc() const
{
    return m_adc;
}
