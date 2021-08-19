#include <QSerialPortInfo>
#include <QSerialPort>
#include <QTimer>
#include <QSettings>
#include <QThread>
#include <QProcess>
#include <QtConcurrent/QtConcurrent>
#include "QtNetwork/QNetworkInterface"

#include <QTcpSocket>
#include <QModbusTcpServer>
#include <QHostAddress>
#include "Implementations/Modbus/QModbusTcpConnObserverImp.h"

#include "MachineBackend.h"

#include "MachineData.h"
#include "MachineEnums.h"
#include "MachineDefaultParameters.h"

#include "BoardIO/Drivers/QGpioSysfs/QGpioSysfs.h"
#include "BoardIO/Drivers/BlowerRegalECM/BlowerRegalECM.h"
#include "BoardIO/Drivers/RTCpcf8523/RTCpcf8523.h"
#include "BoardIO/Drivers/LEDpca9633/LEDpca9633.h"
#include "BoardIO/Drivers/AImcp3422x/AIManage.h"
#include "BoardIO/Drivers/PWMpca9685/PWMpca9685.h"
#include "BoardIO/Drivers/DIOpca9674/DIOpca9674.h"
#include "BoardIO/Drivers/AOmcp4725/AOmcp4725.h"
#include "BoardIO/Drivers/i2c/I2CPort.h"
#include "BoardIO/BoardIO.h"
#include "BoardIO/Drivers/SensirionSPD8xx/SensirionSPD8xx.h"
#include "BoardIO/Drivers/ParticleCounterZH03B/ParticleCounterZH03B.h"

#include "Implementations/BlowerRbm/BlowerRbmDsi.h"
#include "Implementations/DeviceAnalogCom/DeviceAnalogCom.h"
#include "Implementations/SashWindow/SashWindow.h"
#include "Implementations/DigitalOut/DeviceDigitalOut.h"
#include "Implementations/MotorizeOnRelay/MotorizeOnRelay.h"
#include "Implementations/AirflowVelocity/AirflowVelocity.h"
#include "Implementations/Temperature/Temperature.h"
#include "Implementations/PressureDiff/PressureDiff.h"
#include "Implementations/ParticleCounter/ParticleCounter.h"

#include "Implementations/DataLog/DataLogSql.h"
#include "Implementations/DataLog/DataLog.h"

#include "Implementations/AlarmLog/AlarmLogSql.h"
#include "Implementations/AlarmLog/AlarmLog.h"
#include "Implementations/AlarmLog/AlarmLogEnum.h"
#include "Implementations/AlarmLog/AlarmLogText.h"

#include "Implementations/EventLog/EventLogSql.h"
#include "Implementations/EventLog/EventLog.h"
#include "Implementations/EventLog/EventLogText.h"

#include "Implementations/SchedulerDayOutput/SchedulerDayOutput.h"

/// MODBUS REGISTER
struct modbusRegisterAddress
{
    struct operationMode     {static const short addr = 0;   short rw = 0; uint16_t value;} operationMode;
    struct sashState         {static const short addr = 1;   short rw = 0; uint16_t value;} sashState;
    struct fanState          {static const short addr = 2;   short rw = 0; uint16_t value;} fanState;
    struct fanDutyCycle      {static const short addr = 3;   short rw = 0; uint16_t value;} fanDutyCycle;
    struct fanRpm            {static const short addr = 4;   short rw = 0; uint16_t value;} fanRpm;
    struct lightState        {static const short addr = 5;   short rw = 0; uint16_t value;} lightState;
    struct lightIntensity    {static const short addr = 6;   short rw = 0; uint16_t value;} lightIntensity;
    struct socketState       {static const short addr = 7;   short rw = 0; uint16_t value;} socketState;
    struct gasState          {static const short addr = 8;   short rw = 0; uint16_t value;} gasState;
    struct uvState           {static const short addr = 9;   short rw = 0; uint16_t value;} uvState;
    struct sashMotorizeState {static const short addr = 10;  short rw = 0; uint16_t value;} sashMotorizeState;
    struct meaUnit           {static const short addr = 11;  short rw = 0; uint16_t value;} meaUnit;
    struct temperature       {static const short addr = 12;  short rw = 0; uint16_t value;} temperature;
    struct airflowInflow     {static const short addr = 13;  short rw = 0; uint16_t value;} airflowInflow;
    struct airflowDownflow   {static const short addr = 14;  short rw = 0; uint16_t value;} airflowDownflow;
    struct airflowExhaust    {static const short addr = 15;  short rw = 0; uint16_t value;} airflowExhaust;
    struct pressureExhaust   {static const short addr = 16;  short rw = 0; uint16_t value;} pressureExhaust;
    struct alarmSash         {static const short addr = 17;  short rw = 0; uint16_t value;} alarmSash;
    struct alarmInflow       {static const short addr = 18;  short rw = 0; uint16_t value;} alarmInflow;
    struct alarmDownflow     {static const short addr = 19;  short rw = 0; uint16_t value;} alarmDownflow;
    struct alarmExhaust      {static const short addr = 20;  short rw = 0; uint16_t value;} alarmExhaust;
    struct alarmCom          {static const short addr = 21;  short rw = 0; uint16_t value;} alarmCom;
    struct filterLife        {static const short addr = 22;  short rw = 0; uint16_t value;} filterLife;
    struct alarmFlapExhaust  {static const short addr = 23;  short rw = 0; uint16_t value;} alarmFlapExhaust;
    struct fanInflowDutyCycle{static const short addr = 24;  short rw = 0; uint16_t value;} fanInflowDutyCycle;
} modbusRegisterAddress;

#define MODBUS_REGISTER_COUNT   23
#define ALLOW_ANY_IP            "0.0.0.0"
#define LOCALHOST_ONLY          "127.0.0.1"

MachineBackend::MachineBackend(QObject *parent) : QObject(parent)
{
}

MachineBackend::~MachineBackend()
{
    //    qDebug() << metaObject()->className() << __FUNCTION__<< thread();
}

void MachineBackend::routineTask()
{
    int value = pData->getMachineBackendState();
    switch (value) {
    case MachineEnums::MACHINE_STATE_SETUP:
        setup();
        break;
    case MachineEnums::MACHINE_STATE_LOOP:
        loop();
        break;
    case MachineEnums::MACHINE_STATE_STOP:
        deallocate();
        break;
    default:
        break;
    }
}

