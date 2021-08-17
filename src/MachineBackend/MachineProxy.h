#pragma once

#include <QObject>
#include <QScopedPointer>
#include <QJsonArray>

#include "MachineEnums.h"

class QThread;
class QTimer;
class MachineBackend;
class MachineData;

class QQmlEngine;
class QJSEngine;

class MachineProxy : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int count
               READ getCount
               NOTIFY countChanged)

    Q_ENUM(MachineEnums::EnumItemMachineState);
    Q_ENUM(MachineEnums::EnumItemSashState);
    Q_ENUM(MachineEnums::EnumItemFanState);
    Q_ENUM(MachineEnums::EnumMotorSashState);
    Q_ENUM(MachineEnums::EnumAirflowCalibState);
    Q_ENUM(MachineEnums::EnumMeasurementUnitState);
    Q_ENUM(MachineEnums::EnumOperationModeState);
    Q_ENUM(MachineEnums::EnumTempAmbientState);
    Q_ENUM(MachineEnums::EnumAlarmState);
    Q_ENUM(MachineEnums::EnumAlarmSashState);
    Q_ENUM(MachineEnums::EnumSecurityAccessState);

public:
    explicit MachineProxy(QObject *parent = nullptr);
    ~MachineProxy();

    static QObject *singletonProvider(QQmlEngine *qmlEngine, QJSEngine *);

    int getCount() const;

signals:

    void countChanged(int count);

public slots:
    void initSingleton();
    void setup(QObject *pData);
    void stop();

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

    /// API for Certification Date Remainder
    void setDateCertificationRemainder(const QString value);

    void setMeasurementUnit(short value);

    void setSerialNumber(QString value);

    //// FAN
    void setFanState(short value);
    void setFanPrimaryDutyCycle(short value);
    //Added for LA2-EU
    void setFanDownflowDutyCycle(short value);
    void setFanInflowDutyCycle(short value);
    //
    void setFanPrimaryNominalDutyCycleFactory(short value);
    void setFanPrimaryNominalRpmFactory(int value);
    void setFanPrimaryMinimumDutyCycleFactory(short value);
    void setFanPrimaryMinimumRpmFactory(int value);
    void setFanPrimaryStandbyDutyCycleFactory(short value);
    void setFanPrimaryStandbyRpmFactory(int value);
    //
    void setFanPrimaryNominalDutyCycleField(short value);
    void setFanPrimaryNominalRpmField(int value);
    void setFanPrimaryMinimumDutyCycleField(short value);
    void setFanPrimaryMinimumRpmField(int value);
    void setFanPrimaryStandbyDutyCycleField(short value);
    void setFanPrimaryStandbyRpmField(int value);

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

    void setWarmingUpTimeSave(short minutes);
    void setPostPurgeTimeSave(short minutes);

    void setSashMotorizeInstalled(short value);
    void setSashWindowMotorizeState(short sashMotorizeState);

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
    void saveInflowMeaDimNominalGrid(const QJsonArray grid, int total,
                                     int average, int volume, int velocity,
                                     int ducy, int rpm,
                                     int fullField = 0);
    void saveInflowMeaDimMinimumGrid(const QJsonArray grid, int total,
                                     int average, int volume, int velocity,
                                     int ducy, int rpm);
    void saveInflowMeaDimStandbyGrid(const QJsonArray grid, int total,
                                     int average, int volume, int velocity,
                                     int ducy, int rpm);
    //
    void saveInflowMeaSecNominalGrid(const QJsonArray grid, int total,
                                     int average, int velocity,
                                     int ducy, int rpm);
    //
    //DOWNFLOW
    //    void saveDownflowSensorConstant(short ifaConstant);
    //
    //    void saveDownflowAdcPointFactory(int pointZero, int pointMin, int pointNom);
    void setDownflowVelocityPointFactory(int pointZero, int pointMin, int pointNom);
    void setDownflowVelocityPointFactory(int point, int value);
    //    void saveDownflowTemperatureFactory(short ifaTemperatureFactory, int adc);
    //
    //    void saveDownflowAdcPointField(short point, int adc);
    void setDownflowVelocityPointField(int pointZero, int pointMin, int pointNom);
    void setDownflowVelocityPointField(int point, int value);
    //    void saveDownflowTemperatureField(short value, int adc);
    //
    void saveDownflowMeaNominalGrid(const QJsonArray grid,
                                    int total,
                                    int velocity, int velocityLowest, int velocityHighest,
                                    int deviation, int deviationp,
                                    int fullField = 0);
    //
    void initAirflowCalibrationStatus(short value);

    /// DATALOG
    void setDataLogEnable(bool dataLogEnable);
    void setDataLogRunning(bool dataLogRunning);
    void setDataLogPeriod(short dataLogPeriod);
    void setDataLogCount(int dataLogCount);

    ///MODBUS
    void setModbusSlaveID(short slaveId);
    void setModbusAllowingIpMaster(const QString ipAddr);
    void setModbusAllowSetFan(bool value);
    void setModbusAllowSetLight(bool value);
    void setModbusAllowSetLightIntensity(bool value);
    void setModbusAllowSetSocket(bool value);
    void setModbusAllowSetGas(bool value);
    void setModbusAllowSetUvLight(bool value);

    /// EVENTLOG
    void insertEventLog(const QString eventText);

    ///UV AUTO SET
    void setUVAutoEnabled(int uvAutoSetEnabled);
    void setUVAutoTime(int uvAutoSetTime);
    void setUVAutoDayRepeat(int uvAutoSetDayRepeat);
    void setUVAutoWeeklyDay(int uvAutoSetWeeklyDay);

    ///FAN AUTO SET
    void setFanAutoEnabled(int fanAutoSetEnabled);
    void setFanAutoTime(int fanAutoSetTime);
    void setFanAutoDayRepeat(int fanAutoSetDayRepeat);
    void setFanAutoWeeklyDay(int fanAutoSetWeeklyDay);

    /// ESCO LOCK SERVICE
    void setEscoLockServiceEnable(int escoLockServiceEnable);

    /// CABINET DISPLAY NAME
    void setCabinetDisplayName(const QString cabinetDisplayName);

    /// CABINET FAN PIN
    void setFanPIN(const QString fanPIN);

    /// FAN USAGE
    void setFanUsageMeter(int minutes);

    /// UV USAGE
    void setUvUsageMeter(int minutes);

    /// FILTER USAGE
    void setFilterUsageMeter(int minutes);

    /// SASH CYCLE METER
    void setSashCycleMeter(int sashCycleMeter);

    /// Sensor Environtmental Temperature Limitation
    void setEnvTempHighestLimit(int envTempHighestLimit);
    void setEnvTempLowestLimit(int envTempLowestLimit);

    /// Particle Sensor
    void setParticleCounterSensorInstalled(bool particleCounterSensorInstalled);

    void setWatchdogResetterState(bool state);

    void refreshLogRowsCount(const QString table);

    void setShippingModeEnable(bool shippingModeEnable);

    void setCurrentSystemAsKnown(bool value);

    void readSbcCurrentFullMacAddress();

private slots:
    void doStopping();

private:
    QScopedPointer<QTimer>          m_timerEventForMachineState;
    QScopedPointer<QThread>         m_threadForMachineState;
    QScopedPointer<MachineBackend>  m_machineBackend;

    MachineData*                    pMachineData;
    int m_count;
};

