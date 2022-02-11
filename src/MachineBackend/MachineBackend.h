#pragma once

#include <QObject>
#include <QScopedPointer>
#include <QJsonArray>
#include <QtDebug>

#ifdef QT_DEBUG
#include <QtWebSockets/QWebSocketServer>
#include <QtWebSockets/QWebSocket>
#endif

class QSettings;
class QThread;
class QTimer;

class QSerialPort;
class QModbusTcpServer;
class QTcpSocket;
class QModbusTcpConnObserverImp;
#include <QModbusDataUnit>
#include <QVector>

class SchedulerDayOutput;

class DataLogSql;
class DataLog;
class AlarmLogSql;
class AlarmLog;
class EventLogSql;
class EventLog;

class ParticleCounter;
class PressureDiffManager;
class BlowerRbmDsi;
class DeviceAnalogCom;
class SashWindow;
class DeviceDigitalOut;
class DevicePWMOut;
class MotorizeOnRelay;
class AirflowVelocity;
class ClosedLoopControl;
class Temperature;
class ClassManager;

class BlowerRegalECM;
class RTCpcf8523;
class LEDpca9633;
class AIManage;
class PWMpca9685;
class DIOpca9674;
class AOmcp4725;
class I2CPort;
class BoardIO;
class QGpioSysfs;
class SensirionSPD8xx;
class ParticleCounterZH03B;

class MachineData;


class MachineBackend : public QObject
{
    Q_OBJECT
public:
    explicit MachineBackend(QObject *parent = nullptr);
    ~MachineBackend();

public slots:
    void routineTask();

    void stop();

    void setMachineData(MachineData* data);

    /// API for general
    void setLcdTouched();

    void setLcdBrightnessLevel(short value);
    void setLcdBrightnessDelayToDimm(short value);
    void saveLcdBrightnessLevel(short value);

    void saveLanguage(const QString value);

    void setTimeZone(const QString value);
    void setDateTime(const QString value);

    void saveTimeClockPeriod(short value);

    void deleteFileOnSystem(const QString path);

    void setMuteVivariumState(short value);
    void setMuteAlarmState(short value);
    void setMuteAlarmTime(short value);

    void setBuzzerState(bool value);
    void setBuzzerBeep();

    void setSignedUser(const QString username, const QString fullname);

    /// API for Cabinet operational
    void setOperationModeSave(short value);
    void setOperationMaintenanceMode();
    void setOperationPreviousMode();

    /// API for Security Access
    void setSecurityAccessModeSave(short value);

    /// API for Certification remainder
    void setDateCertificationRemainder (const QString remainder);

    //    void setCertificationExpired (bool certificationExpired );

    void setMeasurementUnit(short value);

    void setSerialNumber(QString value);

    void setFanState(short value);
    //
    void setFanPrimaryState(short value);
    void setFanPrimaryDutyCycle(short value);
    //
    void setFanPrimaryMaximumDutyCycleFactory(short value);
    void setFanPrimaryMaximumRpmFactory(int value);
    void setFanPrimaryNominalDutyCycleFactory(short value);
    void setFanPrimaryNominalRpmFactory(int value);
    void setFanPrimaryMinimumDutyCycleFactory(short value);
    void setFanPrimaryMinimumRpmFactory(int value);
    void setFanPrimaryStandbyDutyCycleFactory(short value);
    void setFanPrimaryStandbyRpmFactory(int value);
    //
    void setFanPrimaryMaximumDutyCycleField(short value);
    void setFanPrimaryMaximumRpmField(int value);
    void setFanPrimaryNominalDutyCycleField(short value);
    void setFanPrimaryNominalRpmField(int value);
    void setFanPrimaryMinimumDutyCycleField(short value);
    void setFanPrimaryMinimumRpmField(int value);
    void setFanPrimaryStandbyDutyCycleField(short value);
    void setFanPrimaryStandbyRpmField(int value);