void MachineBackend::setup()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    /// initial
    pData->setHasStopped(false);

    /// Permanent settings storage
    //    m_settings.reset(new QSettings);
    //    qDebug() << m_settings->fileName();
    QScopedPointer<QSettings> m_settings(new QSettings);

    /// READ SERIAL NUMBER
    {
        QString serialNumber = m_settings->value(SKEY_SBC_SERIAL_NUMBER, SDEF_SBC_SERIAL_NUMBER).toString();
        pData->setSbcSerialNumber(serialNumber);

        if(serialNumber == SDEF_SBC_SERIAL_NUMBER){
            serialNumber = _readSbcSerialNumber();
            _setSbcSerialNumber(serialNumber);
            pData->setSbcCurrentSerialNumber(serialNumber);
            pData->setSbcCurrentSerialNumberKnown(true);
        }else{
            pData->setSbcCurrentSerialNumber(_readSbcSerialNumber());
            if(serialNumber == pData->getSbcCurrentSerialNumber())
                pData->setSbcCurrentSerialNumberKnown(true);
            else
                pData->setSbcCurrentSerialNumberKnown(false);
        }
        //        pData->setSbcCurrentSerialNumberKnown(false);
    }
    /// READ SYSTEM INFORMATION
    {
        QStringList sysInfoDefault = (QStringList() << SDEF_SBC_SYS_INFO);
        QStringList sysInfo = m_settings->value(SKEY_SBC_SYS_INFO, sysInfoDefault).toStringList();
        pData->setSbcSystemInformation(sysInfo);
        qDebug() << "------ SysInfo ------";
        qDebug() << sysInfo;

        if(sysInfo == sysInfoDefault){
            sysInfo = _readSbcSystemInformation();
            _setSbcSystemInformation(sysInfo);
            _setSbcCurrentSystemInformation(sysInfo);
        }else{
            sysInfo = _readSbcSystemInformation();
            _setSbcCurrentSystemInformation(sysInfo);
        }
    }

    ////GPIO Buzzer
    {
        short buzzerGpioPin = 27; /// GPIO-20
        m_pBuzzer.reset(new QGpioSysfs);
        m_pBuzzer->setup(buzzerGpioPin);
    }

    /// BoardIO
    {
        /// Board IO use i2c port for communication
        /// setup i2c port
        m_i2cPort.reset(new I2CPort);
        /// define which i2c port number want to use
        /// ESCO OS Y313 has allocated i2cport number 4 for board communication
        m_i2cPort->setPortNumber(4);
        m_i2cPort->openPort();

        /// Initializing every required board
        {
            /// IO EXTENDER
            {
                m_boardCtpIO.reset(new LEDpca9633);
                m_boardCtpIO->setI2C(m_i2cPort.data());
                bool response = m_boardCtpIO->init();

                pData->setBoardStatusCtpIoe(!response);

                ///Pin 0 - PWM0 connect to LCD Brightness Control
                m_boardCtpIO->setOutputAsPWM(LEDpca9633_CHANNEL_BL);
                /// Pin 1 (active low) - PWM1 connect to Mosfet to controll watchdog gate (NPN)
                /// Now we need disabled first the pin because watchdown dot ready yet
                /// Disconnect watchdog bridge
                m_boardCtpIO->setOutputAsDigital(LEDpca9633_CHANNEL_WDG, MachineEnums::DIG_STATE_ONE);
                //// connect watchdog brigde, just for your information
                //                m_boardCtpIO->setOutputAsDigital(LEDpca9633_CHANNEL_WDG, MachineEnums::DIG_STATE_ZERO);

                /// catch error status of the board
                QObject::connect(m_boardCtpIO.data(), &LEDpca9633::errorComToleranceReached,
                                 this, [&](int error){
                    qDebug() << "LEDpca9633::errorComToleranceReached" << error << thread();
                    pData->setBoardStatusCtpIoe(false);
                });
                QObject::connect(m_boardCtpIO.data(), &LEDpca9633::errorComToleranceCleared,
                                 this, [&](int error){
                    qDebug() << "LEDpca9633::errorComToleranceCleared" << error << thread();
                    pData->setBoardStatusCtpIoe(true);
                });
            }

            //// RTC
            {
                m_boardCtpRTC.reset(new RTCpcf8523);
                m_boardCtpRTC->setI2C(m_i2cPort.data());
                //check status osilation of second
                short response = m_boardCtpRTC->init();

                pData->setBoardStatusCtpRtc(!response);
#ifdef __arm__
                /// get time from RTC the set to Linux system
                /// Then Linux system time will count indepedenlty affect from NTP
                int wday = 0, day = 0, month = 0, year = 0;
                response = m_boardCtpRTC->getDate(wday, day, month, year);
                if(response != 0) qWarning() << metaObject()->className() << __func__ << "m_boardCtpRTC fail";
                qDebug() << metaObject()->className() << __func__ <<"RTC: "<< wday << "-" << day <<  "-" << month << year;
                int hour = 0, minute = 0, second = 0;
                response = m_boardCtpRTC->getClock(hour, minute, second);
                if(response != 0) qWarning() << metaObject()->className() << __func__ << "m_boardCtpRTC fail";
                qDebug() << metaObject()->className() << __func__ <<"RTC: "<< hour << ":" << minute <<  ":" << second;

                /// set to linux system, it's require with following format
                /// 2015-11-20 15:58:30
                QString dateTimeFormat = QString().asprintf("%d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, minute, second);
                qDebug() << metaObject()->className() << __func__ << "dateTimeFormat" << dateTimeFormat;
                QDateTime dateValidation = QDateTime::fromString(dateTimeFormat, "yyyy-MM-dd hh:mm:ss");
                if(response == 0) {
                    if(dateValidation.isValid()){
                        qDebug() << metaObject()->className() << __func__
                                 << "DateTimeRTC is valid! set linux system based on RTC" << dateTimeFormat;
                        _setDateTimeLinux(dateTimeFormat);
                    }
                    else {
                        QDateTime dateTimeLinux = QDateTime::currentDateTime();
                        qDebug() << metaObject()->className() << __func__
                                 << "DateTimeRTC is invalid! Force update time based on linux" << dateTimeLinux.toString("yyyy-MM-dd hh:mm:ss");
                        /// if RTC time not valid, set to 2000-01-01 00:00:00
                        m_boardCtpRTC->setClock(dateTimeLinux.time().hour(),
                                                dateTimeLinux.time().minute(),
                                                dateTimeLinux.time().second());
                        m_boardCtpRTC->setDate(dateTimeLinux.date().weekNumber(),
                                               dateTimeLinux.date().day(),
                                               dateTimeLinux.date().month(),
                                               dateTimeLinux.date().year());
                    }
                }
#endif
                //DEFINE_GPIO_FOR_WATCHDOG_GATE
                {
#ifdef __arm__
                    //                    SET_RTC_TIMER_AS_WATCHDOG
                    m_boardCtpRTC->setClearInterrupt();
                    m_boardCtpRTC->setClockOutCtrl(PCF8523_CLOCKOUT_CTRL_DISABLED);
                    m_boardCtpRTC->setTimerFreqCtrl(PCF8523_TIMER_SOURCE_FREQ_S);
                    m_boardCtpRTC->setTimerAModeInterrupt(PCF8523_TIMER_MODE_INT_PULSE);
                    m_boardCtpRTC->setTimerAInteruptEnable(MachineEnums::DIG_STATE_ONE);
#endif
                    ////EVENT TIMER TO RESET WATCHDOG COUNTER
                    m_timerEventForRTCWatchdogReset.reset(new QTimer);
                    m_timerEventForRTCWatchdogReset->setInterval(TIMER_INTERVAL_30_SECOND);
                    connect(m_timerEventForRTCWatchdogReset.data(), &QTimer::timeout,
                            [=](){
#ifdef __arm__
                        m_boardCtpRTC->setTimerACount(SDEF_WATCHDOG_PERIOD, I2CPort::I2C_SEND_MODE_QUEUE);
#endif
                    });
#ifdef __arm__
                    m_boardCtpRTC->setTimerAMode(PCF8523_TIMER_A_MODE_WATCHDOG, I2CPort::I2C_SEND_MODE_DIRECT);
                    m_boardCtpRTC->setTimerACount(SDEF_WATCHDOG_PERIOD, I2CPort::I2C_SEND_MODE_DIRECT);
#endif
                }

                /// catch error status of the board
                QObject::connect(m_boardCtpRTC.data(), &RTCpcf8523::errorComToleranceReached,
                                 this, [&](int error){
                    qDebug() << "RTCpcf8523::errorComToleranceReached" << error << thread();
                    pData->setBoardStatusCtpRtc(false);
                });
                QObject::connect(m_boardCtpRTC.data(), &RTCpcf8523::errorComToleranceCleared,
                                 this, [&](int error){
                    qDebug() << "RTCpcf8523::errorComToleranceCleared" << error << thread();
                    pData->setBoardStatusCtpRtc(true);
                });
            }

            //            abort();

            /// DIGITAL_INPUT
            {
                m_boardDigitalInput1.reset(new DIOpca9674);
                m_boardDigitalInput1->setI2C(m_i2cPort.data());

                bool response = m_boardDigitalInput1->init();
                m_boardDigitalInput1->polling();

                pData->setBoardStatusHybridDigitalInput(!response);

                /// catch error status of the board
                QObject::connect(m_boardDigitalInput1.data(), &DIOpca9674::errorComToleranceReached,
                                 this, [&](int error){
                    qDebug() << "DIOpca9674::errorComToleranceReached" << error << thread();
                    pData->setBoardStatusHybridDigitalInput(false);
                });
                QObject::connect(m_boardDigitalInput1.data(), &DIOpca9674::errorComToleranceCleared,
                                 this, [&](int error){
                    qDebug() << "AIManage::errorComToleranceCleared" << error << thread();
                    pData->setBoardStatusHybridDigitalInput(true);
                });
            }//

            ////DIGITAL_OUTPUT/PWM
            {
                m_boardRelay1.reset(new PWMpca9685);
                m_boardRelay1->setI2C(m_i2cPort.data());
                m_boardRelay1->preInitCountChannelsToPool(8);
                m_boardRelay1->preInitFrequency(PCA9685_PWM_VAL_FREQ_100HZ);

                bool response = m_boardRelay1->init();
                m_boardRelay1->polling();

                pData->setBoardStatusHybridDigitalRelay(!response);

                ////MONITORING COMMUNICATION STATUS
                QObject::connect(m_boardRelay1.data(), &PWMpca9685::errorComToleranceReached,
                                 this, [&](int error){
                    qDebug() << "PWMpca9685::errorComToleranceReached" << error << thread();
                    pData->setBoardStatusHybridDigitalRelay(false);
                });
                QObject::connect(m_boardRelay1.data(), &PWMpca9685::errorComToleranceCleared,
                                 this, [&](int error){
                    qDebug() << "AIManage::errorComToleranceCleared" << error << thread();
                    pData->setBoardStatusHybridDigitalRelay(true);
                });
            }

            /// Analog Input
            {
                m_boardAnalogInput1.reset(new AIManage);
                m_boardAnalogInput1->setupAIModule();
                m_boardAnalogInput1->setI2C(m_i2cPort.data());
                m_boardAnalogInput1->setAddress(0x69);

                bool response = m_boardAnalogInput1->init();
                m_boardAnalogInput1->polling();

                pData->setBoardStatusHybridAnalogInput(!response);

                //DEFINE_CHANNEL_FOR_TEMPERATURE
                m_boardAnalogInput1->setChannelDoPoll(0, true);
                m_boardAnalogInput1->setChannelDoAverage(0, true);
                m_boardAnalogInput1->setChannelSamples(0, 30);

                //DEFINE_CHANNEL_FOR_AIRFLOW
                m_boardAnalogInput1->setChannelDoPoll(1, true);
                m_boardAnalogInput1->setChannelDoAverage(1, true);
                m_boardAnalogInput1->setChannelSamples(1, 100);

                ////MONITORING COMMUNICATION STATUS
                QObject::connect(m_boardAnalogInput1.data(), &AIManage::errorComToleranceReached,
                                 this, [&](int error){
                    qDebug() << "AIManage::errorComToleranceReached" << error << thread();
                    pData->setBoardStatusHybridAnalogInput(false);
                });
                QObject::connect(m_boardAnalogInput1.data(), &AIManage::errorComToleranceCleared,
                                 this, [&](int error){
                    qDebug() << "AIManage::errorComToleranceCleared" << error << thread();
                    pData->setBoardStatusHybridAnalogInput(true);
                });
            }

            /// Analog Output Board - LIGHT INTENSITY
            {
                m_boardAnalogOutput1.reset(new AOmcp4725);
                m_boardAnalogOutput1->setI2C(m_i2cPort.data());
                m_boardAnalogOutput1->setAddress(0x60);

                bool response = m_boardAnalogOutput1->init();
                m_boardAnalogOutput1->polling();

                pData->setBoardStatusHybridAnalogOutput1(!response);

                /// catch error status of the board
                QObject::connect(m_boardAnalogOutput1.data(), &AOmcp4725::errorComToleranceReached,
                                 this, [&](int error){
                    qDebug() << "m_boardAnalogOutput1 Error changed" << error << thread();
                    pData->setBoardStatusHybridAnalogOutput1(false);
                });
                QObject::connect(m_boardAnalogOutput1.data(), &AIManage::errorComToleranceCleared,
                                 this, [&](int error){
                    qDebug() << "m_boardAnalogOutput1 Error changed" << error << thread();
                    pData->setBoardStatusHybridAnalogOutput1(true);
                });
            }//

            /// Analog Output Board - INFLOW FAN
            {
                m_boardAnalogOutput2.reset(new AOmcp4725);
                m_boardAnalogOutput2->setI2C(m_i2cPort.data());
                m_boardAnalogOutput2->setAddress(0x61);

                bool response = m_boardAnalogOutput2->init();
                m_boardAnalogOutput2->polling();

                pData->setBoardStatusHybridAnalogOutput2(!response);

                /// catch error status of the board
                QObject::connect(m_boardAnalogOutput2.data(), &AOmcp4725::errorComToleranceReached,
                                 this, [&](int error){
                    qDebug() << "m_boardAnalogOutput2 Error changed" << error << thread();
                    pData->setBoardStatusHybridAnalogOutput2(false);
                });
                QObject::connect(m_boardAnalogOutput2.data(), &AIManage::errorComToleranceCleared,
                                 this, [&](int error){
                    qDebug() << "m_boardAnalogOutput2 Error changed" << error << thread();
                    pData->setBoardStatusHybridAnalogOutput2(true);
                });
            }//

            /// SEAS BOARD FLAP INTEGRATED
            {
                short installed = m_settings->value(SKEY_SEAS_BOARD_FLAP_INSTALLED, MachineEnums::DIG_STATE_ZERO).toInt();
                //installed = 1;
                pData->setSeasFlapInstalled(installed);
            }

            /// EXHAUST_PRESSURE_DIFF_SENSIRION_SPD8xx
            /// SEAS INTEGRATED
            {
                short installed = m_settings->value(SKEY_SEAS_INSTALLED, MachineEnums::DIG_STATE_ZERO).toInt();
                //installed = 1;
                pData->setSeasInstalled(installed);

                m_boardSensirionSPD8xx.reset(new SensirionSPD8xx);
                m_boardSensirionSPD8xx->setI2C(m_i2cPort.data());

                //        //CABINET TYPE B IS MANDATORY TO INSTALL EXHAUST PRESSURE SENSOR
                //        //THE PRESSURE RANGE TO BE MONITORING IS IN RANGE BETWEEN 0 TO 500 Pa
                //        //TYPICALLY FAIL POINT IS AT 200 Pa
                //        m_pSensirionSPD8xxExhaust->setSensorRangeType(SensirionSPD8xx::SPD_RANGE_TYPE_500Pa);
                //
                //CABINET TYPE A IS OPTIONAL TO INSTALL EXHAUST PRESSURE SENSOR
                //THE PRESSURE RANGE TO BE MONITORING IS IN RANGE BETWEEN -125 TO 125 Pa
                //TYPICALLY FAIL POINT IS AT -3 Pa
                m_boardSensirionSPD8xx->setSensorRangeType(SensirionSPD8xx::SPD_RANGE_TYPE_125Pa);

                /// MONITORING COMMUNICATION STATUS
                /// catch error status of the board
                QObject::connect(m_boardSensirionSPD8xx.data(), &SensirionSPD8xx::errorComToleranceReached,
                                 this, [&](int error){
                    qDebug() << "SensirionSPD8xx::errorComToleranceReached" << error << thread();
                    pData->setBoardStatusPressureDiff(false);
                });
                QObject::connect(m_boardSensirionSPD8xx.data(), &SensirionSPD8xx::errorComToleranceCleared,
                                 this, [&](int error){
                    qDebug() << "SensirionSPD8xx::errorComToleranceCleared" << error << thread();
                    pData->setBoardStatusPressureDiff(true);
                });

                if (installed) {
                    bool response = m_boardSensirionSPD8xx->init();
                    m_boardSensirionSPD8xx->polling();

                    pData->setBoardStatusPressureDiff(!response);

                    m_boardSensirionSPD8xx->setDataSampleMaxPressurePa(50);
                    m_boardSensirionSPD8xx->readDiffPressure();
                    int pressure = m_boardSensirionSPD8xx->diffPressurePa();
                    //            pressure = 5;//PLEASE REMOVE AFTER DEBUGGING
                    pData->setSeasPressureDiffPa(pressure);
                }
            }
        }//

        /// Required object to manage communication
        /// communication will use daisy chain mechanism
        /// in one port i2c will connect to many board
        /// will use short poling mechanism to synchronization the states between machine logic and actual board
        m_boardIO.reset(new BoardIO);
        m_boardIO->setI2C(m_i2cPort.data());
        /// add any board for short polling
        {
            m_boardIO->addSlave(m_boardDigitalInput1.data());
            m_boardIO->addSlave(m_boardRelay1.data());
            m_boardIO->addSlave(m_boardAnalogInput1.data());
            m_boardIO->addSlave(m_boardAnalogOutput1.data());
            m_boardIO->addSlave(m_boardAnalogOutput2.data());
            if(pData->getSeasInstalled()){ m_boardIO->addSlave(m_boardSensirionSPD8xx.data());}

            m_boardIO->addSlave(m_boardCtpIO.data());
            m_boardIO->addSlave(m_boardCtpRTC.data());
        }
        /// setup thread and timer interupt for board IO
        {
            /// create timer for triggering the loop (routine task) and execute any pending request
            /// routine task and any pending task will executed by FIFO mechanism
            m_timerEventForBoardIO.reset(new QTimer);
            m_timerEventForBoardIO->setInterval(TEI_FOR_BOARD_IO);

            /// create independent thread
            /// looping inside this thread will run parallel* beside machineState loop
            m_threadForBoardIO.reset(new QThread);

            /// Start timer event when thread was started
            QObject::connect(m_threadForBoardIO.data(), &QThread::started,
                             m_timerEventForBoardIO.data(), [&](){
                //                qDebug() << "m_timerInterruptForBoardIO::started" << thread();
                m_timerEventForBoardIO->start();
            });

            /// Stop timer event when thread was finished
            QObject::connect(m_threadForBoardIO.data(), &QThread::finished,
                             m_timerEventForBoardIO.data(), [&](){
                //                qDebug() << "m_timerInterruptForBoardIO::finished" << thread();
                m_timerEventForBoardIO->stop();
            });

            /// Enable triggerOnStarted, calling the worker of FanRbmDsi when thread has started
            /// This is use lambda function, this symbol [&] for pass m_boardIO object
            QObject::connect(m_threadForBoardIO.data(), &QThread::started,
                             m_boardIO.data(), [&](){
                //                qDebug() << "m_boardIO::started" << thread();
                m_boardIO->routineTask();
            });

            /// Call routine task fan (syncronazation value)
            /// This method calling by timerEvent
            QObject::connect(m_timerEventForBoardIO.data(), &QTimer::timeout,
                             m_boardIO.data(), [&](){
                //                qDebug() << "m_boardIO::timeout" << thread();
                m_boardIO->routineTask();
            });

            /// Run loop thread when Machine State goes to looping / routine task
            QObject::connect(this, &MachineBackend::loopStarted,
                             m_threadForBoardIO.data(), [&](){
                //                qDebug() << "m_threadForBoardIO::loopStarted" << thread();
                m_threadForBoardIO->start();
            });

            /// Do move fan routine task / looping to independent thread
            m_boardIO->moveToThread(m_threadForBoardIO.data());
            /// Do move timer event for fan routine task to independent thread
            /// make the timer has prescission because independent from this Macine State looping
            m_timerEventForBoardIO->moveToThread(m_threadForBoardIO.data());
        }//
    }//

    /// MODBUS
    {
        QString allowedIP = m_settings->value(SKEY_MODBUS_ALLOW_IP, LOCALHOST_ONLY).toString();
        pData->setModbusAllowIpMaster(allowedIP);

        short slaveID = m_settings->value(SKEY_MODBUS_SLAVE_ID, 1).toInt();
        pData->setModbusSlaveID(slaveID);

        enum {REG_RO, REG_RW};
        modbusRegisterAddress.fanState.rw       = m_settings->value(SKEY_MODBUS_RW_FAN, REG_RO).toInt();
        modbusRegisterAddress.lightState.rw     = m_settings->value(SKEY_MODBUS_RW_LAMP, REG_RO).toInt();
        modbusRegisterAddress.lightIntensity.rw = m_settings->value(SKEY_MODBUS_RW_LAMP_DIMM, REG_RO).toInt();
        modbusRegisterAddress.socketState.rw    = m_settings->value(SKEY_MODBUS_RW_SOCKET, REG_RO).toInt();
        modbusRegisterAddress.gasState.rw       = m_settings->value(SKEY_MODBUS_RW_GAS, REG_RO).toInt();
        modbusRegisterAddress.uvState.rw        = m_settings->value(SKEY_MODBUS_RW_UV, REG_RO).toInt();

        pData->setModbusAllowSetFan(modbusRegisterAddress.fanState.rw);
        pData->setModbusAllowSetLight(modbusRegisterAddress.lightState.rw);
        pData->setModbusAllowSetLightIntensity(modbusRegisterAddress.lightIntensity.rw);
        pData->setModbusAllowSetSocket(modbusRegisterAddress.socketState.rw);
        pData->setModbusAllowSetGas(modbusRegisterAddress.gasState.rw);
        pData->setModbusAllowSetUvLight(modbusRegisterAddress.uvState.rw);

        /// Create main object for modbus
        m_pModbusServer = new QModbusTcpServer(this);
        /// Monitoring incomming connection
        m_pModbusTcpConnObserver = new QModbusTcpConnObserverImp(this);
        m_pModbusTcpConnObserver->setMachineBackend(this); /// see the callback -> _callbackOnModbusConnectionStatusChanged
        m_pModbusServer->installConnectionObserver(m_pModbusTcpConnObserver);
        /// Register Address
        QModbusDataUnitMap reg;
        reg.insert(QModbusDataUnit::HoldingRegisters,
                   {QModbusDataUnit::HoldingRegisters, 0, MODBUS_REGISTER_COUNT});
        /// Shadow of the modbus register
        m_modbusDataUnitBufferRegisterHolding.reset(new QVector<uint16_t>(MODBUS_REGISTER_COUNT));
        /// put the register map to modbus handler
        m_pModbusServer->setMap(reg);
        /// Common number port for modbus TCP
        m_pModbusServer->setConnectionParameter(QModbusDevice::NetworkPortParameter, "5502");
        /// Listen from all addresses request
        m_pModbusServer->setConnectionParameter(QModbusDevice::NetworkAddressParameter, "0.0.0.0");
        /// the address of this Mobus server instance, default 1
        m_pModbusServer->setServerAddress(slaveID);
        /// monitoring the request
        connect(m_pModbusServer, &QModbusTcpServer::dataWritten,
                this, &MachineBackend::_onModbusDataWritten, Qt::UniqueConnection);

        /// Start teh modbus
        bool connected = m_pModbusServer->connectDevice();
        if (!connected) {
            qWarning() << m_pModbusServer->errorString();
        }
    }

    /// Fan Exhaust
    {
        m_pFanInflow.reset(new DeviceAnalogCom);
        m_pFanInflow->setSubBoard(m_boardAnalogOutput2.data());

        connect(m_pFanInflow.data(), &DeviceAnalogCom::stateChanged,
                pData, [&](int newVal){
            pData->setFanInflowDutyCycle(newVal);

            /// MODBUS
            _setModbusRegHoldingValue(modbusRegisterAddress.fanInflowDutyCycle.addr, newVal);
        });
    }
    /// Fan Primary - Fan Downflow
    {
        /// find and initializing serial port for fan
        m_serialPort1.reset(new QSerialPort());
        foreach(const QSerialPortInfo &info, QSerialPortInfo::availablePorts()){
            if((info.vendorIdentifier() == BLOWER_USB_SERIAL_VID) &&
                    (info.productIdentifier() == BLOWER_USB_SERIAL_PID)){

                m_serialPort1->setPort(info);

                if(m_serialPort1->open(QIODevice::ReadWrite)){
                    m_serialPort1->setBaudRate(QSerialPort::BaudRate::Baud4800);
                    m_serialPort1->setDataBits(QSerialPort::DataBits::Data8);
                    m_serialPort1->setParity(QSerialPort::Parity::NoParity);
                    m_serialPort1->setStopBits(QSerialPort::StopBits::OneStop);
                }

                break;
            }
        }

        /// RBM COM Board is OK and ready to send fan paramaters
        if (!m_serialPort1->isOpen()) {
            qWarning() << __FUNCTION__ << thread() << "serial port for fan cannot be opened";
            pData->setBoardStatusRbmCom(false);
        }
        /// initializing the fan object
        m_boardRegalECM.reset(new BlowerRegalECM);
        /// set the serial port
        m_boardRegalECM->setSerialComm(m_serialPort1.data());
        /// we expect the first value of the the fan from not running
        /// now, we assume the response from the fan is always OK,
        //        /// so we dont care the return value of following API
        m_boardRegalECM->stop();
        int maxAirVolume;
        /// setup profile fan ecm
        {
            /// query profile from machine profile
            QJsonObject machineProfile = pData->getMachineProfile();
            QJsonObject fanProfile = machineProfile.value("fan").toObject();

            short direction = fanProfile.value("direction").toInt();
            int highSpeedLimit = fanProfile.value("highSpeedLimit").toInt();
            maxAirVolume = fanProfile.value("maxAirVolume").toInt();

            QJsonObject constantProfile = fanProfile.value("constant").toObject();

            double a1 = constantProfile.value("a1").toDouble();
            double a2 = constantProfile.value("a2").toDouble();
            double a3 = constantProfile.value("a3").toDouble();
            double a4 = constantProfile.value("a4").toDouble();

            m_boardRegalECM->setDirection(direction);
            m_boardRegalECM->setCutbackSpeed(highSpeedLimit);
            m_boardRegalECM->setAirflowScaling(maxAirVolume);
            short response = m_boardRegalECM->setBlowerContant(a1, a2, a3, a4);

            pData->setBoardStatusRbmCom(response == 0);
        }

        ////MONITORING COMMUNICATION STATUS
        QObject::connect(m_boardRegalECM.data(), &BlowerRegalECM::errorComToleranceReached,
                         this, [&](int error){
            qDebug() << "BlowerRegalECM::errorComToleranceReached" << error << thread();
            pData->setBoardStatusRbmCom(false);
        });
        QObject::connect(m_boardRegalECM.data(), &BlowerRegalECM::errorComToleranceCleared,
                         this, [&](int error){
            qDebug() << "BlowerRegalECM::errorComToleranceCleared" << error << thread();
            pData->setBoardStatusRbmCom(true);
        });

        /// create object for value keeper
        /// ensure actuator value is what machine value requested
        m_pFanPrimary.reset(new BlowerRbmDsi);

        /// pass the virtual object sub module board
        m_pFanPrimary->setSubModule(m_boardRegalECM.data());

        /// use air volume demand mode, blower will have auto compesate to achive the air volume demand
        m_pFanPrimary->setDemandMode(BlowerRbmDsi::AIRVOLUME_DEMMAND_BRDM);
        m_pFanPrimary->setAirVolumeScale(maxAirVolume);

        /// create timer for triggering the loop (routine task) and execute any pending request
        /// routine task and any pending task will executed by FIFO mechanism
        m_timerEventForFanRbmDsi.reset(new QTimer);
        m_timerEventForFanRbmDsi->setInterval(TEI_FOR_BLOWER_RBMDSI);

        /// create independent thread
        /// looping inside this thread will run parallel* beside machineState loop
        m_threadForFanRbmDsi.reset(new QThread);

        /// Start timer event when thread was started
        QObject::connect(m_threadForFanRbmDsi.data(), &QThread::started,
                         m_timerEventForFanRbmDsi.data(), [&](){
            //            qDebug() << "m_timerEventForFanRbmDsi::started" << thread();
            m_timerEventForFanRbmDsi->start();
        });

        /// Stop timer event when thread was finished
        QObject::connect(m_threadForFanRbmDsi.data(), &QThread::finished,
                         m_timerEventForFanRbmDsi.data(), [&](){
            //            qDebug() << "m_timerEventForFanRbmDsi::finished" << thread();
            m_timerEventForFanRbmDsi->stop();
        });

        /// Enable triggerOnStarted, calling the worker of FanRbmDsi when thread has started
        /// This is use lambda function, this symbol [&] for pass m_fanRbmDsi object to can captured by lambda
        /// m_fanRbmDsi.data(), [&](){m_fanRbmDsi->worker();});
        QObject::connect(m_threadForFanRbmDsi.data(), &QThread::started,
                         m_pFanPrimary.data(), [&](){
            m_pFanPrimary->routineTask();
        });

        /// Call routine task fan (syncronazation value)
        /// This method calling by timerEvent
        QObject::connect(m_timerEventForFanRbmDsi.data(), &QTimer::timeout,
                         m_pFanPrimary.data(), [&](){
            //            qDebug() << "m_fanRbmDsi::timeout" << thread();
            m_pFanPrimary->routineTask();
        });

        /// Run fan loop thread when Machine State goes to looping / routine task
        QObject::connect(this, &MachineBackend::loopStarted,
                         m_threadForFanRbmDsi.data(), [&](){
            //            qDebug() << "m_threadForFanRbmDsi::loopStarted" << thread();
            m_threadForFanRbmDsi->start();
        });

        /// call this when actual blower duty cycle has changed
        QObject::connect(m_pFanPrimary.data(), &BlowerRbmDsi::dutyCycleChanged,
                         this, &MachineBackend::_onFanPrimaryActualDucyChanged);

        /// call this when actual blower rpm has changed
        QObject::connect(m_pFanPrimary.data(), &BlowerRbmDsi::rpmChanged,
                         this, &MachineBackend::_onFanPrimaryActualRpmChanged);

        /// call this when actual blower interloked
        QObject::connect(m_pFanPrimary.data(), &BlowerRbmDsi::interlockChanged,
                         pData, [&](short newVal){
            pData->setFanPrimaryInterlocked(newVal);
        });

        /// Do move fan routine task / looping to independent thread
        m_pFanPrimary->moveToThread(m_threadForFanRbmDsi.data());
        /// Do move timer event for fan routine task to independent thread
        /// make the timer has prescission because independent from this Macine State looping
        m_timerEventForFanRbmDsi->moveToThread(m_threadForFanRbmDsi.data());
        /// Also move all necesarry object to independent fan thread
        m_serialPort1->moveToThread(m_threadForFanRbmDsi.data());
        m_boardRegalECM->moveToThread(m_threadForFanRbmDsi.data());
    }//

    /// SASH
    {
        m_pSashWindow.reset(new SashWindow);
        m_pSashWindow->setSubModule(m_boardDigitalInput1.data());

        /// early update sash state
        m_boardDigitalInput1->polling();
        m_pSashWindow->routineTask();
        int currentState = m_pSashWindow->sashState();
        pData->setSashWindowState(currentState);

        /// MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.sashState.addr, currentState);

        QObject::connect(m_pSashWindow.data(), &SashWindow::mSwitchStateChanged,
                         pData, &MachineData::setMagSWState);

        QObject::connect(m_pSashWindow.data(), &SashWindow::sashStateChanged,
                         this, &MachineBackend::_onSashStateChanged);
    }//

    /// Sash Window Motorize
    {
        bool installed = m_settings->value(SKEY_SASH_MOTOR_INSTALLED, MachineEnums::DIG_STATE_ZERO).toInt();
        //        installed = true;
        pData->setSashWindowMotorizeInstalled(installed);

        m_pSasWindowMotorize.reset(new MotorizeOnRelay);
        m_pSasWindowMotorize->setSubModule(m_boardRelay1.data());
        m_pSasWindowMotorize->setChannelUp(4);
        m_pSasWindowMotorize->setChannelDown(3);

#ifdef QT_DEBUG
        /// allow up channel up and down channel active in one time
        /// this only for testing/debug
        m_pSasWindowMotorize->setProtectFromDualActive(true);
#endif

        connect(m_pSasWindowMotorize.data(), &MotorizeOnRelay::stateChanged,
                pData, [&](int newVal){
            pData->setSashWindowMotorizeState(newVal);

            /// MODBUS
            _setModbusRegHoldingValue(modbusRegisterAddress.sashMotorizeState.addr, newVal);
        });

        connect(m_pSasWindowMotorize.data(), &MotorizeOnRelay::interlockUpChanged,
                pData, [&](short newVal){
            pData->setSashWindowMotorizeUpInterlocked(newVal);
        });
        connect(m_pSasWindowMotorize.data(), &MotorizeOnRelay::interlockDownChanged,
                pData, [&](short newVal){
            pData->setSashWindowMotorizeDownInterlocked(newVal);
        });
    }

    /// Light Intensity
    {
        m_pLightIntensity.reset(new DeviceAnalogCom);
        m_pLightIntensity->setSubBoard(m_boardAnalogOutput1.data());

        int min = m_settings->value(SKEY_LIGHT_INTENSITY_MIN, 30).toInt(); //percent

        int adcMin;
        m_boardAnalogOutput1->voltToInputcode((min / 10) * 1000 /*to miliVolt*/, &adcMin);

        //        qDebug() << "adcMin" << adcMin;

        m_pLightIntensity->setAdcMin(adcMin);
        m_pLightIntensity->setStateMin(min);

        short light = m_settings->value(SKEY_LIGHT_INTENSITY, 100).toInt();

        /// CAUSED BLINKING - NO IMPLEMENTED
        /// bacasue boardIo poilling not started yet, so we manually call
        /// the board instead m_lightIntensity object
        /// this i2c communication will used direct mode
        //        int inputCode = m_lightIntensity->stateToAdc(light);
        //        qDebug() << "m_lightIntensity" << inputCode;
        //        m_boardAnalogOutput1->setDAC(inputCode);

        m_pLightIntensity->setState(light);

        connect(m_pLightIntensity.data(), &DeviceAnalogCom::stateChanged,
                pData, [&](int newVal){
            pData->setLightIntensity(newVal);

            /// MODBUS
            _setModbusRegHoldingValue(modbusRegisterAddress.lightIntensity.addr, newVal);
        });
    }

    /// Light
    {
        m_pLight.reset(new DeviceDigitalOut);
        m_pLight->setSubModule(m_boardRelay1.data());
        m_pLight->setChannelIO(0);

        connect(m_pLight.data(), &DeviceDigitalOut::stateChanged,
                this, &MachineBackend::_onLightStateChanged);

        connect(m_pLight.data(), &DeviceDigitalOut::interlockChanged,
                pData, [&](int newVal){
            pData->setLightInterlocked(newVal);
        });
    }

    /// Socket
    {
        bool installed = m_settings->value(SKEY_SOCKET_INSTALLED, MachineEnums::DIG_STATE_ONE).toInt();
        pData->setSocketInstalled(installed);

        m_pSocket.reset(new DeviceDigitalOut);
        m_pSocket->setSubModule(m_boardRelay1.data());
        m_pSocket->setChannelIO(5);

        connect(m_pSocket.data(), &DeviceDigitalOut::stateChanged,
                this, &MachineBackend::_onSocketStateChanged);

        connect(m_pSocket.data(), &DeviceDigitalOut::interlockChanged,
                pData, [&](int newVal){
            pData->setSocketInterlocked(newVal);
        });
    }

    /// Gas
    {
        bool installed = m_settings->value(SKEY_GAS_INSTALLED, MachineEnums::DIG_STATE_ONE).toInt();
        pData->setGasInstalled(installed);

        m_pGas.reset(new DeviceDigitalOut);
        m_pGas->setSubModule(m_boardRelay1.data());
        m_pGas->setChannelIO(2);

        connect(m_pGas.data(), &DeviceDigitalOut::stateChanged,
                this, &MachineBackend::_onGasStateChanged);

        connect(m_pGas.data(), &DeviceDigitalOut::interlockChanged,
                pData, [&](int newVal){
            pData->setGasInterlocked(newVal);
        });
    }

    /// UV
    {
        bool installed = m_settings->value(SKEY_UV_INSTALLED, MachineEnums::DIG_STATE_ONE).toInt();
        pData->setUvInstalled(installed);

        m_pUV.reset(new DeviceDigitalOut);
        m_pUV->setSubModule(m_boardRelay1.data());
        m_pUV->setChannelIO(1);

        connect(m_pUV.data(), &DeviceDigitalOut::stateChanged,
                this, &MachineBackend::_onUVStateChanged);

        connect(m_pUV.data(), &DeviceDigitalOut::interlockChanged,
                pData, [&](int newVal){
            pData->setUvInterlocked(newVal);
        });

        /// UV Meter
        {
            int minutes = m_settings->value(SKEY_UV_METER, SDEF_UV_MAXIMUM_TIME_LIFE).toInt();
            int minutesPercentLeft = __getPercentFrom(minutes, SDEF_UV_MAXIMUM_TIME_LIFE);
            /// event if in % value is zero but the minutes more then 0 minutes, then set % to 1
            if (minutesPercentLeft == 0 && minutes > 0) minutesPercentLeft = 1;

            //update to global observable variable
            pData->setUvLifeMinutes(minutes);
            pData->setUvLifePercent(minutesPercentLeft);
        }

        /// UV Timer
        {
            int minutes = m_settings->value(SKEY_UV_TIME, 30).toInt(); //30 minutes (as per Yandra)
            //            minutes = 1;
            pData->setUvTime(minutes);
            pData->setUvTimeCountdown(minutes * 60);
        }
    }

    /// Exhaust Contact
    {
        m_pExhaustContact.reset(new DeviceDigitalOut);
        m_pExhaustContact->setSubModule(m_boardRelay1.data());
        m_pExhaustContact->setChannelIO(6);

        connect(m_pExhaustContact.data(), &DeviceDigitalOut::stateChanged,
                pData, [&](int newVal){
            pData->setExhaustContactState(newVal);
        });
    }

    /// Alarm Contact
    {
        m_pAlarmContact.reset(new DeviceDigitalOut);
        m_pAlarmContact->setSubModule(m_boardRelay1.data());
        m_pAlarmContact->setChannelIO(7);

        connect(m_pAlarmContact.data(), &DeviceDigitalOut::stateChanged,
                pData, [&](int newVal){
            pData->setAlarmContactState(newVal);
        });
    }

    /// Particle Counter
    {
        bool particleCounterSensorInstalled = m_settings->value(SKEY_PARTICLE_COUNTER_INST, MachineEnums::DIG_STATE_ZERO).toInt();
        pData->setParticleCounterSensorInstalled(particleCounterSensorInstalled);

        if(pData->getParticleCounterSensorInstalled()) {
            /// find and initializing serial port for fan
            m_serialPort2.reset(new QSerialPort());
            foreach(const QSerialPortInfo &info, QSerialPortInfo::availablePorts()){

                qDebug() << info.vendorIdentifier() << info.productIdentifier();

                if((info.vendorIdentifier() == PARTICLE_COUNTER_UART_VID) &&
                        (info.productIdentifier() == PARTICLE_COUNTER_UART_PID)){

                    m_serialPort2->setPort(info);

                    if(m_serialPort2->open(QIODevice::ReadWrite)){
                        m_serialPort2->setBaudRate(QSerialPort::BaudRate::Baud9600);
                        m_serialPort2->setDataBits(QSerialPort::DataBits::Data8);
                        m_serialPort2->setParity(QSerialPort::Parity::NoParity);
                        m_serialPort2->setStopBits(QSerialPort::StopBits::OneStop);
                    }
                    break;
                }
            }

            //        //// FOR TESTING IN DEVELOPER PC
            //        ////
            //        //        m_serialPort2->setPortName("COM3");
            //        //        m_serialPort2->setPortName("COM7");
            //        m_serialPort2->setPortName("COM10");
            //        m_serialPort2->setBaudRate(QSerialPort::BaudRate::Baud9600);
            //        m_serialPort2->setDataBits(QSerialPort::DataBits::Data8);
            //        m_serialPort2->setParity(QSerialPort::Parity::NoParity);
            //        m_serialPort2->setStopBits(QSerialPort::StopBits::OneStop);
            //        m_serialPort2->open(QIODevice::ReadWrite);
            //        /////

            /// Board is OK and ready to send fan paramaters
            if (!m_serialPort2->isOpen()) {
                qWarning() << metaObject()->className() << __FUNCTION__ << "PARTICLE_COUNTER" << "serial port 2 for particle counter cannot be opened";
                //            pData->setBoardStatusRbmCom(false);
            }
            else {
                qDebug() << metaObject()->className() << "PARTICLE_COUNTER Port open at " << __func__ << m_serialPort2->portName();
            }
            /// initializing the fan object
            m_boardParticleCounterZH03B.reset(new ParticleCounterZH03B);
            /// set the serial port
            m_boardParticleCounterZH03B->setSerialComm(m_serialPort2.data());

            ///set to Q&A Communication mode
            int resp = m_boardParticleCounterZH03B->setQA();
            if(resp != 0){
                qWarning() << metaObject()->className() << __FUNCTION__ << "PARTICLE_COUNTER" << "Failed to set to Q&A Communication Mode";
            }
            else {
                qDebug() << metaObject()->className() << "PARTICLE_COUNTER Q&A Communication Mode " << __func__ << m_serialPort2->portName();
            }

            ///initially turned off Fan
            m_boardParticleCounterZH03B->setDormantMode(MachineEnums::FAN_STATE_OFF);

            /// create object for value keeper
            /// ensure actuator value is what machine value requested
            m_pParticleCounter.reset(new ParticleCounter);

            /// pass the virtual object sub module board
            m_pParticleCounter->setSubModule(m_boardParticleCounterZH03B.data());

            /// create timer for triggering the loop (routine task) and execute any pending request
            /// routine task and any pending task will executed by FIFO mechanism
            m_timerEventForParticleCounter.reset(new QTimer);
            m_timerEventForParticleCounter->setInterval(std::chrono::seconds(5));

            /// create independent thread
            /// looping inside this thread will run parallel* beside machineState loop
            m_threadForParticleCounter.reset(new QThread);

            /// Start timer event when thread was started
            QObject::connect(m_threadForParticleCounter.data(), &QThread::started,
                             m_timerEventForParticleCounter.data(), [&](){
                //            qDebug() << "m_timerEventForFanRbmDsi::started" << thread();
                m_timerEventForParticleCounter->start();
            });

            /// Stop timer event when thread was finished
            QObject::connect(m_threadForParticleCounter.data(), &QThread::finished,
                             m_timerEventForParticleCounter.data(), [&](){
                //            qDebug() << "m_timerEventForFanRbmDsi::finished" << thread();
                m_timerEventForParticleCounter->stop();
            });

            /// Enable triggerOnStarted, calling the worker of FanRbmDsi when thread has started
            /// This is use lambda function, this symbol [&] for pass m_fanRbmDsi object to can captured by lambda
            /// m_pParticleCounter.data(), [&](){m_pParticleCounter->routineTask();});
            QObject::connect(m_threadForParticleCounter.data(), &QThread::started,
                             m_pParticleCounter.data(), [&](){
                m_pParticleCounter->routineTask();
            });

            /// Call routine task fan (syncronazation value)
            /// This method calling by timerEvent
            QObject::connect(m_timerEventForParticleCounter.data(), &QTimer::timeout,
                             m_pParticleCounter.data(), [&](){
                m_pParticleCounter->routineTask();
            });

            /// Run fan loop thread when Machine State goes to looping / routine task
            QObject::connect(this, &MachineBackend::loopStarted,
                             m_threadForParticleCounter.data(), [&](){
                m_threadForParticleCounter->start();
            });

            /// call this when actual blower duty cycle has changed
            QObject::connect(m_pParticleCounter.data(), &ParticleCounter::pm1_0Changed,
                             this, &MachineBackend::_onParticleCounterPM1_0Changed);
            QObject::connect(m_pParticleCounter.data(), &ParticleCounter::pm2_5Changed,
                             this, &MachineBackend::_onParticleCounterPM2_5Changed);
            QObject::connect(m_pParticleCounter.data(), &ParticleCounter::pm10Changed,
                             this, &MachineBackend::_onParticleCounterPM10Changed);
            QObject::connect(m_pParticleCounter.data(), &ParticleCounter::fanStatePaCoChanged,
                             this, &MachineBackend::_onParticleCounterSensorFanStateChanged);

            /// Do move fan routine task / looping to independent thread
            m_pParticleCounter->moveToThread(m_threadForParticleCounter.data());
            /// Do move timer event for fan routine task to independent thread
            /// make the timer has prescission because independent from this Macine State looping
            m_timerEventForParticleCounter->moveToThread(m_threadForParticleCounter.data());
            /// Also move all necesarry object to independent fan thread
            m_serialPort2->moveToThread(m_threadForParticleCounter.data());
            m_boardParticleCounterZH03B->moveToThread(m_threadForParticleCounter.data());
        }
    }//

    /// Measurement Unit
    {
        int meaUnit = m_settings->value(SKEY_MEASUREMENT_UNIT,
                                        MachineEnums::MEA_UNIT_METRIC).toInt();

        pData->setMeasurementUnit(meaUnit);

        ///MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.meaUnit.addr, meaUnit);

        //        qDebug() << "SKEY_MEASUREMENT_UNIT" << meaUnit;
    }

    /// Cabinet Display Name
    /// Also it's used as hotname in network
    {
        QString cabinetDisplayName = m_settings->value(SKEY_CAB_DISPLAY_NAME, "BSC-1").toString();
        QString nameNormalization = QString(cabinetDisplayName).replace("#~#", " ");

        pData->setCabinetDisplayName(nameNormalization);

#ifdef __linux__
        QString idStrCabDisplayName = "esco-centurion-" + cabinetDisplayName;
        /// Set to linux system
        QProcess::execute("hostnamectl", QStringList() << "set-hostname" << idStrCabDisplayName);
#endif
        //        qDebug() << "SKEY_CAB_DISPLAY_NAME" << displayName;
    }//

    /// TEMPERATURE
    {
        m_pTemperature.reset(new Temperature);
        m_pTemperature->setSubModule(m_boardAnalogInput1.data());
        m_pTemperature->setChannelIO(0);

        connect(m_pTemperature.data(), &Temperature::adcChanged,
                pData, &MachineData::setTemperatureAdc);
        connect(m_pTemperature.data(), &Temperature::celciusChanged,
                this, &MachineBackend::_onTemperatureActualChanged);

        /// force update temperature string
        int temp = 0;
        pData->setTemperatureCelcius(temp);

        if (pData->getMeasurementUnit()) {
            pData->setTemperature(temp);
            QString valueStr = QString::asprintf("%d°F", temp);
            pData->setTemperatureValueStrf(valueStr);
        }
        else {
            pData->setTemperature(temp);
            QString valueStr = QString::asprintf("%d°C", temp);
            pData->setTemperatureValueStrf(valueStr);
        }
    }
    /// AIRFLOW MONITOR ENABLE
    {
        bool airflowMonitorEnable = m_settings->value(SKEY_AF_MONITOR_ENABLE, MachineEnums::DIG_STATE_ONE).toBool();
        pData->setAirflowMonitorEnable(airflowMonitorEnable);
    }

    /// AIRFLOW_INFLOW
    {
        ////CREATE INFLOW OBJECT
        m_pAirflowInflow.reset(new AirflowVelocity());
        m_pAirflowInflow->setAIN(m_boardAnalogInput1.data());
        m_pAirflowInflow->setChannel(1);

        /// CONNECTION
        connect(m_pAirflowInflow.data(), &AirflowVelocity::adcConpensationChanged,
                pData, [&](int newVal){
            //            qDebug() << newVal;
            pData->setInflowAdcConpensation(newVal);
            //            qDebug() << "convertADCtomVolt: " << m_boardAnalogInput1->getPAIModule()->convertADCtomVolt(newVal);
        });
        connect(m_pAirflowInflow.data(), &AirflowVelocity::velocityChanged,
                this, &MachineBackend::_onInflowVelocityActualChanged);
        connect(m_pAirflowInflow.data(), &AirflowVelocity::velocityChanged,
                this, &MachineBackend::_calculteDownflowVelocity);

        /// Temperature has effecting to Airflow Reading
        /// so, need to update temperature value on the Airflow Calculation
        connect(m_pTemperature.data(), &Temperature::celciusChanged,
                m_pAirflowInflow.data(), &AirflowVelocity::setTemperature);
    }

    /// SEAS INTEGRATED
    {

        m_pSeas.reset(new PressureDiffManager);
        m_pSeas->setSubModule(m_boardSensirionSPD8xx.data());

        short offset = m_settings->value(SKEY_SEAS_OFFSET_PA, 0).toInt();
        pData->setSeasPressureDiffPaOffset(offset);
        int lowLimit = m_settings->value(SKEY_SEAS_FAIL_POINT_PA, 1000).toInt();
        pData->setSeasPressureDiffPaLowLimit(lowLimit);

        m_pSeas->setOffsetPa(offset);

        //// MONITORING EXHAUST PRESSURE ACTUAL VALUE
        QObject::connect(m_pSeas.data(), &PressureDiffManager::actualPaChanged,
                         this, &MachineBackend::_onSeasPressureDiffPaChanged);

        /// force update pressure text value
        _onSeasPressureDiffPaChanged(0);
    }

    /// LCD Brightness
    {
        short time          = m_settings->value(SKEY_LCD_DELAY_TO_DIMM, 1/*minute*/).toInt();
        short brightness    = m_settings->value(SKEY_LCD_BL, 50).toInt();

        /// SEND TO BOARD
        m_boardCtpIO->setOutputPWM(LEDpca9633_CHANNEL_BL, brightness);

        /// UPDATE INFO
        pData->setLcdBrightnessLevel(brightness);
        pData->setLcdBrightnessLevelUser(brightness);
        pData->setLcdBrightnessDelayToDimm(time);

        /// SETUP TIMER EVENT
        m_timerEventForLcdToDimm.reset(new QTimer);
        m_timerEventForLcdToDimm->setInterval(std::chrono::minutes(time));

        /// CALL THIS FUNCTION WHEN TIMER WAS TRIGGERED
        QObject::connect(m_timerEventForLcdToDimm.data(), &QTimer::timeout,
                         this, &MachineBackend::_onTimerEventLcdDimm);
        ///
        QObject::connect(this, &MachineBackend::loopStarted,
                         [&](){
            m_timerEventForLcdToDimm->start();
        });
    }

    /// Language
    {
        QString langCode = m_settings->value(SKEY_LANGUAGE, "en#0").toString();
        pData->setLanguage(langCode);
    }

    /// TimeZone
    {
        QString tz = m_settings->value(SKEY_TZ, "Asia/Jakarta#7#UTC+07:00").toString();
        pData->setTimeZone(tz);

        //        QElapsedTimer elapsed;
        //        elapsed.start();

        QString location = tz.split("#").first();
        _setTimeZoneLinux(location);

        /// 12h or 24h
        int timeClockPeriod = m_settings->value(SKEY_CLOCK_PERIOD, 12).toInt();
        pData->setTimeClockPeriod(timeClockPeriod);

        //        qDebug () << timeClockPeriod;

        //        qDebug() << __func__ << elapsed.elapsed() << "ms";
    }

    /// Operation Mode
    {
        int value = m_settings->value(SKEY_OPERATION_MODE,
                                      MachineEnums::MODE_OPERATION_QUICKSTART).toInt();
        pData->setOperationMode(value);

        //        qDebug() << "SKEY_OPERATION_MODE" << value;
        /// MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.operationMode.addr, value);
    }

    /// SENSOR TEMPERATURE ENVIRONTMENTAL LIMITATION
    {
        QJsonObject machineProfile = pData->getMachineProfile();
        QJsonObject envTempLimit = machineProfile.value("envTempLimit").toObject();

        short highLimit = envTempLimit.value("highest").toInt();
        short lowLimit  = envTempLimit.value("lowest").toInt();

        highLimit = m_settings->value(SKEY_ENV_TEMP_HIGH_LIMIT, highLimit).toInt();
        lowLimit = m_settings->value(SKEY_ENV_TEMP_LOW_LIMIT, lowLimit).toInt();

        pData->setEnvTempHighestLimit(highLimit);
        pData->setEnvTempLowestLimit(lowLimit);

        //        qDebug() << "SKEY_ELS_ENABLE" << value;
    }

    /// Fan PIN
    {
        /// 00000-md5
        QString value = m_settings->value(SKEY_FAN_PIN,
                                          "dcddb75469b4b4875094e14561e573d8").toString();
        pData->setFanPIN(value);
    }

    /// Security Access Mode
    {
        int value = m_settings->value(SKEY_SECURITY_ACCESS_MODE,
                                      MachineEnums::MODE_SECURITY_ACCESS_SECURE).toInt();
        pData->setSecurityAccessMode(value);

        //        qDebug() << "SKEY_SECURITY_ACCESS_MODE" << value;
    }

    /// Esco Lock Service Enable/Disabled
    {
        /// By default is disabled
        int value = m_settings->value(SKEY_ELS_ENABLE,
                                      MachineEnums::DIG_STATE_ZERO).toInt();
        pData->setEscoLockServiceEnable(value);

        //        qDebug() << "SKEY_ELS_ENABLE" << value;
    }

    /// Certification Expired
    {
        QDate currentDate = QDate::currentDate();
        QString dateText = currentDate.toString("dd-MM-yyyy");

        QString dateExpire = m_settings->value(SKEY_CALENDER_REMAINDER_MODE,dateText).toString();

        pData->setDateCertificationRemainder(dateExpire);

        _checkCertificationReminder();
    }

    /// Airflow Calibration Load + FAN
    {
        QSettings settings;

        int fanNominalDutyCycleFactory  = settings.value(SKEY_FAN_PRI_NOM_DCY_FACTORY, 49).toInt();
        int fanNominalRpmFactory        = settings.value(SKEY_FAN_PRI_NOM_RPM_FACTORY, 0).toInt();

        int fanMinimumDutyCycleFactory  = settings.value(SKEY_FAN_PRI_MIN_DCY_FACTORY, 36).toInt();
        int fanMinimumRpmFactory        = settings.value(SKEY_FAN_PRI_MIN_RPM_FACTORY, 0).toInt();

        int fanStandbyDutyCycleFactory  = settings.value(SKEY_FAN_PRI_STB_DCY_FACTORY, 18).toInt();
        int fanStandbyRpmFactory        = settings.value(SKEY_FAN_PRI_STB_RPM_FACTORY, 0).toInt();

        int fanNominalDutyCycleField    = settings.value(SKEY_FAN_PRI_NOM_DCY_FIELD, 0).toInt();
        int fanNominalRpmField          = settings.value(SKEY_FAN_PRI_NOM_RPM_FIELD, 0).toInt();

        int fanMinimumDutyCycleField    = settings.value(SKEY_FAN_PRI_MIN_DCY_FIELD, 0).toInt();
        int fanMinimumRpmField          = settings.value(SKEY_FAN_PRI_MIN_RPM_FIELD, 0).toInt();

        int fanStandbyDutyCycleField    = settings.value(SKEY_FAN_PRI_STB_DCY_FIELD, 0).toInt();
        int fanStandbyRpmField          = settings.value(SKEY_FAN_PRI_STB_RPM_FIELD, 0).toInt();

        int sensorConstant  = settings.value(SKEY_IFA_SENSOR_CONST, 0).toInt();

        int tempCalib       = settings.value(SKEY_IFA_CAL_TEMP, 0).toInt();
        int tempCalibAdc    = settings.value(SKEY_IFA_CAL_TEMP_ADC, 0).toInt();

        int ifaAdcZeroFactory = settings.value(QString(SKEY_IFA_CAL_ADC_FACTORY) + "0", 0).toInt();
        int ifaAdcMinFactory  = settings.value(QString(SKEY_IFA_CAL_ADC_FACTORY) + "1", 0).toInt();
        int ifaAdcNomFactory  = settings.value(QString(SKEY_IFA_CAL_ADC_FACTORY) + "2", 0).toInt();

        int ifaVelMinFactory  = settings.value(QString(SKEY_IFA_CAL_VEL_FACTORY) + "1", 40).toInt();
        int ifaVelNomFactory  = settings.value(QString(SKEY_IFA_CAL_VEL_FACTORY) + "2", 53).toInt();

        int ifaVelLowAlarm    = settings.value(QString(SKEY_IFA_CAL_VEL_LOW_LIMIT), ifaVelMinFactory).toInt();

        int ifaAdcZeroField   = settings.value(QString(SKEY_IFA_CAL_ADC_FIELD) + "0", 0).toInt();
        int ifaAdcMinField    = settings.value(QString(SKEY_IFA_CAL_ADC_FIELD) + "1", 0).toInt();
        int ifaAdcNomField    = settings.value(QString(SKEY_IFA_CAL_ADC_FIELD) + "2", 0).toInt();

        int ifaVelMinField    = settings.value(QString(SKEY_IFA_CAL_VEL_FIELD) + "1", 0).toInt();
        int ifaVelNomField    = settings.value(QString(SKEY_IFA_CAL_VEL_FIELD) + "2", 0).toInt();

        int dfaVelNomFactory  = settings.value(QString(SKEY_DFA_CAL_VEL_FACTORY) + "2", 0).toInt();
        int dfaVelNomField    = settings.value(QString(SKEY_DFA_CAL_VEL_FIELD) + "2", 0).toInt();

        //        //CALIB PHASE; NONE, FACTORY, or FIELD
        //        //        int afCalibPhase      = settings.value(SKEY_AF_CALIB_PHASE, 0).toInt();
        //        qDebug() << ifaAdcZeroFactory << ifaAdcMinFactory << ifaAdcNomFactory;
        //        qDebug() << ifaVelMinFactory << ifaVelNomFactory;
        //        qDebug() << fanNominalDutyCycleFactory;
        bool calibPhaseFactory =
                (ifaAdcZeroFactory < ifaAdcMinFactory)
                && (ifaAdcMinFactory < ifaAdcNomFactory)
                && (ifaVelMinFactory < ifaVelNomFactory)
                && fanNominalDutyCycleFactory;

        //        qDebug() << ifaAdcZeroField << ifaAdcMinField << ifaAdcNomField;
        //        qDebug() << ifaVelMinField << ifaVelNomField;
        //        qDebug() << fanStandbyDutyCycleField;
        bool calibPhaseField =
                (ifaAdcZeroField < ifaAdcMinField)
                && (ifaAdcMinField< ifaAdcNomField)
                && (ifaVelMinField < ifaVelNomField)
                && fanStandbyDutyCycleField;

        //        calibPhaseFactory = false;
        //        calibPhaseField = false;
        int calibPhase = calibPhaseField
                ? MachineEnums::AF_CALIB_FIELD
                : (calibPhaseFactory ? MachineEnums::AF_CALIB_FACTORY : MachineEnums::AF_CALIB_NONE);
        //        qDebug() << "calibPhase" << calibPhase;

#ifdef QT_DEBUG
        /// Testing purpose
        //        if (fanNominalDutyCycleFactory > 15) fanNominalDutyCycleFactory = 15;
        //        if (fanMinimumDutyCycleFactory > 10) fanMinimumDutyCycleFactory = 10;
        //        if (fanStandbyDutyCycleFactory > 5) fanStandbyDutyCycleFactory = 5;
        //        if (fanNominalDutyCycleField > 10) fanNominalDutyCycleField = 10;
        //        if (fanStandbyDutyCycleField > 5) fanStandbyDutyCycleField = 5;
#endif
        pData->setFanPrimaryNominalDutyCycleFactory(fanNominalDutyCycleFactory);
        pData->setFanPrimaryNominalRpmFactory(fanNominalRpmFactory);

        pData->setFanPrimaryMinimumDutyCycleFactory(fanMinimumDutyCycleFactory);
        pData->setFanPrimaryMinimumRpmFactory(fanMinimumRpmFactory);

        pData->setFanPrimaryStandbyDutyCycleFactory(fanStandbyDutyCycleFactory);
        pData->setFanPrimaryStandbyRpmFactory(fanStandbyRpmFactory);

        pData->setFanPrimaryNominalDutyCycleField(fanNominalDutyCycleField);
        pData->setFanPrimaryNominalRpmField(fanNominalRpmField);

        pData->setFanPrimaryMinimumDutyCycleField(fanMinimumDutyCycleField);
        pData->setFanPrimaryMinimumRpmField(fanMinimumRpmField);

        pData->setFanPrimaryStandbyDutyCycleField(fanStandbyDutyCycleField);
        pData->setFanPrimaryStandbyRpmField(fanStandbyRpmField);

        pData->setInflowSensorConstant(sensorConstant);
        pData->setInflowTempCalib(tempCalib);
        pData->setInflowTempCalibAdc(tempCalibAdc);

        pData->setInflowAdcPointFactory(0, ifaAdcZeroFactory);
        pData->setInflowAdcPointFactory(1, ifaAdcMinFactory);
        pData->setInflowAdcPointFactory(2, ifaAdcNomFactory);

        pData->setInflowVelocityPointFactory(1, ifaVelMinFactory);
        pData->setInflowVelocityPointFactory(2, ifaVelNomFactory);

        pData->setInflowLowLimitVelocity(ifaVelLowAlarm);

        pData->setInflowAdcPointField(0, ifaAdcZeroField);
        pData->setInflowAdcPointField(1, ifaAdcMinField);
        pData->setInflowAdcPointField(2, ifaAdcNomField);

        pData->setInflowVelocityPointField(1, ifaVelMinField);
        pData->setInflowVelocityPointField(2, ifaVelNomField);

        pData->setDownflowVelocityPointFactory(2, dfaVelNomFactory);
        pData->setDownflowVelocityPointField(2, dfaVelNomField);

        initAirflowCalibrationStatus(calibPhase);

        /// force generate velocity string
        _onInflowVelocityActualChanged(0);
        _calculteDownflowVelocity(0);
    }

    /// Output Auto Set
    {
        /// UV SCHEDULER
        {
            m_uvSchedulerAutoSet.reset(new SchedulerDayOutput);

            bool enable    = m_settings->value(SKEY_SCHEO_UV_ENABLE, false).toInt();
            int  time      = m_settings->value(SKEY_SCHEO_UV_TIME, 480/*8:00 AM*/).toInt();
            int  repeat    = m_settings->value(SKEY_SCHEO_UV_REPEAT, SchedulerDayOutput::DAYS_REPEAT_ONCE).toInt();
            int  repeatDay = m_settings->value(SKEY_SCHEO_UV_REPEAT_DAY, SchedulerDayOutput::DAY_MONDAY).toInt();

            pData->setUVAutoEnabled(enable);
            pData->setUVAutoTime(time);
            pData->setUVAutoDayRepeat(repeat);
            pData->setUVAutoWeeklyDay(repeatDay);

            m_uvSchedulerAutoSet->setEnabled(enable);
            m_uvSchedulerAutoSet->setTime(time);
            m_uvSchedulerAutoSet->setDayRepeat(repeat);
            m_uvSchedulerAutoSet->setWeeklyDay(repeatDay);

            /// call this when schedulling spec is same
            QObject::connect(m_uvSchedulerAutoSet.data(), &SchedulerDayOutput::activated,
                             this, &MachineBackend::_onTriggeredUvSchedulerAutoSet);
        }

        /// FAN SCHEDULER
        {
            m_fanSchedulerAutoSet.reset(new SchedulerDayOutput);

            bool enable    = m_settings->value(SKEY_SCHEO_FAN_ENABLE, false).toInt();
            int  time      = m_settings->value(SKEY_SCHEO_FAN_TIME, 480/*8:00 AM*/).toInt();
            int  repeat    = m_settings->value(SKEY_SCHEO_FAN_REPEAT, SchedulerDayOutput::DAYS_REPEAT_ONCE).toInt();
            int  repeatDay = m_settings->value(SKEY_SCHEO_FAN_REPEAT_DAY, SchedulerDayOutput::DAY_MONDAY).toInt();

            pData->setFanAutoEnabled(enable);
            pData->setFanAutoTime(time);
            pData->setFanAutoDayRepeat(repeat);
            pData->setFanAutoWeeklyDay(repeatDay);

            m_fanSchedulerAutoSet->setEnabled(enable);
            m_fanSchedulerAutoSet->setTime(time);
            m_fanSchedulerAutoSet->setDayRepeat(repeat);
            m_fanSchedulerAutoSet->setWeeklyDay(repeatDay);

            /// call this when schedulling spec is same
            QObject::connect(m_fanSchedulerAutoSet.data(), &SchedulerDayOutput::activated,
                             this, &MachineBackend::_onTriggeredFanSchedulerAutoSet);
        }
    }

    /// DATA LOG
    {
        short enable = m_settings->value(SKEY_DATALOG_ENABLE, 1).toInt();
        short period = m_settings->value(SKEY_DATALOG_PERIOD, 10).toInt(); /// default every 10 minutes

        pData->setDataLogEnable(enable);
        pData->setDataLogPeriod(period);
        pData->setDataLogSpaceMaximum(DATALOG_MAX_ROW);

        m_timerEventForDataLog.reset(new QTimer);
        m_timerEventForDataLog->setInterval(period * 1 * 1000);
        ///
        QObject::connect(m_timerEventForDataLog.data(), &QTimer::timeout,
                         this, &MachineBackend::_insertDataLog);
        ///
        if(enable) {
            QObject::connect(this, &MachineBackend::loopStarted,
                             [&](){
                pData->setDataLogRunning(true);
                m_timerEventForDataLog->start();
            });
        }

        m_pDataLogSql.reset(new DataLogSql);
        m_pDataLog.reset(new DataLog);
        m_pDataLog->setPSqlInterface(m_pDataLogSql.data());

        m_threadForDatalog.reset(new QThread);
        /// move the object to extra thread, so every query will execute in the separated thread
        m_pDataLog->moveToThread(m_threadForDatalog.data());
        m_pDataLogSql->moveToThread(m_threadForDatalog.data());

        QObject::connect(m_threadForDatalog.data(), &QThread::started,
                         m_pDataLog.data(), [&](){
            m_pDataLog->routineTask();
        });
        QObject::connect(this, &MachineBackend::loopStarted,
                         [&](){
            m_threadForDatalog->start();
        });
    }

    /// ALARM LOG
    {
        m_pAlarmLogSql.reset(new AlarmLogSql);
        m_pAlarmLog.reset(new AlarmLog);
        m_pAlarmLog->setPSqlInterface(m_pAlarmLogSql.data());

        pData->setAlarmLogSpaceMaximum(ALARMEVENTLOG_MAX_ROW);

        m_threadForAlarmLog.reset(new QThread);
        /// move the object to extra thread, so every query will execute in the separated thread
        m_pAlarmLog->moveToThread(m_threadForAlarmLog.data());
        m_pAlarmLogSql->moveToThread(m_threadForAlarmLog.data());

        QObject::connect(m_threadForAlarmLog.data(), &QThread::started,
                         m_pAlarmLog.data(), [&](){
            m_pAlarmLog->routineTask();
        });
        QObject::connect(this, &MachineBackend::loopStarted,
                         [&](){
            m_threadForAlarmLog->start();
        });
    }

    /// EVENT LOG
    {
        m_pEventLogSql.reset(new EventLogSql);
        m_pEventLog.reset(new EventLog);
        m_pEventLog->setPSqlInterface(m_pEventLogSql.data());

        pData->setEventLogSpaceMaximum(ALARMEVENTLOG_MAX_ROW);

        m_threadForEventLog.reset(new QThread);
        /// move the object to extra thread, so every query will execute in the separated thread
        m_pEventLog->moveToThread(m_threadForEventLog.data());
        m_pEventLogSql->moveToThread(m_threadForEventLog.data());

        QObject::connect(m_threadForEventLog.data(), &QThread::started,
                         m_pEventLog.data(), [&](){
            m_pEventLog->routineTask();
        });
        QObject::connect(this, &MachineBackend::loopStarted,
                         [&](){
            m_threadForEventLog->start();
        });
    }

    /// Sensor Warming up
    {
        int minutes = m_settings->value(SKEY_WARMUP_TIME, 3).toInt(); //3 minutes
        pData->setWarmingUpTime(minutes);
        pData->setWarmingUpCountdown(minutes * 60);
    }

    /// Post purging
    {
        int minutes = m_settings->value(SKEY_POSTPURGE_TIME, 0).toInt(); //0 minutes, disabled
        pData->setPostPurgingTime(minutes);
        pData->setPostPurgingCountdown(minutes * 60);
    }

    /// Filter Meter
    {
        int minutes = m_settings->value(SKEY_FILTER_METER, SDEF_FILTER_MAXIMUM_TIME_LIFE).toInt();
        int minutesPercentLeft = __getPercentFrom(minutes, SDEF_FILTER_MAXIMUM_TIME_LIFE);
        /// event if in % value is zero but the minutes more then 0 minutes, then set % to 1
        if (minutesPercentLeft == 0 && minutes > 0) minutesPercentLeft = 1;

        //update to global observable variable
        pData->setFilterLifeMinutes(minutes);
        pData->setFilterLifePercent(minutesPercentLeft);

        ///MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.filterLife.addr, minutesPercentLeft);
    }

    /// Sash Cycle Meter
    {
        /// the formula for the sash cycle value for tubular motor is
        /// Every attached break point if the previous sash state is safe height, will be increase 0.5 step
        /// in the program value will counting
        int cycle = m_settings->value(SKEY_SASH_CYCLE_METER, MachineEnums::DIG_STATE_ZERO).toInt();

        //update to global observable variable
        pData->setSashCycleMeter(cycle);

        ///MODBUS
        //        _setModbusRegHoldingValue(modbusRegisterAddress.filterLife.addr, minutesPercentLeft);
    }

    /// FAN Usage Meter
    {
        int minutes = m_settings->value(SKEY_FAN_METER, MachineEnums::DIG_STATE_ZERO).toInt();
        //        minutes = 1000;

        //update to global observable variable
        pData->setFanUsageMeter(minutes);
    }

    /// Mute Audible Alarm
    {
        int minutes = m_settings->value(SKEY_MUTE_ALARM_TIME, 5).toInt(); //3 minutes
        //        minutes = 1;
        pData->setMuteAlarmTime(minutes);
        pData->setMuteAlarmCountdown(minutes * 60);
    }

    /// Serial Number
    {
        QString year_sn = QDate::currentDate().toString("yyyy-000000");
        QString sn = m_settings->value(SKEY_SERIAL_NUMMBER, year_sn).toString();
        pData->setSerialNumber(sn);
    }

    /// JUST TIMER for triggering action by time
    {
        m_timerEventEverySecond.reset(new QTimer);
        m_timerEventEverySecond->setInterval(std::chrono::seconds(1));

        QObject::connect(m_timerEventEverySecond.data(), &QTimer::timeout,
                         this, &MachineBackend::_onTriggeredEventEverySecond);
        QObject::connect(this, &MachineBackend::loopStarted, [&]{
            m_timerEventEverySecond->start();
        });

        m_timerEventEveryMinute.reset(new QTimer);
        m_timerEventEveryMinute->setInterval(std::chrono::minutes(1));

        QObject::connect(m_timerEventEveryMinute.data(), &QTimer::timeout,
                         this, &MachineBackend::_onTriggeredEventEveryMinute);
        QObject::connect(this, &MachineBackend::loopStarted, [&]{
            m_timerEventEveryMinute->start();
        });

        m_timerEventEveryHour.reset(new QTimer);
        m_timerEventEveryHour->setInterval(std::chrono::hours(1));

        QObject::connect(m_timerEventEveryMinute.data(), &QTimer::timeout,
                         this, &MachineBackend::_onTriggeredEventEveryHour);
        QObject::connect(this, &MachineBackend::loopStarted, [&]{
            m_timerEventEveryHour->start();
        });
    }

    ///Shipping Mode
    {
        bool shippingMode = m_settings->value(SKEY_SHIPPING_MOD_ENABLE, MachineEnums::DIG_STATE_ZERO).toInt();
        pData->setShippingModeEnable(shippingMode);
        if(shippingMode){
            pData->setOperationMode(MachineEnums::MODE_OPERATION_MAINTENANCE);
        }
    }

    //// Don't care power outage while shipping mode active
    if(!pData->getShippingModeEnable()){
        /// Power outage
        {
            short poweroutage = m_settings->value(SKEY_POWER_OUTAGE, MachineEnums::DIG_STATE_ZERO).toInt();
            m_settings->setValue(SKEY_POWER_OUTAGE, MachineEnums::DIG_STATE_ZERO);
            //        qDebug() << __func__ << "poweroutage" << poweroutage;

            short uvState    = m_settings->value(SKEY_POWER_OUTAGE_UV, MachineEnums::DIG_STATE_ZERO).toInt();
            //        qDebug() << SKEY_POWER_OUTAGE_UV << uvState;
            /// clear the flag
            m_settings->setValue(SKEY_POWER_OUTAGE_UV, MachineEnums::DIG_STATE_ZERO);
            pData->setPowerOutageUvState(uvState);

            short fanState   = m_settings->value(SKEY_POWER_OUTAGE_FAN, MachineEnums::DIG_STATE_ZERO).toInt();
            //        qDebug() << SKEY_POWER_OUTAGE_FAN << uvState;
            /// clear the flag
            m_settings->setValue(SKEY_POWER_OUTAGE_FAN, MachineEnums::DIG_STATE_ZERO);
            pData->setPowerOutageFanState(fanState);

            //update to global observable variable
            if(poweroutage) {
                QString poweroutageTime = m_settings->value(SKEY_POWER_OUTAGE_TIME, "").toString();
                QString poweroutageRecoverTime = QDateTime().currentDateTime().toString("dd-MMM-yyyy hh:mm");
                //            qDebug() << "poweroutageTime:" << poweroutageTime << "poweroutageRecoverTime: " << poweroutageRecoverTime;

                ///event log
                QString failureMsg = EVENT_STR_POWER_FAILURE + " " + poweroutageTime;
                _insertEventLog(failureMsg);

                pData->setPowerOutage(poweroutage);
                pData->setPowerOutageTime(poweroutageTime);
                pData->setPowerOutageRecoverTime(poweroutageRecoverTime);

                switch (pData->getSashWindowState()) {
                case MachineEnums::SASH_STATE_ERROR_SENSOR_SSV:
                    /// NOTHING TODO
                    break;
                case MachineEnums::SASH_STATE_FULLY_CLOSE_SSV:
                {
                    m_pUV->setState(uvState);
                }
                    break;
                default:
                {
                    if(fanState) {
                        short dutyCycle = pData->getFanPrimaryNominalDutyCycle();
                        switch (fanState) {
                        case MachineEnums::FAN_STATE_ON:
                            ///Force turned on light if the blower is nominal
                            m_pLight->setInterlock(MachineEnums::DIG_STATE_ZERO);
                            m_pLight->setState(MachineEnums::DIG_STATE_ONE);
                            m_pLight->routineTask();
                            m_i2cPort->sendOutQueue();
                            break;
                        case MachineEnums::FAN_STATE_STANDBY:
                            dutyCycle = pData->getFanPrimaryStandbyDutyCycle();
                            break;
                        }

                        m_pFanPrimary->setDutyCycle(pData->getFanPrimaryNominalDutyCycle());
                        m_pFanPrimary->routineTask();
                        /// wait until fan actually turned on or exceed the time out (10 seconds)
                        for (int var = 0; var < 10; ++var) {
                            m_pFanPrimary->routineTask();
                            if(m_pFanPrimary->dutyCycle() == dutyCycle){
                                //                            qDebug() << __func__ << "Power outage - Fan State Changed" << var;
                                _onFanPrimaryActualDucyChanged(dutyCycle);
                                break;
                            }
                            QThread::sleep(1);
                        }
                    }
                }
                    break;
                }
            }
        }
    }

    /// Buzzer indication
    {
        /// give finished machine backend setup
        m_pBuzzer->setState(MachineEnums::DIG_STATE_ONE);
        sleep(1);
        m_pBuzzer->setState(MachineEnums::DIG_STATE_ZERO);
    }

    ///event log
    _insertEventLog(EVENT_STR_POWER_ON);

    /// WATCHDOG
    /// connect watchdog brigde, now watchdog event from RTC can reset the SBC if counter timeout
    m_boardCtpIO->setOutputAsDigital(LEDpca9633_CHANNEL_WDG, MachineEnums::DIG_STATE_ZERO,
                                     I2CPort::I2C_SEND_MODE_DIRECT);
    /// restart counter number
    m_boardCtpRTC->setTimerACount(SDEF_WATCHDOG_PERIOD, I2CPort::I2C_SEND_MODE_DIRECT);
    /// enable event to restart countdown wtachdog
    m_timerEventForRTCWatchdogReset->start();

    /// Change value to loop, routine task
    pData->setMachineBackendState(MachineEnums::MACHINE_STATE_LOOP);
    /// GIVE A SIGNAL
    emit loopStarted();

#ifdef QT_DEBUG
    m_pWebSocketServerDummyState.reset(new QWebSocketServer(qAppName(), QWebSocketServer::NonSecureMode));
    bool ok = m_pWebSocketServerDummyState->listen(QHostAddress::Any, 8789);
    if (ok){
        connect(m_pWebSocketServerDummyState.data(), &QWebSocketServer::newConnection,
                this, &MachineBackend::onDummyStateNewConnection);
    }
#endif
}

