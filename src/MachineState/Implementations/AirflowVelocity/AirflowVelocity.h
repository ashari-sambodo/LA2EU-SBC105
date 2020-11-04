#ifndef AIRFLOWMANAGER_H
#define AIRFLOWMANAGER_H

#include "../ClassManager.h"
#include "BoardIO/Drivers/AImcp3422x/AIManage.h"

#define AIRFLOWNANAGER_MAX_ADC_POINT    3

class AirflowManager : public ClassManager
{
    Q_OBJECT
public:
    explicit AirflowManager(QObject *parent = nullptr);

    void setAIN(AIManage *value);
    void setChannel(int channel);

    void routineTask(int parameter = 0);

    void calculateCompensationADC();

    void setAdcPoint(int point, int value);
    void setVelocityPoint(int point, double value);
    void setConstant(int value);
    void initScope();

    int adc() const;
    int adcConpensation() const;
    double velocity() const;

    double getM1() const;
    double getM2() const;
    double getB1() const;
    double getB2() const;

    double getVelocityPoint(int point) const;

    bool getAdcChanged() const;
    void setAdcChanged(bool newVal);

    bool getVelocityChanged() const;
    void setVelocityChanged(bool velocityChanged);

    void setTemperature(double newVal);

signals:
    void adcChanged(int val);
    void adcConpensationChanged(int val);
    void velocityChanged(double val);
    void workerFinished();

private:
    AIManage * pAI;
    int m_channel;

    int m_adc;
    int m_adcConpensation;
    double m_velocity;
    int m_constant;
    double m_temperature;
    bool m_temperatureChanged;

    int m_adcPoint[AIRFLOWNANAGER_MAX_ADC_POINT];
    double m_velocityPoint[AIRFLOWNANAGER_MAX_ADC_POINT];

    //scope cache
    //scope 1
    double m_m1;
    double m_b1;
    //scope 2
    double m_m2;
    double m_b2;

    int adcDummy;

    bool m_adcChanged;
    bool m_velocityChanged;
};

#endif // AIRFLOWMANAGER_H
