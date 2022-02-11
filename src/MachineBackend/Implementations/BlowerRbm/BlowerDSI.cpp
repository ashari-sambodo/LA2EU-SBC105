#include "BlowerDSI.h"

#define USB_SERIAL_VID      4292
#define USB_SERIAL_PID      60000

#define RPM_MAX_SAMPLES     50/*10*/

BlowerDSIManager::BlowerDSIManager(QObject *parent)
    : ClassManager (parent)
{

    m_pSerialPort.reset();
    m_pModuleECM.reset();

    m_cutbackSpeed      = 0;
    m_interlock         = 0;
    m_speedDutyCycle    = 0;

    m_direction         = 0;
    m_cutbackSlope      = 0x4;
    m_airflowScalling   = 0;
    m_constantA1        = 0;
    m_constantA2        = 0;
    m_constantA3        = 0;
    m_constantA4        = 0;

    m_address           = 0;
    m_speedRPM          = 0;
    m_airflowDemand     = 0;
    //    QString m_firmwareVersion;
    //    int m_programVersion;
    //    int m_controlRev;
    //    int m_controlType;
    //    int m_serialNumber;
    //    int m_demand;
    //    int m_voltage;
    //    int m_statusOtmp, m_statusRamp,
    //    m_statusStart, m_statusRun,
    //    m_statusCutBk, m_statusStall,
    //    m_statusRas, m_statusBrake,
    //    m_statusRbc, m_statusBrownOut,
    //    m_statusOsc, m_statusReverseRotation;
    //    int m_powerLevel, m_mfrMode;
    //    int m_shaftPower;
    //    int m_controlTemperature;

    m_airflowDemand_Req = 0;
    //    int m_speed_Req;
    //    int m_torque_Req;
    //    int m_airflowScaling_Req;
    //    int m_direction_Req;
    //    int m_slewRate_Req;
    //    int m_blowerConstA1_Req;
    //    int m_blowerConstA2_Req;
    //    int m_blowerConstA3_Req;
    //    int m_blowerConstA4_Req;
    //    int m_cutbackSlope_Req;
    //    int m_cutbackSpeed_Req;
    //    int m_brakeOnOff_Req;
    //    int m_speedLoopConstKp_Req;
    //    int m_speedLoopConstKi_Req;
    //    int m_speedLoopConstKd_Req;

    //    int m_addressNew_Req;

    m_rpmSamplesSum     = 0;
}

void BlowerDSIManager::setup()
{
    //    printf("BlowerDSIManager::init cabinetModel = %d cabinetSize %d\n", cabinetModel, cabinetSize);
    //    fflush(stdout);

    //INITIALIZE_SUB_ECM_INSTANCE
    m_pModuleECM.reset(new BlowerRegalECM);

    ////ERROR COUNT MAX 5 TIMES
    m_pModuleECM->setErrorComCountMax(5);

    //INITIALIZE SEIAL PORT
    if(initSerialPort() == -1) return;

    //SET SERIAL BUS
    m_pModuleECM->setSerialComm(m_pSerialPort.data());

    //INIT BLOWER CALIBRATION PARAMETER
    int response = m_pModuleECM->stop();
    if(response == 0) response = m_pModuleECM->setDirection(m_direction);
    if(response == 0) response = m_pModuleECM->setCutbackSpeed(m_cutbackSpeed);
    if(response == 0) response = m_pModuleECM->setCutbackSlope(m_cutbackSlope);
    if(response == 0) response = m_pModuleECM->setAirflowScaling(m_airflowScalling);
    if(response == 0) response = m_pModuleECM->setBlowerContant(m_constantA1,
                                                                m_constantA2,
                                                                m_constantA3,
                                                                m_constantA4);
}