void MachineBackend::loop()
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    /// Just execute for the first cycle loop
    if (m_loopStarterTaskExecute) {
        m_loopStarterTaskExecute  = false;
        qInfo() << metaObject()->className() << __FUNCTION__ << "loopStarterTaskExecute";
    }

    /// READ_SENSOR
    /// put any read sensor routineTask in here
    m_pSashWindow->routineTask();
    m_pTemperature->routineTask();
    m_pAirflowInflow->routineTask();
    if(pData->getSeasInstalled()) { m_pSeas->routineTask(); }

    /// PROCESSING
    /// put any processing/machine value condition in here
    //    pData->setCount(pData->getCount() + 1);
    //    _onInflowVelocityActualChanged(pData->getCount() + 100);
    _machineState();

    /// ACTUATOR
    /// put any actuator routine task in here
    m_pSasWindowMotorize->routineTask();
    m_pFanInflow->routineTask();
    m_pLight->routineTask();
    m_pLightIntensity->routineTask();
    if(pData->getSocketInstalled()) m_pSocket->routineTask();
    if(pData->getGasInstalled()) m_pGas->routineTask();
    if(pData->getUvInstalled()) m_pUV->routineTask();
    m_pExhaustContact->routineTask();
    m_pAlarmContact->routineTask();
    //    m_pExhaustPressure->routineTask();

    if(m_stop){
        pData->setMachineBackendState(MachineEnums::MACHINE_STATE_STOP);
    }
}

void MachineBackend::deallocate()
{
    ///Guard to ensure the followng function called once from event timer proxy
    if(m_deallocatting) return;
    m_deallocatting = true;

    ///event log
    _insertEventLog(EVENT_STR_POWER_OFF);

    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-1";

    //// CLOSE WATCHDOG GATE
    //// THIS PIN CONNECTED TO MOSFET NPN
    //// DISCONNECT WATCHDOG EFFECT
    m_boardCtpIO->setOutputAsDigital(LEDpca9633_CHANNEL_WDG, MachineEnums::DIG_STATE_ONE);

    /// Shutting down modbus communication
    m_pModbusServer->disconnectDevice();

    m_timerEventEverySecond->stop();
    m_timerEventEveryMinute->stop();
    m_timerEventEveryHour->stop();
    m_timerEventForDataLog->stop();
    m_timerEventForLcdToDimm->stop();
    m_timerEventForRTCWatchdogReset->stop();

    /// turned off the blower
    if(pData->getFanPrimaryState()){
        _setFanPrimaryStateOFF();
        QEventLoop waitLoop;
        /// https://www.kdab.com/nailing-13-signal-slot-mistakes-clazy-1-3/
        QObject::connect(m_pFanPrimary.data(), &BlowerRbmDsi::dutyCycleChanged,
                         &waitLoop, [this, &waitLoop] (int dutyCycle){
            //            qDebug() << "waitLoop" << dutyCycle;
            if (dutyCycle == 0){
                waitLoop.quit();
            }
            else {
                _setFanPrimaryStateOFF();
            }
        });
        waitLoop.exec();
    }

    //    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-2";
    if(m_threadForBoardIO){
        m_threadForBoardIO->quit();
        m_threadForBoardIO->wait();
    }

    //    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-3";

    if(m_threadForFanRbmDsi){
        m_threadForFanRbmDsi->quit();
        m_threadForFanRbmDsi->wait();
    }

    //    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-4";

    if(m_threadForDatalog){
        m_threadForDatalog->quit();
        m_threadForDatalog->wait();
    }

    //    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-5";

    if(m_threadForAlarmLog){
        m_threadForAlarmLog->quit();
        m_threadForAlarmLog->wait();
    }

    //    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-6";

    if(m_threadForEventLog){
        m_threadForEventLog->quit();
        m_threadForEventLog->wait();
    }

    if(m_threadForParticleCounter){
        m_threadForParticleCounter->quit();
        m_threadForParticleCounter->wait();
    }

    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-7";

    /// turned off all the relays
    m_boardRelay1->setAllPWM(MachineEnums::DIG_STATE_ZERO);
    //    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-9";

    /// Increse brightness
    m_boardCtpIO->setOutputPWM(LEDpca9633_CHANNEL_BL, 70);

    /// Buzzer indication
    {
        /// give finished tone of machine backend setup
        m_pBuzzer->setState(MachineEnums::DIG_STATE_ONE);
        sleep(1);
        m_pBuzzer->setState(MachineEnums::DIG_STATE_ZERO);
    }

    qDebug() << metaObject()->className() << __FUNCTION__ << "will hasStopped" << thread();
    emit hasStopped();
}

/////////////////////////////////////////////////// API Group for General Object Operation

void MachineBackend::setMachineData(MachineData *data)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << data << thread();
    pData = data;
}

void MachineBackend::stop()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    m_stop = true;
}

void MachineBackend::setLcdTouched()
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    /// Wake up LCD Brightness Level
    _wakeupLcdBrightnessLevel();
}

void MachineBackend::setLcdBrightnessLevel(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    pData->setLcdBrightnessLevel(value);
    pData->setLcdBrightnessLevelUser(value);

    m_boardCtpIO->setOutputPWM(LEDpca9633_CHANNEL_BL, value, I2CPort::I2C_SEND_MODE_QUEUE);
}

void MachineBackend::setLcdBrightnessDelayToDimm(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_LCD_DELAY_TO_DIMM, value);
    pData->setLcdBrightnessDelayToDimm(value);

    m_timerEventForLcdToDimm->setInterval(std::chrono::minutes(value));
}

void MachineBackend::saveLcdBrightnessLevel(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();
    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_LCD_BL, value);
}

void MachineBackend::saveLanguage(const QString value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    pData->setLanguage(value);
    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_LANGUAGE, value);
}

/**
 * @brief MachineBackend::setTimeZone
 * @param value
 * expected value: timezonelocation#offset#utcnotanion
 * example: Asia/Jakarta#7#UTC+07:00
 * this function took time about 800 ms, so need implementing on the Concurrent
 */
void MachineBackend::setTimeZone(const QString value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    QFuture<void> future = QtConcurrent::run([&, value](){

        QStringList data = value.split("#", Qt::SkipEmptyParts);

        if (data.length() == 3) {

            QString locationTimeZone = data[0];
            _setTimeZoneLinux(locationTimeZone);
        }
    });

    pData->setTimeZone(value);
    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_TZ, value);
}

/**
 * @brief MachineBackend::setDateTime
 * @param value
 * To set date only, we can use a set-time switch along with the format of date in YY:MM:DD (Year, Month, Day).
 * example: timedatectl set-time 2015-11-20
 * To set time only, we can use a set-time switch along with the format of time in HH:MM:SS (Hour, Minute, and Seconds).
 * example: timedatectl set-time 15:58:30
 * This execution need about 9,6 seconds to finish. So, need run on other thread / Asyncronous
 */
void MachineBackend::setDateTime(const QString value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    QFuture<void> future = QtConcurrent::run([&, value]{
        _setDateTimeLinux(value);
    });

#ifdef __arm__
    QDateTime dateValidation = QDateTime::fromString(value, "yyyy-MM-dd hh:mm:ss");
    if(dateValidation.isValid()) {
        qDebug() << metaObject()->className() << __FUNCTION__ << "Set to RTC" << value;

        m_boardCtpRTC->setClock(dateValidation.time().hour(),
                                dateValidation.time().minute(),
                                dateValidation.time().second(),
                                I2CPort::I2C_SEND_MODE_QUEUE);
        m_boardCtpRTC->setDate(dateValidation.date().weekNumber(),
                               dateValidation.date().day(),
                               dateValidation.date().month(),
                               dateValidation.date().year(),
                               I2CPort::I2C_SEND_MODE_QUEUE);
    }
#endif
}

void MachineBackend::saveTimeClockPeriod(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    //    QElapsedTimer elapsed;
    //    elapsed.start();

    pData->setTimeClockPeriod(value);
    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_CLOCK_PERIOD, value);

    //    qDebug() << __func__ << elapsed.elapsed() << "ms";
}

void MachineBackend::deleteFileOnSystem(const QString path)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << path << thread();

    QString pathFilter = path;
#ifdef WIN32
    pathFilter.replace("file:///C", "c");
#elif __linux__
    pathFilter.replace("file://", "");
#endif

    if(QFile::exists(pathFilter)) {
        bool removed = QFile::remove(pathFilter);
        qInfo() << metaObject()->className() << __FUNCTION__ << pathFilter << removed;
    }
    else {
        qDebug() << metaObject()->className() << __FUNCTION__ << pathFilter << "does not exist!" << thread();
    }
}

void MachineBackend::setMuteVivariumState(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    pData->setMuteAlarmState(value);
    if(value) {
        _startMuteAlarmTimer();
        pData->setVivariumMuteState(value);
    }
    else {
        _cancelMuteAlarmTimer();
    }

    m_pBuzzer->setState(MachineEnums::DIG_STATE_ZERO);
}

