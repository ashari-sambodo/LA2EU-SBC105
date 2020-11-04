#ifndef DIGITALOUTMANAGER_H
#define DIGITALOUTMANAGER_H

#include "../ClassManager.h"
#include "BoardIO/Drivers/PWMpca9685/PWMpca9685.h"

class DigitalOutManager : public ClassManager
{
    Q_OBJECT
public:
    explicit DigitalOutManager(QObject *parent = nullptr);

    void routineTask(int parameter = 0) override;

    void setSubModule(PWMpca9685 * obj);
    void setChannelIO(int channel);
    void setState(int state);
    void setInterlock(int interlock);

    int interlock() const;
    int state() const;

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
};

#endif // DIGITALOUTMANAGER_H