    //Added for LA2-EU
    void setFanInflowState(short value);
    void setFanInflowDutyCycle(short value);
    //
    void setFanInflowNominalDutyCycleFactory(short value);
    void setFanInflowNominalRpmFactory(int value);
    void setFanInflowMinimumDutyCycleFactory(short value);
    void setFanInflowMinimumRpmFactory(int value);
    void setFanInflowStandbyDutyCycleFactory(short value);
    void setFanInflowStandbyRpmFactory(int value);
    //
    void setFanInflowNominalDutyCycleField(short value);
    void setFanInflowNominalRpmField(int value);
    void setFanInflowMinimumDutyCycleField(short value);
    void setFanInflowMinimumRpmField(int value);
    void setFanInflowStandbyDutyCycleField(short value);
    void setFanInflowStandbyRpmField(int value);

    void setLightIntensity(short lightIntensity);
    void saveLightIntensity(short lightIntensity);

    void setLightState(short lightState);

    void setSocketInstalled(short value);
    void setSocketState(short socketState);

    void setGasInstalled(short value);
    void setGasState(short gasState);

    void setUvInstalled(short value);
    void setUvState(short uvState);
    void setUvTimeSave(int minutes);

    void setWarmingUpTimeSave(short seconds);
    void setPostPurgeTimeSave(short seconds);

    void setExhaustContactState(short exhaustContactState);

    void setAlarmContactState(short alarmContactState);

    void setSashMotorizeInstalled(short value);
    void setSashMotorizeState(short value);

    void setSeasFlapInstalled(short value);

    void setSeasBuiltInInstalled(short value);
    void setSeasPressureDiffPaLowLimit(int value);
    void setSeasPressureDiffPaOffset(int value);

    //////////
    void setAirflowMonitorEnable(bool airflowMonitorEnable);

    //INFLOW
    void setInflowSensorConstantTemporary(short value);
    //
    void setInflowSensorConstant(short value);
    void setInflowTemperatureCalib(short value, int adc);
    //
    void setInflowAdcPointFactory(int pointZero, int pointMin, int pointNom);
    void setInflowAdcPointFactory(int point, int value);
    void setInflowVelocityPointFactory(int pointZero, int pointMin, int pointNom);
    void setInflowVelocityPointFactory(int point, int value);
    //
    void setInflowAdcPointField(int pointZero, int pointMin, int pointNom);
    void setInflowAdcPointField(int point, int value);
    void setInflowVelocityPointField(int pointZero, int pointMin, int pointNom);
    void setInflowVelocityPointField(int point, int value);
    //
    void setInflowLowLimitVelocity(short value);
    //
    void saveInflowMeaDimNominalGrid(const QJsonArray grid,
                                     int total, int average,
                                     int volume, int velocity,
                                     int ducy, int rpm,
                                     int fullField = 0);
    void saveInflowMeaDimMinimumGrid(const QJsonArray grid,
                                     int total, int average,
                                     int volume, int velocity,
                                     int ducy, int rpm);
    void saveInflowMeaDimStandbyGrid(const QJsonArray grid,
                                     int total, int average,
                                     int volume, int velocity,
                                     int ducy, int rpm);
    //
    void saveInflowMeaSecNominalGrid(const QJsonArray grid,
                                     int total, int average,
                                     int velocity, int ducy, int rpm);
    ///
    //DOWNFLOW
    void setDownflowSensorConstantTemporary(short value);
    //
    void setDownflowSensorConstant(short value);
    void setDownflowTemperatureCalib(short value, int adc);
    void setDownflowAdcPointFactory(int pointZero, int pointMin, int pointNom, int pointMax);
    void setDownflowAdcPointFactory(int point, int value);
    void setDownflowVelocityPointFactory(int pointZero, int pointMin, int pointNom, int pointMax);
    void setDownflowVelocityPointFactory(int point, int value);
    //
    void setDownflowAdcPointField(int pointZero, int pointMin, int pointNom, int pointMax);
    void setDownflowAdcPointField(int point, int value);
    void setDownflowVelocityPointField(int pointZero, int pointMin, int pointNom, int pointMax);
    void setDownflowVelocityPointField(int point, int value);
    //
    void setDownflowLowLimitVelocity(short value);
    void setDownflowHighLimitVelocity(short value);
    //
    void saveDownflowMeaNominalGrid(const QJsonArray grid, int total,
                                    int velocity,
                                    int velocityLowest, int velocityHighest,
                                    int deviation, int deviationp,
                                    int ducy, int rpm, int fullField = 0);
    void saveDownflowMeaMinimumGrid(const QJsonArray grid, int total,
                                    int velocity,
                                    int velocityLowest, int velocityHighest,
                                    int deviation, int deviationp,
                                    int ducy, int rpm);
    void saveDownflowMeaMaximumGrid(const QJsonArray grid, int total,
                                    int velocity,
                                    int velocityLowest, int velocityHighest,
                                    int deviation, int deviationp,
                                    int ducy, int rpm);
    //
    void initAirflowCalibrationStatus(short value);

