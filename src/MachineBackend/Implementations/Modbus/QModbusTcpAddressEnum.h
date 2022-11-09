#pragma once
#include <QObject>

namespace Addrs
{
Q_NAMESPACE
enum Register{
    OperationMode,
    SashState,
    FanState,
    DfaFanState,
    DfaFanDutyCycle,
    DfaFanRpm,
    DfaFanUsage,
    IfaFanState,
    IfaFanDutyCycle,
    IfaFanRpm,
    IfaFanUsage,
    LightState,
    LightIntensity,
    SocketState,
    GasState,
    UvState,
    UvLifeLeft,
    FilterLife,
    SashMotorizeState,
    SashCycle,
    MeaUnit,
    Temperature,
    AirflowInflow,
    AirflowDownflow,
    ExhaustVolume,
    PressureExhaust,
    FanClosedLoopControl,
    ParticleCounter0_5um,
    ParticleCounter5um,
    AlarmSash,
    AlarmInflowLow,
    AlarmInflowHigh,
    AlarmDownflowLow,
    AlarmDownflowHigh,
    AlarmExhaustLow,
    AlarmFlapExhaust,
    AlarmBoardCom,
    AlarmTempLow,
    AlarmTempHigh,
    AlarmSashCycleMotorLocked,
    AlarmStbFanOff,
    AlarmFrontPanel,
    AlarmSashDownStuck,
    ///
    Total
};
}//