void MachineBackend::setMuteAlarmState(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    pData->setMuteAlarmState(value);
    if(value) {
        _startMuteAlarmTimer();
    }
    else {
        _cancelMuteAlarmTimer();
    }

    m_pBuzzer->setState(MachineEnums::DIG_STATE_ZERO);
}

void MachineBackend::setMuteAlarmTime(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    pData->setMuteAlarmTime(value);
    int seconds = value * 60;
    pData->setMuteAlarmCountdown(seconds);

    QSettings settings;
    settings.setValue(SKEY_MUTE_ALARM_TIME, value);
}

void MachineBackend::setBuzzerState(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    m_pBuzzer->setState(value);
}

void MachineBackend::setBuzzerBeep()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    m_pBuzzer->setState(MachineEnums::DIG_STATE_ONE);

    /// future auto turned off
    m_timerEventForBuzzerBeep.reset(new QTimer);
    m_timerEventForBuzzerBeep->setSingleShot(MachineEnums::DIG_STATE_ONE);
    m_timerEventForBuzzerBeep->start(100);
    QObject::connect(m_timerEventForBuzzerBeep.data(), &QTimer::timeout, this, [&](){
        m_pBuzzer->setState(MachineEnums::DIG_STATE_ZERO);
        //        qDebug() << "buzzer beep off";
    });
}

void MachineBackend::setSignedUser(const QString username, const QString fullname)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << username << fullname;

    m_signedUsername = username;
    m_signedFullname = fullname;
}

void MachineBackend::setDataLogEnable(bool dataLogEnable)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    pData->setDataLogEnable(dataLogEnable);

    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_DATALOG_ENABLE, dataLogEnable ? 1 : 0);
}

void MachineBackend::setDataLogRunning(bool dataLogRunning)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if(dataLogRunning) m_timerEventForDataLog->start();
    else m_timerEventForDataLog->stop();

    pData->setDataLogRunning(dataLogRunning);
}

void MachineBackend::setDataLogPeriod(short dataLogPeriod)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << dataLogPeriod;

    m_timerEventForDataLog->setInterval(dataLogPeriod * 1 * 1000); /// convert minute to ms
    if(pData->getDataLogEnable()) m_timerEventForDataLog->start();

    pData->setDataLogPeriod(dataLogPeriod);

    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_DATALOG_PERIOD, dataLogPeriod);
}

void MachineBackend::setDataLogCount(int dataLogCount)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    pData->setDataLogCount(dataLogCount);
    pData->setDataLogIsFull(dataLogCount >= DATALOG_MAX_ROW);
}

void MachineBackend::setModbusSlaveID(short slaveId)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << slaveId;

    pData->setModbusSlaveID(slaveId);
    m_pModbusServer->setServerAddress(slaveId);

    QSettings settings;
    settings.setValue(SKEY_MODBUS_SLAVE_ID, slaveId);
}

void MachineBackend::setModbusAllowingIpMaster(const QString ipAddr)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << ipAddr;

    if(ipAddr == pData->getModbusAllowIpMaster()) return;

    pData->setModbusAllowIpMaster(ipAddr);
    QSettings settings;
    settings.setValue(SKEY_MODBUS_ALLOW_IP, ipAddr);

    m_pModbusServer->disconnectDevice();
    m_pModbusServer->connectDevice();
}

void MachineBackend::setModbusAllowSetFan(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    modbusRegisterAddress.fanState.rw = value;
    pData->setModbusAllowSetFan(value);
    QSettings settings;
    settings.setValue(SKEY_MODBUS_RW_FAN, value ? 1 : 0);
}

void MachineBackend::setModbusAllowSetLight(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    modbusRegisterAddress.lightState.rw = value;
    pData->setModbusAllowSetLight(value);
    QSettings settings;
    settings.setValue(SKEY_MODBUS_RW_LAMP, value ? 1 : 0);
}

void MachineBackend::setModbusAllowSetLightIntensity(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    modbusRegisterAddress.lightIntensity.rw = value;
    pData->setModbusAllowSetLightIntensity(value);
    QSettings settings;
    settings.setValue(SKEY_MODBUS_RW_LAMP_DIMM, value ? 1 : 0);
}

void MachineBackend::setModbusAllowSetSocket(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    modbusRegisterAddress.socketState.rw = value;
    pData->setModbusAllowSetSocket(value);
    QSettings settings;
    settings.setValue(SKEY_MODBUS_RW_SOCKET, value ? 1 : 0);
}

void MachineBackend::setModbusAllowSetGas(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    modbusRegisterAddress.gasState.rw = value;
    pData->setModbusAllowSetGas(value);
    QSettings settings;
    settings.setValue(SKEY_MODBUS_RW_GAS, value ? 1 : 0);
}

void MachineBackend::setModbusAllowSetUvLight(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    modbusRegisterAddress.uvState.rw = value;
    pData->setModbusAllowSetUvLight(value);
    QSettings settings;
    settings.setValue(SKEY_MODBUS_RW_UV, value ? 1 : 0);
}

void MachineBackend::setOperationModeSave(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if(pData->getOperationMode() == value) return;

    m_operationPrevMode = value;
    pData->setOperationMode(value);

    if(value != MachineEnums::MODE_OPERATION_MAINTENANCE) {
        QScopedPointer<QSettings> m_settings(new QSettings);
        m_settings->setValue(SKEY_OPERATION_MODE, value);
    }

    ///MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.operationMode.addr, value);
}

void MachineBackend::setOperationMaintenanceMode()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    m_operationPrevMode = pData->getOperationMode();
    pData->setOperationMode(MachineEnums::MODE_OPERATION_MAINTENANCE);

    ///MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.operationMode.addr, MachineEnums::MODE_OPERATION_MAINTENANCE);
}

void MachineBackend::setOperationPreviousMode()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    pData->setOperationMode(m_operationPrevMode);

    ///MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.operationMode.addr, m_operationPrevMode);
}

void MachineBackend::setSecurityAccessModeSave(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << "securiy status check";
    pData->setSecurityAccessMode(value);

    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_SECURITY_ACCESS_MODE,value);
}

void MachineBackend::setDateCertificationRemainder(const QString remainder)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    pData->setDateCertificationRemainder(remainder);

    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_CALENDER_REMAINDER_MODE,remainder);

    qDebug() << "tanggal" << remainder;

    _checkCertificationReminder();
}

//void MachineBackend::setCertificationExpired(bool certificationExpired)
//{
//    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

//    QDateTime dateTime = QDateTime::currentDateTime();
//    QString dateText = dateTime.toString("dd-MM-yyyy");
//    QString timeText = dateTime.toString("hh:mm:ss");

////    pData->setCertificationExpired(SKEY_CALENDER_REMAINDER_MODE == dateText);
//}


//void MachineBackend::setSaveMachineProfileName(const QString value)
//{
//    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

//    QSettings settings;
//    settings.setValue(SKEY_MACH_PROFILE, value);

//    pData->setMachineProfileName(value);
//}

///**
// * @brief MachineBackend::saveMachineProfile
// * @param value
// * consume about saveMachineProfile 8 ms
// */
//void MachineBackend::saveMachineProfile(const QJsonObject value)
//{
//    //    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

//    //    QElapsedTimer elapsed;
//    //    elapsed.start();

//    QJsonDocument doc(value);
//    QByteArray docByteArray = doc.toJson(QJsonDocument::Compact);
//    QString strJson = QLatin1String(docByteArray);

//    QSettings settings;
//    settings.beginGroup(SKEY_MACH_PROFILE);
//    settings.setValue(SKEY_MACH_PROFILE, strJson);
//    settings.endGroup();

//    pData->setMachineProfileName(value.value("name").toString());

//    //    qDebug() << __func__ << elapsed.elapsed() << "ms";
//}

///**
// * @brief MachineBackend::readMachineProfile
// */
//void MachineBackend::readMachineProfile()
//{
//    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

//    QElapsedTimer elapsed;
//    elapsed.start();

//    QSettings settings;
//    settings.beginGroup(SKEY_MACH_PROFILE);
//    QString profileStr = settings.value(SKEY_MACH_PROFILE, "{}").toString();
//    settings.endGroup();

//    //    qDebug() << "profileStr" << profileStr;

//    QJsonDocument jDoc = QJsonDocument::fromJson(profileStr.toLocal8Bit());

//    if(jDoc.isNull()) {
//        qWarning() << __func__ << "failed at jdoc";
//        return;
//    }

//    if(!jDoc.isObject()) {
//        qWarning() << __func__ << "failed at object";
//        return;
//    }

//    QJsonObject jObj = jDoc.object();

//    pData->setMachineProfile(jObj);

//    qDebug() << __func__ << elapsed.elapsed() << "ms";
//}

void MachineBackend::setMeasurementUnit(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    if(value == pData->getMeasurementUnit()) return;

    pData->setMeasurementUnit(value);

    {
        QSettings settings;
        settings.setValue(SKEY_MEASUREMENT_UNIT, value);
    }

    /// force update temperature value and temperature strf
    _onTemperatureActualChanged(pData->getTemperatureCelcius());

    /// Not calibrated yet
    //    qDebug() << __func__ << "getAirflowCalibrationStatus" << pData->getAirflowCalibrationStatus();
    if(pData->getAirflowCalibrationStatus() == MachineEnums::AF_CALIB_NONE) return;

    /// convert calibration airflow value to target measurement unit
    int velPointMinFactory      = pData->getInflowVelocityPointFactory(1);
    int velPointNomFactory      = pData->getInflowVelocityPointFactory(2);
    int velPointMinField        = pData->getInflowVelocityPointField(1);
    int velPointNomField        = pData->getInflowVelocityPointField(2);
    int dfaVelPointNomFactory   = pData->getDownflowVelocityPointFactory(2);
    int dfaVelPointNomField     = pData->getDownflowVelocityPointField(2);
    int tempCalib               = pData->getInflowTempCalib();

    int velPointLowAlarm        = pData->getInflowLowLimitVelocity();

    int tempCelsius            = pData->getTemperatureCelcius();
    //    ///test
    //    velPointMinFactory  = !value ? 7900 : 40;
    //    velPointNomFactory  = !value ? 10500 : 53;
    //    velPointMinField    = !value ? 7900 : 40;
    //    velPointNomField    = !value ? 10500 : 53;
    //    tempCalib           = !value ? 7700 : 25;

    int _velPointLowAlarm;
    int _velPointMinFactory, _velPointNomFactory, _velPointMinField,_velPointNomField;
    int _dfaVelPointNomFactory, _dfaVelPointNomField;
    int _tempCalib;
    int _tempCelsius = tempCelsius;
    int _tempFahrenheit = __convertCtoF(tempCelsius);

    if (value) {
        //        qDebug() << "__convertMpsToFpm" ;
        /// Imperial
        _velPointMinFactory  = qCeil(__convertMpsToFpm(velPointMinFactory) / 100.0) * 100;
        _velPointNomFactory  = qCeil(__convertMpsToFpm(velPointNomFactory) / 100.0) * 100;
        _velPointMinField    = qCeil(__convertMpsToFpm(velPointMinField) / 100.0) * 100;
        _velPointNomField    = qCeil(__convertMpsToFpm(velPointNomField) / 100.0) * 100;

        _velPointLowAlarm    = qCeil(__convertMpsToFpm(velPointLowAlarm) / 100.0) * 100;

        _dfaVelPointNomFactory  = qCeil(__convertMpsToFpm(dfaVelPointNomFactory) / 100.0) * 100;
        _dfaVelPointNomField    = qCeil(__convertMpsToFpm(dfaVelPointNomField) / 100.0) * 100;

        _tempCalib = __convertCtoF(tempCalib);

        pData->setTemperature(_tempFahrenheit);
        QString valueStr = QString::asprintf("%d°F", _tempFahrenheit);
        pData->setTemperatureValueStrf(valueStr);

    } else {
        //        qDebug() << "__convertFpmToMps" ;
        /// metric
        _velPointMinFactory  = qRound(__convertFpmToMps(velPointMinFactory / 100.0) * 100);
        _velPointNomFactory  = qRound(__convertFpmToMps(velPointNomFactory / 100.0) * 100);
        _velPointMinField    = qRound(__convertFpmToMps(velPointMinField  / 100.0) * 100);
        _velPointNomField    = qRound(__convertFpmToMps(velPointNomField  / 100.0) * 100);

        _velPointLowAlarm    = qRound(__convertFpmToMps(velPointNomField  / 100.0) * 100);

        _dfaVelPointNomFactory  = qRound(__convertFpmToMps(dfaVelPointNomFactory / 100.0) * 100);
        _dfaVelPointNomField    = qRound(__convertFpmToMps(dfaVelPointNomField / 100.0) * 100);

        _tempCalib = __convertFtoC(tempCalib);

        pData->setTemperature(_tempCelsius);
        QString valueStr = QString::asprintf("%d°C", _tempCelsius);
        pData->setTemperatureValueStrf(valueStr);
    }

    /// set to data
    pData->setInflowVelocityPointFactory(1, _velPointMinFactory);
    pData->setInflowVelocityPointFactory(2, _velPointNomFactory);
    pData->setInflowVelocityPointField(1, _velPointMinField);
    pData->setInflowVelocityPointField(2, _velPointNomField);
    pData->setDownflowVelocityPointFactory(2, _dfaVelPointNomFactory);
    pData->setDownflowVelocityPointField(2, _dfaVelPointNomField);
    pData->setInflowTempCalib(_tempCalib);

    pData->setInflowLowLimitVelocity(_velPointLowAlarm);

    QSettings settings;
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FACTORY) + "1", _velPointMinFactory);
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FACTORY) + "2", _velPointNomFactory);
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FIELD)   + "1", _velPointMinField);
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FIELD)   + "2", _velPointNomField);
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FACTORY) + "2", _dfaVelPointNomFactory);
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FIELD)   + "2", _dfaVelPointNomField);
    settings.setValue(SKEY_IFA_CAL_VEL_LOW_LIMIT, _velPointLowAlarm);

    /// reinit calibration point
    initAirflowCalibrationStatus(pData->getAirflowCalibrationStatus());
    //    /// force recalculate velocity
    //    short forceRecalculateVelocity = 2;
    //    m_pAirflowInflow->routineTask(forceRecalculateVelocity);

    //    qDebug() << "getInflowVelocityPointFactory-1" << pData->getInflowVelocityPointFactory(1);
    //    qDebug() << "getInflowVelocityPointFactory-2" << pData->getInflowVelocityPointFactory(2);
    //    qDebug() << "getInflowVelocityPointField-1" << pData->getInflowVelocityPointField(1);
    //    qDebug() << "getInflowVelocityPointField-2" << pData->getInflowVelocityPointField(2);
    //    qDebug() << "getDownflowVelocityPointFactory-2" << pData->getDownflowVelocityPointFactory(2);
    //    qDebug() << "getDownflowVelocityPointField-2" << pData->getDownflowVelocityPointField(2);
    //    qDebug() << "getInflowTempCalib" << pData->getInflowTempCalib();

    /// UPDATE PRESSURE VALAUE BASED ON CURRENT MEASUREMENT UNIT
    if(pData->getSeasInstalled()){
        int pa = pData->getSeasPressureDiffPa();
        _onSeasPressureDiffPaChanged(pa);
    }
}

void MachineBackend::setSerialNumber(QString value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    pData->setSerialNumber(value);
    QSettings m_settings;
    m_settings.setValue(SKEY_SERIAL_NUMMBER, value);
}

void MachineBackend::_wakeupLcdBrightnessLevel()
{
    short brightness = pData->getLcdBrightnessLevel();
    short brightnessUser = pData->getLcdBrightnessLevelUser();

    if (brightness != brightnessUser) {
        m_boardCtpIO->setOutputPWM(LEDpca9633_CHANNEL_BL, brightnessUser, I2CPort::I2C_SEND_MODE_QUEUE);
    }

    pData->setLcdBrightnessLevelDimmed(false);

    /// If the timer is already running, it will be stopped and restarted.
    m_timerEventForLcdToDimm->start();
}

/**
 * @brief MachineBackend::_setTimeZone
 * @param value; example: Asia/Jakarta
 */
void MachineBackend::_setTimeZoneLinux(const QString value)
{
    Q_UNUSED(value)
#ifdef __linux__
    QProcess().execute("timedatectl", QStringList() << "set-timezone" << value);
#endif
}
/**
 * @brief MachineBackend::_setDateTime
 * @param value; example 2015-11-20 15:58:30 yyyy-MM-dd hh-mm-ss
 * user subprocess date -s intead timedatectl,
 * because timedatectl not allowed if ntp sync active but date -s does
 */
void MachineBackend::_setDateTimeLinux(const QString value)
{
    Q_UNUSED(value)
    //    QElapsedTimer elapsed;
    //    elapsed.start();
#ifdef __linux__
    QProcess().execute("date", QStringList() << "-s" << value);
#endif
    //    qDebug() << __func__ << elapsed.elapsed() << "ms";
}


QString MachineBackend::_readMacAddress()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    QString text = "";

#ifdef __linux__
    foreach(QNetworkInterface interface, QNetworkInterface::allInterfaces())
    {
        text += interface.hardwareAddress()+"#";
    }
#else
    text = SDEF_FULL_MAC_ADDRESS;
#endif

    qDebug() << "MAC:" << text;
    return text;
}

QStringList MachineBackend::_readSbcSystemInformation()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    qDebug() << sysInfo;
    //    QStringList sysInfo;
    QStringList sysInfo;
    QString sysInfoStr;

#ifdef __linux__
    QProcess process;

    process.start("cat", QStringList()<<"/proc/cpuinfo");
    process.waitForFinished();
    usleep(1000);
    QString output(process.readAllStandardOutput());
    //    qDebug()<<output;
    QString err(process.readAllStandardError());
    qDebug()<<err;

    sysInfoStr = output.remove(QRegularExpression("[\t]+"));
    sysInfo = sysInfoStr.split("\n", Qt::SkipEmptyParts);

    qDebug() << sysInfo;
#else
    sysInfo = QStringList() << "Unknown";
#endif
    return sysInfo;
}

QString MachineBackend::_readSbcSerialNumber()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    qDebug() << sysInfo;
    //    QStringList sysInfo;
    QString serialNumber;

#ifdef __linux__
    QProcess process;

    process.start("cat", QStringList() << "/sys/firmware/devicetree/base/serial-number");
    process.waitForFinished();
    usleep(1000);
    QString output(process.readAllStandardOutput());
    qDebug()<<output;
    serialNumber = output;

    QString err(process.readAllStandardError());
    qDebug()<<err;
#else
    serialNumber = SDEF_SBC_SERIAL_NUMBER;
#endif
    qDebug() << "Serial Number:" << serialNumber;
    return serialNumber;
}

void MachineBackend::_setSbcSystemInformation(QStringList sysInfo)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    qDebug() << sysInfo;

    QSettings settings;
    settings.setValue(SKEY_SBC_SYS_INFO, sysInfo);

    pData->setSbcSystemInformation(sysInfo);
}

void MachineBackend::_setSbcCurrentSystemInformation(QStringList sysInfo)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    qDebug() << sysInfo;

    QSettings settings;
    pData->setSbcCurrentSystemInformation(sysInfo);
}

void MachineBackend::_setSbcSerialNumber(QString value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    qDebug() << sysInfo;

    QSettings settings;
    settings.setValue(SKEY_SBC_SERIAL_NUMBER, value);

    pData->setSbcSerialNumber(value);
}

////////////////////////////////////////////////// API Group for specific cabinet

void MachineBackend::setFanState(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    switch (value) {
    case MachineEnums::FAN_STATE_ON:
    {
        _setFanPrimaryStateNominal();
        _setFanInflowStateNominal();
    }
        break;
    case MachineEnums::FAN_STATE_STANDBY:
    {
        _setFanPrimaryStateStandby();
        _setFanInflowStateStandby();
    }
        break;
    default:
    {
        ///Check if the cabinet want to post purging before actually turned off the blower
        if (!isMaintenanceModeActive()) {
            ///IF NO IN PURGING CONDITION
            if(pData->getPostPurgingActive()){
                return;
            }
            /// IF PURGING TIME MORE THAN ZERO
            else if (pData->getPostPurgingTime()
                     && !pData->getWarmingUpActive()
                     && !pData->getAlarmsState()){
                /// NO PURGING WHILE WARMING UP
                /// NO PURGING WHILE ALARMS
                _startPostPurgingTime();
                return;
            }
        }
        /// ACTUALY TURNED OFF THE FAN
        _setFanPrimaryStateOFF();
        _setFanInflowStateOFF();
    }
        break;
    }
}

void MachineBackend::setFanPrimaryDutyCycle(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    if(value < 0) return;
    if(value > 100) return;

    _setFanPrimaryDutyCycle(value);
}

void MachineBackend::setFanPrimaryNominalDutyCycleFactory(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_NOM_DCY_FACTORY, value);

    pData->setFanPrimaryNominalDutyCycleFactory(value);
}

void MachineBackend::setFanPrimaryNominalRpmFactory(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_NOM_RPM_FACTORY, value);

    pData->setFanPrimaryNominalRpmFactory(value);
}

void MachineBackend::setFanPrimaryMinimumDutyCycleFactory(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_MIN_DCY_FACTORY, value);

    pData->setFanPrimaryMinimumDutyCycleFactory(value);
}

void MachineBackend::setFanPrimaryMinimumRpmFactory(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_MIN_RPM_FACTORY, value);

    pData->setFanPrimaryMinimumRpmFactory(value);
}

void MachineBackend::setFanPrimaryStandbyDutyCycleFactory(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_STB_DCY_FACTORY, value);

    pData->setFanPrimaryStandbyDutyCycleFactory(value);
}

void MachineBackend::setFanPrimaryStandbyRpmFactory(int value)
{
    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_STB_RPM_FACTORY, value);

    pData->setFanPrimaryStandbyRpmFactory(value);
}

void MachineBackend::setFanPrimaryNominalDutyCycleField(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_NOM_DCY_FIELD, value);

    pData->setFanPrimaryNominalDutyCycleField(value);
}

void MachineBackend::setFanPrimaryNominalRpmField(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_NOM_RPM_FIELD, value);

    pData->setFanPrimaryNominalRpmField(value);
}

void MachineBackend::setFanPrimaryMinimumDutyCycleField(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_MIN_DCY_FIELD, value);

    pData->setFanPrimaryMinimumDutyCycleField(value);
}

void MachineBackend::setFanPrimaryMinimumRpmField(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_MIN_RPM_FIELD, value);

    pData->setFanPrimaryMinimumRpmField(value);
}

void MachineBackend::setFanPrimaryStandbyDutyCycleField(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_STB_DCY_FIELD, value);

    pData->setFanPrimaryStandbyDutyCycleField(value);
}

void MachineBackend::setFanPrimaryStandbyRpmField(int value)
{
    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_STB_RPM_FIELD, value);

    pData->setFanPrimaryStandbyRpmField(value);
}

///FAN INFLOW
void MachineBackend::setFanInflowDutyCycle(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    _setFanInflowDutyCycle(value);
}

void MachineBackend::setFanInflowNominalDutyCycleFactory(short value)
{
    QSettings settings;
    settings.setValue(SKEY_FAN_INF_NOM_DCY_FACTORY, value);

    pData->setFanInflowNominalDutyCycleFactory(value);
}

void MachineBackend::setFanInflowNominalRpmFactory(int value)
{
    QSettings settings;
    settings.setValue(SKEY_FAN_INF_NOM_RPM_FACTORY, value);

    pData->setFanInflowNominalRpmFactory(value);
}

void MachineBackend::setFanInflowMinimumDutyCycleFactory(short value)
{
    QSettings settings;
    settings.setValue(SKEY_FAN_INF_MIN_DCY_FACTORY, value);

    pData->setFanInflowMinimumDutyCycleFactory(value);
}

void MachineBackend::setFanInflowMinimumRpmFactory(int value)
{
    QSettings settings;
    settings.setValue(SKEY_FAN_INF_MIN_RPM_FACTORY, value);

    pData->setFanInflowMinimumRpmFactory(value);
}

void MachineBackend::setFanInflowStandbyDutyCycleFactory(short value)
{
    QSettings settings;
    settings.setValue(SKEY_FAN_INF_STB_DCY_FACTORY, value);

    pData->setFanInflowStandbyDutyCycleFactory(value);
}

void MachineBackend::setFanInflowStandbyRpmFactory(int value)
{
    QSettings settings;
    settings.setValue(SKEY_FAN_INF_STB_RPM_FACTORY, value);

    pData->setFanInflowStandbyRpmFactory(value);
}

void MachineBackend::setFanInflowNominalDutyCycleField(short value)
{
    QSettings settings;
    settings.setValue(SKEY_FAN_INF_NOM_DCY_FIELD, value);

    pData->setFanInflowNominalDutyCycleField(value);
}

void MachineBackend::setFanInflowNominalRpmField(int value)
{
    QSettings settings;
    settings.setValue(SKEY_FAN_INF_NOM_RPM_FIELD, value);

    pData->setFanInflowNominalRpmField(value);
}

void MachineBackend::setFanInflowMinimumDutyCycleField(short value)
{
    QSettings settings;
    settings.setValue(SKEY_FAN_INF_MIN_DCY_FIELD, value);

    pData->setFanInflowMinimumDutyCycleField(value);
}

void MachineBackend::setFanInflowMinimumRpmField(int value)
{
    QSettings settings;
    settings.setValue(SKEY_FAN_INF_MIN_RPM_FIELD, value);

    pData->setFanInflowMinimumRpmField(value);
}

void MachineBackend::setFanInflowStandbyDutyCycleField(short value)
{
    QSettings settings;
    settings.setValue(SKEY_FAN_INF_STB_DCY_FIELD, value);

    pData->setFanInflowStandbyDutyCycleField(value);
}

void MachineBackend::setFanInflowStandbyRpmField(int value)
{
    QSettings settings;
    settings.setValue(SKEY_FAN_INF_STB_RPM_FIELD, value);

    pData->setFanInflowStandbyRpmField(value);
}

void MachineBackend::setLightIntensity(short lightIntensity)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << lightIntensity;

    if(lightIntensity < 30) return;
    if(lightIntensity > 100) return;

    m_pLightIntensity->setState(lightIntensity);
}

void MachineBackend::saveLightIntensity(short lightIntensity)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << lightIntensity;

    if(lightIntensity < 30) return;
    if(lightIntensity > 100) return;

    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_LIGHT_INTENSITY, lightIntensity);
}

void MachineBackend::setLightState(short lightState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << lightState;

    bool val = lightState;

    m_pLight->setState(val);
}

void MachineBackend::setSocketInstalled(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings m_settings;
    m_settings.setValue(SKEY_SOCKET_INSTALLED, value);
}

void MachineBackend::setSocketState(short socketState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << socketState;

    bool val = socketState;

    m_pSocket->setState(val);
}

void MachineBackend::setGasInstalled(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings m_settings;
    m_settings.setValue(SKEY_GAS_INSTALLED, value);
}

void MachineBackend::setGasState(short gasState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << gasState;

    bool val = gasState;

    m_pGas->setState(val);
}

void MachineBackend::setUvInstalled(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings m_settings;
    m_settings.setValue(SKEY_UV_INSTALLED, value);
}

void MachineBackend::setUvState(short uvState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << uvState;

    bool val = uvState;

    m_pUV->setState(val);
}

void MachineBackend::setUvTimeSave(int minutes)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << minutes;

    pData->setUvTime(minutes);
    pData->setUvTimeCountdown(minutes * 60);

    QSettings settings;
    settings.setValue(SKEY_UV_TIME, minutes);
}

void MachineBackend::setWarmingUpTimeSave(short minutes)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << minutes;

    pData->setWarmingUpTime(minutes);
    pData->setWarmingUpCountdown(minutes * 60);

    QSettings settings;
    settings.setValue(SKEY_WARMUP_TIME, minutes);
}

void MachineBackend::setPostPurgeTimeSave(short minutes)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << minutes;

    pData->setPostPurgingTime(minutes);
    pData->setPostPurgingCountdown(minutes * 60);

    QSettings settings;
    settings.setValue(SKEY_POSTPURGE_TIME, minutes);
}

void MachineBackend::setExhaustContactState(short exhaustContactState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << exhaustContactState;

    m_pExhaustContact->setState(exhaustContactState);
}

void MachineBackend::setAlarmContactState(short alarmContactState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << alarmContactState;

    m_pAlarmContact->setState(alarmContactState);
}

void MachineBackend::setSashMotorizeInstalled(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings m_settings;
    m_settings.setValue(SKEY_SASH_MOTOR_INSTALLED, value);
}

void MachineBackend::setSashMotorizeState(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    m_pSasWindowMotorize->setState(value);
    m_pSasWindowMotorize->routineTask();
}

void MachineBackend::setSeasFlapInstalled(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings m_settings;
    m_settings.setValue(SKEY_SEAS_BOARD_FLAP_INSTALLED, value);
}

void MachineBackend::setSeasBuiltInInstalled(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings m_settings;
    m_settings.setValue(SKEY_SEAS_INSTALLED, value);
}

void MachineBackend::setSeasPressureDiffPaLowLimit(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;
    qDebug() << "low pressure set";

    pData-> setSeasPressureDiffPaLowLimit(value);
}

void MachineBackend::setSeasPressureDiffPaOffset(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;
    qDebug() << "pressure Off set";

    pData->setSeasPressureDiffPaOffset(value);
    m_pSeas->setOffsetPa(value);
}

void MachineBackend::setAirflowMonitorEnable(bool airflowMonitorEnable)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << airflowMonitorEnable;

    pData->setAirflowMonitorEnable(airflowMonitorEnable);

    QSettings m_settings;
    m_settings.setValue(SKEY_AF_MONITOR_ENABLE, airflowMonitorEnable);
}

