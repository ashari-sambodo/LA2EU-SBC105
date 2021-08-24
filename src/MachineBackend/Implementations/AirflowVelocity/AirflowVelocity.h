#ifndef AIRFLOWMANAGER_H
#define AIRFLOWMANAGER_H

#include "../ClassManager.h"
#include "BoardIO/Drivers/AImcp3422x/AIManage.h"

#define AIRFLOWNANAGER_MAX_ADC_POINT    3

class AirflowVelocity : public ClassManager
{
    Q_OBJECT
public:
    explicit AirflowVelocity(QObject *parent = nullptr);

    void setAIN(AIManage *value);
    void setChannel(int channel);

    void routineTask(int parameter = 0) override;

    //    void calculateCompensationADC();

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

    void setTemperature(int newVal);
    void setAdcResolutionBits(unsigned char bits);

    enum CALIB_POINT_MODE {AFCALIB_POINT_3POINTS, AFCALIB_POINT_2POINTS};

    bool getDummyStateEnable() const;
    void setDummyStateEnable(bool dummyStateEnable);

    int getDummyState() const;
    void setDummyState(int dummyState);

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
    int m_temperature;
    bool m_temperatureChanged = false;
    bool m_sensorConstantChanged = false;
    bool m_scopeChanged = false;

    int m_adcPoint[AIRFLOWNANAGER_MAX_ADC_POINT] = { 0 };  /// fill all element to zero
    double m_velocityPoint[AIRFLOWNANAGER_MAX_ADC_POINT] = { 0 }; /// fill all element to zero

    //scope cache
    //scope 1
    double m_m1;
    double m_b1;
    //scope 2
    double m_m2;
    double m_b2;

    short m_calibPointMode = 0;

    unsigned char m_maxAdcResBits;

    int adcDummy;

    bool m_adcChanged;
    bool m_velocityChanged;

    bool m_dummyStateEnable = false;
    int m_dummyState = 0;
};

#endif // AIRFLOWMANAGER_H
