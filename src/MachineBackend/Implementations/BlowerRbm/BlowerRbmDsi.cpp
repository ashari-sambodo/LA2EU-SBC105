#include "BlowerRbmDsi.h"

#define RPM_MAX_SAMPLES     50/*10*/

BlowerRbmDsi::BlowerRbmDsi(QObject *parent) : ClassManager(parent)
{
    pModule = nullptr;

    m_interlocked = 0;

    m_speedDemand   = 0;
    m_dutyCycle         = 0;

    m_directionDemand   = 0;

    m_speedRPM          = 0;
    m_rpmSamplesSum     = 0;
}

void BlowerRbmDsi::routineTask(int parameter)
{
    Q_UNUSED(parameter);
    //    qDebug() << metaObject()->className() << __FUNCTION__ << QObject::thread();

    updateActualDemand();
    readActualSpeedRPM();
}

void BlowerRbmDsi::setSubModule(BlowerRegalECM *module)
{
    pModule = module;
}

void BlowerRbmDsi::setInterlock(int newVal)
{
    if(m_interlocked == newVal) return;
    m_interlocked = newVal;
    emit interlockChanged(m_interlocked);

    if((m_speedDemand > 0) && m_interlocked) m_speedDemand = 0;
}

void BlowerRbmDsi::updateActualDemand()
{
#ifdef QT_DEBUG
    if(m_dummyStateEnable){
        int demandInPercent = m_dummyState;
        //        switch (m_demandMode) {
        //        case TORQUE_DEMMAND_BRDM:
        //            /// convert from byte torque to percent representative
        //            demandInPercent = pModule->torqueValToPercent(m_dummyState);
        //            break;
        //        case AIRVOLUME_DEMMAND_BRDM:
        //            /// convert from byte torque to percent representative
        //            demandInPercent = pModule->airVolumeCfmToPercent(m_dummyState, m_airVolumeScale);
        //            break;
        //        default:
        //            break;
        //        }

        if(m_dutyCycle != demandInPercent){
            m_dutyCycle = demandInPercent;

            emit dutyCycleChanged(m_dutyCycle);
        }

        if((m_speedDemand > 0) && m_interlocked) m_speedDemand = 0;
        if(m_interlocked && m_dutyCycle) m_dutyCycle = 0;
        else {
            m_speedDemand = m_dutyCycle;
        }
        m_dummyState = m_speedDemand;
        return;
    }
#endif

    int response = -1;

    int actualDemand = 0;
    response = pModule->getDemand(&actualDemand);

    //                qDebug() << "actualDemand: " << actualDemand;

    if(response == 0) {

        /// CLEAR ERROR COUNT IF NOT YET REACH THE MAXIMUM ERROR
        if(pModule->errorComToleranceCount()){
            //            pModule->setErrorComToleranceCount(0);
            pModule->clearErrorComToleranceCount();
        }

        int demandInPercent = 0;
        switch (m_demandMode) {
        case TORQUE_DEMMAND_BRDM:
            /// convert from byte torque to percent representative
            demandInPercent = pModule->torqueValToPercent(actualDemand);
            break;
        case AIRVOLUME_DEMMAND_BRDM:
            /// convert from byte torque to percent representative
            demandInPercent = pModule->airVolumeCfmToPercent(actualDemand, m_airVolumeScale);
            break;
        default:
            break;
        }

        //                    qDebug() << "actualDemand(%): " << actualDemand;

        /// UPDATE ACTUAL VALUE
        if(m_dutyCycle != demandInPercent){
            m_dutyCycle = demandInPercent;

            emit dutyCycleChanged(m_dutyCycle);
        }

        /// Update to demand value
        int value = m_demandMode ? actualDemand : m_dutyCycle;
        if((m_speedDemand > 0) && m_interlocked) m_speedDemand = 0;
        if(m_speedDemand != value){

            switch (m_demandMode) {
            case TORQUE_DEMMAND_BRDM:
                /// convert from byte torque to percent representative
                response = pModule->setTorqueDemand(m_speedDemand);
                break;
            case AIRVOLUME_DEMMAND_BRDM:
                response = pModule->setAirflowDemand(m_speedDemand);
                break;
            default:
                break;
            }

            if(response == 0){
                if(m_speedDemand) response = pModule->start();
                else response = pModule->stop();
            }

            //                        qDebug() << "m_dutyCycleDemand: " << m_dutyCycleDemand << "m_dutyCycle: " << m_dutyCycle;
        }
    }
    else {
        ///ECM COMMUNICATION HAVE NO RESPONSE CORRECTLY
        ///INCREASE_COMM_ERROR_COUNT
        //        int errorCount = pModule->errorComToleranceCount();
        //        errorCount = errorCount + 1;
        //        pModule->setErrorComToleranceCount(errorCount);

        //                        #ifndef NO_PRINT_DEBUG
        //        printf("BlowerDSIManager::updateActualState error response %d\n", errorCount);
        //        fflush(stdout);
        //                        #endif

        pModule->increaseErrorComToleranceCount();
    }
    //#endif
}

