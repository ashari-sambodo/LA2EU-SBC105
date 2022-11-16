//#include <QDebug>
#include <cmath>
#include "AirflowVelocity.h"

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
    m_maxAdcResBits     = 12; // Default ADC Resolution 12 bits
    //    m_scopeCount        = AIRFLOWNANAGER_MAX_ADC_POINT;
    m_meaUnit           = 0;

    adcDummy            = 0;
    m_adcChanged        = false;
    m_velocityChanged   = false;
}

/**
 * @brief AirflowManager::worker
 * @param parameter
 * Calculate ADC Compensation, then
 * Calculate AIrflow Velocity
 * parameter:
 *  1 for force recalculate adc conpensation
 *  2 for force recalculate velocity
 *  3 for force recalculate adc conpensation and velocity
 */
void AirflowVelocity::routineTask(int parameter)
{
    //    Q_UNUSED(parameter);

    bool recalculateAdcConpensation = false;
    bool recalculateVelocity = false;

    switch (parameter) {
    case 1:
        recalculateAdcConpensation = true;
        break;
    case 2:
        recalculateVelocity = true;
        break;
    }

    //// Map the original ADC value to specific bits
    int adc = /*pAI->getAdcMap(m_channel, m_maxAdcResBits);*/pAI->getADC(m_channel);
    int mvolt = pAI->getmVolt(m_channel);

#ifdef QT_DEBUG
    if(m_dummyStateEnable){
        adc = m_dummyState;
    }
#endif

    //dummyADC
    //    adc = adcDummy += 10;
    //    qDebug() << "AirflowManager::workerCompensationADC() " << adc;

    //ADC
    if(m_adc != adc){
        m_adc = adc;
        recalculateAdcConpensation = true;
        emit adcChanged(m_adc);

        //        qDebug() << __func__ << "m_adc" << m_adc;
    }

    if(m_mVolt != mvolt){
        m_mVolt = mvolt;
        emit mVoltChanged(mvolt);
    }

    //TEMPERATURE EFFECTED TO AIRFLOW SENSOR
    if(m_temperatureChanged){
        recalculateAdcConpensation = true;
        m_temperatureChanged = false;
    }

    //ADC CONPENSATION
    if(recalculateAdcConpensation || m_sensorConstantChanged){
        //ADC TEMPERATURE CONVESATION
        int adcC = m_adc;
        double adcCompTemp = 0.0;

        if((m_constant != 0) && (m_temperature <= 50.0)){
            adcCompTemp = (m_temperature - 25.0) + static_cast<double>(m_constant);
            adcCompTemp *= static_cast<double>(m_adc);
            adcCompTemp /= static_cast<double>(m_constant);

            adcC = static_cast<int>(adcCompTemp);
            //adcC = qRound((double)m_adc + (double)m_adc * (m_temperature - 25.0) / (double)m_constant);
            //There is no ADC negative value
            if(adcC < 0) adcC = m_adc;
        }//

        if(m_adcConpensation != adcC){
            m_adcConpensation   = adcC;
            recalculateVelocity = true;
            emit adcConpensationChanged(m_adcConpensation);

            //            qDebug() << "m_adc" << m_adc;
            //            qDebug() << "m_temperature" << m_temperature;
            //            qDebug() << "m_constant" << m_constant;
        }

        // CLEAR FLAG
        //        if(m_sensorConstantChanged) qDebug() << "m_sensorConstantChanged::recalculateAdcConpensation";
        if(m_sensorConstantChanged) m_sensorConstantChanged = false;
    }

    //VELOCITY
    if(recalculateVelocity || m_scopeChanged){
        if(m_scopeChanged) m_scopeChanged = false;

        double velocity = 0;

        if(m_adcConpensation <= m_adcPoint[Pt_Zero]){
            velocity = 0;

        }else if(m_adcConpensation <= m_adcPoint[Pt_Minimum]){
            velocity = /*qRound(*/(static_cast<double>(m_adcConpensation) - m_b1) / m_m1/*)*/;

        }else{
            velocity = /*qRound(*/(static_cast<double>(m_adcConpensation) - m_b2) / m_m2/*)*/;
        }
        //        else{
        //            if(m_scopeCount == AIRFLOWNANAGER_MAX_ADC_POINT){
        //                velocity = /*qRound(*/(static_cast<double>(m_adcConpensation) - m_b3) / m_m3/*)*/;
        //                qDebug() << metaObject()->className() << __func__ << "m_adcPoint[3]" << m_adcPoint[3] << m_adcConpensation << m_b3 << m_m3 << "velocity" << velocity;
        //            }else {
        //                velocity = /*qRound(*/(static_cast<double>(m_adcConpensation) - m_b2) / m_m2/*)*/;
        //                qDebug() << metaObject()->className() << __func__ << "m_adcPoint[2]" << m_adcPoint[2] << m_adcConpensation << m_b2 << m_m2 << "velocity" << velocity;
        //            }//
        //        }//

        double velHigh      = m_velocityPoint[Pt_Maximum];
        double velNominal   = m_velocityPoint[Pt_Nominal];
        double velLow       = m_velocityPoint[Pt_Minimum];
        double velActual    = velocity;
        double valueVel     = 0;
        double velocityForClosedLoop = 0;

        if(m_meaUnit) {
            if(velHigh > 0)     velHigh /= 100.0;
            if(velNominal > 0)  velNominal /= 100.0;
            if(velLow > 0)      velLow /= 100.0;
            if(velActual > 0)   velActual /= 100.0;
        }//

        /// generate an offset in order to decide what rounding method need to implement
        /// use 40% of the deviation between Nominal and one of the alarm velocity
        int offsetBeforeAlarm = qRound(0.4 * (velNominal - velLow));
        /// Remove decimal point if actual velocity is greater than Nominal
        /// Round it if less than Nominal
        if(velActual > velNominal){
            if((velActual >= (velHigh - offsetBeforeAlarm)) && (velHigh > velNominal))
                valueVel = qRound(velActual);
            else{
                valueVel = static_cast<int>(velActual);
            }
        }//
        else{
            if(velActual <= (velLow + offsetBeforeAlarm))
                valueVel = static_cast<int>(velActual);
            else
                valueVel = qRound(velActual);
        }//
        /// make a different emit signal value for Closed loop Control
        velocityForClosedLoop = qRound(velActual);

        if(m_meaUnit) {
            if(velHigh > 0)     velHigh *= 100.0;
            if(velNominal > 0)  velNominal *= 100.0;
            if(velLow > 0)      velLow *= 100.0;
            if(velActual > 0)   velActual *= 100.0;
            if(valueVel > 0)    valueVel *= 100.0;
            if(velocityForClosedLoop > 0)velocityForClosedLoop *= 100.0;
        }//

        qDebug() << velLow << velHigh << offsetBeforeAlarm;
        qDebug() << velNominal << velActual << "final:" << valueVel;
        qDebug() << "velocityForClosedLoop:" << velocityForClosedLoop;

        //nomalization, airflow value dont have negative
        if(valueVel < 0) valueVel = 0;
        if(velocityForClosedLoop < 0) velocityForClosedLoop = 0;

        if(fabs(valueVel - m_velocity) >= 1){
            m_velocity = valueVel;

            if(!m_velocityChanged) m_velocityChanged = true;
            emit velocityChanged(m_velocity);
        }//
        if(fabs(velocityForClosedLoop - m_velocityForClosedLoop) >= 1){
            m_velocityForClosedLoop = velocityForClosedLoop;
            emit velocityForClosedLoopChanged(m_velocityForClosedLoop);
        }
    }//

    emit workerFinished();
}//

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
    if(m_constant == value) return;
    m_constant = value;
    m_sensorConstantChanged = true;
}