    /// DATALOG
    void setDataLogEnable(bool dataLogEnable);
    void setDataLogRunning(bool dataLogRunning);
    void setDataLogPeriod(short dataLogPeriod);
    void setDataLogCount(int dataLogCount);

    /// MODBUS
    void setModbusSlaveID(short slaveId);
    void setModbusAllowingIpMaster(const QString ipAddr);
    void setModbusAllowSetFan(bool value);
    void setModbusAllowSetLight(bool value);
    void setModbusAllowSetLightIntensity(bool value);
    void setModbusAllowSetSocket(bool value);
    void setModbusAllowSetGas(bool value);
    void setModbusAllowSetUvLight(bool value);
    /// Dont use for nomal function
    bool _callbackOnModbusConnectionStatusChanged(QTcpSocket* newClient);

    void insertEventLog(const QString eventText);
    ///
    void refreshLogRowsCount(const QString table);

    /// UV AUTO SET
    /// ON
    void setUVAutoEnabled(int uvAutoSetEnabled);
    void setUVAutoTime(int uvAutoSetTime);
    void setUVAutoDayRepeat(int uvAutoSetDayRepeat);
    void setUVAutoWeeklyDay(int uvAutoSetWeeklyDay);
    /// OFF
    void setUVAutoEnabledOff(int uvAutoSetEnabledOff);
    void setUVAutoTimeOff(int uvAutoSetTimeOff);
    void setUVAutoDayRepeatOff(int uvAutoSetDayRepeatOff);
    void setUVAutoWeeklyDayOff(int uvAutoSetWeeklyDayOff);

    /// FAN AUTO SET
    /// ON
    void setFanAutoEnabled(int fanAutoSetEnabled);
    void setFanAutoTime(int fanAutoSetTime);
    void setFanAutoDayRepeat(int fanAutoSetDayRepeat);
    void setFanAutoWeeklyDay(int fanAutoSetWeeklyDay);
    /// OFF
    void setFanAutoEnabledOff(int fanAutoSetEnabledOff);
    void setFanAutoTimeOff(int fanAutoSetTimeOff);
    void setFanAutoDayRepeatOff(int fanAutoSetDayRepeatOff);
    void setFanAutoWeeklyDayOff(int fanAutoSetWeeklyDayOff);

    /// ESCO LOCK SERVICE
    void setEscoLockServiceEnable(int escoLockServiceEnable);

    /// CABINET DISPLAY NAME
    void setCabinetDisplayName(const QString cabinetDisplayName);

    /// CABINET FAN PIN
    void setFanPIN(const QString fanPIN);

    /// FAN USAGE
    void setFanPrimaryUsageMeter(int minutes);
    void setFanInflowUsageMeter(int minutes);

    /// UV USAGE
    void setUvUsageMeter(int minutes);

