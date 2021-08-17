#pragma once
#include <QObject>

#define EVENT_STR_POWER_ON          QObject::tr("System on")
#define EVENT_STR_POWER_OFF         QObject::tr("System stopped")
#define EVENT_STR_POWER_FAILURE     QObject::tr("Power failure at")

#define EVENT_STR_PWR_FAIL_FAN      QObject::tr("Power recovered! Set back Fan to on")
#define EVENT_STR_PWR_FAIL_UV       QObject::tr("Power recovered! Set back UV to on")

#define EVENT_STR_SASH_SAFE         QObject::tr("Sash safe height")
#define EVENT_STR_SASH_UNSAFE       QObject::tr("Sash unsafe height")
#define EVENT_STR_SASH_FC           QObject::tr("Sash fully close")
#define EVENT_STR_SASH_FO           QObject::tr("Sash fully open")
#define EVENT_STR_SASH_STB          QObject::tr("Sash fully standby")
#define EVENT_STR_SASH_ERROR        QObject::tr("Sash unknown state")

#define EVENT_STR_FAN_ON_SCH        QObject::tr("Fan scheduler has trigger")
#define EVENT_STR_UV_ON_SCH         QObject::tr("UV scheduler has trigger")

#define EVENT_STR_FAN_ON            QObject::tr("Set Fan on")
#define EVENT_STR_FAN_STANDBY       QObject::tr("Set Fan standby")
#define EVENT_STR_FAN_OFF           QObject::tr("Set Fan off")

#define EVENT_STR_LIGHT_ON           QObject::tr("Set Light on")

#define EVENT_STR_MODBUS_CON        QObject::tr("Modbus connected")
#define EVENT_STR_MODBUS_DIS        QObject::tr("Modbus disconnected")
#define EVENT_STR_MODBUS_REJECT     QObject::tr("Modbus rejected")

#define EVENT_STR_TEMP_AMB_LOW      QObject::tr("Enviromental temp too low")
#define EVENT_STR_TEMP_AMB_HIGH     QObject::tr("Enviromental temp too high")
#define EVENT_STR_TEMP_AMB_NORM     QObject::tr("Enviromental temp too normal")
