#ifndef MOTORIZEONRELAYMANAGER_H
#define MOTORIZEONRELAYMANAGER_H

#include "../ClassManager.h"
#include "BoardIO/Drivers/PWMpca9685/PWMpca9685.h"

class MotorizeOnRelayManager : public ClassManager
{
    Q_OBJECT
public:
    explicit MotorizeOnRelayManager(QObject *parent = nullptr);

    void worker(int parameter = 0) override;

    void setSubModule(PWMpca9685 *module);

    void setState(short state);
    void setInterlockUp(short interlock);
    void setInterlockDown(short interlock);

    int interlockUp() const;
    int interlockDown() const;

    void setChannelUp(char channelUp);
    void setChannelDown(char channelDown);

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
};

#endif // MOTORIZEONRELAYMANAGER_H