    /// FILTER USAGE
    void setFilterUsageMeter(int minutes);

    /// SASH CYCLE METER
    void setSashCycleMeter(int sashCycleMeter);

    /// Sensor Environtmental Temperature Limitation
    void setEnvTempHighestLimit(int envTempHighestLimit);
    void setEnvTempLowestLimit(int envTempLowestLimit);

    /// Particle Counter
    void setParticleCounterSensorInstalled(bool particleCounterSensorInstalled);

    void setWatchdogResetterState(bool state);

    void setShippingModeEnable(bool shippingModeEnable);

    void setCurrentSystemAsKnown(bool value);

    void readSbcCurrentFullMacAddress();

    void setFanClosedLoopControlEnable(bool value);
    void setFanClosedLoopControlEnablePrevState(bool value);
    void setFanClosedLoopSamplingTime(int value);
    void setFanClosedLoopGainIntegralDfa(float value);
    void setFanClosedLoopGainProportionalDfa(float value);
    void setFanClosedLoopGainDerivativeDfa(float value);
    void setFanClosedLoopGainIntegralIfa(float value);
    void setFanClosedLoopGainProportionalIfa(float value);
    void setFanClosedLoopGainDerivativeIfa(float value);

    void setReadClosedLoopResponse(bool value);

    /// FRONT PANEL SWITCH LA2EU
    void setFrontPanelSwitchInstalled(bool value);
    /// Set FAN RBM Address
    void scanRbmComPortAvalaible(bool value);
    void setRbmComPortDfa(QString value);
    void setRbmComPortIfa(QString value);

    void setSashMotorOffDelayMsec(int value);

    void setDelayAlarmAirflowSec(int value);

signals:
    void hasStopped();

    void loopStarted();
    void timerEventWorkerStarted();

private:
    MachineData*    pData;

    void setup();
    void loop();
    void deallocate();

    bool m_stop = false;
    bool m_loopStarterTaskExecute = false;
    bool m_deallocatting = false;

    /// Board IO
    QScopedPointer<QThread>         m_threadForBoardIO;
    QScopedPointer<QTimer>          m_timerEventForBoardIO;
    ///
    QScopedPointer<BoardIO>         m_boardIO;
    QScopedPointer<I2CPort>         m_i2cPort;

    /// CTP
    QScopedPointer<RTCpcf8523>      m_boardCtpRTC;
    QScopedPointer<LEDpca9633>      m_boardCtpIO;
    /// Digital Input
    QScopedPointer<DIOpca9674>      m_boardDigitalInput1;
    /// Digital Swith / PWM
    QScopedPointer<PWMpca9685>      m_boardRelay1;
    /// PWM Output
    //    QScopedPointer<PWMpca9685>      m_boardPWMOut;
    /// HAB - Analog Input (Inflow & Temperature)
    QScopedPointer<AIManage>        m_boardAnalogInput1;
    /// HAB - Analog Output
    QScopedPointer<AOmcp4725>       m_boardAnalogOutput1;//Light Intensity
    /// HAB - Analog Output FAN Inflow
    QScopedPointer<AOmcp4725>       m_boardAnalogOutput2;//Fan Inflow Duty Cycle
    /// AI - Analog Input (Downflow)
    QScopedPointer<AIManage>        m_boardAnalogInput2;

