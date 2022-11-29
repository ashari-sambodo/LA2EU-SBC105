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
    FAN_STATE_STANDBY,
    FAN_STATE_DIFFERENT // The condition is when both of fan are on but the state is not the same
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

enum EnumUserRoleLevel {
    USER_LEVEL_GUEST,
    USER_LEVEL_OPERATOR,
    USER_LEVEL_SUPERVISOR,
    USER_LEVEL_ADMIN,
    USER_LEVEL_SERVICE,
    USER_LEVEL_SERVICE_ESCO,
    USER_LEVEL_FACTORY,
};
Q_ENUMS(EnumUserRoleLevel)
enum EnumSecurityAccessState{
    MODE_SECURITY_ACCESS_LOW,
    MODE_SECURITY_ACCESS_MEDIUM,
    MODE_SECURITY_ACCESS_HIGH,

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

enum FanList{
    FAN_DOWNFLOW,
    FAN_INFLOW
};
Q_ENUMS(FanList)

enum ExternalResourcePathCode{
    Resource_QuickTourAsset,
    Resource_General
};
Q_ENUMS(ExternalResourcePathCode)

enum GeneralPurposeEnums{
    BUSY_CYCLE_1 = 1,
    BUSY_CYCLE_2,
    BUSY_CYCLE_3,
    BUSY_CYCLE_4,
    BUSY_CYCLE_5,
    BUSY_CYCLE_10 = 10,
    BUSY_CYCLE_FAN = 2,
    FOOTER_HEIGHT = 70
};
Q_ENUMS(GeneralPurposeEnums)

//enum PreventiveMaintenance{
//    PM_DAILY,
//    PM_WEEKLY,
//    PM_MONTHLY,
//    PM_QUARTERLY,
//    PM_ANNUALLY,
//    PM_BIENNIALLY,
//    PM_QUINQUENNIALLY,
//    PM_CANOPY,
//    Total_PM
//};
//Q_ENUMS(PreventiveMaintenance)

enum PreventiveMaintenanceCode{
    PM_DAILY_CODE           = 0x0001,
    PM_WEEKLY_CODE          = 0x0002,
    PM_MONTHLY_CODE         = 0x0004,
    PM_QUARTERLY_CODE       = 0x0008,
    PM_ANNUALLY_CODE        = 0x0010,
    PM_BIENNIALLY_CODE      = 0x0020,
    PM_QUINQUENNIALLY_CODE  = 0x0040,
    PM_CANOPY_CODE          = 0x0080,
};
Q_ENUMS(PreventiveMaintenanceCode)


enum ReplaceableTableHeaderEnums {
    RPList_ROWID,// show