void MachineBackend::saveInflowMeaDimNominalGrid(QJsonArray grid, int total,
                                                 int average, int volume,
                                                 int velocity,
                                                 int ducy, int rpm,
                                                 int fullField)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QJsonDocument doc(grid);
    QByteArray docByteArray = doc.toJson(QJsonDocument::Compact);
    QString strJson = QLatin1String(docByteArray);

    qDebug() << strJson;

    QSettings settings;

    switch (fullField) {
    case MachineEnums::FULL_CALIBRATION:
        settings.setValue(SKEY_IFA_CAL_GRID_NOM, strJson);
        if(pData->getMeasurementUnit()){//Imperial
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_VOL_IMP, volume);
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_VEL_IMP, velocity);
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_AVG_IMP, average);
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_TOT_IMP, total);
            //convert to metric
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_VOL, __convertCfmToLs(volume));
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_VEL, __convertFpmToMps(velocity));
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_AVG, __convertCfmToLs(average));
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_TOT, __convertCfmToLs(total));
        }
        else{
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_VOL, volume);
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_VEL, velocity);
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_AVG, average);
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_TOT, total);
            //convert to Imperial
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_VOL_IMP, __convertLsToCfm(volume));
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_VEL_IMP, __convertMpsToFpm(velocity));
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_AVG_IMP, __convertLsToCfm(average));
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_TOT_IMP, __convertLsToCfm(total));
        }
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_DCY, ducy);
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_RPM, rpm);

        ///remove field grid
        settings.remove(SKEY_IFA_CAL_GRID_NOM_FIL);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_VOL_FIL);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_VEL_FIL);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_AVG_FIL);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_TOT_FIL);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_VOL_FIL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_VEL_FIL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_AVG_FIL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_TOT_FIL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_DCY_FIL);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_RPM_FIL);

        break;
    case MachineEnums::FIELD_CALIBRATION:
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_FIL, strJson);
        if(pData->getMeasurementUnit()){//Imperial
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_VOL_FIL_IMP, volume);
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_VEL_FIL_IMP, velocity);
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_AVG_FIL_IMP, average);
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_TOT_FIL_IMP, total);
            //convert to metric
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_VOL_FIL, __convertCfmToLs(volume));
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_VEL_FIL, __convertFpmToMps(velocity));
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_AVG_FIL, __convertCfmToLs(average));
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_TOT_FIL, __convertCfmToLs(total));
        }else{
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_VOL_FIL, volume);
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_VEL_FIL, velocity);
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_AVG_FIL, average);
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_TOT_FIL, total);
            //convert to Imperial
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_VOL_FIL_IMP, __convertLsToCfm(volume));
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_VEL_FIL_IMP, __convertMpsToFpm(velocity));
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_AVG_FIL_IMP, __convertLsToCfm(average));
            settings.setValue(SKEY_IFA_CAL_GRID_NOM_TOT_FIL_IMP, __convertLsToCfm(total));
        }
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_DCY_FIL, ducy);
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_RPM_FIL, rpm);

        ///clear secondary method in field calibration
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_FIL);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_TOT_FIL);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_AVG_FIL);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_VEL_FIL);

        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_TOT_FIL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_AVG_FIL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_VEL_FIL_IMP);

        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_DCY_FIL);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_RPM_FIL);
        break;
    default:
        break;
    }

    /// remove the draf
    settings.beginGroup("meaifanomDraft");
    settings.remove("drafAirflowGridStr");
    settings.endGroup();
    settings.beginGroup("meaifanomdimfieldDraft");
    settings.remove("drafAirflowGridStr");
    settings.endGroup();
}

void MachineBackend::saveInflowMeaDimMinimumGrid(QJsonArray grid,
                                                 int total, int average,
                                                 int volume, int velocity,
                                                 int ducy, int rpm)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QJsonDocument doc(grid);
    QByteArray docByteArray = doc.toJson(QJsonDocument::Compact);
    QString strJson = QLatin1String(docByteArray);

    //    qDebug() << strJson;

    QSettings settings;
    settings.setValue(SKEY_IFA_CAL_GRID_MIN, strJson);
    if(pData->getMeasurementUnit()){//Imperial
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_VOL_IMP, volume);
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_VEL_IMP, velocity);
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_AVG_IMP, average);
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_TOT_IMP, total);
        //convert to metric
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_VOL, __convertCfmToLs(volume));
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_VEL, __convertFpmToMps(velocity));
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_AVG, __convertCfmToLs(average));
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_TOT, __convertCfmToLs(total));
    }else{
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_VOL, volume);
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_VEL, velocity);
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_AVG, average);
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_TOT, total);
        //convert to imperial
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_VOL_IMP, __convertLsToCfm(volume));
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_VEL_IMP, __convertMpsToFpm(velocity));
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_AVG_IMP, __convertLsToCfm(average));
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_TOT_IMP, __convertLsToCfm(total));
    }
    settings.setValue(SKEY_IFA_CAL_GRID_MIN_DCY, ducy);
    settings.setValue(SKEY_IFA_CAL_GRID_MIN_RPM, rpm);

    settings.beginGroup("meaifaminDraft");
    settings.remove("drafAirflowGridStr");
    settings.endGroup();
}

void MachineBackend::saveInflowMeaDimStandbyGrid(QJsonArray grid, int total,
                                                 int average, int volume,
                                                 int velocity,
                                                 int ducy, int rpm)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QJsonDocument doc(grid);
    QByteArray docByteArray = doc.toJson(QJsonDocument::Compact);
    QString strJson = QLatin1String(docByteArray);

    //    qDebug() << strJson;

    QSettings settings;
    settings.setValue(SKEY_IFA_CAL_GRID_STB, strJson);
    if(pData->getMeasurementUnit()){//Imperial
        settings.setValue(SKEY_IFA_CAL_GRID_STB_VOL_IMP, volume);
        settings.setValue(SKEY_IFA_CAL_GRID_STB_VEL_IMP, velocity);
        settings.setValue(SKEY_IFA_CAL_GRID_STB_AVG_IMP, average);
        settings.setValue(SKEY_IFA_CAL_GRID_STB_TOT_IMP, total);

        settings.setValue(SKEY_IFA_CAL_GRID_STB_VOL, __convertCfmToLs(volume));
        settings.setValue(SKEY_IFA_CAL_GRID_STB_VEL, __convertFpmToMps(velocity));
        settings.setValue(SKEY_IFA_CAL_GRID_STB_AVG, __convertCfmToLs(average));
        settings.setValue(SKEY_IFA_CAL_GRID_STB_TOT, __convertCfmToLs(total));
    }else{
        settings.setValue(SKEY_IFA_CAL_GRID_STB_VOL, volume);
        settings.setValue(SKEY_IFA_CAL_GRID_STB_VEL, velocity);
        settings.setValue(SKEY_IFA_CAL_GRID_STB_AVG, average);
        settings.setValue(SKEY_IFA_CAL_GRID_STB_TOT, total);

        settings.setValue(SKEY_IFA_CAL_GRID_STB_VOL_IMP, __convertLsToCfm(volume));
        settings.setValue(SKEY_IFA_CAL_GRID_STB_VEL_IMP, __convertMpsToFpm(velocity));
        settings.setValue(SKEY_IFA_CAL_GRID_STB_AVG_IMP, __convertLsToCfm(average));
        settings.setValue(SKEY_IFA_CAL_GRID_STB_TOT_IMP, __convertLsToCfm(total));
    }
    settings.setValue(SKEY_IFA_CAL_GRID_STB_DCY, ducy);
    settings.setValue(SKEY_IFA_CAL_GRID_STB_RPM, rpm);

    settings.beginGroup("meaifastbDraft");
    settings.remove("drafAirflowGridStr");
    settings.endGroup();

    //    qDebug() << "StandBy Value Cal " << volume << velocity << average << total << ducy;
}

void MachineBackend::saveInflowMeaSecNominalGrid(const QJsonArray grid,
                                                 int total, int average,
                                                 int velocity,
                                                 int ducy, int rpm)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QJsonDocument doc(grid);
    QByteArray docByteArray = doc.toJson(QJsonDocument::Compact);
    QString strJson = QLatin1String(docByteArray);

    //    qDebug() << strJson;

    QSettings settings;
    settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_FIL, strJson);
    if(pData->getMeasurementUnit()){//Imperial
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_TOT_FIL_IMP, total);
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_AVG_FIL_IMP, average);
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_VEL_FIL_IMP, velocity);
        //convert to metric
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_TOT_FIL, __convertCfmToLs(total));
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_AVG_FIL, __convertCfmToLs(average));
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_VEL_FIL, __convertFpmToMps(velocity));
    }else{
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_TOT_FIL, total);
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_AVG_FIL, average);
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_VEL_FIL, velocity);
        //convert to imperial
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_TOT_FIL_IMP, __convertLsToCfm(total));
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_AVG_FIL_IMP, __convertLsToCfm(average));
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_VEL_FIL_IMP, __convertMpsToFpm(velocity));
    }
    settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_DCY_FIL, ducy);
    settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_RPM_FIL, rpm);

    /// clear DIM Method in field calibration
    settings.remove(SKEY_IFA_CAL_GRID_NOM_FIL);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_VOL_FIL);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_VEL_FIL);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_AVG_FIL);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_TOT_FIL);

    settings.remove(SKEY_IFA_CAL_GRID_NOM_VOL_FIL_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_VEL_FIL_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_AVG_FIL_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_TOT_FIL_IMP);

    settings.remove(SKEY_IFA_CAL_GRID_NOM_DCY_FIL);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_RPM_FIL);

    settings.beginGroup("meaifanomsecDraft");
    settings.remove("drafAirflowGridStr");
    settings.endGroup();

    settings.beginGroup("meaifanomsecfieldDraft");
    settings.remove("drafAirflowGridStr");
    settings.endGroup();
}

/**
 * @brief MachineBackend::setInflowSensorConstant
 * @param value
 * This only set the sensor inflow contant for temporary
 * after system restarting,
 */
void MachineBackend::setInflowSensorConstantTemporary(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    m_pAirflowInflow->setConstant(value);
    // force calling airflow routine task
    m_pAirflowInflow->routineTask();
}

void MachineBackend::_setFanPrimaryDutyCycle(short dutyCycle)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << "Set fan duty" << dutyCycle << "%";
    /// talk to another thread
    /// append pending task to target object and target thread
    QMetaObject::invokeMethod(m_pFanPrimary.data(),[&, dutyCycle]{
        m_pFanPrimary->setDutyCycle(dutyCycle);
    },
    Qt::QueuedConnection);
}

void MachineBackend::_setFanPrimaryInterlocked(bool interlocked)
{
    /// talk to another thread
    /// append pending task to target object and target thread
    QMetaObject::invokeMethod(m_pFanPrimary.data(),[&, interlocked]{
        m_pFanPrimary->setInterlock(interlocked);
    },
    Qt::QueuedConnection);
}

void MachineBackend::_setFanInflowDutyCycle(short dutyCycle)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << "Set fan duty" << dutyCycle << "%";
    /// talk to another thread
    /// append pending task to target object and target thread
    QMetaObject::invokeMethod(m_pFanInflow.data(),[&, dutyCycle]{
        m_pFanInflow->setState(dutyCycle);
        m_pFanInflow->routineTask();
    },
    Qt::QueuedConnection);
}

void MachineBackend::_setFanInflowInterlocked(bool interlocked)
{
    /// talk to another thread
    /// append pending task to target object and target thread
    QMetaObject::invokeMethod(m_pFanInflow.data(),[&, interlocked]{
        m_pFanInflow->setInterlock(interlocked);
    },
    Qt::QueuedConnection);
}

void MachineBackend::setInflowAdcPointField(int pointZero, int pointMin, int pointNom)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << pointZero << pointMin << pointNom;

    QSettings settings;
    settings.setValue(QString(SKEY_IFA_CAL_ADC_FIELD) + "0", pointZero);
    settings.setValue(QString(SKEY_IFA_CAL_ADC_FIELD) + "1", pointMin);
    settings.setValue(QString(SKEY_IFA_CAL_ADC_FIELD) + "2", pointNom);

    pData->setInflowAdcPointField(0, pointZero);
    pData->setInflowAdcPointField(1, pointMin);
    pData->setInflowAdcPointField(2, pointNom);
}

void MachineBackend::setInflowAdcPointField(int point, int value)
{
    QSettings settings;
    settings.setValue(QString(SKEY_IFA_CAL_ADC_FIELD) + QString::number(point), value);

    pData->setInflowAdcPointField(point, value);
}

void MachineBackend::setInflowVelocityPointField(int /*pointZero*/, int pointMin, int pointNom)
{
    QSettings settings;
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FIELD) + "1", pointMin);
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FIELD) + "2", pointNom);

    pData->setInflowVelocityPointField(1, pointMin);
    pData->setInflowVelocityPointField(2, pointNom);
}

void MachineBackend::setInflowVelocityPointField(int point, int value)
{
    QSettings settings;
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FIELD) + QString::number(point), value);

    pData->setInflowVelocityPointField(point, value);
}

void MachineBackend::setInflowSensorConstant(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QSettings settings;
    settings.setValue(SKEY_IFA_SENSOR_CONST, value);

    pData->setInflowSensorConstant(value);
}

void MachineBackend::setInflowTemperatureCalib(short value, int adc)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QSettings settings;
    settings.setValue(SKEY_IFA_CAL_TEMP, value);
    settings.setValue(SKEY_IFA_CAL_TEMP_ADC, adc);

    pData->setInflowTempCalib(value);
    pData->setInflowTempCalibAdc(adc);
}

void MachineBackend::setInflowAdcPointFactory(int pointZero, int pointMin, int pointNom)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QSettings settings;
    settings.setValue(QString(SKEY_IFA_CAL_ADC_FACTORY) + "0", pointZero);
    settings.setValue(QString(SKEY_IFA_CAL_ADC_FACTORY) + "1", pointMin);
    settings.setValue(QString(SKEY_IFA_CAL_ADC_FACTORY) + "2", pointNom);

    pData->setInflowAdcPointFactory(0, pointZero);
    pData->setInflowAdcPointFactory(1, pointMin);
    pData->setInflowAdcPointFactory(2, pointNom);
}

void MachineBackend::setInflowAdcPointFactory(int point, int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QSettings settings;
    settings.setValue(QString(SKEY_IFA_CAL_ADC_FACTORY) + QString::number(point), value);

    pData->setInflowAdcPointFactory(point, value);
}

void MachineBackend::setInflowVelocityPointFactory(int /*pointZero*/, int pointMin, int pointNom)
{
    QSettings settings;
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FACTORY) + "1", pointMin);
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FACTORY) + "2", pointNom);

    pData->setInflowVelocityPointFactory(1, pointMin);
    pData->setInflowVelocityPointFactory(2, pointNom);
}

void MachineBackend::setInflowVelocityPointFactory(int point, int value)
{
    QSettings settings;
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FACTORY) + QString::number(point), value);

    pData->setInflowVelocityPointFactory(point, value);
}

void MachineBackend::setInflowLowLimitVelocity(short value)
{
    QSettings settings;
    settings.setValue(SKEY_IFA_CAL_VEL_LOW_LIMIT, value);

    pData->setInflowLowLimitVelocity(value);
}

void MachineBackend::saveDownflowMeaNominalGrid(const QJsonArray grid, int total,
                                                int velocity,
                                                int velocityLowest, int velocityHighest,
                                                int deviation, int deviationp,
                                                int fullField)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QJsonDocument doc(grid);
    QByteArray docByteArray = doc.toJson(QJsonDocument::Compact);
    QString strJson = QLatin1String(docByteArray);

    //    qDebug() << strJson;

    QSettings settings;

    switch (fullField) {
    case MachineEnums::FULL_CALIBRATION:
        settings.setValue(SKEY_DFA_CAL_GRID_NOM, strJson);
        if(pData->getMeasurementUnit())//Imperial
        {
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_IMP, velocity);
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_TOT_IMP, total);
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_LOW_IMP, velocityLowest);
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_HIGH_IMP, velocityHighest);
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEV_IMP, deviation);
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEVP_IMP, deviationp);
            //convert to metric
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL, __convertFpmToMps(velocity));
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_TOT, __convertFpmToMps(total));
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_LOW, __convertFpmToMps(velocityLowest));
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_HIGH, __convertFpmToMps(velocityHighest));
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEV, __convertFpmToMps(deviation));
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEVP, (deviationp));
        }else{
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL, velocity);
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_TOT, total);
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_LOW, velocityLowest);
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_HIGH, velocityHighest);
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEV, deviation);
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEVP, deviationp);
            //convert to imperial
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_IMP, __convertMpsToFpm(velocity));
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_TOT_IMP, __convertMpsToFpm(total));
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_LOW_IMP, __convertMpsToFpm(velocityLowest));
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_HIGH_IMP, __convertMpsToFpm(velocityHighest));
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEV_IMP, __convertMpsToFpm(deviation));
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEVP_IMP, (deviationp));
        }

        //        qDebug() << "FULL_CALIBRATION_DOWNFLOW_BACKEND" << strJson;

        /// If performe factory/full calibration
        /// it's necessary to remove field calibration value
        settings.remove(SKEY_DFA_CAL_GRID_NOM_FIL);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_FIL);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_TOT_FIL);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_LOW_FIL);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_HIGH_FIL);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_DEV_FIL);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_DEVP_FIL);

        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_FIL_IMP);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_TOT_FIL_IMP);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_LOW_FIL_IMP);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_HIGH_FIL_IMP);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_DEV_FIL_IMP);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_DEVP_FIL_IMP);
        break;

    case MachineEnums::FIELD_CALIBRATION:
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_FIL, strJson);
        if(pData->getMeasurementUnit())//Imperial
        {
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_FIL_IMP, velocity);
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_TOT_FIL_IMP, total);
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_LOW_FIL_IMP, velocityLowest);
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_HIGH_FIL_IMP, velocityHighest);
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEV_FIL_IMP, deviation);
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEVP_FIL_IMP, deviationp);
            //convert to metric
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_FIL, __convertFpmToMps(velocity));
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_TOT_FIL, __convertFpmToMps(total));
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_LOW_FIL, __convertFpmToMps(velocityLowest));
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_HIGH_FIL, __convertFpmToMps(velocityHighest));
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEV_FIL, __convertFpmToMps(deviation));
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEVP_FIL, (deviationp));
        }else{
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_FIL, velocity);
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_TOT_FIL, total);
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_LOW_FIL, velocityLowest);
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_HIGH_FIL, velocityHighest);
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEV_FIL, deviation);
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEVP_FIL, deviationp);
            //convert to imperial
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_FIL_IMP, __convertMpsToFpm(velocity));
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_TOT_FIL_IMP, __convertMpsToFpm(total));
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_LOW_FIL_IMP, __convertMpsToFpm(velocityLowest));
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_HIGH_FIL_IMP, __convertMpsToFpm(velocityHighest));
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEV_FIL_IMP, __convertMpsToFpm(deviation));
            settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEVP_FIL_IMP, (deviationp));
        }

        //        qDebug() << "FIELD_CALIBRATION_DOWNFLOW_BACKEND" << strJson;
        break;
    default:
        break;
    }

    settings.beginGroup("meadfanomDraft");
    settings.remove("drafAirflowGridStr");
    settings.endGroup();
    settings.beginGroup("meadfanomfieldDraft");
    settings.remove("drafAirflowGridStr");
    settings.endGroup();
}

void MachineBackend::setDownflowVelocityPointFactory(int /*pointZero*/, int pointMin, int pointNom)
{
    QSettings settings;
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FACTORY) + "1", pointMin);
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FACTORY) + "2", pointNom);

    pData->setDownflowVelocityPointFactory(1, pointMin);
    pData->setDownflowVelocityPointFactory(2, pointNom);
}

void MachineBackend::setDownflowVelocityPointFactory(int point, int value)
{
    QSettings settings;
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FACTORY) + QString::number(point), value);

    pData->setDownflowVelocityPointFactory(point, value);
}

void MachineBackend::setDownflowVelocityPointField(int /*pointZero*/, int pointMin, int pointNom)
{
    QSettings settings;
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FIELD) + "1", pointMin);
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FIELD) + "2", pointNom);

    pData->setDownflowVelocityPointField(1, pointMin);
    pData->setDownflowVelocityPointField(2, pointNom);
}

void MachineBackend::setDownflowVelocityPointField(int point, int value)
{
    QSettings settings;
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FIELD) + QString::number(point), value);

    pData->setDownflowVelocityPointField(point, value);
}

void MachineBackend::initAirflowCalibrationStatus(short value)
{
    switch (value) {
    case MachineEnums::AF_CALIB_FIELD:
        _initAirflowCalibartionField();
        break;
    case MachineEnums::AF_CALIB_FACTORY:
    default:
        _initAirflowCalibartionFactory();
        break;
    }

    pData->setAirflowCalibrationStatus(value);
}

void MachineBackend::_initAirflowCalibartionFactory()
{
    short fanNomDutyCycle   = pData->getFanPrimaryNominalDutyCycleFactory();
    int   fanNomRpm         = pData->getFanPrimaryNominalRpmFactory();
    short fanMinDutyCycle   = pData->getFanPrimaryMinimumDutyCycleFactory();
    int   fanMinRpm         = pData->getFanPrimaryMinimumRpmFactory();
    short fanStbDutyCycle   = pData->getFanPrimaryStandbyDutyCycleFactory();
    int   fanStbRpm         = pData->getFanPrimaryStandbyRpmFactory();

    pData->setFanPrimaryNominalDutyCycle(fanNomDutyCycle);
    pData->setFanPrimaryNominalRpm(fanNomRpm);
    pData->setFanPrimaryMinimumDutyCycle(fanMinDutyCycle);
    pData->setFanPrimaryMinimumRpm(fanMinRpm);
    pData->setFanPrimaryStandbyDutyCycle(fanStbDutyCycle);
    pData->setFanPrimaryStandbyRpm(fanStbRpm);

    int sensorConstant = pData->getInflowSensorConstant();

    int adcPointZero   = pData->getInflowAdcPointFactory(0);
    int adcPointMin    = pData->getInflowAdcPointFactory(1);
    int adcPointNom    = pData->getInflowAdcPointFactory(2);

    int velPointMin    = pData->getInflowVelocityPointFactory(1);
    int velPointNom    = pData->getInflowVelocityPointFactory(2);

    int velLowAlarm    = pData->getInflowLowLimitVelocity();

    /// LOW LIMIT VELOCITY ALARM
    pData->setInflowLowLimitVelocity(velLowAlarm);

    m_pAirflowInflow->setConstant(sensorConstant);

    m_pAirflowInflow->setAdcPoint(0, adcPointZero);
    m_pAirflowInflow->setAdcPoint(1, adcPointMin);
    m_pAirflowInflow->setAdcPoint(2, adcPointNom);

    m_pAirflowInflow->setVelocityPoint(1, velPointMin);
    m_pAirflowInflow->setVelocityPoint(2, velPointNom);

    m_pAirflowInflow->initScope();
}

void MachineBackend::_initAirflowCalibartionField()
{
    //Get delta value between Factory Nominal Duty cycle and Factory Standby Duty Cycle
    short fanNomDutyCycleFact   = pData->getFanPrimaryNominalDutyCycleFactory();
    short fanMinDutyCycleFact   = pData->getFanPrimaryMinimumDutyCycleFactory();Q_UNUSED(fanMinDutyCycleFact)
            short fanStbDutyCycleFact   = pData->getFanPrimaryStandbyDutyCycleFactory();
    short deltaValue = qAbs(fanNomDutyCycleFact - fanStbDutyCycleFact);

    short fanNomDutyCycle   = pData->getFanPrimaryNominalDutyCycleField();
    int   fanNomRpm         = pData->getFanPrimaryNominalRpmField();
    short fanMinDutyCycle   = pData->getFanPrimaryMinimumDutyCycleField();
    int   fanMinRpm         = pData->getFanPrimaryMinimumRpmField();
    short fanStbDutyCycle   = fanNomDutyCycle - deltaValue;
    int   fanStbRpm         = pData->getFanPrimaryStandbyRpmField(); /// this not valid, still follow factory or just zero

    pData->setFanPrimaryNominalDutyCycle(fanNomDutyCycle);
    pData->setFanPrimaryNominalRpm(fanNomRpm);
    pData->setFanPrimaryMinimumDutyCycle(fanMinDutyCycle);
    pData->setFanPrimaryMinimumRpm(fanMinRpm);
    pData->setFanPrimaryStandbyDutyCycle(fanStbDutyCycle);
    pData->setFanPrimaryStandbyRpm(fanStbRpm);

    int sensorConstant = pData->getInflowSensorConstant();

    int adcPointZero   = pData->getInflowAdcPointField(0);
    int adcPointMin    = pData->getInflowAdcPointField(1);
    int adcPointNom    = pData->getInflowAdcPointField(2);

    int velPointMin    = pData->getInflowVelocityPointField(1);
    int velPointNom    = pData->getInflowVelocityPointField(2);

    int velLowAlarm    = pData->getInflowLowLimitVelocity();

    /// LOW LIMIT VELOCITY ALARM
    pData->setInflowLowLimitVelocity(velLowAlarm);

    m_pAirflowInflow->setConstant(sensorConstant);

    m_pAirflowInflow->setAdcPoint(0, adcPointZero);
    m_pAirflowInflow->setAdcPoint(1, adcPointMin);
    m_pAirflowInflow->setAdcPoint(2, adcPointNom);

    m_pAirflowInflow->setVelocityPoint(1, velPointMin);
    m_pAirflowInflow->setVelocityPoint(2, velPointNom);

    m_pAirflowInflow->initScope();
}

void MachineBackend::_onFanPrimaryActualDucyChanged(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    pData->setFanPrimaryDutyCycle(value);

    //// translate duty cycle to fan state
    if (value == MachineEnums::DIG_STATE_ZERO) {
        pData->setFanPrimaryState(MachineEnums::FAN_STATE_OFF);

        _cancelWarmingUpTime();
        _cancelPostPurgingTime();
        _stopFanFilterLifeMeter();
        _cancelPowerOutageCapture();

        /// PARTICLE COUNTER
        /// do not counting when internal blower is on
        if (pData->getParticleCounterSensorInstalled()) {
            if (pData->getParticleCounterSensorFanState()){
                m_pParticleCounter->setFanStatePaCo(MachineEnums::DIG_STATE_ZERO);
            }
        }
    }
    else if (value == pData->getFanPrimaryStandbyDutyCycle()) {
        pData->setFanPrimaryState(MachineEnums::FAN_STATE_STANDBY);
    }
    else {
        pData->setFanPrimaryState(MachineEnums::FAN_STATE_ON);

        _startFanFilterLifeMeter();

        if(!isMaintenanceModeActive()) {
            if(isAirflowHasCalibrated()) {
                _startWarmingUpTime();
                _startPowerOutageCapture();
            }
        }

        /// PARTICLE COUNTER
        /// only counting when internal blower is on
        if (pData->getParticleCounterSensorInstalled()) {
            if (!pData->getParticleCounterSensorFanState()){
                m_pParticleCounter->setFanStatePaCo(MachineEnums::DIG_STATE_ONE);
            }
        }
    }

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.fanState.addr, pData->getFanPrimaryState());
    _setModbusRegHoldingValue(modbusRegisterAddress.fanDutyCycle.addr, value);
}

void MachineBackend::_onFanPrimaryActualRpmChanged(int value)
{
    pData->setFanPrimaryRpm(value);

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.fanRpm.addr, value);
}

void MachineBackend::_onSashStateChanged(short state, short prevState)
{
    Q_UNUSED(prevState)
    pData->setSashWindowState(state);

    /// if there is delay execute action for turned on blower and lamp caused sash safe height
    /// since the sash is change, so cancel the delay execution
    if (eventTimerForDelaySafeHeightAction != nullptr) {
        eventTimerForDelaySafeHeightAction->stop();
        delete eventTimerForDelaySafeHeightAction;
        eventTimerForDelaySafeHeightAction = nullptr;
    }

    /// cleared mute audible alarm
    /// if it active and vivarium mute is not active
    if (pData->getMuteAlarmState() && !pData->getVivariumMuteState()){
        pData->setMuteAlarmState(MachineEnums::DIG_STATE_ZERO);
        _cancelMuteAlarmTimer();
    }//

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.sashState.addr, state);

    /// Event Log
    switch (state) {
    case SashWindow::SASH_STATE_WORK_SSV:
        _insertEventLog(EVENT_STR_SASH_SAFE);
        break;
    case SashWindow::SASH_STATE_UNSAFE_SSV:
        _insertEventLog(EVENT_STR_SASH_UNSAFE);
        break;
    case SashWindow::SASH_STATE_FULLY_CLOSE_SSV:
        _insertEventLog(EVENT_STR_SASH_FC);
        break;
    case SashWindow::SASH_STATE_FULLY_OPEN_SSV:
        _insertEventLog(EVENT_STR_SASH_FO);
        break;
    case SashWindow::SASH_STATE_STANDBY_SSV:
        _insertEventLog(EVENT_STR_SASH_STB);
        break;
    case SashWindow::SASH_STATE_ERROR_SENSOR_SSV:
        _insertEventLog(EVENT_STR_SASH_ERROR);
        break;
    default:
        break;
    }

}

void MachineBackend::_onLightStateChanged(short state)
{
    pData->setLightState(state);

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.lightState.addr, state);

    //    /// EVENT LOG
    //    QString event = state ? EVENT_STR_LIGHT_ON : EVENT_STR_LIGHT_OFF;
    //    _insertEventLog(event);

}

void MachineBackend::_onSocketStateChanged(short state)
{
    pData->setSocketState(state);

    /// MEDIUM
    _setModbusRegHoldingValue(modbusRegisterAddress.socketState.addr, state);

    //    /// EVENT LOG
    //    QString event = state ? EVENT_STR_SOCKET_ON : EVENT_STR_SOCKET_OFF;
    //    _insertEventLog(event);
}

void MachineBackend::_onGasStateChanged(short state)
{
    pData->setGasState(state);

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.gasState.addr, state);

    //    /// EVENT LOG
    //    QString event = state ? EVENT_STR_GAS_ON : EVENT_STR_GAS_OFF;
    //    _insertEventLog(event);
}

void MachineBackend::_onUVStateChanged(short state)
{
    pData->setUvState(state);

    /// TRIGGERING UV TIME AND FRIENDS
    if(state) {
        _startUVTime();
        _startUVLifeMeter();
        _startPowerOutageCapture();
    }
    else {
        _cancelUVTime();
        _stopUVLifeMeter();
        _cancelPowerOutageCapture();
    }

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.uvState.addr, state);

    //    /// EVENT LOG
    //    QString event = state ? EVENT_STR_UV_ON : EVENT_STR_UV_OFF;
    //    _insertEventLog(event);
}

void MachineBackend::_onTemperatureActualChanged(int value)
{
    qDebug() << metaObject()->className() << __func__ << value;

    pData->setTemperatureCelcius(value);
    /// Temperature have effect to airflow reading
    m_pAirflowInflow->setTemperature(value);

    QString valueStr;
    if (pData->getMeasurementUnit()) {
        int fahrenheit = __convertCtoF(value);
        pData->setTemperature(fahrenheit);

        valueStr = QString::asprintf("%d°F", fahrenheit);
        pData->setTemperatureValueStrf(valueStr);
    }
    else {
        pData->setTemperature(value);

        valueStr = QString::asprintf("%d°C", value);
        pData->setTemperatureValueStrf(valueStr);
    }

    //    /// CHANGE TO ANOTHER IMPLEMENTATION
    //    /// IF USED AIRFLOW DEGREEC SENSOR
    //    /// https://degreec.com/pages/f-series-probe
    //    /// https://kl801.ilearning.me/2015/05/21/penjelasan-tentang-lm35
    //    short lowest = 2;
    //    short highest = 60;
    //    /// IF CONTANT NOT ZERO, THIS SYSTEM USED
    //    /// ESCO AIRFLOW SENSOR, WHICH ONLY CAN WORK IN
    //    /// TEMPERATURE RANGE BETWEEN 18 to 30 Deggree C
    //    if(pData->getInflowSensorConstant()){
    //        lowest  = 15;
    //        highest = 35;
    //    }

    /// ENV TEMPERATURE SET POINT GETTING FROM CABINET PROFILE
    /// BUT ALSO ADJUSTABLE
    short lowest = pData->getEnvTempLowestLimit();
    short highest = pData->getEnvTempHighestLimit();

    if (value < lowest){
        if(!isTempAmbLow(pData->getTempAmbientStatus())){
            pData->setTempAmbientStatus(MachineEnums::TEMP_AMB_LOW);

            /// EVENT LOG
            _insertEventLog(EVENT_STR_TEMP_AMB_LOW + " (" + valueStr + ")");

            //            /// ALARM LOG
            //            QString text = QString("%1 (%2)")
            //                    .arg(ALARM_LOG_TEXT_ENV_TEMP_TOO_LOW, pData->getTemperatureValueStrf());
            //            _insertAlarmLog(ALARM_LOG_CODE::ALC_ENV_TEMP_LOW, text);
        }
    }
    else if (value > highest){
        if(!isTempAmbHigh(pData->getTempAmbientStatus())){
            pData->setTempAmbientStatus(MachineEnums::TEMP_AMB_HIGH);

            ///EVENT LOG
            _insertEventLog(EVENT_STR_TEMP_AMB_HIGH + " (" + valueStr + ")");

            //            /// ALARM LOG
            //            QString text = QString("%1 (%2)")
            //                    .arg(ALARM_LOG_TEXT_ENV_TEMP_TOO_HIGH, pData->getTemperatureValueStrf());
            //            _insertAlarmLog(ALARM_LOG_CODE::ALC_ENV_TEMP_HIGH, text);
        }
    }
    else {
        if(!isTempAmbNormal(pData->getTempAmbientStatus())){
            pData->setTempAmbientStatus(MachineEnums::TEMP_AMB_NORMAL);

            ///EVENT LOG
            _insertEventLog(EVENT_STR_TEMP_AMB_NORM + " (" + valueStr + ")");

            //            /// ALARM LOG
            //            QString text = QString("%1 (%2)")
            //                    .arg(ALARM_LOG_TEXT_ENV_TEMP_OK, pData->getTemperatureValueStrf());
            //            _insertAlarmLog(ALARM_LOG_CODE::ALC_ENV_TEMP_OK, text);
        }
    }

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.temperature.addr, pData->getTemperature());

    //    qDebug() << value << pData->getTempAmbientStatus();
}