    /// Implementation
    QScopedPointer<SashWindow>          m_pSashWindow;
    QScopedPointer<DeviceAnalogCom>     m_pLightIntensity;
    QScopedPointer<DeviceDigitalOut>    m_pLight;
    QScopedPointer<DeviceDigitalOut>    m_pSocket;
    QScopedPointer<DeviceDigitalOut>    m_pGas;
    QScopedPointer<DeviceDigitalOut>    m_pUV;
    QScopedPointer<MotorizeOnRelay>     m_pSasWindowMotorize;
    QScopedPointer<DeviceDigitalOut>    m_pExhaustContact;
    QScopedPointer<DeviceDigitalOut>    m_pAlarmContact;
    ///
    //    QScopedPointer<DevicePWMOut>    m_pLightIntensity2;
    //    QScopedPointer<DevicePWMOut>    m_pFanInflow2;
    ///
    QScopedPointer<Temperature>     m_pTemperature;
    QScopedPointer<AirflowVelocity> m_pAirflowInflow;
    QScopedPointer<AirflowVelocity> m_pAirflowDownflow;
    ////
    //QScopedPointer<QTimer>    m_timerEventForSashMotorInterlockSwitch;
    QScopedPointer<QTimer>      m_timerEventForSashWindowRoutine;
    void _onTriggeredEventSashWindowRoutine();
    ///
    QScopedPointer<ClosedLoopControl> m_pIfaFanClosedLoopControl;
    QScopedPointer<ClosedLoopControl> m_pDfaFanClosedLoopControl;
    QScopedPointer<QTimer>           m_timerEventForClosedLoopControl;
    void _onTriggeredEventClosedLoopControl();
    ///
    QScopedPointer<QGpioSysfs>      m_pBuzzer;
    ///
    QScopedPointer<SensirionSPD8xx>     m_boardSensirionSPD8xx;
    QScopedPointer<PressureDiffManager> m_pSeas;

    /// Fan Primary & Fan Inflow
    QScopedPointer<QThread>         m_threadForFanRbmDsi;
    QScopedPointer<QTimer>          m_timerEventForFanRbmDsi;
    QScopedPointer<QThread>         m_threadForFanRbmDsi2;
    QScopedPointer<QTimer>          m_timerEventForFanRbmDsi2;
    ///
    QScopedPointer<DeviceAnalogCom> m_pFanInflow;
    QScopedPointer<BlowerRbmDsi>    m_pFanPrimary;
    QScopedPointer<BlowerRbmDsi>    m_pFanInflow2;
    QScopedPointer<BlowerRegalECM>  m_boardRegalECM;
    QScopedPointer<BlowerRegalECM>  m_boardRegalECM2;
    ///
    QScopedPointer<QSerialPort>     m_serialPort1;
    QScopedPointer<QSerialPort>     m_serialPort12;

    /// Particle Counter
    QScopedPointer<QThread>         m_threadForParticleCounter;
    QScopedPointer<QTimer>          m_timerEventForParticleCounter;
    ///
    QScopedPointer<ParticleCounter>      m_pParticleCounter;
    QScopedPointer<ParticleCounterZH03B> m_boardParticleCounterZH03B;
    ///
    QScopedPointer<QSerialPort>     m_serialPort2;

    /// More Objects
    QScopedPointer<QTimer> m_timerEventForLcdToDimm;
    QScopedPointer<QTimer> m_timerEventForBuzzerBeep;
    QScopedPointer<QTimer> m_timerEventForRTCWatchdogReset;

    QScopedPointer<QTimer> m_timerEventEvery50MSecond;
    QScopedPointer<QTimer> m_timerEventEverySecond;
    QScopedPointer<QTimer> m_timerEventEveryMinute;
    QScopedPointer<QTimer> m_timerEventEveryMinute2;
    QScopedPointer<QTimer> m_timerEventEveryHour;

    void _onTriggeredEventEvery50MSecond();
    void _onTriggeredEventEverySecond();
    void _onTriggeredEventEveryMinute();
    void _onTriggeredEventEveryMinute2();
    void _onTriggeredEventEveryHour();

    ///DATA LOG
    QScopedPointer<QThread>     m_threadForDatalog;
    QScopedPointer<QTimer>      m_timerEventForDataLog;
    QScopedPointer<DataLog>     m_pDataLog;
    QScopedPointer<DataLogSql>  m_pDataLogSql;

    ///ALARM LOG
    QScopedPointer<QThread>      m_threadForAlarmLog;
    QScopedPointer<AlarmLog>     m_pAlarmLog;
    QScopedPointer<AlarmLogSql>  m_pAlarmLogSql;