    RPList_UnitModel,
    RPList_UnitSerialNumber,
    RPList_Date,
    RPList_Time,
    RPList_UserManualCode,
    RPList_UserManualVersion,
    RPList_ElectricalPanel,
    RPList_ElectricalPanelSerialNumber,
    RPList_ElectricalTester,
    RPList_SBCSet1Name,
    RPList_SBCSet2Name,
    RPList_SBCSet3Name,
    RPList_SBCSet4Name,
    RPList_SBCSet5Name,
    RPList_SBCSet6Name,
    RPList_SBCSet7Name,
    RPList_SBCSet8Name,
    RPList_SBCSet9Name,
    RPList_SBCSet10Name,
    RPList_SBCSet11Name,
    RPList_SBCSet12Name,
    RPList_SBCSet13Name,
    RPList_SBCSet14Name,
    RPList_SBCSet15Name,
    RPList_SBCSet1Code,
    RPList_SBCSet2Code,
    RPList_SBCSet3Code,
    RPList_SBCSet4Code,
    RPList_SBCSet5Code,
    RPList_SBCSet6Code,
    RPList_SBCSet7Code,
    RPList_SBCSet8Code,
    RPList_SBCSet9Code,
    RPList_SBCSet10Code,
    RPList_SBCSet11Code,
    RPList_SBCSet12Code,
    RPList_SBCSet13Code,
    RPList_SBCSet14Code,
    RPList_SBCSet15Code,
    RPList_SBCSet1Qty,
    RPList_SBCSet2Qty,
    RPList_SBCSet3Qty,
    RPList_SBCSet4Qty,
    RPList_SBCSet5Qty,
    RPList_SBCSet6Qty,
    RPList_SBCSet7Qty,
    RPList_SBCSet8Qty,
    RPList_SBCSet9Qty,
    RPList_SBCSet10Qty,
    RPList_SBCSet11Qty,
    RPList_SBCSet12Qty,
    RPList_SBCSet13Qty,
    RPList_SBCSet14Qty,
    RPList_SBCSet15Qty,
    RPList_SBCSet1SN,
    RPList_SBCSet2SN,
    RPList_SBCSet3SN,
    RPList_SBCSet4SN,
    RPList_SBCSet5SN,
    RPList_SBCSet6SN,
    RPList_SBCSet7SN,
    RPList_SBCSet8SN,
    RPList_SBCSet9SN,
    RPList_SBCSet10SN,
    RPList_SBCSet11SN,
    RPList_SBCSet12SN,
    RPList_SBCSet13SN,
    RPList_SBCSet14SN,
    RPList_SBCSet15SN,
    RPList_SBCSet1SW,
    RPList_SBCSet2SW,
    RPList_SBCSet3SW,
    RPList_SBCSet4SW,
    RPList_SBCSet5SW,
    RPList_SBCSet6SW,
    RPList_SBCSet7SW,
    RPList_SBCSet8SW,
    RPList_SBCSet9SW,
    RPList_SBCSet10SW,
    RPList_SBCSet11SW,
    RPList_SBCSet12SW,
    RPList_SBCSet13SW,
    RPList_SBCSet14SW,
    RPList_SBCSet15SW,
    RPList_SBCSet1Check,
    RPList_SBCSet2Check,
    RPList_SBCSet3Check,
    RPList_SBCSet4Check,
    RPList_SBCSet5Check,
    RPList_SBCSet6Check,
    RPList_SBCSet7Check,
    RPList_SBCSet8Check,
    RPList_SBCSet9Check,
    RPList_SBCSet10Check,
    RPList_SBCSet11Check,
    RPList_SBCSet12Check,
    RPList_SBCSet13Check,
    RPList_SBCSet14Check,
    RPList_SBCSet15Check,
    RPList_Sensor1Name,
    RPList_Sensor2Name,
    RPList_Sensor3Name,
    RPList_Sensor4Name,
    RPList_Sensor5Name,
    RPList_Sensor1Code,
    RPList_Sensor2Code,
    RPList_Sensor3Code,
    RPList_Sensor4Code,
    RPList_Sensor5Code,
    RPList_Sensor1Qty,
    RPList_Sensor2Qty,
    RPList_Sensor3Qty,
    RPList_Sensor4Qty,
    RPList_Sensor5Qty,
    RPList_Sensor1SN,
    RPList_Sensor2SN,
    RPList_Sensor3SN,
    RPList_Sensor4SN,
    RPList_Sensor5SN,
    RPList_Sensor1Const,
    RPList_Sensor2Const,
    RPList_Sensor3Const,
    RPList_Sensor4Const,
    RPList_Sensor5Const,
    RPList_Sensor1Check,
    RPList_Sensor2Check,
    RPList_Sensor3Check,
    RPList_Sensor4Check,
    RPList_Sensor5Check,
    RPList_UVLED1Name,
    RPList_UVLED2Name,
    RPList_UVLED3Name,
    RPList_UVLED4Name,
    RPList_UVLED5Name,
    RPList_UVLED6Name,
    RPList_UVLED1Code,
    RPList_UVLED2Code,
    RPList_UVLED3Code,
    RPList_UVLED4Code,
    RPList_UVLED5Code,
    RPList_UVLED6Code,
    RPList_UVLED1Qty,
    RPList_UVLED2Qty,
    RPList_UVLED3Qty,
    RPList_UVLED4Qty,
    RPList_UVLED5Qty,
    RPList_UVLED6Qty,
    RPList_UVLED1SN,
    RPList_UVLED2SN,
    RPList_UVLED3SN,
    RPList_UVLED4SN,
    RPList_UVLED5SN,
    RPList_UVLED6SN,
    RPList_UVLED1Check,
    RPList_UVLED2Check,
    RPList_UVLED3Check,
    RPList_UVLED4Check,
    RPList_UVLED5Check,
    RPList_UVLED6Check,
    RPList_PSU1Name,
    RPList_PSU2Name,
    RPList_PSU3Name,
    RPList_PSU4Name,
    RPList_PSU5Name,
    RPList_PSU1Code,
    RPList_PSU2Code,
    RPList_PSU3Code,
    RPList_PSU4Code,
    RPList_PSU5Code,
    RPList_PSU1Qty,
    RPList_PSU2Qty,
    RPList_PSU3Qty,
    RPList_PSU4Qty,
    RPList_PSU5Qty,
    RPList_PSU1SN,
    RPList_PSU2SN,
    RPList_PSU3SN,
    RPList_PSU4SN,
    RPList_PSU5SN,
    RPList_PSU1Check,
    RPList_PSU2Check,
    RPList_PSU3Check,
    RPList_PSU4Check,
    RPList_PSU5Check,
    RPList_MCBEMI1Name,
    RPList_MCBEMI2Name,
    RPList_MCBEMI3Name,
    RPList_MCBEMI4Name,
    RPList_MCBEMI5Name,
    RPList_MCBEMI1Code,
    RPList_MCBEMI2Code,
    RPList_MCBEMI3Code,
    RPList_MCBEMI4Code,
    RPList_MCBEMI5Code,
    RPList_MCBEMI1Qty,
    RPList_MCBEMI2Qty,
    RPList_MCBEMI3Qty,
    RPList_MCBEMI4Qty,
    RPList_MCBEMI5Qty,
    RPList_MCBEMI1SN,
    RPList_MCBEMI2SN,
    RPList_MCBEMI3SN,
    RPList_MCBEMI4SN,
    RPList_MCBEMI5SN,
    RPList_MCBEMI1Check,
    RPList_MCBEMI2Check,
    RPList_MCBEMI3Check,
    RPList_MCBEMI4Check,
    RPList_MCBEMI5Check,
    RPList_ContactSw1Name,
    RPList_ContactSw2Name,
    RPList_ContactSw3Name,
    RPList_ContactSw4Name,
    RPList_ContactSw5Name,
    RPList_ContactSw1Code,
    RPList_ContactSw2Code,
    RPList_ContactSw3Code,
    RPList_ContactSw4Code,
    RPList_ContactSw5Code,
    RPList_ContactSw1Qty,
    RPList_ContactSw2Qty,
    RPList_ContactSw3Qty,
    RPList_ContactSw4Qty,
    RPList_ContactSw5Qty,
    RPList_ContactSw1SN,
    RPList_ContactSw2SN,
    RPList_ContactSw3SN,
    RPList_ContactSw4SN,
    RPList_ContactSw5SN,
    RPList_ContactSw1Check,
    RPList_ContactSw2Check,
    RPList_ContactSw3Check,
    RPList_ContactSw4Check,
    RPList_ContactSw5Check,
    RPList_BMotor1Name,
    RPList_BMotor2Name,
    RPList_BMotor3Name,
    RPList_BMotor4Name,
    RPList_BMotor5Name,
    RPList_BMotor1Code,
    RPList_BMotor2Code,
    RPList_BMotor3Code,
    RPList_BMotor4Code,
    RPList_BMotor5Code,
    RPList_BMotor1Qty,
    RPList_BMotor2Qty,
    RPList_BMotor3Qty,
    RPList_BMotor4Qty,
    RPList_BMotor5Qty,
    RPList_BMotor1SNMotor,
    RPList_BMotor2SNMotor,
    RPList_BMotor3SNMotor,
    RPList_BMotor4SNMotor,
    RPList_BMotor5SNMotor,
    RPList_BMotor1SNBlower,
    RPList_BMotor2SNBlower,
    RPList_BMotor3SNBlower,
    RPList_BMotor4SNBlower,
    RPList_BMotor5SNBlower,
    RPList_BMotor1SW,
    RPList_BMotor2SW,
    RPList_BMotor3SW,
    RPList_BMotor4SW,
    RPList_BMotor5SW,
    RPList_BMotor1Check,
    RPList_BMotor2Check,
    RPList_BMotor3Check,
    RPList_BMotor4Check,
    RPList_BMotor5Check,
    RPList_CapInd1Name,
    RPList_CapInd2Name,
    RPList_CapInd3Name,
    RPList_CapInd4Name,
    RPList_CapInd5Name,
    RPList_CapInd1Code,
    RPList_CapInd2Code,
    RPList_CapInd3Code,
    RPList_CapInd4Code,
    RPList_CapInd5Code,
    RPList_CapInd1Qty,
    RPList_CapInd2Qty,
    RPList_CapInd3Qty,
    RPList_CapInd4Qty,
    RPList_CapInd5Qty,
    RPList_CapInd1SN,
    RPList_CapInd2SN,
    RPList_CapInd3SN,
    RPList_CapInd4SN,
    RPList_CapInd5SN,
    RPList_CapInd1Check,
    RPList_CapInd2Check,
    RPList_CapInd3Check,
    RPList_CapInd4Check,
    RPList_CapInd5Check,
    RPList_Custom1Name,
    RPList_Custom2Name,
    RPList_Custom3Name,
    RPList_Custom4Name,
    RPList_Custom5Name,
    RPList_Custom6Name,
    RPList_Custom7Name,
    RPList_Custom8Name,
    RPList_Custom1Code,
    RPList_Custom2Code,
    RPList_Custom3Code,
    RPList_Custom4Code,
    RPList_Custom5Code,
    RPList_Custom6Code,
    RPList_Custom7Code,
    RPList_Custom8Code,
    RPList_Custom1Qty,
    RPList_Custom2Qty,
    RPList_Custom3Qty,
    RPList_Custom4Qty,
    RPList_Custom5Qty,
    RPList_Custom6Qty,
    RPList_Custom7Qty,
    RPList_Custom8Qty,
    RPList_Custom1SN,
    RPList_Custom2SN,
    RPList_Custom3SN,
    RPList_Custom4SN,
    RPList_Custom5SN,
    RPList_Custom6SN,
    RPList_Custom7SN,
    RPList_Custom8SN,
    RPList_Custom1Check,
    RPList_Custom2Check,
    RPList_Custom3Check,
    RPList_Custom4Check,
    RPList_Custom5Check,
    RPList_Custom6Check,
    RPList_Custom7Check,
    RPList_Custom8Check,
    RPList_Filter1Name,
    RPList_Filter2Name,
    RPList_Filter3Name,
    RPList_Filter4Name,
    RPList_Filter5Name,
    RPList_Filter1Code,
    RPList_Filter2Code,
    RPList_Filter3Code,
    RPList_Filter4Code,
    RPList_Filter5Code,
    RPList_Filter1Qty,
    RPList_Filter2Qty,
    RPList_Filter3Qty,
    RPList_Filter4Qty,
    RPList_Filter5Qty,
    RPList_Filter1SN,
    RPList_Filter2SN,
    RPList_Filter3SN,
    RPList_Filter4SN,
    RPList_Filter5SN,
    RPList_Filter1Size,
    RPList_Filter2Size,
    RPList_Filter3Size,
    RPList_Filter4Size,
    RPList_Filter5Size,
    RPList_Filter1Check,
    RPList_Filter2Check,
    RPList_Filter3Check,
    RPList_Filter4Check,
    RPList_Filter5Check,

