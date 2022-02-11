#ifndef PWMOUTMANAGER_H
#define PWMOUTMANAGER_H

#include "../ClassManager.h"
#include "BoardIO/Drivers/PWMpca9685/PWMpca9685.h"

class DevicePWMOut : public ClassManager
{
    Q_OBJECT
public:
    explicit DevicePWMOut(QObject *parent = nullptr);

    void routineTask(int parameter = 0) override;

    void setSubModule(PWMpca9685 * obj);
    void setChannelIO(int channel);
    void setState(int state);
    void setInterlock(int interlock);
    void setDutyCycleMinimum(short dcyMin);

    int interlock() const;
    int state() const;

    bool dummyStateEnable() const;
    void setDummyStateEnable(bool dummyStateEnable);

    short dummyState() const;
    void setDummyState(short dummyState);

signals:
    void stateChanged(int newVal);
    void interlockChanged(int newVal);
    void channelIOChanged(int newVal, int oldVal);
    void workerFinished();

private:
    PWMpca9685  *pSubModule;
    int m_channelIO;

    int m_state;
    int m_interlock;
    int m_stateRequest;
    short m_dcyMin;

    //    bool m_dummyStateEnable = true;
    bool m_dummyStateEnable = false;
    short m_dummyState = 0;
};

#endif // PWMOUTMANAGER_H