    ///EVENT LOG
    QScopedPointer<QThread>      m_threadForEventLog;
    QScopedPointer<EventLog>     m_pEventLog;
    QScopedPointer<EventLogSql>  m_pEventLogSql;

    /// OUTPUT AUTO SET
    /// UV SCHEDULER
    QScopedPointer<SchedulerDayOutput> m_uvSchedulerAutoSet;
    void _onTriggeredUvSchedulerAutoSet();
    QScopedPointer<SchedulerDayOutput> m_uvSchedulerAutoSetOff;
    void _onTriggeredUvSchedulerAutoSetOff();
    /// FAN SCHEDULER
    QScopedPointer<SchedulerDayOutput> m_fanSchedulerAutoSet;
    void _onTriggeredFanSchedulerAutoSet();
    QScopedPointer<SchedulerDayOutput> m_fanSchedulerAutoSetOff;
    void _onTriggeredFanSchedulerAutoSetOff();

    /// MODBUS
    QModbusTcpServer                            *m_pModbusServer;
    QModbusTcpConnObserverImp                   *m_pModbusTcpConnObserver;
    QScopedPointer<QVector<uint16_t>>            m_modbusDataUnitBufferRegisterHolding;
    void _onModbusDataWritten(QModbusDataUnit::RegisterType table, int address, int size);
    void _modbusCommandHandler(int address, uint16_t value);
    void _setModbusRegHoldingValue(int addr, uint16_t value);

    /// Backup previus operation mode
    short m_operationPrevMode = 0;

    short m_securityAccessPrevMode = 0;

    void _insertDataLog();
    void _insertAlarmLog(int alarmCode, const QString alarmText);
    void _insertEventLog(const QString logText);

    //    void _setFanDownflowDutyCycle(short value);

    void _setFanInflowStateNominal();
    void _setFanInflowStateMinimum();
    void _setFanInflowStateStandby();
    void _setFanInflowStateOFF();
    void _setFanInflowDutyCycle(short dutyCycle);
    void _setFanInflowInterlocked(bool interlocked);

    void _setFanPrimaryStateNominal();
    void _setFanPrimaryStateMinimum();
    void _setFanPrimaryStateStandby();
    void _setFanPrimaryStateOFF();
    void _setFanPrimaryDutyCycle(short dutyCycle);
    void _setFanPrimaryInterlocked(bool interlocked);

    void _wakeupLcdBrightnessLevel();

    void _setTimeZoneLinux(const QString value);
    void _setDateTimeLinux(const QString value);

    QString _readMacAddress();
    QStringList _readSbcSystemInformation();
    QString _readSbcSerialNumber();
    void _setSbcSystemInformation(QStringList sysInfo);
    void _setSbcCurrentSystemInformation(QStringList sysInfo);
    void _setSbcSerialNumber(QString value);
    //    void _setWifiDisabled(bool value);

    void _initAirflowCalibartionFactory();
    void _initAirflowCalibartionField();

    void _onFanPrimaryActualDucyChanged(short value);
    void _onFanPrimaryActualRpmChanged(int value);
    void _onFanInflowActualDucyChanged(short value);
    void _onFanInflowActualRpmChanged(int value);

    void _onSashStateChanged(short prevState, short state);
    void _onLightStateChanged(short state);
    void _onSocketStateChanged(short state);
    void _onGasStateChanged(short state);
    void _onUVStateChanged(short state);

    void _onTemperatureActualChanged(double value);
    void _onInflowVelocityActualChanged(int value);
    void _onDownflowVelocityActualChanged(int value);
    //void _calculteDownflowVelocity(int value);

    void _onSeasPressureDiffPaChanged(int value);

    void _onParticleCounterPM1_0Changed(int pm1_0);
    void _onParticleCounterPM2_5Changed(int pm2_5);
    void _onParticleCounterPM10Changed(int pm10);
    void _onParticleCounterSensorFanStateChanged(int state);