    /// User
    RPList_UserName,// show
    RPList_UserFullName,// show

    RPList_Total
};
Q_ENUMS(ReplaceableTableHeaderEnums)

enum ScreenState{
    ScreenState_Home,
    ScreenState_ResourceMonitor,
    ScreenState_ReplaceableComponent,
    ScreenState_SerialNumber,
    ScreenState_KeyboardOnScreen,
    ScreenState_Other,
};
Q_ENUMS(ScreenState)

enum CabinetSideType{
    CABINET_TYPE_S, // Stainless steel side
    CABINET_TYPE_E // Glass side
};
Q_ENUMS(CabinetSideType)


enum CalibrationStateField{
    CalFieldState_InflowDimNominal,
    CalFieldState_InflowSecNominal,
    CalFieldState_DownflowNominal,
    CalFieldState_SensorConstant,
    CalFieldState_AdcNominal,
    CalFieldState_Total
};
Q_ENUMS(CalibrationStateField)

enum CalibrationStateFactory{
    CalFactoryState_InflowDimNominal,
    CalFactoryState_InflowDimMinimum,
    CalFactoryState_InflowDimStandby,
    CalFactoryState_DownflowNominal,
    CalFactoryState_SensorConstant,
    CalFactoryState_Total
};
Q_ENUMS(CalibrationStateFactory)

enum ResourceMonitor{
    ResMon_CPU_Usage,
    ResMon_CPU_Temp,
    ResMon_Memory_Usage,
    ResMon_SD_Card_Life
};
Q_ENUMS(ResourceMonitor)

enum FilterLifeCalculationMode{
    FilterLifeCalc_BlowerUsage,
    FilterLifeCalc_BlowerRpm,
};
Q_ENUMS(FilterLifeCalculationMode)

enum PointCalib{
    POINT_ZERO,
    POINT_MINIMUM,
    POINT_NOMINAL,
    POINT_MAXIMUM,
    POINT_TOTAL
};
Q_ENUMS(PointCalib)
enum DisplayTheme{
    THEME_NORMAL,
    THEME_DARK
};
Q_ENUMS(DisplayTheme)

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
