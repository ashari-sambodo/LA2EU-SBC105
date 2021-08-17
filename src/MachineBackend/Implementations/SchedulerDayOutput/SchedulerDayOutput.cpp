#include <QTime>
#include <QTimer>
#include <QDate>
#include "SchedulerDayOutput.h"

SchedulerDayOutput::SchedulerDayOutput(QObject *parent) : ClassManager(parent)
{

}

void SchedulerDayOutput::routineTask(int parameter)
{
    Q_UNUSED(parameter);

    if(!m_enabled) return;

    int currentTimeMinutes = QTime::currentTime().msecsSinceStartOfDay() / 60000;
#ifdef QT_DEBUG
    qDebug() << currentTimeMinutes << m_timeMinutes;
#endif

    if(m_dayRepeat == DAYS_REPEAT_ONCE){
        //COMPARE_TIME
        if(currentTimeMinutes == m_timeMinutes){
            emit activated();

            //AUTO_DISABLED AFTER ONCE TRIGGERED
            setEnabled(false);
        }
    }else{
        switch (m_dayRepeat) {
        case DAYS_REPEAT_EVERYDAY:
        {
            //COMPARE_TIME
            if(currentTimeMinutes == m_timeMinutes){
                emit activated();
            }
        }
            break;
        case DAYS_REPEAT_WEEKDAYS:
        {
            //COMPARE_DAY
            //            qDebug() << "AUTO WeekDays: " << QDate().currentDate().dayOfWeek();
            if(QDate::currentDate().dayOfWeek() <= DAY_FRIDAY){
                //COMPARE_TIME
                if(currentTimeMinutes == m_timeMinutes){
                    emit activated();
                }
            }
        }
            break;
        case DAYS_REPEAT_WEEKENDS:
        {
            //COMPARE_DAY
            if((QDate::currentDate().dayOfWeek() == DAY_SATURDAY)
                    || (QDate::currentDate().dayOfWeek() == DAY_SUNDAY)){
                //COMPARE_TIME
                if(currentTimeMinutes == m_timeMinutes){
                    emit activated();
                }
            }
        }
            break;
        case DAYS_REPEAT_WEEKLY:
        {
            //COMPARE_DAY
            if(QDate::currentDate().dayOfWeek() == m_weeklyDay){
                //COMPARE_TIME
                if(currentTimeMinutes == m_timeMinutes){
                    emit activated();
                }
            }
        }
            break;
        default:
            break;
        }
    }

}

void SchedulerDayOutput::setEnabled(int newVal)
{
    if (m_enabled == newVal) return;

    m_enabled = newVal;
    emit enabledChanged(m_enabled);
}

void SchedulerDayOutput::setTime(int newVal)
{
    if (m_timeMinutes == newVal) return;

    m_timeMinutes = newVal;
    emit timeMinuteChanged(m_timeMinutes);
}

void SchedulerDayOutput::setDayRepeat(int newVal)
{
    if (m_dayRepeat == newVal) return;

    m_dayRepeat = newVal;
    emit dayRepeatChanged(m_dayRepeat);
}

void SchedulerDayOutput::setWeeklyDay(int newVal)
{
    if (m_weeklyDay == newVal) return;

    m_weeklyDay = newVal;
    emit weeklyDayChanged(m_weeklyDay);
}
