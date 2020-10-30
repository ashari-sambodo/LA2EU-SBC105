#ifndef BLOWERECMCOMMMANAGER_H
#define BLOWERECMCOMMMANAGER_H

#include <QObject>
#include <QSharedPointer>
#include <QVector>
#include <QtSerialPort/QSerialPort>
#include <QtSerialPort/QSerialPortInfo>

#include "../ClassManager.h"
#include "BoardIO/Drivers/BlowerRegalECM/BlowerRegalECM.h"

class BlowerDSIManager : public ClassManager
{
    Q_OBJECT
public:
    explicit BlowerDSIManager(QObject *parent = nullptr);
    void setup();
    void worker(int parameter = 0) override;

    BlowerRegalECM * getSub();
    QString getSerialPortName() const;

    void setSpeedDutyCycle(int newVal);
    void setInterlock(int newVal);

    int getDirection() const;
    void setDirection(int newVal);

    int getCutbackSlope() const;
    void setCutbackSlope(int newVal);

    int getAirflowScalling() const;
    void setAirflowScaling(int newVal);

    double getConstantA1() const;
    void setConstantA1(double newVal);

    double getConstantA2() const;
    void setConstantA2(double newVal);

    double getConstantA3() const;
    void setConstantA3(double newVal);

    double getConstantA4() const;
    void setConstantA4(double newVal);

    int getCutbackSpeed() const;
    void setCutbackSpeed(int newVal);

signals:
    void workerFinished();
    void serialPortOpened(const QString &portName);
    void serialPortError();

    void interlockChanged(int newVal);

    void addressChanged(int newVal);
    //    void firmwareVersionChanged(const QString);
    //    void programVersionChanged(int newVal);
    //    void controlRevChanged(int newVal);
    //    void controlTypeChanged(int newVal);
    //    void serialNumberChanged(int newVal);
    void speedRPMChanged(int newVal);
    void demandChanged(int newVal);
    void speedDutyCycleChanged(int newVal);
    //    void voltageChanged(int newVal);
    //    void statusOtmpChanged(int newVal);
    //    void statusRampChanged(int newVal);
    //    void statusStartChanged(int newVal);
    //    void statusRunChanged(int newVal);
    //    void statusCutBkChanged(int newVal);
    //    void statusStallChanged(int newVal);
    //    void statusRasChanged(int newVal);
    //    void statusBrakeChanged(int newVal);
    //    void statusRbcChanged(int newVal);
    //    void statusBrownOutChanged(int newVal);
    //    void statusOscChanged(int newVal);
    //    void statusReverseRotationChanged(int newVal);
    //    void powerLevelChanged(int newVal);
    //    void mfrModeChanged(int newVal);
    //    void shaftPowerChanged(int newVal);
    //    void controlTemperatureChanged(int newVal);

private:
    QSharedPointer<QSerialPort> m_pSerialPort;
    QSharedPointer<BlowerRegalECM> m_pModuleECM;

    void updateActualState();
    void updateDemandState();
    void readSpeedRPM();

    int m_cutbackSpeed;
    int m_interlock;
    int m_speedDutyCycle;

    int m_direction;
    int m_cutbackSlope;
    int m_airflowScalling;
    double m_constantA1;
    double m_constantA2;
    double m_constantA3;
    double m_constantA4;

    int m_address;
    int m_speedRPM;
    int m_airflowDemand;
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

    int m_airflowDemand_Req;
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

    int airflowCFMtoDutyCycle(int value);
    int dutyCycletoAirflowCFM(int value);

    int initSerialPort();

    QVector<int> m_rpmSamples;
    int          m_rpmSamplesSum;
};

#endif // BLOWERECMCOMMMANAGER_H