void BlowerDSIManager::worker(int /*parameter*/)
{
    if(m_pSerialPort.isNull() || !m_pSerialPort->isOpen() || m_pModuleECM.isNull()) {
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

    updateActualState();
    updateDemandState();
    readSpeedRPM();

    emit workerFinished();
}

void BlowerDSIManager::readSpeedRPM()
{
    //    printf("BlowerDSIManager::readSpeedRPM\n");
    //    fflush(stdout);
    int response = -1;
    if(!m_pSerialPort.isNull()){
        if(m_pSerialPort->isOpen()){
            if(!m_pModuleECM.isNull()){

                //READ_ACTUAL_RPM
                int actualRPM = m_speedRPM;
                response = m_pModuleECM->getSpeed(&actualRPM);

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
                    //

                    if(m_speedRPM != actualRPM){
                        m_speedRPM = actualRPM;
                        emit speedRPMChanged(m_speedRPM);

                        //        printf("BlowerDSIManager::worker m_speedRPM = %d\n", m_speedRPM);
                        //        fflush(stdout);
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

    //    printf("Blower RPM Data : ");
    //    for (int i=0; i< m_rpmSamples.length(); i++) {
    //        printf("%d ", m_rpmSamples[i]);
    //    }
    //    printf("\n");
    //    fflush(stdout);
}

int BlowerDSIManager::dutyCycletoAirflowCFM(int value)
{
    return qRound((((double)value) / 100.0) * ((double)m_airflowScalling));
}

int BlowerDSIManager::initSerialPort()
{
    m_pSerialPort.reset(new QSerialPort());
    foreach(const QSerialPortInfo &info, QSerialPortInfo::availablePorts()){
        if((info.vendorIdentifier() == USB_SERIAL_VID) && (info.productIdentifier() == USB_SERIAL_PID)){
            m_pSerialPort->setPort(info);
            if(m_pSerialPort->open(QIODevice::ReadWrite)){
                m_pSerialPort->setBaudRate(QSerialPort::BaudRate::Baud4800);
                m_pSerialPort->setDataBits(QSerialPort::DataBits::Data8);
                m_pSerialPort->setParity(QSerialPort::Parity::NoParity);
                m_pSerialPort->setStopBits(QSerialPort::StopBits::OneStop);

                emit serialPortOpened(info.portName());
            }
            break;
        }
    }
    if(!m_pSerialPort->isOpen()) {
        emit serialPortError() ;
        return -1;
    }
    return 0;
}

int BlowerDSIManager::airflowCFMtoDutyCycle(int value)
{
    return qRound((((double)value) / ((double)m_airflowScalling)) * 100.0);
}

BlowerRegalECM *BlowerDSIManager::getSub()
{
    return m_pModuleECM.data();
}

QString BlowerDSIManager::getSerialPortName() const
{
    if(m_pSerialPort.isNull()) return "";
    if(!m_pSerialPort->isOpen()) return "";
    return m_pSerialPort->portName();
}

void BlowerDSIManager::setSpeedDutyCycle(int newVal)
{
#ifndef NO_PRINT_DEBUG
    printf("BlowerDSIManager::setSpeedDutyCycle %d = %d = %d\n", newVal, dutyCycletoAirflowCFM(newVal), m_airflowScalling);
    fflush(stdout);
    printf("BlowerDSIManager::setSpeedDutyCycle interlock %d\n", m_interlock);
    fflush(stdout);
#endif
    m_airflowDemand_Req = dutyCycletoAirflowCFM(newVal);
}

void BlowerDSIManager::setInterlock(int newVal)
{
    if(m_interlock == newVal) return;
    m_interlock = newVal;
    emit interlockChanged(m_interlock);
}

void BlowerDSIManager::updateActualState()
{
    int response = -1;
    if(!m_pSerialPort.isNull()){
        if(m_pSerialPort->isOpen()){
            if(!m_pModuleECM.isNull()){

                int actualAirflowDemand = m_airflowDemand;
                response = m_pModuleECM->getDemand(&actualAirflowDemand);
                if(response == 0) {

                    ///CLEAR ERROR COUNT IF NOT YET REACH THE MAXIMUM ERROR
                    if(m_pModuleECM->errorComCount()){
                        m_pModuleECM->setErrorComCount(0);
                    }

                    ///UPDATE ACTUAL VALUE
                    if(m_airflowDemand != actualAirflowDemand){
                        m_airflowDemand = actualAirflowDemand;

                        emit demandChanged(m_airflowDemand);

                        //interprate to pwm duty cycle
                        int duty = airflowCFMtoDutyCycle(m_airflowDemand);
                        if(m_speedDutyCycle != duty){
                            m_speedDutyCycle = duty;
                            emit speedDutyCycleChanged(m_speedDutyCycle);
                        }

                        //                    #ifndef NO_PRINT_DEBUG
                        //                    printf("BlowerDSIManager::updateActualState m_airflowDemand = %d m_speedDutyCycle %d\n", m_airflowDemand, m_speedDutyCycle);
                        //                    fflush(stdout);
                        //                    #endif
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

void BlowerDSIManager::updateDemandState()
{
    if((m_airflowDemand_Req > 0) && m_interlock) m_airflowDemand_Req = 0;
    if(m_airflowDemand != m_airflowDemand_Req){
        int response = -1;
        response = m_pModuleECM->setAirflowDemand(m_airflowDemand_Req);
        if(response == 0){
            if(m_airflowDemand_Req) response = m_pModuleECM->start();
            else if(!m_airflowDemand_Req) response = m_pModuleECM->stop();
            if(response == 0) updateActualState();
        }

        //        if(response != 0){
        //            //ECM COMMUNICATION HAVE NO RESPONSE CORRECTLY
        //            //INCREASE_COMM_ERROR_COUNT
        //            int errorCount = m_pModuleECM->errorComCount();
        //            errorCount = errorCount + 1;
        //            m_pModuleECM->setErrorComCount(errorCount);

        //            //            #ifndef NO_PRINT_DEBUG
        //            printf("BlowerDSIManager::updateDemandState error response %d\n", errorCount);
        //            fflush(stdout);
        //            //            #endif
        //        }
    }
}

int BlowerDSIManager::getCutbackSpeed() const
{
    return m_cutbackSpeed;
}

void BlowerDSIManager::setCutbackSpeed(int newVal)
{
    m_cutbackSpeed = newVal;
}

double BlowerDSIManager::getConstantA4() const
{
    return m_constantA4;
}

void BlowerDSIManager::setConstantA4(double newVal)
{
    m_constantA4 = newVal;
}

double BlowerDSIManager::getConstantA3() const
{
    return m_constantA3;
}

void BlowerDSIManager::setConstantA3(double newVal)
{
    m_constantA3 = newVal;
}

double BlowerDSIManager::getConstantA2() const
{
    return m_constantA2;
}

void BlowerDSIManager::setConstantA2(double newVal)
{
    m_constantA2 = newVal;
}

double BlowerDSIManager::getConstantA1() const
{
    return m_constantA1;
}

void BlowerDSIManager::setConstantA1(double newVal)
{
    m_constantA1 = newVal;
}

int BlowerDSIManager::getAirflowScalling() const
{
    return m_airflowScalling;
}

void BlowerDSIManager::setAirflowScaling(int newVal)
{
    m_airflowScalling = newVal;
}

int BlowerDSIManager::getCutbackSlope() const
{
    return m_cutbackSlope;
}

void BlowerDSIManager::setCutbackSlope(int newVal)
{
    m_cutbackSlope = newVal;
}

int BlowerDSIManager::getDirection() const
{
    return m_direction;
}

void BlowerDSIManager::setDirection(int newVal)
{
    m_direction = newVal;
}
