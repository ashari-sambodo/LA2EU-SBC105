#pragma once
#include <QObject>

#define EVENT_STR_POWER_ON          QObject::tr("System ON")
#define EVENT_STR_POWER_OFF         QObject::tr("System stopped")
#define EVENT_STR_POWER_FAILURE     QObject::tr("Power failure at")

#define EVENT_STR_PWR_FAIL_FAN      QObject::tr("Power recovered! Set back Fan to ON")
#define EVENT_STR_PWR_FAIL_UV       QObject::tr("Power recovered! Set back UV to ON")

#define EVENT_STR_SASH_SAFE         QObject::tr("Sash safe height")
#define EVENT_STR_SASH_UNSAFE       QObject::tr("Sash unsafe height")
#define EVENT_STR_SASH_FC           QObject::tr("Sash fully closed")
#define EVENT_STR_SASH_FO           QObject::tr("Sash fully opened")
#define EVENT_STR_SASH_STB          QObject::tr("Sash standby")
#define EVENT_STR_SASH_ERROR        QObject::tr("Sash unknown state")

#define EVENT_STR_FAN_ON_SCH        QObject::tr("Fan On scheduler has triggered")
#define EVENT_STR_FAN_OFF_SCH        QObject::tr("Fan Off scheduler has triggered")
#define EVENT_STR_UV_ON_SCH         QObject::tr("UV On scheduler has triggered")
#define EVENT_STR_UV_OFF_SCH         QObject::tr("UV Off scheduler has triggered")

#define EVENT_STR_FAN_ON            QObject::tr("Set Fan ON")
#define EVENT_STR_FAN_STANDBY       QObject::tr("Set Fan Standby")
#define EVENT_STR_FAN_OFF           QObject::tr("Set Fan OFF")

#define EVENT_STR_LIGHT_ON           QObject::tr("Set Light ON")

#define EVENT_STR_MODBUS_CON        QObject::tr("Modbus connected")
#define EVENT_STR_MODBUS_DIS        QObject::tr("Modbus disconnected")
#define EVENT_STR_MODBUS_REJECT     QObject::tr("Modbus rejected")

#define EVENT_STR_TEMP_AMB_LOW      QObject::tr("Environmental temp too low")
#define EVENT_STR_TEMP_AMB_HIGH     QObject::tr("Environmental temp too high")
#define EVENT_STR_TEMP_AMB_NORM     QObject::tr("Environmental temp normal")
