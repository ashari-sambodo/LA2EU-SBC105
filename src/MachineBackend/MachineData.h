#pragma once

#include <QObject>
#include <QJsonObject>

class QQmlEngine;
class QJSEngine;

class MachineData;

class MachineData : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int count
               READ getCount
               //               WRITE setDataCount
               NOTIFY countChanged)

    Q_PROPERTY(int machineState
               READ getMachineBackendState
               //               WRITE setDataWorkerState
               NOTIFY machineStateChanged)

    Q_PROPERTY(bool hasStopped
               READ getHasStopped
               //               WRITE setHasStopped
               NOTIFY hasStoppedChanged)

    Q_PROPERTY(short sashWindowState
               READ getSashWindowState
               //               WRITE setSashWindowState
               NOTIFY sashWindowStateChanged)

    /// Magnetic Switch
    Q_PROPERTY(bool magSW1State
               READ getMagSW1State
               //               WRITE setMagSW1State
               NOTIFY magSWStateChanged)

    Q_PROPERTY(bool magSW2State
               READ getMagSW2State
               //               WRITE setMagSW2State
               NOTIFY magSWStateChanged)

    Q_PROPERTY(bool magSW3State
               READ getMagSW3State
               //               WRITE setMagSW3State
               NOTIFY magSWStateChanged)

    Q_PROPERTY(bool magSW4State
               READ getMagSW4State
               //               WRITE setMagSW4State
               NOTIFY magSWStateChanged)

    Q_PROPERTY(bool magSW5State
               READ getMagSW5State
               //               WRITE setMagSW5State
               NOTIFY magSWStateChanged)

    Q_PROPERTY(bool magSW6State
               READ getMagSW6State
               //               WRITE setMagSW6State
               NOTIFY magSWStateChanged)

    //// FAN
    Q_PROPERTY(short fanState
               READ getFanState
               //               WRITE setFanState
               NOTIFY fanStateChanged)
    //// FAN DOWNFLOW
    Q_PROPERTY(bool fanPrimaryInterlocked
               READ getFanPrimaryInterlocked
               //               WRITE setFanPrimaryInterlocked
               NOTIFY fanPrimaryInterlockedChanged)
    Q_PROPERTY(short fanPrimaryState
               READ getFanPrimaryState
               //               WRITE setFanPrimaryState
               NOTIFY fanPrimaryStateChanged)

    Q_PROPERTY(short fanPrimaryDutyCycle
               READ getFanPrimaryDutyCycle
               //               WRITE setFanPrimaryDutyCycle
               NOTIFY fanPrimaryDutyCycleChanged)

    Q_PROPERTY(int fanPrimaryRpm
               READ getFanPrimaryRpm
               //               WRITE setFanPrimaryRpm
               NOTIFY fanPrimaryRpmChanged)

    //// FAN INFLOW
    Q_PROPERTY(bool fanInflowInterlocked
               READ getFanInflowInterlocked
               //               WRITE setFanInflowInterlocked
               NOTIFY fanInflowInterlockedChanged)
    Q_PROPERTY(short fanInflowState
               READ getFanInflowState
               //               WRITE setFanInflowState
               NOTIFY fanInflowStateChanged)
    Q_PROPERTY(short fanInflowDutyCycle
               READ getFanInflowDutyCycle
               //               WRITE setFanInflowDutyCycle
               NOTIFY fanInflowDutyCycleChanged)
    Q_PROPERTY(int fanInflowRpm
               READ getFanInflowRpm
               //               WRITE setFanInflowRpm
               NOTIFY fanInflowRpmChanged)

    ///Fan Auto Set
    Q_PROPERTY(int      fanAutoSetEnabled
               READ     getFanAutoEnabled
               //               WRITE    setFanAutoEnabled
               NOTIFY   fanAutoEnabledChanged)
    Q_PROPERTY(int      fanAutoSetTime
               READ     getFanAutoTime
               //               WRITE    setFanAutoTime
               NOTIFY   fanAutoTimeChanged)
    Q_PROPERTY(int      fanAutoSetDayRepeat
               READ     getFanAutoDayRepeat
               //               WRITE    setFanAutoDayRepeat
               NOTIFY   fanAutoDayRepeatChanged)
    Q_PROPERTY(int      fanAutoSetWeeklyDay
               READ     getFanAutoWeeklyDay
               //               WRITE    setFanAutoWeeklyDay
               NOTIFY   fanAutoWeeklyDayChanged)

    ////LIGHT
    Q_PROPERTY(short lightState
               READ getLightState
               //               WRITE setLightState
               NOTIFY lightStateChanged)
    Q_PROPERTY(bool lightInterlocked
               READ getLightInterlocked
               //               WRITE setLightInterlocked
               NOTIFY lightInterlockedChanged)
    Q_PROPERTY(short lightIntensity
               READ getLightIntensity
               //               WRITE setLightIntensity
               NOTIFY lightIntensityChanged)

    ///SOCKET
    Q_PROPERTY(short socketState
               READ getSocketState
               //               WRITE setSocketState
               NOTIFY socketStateChanged)
    Q_PROPERTY(bool socketInterlocked
               READ getSocketInterlocked
               //               WRITE setSocketInterlocked
               NOTIFY socketInterlockedChanged)
    Q_PROPERTY(bool socketInstalled
               READ getSocketInstalled
               //               WRITE setSocketInstalled
               NOTIFY socketInstalledChanged)

    ///GAS
    Q_PROPERTY(short gasState
               READ getGasState
               //               WRITE setGasState
               NOTIFY gasStateChanged)
    Q_PROPERTY(bool gasInterlocked
               READ getGasInterlocked
               //               WRITE setGasInterlocked
               NOTIFY gasInterlockedChanged)
    Q_PROPERTY(bool gasInstalled
               READ getGasInstalled
               //               WRITE setGasInstalled
               NOTIFY gasInstalledChanged)

    ///UV
    Q_PROPERTY(short uvState
               READ getUvState
               //               WRITE setUvState
               NOTIFY uvStateChanged)
    Q_PROPERTY(bool uvInterlocked
               READ getUvInterlocked
               //               WRITE setUvInterlocked
               NOTIFY uvInterlockedChanged)
    Q_PROPERTY(bool uvInstalled
               READ getUvInstalled
               //               WRITE setUvInstalled
               NOTIFY uvInstalledChanged)

    ///UV Auto Set
    Q_PROPERTY(int      uvAutoSetEnabled
               READ     getUVAutoEnabled
               //               WRITE    setUVAutoEnabled
               NOTIFY   uvAutoEnabledChanged)
    Q_PROPERTY(int      uvAutoSetTime
               READ     getUVAutoTime
               //               WRITE    setUVAutoTime
               NOTIFY   uvAutoTimeChanged)
    Q_PROPERTY(int      uvAutoSetDayRepeat
               READ     getUVAutoDayRepeat
               //               WRITE    setUVAutoDayRepeat
               NOTIFY   uvAutoDayRepeatChanged)
    Q_PROPERTY(int      uvAutoSetWeeklyDay
               READ     getUVAutoWeeklyDay
               //               WRITE    setUVAutoWeeklyDay
               NOTIFY   uvAutoWeeklyDayChanged)

    /// SEAS BOARD FLAP
    Q_PROPERTY(bool seasFlapInstalled
               READ getSeasFlapInstalled
               //               WRITE setSeasBoardInstalled
               NOTIFY seasFlapInstalledChanged)
    Q_PROPERTY(short seasFlapAlarmPressure
               READ getSeasFlapAlarmPressure
               //               WRITE setSeasFlapAlarmPressure
               NOTIFY seasFlapAlarmPressureChanged)

    /// SEAS INTEGRATED
    Q_PROPERTY(bool seasInstalled
               READ getSeasInstalled
               //               WRITE setSeasInstalled
               NOTIFY seasInstalledChanged)
    Q_PROPERTY(int seasPressureDiffPa
               READ getSeasPressureDiffPa
               //               WRITE setSeasPressureDiffPa
               NOTIFY seasPressureDiffPaChanged)
    Q_PROPERTY(int seasPressureDiff
               READ getSeasPressureDiff
               //               WRITE setSeasPressureDiff
               NOTIFY seasPressureDiffChanged)
    Q_PROPERTY(QString seasPressureDiffStr
               READ getSeasPressureDiffStr
               //               WRITE setSeasPressureDiffStr
               NOTIFY seasPressureDiffStrChanged)
    Q_PROPERTY(int seasPressureDiffPaLowLimit
               READ getSeasPressureDiffPaLowLimit
               //               WRITE setSeasPressureDiffPaLowLimit
               NOTIFY seasPressureDiffPaLowLimitChanged)
    Q_PROPERTY(short seasAlarmPressureLow
               READ getAlarmSeasPressureLow
               //               WRITE setSeasAlarmPressureLow
               NOTIFY seasAlarmPressureLowChanged)
    Q_PROPERTY(short seasPressureDiffPaOffset
               READ getSeasPressureDiffPaOffset
               //               WRITE setSeasPressureDiffPaOffset
               NOTIFY seasPressureDiffPaOffsetChanged)

    ///UV TIME
    Q_PROPERTY(bool uvTimeActive
               READ getUvTimeActive
               //               WRITE setUvTimeActive
               NOTIFY uvTimeActiveChanged)
    ///
    Q_PROPERTY(int uvTime
               READ getUvTime
               //               WRITE setUvTime
               NOTIFY uvTimeChanged)
    ///
    Q_PROPERTY(int uvTimeCountdown
               READ getUvTimeCountdown
               //               WRITE setUvTimeCountdown
               NOTIFY uvTimeCountdownChanged)
    /// UV Life
    Q_PROPERTY(int uvLifeMinutes
               READ getUvLifeMinutes
               //               WRITE setUvLifeMinutes
               NOTIFY uvLifeMinutesChanged)
    ///
    Q_PROPERTY(short uvLifePercent
               READ getUvLifePercent
               //               WRITE setUvLifePercent
               NOTIFY uvLifePercentChanged)

    /// Filter Life
    Q_PROPERTY(int filterLifeMinutes
               READ getFilterLifeMinutes
               //               WRITE setFilterLifeMinutes
               NOTIFY filterLifeMinutesChanged)
    ///
    Q_PROPERTY(short filterLifePercent
               READ getFilterLifePercent
               //               WRITE setFilterLifePercent
               NOTIFY filterLifePercentChanged)

    /// Blower Meter
    Q_PROPERTY(int fanPrimaryUsageMeter
               READ getFanPrimaryUsageMeter
               //               WRITE setFanPrimaryUsageMeter
               NOTIFY fanPrimaryUsageMeterChanged)
    Q_PROPERTY(int fanInflowUsageMeter
               READ getFanInflowUsageMeter
               //               WRITE setFanInflowUsageMeter
               NOTIFY fanInflowUsageMeterChanged)

    ///ALARM
    Q_PROPERTY(short muteAlarmState
               READ getMuteAlarmState
               //               WRITE setMuteAlarmState
               NOTIFY muteAlarmStateChanged)
    Q_PROPERTY(int muteAlarmTime
               READ getMuteAlarmTime
               //               WRITE setMuteAlarmTime
               NOTIFY muteAlarmTimeChanged)
    Q_PROPERTY(int muteAlarmCountdown
               READ getMuteAlarmCountdown
               //               WRITE setMuteAlarmCountdown
               NOTIFY muteAlarmCountdownChanged)

    ///MOTORIZE
    Q_PROPERTY(short sashWindowMotorizeState
               READ getSashWindowMotorizeState
               //               WRITE setSashMotorizeState
               NOTIFY sashWindowMotorizeStateChanged)
    ///
    Q_PROPERTY(bool sashWindowMotorizeUpInterlocked
               READ getSashWindowMotorizeUpInterlocked
               //               WRITE setSashWindowMotorizeUpInterlocked
               NOTIFY sashWindowMotorizeUpInterlockedChanged)
    ///
    Q_PROPERTY(bool sashWindowMotorizeDownInterlocked
               READ getSashWindowMotorizeDownInterlocked
               //               WRITE setSashWindowMotorizeDownInterlocked
               NOTIFY sashWindowMotorizeDownInterlockedChanged)
    ///
    Q_PROPERTY(bool sashWindowMotorizeInstalled
               READ getSashWindowMotorizeInstalled
               //               WRITE setSashWindowMotorizeInstalled
               NOTIFY sashWindowMotorizeInstalledChanged)

    ///EXHAUST_FREE_RELAY_CONTACT
    Q_PROPERTY(short exhaustContactState
               READ getExhaustContactState
               //               WRITE setMuteAlarmState
               NOTIFY exhaustContactStateChanged)

    ///EXHAUST_ALAM_RELAY_CONTACT
    Q_PROPERTY(short alarmContactState
               READ getAlarmContactState
               //               WRITE setSashMotorizeState
               NOTIFY alarmContactStateChanged)

    ///ALARM
    Q_PROPERTY(bool alarmsState
               READ getAlarmsState
               //               WRITE setAlarmsState
               NOTIFY alarmsStateChanged)
    ///BOARD COMMUNICATION
    Q_PROPERTY(short alarmBoardComError
               READ getAlarmBoardComError
               //               WRITE setBoardComError
               NOTIFY alarmBoardComErrorChanged)
    ///
    Q_PROPERTY(short alarmSash
               READ getAlarmSash
               //               WRITE setAlarmSash
               NOTIFY alarmSashChanged)
    ///
    Q_PROPERTY(short alarmInflowLow
               READ getAlarmInflowLow
               //               WRITE setAlarmInflowLow
               NOTIFY alarmInflowLowChanged)
    ///
    Q_PROPERTY(short alarmTempHigh
               READ getAlarmTempHigh
               //               WRITE setAlarmTempHigh
               NOTIFY alarmTempHighChanged)
    ///
    Q_PROPERTY(short alarmTempLow
               READ getAlarmTempLow
               //               WRITE setAlarmTempLow
               NOTIFY alarmTempLowChanged)

    // Temperature
    Q_PROPERTY(int temperatureAdc
               READ     getTemperatureAdc
               //               WRITE    setTemperatureAdc
               NOTIFY   temperatureAdcChanged)
    //
    Q_PROPERTY(short temperatureCelcius
               READ     getTemperatureCelcius
               //               WRITE    setTemperatureCelcius
               NOTIFY   temperatureAdcChanged)
    //
    Q_PROPERTY(short temperature
               READ     getTemperature
               //               WRITE    setTemperature
               NOTIFY   temperatureChanged)
    //
    Q_PROPERTY(QString temperatureValueStr
               READ     getTemperatureValueStrf
               //               WRITE    setTemperatureValueStr
               NOTIFY   temperatureValueStrfChanged)
    ///
    Q_PROPERTY(short tempAmbientStatus
               READ getTempAmbientStatus
               //               WRITE setTempAmbientStatus
               NOTIFY tempAmbientStatusChanged)

    ///POWER OUTAGE
    Q_PROPERTY(bool powerOutage
               READ getPowerOutage
               WRITE setPowerOutage
               NOTIFY powerOutageChanged)
    Q_PROPERTY(QString powerOutageTime
               READ getPowerOutageTime
               //               WRITE setPowerOutageTime
               NOTIFY powerOutageTimeChanged)
    Q_PROPERTY(QString powerOutageRecoverTime
               READ getPowerOutageRecoverTime
               //               WRITE setPowerOutageRecoverTime
               NOTIFY powerOutageRecoverTimeChanged)
    Q_PROPERTY(short powerOutageFanState
               READ getPowerOutageFanState
               //               WRITE setPowerOutageFanState
               NOTIFY powerOutageFanStateChanged)
    //    Q_PROPERTY(short powerOutageLightState
    //               READ getPowerOutageLightState
    //               //               WRITE setPowerOutageLightState
    //               NOTIFY powerOutageLightStateChanged)
    Q_PROPERTY(short powerOutageUvState
               READ getPowerOutageUvState
               //               WRITE setPowerOutageUvState
               NOTIFY powerOutageUvStateChanged)

    //AIRFLOW MONITOR
    Q_PROPERTY(bool      airflowMonitorEnable
               READ     getAirflowMonitorEnable
               //               WRITE    setAirflowMonitorEnable
               NOTIFY   airflowMonitorEnableChanged)

    //AIRFLOW INFLOW
    Q_PROPERTY(int ifaVelocity
               READ getInflowVelocity
               //               WRITE setIfaVelocity
               NOTIFY ifaVelocityChanged)

    Q_PROPERTY(int      ifaAdc
               READ     getInflowAdc
               //               WRITE    setInflowAdc
               NOTIFY   ifaAdcChanged)

    Q_PROPERTY(int      ifaAdcConpensation
               READ     getInflowAdcConpensation
               //               WRITE    setInflowAdcConpensation
               NOTIFY   ifaAdcConpensationChanged)

    Q_PROPERTY(QString  ifaVelocityStr
               READ     getInflowVelocityStr
               //               WRITE    setInflowVelocityStr
               NOTIFY   ifaVelocityStrChanged)

    //AIRFLOW DOWNFLOW
    Q_PROPERTY(int dfaVelocity
               READ getInflowVelocity
               //               WRITE setIfaVelocity
               NOTIFY dfaVelocityChanged)

    Q_PROPERTY(int      dfaAdc
               READ     getInflowAdc
               //               WRITE    setInflowAdc
               NOTIFY   dfaAdcChanged)

    Q_PROPERTY(int      dfaAdcConpensation
               READ     getInflowAdcConpensation
               //               WRITE    setInflowAdcConpensation
               NOTIFY   dfaAdcConpensationChanged)

    Q_PROPERTY(QString  dfaVelocityStr
               READ     getInflowVelocityStr
               //               WRITE    setInflowVelocityStr
               NOTIFY   dfaVelocityStrChanged)

    //AIRFLOW CALIBRATION STATUS
    Q_PROPERTY(short inflowCalibrationStatus
               READ     getInflowCalibrationStatus
               //               WRITE    setInflowCalibrationMode
               NOTIFY   inflowCalibrationStatusChanged)

    Q_PROPERTY(short downflowCalibrationStatus
               READ     getDownflowCalibrationStatus
               //               WRITE    setDownflowCalibrationMode
               NOTIFY   downflowCalibrationStatusChanged)

    Q_PROPERTY(short airflowCalibrationStatus
               READ     getAirflowCalibrationStatus
               //               WRITE    setAirflowCalibrationMode
               NOTIFY   airflowCalibrationStatusChanged)


    ///WARMING UP
    Q_PROPERTY(bool warmingUpActive
               READ getWarmingUpActive
               //               WRITE setWarmingUpRunning
               NOTIFY warmingUpActiveChanged)
    ///
    Q_PROPERTY(int warmingUpTime
               READ getWarmingUpTime
               //               WRITE setWarmingUpTime
               NOTIFY warmingUpTimeChanged)
    ///
    Q_PROPERTY(int warmingUpCountdown
               READ getWarmingUpCountdown
               //               WRITE setWarmingUpCountdown
               NOTIFY warmingUpCountdownChanged)

    ///POST PURGING
    Q_PROPERTY(bool postPurgingActive
               READ getPostPurgingActive
               //               WRITE setPostPurgingRunning
               NOTIFY postPurgingActiveChanged)
    ///
    Q_PROPERTY(int postPurgingTime
               READ getPostPurgingTime
               //               WRITE setPostPurgingTime
               NOTIFY postPurgingTimeChanged)
    ///
    Q_PROPERTY(int postPurgingCountdown
               READ getPostPurgingCountdown
               //               WRITE setPostPurgingCountdown
               NOTIFY postPurgingCountdownChanged)

    /// Measurement Unit
    Q_PROPERTY(short    measurementUnit
               READ     getMeasurementUnit
               //               WRITE    setMeasurementUnit
               NOTIFY   measurementUnitChanged)

    /// Operation Mode
    Q_PROPERTY(short operationMode
               READ getOperationMode
               //               WRITE setOperationMode
               NOTIFY operationModeChanged)

    /// Security Access
    Q_PROPERTY(short securityAccessMode
               READ getSecurityAccessMode
               //                              WRITE setSecurityAccessMode
               NOTIFY securityAccessChanged)

    /// Certification remainder date
    Q_PROPERTY(QString dateCertificationRemainder
               READ getDateCertificationRemainder
               //               WRITE setDateCertificationRemainder
               NOTIFY dateCertificationRemainderChanged)
    Q_PROPERTY(bool certificationExpired
               READ getCertificationExpired
               //               WRITE setCertificationExpired
               NOTIFY certificationExpiredChanged)
    Q_PROPERTY(int certificationExpiredCount
               READ getCertificationExpiredCount
               //               WRITE setCertificationExpiredCount
               NOTIFY certificationExpiredCountChanged)
    Q_PROPERTY(bool certificationExpiredValid
               READ getCertificationExpiredValid
               //               WRITE setCertificationExpiredValid
               NOTIFY certificationExpiredValidChanged)

    /// Serial Number
    Q_PROPERTY(QString serialNumber
               READ getSerialNumber
               WRITE setSerialNumber
               NOTIFY serialNumberChanged)

    /// LCD
    Q_PROPERTY(short lcdBrightnessLevel
               READ getLcdBrightnessLevel
               //               WRITE setLcdBrightness
               NOTIFY lcdBrightnessLevelChanged)

    Q_PROPERTY(short lcdBrightnessLevelUser
               READ getLcdBrightnessLevelUser
               //               WRITE setLcdBrightnessUser
               NOTIFY lcdBrightnessLevelUserChanged)

    Q_PROPERTY(bool lcdBrightnessLevelDimmed
               READ getLcdBrightnessLevelDimmed
               //               WRITE setLcdBrightnessLevelDimmed
               NOTIFY lcdBrightnessLevelDimmedChanged)

    Q_PROPERTY(short lcdBrightnessDelayToDimm
               READ getLcdBrightnessDelayToDimm
               //               WRITE setLcdBrightnessDelayToDimm
               NOTIFY lcdBrightnessDelayToDimmChanged)

    /// language
    Q_PROPERTY(QString language
               READ getLanguage
               //               WRITE setLanguage
               NOTIFY languageChanged)

    /// TimeZone
    /// example value: Asia/Jakarta#7#UTC+07:00
    Q_PROPERTY(QString timeZone
               READ getTimeZone
               //               WRITE setTimeZone
               NOTIFY timeZoneChanged)

    /// Time Period
    /// 12 = 12h
    /// 24 = 24h
    Q_PROPERTY(short timeClockPeriod
               READ getTimeClockPeriod
               //               WRITE setTimeClockPeriod
               NOTIFY timeClockPeriodChanged)

    /// Data Log
    Q_PROPERTY(short dataLogPeriod
               READ getDataLogPeriod
               //               WRITE setDataLogPeriod
               NOTIFY dataLogPeriodChanged)

    Q_PROPERTY(bool dataLogRunning
               READ getDataLogRunning
               //               WRITE setDataLogRunning
               NOTIFY dataLogRunningChanged)

    Q_PROPERTY(bool dataLogEnable
               READ getDataLogEnable
               //               WRITE setDataLogEnable
               NOTIFY dataLogEnableChanged)

    /// maximum rows using integer is 2M+
    /// 1 Years = 525960 Minutes (rows)
    /// 10 Years = 5259600 Minutes (rows)
    Q_PROPERTY(int dataLogCount
               READ getDataLogCount
               //               WRITE setDataLogCount
               NOTIFY dataLogCountChanged)
    Q_PROPERTY(bool dataLogIsFull
               READ getDataLogIsFull
               //               WRITE setDataLogIsFull
               NOTIFY dataLogIsFullChanged)
    Q_PROPERTY(int dataLogSpaceMaximum
               READ getDataLogSpaceMaximum
               //               WRITE setDataLogSpaceMaximum
               NOTIFY dataLogSpaceMaximumChanged)

    /// ALARM LOG
    /// maximum rows using integer is 2M+ / 32 bit
    /// 10 Years = 315569520 rows, if 1 alarm 1 second
    Q_PROPERTY(int alarmLogCount
               READ getAlarmLogCount
               //               WRITE setAlarmLogCount
               NOTIFY alarmLogCountChanged)
    Q_PROPERTY(bool alarmLogIsFull
               READ getAlarmLogIsFull
               //               WRITE setAlarmLogIsFull
               NOTIFY alarmLogIsFullChanged)
    Q_PROPERTY(int alarmLogSpaceMaximum
               READ getAlarmLogSpaceMaximum
               //               WRITE setAlarmLogSpaceMaximum
               NOTIFY alarmLogSpaceMaximumChanged)

    /// EVENT LOG
    /// maximum rows using integer is 2M+ / 32 bit
    /// 10 Years = 315569520 rows, if 1 alarm 1 second
    Q_PROPERTY(int eventLogCount
               READ getEventLogCount
               //               WRITE setEventLogCount
               NOTIFY eventLogCountChanged)
    Q_PROPERTY(bool eventLogIsFull
               READ getEventLogIsFull
               //               WRITE setEventLogIsFull
               NOTIFY eventLogIsFullChanged)
    Q_PROPERTY(int eventLogSpaceMaximum
               READ getEventLogSpaceMaximum
               //               WRITE setEventLogSpaceMaximum
               NOTIFY eventLogSpaceMaximumChanged)

    ///MODBUS
    Q_PROPERTY(short modbusSlaveID
               READ getModbusSlaveID
               WRITE setModbusSlaveID
               NOTIFY modbusSlaveIDChanged)
    ///
    Q_PROPERTY(QString modbusAllowIpMaster
               READ getModbusAllowIpMaster
               //               WRITE setModbusAllowIpMaster
               NOTIFY modbusAllowIpMasterChanged)
    ///
    Q_PROPERTY(bool modbusAllowSetFan
               READ getModbusAllowSetFan
               //               WRITE setModbusAllowSetFan
               NOTIFY modbusAllowSetFanChanged)
    ///
    Q_PROPERTY(bool modbusAllowSetLight
               READ getModbusAllowSetLight
               //               WRITE setModbusAllowSetLight
               NOTIFY modbusAllowSetLightChanged)
    ///
    Q_PROPERTY(bool modbusAllowSetLightIntensity
               READ getModbusAllowSetLightIntensity
               //               WRITE setModbusAllowSetLightIntensity
               NOTIFY modbusAllowSetLightIntensityChanged)
    ///
    Q_PROPERTY(bool modbusAllowSetSocket
               READ getModbusAllowSetSocket
               //               WRITE setModbusAllowSetSocket
               NOTIFY modbusAllowSetSocketChanged)
    ///
    Q_PROPERTY(bool modbusAllowSetGas
               READ getModbusAllowSetGas
               //               WRITE setModbusAllowGasSet
               NOTIFY modbusAllowGasSetChanged)
    ///
    Q_PROPERTY(bool modbusAllowSetUvLight
               READ getModbusAllowSetUvLight
               //               WRITE setModbusAllowSetUvLight
               NOTIFY modbusAllowSetUvLightChanged)
    ///
    Q_PROPERTY(QString modbusLatestStatus
               READ getModbusLatestStatus
               //               WRITE setModbusLatestStatus
               NOTIFY modbusLatestStatusChanged)

    ////
    Q_PROPERTY(QString machineClassName
               READ getMachineClassName
               WRITE setMachineClassName
               NOTIFY machineClassNameChanged)
    ////
    Q_PROPERTY(QString machineModelName
               READ getMachineModelName
               WRITE setMachineModelName
               NOTIFY machineModelNameChanged)
    ////
    Q_PROPERTY(QJsonObject machineProfile
               READ getMachineProfile
               WRITE setMachineProfile
               NOTIFY machineProfileChanged)
    ///
    Q_PROPERTY(QString cabinetDisplayName
               READ getCabinetDisplayName
               //               WRITE setCabinetDisplayName
               NOTIFY cabinetDisplayNameChanged)

    /// Board Status
    Q_PROPERTY(bool boardStatusHybridDigitalRelay
               READ getBoardStatusHybridDigitalRelay
               //               WRITE setBoardStatusHybridDigitalRelay
               NOTIFY boardStatusHybridDigitalRelayChanged)

    Q_PROPERTY(bool boardStatusHybridDigitalInput
               READ getBoardStatusHybridDigitalInput
               //               WRITE setBoardStatusHybridDigitalInput
               NOTIFY boardStatusHybridDigitalInputChanged)

    Q_PROPERTY(bool boardStatusHybridAnalogInput
               READ getBoardStatusHybridAnalogInput
               //               WRITE setBoardStatusHybridAnalogInput
               NOTIFY boardStatusHybridAnalogInputChanged)

    Q_PROPERTY(bool boardStatusAnalogInput
               READ getBoardStatusAnalogInput
               //               WRITE setBoardStatusHybridAnalogInput
               NOTIFY boardStatusAnalogInputChanged)

    Q_PROPERTY(bool boardStatusHybridAnalogOutput
               READ getBoardStatusHybridAnalogOutput
               //               WRITE setBoardStatusHybridAnalogOutput
               NOTIFY boardStatusHybridAnalogOutputChanged)

    Q_PROPERTY(bool boardStatusRbmCom
               READ getBoardStatusRbmCom
               //               WRITE setBoardStatusRbmCom
               NOTIFY boardStatusRbmComChanged)

    Q_PROPERTY(bool boardStatusPressureDiff
               READ getBoardStatusPressureDiff
               //               WRITE setBoardStatusPressureDiff
               NOTIFY boardStatusPressureDiffChanged)

    Q_PROPERTY(bool boardStatusCtpRtc
               READ getBoardStatusCtpRtc
               //               WRITE setBoardStatusCtpRtc
               NOTIFY boardStatusCtpRtcChanged)

    Q_PROPERTY(bool boardStatusCtpIoe
               READ getBoardStatusCtpIoe
               //               WRITE setBoardStatusCtpIoe
               NOTIFY boardStatusCtpIoeChanged)

    Q_PROPERTY(int escoLockServiceEnable
               READ getEscoLockServiceEnable
               //               WRITE setEscoLockServiceEnable
               NOTIFY escoLockServiceEnableChanged)

    Q_PROPERTY(QString fanPIN
               READ getFanPIN
               //               WRITE setFanPIN
               NOTIFY fanPINChanged)

    Q_PROPERTY(int sashCycleMeter
               READ getSashCycleMeter
               //               WRITE setSashCycleMeter
               NOTIFY sashCycleMeterChanged)

    Q_PROPERTY(int envTempLowestLimit
               READ getEnvTempLowestLimit
               //               WRITE setEnvTempLowestLimit
               NOTIFY envTempLowestLimitChanged)

    Q_PROPERTY(int envTempHighestLimit
               READ getEnvTempHighestLimit
               //               WRITE setEnvTempHighestLimit
               NOTIFY envTempHighestLimitChanged)

    /// PARTICLE COUNTER
    Q_PROPERTY(int particleCounterPM2_5
               READ getParticleCounterPM2_5
               //               WRITE setParticleCounterPM2_5
               NOTIFY particleCounterPM2_5Changed)

    Q_PROPERTY(int particleCounterPM1_0
               READ getParticleCounterPM1_0
               //               WRITE setParticleCounterPM1_0
               NOTIFY particleCounterPM1_0Changed)

    Q_PROPERTY(int particleCounterPM10
               READ getParticleCounterPM10
               //               WRITE setParticleCounterPM10
               NOTIFY particleCounterPM10Changed)

    Q_PROPERTY(short particleCounterSensorFanState
               READ getParticleCounterSensorFanState
               //               WRITE setParticleCounterSensorFanState
               NOTIFY particleCounterSensorFanStateChanged)

    Q_PROPERTY(bool particleCounterSensorInstalled
               READ getParticleCounterSensorInstalled
               //               WRITE setParticleCounterSensorInstalled
               NOTIFY particleCounterSensorInstalledChanged)

    /// VIVARIUM MUTE
    Q_PROPERTY(bool vivariumMuteState
               READ getVivariumMuteState
               //               WRITE setVivariumMuteState
               NOTIFY vivariumMuteStateChanged)

    /// RTC_WATCHDOG
    Q_PROPERTY(int watchdogCounter
               READ getWatchdogCounter
               //               WRITE setWatchdogCounter
               NOTIFY watchdogCounterChanged)
    Q_PROPERTY(QString rtcActualDate
               READ getRtcActualDate
               //               WRITE setRtcActualDate
               NOTIFY rtcActualDateChanged)
    Q_PROPERTY(QString rtcActualTime
               READ getRtcActualTime
               //               WRITE setRtcActualTime
               NOTIFY rtcActualTimeChanged)

    /// SHIPPING MODE
    Q_PROPERTY(bool shippingModeEnable
               READ getShippingModeEnable
               //               WRITE setShippingModeEnable
               NOTIFY shippingModeEnableChanged)