void MachineBackend::_onInflowVelocityActualChanged(int value)
{
    pData->setInflowVelocity(value);

    if (pData->getMeasurementUnit()) {
        int valueVel = qRound(value / 100.0);
        QString valueStr = QString::asprintf("%d fpm", valueVel);
        pData->setInflowVelocityStr(valueStr);
    }
    else {
        double valueVel = value / 100.0;
        QString valueStr = QString::asprintf("%.2f m/s", valueVel);
        pData->setInflowVelocityStr(valueStr);
    }

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.airflowInflow.addr, value);

    //    qDebug() << "Inflow" << pData->getInflowVelocityStr();
}

void MachineBackend::_calculteDownflowVelocity(int value)
{
    /// Calculate Downflow based on inflow
    /// DOWNFLOW SENSOR NOT PHYSICALLY INSTALLED
    /// CALCULATE DOWNFLOW VALUE BY PROPORTIONAL METHOD
    /// CALCULATE DOWNFLOW FROM INFLOW PROPORTIONAL
    int velRefActual, velRefPoportional;
    switch (pData->getAirflowCalibrationStatus()) {
    case MachineEnums::AF_CALIB_FIELD:
        velRefActual         = pData->getInflowVelocityPointField(2);
        velRefPoportional    = pData->getDownflowVelocityPointField(2);
        break;
    default:
        velRefActual         = pData->getInflowVelocityPointFactory(2);
        velRefPoportional    = pData->getDownflowVelocityPointFactory(2);
        break;
    }

    int dfVelocity = 0;
    if (velRefActual > 0) {
        dfVelocity = value * velRefPoportional / velRefActual;
    }

    pData->setDownflowVelocity(dfVelocity);

    if (pData->getMeasurementUnit()) {
        int valueVel = qRound(dfVelocity / 100.0);
        QString valueStr = QString::asprintf("%d fpm", valueVel);
        pData->setDownflowVelocityStr(valueStr);
    }
    else {
        double valueVel = dfVelocity / 100.0;
        QString valueStr = QString::asprintf("%.2f m/s", valueVel);
        pData->setDownflowVelocityStr(valueStr);
    }

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.airflowDownflow.addr, dfVelocity);

    //    qDebug() << "Downflow" << pData->getDownflowVelocityStr();
    //    qDebug() << value << velRefActual << velRefPoportional;
}

void MachineBackend::_onSeasPressureDiffPaChanged(int value)
{
    qDebug() << __FUNCTION__ ;
    qDebug() << value ;

    pData->setSeasPressureDiffPa(value);

    if (pData->getMeasurementUnit()) {
        float iwg = __toFixedDecPoint(__convertPa2inWG(value), 3);
        pData->setSeasPressureDiff(qRound(iwg * 1000));

        QString valueStr = QString::asprintf("%.3f iwg", iwg);
        pData->setSeasPressureDiffStrf(valueStr);
    }
    else {
        pData->setSeasPressureDiff(value * 1000);

        QString valueStr = QString::asprintf("%d Pa", value);
        pData->setSeasPressureDiffStrf(valueStr);
    }

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.pressureExhaust.addr, value);
}

void MachineBackend::_onParticleCounterPM1_0Changed(int pm1_0)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << pm1_0;

    pData->setParticleCounterPM1_0(pm1_0);
}

void MachineBackend::_onParticleCounterPM2_5Changed(int pm2_5)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << pm2_5;

    pData->setParticleCounterPM2_5(pm2_5);
}

void MachineBackend::_onParticleCounterPM10Changed(int pm10)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << pm10;

    pData->setParticleCounterPM10(pm10);
}

void MachineBackend::_onParticleCounterSensorFanStateChanged(int state)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << state;

    pData->setParticleCounterSensorFanState(state);
}

void MachineBackend::_onTimerEventLcdDimm()
{
    m_boardCtpIO->setOutputPWM(LEDpca9633_CHANNEL_BL,
                               LCD_DIMM_LEVEL,
                               I2CPort::I2C_SEND_MODE_QUEUE);

    pData->setLcdBrightnessLevel(LCD_DIMM_LEVEL);
    pData->setLcdBrightnessLevelDimmed(true);
}

void MachineBackend::_startWarmingUpTime()
{
    qDebug() << __FUNCTION__ ;

    int seconds = pData->getWarmingUpTime() * 60;
    pData->setWarmingUpCountdown(seconds);
    pData->setWarmingUpActive(MachineEnums::DIG_STATE_ONE);

    /// double ensure this slot not connected to this warming up event
    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventWarmingUp);
    /// connect uniqly timer event for warming up count down
    connect(m_timerEventEverySecond.data(), &QTimer::timeout,
            this, &MachineBackend::_onTimerEventWarmingUp,
            Qt::UniqueConnection);
}

void MachineBackend::_cancelWarmingUpTime()
{
    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventWarmingUp);

    if(!pData->getWarmingUpActive()) return;

    int seconds = pData->getWarmingUpTime() * 60;
    pData->setWarmingUpCountdown(seconds);
    pData->setWarmingUpActive(MachineEnums::DIG_STATE_ZERO);
}

void MachineBackend::_onTimerEventWarmingUp()
{
    //    qDebug() << __FUNCTION__ ;

    int count = pData->getWarmingUpCountdown();
    if(count <= 0){
        disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
                   this, &MachineBackend::_onTimerEventWarmingUp);

        int seconds = pData->getWarmingUpTime() * 60;
        pData->setWarmingUpCountdown(seconds);
        pData->setWarmingUpActive(MachineEnums::DIG_STATE_ZERO);

        /// IF IN NORMAL MODE, AFTER WARMING UP COMPLETE, TURN ON LAMP AUTOMATICALLY
        bool normalMode = pData->getOperationMode() == MachineEnums::MODE_OPERATION_NORMAL;
        if(normalMode) {
            m_pLight->setState(MachineEnums::DIG_STATE_ONE);
        }

        /// Turned bright LED
        _wakeupLcdBrightnessLevel();
    }
    else {
        count--;
        pData->setWarmingUpCountdown(count);
    }
}

void MachineBackend::_startPostPurgingTime()
{
    qDebug() << __FUNCTION__ ;

    int seconds = pData->getPostPurgingTime() * 60;
    pData->setPostPurgingCountdown(seconds);
    pData->setPostPurgingActive(MachineEnums::DIG_STATE_ONE);

    /// double ensure this slot not connected to this warming up event
    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventPostPurging);
    /// connect uniqly timer event for warming up count down
    connect(m_timerEventEverySecond.data(), &QTimer::timeout,
            this, &MachineBackend::_onTimerEventPostPurging,
            Qt::UniqueConnection);
}

void MachineBackend::_cancelPostPurgingTime()
{
    qDebug() << __FUNCTION__ ;

    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventPostPurging);

    if(!pData->getPostPurgingActive()) return;

    int seconds = pData->getPostPurgingTime() * 60;
    pData->setPostPurgingCountdown(seconds);
    pData->setPostPurgingActive(MachineEnums::DIG_STATE_ZERO);
}

void MachineBackend::_onTimerEventPostPurging()
{
    qDebug() << __FUNCTION__ ;

    int count = pData->getPostPurgingCountdown();
    if(count <= 0){
        disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
                   this, &MachineBackend::_onTimerEventPostPurging);

        int seconds = pData->getPostPurgingTime() * 60;
        pData->setPostPurgingCountdown(seconds);
        pData->setPostPurgingActive(MachineEnums::DIG_STATE_ZERO);

        /// ACTUALLY TURNING OFF THE FAN
        _setFanPrimaryStateOFF();

        /// Light up LCD Backlight
        _wakeupLcdBrightnessLevel();
    }
    else {
        count--;
        pData->setPostPurgingCountdown(count);
    }
}

void MachineBackend::_startUVTime()
{
    qDebug() << __FUNCTION__ ;

    int seconds = pData->getUvTime() * 60;
    pData->setUvTimeCountdown(seconds);
    pData->setUvTimeActive(MachineEnums::DIG_STATE_ONE);

    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventUVTimeCountdown);
    /// connect uniqly timer event for warming up count down
    connect(m_timerEventEverySecond.data(), &QTimer::timeout,
            this, &MachineBackend::_onTimerEventUVTimeCountdown,
            Qt::UniqueConnection);
}

void MachineBackend::_cancelUVTime()
{
    qDebug() << __FUNCTION__ ;

    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventUVTimeCountdown);

    if(!pData->getUvTimeActive()) return;

    int seconds = pData->getUvTime() * 60;
    pData->setUvTimeCountdown(seconds);
    pData->setUvTimeActive(MachineEnums::DIG_STATE_ZERO);
}

void MachineBackend::_onTimerEventUVTimeCountdown()
{
    qDebug() << __FUNCTION__ ;

    int count = pData->getUvTimeCountdown();
    if(count <= 0){
        disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
                   this, &MachineBackend::_onTimerEventUVTimeCountdown);

        int seconds = pData->getUvTime() * 60;
        pData->setUvTimeCountdown(seconds);
        pData->setUvTimeActive(MachineEnums::DIG_STATE_ZERO);

        /// TURN OFF UV LAMP AUTOMATICALLY
        if(pData->getUvState()){
            m_pUV->setState(MachineEnums::DIG_STATE_ZERO);
        }

        /// Light up LCD Backlight
        _wakeupLcdBrightnessLevel();
    }
    else {
        count--;
        pData->setUvTimeCountdown(count);
    }
}

void MachineBackend::_startUVLifeMeter()
{
    qDebug() << __FUNCTION__ ;

    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    disconnect(m_timerEventEveryMinute.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventUVLifeCalculate);
    /// connect uniqly timer event for warming up count down
    connect(m_timerEventEveryMinute.data(), &QTimer::timeout,
            this, &MachineBackend::_onTimerEventUVLifeCalculate,
            Qt::UniqueConnection);
}

void MachineBackend::_stopUVLifeMeter()
{
    qDebug() << __FUNCTION__ ;

    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    disconnect(m_timerEventEveryMinute.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventUVLifeCalculate);
}

void MachineBackend::_onTimerEventUVLifeCalculate()
{
    qDebug() << __FUNCTION__ ;

    int minutes = pData->getUvLifeMinutes();
    if(minutes > 0){
        minutes--;
        //        minutes = minutes - 1000;
        int minutesPercentLeft = __getPercentFrom(minutes, SDEF_UV_MAXIMUM_TIME_LIFE);

        /// event if in % value is zero but the minutes more then 0 minutes, then set % to 1
        if (minutesPercentLeft == 0 && minutes > 0) minutesPercentLeft = 1;

        //update to global observable variable
        pData->setUvLifeMinutes(minutes);
        pData->setUvLifePercent(minutesPercentLeft);

        //save to sattings
        QSettings settings;
        settings.setValue(SKEY_UV_METER, minutes);

        //        qDebug() << __FUNCTION__  << minutes;
    }
}

void MachineBackend::_startFanFilterLifeMeter()
{
    qDebug() << __FUNCTION__ ;

    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    disconnect(m_timerEventEveryMinute.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventFanFilterUsageMeterCalculate);
    /// connect uniqly timer event for warming up count down
    connect(m_timerEventEveryMinute.data(), &QTimer::timeout,
            this, &MachineBackend::_onTimerEventFanFilterUsageMeterCalculate,
            Qt::UniqueConnection);
}

void MachineBackend::_stopFanFilterLifeMeter()
{
    qDebug() << __FUNCTION__ ;

    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    disconnect(m_timerEventEveryMinute.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventUVLifeCalculate);
}

void MachineBackend::_onTimerEventFanFilterUsageMeterCalculate()
{
    //    qDebug() << __FUNCTION__ ;

    QSettings settings;
    ///FILTER LIFE
    {
        int minutes = pData->getFilterLifeMinutes();
        if(minutes > 0){
            minutes--;
            //            minutes = minutes - 1000;
            int minutesPercentLeft = __getPercentFrom(minutes, SDEF_FILTER_MAXIMUM_TIME_LIFE);

            /// event if in % value is zero but the minutes more then 0 minutes, then set % to 1
            if (minutesPercentLeft == 0 && minutes > 0) minutesPercentLeft = 1;

            //update to global observable variable
            pData->setFilterLifeMinutes(minutes);
            pData->setFilterLifePercent(minutesPercentLeft);

            //save to sattings
            settings.setValue(SKEY_FILTER_METER, minutes);

            //            qDebug() << __FUNCTION__  << minutes;

            ///MODBUS
            _setModbusRegHoldingValue(modbusRegisterAddress.filterLife.addr, minutesPercentLeft);
        }
    }

    /// FAN METER
    {
        int count = pData->getFanUsageMeter();
        count = count + 1;
        pData->setFanUsageMeter(count);

        settings.setValue(SKEY_FAN_METER, count);

        //        qDebug() << __func__ << "getFanUsageMeter"  << count;
    }
}

void MachineBackend::_startPowerOutageCapture()
{

    qDebug() << __func__;

    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    disconnect(m_timerEventEveryMinute.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventPowerOutageCaptureTime);
    /// connect uniqly timer event for warming up count down
    connect(m_timerEventEveryMinute.data(), &QTimer::timeout,
            this, &MachineBackend::_onTimerEventPowerOutageCaptureTime,
            Qt::UniqueConnection);

    QSettings settings;
    settings.setValue(SKEY_POWER_OUTAGE, MachineEnums::DIG_STATE_ONE);
    settings.setValue(SKEY_POWER_OUTAGE_FAN, MachineEnums::DIG_STATE_ZERO);
    settings.setValue(SKEY_POWER_OUTAGE_UV, MachineEnums::DIG_STATE_ZERO);

    if(pData->getFanPrimaryState()){
        settings.setValue(SKEY_POWER_OUTAGE_FAN, pData->getFanPrimaryState());
    }
    else if(pData->getUvState()){
        settings.setValue(SKEY_POWER_OUTAGE_UV, pData->getUvState());
    }

    /// TRIGERED ON START
    _onTimerEventPowerOutageCaptureTime();
}

void MachineBackend::_cancelPowerOutageCapture()
{
    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    disconnect(m_timerEventEveryMinute.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventPowerOutageCaptureTime);

    QSettings settings;
    settings.setValue(SKEY_POWER_OUTAGE, MachineEnums::DIG_STATE_ZERO);
}

void MachineBackend::_onTimerEventPowerOutageCaptureTime()
{
    //    qDebug() << __FUNCTION__ ;

    QDateTime dateTime;
    QString dateTimeStrf = dateTime.currentDateTime().toString("dd-MMM-yyyy hh:mm");
    //    qDebug() << __FUNCTION__ << dateTimeStrf;

    //save to sattings
    QSettings settings;
    settings.setValue(SKEY_POWER_OUTAGE_TIME, dateTimeStrf);
}

void MachineBackend::_startMuteAlarmTimer()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    int seconds = pData->getMuteAlarmTime() * 60;
    pData->setMuteAlarmCountdown(seconds);

    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventMuteAlarmTimer);
    /// connect uniqly timer event for warming up count down
    connect(m_timerEventEverySecond.data(), &QTimer::timeout,
            this, &MachineBackend::_onTimerEventMuteAlarmTimer,
            Qt::UniqueConnection);
}

void MachineBackend::_cancelMuteAlarmTimer()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventMuteAlarmTimer);

    int seconds = pData->getMuteAlarmTime() * 60;
    pData->setMuteAlarmCountdown(seconds);

    /// clear vivarium mute state
    if (pData->getVivariumMuteState()){
        pData->setVivariumMuteState(false);
    }
}

void MachineBackend::_onTimerEventMuteAlarmTimer()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    int count = pData->getMuteAlarmCountdown();
    if(count <= 0){
        disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
                   this, &MachineBackend::_onTimerEventMuteAlarmTimer);

        int seconds = pData->getMuteAlarmTime() * 60;
        pData->setMuteAlarmCountdown(seconds);
        pData->setMuteAlarmState(MachineEnums::DIG_STATE_ZERO);

        /// TURN AUTOMATICALLY
    }
    else {
        count--;
        pData->setMuteAlarmCountdown(count);
    }
}

void MachineBackend::_readRTCActualTime()
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    int countdown = 0;
    m_boardCtpRTC->getRegBuffer_TimerACount(countdown);
    int wday = 0, day = 0, month = 0, year = 0;
    m_boardCtpRTC->getRegBuffer_Date(wday, day, month, year);
    int hour = 0, minute = 0, second = 0;
    m_boardCtpRTC->getRegBuffer_Clock(hour, minute, second);

    /// set to linux system, it's require with following format
    /// 2015-11-20 15:58:30
    QString dateTimeFormat = QString().asprintf("%d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, minute, second);
    //    qDebug() << metaObject()->className() << __func__ << "dateTimeFormat" << dateTimeFormat << "countdown" << countdown;
    QDateTime dateValidation = QDateTime::fromString(dateTimeFormat, "yyyy-MM-dd hh:mm:ss");

    pData->setWatchdogCounter(countdown);
    pData->setRtcActualDate(dateValidation.date().toString("yyyy-MM-dd"));
    pData->setRtcActualTime(dateValidation.time().toString("hh:mm:ss"));
}

void MachineBackend::_insertDataLog()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    int currentRowCount = pData->getDataLogCount();

    /// This system has limited the datalog count only up to DATALOG_MAX_ROW
    if (currentRowCount >= DATALOG_MAX_ROW){
        return;
    }
    /// Only record the log when blower in nominal condition
    if (pData->getFanPrimaryState() != MachineEnums::FAN_STATE_ON){
        /// if timer event for this task still running, do stop it
        if(m_timerEventForDataLog->isActive()){
            m_timerEventForDataLog->stop();
        }
        return;
    }
    /// Only record the log when airflow has calibrated
    if (!pData->getAirflowCalibrationStatus()){
        /// if timer event for this task still running, do stop it
        if(m_timerEventForDataLog->isActive()){
            m_timerEventForDataLog->stop();
        }
        return;
    }
    QDateTime dateTime = QDateTime::currentDateTime();
    QString dateText = dateTime.toString("yyyy-MM-dd");
    QString timeText = dateTime.toString("hh:mm:ss");

    /// execute this function in where thread the m_pDataLog live at
    QMetaObject::invokeMethod(m_pDataLog.data(),
                              [&,
                              dateText,
                              timeText](){

        QVariantMap dataMap;
        dataMap.insert("date", dateText);
        dataMap.insert("time", timeText);
        dataMap.insert("temp", pData->getTemperatureValueStrf());
        dataMap.insert("ifa",  pData->getInflowVelocityStr());
        dataMap.insert("dfa",  pData->getDownflowVelocityStr());
        dataMap.insert("ifaAdc",  pData->getInflowAdcConpensation());
        dataMap.insert("fanRPM",  pData->getFanPrimaryRpm());

        DataLogSql *sql = m_pDataLog->getPSqlInterface();
        bool success = sql->queryInsert(dataMap);

        /// check how many data log has stored now
        int count;
        success = sql->queryCount(&count);
        //        qDebug() << "success: " << success ;
        if(success){
            pData->setDataLogCount(count);
            //            qDebug() << count << maximumRowCount;
            pData->setDataLogIsFull(count >= DATALOG_MAX_ROW);
        }//
    },
    Qt::QueuedConnection);
}

void MachineBackend::_insertAlarmLog(int alarmCode, const QString alarmText)
{
    QDateTime dateTime = QDateTime::currentDateTime();
    QString dateText = dateTime.toString("yyyy-MM-dd");
    QString timeText = dateTime.toString("hh:mm:ss"); /// fix to 24H

    QString usernameSigned     = m_signedUsername;
    QString userfullnameSigned = m_signedFullname;

    QMetaObject::invokeMethod(m_pAlarmLog.data(),
                              [&,
                              dateText,
                              timeText,
                              alarmCode,
                              alarmText,
                              usernameSigned,
                              userfullnameSigned](){

        QVariantMap dataMap;
        dataMap.insert("date",          dateText);
        dataMap.insert("time",          timeText);
        dataMap.insert("alarmCode",     alarmCode);
        dataMap.insert("alarmText",     alarmText);
        dataMap.insert("username",      usernameSigned);
        dataMap.insert("userfullname",  userfullnameSigned);

        AlarmLogSql *sql = m_pAlarmLog->getPSqlInterface();
        bool success = sql->queryInsert(dataMap);

        /// check how many data log has stored now
        int count;
        success = sql->queryCount(&count);
        //        qDebug() << __FUNCTION__ << "success: " << success << count;
        if(success){
            pData->setAlarmLogCount(count);
            //            qDebug() << count << maximumRowCount;
            pData->setAlarmLogIsFull(count >= ALARMEVENTLOG_MAX_ROW);
        }//
    },
    Qt::QueuedConnection);
}

void MachineBackend::_insertEventLog(const QString logText)
{
    if(pData->getEventLogIsFull()){
        return;
    }

    QDateTime dateTime = QDateTime::currentDateTime();
    QString dateText = dateTime.toString("yyyy-MM-dd");
    QString timeText = dateTime.toString("hh:mm:ss");

    QString usernameSigned     = m_signedUsername;
    QString userfullnameSigned = m_signedFullname;

    QMetaObject::invokeMethod(m_pEventLog.data(),
                              [&,
                              dateText,
                              timeText,
                              logText,
                              usernameSigned,
                              userfullnameSigned](){

        QVariantMap dataMap;
        dataMap.insert("date",          dateText);
        dataMap.insert("time",          timeText);
        dataMap.insert("logText",       logText);
        dataMap.insert("username",      usernameSigned);
        dataMap.insert("userfullname",  userfullnameSigned);

        EventLogSql *sql = m_pEventLog->getPSqlInterface();
        bool success = sql->queryInsert(dataMap);

        /// check how many data log has stored now
        int count;
        success = sql->queryCount(&count);
        //        qDebug() << __FUNCTION__ << "success: " << success << count;
        if(success){
            pData->setEventLogCount(count);
            //            qDebug() << count << maximumRowCount;
            pData->setEventLogIsFull(count >= ALARMEVENTLOG_MAX_ROW);
        }//
    });
}

void MachineBackend::_setFanInflowStateNominal()
{
    short dutyCycle = pData->getFanInflowNominalDutyCycle();
    _setFanInflowDutyCycle(dutyCycle);
}

void MachineBackend::_setFanInflowStateMinimum()
{
    short dutyCycle = pData->getFanInflowMinimumDutyCycle();
    _setFanInflowDutyCycle(dutyCycle);
}

void MachineBackend::_setFanInflowStateStandby()
{
    short dutyCycle = pData->getFanInflowStandbyDutyCycle();
    _setFanInflowDutyCycle(dutyCycle);
}

void MachineBackend::_setFanInflowStateOFF()
{
    short dutyCycle = MachineEnums::FAN_STATE_OFF;
    _setFanInflowDutyCycle(dutyCycle);
}


void MachineBackend::_setFanPrimaryStateNominal()
{
    short dutyCycle = pData->getFanPrimaryNominalDutyCycle();
    _setFanPrimaryDutyCycle(dutyCycle);
}

void MachineBackend::_setFanPrimaryStateMinimum()
{
    short dutyCycle = pData->getFanPrimaryMinimumDutyCycle();
    _setFanPrimaryDutyCycle(dutyCycle);
}

void MachineBackend::_setFanPrimaryStateStandby()
{
    short dutyCycle = pData->getFanPrimaryStandbyDutyCycle();
    _setFanPrimaryDutyCycle(dutyCycle);
}

void MachineBackend::_setFanPrimaryStateOFF()
{
    short dutyCycle = MachineEnums::DIG_STATE_ZERO;
    _setFanPrimaryDutyCycle(dutyCycle);
}

double MachineBackend::__convertCfmToLs(float value)
{
    return static_cast<double>(qRound(static_cast<double>(value) * 0.4719));
}

double MachineBackend::__convertLsToCfm(float value)
{
    return static_cast<double>(qRound(static_cast<double>(value) * 2.11888));
}

double MachineBackend::__convertFpmToMps(float value)
{
    if(value <= 0) return value;
    return value / 197.0;
}

double MachineBackend::__convertMpsToFpm(float value)
{
    return value * 197.0;
}

double MachineBackend::__toFixedDecPoint(float value, short point)
{
    float dec = (float)(qPow(10.0, point));
    //    qDebug() << "dec" << dec;
    return qRound(value * dec) / dec;
}

int MachineBackend::__convertCtoF(int c)
{
    return qRound(((double) c * 9.0/5.0) + 32.0);
}

int MachineBackend::__convertFtoC(int f)
{
    return qRound((double)(f - 32) * 5.0/9.0);
}

float MachineBackend::__convertPa2inWG(int pa)
{
    return pa / 249.0;
}

int MachineBackend::__getPercentFrom(int val, int ref)
{
    return qRound(((float) val/(float) ref) * 100);
}

bool MachineBackend::isMaintenanceModeActive() const
{
    return pData->getOperationMode() == MachineEnums::MODE_OPERATION_MAINTENANCE;
}

bool MachineBackend::isAirflowHasCalibrated() const
{
    return pData->getAirflowCalibrationStatus() >= MachineEnums::AF_CALIB_FACTORY;
}

bool MachineBackend::isTempAmbientNormal() const
{
    return pData->getTempAmbientStatus() == MachineEnums::TEMP_AMB_NORMAL;
}

bool MachineBackend::isTempAmbientLow() const
{
    return pData->getTempAmbientStatus() == MachineEnums::TEMP_AMB_LOW;
}

bool MachineBackend::isTempAmbientHigh() const
{
    return pData->getTempAmbientStatus() == MachineEnums::TEMP_AMB_HIGH;
}

bool MachineBackend::isFanStateNominal() const
{
    return pData->getFanPrimaryState() == MachineEnums::FAN_STATE_ON;
}

bool MachineBackend::isFanStateStandby() const
{
    return pData->getFanPrimaryState() == MachineEnums::FAN_STATE_STANDBY;
}

bool MachineBackend::isAlarmActive(short alarm) const
{
    return alarm >= MachineEnums::ALARM_ACTIVE_STATE;
}

bool MachineBackend::isAlarmNormal(short alarm) const
{
    return alarm == MachineEnums::ALARM_NORMAL_STATE;
}

bool MachineBackend::isAlarmNA(short alarm) const
{
    return alarm == MachineEnums::ALARM_NA_STATE;
}

bool MachineBackend::isTempAmbNormal(short value) const
{
    return value == MachineEnums::TEMP_AMB_NORMAL;
}

bool MachineBackend::isTempAmbLow(short value) const
{
    return value == MachineEnums::TEMP_AMB_LOW;
}

bool MachineBackend::isTempAmbHigh(short value) const
{
    return value == MachineEnums::TEMP_AMB_HIGH;
}

void MachineBackend::_checkCertificationReminder()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QString strDate = pData->getDateCertificationRemainder();
    QDate acDate = QDate::fromString(strDate,"yyyy-MM-dd");

    if(acDate.isValid()){
        QDate currentDate = QDate::currentDate();
        //     QString dateText = dateTime.toString("dd-MM-yyyy");
        //     QString timeText = dateTime.toString("hh:mm:ss");

        qDebug() << "actual date " << acDate;
        qDebug() << "str date " << strDate;

        //    pData->setCertificationExpired(acDate == currentDate);

        int span = currentDate.daysTo(acDate);

        qDebug() << "span days" << span;

        pData->setCertificationExpiredValid(true);
        pData->setCertificationExpired(span == 0);
        pData->setCertificationExpiredCount(span);
    }
    else {
        pData->setCertificationExpiredValid(false);
        pData->setCertificationExpired(false);
        pData->setCertificationExpiredCount(0);
    }
}

/*!
 * \class
 * \brief MachineBackend::_onModbusDataWritten
 * \param table
 * \param address
 * \param size
 */
void MachineBackend::_onModbusDataWritten(QModbusDataUnit::RegisterType table, int address, int size)
{
    m_pModbusServer->setValue(QModbusServer::DeviceBusy, true);
    m_pModbusServer->blockSignals(true);

    for (int i=0; i < size; ++i) {
        quint16 value;
        switch (table) {
        case QModbusDataUnit::RegisterType::HoldingRegisters:
            /// take lates data from modbus device was written
            m_pModbusServer->data(QModbusDataUnit::HoldingRegisters, quint16(address + i), &value);
            qDebug() << __func__ << address + i << value;
            _modbusCommandHandler(address + i, value);
            break;
        default:
            break;
        }
    }

    m_pModbusServer->blockSignals(false);
    m_pModbusServer->setValue(QModbusServer::DeviceBusy, false);
}

/*!
 * \brief MachineBackend::_modbusCommandHandler
 * \param address
 * \param value
 */
void MachineBackend::_modbusCommandHandler(int address, uint16_t value)
{
    qDebug() << __func__ << address << value;

    bool revertData = true;
    switch (address) {
    case modbusRegisterAddress.fanState.addr:
        if (modbusRegisterAddress.fanState.rw){
            setFanState(value);
            revertData = false;
        }
        break;
    case modbusRegisterAddress.lightState.addr:
        if (modbusRegisterAddress.lightState.rw){
            setLightState(value);
            revertData = false;
        }
        break;
    case modbusRegisterAddress.lightIntensity.addr:
        if (modbusRegisterAddress.lightIntensity.rw){
            setLightIntensity(value);
            revertData = false;
        }
        break;
    case modbusRegisterAddress.socketState.addr:
        if (modbusRegisterAddress.socketState.rw){
            setSocketState(value);
            revertData = false;
        }
        break;
    case modbusRegisterAddress.gasState.addr:
        if (modbusRegisterAddress.gasState.rw){
            setGasState(value);
            revertData = false;
        }
        break;
    case modbusRegisterAddress.uvState.addr:
        if (modbusRegisterAddress.uvState.rw){
            setUvState(value);
            revertData = false;
        }
        break;
    }

    if(revertData){
        /// if the register is read-only
        /// revert the value to the actual value from buffer
        uint16_t data = m_modbusDataUnitBufferRegisterHolding->at(address);
        m_pModbusServer->setData(QModbusDataUnit::HoldingRegisters, address, data);
    }
}

