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

    Q_PROPERTY(short blowerExhaustState
               READ getBlowerExhaustState
               //               WRITE setBlowerExhaustState
               NOTIFY blowerExhaustStateChanged)

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

    Q_PROPERTY(short sashMotorizeState
               READ getSashMotorizeState
               //               WRITE setSashMotorizeState
               NOTIFY sashMotorizeStateChanged)

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

    short getBlowerExhaustState() const;

    short getLightState() const;

    short getSocketState() const;

    short getGasState() const;

    short getUvState() const;

    short getMuteAlarmState() const;

    short getSashWindowState() const;

    short getSashMotorizeState() const;

    short getLightIntensity() const;

    bool getAlarmInflowLow() const;

    bool getAlarmSashError() const;

    bool getAlarmSashUnsafe() const;

    bool getAlarmDownflowLow() const;

    bool getAlarmDownflowHigh() const;

    float getVelocityInflowMatric() const;

    float getVelocityDownflowMatric() const;

public slots:
    void initSingleton();

    void setBlowerEcmDemandMode(int blowerEcmDemandMode);

    void setBlowerDownflowState(short blowerDownflowState);

    void setBlowerExhaustState(short blowerExhaustState);

    void setLightState(short lightState);

    void setSocketState(short socketState);

    void setGasState(short gasState);

    void setUvState(short uvState);

    void setMuteAlarmState(short muteAlarmState);

    void setSashWindowState(short sashWindowState);

    void setSashMotorizeState(short sashMotorizeState);

    void setLightIntensity(short lightIntensity);

    void setAlarmInflowLow(bool alarmInflowLow);

    void setAlarmSashError(bool alarmSashError);

    void setAlarmSashUnsafe(bool alarmSashUnsafe);

    void setAlarmDownfLow(bool alarmDownflowLow);

    void setAlarmDownfHigh(bool alarmDownflowHigh);

    void setVelocityInflowMatric(float velocityInflowMatric);

    void setVelocityDownflowMatric(float velocityDownflowMatric);

signals:
    void machineStateChanged(int machineState);

    void countChanged(int count);

    void hasStoppedChanged(bool hasStopped);

    void blowerEcmDemandModeChanged(int blowerEcmDemandMode);

    void blowerDownflowStateChanged(short blowerDownflowState);

    void blowerExhaustStateChanged(short blowerExhaustState);

    void lightStateChanged(short lightState);

    void gasStateChanged(short gasState);

    void uvStateChanged(short uvState);

    void muteAlarmStateChanged(short muteAlarmState);

    void sashWindowStateChanged(short sashWindowState);

    void sashMotorizeStateChanged(short sashMotorizeState);

    void lightIntensityChanged(short lightIntensity);

    void alarmInflowLowChanged(bool alarmInflowLow);

    void alarmSashErrorChanged(bool alarmSashError);

    void alarmSashUnsafeChanged(bool alarmSashUnsafe);

    void alarmDownflowHighChanged(bool alarmDownflowLow);

    void velocityInflowMatricChanged(float velocityInflowMatric);

    void velocityDownflowMatricChanged(float velocityDownflowMatric);

private:
    ///
    short m_machineState;

    int m_count = 0;
    bool m_hasStopped = true;
    int m_blowerEcmDemandMode;
    short m_blowerDownflowState = 0;
    short m_blowerExhaustState = 0;
    short m_lightState = 0;
    short m_socketState = 0;
    short m_gasState = 0;
    short m_uvState = 0;
    short m_muteAlarmState = 0;
    short m_sashWindowState = 0;
    short m_sashMotorizeState = 0;
    short m_lightIntensity = 0;
    bool m_alarmInflowLow = false;
    bool m_alarmSashError = false;
    bool m_alarmSashUnsafe = false;
    bool m_alarmDownflowLow = false;
    bool m_alarmDownflowHigh = false;
    float m_velocityInflowMatric = 0;
    float m_velocityDownflowMatric;
};

