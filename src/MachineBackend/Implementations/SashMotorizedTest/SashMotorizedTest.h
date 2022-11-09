#ifndef SASHMOTORIZEDTEST_H
#define SASHMOTORIZEDTEST_H
#include "../ClassManager.h"

class SashMotorizedTest : public ClassManager {
    Q_OBJECT
public:
    explicit SashMotorizedTest(QObject *parent = nullptr);

    void routineTask(int parameter = 0) override;

    void setSashMotorizedDelayBetweenRun(int value);
    void setSashMotorizedRunCycleLimit(int value);
    void setSashMotorizedTestRunTime(int value);
    void setSashMotorizedTriggeredTimeout(int value);
    void start();
    void stop();

public slots:
    void setSashCycle(int value);
    void setSashMotorizedState(short value);
    void setSashState(short value);

signals:
    void sashMotorizeStateChanged(short value);
    void sashMotorizedTestRunTimeChanged(int value);
    void startRoutineTaskTimer();
    void stopRoutineTaskTimer();
    void started();
    void stopped();

private:
    enum EnumItemSashState{
        SASH_ERROR_SENSOR,
        SASH_FULLY_CLOSED,
        SASH_UNSAFE,
        SASH_STANDBY,
        SASH_WORK,
        SASH_FULLY_OPENED
    };
    Q_ENUMS(EnumItemSashState)

    enum EnumMotorSashState{
        MOTOR_SASH_STATE_OFF,
        MOTOR_SASH_STATE_UP,
        MOTOR_SASH_STATE_DOWN,
        MOTOR_SASH_STATE_UP_DOWN
    };
    Q_ENUMS(EnumMotorSashState)

    void _setSashMotorizedState(short value);

    int m_SashCycle = 0;
    int m_SashMotorizedDelayBetweenRun = 10 * 60;
    int m_SashMotorizedRunCycleLimit = 4;
    int m_SashMotorizedTestRunTime = 0;
    int m_SashMotorizedTriggeredTimeout = 10; // 10 seconds
    short m_SashMotorizedState = 0;
    short m_SashState = 0;
    short m_SashStatePrev = 0;

    int m_SashMotorizedDelayBetweenRunCountDown = 0;
    short m_SashCycleCountDown = 0;
    int m_TimeoutCountDown = 0;
};
#endif // SASHMOTORIZEDTEST_H