void MachineBackend::_setModbusRegHoldingValue(int addr, uint16_t value)
{
    /// Dont continue if the value already same, no more money bro! ^_^
    uint16_t valuePrev;
    m_pModbusServer->data(QModbusDataUnit::HoldingRegisters, quint16(addr), &valuePrev);
    if(value == valuePrev) return;

    /// Dont trigered signal onDataWritten from this action
    m_pModbusServer->blockSignals(true);

    m_pModbusServer->setData(QModbusDataUnit::HoldingRegisters, addr, value);
    m_modbusDataUnitBufferRegisterHolding->replace(addr, value);

    /// Get back trigered signal onDataWritten when master write to register
    m_pModbusServer->blockSignals(false);
}

/*!
 * \brief MachineBackend::_onModbusConnectionStatusChanged
 */
bool MachineBackend::_callbackOnModbusConnectionStatusChanged(QTcpSocket* newClient)
{
    qDebug() << __func__  << thread();

    QString newConnectedClientIPv4 = newClient->peerAddress().toString();
    qDebug() << __func__ << newConnectedClientIPv4;

    if ((pData->getModbusAllowIpMaster() == ALLOW_ANY_IP)
            || pData->getModbusAllowIpMaster() == newConnectedClientIPv4) {

        QString message = "1@" + newConnectedClientIPv4;
        pData->setModbusLatestStatus(message);

        QObject::connect(newClient, &QTcpSocket::disconnected, newClient, [&](){
            qDebug() << "Bye bye!" << pData->getModbusLatestStatus().replace("1@", "");

            QString message = pData->getModbusLatestStatus().replace("1@", "0@");
            pData->setModbusLatestStatus(message);

            /// RECORD IN EVENT LOG
            QString msg = QString("%1 (%2)").arg(EVENT_STR_MODBUS_DIS, message.remove("0@"));
            _insertEventLog(msg);
        });

        /// RECORD IN EVENT LOG
        QString msg = QString("%1 (%2)").arg(EVENT_STR_MODBUS_CON, newConnectedClientIPv4);
        _insertEventLog(msg);

        return true;
    }

    QString msg = QString("%1 (%2)").arg(EVENT_STR_MODBUS_REJECT, newConnectedClientIPv4);
    _insertEventLog(msg);

    qWarning() << __func__ << "Warning! Got requested from not allowable client/master." << newConnectedClientIPv4;
    return false;
}

void MachineBackend::insertEventLog(const QString eventText)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    _insertEventLog(eventText);
}

void MachineBackend::refreshLogRowsCount(const QString table)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    if (table == QLatin1String("datalog")){

        QMetaObject::invokeMethod(m_pDataLog.data(), [&](){

            DataLogSql *sql = m_pDataLog->getPSqlInterface();

            /// check how many data log has stored now
            int count;
            bool success = sql->queryCount(&count);
            //        qDebug() << __FUNCTION__ << "success: " << success << count;
            if(success){
                pData->setDataLogCount(count);
                //            qDebug() << count << maximumRowCount;
                pData->setDataLogIsFull(count >= DATALOG_MAX_ROW);
            }//
        });
    }
    else if (table == QLatin1String("alarmlog")){
        QMetaObject::invokeMethod(m_pAlarmLog.data(), [&](){

            AlarmLogSql *sql = m_pAlarmLog->getPSqlInterface();

            /// check how many data log has stored now
            int count;
            bool success = sql->queryCount(&count);
            //        qDebug() << __FUNCTION__ << "success: " << success << count;
            if(success){
                pData->setAlarmLogCount(count);
                //            qDebug() << count << maximumRowCount;
                pData->setAlarmLogIsFull(count >= ALARMEVENTLOG_MAX_ROW);
            }//
        });
    }
    else if (table == QLatin1String("eventlog")){

        QMetaObject::invokeMethod(m_pEventLog.data(), [&](){

            EventLogSql *sql = m_pEventLog->getPSqlInterface();

            /// check how many data log has stored now
            int count;
            bool success = sql->queryCount(&count);
            //        qDebug() << __FUNCTION__ << "success: " << success << count;
            if(success){
                pData->setEventLogCount(count);
                //            qDebug() << count << maximumRowCount;
                pData->setEventLogIsFull(count >= ALARMEVENTLOG_MAX_ROW);
            }//
        });
    }
}

void MachineBackend::_onTriggeredEventEverySecond()
{
    //    qDebug() << metaObject()->className() << __func__  << thread();

    _readRTCActualTime();
}

void MachineBackend::_onTriggeredEventEveryMinute()
{
    qDebug() << __func__  << thread();

    m_uvSchedulerAutoSet->routineTask();
    m_fanSchedulerAutoSet->routineTask();

    //// SYNC LINUX TIME TO RTC
#ifdef __arm__
    QDateTime dateTimeLinux = QDateTime::currentDateTime();
    qDebug() << metaObject()->className() << __func__
             << "Sync linux time to RTC" << dateTimeLinux.toString("yyyy-MM-dd hh:mm:ss");
    /// if RTC time not valid, set to 2000-01-01 00:00:00
    m_boardCtpRTC->setClock(dateTimeLinux.time().hour(),
                            dateTimeLinux.time().minute(),
                            dateTimeLinux.time().second(),
                            I2CPort::I2C_SEND_MODE_QUEUE);
    m_boardCtpRTC->setDate(dateTimeLinux.date().weekNumber(),
                           dateTimeLinux.date().day(),
                           dateTimeLinux.date().month(),
                           dateTimeLinux.date().year(),
                           I2CPort::I2C_SEND_MODE_QUEUE);
#endif
}

void MachineBackend::_onTriggeredEventEveryHour()
{
    qDebug() << __func__  << thread();

    _checkCertificationReminder();
}

/**
 * @brief MachineBackend::_onTriggeredUvSchedulerAutoSet
 *
 * It's ca
 */
void MachineBackend::_onTriggeredUvSchedulerAutoSet()
{
    qDebug() << metaObject()->className() <<  __func__  << thread();

    m_pUV->setState(MachineEnums::DIG_STATE_ONE);

    _insertEventLog(EVENT_STR_UV_ON_SCH);
}

void MachineBackend::_onTriggeredFanSchedulerAutoSet()
{
    qDebug() << metaObject()->className() << __func__  << thread();

    _setFanPrimaryStateNominal();

    _insertEventLog(EVENT_STR_FAN_ON_SCH);
}

void MachineBackend::setUVAutoEnabled(int uvAutoSetEnabled)
{
    qDebug() << __func__  << thread();
    m_uvSchedulerAutoSet->setEnabled(uvAutoSetEnabled);

    pData->setUVAutoEnabled(uvAutoSetEnabled);

    QSettings settings;
    settings.setValue(SKEY_SCHEO_UV_ENABLE, uvAutoSetEnabled);
}

void MachineBackend::setUVAutoTime(int uvAutoSetTime)
{
    qDebug() << __func__  << thread();
    m_uvSchedulerAutoSet->setTime(uvAutoSetTime);

    pData->setUVAutoTime(uvAutoSetTime);

    QSettings settings;
    settings.setValue(SKEY_SCHEO_UV_TIME, uvAutoSetTime);
}

void MachineBackend::setUVAutoDayRepeat(int uvAutoSetDayRepeat)
{
    qDebug() << __func__  << thread();
    m_uvSchedulerAutoSet->setDayRepeat(uvAutoSetDayRepeat);

    pData->setUVAutoDayRepeat(uvAutoSetDayRepeat);

    QSettings settings;
    settings.setValue(SKEY_SCHEO_UV_REPEAT, uvAutoSetDayRepeat);
}

void MachineBackend::setUVAutoWeeklyDay(int uvAutoSetWeeklyDay)
{
    qDebug() << __func__  << thread();
    m_uvSchedulerAutoSet->setWeeklyDay(uvAutoSetWeeklyDay);

    pData->setUVAutoWeeklyDay(uvAutoSetWeeklyDay);

    QSettings settings;
    settings.setValue(SKEY_SCHEO_UV_REPEAT_DAY, uvAutoSetWeeklyDay);
}

void MachineBackend::setFanAutoEnabled(int fanAutoSetEnabled)
{
    qDebug() << __func__  << thread();
    m_fanSchedulerAutoSet->setEnabled(fanAutoSetEnabled);

    pData->setFanAutoEnabled(fanAutoSetEnabled);

    QSettings settings;
    settings.setValue(SKEY_SCHEO_FAN_ENABLE, fanAutoSetEnabled);
}

void MachineBackend::setFanAutoTime(int fanAutoSetTime)
{
    qDebug() << __func__  << thread();
    m_fanSchedulerAutoSet->setTime(fanAutoSetTime);

    pData->setFanAutoTime(fanAutoSetTime);

    QSettings settings;
    settings.setValue(SKEY_SCHEO_FAN_TIME, fanAutoSetTime);
}

void MachineBackend::setFanAutoDayRepeat(int fanAutoSetDayRepeat)
{
    qDebug() << __func__  << thread();
    m_fanSchedulerAutoSet->setDayRepeat(fanAutoSetDayRepeat);

    pData->setFanAutoDayRepeat(fanAutoSetDayRepeat);

    QSettings settings;
    settings.setValue(SKEY_SCHEO_FAN_REPEAT, fanAutoSetDayRepeat);
}

void MachineBackend::setFanAutoWeeklyDay(int fanAutoSetWeeklyDay)
{
    qDebug() << __func__  << thread();
    m_fanSchedulerAutoSet->setWeeklyDay(fanAutoSetWeeklyDay);

    pData->setFanAutoWeeklyDay(fanAutoSetWeeklyDay);

    QSettings settings;
    settings.setValue(SKEY_SCHEO_FAN_REPEAT_DAY, fanAutoSetWeeklyDay);
}

void MachineBackend::setEscoLockServiceEnable(int escoLockServiceEnable)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setEscoLockServiceEnable(escoLockServiceEnable);

    QSettings settings;
    settings.setValue(SKEY_ELS_ENABLE, escoLockServiceEnable);
}

void MachineBackend::setCabinetDisplayName(const QString cabinetDisplayName)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    QString nameNormalization = QString(cabinetDisplayName).replace(" ", "#~#");

#ifdef __linux__
    QtConcurrent::run([&, nameNormalization]{
        QProcess::execute("hostnamectl", QStringList() << "set-hostname" << nameNormalization);
    });
#endif

    pData->setCabinetDisplayName(cabinetDisplayName);

    QSettings settings;
    settings.setValue(SKEY_CAB_DISPLAY_NAME, nameNormalization);
}

void MachineBackend::setFanPIN(const QString fanPIN)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    QString fanPinEncode = QCryptographicHash::hash(fanPIN.toLocal8Bit(), QCryptographicHash::Md5).toHex();

    pData->setFanPIN(fanPinEncode);

    QSettings settings;
    settings.setValue(SKEY_FAN_PIN, fanPinEncode);
}

void MachineBackend::setFanUsageMeter(int minutes)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setFanUsageMeter(minutes);

    QSettings settings;
    settings.setValue(SKEY_FAN_METER, minutes);

    //        qDebug() << __func__ << "getFanUsageMeter"  << count;
}

void MachineBackend::setUvUsageMeter(int minutes)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    int minutesPercentLeft = __getPercentFrom(minutes, SDEF_UV_MAXIMUM_TIME_LIFE);

    /// event if in % value is zero but the minutes more then 0 minutes, then set % to 1
    if (minutesPercentLeft == 0 && minutes > 0) minutesPercentLeft = 1;

    //update to global observable variable
    pData->setUvLifeMinutes(minutes);
    pData->setUvLifePercent(minutesPercentLeft);

    //save to sattings
    QSettings settings;
    settings.setValue(SKEY_UV_METER, minutes);
}

void MachineBackend::setFilterUsageMeter(int minutes)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    int minutesPercentLeft = __getPercentFrom(minutes, SDEF_FILTER_MAXIMUM_TIME_LIFE);

    /// event if in % value is zero but the minutes more then 0 minutes, then set % to 1
    if (minutesPercentLeft == 0 && minutes > 0) minutesPercentLeft = 1;

    //update to global observable variable
    pData->setFilterLifeMinutes(minutes);
    pData->setFilterLifePercent(minutesPercentLeft);

    //save to sattings
    QSettings settings;
    settings.setValue(SKEY_FILTER_METER, minutes);

}

void MachineBackend::setSashCycleMeter(int sashCycleMeter)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setSashCycleMeter(sashCycleMeter);

    QSettings settings;
    settings.setValue(SKEY_SASH_CYCLE_METER, sashCycleMeter);
}

void MachineBackend::setEnvTempHighestLimit(int envTempHighestLimit)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setEnvTempHighestLimit(envTempHighestLimit);

    QSettings settings;
    settings.setValue(SKEY_ENV_TEMP_HIGH_LIMIT, envTempHighestLimit);
}

void MachineBackend::setEnvTempLowestLimit(int envTempLowestLimit)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setEnvTempLowestLimit(envTempLowestLimit);

    QSettings settings;
    settings.setValue(SKEY_ENV_TEMP_LOW_LIMIT, envTempLowestLimit);
}

void MachineBackend::setParticleCounterSensorInstalled(bool particleCounterSensorInstalled)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setParticleCounterSensorInstalled(particleCounterSensorInstalled);

    QSettings settings;
    settings.setValue(SKEY_PARTICLE_COUNTER_INST, particleCounterSensorInstalled ? 1 : 0);
}

void MachineBackend::setWatchdogResetterState(bool state)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    if(state)  m_timerEventForRTCWatchdogReset->start();
    else m_timerEventForRTCWatchdogReset->stop();
}

void MachineBackend::setShippingModeEnable(bool shippingModeEnable)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    QSettings setting;
    setting.setValue(SKEY_SHIPPING_MOD_ENABLE, shippingModeEnable? 1 : 0);

    /// clear the necesarry data
    if(shippingModeEnable) {
        /// clear all the database
        m_threadForAlarmLog->quit();
        m_threadForAlarmLog->wait();
        m_threadForEventLog->quit();
        m_threadForEventLog->wait();
        m_threadForDatalog->quit();
        m_threadForDatalog->wait();

        /// DATA LOG
        {
            m_pDataLogSql.reset(new DataLogSql);
            m_pDataLogSql->init("m_pDataLogSqlqueryDelete");
            m_pDataLogSql->queryDelete();
        }

        /// ALARM LOG
        {
            m_pAlarmLogSql.reset(new AlarmLogSql);
            m_pAlarmLogSql->init("m_pAlarmLogSqlqueryDelete");
            m_pAlarmLogSql->queryDelete();
        }

        /// EVENT LOG
        {
            m_pEventLogSql.reset(new EventLogSql);
            m_pEventLogSql->init("m_pEventLogSqlqueryDelete");
            m_pEventLogSql->queryDelete();
        }

        /// reset boys
        setting.setValue(SKEY_FILTER_METER, SDEF_FILTER_MAXIMUM_TIME_LIFE);
        setting.setValue(SKEY_FAN_METER, 0);
        setting.setValue(SKEY_SASH_CYCLE_METER, 0);
        setting.setValue(SKEY_UV_METER, SDEF_UV_MAXIMUM_TIME_LIFE);
    }

    pData->setShippingModeEnable(shippingModeEnable);
}

void MachineBackend::setCurrentSystemAsKnown(bool value)
{
    if(value){
        QString serialNumber = pData->getSbcCurrentSerialNumber();
        QStringList sysInfo = pData->getSbcCurrentSystemInformation();

        _setSbcSerialNumber(serialNumber);
        pData->setSbcSystemInformation(sysInfo);
        pData->setSbcCurrentSerialNumberKnown(true);
    }else return;
}

void MachineBackend::readSbcCurrentFullMacAddress()
{
    qDebug() << metaObject()->className() << __func__  << thread();
    pData->setSbcCurrentFullMacAddress(_readMacAddress());
    qDebug() << pData->getSbcCurrentFullMacAddress();
}

