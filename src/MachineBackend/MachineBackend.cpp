#include <QSerialPortInfo>
#include <QSerialPort>
#include <QTimer>
#include <QSettings>
#include <QThread>
#include <QProcess>
#include <QtConcurrent/QtConcurrent>
#include "QtNetwork/QNetworkInterface"
#include <QJsonObject>
#include <QJsonArray>

#include <QTcpSocket>
#include <QModbusTcpServer>
#include <QHostAddress>
#include "Implementations/Modbus/QModbusTcpConnObserverImp.h"

#include "MachineBackend.h"

#include "MachineData.h"
//#include "MachineEnums.h"
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
#include "Implementations/PWMOut/DevicePWMOut.h"
#include "Implementations/MotorizeOnRelay/MotorizeOnRelay.h"
#include "Implementations/AirflowVelocity/AirflowVelocity.h"
#include "Implementations/ClosedLoopControl/ClosedLoopControl.h"
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
#include "Implementations/ReplaceableCompRecord/ReplaceableCompRecord.h"
#include "Implementations/ReplaceableCompRecord/ReplaceableCompRecordSql.h"

#include "Implementations/ResourceMonitorLog/ResourceMonitorLogSql.h"
#include "Implementations/ResourceMonitorLog/ResourceMonitorLog.h"

#include "Implementations/SchedulerDayOutput/SchedulerDayOutput.h"
#include "Implementations/Modbus/QModbusTcpAddressEnum.h"

#include "Implementations/CheckSWUpdate/CheckSWUpdate.h"
#include "Implementations/USBAutoMount/USBAutoMount.h"

// clang-format off
/// MODBUS REGISTER
struct modbusRegisterAddress
{
    struct OperationMode                {static const short addr = Addrs::OperationMode;                short rw = 0;} OperationMode;
    struct SashState                    {static const short addr = Addrs::SashState;                    short rw = 0;} SashState;
    struct FanState                     {static const short addr = Addrs::FanState;                     short rw = 0;} FanState;
    struct DfaFanState                  {static const short addr = Addrs::DfaFanState;                  short rw = 0;} DfaFanState;
    struct DfaFanDutyCycle              {static const short addr = Addrs::DfaFanDutyCycle;              short rw = 0;} DfaFanDutyCycle;
    struct DfaFanRpm                    {static const short addr = Addrs::DfaFanRpm;                    short rw = 0;} DfaFanRpm;
    struct DfaFanUsage                  {static const short addr = Addrs::DfaFanUsage;                  short rw = 0;} DfaFanUsage;
    struct IfaFanState                  {static const short addr = Addrs::IfaFanState;                  short rw = 0;} IfaFanState;
    struct IfaFanDutyCycle              {static const short addr = Addrs::IfaFanDutyCycle;              short rw = 0;} IfaFanDutyCycle;
    struct IfaFanRpm                    {static const short addr = Addrs::IfaFanRpm;                    short rw = 0;} IfaFanRpm;
    struct IfaFanUsage                  {static const short addr = Addrs::IfaFanUsage;                  short rw = 0;} IfaFanUsage;
    struct LightState                   {static const short addr = Addrs::LightState;                   short rw = 0;} LightState;
    struct LightIntensity               {static const short addr = Addrs::LightIntensity;               short rw = 0;} LightIntensity;
    struct SocketState                  {static const short addr = Addrs::SocketState;                  short rw = 0;} SocketState;
    struct GasState                     {static const short addr = Addrs::GasState;                     short rw = 0;} GasState;
    struct UvState                      {static const short addr = Addrs::UvState;                      short rw = 0;} UvState;
    struct UvLifeLeft                   {static const short addr = Addrs::UvLifeLeft;                   short rw = 0;} UvLifeLeft;
    struct FilterLife                   {static const short addr = Addrs::FilterLife;                   short rw = 0;} FilterLife;

    struct SashMotorizeState            {static const short addr = Addrs::SashMotorizeState;            short rw = 0;} SashMotorizeState;//Spare
    struct SashCycle                    {static const short addr = Addrs::SashCycle;                    short rw = 0;} SashCycle;//Spare
    struct MeaUnit                      {static const short addr = Addrs::MeaUnit;                      short rw = 0;} MeaUnit;
    struct Temperature                  {static const short addr = Addrs::Temperature;                  short rw = 0;} Temperature;
    struct AirflowInflow                {static const short addr = Addrs::AirflowInflow;                short rw = 0;} AirflowInflow;
    struct AirflowDownflow              {static const short addr = Addrs::AirflowDownflow;              short rw = 0;} AirflowDownflow;
    struct PressureExhaust              {static const short addr = Addrs::PressureExhaust;              short rw = 0;} PressureExhaust;//Spare
    struct AlarmSash                    {static const short addr = Addrs::AlarmSash;                    short rw = 0;} AlarmSash;
    struct AlarmInflowLow               {static const short addr = Addrs::AlarmInflowLow;               short rw = 0;} AlarmInflowLow;
    struct AlarmInflowHigh              {static const short addr = Addrs::AlarmInflowHigh;              short rw = 0;} AlarmInflowHigh;//Spare
    struct AlarmDownflowLow             {static const short addr = Addrs::AlarmDownflowLow;             short rw = 0;} AlarmDownflowLow;//Spare
    struct AlarmDownflowHigh            {static const short addr = Addrs::AlarmDownflowHigh;            short rw = 0;} AlarmDownflowHigh;//Spare
    struct AlarmExhaustLow              {static const short addr = Addrs::AlarmExhaustLow;              short rw = 0;} AlarmExhaustLow;//Spare
    struct AlarmFlapExhaust             {static const short addr = Addrs::AlarmFlapExhaust;             short rw = 0;} AlarmFlapExhaust;//Spare
    struct AlarmBoardCom                {static const short addr = Addrs::AlarmBoardCom;                short rw = 0;} AlarmBoardCom;
    struct AlarmTempLow                 {static const short addr = Addrs::AlarmTempLow;                 short rw = 0;} AlarmTempLow;
    struct AlarmTempHigh                {static const short addr = Addrs::AlarmTempHigh;                short rw = 0;} AlarmTempHigh;
    struct AlarmSashCycleMotorLocked    {static const short addr = Addrs::AlarmSashCycleMotorLocked;    short rw = 0;} AlarmSashCycleMotorLocked;//Spare
    struct AlarmStbFanOff               {static const short addr = Addrs::AlarmStbFanOff;               short rw = 0;} AlarmStbFanOff;
    struct AlarmFrontPanel              {static const short addr = Addrs::AlarmFrontPanel;              short rw = 0;} AlarmFrontPanel;
    struct AlarmSashDownStuck           {static const short addr = Addrs::AlarmSashDownStuck;           short rw = 0;} AlarmSashDownStuck;
    /// Not used
    struct FanClosedLoopControl         {static const short addr = Addrs::FanClosedLoopControl;         short rw = 0;} FanClosedLoopControl;
} modbusRegisterAddress;
// clang-format on

#define MODBUS_REGISTER_COUNT Addrs::Total
#define ALLOW_ANY_IP            "0.0.0.0"
#define LOCALHOST_ONLY "127.0.0.1"

//#define ON_TESTING


MachineBackend::MachineBackend(QObject *parent) : QObject(parent)
{
}

MachineBackend::~MachineBackend()
{
    //qDebug() << metaObject()->className() << __FUNCTION__<< thread();
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

    //    {
    //        bool wifiDisabled = m_settings->value(SKEY_WIFI_DISABLED, false).toBool();
    //        pData->setWifiDisabled(wifiDisabled);
    //    }

    /// USB Auto Mount
    {
        m_pUSBAutoMount.reset(new USBAutoMount);

        QObject::connect(m_pUSBAutoMount.data(), &USBAutoMount::usbDetectedListChanged,
                         this, [&](const QString &usbList){
                             //qDebug() << "USB List Changed " << usbList;
                             pData->setUsbDetectedList(usbList);

                             if(usbList != ""){
                                 QStringList nameList = usbList.split(",", Qt::SplitBehaviorFlags::SkipEmptyParts);
                                 pData->setLastUsbDetectedName(nameList[nameList.length() - 1]);
                             }
                             else pData->setLastUsbDetectedName("");
                         });

        QObject::connect(m_pUSBAutoMount.data(), &USBAutoMount::usbHasMounted,
                         this, [&](const QString &name){
                             //qDebug() << "USB Has Mounted " << name;
                             //pData->setLastUsbDetectedName(name);

                             emit pData->usbHasMounted(name);
                         });

        QObject::connect(m_pUSBAutoMount.data(), &USBAutoMount::usbHasEjected,
                         this, [&](const QString &name){
                             //qDebug() << "USB Has Ejected " << name;
                             emit pData->usbHasEjected(name);
                         });

        /// TIMER
        m_timerEventForUSBAutoMount.reset(new QTimer);
        m_timerEventForUSBAutoMount->setInterval(5000);

        QObject::connect(m_timerEventForUSBAutoMount.data(), &QTimer::timeout,
                         m_pUSBAutoMount.data(), [&](){
                             //qDebug() << "Check USB List";
                             m_pUSBAutoMount->routineTask();
                         });

        /// THREAD
        m_threadForUSBAutoMount.reset(new QThread);

        QObject::connect(m_threadForUSBAutoMount.data(), &QThread::started,
                         m_timerEventForUSBAutoMount.data(), [&](){
                             m_timerEventForUSBAutoMount->start();
                         });
        QObject::connect(m_threadForUSBAutoMount.data(), &QThread::finished,
                         m_timerEventForUSBAutoMount.data(), [&](){
                             m_timerEventForUSBAutoMount->stop();
                         });

        QObject::connect(this, &MachineBackend::loopStarted,
                         [&](){
                             m_threadForUSBAutoMount->start();
                         });

        /// move the object to extra thread, so every query will execute in the separated thread
        m_pUSBAutoMount->moveToThread(m_threadForUSBAutoMount.data());
        m_timerEventForUSBAutoMount->moveToThread(m_threadForUSBAutoMount.data());
    }//

    /// Read App Software version
    QString newAppName = (QFileInfo(QCoreApplication::applicationFilePath()).fileName()).replace(".exe", "");
    newAppName = newAppName.toUpper();
    qDebug() << "&&&&!!!!!" << newAppName;

    QString  appNameVersion = m_settings->value(SKEY_SBC_SOFTWARE_VERSION, "none").toString();
    if(appNameVersion == "none"){
        m_settings->setValue(SKEY_SBC_SOFTWARE_VERSION, newAppName);
    }
    if(appNameVersion != newAppName){
        m_settings->setValue(SKEY_SBC_SOFTWARE_VERSION, newAppName);
        appNameVersion = newAppName;
        ///event log
        qWarning() << QObject::tr("Software has been updated to") + QString(" %1").arg(newAppName);
        //_insertEventLog(QString(EVENT_STR_APP_UPDATED) + QString(" %1").arg(newAppName));
    }

    /// CHECK FOR SOFTWARE UPDATE
    {
        QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
        qDebug() << targetDir;
        QString targetLocation = targetDir + QString("/swupdate/");

        bool  swuAvailable = m_settings->value(SKEY_SBC_SWU_AVAILABLE, false).toBool();
        QString  swu = m_settings->value(SKEY_SBC_SWU_VERSION, appNameVersion.replace(" ", "")).toString();
        QString  path = m_settings->value(SKEY_SBC_SWU_PATH, targetLocation + swu + ".swu").toString();
        bool checkEn = m_settings->value(SKEY_SBC_SVN_UPDATE_EN, false).toBool(); //Enable manually from Software Update Page
        int checkPeriod = m_settings->value(SKEY_SBC_SVN_UPDATE_PRD, 1).toInt();

        pData->setSvnUpdateAvailable(swuAvailable);
        pData->setSvnUpdateSwuVersion(swu);
        pData->setSvnUpdatePath(path);
        pData->setSvnUpdateCheckForUpdateEnable(checkEn);
        pData->setSvnUpdateCheckForUpdatePeriod(checkPeriod);

        m_pCheckSwUpdate.reset(new CheckSWUpdate);
        m_pCheckSwUpdate->setCheckForSWUpdateEnable(checkEn);
        m_pCheckSwUpdate->setCurrentSoftwareVersion(appNameVersion);
        m_pCheckSwUpdate->setProductionLine(CheckSWUpdate::ProductionLine::One);
        /// Initialize history file
        m_pCheckSwUpdate->initSoftwareHistoryUrl();
        pData->setSvnUpdateHistory(m_pCheckSwUpdate->getSwUpdateHistory());

        QObject::connect(m_pCheckSwUpdate.data(), &CheckSWUpdate::swUpdateAvailable,
                         this, [&](QString swu, QString path, QJsonObject history){
                             _setSoftwareUpdateAvailable(swu, path, history);
                         });
        QObject::connect(m_pCheckSwUpdate.data(), &CheckSWUpdate::swUpdateAvailableReset,
                         this, [&](){
                             _setSoftwareUpdateAvailableReset();
                         });
        QObject::connect(pData, &MachineData::svnUpdateCheckForUpdateEnableChanged,
                         m_pCheckSwUpdate.data(), &CheckSWUpdate::setCheckForSWUpdateEnable);

        /// TIMER
        m_timerEventForCheckSwUpdate.reset(new QTimer);
        m_timerEventForCheckSwUpdate->setInterval(checkPeriod * 60000);
        ///
        QObject::connect(m_timerEventForCheckSwUpdate.data(), &QTimer::timeout,
                         m_pCheckSwUpdate.data(), [&](){
                             if(!m_pCheckSwUpdate->getProcessRunning()){
                                 m_pCheckSwUpdate->routineTask();
                             }//
                         });

        /// THREAD
        m_threadForCheckSwUpdate.reset(new QThread);

        QObject::connect(m_threadForCheckSwUpdate.data(), &QThread::started,
                         m_timerEventForCheckSwUpdate.data(), [&](){
                             if(pData->getSvnUpdateCheckForUpdateEnable())
                                 m_timerEventForCheckSwUpdate->start();
                         });
        QObject::connect(m_threadForCheckSwUpdate.data(), &QThread::finished,
                         m_timerEventForCheckSwUpdate.data(), [&](){
                             m_timerEventForCheckSwUpdate->stop();
                         });

        QObject::connect(this, &MachineBackend::loopStarted,
                         [&](){
                             m_threadForCheckSwUpdate->start();
                         });

        /// move the object to extra thread, so every query will execute in the separated thread
        m_pCheckSwUpdate->moveToThread(m_threadForCheckSwUpdate.data());
        m_timerEventForCheckSwUpdate->moveToThread(m_threadForCheckSwUpdate.data());
    }//

    {
        int screensaver = m_settings->value(SKEY_SCREEN_SAVER_SEC, 1800).toInt();
        pData->setScreenSaverSeconds(screensaver);
    }
    {
        int cabSideType = m_settings->value(SKEY_CABINET_SIDE_TYPE, 0).toInt();
        pData->setCabinetSideType(cabSideType);
    }

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
        }//
        //        pData->setSbcCurrentSerialNumberKnown(false);
    }
    /// READ SYSTEM INFORMATION
    {
        QStringList sysInfoDefault = (QStringList() << SDEF_SBC_SYS_INFO);
        QStringList sysInfo = m_settings->value(SKEY_SBC_SYS_INFO, sysInfoDefault).toStringList();
        pData->setSbcSystemInformation(sysInfo);
        //qDebug() << "------ SysInfo ------";
        //qDebug() << sysInfo;

        if(sysInfo == sysInfoDefault){
            sysInfo = _readSbcSystemInformation();
            _setSbcSystemInformation(sysInfo);
            _setSbcCurrentSystemInformation(sysInfo);
        }else{
            sysInfo = _readSbcSystemInformation();
            _setSbcCurrentSystemInformation(sysInfo);
        }
    }

    ///// Cabinet Width
    {
        /// query profile from machine profile
        QJsonObject machineProfile = pData->getMachineProfile();
        QJsonObject cabinetSize = machineProfile.value("width").toObject();
        int cabFeet = qRound(cabinetSize.value("feet").toDouble());
        pData->setCabinetWidth3Feet(false);
        pData->setCabinetWidthFeet(cabFeet);
        qDebug() << "Cabinet Width:" << cabFeet << "ft";
        qDebug() << "Cabinet Width 3 Ft:" << pData->getCabinetWidth3Feet();
    }//
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
                short response = static_cast<short>(m_boardCtpRTC->init());

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

            //abort();

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
                                     qDebug() << "DIOpca9674::errorComToleranceCleared" << error << thread();
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
                /// Switch Off All Output
                m_boardRelay1->initState(8);

                pData->setBoardStatusHybridDigitalRelay(!response);

                ////MONITORING COMMUNICATION STATUS
                QObject::connect(m_boardRelay1.data(), &PWMpca9685::errorComToleranceReached,
                                 this, [&](int error){
                                     qDebug() << "m_boardRelay1::errorComToleranceReached" << error << thread();
                                     pData->setBoardStatusHybridDigitalRelay(false);
                                 });
                QObject::connect(m_boardRelay1.data(), &PWMpca9685::errorComToleranceCleared,
                                 this, [&](int error){
                                     qDebug() << "m_boardRelay1::errorComToleranceCleared" << error << thread();
                                     pData->setBoardStatusHybridDigitalRelay(true);
                                 });
            }


            //// Create Independent Timer Event For Sash Motorize Auto Off after having stucked
            //            m_timerEventForSashMotorInterlockSwitch.reset(new QTimer);
            //            m_timerEventForSashMotorInterlockSwitch->setInterval(std::chrono::milliseconds(1000));

            //            QObject::connect(m_timerEventForSashMotorInterlockSwitch.data(), &QTimer::timeout,
            //                             this, [&](){
            //                qDebug() << "m_timerEventForSashMotorInterlockSwitch" << "Switch Off sash motor";
            //                m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
            //                m_pSasWindowMotorize->routineTask();
            //                m_timerEventForSashMotorInterlockSwitch->stop();
            //            });

            /// HAB - Analog Input
            {
                m_boardAnalogInput1.reset(new AIManage);
                m_boardAnalogInput1->setupAIModule();
                m_boardAnalogInput1->setI2C(m_i2cPort.data());
                //                if(pData->getCabinetWidth3Feet())
                //                    m_boardAnalogInput1->setAddress(0x6d);
                //                else
                m_boardAnalogInput1->setAddress(0x69);

                bool response = m_boardAnalogInput1->init();
                m_boardAnalogInput1->polling();

                //                if(pData->getCabinetWidth3Feet())
                //                    pData->setBoardStatusAnalogInput1(!response);
                //                else
                pData->setBoardStatusHybridAnalogInput(!response);

                //DEFINE_CHANNEL_FOR_TEMPERATURE
                m_boardAnalogInput1->setChannelDoPoll(0, true);
                m_boardAnalogInput1->setChannelDoAverage(0, true);
                m_boardAnalogInput1->setChannelSamples(0, 30);

                //DEFINE_CHANNEL_FOR_AIRFLOW_INFLOW
                m_boardAnalogInput1->setChannelDoPoll(1, true);
                m_boardAnalogInput1->setChannelDoAverage(1, true);
                m_boardAnalogInput1->setChannelSamples(1, 50);

                ////MONITORING COMMUNICATION STATUS
                QObject::connect(m_boardAnalogInput1.data(), &AIManage::errorComToleranceReached,
                                 this, [&](int error){
                                     qDebug() << "AIManage::errorComToleranceReached" << error << thread();
                                     //                    if(pData->getCabinetWidth3Feet())
                                     //                        pData->setBoardStatusAnalogInput1(false);
                                     //                    else
                                     pData->setBoardStatusHybridAnalogInput(false);
                                 });
                QObject::connect(m_boardAnalogInput1.data(), &AIManage::errorComToleranceCleared,
                                 this, [&](int error){
                                     qDebug() << "AIManage::errorComToleranceCleared" << error << thread();
                                     //                    if(pData->getCabinetWidth3Feet())
                                     //                        pData->setBoardStatusAnalogInput1(true);
                                     //                    else
                                     pData->setBoardStatusHybridAnalogInput(true);
                                 });
            }//

            /// AIB - Analog Input For Airflow Downflow
            {
                m_boardAnalogInput2.reset(new AIManage);
                m_boardAnalogInput2->setupAIModule();
                m_boardAnalogInput2->setI2C(m_i2cPort.data());
                m_boardAnalogInput2->setAddress(0x6F);

                bool response = m_boardAnalogInput2->init();
                m_boardAnalogInput2->polling();

                pData->setBoardStatusAnalogInput(!response);

                //DEFINE_CHANNEL_FOR_AIRFLOW_DOWNFLOW
                m_boardAnalogInput2->setChannelDoPoll(0, true);
                m_boardAnalogInput2->setChannelDoAverage(0, true);
                m_boardAnalogInput2->setChannelSamples(0, 30);

                //DEFINE_CHANNEL_FOR_SASH_MOTORIZED_INTERLOCKED_SWITCH
                m_boardAnalogInput2->setChannelDoPoll(1, true);
                m_boardAnalogInput2->setChannelDoAverage(1, true);
                m_boardAnalogInput2->setChannelSamples(1, 5);

                //DEFINE_CHANNEL_FOR_FRONT_PANEL_OPEN
                m_boardAnalogInput2->setChannelDoPoll(2, true);
                m_boardAnalogInput2->setChannelDoAverage(2, true);
                m_boardAnalogInput2->setChannelSamples(2, 5);

                ////MONITORING COMMUNICATION STATUS
                QObject::connect(m_boardAnalogInput2.data(), &AIManage::errorComToleranceReached,
                                 this, [&](int error){
                                     qDebug() << "AIManage::errorComToleranceReached" << error << thread();
                                     pData->setBoardStatusAnalogInput(false);
                                 });
                QObject::connect(m_boardAnalogInput2.data(), &AIManage::errorComToleranceCleared,
                                 this, [&](int error){
                                     qDebug() << "AIManage::errorComToleranceCleared" << error << thread();
                                     pData->setBoardStatusAnalogInput(true);
                                 });

                /// SETUP CONNECTION FOR SASH MOTORIZED DOWN STUCK SWITCH
                QObject::connect(m_boardAnalogInput2.data(), &AIManage::digitalStateChanged,
                                 this, [&](short channel, bool value){
                                     qDebug() << "AIManage::digitalStateChanged" << channel << value;
                                     if(channel == 1){
                                         pData->setSashMotorDownStuckSwitch(!value);
                                     }//
                                     if(channel == 2){
                                         /// Front Panel Switch Installed on Hybrid Digital Input 6
                                         if(pData->getFrontPanelSwitchInstalled()){
                                             pData->setFrontPanelSwitchState(value);
                                             _checkFrontPanelAlarm();
                                         }//
                                     }//
                                 });//
            }//
            /// Analog Output Board - LIGHT INTENSITY
            {
                m_boardAnalogOutput1.reset(new AOmcp4725);
                m_boardAnalogOutput1->setI2C(m_i2cPort.data());
                m_boardAnalogOutput1->setAddress(0x60);

                bool response = m_boardAnalogOutput1->init();
                m_boardAnalogOutput1->polling();

                //                if(pData->getCabinetWidth3Feet())
                //                    pData->setBoardStatusAnalogOutput(!response);
                //                else
                pData->setBoardStatusHybridAnalogOutput(!response);

                /// catch error status of the board
                QObject::connect(m_boardAnalogOutput1.data(), &AOmcp4725::errorComToleranceReached,
                                 this, [&](int error){
                                     qDebug() << "m_boardAnalogOutput1 Error changed" << error << thread();
                                     //                    if(pData->getCabinetWidth3Feet())
                                     //                        pData->setBoardStatusAnalogOutput(false);
                                     //                    else
                                     pData->setBoardStatusHybridAnalogOutput(false);
                                 });
                QObject::connect(m_boardAnalogOutput1.data(), &AOmcp4725::errorComToleranceCleared,
                                 this, [&](int error){
                                     qDebug() << "m_boardAnalogOutput1 Error changed" << error << thread();
                                     //                    if(pData->getCabinetWidth3Feet())
                                     //                        pData->setBoardStatusAnalogOutput(true);
                                     //                    else
                                     pData->setBoardStatusHybridAnalogOutput(true);
                                 });
            }//
            if(pData->getCabinetWidth3Feet()){
                /// If Cabinet 3 feet selected
                /// Choose wheter to use PWM Output Board or Analog Output Board
                /// for controlling the speed of Fan
                /// default value of this parameter is false
                pData->setUsePwmOutSignal(true);
            }//

            if(pData->getUsePwmOutSignal()){
                ////SUB BOARD PWM OUTPUT
                m_boardPWMOut.reset(new PWMpca9685);
                m_boardPWMOut->setI2C(m_i2cPort.data());
                m_boardPWMOut->preInitCountChannelsToPool(4);
                m_boardPWMOut->preInitFrequency(PCA9685_PWM_VAL_FREQ_100HZ);
                m_boardPWMOut->setAddress(0x41);//A0-A5 -> [100000]

                bool response = m_boardPWMOut->init();
                m_boardPWMOut->polling();

                pData->setBoardStatusPWMOutput(!response);

                ////MONITORING COMMUNICATION STATUS
                QObject::connect(m_boardPWMOut.data(), &PWMpca9685::errorComToleranceReached,
                                 this, [&](int error){
                                     qDebug() << "m_boardPWMOut::errorComToleranceReached" << error << thread();
                                     pData->setBoardStatusPWMOutput(false);
                                 });
                QObject::connect(m_boardPWMOut.data(), &PWMpca9685::errorComToleranceCleared,
                                 this, [&](int error){
                                     qDebug() << "m_boardPWMOut::errorComToleranceCleared" << error << thread();
                                     pData->setBoardStatusPWMOutput(true);
                                 });
            }//
            else{
                /// Analog Output Board - Exhaust fan
                {
                    m_boardAnalogOutput2.reset(new AOmcp4725);
                    m_boardAnalogOutput2->setI2C(m_i2cPort.data());
                    m_boardAnalogOutput2->setAddress(0x61);

                    bool response = m_boardAnalogOutput2->init();
                    m_boardAnalogOutput2->polling();

                    if(pData->getCabinetWidth3Feet())
                        pData->setBoardStatusAnalogOutput(!response);
                    else
                        pData->setBoardStatusHybridAnalogOutput(!response);

                    /// catch error status of the board
                    QObject::connect(m_boardAnalogOutput2.data(), &AOmcp4725::errorComToleranceReached,
                                     this, [&](int error){
                                         qDebug() << "m_boardAnalogOutput2 Error changed" << error << thread();
                                         if(pData->getCabinetWidth3Feet())
                                             pData->setBoardStatusAnalogOutput(false);
                                         else
                                             pData->setBoardStatusHybridAnalogOutput(false);
                                     });
                    QObject::connect(m_boardAnalogOutput2.data(), &AOmcp4725::errorComToleranceCleared,
                                     this, [&](int error){
                                         qDebug() << "m_boardAnalogOutput2 Error changed" << error << thread();
                                         if(pData->getCabinetWidth3Feet())
                                             pData->setBoardStatusAnalogOutput(true);
                                         else
                                             pData->setBoardStatusHybridAnalogOutput(true);
                                     });
                }//
                if(pData->getCabinetWidth3Feet()) {
                    /// Analog Output Board - DOWNFLOW FAN
                    m_boardAnalogOutput4.reset(new AOmcp4725);
                    m_boardAnalogOutput4->setI2C(m_i2cPort.data());
                    m_boardAnalogOutput4->setAddress(0x63);

                    bool response = m_boardAnalogOutput4->init();
                    m_boardAnalogOutput4->polling();

                    //                if(pData->getCabinetWidth3Feet())
                    pData->setBoardStatusAnalogOutput(!response);
                    //                else
                    //                    pData->setBoardStatusHybridAnalogOutput(!response);

                    /// catch error status of the board
                    QObject::connect(m_boardAnalogOutput4.data(), &AOmcp4725::errorComToleranceReached,
                                     this, [&](int error){
                                         qDebug() << "m_boardAnalogOutput4 Error changed" << error << thread();
                                         //                    if(pData->getCabinetWidth3Feet())
                                         pData->setBoardStatusAnalogOutput(false);
                                         //                    else
                                         //                        pData->setBoardStatusHybridAnalogOutput(false);
                                     });
                    QObject::connect(m_boardAnalogOutput4.data(), &AOmcp4725::errorComToleranceCleared,
                                     this, [&](int error){
                                         qDebug() << "m_boardAnalogOutput4 Error changed" << error << thread();
                                         //                    if(pData->getCabinetWidth3Feet())
                                         pData->setBoardStatusAnalogOutput(true);
                                         //                    else
                                         //                        pData->setBoardStatusHybridAnalogOutput(true);
                                     });
                }//
            }//

            /// SEAS BOARD FLAP INTEGRATED
            {
                short installed = static_cast<short>(m_settings->value(SKEY_SEAS_BOARD_FLAP_INSTALLED, MachineEnums::DIG_STATE_ZERO).toInt());
                //installed = 1;
                pData->setSeasFlapInstalled(installed);
            }

            /// FRONT PANEL SWITCH
            {
                bool installed = m_settings->value(SKEY_FRONT_PANEL_INSTALLED, MachineEnums::DIG_STATE_ONE).toBool();
                //installed = 1;
                pData->setFrontPanelSwitchInstalled(installed);
            }

            /// EXHAUST_PRESSURE_DIFF_SENSIRION_SPD8xx
            /// SEAS INTEGRATED
            {
                short installed = static_cast<short>(m_settings->value(SKEY_SEAS_INSTALLED, MachineEnums::DIG_STATE_ZERO).toInt());
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
            /// m_boardIO->addSlave(m_boardPWMOut.data());
            m_boardIO->addSlave(m_boardAnalogInput1.data());
            m_boardIO->addSlave(m_boardAnalogInput2.data());
            m_boardIO->addSlave(m_boardAnalogOutput1.data());///Light Intensity
            if(pData->getUsePwmOutSignal()){
                if(pData->getCabinetWidth3Feet())
                    m_boardIO->addSlave(m_boardPWMOut.data());
            }
            else{
                m_boardIO->addSlave(m_boardAnalogOutput2.data());
                if(pData->getCabinetWidth3Feet()){
                    m_boardIO->addSlave(m_boardAnalogOutput4.data());
                }
            }
            if(pData->getSeasInstalled()){ m_boardIO->addSlave(m_boardSensirionSPD8xx.data());}

            m_boardIO->addSlave(m_boardCtpIO.data());
            m_boardIO->addSlave(m_boardCtpRTC.data());
        }///
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

        short slaveID = static_cast<short>(m_settings->value(SKEY_MODBUS_SLAVE_ID, 1).toInt());
        pData->setModbusSlaveID(slaveID);

        enum {REG_RO, REG_RW};
        modbusRegisterAddress.FanState.rw       = static_cast<short>(m_settings->value(SKEY_MODBUS_RW_FAN, REG_RO).toInt());
        //modbusRegisterAddress.IfaFanState.rw    = modbusRegisterAddress.FanState.rw;
        //modbusRegisterAddress.DfaFanState.rw    = modbusRegisterAddress.FanState.rw;
        modbusRegisterAddress.LightState.rw     = static_cast<short>(m_settings->value(SKEY_MODBUS_RW_LAMP, REG_RO).toInt());
        modbusRegisterAddress.LightIntensity.rw = static_cast<short>(m_settings->value(SKEY_MODBUS_RW_LAMP_DIMM, REG_RO).toInt());
        modbusRegisterAddress.SocketState.rw    = static_cast<short>(m_settings->value(SKEY_MODBUS_RW_SOCKET, REG_RO).toInt());
        modbusRegisterAddress.GasState.rw       = static_cast<short>(m_settings->value(SKEY_MODBUS_RW_GAS, REG_RO).toInt());
        modbusRegisterAddress.UvState.rw        = static_cast<short>(m_settings->value(SKEY_MODBUS_RW_UV, REG_RO).toInt());

        pData->setModbusAllowSetFan(modbusRegisterAddress.FanState.rw);
        pData->setModbusAllowSetLight(modbusRegisterAddress.LightState.rw);
        pData->setModbusAllowSetLightIntensity(modbusRegisterAddress.LightIntensity.rw);
        pData->setModbusAllowSetSocket(modbusRegisterAddress.SocketState.rw);
        pData->setModbusAllowSetGas(modbusRegisterAddress.GasState.rw);
        pData->setModbusAllowSetUvLight(modbusRegisterAddress.UvState.rw);

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

        /// SETUP CONNECTION TO KEEP THE REGISTER VALUES
        /// SYNCED WITH THE ACTUAL VALUE
        {
            //
            QObject::connect(pData, &MachineData::fanPrimaryStateChanged,
                             this, [&](short value){
                                 _setModbusRegHoldingValue(modbusRegisterAddress.FanState.addr, static_cast<ushort>(value));
                                 _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanState.addr, static_cast<ushort>(value));
                             });
            //            QObject::connect(pData, &MachineData::fanPrimaryStateChanged,
            //                             this, [&](short value){
            //                _setModbusRegHoldingValue(modbusRegisterAddress.DfaFanState.addr, static_cast<ushort>(value));
            //            });
            QObject::connect(pData, &MachineData::fanPrimaryDutyCycleChanged,
                             this, [&](short value){
                                 _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanDutyCycle.addr, static_cast<ushort>(value));
                             });
            QObject::connect(pData, &MachineData::fanPrimaryRpmChanged,
                             this, [&](short value){
                                 _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanRpm.addr, static_cast<ushort>(value));
                             });
            //
            //            QObject::connect(pData, &MachineData::fanInflowStateChanged,
            //                             this, [&](short value){
            //                _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanState.addr, static_cast<ushort>(value));
            //            });
            //            QObject::connect(pData, &MachineData::fanInflowDutyCycleChanged,
            //                             this, [&](short value){
            //                _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanDutyCycle.addr, static_cast<ushort>(value));
            //            });
            //            QObject::connect(pData, &MachineData::fanInflowRpmChanged,
            //                             this, [&](short value){
            //                _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanRpm.addr, static_cast<ushort>(value));
            //            });
            //
            QObject::connect(pData, &MachineData::lightStateChanged,
                             this, [&](short value){
                                 _setModbusRegHoldingValue(modbusRegisterAddress.LightState.addr, static_cast<ushort>(value));
                             });
            QObject::connect(pData, &MachineData::lightIntensityChanged,
                             this, [&](short value){
                                 _setModbusRegHoldingValue(modbusRegisterAddress.LightIntensity.addr, static_cast<ushort>(value));
                             });
            QObject::connect(pData, &MachineData::socketStateChanged,
                             this, [&](short value){
                                 _setModbusRegHoldingValue(modbusRegisterAddress.SocketState.addr, static_cast<ushort>(value));
                             });
            QObject::connect(pData, &MachineData::gasStateChanged,
                             this, [&](short value){
                                 _setModbusRegHoldingValue(modbusRegisterAddress.GasState.addr, static_cast<ushort>(value));
                             });
            QObject::connect(pData, &MachineData::uvStateChanged,
                             this, [&](short value){
                                 _setModbusRegHoldingValue(modbusRegisterAddress.UvState.addr, static_cast<ushort>(value));
                             });
        }//
    }

    {
        ///Specify Dual RBM Mode
        pData->setDualRbmMode(false);
    }//


    /// Fan Exhaust
    {
        if(!pData->getDualRbmMode()){
            if(pData->getUsePwmOutSignal()){
                /// Fan Exhaust - PWM OUTPUT
                m_pFanInflowPWM.reset(new DevicePWMOut);
                m_pFanInflowPWM->setSubModule(m_boardPWMOut.data());
                m_pFanInflowPWM->setChannelIO(1);
                m_pFanInflowPWM->setDutyCycleMinimum(0);

                connect(m_pFanInflowPWM.data(), &DevicePWMOut::stateChanged,
                        this, [&](int newVal){
                            _onFanInflowActualDucyChanged(static_cast<short>(newVal));
                        });
            }
            else{
                m_pFanInflowAO.reset(new DeviceAnalogCom);
                m_pFanInflowAO->setSubBoard(m_boardAnalogOutput2.data());
                m_pFanInflowAO->setStateMax(1000);

                connect(m_pFanInflowAO.data(), &DeviceAnalogCom::stateChanged,
                        this, [&](int newVal){
                            _onFanInflowActualDucyChanged(static_cast<short>(newVal));
                        });
            }
        }
    }
    if(pData->getCabinetWidth3Feet()){
        if(pData->getUsePwmOutSignal()){
            m_pFanPrimaryPWM.reset(new DevicePWMOut);
            m_pFanPrimaryPWM->setSubModule(m_boardPWMOut.data());
            m_pFanPrimaryPWM->setChannelIO(0);
            m_pFanPrimaryPWM->setDutyCycleMinimum(0);

            connect(m_pFanPrimaryPWM.data(), &DevicePWMOut::stateChanged,
                    this, [&](int newVal){
                        _onFanPrimaryActualDucyChanged(static_cast<short>(newVal));
                    });
        }
        else{
            m_pFanPrimaryAO.reset(new DeviceAnalogCom);
            m_pFanPrimaryAO->setSubBoard(m_boardAnalogOutput4.data());

            connect(m_pFanPrimaryAO.data(), &DeviceAnalogCom::stateChanged,
                    this, [&](int newVal){
                        _onFanPrimaryActualDucyChanged(static_cast<short>(newVal));
                    });
        }
    }
    else {
        /// Fan DOWNFLOW
        {
            QString portPrimary = m_settings->value(SKEY_RBM_PORT_PRIMARY, BLOWER_USB_SERIAL_PORT0).toString();
            pData->setRbmComPortDfa(portPrimary);
            QString portInflow = BLOWER_USB_SERIAL_PORT1;

            /// find and initializing serial port for fan
            m_serialPort1.reset(new QSerialPort());

            foreach(const QSerialPortInfo &info, QSerialPortInfo::availablePorts()){
                if((info.vendorIdentifier() == BLOWER_USB_SERIAL_VID) &&
                    (info.productIdentifier() == BLOWER_USB_SERIAL_PID)){
                    if((info.portName() == portPrimary)){
                        m_serialPort1->setPort(info);

                        if(m_serialPort1->open(QIODevice::ReadWrite)){
                            m_serialPort1->setBaudRate(QSerialPort::BaudRate::Baud4800);
                            m_serialPort1->setDataBits(QSerialPort::DataBits::Data8);
                            m_serialPort1->setParity(QSerialPort::Parity::NoParity);
                            m_serialPort1->setStopBits(QSerialPort::StopBits::OneStop);
                        }//
                        break;
                    }
                }//
            }//

            /// RBM COM Board is OK and ready to send fan paramaters
            if (!m_serialPort1->isOpen()) {
                qWarning() << __FUNCTION__ << thread() << "serial port 0 for fan dfa cannot be opened";
                pData->setBoardStatusRbmCom(false);
                //pData->setBoardStatusRbmCom2(false);
            }//

            /// initializing the fan object
            m_boardRegalECM.reset(new BlowerRegalECM);
            /// set the serial port
            m_boardRegalECM->setSerialComm(m_serialPort1.data());

            /// we expect the first value of the the fan from not running
            /// now, we assume the response from the fan is always OK,
            ///// so we dont care the return value of following API
            m_boardRegalECM->stop();

            int maxAirVolume = 1800;

            /// SET AIRFLOW VOLUME MODE IN 3 Feet Cabinet
            if(pData->getCabinetWidthFeet() == 3)
            {
                /// setup profile fan ecm
                {
                    /// query profile from machine profile
                    QJsonObject machineProfile = pData->getMachineProfile();
                    QJsonObject fanProfile = machineProfile.value("fan").toObject();

                    short direction = static_cast<short>(fanProfile.value("direction").toInt());
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
                    short response = static_cast<short>(m_boardRegalECM->setBlowerContant(a1, a2, a3, a4));

                    pData->setBoardStatusRbmCom(response == 0);
                }//
            }//
            else{
                /// setup blower ecm by torque demand
                /// in torque mode, we just need to define the direction of rotation
                int response = m_boardRegalECM->setDirection(BlowerRegalECM::BLOWER_REGAL_ECM_DIRECTION_CLW);
                //        m_boardRegalECM->setDirection(BlowerRegalECM::BLOWER_REGAL_ECM_DIRECTION_CCW);
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

            /// create object for state keeper
            /// ensure actuator state is what machine state requested
            m_pFanPrimary.reset(new BlowerRbmDsi);
            /// pass the virtual object sub module board
            m_pFanPrimary->setSubModule(m_boardRegalECM.data());
            if(pData->getCabinetWidthFeet() == 3){
                /// use air volume demand mode, blower will have auto compesate to achive the air volume demand
                //                m_pFanPrimary->setDemandMode(BlowerRbmDsi::AIRVOLUME_DEMMAND_BRDM);
                m_pFanPrimary->setDemandMode(BlowerRbmDsi::TORQUE_DEMMAND_BRDM);
                m_pFanPrimary->setAirVolumeScale(maxAirVolume);
            }
            else
                m_pFanPrimary->setDemandMode(BlowerRbmDsi::TORQUE_DEMMAND_BRDM);

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
                                 //            qDebug() << "m_timerEventForBlowerRbmDsi::started" << thread();
                                 m_timerEventForFanRbmDsi->start();
                             });

            /// Stop timer event when thread was finished
            QObject::connect(m_threadForFanRbmDsi.data(), &QThread::finished,
                             m_timerEventForFanRbmDsi.data(), [&](){
                                 //            qDebug() << "m_timerEventForBlowerRbmDsi::finished" << thread();
                                 m_timerEventForFanRbmDsi->stop();
                             });

            /// Enable triggerOnStarted, calling the worker of BlowerRbmDsi when thread has started
            /// This is use lambda function, this symbol [&] for pass m_blowerRbmDsi object to can captured by lambda
            /// m_blowerRbmDsi.data(), [&](){m_blowerRbmDsi->worker();});
            QObject::connect(m_threadForFanRbmDsi.data(), &QThread::started,
                             m_pFanPrimary.data(), [&](){
                                 m_pFanPrimary->routineTask();
                             });

            /// Call routine task blower (syncronazation state)
            /// This method calling by timerEvent
            QObject::connect(m_timerEventForFanRbmDsi.data(), &QTimer::timeout,
                             m_pFanPrimary.data(), [&](){
                                 //            qDebug() << "m_blowerRbmDsi::timeout" << thread();
                                 m_pFanPrimary->routineTask();
                             });

            /// Run blower loop thread when Machine State goes to looping / routine task
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


            /// Move fan routine task / looping to independent thread
            m_pFanPrimary->moveToThread(m_threadForFanRbmDsi.data());
            /// Do move timer event for fan routine task to independent thread
            /// make the timer has prescission because independent from this Macine State looping
            m_timerEventForFanRbmDsi->moveToThread(m_threadForFanRbmDsi.data());
            /// Also move all necesarry object to independent fan thread
            m_serialPort1->moveToThread(m_threadForFanRbmDsi.data());
            m_boardRegalECM->moveToThread(m_threadForFanRbmDsi.data());
        }//
        /// Fan INFLOW
        {
            if(pData->getDualRbmMode()){
                QString portInflow = m_settings->value(SKEY_RBM_PORT_INFLOW, BLOWER_USB_SERIAL_PORT1).toString();
                pData->setRbmComPortIfa(portInflow);

                m_serialPort12.reset(new QSerialPort());

                foreach(const QSerialPortInfo &info, QSerialPortInfo::availablePorts()){
                    if((info.vendorIdentifier() == BLOWER_USB_SERIAL_VID) &&
                        (info.productIdentifier() == BLOWER_USB_SERIAL_PID)){
                        if(info.portName() == portInflow){
                            m_serialPort12->setPort(info);

                            if(m_serialPort12->open(QIODevice::ReadWrite)){
                                m_serialPort12->setBaudRate(QSerialPort::BaudRate::Baud4800);
                                m_serialPort12->setDataBits(QSerialPort::DataBits::Data8);
                                m_serialPort12->setParity(QSerialPort::Parity::NoParity);
                                m_serialPort12->setStopBits(QSerialPort::StopBits::OneStop);
                            }//
                            break;
                        }//
                    }//
                }//

                /// RBM COM Board is OK and ready to send fan paramaters
                if(!m_serialPort12->isOpen()){
                    qWarning() << __FUNCTION__ << thread() << "serial port 2 for fan ifa cannot be opened";
                    pData->setBoardStatusRbmCom2(false);
                }//
                /// initializing the fan object
                m_boardRegalECM2.reset(new BlowerRegalECM);
                m_boardRegalECM2->setSerialComm(m_serialPort12.data());

                /// we expect the first value of the the fan from not running
                /// now, we assume the response from the fan is always OK,
                ///// so we dont care the return value of following API
                m_boardRegalECM2->stop();

                /// setup blower ecm by torque demand
                /// in torque mode, we just need to define the direction of rotation
                int response2 =  m_boardRegalECM2->setDirection(BlowerRegalECM::BLOWER_REGAL_ECM_DIRECTION_CLW);
                pData->setBoardStatusRbmCom2(response2 == 0);

                ////MONITORING COMMUNICATION STATUS
                QObject::connect(m_boardRegalECM2.data(), &BlowerRegalECM::errorComToleranceReached,
                                 this, [&](int error){
                                     qDebug() << "BlowerRegalECM2::errorComToleranceReached" << error << thread();
                                     pData->setBoardStatusRbmCom2(false);
                                 });
                QObject::connect(m_boardRegalECM2.data(), &BlowerRegalECM::errorComToleranceCleared,
                                 this, [&](int error){
                                     qDebug() << "BlowerRegalECM2::errorComToleranceCleared" << error << thread();
                                     pData->setBoardStatusRbmCom2(true);
                                 });

                /// create object for state keeper
                /// ensure actuator state is what machine state requested
                m_pFanInflow.reset(new BlowerRbmDsi);
                m_pFanInflow->setSubModule(m_boardRegalECM2.data());
                m_pFanInflow->setDemandMode(BlowerRbmDsi::TORQUE_DEMMAND_BRDM);

                /// create timer for triggering the loop (routine task) and execute any pending request
                /// routine task and any pending task will executed by FIFO mechanism
                m_timerEventForFanRbmDsi2.reset(new QTimer);
                m_timerEventForFanRbmDsi2->setInterval(TEI_FOR_BLOWER_RBMDSI);

                /// create independent thread
                /// looping inside this thread will run parallel* beside machineState loop
                m_threadForFanRbmDsi2.reset(new QThread);

                /// Start timer event when thread was started
                /// Start timer event when thread was started
                QObject::connect(m_threadForFanRbmDsi2.data(), &QThread::started,
                                 m_timerEventForFanRbmDsi2.data(), [&](){
                                     //            qDebug() << "m_timerEventForBlowerRbmDsi::started" << thread();
                                     m_timerEventForFanRbmDsi2->start();
                                 });

                /// Stop timer event when thread was finished
                QObject::connect(m_threadForFanRbmDsi2.data(), &QThread::finished,
                                 m_timerEventForFanRbmDsi2.data(), [&](){
                                     //            qDebug() << "m_timerEventForBlowerRbmDsi::finished" << thread();
                                     m_timerEventForFanRbmDsi2->stop();
                                 });

                /// Enable triggerOnStarted, calling the worker of BlowerRbmDsi when thread has started
                /// This is use lambda function, this symbol [&] for pass m_blowerRbmDsi object to can captured by lambda
                /// m_blowerRbmDsi.data(), [&](){m_blowerRbmDsi->worker();});

                QObject::connect(m_threadForFanRbmDsi2.data(), &QThread::started,
                                 m_pFanInflow.data(), [&](){
                                     m_pFanInflow->routineTask();
                                 });

                /// Call routine task blower (syncronazation state)
                /// This method calling by timerEvent
                QObject::connect(m_timerEventForFanRbmDsi2.data(), &QTimer::timeout,
                                 m_pFanInflow.data(), [&](){
                                     //            qDebug() << "m_blowerRbmDsi::timeout" << thread();
                                     m_pFanInflow->routineTask();
                                 });

                /// Run blower loop thread when Machine State goes to looping / routine task
                QObject::connect(this, &MachineBackend::loopStarted,
                                 m_threadForFanRbmDsi2.data(), [&](){
                                     //            qDebug() << "m_threadForFanRbmDsi::loopStarted" << thread();
                                     m_threadForFanRbmDsi2->start();
                                 });

                /// call this when actual blower duty cycle has changed
                QObject::connect(m_pFanInflow.data(), &BlowerRbmDsi::dutyCycleChanged,
                                 this, &MachineBackend::_onFanInflowActualDucyChanged);

                /// call this when actual blower rpm has changed
                QObject::connect(m_pFanInflow.data(), &BlowerRbmDsi::rpmChanged,
                                 this, &MachineBackend::_onFanInflowActualRpmChanged);

                /// call this when actual blower interloked
                QObject::connect(m_pFanInflow.data(), &BlowerRbmDsi::interlockChanged,
                                 pData, [&](short newVal){
                                     pData->setFanInflowInterlocked(newVal);
                                 });

                /// Move fan routine task / looping to independent thread
                m_pFanInflow->moveToThread(m_threadForFanRbmDsi2.data());
                /// Do move timer event for fan routine task to independent thread
                /// make the timer has prescission because independent from this Macine State looping
                m_timerEventForFanRbmDsi2->moveToThread(m_threadForFanRbmDsi2.data());
                /// Also move all necesarry object to independent fan thread
                m_serialPort12->moveToThread(m_threadForFanRbmDsi2.data());
                m_boardRegalECM2->moveToThread(m_threadForFanRbmDsi2.data());
            }//
        }//
    }//
    //    {
    //        QString portAvailable = BLOWER_USB_SERIAL_PORT1;
    //        portAvailable += "#";
    //        portAvailable += BLOWER_USB_SERIAL_PORT1;
    //        pData->setRbmComPortAvailable(portAvailable);
    //    }

    /// Sash Window Motorize
    {
        bool installed = m_settings->value(SKEY_SASH_MOTOR_INSTALLED, MachineEnums::DIG_STATE_ONE).toInt();
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
                    pData->setSashWindowMotorizeState(static_cast<short>(newVal));

                    /// MODBUS
                    _setModbusRegHoldingValue(modbusRegisterAddress.SashMotorizeState.addr, static_cast<ushort>(newVal));
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

    /// SASH
    {
        m_pSashWindow.reset(new SashWindow);
        m_pSashWindow->setSubModule(m_boardDigitalInput1.data());

        /// early update sash state
        m_boardDigitalInput1->polling();
        m_pSashWindow->routineTask();
        int currentState = m_pSashWindow->sashState();
        pData->setSashWindowState(static_cast<short>(currentState));

        /// MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.SashState.addr, static_cast<ushort>(currentState));

        QObject::connect(m_pSashWindow.data(), &SashWindow::mSwitchStateChanged,
                         pData, [&](int index, int newVal){
                             pData->setMagSWState(static_cast<short>(index), static_cast<bool>(newVal));
                             if(index == 5){
                                 //                qDebug() << "index:" << index << "value:" << newVal;
                                 //                /// Front Panel Switch Installed on Hybrid Digital Input 6
                                 //                if(pData->getFrontPanelSwitchInstalled()){
                                 //                    pData->setFrontPanelSwitchState(static_cast<bool>(newVal));
                                 //                }
                                 //                _checkFrontPanelAlarm();
                                 pData->setSashWindowSafeHeight2(static_cast<bool>(newVal));
                             }//
                         });

        QObject::connect(m_pSashWindow.data(), &SashWindow::sashStateChanged,
                         this, &MachineBackend::_onSashStateChanged);

        int timerMs = 250;
        if(pData->getSashWindowMotorizeInstalled())
            timerMs = 50;
        //// Create Independent Timer Event For Sash Motorize
        m_timerEventForSashWindowRoutine.reset(new QTimer);
        m_timerEventForSashWindowRoutine->setInterval(std::chrono::milliseconds(timerMs));

        QObject::connect(m_timerEventForSashWindowRoutine.data(), &QTimer::timeout,
                         this, &MachineBackend::_onTriggeredEventSashWindowRoutine);

        QObject::connect(this, &MachineBackend::loopStarted, [&](){
            m_timerEventForSashWindowRoutine->start();
        });
    }//

    //    /// Light Intensity
    //    if(pData->getUsePwmOutSignal())
    //    {
    //        /// Light Intensity - PWM OUTPUT
    //        int min = m_settings->value(SKEY_LIGHT_INTENSITY_MIN, 30).toInt(); //percent
    //        int light = static_cast<short>(m_settings->value(SKEY_LIGHT_INTENSITY, 100).toInt());

    //        m_pLightIntensityPWM.reset(new DevicePWMOut);
    //        m_pLightIntensityPWM->setSubModule(m_boardPWMOut.data());
    //        m_pLightIntensityPWM->setChannelIO(0);
    //        m_pLightIntensityPWM->setDutyCycleMinimum(static_cast<short>(min));
    //        m_pLightIntensityPWM->setState(light);

    //        connect(m_pLightIntensityPWM.data(), &DevicePWMOut::stateChanged,
    //                this, [&](int newVal){
    //            pData->setLightIntensity(static_cast<short>(newVal));
    //            /// MODBUS
    //            _setModbusRegHoldingValue(modbusRegisterAddress.LightIntensity.addr, static_cast<ushort>(newVal));
    //        });
    //    }//
    //    else
    //    {
    m_pLightIntensity.reset(new DeviceAnalogCom);
    m_pLightIntensity->setSubBoard(m_boardAnalogOutput1.data());

    int min = m_settings->value(SKEY_LIGHT_INTENSITY_MIN, 30).toInt(); //percent

    int adcMin;
    m_boardAnalogOutput1->voltToInputcode((min / 10) * 1000 /*to miliVolt*/, &adcMin);

    //        qDebug() << "adcMin" << adcMin;

    m_pLightIntensity->setAdcMin(adcMin);
    m_pLightIntensity->setStateMin(min);

    short light = static_cast<short>(m_settings->value(SKEY_LIGHT_INTENSITY, 100).toInt());

    /// CAUSED BLINKING - NO IMPLEMENTED
    /// bacasue boardIo poilling not started yet, so we manually call
    /// the board instead m_lightIntensity object
    /// this i2c communication will used direct mode
    //        int inputCode = m_lightIntensity->stateToAdc(light);
    //        qDebug() << "m_lightIntensity" << inputCode;
    //        m_boardAnalogOutput1->setDAC(inputCode);

    //m_pLightIntensity->setState(light);

    pData->setLightIntensity(light);

    connect(m_pLightIntensity.data(), &DeviceAnalogCom::stateChanged,
            pData, [&](int newVal){
                pData->setLightIntensity(static_cast<short>(newVal));

                /// MODBUS
                _setModbusRegHoldingValue(modbusRegisterAddress.LightIntensity.addr, static_cast<ushort>(newVal));
            });
    //    }//

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
        //        connect(m_pGas.data(), &DeviceDigitalOut::workerFinished,
        //                this, [&](){
        //            qDebug() << "m_pGas Worker finished!";
        //        });
        //        connect(pData, &MachineData::alarmsStateChanged,
        //                m_pGas.data(), &DeviceDigitalOut::setInterlock);

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
            pData->setUvLifePercent(static_cast<short>(minutesPercentLeft));
            /// MODBUS
            _setModbusRegHoldingValue(modbusRegisterAddress.UvLifeLeft.addr, static_cast<ushort>(minutesPercentLeft));
        }//

        /// UV Timer
        {
            int minutes = m_settings->value(SKEY_UV_TIME, 30).toInt(); //30 minutes (as per Yandra)
            //minutes = 1;
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
                this, [&](int newVal){
                    pData->setExhaustContactState(static_cast<short>(newVal));
                });
    }

    /// Alarm Contact
    {
        m_pAlarmContact.reset(new DeviceDigitalOut);
        m_pAlarmContact->setSubModule(m_boardRelay1.data());
        m_pAlarmContact->setChannelIO(7);

        connect(m_pAlarmContact.data(), &DeviceDigitalOut::stateChanged,
                this, [&](int newVal){
                    pData->setAlarmContactState(static_cast<short>(newVal));
                });
    }


    /// Particle Counter
    {
        bool particleCounterSensorInstalled = m_settings->value(SKEY_PARTICLE_COUNTER_INST, MachineEnums::DIG_STATE_ZERO).toBool();
        pData->setParticleCounterSensorInstalled(particleCounterSensorInstalled);

        if(pData->getParticleCounterSensorInstalled()) {
            /// find and initializing serial port for fan
            m_serialPort2.reset(new QSerialPort());

#ifndef __linux__
            //// FOR TESTING IN DEVELOPER PC
            m_serialPort2->setPortName("COM9");
            m_serialPort2->setBaudRate(QSerialPort::BaudRate::Baud9600);
            m_serialPort2->setDataBits(QSerialPort::DataBits::Data8);
            m_serialPort2->setParity(QSerialPort::Parity::NoParity);
            m_serialPort2->setStopBits(QSerialPort::StopBits::OneStop);
#endif

#ifdef __arm__
            foreach(const QSerialPortInfo &info, QSerialPortInfo::availablePorts()){
                qDebug() << info.vendorIdentifier() << info.productIdentifier() << info.portName();
                if((info.vendorIdentifier() == PARTICLE_COUNTER_UART_VID) &&
                    (info.productIdentifier() == PARTICLE_COUNTER_UART_PID)){
                    qDebug() << "port name: " << info.portName();
                    m_serialPort2->setPortName(info.portName());
                    m_serialPort2->setBaudRate(QSerialPort::BaudRate::Baud9600);
                    m_serialPort2->setDataBits(QSerialPort::DataBits::Data8);
                    m_serialPort2->setParity(QSerialPort::Parity::NoParity);
                    m_serialPort2->setStopBits(QSerialPort::StopBits::OneStop);
                    break;
                }
            }
#endif
            //Open Here
            m_serialPort2->open(QIODevice::ReadWrite);

            /// Board is OK and ready to send fan paramaters
            if (!m_serialPort2->isOpen()) {
                qWarning() << metaObject()->className() << __FUNCTION__ << "PARTICLE_COUNTER" << "serial port 2 for particle counter cannot be opened";
                pData->setBoardStatusParticleCounter(false);
                //            pData->setBoardStatusRbmCom(false);
            }
            else {
                qDebug() << metaObject()->className() << "PARTICLE_COUNTER Port open at " << __func__ << m_serialPort2->portName();
                pData->setBoardStatusParticleCounter(true);
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

            ////MONITORING COMMUNICATION STATUS
            QObject::connect(m_boardParticleCounterZH03B.data(), &ParticleCounterZH03B::errorComToleranceReached,
                             this, [&](int error){
                                 qDebug() << "ParticleCounterZH03B::errorComToleranceReached" << error << thread();
                                 pData->setBoardStatusParticleCounter(false);
                             });

            QObject::connect(m_boardParticleCounterZH03B.data(), &ParticleCounterZH03B::errorComToleranceCountChanged,
                             this, [&](int error){
                                 qDebug() << "ParticleCounterZH03B::errorComToleranceCountChanged: " << error;
                                 //pData->setBoardStatusParticleCounter(false);
                             });

            QObject::connect(m_boardParticleCounterZH03B.data(), &ParticleCounterZH03B::errorComToleranceCleared,
                             this, [&](int error){
                                 qDebug() << "ParticleCounterZH03B::errorComToleranceCleared" << error << thread();
                                 pData->setBoardStatusParticleCounter(true);
                             });

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

        pData->setMeasurementUnit(static_cast<short>(meaUnit));

        ///MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.MeaUnit.addr, static_cast<ushort>(meaUnit));

        //        qDebug() << "SKEY_MEASUREMENT_UNIT" << meaUnit;
    }

    /// Cabinet Display Name
    /// Also it's used as hostname in network
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


    {///Read Parameter for Closed Loop Control
        bool enablePrev    = m_settings->value(SKEY_FAN_CLOSE_LOOP_ENABLE_PREV, false).toBool();
        bool enable    = m_settings->value(SKEY_FAN_CLOSE_LOOP_ENABLE, false).toBool();
        int samplingTime = m_settings->value(SKEY_FAN_CLOSE_LOOP_STIME, TEI_FOR_CLOSE_LOOP_CONTROL).toInt();
        float dfaGainP = m_settings->value(SKEY_FAN_CLOSE_LOOP_GAIN_P + QString::number(Downflow), 1.5).toFloat();
        float dfaGainI = m_settings->value(SKEY_FAN_CLOSE_LOOP_GAIN_I + QString::number(Downflow), 0).toFloat();
        float dfaGainD = m_settings->value(SKEY_FAN_CLOSE_LOOP_GAIN_D + QString::number(Downflow), 0).toFloat();
        float ifaGainP = m_settings->value(SKEY_FAN_CLOSE_LOOP_GAIN_P + QString::number(Inflow), 1.0).toFloat();
        float ifaGainI = m_settings->value(SKEY_FAN_CLOSE_LOOP_GAIN_I + QString::number(Inflow), 0).toFloat();
        float ifaGainD = m_settings->value(SKEY_FAN_CLOSE_LOOP_GAIN_D + QString::number(Inflow), 0).toFloat();

        pData->setFanFanClosedLoopControlEnablePrevState(enablePrev);
        /// Condition if power failure was happening at Calibration page
        if(enablePrev && !enable)
            pData->setFanClosedLoopControlEnable(enablePrev);
        else
            pData->setFanClosedLoopControlEnable(enable);
        pData->setFanClosedLoopSamplingTime(samplingTime);
        pData->setFanClosedLoopGainProportional(dfaGainP, Downflow);
        pData->setFanClosedLoopGainIntegral(dfaGainI, Downflow);
        pData->setFanClosedLoopGainDerivative(dfaGainD, Downflow);
        pData->setFanClosedLoopGainProportional(ifaGainP, Inflow);
        pData->setFanClosedLoopGainIntegral(ifaGainI, Inflow);
        pData->setFanClosedLoopGainDerivative(ifaGainD, Inflow);

        ///MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.FanClosedLoopControl.addr, static_cast<ushort>(enable));
    }

    /// FAN DOWNFLOW DUTY CYCLE AUTO COMPENSATE
    {
        ////CREATE DOWNFLOW CLOSE LOOP CONTROL OBJECT
        m_pDfaFanClosedLoopControl.reset(new ClosedLoopControl());
        m_pDfaFanClosedLoopControl->setControlEnable(pData->getFanClosedLoopControlEnable());
        m_pDfaFanClosedLoopControl->setGainProportional(pData->getFanClosedLoopGainProportional(Downflow));
        m_pDfaFanClosedLoopControl->setGainIntegral(pData->getFanClosedLoopGainIntegral(Downflow));
        m_pDfaFanClosedLoopControl->setGainDerivative(pData->getFanClosedLoopGainDerivative(Downflow));
        m_pDfaFanClosedLoopControl->setMeasurementUnit(static_cast<uchar>(pData->getMeasurementUnit()));
        m_pDfaFanClosedLoopControl->setSamplingPeriod(static_cast<float>(pData->getFanClosedLoopSamplingTime()));

        /// CONNECTION
        connect(m_pDfaFanClosedLoopControl.data(), &ClosedLoopControl::outputControlChanged,
                this, [&](short dutyCycle){
                    //qDebug() << "m_pDfaFanClosedLoopControl dutyCycle" << dutyCycle;
                    _setFanPrimaryDutyCycle(dutyCycle);
                });
    }
    /// FAN INFLOW DUTY CYCLE AUTO COMPENSATE
    {
        ////CREATE INFLOW CLOSE LOOP CONTROL OBJECT
        m_pIfaFanClosedLoopControl.reset(new ClosedLoopControl());
        m_pIfaFanClosedLoopControl->setControlEnable(pData->getFanClosedLoopControlEnable());
        m_pIfaFanClosedLoopControl->setGainProportional(pData->getFanClosedLoopGainProportional(Inflow));
        m_pIfaFanClosedLoopControl->setGainIntegral(pData->getFanClosedLoopGainIntegral(Inflow));
        m_pIfaFanClosedLoopControl->setGainDerivative(pData->getFanClosedLoopGainDerivative(Inflow));
        m_pIfaFanClosedLoopControl->setMeasurementUnit(static_cast<uchar>(pData->getMeasurementUnit()));
        m_pIfaFanClosedLoopControl->setSamplingPeriod(static_cast<float>(pData->getFanClosedLoopSamplingTime()));

        /// CONNECTION
        connect(m_pIfaFanClosedLoopControl.data(), &ClosedLoopControl::outputControlChanged,
                this, [&](short dutyCycle){
                    //qDebug() << "m_pIfaFanClosedLoopControl dutyCycle" << dutyCycle;
                    _setFanInflowDutyCycle(dutyCycle);
                });
    }
    {
        //// create Timer Event For Close loop control
        m_timerEventForClosedLoopControl.reset(new QTimer);
        m_timerEventForClosedLoopControl->setInterval(std::chrono::milliseconds(pData->getFanClosedLoopSamplingTime()));

        QObject::connect(m_timerEventForClosedLoopControl.data(), &QTimer::timeout,
                         this, &MachineBackend::_onTriggeredEventClosedLoopControl);
        //        QObject::connect(this, &MachineBackend::loopStarted,
        //                         [&](){
        //            m_timerEventForClosedLoopControl->start();
        //        });
    }

    /// TEMPERATURE
    {
        m_pTemperature.reset(new Temperature);
        m_pTemperature->setSubModule(m_boardAnalogInput1.data());
        m_pTemperature->setChannelIO(0);
        m_pTemperature->setPrecision(1);

        connect(m_pTemperature.data(), &Temperature::adcChanged,
                pData, &MachineData::setTemperatureAdc);
        connect(m_pTemperature.data(), &Temperature::celciusPrecisionChanged,
                this, &MachineBackend::_onTemperatureActualChanged);
        //        connect(m_pTemperature.data(), &Temperature::celciusChanged,
        //                this, &MachineBackend::_onTemperatureActualChanged);

        /// force update temperature string
        int temp = 0;
        pData->setTemperatureCelcius(static_cast<short>(temp));

        if (pData->getMeasurementUnit()) {
            pData->setTemperature(static_cast<short>(temp));
            QString valueStr = QString::asprintf("%d°F", temp);
            pData->setTemperatureValueStrf(valueStr);
        }
        else {
            pData->setTemperature(static_cast<short>(temp));
            QString valueStr = QString::asprintf("%d°C", temp);
            pData->setTemperatureValueStrf(valueStr);
        }
    }

    /// AIRFLOW_DOWNFLOW
    {
        ////CREATE INFLOW OBJECT
        m_pAirflowDownflow.reset(new AirflowVelocity());
        m_pAirflowDownflow->setAIN(m_boardAnalogInput2.data());
        m_pAirflowDownflow->setChannel(0);
        //        m_pAirflowDownflow->setScopeCount(3); //Default 4
        m_pAirflowDownflow->setMeasurementUnit(static_cast<uchar>(pData->getMeasurementUnit()));
        //m_pAirflowDownflow->setAdcResolutionBits(12);

        /// CONNECTION
        connect(m_pAirflowDownflow.data(), &AirflowVelocity::adcConpensationChanged,
                pData, [&](int newVal){
                    qDebug() << "m_pAirflowDownflow adc" << newVal;
                    pData->setDownflowAdcConpensation(newVal);
                    //            qDebug() << "convertADCtomVolt: " << m_boardAnalogInput2->getPAIModule()->convertADCtomVolt(newVal);
                });
        connect(m_pAirflowDownflow.data(), &AirflowVelocity::velocityChanged,
                this, &MachineBackend::_onDownflowVelocityActualChanged);
        connect(m_pAirflowDownflow.data(), &AirflowVelocity::velocityForClosedLoopChanged,
                this, [&](double velocity){
                    if (pData->getMeasurementUnit()) {
                        int valueVel = qRound(velocity / 100.0);
                        m_pDfaFanClosedLoopControl->setProcessVariable(static_cast<float>(valueVel));
                    }else{
                        double valueVel = velocity / 100.0;
                        m_pDfaFanClosedLoopControl->setProcessVariable(static_cast<float>(valueVel));
                    }
                });
        /// Temperature has effecting to Airflow Reading
        /// so, need to update temperature value on the Airflow Calculation
        connect(m_pTemperature.data(), &Temperature::celciusPrecisionChanged,
                m_pAirflowDownflow.data(), &AirflowVelocity::setTemperature);
        //        connect(m_pTemperature.data(), &Temperature::celciusChanged,
        //                m_pAirflowDownflow.data(), &AirflowVelocity::setTemperature);
    }

    /// AIRFLOW_INFLOW
    {
        ////CREATE INFLOW OBJECT
        m_pAirflowInflow.reset(new AirflowVelocity());
        m_pAirflowInflow->setAIN(m_boardAnalogInput1.data());
        m_pAirflowInflow->setChannel(1);
        //        m_pAirflowInflow->setScopeCount(3); // Default 4
        m_pAirflowInflow->setMeasurementUnit(static_cast<uchar>(pData->getMeasurementUnit()));
        //m_pAirflowInflow->setAdcResolutionBits(12);

        /// CONNECTION
        connect(m_pAirflowInflow.data(), &AirflowVelocity::adcConpensationChanged,
                pData, [&](int newVal){
                    qDebug() << "m_pAirflowInflow adc" << newVal;
                    pData->setInflowAdcConpensation(newVal);
                    //            qDebug() << "convertADCtomVolt: " << m_boardAnalogInput1->getPAIModule()->convertADCtomVolt(newVal);
                });
        connect(m_pAirflowInflow.data(), &AirflowVelocity::velocityChanged,
                this, &MachineBackend::_onInflowVelocityActualChanged);
        connect(m_pAirflowInflow.data(), &AirflowVelocity::velocityForClosedLoopChanged,
                this, [&](double velocity){
                    if (pData->getMeasurementUnit()) {
                        int valueVel = qRound(velocity / 100.0);
                        m_pIfaFanClosedLoopControl->setProcessVariable(static_cast<float>(valueVel));
                    }else{
                        double valueVel = velocity / 100.0;
                        m_pIfaFanClosedLoopControl->setProcessVariable(static_cast<float>(valueVel));
                    }
                });

        /// Temperature has effecting to Airflow Reading
        /// so, need to update temperature value on the Airflow Calculation
        connect(m_pTemperature.data(), &Temperature::celciusPrecisionChanged,
                m_pAirflowInflow.data(), &AirflowVelocity::setTemperature);
        //        connect(m_pTemperature.data(), &Temperature::celciusChanged,
        //                m_pAirflowInflow.data(), &AirflowVelocity::setTemperature);
    }

    /// AIRFLOW MONITOR ENABLE
    {
        bool airflowMonitorEnable = m_settings->value(SKEY_AF_MONITOR_ENABLE, MachineEnums::DIG_STATE_ONE).toBool();
        pData->setAirflowMonitorEnable(airflowMonitorEnable);
    }//

    /// SEAS INTEGRATED
    {
        m_pSeas.reset(new PressureDiffManager);
        m_pSeas->setSubModule(m_boardSensirionSPD8xx.data());

        short offset = static_cast<short>(m_settings->value(SKEY_SEAS_OFFSET_PA, 0).toInt());
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
        int time          = m_settings->value(SKEY_LCD_DELAY_TO_DIMM, 5 /*minute*/).toInt();
        int brightness    = m_settings->value(SKEY_LCD_BL, 50).toInt();

        /// SEND TO BOARD
        m_boardCtpIO->setOutputPWM(LEDpca9633_CHANNEL_BL, (brightness));

        /// UPDATE INFO
        pData->setLcdBrightnessLevel(static_cast<short>(brightness));
        pData->setLcdBrightnessLevelUser(static_cast<short>(brightness));
        pData->setLcdBrightnessDelayToDimm(static_cast<short>(time));

        /// SETUP TIMER EVENT
        m_timerEventForLcdToDimm.reset(new QTimer);
        m_timerEventForLcdToDimm->setInterval(std::chrono::minutes(time));

        /// CALL THIS FUNCTION WHEN TIMER WAS TRIGGERED
        QObject::connect(m_timerEventForLcdToDimm.data(), &QTimer::timeout,
                         this, &MachineBackend::_onTimerEventLcdDimm);
        ///
        QObject::connect(this, &MachineBackend::loopStarted,
                         [&](){
                             if(pData->getLcdBrightnessDelayToDimm() > 0)
                                 m_timerEventForLcdToDimm->start();
                         });
    }

    /// Language
    {
        QString langCode = m_settings->value(SKEY_LANGUAGE, "en#0#English").toString();
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
        pData->setTimeClockPeriod(static_cast<short>(timeClockPeriod));

        //        qDebug () << timeClockPeriod;

        //        qDebug() << __func__ << elapsed.elapsed() << "ms";
    }

    /// Operation Mode
    {
        int value = m_settings->value(SKEY_OPERATION_MODE,
                                      MachineEnums::MODE_OPERATION_QUICKSTART).toInt();
        pData->setOperationMode(static_cast<short>(value));

        //        qDebug() << "SKEY_OPERATION_MODE" << value;
        /// MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.OperationMode.addr, static_cast<ushort>(value));
    }

    /// SENSOR TEMPERATURE ENVIRONTMENTAL LIMITATION
    {
        QJsonObject machineProfile = pData->getMachineProfile();
        QJsonObject envTempLimit = machineProfile.value("envTempLimit").toObject();

        int highLimit = envTempLimit.value("highest").toInt();
        int lowLimit  = envTempLimit.value("lowest").toInt();

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
                                      MachineEnums::MODE_SECURITY_ACCESS_HIGH).toInt();
        pData->setSecurityAccessMode(static_cast<short>(value));

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

        QString dateExpire = m_settings->value(SKEY_CALENDER_REMINDER_MODE,dateText).toString();

        pData->setDateCertificationReminder(dateExpire);

        _checkCertificationReminder();
    }

    /// Airflow Calibration Load + FAN
    {
        QSettings settings;

        short fanMultiplier = 10;

        ///Fan Downflow
        int fanDfaMaximumDutyCycleFactory  = settings.value(SKEY_FAN_PRI_MAX_DCY_FACTORY, 40*fanMultiplier).toInt();
        int fanDfaMaximumRpmFactory        = settings.value(SKEY_FAN_PRI_MAX_RPM_FACTORY, 0).toInt();

        int fanDfaNominalDutyCycleFactory  = settings.value(SKEY_FAN_PRI_NOM_DCY_FACTORY, 35*fanMultiplier).toInt();
        int fanDfaNominalRpmFactory        = settings.value(SKEY_FAN_PRI_NOM_RPM_FACTORY, 0).toInt();

        int fanDfaMinimumDutyCycleFactory  = settings.value(SKEY_FAN_PRI_MIN_DCY_FACTORY, 25*fanMultiplier).toInt();
        int fanDfaMinimumRpmFactory        = settings.value(SKEY_FAN_PRI_MIN_RPM_FACTORY, 0).toInt();

        int fanDfaStandbyDutyCycleFactory  = settings.value(SKEY_FAN_PRI_STB_DCY_FACTORY, 18*fanMultiplier).toInt();
        int fanDfaStandbyRpmFactory        = settings.value(SKEY_FAN_PRI_STB_RPM_FACTORY, 0).toInt();

        int fanDfaMaximumDutyCycleField    = settings.value(SKEY_FAN_PRI_MAX_DCY_FIELD, 0).toInt();
        int fanDfaMaximumRpmField          = settings.value(SKEY_FAN_PRI_MAX_RPM_FIELD, 0).toInt();

        int fanDfaNominalDutyCycleField    = settings.value(SKEY_FAN_PRI_NOM_DCY_FIELD, 0).toInt();
        int fanDfaNominalRpmField          = settings.value(SKEY_FAN_PRI_NOM_RPM_FIELD, 0).toInt();

        int fanDfaMinimumDutyCycleField    = settings.value(SKEY_FAN_PRI_MIN_DCY_FIELD, 0).toInt();
        int fanDfaMinimumRpmField          = settings.value(SKEY_FAN_PRI_MIN_RPM_FIELD, 0).toInt();

        int fanDfaStandbyDutyCycleField    = settings.value(SKEY_FAN_PRI_STB_DCY_FIELD, 0).toInt();
        int fanDfaStandbyRpmField          = settings.value(SKEY_FAN_PRI_STB_RPM_FIELD, 0).toInt();

        ///Fan Inflow
        int fanIfaNominalDutyCycleFactory  = settings.value(SKEY_FAN_INF_NOM_DCY_FACTORY, 35*fanMultiplier).toInt();
        int fanIfaNominalRpmFactory        = settings.value(SKEY_FAN_INF_NOM_RPM_FACTORY, 0).toInt();

        int fanIfaMinimumDutyCycleFactory  = settings.value(SKEY_FAN_INF_MIN_DCY_FACTORY, 25*fanMultiplier).toInt();
        int fanIfaMinimumRpmFactory        = settings.value(SKEY_FAN_INF_MIN_RPM_FACTORY, 0).toInt();

        int fanIfaStandbyDutyCycleFactory  = settings.value(SKEY_FAN_INF_STB_DCY_FACTORY, 18*fanMultiplier).toInt();
        int fanIfaStandbyRpmFactory        = settings.value(SKEY_FAN_INF_STB_RPM_FACTORY, 0).toInt();

        int fanIfaNominalDutyCycleField    = settings.value(SKEY_FAN_INF_NOM_DCY_FIELD, 0).toInt();
        int fanIfaNominalRpmField          = settings.value(SKEY_FAN_INF_NOM_RPM_FIELD, 0).toInt();

        int fanIfaMinimumDutyCycleField    = settings.value(SKEY_FAN_INF_MIN_DCY_FIELD, 0).toInt();
        int fanIfaMinimumRpmField          = settings.value(SKEY_FAN_INF_MIN_RPM_FIELD, 0).toInt();

        int fanIfaStandbyDutyCycleField    = settings.value(SKEY_FAN_INF_STB_DCY_FIELD, 0).toInt();
        int fanIfaStandbyRpmField          = settings.value(SKEY_FAN_INF_STB_RPM_FIELD, 0).toInt();


        ///AIRFLOW DOWNFLOW
        int dfaSensorConstant  = settings.value(SKEY_DFA_SENSOR_CONST, 0).toInt();

        int dfaTempCalib       = settings.value(SKEY_DFA_CAL_TEMP, 0).toInt();
        int dfaTempCalibAdc    = settings.value(SKEY_DFA_CAL_TEMP_ADC, 0).toInt();

        int dfaAdcZeroFactory = settings.value(QString(SKEY_DFA_CAL_ADC_FACTORY) + "0", 0).toInt();
        int dfaAdcMinFactory  = settings.value(QString(SKEY_DFA_CAL_ADC_FACTORY) + "1", 0).toInt();
        int dfaAdcNomFactory  = settings.value(QString(SKEY_DFA_CAL_ADC_FACTORY) + "2", 0).toInt();
        int dfaAdcMaxFactory  = settings.value(QString(SKEY_DFA_CAL_ADC_FACTORY) + "3", 0).toInt();

        int dfaVelMinFactory  = settings.value(QString(SKEY_DFA_CAL_VEL_FACTORY) + "1", 27).toInt();
        int dfaVelNomFactory  = settings.value(QString(SKEY_DFA_CAL_VEL_FACTORY) + "2", 32).toInt();
        int dfaVelMaxFactory  = settings.value(QString(SKEY_DFA_CAL_VEL_FACTORY) + "3", 37).toInt();

        int dfaVelLowAlarm    = settings.value(QString(SKEY_DFA_CAL_VEL_LOW_LIMIT), dfaVelMinFactory).toInt();
        int dfaVelHighAlarm   = settings.value(QString(SKEY_DFA_CAL_VEL_HIGH_LIMIT), dfaVelMaxFactory).toInt();

        int dfaAdcZeroField   = settings.value(QString(SKEY_DFA_CAL_ADC_FIELD) + "0", 0).toInt();
        int dfaAdcMinField    = settings.value(QString(SKEY_DFA_CAL_ADC_FIELD) + "1", 0).toInt();
        int dfaAdcNomField    = settings.value(QString(SKEY_DFA_CAL_ADC_FIELD) + "2", 0).toInt();
        int dfaAdcMaxField    = settings.value(QString(SKEY_DFA_CAL_ADC_FIELD) + "3", 0).toInt();

        int dfaVelMinField    = settings.value(QString(SKEY_DFA_CAL_VEL_FIELD) + "1", 0).toInt();
        int dfaVelNomField    = settings.value(QString(SKEY_DFA_CAL_VEL_FIELD) + "2", 0).toInt();
        int dfaVelMaxField    = settings.value(QString(SKEY_DFA_CAL_VEL_FIELD) + "3", 0).toInt();

        ///AIRFLOW INFLOW
        int ifaSensorConstant  = settings.value(SKEY_IFA_SENSOR_CONST, 0).toInt();

        int ifaTempCalib       = settings.value(SKEY_IFA_CAL_TEMP, 0).toInt();
        int ifaTempCalibAdc    = settings.value(SKEY_IFA_CAL_TEMP_ADC, 0).toInt();

        int ifaAdcZeroFactory = settings.value(QString(SKEY_IFA_CAL_ADC_FACTORY) + "0", 0).toInt();
        int ifaAdcMinFactory  = settings.value(QString(SKEY_IFA_CAL_ADC_FACTORY) + "1", 0).toInt();
        int ifaAdcNomFactory  = settings.value(QString(SKEY_IFA_CAL_ADC_FACTORY) + "2", 0).toInt();

        int ifaVelMinFactory  = settings.value(QString(SKEY_IFA_CAL_VEL_FACTORY) + "1", 40).toInt();
        int ifaVelNomFactory  = settings.value(QString(SKEY_IFA_CAL_VEL_FACTORY) + "2", 45).toInt();

        int ifaVelLowAlarm    = settings.value(QString(SKEY_IFA_CAL_VEL_LOW_LIMIT), ifaVelMinFactory).toInt();

        int ifaAdcZeroField   = settings.value(QString(SKEY_IFA_CAL_ADC_FIELD) + "0", 0).toInt();
        int ifaAdcMinField    = settings.value(QString(SKEY_IFA_CAL_ADC_FIELD) + "1", 0).toInt();
        int ifaAdcNomField    = settings.value(QString(SKEY_IFA_CAL_ADC_FIELD) + "2", 0).toInt();

        int ifaVelMinField    = settings.value(QString(SKEY_IFA_CAL_VEL_FIELD) + "1", 0).toInt();
        int ifaVelNomField    = settings.value(QString(SKEY_IFA_CAL_VEL_FIELD) + "2", 0).toInt();

        ///AIRFLOW DOWNFLOW CALIBRATION STATUS
        //        //CALIB PHASE; NONE, FACTORY, or FIELD
        //        //        int afCalibPhase      = settings.value(SKEY_AF_CALIB_PHASE, 0).toInt();
        //        qDebug() << dfaAdcZeroFactory << dfaAdcMinFactory << dfaAdcNomFactory;
        //        qDebug() << dfaVelMinFactory << dfaVelNomFactory;
        //        qDebug() << fanNominalDutyCycleFactory;
        bool dfaCalibPhaseFactory = ((dfaAdcNomFactory - 160) >= dfaAdcZeroFactory)
                                    //                && (dfaAdcMinFactory < dfaAdcNomFactory)
                                    && (dfaVelMinFactory < dfaVelNomFactory)
                                    && (dfaVelNomFactory < dfaVelMaxFactory)
                                    && fanDfaNominalDutyCycleFactory;

        //        qDebug() << dfaAdcZeroField << dfaAdcMinField << dfaAdcNomField;
        //        qDebug() << dfaVelMinField << dfaVelNomField;
        //        qDebug() << fanStandbyDutyCycleField;
        bool dfaCalibPhaseField = ((dfaAdcNomField - 160) >= dfaAdcZeroField)
                                  //                && (dfaAdcMinField< dfaAdcNomField)
                                  && (dfaVelMinField < dfaVelNomField)
                                  && (dfaVelNomField < dfaVelMaxField)
                                  && fanDfaNominalDutyCycleField;

        //        qDebug() << dfaAdcZeroField << dfaVelNomField;
        //        qDebug() << dfaVelMinField << dfaVelNomField;
        //        qDebug() << dfaVelNomField << dfaVelMaxField;
        //        qDebug() << fanDfaNominalDutyCycleField;

        int downflowCalibStatus = dfaCalibPhaseField ? MachineEnums::AF_CALIB_FIELD
                                                     : (dfaCalibPhaseFactory ? MachineEnums::AF_CALIB_FACTORY : MachineEnums::AF_CALIB_NONE);

        ///AIRFLOW INFLOW CALIBRATION STATUS
        //        //CALIB PHASE; NONE, FACTORY, or FIELD
        //        //        int afCalibPhase      = settings.value(SKEY_AF_CALIB_PHASE, 0).toInt();
        //        qDebug() << ifaAdcZeroFactory << ifaAdcMinFactory << ifaAdcNomFactory;
        //        qDebug() << ifaVelMinFactory << ifaVelNomFactory;
        //        qDebug() << fanNominalDutyCycleFactory;
        bool ifaCalibPhaseFactory = ((ifaAdcNomFactory - 160) >= ifaAdcZeroFactory)
                                    //                && (ifaAdcMinFactory < ifaAdcNomFactory)
                                    && (ifaVelMinFactory < ifaVelNomFactory)
                                    && fanIfaNominalDutyCycleFactory;

        //        qDebug() << ifaAdcZeroField << ifaAdcMinField << ifaAdcNomField;
        //        qDebug() << ifaVelMinField << ifaVelNomField;
        //        qDebug() << fanStandbyDutyCycleField;
        bool ifaCalibPhaseField = ((ifaAdcNomField - 160) >= ifaAdcZeroField)
                                  //                && (ifaAdcMinField< ifaAdcNomField)
                                  && (ifaVelMinField < ifaVelNomField)
                                  && fanIfaNominalDutyCycleField;

        int inflowCalibStatus = ifaCalibPhaseField ? MachineEnums::AF_CALIB_FIELD
                                                   : (ifaCalibPhaseFactory ? MachineEnums::AF_CALIB_FACTORY : MachineEnums::AF_CALIB_NONE);

        int airflowCalibStatus = (downflowCalibStatus == MachineEnums::AF_CALIB_FIELD) && (inflowCalibStatus == MachineEnums::AF_CALIB_FIELD) ?
                                                                                                                                              MachineEnums::AF_CALIB_FIELD : (downflowCalibStatus == MachineEnums::AF_CALIB_FACTORY) && (inflowCalibStatus == MachineEnums::AF_CALIB_FACTORY) ?
                                                                                                                                                                                                                                                                 MachineEnums::AF_CALIB_FACTORY : MachineEnums::AF_CALIB_NONE;

#ifdef QT_DEBUG
        /// Testing purpose
        //        if (fanNominalDutyCycleFactory > 15) fanNominalDutyCycleFactory = 15;
        //        if (fanMinimumDutyCycleFactory > 10) fanMinimumDutyCycleFactory = 10;
        //        if (fanStandbyDutyCycleFactory > 5) fanStandbyDutyCycleFactory = 5;
        //        if (fanNominalDutyCycleField > 10) fanNominalDutyCycleField = 10;
        //        if (fanStandbyDutyCycleField > 5) fanStandbyDutyCycleField = 5;
#endif
        /// Set FAN DOWNFLOW
        pData->setFanPrimaryMaximumDutyCycleFactory(static_cast<short>(fanDfaMaximumDutyCycleFactory));
        pData->setFanPrimaryMaximumRpmFactory(fanDfaMaximumRpmFactory);

        pData->setFanPrimaryNominalDutyCycleFactory(static_cast<short>(fanDfaNominalDutyCycleFactory));
        pData->setFanPrimaryNominalRpmFactory(fanDfaNominalRpmFactory);

        pData->setFanPrimaryMinimumDutyCycleFactory(static_cast<short>(fanDfaMinimumDutyCycleFactory));
        pData->setFanPrimaryMinimumRpmFactory(fanDfaMinimumRpmFactory);

        pData->setFanPrimaryStandbyDutyCycleFactory(static_cast<short>(fanDfaStandbyDutyCycleFactory));
        pData->setFanPrimaryStandbyRpmFactory(fanDfaStandbyRpmFactory);

        pData->setFanPrimaryMaximumDutyCycleField(static_cast<short>(fanDfaMaximumDutyCycleField));
        pData->setFanPrimaryMaximumRpmField(fanDfaMaximumRpmField);

        pData->setFanPrimaryNominalDutyCycleField(static_cast<short>(fanDfaNominalDutyCycleField));
        pData->setFanPrimaryNominalRpmField(fanDfaNominalRpmField);

        pData->setFanPrimaryMinimumDutyCycleField(static_cast<short>(fanDfaMinimumDutyCycleField));
        pData->setFanPrimaryMinimumRpmField(fanDfaMinimumRpmField);

        pData->setFanPrimaryStandbyDutyCycleField(static_cast<short>(fanDfaStandbyDutyCycleField));
        pData->setFanPrimaryStandbyRpmField(fanDfaStandbyRpmField);

        /// Set FAN INFLOW
        pData->setFanInflowNominalDutyCycleFactory(static_cast<short>(fanIfaNominalDutyCycleFactory));
        pData->setFanInflowNominalRpmFactory(fanIfaNominalRpmFactory);

        pData->setFanInflowMinimumDutyCycleFactory(static_cast<short>(fanIfaMinimumDutyCycleFactory));
        pData->setFanInflowMinimumRpmFactory(fanIfaMinimumRpmFactory);

        pData->setFanInflowStandbyDutyCycleFactory(static_cast<short>(fanIfaStandbyDutyCycleFactory));
        pData->setFanInflowStandbyRpmFactory(fanIfaStandbyRpmFactory);

        pData->setFanInflowNominalDutyCycleField(static_cast<short>(fanIfaNominalDutyCycleField));
        pData->setFanInflowNominalRpmField(fanIfaNominalRpmField);

        pData->setFanInflowMinimumDutyCycleField(static_cast<short>(fanIfaMinimumDutyCycleField));
        pData->setFanInflowMinimumRpmField(fanIfaMinimumRpmField);

        pData->setFanInflowStandbyDutyCycleField(static_cast<short>(fanIfaStandbyDutyCycleField));
        pData->setFanInflowStandbyRpmField(fanIfaStandbyRpmField);

        /// SET AIRFLOW DOWNFLOW
        pData->setDownflowSensorConstant(static_cast<short>(dfaSensorConstant));
        pData->setDownflowTempCalib(static_cast<short>(dfaTempCalib));
        pData->setDownflowTempCalibAdc(static_cast<short>(dfaTempCalibAdc));

        pData->setDownflowAdcPointFactory(0, dfaAdcZeroFactory);
        pData->setDownflowAdcPointFactory(1, dfaAdcMinFactory);
        pData->setDownflowAdcPointFactory(2, dfaAdcNomFactory);
        pData->setDownflowAdcPointFactory(3, dfaAdcMaxFactory);

        pData->setDownflowVelocityPointFactory(1, dfaVelMinFactory);
        pData->setDownflowVelocityPointFactory(2, dfaVelNomFactory);
        pData->setDownflowVelocityPointFactory(3, dfaVelMaxFactory);

        pData->setDownflowLowLimitVelocity(dfaVelLowAlarm);
        pData->setDownflowHighLimitVelocity(dfaVelHighAlarm);

        pData->setDownflowAdcPointField(0, dfaAdcZeroField);
        pData->setDownflowAdcPointField(1, dfaAdcMinField);
        pData->setDownflowAdcPointField(2, dfaAdcNomField);
        pData->setDownflowAdcPointField(3, dfaAdcMaxField);

        pData->setDownflowVelocityPointField(1, dfaVelMinField);
        pData->setDownflowVelocityPointField(2, dfaVelNomField);
        pData->setDownflowVelocityPointField(3, dfaVelMaxField);

        /// SET AIRFLOW INFLOW
        pData->setInflowSensorConstant(static_cast<short>(ifaSensorConstant));
        pData->setInflowTempCalib(static_cast<short>(ifaTempCalib));
        pData->setInflowTempCalibAdc(static_cast<short>(ifaTempCalibAdc));

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

        /// \brief initAirflowCalibrationStatus
        qDebug() << "downflowCalibStatus" << downflowCalibStatus;
        qDebug() << "inflowCalibStatus" << inflowCalibStatus;
        qDebug() << "airflowCalibStatus" << airflowCalibStatus;
        pData->setDownflowCalibrationStatus(static_cast<short>(downflowCalibStatus));
        pData->setInflowCalibrationStatus(static_cast<short>(inflowCalibStatus));
        initAirflowCalibrationStatus(static_cast<short>(airflowCalibStatus));

        /// force generate velocity string
        _onInflowVelocityActualChanged(0);
        _onDownflowVelocityActualChanged(0);
    }


    /// UV SCHEDULER ON
    {
        m_uvSchedulerAutoSet.reset(new SchedulerDayOutput);

        bool enable    = m_settings->value(SKEY_SCHED_UV_ENABLE, false).toInt();
        int  time      = m_settings->value(SKEY_SCHED_UV_TIME, 480/*8:00 AM*/).toInt();
        int  repeat    = m_settings->value(SKEY_SCHED_UV_REPEAT, SchedulerDayOutput::DAYS_REPEAT_ONCE).toInt();
        int  repeatDay = m_settings->value(SKEY_SCHED_UV_REPEAT_DAY, SchedulerDayOutput::DAY_MONDAY).toInt();

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
    }//
    /// UV SCHEDULER OFF
    {
        m_uvSchedulerAutoSetOff.reset(new SchedulerDayOutput);

        bool enable    = m_settings->value(SKEY_SCHED_UV_ENABLE_OFF, false).toInt();
        int  time      = m_settings->value(SKEY_SCHED_UV_TIME_OFF, 490/*8:10 AM*/).toInt();
        int  repeat    = m_settings->value(SKEY_SCHED_UV_REPEAT_OFF, SchedulerDayOutput::DAYS_REPEAT_ONCE).toInt();
        int  repeatDay = m_settings->value(SKEY_SCHED_UV_REPEAT_DAY_OFF, SchedulerDayOutput::DAY_MONDAY).toInt();

        pData->setUVAutoEnabledOff(enable);
        pData->setUVAutoTimeOff(time);
        pData->setUVAutoDayRepeatOff(repeat);
        pData->setUVAutoWeeklyDayOff(repeatDay);

        m_uvSchedulerAutoSetOff->setEnabled(enable);
        m_uvSchedulerAutoSetOff->setTime(time);
        m_uvSchedulerAutoSetOff->setDayRepeat(repeat);
        m_uvSchedulerAutoSetOff->setWeeklyDay(repeatDay);

        /// call this when schedulling spec is same
        QObject::connect(m_uvSchedulerAutoSetOff.data(), &SchedulerDayOutput::activated,
                         this, &MachineBackend::_onTriggeredUvSchedulerAutoSetOff);
    }//

    /// FAN SCHEDULER ON
    {
        m_fanSchedulerAutoSet.reset(new SchedulerDayOutput);

        bool enable    = m_settings->value(SKEY_SCHED_FAN_ENABLE, false).toInt();
        int  time      = m_settings->value(SKEY_SCHED_FAN_TIME, 480/*8:00 AM*/).toInt();
        int  repeat    = m_settings->value(SKEY_SCHED_FAN_REPEAT, SchedulerDayOutput::DAYS_REPEAT_ONCE).toInt();
        int  repeatDay = m_settings->value(SKEY_SCHED_FAN_REPEAT_DAY, SchedulerDayOutput::DAY_MONDAY).toInt();

        pData->setFanAutoEnabled(enable);
        pData->setFanAutoTime(time);
        pData->setFanAutoDayRepeat(repeat);
        pData->setFanAutoWeeklyDay(repeatDay);

        m_fanSchedulerAutoSet->setEnabled(enable);
        m_fanSchedulerAutoSet->setTime(time);
        m_fanSchedulerAutoSet->setDayRepeat(repeat);
        m_fanSchedulerAutoSet->setWeeklyDay(repeatDay);

        /// call this when schedulling spec is the same
        QObject::connect(m_fanSchedulerAutoSet.data(), &SchedulerDayOutput::activated,
                         this, &MachineBackend::_onTriggeredFanSchedulerAutoSet);
    }//
    /// FAN SCHEDULER OFF
    {
        m_fanSchedulerAutoSetOff.reset(new SchedulerDayOutput);

        bool enable    = m_settings->value(SKEY_SCHED_FAN_ENABLE_OFF, false).toInt();
        int  time      = m_settings->value(SKEY_SCHED_FAN_TIME_OFF, 490/*8:10 AM*/).toInt();
        int  repeat    = m_settings->value(SKEY_SCHED_FAN_REPEAT_OFF, SchedulerDayOutput::DAYS_REPEAT_ONCE).toInt();
        int  repeatDay = m_settings->value(SKEY_SCHED_FAN_REPEAT_DAY_OFF, SchedulerDayOutput::DAY_MONDAY).toInt();

        pData->setFanAutoEnabledOff(enable);
        pData->setFanAutoTimeOff(time);
        pData->setFanAutoDayRepeatOff(repeat);
        pData->setFanAutoWeeklyDayOff(repeatDay);

        m_fanSchedulerAutoSetOff->setEnabled(enable);
        m_fanSchedulerAutoSetOff->setTime(time);
        m_fanSchedulerAutoSetOff->setDayRepeat(repeat);
        m_fanSchedulerAutoSetOff->setWeeklyDay(repeatDay);

        /// call this when schedulling spec is the same
        QObject::connect(m_fanSchedulerAutoSetOff.data(), &SchedulerDayOutput::activated,
                         this, &MachineBackend::_onTriggeredFanSchedulerAutoSetOff);
    }//

    /// DATA LOG
    {
        int enable = m_settings->value(SKEY_DATALOG_ENABLE, 1).toInt();
        int period = m_settings->value(SKEY_DATALOG_PERIOD, 10).toInt(); /// default every 10 minutes

        pData->setDataLogEnable(enable);
        pData->setDataLogPeriod(static_cast<short>(period));
        pData->setDataLogSpaceMaximum(DATALOG_MAX_ROW);

        m_timerEventForDataLog.reset(new QTimer);
        m_timerEventForDataLog->setInterval(period * 60 * 1000);
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

    /// REPLACEABLECOMPONENT LOG
    {
        m_pReplaceableCompRecordSql.reset(new ReplaceableCompRecordSql);
        m_pReplaceableCompRecord.reset(new ReplaceableCompRecord);
        m_pReplaceableCompRecord->setPSqlInterface(m_pReplaceableCompRecordSql.data());

        pData->setReplaceableCompRecordSpaceMaximum(ALARMREPLACEABLECOMPRECORD_MAX_ROW);

        m_threadForReplaceableCompRecord.reset(new QThread);
        /// move the object to extra thread, so every query will execute in the separated thread
        m_pReplaceableCompRecord->moveToThread(m_threadForReplaceableCompRecord.data());
        m_pReplaceableCompRecordSql->moveToThread(m_threadForReplaceableCompRecord.data());

        QObject::connect(m_threadForReplaceableCompRecord.data(), &QThread::started,
                         m_pReplaceableCompRecord.data(), [&](){
                             m_pReplaceableCompRecord->routineTask();
                         });
        QObject::connect(this, &MachineBackend::loopStarted,
                         [&](){
                             m_threadForReplaceableCompRecord->start();
                         });

        for(short i=0; i<MachineEnums::RPList_Total; i++)
            m_rpListSettings[i] =  m_pReplaceableCompRecordSql->getParameterStringFromIndex(i);

        m_settings->beginGroup("rplist");
        for(short i=1; i < MachineEnums::RPList_Total; i++){
            QString defaultValue = _getRpListDefaultValue(i);
            pData->setRpListLast(i, m_settings->value(m_rpListSettings[i], defaultValue).toString());
            pData->setRpListSelected(i, "");
            //            qDebug() << i << pData->getRpListLastAtIndex(i);
        }//
        m_settings->endGroup();

        //initReplaceablePartsSettings();
    }//

    /// RESOURCE MONITOR LOG
    {
        bool enable = m_settings->value(SKEY_RESMONLOG_ENABLE, false).toBool();
        int period = m_settings->value(SKEY_RESMONLOG_PERIOD, 10).toInt(); /// default every 10 minutes

        pData->setResourceMonitorLogEnable(enable);
        pData->setResourceMonitorLogPeriod(static_cast<short>(period));
        pData->setResourceMonitorLogSpaceMaximum(RESMONLOG_MAX_ROW);

        m_timerEventForResourceMonitorLog.reset(new QTimer);
        m_timerEventForResourceMonitorLog->setInterval(period * 60 * 1000);
        ///
        QObject::connect(m_timerEventForResourceMonitorLog.data(), &QTimer::timeout,
                         this, &MachineBackend::_insertResourceMonitorLog);
        ///
        if(enable) {
            QObject::connect(this, &MachineBackend::loopStarted,
                             [&](){
                                 pData->setResourceMonitorLogRunning(true);
                                 m_timerEventForResourceMonitorLog->start();
                             });
        }//

        m_pResourceMonitorLogSql.reset(new ResourceMonitorLogSql);
        m_pResourceMonitorLog.reset(new ResourceMonitorLog);
        m_pResourceMonitorLog->setPSqlInterface(m_pResourceMonitorLogSql.data());

        m_threadForResourceMonitorLog.reset(new QThread);
        /// move the object to extra thread, so every query will execute in the separated thread
        m_pResourceMonitorLog->moveToThread(m_threadForResourceMonitorLog.data());
        m_pResourceMonitorLogSql->moveToThread(m_threadForResourceMonitorLog.data());

        QObject::connect(m_threadForResourceMonitorLog.data(), &QThread::started,
                         m_pResourceMonitorLog.data(), [&](){
                             m_pResourceMonitorLog->routineTask();
                         });
        QObject::connect(this, &MachineBackend::loopStarted,
                         [&](){
                             m_threadForResourceMonitorLog->start();
                         });
    }

    /// Sensor Warming up
    {
        int seconds = m_settings->value(SKEY_WARMUP_TIME, 180).toInt(); //3 minutes
        pData->setWarmingUpTime(seconds);
        pData->setWarmingUpCountdown(seconds);
    }

    /// Post purging
    {
        int seconds = m_settings->value(SKEY_POSTPURGE_TIME, 0).toInt(); //0 minutes, disabled
        pData->setPostPurgingTime(seconds);
        pData->setPostPurgingCountdown(seconds);
    }

    /// Filter Meter
    {
        int mode    = m_settings->value(SKEY_FILTER_METER_MODE,     MachineEnums::FilterLifeCalc_BlowerUsage).toInt();
        int minTime = m_settings->value(SKEY_FILTER_METER_MIN_TIME, SDEF_FILTER_MINIMUM_TIME_LIFE).toInt();
        int maxTime = m_settings->value(SKEY_FILTER_METER_MAX_TIME, SDEF_FILTER_MAXIMUM_TIME_LIFE).toInt();
        int minRpm  = m_settings->value(SKEY_FILTER_METER_MIN_RPM,  SDEF_FILTER_MINIMUM_RPM_LIFE).toInt();
        int maxRpm  = m_settings->value(SKEY_FILTER_METER_MAX_RPM,  SDEF_FILTER_MAXIMUM_RPM_LIFE).toInt();

        int lifeMinutes = m_settings->value(SKEY_FILTER_METER_MIN, SDEF_FILTER_MAXIMUM_TIME_LIFE).toInt();
        int lifeRpm = m_settings->value(SKEY_FILTER_METER_RPM, SDEF_FILTER_MINIMUM_RPM_LIFE).toInt(); ///Current Nominal RPM

        int percentLeft = 100;
        if(mode == MachineEnums::FilterLifeCalc_BlowerRpm){
            int value = lifeRpm - minRpm;
            value = value > 0 ? value : 0;
            int rangeValue = maxRpm - minRpm;
            rangeValue = rangeValue > 0 ? rangeValue : 0;

            percentLeft = __getPercentFrom((rangeValue - value), rangeValue);
        }
        else{
            percentLeft = __getPercentFrom(lifeMinutes, maxTime);
        }

        /// event if in % value is zero but the minutes more then 0 minutes, then set % to 1
        if (percentLeft == 0 && lifeMinutes > 0) percentLeft = 1;

        //update to global observable variable
        pData->setFilterLifeMinutes(lifeMinutes);
        pData->setFilterLifeRpm(lifeRpm);
        pData->setFilterLifePercent(static_cast<short>(percentLeft));

        pData->setFilterLifeCalculationMode(mode);
        pData->setFilterLifeMinimumBlowerUsageMode(minTime);
        pData->setFilterLifeMaximumBlowerUsageMode(maxTime);
        pData->setFilterLifeMinimumBlowerRpmMode(minRpm);
        pData->setFilterLifeMaximumBlowerRpmMode(maxRpm);

        ///MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.FilterLife.addr, static_cast<ushort>(percentLeft));

        /// Setup variable buffer for fan rpm (moving average)
        {
            m_fanPrimaryRpmActualBuffer.reset(new QVector<uint16_t>);
            /// reset the buffer value
            m_fanPrimaryRpmActualBuffer->clear();
        }
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
        _setModbusRegHoldingValue(modbusRegisterAddress.SashCycle.addr, static_cast<ushort>(cycle/10));
    }

    /// FAN Primary Usage Meter
    {
        int minutes = m_settings->value(SKEY_FAN_PRI_METER, MachineEnums::DIG_STATE_ZERO).toInt();
        //        minutes = 1000;

        //update to global observable variable
        pData->setFanPrimaryUsageMeter(minutes);
        ///MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.DfaFanUsage.addr, static_cast<ushort>(minutes));
    }
    /// FAN Inflow Usage Meter
    {
        int minutes = m_settings->value(SKEY_FAN_INF_METER, MachineEnums::DIG_STATE_ZERO).toInt();
        //minutes = 1000;

        //update to global observable variable
        pData->setFanInflowUsageMeter(minutes);
        ///MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanUsage.addr, static_cast<ushort>(minutes));
    }

    /// Mute Audible Alarm
    {
        int seconds = m_settings->value(SKEY_MUTE_ALARM_TIME, 180).toInt(); //3 minutes
        //        minutes = 1;
        pData->setMuteAlarmTime(seconds);
        pData->setMuteAlarmCountdown(seconds);
    }

    /// Serial Number
    {
        QString year_sn = QDate::currentDate().toString("yyyy-000000");
        QString sn = m_settings->value(SKEY_SERIAL_NUMMBER, year_sn).toString();
        pData->setSerialNumber(sn);
    }

    /// JUST TIMER for triggering action by time
    {
        m_timerEventEvery50MSecond.reset(new QTimer);
        m_timerEventEvery50MSecond->setInterval(std::chrono::milliseconds(50));

        QObject::connect(m_timerEventEvery50MSecond.data(), &QTimer::timeout,
                         this, &MachineBackend::_onTriggeredEventEvery50MSecond);
        QObject::connect(this, &MachineBackend::loopStarted, [&](){
            m_timerEventEvery50MSecond->start();
        });

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
        //        QObject::connect(this, &MachineBackend::loopStarted, [&]{
        //            m_timerEventEveryMinute->start();
        //        });

        m_timerEventEveryHalfHour.reset(new QTimer);
        m_timerEventEveryHalfHour->setInterval(std::chrono::minutes(30));

        QObject::connect(m_timerEventEveryHalfHour.data(), &QTimer::timeout,
                         this, &MachineBackend::_onTriggeredEventEveryHalfHour);
        QObject::connect(this, &MachineBackend::loopStarted, [&]{
            m_timerEventEveryHalfHour->start();
        });

        m_timerEventEveryMinute2.reset(new QTimer);
        m_timerEventEveryMinute2->setInterval(std::chrono::minutes(1));

        QObject::connect(m_timerEventEveryMinute2.data(), &QTimer::timeout,
                         this, &MachineBackend::_onTriggeredEventEveryMinute2);
        QObject::connect(this, &MachineBackend::loopStarted, [&]{
            m_timerEventEveryMinute2->start();
        });

        m_timerEventEveryHour.reset(new QTimer);
        m_timerEventEveryHour->setInterval(std::chrono::hours(1));

        QObject::connect(m_timerEventEveryHour.data(), &QTimer::timeout,
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
            int poweroutage = m_settings->value(SKEY_POWER_OUTAGE, MachineEnums::DIG_STATE_ZERO).toInt();
            m_settings->setValue(SKEY_POWER_OUTAGE, MachineEnums::DIG_STATE_ZERO);
            //        qDebug() << __func__ << "poweroutage" << poweroutage;

            int uvState    = m_settings->value(SKEY_POWER_OUTAGE_UV, MachineEnums::DIG_STATE_ZERO).toInt();
            //        qDebug() << SKEY_POWER_OUTAGE_UV << uvState;
            /// clear the flag
            m_settings->setValue(SKEY_POWER_OUTAGE_UV, MachineEnums::DIG_STATE_ZERO);
            pData->setPowerOutageUvState(static_cast<short>(uvState));

            int fanState   = m_settings->value(SKEY_POWER_OUTAGE_FAN, MachineEnums::DIG_STATE_ZERO).toInt();
            //        qDebug() << SKEY_POWER_OUTAGE_FAN << uvState;
            /// clear the flag
            m_settings->setValue(SKEY_POWER_OUTAGE_FAN, MachineEnums::DIG_STATE_ZERO);
            pData->setPowerOutageFanState(static_cast<short>(fanState));

            //            /// Sash Interlocked
            //            {
            //                if(pData->getSashWindowMotorizeInstalled()){
            //                    switch (pData->getSashWindowState()) {
            //                    case MachineEnums::SASH_STATE_FULLY_CLOSE_SSV:
            //                        pData->setSashWindowMotorizeUpInterlocked(false);
            //                        pData->setSashWindowMotorizeDownInterlocked(true);
            //                        break;
            //                    case MachineEnums::SASH_STATE_FULLY_OPEN_SSV:
            //                        pData->setSashWindowMotorizeUpInterlocked(true);
            //                        pData->setSashWindowMotorizeDownInterlocked(false);
            //                        break;
            //                    default: break;
            //                    }
            //                }//
            //            }//

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

                if(pData->getSashWindowMotorizeUpInterlocked()){
                    m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                }

                if(pData->getSashWindowMotorizeDownInterlocked()){
                    m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                }

                qDebug() << "###-> pData->getSashWindowState()" << pData->getSashWindowState();

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
                        short dfaDutyCycle = pData->getFanPrimaryNominalDutyCycle();
                        short ifaDutyCycle = pData->getFanInflowNominalDutyCycle();
                        if(pData->getSashWindowState() == MachineEnums::SASH_STATE_WORK_SSV){
                            ///Force turned on light if the blower is nominal
                            //                            m_pLight->setInterlock(MachineEnums::DIG_STATE_ZERO);
                            //                            m_pLight->setState(MachineEnums::DIG_STATE_ONE);
                            //                            m_pLight->routineTask();
                            //                            m_i2cPort->sendOutQueue();
                        }else if(pData->getSashWindowState() == MachineEnums::SASH_STATE_STANDBY_SSV){
                            dfaDutyCycle = pData->getFanPrimaryStandbyDutyCycle();
                            ifaDutyCycle = pData->getFanInflowStandbyDutyCycle();
                        }else{
                            dfaDutyCycle = pData->getFanPrimaryStandbyDutyCycle();
                            ifaDutyCycle = pData->getFanInflowStandbyDutyCycle();
                        }

                        //                        switch (fanState) {
                        //                        case MachineEnums::FAN_STATE_ON:
                        //                            ///Force turned on light if the blower is nominal
                        //                            m_pLight->setInterlock(MachineEnums::DIG_STATE_ZERO);
                        //                            m_pLight->setState(MachineEnums::DIG_STATE_ONE);
                        //                            m_pLight->routineTask();
                        //                            m_i2cPort->sendOutQueue();
                        //                            break;
                        //                        case MachineEnums::FAN_STATE_STANDBY:
                        //                            dfaDutyCycle = pData->getFanPrimaryStandbyDutyCycle();
                        //                            ifaDutyCycle = pData->getFanInflowStandbyDutyCycle();
                        //                            break;
                        //                        case MachineEnums::FAN_STATE_DIFFERENT:
                        //                            dfaDutyCycle = pData->getFanPrimaryStandbyDutyCycle();
                        //                            ifaDutyCycle = pData->getFanInflowStandbyDutyCycle();
                        //                            break;
                        //                        }
                        if(pData->getCabinetWidth3Feet()){
                            if(pData->getUsePwmOutSignal()){
                                m_pFanPrimaryPWM->setState(/*pData->getFanPrimaryNominalDutyCycle()*/dfaDutyCycle);
                                m_pFanPrimaryPWM->routineTask();
                            }
                            else{
                                m_pFanPrimaryAO->setState(/*pData->getFanPrimaryNominalDutyCycle()*/dfaDutyCycle);
                                m_pFanPrimaryAO->routineTask();
                            }
                        }
                        else
                        {
                            m_pFanPrimary->setDutyCycle(/*pData->getFanPrimaryNominalDutyCycle()*/dfaDutyCycle);
                            m_pFanPrimary->routineTask();
                        }
                        if(pData->getDualRbmMode()){
                            m_pFanInflow->setDutyCycle(/*pData->getFanInflowNominalDutyCycle()*/ifaDutyCycle);
                            m_pFanInflow->routineTask();
                        }
                        else {
                            if(pData->getUsePwmOutSignal()){
                                m_pFanInflowPWM->setState(/*pData->getFanInflowNominalDutyCycle()*/ifaDutyCycle);
                                m_pFanInflowPWM->routineTask();
                            }
                            else{
                                m_pFanInflowAO->setState(/*pData->getFanInflowNominalDutyCycle()*/ifaDutyCycle);
                                m_pFanInflowAO->routineTask();
                            }
                        }

                        bool dfaUpdated = false;
                        bool ifaUpdated = false;
                        /// wait until fan actually turned on or exceed the time out (10 seconds)
                        for (int var = 0; var < 10; ++var) {
                            if(pData->getCabinetWidth3Feet()){
                                if(pData->getUsePwmOutSignal())
                                    m_pFanPrimaryPWM->routineTask();
                                else
                                    m_pFanPrimaryAO->routineTask();
                            }
                            else m_pFanPrimary->routineTask();
                            if(pData->getDualRbmMode())
                                m_pFanInflow->routineTask();
                            else {
                                if(pData->getUsePwmOutSignal())
                                    m_pFanInflowPWM->routineTask();
                                else
                                    m_pFanInflowAO->routineTask();
                            }

                            if(pData->getCabinetWidth3Feet()){
                                int fanPrimaryState =  pData->getUsePwmOutSignal() ? m_pFanPrimaryPWM->state() : m_pFanPrimaryAO->getState();
                                if(fanPrimaryState == dfaDutyCycle && !dfaUpdated){
                                    //qDebug() << __func__ << "Power outage - Fan State Changed" << var;
                                    _onFanPrimaryActualDucyChanged(dfaDutyCycle);
                                    dfaUpdated = true;
                                }
                            }else{
                                if(m_pFanPrimary->dutyCycle() == dfaDutyCycle && !dfaUpdated){
                                    //qDebug() << __func__ << "Power outage - Fan State Changed" << var;
                                    _onFanPrimaryActualDucyChanged(dfaDutyCycle);
                                    dfaUpdated = true;
                                }
                            }
                            if(pData->getDualRbmMode()){
                                if((m_pFanInflow->dutyCycle() == ifaDutyCycle) && !ifaUpdated){
                                    //qDebug() << __func__ << "Power outage - Fan State Changed" << var;
                                    _onFanInflowActualDucyChanged(ifaDutyCycle);
                                    ifaUpdated = true;
                                }
                            }else{
                                int fanInflowState =  pData->getUsePwmOutSignal() ? m_pFanInflowPWM->state() : m_pFanInflowAO->getState();
                                if((fanInflowState == ifaDutyCycle) && !ifaUpdated){
                                    //qDebug() << __func__ << "Power outage - Fan State Changed" << var;
                                    _onFanInflowActualDucyChanged(ifaDutyCycle);
                                    ifaUpdated = true;
                                }
                            }
                            if(dfaUpdated && ifaUpdated) break;
                            QThread::sleep(1);
                        }//
                    }//
                }//
                break;
                }//
            }//
        }//
    }//
    //    _initPreventMaintReminder();
    {
        QDateTime nowDateTime = QDateTime().currentDateTime();
        //        QString curDateTimeStr = nowDateTime.toString("dd-MM-yyyy hh:mm:ss");
        QString curDateTimeStr = "01-01-2000 00:00:00";

        QString daily       = m_settings->value(SKEY_PM_LAST_ACK_DAILY, curDateTimeStr).toString();
        QString weekly      = m_settings->value(SKEY_PM_LAST_ACK_WEEKLY, curDateTimeStr).toString();
        QString monthly     = m_settings->value(SKEY_PM_LAST_ACK_MONTHLY, curDateTimeStr).toString();
        QString quarterly   = m_settings->value(SKEY_PM_LAST_ACK_QUARTERLY, curDateTimeStr).toString();
        QString annually    = m_settings->value(SKEY_PM_LAST_ACK_ANNUALLY, curDateTimeStr).toString();
        QString biennially  = m_settings->value(SKEY_PM_LAST_ACK_BIENNIALLY, curDateTimeStr).toString();
        QString quinquennially = m_settings->value(SKEY_PM_LAST_ACK_QUINQUENNIALLY, curDateTimeStr).toString();
        QString canopy      = m_settings->value(SKEY_PM_LAST_ACK_CANOPY, curDateTimeStr).toString();

        //        qDebug() << "Current Date:";
        //        qDebug() << curDateTimeStr;
        //        qDebug() << "Last PM Acknowledge:";
        //        qDebug() << daily;
        //        qDebug() << weekly;
        //        qDebug() << monthly;
        //        qDebug() << quarterly;
        //        qDebug() << annually;
        //        qDebug() << biennially;
        //        qDebug() << quinquennially;
        //        qDebug() << canopy;


        ushort dfault = (MachineEnums::PM_QUARTERLY_CODE |
                         MachineEnums::PM_ANNUALLY_CODE |
                         MachineEnums::PM_BIENNIALLY_CODE |
                         MachineEnums::PM_QUINQUENNIALLY_CODE /*|
                                                                                                                                                                                                                                                                                                                                                                                                       MachineEnums::PM_CANOPY_CODE*/);

        ushort alarmEn = static_cast<ushort>(m_settings->value(SKEY_PM_ALARM_EN, dfault).toInt());

        //        qDebug() << "Default & AlarmEnable:";
        //        qDebug() << dfault << alarmEn;

        pData->setAlarmPreventMaintStateEnable(alarmEn);

        pData->setDailyPreventMaintLastAckDate(daily);
        pData->setWeeklyPreventMaintLastAckDate(weekly);
        pData->setMonthlyPreventMaintLastAckDate(monthly);
        pData->setQuarterlyPreventMaintLastAckDate(quarterly);
        pData->setAnnuallyPreventMaintLastAckDate(annually);
        pData->setBienniallyPreventMaintLastAckDate(biennially);
        pData->setQuinquenniallyPreventMaintLastAckDate(quinquennially);
        pData->setCanopyPreventMaintLastAckDate(canopy);

        QDateTime lastAckDailyDateTime = QDateTime().fromString(daily, "dd-MM-yyyy hh:mm:ss");
        QDateTime lastAckWeeklyDateTime = QDateTime().fromString(weekly, "dd-MM-yyyy hh:mm:ss");
        QDateTime lastAckMonthlyDateTime = QDateTime().fromString(monthly, "dd-MM-yyyy hh:mm:ss");
        QDateTime lastAckQuarterlyDateTime = QDateTime().fromString(quarterly, "dd-MM-yyyy hh:mm:ss");
        QDateTime lastAckAnnuallyDateTime = QDateTime().fromString(annually, "dd-MM-yyyy hh:mm:ss");
        QDateTime lastAckBienniallyDateTime = QDateTime().fromString(biennially, "dd-MM-yyyy hh:mm:ss");
        QDateTime lastAckQuinquenniallyDateTime = QDateTime().fromString(quinquennially, "dd-MM-yyyy hh:mm:ss");
        QDateTime lastAckCanopyDateTime = QDateTime().fromString(canopy, "dd-MM-yyyy hh:mm:ss");

        QDateTime dueDateTimeDaily = lastAckDailyDateTime.addDays(1);
        QDateTime dueDateTimeWeekly = lastAckWeeklyDateTime.addDays(7);
        QDateTime dueDateTimeMonthly = lastAckMonthlyDateTime.addMonths(1);
        QDateTime dueDateTimeQuarterly = lastAckQuarterlyDateTime.addMonths(3);
        QDateTime dueDateTimeAnnually = lastAckAnnuallyDateTime.addYears(1);
        QDateTime dueDateTimeBiennially = lastAckBienniallyDateTime.addYears(2);
        QDateTime dueDateTimeQuinquennially = lastAckQuinquenniallyDateTime.addYears(5);
        QDateTime dueDateTimeCanopy = lastAckCanopyDateTime.addMonths(1);

        //        qDebug() << "Due date for acknowledging:";
        //        qDebug() << dueDateTimeDaily.toString("dd-MM-yyyy hh:mm:ss");
        //        qDebug() << dueDateTimeWeekly.toString("dd-MM-yyyy hh:mm:ss");
        //        qDebug() << dueDateTimeMonthly.toString("dd-MM-yyyy hh:mm:ss");
        //        qDebug() << dueDateTimeQuarterly.toString("dd-MM-yyyy hh:mm:ss");
        //        qDebug() << dueDateTimeAnnually.toString("dd-MM-yyyy hh:mm:ss");
        //        qDebug() << dueDateTimeBiennially.toString("dd-MM-yyyy hh:mm:ss");
        //        qDebug() << dueDateTimeQuinquennially.toString("dd-MM-yyyy hh:mm:ss");
        //        qDebug() << dueDateTimeCanopy.toString("dd-MM-yyyy hh:mm:ss");

        pData->setDailyPreventMaintAckDueDate(dueDateTimeDaily.toString("dd-MM-yyyy hh:mm:ss"));
        pData->setWeeklyPreventMaintAckDueDate(dueDateTimeWeekly.toString("dd-MM-yyyy hh:mm:ss"));
        pData->setMonthlyPreventMaintAckDueDate(dueDateTimeMonthly.toString("dd-MM-yyyy hh:mm:ss"));
        pData->setQuarterlyPreventMaintAckDueDate(dueDateTimeQuarterly.toString("dd-MM-yyyy hh:mm:ss"));
        pData->setAnnuallyPreventMaintAckDueDate(dueDateTimeAnnually.toString("dd-MM-yyyy hh:mm:ss"));
        pData->setBienniallyPreventMaintAckDueDate(dueDateTimeBiennially.toString("dd-MM-yyyy hh:mm:ss"));
        pData->setQuinquenniallyPreventMaintAckDueDate(dueDateTimeQuinquennially.toString("dd-MM-yyyy hh:mm:ss"));
        pData->setCanopyPreventMaintAckDueDate(dueDateTimeCanopy.toString("dd-MM-yyyy hh:mm:ss"));

        ushort alarmPm = 0;
        qint64 dayLeft = 0;
        if(alarmEn & MachineEnums::PM_DAILY_CODE){
            dayLeft = nowDateTime.secsTo(dueDateTimeDaily);
            if(dayLeft <= 82800) alarmPm |= MachineEnums::PM_DAILY_CODE; /// Activate the alarm when time left less than 6 hours
            //            qDebug() << "secsLeft:" << dayLeft;
        }
        if(alarmEn & MachineEnums::PM_WEEKLY_CODE){
            dayLeft = nowDateTime.daysTo(dueDateTimeWeekly);
            if(dayLeft <= 2) alarmPm |= MachineEnums::PM_WEEKLY_CODE;
            //            qDebug() << "dayLeft:" << dayLeft;
        }
        if(alarmEn & MachineEnums::PM_MONTHLY_CODE){
            dayLeft = nowDateTime.daysTo(dueDateTimeMonthly);
            if(dayLeft < 7) alarmPm |= MachineEnums::PM_MONTHLY_CODE;
            //            qDebug() << "dayLeft:" << dayLeft;
        }
        if(alarmEn & MachineEnums::PM_QUARTERLY_CODE){
            dayLeft = nowDateTime.daysTo(dueDateTimeQuarterly);
            if(dayLeft < 14) alarmPm |= MachineEnums::PM_QUARTERLY_CODE;
            //            qDebug() << "dayLeft:" << dayLeft;
        }
        if(alarmEn & MachineEnums::PM_ANNUALLY_CODE){
            dayLeft = nowDateTime.daysTo(dueDateTimeAnnually);
            if(dayLeft < 30) alarmPm |= MachineEnums::PM_ANNUALLY_CODE;
            //            qDebug() << "dayLeft:" << dayLeft;
        }
        if(alarmEn & MachineEnums::PM_BIENNIALLY_CODE){
            dayLeft = nowDateTime.daysTo(dueDateTimeBiennially);
            if(dayLeft < 30) alarmPm |= MachineEnums::PM_BIENNIALLY_CODE;
            //            qDebug() << "dayLeft:" << dayLeft;
        }
        if(alarmEn & MachineEnums::PM_QUINQUENNIALLY_CODE){
            dayLeft = nowDateTime.daysTo(dueDateTimeQuinquennially);
            if(dayLeft < 30) alarmPm |= MachineEnums::PM_QUINQUENNIALLY_CODE;
            //            qDebug() << "dayLeft:" << dayLeft;
        }
        if(alarmEn & MachineEnums::PM_CANOPY_CODE){
            dayLeft = nowDateTime.daysTo(dueDateTimeCanopy);
            if(dayLeft < 7) alarmPm |= MachineEnums::PM_CANOPY_CODE;
            //            qDebug() << "dayLeft:" << dayLeft;
        }

        //        qDebug() << "Alarm PM:" << alarmPm;
        pData->setAlarmPreventMaintState(alarmPm);
    }

    /// User Last Login
    {
        QJsonArray userLastLoginArr = m_settings->value(SKEY_USER_LAST_LOGIN, QJsonArray()).toJsonArray();
        pData->setUserLasLogin(userLastLoginArr);
    }//

    {
        int logoutTime = m_settings->value(SKEY_LOGOUT_TIME, 30*60).toInt();
        pData->setLogoutTime(logoutTime);
    }

    {
        bool enable = m_settings->value(SKEY_21_CFR_11_EN, false).toBool();
        pData->setCfr21Part11Enable(enable);
    }
    {
        /// Execute later
        QTimer::singleShot(30000, this, [&](){
            initWiredConnectionStaticIP();
        });
    }
    /// General connection for Debugging
    QObject::connect(pData, &MachineData::fanStateChanged,
                     this, [&](short value){
                         if(value == MachineEnums::FAN_STATE_OFF) qDebug() << "***** FAN OFF *****";
                         else if(value == MachineEnums::FAN_STATE_ON) qDebug() << "***** FAN ON *****";
                         else if(value == MachineEnums::FAN_STATE_STANDBY) qDebug() << "***** FAN STANDBY *****";
                         else if(value == MachineEnums::FAN_STATE_DIFFERENT) qDebug() << "***** FAN DIFFERENT *****";
                     });
    QObject::connect(pData, &MachineData::sashCycleMeterChanged,
                     this, [&](int cycle){
                         ///MODBUS
                         _setModbusRegHoldingValue(modbusRegisterAddress.SashCycle.addr, static_cast<ushort>(cycle/10));
                     });
    QObject::connect(pData, &MachineData::frontPanelAlarmChanged,
                     this, [&](bool alarm){
                         ///MODBUS
                         _setModbusRegHoldingValue(modbusRegisterAddress.AlarmFrontPanel.addr, alarm);
                     });
    QObject::connect(pData, &MachineData::sashMotorDownStuckSwitchChanged,
                     this, [&](bool alarm){
                         if(alarm) {
                             if((pData->getSashWindowState() != MachineEnums::SASH_STATE_FULLY_CLOSE_SSV) && m_sashMovedDown)
                             {
                                 m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                                 m_pSasWindowMotorize->routineTask();
                                 m_sashMovedDown = false;
                                 pData->setAlarmSashMotorDownStuck(MachineEnums::ALARM_ACTIVE_STATE);
                                 setBuzzerState(MachineEnums::DIG_STATE_ONE);
                                 _insertAlarmLog(ALARM_LOG_CODE::ALC_SASH_MOTOR_DOWN_STUCK_ALARM, ALARM_LOG_TEXT_SASH_MOTOR_DOWN_STUCK_ALARM);
                                 m_pSashWindow->setSafeSwitcher(SashWindow::SWITCHER_UP);
                                 m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_UP);
                                 m_pSasWindowMotorize->routineTask();
                                 qDebug() << "Start timer to turn off sash motor after move up";
                                 QTimer::singleShot(m_delaySashMotorUpAfterStucked, this, [&](){
                                     qDebug() << "Turn off sash motorized!";
                                     m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                                     m_pSasWindowMotorize->routineTask();
                                     setBuzzerState(MachineEnums::DIG_STATE_ZERO);
                                     pData->setAlarmSashMotorDownStuck(MachineEnums::ALARM_NORMAL_STATE);
                                     _insertAlarmLog(ALARM_LOG_CODE::ALC_SASH_MOTOR_DOWN_STUCK_OK, ALARM_LOG_TEXT_SASH_MOTOR_DOWN_STUCK_OK);
                                 });
                             }//
                         }//
                     });

    {
        ///SKEY_SASH_MOTOR_OFF_DELAY
        if(pData->getSashWindowMotorizeInstalled()){
            int sashDelay = m_settings->value(SKEY_SASH_MOTOR_OFF_DELAY, 700).toInt();
            pData->setSashMotorOffDelayMsec(sashDelay);
        }
    }
    {
        ///SKEY_DELAY_ALARM_AIRFLOW
        int alarmDelay = m_settings->value(SKEY_DELAY_ALARM_AIRFLOW, 2).toInt();
        pData->setDelayAlarmAirflowSec(alarmDelay);
    }

    /// Buzzer indication
    {
        /// give finished machine backend setup
        m_pBuzzer->setState(MachineEnums::DIG_STATE_ONE);
        sleep(1);
        m_pBuzzer->setState(MachineEnums::DIG_STATE_ZERO);
    }

    /// Initialize ResourceMonitorParams value
    {
        pData->setResourceMonitorParams(QStringList() << "00" << "00" << "00");
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
}//

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
    //m_pSashWindow->routineTask();
    m_pTemperature->routineTask();
    //if(pData->getFanInflowDutyCycle() > 0)
    m_pAirflowInflow->routineTask();
    //if(pData->getFanPrimaryDutyCycle() > 0)
    m_pAirflowDownflow->routineTask();

    if(pData->getSeasInstalled()) { m_pSeas->routineTask(); }

    /// PROCESSING
    /// put any processing/machine value condition in here
    //    pData->setCount(pData->getCount() + 1);
    //    _onInflowVelocityActualChanged(pData->getCount() + 100);
    _machineState();

    /// ACTUATOR
    /// put any actuator routine task in here
    m_pSasWindowMotorize->routineTask();

    m_pLightIntensity->routineTask();

    if(pData->getUsePwmOutSignal()){
        if(!pData->getDualRbmMode())
            m_pFanInflowPWM->routineTask();
        if(pData->getCabinetWidth3Feet()){
            m_pFanPrimaryPWM->routineTask();
        }
        //        m_pLightIntensityPWM->routineTask();
    }else{
        if(!pData->getDualRbmMode())
            m_pFanInflowAO->routineTask();
        if(pData->getCabinetWidth3Feet()){
            m_pFanPrimaryAO->routineTask();
        }
    }

    m_pLight->routineTask();
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
    m_timerEventForSashWindowRoutine->stop();
    m_timerEventEvery50MSecond->stop();
    m_timerEventEverySecond->stop();
    if(m_timerEventEveryMinute->isActive())
        m_timerEventEveryMinute->stop();
    m_timerEventEveryMinute2->stop();
    m_timerEventEveryHalfHour->stop();
    m_timerEventEveryHour->stop();
    m_timerEventForDataLog->stop();
    m_timerEventForResourceMonitorLog->stop();
    if(m_timerEventForLcdToDimm->isActive())
        m_timerEventForLcdToDimm->stop();
    m_timerEventForRTCWatchdogReset->stop();
    if(m_timerEventForClosedLoopControl->isActive())
        m_timerEventForClosedLoopControl->stop();
    //    if(m_timerEventForSashMotorInterlockSwitch->isActive())
    //        m_timerEventForSashMotorInterlockSwitch->stop();
    /// Turn Off the Blowers
    //if(pData->getFanState())
    //    setFanState(MachineEnums::FAN_STATE_OFF);
    /// turned off the Downflow blower
    //    if(pData->getFanPrimaryState()){
    //        _setFanPrimaryStateOFF();
    //        pData->setFanPrimaryState(MachineEnums::FAN_STATE_OFF);
    //        QEventLoop waitLoop;
    //        /// https://www.kdab.com/nailing-13-signal-slot-mistakes-clazy-1-3/
    //        //m_pFanPrimary->setInterlock(MachineEnums::DIG_STATE_ZERO);
    //        QObject::connect(m_pFanPrimary.data(), &BlowerRbmDsi::dutyCycleChanged,
    //                         &waitLoop, [this, &waitLoop] (int dutyCycle){
    //            qDebug() << "waitLoop" << dutyCycle;
    //            if (dutyCycle == 0){
    //                waitLoop.exit(1);
    //            }
    //            else {
    //                _setFanPrimaryStateOFF();
    //            }
    //        });
    //        waitLoop.exec();
    //    }//

    //    /// turned off the Inflow blower
    //    if(pData->getFanInflowState()){
    //        _setFanInflowStateOFF();
    //        pData->setFanInflowState(MachineEnums::FAN_STATE_OFF);
    //        QEventLoop waitLoop;
    //        /// https://www.kdab.com/nailing-13-signal-slot-mistakes-clazy-1-3/
    //        //m_pFanInflowAO->setInterlock(MachineEnums::DIG_STATE_ZERO);
    //        QObject::connect(m_pFanInflowAO.data(), &DeviceAnalogCom::stateChanged,
    //                         &waitLoop, [this, &waitLoop] (int state){
    //            qDebug() << "waitLoop" << state;
    //            if (state == 0){
    //                waitLoop.exit(1);
    //            }
    //            else {
    //                _setFanInflowStateOFF();
    //            }
    //        });
    //        waitLoop.exec();
    //    }//

    QMetaObject::invokeMethod(m_pUSBAutoMount.data(), [&](){
            m_pUSBAutoMount->ejectAllUsb();
        },
        Qt::DirectConnection);

    if(m_threadForCheckSwUpdate){
        m_threadForCheckSwUpdate->quit();
        m_threadForCheckSwUpdate->wait();
    }

    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-2";
    if(m_threadForBoardIO){
        m_threadForBoardIO->quit();
        m_threadForBoardIO->wait();
    }

    //    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-3";
    if(!pData->getCabinetWidth3Feet()){
        if(m_threadForFanRbmDsi){
            m_threadForFanRbmDsi->quit();
            m_threadForFanRbmDsi->wait();
        }
        if(pData->getDualRbmMode()){
            if(m_threadForFanRbmDsi2){
                m_threadForFanRbmDsi2->quit();
                m_threadForFanRbmDsi2->wait();
            }
        }
    }//

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

    if(m_threadForReplaceableCompRecord){
        m_threadForReplaceableCompRecord->quit();
        m_threadForReplaceableCompRecord->wait();
    }

    if(m_threadForResourceMonitorLog){
        m_threadForResourceMonitorLog->quit();
        m_threadForResourceMonitorLog->wait();
    }
    if(m_threadForParticleCounter){
        m_threadForParticleCounter->quit();
        m_threadForParticleCounter->wait();
    }

    //    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-7";

    if(m_threadForUSBAutoMount){
        m_threadForUSBAutoMount->quit();
        m_threadForUSBAutoMount->wait();
    }

    //    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-8";

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

    qDebug() << metaObject()->className() << __FUNCTION__ << "will be stopped" << thread();
    emit hasStopped();
}

void MachineBackend::_onTriggeredEventSashWindowRoutine()
{
    //#ifndef QT_DEBUG
    //    QElapsedTimer timer;
    //    timer.start();
    //#endif

    //qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    m_pSashWindow->routineTask();

    //short sashPrev = pData->getSashWindowPrevState();
    short sashState = pData->getSashWindowState();

    QString sashPrevStr = "";
    QString sashStr = "";
    //    switch(sashPrev){
    //    case MachineEnums::SASH_STATE_ERROR_SENSOR_SSV: sashPrevStr = "Error"; break;
    //    case MachineEnums::SASH_STATE_FULLY_CLOSE_SSV: sashPrevStr = "Closed"; break;
    //    case MachineEnums::SASH_STATE_UNSAFE_SSV: sashPrevStr = "Unsafe"; break;
    //    case MachineEnums::SASH_STATE_STANDBY_SSV: sashPrevStr = "Standby"; break;
    //    case MachineEnums::SASH_STATE_WORK_SSV: sashPrevStr = "Safe"; break;
    //    case MachineEnums::SASH_STATE_FULLY_OPEN_SSV: sashPrevStr = "Opened"; break;
    //    default: break;
    //    }
    switch(sashState){
    case MachineEnums::SASH_STATE_ERROR_SENSOR_SSV: sashStr = "Error"; break;
    case MachineEnums::SASH_STATE_FULLY_CLOSE_SSV: sashStr = "Closed"; break;
    case MachineEnums::SASH_STATE_UNSAFE_SSV: sashStr = "Unsafe"; break;
    case MachineEnums::SASH_STATE_STANDBY_SSV: sashStr = "Standby"; break;
    case MachineEnums::SASH_STATE_WORK_SSV: sashStr = "Safe"; break;
    case MachineEnums::SASH_STATE_FULLY_OPEN_SSV: sashStr = "Opened"; break;
    default: break;
    }

    //#ifndef QT_DEBUG
    //qDebug() << "SashWindow :" << sashPrevStr << sashStr;
    //#endif
    //    for(short i=1; i>=0; i--){
    //        if(i>0)
    //            pData->setSashWindowStateSample(pData->getSashWindowStateSample(i-1), i);
    //        else
    //            pData->setSashWindowStateSample(sashState, i);
    //    }

    bool sashChangedValid = /*(pData->getSashWindowStateSample(0) == pData->getSashWindowStateSample(1))*/true;
    //    sashChangedValid &= (pData->getSashWindowStateSample(1) == pData->getSashWindowStateSample(2));
    //    sashChangedValid &= (pData->getSashWindowStateSample(2) == pData->getSashWindowStateSample(3));
    //    sashChangedValid &= (pData->getSashWindowStateSample(3) == pData->getSashWindowStateSample(4));

    if(sashChangedValid)
        pData->setSashWindowStateChangedValid(true);
    else
        pData->setSashWindowStateChangedValid(false);
    //qDebug() << "SashSample :" << pData->getSashWindowStateSample(0) << pData->getSashWindowStateSample(1) << pData->getSashWindowStateSample(2)  << pData->getSashWindowStateSample(3) << pData->getSashWindowStateSample(4) << sashChangedValid;

    int modeOperation = pData->getOperationMode();

    switch(modeOperation){
    case MachineEnums::MODE_OPERATION_QUICKSTART:
    case MachineEnums::MODE_OPERATION_NORMAL:
        switch(sashState){
        case MachineEnums::SASH_STATE_ERROR_SENSOR_SSV:
            ////MOTORIZE SASH
            if(pData->getSashWindowMotorizeInstalled()){

                if(pData->getSashWindowMotorizeUpInterlocked()){
                    m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                }

                if(pData->getSashWindowMotorizeDownInterlocked()){
                    m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                }

                if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
                    if(pData->getSashWindowMotorizeState()){
                        if(pData->getSashCycleCountValid()){
                            pData->setSashCycleCountValid(false);
                        }
                        qDebug() << "Sash Motor Off in Sash Error";
                        m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                        m_pSasWindowMotorize->routineTask();
                        if(m_sashMovedDown)m_sashMovedDown = false;
                    }//
                }//
            }//
            ///// CLEAR FLAG OF SASH STATE FLAG
            //    if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
            //       m_pSashWindow->clearFlagSashStateChanged();
            //    }
            break;
        case MachineEnums::SASH_STATE_FULLY_CLOSE_SSV:
            ////MOTORIZE SASH
            if(pData->getSashWindowMotorizeInstalled()){
                if(pData->getSashWindowMotorizeUpInterlocked()){
                    m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                }

                if((pData->getSashWindowPrevState() == MachineEnums::SASH_STATE_FULLY_CLOSE_SSV)
                    && (pData->getSashWindowMotorizeState() == MachineEnums::MOTOR_SASH_STATE_DOWN)){
                    if(!pData->getSashWindowMotorizeDownInterlocked()){
                        m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ONE);
                    }
                }

                if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
                    ///Ensure the Buzzer Alarm Off Once Sash Fully Closed
                    setBuzzerState(MachineEnums::DIG_STATE_ZERO);

                    //                    if(pData->getSashWindowMotorizeState()){
                    if(!pData->getSashCycleCountValid()){
                        pData->setSashCycleCountValid(true);
                    }
                    if(pData->getSashMotorOffDelayMsec()){
                        if(!eventTimerForDelayMotorizedOffAtFullyClosed){
                            m_delaySashMotorFullyClosedExecuted = false;
                            /// Give a delay for a moment for sash moving down after fully closed detected
                            eventTimerForDelayMotorizedOffAtFullyClosed = new QTimer();
                            eventTimerForDelayMotorizedOffAtFullyClosed->setInterval(pData->getSashMotorOffDelayMsec());
                            eventTimerForDelayMotorizedOffAtFullyClosed->setSingleShot(true);
                            ///Ececute this block after a certain time (pData->getSashMotorOffDelayMsec())
                            QObject::connect(eventTimerForDelayMotorizedOffAtFullyClosed, &QTimer::timeout,
                                             eventTimerForDelayMotorizedOffAtFullyClosed, [=](){
                                                 qDebug() << "Sash Motor Off in Sash Fully Closed With Delay";
                                                 m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                                                 m_pSasWindowMotorize->routineTask();
                                                 if(m_sashMovedDown)m_sashMovedDown = false;
                                                 m_delaySashMotorFullyClosedExecuted = true;
                                                 setBuzzerState(MachineEnums::DIG_STATE_ZERO);
                                             });
                            qDebug() << "Timer Sash Motor Off in Sash Fully Closed Start";
                            eventTimerForDelayMotorizedOffAtFullyClosed->start();
                        }
                    }else{
                        qDebug() << "Sash Motor Off in Sash Fully Closed";
                        m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                        m_pSasWindowMotorize->routineTask();
                        if(m_sashMovedDown)m_sashMovedDown = false;
                    }
                    //                }
                }
                if(m_delaySashMotorFullyClosedExecuted){
                    if(!pData->getSashWindowMotorizeDownInterlocked()){
                        m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ONE);
                    }
                    if (eventTimerForDelayMotorizedOffAtFullyClosed != nullptr) {
                        eventTimerForDelayMotorizedOffAtFullyClosed->stop();
                        delete eventTimerForDelayMotorizedOffAtFullyClosed;
                        eventTimerForDelayMotorizedOffAtFullyClosed = nullptr;
                    }
                }
            }
            //        /// CLEAR FLAG OF SASH STATE FLAG
            //        if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
            //            m_pSashWindow->clearFlagSashStateChanged();
            //        }
            break;
        case MachineEnums::SASH_STATE_UNSAFE_SSV:
            ////MOTORIZE SASH
            if(pData->getSashWindowMotorizeInstalled()){

                if(pData->getSashWindowMotorizeUpInterlocked()){
                    m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                }

                if(pData->getSashWindowMotorizeDownInterlocked()){
                    m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                }
            }
            //        /// CLEAR FLAG OF SASH STATE FLAG
            //        if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
            //            m_pSashWindow->clearFlagSashStateChanged();
            //        }
            break;
        case MachineEnums::SASH_STATE_STANDBY_SSV:
            ////MOTORIZE SASH
            if(pData->getSashWindowMotorizeInstalled()){
                if(pData->getSashWindowMotorizeUpInterlocked()){
                    m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                }

                if(pData->getSashWindowMotorizeDownInterlocked()){
                    m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                }

                if(m_pSashWindow->isSashStateChanged() && sashChangedValid && !m_eventLoopSashMotorActive){
                    if(pData->getSashWindowMotorizeState()){
                        if(!pData->getSashCycleCountValid()){
                            pData->setSashCycleCountValid(true);
                        }
                        /// Don't turnOff the sash if the previous State is the same
                        if(pData->getSashWindowPrevState() != MachineEnums::SASH_STATE_STANDBY_SSV){
                            /// Turned off mototrize in every defined magnetic switch
                            if(pData->getSashWindowMotorizeState() == MachineEnums::MOTOR_SASH_STATE_DOWN){
                                m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                                m_pSasWindowMotorize->routineTask();
                                if(m_sashMovedDown)m_sashMovedDown = false;
                                qDebug() << "Sash Motor Off in Sash Standby 1";
                                m_eventLoopCounter = 0;
                                m_eventLoopSashMotorActive = true;
                                QTimer::singleShot(200, this, [&](){
                                    QEventLoop waitLoop;
                                    QObject::connect(m_timerEventEvery50MSecond.data(), &QTimer::timeout,
                                                     &waitLoop, [this, &waitLoop] (){
                                                         short sashWindowState = pData->getSashWindowState();
                                                         m_eventLoopCounter++;
                                                         qDebug() << "waitLoop" << sashWindowState << m_eventLoopCounter;
                                                         if ((sashWindowState == MachineEnums::SASH_STATE_STANDBY_SSV) || (m_eventLoopCounter >= 20)){
                                                             m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                                                             m_pSasWindowMotorize->routineTask();
                                                             qDebug() << "Sash Motor Off in Sash Standby WaitLoop";
                                                             if(pData->getFanState() == MachineEnums::FAN_STATE_ON){
                                                                 ///Ensure the Buzzer Alarm Off Once in Standby Mode and fan ON
                                                                 setBuzzerState(MachineEnums::DIG_STATE_ZERO);
                                                                 //Ensure to cancel warmingup
                                                                 if(pData->getWarmingUpActive()) _cancelWarmingUpTime();
                                                                 setFanState(MachineEnums::FAN_STATE_STANDBY);
                                                             }
                                                             m_eventLoopSashMotorActive = false;
                                                             waitLoop.quit();
                                                         }
                                                         else {
                                                             m_eventLoopSashMotorActive = true;
                                                             m_pSashWindow->setSafeSwitcher(SashWindow::SWITCHER_UP);
                                                             m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_UP);
                                                             m_pSasWindowMotorize->routineTask();
                                                             qDebug() << "Sash Motor Up in WaitLoop Standby";
                                                         }
                                                     });
                                    waitLoop.exec();
                                });
                            }else{
                                m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                                m_pSasWindowMotorize->routineTask();
                                if(m_sashMovedDown)m_sashMovedDown = false;
                                qDebug() << "Sash Motor Off in Sash Standby";
                            }//
                        }//
                    }//
                }//
            }//

            //AUTOMATIC IO STATE
            if(m_pSashWindow->isSashStateChanged() && sashChangedValid && !m_eventLoopSashMotorActive){
                bool autoOnBlower = false;
                autoOnBlower |= (modeOperation != MachineEnums::MODE_OPERATION_MAINTENANCE);
                autoOnBlower &= (pData->getFanState() != MachineEnums::FAN_STATE_OFF);
                autoOnBlower &= (pData->getFanState() != MachineEnums::FAN_STATE_STANDBY);

                if(autoOnBlower){
                    qDebug() << "eventTimerForDelaySafeHeightAction stb" << eventTimerForDelaySafeHeightAction;
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
                                             //qDebug() << "Sash Standby Height after delay turned on out put";
                                             ///Ensure the Buzzer Alarm Off Once in Standby Mode and Fan ON
                                             setBuzzerState(MachineEnums::DIG_STATE_ZERO);
                                             // Make sure Fan is not interlocked
                                             if(pData->getFanPrimaryInterlocked()){
                                                 if(pData->getCabinetWidth3Feet()){
                                                     if(pData->getUsePwmOutSignal())
                                                         m_pFanPrimaryPWM->setInterlock(MachineEnums::DIG_STATE_ZERO);
                                                     else
                                                         m_pFanPrimaryAO->setInterlock(MachineEnums::DIG_STATE_ZERO);
                                                 }
                                                 else
                                                     m_pFanPrimary->setInterlock(MachineEnums::DIG_STATE_ZERO);
                                             }
                                             if(pData->getFanInflowInterlocked()){
                                                 if(pData->getDualRbmMode())
                                                     m_pFanInflow->setInterlock(MachineEnums::DIG_STATE_ZERO);
                                                 else{
                                                     if(pData->getUsePwmOutSignal())
                                                         m_pFanInflowPWM->setInterlock(MachineEnums::DIG_STATE_ZERO);
                                                     else
                                                         m_pFanInflowAO->setInterlock(MachineEnums::DIG_STATE_ZERO);
                                                 }
                                             }
                                             if(pData->getWarmingUpActive()){
                                                 _cancelWarmingUpTime();
                                             }
                                             //TURN BLOWER TO STANDBY SPEED
                                             setFanState(MachineEnums::FAN_STATE_STANDBY);
                                             //_setFanPrimaryStateStandby();
                                         });

                        eventTimerForDelaySafeHeightAction->start();
                    }//
                }//
            }//

            //        /// CLEAR FLAG OF SASH STATE FLAG
            //        if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
            //            m_pSashWindow->clearFlagSashStateChanged();
            //        }
            break;
        case MachineEnums::SASH_STATE_WORK_SSV:
            ////MOTORIZE SASH
            if(pData->getSashWindowMotorizeInstalled()){

                if(pData->getSashWindowMotorizeUpInterlocked()){
                    m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                }

                if(pData->getSashWindowMotorizeDownInterlocked()){
                    m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                }

                if(m_pSashWindow->isSashStateChanged() && sashChangedValid/* && !m_eventLoopSashMotorActive*/){
                    if(pData->getSashWindowMotorizeState()){
                        if(pData->getSashCycleCountValid()){
                            /// Count tubular motor cycle
                            int count = pData->getSashCycleMeter();
                            count = count + 5; /// the value deviced by 10
                            pData->setSashCycleMeter(count);
                            pData->setSashCycleCountValid(false);
                            ///qDebug() << metaObject()->className() << __func__ << "setSashCycleMeter: " << pData->getSashCycleMeter();
                            ///save permanently
                            QSettings settings;
                            settings.setValue(SKEY_SASH_CYCLE_METER, count);
                        }
                        /// Don't turnOff the sash if the previous State is the same
                        if(pData->getSashWindowPrevState() != MachineEnums::SASH_STATE_WORK_SSV){
                            /// Turned off mototrize in every defined magnetic switch

                            if(pData->getSashWindowMotorizeState() == MachineEnums::MOTOR_SASH_STATE_DOWN){
                                m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                                m_pSasWindowMotorize->routineTask();
                                if(m_sashMovedDown)m_sashMovedDown = false;
                                qDebug() << "Sash Motor Off in Sash Safe 1";

                                //                                m_eventLoopCounter = 0;
                                //                                m_eventLoopSashMotorActive = true;
                                //                                QTimer::singleShot(200, this, [&](){
                                //                                    QEventLoop waitLoop;
                                //                                    QObject::connect(m_timerEventEvery50MSecond.data(), &QTimer::timeout,
                                //                                                     &waitLoop, [this, &waitLoop] (){
                                //                                        short sashWindowState = pData->getSashWindowState();
                                //                                        m_eventLoopCounter++;
                                //                                        qDebug() << "waitLoop" << sashWindowState << m_eventLoopCounter;
                                //                                        if ((sashWindowState == MachineEnums::SASH_STATE_WORK_SSV) || (m_eventLoopCounter >= 20)){
                                //                                            m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                                //                                            m_pSasWindowMotorize->routineTask();
                                //                                            qDebug() << "Sash Motor Off in Sash Safe WaitLoop";

                                //                                            ///Ensure the Buzzer Alarm Off Once Sahs Safe
                                //                                            setBuzzerState(MachineEnums::DIG_STATE_ZERO);
                                //                                            ////TURN ON LAMP
                                //                                            m_pLight->setState(MachineEnums::DIG_STATE_ONE);
                                //                                            _insertEventLog(EVENT_STR_LIGHT_ON);
                                //                                            ////IF CURRENT MODE MOPERATION IS QUICK START OR
                                //                                            ////IF CURRENT FAN STATE IS STANDBY SPEED; THEN
                                //                                            ////SWITCH BLOWER SPEED TO NOMINAL SPEED
                                //                                            bool autoOnBlower = false;
                                //                                            autoOnBlower |= (pData->getOperationMode() == MachineEnums::MODE_OPERATION_QUICKSTART);
                                //                                            autoOnBlower |= (pData->getFanPrimaryState() == MachineEnums::FAN_STATE_STANDBY || pData->getFanInflowState() == MachineEnums::FAN_STATE_STANDBY);
                                //                                            autoOnBlower &= (pData->getFanState() != MachineEnums::FAN_STATE_ON);

                                //                                            if(autoOnBlower){
                                //                                                //_setFanPrimaryStateNominal();
                                //                                                setFanState(MachineEnums::FAN_STATE_ON);
                                //                                                /// Tell every one if the fan state will be changing
                                //                                                emit pData->fanSwithingStateTriggered(MachineEnums::DIG_STATE_ONE);
                                //                                                ////
                                //                                                _insertEventLog(EVENT_STR_FAN_ON);
                                //                                            }
                                //                                            /// clear vivarium mute state
                                //                                            if(pData->getVivariumMuteState()){
                                //                                                setMuteVivariumState(false);
                                //                                            }

                                //                                            m_eventLoopSashMotorActive = false;
                                //                                            waitLoop.quit();
                                //                                        }
                                //                                        else {
                                //                                            m_eventLoopSashMotorActive = true;
                                //                                            m_pSashWindow->setSafeSwitcher(SashWindow::SWITCHER_UP);
                                //                                            m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_UP);
                                //                                            m_pSasWindowMotorize->routineTask();
                                //                                            qDebug() << "Sash Motor Up in WaitLoop Safe";
                                //                                        }
                                //                                    });

                                //                                    waitLoop.exec();
                                //                                });

                            }else{
                                m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                                m_pSasWindowMotorize->routineTask();
                                if(m_sashMovedDown)m_sashMovedDown = false;
                                qDebug() << "Sash Motor Off in Sash Safe";
                            }
                        }
                    }//
                }//
            }//
            //AUTOMATIC IO STATE
            //IF SASH STATE JUST CHANGED
            if(m_pSashWindow->isSashStateChanged() && sashChangedValid /*&& !m_eventLoopSashMotorActive*/
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

                                     //qDebug() << "Sash Safe Height after delay turned on out put";
                                     ///Ensure the Buzzer Alarm Off Once Sahs Safe
                                     setBuzzerState(MachineEnums::DIG_STATE_ZERO);
                                     ///
                                     ////IF CURRENT MODE MOPERATION IS QUICK START OR
                                     ////IF CURRENT FAN STATE IS STANDBY SPEED; THEN
                                     ////SWITCH BLOWER SPEED TO NOMINAL SPEED
                                     bool autoOnBlower = false;
                                     autoOnBlower |= (modeOperation == MachineEnums::MODE_OPERATION_QUICKSTART);
                                     autoOnBlower |= (pData->getFanPrimaryState() == MachineEnums::FAN_STATE_STANDBY || pData->getFanInflowState() == MachineEnums::FAN_STATE_STANDBY);
                                     autoOnBlower &= (pData->getFanState() != MachineEnums::FAN_STATE_ON);

                                     if(autoOnBlower){
                                         // Make sure Fan is not interlocked
                                         if(pData->getFanPrimaryInterlocked()){
                                             if(pData->getCabinetWidth3Feet()){
                                                 if(pData->getUsePwmOutSignal())
                                                     m_pFanPrimaryPWM->setInterlock(MachineEnums::DIG_STATE_ZERO);
                                                 else
                                                     m_pFanPrimaryAO->setInterlock(MachineEnums::DIG_STATE_ZERO);
                                             }
                                             else
                                                 m_pFanPrimary->setInterlock(MachineEnums::DIG_STATE_ZERO);
                                         }
                                         if(pData->getFanInflowInterlocked()){
                                             if(pData->getDualRbmMode())
                                                 m_pFanInflow->setInterlock(MachineEnums::DIG_STATE_ZERO);
                                             else{
                                                 if(pData->getUsePwmOutSignal())
                                                     m_pFanInflowPWM->setInterlock(MachineEnums::DIG_STATE_ZERO);
                                                 else
                                                     m_pFanInflowAO->setInterlock(MachineEnums::DIG_STATE_ZERO);
                                             }
                                         }
                                         //_setFanPrimaryStateNominal();
                                         setFanState(MachineEnums::FAN_STATE_ON);
                                         /// Tell every one if the fan state will be changing
                                         emit pData->fanSwithingStateTriggered(MachineEnums::DIG_STATE_ONE);
                                         ////
                                         _insertEventLog(EVENT_STR_FAN_ON);
                                     }
                                     else if(!pData->getWarmingUpActive()){
                                         ////TURN ON LAMP
                                         /// ONLY IF BLOWER IS'NT AT WARMING UP CONDITION
                                         /// AND NO EXHAUST ALARM
                                         qDebug() << "Turn on the lamp if no warming up at safe height";
                                         setLightState(MachineEnums::DIG_STATE_ONE);
                                         ///
                                         _insertEventLog(EVENT_STR_LIGHT_ON);
                                     }
                                     ///Ensure the Buzzer Alarm Off Once Sahs Safe
                                     setBuzzerState(MachineEnums::DIG_STATE_ZERO);

                                     /// clear vivarium mute state
                                     if(pData->getVivariumMuteState()){
                                         setMuteVivariumState(false);
                                     }
                                 });
                /////CLEAR INTERLOCK FAN
                if(pData->getFanPrimaryInterlocked()){
                    _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ZERO);
                }
                eventTimerForDelaySafeHeightAction->start();
            }
            //        /// CLEAR FLAG OF SASH STATE FLAG
            //        if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
            //            m_pSashWindow->clearFlagSashStateChanged();
            //        }
            break;
        case MachineEnums::SASH_STATE_FULLY_OPEN_SSV:
            ////MOTORIZE SASH
            if(pData->getSashWindowMotorizeInstalled()){

                if(!pData->getSashWindowMotorizeUpInterlocked()){
                    m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ONE);
                }

                if(pData->getSashWindowMotorizeDownInterlocked()){
                    m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                }

                if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
                    if(pData->getSashWindowMotorizeState()){
                        if(!pData->getSashCycleCountValid()){
                            pData->setSashCycleCountValid(true);
                        }
                        qDebug() << "Sash Motor Off in Sash Fully Open";
                        m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                        m_pSasWindowMotorize->routineTask();
                        if(m_sashMovedDown)m_sashMovedDown = false;
                    }
                }
            }
            //        /// CLEAR FLAG OF SASH STATE FLAG
            //        if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
            //            m_pSashWindow->clearFlagSashStateChanged();
            //        }
            break;
        }//
        break;
    case MachineEnums::MODE_OPERATION_MAINTENANCE:
        ////MOTORIZE SASH
        if(pData->getSashWindowMotorizeInstalled()){

            if(pData->getSashWindowMotorizeUpInterlocked()){
                m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
            }

            if(pData->getSashWindowMotorizeDownInterlocked()){
                m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
            }

            if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
                if(pData->getSashWindowMotorizeState()){
                    qDebug() << "Sash Motor Off in Mode Maintenance";
                    m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                    m_pSasWindowMotorize->routineTask();
                    if(m_sashMovedDown)m_sashMovedDown = false;
                }
            }
        }//
        break;
    }//

    /// CLEAR FLAG OF SASH STATE FLAG
    if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
        m_pSashWindow->clearFlagSashStateChanged();
    }
    //#ifndef QT_DEBUG
    //    qDebug() << "The _onTriggeredEventSashWindowRoutine operation took" << timer.elapsed() << "ms";
    //    qDebug() << "The _onTriggeredEventSashWindowRoutine operation took" << timer.nsecsElapsed() << "ns";
    //#endif
}//

void MachineBackend::_onTriggeredEventClosedLoopControl()
{
    //qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    m_pIfaFanClosedLoopControl->routineTask();
    m_pDfaFanClosedLoopControl->routineTask();

    /// Record the Output Response
    if(pData->getReadClosedLoopResponse()){
        if(pData->getClosedLoopResponseStatus()) pData->setClosedLoopResponseStatus(false);

        ushort dfaVel = static_cast<ushort>(pData->getDownflowVelocity());
        ushort ifaVel = static_cast<ushort>(pData->getInflowVelocity());

        //        if(pData->getMeasurementUnit()){
        //            dfaVel = static_cast<ushort>(__convertFpmToMps(static_cast<double>(dfaVel)/100.0) * 100);
        //            ifaVel = static_cast<ushort>(__convertFpmToMps(static_cast<double>(ifaVel)/100.0) * 100);
        //        }

        pData->setDfaVelClosedLoopResponse(dfaVel, m_counter);
        pData->setIfaVelClosedLoopResponse(ifaVel, m_counter);

        qDebug() << m_counter << dfaVel << ifaVel;

        if(++m_counter >= 60) /// only read 60 samples
        {
            m_counter = 0;
            pData->setReadClosedLoopResponse(false);
            pData->setClosedLoopResponseStatus(true);
        }
    }
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

    if(m_signedUsername != ""){
        _resetLogoutTime();
    }
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
    if(!m_timerEventForLcdToDimm->isActive()){
        if(value > 0)
            m_timerEventForLcdToDimm->start();
    }
    else{
        if(value == 0)
            m_timerEventForLcdToDimm->stop();
    }
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
    //int seconds = value * 60;
    pData->setMuteAlarmCountdown(value);

    QSettings settings;
    settings.setValue(SKEY_MUTE_ALARM_TIME, value);
}

void MachineBackend::setBuzzerState(bool value)
{
    //qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();
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

void MachineBackend::setSignedUser(const QString username, const QString fullname, short userLevel)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << username << fullname << userLevel;

    m_signedUsername = username;
    m_signedFullname = fullname;
    m_signedUserLevel = userLevel;

    if(m_signedUsername != ""){
        _startLogoutTime();
    }else{
        _cancelLogoutTime();
    }
}

void MachineBackend::setUserLastLogin(const QString username, const QString fullname)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << username << fullname << thread();
    if(username == "" || fullname == "") return;

    QDateTime loginDateTime = QDateTime::currentDateTime();
    QString loginDateTimeText = loginDateTime.toString("yyyy-MM-dd hh:mm:ss");

    /// https://thecodeprogram.com/how-to-use-json-data-with-qt-c--
    QJsonArray userLastLoginArr = pData->getUserLastLogin();
    QJsonObject userLastLoginObjNew;

    //    qDebug() << "before:" << userLastLoginArr;

    /// Remember Only 10 user last login
    /// Remove the 10th data
    if(userLastLoginArr.size() >= 10)
        userLastLoginArr.pop_back();

    bool usernameOnList = false;
    short usernameOnListAtIndex = 0;

    for(short i=0; i<userLastLoginArr.count(); i++){
        QJsonObject userLastLoginObj = userLastLoginArr[i].toObject();
        if(userLastLoginObj.value("username").toString() == username){
            usernameOnList = true;
            usernameOnListAtIndex = i;
            //            qDebug() << "User exist at index:" << i;
            break;
        }//
    }//
    if(!usernameOnList){
        userLastLoginObjNew.insert("username", username);
        userLastLoginObjNew.insert("fullname", fullname);
        userLastLoginObjNew.insert("login", loginDateTimeText);
    }//
    else{
        // update the last login date and time
        userLastLoginObjNew = userLastLoginArr.at(usernameOnListAtIndex).toObject();
        userLastLoginObjNew.remove("login");
        userLastLoginObjNew.insert("login", loginDateTimeText);

        // Remove the object at current index and append to front later
        userLastLoginArr.removeAt(usernameOnListAtIndex);
    }//

    //    qDebug() << "add:" << userLastLoginObjNew;

    userLastLoginArr.prepend(userLastLoginObjNew);

    //    qDebug() << "after:" << userLastLoginArr;

    QSettings settings;
    settings.setValue(SKEY_USER_LAST_LOGIN, userLastLoginArr);

    pData->setUserLasLogin(userLastLoginArr);
}

void MachineBackend::deleteUserLastLogin(const QString username)
{
    QJsonArray userLastLoginArr = pData->getUserLastLogin();

    bool usernameOnList = false;
    short usernameOnListAtIndex = 0;

    for(short i=0; i<userLastLoginArr.count(); i++){
        QJsonObject userLastLoginObj = userLastLoginArr[i].toObject();
        if(userLastLoginObj.value("username").toString() == username){
            usernameOnList = true;
            usernameOnListAtIndex = i;
            //            qDebug() << "User exist at index:" << i;
            break;
        }//
    }//
    if(usernameOnList){
        userLastLoginArr.removeAt(usernameOnListAtIndex);
    }//

    QSettings settings;
    settings.setValue(SKEY_USER_LAST_LOGIN, userLastLoginArr);

    pData->setUserLasLogin(userLastLoginArr);
}//

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
    if(m_timerEventForDataLog->isActive())
        m_timerEventForDataLog->stop();
    m_timerEventForDataLog->setInterval(dataLogPeriod * 60 * 1000); /// convert minute to ms
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

void MachineBackend::setResourceMonitorLogEnable(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    pData->setResourceMonitorLogEnable(value);

    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_RESMONLOG_ENABLE, value ? 1 : 0);

    if(value)
        setResourceMonitorLogRunning(true);
    else
        setResourceMonitorLogRunning(false);
}

void MachineBackend::setResourceMonitorLogRunning(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if(value) m_timerEventForResourceMonitorLog->start();
    else m_timerEventForResourceMonitorLog->stop();

    pData->setResourceMonitorLogRunning(value);
}

void MachineBackend::setResourceMonitorLogPeriod(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    if(m_timerEventForResourceMonitorLog->isActive())
        m_timerEventForResourceMonitorLog->stop();
    m_timerEventForResourceMonitorLog->setInterval(value * 60 * 1000); /// convert minute to ms
    if(pData->getResourceMonitorLogEnable()) m_timerEventForResourceMonitorLog->start();

    pData->setResourceMonitorLogPeriod(value);

    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_RESMONLOG_PERIOD, value);
}

void MachineBackend::setResourceMonitorLogCount(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    pData->setResourceMonitorLogCount(value);
    pData->setResourceMonitorLogIsFull(value >= RESMONLOG_MAX_ROW);
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

    modbusRegisterAddress.FanState.rw = value;
    //    modbusRegisterAddress.IfaFanState.rw = value;
    //    modbusRegisterAddress.DfaFanState.rw = value;
    pData->setModbusAllowSetFan(value);
    QSettings settings;
    settings.setValue(SKEY_MODBUS_RW_FAN, value ? 1 : 0);
}

void MachineBackend::setModbusAllowSetLight(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    modbusRegisterAddress.LightState.rw = value;
    pData->setModbusAllowSetLight(value);
    QSettings settings;
    settings.setValue(SKEY_MODBUS_RW_LAMP, value ? 1 : 0);
}

void MachineBackend::setModbusAllowSetLightIntensity(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    modbusRegisterAddress.LightIntensity.rw = value;
    pData->setModbusAllowSetLightIntensity(value);
    QSettings settings;
    settings.setValue(SKEY_MODBUS_RW_LAMP_DIMM, value ? 1 : 0);
}

void MachineBackend::setModbusAllowSetSocket(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    modbusRegisterAddress.SocketState.rw = value;
    pData->setModbusAllowSetSocket(value);
    QSettings settings;
    settings.setValue(SKEY_MODBUS_RW_SOCKET, value ? 1 : 0);
}

void MachineBackend::setModbusAllowSetGas(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    modbusRegisterAddress.GasState.rw = value;
    pData->setModbusAllowSetGas(value);
    QSettings settings;
    settings.setValue(SKEY_MODBUS_RW_GAS, value ? 1 : 0);
}

void MachineBackend::setModbusAllowSetUvLight(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    modbusRegisterAddress.UvState.rw = value;
    pData->setModbusAllowSetUvLight(value);
    QSettings settings;
    settings.setValue(SKEY_MODBUS_RW_UV, value ? 1 : 0);
}

void MachineBackend::setOperationModeSave(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if(pData->getOperationMode() == value) return;

    if(m_operationPrevMode == MachineEnums::MODE_OPERATION_MAINTENANCE){
        //Also check if prev. fan condition is on(while maintenance), set warmingup executed as true
        //and start power outage capture, if not started yet
        if(pData->getFanPrimaryState() == MachineEnums::FAN_STATE_ON){
            if(!pData->getWarmingUpExecuted())
                pData->setWarmingUpExecuted(true);
            QSettings settings;
            bool powerFailCapt = settings.value(SKEY_POWER_OUTAGE).toBool();
            if(powerFailCapt != true){
                _startPowerOutageCapture();
            }
        }
    }

    m_operationPrevMode = value;
    pData->setOperationMode(value);

    if(value != MachineEnums::MODE_OPERATION_MAINTENANCE) {
        QScopedPointer<QSettings> m_settings(new QSettings);
        m_settings->setValue(SKEY_OPERATION_MODE, value);
    }

    ///MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.OperationMode.addr, static_cast<ushort>(value));
}

void MachineBackend::setOperationMaintenanceMode()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if(pData->getOperationMode() != MachineEnums::MODE_OPERATION_MAINTENANCE)
        m_operationPrevMode = pData->getOperationMode();
    pData->setOperationMode(MachineEnums::MODE_OPERATION_MAINTENANCE);

    ///MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.OperationMode.addr, MachineEnums::MODE_OPERATION_MAINTENANCE);
}

void MachineBackend::setOperationPreviousMode()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    pData->setOperationMode(m_operationPrevMode);

    // To force triggered dutycycle changed
    if(m_operationPrevMode != MachineEnums::MODE_OPERATION_MAINTENANCE){
        //_onFanPrimaryActualDucyChanged(pData->getFanPrimaryDutyCycle());

        //Also check if prev. fan condition is on(while maintenance), set warmingup executed as true
        //and start power outage capture, if not started yet
        if(pData->getFanPrimaryState() == MachineEnums::FAN_STATE_ON){
            if(!pData->getWarmingUpExecuted())
                pData->setWarmingUpExecuted(true);
            QSettings settings;
            bool powerFailCapt = settings.value(SKEY_POWER_OUTAGE).toBool();
            if(powerFailCapt != true){
                _startPowerOutageCapture();
            }
        }
    }

    ///MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.OperationMode.addr, static_cast<ushort>(m_operationPrevMode));
}

void MachineBackend::setSecurityAccessModeSave(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << "securiy status check";
    pData->setSecurityAccessMode(value);

    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_SECURITY_ACCESS_MODE,value);
}

void MachineBackend::setDateCertificationReminder(const QString reminder)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    pData->setDateCertificationReminder(reminder);

    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_CALENDER_REMINDER_MODE,reminder);

    qDebug() << "tanggal" << reminder;

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
    /// Update to Closed Loop Control Object
    m_pDfaFanClosedLoopControl->setMeasurementUnit(static_cast<uchar>(value));
    m_pIfaFanClosedLoopControl->setMeasurementUnit(static_cast<uchar>(value));
    /// Update to Airflow Velocity Object
    m_pAirflowInflow->setMeasurementUnit(static_cast<uchar>(value));
    m_pAirflowDownflow->setMeasurementUnit(static_cast<uchar>(value));

    {
        QSettings settings;
        settings.setValue(SKEY_MEASUREMENT_UNIT, value);
    }

    /// force update temperature value and temperature strf
    _onTemperatureActualChanged(pData->getTemperatureCelcius());

    /// Not calibrated yet
    //    qDebug() << __func__ << "getAirflowCalibrationStatus" << pData->getAirflowCalibrationStatus();
    //if(pData->getAirflowCalibrationStatus() == MachineEnums::AF_CALIB_NONE
    //        && pData->getInflowCalibrationStatus() == MachineEnums::AF_CALIB_NONE
    //       && pData->getDownflowCalibrationStatus() == MachineEnums::AF_CALIB_NONE)
    //   return;

    /// convert calibration airflow value to target measurement unit
    int ifaVelPointMinFactory      = pData->getInflowVelocityPointFactory(1);
    int ifaVelPointNomFactory      = pData->getInflowVelocityPointFactory(2);
    int ifaVelPointMinField        = pData->getInflowVelocityPointField(1);
    int ifaVelPointNomField        = pData->getInflowVelocityPointField(2);
    int ifaVelPointLowAlarm        = pData->getInflowLowLimitVelocity();

    int dfaVelPointMinFactory      = pData->getDownflowVelocityPointFactory(1);
    int dfaVelPointNomFactory      = pData->getDownflowVelocityPointFactory(2);
    int dfaVelPointMaxFactory      = pData->getDownflowVelocityPointFactory(3);
    int dfaVelPointMinField        = pData->getDownflowVelocityPointField(1);
    int dfaVelPointNomField        = pData->getDownflowVelocityPointField(2);
    int dfaVelPointMaxField        = pData->getDownflowVelocityPointField(3);
    int dfaVelPointLowAlarm        = pData->getDownflowLowLimitVelocity();
    int dfaVelPointHighAlarm       = pData->getDownflowHighLimitVelocity();

    int ifaTempCalib               = pData->getInflowTempCalib();
    int dfaTempCalib               = pData->getDownflowTempCalib();

    int tempCelsius                = pData->getTemperatureCelcius();
    int tempLowestLimit            = pData->getEnvTempLowestLimit();
    int tempHighestLimit           = pData->getEnvTempHighestLimit();
    //    ///test
    //    velPointMinFactory  = !value ? 7900 : 40;
    //    velPointNomFactory  = !value ? 10500 : 53;
    //    velPointMinField    = !value ? 7900 : 40;
    //    velPointNomField    = !value ? 10500 : 53;
    //    tempCalib           = !value ? 7700 : 25;

    int _ifaVelPointMinFactory;
    int _ifaVelPointNomFactory;
    int _ifaVelPointMinField;
    int _ifaVelPointNomField;
    int _ifaVelPointLowAlarm;

    int _dfaVelPointMinFactory;
    int _dfaVelPointNomFactory;
    int _dfaVelPointMaxFactory;
    int _dfaVelPointMinField;
    int _dfaVelPointNomField;
    int _dfaVelPointMaxField;
    int _dfaVelPointLowAlarm;
    int _dfaVelPointHighAlarm;

    int _ifaTempCalib;
    int _dfaTempCalib;

    int _tempCelsius = tempCelsius;
    int _tempLowestLimit;
    int _tempHighestLimit;
    int _tempFahrenheit = __convertCtoF(tempCelsius);

    if (value) {
        //        qDebug() << "__convertMpsToFpm" ;
        /// Imperial
        if(pData->getClosedLoopResponseStatus()){
            for(uchar i = 0; i < 60; i++){
                pData->setDfaVelClosedLoopResponse(static_cast<ushort>(qCeil((__convertMpsToFpm(pData->getDfaVelClosedLoopResponse(i)) / 100.0) * 100.0)), i);
                pData->setIfaVelClosedLoopResponse(static_cast<ushort>(qCeil((__convertMpsToFpm(pData->getIfaVelClosedLoopResponse(i)) / 100.0) * 100.0)), i);
            }
        }
        _ifaVelPointMinFactory = qCeil((__convertMpsToFpm(ifaVelPointMinFactory) / 100.0) * 100.0);
        _ifaVelPointNomFactory = qCeil((__convertMpsToFpm(ifaVelPointNomFactory) / 100.0) * 100.0);
        _ifaVelPointMinField   = qCeil((__convertMpsToFpm(ifaVelPointMinField) / 100.0) * 100.0);
        _ifaVelPointNomField   = qCeil((__convertMpsToFpm(ifaVelPointNomField) / 100.0) * 100.0);
        _ifaVelPointLowAlarm   = qCeil((__convertMpsToFpm(ifaVelPointLowAlarm) / 100.0) * 100.0);

        _dfaVelPointMinFactory = qCeil((__convertMpsToFpm(dfaVelPointMinFactory) / 100.0) * 100.0);
        _dfaVelPointNomFactory = qCeil((__convertMpsToFpm(dfaVelPointNomFactory) / 100.0) * 100.0);
        _dfaVelPointMaxFactory = qCeil((__convertMpsToFpm(dfaVelPointMaxFactory) / 100.0) * 100.0);
        _dfaVelPointMinField   = qCeil((__convertMpsToFpm(dfaVelPointMinField) / 100.0) * 100.0);
        _dfaVelPointNomField   = qCeil((__convertMpsToFpm(dfaVelPointNomField) / 100.0) * 100.0);
        _dfaVelPointMaxField   = qCeil((__convertMpsToFpm(dfaVelPointMaxField) / 100.0) * 100.0);
        _dfaVelPointLowAlarm   = qCeil((__convertMpsToFpm(dfaVelPointLowAlarm) / 100.0) * 100.0);
        _dfaVelPointHighAlarm  = qCeil((__convertMpsToFpm(dfaVelPointHighAlarm) / 100.0) * 100.0);

        _ifaTempCalib = __convertCtoF(ifaTempCalib);
        _dfaTempCalib = __convertCtoF(dfaTempCalib);

        pData->setTemperature(static_cast<short>(_tempFahrenheit));
        QString valueStr = QString::asprintf("%d°F", _tempFahrenheit);
        pData->setTemperatureValueStrf(valueStr);

        _tempLowestLimit = __convertCtoF(tempLowestLimit);
        _tempHighestLimit = __convertCtoF(tempHighestLimit);

    } else {
        //        qDebug() << "__convertFpmToMps" ;
        /// metric
        if(pData->getClosedLoopResponseStatus()){
            for(uchar i = 0; i < 60; i++){
                pData->setDfaVelClosedLoopResponse(static_cast<ushort>(qRound((__convertFpmToMps(pData->getDfaVelClosedLoopResponse(i)) / 100.0) * 100.0)), i);
                pData->setIfaVelClosedLoopResponse(static_cast<ushort>(qRound((__convertFpmToMps(pData->getIfaVelClosedLoopResponse(i)) / 100.0) * 100.0)), i);
            }
        }
        _ifaVelPointMinFactory = qRound((__convertFpmToMps(ifaVelPointMinFactory) / 100.0) * 100.0);
        _ifaVelPointNomFactory = qRound((__convertFpmToMps(ifaVelPointNomFactory) / 100.0) * 100.0);
        _ifaVelPointMinField   = qRound((__convertFpmToMps(ifaVelPointMinField) / 100.0) * 100.0);
        _ifaVelPointNomField   = qRound((__convertFpmToMps(ifaVelPointNomField) / 100.0) * 100.0);
        _ifaVelPointLowAlarm   = qRound((__convertFpmToMps(ifaVelPointLowAlarm) / 100.0) * 100.0);

        _dfaVelPointMinFactory = qRound((__convertFpmToMps(dfaVelPointMinFactory) / 100.0) * 100.0);
        _dfaVelPointNomFactory = qRound((__convertFpmToMps(dfaVelPointNomFactory) / 100.0) * 100.0);
        _dfaVelPointMaxFactory = qRound((__convertFpmToMps(dfaVelPointMaxFactory) / 100.0) * 100.0);
        _dfaVelPointMinField   = qRound((__convertFpmToMps(dfaVelPointMinField) / 100.0) * 100.0);
        _dfaVelPointNomField   = qRound((__convertFpmToMps(dfaVelPointNomField) / 100.0) * 100.0);
        _dfaVelPointMaxField   = qRound((__convertFpmToMps(dfaVelPointMaxField) / 100.0) * 100.0);
        _dfaVelPointLowAlarm   = qRound((__convertFpmToMps(dfaVelPointLowAlarm) / 100.0) * 100.0);
        _dfaVelPointHighAlarm  = qRound((__convertFpmToMps(dfaVelPointHighAlarm) / 100.0) * 100.0);

        _ifaTempCalib = __convertFtoC(ifaTempCalib);
        _dfaTempCalib = __convertFtoC(dfaTempCalib);

        pData->setTemperature(static_cast<short>(_tempCelsius));
        QString valueStr = QString::asprintf("%d°C", static_cast<short>(_tempCelsius));
        pData->setTemperatureValueStrf(valueStr);

        _tempLowestLimit = __convertFtoC(tempLowestLimit);
        _tempHighestLimit = __convertFtoC(tempHighestLimit);
    }

    /// set to data
    pData->setInflowVelocityPointFactory(1, _ifaVelPointMinFactory);
    pData->setInflowVelocityPointFactory(2, _ifaVelPointNomFactory);
    pData->setInflowVelocityPointField(1, _ifaVelPointMinField);
    pData->setInflowVelocityPointField(2, _ifaVelPointNomField);

    pData->setDownflowVelocityPointFactory(1, _dfaVelPointMinFactory);
    pData->setDownflowVelocityPointFactory(2, _dfaVelPointNomFactory);
    pData->setDownflowVelocityPointFactory(3, _dfaVelPointMaxFactory);
    pData->setDownflowVelocityPointField(1, _dfaVelPointMinField);
    pData->setDownflowVelocityPointField(2, _dfaVelPointNomField);
    pData->setDownflowVelocityPointField(3, _dfaVelPointMaxField);

    setInflowTemperatureCalib(static_cast<short>(_ifaTempCalib), pData->getInflowTempCalibAdc());
    setDownflowTemperatureCalib(static_cast<short>(_dfaTempCalib), pData->getDownflowTempCalibAdc());
    setEnvTempLowestLimit(_tempLowestLimit);
    setEnvTempHighestLimit(_tempHighestLimit);

    pData->setInflowLowLimitVelocity(_ifaVelPointLowAlarm);
    pData->setDownflowLowLimitVelocity(_dfaVelPointLowAlarm);
    pData->setDownflowHighLimitVelocity(_dfaVelPointHighAlarm);

    QSettings settings;
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FACTORY) + "1", _ifaVelPointMinFactory);
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FACTORY) + "2", _ifaVelPointNomFactory);
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FIELD)   + "1", _ifaVelPointMinField);
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FIELD)   + "2", _ifaVelPointNomField);

    settings.setValue(QString(SKEY_DFA_CAL_VEL_FACTORY) + "1", _dfaVelPointMinFactory);
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FACTORY) + "2", _dfaVelPointNomFactory);
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FACTORY) + "3", _dfaVelPointMaxFactory);
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FIELD)   + "1", _dfaVelPointMinField);
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FIELD)   + "2", _dfaVelPointNomField);
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FIELD)   + "3", _dfaVelPointMaxField);

    settings.setValue(SKEY_IFA_CAL_VEL_LOW_LIMIT, _ifaVelPointLowAlarm);
    settings.setValue(SKEY_DFA_CAL_VEL_LOW_LIMIT, _dfaVelPointLowAlarm);
    settings.setValue(SKEY_DFA_CAL_VEL_HIGH_LIMIT, _dfaVelPointHighAlarm);


    /// UPDATE PRESSURE VALAUE BASED ON CURRENT MEASUREMENT UNIT
    if(pData->getSeasInstalled()){
        int pa = pData->getSeasPressureDiffPa();
        _onSeasPressureDiffPaChanged(pa);
    }

    // If not calibrated yet, skip reinit
    if(pData->getAirflowCalibrationStatus() == MachineEnums::AF_CALIB_NONE){
        return;
    }

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

    if(pData->getLcdBrightnessDelayToDimm() > 0)
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

    Q_UNUSED(sysInfoStr)
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

    //qDebug() << sysInfo;
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

//void MachineBackend::_setWifiDisabled(bool value)
//{
//    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

//#ifdef __linux__
//    QProcess process;

//    QString command = value

//    process.start("nmcli", QStringList() << "networking" << );
//    process.waitForFinished();
//    usleep(1000);
//    QString output(process.readAllStandardOutput());
//    qDebug()<<output;
//    serialNumber = output;

//    QString err(process.readAllStandardError());
//    qDebug()<<err;
//#endif
//}

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
        /// Check if the cabinet want to post purging before actually turned off the blower
        if (!isMaintenanceModeActive()) {
            /// IF NO IN PURGING CONDITION
            if(pData->getPostPurgingActive()){
                if(pData->getSashWindowState() == MachineEnums::SASH_STATE_FULLY_CLOSE_SSV){
                    _cancelPostPurgingTime();
                    _setFanPrimaryStateOFF();
                }//
                else{
                    return;
                }//
            }
            /// IF PURGING TIME MORE THAN ZERO
            else if (pData->getPostPurgingTime()
                     && !pData->getWarmingUpActive()){
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
    pData->setFanState(value);
    pData->setFanInflowState(value);
    pData->setFanPrimaryState(value);
}

void MachineBackend::setFanPrimaryState(short value)
{
    switch(value){
    case MachineEnums::FAN_STATE_ON:
        _setFanPrimaryStateNominal();
        break;
    case MachineEnums::FAN_STATE_STANDBY:
        _setFanPrimaryStateStandby();
        break;
    case MachineEnums::FAN_STATE_OFF:
        _setFanPrimaryStateOFF();
        break;
    default:
        _setFanPrimaryStateOFF();
        break;
    }
}

void MachineBackend::setFanPrimaryDutyCycle(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    //    if(value < 0) return;
    //    if(value > 100) return;

    _setFanPrimaryDutyCycle(value);
}

void MachineBackend::setFanInflowState(short value)
{
    switch(value){
    case MachineEnums::FAN_STATE_ON:
        _setFanInflowStateNominal();
        break;
    case MachineEnums::FAN_STATE_STANDBY:
        _setFanInflowStateStandby();
        break;
    case MachineEnums::FAN_STATE_OFF:
        _setFanInflowStateOFF();
        break;
    default:
        _setFanInflowStateOFF();
        break;
    }
}

void MachineBackend::setFanPrimaryMaximumDutyCycleFactory(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_MAX_DCY_FACTORY, value);

    pData->setFanPrimaryMaximumDutyCycleFactory(value);
}

void MachineBackend::setFanPrimaryMaximumRpmFactory(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_MAX_RPM_FACTORY, value);

    pData->setFanPrimaryMaximumRpmFactory(value);
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

void MachineBackend::setFanPrimaryMaximumDutyCycleField(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_MAX_DCY_FIELD, value);

    pData->setFanPrimaryMaximumDutyCycleField(value);
}

void MachineBackend::setFanPrimaryMaximumRpmField(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_MAX_RPM_FIELD, value);

    pData->setFanPrimaryMaximumRpmField(value);
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
    //    if(pData->getUsePwmOutSignal()){
    //        m_pLightIntensityPWM->setState(lightIntensity);
    //    }else{
    m_pLightIntensity->setState(lightIntensity);
    //    }
}//

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
    if(val){
        m_pLightIntensity->setState(pData->getLightIntensity());
    }
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

void MachineBackend::setWarmingUpTimeSave(short seconds)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << seconds;

    pData->setWarmingUpTime(seconds);
    pData->setWarmingUpCountdown(seconds);

    QSettings settings;
    settings.setValue(SKEY_WARMUP_TIME, seconds);
}

void MachineBackend::setPostPurgeTimeSave(short seconds)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << seconds;

    pData->setPostPurgingTime(seconds);
    pData->setPostPurgingCountdown(seconds);

    QSettings settings;
    settings.setValue(SKEY_POSTPURGE_TIME, seconds);
}

void MachineBackend::setExhaustContactState(short exhaustContactState)
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    qDebug() << exhaustContactState;

    m_pExhaustContact->setState(exhaustContactState);
    pData->setExhaustContactState(exhaustContactState);
}

void MachineBackend::setAlarmContactState(short alarmContactState)
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    qDebug() << alarmContactState;

    m_pAlarmContact->setState(alarmContactState);
    pData->setAlarmContactState(alarmContactState);
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

    if(value == MachineEnums::MOTOR_SASH_STATE_UP){
        m_pSashWindow->setSafeSwitcher(SashWindow::SWITCHER_UP);
        m_sashMovedDown = false;
    }
    else if(value == MachineEnums::MOTOR_SASH_STATE_DOWN){
        m_sashMovedDown = true;
        m_pSashWindow->setSafeSwitcher(SashWindow::SWITCHER_DOWN);
        if(pData->getSashWindowState() == MachineEnums::SASH_STATE_STANDBY_SSV){
            if(pData->getFanState() != MachineEnums::FAN_STATE_OFF)
                setFanState(MachineEnums::FAN_STATE_OFF);
        }//
    }else{
        m_sashMovedDown = false;
    }

    int sashCycle = pData->getSashCycleMeter()/10;

    if(sashCycle <= 16000){
        /// Record Previous State of the Sash Window
        pData->setSashWindowPrevState(pData->getSashWindowState());

        m_pSasWindowMotorize->setState(value);
        m_pSasWindowMotorize->routineTask();
        if(!isAlarmNormal(pData->getSashCycleMotorLockedAlarm())){
            pData->setSashCycleMotorLockedAlarm(MachineEnums::ALARM_NORMAL_STATE);
            _insertAlarmLog(ALARM_LOG_CODE::ALC_SASH_MOTOR_OK, ALARM_LOG_TEXT_SASH_MOTOR_OK);
        }
    }//
    else{
        m_pSasWindowMotorize->setInterlockDown(1);
        m_pSasWindowMotorize->setInterlockUp(1);
        if(!isAlarmActive(pData->getSashCycleMotorLockedAlarm())){
            pData->setSashCycleMotorLockedAlarm(MachineEnums::ALARM_ACTIVE_STATE);
            _insertAlarmLog(ALARM_LOG_CODE::ALC_SASH_MOTOR_LOCKED, ALARM_LOG_TEXT_SASH_MOTOR_LOCKED);
        }
    }//
}//

void MachineBackend::setSeasFlapInstalled(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread() ;
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

    pData->setSeasPressureDiffPaOffset(static_cast<short>(value));
    m_pSeas->setOffsetPa(value);
}

void MachineBackend::setAirflowMonitorEnable(bool airflowMonitorEnable)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << airflowMonitorEnable;

    pData->setAirflowMonitorEnable(airflowMonitorEnable);

    QSettings m_settings;
    m_settings.setValue(SKEY_AF_MONITOR_ENABLE, airflowMonitorEnable);

    if(!pData->getWarmingUpTime()){
        /// Set back the warm up timer to 3 minutes
        setWarmingUpTimeSave(3 * 60);
    }//
}//

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

        //        ///clear secondary method in field calibration
        //        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_FIL);
        //        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_TOT_FIL);
        //        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_AVG_FIL);
        //        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_VEL_FIL);

        //        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_TOT_FIL_IMP);
        //        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_AVG_FIL_IMP);
        //        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_VEL_FIL_IMP);

        //        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_DCY_FIL);
        //        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_RPM_FIL);
        break;
    default:
        break;
    }

    /// remove the draf
    //    settings.beginGroup("meaifanomDraft");
    //    settings.remove("drafAirflowGridStr");
    //    settings.endGroup();
    //    settings.beginGroup("meaifanomdimfieldDraft");
    //    settings.remove("drafAirflowGridStr");
    //    settings.endGroup();
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

    //    settings.beginGroup("meaifaminDraft");
    //    settings.remove("drafAirflowGridStr");
    //    settings.endGroup();
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

    //    settings.beginGroup("meaifastbDraft");
    //    settings.remove("drafAirflowGridStr");
    //    settings.endGroup();

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

    //    /// clear DIM Method in field calibration
    //    settings.remove(SKEY_IFA_CAL_GRID_NOM_FIL);
    //    settings.remove(SKEY_IFA_CAL_GRID_NOM_VOL_FIL);
    //    settings.remove(SKEY_IFA_CAL_GRID_NOM_VEL_FIL);
    //    settings.remove(SKEY_IFA_CAL_GRID_NOM_AVG_FIL);
    //    settings.remove(SKEY_IFA_CAL_GRID_NOM_TOT_FIL);

    //    settings.remove(SKEY_IFA_CAL_GRID_NOM_VOL_FIL_IMP);
    //    settings.remove(SKEY_IFA_CAL_GRID_NOM_VEL_FIL_IMP);
    //    settings.remove(SKEY_IFA_CAL_GRID_NOM_AVG_FIL_IMP);
    //    settings.remove(SKEY_IFA_CAL_GRID_NOM_TOT_FIL_IMP);

    //    settings.remove(SKEY_IFA_CAL_GRID_NOM_DCY_FIL);
    //    settings.remove(SKEY_IFA_CAL_GRID_NOM_RPM_FIL);

    //    settings.beginGroup("meaifanomsecDraft");
    //    settings.remove("drafAirflowGridStr");
    //    settings.endGroup();

    //    settings.beginGroup("meaifanomsecfieldDraft");
    //    settings.remove("drafAirflowGridStr");
    //    settings.endGroup();
}

void MachineBackend::setDownflowSensorConstantTemporary(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    m_pAirflowDownflow->setConstant(value);
    // force calling airflow routine task
    m_pAirflowDownflow->routineTask();
}

void MachineBackend::setDownflowSensorConstant(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QSettings settings;
    settings.setValue(SKEY_DFA_SENSOR_CONST, value);

    pData->setDownflowSensorConstant(value);
}

void MachineBackend::setDownflowTemperatureCalib(short value, int adc)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QSettings settings;
    settings.setValue(SKEY_DFA_CAL_TEMP, value);
    settings.setValue(SKEY_DFA_CAL_TEMP_ADC, adc);

    pData->setDownflowTempCalib(value);
    pData->setDownflowTempCalibAdc(static_cast<short>(adc));
}

void MachineBackend::setDownflowAdcPointFactory(int pointZero, int pointMin, int pointNom, int pointMax)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QSettings settings;
    settings.setValue(QString(SKEY_DFA_CAL_ADC_FACTORY) + "0", pointZero);
    settings.setValue(QString(SKEY_DFA_CAL_ADC_FACTORY) + "1", pointMin);
    settings.setValue(QString(SKEY_DFA_CAL_ADC_FACTORY) + "2", pointNom);
    settings.setValue(QString(SKEY_DFA_CAL_ADC_FACTORY) + "3", pointMax);

    pData->setDownflowAdcPointFactory(0, pointZero);
    pData->setDownflowAdcPointFactory(1, pointMin);
    pData->setDownflowAdcPointFactory(2, pointNom);
    pData->setDownflowAdcPointFactory(3, pointMax);
}

void MachineBackend::setDownflowAdcPointFactory(int point, int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QSettings settings;
    settings.setValue(QString(SKEY_DFA_CAL_ADC_FACTORY) + QString::number(point), value);

    pData->setDownflowAdcPointFactory(static_cast<short>(point), value);
}

void MachineBackend::_setFanPrimaryDutyCycle(short dutyCycle)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    /// talk to another thread
    /// append pending task to target object and target thread
    if(pData->getCabinetWidth3Feet()){
        qDebug() << "-> Set fan duty" << dutyCycle << "%";
        if(pData->getUsePwmOutSignal()){
            QMetaObject::invokeMethod(m_pFanPrimaryPWM.data(),[&, dutyCycle]{
                    m_pFanPrimaryPWM->setState(dutyCycle);
                    m_pFanPrimaryPWM->routineTask();
                },
                Qt::QueuedConnection);
        }
        else{
            QMetaObject::invokeMethod(m_pFanPrimaryAO.data(),[&, dutyCycle]{
                    m_pFanPrimaryAO->setState(dutyCycle);
                    m_pFanPrimaryAO->routineTask();
                },
                Qt::QueuedConnection);
        }
    }else{
        QMetaObject::invokeMethod(m_pFanPrimary.data(),[&, dutyCycle]{
                m_pFanPrimary->setDutyCycle(dutyCycle);
            },
            Qt::QueuedConnection);
    }
}

void MachineBackend::_setFanPrimaryInterlocked(bool interlocked)
{
    /// talk to another thread
    /// append pending task to target object and target thread
    if(pData->getCabinetWidth3Feet()){
        if(pData->getUsePwmOutSignal()){
            QMetaObject::invokeMethod(m_pFanPrimaryPWM.data(),[&, interlocked]{
                    m_pFanPrimaryPWM->setInterlock(interlocked);
                },
                Qt::QueuedConnection);
        }
        else{
            QMetaObject::invokeMethod(m_pFanPrimaryAO.data(),[&, interlocked]{
                    m_pFanPrimaryAO->setInterlock(interlocked);
                },
                Qt::QueuedConnection);
        }
    }else{
        QMetaObject::invokeMethod(m_pFanPrimary.data(),[&, interlocked]{
                m_pFanPrimary->setInterlock(interlocked);
            },
            Qt::QueuedConnection);
    }
    pData->setFanPrimaryInterlocked(interlocked);
}

void MachineBackend::_setFanInflowDutyCycle(short dutyCycle)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    /// talk to another thread
    /// append pending task to target object and target thread
    if(!pData->getDualRbmMode())
    {
        qDebug() << "-> Set fan duty" << dutyCycle << "%";
        if(pData->getUsePwmOutSignal()){
            QMetaObject::invokeMethod(m_pFanInflowPWM.data(),[&, dutyCycle]{
                    m_pFanInflowPWM->setState(dutyCycle);
                    m_pFanInflowPWM->routineTask();
                },
                Qt::QueuedConnection);
        }else{
            QMetaObject::invokeMethod(m_pFanInflowAO.data(),[&, dutyCycle]{
                    m_pFanInflowAO->setState(dutyCycle);
                    m_pFanInflowAO->routineTask();
                },
                Qt::QueuedConnection);
        }
    }
    else{
        qDebug() << "Set fan duty" << dutyCycle << "%";
        QMetaObject::invokeMethod(m_pFanInflow.data(),[&, dutyCycle]{
                m_pFanInflow->setDutyCycle(dutyCycle);
            },
            Qt::QueuedConnection);
    }
}

void MachineBackend::_setFanInflowInterlocked(bool interlocked)
{
    /// talk to another thread
    /// append pending task to target object and target thread
    if(pData->getDualRbmMode()){
        if(pData->getUsePwmOutSignal()){
            QMetaObject::invokeMethod(m_pFanInflowPWM.data(),[&, interlocked]{
                    m_pFanInflowPWM->setInterlock(interlocked);
                },
                Qt::QueuedConnection);
        }else{
            QMetaObject::invokeMethod(m_pFanInflowAO.data(),[&, interlocked]{
                    m_pFanInflowAO->setInterlock(interlocked);
                },
                Qt::QueuedConnection);
        }
    }
    else {
        QMetaObject::invokeMethod(m_pFanInflow.data(),[&, interlocked]{
                m_pFanInflow->setInterlock(interlocked);
            },
            Qt::QueuedConnection);
    }
    pData->setFanInflowInterlocked(interlocked);
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

    pData->setInflowAdcPointField(static_cast<short>(point), value);
}

void MachineBackend::setInflowVelocityPointField(int pointZero, int pointMin, int pointNom)
{
    Q_UNUSED(pointZero)
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

    pData->setInflowVelocityPointField(static_cast<short>(point), value);
}

/**
 * @brief MachineBackend::setInflowSensorConstant
 * @param value
 * This only set the sensor inflow constant for temporary
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
    pData->setInflowTempCalibAdc(static_cast<short>(adc));
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

    pData->setInflowAdcPointFactory(static_cast<short>(point), value);
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

    pData->setInflowVelocityPointFactory(static_cast<short>(point), value);
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
                                                int ducy, int rpm, int fullField)
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

        settings.setValue(SKEY_DFA_CAL_GRID_NOM_DCY, ducy);
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_RPM, rpm);

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

        settings.remove(SKEY_DFA_CAL_GRID_NOM_DCY_FIL);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_RPM_FIL);
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

        settings.setValue(SKEY_DFA_CAL_GRID_NOM_DCY_FIL, ducy);
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_RPM_FIL, rpm);
        //        qDebug() << "FIELD_CALIBRATION_DOWNFLOW_BACKEND" << strJson;
        break;
    default:
        break;
    }

    //    settings.beginGroup("meadfanomDraft");
    //    settings.remove("drafAirflowGridStr");
    //    settings.endGroup();
    //    settings.beginGroup("meadfanomfieldDraft");
    //    settings.remove("drafAirflowGridStr");
    //    settings.endGroup();
}

void MachineBackend::saveDownflowMeaMinimumGrid(const QJsonArray grid,
                                                int total,
                                                int velocity,
                                                int velocityLowest,
                                                int velocityHighest,
                                                int deviation,
                                                int deviationp,
                                                int ducy, int rpm)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QJsonDocument doc(grid);
    QByteArray docByteArray = doc.toJson(QJsonDocument::Compact);
    QString strJson = QLatin1String(docByteArray);

    //    qDebug() << strJson;

    QSettings settings;

    settings.setValue(SKEY_DFA_CAL_GRID_MIN, strJson);
    if(pData->getMeasurementUnit())//Imperial
    {
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_IMP, velocity);
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_TOT_IMP, total);
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_LOW_IMP, velocityLowest);
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_HIGH_IMP, velocityHighest);
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_DEV_IMP, deviation);
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_DEVP_IMP, deviationp);
        //convert to metric
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL, __convertFpmToMps(velocity));
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_TOT, __convertFpmToMps(total));
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_LOW, __convertFpmToMps(velocityLowest));
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_HIGH, __convertFpmToMps(velocityHighest));
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_DEV, __convertFpmToMps(deviation));
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_DEVP, (deviationp));
    }else{
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL, velocity);
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_TOT, total);
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_LOW, velocityLowest);
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_HIGH, velocityHighest);
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_DEV, deviation);
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_DEVP, deviationp);
        //convert to imperial
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_IMP, __convertMpsToFpm(velocity));
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_TOT_IMP, __convertMpsToFpm(total));
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_LOW_IMP, __convertMpsToFpm(velocityLowest));
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_HIGH_IMP, __convertMpsToFpm(velocityHighest));
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_DEV_IMP, __convertMpsToFpm(deviation));
        settings.setValue(SKEY_DFA_CAL_GRID_MIN_VEL_DEVP_IMP, (deviationp));
    }

    settings.setValue(SKEY_DFA_CAL_GRID_MIN_DCY, ducy);
    settings.setValue(SKEY_DFA_CAL_GRID_MIN_RPM, rpm);
    //        qDebug() << "FULL_CALIBRATION_DOWNFLOW_BACKEND" << strJson;

    //    settings.beginGroup("meadfaminDraft");
    //    settings.remove("drafAirflowGridStr");
    //    settings.endGroup();
}

void MachineBackend::saveDownflowMeaMaximumGrid(const QJsonArray grid,
                                                int total,
                                                int velocity,
                                                int velocityLowest,
                                                int velocityHighest,
                                                int deviation,
                                                int deviationp,
                                                int ducy, int rpm)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QJsonDocument doc(grid);
    QByteArray docByteArray = doc.toJson(QJsonDocument::Compact);
    QString strJson = QLatin1String(docByteArray);

    //    qDebug() << strJson;

    QSettings settings;

    settings.setValue(SKEY_DFA_CAL_GRID_MAX, strJson);
    if(pData->getMeasurementUnit())//Imperial
    {
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_IMP, velocity);
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_TOT_IMP, total);
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_LOW_IMP, velocityLowest);
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_HIGH_IMP, velocityHighest);
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_DEV_IMP, deviation);
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_DEVP_IMP, deviationp);
        //convert to metric
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL, __convertFpmToMps(velocity));
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_TOT, __convertFpmToMps(total));
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_LOW, __convertFpmToMps(velocityLowest));
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_HIGH, __convertFpmToMps(velocityHighest));
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_DEV, __convertFpmToMps(deviation));
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_DEVP, (deviationp));
    }else{
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL, velocity);
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_TOT, total);
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_LOW, velocityLowest);
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_HIGH, velocityHighest);
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_DEV, deviation);
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_DEVP, deviationp);
        //convert to imperial
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_IMP, __convertMpsToFpm(velocity));
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_TOT_IMP, __convertMpsToFpm(total));
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_LOW_IMP, __convertMpsToFpm(velocityLowest));
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_HIGH_IMP, __convertMpsToFpm(velocityHighest));
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_DEV_IMP, __convertMpsToFpm(deviation));
        settings.setValue(SKEY_DFA_CAL_GRID_MAX_VEL_DEVP_IMP, (deviationp));
    }
    settings.setValue(SKEY_DFA_CAL_GRID_MAX_DCY, ducy);
    settings.setValue(SKEY_DFA_CAL_GRID_MAX_RPM, rpm);
    //        qDebug() << "FULL_CALIBRATION_DOWNFLOW_BACKEND" << strJson;

    //    settings.beginGroup("meadfamaxDraft");
    //    settings.remove("drafAirflowGridStr");
    //    settings.endGroup();
}

void MachineBackend::setDownflowVelocityPointFactory(int /*pointZero*/, int pointMin, int pointNom, int pointMax)
{
    QSettings settings;
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FACTORY) + "1", pointMin);
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FACTORY) + "2", pointNom);
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FACTORY) + "3", pointMax);

    pData->setDownflowVelocityPointFactory(1, pointMin);
    pData->setDownflowVelocityPointFactory(2, pointNom);
    pData->setDownflowVelocityPointFactory(3, pointMax);
}

void MachineBackend::setDownflowVelocityPointFactory(int point, int value)
{
    QSettings settings;
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FACTORY) + QString::number(point), value);

    pData->setDownflowVelocityPointFactory(static_cast<short>(point), value);
}

void MachineBackend::setDownflowAdcPointField(int pointZero, int pointMin, int pointNom, int pointMax)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << pointZero << pointMin << pointNom;

    QSettings settings;
    settings.setValue(QString(SKEY_DFA_CAL_ADC_FIELD) + "0", pointZero);
    settings.setValue(QString(SKEY_DFA_CAL_ADC_FIELD) + "1", pointMin);
    settings.setValue(QString(SKEY_DFA_CAL_ADC_FIELD) + "2", pointNom);
    settings.setValue(QString(SKEY_DFA_CAL_ADC_FIELD) + "3", pointMax);

    pData->setDownflowAdcPointField(0, pointZero);
    pData->setDownflowAdcPointField(1, pointMin);
    pData->setDownflowAdcPointField(2, pointNom);
    pData->setDownflowAdcPointField(3, pointMax);
}

void MachineBackend::setDownflowAdcPointField(int point, int value)
{
    QSettings settings;
    settings.setValue(QString(SKEY_DFA_CAL_ADC_FIELD) + QString::number(point), value);

    pData->setDownflowAdcPointField(static_cast<short>(point), value);
}

void MachineBackend::setDownflowVelocityPointField(int /*pointZero*/, int pointMin, int pointNom, int pointMax)
{
    QSettings settings;
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FIELD) + "1", pointMin);
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FIELD) + "2", pointNom);
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FIELD) + "3", pointMax);

    pData->setDownflowVelocityPointField(1, pointMin);
    pData->setDownflowVelocityPointField(2, pointNom);
    pData->setDownflowVelocityPointField(3, pointMax);
}

void MachineBackend::setDownflowVelocityPointField(int point, int value)
{
    QSettings settings;
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FIELD) + QString::number(point), value);

    pData->setDownflowVelocityPointField(static_cast<short>(point), value);
}

void MachineBackend::setDownflowLowLimitVelocity(short value)
{
    QSettings settings;
    settings.setValue(SKEY_DFA_CAL_VEL_LOW_LIMIT, value);

    pData->setDownflowLowLimitVelocity(value);
}

void MachineBackend::setDownflowHighLimitVelocity(short value)
{
    QSettings settings;
    settings.setValue(SKEY_DFA_CAL_VEL_HIGH_LIMIT, value);

    pData->setDownflowHighLimitVelocity(value);
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
void MachineBackend::initFanConfigurationStatus(short value)
{
    switch (value) {
    case MachineEnums::AF_CALIB_FIELD:
    {
        short fanNomDutyCycle   = pData->getFanPrimaryNominalDutyCycleField();
        int   fanNomRpm         = pData->getFanPrimaryNominalRpmField();
        short fanMinDutyCycle   = pData->getFanPrimaryMinimumDutyCycleField();
        int   fanMinRpm         = pData->getFanPrimaryMinimumRpmField();
        short fanStbDutyCycle   = pData->getFanPrimaryStandbyDutyCycleField(); // Just Follow Stb Factory//fanNomDutyCycle - deltaValue;
        int   fanStbRpm         = pData->getFanPrimaryStandbyRpmField(); /// this not valid, still follow factory or just zero

        pData->setFanPrimaryNominalDutyCycle(fanNomDutyCycle);
        pData->setFanPrimaryNominalRpm(static_cast<short>(fanNomRpm));
        pData->setFanPrimaryMinimumDutyCycle(fanMinDutyCycle);
        pData->setFanPrimaryMinimumRpm(static_cast<short>(fanMinRpm));
        pData->setFanPrimaryStandbyDutyCycle(fanStbDutyCycle);
        pData->setFanPrimaryStandbyRpm(fanStbRpm);
    }
    break;
    case MachineEnums::AF_CALIB_FACTORY:
    default:
    {
        short fanNomDutyCycle   = pData->getFanPrimaryNominalDutyCycleFactory();
        int   fanNomRpm         = pData->getFanPrimaryNominalRpmFactory();
        short fanMinDutyCycle   = pData->getFanPrimaryMinimumDutyCycleFactory();
        int   fanMinRpm         = pData->getFanPrimaryMinimumRpmFactory();
        short fanStbDutyCycle   = pData->getFanPrimaryStandbyDutyCycleFactory();
        int   fanStbRpm         = pData->getFanPrimaryStandbyRpmFactory();

        pData->setFanPrimaryNominalDutyCycle(fanNomDutyCycle);
        pData->setFanPrimaryNominalRpm(static_cast<short>(fanNomRpm));
        pData->setFanPrimaryMinimumDutyCycle(fanMinDutyCycle);
        pData->setFanPrimaryMinimumRpm(static_cast<short>(fanMinRpm));
        pData->setFanPrimaryStandbyDutyCycle(fanStbDutyCycle);
        pData->setFanPrimaryStandbyRpm(fanStbRpm);
    }
    break;
    }
}

void MachineBackend::setAirflowFactoryCalibrationState(int index, bool state)
{
    qDebug() << __func__ << index << state;

    const QString keyStrFact[MachineEnums::CalFactoryState_Total] = {
        "IfaDimNom",
        "IfaDimMin",
        "IfaDimStb",
        "DfaNom",
        "Const"
    };

    QSettings settings;

    pData->setAirflowFactoryCalibrationState(index, state);
    settings.setValue(SKEY_AIRFLOW_FACTORY_CALIB_STATE + keyStrFact[index], state);
}

void MachineBackend::setAirflowFieldCalibrationState(int index, bool value)
{
    qDebug() << __func__ << index << value;

    const QString keyStrField[MachineEnums::CalFieldState_Total] = {
        "IfaDimNom",
        "IfaSecNom",
        "DfaNom",
        "Const",
        "AdcNom"
    };

    QSettings settings;

    pData->setAirflowFieldCalibrationState(index, value);
    settings.setValue(SKEY_AIRFLOW_FIELD_CALIB_STATE + keyStrField[index], value);
}//

void MachineBackend::_initAirflowCalibartionFactory()
{
    /// DOWNFLOW
    short fanDfaMaxDutyCycle   = pData->getFanPrimaryMaximumDutyCycleFactory();
    int   fanDfaMaxRpm         = pData->getFanPrimaryMaximumRpmFactory();
    short fanDfaNomDutyCycle   = pData->getFanPrimaryNominalDutyCycleFactory();
    int   fanDfaNomRpm         = pData->getFanPrimaryNominalRpmFactory();
    short fanDfaMinDutyCycle   = pData->getFanPrimaryMinimumDutyCycleFactory();
    int   fanDfaMinRpm         = pData->getFanPrimaryMinimumRpmFactory();
    short fanDfaStbDutyCycle   = pData->getFanPrimaryStandbyDutyCycleFactory();
    int   fanDfaStbRpm         = pData->getFanPrimaryStandbyRpmFactory();

    pData->setFanPrimaryMaximumDutyCycle(fanDfaMaxDutyCycle);
    pData->setFanPrimaryMaximumRpm(static_cast<short>(fanDfaMaxRpm));
    pData->setFanPrimaryNominalDutyCycle(fanDfaNomDutyCycle);
    pData->setFanPrimaryNominalRpm(static_cast<short>(fanDfaNomRpm));
    pData->setFanPrimaryMinimumDutyCycle(fanDfaMinDutyCycle);
    pData->setFanPrimaryMinimumRpm(static_cast<short>(fanDfaMinRpm));
    pData->setFanPrimaryStandbyDutyCycle(fanDfaStbDutyCycle);
    pData->setFanPrimaryStandbyRpm(fanDfaStbRpm);

    int dfaSensorConstant = pData->getDownflowSensorConstant();
    int dfaAdcPointZero   = pData->getDownflowAdcPointFactory(0);
    int dfaAdcPointMin    = pData->getDownflowAdcPointFactory(1);
    int dfaAdcPointNom    = pData->getDownflowAdcPointFactory(2);
    int dfaAdcPointMax    = pData->getDownflowAdcPointFactory(3);
    int dfaVelPointMin    = pData->getDownflowVelocityPointFactory(1);
    int dfaVelPointNom    = pData->getDownflowVelocityPointFactory(2);
    int dfaVelPointMax    = pData->getDownflowVelocityPointFactory(3);
    int dfaVelLowAlarm    = pData->getDownflowLowLimitVelocity();
    int dfaVelHighAlarm   = pData->getDownflowHighLimitVelocity();
    /// LOW LIMIT VELOCITY ALARM
    pData->setDownflowLowLimitVelocity(dfaVelLowAlarm);
    pData->setDownflowHighLimitVelocity(dfaVelHighAlarm);

    /// INFLOW
    short fanIfaNomDutyCycle   = pData->getFanInflowNominalDutyCycleFactory();
    int   fanIfaNomRpm         = pData->getFanInflowNominalRpmFactory();
    short fanIfaMinDutyCycle   = pData->getFanInflowMinimumDutyCycleFactory();
    int   fanIfaMinRpm         = pData->getFanInflowMinimumRpmFactory();
    short fanIfaStbDutyCycle   = pData->getFanInflowStandbyDutyCycleFactory();
    int   fanIfaStbRpm         = pData->getFanInflowStandbyRpmFactory();

    pData->setFanInflowNominalDutyCycle(fanIfaNomDutyCycle);
    pData->setFanInflowNominalRpm(static_cast<short>(fanIfaNomRpm));
    pData->setFanInflowMinimumDutyCycle(fanIfaMinDutyCycle);
    pData->setFanInflowMinimumRpm(static_cast<short>(fanIfaMinRpm));
    pData->setFanInflowStandbyDutyCycle(fanIfaStbDutyCycle);
    pData->setFanInflowStandbyRpm(fanIfaStbRpm);

    int ifaSensorConstant = pData->getInflowSensorConstant();
    int ifaAdcPointZero   = pData->getInflowAdcPointFactory(0);
    int ifaAdcPointMin    = pData->getInflowAdcPointFactory(1);
    int ifaAdcPointNom    = pData->getInflowAdcPointFactory(2);
    int ifaVelPointMin    = pData->getInflowVelocityPointFactory(1);
    int ifaVelPointNom    = pData->getInflowVelocityPointFactory(2);
    int ifaVelLowAlarm    = pData->getInflowLowLimitVelocity();
    /// LOW LIMIT VELOCITY ALARM
    pData->setInflowLowLimitVelocity(ifaVelLowAlarm);

    /// AIRFLOW DOWNFLOW
    m_pAirflowDownflow->setConstant(dfaSensorConstant);
    m_pAirflowDownflow->setAdcPoint(0, dfaAdcPointZero);
    m_pAirflowDownflow->setAdcPoint(1, dfaAdcPointMin);
    m_pAirflowDownflow->setAdcPoint(2, dfaAdcPointNom);
    m_pAirflowDownflow->setAdcPoint(3, dfaAdcPointMax);
    m_pAirflowDownflow->setVelocityPoint(1, dfaVelPointMin);
    m_pAirflowDownflow->setVelocityPoint(2, dfaVelPointNom);
    m_pAirflowDownflow->setVelocityPoint(3, dfaVelPointMax);
    m_pAirflowDownflow->initScope();

    /// AIRFLOW INFLOW
    m_pAirflowInflow->setConstant(ifaSensorConstant);
    m_pAirflowInflow->setAdcPoint(0, ifaAdcPointZero);
    m_pAirflowInflow->setAdcPoint(1, ifaAdcPointMin);
    m_pAirflowInflow->setAdcPoint(2, ifaAdcPointNom);
    m_pAirflowInflow->setVelocityPoint(1, ifaVelPointMin);
    m_pAirflowInflow->setVelocityPoint(2, ifaVelPointNom);
    m_pAirflowInflow->initScope();
    /// CLOSE LOOP CONTROL
    pData->setFanClosedLoopSetpoint(dfaVelPointNom, Downflow);
    pData->setFanClosedLoopSetpoint(ifaVelPointNom, Inflow);
    m_pDfaFanClosedLoopControl->setSetpoint(static_cast<short>(dfaVelPointNom));
    m_pDfaFanClosedLoopControl->setSetpointDcy(static_cast<short>(fanDfaNomDutyCycle));
    m_pIfaFanClosedLoopControl->setSetpoint(static_cast<short>(ifaVelPointNom));
    m_pIfaFanClosedLoopControl->setSetpointDcy(static_cast<short>(fanIfaNomDutyCycle));
}

void MachineBackend::_initAirflowCalibartionField()
{
    /// DOWNFLOW
    //Get delta value between Factory Nominal Duty cycle and Factory Standby Duty Cycle
    short fanDfaNomDutyCycleFact   = pData->getFanPrimaryNominalDutyCycleFactory();
    short fanDfaStbDutyCycleFact   = pData->getFanPrimaryStandbyDutyCycleFactory();
    int dfaDeltaValueStb = qAbs(fanDfaNomDutyCycleFact - fanDfaStbDutyCycleFact);

    int fanDfaMaxDutyCycle   = pData->getFanPrimaryMaximumDutyCycleField();
    int   fanDfaMaxRpm         = pData->getFanPrimaryMaximumRpmField();
    int fanDfaNomDutyCycle   = pData->getFanPrimaryNominalDutyCycleField();
    int   fanDfaNomRpm         = pData->getFanPrimaryNominalRpmField();
    short fanDfaMinDutyCycle   = pData->getFanPrimaryMinimumDutyCycleField();
    int   fanDfaMinRpm         = pData->getFanPrimaryMinimumRpmField();
    int fanDfaStbDutyCycle   = fanDfaNomDutyCycle - dfaDeltaValueStb;
    int   fanDfaStbRpm         = pData->getFanPrimaryStandbyRpmField(); /// this not valid, still follow factory or just zero

    pData->setFanPrimaryMaximumDutyCycle(static_cast<short>(fanDfaMaxDutyCycle));
    pData->setFanPrimaryMaximumRpm(static_cast<short>(fanDfaMaxRpm));
    pData->setFanPrimaryNominalDutyCycle(static_cast<short>(fanDfaNomDutyCycle));
    pData->setFanPrimaryNominalRpm(static_cast<short>(fanDfaNomRpm));
    pData->setFanPrimaryMinimumDutyCycle(fanDfaMinDutyCycle);
    pData->setFanPrimaryMinimumRpm(static_cast<short>(fanDfaMinRpm));
    pData->setFanPrimaryStandbyDutyCycle(static_cast<short>(fanDfaStbDutyCycle));
    pData->setFanPrimaryStandbyRpm(fanDfaStbRpm);

    int dfaSensorConstant = pData->getDownflowSensorConstant();
    int dfaAdcPointZero   = pData->getDownflowAdcPointField(0);
    int dfaAdcPointMin    = pData->getDownflowAdcPointField(1);
    int dfaAdcPointNom    = pData->getDownflowAdcPointField(2);
    int dfaAdcPointMax    = pData->getDownflowAdcPointField(3);

    int dfaVelPointMin    = pData->getDownflowVelocityPointField(1);
    int dfaVelPointNom    = pData->getDownflowVelocityPointField(2);
    int dfaVelPointMax    = pData->getDownflowVelocityPointField(3);
    int dfaVelLowAlarm    = pData->getDownflowLowLimitVelocity();
    int dfaVelHighAlarm    = pData->getDownflowHighLimitVelocity();

    /// LOW LIMIT VELOCITY ALARM
    pData->setDownflowLowLimitVelocity(dfaVelLowAlarm);
    pData->setDownflowHighLimitVelocity(dfaVelHighAlarm);

    /// INFLOW
    //Get delta value between Factory Nominal Duty cycle and Factory Standby Duty Cycle
    short fanIfaNomDutyCycleFact   = pData->getFanInflowNominalDutyCycleFactory();
    short fanIfaStbDutyCycleFact   = pData->getFanInflowStandbyDutyCycleFactory();
    int ifaDeltaValue = qAbs(fanIfaNomDutyCycleFact - fanIfaStbDutyCycleFact);

    int fanIfaNomDutyCycle      = pData->getFanInflowNominalDutyCycleField();
    int   fanIfaNomRpm          = pData->getFanInflowNominalRpmField();
    short fanIfaMinDutyCycle    = pData->getFanInflowMinimumDutyCycleField();
    int   fanIfaMinRpm          = pData->getFanInflowMinimumRpmField();
    int fanIfaStbDutyCycle      = fanIfaNomDutyCycle - ifaDeltaValue;
    int   fanIfaStbRpm          = pData->getFanInflowStandbyRpmField(); /// this not valid, still follow factory or just zero

    pData->setFanInflowNominalDutyCycle(static_cast<short>(fanIfaNomDutyCycle));
    pData->setFanInflowNominalRpm(static_cast<short>(fanIfaNomRpm));
    pData->setFanInflowMinimumDutyCycle(fanIfaMinDutyCycle);
    pData->setFanInflowMinimumRpm(static_cast<short>(fanIfaMinRpm));
    pData->setFanInflowStandbyDutyCycle(static_cast<short>(fanIfaStbDutyCycle));
    pData->setFanInflowStandbyRpm(fanIfaStbRpm);

    int ifaSensorConstant = pData->getInflowSensorConstant();
    int ifaAdcPointZero   = pData->getInflowAdcPointField(0);
    int ifaAdcPointMin    = pData->getInflowAdcPointField(1);
    int ifaAdcPointNom    = pData->getInflowAdcPointField(2);

    int ifaVelPointMin    = pData->getInflowVelocityPointField(1);
    int ifaVelPointNom    = pData->getInflowVelocityPointField(2);
    int ifaVelLowAlarm    = pData->getInflowLowLimitVelocity();

    /// LOW LIMIT VELOCITY ALARM
    pData->setInflowLowLimitVelocity(ifaVelLowAlarm);

    /// AIRFLOW DOWNFLOW
    m_pAirflowDownflow->setConstant(dfaSensorConstant);
    m_pAirflowDownflow->setAdcPoint(0, dfaAdcPointZero);
    m_pAirflowDownflow->setAdcPoint(1, dfaAdcPointMin);
    m_pAirflowDownflow->setAdcPoint(2, dfaAdcPointNom);
    m_pAirflowDownflow->setAdcPoint(3, dfaAdcPointMax);
    m_pAirflowDownflow->setVelocityPoint(1, dfaVelPointMin);
    m_pAirflowDownflow->setVelocityPoint(2, dfaVelPointNom);
    m_pAirflowDownflow->setVelocityPoint(3, dfaVelPointMax);
    m_pAirflowDownflow->initScope();
    /// AIRFLOW INFLOW
    m_pAirflowInflow->setConstant(ifaSensorConstant);
    m_pAirflowInflow->setAdcPoint(0, ifaAdcPointZero);
    m_pAirflowInflow->setAdcPoint(1, ifaAdcPointMin);
    m_pAirflowInflow->setAdcPoint(2, ifaAdcPointNom);
    m_pAirflowInflow->setVelocityPoint(1, ifaVelPointMin);
    m_pAirflowInflow->setVelocityPoint(2, ifaVelPointNom);
    m_pAirflowInflow->initScope();
    /// CLOSE LOOP CONTROL
    pData->setFanClosedLoopSetpoint(dfaVelPointNom, Downflow);
    pData->setFanClosedLoopSetpoint(ifaVelPointNom, Inflow);
    m_pDfaFanClosedLoopControl->setSetpoint(static_cast<short>(dfaVelPointNom));
    m_pDfaFanClosedLoopControl->setSetpointDcy(static_cast<short>(fanDfaNomDutyCycle));
    m_pIfaFanClosedLoopControl->setSetpoint(static_cast<short>(ifaVelPointNom));
    m_pIfaFanClosedLoopControl->setSetpointDcy(static_cast<short>(fanIfaNomDutyCycle));
}

void MachineBackend::_onFanPrimaryActualDucyChanged(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    pData->setFanPrimaryDutyCycle(value);

    //// translate duty cycle to fan state
    if (value == MachineEnums::DIG_STATE_ZERO) {
        pData->setFanPrimaryState(MachineEnums::FAN_STATE_OFF);
        /// Set the Fan State to OFF if one of the blowers is Off
        pData->setFanState(MachineEnums::FAN_STATE_OFF);
        pData->setWarmingUpExecuted(false); //reset Warming up executed

        _cancelWarmingUpTime();
        _cancelPostPurgingTime();
        _stopFanFilterLifeMeter();
        _cancelPowerOutageCapture();

        if(m_timerEventForClosedLoopControl->isActive())
            m_timerEventForClosedLoopControl->stop();

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
        /// Check Another Fan State
        if(pData->getFanInflowState() == MachineEnums::FAN_STATE_STANDBY)
            pData->setFanState(MachineEnums::FAN_STATE_STANDBY);
        else
            pData->setFanState(MachineEnums::FAN_STATE_DIFFERENT);

        pData->setWarmingUpExecuted(false); //reset Warming up executed

        /// Deactivate ClosedLoopControl when in Standby Mode
        if(m_timerEventForClosedLoopControl->isActive())
            m_timerEventForClosedLoopControl->stop();
    }
    else {
        pData->setFanPrimaryState(MachineEnums::FAN_STATE_ON);
        /// Check Another Fan State
        if(pData->getFanInflowState() == MachineEnums::FAN_STATE_ON)
            pData->setFanState(MachineEnums::FAN_STATE_ON);
        else
            pData->setFanState(MachineEnums::FAN_STATE_DIFFERENT);

        if(!m_timerEventForClosedLoopControl->isActive()){
            _startFanFilterLifeMeter();

            if(!isMaintenanceModeActive()) {
                if(isAirflowHasCalibrated()) {
                    if(!pData->getWarmingUpActive() && !pData->getWarmingUpExecuted())
                    {
                        _startWarmingUpTime();
                        _startPowerOutageCapture();
                    }
                }
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
    _setModbusRegHoldingValue(modbusRegisterAddress.FanState.addr, static_cast<ushort>(pData->getFanState()));
    _setModbusRegHoldingValue(modbusRegisterAddress.DfaFanState.addr, static_cast<ushort>(pData->getFanPrimaryState()));
    _setModbusRegHoldingValue(modbusRegisterAddress.DfaFanDutyCycle.addr, static_cast<ushort>(value));
}

void MachineBackend::_onFanPrimaryActualRpmChanged(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();
    pData->setFanPrimaryRpm(value);

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.DfaFanRpm.addr, static_cast<ushort>(value));
}

void MachineBackend::_onFanInflowActualDucyChanged(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    pData->setFanInflowDutyCycle(value);

    //// translate duty cycle to fan state
    if (value == MachineEnums::DIG_STATE_ZERO) {
        pData->setFanInflowState(MachineEnums::FAN_STATE_OFF);
        /// Set the Fan State to OFF if one of the blowers is Off
        pData->setFanState(MachineEnums::FAN_STATE_OFF);

        pData->setWarmingUpExecuted(false); //reset Warming up executed

        _cancelWarmingUpTime();
        _cancelPostPurgingTime();
        _stopFanFilterLifeMeter();
        _cancelPowerOutageCapture();

        if(m_timerEventForClosedLoopControl->isActive())
            m_timerEventForClosedLoopControl->stop();

        /// PARTICLE COUNTER
        /// do not counting when internal blower is on
        if (pData->getParticleCounterSensorInstalled()) {
            if (pData->getParticleCounterSensorFanState()){
                m_pParticleCounter->setFanStatePaCo(MachineEnums::DIG_STATE_ZERO);
            }
        }
    }
    else if (value == pData->getFanInflowStandbyDutyCycle()) {
        pData->setFanInflowState(MachineEnums::FAN_STATE_STANDBY);
        /// Check Another Fan State
        if(pData->getFanPrimaryState() == MachineEnums::FAN_STATE_STANDBY)
            pData->setFanState(MachineEnums::FAN_STATE_STANDBY);
        else
            pData->setFanState(MachineEnums::FAN_STATE_DIFFERENT);

        pData->setWarmingUpExecuted(false); //reset Warming up executed

        /// Disactivate ClosedLoopControl when in Standby Mode
        if(m_timerEventForClosedLoopControl->isActive())
            m_timerEventForClosedLoopControl->stop();
    }
    else {
        pData->setFanInflowState(MachineEnums::FAN_STATE_ON);
        /// Check Another Fan State
        if(pData->getFanPrimaryState() == MachineEnums::FAN_STATE_ON)
            pData->setFanState(MachineEnums::FAN_STATE_ON);
        else
            pData->setFanState(MachineEnums::FAN_STATE_DIFFERENT);

        if(!m_timerEventForClosedLoopControl->isActive()){
            _startFanFilterLifeMeter();

            if(!isMaintenanceModeActive()) {
                if(isAirflowHasCalibrated()) {
                    if(!pData->getWarmingUpActive() && !pData->getWarmingUpExecuted())
                    {
                        _startWarmingUpTime();
                        _startPowerOutageCapture();
                    }
                }
            }/*else {
                /// Activate event timer for Fan Closed Loop Control After WarmingUp Finished
                /// Only if both fan state in Nominal
                if(isAirflowHasCalibrated() && isFanStateNominal() && pData->getFanClosedLoopControlEnable() && !pData->getReadClosedLoopResponse()){
                    /// Set Initial Actual Fan Duty Cycle before m_timerEventForClosedLoopControl is activated
                    m_pDfaFanClosedLoopControl->setActualFanDutyCycle(pData->getFanPrimaryDutyCycle());
                    m_pIfaFanClosedLoopControl->setActualFanDutyCycle(pData->getFanInflowDutyCycle());
                    m_timerEventForClosedLoopControl->start();
                }
            }*/
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
    _setModbusRegHoldingValue(modbusRegisterAddress.FanState.addr, static_cast<ushort>(pData->getFanState()));
    _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanState.addr, static_cast<ushort>(pData->getFanInflowState()));
    _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanDutyCycle.addr, static_cast<ushort>(value));
}

void MachineBackend::_onFanInflowActualRpmChanged(int value)
{
    pData->setFanInflowRpm(value);

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanRpm.addr, static_cast<ushort>(value));
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
    _setModbusRegHoldingValue(modbusRegisterAddress.SashState.addr, static_cast<ushort>(state));

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
    if(pData->getFrontPanelSwitchInstalled())
        _checkFrontPanelAlarm();
}

void MachineBackend::_onLightStateChanged(short state)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << state << thread();

    pData->setLightState(state);

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.LightState.addr, static_cast<ushort>(state));

    //    /// EVENT LOG
    //    QString event = state ? EVENT_STR_LIGHT_ON : EVENT_STR_LIGHT_OFF;
    //    _insertEventLog(event);

}

void MachineBackend::_onSocketStateChanged(short state)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << state << thread();

    pData->setSocketState(state);

    /// MEDIUM
    _setModbusRegHoldingValue(modbusRegisterAddress.SocketState.addr, static_cast<ushort>(state));

    //    /// EVENT LOG
    //    QString event = state ? EVENT_STR_SOCKET_ON : EVENT_STR_SOCKET_OFF;
    //    _insertEventLog(event);
}

void MachineBackend::_onGasStateChanged(short state)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << state << thread();

    pData->setGasState(state);

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.GasState.addr, static_cast<ushort>(state));

    //    /// EVENT LOG
    //    QString event = state ? EVENT_STR_GAS_ON : EVENT_STR_GAS_OFF;
    //    _insertEventLog(event);
}

void MachineBackend::_onUVStateChanged(short state)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << state << thread();

    pData->setUvState(state);

    /// TRIGGERING UV TIME AND FRIENDS
    if(state) {
        if(pData->getUvTime()){
            _startUVTime();
        }
        _startPowerOutageCapture();
        _startUVLifeMeter();
    }
    else {
        if(pData->getUvTime()){
            _cancelUVTime();
        }
        _stopUVLifeMeter();
        _cancelPowerOutageCapture();
    }

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.UvState.addr, static_cast<ushort>(state));

    //    /// EVENT LOG
    //    QString event = state ? EVENT_STR_UV_ON : EVENT_STR_UV_OFF;
    //    _insertEventLog(event);
}

void MachineBackend::_onTemperatureActualChanged(double value)
{
    qDebug() << metaObject()->className() << __func__ << value;

    pData->setTemperatureCelcius(static_cast<short>(value));
    /// Temperature is effecting the airflow reading
    m_pAirflowInflow->setTemperature(value);
    m_pAirflowDownflow->setTemperature(value);

    QString valueStr;
    if (pData->getMeasurementUnit()) {
        int fahrenheit = __convertCtoF(static_cast<int>(value));
        pData->setTemperature(static_cast<short>(fahrenheit));

        valueStr = QString::asprintf("%d°F", fahrenheit);
        pData->setTemperatureValueStrf(valueStr);

        //        tempBasedOnMeaUnit = static_cast<short>(fahrenheit);
    }
    else {
        pData->setTemperature(static_cast<short>(value));

        valueStr = QString::asprintf("%d°C", static_cast<int>(value));
        pData->setTemperatureValueStrf(valueStr);
        //        tempBasedOnMeaUnit = value;
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
    short lowest = static_cast<short>(pData->getEnvTempLowestLimit());
    short highest = static_cast<short>(pData->getEnvTempHighestLimit());

    if (pData->getTemperature() < lowest){
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
    else if (pData->getTemperature() > highest){
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
    _setModbusRegHoldingValue(modbusRegisterAddress.Temperature.addr, static_cast<ushort>(pData->getTemperature()));

    //    qDebug() << value << pData->getTempAmbientStatus();
}

void MachineBackend::_onInflowVelocityActualChanged(int value)
{
    //    int finalValue = value;
    bool ifaTooLow = value <= pData->getInflowLowLimitVelocity();
    if(ifaTooLow){
        if(!m_alarmInflowLowDelaySet){
            m_alarmInflowLowDelayCountdown = pData->getDelayAlarmAirflowSec();
            m_alarmInflowLowDelaySet = true;
            pData->setInflowValueHeld(true);
        }
    }else{
        if(m_alarmInflowLowDelaySet){
            m_alarmInflowLowDelaySet = false;
            m_alarmInflowLowDelayCountdown = 0;
        }
    }

    if(!pData->getInflowValueHeld()){
        if (pData->getMeasurementUnit()) {
            int valueVel = qRound(value / 100.0);
            QString valueStr = QString::asprintf("%d fpm", valueVel);
            pData->setInflowVelocityStr(valueStr);
            //m_pIfaFanClosedLoopControl->setProcessVariable(static_cast<float>(valueVel));
            //finalValue = valueVel * 100;
        }
        else {
            double valueVel = value / 100.0;
            QString valueStr = QString::asprintf("%.2f m/s", valueVel);
            pData->setInflowVelocityStr(valueStr);
            //m_pIfaFanClosedLoopControl->setProcessVariable(static_cast<float>(valueVel));
        }
        pData->setInflowVelocity(value);
        /// MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.AirflowInflow.addr, static_cast<ushort>(value));
    }

    //    qDebug() << "Inflow" << pData->getInflowVelocityStr();
}
void MachineBackend::_onDownflowVelocityActualChanged(int value)
{
    bool dfaTooLow = value <= pData->getDownflowLowLimitVelocity();
    bool dfaTooHigh = value >= pData->getDownflowHighLimitVelocity();

    if(dfaTooLow || dfaTooHigh){
        if(dfaTooLow){
            if(!m_alarmDownflowLowDelaySet){
                m_alarmDownflowLowDelayCountdown = pData->getDelayAlarmAirflowSec();
                m_alarmDownflowLowDelaySet = true;
                pData->setDownflowValueHeld(true);
            }
        }
        if(dfaTooHigh){
            if(!m_alarmDownflowHighDelaySet){
                m_alarmDownflowHighDelayCountdown = pData->getDelayAlarmAirflowSec();
                m_alarmDownflowHighDelaySet = true;
                pData->setDownflowValueHeld(true);
            }
        }
    }
    else{
        if(m_alarmDownflowLowDelaySet){
            m_alarmDownflowLowDelaySet = false;
            m_alarmDownflowLowDelayCountdown = 0;
        }
        if(m_alarmDownflowHighDelaySet){
            m_alarmDownflowHighDelaySet = false;
            m_alarmDownflowHighDelayCountdown = 0;
        }
    }
    if(!pData->getDownflowValueHeld()){
        if (pData->getMeasurementUnit()) {
            int valueVel = qRound(value / 100.0);
            QString valueStr = QString::asprintf("%d fpm", valueVel);
            pData->setDownflowVelocityStr(valueStr);
            //m_pDfaFanClosedLoopControl->setProcessVariable(static_cast<float>(valueVel));
        }
        else {
            double valueVel = value / 100.0;
            QString valueStr = QString::asprintf("%.2f m/s", valueVel);
            pData->setDownflowVelocityStr(valueStr);
            //m_pDfaFanClosedLoopControl->setProcessVariable(static_cast<float>(valueVel));
        }

        pData->setDownflowVelocity(value);
        /// MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.AirflowDownflow.addr, static_cast<ushort>(value));
    }
    //    qDebug() << "Inflow" << pData->getInflowVelocityStr();
}

void MachineBackend::_onSeasPressureDiffPaChanged(int value)
{
    qDebug() << __FUNCTION__ ;
    qDebug() << value ;

    pData->setSeasPressureDiffPa(value);

    if (pData->getMeasurementUnit()) {
        double iwg = __toFixedDecPoint(__convertPa2inWG(value), 3);
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
    _setModbusRegHoldingValue(modbusRegisterAddress.PressureExhaust.addr, static_cast<ushort>(value));
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

    pData->setParticleCounterSensorFanState(static_cast<short>(state));
}

void MachineBackend::_onTimerEventLcdDimm()
{
    m_boardCtpIO->setOutputPWM(LEDpca9633_CHANNEL_BL,
                               LCD_DIMM_LEVEL,
                               I2CPort::I2C_SEND_MODE_QUEUE);

    pData->setLcdBrightnessLevel(LCD_DIMM_LEVEL);
    pData->setLcdBrightnessLevelDimmed(true);
}

void MachineBackend::_startLogoutTime()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    int seconds = pData->getLogoutTime();
    if(!seconds) return;
    m_logoutTimeCountdown = seconds;

    /// double ensure this slot not connected to this warming up event
    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventLogout);
    /// connect uniqly timer event for warming up count down
    connect(m_timerEventEverySecond.data(), &QTimer::timeout,
            this, &MachineBackend::_onTimerEventLogout,
            Qt::UniqueConnection);
}

void MachineBackend::_resetLogoutTime()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    int seconds = pData->getLogoutTime();
    if(!seconds) return;
    m_logoutTimeCountdown = seconds;

    /// double ensure this slot not connected to this warming up event
    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventLogout);
    /// connect uniqly timer event for warming up count down
    connect(m_timerEventEverySecond.data(), &QTimer::timeout,
            this, &MachineBackend::_onTimerEventLogout,
            Qt::UniqueConnection);
}

void MachineBackend::_cancelLogoutTime()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventLogout);

    int seconds = pData->getLogoutTime();
    m_logoutTimeCountdown = seconds;
}

void MachineBackend::_onTimerEventLogout()
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << m_logoutTimeCountdown << thread();
    if(m_logoutTimeCountdown <= 0){
        disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
                   this, &MachineBackend::_onTimerEventLogout);

        int seconds = pData->getLogoutTime();
        m_logoutTimeCountdown = seconds;

        /// Turned bright LED
        _wakeupLcdBrightnessLevel();

        emit pData->timerEventLogout();
    }
    else {
        m_logoutTimeCountdown--;
    }
}
void MachineBackend::_startWarmingUpTime()
{
    qDebug() << __FUNCTION__ ;

    int seconds = pData->getWarmingUpTime();
    Q_UNUSED(seconds)
#ifndef __arm__
    seconds = 40;
#endif
    pData->setWarmingUpCountdown(seconds);
    pData->setWarmingUpActive(MachineEnums::DIG_STATE_ONE);

    /// double ensure this slot not connected to this warming up event
    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventWarmingUp);
    /// connect uniqly timer event for warming up count down
    connect(m_timerEventEverySecond.data(), &QTimer::timeout,
            this, &MachineBackend::_onTimerEventWarmingUp,
            Qt::UniqueConnection);
    /// IF IN NORMAL MODE, AFTER WARMING UP COMPLETE, TURN ON LAMP AUTOMATICALLY
    bool normalMode = pData->getOperationMode() == MachineEnums::MODE_OPERATION_NORMAL;
    bool quickMode = pData->getOperationMode() == MachineEnums::MODE_OPERATION_QUICKSTART;

    if(normalMode || quickMode) {
        setLightState(MachineEnums::DIG_STATE_ZERO);
    }
}

void MachineBackend::_cancelWarmingUpTime()
{
    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventWarmingUp);

    if(!pData->getWarmingUpActive()) return;

    int seconds = pData->getWarmingUpTime();
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

        int seconds = pData->getWarmingUpTime();
        pData->setWarmingUpCountdown(seconds);
        pData->setWarmingUpActive(MachineEnums::DIG_STATE_ZERO);
        pData->setWarmingUpExecuted(true);

        /// IF IN NORMAL MODE, AFTER WARMING UP COMPLETE, TURN ON LAMP AUTOMATICALLY
        bool normalMode = pData->getOperationMode() == MachineEnums::MODE_OPERATION_NORMAL;
        bool quickMode = pData->getOperationMode() == MachineEnums::MODE_OPERATION_QUICKSTART;

        if(normalMode || quickMode) {
            setLightState(MachineEnums::DIG_STATE_ONE);
        }

        /// Turned bright LED
        _wakeupLcdBrightnessLevel();
        /// Activate event timer for Fan Closed Loop Control After WarmingUp Finished
        /// Only if both fan state in Nominal
        if(isFanStateNominal() && pData->getFanClosedLoopControlEnable() && !pData->getReadClosedLoopResponse()){
            /// Set Initial Actual Fan Duty Cycle before m_timerEventForClosedLoopControl is activated
            m_pDfaFanClosedLoopControl->setActualFanDutyCycle(pData->getFanPrimaryDutyCycle());
            m_pIfaFanClosedLoopControl->setActualFanDutyCycle(pData->getFanInflowDutyCycle());
            m_timerEventForClosedLoopControl->start();
        }

        /// Ensure The Data Log timer is Active Data Log Once WarmingUp Time finished
        if(pData->getDataLogEnable()){
            if(!m_timerEventForDataLog->isActive()){
                m_timerEventForDataLog->start();
            }//
        }//

        /// Turned bright LED
        _wakeupLcdBrightnessLevel();
    }
    else {
        count--;
        pData->setWarmingUpCountdown(count);
        if(pData->getReadClosedLoopResponse() && !m_timerEventForClosedLoopControl->isActive()){
            m_pDfaFanClosedLoopControl->setActualFanDutyCycle(pData->getFanPrimaryDutyCycle());
            m_pIfaFanClosedLoopControl->setActualFanDutyCycle(pData->getFanInflowDutyCycle());
            m_timerEventForClosedLoopControl->start();
        }
    }
}

void MachineBackend::_startPostPurgingTime()
{
    qDebug() << __FUNCTION__ ;

    int seconds = pData->getPostPurgingTime();
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

    int seconds = pData->getPostPurgingTime();
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

        int seconds = pData->getPostPurgingTime();
        pData->setPostPurgingCountdown(seconds);
        pData->setPostPurgingActive(MachineEnums::DIG_STATE_ZERO);

        /// ACTUALLY TURNING OFF THE FAN
        _setFanPrimaryStateOFF();
        _setFanInflowStateOFF();
        //pData->setFanState(MachineEnums::FAN_STATE_OFF);
        //pData->setFanPrimaryState(MachineEnums::FAN_STATE_OFF);
        //pData->setFanInflowState(MachineEnums::FAN_STATE_OFF);
        //setFanState(MachineEnums::FAN_STATE_OFF);
        /// Light up LCD Backlight
        _wakeupLcdBrightnessLevel();
    }
    else {
        count--;
        pData->setPostPurgingCountdown(count);
        if(pData->getSashWindowState() == MachineEnums::SASH_STATE_FULLY_CLOSE_SSV){
            _cancelPostPurgingTime();
            /// ACTUALLY TURNING OFF THE FAN
            _setFanPrimaryStateOFF();
            _setFanInflowStateOFF();
        }
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
        pData->setUvLifePercent(static_cast<short>(minutesPercentLeft));

        //save to sattings
        QSettings settings;
        settings.setValue(SKEY_UV_METER, minutes);

        //        qDebug() << __FUNCTION__  << minutes;
        /// MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.UvLifeLeft.addr, static_cast<ushort>(minutesPercentLeft));
    }
}

void MachineBackend::_startFanFilterLifeMeter()
{
    qDebug() << __FUNCTION__ ;

    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    disconnect(m_timerEventEveryMinute.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventFanFilterUsageMeterCalculate);

    {
        /// reset the buffer value
        m_fanPrimaryRpmActualBuffer->clear();
        //        m_fanPrimaryRpmIndexMovAvg = 0;
    }
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
    qDebug() << metaObject()->className() << __func__  << thread();

    QSettings settings;
    ///FILTER LIFE
    {
        int minutes = pData->getFilterLifeMinutes();
        if(minutes > 0){
            minutes--;
            //            minutes = minutes - 1000;
            int percentLife = __getPercentFrom(minutes, pData->getFilterLifeMaximumBlowerUsageMode());

            /// event if in % value is zero but the minutes more then 0 minutes, then set % to 1
            if (percentLife == 0 && minutes > 0) percentLife = 1;

            //update to global observable variable
            pData->setFilterLifeMinutes(minutes);

            //save to sattings
            settings.setValue(SKEY_FILTER_METER_MIN, minutes);

            if(pData->getFilterLifeCalculationMode() == MachineEnums::FilterLifeCalc_BlowerUsage){
                pData->setFilterLifePercent(static_cast<short>(percentLife));

                ///MODBUS
                _setModbusRegHoldingValue(modbusRegisterAddress.FilterLife.addr, static_cast<ushort>(percentLife));
            }
        }
    }

    /// FAN METER
    {
        int count = pData->getFanPrimaryUsageMeter();
        count = count + 1;
        pData->setFanPrimaryUsageMeter(count);

        settings.setValue(SKEY_FAN_PRI_METER, count);

        //        qDebug() << __func__ << "getFanPrimaryUsageMeter"  << count;
        ///MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.DfaFanUsage.addr, static_cast<ushort>(count));

        count = pData->getFanInflowUsageMeter();
        count = count + 1;
        pData->setFanInflowUsageMeter(count);

        settings.setValue(SKEY_FAN_INF_METER, count);

        //        qDebug() << __func__ << "getFanInflowUsageMeter"  << count;
        ///MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanUsage.addr, static_cast<ushort>(count));
    }
}

void MachineBackend::_startPowerOutageCapture()
{
    qDebug() << __func__;

    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    disconnect(m_timerEventEveryMinute2.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventPowerOutageCaptureTime);
    /// connect uniqly timer event for warming up count down
    connect(m_timerEventEveryMinute2.data(), &QTimer::timeout,
            this, &MachineBackend::_onTimerEventPowerOutageCaptureTime,
            Qt::UniqueConnection);

    QSettings settings;
    settings.setValue(SKEY_POWER_OUTAGE, MachineEnums::DIG_STATE_ONE);
    settings.setValue(SKEY_POWER_OUTAGE_FAN, MachineEnums::DIG_STATE_ZERO);
    settings.setValue(SKEY_POWER_OUTAGE_UV, MachineEnums::DIG_STATE_ZERO);
    //    if(pData->getSocketInstalled())
    //        settings.setValue(SKEY_POWER_OUTAGE_SOCKET, MachineEnums::DIG_STATE_ZERO);

    if(pData->getFanState()){
        settings.setValue(SKEY_POWER_OUTAGE_FAN, pData->getFanState());
    }
    else if(pData->getUvState()){
        settings.setValue(SKEY_POWER_OUTAGE_UV, pData->getUvState());
    }
    //    if(pData->getSocketInstalled() && pData->getSocketState()){
    //        settings.setValue(SKEY_POWER_OUTAGE_SOCKET, pData->getSocketState());
    //    }

    /// TRIGERED ON START
    _onTimerEventPowerOutageCaptureTime();
}

void MachineBackend::_cancelPowerOutageCapture()
{
    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    disconnect(m_timerEventEveryMinute2.data(), &QTimer::timeout,
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

    int seconds = pData->getMuteAlarmTime();
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

    int seconds = pData->getMuteAlarmTime();
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

        int seconds = pData->getMuteAlarmTime();
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
    if (pData->getFanState() != MachineEnums::FAN_STATE_ON){
        /// if timer event for this task still running, do stop it
        if(m_timerEventForDataLog->isActive()){
            m_timerEventForDataLog->stop();
        }
        return;
    }
    //    /// Only record the log when airflow has calibrated
    //    if (!pData->getAirflowCalibrationStatus()){
    //        /// if timer event for this task still running, do stop it
    //        if(m_timerEventForDataLog->isActive()){
    //            m_timerEventForDataLog->stop();
    //        }
    //        return;
    //    }

    QDateTime dateTime = QDateTime::currentDateTime();
    QString dateText = dateTime.toString("yyyy-MM-dd");
    QString timeText = dateTime.toString("hh:mm:ss");

    QString temperature = pData->getTemperatureValueStrf();
    QString dfaVelocity = pData->getDownflowVelocityStr();
    int dfaVelAdc       = pData->getDownflowAdcConpensation();
    int dfaFanDcy       = pData->getFanPrimaryDutyCycle();
    int dfaFanRpm       = pData->getFanPrimaryRpm();
    QString ifaVelocity = pData->getInflowVelocityStr();
    int ifaVelAdc       = pData->getInflowAdcConpensation();
    int ifaFanDcy       = pData->getFanInflowDutyCycle();

    /// execute this function in where thread the m_pDataLog live at
    QMetaObject::invokeMethod(m_pDataLog.data(),
        [&,
         dateText,
         timeText,
         temperature,
         dfaVelocity,
         dfaVelAdc,
         dfaFanDcy,
         dfaFanRpm,
         ifaVelocity,
         ifaVelAdc,
         ifaFanDcy](){
            QVariantMap dataMap;
            dataMap.insert("date",      dateText);
            dataMap.insert("time",      timeText);
            dataMap.insert("temp",      temperature);
            dataMap.insert("dfa",       dfaVelocity);
            dataMap.insert("dfaAdc",    dfaVelAdc);
            dataMap.insert("dfaFanDcy", dfaFanDcy);
            dataMap.insert("dfaFanRPM", dfaFanRpm);
            dataMap.insert("ifa",       ifaVelocity);
            dataMap.insert("ifaAdc",    ifaVelAdc);
            dataMap.insert("ifaFanDcy", ifaFanDcy);
            //qDebug() << dataMap;
            DataLogSql *sql = m_pDataLog->getPSqlInterface();
            bool success = sql->queryInsert(dataMap);

            /// check how many data log has stored now
            int count;
            success = sql->queryCount(&count);
            //        qDebug() << "success: " << success ;
            if(success){
                setDataLogCount(count);
                //            pData->setDataLogCount(count);
                qDebug() << count << "to" << DATALOG_MAX_ROW;
                //            pData->setDataLogIsFull(count >= DATALOG_MAX_ROW);
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
                bool logHasFull = count >= ALARMEVENTLOG_MAX_ROW;
                pData->setAlarmLogIsFull(logHasFull);
                if(count > ALARMEVENTLOG_MAX_ROW)
                    /// delete the last row from table
                    success = sql->queryDeleteOldestRowId();
            }//
        },
        Qt::QueuedConnection);
}

void MachineBackend::_insertEventLog(const QString logText)
{
    //    if(pData->getEventLogIsFull()){
    //        return;
    //    }

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
                                  //qDebug() << dataMap;
                                  EventLogSql *sql = m_pEventLog->getPSqlInterface();
                                  bool success = sql->queryInsert(dataMap);

                                  /// check how many data log has stored now
                                  int count;
                                  success = sql->queryCount(&count);
                                  //        qDebug() << __FUNCTION__ << "success: " << success << count;
                                  if(success){
                                      pData->setEventLogCount(count);
                                      //            qDebug() << count << maximumRowCount;
                                      bool logHasFull = count >= ALARMEVENTLOG_MAX_ROW;
                                      pData->setEventLogIsFull(logHasFull);
                                      if(count > ALARMEVENTLOG_MAX_ROW)
                                          /// delete the last row from table
                                          success = sql->queryDeleteOldestRowId();
                                  }//
                              });
}//

void MachineBackend::_insertResourceMonitorLog()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QDateTime dateTime = QDateTime::currentDateTime();
    QString dateText = dateTime.toString("yyyy-MM-dd");
    QString timeText = dateTime.toString("hh:mm:ss");

    if(pData->getFrontEndScreenState() != MachineEnums::ScreenState_ResourceMonitor)
        _readResourceMonitorParams();

    /// execute this function in where thread the m_pResourceMonitorLog live at
    QMetaObject::invokeMethod(m_pResourceMonitorLog.data(),
        [&,
         dateText,
         timeText](){

            QVariantMap dataMap;
            dataMap.insert("date", dateText);
            dataMap.insert("time", timeText);
            dataMap.insert("cpuUsage", pData->getResourceMonitorParams().at(MachineEnums::ResMon_CPU_Usage));
            dataMap.insert("memUsage", pData->getResourceMonitorParams().at(MachineEnums::ResMon_Memory_Usage));
            dataMap.insert("cpuTemp",  pData->getResourceMonitorParams().at(MachineEnums::ResMon_CPU_Temp));

            ResourceMonitorLogSql *sql = m_pResourceMonitorLog->getPSqlInterface();
            bool success = sql->queryInsert(dataMap);

            /// check how many data log has stored now
            int count;
            success = sql->queryCount(&count);
            //        qDebug() << "success: " << success ;
            if(success){
                pData->setResourceMonitorLogCount(count);
                //            qDebug() << count << maximumRowCount;
                bool logHasFull = count >= RESMONLOG_MAX_ROW;
                pData->setResourceMonitorLogIsFull(logHasFull);
                if(count > RESMONLOG_MAX_ROW)
                    /// delete the last row from table
                    success = sql->queryDeleteOldestRowId();
            }//
        },
        Qt::QueuedConnection);
}

void MachineBackend::_setFanInflowStateNominal()
{
    short dutyCycle = pData->getFanInflowNominalDutyCycle();
    short divide = dutyCycle/4;
    if(divide == pData->getFanInflowStandbyDutyCycle()) divide -= 1;
    qDebug() << "1st time dutycycle set" << divide;
    _setFanInflowDutyCycle(divide);
    /// divide into two time for setting up the Nominal duty cycle
    /// this is for reducing the irush current of the motor blower
    /// Implement this method if the nominal duty cylcle is relative high
    QTimer::singleShot(5000, this, [&, dutyCycle](){
        qDebug() << "2nd time dutycycle set" << dutyCycle;
        _setFanInflowDutyCycle(dutyCycle);
    });
}//

void MachineBackend::_setFanInflowStateMinimum()
{
    short dutyCycle = pData->getFanInflowMinimumDutyCycle();
    _setFanInflowDutyCycle(dutyCycle);
}//

void MachineBackend::_setFanInflowStateStandby()
{
    short dutyCycle = pData->getFanInflowStandbyDutyCycle();
    _setFanInflowDutyCycle(dutyCycle);
}

void MachineBackend::_setFanInflowStateOFF()
{
    short dutyCycle = MachineEnums::DIG_STATE_ZERO;
    _setFanInflowDutyCycle(dutyCycle);
}


void MachineBackend::_setFanPrimaryStateNominal()
{
    short dutyCycle = pData->getFanPrimaryNominalDutyCycle();
    short divide = dutyCycle/4;
    if(divide == pData->getFanPrimaryStandbyDutyCycle()) divide -= 1;
    qDebug() << "1st time dutycycle set" << divide;
    _setFanPrimaryDutyCycle(divide);
    /// divide into two time for setting up the Nominal duty cycle
    /// this is for reducing the irush current of the motor blower
    /// Implement this method if the nominal duty cylcle is relative high
    QTimer::singleShot(5000, this, [&, dutyCycle](){
        qDebug() << "2nd time dutycycle set" << dutyCycle;
        _setFanPrimaryDutyCycle(dutyCycle);
    });
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

double MachineBackend::__convertCfmToLs(double value)
{
    return static_cast<double>(qRound(static_cast<double>(value) * 0.4719));
}

double MachineBackend::__convertLsToCfm(double value)
{
    return static_cast<double>(qRound(static_cast<double>(value) * 2.11888));
}

double MachineBackend::__convertFpmToMps(double value)
{
    if(value <= 0) return value;
    return value / 197.0;
}

double MachineBackend::__convertMpsToFpm(double value)
{
    return value * 197.0;
}

double MachineBackend::__toFixedDecPoint(double value, short point)
{
    double dec = static_cast<double>(qPow(10.0, point));
    //    qDebug() << "dec" << dec;
    return qRound(value * dec) / dec;
}

int MachineBackend::__convertCtoF(int c)
{
    return qRound((static_cast<double>(c) * 9.0/5.0) + 32.0);
}

int MachineBackend::__convertFtoC(int f)
{
    return qRound(static_cast<double>(f - 32) * 5.0/9.0);
}

double MachineBackend::__convertPa2inWG(int pa)
{
    return pa / 249.0;
}

int MachineBackend::__getPercentFrom(int val, int ref)
{
    return qRound((static_cast<double>(val)/ static_cast<double>(ref)) * 100.0);
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

bool MachineBackend::isFanStateDifferent() const
{
    return pData->getFanState() == MachineEnums::FAN_STATE_DIFFERENT;
}

bool MachineBackend::isFanStateNominal() const
{
    return pData->getFanState() == MachineEnums::FAN_STATE_ON;
}

bool MachineBackend::isFanStateStandby() const
{
    return pData->getFanState() == MachineEnums::FAN_STATE_STANDBY;
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

    QString strDate = pData->getDateCertificationReminder();
    QDate acDate = QDate::fromString(strDate,"yyyy-MM-dd");

    if(acDate.isValid()){
        QDate currentDate = QDate::currentDate();
        //     QString dateText = dateTime.toString("dd-MM-yyyy");
        //     QString timeText = dateTime.toString("hh:mm:ss");

        qDebug() << "actual date " << acDate;
        qDebug() << "str date " << strDate;

        //    pData->setCertificationExpired(acDate == currentDate);

        qint64 span = currentDate.daysTo(acDate);

        qDebug() << "span days" << span;

        pData->setCertificationExpiredValid(true);
        pData->setCertificationExpired(span == 0);
        pData->setCertificationExpiredCount(static_cast<int>(span));
    }
    else {
        pData->setCertificationExpiredValid(false);
        pData->setCertificationExpired(false);
        pData->setCertificationExpiredCount(0);
    }
}

void MachineBackend::_checkFrontPanelAlarm()
{
    if(pData->getFrontPanelSwitchInstalled()){
        if(pData->getFrontPanelSwitchState() && (pData->getSashWindowState() != MachineEnums::SASH_STATE_FULLY_CLOSE_SSV)){
            if(!isAlarmActive(pData->getFrontPanelAlarm())){
                pData->setFrontPanelAlarm(MachineEnums::ALARM_ACTIVE_STATE);
                _insertAlarmLog(ALARM_LOG_CODE::ALC_FRONT_PANEL_ALARM, ALARM_LOG_TEXT_FRONT_PANEL_ALARM);
            }
        }else{
            if(!isAlarmNormal(pData->getFrontPanelAlarm())){
                pData->setFrontPanelAlarm(MachineEnums::ALARM_NORMAL_STATE);
                _insertAlarmLog(ALARM_LOG_CODE::ALC_FRONT_PANEL_OK, ALARM_LOG_TEXT_FRONT_PANEL_OK);
            }
        }
    }else{
        if(!isAlarmNA(pData->getFrontPanelAlarm()))
            pData->setFrontPanelAlarm(MachineEnums::ALARM_NA_STATE);
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
    if(m_signedUserLevel > MachineEnums::USER_LEVEL_GUEST && m_signedUserLevel != MachineEnums::USER_LEVEL_ADMIN){
        switch (address) {
        case modbusRegisterAddress.FanState.addr:
            if (modbusRegisterAddress.FanState.rw){
                if(!pData->getFanPrimaryInterlocked() && !pData->getFanInflowInterlocked()){
                    setFanState(static_cast<short>(value));
                    revertData = false;
                }
            }
            break;
        case modbusRegisterAddress.DfaFanState.addr:
            if (modbusRegisterAddress.DfaFanState.rw){
                if(!pData->getFanPrimaryInterlocked())
                {
                    setFanPrimaryState(static_cast<short>(value));
                    revertData = false;
                }
            }
            break;
        case modbusRegisterAddress.IfaFanState.addr:
            if (modbusRegisterAddress.IfaFanState.rw){
                if(!pData->getFanInflowInterlocked())
                {
                    setFanInflowState(static_cast<short>(value));
                    revertData = false;
                }
            }
            break;
        case modbusRegisterAddress.LightState.addr:
            if (modbusRegisterAddress.LightState.rw){
                if(!pData->getLightInterlocked()){
                    setLightState(static_cast<short>(value));
                    revertData = false;
                }
            }
            break;
        case modbusRegisterAddress.LightIntensity.addr:
            if (modbusRegisterAddress.LightIntensity.rw){
                if(!pData->getLightInterlocked()){
                    setLightIntensity(static_cast<short>(value));
                    revertData = false;
                }//
            }
            break;
        case modbusRegisterAddress.SocketState.addr:
            if (modbusRegisterAddress.SocketState.rw){
                if(!pData->getSocketInterlocked()){
                    setSocketState(static_cast<short>(value));
                    revertData = false;
                }//
            }
            break;
        case modbusRegisterAddress.GasState.addr:
            if (modbusRegisterAddress.GasState.rw){
                if(!pData->getGasInterlocked()){
                    setGasState(static_cast<short>(value));
                    revertData = false;
                }//
            }
            break;
        case modbusRegisterAddress.UvState.addr:
            if (modbusRegisterAddress.UvState.rw){
                if(!pData->getUvInterlocked()){
                    setUvState(static_cast<short>(value));
                    revertData = false;
                }//
            }
            break;
        }//
    }//

    if(revertData){
        /// if the register is read-only
        /// revert the value to the actual value from buffer
        uint16_t data = m_modbusDataUnitBufferRegisterHolding->at(address);
        m_pModbusServer->setData(QModbusDataUnit::HoldingRegisters, static_cast<ushort>(address), data);
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

    m_pModbusServer->setData(QModbusDataUnit::HoldingRegisters, static_cast<ushort>(addr), value);
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
    }//
    else if (table == QLatin1String("replaceablecomprecord")){

        QMetaObject::invokeMethod(m_pReplaceableCompRecord.data(), [&](){

            ReplaceableCompRecordSql *sql = m_pReplaceableCompRecord->getPSqlInterface();

            /// check how many data log has stored now
            int count;
            bool success = sql->queryCount(&count);
            //        qDebug() << __FUNCTION__ << "success: " << success << count;
            if(success){
                pData->setReplaceableCompRecordCount(count);
                //            qDebug() << count << maximumRowCount;
                pData->setReplaceableCompRecordIsFull(count >= ALARMREPLACEABLECOMPRECORD_MAX_ROW);
            }//
        });
    }//
    else if (table == QLatin1String("resourcemonitorlog")){

        QMetaObject::invokeMethod(m_pResourceMonitorLog.data(), [&](){

            ResourceMonitorLogSql *sql = m_pResourceMonitorLog->getPSqlInterface();

            /// check how many data log has stored now
            int count;
            bool success = sql->queryCount(&count);
            //        qDebug() << __FUNCTION__ << "success: " << success << count;
            if(success){
                pData->setResourceMonitorLogCount(count);
                //            qDebug() << count << maximumRowCount;
                pData->setResourceMonitorLogIsFull(count >= RESMONLOG_MAX_ROW);
            }//
        });
    }//
}//

void MachineBackend::_onTriggeredEventEverySecond()
{
    //    qDebug() << metaObject()->className() << __func__  << thread();

    _readRTCActualTime();
    /// Start the eventTimerEveryMinute when current time second value is 0
    if(!m_timerEventEveryMinute->isActive()){
        int currentTimeSecond = QTime::currentTime().second();
        qDebug() << currentTimeSecond;
        if(currentTimeSecond == 9){ /// tolerance +9_+10 seconds
            m_timerEventEveryMinute->start();
        }
    }

    /// Cabinet Up Time
    pData->setCabinetUpTime(pData->getCabinetUpTime()+1);

    /// Resource Monitor
    if(pData->getFrontEndScreenState() == MachineEnums::ScreenState_ResourceMonitor)
        _readResourceMonitorParams();

    if(m_scanRbmComPortAvailable){
        short index = 0;
        short max = 2;
        QString portAvailable = "";
        foreach(const QSerialPortInfo &info, QSerialPortInfo::availablePorts()){
            if((info.vendorIdentifier() == BLOWER_USB_SERIAL_VID) &&
                (info.productIdentifier() == BLOWER_USB_SERIAL_PID)){

                portAvailable += info.portName();
                if(index != (max-1)) portAvailable += "#";
                index++;
            }//
            if(index >= max) break;
        }//
#ifdef QT_DEBUG
        portAvailable = BLOWER_USB_SERIAL_PORT0;
        portAvailable += "#";
        portAvailable += BLOWER_USB_SERIAL_PORT1;
#endif
        //qDebug() << portAvailable;
        pData->setRbmComPortAvailable(portAvailable);
    }//

    if(m_alarmInflowLowDelayCountdown){
        m_alarmInflowLowDelayCountdown--;
        //pData->setInflowValueHeld(true);
    }else{
        if(pData->getInflowValueHeld()){
            pData->setInflowValueHeld(false);
            /// Re initiate the Inflow velocity
            m_pAirflowInflow->emitVelocityChanged();
        }
    }
    if(m_alarmDownflowLowDelayCountdown || m_alarmDownflowHighDelayCountdown){
        if(m_alarmDownflowLowDelayCountdown)
            m_alarmDownflowLowDelayCountdown--;
        if(m_alarmDownflowHighDelayCountdown)
            m_alarmDownflowHighDelayCountdown--;
        //pData->setDownflowValueHeld(true);
    }else{
        if(pData->getDownflowValueHeld()){
            pData->setDownflowValueHeld(false);
            /// Re-initiate the downflow velocity
            m_pAirflowDownflow->emitVelocityChanged();
        }
    }


    {

        if(pData->getFanPrimaryState() == MachineEnums::FAN_STATE_ON
            && pData->getFanPrimaryDutyCycle()
            && pData->getFanPrimaryRpm()){
            //            for(short i=0; i<60; i++)
            if(m_fanPrimaryRpmActualBuffer->length() >= SDEF_FILTER_RPM_MOV_AVG){
                m_fanPrimaryRpmMovAvgTotal = m_fanPrimaryRpmMovAvgTotal - m_fanPrimaryRpmActualBuffer->front();
                m_fanPrimaryRpmActualBuffer->pop_front();
            }//

            int rpm = pData->getFanPrimaryRpm();

            m_fanPrimaryRpmActualBuffer->push_back(rpm);
            m_fanPrimaryRpmMovAvgTotal   = m_fanPrimaryRpmMovAvgTotal + rpm;
            m_fanPrimaryRpmMovAvg = m_fanPrimaryRpmMovAvgTotal / m_fanPrimaryRpmActualBuffer->length();

            /// Consider as stable if the fluctuation is less than +- 10
            if(qAbs(m_fanPrimaryRpmActualBuffer->back() - rpm) <= 10){
                if(++m_fanPrimaryRpmMovAvgCountStable >= 60){
                    m_fanPrimaryRpmMovAvgCountStable = 60;
                    /// Save the new stable rpm as a new nominal rpm
                    if(pData->getFilterLifeRpm() != m_fanPrimaryRpmMovAvg){
                        pData->setFilterLifeRpm(m_fanPrimaryRpmMovAvg);
                        QSettings settings;
                        settings.setValue(SKEY_FILTER_METER_RPM, m_fanPrimaryRpmMovAvg);
                    }//
                }//
            }//
            else m_fanPrimaryRpmMovAvgCountStable = 0;

            int percentLife = 100;

            int minRpm  = pData->getFilterLifeMinimumBlowerRpmMode();
            int maxRpm  = pData->getFilterLifeMaximumBlowerRpmMode();


            int value = m_fanPrimaryRpmMovAvg - minRpm;
            value = value > 0 ? value : 0;
            int rangeValue = maxRpm - minRpm;
            rangeValue = rangeValue > 0 ? rangeValue : 0;

            percentLife = __getPercentFrom((rangeValue - value), rangeValue);

            if(pData->getFilterLifeCalculationMode() == MachineEnums::FilterLifeCalc_BlowerRpm){
                pData->setFilterLifePercent(static_cast<short>(percentLife));

                ///MODBUS
                _setModbusRegHoldingValue(modbusRegisterAddress.FilterLife.addr, static_cast<ushort>(percentLife));
            }//

            qDebug() << rpm << m_fanPrimaryRpmMovAvg << percentLife << m_fanPrimaryRpmMovAvgCountStable;
        }//
    }//
}//

void MachineBackend::_onTriggeredEventEvery50MSecond()
{

}//

void MachineBackend::_onTriggeredEventEveryMinute2()
{

}//

void MachineBackend::_onTriggeredEventEveryMinute()
{
    qDebug() << __func__  << thread();

    m_uvSchedulerAutoSet->routineTask();
    m_fanSchedulerAutoSet->routineTask();
    m_uvSchedulerAutoSetOff->routineTask();
    m_fanSchedulerAutoSetOff->routineTask();
}

void MachineBackend::_onTriggeredEventEveryHalfHour()
{
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
    /// Disable Scheduler if the repeat just once
    if(pData->getUVAutoDayRepeat() == 0){
        setUVAutoEnabled(MachineEnums::DIG_STATE_ZERO);
    }
}

void MachineBackend::_onTriggeredUvSchedulerAutoSetOff()
{
    qDebug() << metaObject()->className() <<  __func__  << thread();

    m_pUV->setState(MachineEnums::DIG_STATE_ZERO);

    _insertEventLog(EVENT_STR_UV_OFF_SCH);
    /// Disable Scheduler if the repeat just once
    if(pData->getUVAutoDayRepeatOff() == 0){
        setUVAutoEnabledOff(MachineEnums::DIG_STATE_ZERO);
    }
}

void MachineBackend::_onTriggeredFanSchedulerAutoSet()
{
    qDebug() << metaObject()->className() << __func__  << thread();

    setFanState(MachineEnums::FAN_STATE_ON);
    //    _setFanPrimaryStateNominal();

    _insertEventLog(EVENT_STR_FAN_ON_SCH);
    /// Disable Scheduler if the repeat just once
    if(pData->getFanAutoDayRepeat() == 0){
        setFanAutoEnabled(MachineEnums::DIG_STATE_ZERO);
    }
}

void MachineBackend::_onTriggeredFanSchedulerAutoSetOff()
{
    qDebug() << metaObject()->className() << __func__  << thread();

    setFanState(MachineEnums::FAN_STATE_OFF);
    //    _setFanPrimaryStateNominal();

    _insertEventLog(EVENT_STR_FAN_OFF_SCH);
    /// Disable Scheduler if the repeat just once
    if(pData->getFanAutoDayRepeatOff() == 0){
        setFanAutoEnabledOff(MachineEnums::DIG_STATE_ZERO);
    }
}

void MachineBackend::setUVAutoEnabled(int uvAutoSetEnabled)
{
    qDebug() << __func__  << thread();
    m_uvSchedulerAutoSet->setEnabled(uvAutoSetEnabled);

    pData->setUVAutoEnabled(uvAutoSetEnabled);

    QSettings settings;
    settings.setValue(SKEY_SCHED_UV_ENABLE, uvAutoSetEnabled);
}

void MachineBackend::setUVAutoTime(int uvAutoSetTime)
{
    qDebug() << __func__  << thread();
    m_uvSchedulerAutoSet->setTime(uvAutoSetTime);

    pData->setUVAutoTime(uvAutoSetTime);

    QSettings settings;
    settings.setValue(SKEY_SCHED_UV_TIME, uvAutoSetTime);
}

void MachineBackend::setUVAutoDayRepeat(int uvAutoSetDayRepeat)
{
    qDebug() << __func__  << thread();
    m_uvSchedulerAutoSet->setDayRepeat(uvAutoSetDayRepeat);

    pData->setUVAutoDayRepeat(uvAutoSetDayRepeat);

    QSettings settings;
    settings.setValue(SKEY_SCHED_UV_REPEAT, uvAutoSetDayRepeat);
}

void MachineBackend::setUVAutoWeeklyDay(int uvAutoSetWeeklyDay)
{
    qDebug() << __func__  << thread();
    m_uvSchedulerAutoSet->setWeeklyDay(uvAutoSetWeeklyDay);

    pData->setUVAutoWeeklyDay(uvAutoSetWeeklyDay);

    QSettings settings;
    settings.setValue(SKEY_SCHED_UV_REPEAT_DAY, uvAutoSetWeeklyDay);
}

void MachineBackend::setUVAutoEnabledOff(int uvAutoSetEnabledOff)
{
    qDebug() << __func__  << thread();
    m_uvSchedulerAutoSetOff->setEnabled(uvAutoSetEnabledOff);

    pData->setUVAutoEnabledOff(uvAutoSetEnabledOff);

    QSettings settings;
    settings.setValue(SKEY_SCHED_UV_ENABLE_OFF, uvAutoSetEnabledOff);
}

void MachineBackend::setUVAutoTimeOff(int uvAutoSetTimeOff)
{
    qDebug() << __func__  << thread();
    m_uvSchedulerAutoSetOff->setTime(uvAutoSetTimeOff);

    pData->setUVAutoTimeOff(uvAutoSetTimeOff);

    QSettings settings;
    settings.setValue(SKEY_SCHED_UV_TIME_OFF, uvAutoSetTimeOff);
}

void MachineBackend::setUVAutoDayRepeatOff(int uvAutoSetDayRepeatOff)
{
    qDebug() << __func__  << thread();
    m_uvSchedulerAutoSetOff->setDayRepeat(uvAutoSetDayRepeatOff);

    pData->setUVAutoDayRepeatOff(uvAutoSetDayRepeatOff);

    QSettings settings;
    settings.setValue(SKEY_SCHED_UV_REPEAT_OFF, uvAutoSetDayRepeatOff);
}

void MachineBackend::setUVAutoWeeklyDayOff(int uvAutoSetWeeklyDayOff)
{
    qDebug() << __func__  << thread();
    m_uvSchedulerAutoSetOff->setWeeklyDay(uvAutoSetWeeklyDayOff);

    pData->setUVAutoWeeklyDayOff(uvAutoSetWeeklyDayOff);

    QSettings settings;
    settings.setValue(SKEY_SCHED_UV_REPEAT_DAY_OFF, uvAutoSetWeeklyDayOff);
}

/// FAN ON SCHEDULER
void MachineBackend::setFanAutoEnabled(int fanAutoSetEnabled)
{
    qDebug() << __func__  << thread();
    m_fanSchedulerAutoSet->setEnabled(fanAutoSetEnabled);

    pData->setFanAutoEnabled(fanAutoSetEnabled);

    QSettings settings;
    settings.setValue(SKEY_SCHED_FAN_ENABLE, fanAutoSetEnabled);
}

void MachineBackend::setFanAutoTime(int fanAutoSetTime)
{
    qDebug() << __func__  << thread();
    m_fanSchedulerAutoSet->setTime(fanAutoSetTime);

    pData->setFanAutoTime(fanAutoSetTime);

    QSettings settings;
    settings.setValue(SKEY_SCHED_FAN_TIME, fanAutoSetTime);
}

void MachineBackend::setFanAutoDayRepeat(int fanAutoSetDayRepeat)
{
    qDebug() << __func__  << thread();
    m_fanSchedulerAutoSet->setDayRepeat(fanAutoSetDayRepeat);

    pData->setFanAutoDayRepeat(fanAutoSetDayRepeat);

    QSettings settings;
    settings.setValue(SKEY_SCHED_FAN_REPEAT, fanAutoSetDayRepeat);
}

void MachineBackend::setFanAutoWeeklyDay(int fanAutoSetWeeklyDay)
{
    qDebug() << __func__  << thread();
    m_fanSchedulerAutoSet->setWeeklyDay(fanAutoSetWeeklyDay);

    pData->setFanAutoWeeklyDay(fanAutoSetWeeklyDay);

    QSettings settings;
    settings.setValue(SKEY_SCHED_FAN_REPEAT_DAY, fanAutoSetWeeklyDay);
}
/// FAN OFF SCHEDULER
void MachineBackend::setFanAutoEnabledOff(int fanAutoSetEnabledOff)
{
    qDebug() << __func__  << thread();
    m_fanSchedulerAutoSetOff->setEnabled(fanAutoSetEnabledOff);

    pData->setFanAutoEnabledOff(fanAutoSetEnabledOff);

    QSettings settings;
    settings.setValue(SKEY_SCHED_FAN_ENABLE_OFF, fanAutoSetEnabledOff);
}

void MachineBackend::setFanAutoTimeOff(int fanAutoSetTimeOff)
{
    qDebug() << __func__  << thread();
    m_fanSchedulerAutoSetOff->setTime(fanAutoSetTimeOff);

    pData->setFanAutoTimeOff(fanAutoSetTimeOff);

    QSettings settings;
    settings.setValue(SKEY_SCHED_FAN_TIME_OFF, fanAutoSetTimeOff);
}

void MachineBackend::setFanAutoDayRepeatOff(int fanAutoSetDayRepeatOff)
{
    qDebug() << __func__  << thread();
    m_fanSchedulerAutoSetOff->setDayRepeat(fanAutoSetDayRepeatOff);

    pData->setFanAutoDayRepeatOff(fanAutoSetDayRepeatOff);

    QSettings settings;
    settings.setValue(SKEY_SCHED_FAN_REPEAT_OFF, fanAutoSetDayRepeatOff);
}

void MachineBackend::setFanAutoWeeklyDayOff(int fanAutoSetWeeklyDayOff)
{
    qDebug() << __func__  << thread();
    m_fanSchedulerAutoSetOff->setWeeklyDay(fanAutoSetWeeklyDayOff);

    pData->setFanAutoWeeklyDayOff(fanAutoSetWeeklyDayOff);

    QSettings settings;
    settings.setValue(SKEY_SCHED_FAN_REPEAT_DAY_OFF, fanAutoSetWeeklyDayOff);
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

void MachineBackend::setFanPrimaryUsageMeter(int minutes)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setFanPrimaryUsageMeter(minutes);

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_METER, minutes);

    //        qDebug() << __func__ << "getFanPrimaryUsageMeter"  << count;
    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.DfaFanUsage.addr, static_cast<ushort>(minutes));
}

void MachineBackend::setFanInflowUsageMeter(int minutes)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setFanInflowUsageMeter(minutes);

    QSettings settings;
    settings.setValue(SKEY_FAN_INF_METER, minutes);

    //        qDebug() << __func__ << "getFanInflowUsageMeter"  << count;
    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanUsage.addr, static_cast<ushort>(minutes));
}

void MachineBackend::setUvUsageMeter(int minutes)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    int minutesPercentLeft = __getPercentFrom(minutes, SDEF_UV_MAXIMUM_TIME_LIFE);

    /// event if in % value is zero but the minutes more then 0 minutes, then set % to 1
    if (minutesPercentLeft == 0 && minutes > 0) minutesPercentLeft = 1;

    //update to global observable variable
    pData->setUvLifeMinutes(minutes);
    pData->setUvLifePercent(static_cast<short>(minutesPercentLeft));

    //save to sattings
    QSettings settings;
    settings.setValue(SKEY_UV_METER, minutes);
    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.UvLifeLeft.addr, static_cast<ushort>(minutesPercentLeft));
}

void MachineBackend::setFilterUsageMeter(int percent)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    int maxMinsUsage = pData->getFilterLifeMaximumBlowerUsageMode();
    int maxRpmUsage = pData->getFilterLifeMaximumBlowerRpmMode();
    int minRpmUsage = pData->getFilterLifeMinimumBlowerRpmMode();
    int rangeRpm = maxRpmUsage - minRpmUsage;

    int minutesLeft = qRound((double)maxMinsUsage - (((100.0-(double)percent)/100.0)*(double)maxMinsUsage));
    int currRpmNom = qRound((double)minRpmUsage + (((100.0-(double)percent)/100.0) * (double)rangeRpm));

    /// event if in % value is zero but the minutes more then 0 minutes, then set % to 1
    if (percent == 0 && (minutesLeft > 0 || currRpmNom < maxRpmUsage)) percent = 1;

    //update to global observable variable
    pData->setFilterLifeMinutes(minutesLeft);
    pData->setFilterLifeRpm(currRpmNom);
    pData->setFilterLifePercent(static_cast<short>(percent));

    //save to sattings
    QSettings settings;
    settings.setValue(SKEY_FILTER_METER_MIN, minutesLeft);
    settings.setValue(SKEY_FILTER_METER_RPM, currRpmNom);
    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.FilterLife.addr, static_cast<ushort>(percent));
}

void MachineBackend::setFilterLifeCalculationMode(int value)
{
    QSettings settings;
    settings.setValue(SKEY_FILTER_METER_MODE, value);
    pData->setFilterLifeCalculationMode(value);
}

void MachineBackend::setFilterLifeMinimumBlowerUsageMode(int value)
{
    QSettings settings;
    settings.setValue(SKEY_FILTER_METER_MIN_TIME, value*60);
    pData->setFilterLifeMinimumBlowerUsageMode(value*60);
}

void MachineBackend::setFilterLifeMaximumBlowerUsageMode(int value)
{
    QSettings settings;
    settings.setValue(SKEY_FILTER_METER_MAX_TIME, value*60);
    pData->setFilterLifeMaximumBlowerUsageMode(value*60);
}

void MachineBackend::setFilterLifeMinimumBlowerRpmMode(int value)
{
    QSettings settings;
    settings.setValue(SKEY_FILTER_METER_MIN_RPM, value);
    pData->setFilterLifeMinimumBlowerRpmMode(value);
}

void MachineBackend::setFilterLifeMaximumBlowerRpmMode(int value)
{
    QSettings settings;
    settings.setValue(SKEY_FILTER_METER_MAX_RPM, value);
    pData->setFilterLifeMaximumBlowerRpmMode(value);
}

void MachineBackend::setSashCycleMeter(int sashCycleMeter)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    int prevSashCycle = pData->getSashCycleMeter()/10;
    if(prevSashCycle >= 16000 && sashCycleMeter < 16000){
        m_pSasWindowMotorize->setInterlockDown(0);
        m_pSasWindowMotorize->setInterlockUp(0);
        if(!isAlarmNormal(pData->getSashCycleMotorLockedAlarm())){
            pData->setSashCycleMotorLockedAlarm(MachineEnums::ALARM_NORMAL_STATE);
            _insertAlarmLog(ALARM_LOG_CODE::ALC_SASH_MOTOR_OK, ALARM_LOG_TEXT_SASH_MOTOR_OK);
        }
    }//

    pData->setSashCycleMeter(sashCycleMeter);

    QSettings settings;
    settings.setValue(SKEY_SASH_CYCLE_METER, sashCycleMeter);
    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.SashCycle.addr, static_cast<ushort>(sashCycleMeter));
}

void MachineBackend::setEnvTempHighestLimit(int envTempHighestLimit)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setEnvTempHighestLimit(envTempHighestLimit);

    QSettings settings;
    settings.setValue(SKEY_ENV_TEMP_HIGH_LIMIT, envTempHighestLimit);

    /// force update temperature value and temperature strf
    _onTemperatureActualChanged(pData->getTemperatureCelcius());
}

void MachineBackend::setEnvTempLowestLimit(int envTempLowestLimit)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setEnvTempLowestLimit(envTempLowestLimit);

    QSettings settings;
    settings.setValue(SKEY_ENV_TEMP_LOW_LIMIT, envTempLowestLimit);

    /// force update temperature value and temperature strf
    _onTemperatureActualChanged(pData->getTemperatureCelcius());
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
        m_threadForResourceMonitorLog->quit();
        m_threadForResourceMonitorLog->wait();

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

        /// RESOURCE MONITOR
        {
            m_pResourceMonitorLogSql.reset(new ResourceMonitorLogSql);
            m_pResourceMonitorLogSql->init("m_pResourceMonitorLogSqlqueryDelete");
            m_pResourceMonitorLogSql->queryDelete();
        }

        /// reset boys
        setting.setValue(SKEY_FILTER_METER_MIN, pData->getFilterLifeMaximumBlowerUsageMode());
        setting.setValue(SKEY_FILTER_METER_RPM, pData->getFilterLifeMinimumBlowerRpmMode());
        setting.setValue(SKEY_FAN_PRI_METER, 0);
        setting.setValue(SKEY_FAN_INF_METER, 0);
        setting.setValue(SKEY_SASH_CYCLE_METER, 0);
        setting.setValue(SKEY_UV_METER, SDEF_UV_MAXIMUM_TIME_LIFE);

        /// Disable Software SVN Check for Update
        setting.setValue(SKEY_SBC_SVN_UPDATE_EN, false);

        /// Clear User Login History
        setting.setValue(SKEY_USER_LAST_LOGIN, QJsonArray());
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

void MachineBackend::setFanClosedLoopControlEnable(bool value)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    if(pData->getFanClosedLoopControlEnable() == value)return;

    if(!value) {
        if(m_timerEventForClosedLoopControl->isActive())
            m_timerEventForClosedLoopControl->stop();
        if(isFanStateNominal()){
            setFanState(MachineEnums::FAN_STATE_ON);
            //_setFanPrimaryDutyCycle(dutyCycle);
            //_setFanPrimaryDutyCycle(dutyCycle);
        }
    }else{
        if(isFanStateNominal() && !pData->getWarmingUpActive() && isAirflowHasCalibrated()){
            /// Set Initial Actual Fan Duty Cycle before m_timerEventForClosedLoopControl is activated
            m_pDfaFanClosedLoopControl->setActualFanDutyCycle(pData->getFanPrimaryDutyCycle());
            m_pIfaFanClosedLoopControl->setActualFanDutyCycle(pData->getFanInflowDutyCycle());
            m_timerEventForClosedLoopControl->start();
        }
    }
    pData->setFanClosedLoopControlEnable(value);
    m_pDfaFanClosedLoopControl->setControlEnable(value);
    m_pIfaFanClosedLoopControl->setControlEnable(value);
    QSettings settings;
    settings.setValue(SKEY_FAN_CLOSE_LOOP_ENABLE, value);

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.FanClosedLoopControl.addr, static_cast<ushort>(value));
}

void MachineBackend::setFanClosedLoopControlEnablePrevState(bool value)
{
    pData->setFanFanClosedLoopControlEnablePrevState(value);
    QSettings settings;
    settings.setValue(SKEY_FAN_CLOSE_LOOP_ENABLE_PREV, value);
}

void MachineBackend::setFanClosedLoopSamplingTime(int value)
{
    if(pData->getFanClosedLoopSamplingTime() == value) return;
    bool needToActivate = false;

    pData->setFanClosedLoopSamplingTime(value);

    QSettings settings;
    settings.setValue(SKEY_FAN_CLOSE_LOOP_STIME, value);

    if(m_timerEventForClosedLoopControl->isActive()){
        m_timerEventForClosedLoopControl->stop();
        needToActivate = true;
    }

    m_pDfaFanClosedLoopControl->setSamplingPeriod(static_cast<float>(value));
    m_pIfaFanClosedLoopControl->setSamplingPeriod(static_cast<float>(value));
    /// Adjust timer event for m_timerEventForClosedLoopControl
    m_timerEventForClosedLoopControl->setInterval(std::chrono::milliseconds(static_cast<int>(value)));
    if(needToActivate)
        m_timerEventForClosedLoopControl->start();
}

void MachineBackend::setFanClosedLoopGainProportionalDfa(float value)
{
    pData->setFanClosedLoopGainProportional(value, Downflow);
    m_pDfaFanClosedLoopControl->setGainProportional(value);
    QSettings settings;
    settings.setValue(SKEY_FAN_CLOSE_LOOP_GAIN_P + QString::number(Downflow), value);
}

void MachineBackend::setFanClosedLoopGainIntegralDfa(float value)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setFanClosedLoopGainIntegral(value, Downflow);
    m_pDfaFanClosedLoopControl->setGainIntegral(value);
    QSettings settings;
    settings.setValue(SKEY_FAN_CLOSE_LOOP_GAIN_I + QString::number(Downflow), value);
}

void MachineBackend::setFanClosedLoopGainDerivativeDfa(float value)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setFanClosedLoopGainDerivative(value, Downflow);
    m_pDfaFanClosedLoopControl->setGainDerivative(value);
    QSettings settings;
    settings.setValue(SKEY_FAN_CLOSE_LOOP_GAIN_D + QString::number(Downflow), value);
}

void MachineBackend::setFanClosedLoopGainProportionalIfa(float value)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setFanClosedLoopGainProportional(value, Inflow);
    m_pIfaFanClosedLoopControl->setGainProportional(value);
    QSettings settings;
    settings.setValue(SKEY_FAN_CLOSE_LOOP_GAIN_P + QString::number(Inflow), value);
}

void MachineBackend::setFanClosedLoopGainIntegralIfa(float value)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setFanClosedLoopGainIntegral(value, Inflow);
    m_pIfaFanClosedLoopControl->setGainIntegral(value);
    QSettings settings;
    settings.setValue(SKEY_FAN_CLOSE_LOOP_GAIN_I + QString::number(Inflow), value);
}

void MachineBackend::setFanClosedLoopGainDerivativeIfa(float value)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setFanClosedLoopGainDerivative(value, Inflow);
    m_pIfaFanClosedLoopControl->setGainDerivative(value);
    QSettings settings;
    settings.setValue(SKEY_FAN_CLOSE_LOOP_GAIN_D + QString::number(Inflow), value);
}

void MachineBackend::setReadClosedLoopResponse(bool value)
{
    pData->setReadClosedLoopResponse(value);
}

void MachineBackend::setAlarmPreventMaintStateEnable(ushort pmCode, bool value)
{
    ushort alarmEn = pData->getAlarmPreventMaintStateEnable();
    if(value){
        alarmEn |= pmCode;
    }else{
        alarmEn &= ~pmCode;
    }

    QSettings setting;
    setting.setValue(SKEY_PM_ALARM_EN, alarmEn);
    pData->setAlarmPreventMaintStateEnable(alarmEn);

    /// Update the active alarm
    QDateTime nowDateTime = QDateTime().currentDateTime();
    QDateTime dueDateTimeDaily = QDateTime().fromString(pData->getDailyPreventMaintAckDueDate(), "dd-MM-yyyy hh:mm:ss");
    QDateTime dueDateTimeWeekly = QDateTime().fromString(pData->getWeeklyPreventMaintAckDueDate(), "dd-MM-yyyy hh:mm:ss");
    QDateTime dueDateTimeMonthly = QDateTime().fromString(pData->getMonthlyPreventMaintAckDueDate(), "dd-MM-yyyy hh:mm:ss");
    QDateTime dueDateTimeQuarterly = QDateTime().fromString(pData->getQuarterlyPreventMaintAckDueDate(), "dd-MM-yyyy hh:mm:ss");
    QDateTime dueDateTimeAnnually = QDateTime().fromString(pData->getAnnuallyPreventMaintAckDueDate(), "dd-MM-yyyy hh:mm:ss");
    QDateTime dueDateTimeBiennially = QDateTime().fromString(pData->getBienniallyPreventMaintAckDueDate(), "dd-MM-yyyy hh:mm:ss");
    QDateTime dueDateTimeQuinquennially = QDateTime().fromString(pData->getQuinquenniallyPreventMaintAckDueDate(), "dd-MM-yyyy hh:mm:ss");
    QDateTime dueDateTimeCanopy = QDateTime().fromString(pData->getCanopyPreventMaintAckDueDate(), "dd-MM-yyyy hh:mm:ss");

    ushort alarmPm = 0;
    qint64 dayLeft = 0;
    if(alarmEn & MachineEnums::PM_DAILY_CODE){
        dayLeft = nowDateTime.secsTo(dueDateTimeDaily);
        if(dayLeft <= 82800) alarmPm |= MachineEnums::PM_DAILY_CODE; /// Activate the alarm when time left less than 6 hours
        qDebug() << "secsLeft:" << dayLeft;
    }
    if(alarmEn & MachineEnums::PM_WEEKLY_CODE){
        dayLeft = nowDateTime.daysTo(dueDateTimeWeekly);
        if(dayLeft <= 2) alarmPm |= MachineEnums::PM_WEEKLY_CODE;
        qDebug() << "dayLeft:" << dayLeft;
    }
    if(alarmEn & MachineEnums::PM_MONTHLY_CODE){
        dayLeft = nowDateTime.daysTo(dueDateTimeMonthly);
        if(dayLeft < 7) alarmPm |= MachineEnums::PM_MONTHLY_CODE;
        qDebug() << "dayLeft:" << dayLeft;
    }
    if(alarmEn & MachineEnums::PM_QUARTERLY_CODE){
        dayLeft = nowDateTime.daysTo(dueDateTimeQuarterly);
        if(dayLeft < 14) alarmPm |= MachineEnums::PM_QUARTERLY_CODE;
        qDebug() << "dayLeft:" << dayLeft;
    }
    if(alarmEn & MachineEnums::PM_ANNUALLY_CODE){
        dayLeft = nowDateTime.daysTo(dueDateTimeAnnually);
        if(dayLeft < 30) alarmPm |= MachineEnums::PM_ANNUALLY_CODE;
        qDebug() << "dayLeft:" << dayLeft;
    }
    if(alarmEn & MachineEnums::PM_BIENNIALLY_CODE){
        dayLeft = nowDateTime.daysTo(dueDateTimeBiennially);
        if(dayLeft < 30) alarmPm |= MachineEnums::PM_BIENNIALLY_CODE;
        qDebug() << "dayLeft:" << dayLeft;
    }
    if(alarmEn & MachineEnums::PM_QUINQUENNIALLY_CODE){
        dayLeft = nowDateTime.daysTo(dueDateTimeQuinquennially);
        if(dayLeft < 30) alarmPm |= MachineEnums::PM_QUINQUENNIALLY_CODE;
        qDebug() << "dayLeft:" << dayLeft;
    }
    if(alarmEn & MachineEnums::PM_CANOPY_CODE){
        dayLeft = nowDateTime.daysTo(dueDateTimeCanopy);
        if(dayLeft < 7) alarmPm |= MachineEnums::PM_CANOPY_CODE;
        qDebug() << "dayLeft:" << dayLeft;
    }

    qDebug() << "Alarm PM:" << alarmPm;
    pData->setAlarmPreventMaintState(alarmPm);
}

void MachineBackend::setAlarmPreventMaintStateAck(ushort pmCode, bool value, bool snooze)
{
    qDebug() << metaObject()->className() << __func__  << pmCode << value << snooze << thread();

    QDateTime nowDateTime = QDateTime().currentDateTime();
    QDateTime dueDateTime;
    QString curDateTimeStr = nowDateTime.toString("dd-MM-yyyy hh:mm:ss");
    QString dueDateTimeStr;

    QSettings setting;

    ushort alarmAck = pData->getAlarmPreventMaintStateAck();

    if(value){
        alarmAck |= pmCode;
    }else{
        alarmAck &= ~pmCode;
    }

    switch(pmCode){
    case MachineEnums::PM_DAILY_CODE:
        if(value && !snooze){
            dueDateTime = QDateTime().fromString(curDateTimeStr, "dd-MM-yyyy hh:mm:ss").addDays(1);
            dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
            pData->setDailyPreventMaintAckDueDate(dueDateTimeStr);
            setting.setValue(SKEY_PM_LAST_ACK_DAILY, curDateTimeStr);
            pData->setDailyPreventMaintLastAckDate(curDateTimeStr);
        }
        break;
    case MachineEnums::PM_WEEKLY_CODE:
        if(value && !snooze){
            dueDateTime = QDateTime().fromString(curDateTimeStr, "dd-MM-yyyy hh:mm:ss").addDays(7);
            dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
            pData->setWeeklyPreventMaintAckDueDate(dueDateTimeStr);
            setting.setValue(SKEY_PM_LAST_ACK_WEEKLY, curDateTimeStr);
            pData->setWeeklyPreventMaintLastAckDate(curDateTimeStr);
        }
        break;
    case MachineEnums::PM_MONTHLY_CODE:
        if(value && !snooze){
            dueDateTime = QDateTime().fromString(curDateTimeStr, "dd-MM-yyyy hh:mm:ss").addMonths(1);
            dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
            pData->setMonthlyPreventMaintAckDueDate(dueDateTimeStr);
            setting.setValue(SKEY_PM_LAST_ACK_MONTHLY, curDateTimeStr);
            pData->setMonthlyPreventMaintLastAckDate(curDateTimeStr);
        }
        break;
    case MachineEnums::PM_QUARTERLY_CODE:
        if(value && !snooze){
            dueDateTime = QDateTime().fromString(curDateTimeStr, "dd-MM-yyyy hh:mm:ss").addMonths(3);
            dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
            pData->setQuarterlyPreventMaintAckDueDate(dueDateTimeStr);
            setting.setValue(SKEY_PM_LAST_ACK_QUARTERLY, curDateTimeStr);
            pData->setQuarterlyPreventMaintLastAckDate(curDateTimeStr);
        }
        break;
    case MachineEnums::PM_ANNUALLY_CODE:
        if(value && !snooze){
            dueDateTime = QDateTime().fromString(curDateTimeStr, "dd-MM-yyyy hh:mm:ss").addYears(1);
            dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
            pData->setAnnuallyPreventMaintAckDueDate(dueDateTimeStr);
            setting.setValue(SKEY_PM_LAST_ACK_ANNUALLY, curDateTimeStr);
            pData->setAnnuallyPreventMaintLastAckDate(curDateTimeStr);
        }
        break;
    case MachineEnums::PM_BIENNIALLY_CODE:
        if(value && !snooze){
            dueDateTime = QDateTime().fromString(curDateTimeStr, "dd-MM-yyyy hh:mm:ss").addYears(2);
            dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
            pData->setBienniallyPreventMaintAckDueDate(dueDateTimeStr);
            setting.setValue(SKEY_PM_LAST_ACK_BIENNIALLY, curDateTimeStr);
            pData->setBienniallyPreventMaintLastAckDate(curDateTimeStr);
        }
        break;
    case MachineEnums::PM_QUINQUENNIALLY_CODE:
        if(value && !snooze){
            dueDateTime = QDateTime().fromString(curDateTimeStr, "dd-MM-yyyy hh:mm:ss").addYears(5);
            dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
            pData->setQuinquenniallyPreventMaintAckDueDate(dueDateTimeStr);
            setting.setValue(SKEY_PM_LAST_ACK_QUINQUENNIALLY, curDateTimeStr);
            pData->setQuinquenniallyPreventMaintLastAckDate(curDateTimeStr);
        }
        break;
    case MachineEnums::PM_CANOPY_CODE:
        if(value && !snooze){
            dueDateTime = QDateTime().fromString(curDateTimeStr, "dd-MM-yyyy hh:mm:ss").addMonths(1);
            dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
            pData->setCanopyPreventMaintAckDueDate(dueDateTimeStr);
            setting.setValue(SKEY_PM_LAST_ACK_CANOPY, curDateTimeStr);
            pData->setCanopyPreventMaintLastAckDate(curDateTimeStr);
        }
        break;
    default: break;
    }

    pData->setAlarmPreventMaintStateAck(alarmAck);
}

void MachineBackend::setEth0ConName(const QString value)
{
    qDebug() << metaObject()->className() << __func__ << value << thread();

    QSettings settings;
    settings.setValue(SKEY_ETH_CON_NAME + QString("0"), value);
    pData->setEth0ConName(value);
}

void MachineBackend::setEth0Ipv4Address(const QString value)
{
    qDebug() << metaObject()->className() << __func__ << value << thread() ;

    QSettings settings;
    settings.setValue(SKEY_ETH_CON_IPv4 + QString("0"), value);
    pData->setEth0Ipv4Address(value);
}

void MachineBackend::setEth0ConEnabled(bool value)
{
    qDebug() << metaObject()->className() << __func__ << value << thread() ;

    QSettings settings;
    settings.setValue(SKEY_ETH_CON_ENABLE + QString("0"), value);
    pData->setEth0ConEnabled(value);
#ifdef __linux__
    if(!value){
        QProcess qprocess;
        QString command = QString("nmcli connection delete id %1").arg(pData->getEth0ConName());
        qWarning() << command;
        qprocess.start(command);
        qprocess.waitForFinished();
        if (qprocess.exitCode()) {
            qWarning() << "Failed while trying to delete connection" << pData->getEth0ConName();
        }

    }
#endif
}

void MachineBackend::setWiredNetworkHasbeenConfigured(bool value)
{
    pData->setWiredNetworkHasbeenConfigured(value);
}

void MachineBackend::initWiredConnectionStaticIP()
{
    qDebug() << metaObject()->className() << __func__ << thread() ;

    QScopedPointer<QSettings> m_settings(new QSettings);
    /// Init Wired Connection Static IP Address

    QString eth0ConName = m_settings->value(SKEY_ETH_CON_NAME + QString("0"), "ESCO_BSC").toString();
    QString eth0Ipv4Address = m_settings->value(SKEY_ETH_CON_IPv4 + QString("0"), "192.168.2.10").toString();
    bool eth0ConEnabled = m_settings->value(SKEY_ETH_CON_ENABLE + QString("0"), true).toBool();
    //    QString gateway = QString("%1.%2.%3.1").arg(eth0Ipv4Address.split(".").at(0)).arg(eth0Ipv4Address.split(".").at(1)).arg(eth0Ipv4Address.split(".").at(2));
    //        qWarning() << "gateway:" << gateway;

    pData->setEth0ConName(eth0ConName);
    pData->setEth0Ipv4Address(eth0Ipv4Address);
    pData->setEth0ConEnabled(eth0ConEnabled);

    if(eth0ConEnabled){
#ifdef __linux__
        QProcess qprocess;

        QString gateway = QString("%1.%2.").arg(eth0Ipv4Address.split(".").at(0), eth0Ipv4Address.split(".").at(1));
        gateway += QString("%3.1").arg(eth0Ipv4Address.split(".").at(2));
        qDebug() << "Gateway:" << gateway;

        QStringList commandStrList;
        commandStrList.clear();
        commandStrList.append("eth0");
        commandStrList.append(eth0ConName);
        commandStrList.append(QString("%1/24").arg(eth0Ipv4Address));
        commandStrList.append(gateway);
        qWarning() << commandStrList;

        qprocess.start("wiredconinitstatic", commandStrList);
        qprocess.waitForFinished(); /// wait about maximum 30 seconds
        QString output(qprocess.readAllStandardOutput());
        int exitCode = qprocess.exitCode();
        qWarning() << output;
        qWarning() << "Exit Code:" << exitCode;

        /// Check eth0 Metric, it must be greater than 600 (wlan0 default)
        commandStrList.clear();
        commandStrList.append("eth0");
        commandStrList.append(eth0ConName);
        commandStrList.append(eth0Ipv4Address);
        commandStrList.append("800");/// set the metric to 800
        qWarning() << commandStrList;

        qprocess.start("wiredconsetmetric", commandStrList);
        qprocess.waitForFinished(); /// wait about maximum 30 seconds
        output = qprocess.readAllStandardOutput();
        exitCode = qprocess.exitCode();
        qWarning() << output;
        qWarning() << "Exit Code:" << exitCode;
        if(exitCode == 5){
            /// If the metric was successfully set, then need to Reboot the system
            pData->setWiredNetworkHasbeenConfigured(true);
        }
#endif
    }
}

void MachineBackend::setSvnUpdateHasBeenApplied()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    QSettings settings;
    settings.setValue(SKEY_SBC_SWU_AVAILABLE, false);

    pData->setSvnUpdateAvailable(false);
}

void MachineBackend::setSvnUpdateCheckEnable(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    QSettings settings;
    settings.setValue(SKEY_SBC_SVN_UPDATE_EN, value);

    pData->setSvnUpdateCheckForUpdateEnable(value);

    QMetaObject::invokeMethod(m_timerEventForCheckSwUpdate.data(), [&, value](){
            if(!value){
                if(m_timerEventForCheckSwUpdate->isActive())
                    m_timerEventForCheckSwUpdate->stop();
            }else{
                m_timerEventForCheckSwUpdate->setInterval(pData->getSvnUpdateCheckForUpdatePeriod() * 60000);
                if(!m_timerEventForCheckSwUpdate->isActive())
                    m_timerEventForCheckSwUpdate->start();
            }
        },
        Qt::QueuedConnection);
}

void MachineBackend::setSvnUpdateCheckPeriod(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if(pData->getSvnUpdateCheckForUpdatePeriod() == value)return;

    QSettings settings;
    settings.setValue(SKEY_SBC_SVN_UPDATE_PRD, value);

    pData->setSvnUpdateCheckForUpdatePeriod(value);
    bool enable = pData->getSvnUpdateCheckForUpdateEnable();

    QMetaObject::invokeMethod(m_timerEventForCheckSwUpdate.data(), [&, enable, value](){
            m_timerEventForCheckSwUpdate->setInterval(value * 60000);
            if(!enable){
                if(m_timerEventForCheckSwUpdate->isActive())
                    m_timerEventForCheckSwUpdate->stop();
            }else{
                if(!m_timerEventForCheckSwUpdate->isActive())
                    m_timerEventForCheckSwUpdate->start();
            }
        },
        Qt::QueuedConnection);
}

void MachineBackend::checkSoftwareVersionHistory()
{
    if(m_signedUserLevel == MachineEnums::USER_LEVEL_FACTORY)
        pData->setSvnUpdateHistory(m_pCheckSwUpdate->getSwUpdateHistory());
}

void MachineBackend::setAlarmExperimentTimerIsOver(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();
    pData->setAlarmExperimentTimerIsOver(value);

    if(isAlarmActive(value)){
        _insertAlarmLog(ALARM_LOG_CODE::ALC_EXP_TIMER_OVER_ALARM, ALARM_LOG_TEXT_EXP_TIMER_OVER_OK);
    }//
    else if(isAlarmNormal(value)){
        _insertAlarmLog(ALARM_LOG_CODE::ALC_EXP_TIMER_OVER_OK, ALARM_LOG_TEXT_EXP_TIMER_OVER_ALARM);
    }//
}

//void MachineBackend::initReplaceablePartsSettings()
//{
//    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

//    QSettings settings;
//    settings.beginGroup("rplist");

//    for(short i=1; i < MachineEnums::RPList_Total; i++){
//        pData->setRpListLast(i, settings.value(m_rpListSettings[i], "").toString());
//    }

//    settings.endGroup();
//}

void MachineBackend::setReplaceablePartsSettings(short index, const QString value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << m_rpListSettings[index] << value << thread();

    QSettings settings;

    settings.beginGroup("rplist");
    settings.setValue(m_rpListSettings[index], value);
    settings.endGroup();

    pData->setRpListLast(index, value);
}

void MachineBackend::setReplaceablePartsSelected(short descRowId)
{
    qDebug() << metaObject()->className() << __FUNCTION__ <<  descRowId << thread();

    QMetaObject::invokeMethod(m_pReplaceableCompRecord.data(), [&, descRowId](){
        QStringList strList;
        ReplaceableCompRecordSql *sql = m_pReplaceableCompRecord->getPSqlInterface();
        int count;
        bool success = sql->queryCount(&count);
        short indexRowId = count-descRowId;//index start from 0
        short rowId = indexRowId + 1;
        qDebug() << "Actual row ID" << rowId;

        if(success){
            success = m_pReplaceableCompRecord->getDataFromTableAtRowId(&strList, rowId);
            if(success){
                //qDebug() << strList;
                if(strList.length() != MachineEnums::RPList_Total){
                    qWarning() << "Data length invalid!" << strList.length() << "should be" << MachineEnums::RPList_Total;
                    return;
                }//
                for(short i=1; i < MachineEnums::RPList_Total; i++){
                    //pData->setRpListLast(i, m_settings->value(m_rpListSettings[i], "").toString());
                    //if(i==1) qDebug() << strList.at(i);
                    pData->setRpListSelected(i, strList.at(i));
                    //            qDebug() << i << pData->getRpListLastAtIndex(i);
                }//
            }//
        }//
    });

    //QJsonDocument doc = value.toJsonDocument();
    //qDebug() << doc;
    //pData->setRpListSelected();
}//

void MachineBackend::setKeyboardStringOnAcceptedEvent(const QString value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    pData->setKeyboardStringOnAcceptedEvent(value);
}

void MachineBackend::insertReplaceableComponentsForm()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    int currentRowCount = pData->getReplaceableCompRecordCount();
    //    /// This system has limited the datalog count only up to DATALOG_MAX_ROW
    //    if (currentRowCount >= ALARMREPLACEABLECOMPRECORD_MAX_ROW){
    //        return;
    //    }

    //    QDateTime dateTime = QDateTime::currentDateTime();
    //    QString dateTimeText = dateTime.toString("yyyy-MM-dd hh:mm:ss");

    QVariantMap dataMap;
    for(short i=MachineEnums::RPList_UnitModel; i<MachineEnums::RPList_Total; i++){
        if(i == MachineEnums::RPList_UserName){
            dataMap.insert(m_rpListSettings[i], m_signedUsername);
            qDebug() << i << m_rpListSettings[i] << m_signedUsername;
        }
        else if(i == MachineEnums::RPList_UserFullName){
            dataMap.insert(m_rpListSettings[i], m_signedFullname);
            qDebug() << i << m_rpListSettings[i] << m_signedFullname;
        }
        else{
            dataMap.insert(m_rpListSettings[i], pData->getRpListLastAtIndex(i));
            qDebug() << i << m_rpListSettings[i] << pData->getRpListLastAtIndex(i);
        }//
    }//

    /// execute this function in where thread the m_pReplaceableCompRecord live at
    QMetaObject::invokeMethod(m_pReplaceableCompRecord.data(),
        [&,
         dataMap](){
            ReplaceableCompRecordSql *sql = m_pReplaceableCompRecord->getPSqlInterface();
            bool success = sql->queryInsert(dataMap);

            /// check how many data log has stored now
            int count;
            success = sql->queryCount(&count);
            //        qDebug() << "success: " << success ;
            if(success){
                pData->setReplaceableCompRecordCount(count);
                //            qDebug() << count << maximumRowCount;
                bool logHasFull = count >= ALARMREPLACEABLECOMPRECORD_MAX_ROW;
                pData->setReplaceableCompRecordIsFull(logHasFull);
                if(count > ALARMREPLACEABLECOMPRECORD_MAX_ROW)
                    /// delete the last row from table
                    success = sql->queryDeleteOldestRowId();
            }//
        },
        Qt::QueuedConnection);
}

void MachineBackend::resetReplaceablePartsSettings()
{
    QSettings settings;

    settings.beginGroup("rplist");
    for(short i=1; i < MachineEnums::RPList_Total; i++){
        QString defaultValue = _getRpListDefaultValue(i);
        settings.setValue(m_rpListSettings[i], defaultValue);
        pData->setRpListLast(i, defaultValue);
        pData->setRpListSelected(i, "");
        //            qDebug() << i << pData->getRpListLastAtIndex(i);
    }//
    settings.endGroup();
}

void MachineBackend::requestEjectUsb(QString usbName)
{
    /**
     * The reason to use QMetaObject::invokeMethod if the recipient object might be in another thread
     * is that attempting to call a slot directly on an object in another thread can lead to corruption
     * or worse if it accesses or modifies non-thread-safe data **/
    QMetaObject::invokeMethod(m_pUSBAutoMount.data(), [&, usbName](){
            m_pUSBAutoMount->requestEjectUsb(usbName);
        },
        Qt::QueuedConnection);
}

void MachineBackend::setFrontEndScreenState(short value)
{
    pData->setFrontEndScreenStatePrev(pData->getFrontEndScreenState());
    pData->setFrontEndScreenState(value);
}

void MachineBackend::setInstallationWizardActive(bool value)
{
    pData->setInstallationWizardActive(value);
}

void MachineBackend::setSomeSettingsAfterExtConfigImported()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
#ifdef __linux__
    QSettings settings;
    QString year_sn = QDate::currentDate().toString("yyyy-000000");

    settings.setValue("sbcSN", "0000000000000001");
    settings.setValue("sbcSysInfo", "sysInfo:sbc");
    settings.setValue("serNum", year_sn);
#endif
}

void MachineBackend::setAllOutputShutdown()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
#ifdef __linux__
    QProcess qprocess;
    qprocess.start("boardinit", QStringList());
    qprocess.waitForFinished();
    qDebug() << qprocess.readAllStandardOutput();
#endif
}//

void MachineBackend::setFrontPanelSwitchInstalled(bool value)
{
    qDebug() << metaObject()->className() << __func__ << value << thread() ;

    pData->setFrontPanelSwitchInstalled(value);
    QSettings settings;
    settings.setValue(SKEY_FRONT_PANEL_INSTALLED, value);
}

void MachineBackend::scanRbmComPortAvalaible(bool value)
{
    m_scanRbmComPortAvailable = value;
}

void MachineBackend::setRbmComPortDfa(QString value)
{
    qDebug() << metaObject()->className() << __func__ << value << thread() ;

    pData->setRbmComPortDfa(value);
    QSettings settings;
    settings.setValue(SKEY_RBM_PORT_PRIMARY, value);
}

void MachineBackend::setRbmComPortIfa(QString value)
{
    qDebug() << metaObject()->className() << __func__ << value << thread() ;

    pData->setRbmComPortIfa(value);
    QSettings settings;
    settings.setValue(SKEY_RBM_PORT_INFLOW, value);
}

void MachineBackend::setSashMotorOffDelayMsec(int value)
{
    qDebug() << metaObject()->className() << __func__ << value << thread() ;

    pData->setSashMotorOffDelayMsec(value);
    QSettings settings;
    settings.setValue(SKEY_SASH_MOTOR_OFF_DELAY, value);
}

void MachineBackend::setDelayAlarmAirflowSec(int value)
{
    qDebug() << metaObject()->className() << __func__ << value << thread() ;

    pData->setDelayAlarmAirflowSec(value);
    QSettings settings;
    settings.setValue(SKEY_DELAY_ALARM_AIRFLOW, value);
}

void MachineBackend::setScreenSaverSeconds(int value)
{
    qDebug() << metaObject()->className() << __func__ << value << thread() ;

    pData->setScreenSaverSeconds(value);
    QSettings settings;
    settings.setValue(SKEY_SCREEN_SAVER_SEC, value);
}

void MachineBackend::setCabinetSideType(short value)
{
    qDebug() << metaObject()->className() << __func__ << value << thread() ;

    pData->setCabinetSideType(value);
    QSettings settings;
    settings.setValue(SKEY_CABINET_SIDE_TYPE, value);
}

void MachineBackend::setLogoutTime(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    QSettings settings;
    settings.setValue(SKEY_LOGOUT_TIME, value);
    pData->setLogoutTime(value);

    if(!value){
        _cancelLogoutTime();
    }else{
        _resetLogoutTime();
    }
}

void MachineBackend::setCFR21Part11Enable(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();
    QSettings settings;
    settings.setValue(SKEY_21_CFR_11_EN, value);
    pData->setCfr21Part11Enable(value);
}//
//void MachineBackend::setWifiDisabled(bool value)
//{
//    qDebug() << metaObject()->className() << __func__ << value << thread() ;

//    QSettings settings;
//    settings.setValue(SKEY_WIFI_DISABLED, value);
//    pData->setWifiDisabled(value);
//}

void MachineBackend::_machineState()
{
    //    qDebug() << __func__;

    ///ALARM BOARD
    bool alarmsBoards = false;
    alarmsBoards |= !pData->getBoardStatusHybridDigitalInput();
    alarmsBoards |= !pData->getBoardStatusHybridDigitalRelay();
    alarmsBoards |= !pData->getBoardStatusHybridAnalogInput();
    alarmsBoards |= !pData->getBoardStatusHybridAnalogOutput();
    if(pData->getCabinetWidth3Feet()){
        //        alarmsBoards |= !pData->getBoardStatusAnalogInput1();
        if(pData->getUsePwmOutSignal())
            alarmsBoards |= !pData->getBoardStatusPWMOutput();
        else
            alarmsBoards |= !pData->getBoardStatusAnalogOutput();
    }else{
        alarmsBoards |= !pData->getBoardStatusRbmCom();
        if(pData->getDualRbmMode())
            alarmsBoards |= !pData->getBoardStatusRbmCom2();
    }//
    alarmsBoards |= !pData->getBoardStatusCtpRtc();
    alarmsBoards |= !pData->getBoardStatusCtpIoe();
    if(pData->getSeasInstalled())
        alarmsBoards |= !pData->getBoardStatusPressureDiff();
    alarmsBoards |= !pData->getBoardStatusAnalogInput();

    Q_UNUSED((alarmsBoards))

    ///demo
#ifdef QT_DEBUG
    alarmsBoards = false;
#endif
#ifdef ON_TESTING
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
                //            ////MOTORIZE SASH
                //            if(pData->getSashWindowMotorizeInstalled()){

                //                if(pData->getSashWindowMotorizeUpInterlocked()){
                //                    m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                //                }

                //                if(pData->getSashWindowMotorizeDownInterlocked()){
                //                    m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                //                }

                //                if(m_pSashWindow->isSashStateChanged() && pData->getSashWindowStateChangedValid()){
                //                    if(pData->getSashWindowMotorizeState()){
                //                        /// Count tubular motor cycle
                //                        int count = pData->getSashCycleMeter();
                //                        count = count + 5; /// the value deviced by 10
                //                        pData->setSashCycleMeter(count);
                //                        ///qDebug() << metaObject()->className() << __func__ << "setSashCycleMeter: " << pData->getSashCycleMeter();
                //                        ///save permanently
                //                        QSettings settings;
                //                        settings.setValue(SKEY_SASH_CYCLE_METER, count);

                //                        qDebug() << "Sash Motor Off in Sash Safe";
                //                        /// Don't turnOff the sash if the previous State is the same
                //                        if(pData->getSashWindowPrevState() != MachineEnums::SASH_STATE_WORK_SSV){
                //                            /// Turned off mototrize in every defined magnetic switch
                //                            m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                //                            m_pSasWindowMotorize->routineTask();
                //                        }
                //                    }//
                //                }//
                //            }//

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

                if(pData->getFanInflowInterlocked()){
                    //qDebug()<<"case MachineEnums::SASH_STATE_WORK_SSV: 0";
                    _setFanInflowInterlocked(MachineEnums::DIG_STATE_ZERO);
                }

                /// CLEAR LAMP INTERLOCK
                if(pData->getLightInterlocked()){
                    m_pLight->setInterlock(MachineEnums::DIG_STATE_ZERO);
                }

                ///////////////INTERLOCK GAS IF DEVICE INSTALLED AND WARMUP IS NOT ACTIVE
                /// AND NO ALARM
                if(pData->getGasInstalled()){
                    if(isFanStateNominal()
                        && !pData->getPostPurgingActive()
                        && !pData->getWarmingUpActive() && !pData->getAlarmsState()){
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

                //// NA ALARM STANDBY FAN OFF
                if(!isAlarmNA(pData->getAlarmStandbyFanOff())){
                    pData->setAlarmStandbyFanOff(MachineEnums::ALARM_NA_STATE);
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
                        && !pData->getPostPurgingActive()
                        && isAirflowHasCalibrated()){

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
                        bool alarmAirflowAvailable = false;
                        if(isFanStateNominal() && pData->getAirflowMonitorEnable()){
                            if (isAirflowHasCalibrated()){
                                if (isTempAmbientNormal()){
                                    if (!pData->getWarmingUpActive()){
                                        alarmAirflowAvailable = true;
                                        //if(!pData->dataPostpurgeState()){

                                        //SET IF ACTUAL AF IS LOWER THAN MINIMUM, OTHERWISE UNSET
                                        bool ifaTooLow = false;
                                        bool dfaTooLow = false;
                                        bool dfaTooHigh = false;
                                        short alarmOffset = 0/*pData->getMeasurementUnit() ? 100 : 1*/;
                                        ifaTooLow = pData->getInflowVelocity() <= pData->getInflowLowLimitVelocity();
                                        dfaTooLow = pData->getDownflowVelocity() <= pData->getDownflowLowLimitVelocity() + alarmOffset;
                                        dfaTooHigh = pData->getDownflowVelocity() >= pData->getDownflowHighLimitVelocity() - alarmOffset;

                                        //qDebug() << "ifaTooLow: " << ifaTooLow << pData->getInflowVelocity() << pData->getInflowLowLimitVelocity();
                                        //qDebug() << "dfaTooLow: " << dfaTooLow << pData->getDownflowVelocity() << pData->getDownflowLowLimitVelocity();
                                        //qDebug() << "dfaTooHigh: " << dfaTooHigh << pData->getDownflowVelocity() << pData->getDownflowHighLimitVelocity();

                                        /// INFLOW
                                        if(ifaTooLow){
                                            //                                        if(!m_alarmInflowLowDelaySet){
                                            //                                            m_alarmInflowLowDelayCountdown = pData->getDelayAlarmAirflowSec();
                                            //                                            m_alarmInflowLowDelaySet = true;
                                            //                                        }
                                            if(!isAlarmActive(pData->getAlarmInflowLow()) && m_alarmInflowLowDelaySet && !m_alarmInflowLowDelayCountdown){
                                                pData->setAlarmInflowLow(MachineEnums::ALARM_ACTIVE_STATE);

                                                QString text = QString("%1 (%2)")
                                                                   .arg(ALARM_LOG_TEXT_INFLOW_ALARM_TOO_LOW, pData->getInflowVelocityStr());
                                                _insertAlarmLog(ALARM_LOG_CODE::ALC_INFLOW_ALARM_LOW, text);
                                            }
                                        }
                                        else {
                                            //                                        if(m_alarmInflowLowDelaySet){
                                            //                                            m_alarmInflowLowDelaySet = false;
                                            //                                            m_alarmInflowLowDelayCountdown = 0;
                                            //                                        }
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
                                        /// DOWNFLOW
                                        if(dfaTooLow){
                                            //                                        if(!m_alarmDownflowLowDelaySet){
                                            //                                            m_alarmDownflowLowDelayCountdown = pData->getDelayAlarmAirflowSec();
                                            //                                            m_alarmDownflowLowDelaySet = true;
                                            //                                        }
                                            if(!isAlarmActive(pData->getAlarmDownflowLow()) && m_alarmDownflowLowDelaySet && !m_alarmDownflowLowDelayCountdown){
                                                pData->setAlarmDownflowLow(MachineEnums::ALARM_ACTIVE_STATE);

                                                QString text = QString("%1 (%2)")
                                                                   .arg(ALARM_LOG_TEXT_DOWNFLOW_ALARM_TOO_LOW, pData->getDownflowVelocityStr());
                                                _insertAlarmLog(ALARM_LOG_CODE::ALC_DOWNFLOW_ALARM_LOW, text);
                                            }
                                        }
                                        else if(dfaTooHigh){
                                            //                                        if(!m_alarmDownflowHighDelaySet){
                                            //                                            m_alarmDownflowHighDelayCountdown = pData->getDelayAlarmAirflowSec();
                                            //                                            m_alarmDownflowHighDelaySet = true;
                                            //                                        }
                                            if(!isAlarmActive(pData->getAlarmDownflowHigh()) && m_alarmDownflowHighDelaySet && !m_alarmDownflowHighDelayCountdown){

                                                pData->setAlarmDownflowHigh(MachineEnums::ALARM_ACTIVE_STATE);

                                                QString text = QString("%1 (%2)")
                                                                   .arg(ALARM_LOG_TEXT_DOWNFLOW_ALARM_TOO_HIGH, pData->getDownflowVelocityStr());
                                                _insertAlarmLog(ALARM_LOG_CODE::ALC_DOWNFLOW_ALARM_HIGH, text);
                                            }
                                        }
                                        else {
                                            //                                        if(m_alarmDownflowLowDelaySet){
                                            //                                            m_alarmDownflowLowDelaySet = false;
                                            //                                            m_alarmDownflowLowDelayCountdown = 0;
                                            //                                        }
                                            //                                        if(m_alarmDownflowHighDelaySet){
                                            //                                            m_alarmDownflowHighDelaySet = false;
                                            //                                            m_alarmDownflowHighDelayCountdown = 0;
                                            //                                        }

                                            short prevState = pData->getAlarmDownflowLow();
                                            short prevState1 = pData->getAlarmDownflowHigh();

                                            if(!isAlarmNormal(prevState)){
                                                pData->setAlarmDownflowLow(MachineEnums::ALARM_NORMAL_STATE);
                                            }
                                            if(!isAlarmNormal(prevState1)){
                                                pData->setAlarmDownflowHigh(MachineEnums::ALARM_NORMAL_STATE);
                                            }

                                            if(isAlarmActive(prevState) || isAlarmActive(prevState1)) {
                                                QString text = QString("%1 (%2)")
                                                                   .arg(ALARM_LOG_TEXT_DOWNFLOW_ALARM_OK, pData->getDownflowVelocityStr());
                                                _insertAlarmLog(ALARM_LOG_CODE::ALC_DOWNFLOW_ALARM_OK, text);
                                            }//
                                        }//
                                    }//
                                }//
                            }//
                        }//
                        if(!alarmAirflowAvailable){
                            if(!isAlarmNA(pData->getAlarmInflowLow())) {
                                pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
                                pData->setAlarmDownflowLow(MachineEnums::ALARM_NORMAL_STATE);
                                pData->setAlarmDownflowHigh(MachineEnums::ALARM_NORMAL_STATE);
                            }
                        }
                    }

                    ////CABINET TYPE A, EXAMPLE LA2
                    if(pData->getSeasInstalled()){
                        //DEPENDING_TO_BLOWER_STATE
                        //DEPENDING_TO_AF_CALIBRATION_STATUS
                        //ONLY_IF_BLOWER_IS_ON
                        short alarm = pData->getAlarmSeasPressureLow();
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

                //            //AUTOMATIC IO STATE
                //            //IF SASH STATE JUST CHANGED
                //            if(m_pSashWindow->isSashStateChanged() && pData->getSashWindowStateChangedValid()
                //                    && (m_pSashWindow->previousState() == MachineEnums::SASH_STATE_UNSAFE_SSV)
                //                    && !eventTimerForDelaySafeHeightAction){

                //                /// delayQuickModeAutoOn object will be destroyed when the sash state is changed
                //                /// see also _onSashStateChanged()

                //                /// Delay execution
                //                eventTimerForDelaySafeHeightAction = new QTimer();
                //                eventTimerForDelaySafeHeightAction->setInterval(m_sashSafeAutoOnOutputDelayTimeMsec);
                //                eventTimerForDelaySafeHeightAction->setSingleShot(true);
                //                ///Ececute this block after a certain time (m_sashSafeAutoOnOutputDelayTimeMsec)
                //                QObject::connect(eventTimerForDelaySafeHeightAction, &QTimer::timeout, eventTimerForDelaySafeHeightAction,
                //                                 [=](){

                //                    qDebug() << "Sash Safe Height after delay turned on out put";
                //                    ///Ensure the Buzzer Alarm Off Once Sahs Safe
                //                    setBuzzerState(MachineEnums::DIG_STATE_ZERO);
                //                    ////TURN ON LAMP
                //                    m_pLight->setState(MachineEnums::DIG_STATE_ONE);
                //                    ///
                //                    _insertEventLog(EVENT_STR_LIGHT_ON);
                //                    ////IF CURRENT MODE MOPERATION IS QUICK START OR
                //                    ////IF CURRENT FAN STATE IS STANDBY SPEED; THEN
                //                    ////SWITCH BLOWER SPEED TO NOMINAL SPEED
                //                    bool autoOnBlower = false;
                //                    autoOnBlower |= (modeOperation == MachineEnums::MODE_OPERATION_QUICKSTART);
                //                    autoOnBlower |= (pData->getFanPrimaryState() == MachineEnums::FAN_STATE_STANDBY || pData->getFanInflowState() == MachineEnums::FAN_STATE_STANDBY);
                //                    autoOnBlower &= (pData->getFanState() != MachineEnums::FAN_STATE_ON);

                //                    if(autoOnBlower){
                //                        //_setFanPrimaryStateNominal();
                //                        setFanState(MachineEnums::FAN_STATE_ON);
                //                        /// Tell every one if the fan state will be changing
                //                        emit pData->fanSwithingStateTriggered(MachineEnums::DIG_STATE_ONE);
                //                        ////
                //                        _insertEventLog(EVENT_STR_FAN_ON);
                //                    }

                //                    /// clear vivarium mute state
                //                    if(pData->getVivariumMuteState()){
                //                        setMuteVivariumState(false);
                //                    }
                //                });

                //                eventTimerForDelaySafeHeightAction->start();
                //            }
                //            /// CLEAR FLAG OF SASH STATE FLAG
                //            if(m_pSashWindow->isSashStateChanged() && pData->getSashWindowStateChangedValid()){
                //                m_pSashWindow->clearFlagSashStateChanged();
                //            }
            }
            break;
            case MachineEnums::SASH_STATE_UNSAFE_SSV:
            {
                //            ////MOTORIZE SASH
                //            if(pData->getSashWindowMotorizeInstalled()){

                //                if(pData->getSashWindowMotorizeUpInterlocked()){
                //                    m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                //                }

                //                if(pData->getSashWindowMotorizeDownInterlocked()){
                //                    m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                //                }
                //            }

                ///LOCK FAN IF CURRENT STATE OFF
                if(!pData->getFanPrimaryState()){
                    if(!pData->getFanPrimaryInterlocked()){
                        _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ONE);
                    }
                }

                ///LOCK FAN IF CURRENT STATE OFF
                if(!pData->getFanInflowState()){
                    if(!pData->getFanInflowInterlocked()){
                        //qDebug()<<"case MachineEnums::SASH_STATE_UNSAFE_SSV: 1";
                        _setFanInflowInterlocked(MachineEnums::DIG_STATE_ONE);
                    }
                }

                //LOCK LAMP
                if(pData->getLightState())
                    setLightState(MachineEnums::DIG_STATE_ZERO);
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

                //// NA ALARM STANDBY FAN OFF
                if(!isAlarmNA(pData->getAlarmStandbyFanOff())){
                    pData->setAlarmStandbyFanOff(MachineEnums::ALARM_NA_STATE);
                }

                ////NA ALARM AIRFLOW
                if(!isAlarmNA(pData->getAlarmInflowLow())){
                    pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
                }
                if(!isAlarmNA(pData->getAlarmDownflowLow())){
                    pData->setAlarmDownflowLow(MachineEnums::ALARM_NA_STATE);
                }
                if(!isAlarmNA(pData->getAlarmDownflowHigh())){
                    pData->setAlarmDownflowHigh(MachineEnums::ALARM_NA_STATE);
                }

                if (!isAlarmNA(pData->getAlarmTempHigh())) {
                    pData->setAlarmTempHigh(MachineEnums::ALARM_NA_STATE);
                }
                if (isAlarmNA(pData->getAlarmTempLow())) {
                    pData->setAlarmTempLow(MachineEnums::ALARM_NA_STATE);
                }
                //            /// CLEAR FLAG OF SASH STATE FLAG
                //            if(m_pSashWindow->isSashStateChanged() && pData->getSashWindowStateChangedValid()){
                //                m_pSashWindow->clearFlagSashStateChanged();
                //            }
            }
            break;
            case MachineEnums::SASH_STATE_FULLY_CLOSE_SSV:
            {
                //            ////MOTORIZE SASH
                //            if(pData->getSashWindowMotorizeInstalled()){

                //                if(pData->getSashWindowMotorizeUpInterlocked()){
                //                    m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                //                }

                //                if(m_pSashWindow->isSashStateChanged()){
                //                    if(pData->getSashWindowMotorizeState()){
                //                        if(pData->getSashMotorOffDelayMsec()){
                //                            if(!eventTimerForDelayMotorizedOffAtFullyClosed){
                //                                m_delaySashMotorFullyClosedExecuted = false;
                //                                /// Give a delay for a moment for sash moving down after fully closed detected
                //                                eventTimerForDelayMotorizedOffAtFullyClosed = new QTimer();
                //                                eventTimerForDelayMotorizedOffAtFullyClosed->setInterval(pData->getSashMotorOffDelayMsec());
                //                                eventTimerForDelayMotorizedOffAtFullyClosed->setSingleShot(true);
                //                                ///Ececute this block after a certain time (pData->getSashMotorOffDelayMsec())
                //                                QObject::connect(eventTimerForDelayMotorizedOffAtFullyClosed, &QTimer::timeout,
                //                                                 eventTimerForDelayMotorizedOffAtFullyClosed, [=](){
                //                                    qDebug() << "Sash Motor Off in Sash Fully Closed With Delay";
                //                                    m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                //                                    m_pSasWindowMotorize->routineTask();
                //                                    m_delaySashMotorFullyClosedExecuted = true;
                //                                });

                //                                eventTimerForDelayMotorizedOffAtFullyClosed->start();
                //                            }
                //                        }else{
                //                            qDebug() << "Sash Motor Off in Sash Fully Closed";
                //                            m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                //                            m_pSasWindowMotorize->routineTask();
                //                        }
                //                    }
                //                }
                //                if(m_delaySashMotorFullyClosedExecuted){
                //                    if(!pData->getSashWindowMotorizeDownInterlocked()){
                //                        m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ONE);
                //                    }
                //                    if (eventTimerForDelayMotorizedOffAtFullyClosed != nullptr) {
                //                        eventTimerForDelayMotorizedOffAtFullyClosed->stop();
                //                        delete eventTimerForDelayMotorizedOffAtFullyClosed;
                //                        eventTimerForDelayMotorizedOffAtFullyClosed = nullptr;
                //                    }
                //                }
                //            }

                /// MakeSure The Fan in Off state while in FullyClosed Sash
                if(pData->getFanState() != MachineEnums::FAN_STATE_OFF)
                    setFanState(MachineEnums::FAN_STATE_OFF);

                //LOCK FAN
                if(!pData->getFanPrimaryInterlocked()){
                    _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ONE);
                }
                if(!pData->getFanInflowInterlocked()){
                    //qDebug()<<"case MachineEnums::SASH_STATE_FULLY_CLOSE_SSV: 1";
                    _setFanInflowInterlocked(MachineEnums::DIG_STATE_ONE);
                }

                //LOCK LAMP
                if(!pData->getLightInterlocked()){
                    m_pLight->setInterlock(MachineEnums::DIG_STATE_ONE);
                }

                //UNLOCK UV IF DEVICE INSTALLED
                if(pData->getUvInstalled()){
                    /// Interlocked UV Light If Front Panel is Opened
                    if(pData->getFrontPanelSwitchState()){
                        if(!pData->getUvInterlocked()){
                            m_pUV->setInterlock(MachineEnums::DIG_STATE_ONE);
                        }
                    }
                    else{
                        if(pData->getUvInterlocked()){
                            m_pUV->setInterlock(MachineEnums::DIG_STATE_ZERO);
                        }
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
                    setBuzzerState(MachineEnums::DIG_STATE_ZERO);
                    pData->setAlarmSash(MachineEnums::ALARM_SASH_NA_STATE);
                }
                //// NA ALARM STANDBY FAN OFF
                if(!isAlarmNA(pData->getAlarmStandbyFanOff())){
                    pData->setAlarmStandbyFanOff(MachineEnums::ALARM_NA_STATE);
                }
                ///NO APPLICABLE AIRFLOW ALARM IF THE SASH NOT IN WORKING HEIGHT
                if(!isAlarmNA(pData->getAlarmInflowLow())){
                    pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
                }
                if(!isAlarmNA(pData->getAlarmDownflowLow())){
                    pData->setAlarmDownflowLow(MachineEnums::ALARM_NA_STATE);
                }
                if(!isAlarmNA(pData->getAlarmDownflowHigh())){
                    pData->setAlarmDownflowHigh(MachineEnums::ALARM_NA_STATE);
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
                //            /// CLEAR FLAG OF SASH STATE FLAG
                //            if(m_pSashWindow->isSashStateChanged() && pData->getSashWindowStateChangedValid()){
                //                m_pSashWindow->clearFlagSashStateChanged();
                //            }
            }
            break;
            case MachineEnums::SASH_STATE_STANDBY_SSV:
            {
                //            ////MOTORIZE SASH
                //            if(pData->getSashWindowMotorizeInstalled()){

                //                if(pData->getSashWindowMotorizeUpInterlocked()){
                //                    m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                //                }

                //                if(pData->getSashWindowMotorizeDownInterlocked()){
                //                    m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                //                }

                //                if(m_pSashWindow->isSashStateChanged() && pData->getSashWindowStateChangedValid()){
                //                    if(pData->getSashWindowMotorizeState()){
                //                        qDebug() << "Sash Motor Off in Sash Standby";
                //                        /// Don't turnOff the sash if the previous State is the same
                //                        if(pData->getSashWindowPrevState() != MachineEnums::SASH_STATE_STANDBY_SSV){
                //                            /// Turned off mototrize in every defined magnetic switch
                //                            m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                //                            m_pSasWindowMotorize->routineTask();
                //                        }
                //                    }//
                //                }//
                //            }//

                ////LOCK LAMP
                if(!pData->getLightInterlocked()){
                    m_pLight->setInterlock(MachineEnums::DIG_STATE_ONE);
                }//

                ////LOCK UV IF DEVICE INSTALLED
                if(pData->getUvInstalled()){
                    if(!pData->getUvInterlocked()){
                        m_pUV->setInterlock(MachineEnums::DIG_STATE_ONE);
                    }
                }//

                //LOCK GAS IF DEVICE INSTALLED
                if(pData->getGasInstalled()){
                    if(!pData->getGasInterlocked()){
                        m_pGas->setInterlock(MachineEnums::DIG_STATE_ONE);
                    }
                }//

                //UNLOCK FAN
                if(pData->getFanPrimaryInterlocked()){
                    _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ZERO);
                }
                if(pData->getFanInflowInterlocked()){
                    //qDebug()<<"case MachineEnums::SASH_STATE_STANDBY_SSV: 0";
                    _setFanInflowInterlocked(MachineEnums::DIG_STATE_ZERO);
                }

                //            //AUTOMATIC IO STATE
                //            if(m_pSashWindow->isSashStateChanged() && pData->getSashWindowStateChangedValid()){
                //                if((pData->getFanState() == MachineEnums::FAN_STATE_ON)){
                //                    qDebug() << "eventTimerForDelaySafeHeightAction stb" << eventTimerForDelaySafeHeightAction;
                //                    if(!eventTimerForDelaySafeHeightAction){

                //                        /// delayQuickModeAutoOn oject will be destroyed when the sash state is changed
                //                        /// see also _onSashStateChanged()
                //                        /// Delay execution
                //                        eventTimerForDelaySafeHeightAction = new QTimer();
                //                        eventTimerForDelaySafeHeightAction->setInterval(m_sashSafeAutoOnOutputDelayTimeMsec);
                //                        eventTimerForDelaySafeHeightAction->setSingleShot(true);
                //                        ///Ececute this block after a certain time (m_sashSafeAutoOnOutputDelayTimeMsec)
                //                        QObject::connect(eventTimerForDelaySafeHeightAction, &QTimer::timeout, eventTimerForDelaySafeHeightAction,
                //                                         [=](){
                //                            qDebug() << "Sash Standby Height after delay turned on out put";
                //                            //TURN BLOWER TO STANDBY SPEED
                //                            setFanState(MachineEnums::FAN_STATE_STANDBY);
                //                            //_setFanPrimaryStateStandby();
                //                        });

                //                        eventTimerForDelaySafeHeightAction->start();
                //                    }//
                //                    //                if(pData->getFanPrimaryState() == MachineEnums::FAN_STATE_ON){
                //                    //                    //TURN BLOWER TO STANDBY SPEED
                //                    //                    _setFanPrimaryStateStandby();
                //                    //                }
                //                }//
                //            }//

                /// ALARM STANDBY FAN OFF
                if(!isFanStateStandby()) {
                    if(!isAlarmActive(pData->getAlarmStandbyFanOff())){
                        pData->setAlarmStandbyFanOff(MachineEnums::ALARM_ACTIVE_STATE);
                        /// INSERT ALARM LOG
                        QString text = QString("%1").arg(ALARM_LOG_TEXT_FAN_STB_OFF_ACTIVE);
                        _insertAlarmLog(ALARM_LOG_CODE::ALC_STB_FAN_OFF_ACTIVE, text);
                    }
                }else{
                    if(isAlarmActive(pData->getAlarmStandbyFanOff())){
                        pData->setAlarmStandbyFanOff(MachineEnums::ALARM_NORMAL_STATE);
                        /// INSERT ALARM LOG
                        QString text = QString("%1").arg(ALARM_LOG_TEXT_FAN_STB_OFF_OK);
                        _insertAlarmLog(ALARM_LOG_CODE::ALC_STB_FAN_OFF_INACTIVE, text);
                    }
                }//

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
                    //if(isFanStateStandby()){
                    ////UNSET ALARM SASH
                    if(!isAlarmNA(pData->getAlarmSash())){
                        pData->setAlarmSash(MachineEnums::ALARM_SASH_NA_STATE);
                    }
                    //}
                    //                else {
                    //                    if (!isAlarmActive(pData->getAlarmSash())){
                    //                        pData->setAlarmSash(MachineEnums::ALARM_SASH_ACTIVE_UNSAFE_STATE);

                    //                        _insertAlarmLog(ALARM_LOG_CODE::ALC_SASH_WINDOW_UNSAFE,
                    //                                        ALARM_LOG_TEXT_SASH_UNSAFE);
                    //                    }
                    //                }
                }

                ///NO AVAILABLE AIRFLOW ALARM IF THE SASH NOT IN WORKING HEIGHT
                if(!isAlarmNA(pData->getAlarmInflowLow())){
                    pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
                }
                if(!isAlarmNA(pData->getAlarmDownflowLow())){
                    pData->setAlarmDownflowLow(MachineEnums::ALARM_NA_STATE);
                }
                if(!isAlarmNA(pData->getAlarmDownflowHigh())){
                    pData->setAlarmDownflowHigh(MachineEnums::ALARM_NA_STATE);
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

                //            /// CLEAR FLAG OF SASH STATE FLAG
                //            if(m_pSashWindow->isSashStateChanged() && pData->getSashWindowStateChangedValid()){
                //                m_pSashWindow->clearFlagSashStateChanged();
                //            }
            }
            break;
            case MachineEnums::SASH_STATE_FULLY_OPEN_SSV:
            {
                //            ////MOTORIZE SASH
                //            if(pData->getSashWindowMotorizeInstalled()){

                //                if(!pData->getSashWindowMotorizeUpInterlocked()){
                //                    m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ONE);
                //                }

                //                if(pData->getSashWindowMotorizeDownInterlocked()){
                //                    m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                //                }

                //                if(m_pSashWindow->isSashStateChanged()  && pData->getSashWindowStateChangedValid()){
                //                    if(pData->getSashWindowMotorizeState()){
                //                        qDebug() << "Sash Motor On in Sash Fully Open count";
                //                        m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                //                        m_pSasWindowMotorize->routineTask();
                //                    }
                //                }
                //            }

                ///LOCK FAN IF CURRENT STATE OFF
                if(!pData->getFanPrimaryDutyCycle()){
                    if(pData->getFanPrimaryInterlocked()){
                        _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ZERO);
                    }
                }
                if(!pData->getFanInflowDutyCycle()){
                    if(pData->getFanInflowInterlocked()){
                        //qDebug()<<"case MachineEnums::SASH_STATE_FULLY_OPEN_SSV: 0";
                        _setFanInflowInterlocked(MachineEnums::DIG_STATE_ZERO);
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
                //// NA ALARM STANDBY FAN OFF
                if(!isAlarmNA(pData->getAlarmStandbyFanOff())){
                    pData->setAlarmStandbyFanOff(MachineEnums::ALARM_NA_STATE);
                }
                ///NO APPLICABLE AIRFLOW ALARM IF THE SASH NOT IN WORKING HEIGHT
                if(!isAlarmNA(pData->getAlarmInflowLow())){
                    pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
                }
                if(!isAlarmNA(pData->getAlarmDownflowLow())){
                    pData->setAlarmDownflowLow(MachineEnums::ALARM_NA_STATE);
                }
                if(!isAlarmNA(pData->getAlarmDownflowHigh())){
                    pData->setAlarmDownflowHigh(MachineEnums::ALARM_NA_STATE);
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
                //            /// CLEAR FLAG OF SASH STATE FLAG
                //            if(m_pSashWindow->isSashStateChanged() && pData->getSashWindowStateChangedValid()){
                //                m_pSashWindow->clearFlagSashStateChanged();
                //            }
            }
            break;
            default:
                //SASH SENSOR ERROR
                {
                    //            ////MOTORIZE SASH
                    //            if(pData->getSashWindowMotorizeInstalled()){

                    //                if(pData->getSashWindowMotorizeUpInterlocked()){
                    //                    m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                    //                }

                    //                if(pData->getSashWindowMotorizeDownInterlocked()){
                    //                    m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                    //                }

                    //                if(m_pSashWindow->isSashStateChanged() && pData->getSashWindowStateChangedValid()){
                    //                    if(pData->getSashWindowMotorizeState()){
                    //                        qDebug() << "Sash Motor Off in Sash Error";
                    //                        m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                    //                        m_pSasWindowMotorize->routineTask();
                    //                    }
                    //                }
                    //            }

                    //LOCK FAN
                    if(!pData->getFanPrimaryInterlocked()){
                        if(!pData->getFanPrimaryState()){
                            _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ONE);
                        }
                    }
                    if(!pData->getFanInflowInterlocked()){
                        if(!pData->getFanInflowState()){
                            //qDebug()<<"case MachineEnums::SASH SENSOR ERROR: 1";
                            _setFanInflowInterlocked(MachineEnums::DIG_STATE_ONE);
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

                    //// NA ALARM STANDBY FAN OFF
                    if(!isAlarmNA(pData->getAlarmStandbyFanOff())){
                        pData->setAlarmStandbyFanOff(MachineEnums::ALARM_NA_STATE);
                    }

                    ///NO APPLICABLE AIRFLOW ALARM IF THE SASH NOT IN WORKING HEIGHT
                    if(!isAlarmNA(pData->getAlarmInflowLow())){
                        pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
                    }
                    if(!isAlarmNA(pData->getAlarmDownflowLow())){
                        pData->setAlarmDownflowLow(MachineEnums::ALARM_NA_STATE);
                    }
                    if(!isAlarmNA(pData->getAlarmDownflowHigh())){
                        pData->setAlarmDownflowHigh(MachineEnums::ALARM_NA_STATE);
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
                    //            /// CLEAR FLAG OF SASH STATE FLAG
                    //            if(m_pSashWindow->isSashStateChanged() && pData->getSashWindowStateChangedValid()){
                    //                m_pSashWindow->clearFlagSashStateChanged();
                    //            }
                }
                break;
            }
            //////////////////////////////////////////////CONDITION BY SASH - END
        }
        //////////////////////////////CONDITION BY MODE NORMAL OR QUICKSTART - END
        break;
    case MachineEnums::MODE_OPERATION_MAINTENANCE:
    {
        //        ////MOTORIZE SASH
        //        if(pData->getSashWindowMotorizeInstalled()){

        //            if(pData->getSashWindowMotorizeUpInterlocked()){
        //                m_pSasWindowMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
        //            }

        //            if(pData->getSashWindowMotorizeDownInterlocked()){
        //                m_pSasWindowMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
        //            }

        //            if(m_pSashWindow->isSashStateChanged()){
        //                if(pData->getSashWindowMotorizeState()){
        //                    qDebug() << "Sash Motor Off in Mode Maintenance";
        //                    m_pSasWindowMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
        //                    m_pSasWindowMotorize->routineTask();
        //                }
        //            }
        //        }

        /////CLEAR INTERLOCK FAN
        if(pData->getFanPrimaryInterlocked()){
            _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ZERO);
        }
        if(pData->getFanInflowInterlocked()){
            //qDebug()<<"case MODE_OPERATION_MAINTENANCE : 0";
            _setFanInflowInterlocked(MachineEnums::DIG_STATE_ZERO);
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
        if(!isAlarmNA(pData->getAlarmDownflowLow())){
            pData->setAlarmDownflowLow(MachineEnums::ALARM_NA_STATE);
        }
        if(!isAlarmNA(pData->getAlarmDownflowHigh())){
            pData->setAlarmDownflowHigh(MachineEnums::ALARM_NA_STATE);
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
        if (!isAlarmNA(pData->getAlarmTempLow())) {
            pData->setAlarmTempLow(MachineEnums::ALARM_NA_STATE);
        }
        //// NA ALARM STANDBY FAN OFF
        if(!isAlarmNA(pData->getAlarmStandbyFanOff())){
            pData->setAlarmStandbyFanOff(MachineEnums::ALARM_NA_STATE);
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

        //        /// CLEAR FLAG OF SASH STATE FLAG
        //        if(m_pSashWindow->isSashStateChanged()){
        //            m_pSashWindow->clearFlagSashStateChanged();
        //        }
    }/// THE END OF MAINTENANCE MODE
    break;
    }


    bool alarms = false;
    //Check The Alarms Only when SBC used is the registered SBC
    if(pData->getSbcCurrentSerialNumberKnown()/* && pData->getOperationMode() != MachineEnums::MODE_OPERATION_MAINTENANCE*/)
    {
        alarms |= isAlarmActive(pData->getAlarmBoardComError());
        alarms |= isAlarmActive(pData->getAlarmInflowLow());
        alarms |= isAlarmActive(pData->getAlarmDownflowLow());
        alarms |= isAlarmActive(pData->getAlarmDownflowHigh());
        alarms |= isAlarmActive(pData->getAlarmSeasPressureLow());

        alarms |= isAlarmActive(pData->getSeasFlapAlarmPressure());
        alarms |= isAlarmActive(pData->getAlarmSash());
        alarms |= isAlarmActive(pData->getAlarmTempHigh());
        alarms |= isAlarmActive(pData->getAlarmTempLow());
        alarms |= isAlarmActive(pData->getAlarmStandbyFanOff());

        alarms |= isAlarmActive(pData->getSashCycleMotorLockedAlarm());
        alarms |= isAlarmActive(pData->getFrontPanelAlarm());
        alarms |= isAlarmActive(pData->getAlarmSashMotorDownStuck());
        alarms |= isAlarmActive(pData->getAlarmExperimentTimerIsOver());
        //    alarms = false;
        //        qDebug() << "alarms" << alarms;
        //        qDebug() << pData->getAlarmBoardComError() << pData->getAlarmInflowLow() << pData->getAlarmDownflowLow() << pData->getAlarmDownflowHigh() << pData->getAlarmSeasPressureLow();
        //        qDebug() << pData->getSeasFlapAlarmPressure() << pData->getAlarmSash() << pData->getAlarmTempHigh() << pData->getAlarmTempLow() << pData->getAlarmStandbyFanOff();
        //        qDebug() << pData->getSashCycleMotorLockedAlarm() << pData->getFrontPanelAlarm() << pData->getAlarmSashMotorDownStuck();
#ifdef ON_TESTING
        alarms = false;
#endif
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
    if(pData->getFanState()){
        if(!pData->getExhaustContactState())
            setExhaustContactState(MachineEnums::DIG_STATE_ONE);
    }else{
        if(pData->getExhaustContactState())
            setExhaustContactState(MachineEnums::DIG_STATE_ZERO);
    }

    //RELAY CONTACT STATE FOR BLOWER INDICATION
    //SET RELAY CONTACT ALARM IF INTERNAL BLOWER ON/STANDBY
    //OTHERWISE UNSET
    if(pData->getAlarmsState()){
        if(!pData->getAlarmContactState())
            setAlarmContactState(MachineEnums::DIG_STATE_ONE);
    }
    else {
        if(pData->getAlarmContactState())
            setAlarmContactState(MachineEnums::DIG_STATE_ZERO);
    }

    /// MODBUS ALARM STATUS
    _setModbusRegHoldingValue(modbusRegisterAddress.AlarmBoardCom.addr, static_cast<ushort>(pData->getAlarmBoardComError()));
    _setModbusRegHoldingValue(modbusRegisterAddress.AlarmSash.addr, static_cast<ushort>(pData->getAlarmSash()));
    _setModbusRegHoldingValue(modbusRegisterAddress.AlarmInflowLow.addr, static_cast<ushort>(pData->getAlarmInflowLow()));
    _setModbusRegHoldingValue(modbusRegisterAddress.AlarmDownflowLow.addr, static_cast<ushort>(pData->getAlarmDownflowLow()));
    _setModbusRegHoldingValue(modbusRegisterAddress.AlarmDownflowHigh.addr, static_cast<ushort>(pData->getAlarmDownflowHigh()));
    _setModbusRegHoldingValue(modbusRegisterAddress.AlarmTempLow.addr, static_cast<ushort>(pData->getAlarmTempLow()));
    _setModbusRegHoldingValue(modbusRegisterAddress.AlarmTempHigh.addr, static_cast<ushort>(pData->getAlarmTempHigh()));
    _setModbusRegHoldingValue(modbusRegisterAddress.AlarmSashCycleMotorLocked.addr, static_cast<ushort>(pData->getSashCycleMotorLockedAlarm()));
    _setModbusRegHoldingValue(modbusRegisterAddress.AlarmStbFanOff.addr, static_cast<ushort>(pData->getAlarmStandbyFanOff()));
    _setModbusRegHoldingValue(modbusRegisterAddress.AlarmFrontPanel.addr, static_cast<ushort>(pData->getFrontPanelAlarm()));
    _setModbusRegHoldingValue(modbusRegisterAddress.AlarmSashDownStuck.addr, static_cast<ushort>(pData->getAlarmSashMotorDownStuck()));

    if(pData->getSeasInstalled()){
        _setModbusRegHoldingValue(modbusRegisterAddress.AlarmExhaustLow.addr, static_cast<ushort>(pData->getAlarmSeasPressureLow()));
    }
    if(pData->getSeasFlapInstalled()){
        _setModbusRegHoldingValue(modbusRegisterAddress.AlarmFlapExhaust.addr, static_cast<ushort>(pData->getSeasFlapAlarmPressure()));
    }

    //    /// CLEAR FLAG OF SASH STATE FLAG
    //    if(m_pSashWindow->isSashStateChanged()){
    //        m_pSashWindow->clearFlagSashStateChanged();
    //    }
}
void MachineBackend::_setSoftwareUpdateAvailable(QString swu, QString path, QJsonObject history)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    qDebug() << sysInfo;

    QSettings settings;
    settings.setValue(SKEY_SBC_SWU_AVAILABLE, true);
    settings.setValue(SKEY_SBC_SWU_VERSION, swu);
    settings.setValue(SKEY_SBC_SWU_PATH, path);

    pData->setSvnUpdateAvailable(true);
    pData->setSvnUpdateSwuVersion(swu);
    pData->setSvnUpdatePath(path);
    pData->setSvnUpdateHistory(history);


    qWarning() << "Software Update available:" << swu << path;
    qWarning() << history;
}

void MachineBackend::_setSoftwareUpdateAvailableReset()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    qDebug() << sysInfo;
    if(!pData->getSvnUpdateAvailable())return;

    QSettings settings;
    settings.setValue(SKEY_SBC_SWU_AVAILABLE, false);

    pData->setSvnUpdateAvailable(false);
}

void MachineBackend::_readResourceMonitorParams()
{
    ///$CPUUSAGE $CPUTEMP $MEMUSAGE
    QString resMonOut = "00 00 00";
    QStringList resMonParams;

#ifdef __linux__
    QProcess qprocess;
    qprocess.start("resmon", QStringList() << "all");
    qprocess.waitForFinished();
    if(!qprocess.exitCode()){
        resMonOut = qprocess.readAllStandardOutput();
    }
#endif
    resMonOut.replace("\n", "");
    for(short i=0; i<resMonOut.split(" ").length(); i++){
        resMonParams.append(resMonOut.split(" ")[i]);
    }

    qDebug() << resMonParams;
    pData->setResourceMonitorParams(resMonParams);
}

QString MachineBackend::_getRpListDefaultValue(short index)
{
    QString retStr = "";
    QJsonObject dbDefault = pData->getRpListDefault();

    if(index < MachineEnums::RPList_SBCSet1Name){
        switch(index){
        case MachineEnums::RPList_UnitModel: retStr = pData->getMachineModelName(); break;
        case MachineEnums::RPList_UnitSerialNumber: retStr = pData->getSerialNumber(); break;
        case MachineEnums::RPList_Date: break;
        case MachineEnums::RPList_Time: break;
        case MachineEnums::RPList_UserManualCode: break;
        case MachineEnums::RPList_UserManualVersion: break;
        case MachineEnums::RPList_ElectricalPanel: break;
        case MachineEnums::RPList_ElectricalPanelSerialNumber: break;
        case MachineEnums::RPList_ElectricalTester: break;
        }
    }
    else if(index >= MachineEnums::RPList_SBCSet1Name && index <= MachineEnums::RPList_SBCSet15Qty){
        bool isName = index < MachineEnums::RPList_SBCSet1Code;
        bool isCode = !isName && (index < MachineEnums::RPList_SBCSet1Qty);
        //bool isQty = !isName && !isCode;
        short startIndex = isName ? MachineEnums::RPList_SBCSet1Name
                                  : (isCode ? MachineEnums::RPList_SBCSet1Code
                                            : MachineEnums::RPList_SBCSet1Qty);
        QString key = isName ? "desc" : (isCode ? "id" : "qty");
        QJsonArray defArray = dbDefault["sbcSet"].toArray();
        if(!defArray[index-startIndex].isUndefined()){
            QJsonObject defObj = defArray[index-startIndex].toObject();
            retStr = defObj[key].toString();
        }//
    }//
    else if(index == MachineEnums::RPList_SBCSet1SN || index == MachineEnums::RPList_SBCSet1SW){
        if(index == MachineEnums::RPList_SBCSet1SN){
            retStr = pData->getSbcSerialNumber();
        }
        else{
            QSettings settings;
            retStr = settings.value(SKEY_SBC_SOFTWARE_VERSION, "").toString();
        }
    }
    else if(index >= MachineEnums::RPList_Sensor1Name && index <= MachineEnums::RPList_Sensor5Qty){
        bool isName = index < MachineEnums::RPList_Sensor1Code;
        bool isCode = !isName && (index < MachineEnums::RPList_Sensor1Qty);
        //bool isQty = !isName && !isCode;
        short startIndex = isName ? MachineEnums::RPList_Sensor1Name
                                  : (isCode ? MachineEnums::RPList_Sensor1Code
                                            : MachineEnums::RPList_Sensor1Qty);
        QString key = isName ? "desc" : (isCode ? "id" : "qty");
        QJsonArray defArray = dbDefault["sensors"].toArray();
        if(!defArray[index-startIndex].isUndefined()){
            QJsonObject defObj = defArray[index-startIndex].toObject();
            retStr = defObj[key].toString();
        }
    }
    else if(index >= MachineEnums::RPList_UVLED1Name && index <= MachineEnums::RPList_UVLED6Qty){
        bool isName = index < MachineEnums::RPList_UVLED1Code;
        bool isCode = !isName && (index < MachineEnums::RPList_UVLED1Qty);
        //bool isQty = !isName && !isCode;
        short startIndex = isName ? MachineEnums::RPList_UVLED1Name
                                  : (isCode ? MachineEnums::RPList_UVLED1Code
                                            : MachineEnums::RPList_UVLED1Qty);
        QString key = isName ? "desc" : (isCode ? "id" : "qty");

        QJsonArray defArray = dbDefault["uvLed"].toArray();
        if(!defArray[index-startIndex].isUndefined()){
            QJsonObject defObj = defArray[index-startIndex].toObject();
            retStr = defObj[key].toString();
        }
    }
    else if(index >= MachineEnums::RPList_PSU1Name && index <= MachineEnums::RPList_PSU5Qty){
        bool isName = index < MachineEnums::RPList_PSU1Code;
        bool isCode = !isName && (index < MachineEnums::RPList_PSU1Qty);
        //bool isQty = !isName && !isCode;
        short startIndex = isName ? MachineEnums::RPList_PSU1Name
                                  : (isCode ? MachineEnums::RPList_PSU1Code
                                            : MachineEnums::RPList_PSU1Qty);
        QString key = isName ? "desc" : (isCode ? "id" : "qty");

        QJsonArray defArray = dbDefault["psu"].toArray();
        if(!defArray[index-startIndex].isUndefined()){
            QJsonObject defObj = defArray[index-startIndex].toObject();
            retStr = defObj[key].toString();
        }
    }
    else if(index >= MachineEnums::RPList_MCBEMI1Name && index <= MachineEnums::RPList_MCBEMI5Qty){
        bool isName = index < MachineEnums::RPList_MCBEMI1Code;
        bool isCode = !isName && (index < MachineEnums::RPList_MCBEMI1Qty);
        //bool isQty = !isName && !isCode;
        short startIndex = isName ? MachineEnums::RPList_MCBEMI1Name
                                  : (isCode ? MachineEnums::RPList_MCBEMI1Code
                                            : MachineEnums::RPList_MCBEMI1Qty);
        QString key = isName ? "desc" : (isCode ? "id" : "qty");

        QJsonArray defArray = dbDefault["mcbEmi"].toArray();
        if(!defArray[index-startIndex].isUndefined()){
            QJsonObject defObj = defArray[index-startIndex].toObject();
            retStr = defObj[key].toString();
        }
    }
    else if(index >= MachineEnums::RPList_ContactSw1Name && index <= MachineEnums::RPList_ContactSw5Qty){
        bool isName = index < MachineEnums::RPList_ContactSw1Code;
        bool isCode = !isName && (index < MachineEnums::RPList_ContactSw1Qty);
        //bool isQty = !isName && !isCode;
        short startIndex = isName ? MachineEnums::RPList_ContactSw1Name
                                  : (isCode ? MachineEnums::RPList_ContactSw1Code
                                            : MachineEnums::RPList_ContactSw1Qty);
        QString key = isName ? "desc" : (isCode ? "id" : "qty");

        QJsonArray defArray = dbDefault["contactSw"].toArray();
        if(!defArray[index-startIndex].isUndefined()){
            QJsonObject defObj = defArray[index-startIndex].toObject();
            retStr = defObj[key].toString();
        }
    }
    else if(index >= MachineEnums::RPList_BMotor1Name && index <= MachineEnums::RPList_BMotor5Qty){
        bool isName = index < MachineEnums::RPList_BMotor1Code;
        bool isCode = !isName && (index < MachineEnums::RPList_BMotor1Qty);
        //bool isQty = !isName && !isCode;
        short startIndex = isName ? MachineEnums::RPList_BMotor1Name
                                  : (isCode ? MachineEnums::RPList_BMotor1Code
                                            : MachineEnums::RPList_BMotor1Qty);
        QString key = isName ? "desc" : (isCode ? "id" : "qty");

        QJsonArray defArray = dbDefault["bMotor"].toArray();
        if(!defArray[index-startIndex].isUndefined()){
            QJsonObject defObj = defArray[index-startIndex].toObject();
            retStr = defObj[key].toString();
        }
    }
    else if(index >= MachineEnums::RPList_CapInd1Name && index <= MachineEnums::RPList_CapInd5Qty){
        bool isName = index < MachineEnums::RPList_CapInd1Code;
        bool isCode = !isName && (index < MachineEnums::RPList_CapInd1Qty);
        //bool isQty = !isName && !isCode;
        short startIndex = isName ? MachineEnums::RPList_CapInd1Name
                                  : (isCode ? MachineEnums::RPList_CapInd1Code
                                            : MachineEnums::RPList_CapInd1Qty);
        QString key = isName ? "desc" : (isCode ? "id" : "qty");

        QJsonArray defArray = dbDefault["capInd"].toArray();
        if(!defArray[index-startIndex].isUndefined()){
            QJsonObject defObj = defArray[index-startIndex].toObject();
            retStr = defObj[key].toString();
        }
    }
    else if(index >= MachineEnums::RPList_Custom1Name && index <= MachineEnums::RPList_Custom8Qty){
        //        bool isName = index < MachineEnums::RPList_Custom1Code;
        //        bool isCode = !isName && (index < MachineEnums::RPList_Custom1Qty);
        //        //bool isQty = !isName && !isCode;
        //        short startIndex = isName ? MachineEnums::RPList_Custom1Name
        //                                  : (isCode ? MachineEnums::RPList_Custom1Code
        //                                            : MachineEnums::RPList_Custom1Qty);
        //        QString key = isName ? "desc" : (isCode ? "id" : "qty");
        //        QJsonArray defArray = dbDefault["custom"].toArray();
        //        if(!defArray[index-startIndex].isUndefined()){
        //            QJsonObject defObj = defArray[index-startIndex].toObject();
        //            retStr = defObj[key].toString();
        //        }
    }
    else if(index >= MachineEnums::RPList_Filter1Name && index <= MachineEnums::RPList_Filter5Qty){
        bool isName = index < MachineEnums::RPList_Filter1Code;
        bool isCode = !isName && (index < MachineEnums::RPList_Filter1Qty);
        //bool isQty = !isName && !isCode;
        short startIndex = isName ? MachineEnums::RPList_Filter1Name
                                  : (isCode ? MachineEnums::RPList_Filter1Code
                                            : MachineEnums::RPList_Filter1Qty);
        QString key = isName ? "desc" : (isCode ? "id" : "qty");

        QJsonArray defArray = dbDefault["filter"].toArray();
        if(!defArray[index-startIndex].isUndefined()){
            QJsonObject defObj = defArray[index-startIndex].toObject();
            retStr = defObj[key].toString();
        }
    }
    return retStr;
}//

//void MachineBackend::_initPreventMaintReminder()
//{
//    QScopedPointer<QSettings> m_settings(new QSettings);
//}//

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

        if(message == QLatin1String("#hdi6#dummy#1")){
            m_pSashWindow->setDummy6StateEnable(true);
        }
        else if(message == QLatin1String("#hdi6#dummy#0")){
            m_pSashWindow->setDummy6StateEnable(false);
        }
        else if(message == QLatin1String("#hdi6#state#0")){
            m_pSashWindow->setDummy6State(0);
        }
        else if(message == QLatin1String("#hdi6#state#1")){
            m_pSashWindow->setDummy6State(1);
        }

        if(message == QLatin1String("#fan#dummy#1")){
            if(pData->getCabinetWidth3Feet()){
                if(pData->getUsePwmOutSignal()){
                    QMetaObject::invokeMethod(m_pFanPrimaryPWM.data(),[&]{
                            m_pFanPrimaryPWM->setDummyStateEnable(1);
                        },
                        Qt::QueuedConnection);
                }else{
                    QMetaObject::invokeMethod(m_pFanPrimaryAO.data(),[&]{
                            m_pFanPrimaryAO->setDummyStateEnable(1);
                        },
                        Qt::QueuedConnection);
                }
            }else{
                QMetaObject::invokeMethod(m_pFanPrimary.data(),[&]{
                        m_pFanPrimary->setDummyStateEnable(1);
                    },
                    Qt::QueuedConnection);
            }
        }
        else if(message == QLatin1String("#fan#dummy#0")){
            if(pData->getCabinetWidth3Feet()){
                if(pData->getUsePwmOutSignal())
                    QMetaObject::invokeMethod(m_pFanPrimaryPWM.data(),[&]{
                            m_pFanPrimaryPWM->setDummyStateEnable(0);
                        },
                        Qt::QueuedConnection);
                else
                    QMetaObject::invokeMethod(m_pFanPrimaryAO.data(),[&]{
                            m_pFanPrimaryAO->setDummyStateEnable(0);
                        },
                        Qt::QueuedConnection);
            }else{
                QMetaObject::invokeMethod(m_pFanPrimary.data(),[&]{
                        m_pFanPrimary->setDummyStateEnable(0);
                    },
                    Qt::QueuedConnection);
            }
        }
        else if(message == QLatin1String("#fanIfa#dummy#1")){
            if(pData->getDualRbmMode()){
                QMetaObject::invokeMethod(m_pFanInflow.data(),[&]{
                        m_pFanInflow->setDummyStateEnable(1);
                    },
                    Qt::QueuedConnection);
            }else{
                if(pData->getUsePwmOutSignal()){
                    QMetaObject::invokeMethod(m_pFanInflowPWM.data(),[&]{
                            m_pFanInflowPWM->setDummyStateEnable(1);
                        },
                        Qt::QueuedConnection);
                }else{
                    QMetaObject::invokeMethod(m_pFanInflowAO.data(),[&]{
                            m_pFanInflowAO->setDummyStateEnable(1);
                        },
                        Qt::QueuedConnection);
                }
            }
        }
        else if(message == QLatin1String("#fanIfa#dummy#0")){
            if(pData->getDualRbmMode()){
                QMetaObject::invokeMethod(m_pFanInflow.data(),[&]{
                        m_pFanInflow->setDummyStateEnable(0);
                    },
                    Qt::QueuedConnection);
            }else{
                if(pData->getUsePwmOutSignal()){
                    QMetaObject::invokeMethod(m_pFanInflowPWM.data(),[&]{
                            m_pFanInflowPWM->setDummyStateEnable(0);
                        },
                        Qt::QueuedConnection);
                }else{
                    QMetaObject::invokeMethod(m_pFanInflowAO.data(),[&]{
                            m_pFanInflowAO->setDummyStateEnable(0);
                        },
                        Qt::QueuedConnection);
                }
            }
        }
        else if(message.contains("#fan#state#")){
            QString adcStr = message.split("#", Qt::SkipEmptyParts)[2];
            int value = std::atoi(adcStr.toStdString().c_str());
            if(pData->getCabinetWidth3Feet()){
                if(pData->getUsePwmOutSignal()){
                    QMetaObject::invokeMethod(m_pFanPrimaryPWM.data(),[&, value]{
                            m_pFanPrimaryPWM->setDummyState(static_cast<short>(value));
                        },
                        Qt::QueuedConnection);
                }else{
                    QMetaObject::invokeMethod(m_pFanPrimaryAO.data(),[&, value]{
                            m_pFanPrimaryAO->setDummyState(static_cast<short>(value));
                        },
                        Qt::QueuedConnection);
                }
            }else{
                QMetaObject::invokeMethod(m_pFanPrimary.data(),[&, value]{
                        m_pFanPrimary->setDummyState(static_cast<short>(value));
                    },
                    Qt::QueuedConnection);
            }//
        }
        else if(message.contains("#fan#rpm#")){
            QString adcStr = message.split("#", Qt::SkipEmptyParts)[2];
            int value = std::atoi(adcStr.toStdString().c_str());
            if(pData->getCabinetWidth3Feet()){
                //                QMetaObject::invokeMethod(m_pFanPrimaryAO.data(),[&, value]{
                //                    m_pFanPrimaryAO->setDummyRpm(value);
                //                },
                //                Qt::QueuedConnection);
            }else{
                QMetaObject::invokeMethod(m_pFanPrimary.data(),[&, value]{
                        m_pFanPrimary->setDummyRpm(value);
                    },
                    Qt::QueuedConnection);
            }
        }

        else if(message.contains("#fanIfa#state#")){
            QString adcStr = message.split("#", Qt::SkipEmptyParts)[2];
            int value = std::atoi(adcStr.toStdString().c_str());
            if(pData->getDualRbmMode()){
                QMetaObject::invokeMethod(m_pFanInflow.data(),[&, value]{
                        m_pFanInflow->setDummyState(static_cast<short>(value));
                    },
                    Qt::QueuedConnection);
            }else{
                if(pData->getUsePwmOutSignal())
                    QMetaObject::invokeMethod(m_pFanInflowPWM.data(),[&, value]{
                            m_pFanInflowPWM->setDummyState(static_cast<short>(value));
                        },
                        Qt::QueuedConnection);
                else
                    QMetaObject::invokeMethod(m_pFanInflowAO.data(),[&, value]{
                            m_pFanInflowAO->setDummyState(static_cast<short>(value));
                        },
                        Qt::QueuedConnection);
            }
        }
        else if(message.contains("#fanIfa#rpm#")){
            QString adcStr = message.split("#", Qt::SkipEmptyParts)[2];
            int value = std::atoi(adcStr.toStdString().c_str());
            if(pData->getDualRbmMode()){
                QMetaObject::invokeMethod(m_pFanInflow.data(),[&, value]{
                        m_pFanInflow->setDummyRpm(value);
                    },
                    Qt::QueuedConnection);
            }/*else{
                QMetaObject::invokeMethod(m_pFanInflowAO.data(),[&, value]{
                    m_pFanInflowAO->setDummyRpm(value);
                },
                Qt::QueuedConnection);
            }*/
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
            //            if(pData->getUsePwmOutSignal())
            //                m_pLightIntensityPWM->setDummyStateEnable(1);
            //            else
            m_pLightIntensity->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#lampdim#dummy#0")){
            //            if(pData->getUsePwmOutSignal())
            //                m_pLightIntensityPWM->setDummyStateEnable(0);
            //            else
            m_pLightIntensity->setDummyStateEnable(0);
        }
        else if(message.contains("#lampdim#state#")){
            QString state = message.split("#", Qt::SkipEmptyParts)[2];
            int dim = std::atoi(state.toStdString().c_str());
            //            if(pData->getUsePwmOutSignal())
            //                m_pLightIntensityPWM->setDummyState(static_cast<short>(dim));
            //            else
            m_pLightIntensity->setDummyState(static_cast<short>(dim));
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

        if(message == QLatin1String("#dfadc#dummy#1")){
            m_pAirflowDownflow->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#dfadc#dummy#0")){
            m_pAirflowDownflow->setDummyStateEnable(0);
        }
        else if(message.contains("#dfadc#state#")){
            QString adcStr = message.split("#", Qt::SkipEmptyParts)[2];
            int adc = std::atoi(adcStr.toStdString().c_str());
            m_pAirflowDownflow->setDummyState(adc);
        }

        if(message == QLatin1String("#sashmotor#dummy#1")){
            m_pSasWindowMotorize->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#sashmotor#dummy#0")){
            m_pSasWindowMotorize->setDummyStateEnable(0);
        }
        else if(message == QLatin1String("#sashmotor#state#0")){
            //qDebug() << "Sash Motor Off in Sash Safe count";
            m_pSasWindowMotorize->setDummyState(MachineEnums::MOTOR_SASH_STATE_OFF);
        }
        else if(message == QLatin1String("#sashmotor#state#1")){
            m_pSasWindowMotorize->setDummyState(MachineEnums::MOTOR_SASH_STATE_UP);
        }
        else if(message == QLatin1String("#sashmotor#state#2")){
            m_pSasWindowMotorize->setDummyState(MachineEnums::MOTOR_SASH_STATE_DOWN);
        }

        if(message == QLatin1String("#sashmotordownstuck#dummy#1")){
            m_dummySashMotorDownStuckSwitchEnabled = true;
        }
        else if(message == QLatin1String("#sashmotordownstuck#dummy#0")){
            m_dummySashMotorDownStuckSwitchEnabled = false;
        }
        else if(message == QLatin1String("#sashmotordownstuck#state#1")){
            if(m_dummySashMotorDownStuckSwitchEnabled){
                pData->setSashMotorDownStuckSwitch(true);
                qDebug() << "setSashMotorDownStuckSwitch" << true;
            }
        }
        else if(message == QLatin1String("#sashmotordownstuck#state#0")){
            if(m_dummySashMotorDownStuckSwitchEnabled){
                pData->setSashMotorDownStuckSwitch(false);
                qDebug() << "setSashMotorDownStuckSwitch" << false;
            }
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
            m_pTemperature->setDummyAdcState(static_cast<short>(value));
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
            m_pSeas->setDummyState(static_cast<short>(value));
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
