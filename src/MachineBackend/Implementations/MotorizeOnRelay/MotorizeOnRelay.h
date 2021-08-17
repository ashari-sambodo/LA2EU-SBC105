#ifndef MOTORIZEONRELAYMANAGER_H
#define MOTORIZEONRELAYMANAGER_H

#include "../ClassManager.h"
#include "BoardIO/Drivers/PWMpca9685/PWMpca9685.h"

class MotorizeOnRelay : public ClassManager
{
    Q_OBJECT
public:
    explicit MotorizeOnRelay(QObject *parent = nullptr);

    void routineTask(int parameter = 0) override;

    void setSubModule(PWMpca9685 *module);

    void setState(short state);
    void setInterlockUp(short interlock);
    void setInterlockDown(short interlock);

    int interlockUp() const;
    int interlockDown() const;

    void setChannelUp(char channelUp);
    void setChannelDown(char channelDown);

    bool protectFromDualActive() const;
    void setProtectFromDualActive(bool protectFromDualActive);

    bool dummyStateEnable() const;
    void setDummyStateEnable(bool dummyStateEnable);

    short dummyState() const;
    void setDummyState(short dummyState);

signals:
    void stateChanged(int newVal);
    void interlockUpChanged(int newVal);
    void interlockDownChanged(int newVal);

private:
    PWMpca9685  *pSubModule;
    char m_channelUp;
    char m_channelDown;

    short m_state;
    short m_stateRequest;

    short m_interlockUp;
    short m_interlockDown;

    bool m_protectFromDualActive = true;

    bool m_dummyStateEnable = false;
    short m_dummyState = 0;
};

#endif // MOTORIZEONRELAYMANAGER_H
