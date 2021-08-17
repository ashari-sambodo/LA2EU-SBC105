#pragma once

#include <QObject>

namespace MachineEnums
{
Q_NAMESPACE         // required for meta object creation

enum EnumItemMachineState {
    MACHINE_STATE_SETUP,
    MACHINE_STATE_LOOP,
    MACHINE_STATE_STOP
};
Q_ENUM_NS(EnumItemMachineState)  // register the enum in meta object data

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

enum EnumAirflowCalibState{
    AF_CALIB_NONE,
    AF_CALIB_FACTORY,
    AF_CALIB_FIELD
};
Q_ENUMS(EnumAirflowCalibState)

enum EnumMeasurementUnitState{
    MEA_UNIT_METRIC,
    MEA_UNIT_IMPERIAL,
};
Q_ENUMS(EnumMeasurementUnitState)

enum EnumDigitalState{
    DIG_STATE_ZERO,
    DIG_STATE_ONE,
};
Q_ENUMS(EnumDigitalState)

enum EnumTempAmbientState{
    TEMP_AMB_NORMAL,
    TEMP_AMB_LOW,
    TEMP_AMB_HIGH,
};
Q_ENUMS(EnumTempAmbientState)

enum EnumOperationModeState{
    MODE_OPERATION_QUICKSTART,
    MODE_OPERATION_NORMAL,
    MODE_OPERATION_MAINTENANCE
};
Q_ENUMS(EnumOperationModeState)

enum EnumSecurityAccessState{
    MODE_SECURITY_ACCESS_LOW,
    MODE_SECURITY_ACCESS_MODERATE,
    MODE_SECURITY_ACCESS_SECURE,

};
Q_ENUMS(EnumSecurityAccessState)

enum EnumAlarmState{
    ALARM_NA_STATE,
    ALARM_NORMAL_STATE,
    ALARM_ACTIVE_STATE,
};
Q_ENUMS(EnumAlarmState)

enum EnumAlarmSashState{
    ALARM_SASH_NA_STATE,
    ALARM_SASH_NORMAL_STATE,
    ALARM_SASH_ACTIVE_UNSAFE_STATE,
    ALARM_SASH_ACTIVE_FO_STATE,
    ALARM_SASH_ACTIVE_ERROR_STATE,
};
Q_ENUMS(EnumAlarmSashState)

enum CalibrationMode{
    FULL_CALIBRATION,
    FIELD_CALIBRATION
};
Q_ENUMS(CalibrationMode)

enum EnumItemDigitalInputPin {
    DIGITAL_INPUT_PIN_1,
    DIGITAL_INPUT_PIN_2,
    DIGITAL_INPUT_PIN_3,
    DIGITAL_INPUT_PIN_4,
    DIGITAL_INPUT_PIN_5,
    DIGITAL_INPUT_PIN_6
};
Q_ENUMS(EnumItemDigitalInputPin)
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
