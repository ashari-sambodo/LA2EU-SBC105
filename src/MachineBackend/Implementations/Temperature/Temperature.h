#ifndef TEMPERATUREMANAGER_H
#define TEMPERATUREMANAGER_H

#include "../ClassManager.h"
#include "BoardIO/Drivers/AImcp3422x/AIManage.h"

class Temperature : public ClassManager
{
    Q_OBJECT
public:
    explicit Temperature(QObject *parent = nullptr);

    void routineTask(int parameter = 0) override;

    void setSubModule(AIManage *obj);
    void setChannelIO(int channel);

    int celcius() const;
    double celciusPrecision() const;

    void setPrecision(int newVal);

    bool dummyStateEnable() const;
    void setDummyStateEnable(bool dummyStateEnable);

    int dummyAdcState() const;
    void setDummyAdcState(short dummyAdcState);

    int dummyMVoltState() const;
    void setDummyMVoltState(int dummyMVoltState);

signals:
    void workerFinished();
    void channelIOChanged(int newChannel, int oldChannel);

    void adcChanged(int newVal);
    void voltageChanged(int newVal);
    void celciusChanged(int newVal);
    void celciusPrecisionChanged(double newVal);

private:
    AIManage    *pSubModule;

    int m_adc;
    int m_mVolt;
    int m_celcius;
    double m_celciusPrecision;
    int m_channelIO;
    int m_precision;

    int voltageToTemperature(int mVolt);
    double voltageToTemperaturePrecision(int mVolt);
    int temperatureToVoltage(int temperature);

    bool m_dummyStateEnable = false;
    int m_dummyAdcState = 0;
    int m_dummyMVoltState = 0;

};

#endif // TEMPERATUREMANAGER_H