public:
    static QObject *singletonProvider(QQmlEngine *qmlEngine, QJSEngine *);
    static void singletonDelete();

    explicit MachineData(QObject *parent = nullptr);
    ~MachineData() override;

    Q_INVOKABLE short getMachineBackendState() const;
    void setMachineBackendState(short getMachineBackendState);

    int getCount() const;
    void setCount(int count);

    bool getHasStopped() const;
    void setHasStopped(bool hasStopped);

    ///CONTROL STATE

    ///SASH
    short getSashWindowState() const;
    void setSashWindowState(short sashWindowState);

    ///FAN
    short getFanState() const;
    void setFanState(short fanState);
    /// FAN DOWNFLOW
    short getFanPrimaryState() const;
    void setFanPrimaryState(short fanPrimaryState);
    ///
    bool getFanPrimaryInterlocked() const;
    void setFanPrimaryInterlocked(short fanPrimaryInterlocked);
    //
    short getFanInflowState() const;
    void setFanInflowState(short fanInflowState);
    ///
    bool getFanInflowInterlocked() const;
    void setFanInflowInterlocked(short fanInflowInterlocked);
    //
    ///LIGHT
    void setLightInterlocked(bool lightInterlocked);
    bool getLightInterlocked() const;
    ///
    short getLightState() const;
    void setLightState(short lightState);
    ///
    short getLightIntensity() const;
    void setLightIntensity(short lightIntensity);

    ///SOCKET
    void setSocketInterlocked(bool socketInterlocked);
    bool getSocketInterlocked() const;
    ///
    short getSocketState() const;
    void setSocketState(short socketState);
    ///
    bool getSocketInstalled() const;
    void setSocketInstalled(bool socketInstalled);

    ///GAS
    bool getGasInterlocked() const;
    void setGasInterlocked(bool gasInterlocked);
    ///
    short getGasState() const;
    void setGasState(short gasState);
    ///
    bool getGasInstalled() const;
    void setGasInstalled(bool gasInstalled);

    ///UV
    bool getUvInterlocked() const;
    void setUvInterlocked(bool uvInterlocked);
    ///
    short getUvState() const;
    void setUvState(short uvState);
    ///
    bool getUvInstalled() const;
    void setUvInstalled(bool uvInstalled);
    /// UV TIME
    bool getUvTimeActive() const;
    void setUvTimeActive(bool uvTimeActive);
    ///
    int getUvTime() const;
    void setUvTime(int uvTime);
    ///
    int getUvTimeCountdown() const;
    void setUvTimeCountdown(int uvTimeCountdown);
    ///UV LIFE
    int getUvLifeMinutes() const;
    void setUvLifeMinutes(int uvLifeMinutes);
    ///
    short getUvLifePercent() const;
    void setUvLifePercent(short uvLifePercent);

    //// SASH-MOTORIZE
    short getSashWindowMotorizeState() const;
    void setSashWindowMotorizeState(short sashMotorizeState);
    ////
    bool getSashWindowMotorizeUpInterlocked() const;
    void setSashWindowMotorizeUpInterlocked(bool sashWindowMotorizeUpInterlocked);
    ////
    bool getSashWindowMotorizeDownInterlocked() const;
    void setSashWindowMotorizeDownInterlocked(bool sashWindowMotorizeDownInterlocked);
    ////
    bool getSashWindowMotorizeInstalled() const;
    void setSashWindowMotorizeInstalled(bool sashWindowMotorizeInstalled);

    ///FREE-RELAY-CONTACT
    short getExhaustContactState() const;
    void setExhaustContactState(short exhaustContactState);
    ///
    short getAlarmContactState() const;
    void setAlarmContactState(short alarmContactState);

    ///MUTE ALARM
    short getMuteAlarmState() const;
    void setMuteAlarmState(short muteAlarmState);
    ///
    int getMuteAlarmTime() const;
    void setMuteAlarmTime(int muteAlarmTime);
    ///
    int getMuteAlarmCountdown() const;
    void setMuteAlarmCountdown(int muteAlarmCountdown);

    ///ALARM
    bool getAlarmsState() const;
    void setAlarmsState(bool alarmsState);
    ///
    short getAlarmBoardComError() const;
    void setAlarmBoardComError(short alarmBoardComError);
    ///
    short getAlarmInflowLow() const;
    void setAlarmInflowLow(short alarmInflowLow);
    ///
    short getAlarmSash() const;
    void setAlarmSash(short alarmSash);
    ///
    //    void setAlarmDownfLow(bool alarmDownflowLow);
    //    void setAlarmDownfHigh(bool alarmDownflowHigh);
    short getAlarmTempHigh() const;
    void setAlarmTempHigh(short alarmTempHigh);
    ///
    short getAlarmTempLow() const;
    void setAlarmTempLow(short alarmTempLow);

    //TEMPERATURE
    int getTemperatureAdc() const;
    short getTemperatureCelcius() const;
    short getTemperature() const;
    QString getTemperatureValueStrf() const;
    //
    void setTemperatureAdc(int temperatureAdc);
    void setTemperatureCelcius(short temperatureCelcius);
    void setTemperature(short temperature);
    void setTemperatureValueStrf(QString temperatureValueStrf);
    //
    short getTempAmbientStatus() const;
    void setTempAmbientStatus(short tempAmbientStatus);

    //MEASUREMENT UNIT
    short getMeasurementUnit() const;
    void setMeasurementUnit(short measurementUnit);
    //
    short getMeasurementUnitDuringCalib() const;
    void setMeasurementUnitDuringCalib(short measurementUnitDuringCalib);

    //FAN
    Q_INVOKABLE short   getFanPrimaryDutyCycle() const;
    Q_INVOKABLE int     getFanPrimaryRpm() const;
    //
    //    Q_INVOKABLE int     getFanDownflowDutyCycle() const;
    //
    Q_INVOKABLE short   getFanPrimaryMaximumlDutyCycle() const;
    Q_INVOKABLE int     getFanPrimaryMaximumRpm() const;
    Q_INVOKABLE short   getFanPrimaryNominalDutyCycle() const;
    Q_INVOKABLE int     getFanPrimaryNominalRpm() const;
    Q_INVOKABLE short   getFanPrimaryMinimumDutyCycle() const;
    Q_INVOKABLE int     getFanPrimaryMinimumRpm() const;
    Q_INVOKABLE short   getFanPrimaryStandbyDutyCycle() const;
    Q_INVOKABLE int     getFanPrimaryStandbyRpm() const;
    //
    Q_INVOKABLE short   getFanPrimaryMaximumDutyCycleFactory() const;
    Q_INVOKABLE int     getFanPrimaryMaximumRpmFactory() const;
    Q_INVOKABLE short   getFanPrimaryMaximumDutyCycleField() const;
    Q_INVOKABLE int     getFanPrimaryMaximumRpmField() const;
    //
    Q_INVOKABLE short   getFanPrimaryNominalDutyCycleFactory() const;
    Q_INVOKABLE int     getFanPrimaryNominalRpmFactory() const;
    Q_INVOKABLE short   getFanPrimaryNominalDutyCycleField() const;
    Q_INVOKABLE int     getFanPrimaryNominalRpmField() const;
    //
    Q_INVOKABLE short   getFanPrimaryMinimumDutyCycleFactory() const;
    Q_INVOKABLE int     getFanPrimaryMinimumRpmFactory() const;
    Q_INVOKABLE short   getFanPrimaryMinimumDutyCycleField() const;
    Q_INVOKABLE int     getFanPrimaryMinimumRpmField() const;
    //
    Q_INVOKABLE short   getFanPrimaryStandbyDutyCycleFactory() const;
    Q_INVOKABLE int     getFanPrimaryStandbyRpmFactory() const;
    Q_INVOKABLE short   getFanPrimaryStandbyDutyCycleField() const;
    Q_INVOKABLE int     getFanPrimaryStandbyRpmField() const;
    //
    void    setFanPrimaryDutyCycle(short value);
    void    setFanPrimaryRpm(int value);
    //
    void    setFanPrimaryMaximumDutyCycle(short value);
    void    setFanPrimaryMaximumRpm(short value);
    void    setFanPrimaryNominalDutyCycle(short value);
    void    setFanPrimaryNominalRpm(short value);
    void    setFanPrimaryMinimumDutyCycle(short value);
    void    setFanPrimaryMinimumRpm(short value);
    void    setFanPrimaryStandbyDutyCycle(short value);
    void    setFanPrimaryStandbyRpm(int fanPrimaryStandbyRpm);
    //
    void    setFanPrimaryMaximumDutyCycleFactory(short fanPrimaryMaximumDutyCycleFactory);
    void    setFanPrimaryMaximumRpmFactory(int fanPrimaryMaximumRpmFactory);
    void    setFanPrimaryMaximumDutyCycleField(short fanPrimaryMaximumDutyCycleField);
    void    setFanPrimaryMaximumRpmField(int fanPrimaryMaximumRpmField);
    //
    void    setFanPrimaryNominalDutyCycleFactory(short fanPrimaryNominalDutyCycleFactory);
    void    setFanPrimaryNominalRpmFactory(int fanPrimaryNominalRpmFactory);
    void    setFanPrimaryNominalDutyCycleField(short fanPrimaryNominalDutyCycleField);
    void    setFanPrimaryNominalRpmField(int fanPrimaryNominalRpmField);
    //
    void    setFanPrimaryMinimumDutyCycleFactory(short fanPrimaryMinimumDutyCycleFactory);
    void    setFanPrimaryMinimumRpmFactory(int fanPrimaryMinimumRpmFactory);
    void    setFanPrimaryMinimumDutyCycleField(short fanPrimaryMinimumDutyCycleField);
    void    setFanPrimaryMinimumRpmField(int fanPrimaryMinimumRpmField);
    //
    void    setFanPrimaryStandbyDutyCycleFactory(short fanPrimaryStandbyDutyCycleFactory);
    void    setFanPrimaryStandbyRpmFactory(int fanPrimaryStandbyRpmFactory);
    void    setFanPrimaryStandbyDutyCycleField(short fanPrimaryStandbyDutyCycleField);
    void    setFanPrimaryStandbyRpmField(int fanPrimaryStandbyRpmField);

    ////Added for LA2-EU
    //FAN INFLOW
    Q_INVOKABLE short   getFanInflowDutyCycle() const;
    Q_INVOKABLE int     getFanInflowRpm() const;
    //
    Q_INVOKABLE short   getFanInflowNominalDutyCycle() const;
    Q_INVOKABLE int     getFanInflowNominalRpm() const;
    Q_INVOKABLE short   getFanInflowMinimumDutyCycle() const;
    Q_INVOKABLE int     getFanInflowMinimumRpm() const;
    Q_INVOKABLE short   getFanInflowStandbyDutyCycle() const;
    Q_INVOKABLE int     getFanInflowStandbyRpm() const;
    //
    Q_INVOKABLE short   getFanInflowNominalDutyCycleFactory() const;
    Q_INVOKABLE int     getFanInflowNominalRpmFactory() const;
    Q_INVOKABLE short   getFanInflowNominalDutyCycleField() const;
    Q_INVOKABLE int     getFanInflowNominalRpmField() const;
    //
    Q_INVOKABLE short   getFanInflowMinimumDutyCycleFactory() const;
    Q_INVOKABLE int     getFanInflowMinimumRpmFactory() const;
    Q_INVOKABLE short   getFanInflowMinimumDutyCycleField() const;
    Q_INVOKABLE int     getFanInflowMinimumRpmField() const;
    //
    Q_INVOKABLE short   getFanInflowStandbyDutyCycleFactory() const;
    Q_INVOKABLE int     getFanInflowStandbyRpmFactory() const;
    Q_INVOKABLE short   getFanInflowStandbyDutyCycleField() const;
    Q_INVOKABLE int     getFanInflowStandbyRpmField() const;
    //Added for LA2-EU
    void    setFanInflowDutyCycle(short value);
    void    setFanInflowRpm(int value);
    //
    void    setFanInflowNominalDutyCycle(short value);
    void    setFanInflowNominalRpm(short value);
    void    setFanInflowMinimumDutyCycle(short value);
    void    setFanInflowMinimumRpm(short value);
    void    setFanInflowStandbyDutyCycle(short value);
    void    setFanInflowStandbyRpm(int fanInflowStandbyRpm);
    //
    void    setFanInflowNominalDutyCycleFactory(short fanInflowNominalDutyCycleFactory);
    void    setFanInflowNominalRpmFactory(int fanInflowNominalRpmFactory);
    void    setFanInflowNominalDutyCycleField(short fanInflowNominalDutyCycleField);
    void    setFanInflowNominalRpmField(int fanInflowNominalRpmField);
    //
    void    setFanInflowMinimumDutyCycleFactory(short fanInflowMinimumDutyCycleFactory);
    void    setFanInflowMinimumRpmFactory(int fanInflowMinimumRpmFactory);
    void    setFanInflowMinimumDutyCycleField(short fanInflowMinimumDutyCycleField);
    void    setFanInflowMinimumRpmField(int fanInflowMinimumRpmField);
    //
    void    setFanInflowStandbyDutyCycleFactory(short fanInflowStandbyDutyCycleFactory);
    void    setFanInflowStandbyRpmFactory(int fanInflowStandbyRpmFactory);
    //
    void    setFanInflowStandbyDutyCycleField(short fanInflowStandbyDutyCycleField);
    void    setFanInflowStandbyRpmField(int fanInflowStandbyRpmField);

    // Magenetic Swtich for Sash Windows
    void setMagSWState(short index, bool value);
    bool getMagSW1State() const;
    bool getMagSW2State() const;
    bool getMagSW3State() const;
    bool getMagSW4State() const;
    bool getMagSW5State() const;
    bool getMagSW6State() const;

    //MACHINE ID
    QJsonObject getMachineProfile() const;
    QString getMachineProfileName() const;
    QString getMachineModelName() const;
    QString getMachineClassName() const;
    void setMachineProfile(QJsonObject machineProfile);
    void setMachineProfileName(QString machineProfile);
    void setMachineModelName(QString machineModelName);
    void setMachineClassName(QString machineClassName);

    //LCD BRIGHTNESS
    short getLcdBrightnessLevelUser() const;
    short getLcdBrightnessLevel() const;
    short getLcdBrightnessDelayToDimm() const;
    bool getLcdBrightnessLevelDimmed() const;
    ///
    void setLcdBrightnessLevelUser(short lcdBrightnessLevelUser);
    void setLcdBrightnessLevel(short lcdBrightnessLevel);
    void setLcdBrightnessDelayToDimm(short lcdBrightnessDelayToDimm);
    void setLcdBrightnessLevelDimmed(bool lcdBrightnessLevelDimmed);

    //LANGUAGE
    QString getLanguage() const;
    void setLanguage(QString language);

    //TIMEZONE
    QString getTimeZone() const;
    void    setTimeZone(QString timeZone);
    short   getTimeClockPeriod() const;
    void    setTimeClockPeriod(short timeClockPeriod);

    //AIRFLOW MONITOR
    bool getAirflowMonitorEnable() const;
    void setAirflowMonitorEnable(bool airflowMonitorEnable);

    //AIRFLOW INFLOW
    int     getInflowVelocity() const;
    int     getInflowAdc() const;
    int     getInflowAdcConpensation() const;
    QString getInflowVelocityStr() const;
    //
    Q_INVOKABLE int getInflowLowLimitVelocity() const;
    Q_INVOKABLE short getInflowSensorConstant();
    Q_INVOKABLE int getInflowTempCalib();
    Q_INVOKABLE int getInflowTempCalibAdc();
    Q_INVOKABLE int getInflowAdcPointFactory(short point);
    Q_INVOKABLE int getInflowVelocityPointFactory(short point);
    Q_INVOKABLE int getInflowAdcPointField(short point);
    Q_INVOKABLE int getInflowVelocityPointField(short point);
    //
    void    setInflowVelocity(int ifaVelocity);
    void    setInflowAdc(int ifaAdc);
    void    setInflowAdcConpensation(int ifaAdcConpensation);
    void    setInflowVelocityStr(QString ifaVelocityStr);
    //
    void    setInflowLowLimitVelocity(int ifaLowLimitVelocity);
    void    setInflowSensorConstant(short value);
    void    setInflowTempCalib(short value);
    void    setInflowTempCalibAdc(short value);
    void    setInflowAdcPointFactory(short point, int value);
    void    setInflowVelocityPointFactory(short point, int value);
    void    setInflowAdcPointField(short point, int value);
    void    setInflowVelocityPointField(short point, int value);
    //

    //AIRFLOW DOWNFLOW
    int     getDownflowVelocity() const;
    int     getDownflowAdc() const;
    int     getDownflowAdcConpensation() const;
    QString getDownflowVelocityStr() const;
    //
    Q_INVOKABLE int getDownflowLowLimitVelocity() const;
    Q_INVOKABLE int getDownflowHighLimitVelocity() const;
    Q_INVOKABLE short getDownflowSensorConstant();
    Q_INVOKABLE int getDownflowTempCalib();
    Q_INVOKABLE int getDownflowTempCalibAdc();
    Q_INVOKABLE int getDownflowAdcPointFactory(short point);
    Q_INVOKABLE int getDownflowVelocityPointFactory(short point);
    Q_INVOKABLE int getDownflowAdcPointField(short point);
    Q_INVOKABLE int getDownflowVelocityPointField(short point);
    //
    void    setDownflowVelocity(int ifaVelocity);
    void    setDownflowAdc(int ifaAdc);
    void    setDownflowAdcConpensation(int ifaAdcConpensation);
    void    setDownflowVelocityStr(QString dfaVelocityStr);
    //
    void    setDownflowLowLimitVelocity(int ifaLowLimitVelocity);
    void    setDownflowHighLimitVelocity(int ifaHighLimitVelocity);
    void    setDownflowSensorConstant(short value);
    void    setDownflowTempCalib(short value);
    void    setDownflowTempCalibAdc(short value);
    void    setDownflowAdcPointFactory(short point, int value);
    void    setDownflowVelocityPointFactory(short point, int value);
    void    setDownflowAdcPointField(short point, int value);
    void    setDownflowVelocityPointField(short point, int value);
    //

    //AIRFLOW CALIBRATION STATUS
    void    setInflowCalibrationStatus(short infflowCalibrationStatus);
    short   getInflowCalibrationStatus() const;
    void    setDownflowCalibrationStatus(short downflowCalibrationStatus);
    short   getDownflowCalibrationStatus() const;
    void    setAirflowCalibrationStatus(short airflowCalibrationStatus);
    short   getAirflowCalibrationStatus() const;

    /// Board Status
    bool getBoardStatusHybridDigitalRelay() const;
    void setBoardStatusHybridDigitalRelay(bool boardStatusHybridDigitalRelay);
    //
    bool getBoardStatusHybridDigitalInput() const;
    void setBoardStatusHybridDigitalInput(bool boardStatusHybridDigitalInput);
    //
    bool getBoardStatusHybridAnalogInput() const;
    void setBoardStatusHybridAnalogInput(bool boardStatusHybridAnalogInput);
    //
    bool getBoardStatusAnalogInput() const;
    void setBoardStatusAnalogInput(bool boardStatusAnalogInput);
    //
    bool getBoardStatusHybridAnalogOutput() const;
    void setBoardStatusHybridAnalogOutput(bool boardStatusHybridAnalogOutput);
    //
    bool getBoardStatusRbmCom() const;
    void setBoardStatusRbmCom(bool boardStatusRbmCom);
    //
    bool getBoardStatusPressureDiff() const;
    void setBoardStatusPressureDiff(bool boardStatusPressureDiff);
    //
    bool getBoardStatusCtpRtc() const;
    void setBoardStatusCtpRtc(bool boardStatusCtpRtc);
    //
    bool getBoardStatusCtpIoe() const;
    void setBoardStatusCtpIoe(bool boardStatusCtpIoe);

    /// DATA LOG
    bool getDataLogEnable() const;
    bool getDataLogRunning() const;
    short getDataLogPeriod() const;
    int   getDataLogCount() const;
    bool  getDataLogIsFull() const;
    //
    void setDataLogEnable(bool dataLogEnable);
    void setDataLogRunning(bool dataLogRunning);
    void setDataLogCount(int dataLogCount);
    void setDataLogPeriod(short dataLogPeriod);
    void setDataLogIsFull(bool dataLogIsFull);

    /// OPERATION MODE
    short getOperationMode() const;
    void setOperationMode(short operationMode);

    ///WARMING-UP
    bool getWarmingUpActive() const;
    void setWarmingUpActive(bool warmingUpActive);
    ///
    int getWarmingUpTime() const;
    void setWarmingUpTime(int warmingUpTime);
    ///
    int getWarmingUpCountdown() const;
    void setWarmingUpCountdown(int warmingUpCountdown);

    ///POST PURGING
    bool getPostPurgingActive() const;
    void setPostPurgingActive(bool postPurgingActive);
    ///
    int getPostPurgingTime() const;
    void setPostPurgingTime(int postPurgingTime);
    ///
    int getPostPurgingCountdown() const;
    void setPostPurgingCountdown(int postPurgingCountdown);

    /// FILTER LIFE
    int getFilterLifeMinutes() const;
    void setFilterLifeMinutes(int filterLifeMinutes);
    ///
    short getFilterLifePercent() const;
    void setFilterLifePercent(short filterLifePercent);

    /// POWER OUTAGE
    bool getPowerOutage() const;
    void setPowerOutage(bool powerOutage);
    ///
    QString getPowerOutageTime() const;
    void setPowerOutageTime(QString powerOutageTime);
    ///
    QString getPowerOutageRecoverTime() const;
    void setPowerOutageRecoverTime(QString powerOutageRecoverTime);
    ///
    short getPowerOutageFanState() const;
    void setPowerOutageFanState(short powerOutageFanState);
    ///
    //    short getPowerOutageLightState() const;
    //    void setPowerOutageLightState(short powerOutageLightState);
    ///
    short getPowerOutageUvState() const;
    void setPowerOutageUvState(short powerOutageUvState);

    /// SEAS BOARD FLAP
    bool getSeasFlapInstalled() const;
    void setSeasFlapInstalled(bool seasFlapInstalled);
    ///
    short getSeasFlapAlarmPressure() const;
    void setSeasFlapAlarmPressure(short seasFlapAlarmPressure);
    /// SEAS
    bool getSeasInstalled() const;
    void setSeasInstalled(bool seasInstalled);
    ///
    int getSeasPressureDiffPa() const;
    void setSeasPressureDiffPa(int seasPressureDiffPa);
    ///
    int getSeasPressureDiffPaLowLimit() const;
    void setSeasPressureDiffPaLowLimit(int seasPressureDiffPaLowLimit);
    ///
    int getSeasPressureDiff() const;
    void setSeasPressureDiff(int seasPressureDiff);
    ///
    QString getSeasPressureDiffStr() const;
    void setSeasPressureDiffStrf(QString seasPressureDiffStr);

    ///
    short getAlarmSeasPressureLow() const;
    void setSeasAlarmPressureLow(short seasAlarmPressureLow);
    ///
    short getSeasPressureDiffPaOffset() const;
    void setSeasPressureDiffPaOffset(short seasPressureDiffPaOffset);

    /// FAN USAGE METER
    int getFanPrimaryUsageMeter() const;
    void setFanPrimaryUsageMeter(int fanPrimaryUsageMeter);
    int getFanInflowUsageMeter() const;
    void setFanInflowUsageMeter(int fanInflowUsageMeter);

    /// SERIAL NUMBER
    QString getSerialNumber() const;
    void setSerialNumber(QString serialNumber);

    /// ALARM LOG
    int getAlarmLogCount() const;
    void setAlarmLogCount(int alarmLogCount);
    ///
    bool getAlarmLogIsFull() const;
    void setAlarmLogIsFull(bool alarmLogIsFull);

    /// MODBUS
    short getModbusSlaveID() const;
    void setModbusSlaveID(short modbusSlaveID);
    ///
    QString getModbusAllowIpMaster() const;
    void setModbusAllowIpMaster(QString modbusAllowIpMaster);
    ////
    bool getModbusAllowSetFan() const;
    void setModbusAllowSetFan(bool modbusAllowSetFan);
    ///
    bool getModbusAllowSetLight() const;
    void setModbusAllowSetLight(bool modbusAllowSetLight);
    ///
    bool getModbusAllowSetLightIntensity() const;
    void setModbusAllowSetLightIntensity(bool modbusAllowSetLightIntensity);
    ///
    bool getModbusAllowSetSocket() const;
    void setModbusAllowSetSocket(bool modbusAllowSetSocket);
    ///
    bool getModbusAllowSetGas() const;
    void setModbusAllowSetGas(bool modbusAllowGasSet);
    ///
    bool getModbusAllowSetUvLight() const;
    void setModbusAllowSetUvLight(bool modbusAllowSetUvLight);
    ///
    QString getModbusLatestStatus() const;
    void setModbusLatestStatus(QString modbusLatestStatus);

    /// EVENT LOG
    int getEventLogCount() const;
    void setEventLogCount(int eventLogCount);
    ///
    bool getEventLogIsFull() const;
    void setEventLogIsFull(bool eventLogIsFull);

    /// UV AUTO SET
    int getUVAutoEnabled() const;
    void setUVAutoEnabled(int uvAutoSetEnabled);
    ///
    int getUVAutoTime() const;
    void setUVAutoTime(int uvAutoSetTime);
    ///
    int getUVAutoDayRepeat() const;
    void setUVAutoDayRepeat(int uvAutoSetDayRepeat);
    ///
    int getUVAutoWeeklyDay() const;
    void setUVAutoWeeklyDay(int uvAutoSetWeeklyDay);

    /// FAN AUTO SET
    int getFanAutoEnabled() const;
    void setFanAutoEnabled(int fanAutoSetEnabled);
    ///
    int getFanAutoTime() const;
    void setFanAutoTime(int fanAutoSetTime);
    ///
    int getFanAutoDayRepeat() const;
    void setFanAutoDayRepeat(int fanAutoSetDayRepeat);
    ///
    int getFanAutoWeeklyDay() const;
    void setFanAutoWeeklyDay(int fanAutoSetWeeklyDay);

    ///Security Accsess
    short getSecurityAccessMode() const;
    void setSecurityAccessMode(short securityAccessMode);

    /// Certification Date Remainder
    QString getDateCertificationRemainder() const;
    void setDateCertificationRemainder(QString dateCertificationRemainder);
    ///
    bool getCertificationExpired() const;
    void setCertificationExpired(bool certificationExpired);
    ///
    int getCertificationExpiredCount() const;
    void setCertificationExpiredCount(int certificationExpiredCount);
    ///
    bool getCertificationExpiredValid() const;
    void setCertificationExpiredValid(bool certificationExpiredValid);

    /// ESCO LOCK SERVICE
    int getEscoLockServiceEnable() const;
    void setEscoLockServiceEnable(int escoLockServiceEnable);

    /// CABINET NAME
    QString getCabinetDisplayName() const;
    void setCabinetDisplayName(QString cabinetDisplayName);

    /// FAN PIN
    QString getFanPIN() const;
    void setFanPIN(QString fanPIN);

    /// SASH CYCLE METER
    int getSashCycleMeter() const;
    void setSashCycleMeter(int sashCycleMeter);

    /// ENVIRONMENTAL TEMPERATURE LIMIT
    int getEnvTempHighestLimit() const;
    int getEnvTempLowestLimit() const;
    ///
    void setEnvTempHighestLimit(int envTempHighestLimit);
    void setEnvTempLowestLimit(int envTempLowestLimit);

    /// PARTICLE COUNTER
    int getParticleCounterPM2_5() const;
    int getParticleCounterPM10() const;
    int getParticleCounterPM1_0() const;
    short getParticleCounterSensorFanState() const;
    bool getParticleCounterSensorInstalled() const;
    ///
    void setParticleCounterPM2_5(int particleCounterPM2_5);
    void setParticleCounterPM10(int particleCounterPM10);
    void setParticleCounterPM1_0(int particleCounterPM1_0);
    void setParticleCounterSensorFanState(short particleCounterSensorFanState);
    void setParticleCounterSensorInstalled(bool particleCounterSensorInstalled);

    bool getVivariumMuteState() const;
    void setVivariumMuteState(bool vivariumMuteState);

    /// WATCHDOG
    int getWatchdogCounter() const;
    QString getRtcActualDate() const;
    QString getRtcActualTime() const;
    ///
    void setWatchdogCounter(int watchdogCounter);
    void setRtcActualDate(QString rtcActualDate);
    void setRtcActualTime(QString rtcActualTime);

    /// LOGS
    int getDataLogSpaceMaximum() const;
    int getAlarmLogSpaceMaximum() const;
    int getEventLogSpaceMaximum() const;
    ///
    void setAlarmLogSpaceMaximum(int alarmLogSpaceMaximum);
    void setEventLogSpaceMaximum(int eventLogSpaceMaximum);
    void setDataLogSpaceMaximum(int dataLogSpaceMaximum);

    bool getShippingModeEnable() const;
    void setShippingModeEnable(bool shippingModeEnable);

    Q_INVOKABLE QString getSbcSerialNumber() const;
    void setSbcSerialNumber(QString sbcSerialNumber);
    Q_INVOKABLE QString getSbcCurrentFullMacAddress() const;
    void setSbcCurrentFullMacAddress(QString sbcCurrentFullMacAddress);
    Q_INVOKABLE QStringList getSbcSystemInformation()const;
    void setSbcSystemInformation(QStringList sbcSystemInformation);

    Q_INVOKABLE bool getSbcCurrentSerialNumberKnown()const;
    void setSbcCurrentSerialNumberKnown(bool value);

    Q_INVOKABLE QString getSbcCurrentSerialNumber() const;
    void setSbcCurrentSerialNumber(QString sbcCurrentSerialNumber);
    Q_INVOKABLE QStringList getSbcCurrentSystemInformation()const;
    void setSbcCurrentSystemInformation(QStringList sbcCurrentSystemInformation);

