#include "BlowerRbmDsi.h"

#define RPM_MAX_SAMPLES     50/*10*/

BlowerRbmDsi::BlowerRbmDsi(QObject *parent) : ClassManager(parent)
{
    pModule = nullptr;

    m_interlocked = 0;

    m_dutyCycleDemand   = 0;
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

    if((m_dutyCycleDemand > 0) && m_interlocked) m_dutyCycleDemand = 0;
}

void BlowerRbmDsi::updateActualDemand()
{
    int response = -1;

    int actualDemand = 0;
    response = pModule->getDemand(&actualDemand);

    //                qDebug() << "actualDemand: " << actualDemand;

    if(response == 0) {

        /// CLEAR ERROR COUNT IF NOT YET REACH THE MAXIMUM ERROR
        if(pModule->errorComToleranceCount()){
            pModule->setErrorComToleranceCount(0);
        }

        /// convert from byte torque to percent representative
        actualDemand = pModule->torqueValToPercent(actualDemand);

        //                    qDebug() << "actualDemand(%): " << actualDemand;

        /// UPDATE ACTUAL VALUE
        if(m_dutyCycle != actualDemand){
            m_dutyCycle = actualDemand;

            emit dutyCycleChanged(m_dutyCycle);
        }

        /// Update to demand value
        if(m_dutyCycleDemand != m_dutyCycle){
            response = pModule->setTorqueDemand(m_dutyCycleDemand);
            if(response == 0){
                if(m_dutyCycleDemand) response = pModule->start();
                else response = pModule->stop();
            }

            //                        qDebug() << "m_dutyCycleDemand: " << m_dutyCycleDemand << "m_dutyCycle: " << m_dutyCycle;
        }
    }
    else {
        //ECM COMMUNICATION HAVE NO RESPONSE CORRECTLY
        //INCREASE_COMM_ERROR_COUNT
        int errorCount = pModule->errorComToleranceCount();
        errorCount = errorCount + 1;
        pModule->setErrorComToleranceCount(errorCount);

        //                        #ifndef NO_PRINT_DEBUG
        //        printf("BlowerDSIManager::updateActualState error response %d\n", errorCount);
        //        fflush(stdout);
        //                        #endif
    }
}

void BlowerRbmDsi::readActualSpeedRPM()
{
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
            pModule->setErrorComToleranceCount(0);
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
            emit speedRPMChanged(m_speedRPM);

            //                        printf("readActualSpeedRPM m_speedRPM = %d\n", m_speedRPM);
            //                        fflush(stdout);
        }
    }
    else {
        //ECM COMMUNICATION HAVE NO RESPONSE CORRECTLY
        //INCREASE_COMM_ERROR_COUNT
        int errorCount = pModule->errorComToleranceCount();
        errorCount = errorCount + 1;
        pModule->setErrorComToleranceCount(errorCount);

        //                #ifndef NO_PRINT_DEBUG
        //        printf("BlowerDSIManager::readSpeedRPM error response %d\n", errorCount);
        //        fflush(stdout);
        //                #endif
    }
}

void BlowerRbmDsi::setDirection(int direction)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << direction << QObject::thread();

    m_directionDemand = direction;
}

void BlowerRbmDsi::setDutyCycle(int newVal)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << newVal << QObject::thread();

    if(m_interlocked) {
        m_dutyCycleDemand = 0;
        return;
    }
    m_dutyCycleDemand = newVal;
}
