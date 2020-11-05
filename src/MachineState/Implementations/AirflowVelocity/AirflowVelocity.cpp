#include "AirflowVelocity.h"
#include <cmath>

/// 11-5-2020
/// option to select between 2 point calibration or 3 point calibration

AirflowVelocity::AirflowVelocity(QObject *parent)
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
void AirflowVelocity::routineTask(int parameter)
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

        switch (m_calibPointMode) {
        case AFCALIB_POINT_3POINTS:
            if(m_adcConpensation <= m_adcPoint[0]){
                velocity = 0;
            }else if(m_adcConpensation <= m_adcPoint[1]){
                velocity = (double)qRound((((double)m_adcConpensation - m_b1) / m_m1) * 1000.0) / 1000.0;
            }else{
                velocity = (double)qRound((((double)m_adcConpensation - m_b2) / m_m2) * 1000.0) / 1000.0;
            }
            break;
        case AFCALIB_POINT_2POINTS:
            if(m_adcConpensation <= m_adcPoint[0]){
                velocity = 0;
            }else {
                velocity = (double)qRound((((double)m_adcConpensation - m_b1) / m_m1) * 1000.0) / 1000.0;
            }
            break;
        default:
            break;
        }

        //nomalization, airflow value dont have negative
        if(velocity < 0) m_velocity = 0;

        //    printf("Velocity %.2f\n", m_velocity);
        //    fflush(stdout);

        if(fabs(velocity - m_velocity) >= 0.001){
            m_velocity = velocity;

            if(!m_velocityChanged) m_velocityChanged = true;
            emit velocityChanged(m_velocity);
        }
    }

    emit workerFinished();

    //    Q_UNUSED(parameter);

    //    int adc = pAI->getADC(m_channel);

    //    //dummyADC
    //    //    adc = adcDummy += 10;
    //    //    qDebug() << "AirflowManager::workerCompensationADC() " << adc;

    //    bool recalculateAdcConpensation = false;
    //    bool recalculateVelocity        = false;

    //    //ADC
    //    int adcC = 0;
    //    if(m_adc != adc){
    //        m_adc = adc;
    //        recalculateAdcConpensation = true;
    //        emit adcChanged(m_adc);
    //    }

    //    //TEMPERATURE
    //    if(m_temperatureChanged){
    //        recalculateAdcConpensation = true;
    //        m_temperatureChanged = false;
    //    }

    //    //ADC CONPENSATION
    //    if(recalculateAdcConpensation){

    //        //ADC TEMPERATURE CONVESATION
    //        if((m_constant == 0) || (m_temperature > 50.0)){
    //            adcC = adc;
    //        }
    //        else{
    //            adcC = qRound((double)adc + (double)adc * (m_temperature - 25.0) / (double)m_constant);
    //            //            double result;
    //            //            result =  m_temperature - 25.0;
    //            //            result += (double)m_constant;
    //            //            result *= (double)(adc);
    //            //            result /= (double)(m_constant);
    //            //            adcC = qRound(result);
    //        }

    //        if(m_adcConpensation != adcC){
    //            m_adcConpensation   = adcC;
    //            recalculateVelocity = true;
    //            emit adcConpensationChanged(m_adcConpensation);
    //        }
    //    }

    //    //VELOCITY
    //    if(recalculateVelocity){
    //        double velocity = 0;
    //        if(m_adcConpensation <= m_adcPoint[0]){
    //            velocity = 0;
    //        }else if(m_adcConpensation <= m_adcPoint[1]){
    //            velocity = (double)qRound((((double)m_adcConpensation - m_b1) / m_m1) * 1000.0) / 1000.0;
    //        }else{
    //            velocity = (double)qRound((((double)m_adcConpensation - m_b2) / m_m2) * 1000.0) / 1000.0;
    //        }

    //        //nomalization, airflow value dont have negative
    //        if(m_velocity < 0) m_velocity = 0;

    //        //    printf("Velocity %.2f\n", m_velocity);
    //        //    fflush(stdout);

    //        if(fabs(velocity - m_velocity) >= 0.001){
    //            m_velocity = velocity;

    //            if(!m_velocityChanged) m_velocityChanged = true;
    //            emit velocityChanged(m_velocity);
    //        }
    //    }

    //    emit workerFinished();
}