void BlowerRbmDsi::readActualSpeedRPM()
{
#ifdef QT_DEBUG
    if(m_dummyStateEnable){
        int actualRPM = m_dummyRpm;

        if(m_speedRPM != actualRPM){
            m_speedRPM = actualRPM;
            emit rpmChanged(m_speedRPM);
        }
        return;
    }
#endif

    int response = -1;

    //READ_ACTUAL_RPM
    int actualRPM = 0;
    response = pModule->getSpeed(&actualRPM);

    //                qDebug() << "actualRPM: " << m_speedRPM;

    ///demo
    //    int actualRPM = m_speedRPM;
    //    actualRPM = actualRPM + 3;
    //    if(actualRPM >= 50) actualRPM = 0;

    if(response == 0){

        ///CLEAR ERROR COUNT IF NOT YET REACH THE MAXIMUM ERROR
        if(pModule->errorComToleranceCount()){
            //            pModule->setErrorComToleranceCount(0);
            pModule->clearErrorComToleranceCount();
        }

        //SMOOTHING
        if(m_rpmSamples.length() >= RPM_MAX_SAMPLES){
            m_rpmSamplesSum  = m_rpmSamplesSum - m_rpmSamples.front();
            m_rpmSamples.pop_front();
            m_rpmSamples.push_back(actualRPM);
        }else{
            m_rpmSamples.push_back(actualRPM);
        }
        m_rpmSamplesSum = m_rpmSamplesSum + actualRPM;
        actualRPM       = m_rpmSamplesSum / m_rpmSamples.length();

        if(m_speedRPM != actualRPM){
            m_speedRPM = actualRPM;
            emit rpmChanged(m_speedRPM);

            //                        printf("readActualSpeedRPM m_speedRPM = %d\n", m_speedRPM);
            //                        fflush(stdout);
        }
    }
    else {
        //ECM COMMUNICATION HAVE NO RESPONSE CORRECTLY
        //INCREASE_COMM_ERROR_COUNT
        //        int errorCount = pModule->errorComToleranceCount();
        //        errorCount = errorCount + 1;
        //        pModule->setErrorComToleranceCount(errorCount);

        //                #ifndef NO_PRINT_DEBUG
        //        printf("BlowerDSIManager::readSpeedRPM error response %d\n", errorCount);
        //        fflush(stdout);
        //                #endif
        pModule->increaseErrorComToleranceCount();
    }
}

int BlowerRbmDsi::dummyRpm() const
{
    return m_dummyRpm;
}

void BlowerRbmDsi::setDummyRpm(int dummyRpm)
{
    m_dummyRpm = dummyRpm;
}

int BlowerRbmDsi::dutyCycle() const
{
    return m_dutyCycle;
}

short BlowerRbmDsi::dummyState() const
{
    return m_dummyState;
}

void BlowerRbmDsi::setDummyState(short dummyState)
{
    m_dummyState = dummyState;
}

bool BlowerRbmDsi::dummyStateEnable() const
{
    return m_dummyStateEnable;
}

void BlowerRbmDsi::setDummyStateEnable(bool dummyStateEnable)
{
    m_dummyStateEnable = dummyStateEnable;
}

short BlowerRbmDsi::demandMode() const
{
    return m_demandMode;
}

void BlowerRbmDsi::setDemandMode(short demandMode)
{
    m_demandMode = demandMode;
    pModule->setDemandMode(static_cast<unsigned char>(m_demandMode));
}

int BlowerRbmDsi::airVolumeScale() const
{
    return m_airVolumeScale;
}

void BlowerRbmDsi::setAirVolumeScale(int airVolumeScale)
{
    m_airVolumeScale = airVolumeScale;
}

void BlowerRbmDsi::setDirection(int direction)
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << direction << QObject::thread();
    
    m_directionDemand = direction;
}

void BlowerRbmDsi::setDutyCycle(int newVal)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << newVal << QObject::thread();

    if(m_interlocked) {
        qDebug() << "Interlocked";
        if(m_speedDemand != 0) m_speedDemand = 0;
        return;
    }

    switch (m_demandMode) {
    case TORQUE_DEMMAND_BRDM:
        /// convert scalling air volume
        newVal = /*pModule->torquePercentToVal*/(newVal);
        break;
    case AIRVOLUME_DEMMAND_BRDM:
        /// convert scalling air volume
        newVal = pModule->airVolumePercentToCfm(newVal, m_airVolumeScale);
        break;
    default:
        break;
    }

    m_speedDemand = newVal;
#ifdef QT_DEBUG
    m_dummyState = m_speedDemand;
#endif
    qDebug() << __func__ << "m_speedDemand" << m_speedDemand;
}
