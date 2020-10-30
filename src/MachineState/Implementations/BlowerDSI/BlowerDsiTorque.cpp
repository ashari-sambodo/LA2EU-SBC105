#include <QSerialPortInfo>
#include "BlowerDsiTorque.h"

#define USB_SERIAL_VID      4292
#define USB_SERIAL_PID      60000

#define RPM_MAX_SAMPLES     50/*10*/

BlowerDsiTorque::BlowerDsiTorque(QObject *parent) : ClassManager(parent)
{
    m_interlocked = 0;

    m_dutyCycleDemand   = 0;
    m_dutyCycle         = 0;

    m_directionDemand   = 0;

    m_speedRPM          = 0;
    m_rpmSamplesSum     = 0;
}

int BlowerDsiTorque::setup()
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << QObject::thread();

    //INITIALIZE SEIAL PORT
    m_pSerialPort.reset(new QSerialPort(this));
    foreach(const QSerialPortInfo &info, QSerialPortInfo::availablePorts()){
        if((info.vendorIdentifier() == USB_SERIAL_VID) && (info.productIdentifier() == USB_SERIAL_PID)){
            m_pSerialPort->setPort(info);
            if(m_pSerialPort->open(QIODevice::ReadWrite)){
                m_pSerialPort->setBaudRate(QSerialPort::BaudRate::Baud4800);
                m_pSerialPort->setDataBits(QSerialPort::DataBits::Data8);
                m_pSerialPort->setParity(QSerialPort::Parity::NoParity);
                m_pSerialPort->setStopBits(QSerialPort::StopBits::OneStop);
            }
            break;
        }
    }

    //INITIALIZE_SUB_ECM_INSTANCE
    m_pModuleECM.reset(new BlowerRegalECM(this));

    ////ERROR COUNT MAX 5 TIMES
    m_pModuleECM->setErrorComCountMax(5);

    //SET SERIAL BUS
    m_pModuleECM->setSerialComm(m_pSerialPort.data());

    //INIT BLOWER CALIBRATION PARAMETER
    int response = m_pModuleECM->stop();
    if(response == 0) response = m_pModuleECM->setDirection(m_directionDemand);

    /// Monitor error count changes
    /// forward signal to signal
    QObject::connect(m_pModuleECM.data(), &BlowerRegalECM::errorComCountChanged,
                     this, &BlowerDsiTorque::errorComCountChanged);
    return 0;
}

void BlowerDsiTorque::worker()
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << QObject::thread();

    if(!m_pSerialPort->isOpen()) {
        if(!m_pModuleECM.isNull()){
            //INCREASE_COMM_ERROR_COUNT
            int errorCount = m_pModuleECM->errorComCount();
            errorCount = errorCount + 1;
            m_pModuleECM->setErrorComCount(errorCount);

            //#ifndef NO_PRINT_DEBUG
            //        printf("BlowerDSIManager::worker errorCount %d\n", errorCount);
            //        fflush(stdout);
            //#endif
            return;
        }
    }

    updateActualDemand();
    readActualSpeedRPM();
}

void BlowerDsiTorque::setInterlock(int newVal)
{
    if(m_interlocked == newVal) return;
    m_interlocked = newVal;
    emit interlockChanged(m_interlocked);

    if((m_dutyCycleDemand > 0) && m_interlocked) m_dutyCycleDemand = 0;
}

void BlowerDsiTorque::updateActualDemand()
{
    int response = -1;
    if(!m_pSerialPort.isNull()){
        if(m_pSerialPort->isOpen()){
            if(!m_pModuleECM.isNull()){

                int actualDemand = 0;
                response = m_pModuleECM->getDemand(&actualDemand);

                //                qDebug() << "actualDemand: " << actualDemand;

                if(response == 0) {

                    /// CLEAR ERROR COUNT IF NOT YET REACH THE MAXIMUM ERROR
                    if(m_pModuleECM->errorComCount()){
                        m_pModuleECM->setErrorComCount(0);
                    }

                    /// convert from byte torque to percent representative
                    actualDemand = m_pModuleECM->torqueValToPercent(actualDemand);

                    //                    qDebug() << "actualDemand(%): " << actualDemand;

                    /// UPDATE ACTUAL VALUE
                    if(m_dutyCycle != actualDemand){
                        m_dutyCycle = actualDemand;

                        emit dutyCycleChanged(m_dutyCycle);
                    }

                    /// Update to demand value
                    if(m_dutyCycleDemand != m_dutyCycle){
                        response = m_pModuleECM->setTorqueDemand(m_dutyCycleDemand);
                        if(response == 0){
                            if(m_dutyCycleDemand) response = m_pModuleECM->start();
                            else response = m_pModuleECM->stop();
                        }

                        //                        qDebug() << "m_dutyCycleDemand: " << m_dutyCycleDemand << "m_dutyCycle: " << m_dutyCycle;
                    }
                }
            }
        }
    }

    if(response != 0){
        //ECM COMMUNICATION HAVE NO RESPONSE CORRECTLY
        //INCREASE_COMM_ERROR_COUNT
        int errorCount = m_pModuleECM->errorComCount();
        errorCount = errorCount + 1;
        m_pModuleECM->setErrorComCount(errorCount);

        //                        #ifndef NO_PRINT_DEBUG
        //        printf("BlowerDSIManager::updateActualState error response %d\n", errorCount);
        //        fflush(stdout);
        //                        #endif
    }
}

void BlowerDsiTorque::readActualSpeedRPM()
{
    int response = -1;
    if(!m_pSerialPort.isNull()){
        if(m_pSerialPort->isOpen()){
            if(!m_pModuleECM.isNull()){

                //READ_ACTUAL_RPM
                int actualRPM = 0;
                response = m_pModuleECM->getSpeed(&actualRPM);

                //                qDebug() << "actualRPM: " << m_speedRPM;

                ///demo
                //    int actualRPM = m_speedRPM;
                //    actualRPM = actualRPM + 3;
                //    if(actualRPM >= 50) actualRPM = 0;

                if(response == 0){

                    ///CLEAR ERROR COUNT IF NOT YET REACH THE MAXIMUM ERROR
                    if(m_pModuleECM->errorComCount()){
                        m_pModuleECM->setErrorComCount(0);
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
            }
        }
    }

    if(response != 0){
        //ECM COMMUNICATION HAVE NO RESPONSE CORRECTLY
        //INCREASE_COMM_ERROR_COUNT
        int errorCount = m_pModuleECM->errorComCount();
        errorCount = errorCount + 1;
        m_pModuleECM->setErrorComCount(errorCount);

        //                #ifndef NO_PRINT_DEBUG
        //        printf("BlowerDSIManager::readSpeedRPM error response %d\n", errorCount);
        //        fflush(stdout);
        //                #endif
    }
}

void BlowerDsiTorque::setDirection(int direction)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << direction << QObject::thread();

    m_directionDemand = direction;
}

void BlowerDsiTorque::setDutyCycle(int newVal)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << newVal << QObject::thread();

    if(m_interlocked) {
        m_dutyCycleDemand = 0;
        return;
    }
    m_dutyCycleDemand = newVal;
}