public slots:
    void initSingleton();

signals:
    void machineStateChanged(int machineState);

    void countChanged(int count);

    void hasStoppedChanged(bool hasStopped);

    void fanStateChanged(short fanState);

    void fanPrimaryStateChanged(short fanPrimaryState);
    void fanInflowStateChanged(short fanInflowState);
    void lightStateChanged(short lightState);
    void socketStateChanged(short socketState);
    void gasStateChanged(short gasState);
    void uvStateChanged(short uvState);

    void muteAlarmStateChanged(short muteAlarmState);

    void sashWindowStateChanged(short sashWindowState);
    void sashWindowMotorizeStateChanged(short sashMotorizeState);
    void exhaustContactStateChanged(short gasState);
    void alarmContactStateChanged(short uvState);
    void lightIntensityChanged(short lightIntensity);

    void magSWStateChanged(short index, bool state);

    void alarmInflowLowChanged(short alarmInflowLow);
    void alarmSashChanged(short alarmSash);
    void alarmSashUnsafeChanged(short alarmSashUnsafe);

    //AIRFLOW MONITOR
    void airflowMonitorEnableChanged(bool airflowMonitorEnable);

    //AIRFLOW INFLOW
    void ifaVelocityChanged(int ifaVelocity);
    void ifaAdcChanged(int ifaAdc);
    void ifaAdcConpensationChanged(int ifaAdcConpensation);
    void ifaVelocityStrChanged(QString ifaVelocityStr);
    //AIRFLOW DOWNFLOW
    void dfaVelocityChanged(int ifaVelocity);
    void dfaAdcChanged(int ifaAdc);
    void dfaAdcConpensationChanged(int dfaAdcConpensation);
    void dfaVelocityStrChanged(QString dfaVelocityStr);

    //AIRFLOW CALIBRATION STATUS
    void inflowCalibrationStatusChanged(short inflowCalibrationStatus);
    void downflowCalibrationStatusChanged(short downflowCalibrationStatus);
    void airflowCalibrationStatusChanged(short airflowCalibrationStatus);

    void measurementUnitChanged(short measurementUnit);
    void measurementUnitDuringCalibChanged(short measurementUnitDuringCalib);

    void fanPrimaryDutyCycleChanged(short fanPrimaryDutyCycle);
    void fanPrimaryRpmChanged(int fanPrimaryRpm);
    //Added for LA2-EU
    void fanInflowDutyCycleChanged(short fanInflowDutyCycle);
    void fanInflowRpmChanged(int fanInflowRpm);
    //
    void temperatureChanged(short temperature);
    void temperatureAdcChanged(int value);
    void temperatureValueStrfChanged(QString value);

    void machineModelNameChanged(QString machineModelName);
    void machineClassNameChanged(QString machineClassName);
    void machineProfileNameChanged(QString machineProfile);
    void machineProfileChanged(QJsonObject machineProfile);

    void lcdBrightnessLevelChanged(short lcdBrightnessLevel);
    void lcdBrightnessLevelUserChanged(short lcdBrightnessLevelUser);
    void lcdBrightnessDelayToDimmChanged(short lcdBrightnessDelayToDimm);
    void lcdBrightnessLevelDimmedChanged(bool lcdBrightnessLevelDimmed);

    void languageChanged(QString language);

    void timeZoneChanged(QString timeZone);
    void timeClockPeriodChanged(short timeClockPeriod);

    //    void fanPrimaryStandbyRpmChanged(int fanPrimaryStandbyRpm);
    //    void fanPrimaryNominalDutyCycleFieldChanged(short fanPrimaryNominalDutyCycleField);
    //    void fanPrimaryNominalRpmFieldChanged(int fanPrimaryNominalRpmField);
    //    void fanPrimaryNominalDutyCycleFactoryChanged(short fanPrimaryNominalDutyCycleFactory);
    //    void fanPrimaryNominalRpmFactoryChanged(int fanPrimaryNominalRpmFactory);
    //    void fanPrimaryStandbyDutyCycleFactoryChanged(short fanPrimaryStandbyDutyCycleFactory);
    //    void fanPrimaryStandbyRpmFactoryChanged(int fanPrimaryStandbyRpmFactory);
    //    void fanPrimaryStandbyDutyCycleFieldChanged(short fanPrimaryStandbyDutyCycleField);
    //    void fanPrimaryStandbyRpmFieldChanged(int fanPrimaryStandbyRpmField);

    void exhPressureActualPaChanged();

    void boardStatusHybridDigitalRelayChanged(bool boardStatusHybridDigitalRelay);
    void boardStatusHybridDigitalInputChanged(bool boardStatusHybridDigitalInput);
    void boardStatusHybridAnalogInputChanged(bool boardStatusHybridAnalogInput);
    void boardStatusAnalogInputChanged(bool boardStatusAnalogInput);
    void boardStatusHybridAnalogOutputChanged(bool boardStatusHybridAnalogOutput);
    void boardStatusRbmComChanged(bool boardStatusRbmCom);
    void boardStatusPressureDiffChanged(bool boardStatusPressureDiff);
    void boardStatusCtpRtcChanged(bool boardStatusCtpRtc);
    void boardStatusCtpIoeChanged(bool boardStatusCtpIoe);

    /// DATA LOG
    void dataLogEnableChanged(bool dataLogEnable);
    void dataLogRunningChanged(bool dataLogRunning);
    void dataLogCountChanged(int dataLogCount);
    void dataLogPeriodChanged(int dataLogCount);
    void dataLogIsFullChanged(bool dataLogIsFull);

    void fanPrimaryInterlockedChanged(short fanPrimaryInterlocked);
    void fanInflowInterlockedChanged(short fanInflowInterlocked);
    void lightInterlockedChanged(bool lightInterlocked);
    void socketInterlockedChanged(bool socketInterlocked);
    void gasInterlockedChanged(bool gasInterlocked);
    void socketInstalledChanged(bool socketInstalled);
    void gasInstalledChanged(bool gasInstalled);

    void uvInterlockedChanged(bool uvInterlocked);
    void uvInstalledChanged(bool uvInstalled);
    ///
    void uvTimeActiveChanged(bool uvTimeActive);
    void uvTimeChanged(int uvTime);
    void uvTimeCountdownChanged(int uvTimeCountdown);

    void tempAmbientStatusChanged(short tempAmbientStatus);

    void operationModeChanged(short operationMode);

    void sashWindowMotorizeUpInterlockedChanged(bool sashWindowMotorizeUpInterlocked);
    void sashWindowMotorizeDownInterlockedChanged(bool sashWindowMotorizeDownInterlocked);
    void sashWindowMotorizeInstalledChanged(bool sashWindowMotorizeInstalled);

    void warmingUpActiveChanged(bool warmingUpRunning);
    void warmingUpTimeChanged(int warmingUpTime);
    void warmingUpCountdownChanged(int warmingUpCountdown);

    void fanSwithingStateTriggered(bool stateTo);
    //void fanInflowSwithingStateTriggered(bool stateTo);

    void uvLifeMinutesChanged(int uvLifeMinutes);
    void uvLifePercentChanged(short uvLifePercent);

    void alarmSashFullyOpenChanged(short alarmSashFullyOpen);
    void alarmsStateChanged(bool alarmState);
    void alarmBoardComErrorChanged(short alarmBoardComError);

    void postPurgingActiveChanged(bool postPurgingActive);
    void postPurgingTimeChanged(int postPurgingTime);
    void postPurgingCountdownChanged(int postPurgingCountdown);

    void filterLifeMinutesChanged(int filterLifeMinutes);
    void filterLifePercentChanged(short filterLifePercent);

    void powerOutageChanged(bool powerOutage);
    void powerOutageTimeChanged(QString powerOutageTime);
    void powerOutageRecoverTimeChanged(QString powerOutageRecoverTime);
    void powerOutageFanStateChanged(short powerOutageFanState);
    void powerOutageUvStateChanged(short powerOutageUvState);

    //    void powerOutageLightStateChanged(short powerOutageLightState);

    void seasFlapInstalledChanged(bool seasFlapInstalled);
    void seasFlapAlarmPressureChanged(short seasFlapAlarmPressure);

    void seasInstalledChanged(bool seasInstalled);
    void seasPressureDiffPaChanged(int seasPressureDiffPa);
    void seasPressureDiffChanged(int seasPressureDiff);
    void seasPressureDiffStrChanged(QString seasPressureDiffStr);
    void seasPressureDiffPaLowLimitChanged(int seasPressureDiffPaLowLimit);
    void seasAlarmPressureLowChanged(short seasAlarmPressureLow);
    void seasPressureDiffPaOffsetChanged(short seasPressureDiffPaOffset);

    void fanPrimaryUsageMeterChanged(int fanPrimaryUsageMeter);
    void fanInflowUsageMeterChanged(int fanPrimaryUsageMeter);

    void muteAlarmTimeChanged(int muteAlarmTime);
    void muteAlarmCountdownChanged(int muteAlarmCountdown);

    void serialNumberChanged(QString serialNumber);

    void alarmLogCountChanged(int alarmLogCount);
    void alarmLogIsFullChanged(bool alarmLogIsFull);

    void modbusAllowIpMasterChanged(QString modbusAllowIpMaster);
    void modbusAllowSetFanChanged(bool modbusAllowSetFan);
    void modbusAllowSetLightChanged(bool modbusAllowSetLight);
    void modbusAllowSetLightIntensityChanged(bool modbusAllowSetLightIntensity);
    void modbusAllowSetSocketChanged(bool modbusAllowSetSocket);
    void modbusAllowGasSetChanged(bool modbusAllowGasSet);
    void modbusAllowSetUvLightChanged(bool modbusAllowSetUvLight);
    void modbusLatestStatusChanged(QString modbusLatestStatus);

    void modbusSlaveIDChanged(short modbusSlaveID);

    void eventLogCountChanged(int eventLogCount);
    void eventLogIsFullChanged(bool eventLogIsFull);

    void uvAutoEnabledChanged(int uvAutoSetEnabled);

    void uvAutoTimeChanged(int uvAutoSetTime);

    void uvAutoDayRepeatChanged(int uvAutoSetDayRepeat);

    void uvAutoWeeklyDayChanged(int uvAutoSetWeeklyDay);

    void fanAutoEnabledChanged(int fanAutoSetEnabled);

    void fanAutoTimeChanged(int fanAutoSetTime);

    void fanAutoDayRepeatChanged(int fanAutoSetDayRepeat);

    void fanAutoWeeklyDayChanged(int fanAutoSetWeeklyDay);

    void securityAccessChanged(short securityAccessMode);

    void dateCertificationRemainderChanged(QString dateCertificationRemainder);

    void certificationExpiredChanged(bool certificationExpired);

    void certificationExpiredCountChanged(int certificationExpiredCount);

    void escoLockServiceEnableChanged(int escoLockServiceEnable);

    void certificationExpiredValidChanged(int certificationExpiredValid);

    void cabinetDisplayNameChanged(QString cabinetDisplayName);

    void fanPINChanged(QString fanPIN);

    void sashCycleMeterChanged(int sashCycleMeter);

    void envTempHighestLimitChanged(int envTempHighestLimit);

    void envTempLowestLimitChanged(int envTempLowestLimit);

    void alarmTempHighChanged(short alarmTempHigh);

    void alarmTempLowChanged(short alarmTempLow);

    void particleCounterPM2_5Changed(int particleCounterPM2_5);

    void particleCounterPM10Changed(int particleCounterPM10);

    void particleCounterPM1_0Changed(int particleCounterPM1_0);

    void particleCounterSensorInstalledChanged(bool particleCounterSensorInstalled);

    void particleCounterSensorFanStateChanged(short particleCounterSensorFanState);

    void vivariumMuteStateChanged(bool vivariumMuteState);

    void watchdogCounterChanged(int watchdogCounter);

    void rtcActualDateChanged(QString rtcActualDate);

    void rtcActualTimeChanged(QString rtcActualTime);

    void dataLogSpaceMaximumChanged(int dataLogSpaceMaximum);

    void alarmLogSpaceMaximumChanged(int alarmLogSpaceMaximum);

    void eventLogSpaceMaximumChanged(int eventLogSpaceMaximum);

    void shippingModeEnableChanged(bool shippingModeEnable);

