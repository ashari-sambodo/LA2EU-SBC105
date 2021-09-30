#pragma once
#include <QObject>

#define ALARM_LOG_TEXT_SASH_OK              QObject::tr("Alarm Sash | Normal | Safe height ")
#define ALARM_LOG_TEXT_SASH_UNSAFE          QObject::tr("Alarm Sash | Fail | Unsafe height")
#define ALARM_LOG_TEXT_SASH_FO              QObject::tr("Alarm Sash | Fail | Fully open")
#define ALARM_LOG_TEXT_SASH_ERROR           QObject::tr("Alarm Sash | Fail | Sensor Error")

#define ALARM_LOG_TEXT_INFLOW_ALARM_OK      QObject::tr("Alarm Inflow | Normal")
#define ALARM_LOG_TEXT_INFLOW_ALARM_TOO_LOW QObject::tr("Alarm Inflow | Fail | Too low")

#define ALARM_LOG_TEXT_DOWNFLOW_ALARM_OK        QObject::tr("Alarm Downflow | Normal")
#define ALARM_LOG_TEXT_DOWNFLOW_ALARM_TOO_LOW   QObject::tr("Alarm Downflow | Fail | Too low")
#define ALARM_LOG_TEXT_DOWNFLOW_ALARM_TOO_HIGH  QObject::tr("Alarm Downflow | Fail | Too high")

#define ALARM_LOG_TEXT_SEAS_OK              QObject::tr("Alarm Exhaust | Normal")
#define ALARM_LOG_TEXT_SEAS_TOO_HIGH        QObject::tr("Alarm Exhaust | Fail | Too high")

#define ALARM_LOG_TEXT_SEAS_FLAP_OK         QObject::tr("Alarm Exhaust | Normal")
#define ALARM_LOG_TEXT_SEAS_FLAP_LOW        QObject::tr("Alarm Exhaust | Fail | Too low")

#define ALARM_LOG_TEXT_ENV_TEMP_OK          QObject::tr("Alarm Temperature | Normal")
#define ALARM_LOG_TEXT_ENV_TEMP_TOO_LOW     QObject::tr("Alarm Temperature | Fail | Too low")
#define ALARM_LOG_TEXT_ENV_TEMP_TOO_HIGH    QObject::tr("Alarm Temperature | Fail | Too high")

#define ALARM_LOG_TEXT_FAN_STB_OFF_OK    QObject::tr("Alarm Fan Standby | Normal")
#define ALARM_LOG_TEXT_FAN_STB_OFF_ACTIVE      QObject::tr("Alarm Fan Standby | Active")

#define ALARM_LOG_TEXT_SASH_MOTOR_OK          QObject::tr("Alarm Sash Cycle | Normal")
#define ALARM_LOG_TEXT_SASH_MOTOR_LOCKED      QObject::tr("Alarm Sash Cycle | Locked")

#define ALARM_LOG_TEXT_FRONT_PANEL_OK      QObject::tr("Front Panel Alarm | Normal")
#define ALARM_LOG_TEXT_FRONT_PANEL_ALARM   QObject::tr("Front Panel Alarm | Active")
