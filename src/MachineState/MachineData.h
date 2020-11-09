#pragma once

#include <QObject>

class QQmlEngine;
class QJSEngine;

class MachineData : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int blowerEcmDemandMode
               READ getBlowerEcmDemandMode
               //               WRITE setBlowerEcmDemandMode
               NOTIFY blowerEcmDemandModeChanged)

    Q_PROPERTY(int count
               READ getCount
               //               WRITE setDataCount
               NOTIFY countChanged)

    Q_PROPERTY(int machineState
               READ getMachineState
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

    Q_PROPERTY(short blowerDownflowState
               READ getBlowerDownflowState
               //               WRITE setBlowerDownflowState
               NOTIFY blowerDownflowStateChanged)

    Q_PROPERTY(short blowerInflowState
               READ getBlowerInflowState
               //               WRITE setBlowerInflowState
               NOTIFY blowerInflowStateChanged)

    Q_PROPERTY(short blowerDownflowDutyCycle
               READ getBlowerDownflowDutyCycle
               //               WRITE setBlowerDownflowDutyCycle
               NOTIFY blowerDownflowDutyCycleChanged)

    Q_PROPERTY(short blowerInflowDutyCycle
               READ getBlowerInflowDutyCycle
               //               WRITE setBlowerInflowDutyCycle
               NOTIFY blowerInflowDutyCycleChanged)

    Q_PROPERTY(short lightState
               READ getLightState
               //               WRITE setLightState
               NOTIFY lightStateChanged)

    Q_PROPERTY(short lightIntensity
               READ getLightIntensity
               //               WRITE setLightIntensity
               NOTIFY lightIntensityChanged)

    Q_PROPERTY(short socketState
               READ getSocketState
               //               WRITE setSocketState
               NOTIFY lightStateChanged)

    Q_PROPERTY(short gasState
               READ getGasState
               //               WRITE setGasState
               NOTIFY gasStateChanged)

    Q_PROPERTY(short uvState
               READ getUvState
               //               WRITE setUvState
               NOTIFY uvStateChanged)

    Q_PROPERTY(short muteAlarmState
               READ getMuteAlarmState
               //               WRITE setMuteAlarmState
               NOTIFY muteAlarmStateChanged)

    Q_PROPERTY(short sashWindowMotorizeState
               READ getSashWindowMotorizeState
               //               WRITE setSashMotorizeState
               NOTIFY sashWindowMotorizeStateChanged)

    Q_PROPERTY(bool alarmSashUnsafe
               READ getAlarmSashUnsafe
               //               WRITE setAlarmSashUnsafe
               NOTIFY alarmSashUnsafeChanged)

    Q_PROPERTY(bool alarmSashError
               READ getAlarmSashError
               //               WRITE setAlarmSashError
               NOTIFY alarmSashErrorChanged)

    Q_PROPERTY(bool alarmInflowLow
               READ getAlarmInflowLow
               //               WRITE setAlarmInflowLow
               NOTIFY alarmInflowLowChanged)

    Q_PROPERTY(bool alarmDownflowLow
               READ getAlarmDownflowLow
               //               WRITE setAlarmDownfLow
               NOTIFY alarmDownflowHighChanged)

    Q_PROPERTY(bool alarmDownflowHigh
               READ getAlarmDownflowHigh
               //               WRITE setAlarmDownfHigh
               NOTIFY alarmDownflowHighChanged)

    Q_PROPERTY(float velocityInflowMatric
               READ getVelocityInflowMatric
               //               WRITE setVelocityInflowMatric
               NOTIFY velocityInflowMatricChanged)

    Q_PROPERTY(float velocityDownflowMatric
               READ getVelocityDownflowMatric
               //               WRITE setVelocityDownflowMatric
               NOTIFY velocityDownflowMatricChanged)

    /// Temperature
    Q_PROPERTY(int      temperatureAdc
               READ     getTemperatureAdc
               //               WRITE    setTemperatureAdc
               NOTIFY   temperatureAdcChanged)

    Q_PROPERTY(QString  temperatureValueStr
               READ     getTemperatureValueStr
               //               WRITE    setTemperatureValueStr
               NOTIFY   temperatureValueStrChanged)

    /// AIRFLOW_INFLOW
    Q_PROPERTY(int      ifaAdc
               READ     getInflowAdc
               //               WRITE    setInflowAdc
               NOTIFY   ifaAdcChanged)

    Q_PROPERTY(int      ifaAdcConpensation
               READ     getInflowAdcConpensation
               //               WRITE    setInflowAdcConpensation
               NOTIFY   ifaAdcConpensationChanged)

    Q_PROPERTY(float    ifaVelocity
               READ     getInflowVelocity
               //               WRITE    setInflowVelocity
               NOTIFY   ifaVelocityChanged)

    Q_PROPERTY(float    ifaVelocityImperial
               READ     getInflowVelocityImperial
               //               WRITE    setInflowVelocityImperial
               NOTIFY   ifaVelocityImperialChanged)

    Q_PROPERTY(QString  dfaVelocityStr
               READ     getInflowVelocityStr
               //               WRITE    setInflowVelocityStr
               NOTIFY   ifaVelocityStrChanged)

    /// AIRFLOW_DOWNFLOW
    Q_PROPERTY(int      dfaAdc
               READ     getDownflowAdc
               //               WRITE    setDownflowAdc
               NOTIFY   ifaAdcChanged)

    Q_PROPERTY(int      dfaAdcConpensation
               READ     getDownflowAdcConpensation
               //               WRITE    setDownflowAdcConpensation
               NOTIFY   dfaAdcConpensationChanged)

    Q_PROPERTY(float    dfaVelocity
               READ     getDownflowVelocity
               //               WRITE     setDownflowVelocity
               NOTIFY   dfaVelocityChanged)

    Q_PROPERTY(float    dfaVelocityImperial
               READ     getDownflowVelocityImperial
               //               WRITE    setDownflowVelocityImperial
               NOTIFY   dfaVelocityImperialChanged)

    Q_PROPERTY(QString  dfaVelocityStr
               READ     getDownflowVelocityStr
               //               WRITE    setDownflowVelocityStr
               NOTIFY   dfaVelocityStrChanged)

    /// Measurement Unit
    Q_PROPERTY(short    measurementUnit
               READ     getMeasurementUnit
               //               WRITE    setMeasurementUnit
               NOTIFY   measurementUnitChanged)

public:
    explicit MachineData(QObject *parent = nullptr);
    ~MachineData();

    static QObject *singletonProvider(QQmlEngine *qmlEngine, QJSEngine *);
    static void singletonDelete();

    Q_INVOKABLE short getMachineState() const;
    void setMachineState(short getMachineState);

    int getCount() const;
    void setCount(int count);

    bool getHasStopped() const;

    void setHasStopped(bool hasStopped);

    int getBlowerEcmDemandMode() const;

    short getBlowerDownflowState() const;

    short getBlowerInflowState() const;

    short getLightState() const;

    short getSocketState() const;

    short getGasState() const;

    short getUvState() const;

    short getMuteAlarmState() const;

    short getSashWindowState() const;

    short getSashWindowMotorizeState() const;

    short getLightIntensity() const;

    bool getAlarmInflowLow() const;

    bool getAlarmSashError() const;

    bool getAlarmSashUnsafe() const;

    bool getAlarmDownflowLow() const;

    bool getAlarmDownflowHigh() const;

    float getVelocityInflowMatric() const;

    float getVelocityDownflowMatric() const;

    int getInflowAdc() const;

    int getInflowAdcConpensation() const;

    float getInflowVelocity() const;

    float getInflowVelocityImperial() const;

    int getDownflowAdc() const;

    int getDownflowAdcConpensation() const;

    float getDownflowVelocity() const;

    float getDownflowVelocityImperial() const;

    QString getInflowVelocityStr() const;

    QString getDownflowVelocityStr() const;

    int getTemperatureAdc() const;

    QString getTemperatureValueStr() const;

    short getMeasurementUnit() const;

    void setInflowAdcPoint(short point, int adc);
    void setInflowAdcPointFactory(short point, int adc);
    void setInflowAdcPointField(short point, int adc);
    void setInflowVelocityPoint(short point, float value);
    void setInflowVelocityPointFactory(short point, float value);
    void setInflowVelocityPointField(short point, float value);
    ///
    void setInflowConstant(int ifaConstant);
    void setInflowTemperatureADC(int ifaTemperatureADC);
    void setInflowTemperatureFactory(float ifaTemperatureFactory);
    void setInflowTemperature(short ifaTemperature);
    void setInflowTemperatureADCFactory(int ifaTemperatureADCFactory);
    void setInflowTemperatureField(short ifaTemperatureField);
    void setInflowTemperatureADCField(int ifaTemperatureADCField);
    void setInflowLowLimitVelocity(float ifaLowLimitVelocity);


    void setDownflowAdcPoint(short point, int adc);
    void setDownflowAdcPointFactory(short point, int adc);
    void setDownflowAdcPointField(short point, int adc);
    void setDownflowVelocityPoint(short point, float value);
    void setDownflowVelocityPointFactory(short point, float value);
    void setDownflowVelocityPointField(short point, float value);
    ///
    void setDownflowConstant(int dfaConstant);
    void setDownflowTemperatureADC(int dfaTemperatureADC);
    void setDownflowTemperatureFactory(short dfaTemperatureFactory);
    void setDownflowTemperatureField(short dfaTemperatureField);
    void setDownflowTemperatureADCField(int dfaTemperatureADCField);
    void setDownflowTemperatureADCFactory(int dfaTemperatureADCFactory);
    void setDownflowLowLimitVelocity(float dfaLowLimitVelocity);
    void setDownflowHigLimitVelocity(float dfaHigLimitVelocity);

    Q_INVOKABLE int getInflowConstant() const;
    Q_INVOKABLE short getInflowTemperature() const;
    Q_INVOKABLE int getInflowTemperatureADC() const;
    Q_INVOKABLE short getInflowTemperatureFactory() const;
    Q_INVOKABLE int getInflowTemperatureADCFactory() const;
    Q_INVOKABLE short getInflowTemperatureField() const;
    Q_INVOKABLE int getInflowTemperatureADCField() const;
    Q_INVOKABLE float getInflowLowLimitVelocity() const;
    Q_INVOKABLE float getDownflowLowLimitVelocity() const;
    Q_INVOKABLE float getDownflowHighLimitVelocity() const;

    Q_INVOKABLE int getDownflowConstant() const;
    Q_INVOKABLE short getDownflowTemperatureField() const;
    Q_INVOKABLE int getDownflowTemperatureADCField() const;
    Q_INVOKABLE short getDownflowTemperatureFactory() const;
    Q_INVOKABLE int getDownflowTemperatureADCFactory() const;
    Q_INVOKABLE short getDownflowTemperature() const;
    Q_INVOKABLE int getDownflowTemperatureADC() const;
    Q_INVOKABLE void setDownflowTemperature(short dfaTemperature);

    void setBlowerEcmDemandMode(int blowerEcmDemandMode);

    void setBlowerDownflowState(short blowerDownflowState);

    void setBlowerInflowState(short blowerInflowState);

    void setLightState(short lightState);

    void setSocketState(short socketState);

    void setGasState(short gasState);

    void setUvState(short uvState);

    void setMuteAlarmState(short muteAlarmState);

    void setSashWindowState(short sashWindowState);

    void setSashWindowMotorizeState(short sashMotorizeState);

    void setLightIntensity(short lightIntensity);

    void setAlarmInflowLow(bool alarmInflowLow);

    void setAlarmSashError(bool alarmSashError);

    void setAlarmSashUnsafe(bool alarmSashUnsafe);

    void setAlarmDownfLow(bool alarmDownflowLow);

    void setAlarmDownfHigh(bool alarmDownflowHigh);

    void setVelocityInflowMatric(float velocityInflowMatric);

    void setVelocityDownflowMatric(float velocityDownflowMatric);

    void setInflowAdc(int ifaAdc);

    void setInflowAdcConpensation(int ifaAdcConpensation);

    void setInflowVelocity(float ifaVelocity);

    void setInflowVelocityImperial(float ifaVelocityImperial);

    void setDownflowAdc(int dfaAdc);

    void setDownflowAdcConpensation(int dfaAdcConpensation);

    void setDownflowVelocity(float dfaVelocity);

    void setDownflowVelocityImperial(float dfaVelocityImperial);

    void setInflowVelocityStr(QString ifaVelocityStr);

    void setDownflowVelocityStr(QString dfaVelocityStr);

    void setTemperatureAdc(int temperatureAdc);

    void setTemperatureValueStr(QString temperatureValueStr);

    void setMeasurementUnit(short measurementUnit);

    short getBlowerDownflowDutyCycle() const;

    short getBlowerInflowDutyCycle() const;

    void setBlowerDownflowDutyCycle(short blowerDownflowDutyCycle);

    void setBlowerInflowDutyCycle(short blowerInflowDutyCycle);

public slots:
    void initSingleton();

signals:
    void machineStateChanged(int machineState);

    void countChanged(int count);

    void hasStoppedChanged(bool hasStopped);

    void blowerEcmDemandModeChanged(int blowerEcmDemandMode);

    void blowerDownflowStateChanged(short blowerDownflowState);

    void blowerInflowStateChanged(short blowerInflowState);

    void lightStateChanged(short lightState);

    void gasStateChanged(short gasState);

    void uvStateChanged(short uvState);

    void muteAlarmStateChanged(short muteAlarmState);

    void sashWindowStateChanged(short sashWindowState);

    void sashWindowMotorizeStateChanged(short sashMotorizeState);

    void lightIntensityChanged(short lightIntensity);

    void alarmInflowLowChanged(bool alarmInflowLow);

    void alarmSashErrorChanged(bool alarmSashError);

    void alarmSashUnsafeChanged(bool alarmSashUnsafe);

    void alarmDownflowHighChanged(bool alarmDownflowLow);

    void velocityInflowMatricChanged(float velocityInflowMatric);

    void velocityDownflowMatricChanged(float velocityDownflowMatric);

    void ifaAdcChanged(int ifaAdc);

    void ifaAdcConpensationChanged(int ifaAdcConpensation);

    void ifaVelocityChanged(float ifaVelocity);

    void ifaVelocityImperialChanged(float ifaVelocityImperial);

    void dfaAdcConpensationChanged(int dfaAdcConpensation);

    void dfaVelocityChanged(float dfaVelocity);

    void dfaVelocityImperialChanged(float dfaVelocityImperial);

    void ifaVelocityStrChanged(QString dfaVelocityStr);

    void dfaVelocityStrChanged(QString dfaVelocityStr);

    void temperatureAdcChanged(int temperatureAdc);

    void temperatureValueStrChanged(QString temperatureValueStr);

    void measurementUnitChanged(short measurementUnit);

    void blowerDownflowDutyCycleChanged(short blowerDownflowDutyCycle);

    void blowerInflowDutyCycleChanged(short blowerInflowDutyCycle);

private:
    ///
    short m_machineState;

    int m_count = 0;
    bool m_hasStopped = true;
    int m_blowerEcmDemandMode;
    short m_blowerDownflowState = 0;
    short m_blowerInflowState = 0;
    short m_lightState = 0;
    short m_socketState = 0;
    short m_gasState = 0;
    short m_uvState = 0;
    short m_muteAlarmState = 0;
    short m_sashWindowState = 0;
    short m_sashWindowMotorizeState = 0;
    short m_lightIntensity = 0;
    bool m_alarmInflowLow = false;
    bool m_alarmSashError = false;
    bool m_alarmSashUnsafe = false;
    bool m_alarmDownflowLow = false;
    bool m_alarmDownflowHigh = false;
    float m_velocityInflowMatric = 0;
    float m_velocityDownflowMatric;
    int m_ifaAdc;
    int m_ifaAdcConpensation;
    float m_ifaVelocity;
    float m_ifaVelocityImperial;
    int m_dfaAdc;
    int m_dfaAdcConpensation;
    float m_dfaVelocity;
    float m_dfaVelocityImperial;
    QString m_ifaVelocityStr;
    QString m_dfaVelocityStr;
    int m_temperatureAdc;
    QString m_temperatureValueStr;
    short m_measurementUnit;

    ///
    int     m_ifaConstant;
    int     m_ifaAdcPoint[3];
    float   m_ifaVelocityPoint[3];
    short   m_ifaTemperature = 0;
    int     m_ifaTemperatureADC = 0;
    ///
    int     m_ifaAdcPointFactory[3];
    float   m_ifaVelocityPointFactory[3];
    short   m_ifaTemperatureFactory = 0;
    int     m_ifaTemperatureADCFactory = 0;
    ///
    int     m_ifaAdcPointField[3];
    float   m_ifaVelocityPointField[3];
    short   m_ifaTemperatureField = 0;
    int     m_ifaTemperatureADCField = 0;
    ///
    float   m_ifaLowLimitVelocity = 0;

    ///
    int     m_dfaConstant = 0;
    int     m_dfaAdcPoint[3] = {0,0,0};
    float   m_dfaVelocityPoint[3] = {0,0,0};
    short   m_dfaTemperature = 0;
    int     m_dfaTemperatureADC = 0;
    ///
    int     m_dfaAdcPointFactory[3];
    float   m_dfaVelocityPointFactory[3];
    short   m_dfaTemperatureFactory = 0;
    int     m_dfaTemperatureADCFactory = 0;
    ///
    int     m_dfaAdcPointField[3];
    float   m_dfaVelocityPointField[3];
    short   m_dfaTemperatureField = 0;
    int     m_dfaTemperatureADCField = 0;
    ///
    float   m_dfaLowLimitVelocity = 0;
    float   m_dfaHigLimitVelocity = 0;

    short m_blowerDownflowDutyCycle = 0;
    short m_blowerInflowDutyCycle = 0;
};