private:
    ///
    short m_machineState;

    int m_count = 0;
    bool m_hasStopped = true;

    // CONTROL STATES

    ///SASH-Magnetic Switch
    bool  m_magSwitchState[6] = {false, false, false, false, false, false};
    ///SASH
    short m_sashWindowState = 0;

    short m_fanState = 0;
    short m_fanPrimaryState = 0;
    short m_fanInflowState = 0;

    short m_lightState = 0;
    bool m_lightInterlocked = false;
    short m_lightIntensity = 0;

    bool m_socketInterlocked = false;
    short m_socketState = 0;
    bool m_socketInstalled = false;

    bool m_gasInterlocked = false;
    short m_gasState = 0;
    bool m_gasInstalled = false;

    bool m_uvInterlocked = false;
    short m_uvState = 0;
    bool m_uvInstalled = false;

    short m_muteAlarmState = 0;
    int m_muteAlarmTime = 0;
    int m_muteAlarmCountdown = 0;

    short m_sashWindowMotorizeState = 0;
    short m_exhaustContactState = 0;
    short m_alarmContactState = 0;

    /// ALARM STATES
    bool m_alarmsState = false;
    short m_alarmBoardComError = 0;
    short m_alarmInflowLow = 0;
    short m_alarmSash = 0;
    //    bool m_alarmDownflowLow = false;
    //    bool m_alarmDownflowHigh = false;
    short m_alarmTempHigh = 0;
    short m_alarmTempLow = 0;

    short m_measurementUnit = 0; //mps
    short m_measurementUnitDuringCalib = 0; //mps

    // ACTUAL TEMPERATURE
    int     m_temperatureAdc = 0;
    short   m_temperature = 0;
    QString m_temperatureValueStrf;
    short   m_temperatureCelcius = 0;


    //AIRFLOW MONITOR
    bool m_airflowMonitorEnable = true;

    //AIRFLOW INFLOW
    int     m_ifaVelocity = 0;
    int     m_ifaAdc = 0;
    int     m_ifaAdcConpensation = 0;
    QString m_ifaVelocityStr;
    //
    int     m_ifaLowLimitVelocity = 0;
    short   m_ifaConstant = 0;
    short   m_ifaTemperatureCalib = 0;
    short   m_ifaTemperatureCalibAdc = 0;
    int     m_ifaAdcPointFactory[3] = {0,0,0};
    int     m_ifaVelocityPointFactory[3] = {0,0,0};
    int     m_ifaAdcPointField[3] = {0,0,0};
    int     m_ifaVelocityPointField[3] = {0,0,0};
    //
    //AIRFLOW DOWNFLOW
    int     m_dfaVelocity = 0;
    int     m_dfaAdc = 0;
    int     m_dfaAdcConpensation = 0;
    QString m_dfaVelocityStr;
    //
    int     m_dfaLowLimitVelocity = 0;
    int     m_dfaHighLimitVelocity = 0;
    short   m_dfaConstant = 0;
    short   m_dfaTemperatureCalib = 0;
    short   m_dfaTemperatureCalibAdc = 0;
    int     m_dfaAdcPointFactory[4] = {0,0,0,0};
    int     m_dfaVelocityPointFactory[4] = {0,0,0,0};
    int     m_dfaAdcPointField[4] = {0,0,0,0};
    int     m_dfaVelocityPointField[4] = {0,0,0,0};

    //AIRFLOW CALIBRATION STATUS
    short m_inflowCalibrationStatus;
    short m_downflowCalibrationStatus;
    short m_airflowCalibrationStatus;

    // PRESSURE DIFFERENTIAL
    int    m_dataExhPressureActualPa = 0;

    //MACHINE PROFILE
    QString     m_machineProfileName;
    QJsonObject m_machineProfile;
    QString     m_unitModelName;
    QString     m_unitClassName;

    //LCD BRIGHTNESS
    short m_lcdBrightnessLevelUser = 0;
    short m_lcdBrightnessLevel = 0;
    short m_lcdBrightnessDelayToDimm = 0;
    bool m_lcdBrightnessLevelDimmed = 0;

    //DATE TIME AND LANGUAGE
    QString m_language;
    QString m_timeZone;
    short m_timeClockPeriod = 12; // 12h

    //FAN CALIBRATION
    short   m_fanPrimaryDutyCycle = 0;
    int     m_fanPrimaryRpm = 0;
    short   m_fanPrimaryMaximumDutyCycle = 0;
    int     m_fanPrimaryMaximumRpm = 0;
    short   m_fanPrimaryNominalDutyCycle = 0;
    int     m_fanPrimaryNominalRpm = 0;
    short   m_fanPrimaryMinimumDutyCycle = 0;
    int     m_fanPrimaryMinimumRpm = 0;
    short   m_fanPrimaryStandbyDutyCycle = 0;
    int     m_fanPrimaryStandbyRpm = 0;

    short   m_fanPrimaryMaximumDutyCycleFactory = 0;
    int     m_fanPrimaryMaximumRpmFactory = 0;
    short   m_fanPrimaryMaximumDutyCycleField = 0;
    int     m_fanPrimaryMaximumRpmField = 0;

    short   m_fanPrimaryNominalDutyCycleFactory = 0;
    int     m_fanPrimaryNominalRpmFactory = 0;
    short   m_fanPrimaryNominalDutyCycleField = 0;
    int     m_fanPrimaryNominalRpmField = 0;

    short   m_fanPrimaryMinimumDutyCycleFactory = 0;
    int     m_fanPrimaryMinimumRpmFactory = 0;
    short   m_fanPrimaryMinimumDutyCycleField = 0;
    int     m_fanPrimaryMinimumRpmField = 0;

    short   m_fanPrimaryStandbyDutyCycleFactory = 0;
    int     m_fanPrimaryStandbyRpmFactory = 0;
    short   m_fanPrimaryStandbyDutyCycleField = 0;
    int     m_fanPrimaryStandbyRpmField = 0;

    //FAN INFLOW
    short   m_fanInflowDutyCycle = 0;
    int     m_fanInflowRpm = 0;
    short   m_fanInflowNominalDutyCycle = 0;
    int     m_fanInflowNominalRpm = 0;
    short   m_fanInflowMinimumDutyCycle = 0;
    int     m_fanInflowMinimumRpm = 0;
    short   m_fanInflowStandbyDutyCycle = 0;
    int     m_fanInflowStandbyRpm = 0;
    short   m_fanInflowNominalDutyCycleFactory = 0;
    int     m_fanInflowNominalRpmFactory = 0;
    short   m_fanInflowNominalDutyCycleField = 0;
    int     m_fanInflowNominalRpmField = 0;

    short   m_fanInflowMinimumDutyCycleFactory = 0;
    int     m_fanInflowMinimumRpmFactory = 0;
    short   m_fanInflowMinimumDutyCycleField = 0;
    int     m_fanInflowMinimumRpmField = 0;

    short   m_fanInflowStandbyDutyCycleFactory = 0;
    int     m_fanInflowStandbyRpmFactory = 0;
    short   m_fanInflowStandbyDutyCycleField = 0;
    int     m_fanInflowStandbyRpmField = 0;

    //
    bool    m_boardStatusHybridDigitalRelay = false;
    bool    m_boardStatusHybridDigitalInput = false;
    bool    m_boardStatusHybridAnalogInput  = false;
    bool    m_boardStatusAnalogInput  = false;
    bool    m_boardStatusHybridAnalogOutput = false;
    bool    m_boardStatusRbmCom  = false;
    bool    m_boardStatusPressureDiff  = false;
    bool    m_boardStatusCtpRtc = false;
    bool    m_boardStatusCtpIoe = false;



    /// Datalog
    bool m_dataLogEnable    = false;
    bool m_dataLogRunning   = false;
    short m_dataLogPeriod   = 10; //minutes
    int   m_dataLogCount    = 0;
    bool  m_dataLogIsFull   = false;

    bool m_fanPrimaryInterlocked = false;
    bool m_fanInflowInterlocked = false;

    short m_tempAmbientStatus = 0;

    short m_operationMode = 0;

    bool m_sashWindowMotorizeUpInterlocked = false;
    bool m_sashWindowMotorizeDownInterlocked = false;
    bool m_sashWindowMotorizeInstalled = false;

    ///WARMING-UP
    bool m_warmingUpActive = false;
    int  m_warmingUpTime = 0;
    int  m_warmingUpCountdown = 0;

    bool m_uvTimeActive = false;
    int m_uvTime = 0;
    int m_uvTimeCountdown = 0;

    int m_uvLifeMinutes = 0;
    short m_uvLifePercent = 0;

    bool m_postPurgingActive = false;
    int m_postPurgingTime = 0;
    int m_postPurgingCountdown = 0;

    int m_filterLifeMinutes = 0;
    short m_filterLifePercent = 0;

    bool m_powerOutage = false;
    QString m_powerOutageTime;
    QString m_powerOutageRecoverTime;
    short m_powerOutageFanState = 0;
    //    short m_powerOutageLightState = 0;
    short m_powerOutageUvState = 0;

    ///    SEAS FLAP
    bool m_seasFlapInstalled = false;
    short m_seasFlapAlarmPressure = 0;

    /// SEAS
    bool m_seasInstalled = false;
    int m_seasPressureDiffPa = 0;
    int m_seasPressureDiff = 0;
    QString m_seasPressureDiffStr;
    int m_seasPressureDiffPaLowLimit = 0;
    short m_seasAlarmPressureLow = 0;
    short m_seasPressureDiffPaOffset = 0;

    /// FAN USAGE MATER
    int m_fanPrimaryUsageMeter = 0;
    int m_fanInflowUsageMeter = 0;
    QString m_serialNumber;

    /// ALARM LOG
    int m_alarmLogCount = 0;
    bool m_alarmLogIsFull = false;

    /// MODBUS
    QString m_modbusAllowIpMaster;
    bool m_modbusAllowSetFan = false;
    bool m_modbusAllowSetLight = false;
    bool m_modbusAllowSetLightIntensity = false;
    bool m_modbusAllowSetSocket = false;
    bool m_modbusAllowSetGas = false;
    bool m_modbusAllowSetUvLight = false;
    QString m_modbusLatestStatus;
    short m_modbusSlaveID = 1;

    int m_eventLogCount = 0;
    bool m_eventLogIsFull = false;

    int m_uvAutoSetEnabled = 0;
    int m_uvAutoSetTime = 0;
    int m_uvAutoSetDayRepeat = 0;
    int m_uvAutoSetWeeklyDay = 0;

    int m_fanAutoSetEnabled = 0;
    int m_fanAutoSetTime = 0;
    int m_fanAutoSetDayRepeat = 0;
    int m_fanAutoSetWeeklyDay = 0;

    short m_securityAccessMode = 0;

    QString m_dateCertificationRemainder;
    bool m_certificationExpired = false;
    int m_certificationExpiredCount = 0;
    bool m_certificationExpiredValid = false;

    bool m_escoLockServiceEnable = false;

    QString m_cabinetDisplayName;

    QString m_fanPIN;

    int m_sashCycleMeter = 0;

    int m_envTempHighestLimit = 0;
    int m_envTempLowestLimit = 0;

    /// PARTICLE COUNTER
    int m_particleCounterPM2_5 = 0;
    int m_particleCounterPM10 = 0;
    int m_particleCounterPM1_0 = 0;
    bool m_particleCounterSensorInstalled = false;
    short m_particleCounterSensorFanState = 0;

    bool m_vivariumMuteState = false;

    /// WATCHDOG
    int m_watchdogCounter = 0;
    QString m_rtcActualDate;
    QString m_rtcActualTime;

    int m_dataLogSpaceMaximum = 0;
    int m_alarmLogSpaceMaximum = 0;
    int m_eventLogSpaceMaximum = 0;

    bool m_shippingModeEnable = false;


    QString m_sbcSerialNumber;
    QString m_sbcCurrentFullMacAddress;
    QStringList m_sbcSystemInformation;
    bool m_sbcCurrentSerialNumberKnown = false;
    QString m_sbcCurrentSerialNumber;
    QStringList m_sbcCurrentSystemInformation;
};