void MachineBackend::_machineState()
{
    //    qDebug() << __func__;

    ///ALARM BOARD
    bool alarmsBoards = false;
    alarmsBoards |= !pData->getBoardStatusHybridDigitalInput();
    alarmsBoards |= !pData->getBoardStatusHybridDigitalRelay();
    alarmsBoards |= !pData->getBoardStatusHybridAnalogInput();
    alarmsBoards |= !pData->getBoardStatusHybridAnalogOutput1();
    alarmsBoards |= !pData->getBoardStatusHybridAnalogOutput2();
    alarmsBoards |= !pData->getBoardStatusRbmCom();
    alarmsBoards |= !pData->getBoardStatusCtpRtc();
    alarmsBoards |= !pData->getBoardStatusCtpIoe();
    if(pData->getSeasInstalled()){alarmsBoards |= !pData->getBoardStatusPressureDiff();}

    ///demo
#ifdef QT_DEBUG
    alarmsBoards = false;
#endif

    if(alarmsBoards){
        if(!isAlarmActive(pData->getAlarmBoardComError())){
            pData->setAlarmBoardComError(MachineEnums::ALARM_ACTIVE_STATE);
        }
    }
    else {
        if(!isAlarmNormal(pData->getAlarmBoardComError())){
            pData->setAlarmBoardComError(MachineEnums::ALARM_NORMAL_STATE);
        }
    }

    /// STATE MACINE BASED ON OPERATION MODE AND SASH STATE
    int modeOperation = pData->getOperationMode();
    //    modeOperation = MachineEnums::MODE_OPERATION_NORMAL;

    switch (modeOperation) {
    case MachineEnums::MODE_OPERATION_QUICKSTART:
    case MachineEnums::MODE_OPERATION_NORMAL:
        //CONDITION BY MODE NORMAL OR QUICKSTART
    {
        ////CABINET WITH SEAS SIGNAL ALARM BOARD FOR COLLAR WITH FLAP
        if(pData->getSeasFlapInstalled()){
            //DEPENDING_TO_BLOWER_STATE
            //DEPENDING_TO_AF_CALIBRATION_STATUS
            //ONLY_IF_BLOWER_IS_ON
            short alarm = pData->getSeasFlapAlarmPressure();

            //                    if((isFanStateNominal() && isAirflowHasCalibrated())){
            //                        int actual  = pData->getSeasPressureDiffPa();
            //                        int fail    = pData->getSeasPressureDiffPaLowLimit();

            //                    printf("%d %d %s", actual, fail, (actual >= fail) ? "Bigger" : "Less");
            //                    fflush(stdout);

            if(pData->getMagSW6State()){
                //SEAS BOARD FLAP IS ALARM
                if(!isAlarmActive(alarm)){
                    /// SET ALARM EXHAUST
                    pData->setSeasFlapAlarmPressure(MachineEnums::ALARM_ACTIVE_STATE);

                    /// INSERT ALARM LOG
                    QString text = QString("%1")
                            .arg(ALARM_LOG_TEXT_SEAS_FLAP_LOW);
                    _insertAlarmLog(ALARM_LOG_CODE::ALC_SEAS_FLAP_LOW, text);
                }
            }
            else {
                //EXHAUST IS NORMAL
                if(!isAlarmNormal(alarm)){
                    //UNSET ALARM EXHAUST
                    pData->setSeasFlapAlarmPressure(MachineEnums::ALARM_NORMAL_STATE);

                    /// INSERT ALARM LOG
                    QString text = QString("%1")
                            .arg(ALARM_LOG_TEXT_SEAS_FLAP_OK);
                    _insertAlarmLog(ALARM_LOG_CODE::ALC_SEAS_FLAP_OK, text);
                }
            }
            //                    }
            //                    else {
            //                        if (!isAlarmNA(alarm)) {
            //                            //NOT APPLICABLE ALARM EXHAUST
            //                            pData->setSeasAlarmPressureLow(MachineEnums::ALARM_NA_STATE);
            //                        }
            //                    }
        }

        //CONDITION BY SASH
        switch (pData->getSashWindowState()) {
        case MachineEnums::SASH_STATE_WORK_SSV:
        {
            ////MOTORIZE SASH
            if(pData->getSashWindowMotorizeInstalled()){

                if(pData->getSashWindowMotorizeUpInterlocked()){
                    m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                }

                if(pData->getSashWindowMotorizeDownInterlocked()){
                    m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                }

                if(m_pSashWindow->isSashStateChanged()){
                    if(pData->getSashWindowMotorizeState()){
                        /// Count tubular motor cycle
                        int count = pData->getSashCycleMeter();
                        count = count + 5; /// the value deviced by 10
                        pData->setSashCycleMeter(count);
                        //                        qDebug() << metaObject()->className() << __func__ << "setSashCycleMeter: " << pData->getSashCycleMeter();
                        ///save permanently
                        QSettings settings;
                        settings.setValue(SKEY_SASH_CYCLE_METER, count);

                        /// Turned off mototrize in every defined magnetic switch
                        m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                        m_pSasWindowMotorize->routineTask();
                    }
                }
            }

            ////INTERLOCK UV IF DEVICE INSTALLED
            if(pData->getUvInstalled()){
                if(!pData->getUvInterlocked()){
                    m_pUV->setInterlock(MachineEnums::DIG_STATE_ONE);
                }
            }

            /////CLEAR INTERLOCK FAN
            if(pData->getFanPrimaryInterlocked()){
                _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ZERO);
            }

            /// CLEAR LAMP INTERLOCK
            if(pData->getLightInterlocked()){
                m_pLight->setInterlock(MachineEnums::DIG_STATE_ZERO);
            }

            ///////////////INTERLOCK GAS IF DEVICE INSTALLED AND WARMUP IS NOT ACTIVE
            if(pData->getGasInstalled()){
                if(isFanStateNominal()
                        && !pData->getPostPurgingActive()
                        && !pData->getWarmingUpActive()){
                    if (pData->getGasInterlocked()){
                        m_pGas->setInterlock(MachineEnums::DIG_STATE_ZERO);
                    }
                }
                else{
                    if (!pData->getGasInterlocked()){
                        m_pGas->setInterlock(MachineEnums::DIG_STATE_ONE);
                    }
                }
            }

            /// ALARM
            if(isAlarmActive(pData->getAlarmBoardComError())){
                /// THERE IS COMMUNICATION ERROR BETWEEN BOARD
                /// IN THIS SITUATION, AIRFLOW ALARM AND SASH ALARM NOT APPLICABLE (NA)

                if(!isAlarmNA(pData->getAlarmSash())){
                    pData->setAlarmSash(MachineEnums::ALARM_SASH_NA_STATE);
                }
                if(!isAlarmNA(pData->getAlarmInflowLow())) {
                    pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
                }
            }
            else {
                if(!isAlarmNormal(pData->getAlarmSash())){
                    short prevState = pData->getAlarmSash();
                    pData->setAlarmSash(MachineEnums::ALARM_SASH_NORMAL_STATE);

                    if (isAlarmActive(prevState)){
                        _insertAlarmLog(ALARM_LOG_CODE::ALC_SASH_WINDOW_OK,
                                        ALARM_LOG_TEXT_SASH_OK);
                    }
                }

                /// ENVIRONMENTAL TEMPERATURE ALARM
                if(isFanStateNominal()
                        && !pData->getWarmingUpActive()
                        && !pData->getPostPurgingActive()){

                    if (isTempAmbientHigh() && !isAlarmActive(pData->getAlarmTempHigh())) {
                        pData->setAlarmTempHigh(MachineEnums::ALARM_ACTIVE_STATE);

                        /// ALARM LOG
                        QString text = QString("%1 (%2)")
                                .arg(ALARM_LOG_TEXT_ENV_TEMP_TOO_HIGH, pData->getTemperatureValueStrf());
                        _insertAlarmLog(ALARM_LOG_CODE::ALC_ENV_TEMP_HIGH, text);
                    }
                    else if (!isTempAmbientHigh() && !isAlarmNormal(pData->getAlarmTempHigh())) {
                        pData->setAlarmTempHigh(MachineEnums::ALARM_NORMAL_STATE);

                        /// ALARM LOG
                        QString text = QString("%1 (%2)")
                                .arg(ALARM_LOG_TEXT_ENV_TEMP_OK, pData->getTemperatureValueStrf());
                        _insertAlarmLog(ALARM_LOG_CODE::ALC_ENV_TEMP_OK, text);
                    }

                    if (isTempAmbientLow() && !isAlarmActive(pData->getAlarmTempLow())) {
                        pData->setAlarmTempLow(MachineEnums::ALARM_ACTIVE_STATE);

                        /// ALARM LOG
                        QString text = QString("%1 (%2)")
                                .arg(ALARM_LOG_TEXT_ENV_TEMP_TOO_LOW, pData->getTemperatureValueStrf());
                        _insertAlarmLog(ALARM_LOG_CODE::ALC_ENV_TEMP_LOW, text);
                    }
                    else if (!isTempAmbientLow() && !isAlarmNormal(pData->getAlarmTempLow())) {
                        pData->setAlarmTempLow(MachineEnums::ALARM_NORMAL_STATE);

                        /// ALARM LOG
                        QString text = QString("%1 (%2)")
                                .arg(ALARM_LOG_TEXT_ENV_TEMP_OK, pData->getTemperatureValueStrf());
                        _insertAlarmLog(ALARM_LOG_CODE::ALC_ENV_TEMP_OK, text);
                    }
                }
                else {
                    if (!isAlarmNA(pData->getAlarmTempHigh())) {
                        pData->setAlarmTempHigh(MachineEnums::ALARM_NA_STATE);
                    }
                    if (isAlarmNA(pData->getAlarmTempLow())) {
                        pData->setAlarmTempLow(MachineEnums::ALARM_NA_STATE);
                    }
                }

                //ALARM AIRFLOW FLAG
                //IF FAN STATE IS NOMINAL
                //IF AIFLOW CALIBRATED IN FACTORY OR FIELD
                //OTHERWISE UNSET
                {
                    bool alarmInflowAvailable = false;
                    if(isFanStateNominal() && pData->getAirflowMonitorEnable()){
                        if (isAirflowHasCalibrated()){
                            if (isTempAmbientNormal()){
                                if (!pData->getWarmingUpActive()){
                                    alarmInflowAvailable = true;
                                    //                                if(!pData->dataPostpurgeState()){

                                    //SET IF ACTUAL AF IS LOWER THAN MINIMUM, OTHERWISE UNSET
                                    bool tooLow = false;
                                    tooLow = pData->getInflowVelocity() <= pData->getInflowLowLimitVelocity();
                                    //                                qDebug() << "tooLow: " << tooLow << pData->getInflowVelocity() << pData->getInflowLowLimitVelocity();

                                    if(tooLow){
                                        if(!isAlarmActive(pData->getAlarmInflowLow())){

                                            pData->setAlarmInflowLow(MachineEnums::ALARM_ACTIVE_STATE);

                                            QString text = QString("%1 (%2)")
                                                    .arg(ALARM_LOG_TEXT_INFLOW_ALARM_TOO_LOW, pData->getInflowVelocityStr());
                                            _insertAlarmLog(ALARM_LOG_CODE::ALC_INFLOW_ALARM_LOW, text);
                                        }
                                    }
                                    else {
                                        if(!isAlarmNormal(pData->getAlarmInflowLow())){
                                            short prevState = pData->getAlarmInflowLow();
                                            pData->setAlarmInflowLow(MachineEnums::ALARM_NORMAL_STATE);


                                            if(isAlarmActive(prevState)) {
                                                QString text = QString("%1 (%2)")
                                                        .arg(ALARM_LOG_TEXT_INFLOW_ALARM_OK, pData->getInflowVelocityStr());
                                                _insertAlarmLog(ALARM_LOG_CODE::ALC_INFLOW_ALARM_OK, text);
                                            }//
                                        }//
                                    }//
                                }//
                            }
                            //                    }
                        }
                    }
                    if(!alarmInflowAvailable){
                        if(!isAlarmNA(pData->getAlarmInflowLow())) {
                            pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
                        }
                    }
                }

                ////CABINET TYPE A, EXAMPLE LA2
                if(pData->getSeasInstalled()){
                    //DEPENDING_TO_BLOWER_STATE
                    //DEPENDING_TO_AF_CALIBRATION_STATUS
                    //ONLY_IF_BLOWER_IS_ON
                    int alarm = pData->getAlarmSeasPressureLow();
                    if((isFanStateNominal() && isAirflowHasCalibrated()) && pData->getAirflowMonitorEnable()){
                        int actual  = pData->getSeasPressureDiffPa();
                        int fail    = pData->getSeasPressureDiffPaLowLimit();

                        //                    printf("%d %d %s", actual, fail, (actual >= fail) ? "Bigger" : "Less");
                        //                    fflush(stdout);

                        if(actual >= fail){
                            //EXHAUST IS FAIL
                            if(!isAlarmActive(alarm)){
                                /// SET ALARM EXHAUST
                                pData->setSeasAlarmPressureLow(MachineEnums::ALARM_ACTIVE_STATE);

                                /// INSERT ALARM LOG
                                QString text = QString("%1 (%2)")
                                        .arg(ALARM_LOG_TEXT_SEAS_TOO_HIGH, pData->getSeasPressureDiffStr());
                                _insertAlarmLog(ALARM_LOG_CODE::ALC_SEAS_HIGH, text);
                            }
                        }
                        else {
                            //EXHAUST IS NORMAL
                            if(!isAlarmNormal(alarm)){
                                //UNSET ALARM EXHAUST
                                pData->setSeasAlarmPressureLow(MachineEnums::ALARM_NORMAL_STATE);

                                /// INSERT ALARM LOG
                                QString text = QString("%1 (%2)")
                                        .arg(ALARM_LOG_TEXT_SEAS_OK, pData->getSeasPressureDiffStr());
                                _insertAlarmLog(ALARM_LOG_CODE::ALC_SEAS_OK, text);
                            }
                        }
                    }
                    else {
                        if (!isAlarmNA(alarm)) {
                            //NOT APPLICABLE ALARM EXHAUST
                            pData->setSeasAlarmPressureLow(MachineEnums::ALARM_NA_STATE);
                        }
                    }
                }
            }

            //AUTOMATIC IO STATE
            //IF SASH STATE JUST CHANGED
            if(m_pSashWindow->isSashStateChanged()
                    && (m_pSashWindow->previousState() == MachineEnums::SASH_STATE_UNSAFE_SSV)
                    && !eventTimerForDelaySafeHeightAction){

                /// delayQuickModeAutoOn object will be destroyed when the sash state is changed
                /// see also _onSashStateChanged()

                /// Delay execution
                eventTimerForDelaySafeHeightAction = new QTimer();
                eventTimerForDelaySafeHeightAction->setInterval(m_sashSafeAutoOnOutputDelayTimeMsec);
                eventTimerForDelaySafeHeightAction->setSingleShot(true);
                ///Ececute this block after a certain time (m_sashSafeAutoOnOutputDelayTimeMsec)
                QObject::connect(eventTimerForDelaySafeHeightAction, &QTimer::timeout, eventTimerForDelaySafeHeightAction,
                                 [=](){

                    qDebug() << "Sash Safe Height after delay turned on out put";
                    ////TURN ON LAMP
                    m_pLight->setState(MachineEnums::DIG_STATE_ONE);
                    ///
                    _insertEventLog(EVENT_STR_LIGHT_ON);
                    ////IF CURRENT MODE MOPERATION IS QUICK START OR
                    ////IF CURRENT FAN STATE IS STANDBY SPEED; THEN
                    ////SWITCH BLOWER SPEED TO NOMINAL SPEED
                    bool autoOnBlower = false;
                    autoOnBlower |= (modeOperation == MachineEnums::MODE_OPERATION_QUICKSTART);
                    autoOnBlower |= (pData->getFanPrimaryState() == MachineEnums::FAN_STATE_STANDBY);
                    autoOnBlower &= (pData->getFanPrimaryState() != MachineEnums::FAN_STATE_ON);

                    if(autoOnBlower){
                        _setFanPrimaryStateNominal();
                        /// Tell every one if the fan state will be changing
                        emit pData->fanPrimarySwithingStateTriggered(MachineEnums::DIG_STATE_ONE);
                        ////
                        _insertEventLog(EVENT_STR_FAN_ON);
                    }

                    /// clear vivarium mute state
                    if(pData->getVivariumMuteState()){
                        setMuteVivariumState(false);
                    }
                });

                eventTimerForDelaySafeHeightAction->start();
            }
        }
            break;
        case MachineEnums::SASH_STATE_UNSAFE_SSV:
        {
            ////MOTORIZE SASH
            if(pData->getSashWindowMotorizeInstalled()){

                if(pData->getSashWindowMotorizeUpInterlocked()){
                    m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                }

                if(pData->getSashWindowMotorizeDownInterlocked()){
                    m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                }
            }

            ///LOCK FAN IF CURRENT STATE OFF
            if(!pData->getFanPrimaryState()){
                if(!pData->getFanPrimaryInterlocked()){
                    _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ONE);
                }
            }

            //LOCK LAMP
            if(!pData->getLightInterlocked()){
                m_pLight->setInterlock(MachineEnums::DIG_STATE_ONE);
            }

            //LOCK UV IF DEVICE INSTALLED
            if(pData->getUvInstalled()){
                if(!pData->getUvInterlocked()){
                    m_pUV->setInterlock(MachineEnums::DIG_STATE_ONE);
                }
            }

            //LOCK GAS IF DEVICE INSTALLED
            if(pData->getGasInstalled()){
                if(!pData->getGasInterlocked()){
                    m_pGas->setInterlock(MachineEnums::DIG_STATE_ONE);
                }
            }

            ////ALARM
            if(isAlarmActive(pData->getAlarmBoardComError())){
                /// THERE IS COMMUNICATION ERROR BETWEEN BOARD
                /// IN THIS SITUATION, AIRFLOW ALARM AND SASH ALARM NOT APPLICABLE (NA)

                if(!isAlarmNA(pData->getAlarmSash())){
                    pData->setAlarmSash(MachineEnums::ALARM_SASH_NA_STATE);
                }
            }
            else {
                ////SET ALARM SASH
                if(pData->getAlarmSash() != MachineEnums::ALARM_SASH_ACTIVE_UNSAFE_STATE){
                    pData->setAlarmSash(MachineEnums::ALARM_SASH_ACTIVE_UNSAFE_STATE);

                    ///update to alarm log
                    _insertAlarmLog(ALARM_LOG_CODE::ALC_SASH_WINDOW_UNSAFE,
                                    ALARM_LOG_TEXT_SASH_UNSAFE);
                }
            }

            ////NA ALARM AIRFLOW
            if(!isAlarmNA(pData->getAlarmInflowLow())){
                pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
            }

            if (!isAlarmNA(pData->getAlarmTempHigh())) {
                pData->setAlarmTempHigh(MachineEnums::ALARM_NA_STATE);
            }
            if (isAlarmNA(pData->getAlarmTempLow())) {
                pData->setAlarmTempLow(MachineEnums::ALARM_NA_STATE);
            }
        }
            break;
        case MachineEnums::SASH_STATE_FULLY_CLOSE_SSV:
        {
            ////MOTORIZE SASH
            if(pData->getSashWindowMotorizeInstalled()){

                if(pData->getSashWindowMotorizeUpInterlocked()){
                    m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                }

                if(!pData->getSashWindowMotorizeDownInterlocked()){
                    m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ONE);
                }

                if(m_pSashWindow->isSashStateChanged()){
                    if(pData->getSashWindowMotorizeState()){
                        m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                        m_pSasWindowMotorize->routineTask();
                    }
                }
            }

            //LOCK FAN
            if(!pData->getFanPrimaryInterlocked()){
                _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ONE);
            }

            //LOCK LAMP
            if(!pData->getLightInterlocked()){
                m_pLight->setInterlock(MachineEnums::DIG_STATE_ONE);
            }

            //UNLOCK UV IF DEVICE INSTALLED
            if(pData->getUvInstalled()){
                if(pData->getUvInterlocked()){
                    m_pUV->setInterlock(MachineEnums::DIG_STATE_ZERO);
                }
            }

            //LOCK GAS IF DEVICE INSTALLED
            if(pData->getGasInstalled()){
                if(!pData->getUvInterlocked()){
                    m_pGas->setInterlock(MachineEnums::DIG_STATE_ONE);
                }
            }

            ////NO APPLICABLE
            if(!isAlarmNA(pData->getAlarmSash())){
                pData->setAlarmSash(MachineEnums::ALARM_SASH_NA_STATE);
            }

            ///NO APPLICABLE AIRFLOW ALARM IF THE SASH NOT IN WORKING HEIGHT
            if(!isAlarmNA(pData->getAlarmInflowLow())){
                pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
            }
            //            //UNSET EXHAUST ALARM IF EXIST
            //            if(pData->dataExhPressureInstalled()){
            //                if(pData->dataExhPressureAlarm()){
            //                    pData->setDataExhPressureAlarm(MachineEnums::DIG_STATE_ZERO);
            //                }
            //            }
            if (!isAlarmNA(pData->getAlarmTempHigh())) {
                pData->setAlarmTempHigh(MachineEnums::ALARM_NA_STATE);
            }
            if (isAlarmNA(pData->getAlarmTempLow())) {
                pData->setAlarmTempLow(MachineEnums::ALARM_NA_STATE);
            }

        }
            break;
        case MachineEnums::SASH_STATE_STANDBY_SSV:
        {
            ////MOTORIZE SASH
            if(pData->getSashWindowMotorizeInstalled()){

                if(pData->getSashWindowMotorizeUpInterlocked()){
                    m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                }

                if(pData->getSashWindowMotorizeDownInterlocked()){
                    m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                }

                if(m_pSashWindow->isSashStateChanged()){
                    if(pData->getSashWindowMotorizeState()){
                        m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                        m_pSasWindowMotorize->routineTask();
                    }
                }
            }

            ////LOCK LAMP
            if(!pData->getLightInterlocked()){
                m_pLight->setInterlock(MachineEnums::DIG_STATE_ONE);
            }

            ////LOCK UV IF DEVICE INSTALLED
            if(pData->getUvInstalled()){
                if(!pData->getUvInterlocked()){
                    m_pUV->setInterlock(MachineEnums::DIG_STATE_ONE);
                }
            }

            //LOCK GAS IF DEVICE INSTALLED
            if(pData->getGasInstalled()){
                if(!pData->getGasInterlocked()){
                    m_pGas->setInterlock(MachineEnums::DIG_STATE_ONE);
                }
            }

            //UNLOCK FAN
            if(pData->getFanPrimaryInterlocked()){
                _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ZERO);
            }

            //AUTOMATIC IO STATE
            if(m_pSashWindow->isSashStateChanged()){
                if((pData->getFanPrimaryState() == MachineEnums::FAN_STATE_ON)){
                    if(!eventTimerForDelaySafeHeightAction){

                        /// delayQuickModeAutoOn oject will be destroyed when the sash state is changed
                        /// see also _onSashStateChanged()

                        /// Delay execution
                        eventTimerForDelaySafeHeightAction = new QTimer();
                        eventTimerForDelaySafeHeightAction->setInterval(m_sashSafeAutoOnOutputDelayTimeMsec);
                        eventTimerForDelaySafeHeightAction->setSingleShot(true);
                        ///Ececute this block after a certain time (m_sashSafeAutoOnOutputDelayTimeMsec)
                        QObject::connect(eventTimerForDelaySafeHeightAction, &QTimer::timeout, eventTimerForDelaySafeHeightAction,
                                         [=](){

                            qDebug() << "Sash Safe Height after delay turned on out put";
                            //TURN BLOWER TO STANDBY SPEED
                            _setFanPrimaryStateStandby();
                        });

                        eventTimerForDelaySafeHeightAction->start();
                    }
                    //                if(pData->getFanPrimaryState() == MachineEnums::FAN_STATE_ON){
                    //                    //TURN BLOWER TO STANDBY SPEED
                    //                    _setFanPrimaryStateStandby();
                    //                }
                }
            }

            ///ALARM
            if(isAlarmActive(pData->getAlarmBoardComError())){
                /// THERE IS COMMUNICATION ERROR BETWEEN BOARD
                /// IN THIS SITUATION, AIRFLOW ALARM AND SASH ALARM NOT APPLICABLE (NA)
                if(!isAlarmNA(pData->getAlarmSash())){
                    pData->setAlarmSash(MachineEnums::ALARM_SASH_NA_STATE);
                }
            }
            else {
                /// FAN IS IN STANDBY SPEED
                if(isFanStateStandby()){
                    ////UNSET ALARM SASH
                    if(!isAlarmNA(pData->getAlarmSash())){
                        pData->setAlarmSash(MachineEnums::ALARM_SASH_NA_STATE);
                    }
                }
                else {
                    if (!isAlarmActive(pData->getAlarmSash())){
                        pData->setAlarmSash(MachineEnums::ALARM_SASH_ACTIVE_UNSAFE_STATE);

                        _insertAlarmLog(ALARM_LOG_CODE::ALC_SASH_WINDOW_UNSAFE,
                                        ALARM_LOG_TEXT_SASH_UNSAFE);
                    }
                }
            }

            ///NO AVAILABLE AIRFLOW ALARM IF THE SASH NOT IN WORKING HEIGHT
            if(!isAlarmNA(pData->getAlarmInflowLow())){
                pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
            }

            //            //UNSET EXHAUST ALARM IF EXIST
            //            if(pData->dataExhPressureInstalled()){
            //                if(pData->dataExhPressureAlarm()){
            //                    pData->setDataExhPressureAlarm(MachineEnums::DIG_STATE_ZERO);
            //                }
            //            }

            if (!isAlarmNA(pData->getAlarmTempHigh())) {
                pData->setAlarmTempHigh(MachineEnums::ALARM_NA_STATE);
            }
            if (isAlarmNA(pData->getAlarmTempLow())) {
                pData->setAlarmTempLow(MachineEnums::ALARM_NA_STATE);
            }
        }
            break;
        case MachineEnums::SASH_STATE_FULLY_OPEN_SSV:
        {
            ////MOTORIZE SASH
            if(pData->getSashWindowMotorizeInstalled()){

                if(!pData->getSashWindowMotorizeUpInterlocked()){
                    m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ONE);
                }

                if(pData->getSashWindowMotorizeDownInterlocked()){
                    m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                }

                if(m_pSashWindow->isSashStateChanged()){
                    if(pData->getSashWindowMotorizeState()){
                        m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                        m_pSasWindowMotorize->routineTask();
                    }
                }
            }

            ///LOCK FAN IF CURRENT STATE OFF
            if(!pData->getFanPrimaryDutyCycle()){
                if(pData->getFanPrimaryInterlocked()){
                    _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ZERO);
                }
            }

            //UNLOCK LAMP
            if(pData->getLightInterlocked()){
                m_pLight->setInterlock(MachineEnums::DIG_STATE_ZERO);
            }

            //LOCK UV IF DEVICE INSTALLED
            if(pData->getUvInstalled()){
                if(!pData->getUvInterlocked()){
                    m_pUV->setInterlock(MachineEnums::DIG_STATE_ONE);
                }
            }

            //LOCK GAS IF DEVICE INSTALLED
            if(pData->getGasInstalled()){
                if(!pData->getGasInterlocked()){
                    m_pGas->setInterlock(MachineEnums::DIG_STATE_ONE);
                }
            }

            ///ALARMs
            if(isAlarmActive(pData->getAlarmBoardComError())){
                /// THERE IS COMMUNICATION ERROR BETWEEN BOARD
                /// IN THIS SITUATION, AIRFLOW ALARM AND SASH ALARM IS NOT APPLICABLE (NA)

                if(!isAlarmNA(pData->getAlarmSash())){
                    pData->setAlarmSash(MachineEnums::ALARM_SASH_NA_STATE);
                }
            }
            else {
                ////SET ALARM SASH
                if(pData->getAlarmSash() != MachineEnums::ALARM_SASH_ACTIVE_FO_STATE){
                    pData->setAlarmSash(MachineEnums::ALARM_SASH_ACTIVE_FO_STATE);

                    _insertAlarmLog(ALARM_LOG_CODE::ALC_SASH_WINDOW_FULLY_OPEN,
                                    ALARM_LOG_TEXT_SASH_FO);
                }
            }

            ///NO APPLICABLE AIRFLOW ALARM IF THE SASH NOT IN WORKING HEIGHT
            if(!isAlarmNA(pData->getAlarmInflowLow())){
                pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
            }

            //            //UNSET EXHAUST ALARM IF EXIST
            //            if(pData->dataExhPressureInstalled()){
            //                if(pData->dataExhPressureAlarm()){
            //                    pData->setDataExhPressureAlarm(MachineEnums::DIG_STATE_ZERO);
            //                }
            //            }

            if (!isAlarmNA(pData->getAlarmTempHigh())) {
                pData->setAlarmTempHigh(MachineEnums::ALARM_NA_STATE);
            }
            if (isAlarmNA(pData->getAlarmTempLow())) {
                pData->setAlarmTempLow(MachineEnums::ALARM_NA_STATE);
            }

        }
            break;
        default:
            //SASH SENSOR ERROR
        {
            ////MOTORIZE SASH
            if(pData->getSashWindowMotorizeInstalled()){

                if(pData->getSashWindowMotorizeUpInterlocked()){
                    m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                }

                if(pData->getSashWindowMotorizeDownInterlocked()){
                    m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                }

                if(m_pSashWindow->isSashStateChanged()){
                    if(pData->getSashWindowMotorizeState()){
                        m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                        m_pSasWindowMotorize->routineTask();
                    }
                }
            }

            //LOCK FAN
            if(!pData->getFanPrimaryInterlocked()){
                if(!pData->getFanPrimaryState()){
                    _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ONE);
                }
            }

            //LOCK LAMP
            if(!pData->getLightInterlocked()){
                m_pLight->setInterlock(MachineEnums::DIG_STATE_ONE);
            }

            //LOCK UV IF DEVICE INSTALLED
            if(pData->getUvInstalled()){
                if(!pData->getUvInterlocked()){
                    m_pUV->setInterlock(MachineEnums::DIG_STATE_ONE);
                }
            }

            //LOCK GAS IF DEVICE INSTALLED
            if(pData->getGasInstalled()){
                if(!pData->getGasInterlocked()){
                    m_pGas->setInterlock(MachineEnums::DIG_STATE_ONE);
                }
            }

            ///ALARMS
            if(isAlarmActive(pData->getAlarmBoardComError())){
                /// THERE IS COMMUNICATION ERROR BETWEEN BOARD
                /// IN THIS SITUATION, AIRFLOW ALARM AND SASH ALARM NOT APPLICABLE (NA)

                if(!isAlarmNA(pData->getAlarmSash())){
                    pData->setAlarmSash(MachineEnums::ALARM_SASH_NA_STATE);
                }
            }
            else {
                ////SET ALARM SASH
                if(pData->getAlarmSash() != MachineEnums::ALARM_SASH_ACTIVE_ERROR_STATE){
                    pData->setAlarmSash(MachineEnums::ALARM_SASH_ACTIVE_ERROR_STATE);

                    _insertAlarmLog(ALARM_LOG_CODE::ALC_SASH_WINDOW_ERROR,
                                    ALARM_LOG_TEXT_SASH_ERROR);
                }
            }

            ///NO APPLICABLE AIRFLOW ALARM IF THE SASH NOT IN WORKING HEIGHT
            if(!isAlarmNA(pData->getAlarmInflowLow())){
                pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
            }

            //            //UNSET EXHAUST ALARM IF EXIST
            //            if(pData->dataExhPressureInstalled()){
            //                if(pData->dataExhPressureAlarm()){
            //                    pData->setDataExhPressureAlarm(MachineEnums::DIG_STATE_ZERO);
            //                }
            //            }

            if (!isAlarmNA(pData->getAlarmTempHigh())) {
                pData->setAlarmTempHigh(MachineEnums::ALARM_NA_STATE);
            }
            if (isAlarmNA(pData->getAlarmTempLow())) {
                pData->setAlarmTempLow(MachineEnums::ALARM_NA_STATE);
            }
        }
            break;
        }
        //////////////////////////////////////////////CONDITION BY SASH - END
    }
        //////////////////////////////CONDITION BY MODE NORMAL OR QUICKSTART - END
        break;
    case MachineEnums::MODE_OPERATION_MAINTENANCE:
    {
        ////MOTORIZE SASH
        if(pData->getSashWindowMotorizeInstalled()){

            if(pData->getSashWindowMotorizeUpInterlocked()){
                m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
            }

            if(pData->getSashWindowMotorizeDownInterlocked()){
                m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
            }

            if(m_pSashWindow->isSashStateChanged()){
                if(pData->getSashWindowMotorizeState()){
                    m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                    m_pSasWindowMotorize->routineTask();
                }
            }
        }

        /////CLEAR INTERLOCK FAN
        if(pData->getFanPrimaryInterlocked()){
            _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ZERO);
        }

        ////CLEAR LIGHT GAS
        if(pData->getLightInterlocked()){
            m_pLight->setInterlock(MachineEnums::DIG_STATE_ZERO);
        }

        ////CLEAR INTERLOCK GAS IF DEVICE INSTALLED
        if(pData->getGasInstalled()){
            if (pData->getGasInterlocked()){
                m_pGas->setInterlock(MachineEnums::DIG_STATE_ZERO);
            }
        }

        ////CLEAR INTERLOCK UV IF DEVICE INSTALLED
        if(pData->getUvInstalled()){
            if(pData->getUvInterlocked()){
                m_pUV->setInterlock(MachineEnums::DIG_STATE_ZERO);
            }
        }

        /// CLEAR ALARM
        if(!isAlarmNA(pData->getAlarmSash())){
            pData->setAlarmSash(MachineEnums::ALARM_SASH_NA_STATE);
        }
        if(!isAlarmNA(pData->getAlarmInflowLow())){
            pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
        }
        if(!isAlarmActive(pData->getAlarmSeasPressureLow())){
            pData->setSeasAlarmPressureLow(MachineEnums::ALARM_NA_STATE);
        }
        if(!isAlarmActive(pData->getSeasFlapAlarmPressure())){
            pData->setSeasFlapAlarmPressure(MachineEnums::ALARM_NA_STATE);
        }
        if (!isAlarmNA(pData->getAlarmTempHigh())) {
            pData->setAlarmTempHigh(MachineEnums::ALARM_NA_STATE);
        }
        if (isAlarmNA(pData->getAlarmTempLow())) {
            pData->setAlarmTempLow(MachineEnums::ALARM_NA_STATE);
        }

        /// cleared mute audible alarm
        if (pData->getMuteAlarmState()){
            pData->setMuteAlarmState(MachineEnums::DIG_STATE_ZERO);
            _cancelMuteAlarmTimer();
        }

        /// clearm warming up state
        if (pData->getWarmingUpActive()){
            _cancelWarmingUpTime();
        }

        /// clearm post purge up state
        if (pData->getPostPurgingActive()){
            _cancelPostPurgingTime();
        }
    }
        break;
    }

    bool alarms = false;
    //Check The Alarms Only when SBC used is the registered SBC
    if(pData->getSbcCurrentSerialNumberKnown())
    {
        alarms |= isAlarmActive(pData->getAlarmBoardComError());
        alarms |= isAlarmActive(pData->getAlarmInflowLow());
        alarms |= isAlarmActive(pData->getAlarmSeasPressureLow());
        alarms |= isAlarmActive(pData->getSeasFlapAlarmPressure());
        alarms |= isAlarmActive(pData->getAlarmSash());
        alarms |= isAlarmActive(pData->getAlarmTempHigh());
        alarms |= isAlarmActive(pData->getAlarmTempLow());
        //    alarms = false;
        //    qDebug() << "alarms" << alarms;
        {
            int currentAlarm = pData->getAlarmsState();
            if (currentAlarm != alarms) {
                pData->setAlarmsState(alarms);

                //            qDebug() << "Audible Alarm" << pData->getMuteAlarmState() << pData->getVivariumMuteState();

                /// clear the mute of audible alarm
                if (pData->getMuteAlarmState()  && !pData->getVivariumMuteState()){
                    pData->setMuteAlarmState(MachineEnums::DIG_STATE_ZERO);
                    _cancelMuteAlarmTimer();
                }

                /// open the eyes, bolototkeun!
                _wakeupLcdBrightnessLevel();
            }
        }
    }else{
        pData->setAlarmsState(alarms);
    }

    //RELAY CONTACT STATE FOR BLOWER INDICATION
    //SET RELAY CONTACT ALARM IF INTERNAL BLOWER ON/STANDBY
    //OTHERWISE UNSET
    if(pData->getFanPrimaryState()){
        m_pExhaustContact->setState(MachineEnums::DIG_STATE_ONE);
    }else{
        m_pExhaustContact->setState(MachineEnums::DIG_STATE_ZERO);
    }

    //RELAY CONTACT STATE FOR BLOWER INDICATION
    //SET RELAY CONTACT ALARM IF INTERNAL BLOWER ON/STANDBY
    //OTHERWISE UNSET
    if(pData->getAlarmsState()){
        m_pAlarmContact->setState(MachineEnums::DIG_STATE_ONE);
    }else{
        m_pAlarmContact->setState(MachineEnums::DIG_STATE_ZERO);
    }

    /// MODBUS ALARM STATUS
    _setModbusRegHoldingValue(modbusRegisterAddress.alarmCom.addr, pData->getAlarmBoardComError());
    _setModbusRegHoldingValue(modbusRegisterAddress.alarmSash.addr, pData->getAlarmSash());
    _setModbusRegHoldingValue(modbusRegisterAddress.alarmInflow.addr, pData->getAlarmInflowLow());
    if(pData->getSeasInstalled()){
        _setModbusRegHoldingValue(modbusRegisterAddress.alarmExhaust.addr, pData->getAlarmSeasPressureLow());
    }
    if(pData->getSeasFlapInstalled()){
        _setModbusRegHoldingValue(modbusRegisterAddress.alarmFlapExhaust.addr, static_cast<ushort>(pData->getSeasFlapAlarmPressure()));
    }

    /// CLEAR FLAG OF SASH STATE FLAG
    if(m_pSashWindow->isSashStateChanged()){
        m_pSashWindow->clearFlagSashStateChanged();
    }
}

#ifdef QT_DEBUG
void MachineBackend::onDummyStateNewConnection()
{
    QWebSocket *pSocket = m_pWebSocketServerDummyState->nextPendingConnection();

    qDebug() << "Client connected:" << pSocket->peerAddress();

    connect(pSocket, &QWebSocket::textMessageReceived, pSocket, [&](const QString message){

        qDebug() << "Client textMessageReceived:" << message;

        if(message == QLatin1String("#sash#dummy#1")){
            m_pSashWindow->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#sash#dummy#0")){
            m_pSashWindow->setDummyStateEnable(0);
        }
        else if(message == QLatin1String("#sash#state#fc")){
            m_pSashWindow->setDummyState(SashWindow::SASH_STATE_FULLY_CLOSE_SSV);
        }
        else if(message == QLatin1String("#sash#state#uh")){
            m_pSashWindow->setDummyState(SashWindow::SASH_STATE_UNSAFE_SSV);
        }
        else if(message == QLatin1String("#sash#state#sh")){
            m_pSashWindow->setDummyState(SashWindow::SASH_STATE_WORK_SSV);
        }
        else if(message == QLatin1String("#sash#state#sb")){
            m_pSashWindow->setDummyState(SashWindow::SASH_STATE_STANDBY_SSV);
        }
        else if(message == QLatin1String("#sash#state#fo")){
            m_pSashWindow->setDummyState(SashWindow::SASH_STATE_FULLY_OPEN_SSV);
        }
        else if(message == QLatin1String("#sash#state#er")){
            m_pSashWindow->setDummyState(SashWindow::SASH_STATE_ERROR_SENSOR_SSV);
        }

        if(message == QLatin1String("#fan#dummy#1")){
            QMetaObject::invokeMethod(m_pFanPrimary.data(),[&]{
                m_pFanPrimary->setDummyStateEnable(1);
            },
            Qt::QueuedConnection);
            QMetaObject::invokeMethod(m_pFanInflow.data(),[&]{
                m_pFanInflow->setDummyStateEnable(1);
            },
            Qt::QueuedConnection);
        }
        else if(message == QLatin1String("#fan#dummy#0")){
            QMetaObject::invokeMethod(m_pFanPrimary.data(),[&]{
                m_pFanPrimary->setDummyStateEnable(0);
            },
            Qt::QueuedConnection);
            QMetaObject::invokeMethod(m_pFanInflow.data(),[&]{
                m_pFanInflow->setDummyStateEnable(0);
            },
            Qt::QueuedConnection);
        }
        else if(message.contains("#fan#state#")){
            QString adcStr = message.split("#", Qt::SkipEmptyParts)[2];
            int value = std::atoi(adcStr.toStdString().c_str());
            QMetaObject::invokeMethod(m_pFanPrimary.data(),[&, value]{
                m_pFanPrimary->setDummyState(value);
            },
            Qt::QueuedConnection);
            QMetaObject::invokeMethod(m_pFanInflow.data(),[&, value]{
                m_pFanInflow->setDummyState(value);
            },
            Qt::QueuedConnection);
        }
        else if(message.contains("#fan#rpm#")){
            QString adcStr = message.split("#", Qt::SkipEmptyParts)[2];
            int value = std::atoi(adcStr.toStdString().c_str());
            QMetaObject::invokeMethod(m_pFanPrimary.data(),[&, value]{
                m_pFanPrimary->setDummyRpm(value);
            },
            Qt::QueuedConnection);
        }

        if(message == QLatin1String("#lamp#dummy#1")){
            m_pLight->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#lamp#dummy#0")){
            m_pLight->setDummyStateEnable(0);
        }
        else if(message == QLatin1String("#lamp#state#1")){
            m_pLight->setDummyState(1);
        }
        else if(message == QLatin1String("#lamp#state#0")){
            m_pLight->setDummyState(0);
        }

        if(message == QLatin1String("#socket#dummy#1")){
            m_pSocket->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#socket#dummy#0")){
            m_pSocket->setDummyStateEnable(0);
        }
        else if(message == QLatin1String("#socket#state#1")){
            m_pSocket->setDummyState(1);
        }
        else if(message == QLatin1String("#socket#state#0")){
            m_pSocket->setDummyState(0);
        }

        if(message == QLatin1String("#gas#dummy#1")){
            m_pGas->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#gas#dummy#0")){
            m_pGas->setDummyStateEnable(0);
        }
        else if(message == QLatin1String("#gas#state#1")){
            m_pGas->setDummyState(1);
        }
        else if(message == QLatin1String("#gas#state#0")){
            m_pGas->setDummyState(0);
        }

        if(message == QLatin1String("#lampdim#dummy#1")){
            m_pLightIntensity->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#lampdim#dummy#0")){
            m_pLightIntensity->setDummyStateEnable(0);
        }

        if(message == QLatin1String("#uv#dummy#1")){
            m_pUV->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#uv#dummy#0")){
            m_pUV->setDummyStateEnable(0);
        }
        else if(message == QLatin1String("#uv#state#1")){
            m_pUV->setDummyState(1);
        }
        else if(message == QLatin1String("#uv#state#0")){
            m_pUV->setDummyState(0);
        }

        if(message == QLatin1String("#ifadc#dummy#1")){
            m_pAirflowInflow->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#ifadc#dummy#0")){
            m_pAirflowInflow->setDummyStateEnable(0);
        }
        else if(message.contains("#ifadc#state#")){
            QString adcStr = message.split("#", Qt::SkipEmptyParts)[2];
            int adc = std::atoi(adcStr.toStdString().c_str());
            m_pAirflowInflow->setDummyState(adc);
        }

        if(message == QLatin1String("#sashmotor#dummy#1")){
            m_pSasWindowMotorize->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#sashmotor#dummy#0")){
            m_pSasWindowMotorize->setDummyStateEnable(0);
        }
        else if(message == QLatin1String("#sashmotor#state#0")){
            m_pSasWindowMotorize->setDummyState(MachineEnums::MOTOR_SASH_STATE_OFF);
        }
        else if(message == QLatin1String("#sashmotor#state#1")){
            m_pSasWindowMotorize->setDummyState(MachineEnums::MOTOR_SASH_STATE_UP);
        }
        else if(message == QLatin1String("#sashmotor#state#2")){
            m_pSasWindowMotorize->setDummyState(MachineEnums::MOTOR_SASH_STATE_DOWN);
        }

        if(message == QLatin1String("#temp#dummy#1")){
            m_pTemperature->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#temp#dummy#0")){
            m_pTemperature->setDummyStateEnable(0);
        }
        else if(message.contains("#temp#adc#")){
            QString adcStr = message.split("#", Qt::SkipEmptyParts)[2];
            int value = std::atoi(adcStr.toStdString().c_str());
            m_pTemperature->setDummyAdcState(value);
        }
        else if(message.contains("#temp#volt#")){
            QString adcStr = message.split("#", Qt::SkipEmptyParts)[2];
            int value = std::atoi(adcStr.toStdString().c_str());
            m_pTemperature->setDummyMVoltState(value);
        }

        if(message == QLatin1String("#seas#dummy#1")){
            m_pSeas->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#seas#dummy#0")){
            m_pSeas->setDummyStateEnable(0);
        }
        else if(message.contains("#seas#state#")){
            QString adcStr = message.split("#", Qt::SkipEmptyParts)[2];
            int value = std::atoi(adcStr.toStdString().c_str());
            //            qDebug() << message << value;
            m_pSeas->setDummyState(value);
        }
    });
    connect(pSocket, &QWebSocket::disconnected, [=]{
        qDebug() << "Someone disconnected!";
    });

    m_clientsDummyState << pSocket;
}

#endif

//void MachineBackend::_onExhPressureActualPaChanged(int newVal)
//{
//    pData->setDataExhPressureActualPa(newVal);
//}
