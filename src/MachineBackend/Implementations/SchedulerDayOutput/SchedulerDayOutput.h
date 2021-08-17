#pragma once

#include "../ClassManager.h"

class SchedulerDayOutput : public ClassManager
{
    Q_OBJECT
public:
    explicit SchedulerDayOutput(QObject *parent = nullptr);

    void routineTask(int parameter = 0 ) override;

    void setEnabled(int newVal);
    void setTime(int newVal);
    void setDayRepeat(int newVal);
    void setWeeklyDay(int newVal);

    enum SchedulerDayEnum{
        DAY_MONDAY = 1,
        DAY_TUESDAY,
        DAY_WEDNESDAY,
        DAY_THURSDAY,
        DAY_FRIDAY,
        DAY_SATURDAY,
        DAY_SUNDAY,
    };

    enum SchedulerDaysRepeat{
        DAYS_REPEAT_ONCE,
        DAYS_REPEAT_EVERYDAY,
        DAYS_REPEAT_WEEKDAYS,
        DAYS_REPEAT_WEEKENDS,
        DAYS_REPEAT_WEEKLY,
    };

signals:
    void activated();

    void dayRepeatChanged(int newVal);
    void enabledChanged(int newVal);
    void timeMinuteChanged(int newVal);
    void weeklyDayChanged(int newVal);

private:
    int m_timeMinutes = 0;
    int m_dayRepeat = 0;
    int m_weeklyDay = 0;
    int m_enabled = 0;
};

