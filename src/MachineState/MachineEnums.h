#pragma once

#include <QObject>

namespace MachineEnums
{
Q_NAMESPACE         // required for meta object creation

enum EnumItemState {
    MACHINE_STATE_SETUP,
    MACHINE_STATE_LOOP,
    MACHINE_STATE_STOP
};
Q_ENUM_NS(EnumItemState)  // register the enum in meta object data

enum EnumItemSashState{
    SASH_STATE_ERROR_SENSOR_SSV,
    SASH_STATE_FULLY_CLOSE_SSV,
    SASH_STATE_UNSAFE_SSV,
    SASH_STATE_STANDBY_SSV,
    SASH_STATE_WORK_SSV,
    SASH_STATE_FULLY_OPEN_SSV
};
Q_ENUMS(EnumItemSashState)

enum EnumItemFanState{
    FAN_STATE_OFF,
    FAN_STATE_ON,
    FAN_STATE_STANDBY
};
Q_ENUMS(EnumItemFanState)

enum EnumMotorSashState{
    MOTOR_SASH_STATE_OFF,
    MOTOR_SASH_STATE_UP,
    MOTOR_SASH_STATE_DOWN,
    MOTOR_SASH_STATE_UP_DOWN
};
Q_ENUMS(EnumMotorSashState)

}

//class MachineEnums : public QObject
//{
//    Q_OBJECT
//public:
//    MachineEnums(QObject *parent = nullptr) : QObject(parent) {}

//    enum EnumItemState {
//        MACHINE_STATE_SETUP,
//        MACHINE_STATE_LOOP,
//        MACHINE_STATE_STOP
//    };
//    Q_ENUM(EnumItemState)

//    //    enum EnumItemSashState : quint8 {
//    //        SASH_STATE_ERROR_SENSOR_SSV,
//    //        SASH_STATE_FULLY_CLOSE_SSV,
//    //        SASH_STATE_UNSAFE_SSV,
//    //        SASH_STATE_STANDBY_SSV,
//    //        SASH_STATE_WORK_SSV,
//    //        SASH_STATE_FULLY_OPEN_SSV
//    //    };
//};