///**
// * @brief AirflowManager::calculateCompensationADC
// * Not like worker function, this just calculte adc compensation
// */
//void AirflowVelocity::calculateCompensationADC()
//{
//    int adc = pAI->getADC(m_channel);

//    //dummyADC
//    //    adc = adcDummy += 10;
//    //    qDebug() << "AirflowManager::workerCompensationADC() " << adc;

//    bool recalculateAdcConpensation = false;

//    //ADC
//    int adcC = 0;
//    if(m_adc != adc){
//        m_adc = adc;
//        recalculateAdcConpensation = true;
//        emit adcChanged(m_adc);
//    }

//    //TEMPERATURE
//    if(m_temperatureChanged){
//        recalculateAdcConpensation = true;
//        m_temperatureChanged = false;
//    }

//    //ADC CONPENSATION
//    if(recalculateAdcConpensation){

//        //ADC TEMPERATURE CONVESATION
//        if((m_constant == 0) || (m_temperature > 50.0)){
//            adcC = adc;
//        }
//        else{
//            double result;
//            result =  m_temperature - 25.0;
//            result += (double)m_constant;
//            result *= (double)(adc);
//            result /= (double)(m_constant);
//            adcC = qRound(result);
//        }

//        if(m_adcConpensation != adcC){
//            m_adcConpensation   = adcC;
//            emit adcConpensationChanged(m_adcConpensation);
//        }
//    }
//}

void AirflowVelocity::setAdcPoint(int point, int value)
{
    m_adcPoint[point] = value;
}

void AirflowVelocity::setVelocityPoint(int point, double value)
{
    m_velocityPoint[point] = value;
}

void AirflowVelocity::setConstant(int value)
{
    m_constant = value;
}

/**
 * @brief AirflowManager::initScope
 * Pre calculate velocity scope
 */
void AirflowVelocity::initScope()
{
    m_m1 = (double)(m_adcPoint[1] - m_adcPoint[0]) / (m_velocityPoint[1] - m_velocityPoint[0]);
    m_b1 = (double)(m_adcPoint[0]) - m_m1 * m_velocityPoint[0];

    m_m2 = ((double)(m_adcPoint[2] - m_adcPoint[1])) / (m_velocityPoint[2] - m_velocityPoint[1]);
    m_b2 = (double)(m_adcPoint[1]) - m_m2 * m_velocityPoint[1];

    //    qDebug() << "m1: "<< m_m1;
    //    qDebug() << "b1: "<< m_b1;

    //    qDebug() << "m2: "<< m_m2 << " == " << "ADC2: "<< m_adcPoint[2] <<" ADC1: " << m_adcPoint[1]<<" VEL2: " << m_velocityPoint[2] << " VEL1: " << m_velocityPoint[1];
    //    qDebug() << "b2: "<< m_b2;

}

void AirflowVelocity::setTemperature(int newVal)
{
    if(m_temperature == newVal) return;
    m_temperature = newVal;
    if(!m_temperatureChanged) m_temperatureChanged = true;
}

void AirflowVelocity::setAIN(AIManage *value)
{
    pAI = value;
}

void AirflowVelocity::setChannel(int channel)
{
    m_channel = channel;
}

bool AirflowVelocity::getVelocityChanged() const
{
    return m_velocityChanged;
}

void AirflowVelocity::setVelocityChanged(bool velocityChanged)
{
    m_velocityChanged = velocityChanged;
}

bool AirflowVelocity::getAdcChanged() const
{
    return m_adcChanged;
}

void AirflowVelocity::setAdcChanged(bool newVal)
{
    m_adcChanged = newVal;
}

double AirflowVelocity::getB1() const
{
    return m_b1;
}

double AirflowVelocity::getB2() const
{
    return m_b2;
}

double AirflowVelocity::getVelocityPoint(int point) const
{
    return m_velocityPoint[point];
}

double AirflowVelocity::getM2() const
{
    return m_m2;
}

double AirflowVelocity::getM1() const
{
    return m_m1;
}

double AirflowVelocity::velocity() const
{
    return m_velocity;
}

int AirflowVelocity::adcConpensation() const
{
    return m_adcConpensation;
}

int AirflowVelocity::adc() const
{
    return m_adc;
}