/**
 * @brief AirflowManager::initScope
 * Pre calculate velocity scope
 */
void AirflowVelocity::initScope()
{
    qDebug() << metaObject()->className() << __func__ << m_adcPoint[Pt_Nominal] << m_adcPoint[Pt_Minimum] << m_adcPoint[Pt_Zero];
    qDebug() << metaObject()->className() << __func__ << m_velocityPoint[Pt_Nominal] << m_velocityPoint[Pt_Minimum];

    double m1 = (static_cast<double>(m_adcPoint[1] - m_adcPoint[0])) / (m_velocityPoint[1] - m_velocityPoint[0]);
    double b1 = (static_cast<double>(m_adcPoint[0])) - (m1 * m_velocityPoint[0]);

    double m2, b2;

    //    if(m_scopeCount != 2){
    m2 = (static_cast<double>(m_adcPoint[2] - m_adcPoint[1])) / (m_velocityPoint[2] - m_velocityPoint[1]);
    b2 = (static_cast<double>(m_adcPoint[1])) - (m2 * m_velocityPoint[1]);
    //    }else{
    //        m2 = (static_cast<double>(m_adcPoint[2] - m_adcPoint[0])) / (m_velocityPoint[2] - m_velocityPoint[0]);
    //        b2 = (static_cast<double>(m_adcPoint[0])) - (m2 * m_velocityPoint[0]);
    //    }

    //    double m3=0.0, b3=0.0;
    //    if(m_scopeCount == AIRFLOWNANAGER_MAX_ADC_POINT){
    //        m3 = (static_cast<double>(m_adcPoint[3] - m_adcPoint[2])) / (m_velocityPoint[3] - m_velocityPoint[2]);
    //        b3 = (static_cast<double>(m_adcPoint[2])) - (m3 * m_velocityPoint[2]);
    //    }

    if((m_m1 != m1) || (m_b1 != b1) || (m_m2 != m2) || (m_b2 != b2)/* || (((m_m3 != m3) || (m_b3 != b3)) && (m_scopeCount == AIRFLOWNANAGER_MAX_ADC_POINT))*/){
        m_m1 = m1;
        m_b1 = b1;
        m_m2 = m2;
        m_b2 = b2;
        //        if(m_scopeCount == AIRFLOWNANAGER_MAX_ADC_POINT){
        //            m_m3 = m3;
        //            m_b3 = b3;
        //        }

        m_scopeChanged = true;

        qDebug() << metaObject()->className() << __func__ << "Scope changed!";
        qDebug() << metaObject()->className() << __func__ << m1 << b1;
        qDebug() << metaObject()->className() << __func__ << m2 << b2;
        //        if(m_scopeCount == AIRFLOWNANAGER_MAX_ADC_POINT)
        //            qDebug() << metaObject()->className() << __func__ << m3 << b3;
    }

    //    qDebug() << "ADC2: "<< m_adcPoint[2] <<" ADC1: " << m_adcPoint[1];
    //    qDebug() << "VEL2: " << m_velocityPoint[2] << " VEL1: " << m_velocityPoint[1];
}

//void AirflowVelocity::setScopeCount(unsigned char scopeCount)
//{
//    m_scopeCount = scopeCount;
//}

void AirflowVelocity::setMeasurementUnit(uchar value)
{
    m_meaUnit = value;
}

void AirflowVelocity::emitVelocityChanged()
{
    emit velocityChanged(m_velocity);
}

void AirflowVelocity::setTemperature(double newVal)
{
    qDebug() << metaObject()->className() << __func__ << newVal;

    if(abs(m_temperature - newVal) < 0.01) return;
    m_temperature = newVal;
    if(!m_temperatureChanged) m_temperatureChanged = true;
}

void AirflowVelocity::setAdcResolutionBits(unsigned char bits)
{
    m_maxAdcResBits = bits;
}

bool AirflowVelocity::getDummyStateEnable() const
{
    return m_dummyStateEnable;
}

void AirflowVelocity::setDummyStateEnable(bool dummyStateEnable)
{
    m_dummyStateEnable = dummyStateEnable;
}

int AirflowVelocity::getDummyState() const
{
    return m_dummyState;
}

void AirflowVelocity::setDummyState(int dummyState)
{
    m_dummyState = dummyState;
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
