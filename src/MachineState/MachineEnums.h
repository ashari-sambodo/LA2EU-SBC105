#pragma once

#include <QObject>

namespace MachineEnums
{
Q_NAMESPACE         // required for meta object creation
enum EnumItemState {
    MACHINE_STATE_SETUP,
    MACHINE_STATE_LOOP,
    MACHINE_STATE_STOPPING
};
Q_ENUM_NS(EnumItemState)  // register the enum in meta object data
}

//class MachineEnums : public QObject
//{
//    Q_OBJECT
//public:
//    MachineEnums(QObject *parent = nullptr) : QObject(parent) {}

//    enum EnumItemState {
//        MACHINE_STATE_SETUP,
//        MACHINE_STATE_LOOP,
//        MACHINE_STATE_STOPPING
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