    void _onTimerEventLcdDimm();

    void _startWarmingUpTime();
    void _cancelWarmingUpTime();
    void _onTimerEventWarmingUp();

    void _startPostPurgingTime();
    void _cancelPostPurgingTime();
    void _onTimerEventPostPurging();

    void _startUVTime();
    void _cancelUVTime();
    void _onTimerEventUVTimeCountdown();

    void _startUVLifeMeter();
    void _stopUVLifeMeter();
    void _onTimerEventUVLifeCalculate();

    void _startFanFilterLifeMeter();
    void _stopFanFilterLifeMeter();
    void _onTimerEventFanFilterUsageMeterCalculate();

    void _startPowerOutageCapture();
    void _cancelPowerOutageCapture();
    void _onTimerEventPowerOutageCaptureTime();

    void _startMuteAlarmTimer();
    void _cancelMuteAlarmTimer();
    void _onTimerEventMuteAlarmTimer();

    void _readRTCActualTime();

    double __convertCfmToLs(double value);
    double __convertLsToCfm(double value);
    double __convertFpmToMps(double value);
    double __convertMpsToFpm(double value);
    double __toFixedDecPoint(double value, short point);
    int __convertCtoF(int c);
    int __convertFtoC(int f);
    double __convertPa2inWG(int pa);
    int __getPercentFrom(int val, int ref);

    bool isMaintenanceModeActive() const;

    bool isAirflowHasCalibrated() const;

    bool isTempAmbientNormal() const;
    bool isTempAmbientLow() const;
    bool isTempAmbientHigh() const;

    bool isFanStateDifferent() const;
    bool isFanStateNominal() const;
    bool isFanStateStandby() const;

    bool isAlarmActive(short alarm) const;
    bool isAlarmNormal(short alarm) const;
    bool isAlarmNA(short alarm) const;

    bool isTempAmbNormal(short value) const;
    bool isTempAmbLow(short value) const;
    bool isTempAmbHigh(short value) const;

    void _checkCertificationReminder();
    void _checkFrontPanelAlarm();

    void _machineState();

    QString m_signedUsername;
    QString m_signedFullname;

    QTimer* eventTimerForDelaySafeHeightAction = nullptr;
    int  m_sashSafeAutoOnOutputDelayTimeMsec = 100; /// 100ms //original 3 seconds

    QTimer* eventTimerForDelayMotorizedOffAtFullyClosed = nullptr;
    //int  m_sashMotorizedOffAtFullyClosedDelayTimeMsec = 500; /// 500ms for 6 feet /// 700ms for 4 feet
    bool  m_delaySashMotorFullyClosedExecuted = false;
    uchar m_counter = 0;
    bool m_scanRbmComPortAvailable = false;
    bool m_dummySashMotorDownStuckSwitchEnabled = false;
    bool m_dummySashMotorDownStuckSwitchState = false;
    bool m_eventLoopSashMotorActive = false;
    short m_eventLoopCounter = 0;
    short m_delaySashMotorUpAfterStucked = 1500; /// 1500ms for 6ft /// 1000ms for 4ft
    bool m_sashMovedDown = false;
    //    bool m_alarmAirflowFailInterlocked = false;

    int m_alarmInflowLowDelayCountdown = 0;
    int m_alarmDownflowLowDelayCountdown = 0;
    int m_alarmDownflowHighDelayCountdown = 0;
    bool m_alarmInflowLowDelaySet = false;
    bool m_alarmDownflowLowDelaySet = false;
    bool m_alarmDownflowHighDelaySet = false;

#ifdef QT_DEBUG
    QScopedPointer<QWebSocketServer> m_pWebSocketServerDummyState;
    QList<QWebSocket *> m_clientsDummyState;
    void onDummyStateNewConnection();
#endif

    //    void _onExhPressureActualPaChanged(int newVal);
};

