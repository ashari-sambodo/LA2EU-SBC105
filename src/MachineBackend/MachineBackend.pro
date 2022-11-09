QT -= gui
QT += qml
QT += sql
QT += websockets
QT += serialport
QT += serialbus

TEMPLATE = lib
CONFIG += staticlib

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES +=  \
    BoardIO/Drivers/ParticleCounterZH03B/ParticleCounterZH03B.cpp \
    BoardIO/Drivers/i2c/I2CPort.cpp \
    Implementations/AlarmLog/AlarmLog.cpp \
    Implementations/AlarmLog/AlarmLogSql.cpp \
    Implementations/BlowerRbm/BlowerRbmDsi.cpp \
    Implementations/CheckSWUpdate/CheckSWUpdate.cpp \
    Implementations/ClassManager.cpp \
    Implementations/AirflowVelocity/AirflowVelocity.cpp \
    Implementations/ClosedLoopControl/ClosedLoopControl.cpp \
    Implementations/DataLog/DataLogSql.cpp \
    Implementations/DataLog/DataLog.cpp \
    Implementations/DeviceAnalogCom/DeviceAnalogCom.cpp \
    Implementations/DigitalOut/DeviceDigitalOut.cpp \
    Implementations/EventLog/EventLog.cpp \
    Implementations/EventLog/EventLogSql.cpp \
    Implementations/LampDimm/LampDimm.cpp \
    Implementations/Modbus/QModbusTcpConnObserverImp.cpp \
    Implementations/MotorizeOnRelay/MotorizeOnRelay.cpp \
    Implementations/PWMOut/DevicePWMOut.cpp \
    Implementations/ParticleCounter/ParticleCounter.cpp \
    Implementations/PressureDiff/PressureDiff.cpp \
    Implementations/ReplaceableCompRecord/ReplaceableCompRecord.cpp \
    Implementations/ReplaceableCompRecord/ReplaceableCompRecordSql.cpp \
    Implementations/ResourceMonitorLog/ResourceMonitorLog.cpp \
    Implementations/ResourceMonitorLog/ResourceMonitorLogSql.cpp \
    Implementations/SashMotorizedTest/SashMotorizedTest.cpp \
    Implementations/SashWindow/SashWindow.cpp \
    Implementations/SchedulerDayOutput/SchedulerDayOutput.cpp \
    Implementations/Temperature/Temperature.cpp \
    Implementations/USBAutoMount/USBAutoMount.cpp \
    MachineBackend.cpp \
    MachineData.cpp \
    MachineProxy.cpp

HEADERS +=  \
    BoardIO/Drivers/ParticleCounterZH03B/ParticleCounterZH03B.h \
    BoardIO/Drivers/i2c/I2CPort.h \
    Implementations/AlarmLog/AlarmLog.h \
    Implementations/AlarmLog/AlarmLogEnum.h \
    Implementations/AlarmLog/AlarmLogSql.h \
    Implementations/AlarmLog/AlarmLogText.h \
    Implementations/BlowerRbm/BlowerRbmDsi.h \
    Implementations/CheckSWUpdate/CheckSWUpdate.h \
    Implementations/ClassManager.h \
    Implementations/AirflowVelocity/AirflowVelocity.h \
    Implementations/ClosedLoopControl/ClosedLoopControl.h \
    Implementations/DataLog/DataLogSql.h \
    Implementations/DataLog/DataLog.h \
    Implementations/DeviceAnalogCom/DeviceAnalogCom.h \
    Implementations/DigitalOut/DeviceDigitalOut.h \
    Implementations/EventLog/EventLog.h \
    Implementations/EventLog/EventLogSql.h \
    Implementations/EventLog/EventLogText.h \
    Implementations/LampDimm/LampDimm.h \
    Implementations/Modbus/QModbusTcpAddressEnum.h \
    Implementations/Modbus/QModbusTcpConnObserverImp.h \
    Implementations/MotorizeOnRelay/MotorizeOnRelay.h \
    Implementations/PWMOut/DevicePWMOut.h \
    Implementations/ParticleCounter/ParticleCounter.h \
    Implementations/PressureDiff/PressureDiff.h \
    Implementations/ReplaceableCompRecord/ReplaceableCompRecord.h \
    Implementations/ReplaceableCompRecord/ReplaceableCompRecordSql.h \
    Implementations/ResourceMonitorLog/ResourceMonitorLog.h \
    Implementations/ResourceMonitorLog/ResourceMonitorLogSql.h \
    Implementations/SashMotorizedTest/SashMotorizedTest.h \
    Implementations/SashWindow/SashWindow.h \
    Implementations/SchedulerDayOutput/SchedulerDayOutput.h \
    Implementations/Temperature/Temperature.h \
    Implementations/USBAutoMount/USBAutoMount.h \
    MachineBackend.h \
    MachineData.h \
    MachineDefaultParameters.h \
    MachineEnums.h \
    MachineProxy.h

### BoardIO
SOURCES += \
    BoardIO/BoardIO.cpp \
    BoardIO/BoardIOLibraryID.cpp \
    BoardIO/Drivers/AImcp3422x/AIManage.cpp \
    BoardIO/Drivers/AImcp3422x/AImcp342x.cpp \
    BoardIO/Drivers/AOmcp4725/AOmcp4725.cpp \
    BoardIO/Drivers/BlowerRegalECM/BlowerRegalECM.cpp \
    BoardIO/Drivers/ClassDriver.cpp \
    BoardIO/Drivers/DIOpca9674/DIOpca9674.cpp \
    BoardIO/Drivers/LEDpca9633/LEDpca9633.cpp \
    BoardIO/Drivers/PWMpca9685/PWMpca9685.cpp \
    BoardIO/Drivers/QGpioSysfs/QGpioSysfs.cpp \
    BoardIO/Drivers/RTCpcf8523/RTCpcf8523.cpp \
    BoardIO/Drivers/SensirionSPD8xx/SensirionSPD8xx.cpp

HEADERS += \
    BoardIO/BoardIO.h \
    BoardIO/BoardIOLibraryID.h \
    BoardIO/Drivers/AImcp3422x/AIManage.h \
    BoardIO/Drivers/AImcp3422x/AImcp342x.h \
    BoardIO/Drivers/AOmcp4725/AOmcp4725.h \
    BoardIO/Drivers/BlowerRegalECM/BlowerRegalECM.h \
    BoardIO/Drivers/ClassDriver.h \
    BoardIO/Drivers/DIOpca9674/DIOpca9674.h \
    BoardIO/Drivers/LEDpca9633/LEDpca9633.h \
    BoardIO/Drivers/PWMpca9685/PWMpca9685.h \
    BoardIO/Drivers/QGpioSysfs/QGpioSysfs.h \
    BoardIO/Drivers/RTCpcf8523/RTCpcf8523.h \
    BoardIO/Drivers/SensirionSPD8xx/SensirionSPD8xx.h

TRANSLATIONS =  i18n/translating-qml_de.ts \
                i18n/translating-qml_zh.ts \
                i18n/translating-qml_ja.ts \
                i18n/translating-qml_ko.ts \
                i18n/translating-qml_es.ts \
                i18n/translating-qml_it.ts \
                i18n/translating-qml_fr.ts \
                i18n/translating-qml_fi.ts

## Default rules for deployment.
#unix {
#    target.path = $$[QT_INSTALL_PLUGINS]/generic
#}
#!isEmpty(target.path): INSTALLS += target

RESOURCES += \
    i18n/i18n.qrc

DISTFILES +=
