QT -= gui

TEMPLATE = lib
CONFIG += staticlib

CONFIG += c++11

QT += qml
QT += serialport

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
    Implementations/BlowerRbm/BlowerRbmDsi.cpp \
    Implementations/ClassManager.cpp \
    Implementations/AirflowVelocity/AirflowVelocity.cpp \
    Implementations/DeviceAnalogCom/DeviceAnalogCom.cpp \
    Implementations/DigitalOut/DigitalOut.cpp \
    Implementations/LampDimm/LampDimm.cpp \
    Implementations/MotorizeOnRelay/MotorizeOnRelay.cpp \
    Implementations/PressureDiff/PressureDiff.cpp \
    Implementations/SashWindow/SashWindow.cpp \
    Implementations/Temperature/Temperature.cpp \
    MachineData.cpp \
    MachineState.cpp \
    MachineStateProxy.cpp

HEADERS +=  \
    Implementations/BlowerRbm/BlowerRbmDsi.h \
    Implementations/ClassManager.h \
    Implementations/AirflowVelocity/AirflowVelocity.h \
    Implementations/DeviceAnalogCom/DeviceAnalogCom.h \
    Implementations/DigitalOut/DigitalOut.h \
    Implementations/LampDimm/LampDimm.h \
    Implementations/MotorizeOnRelay/MotorizeOnRelay.h \
    Implementations/PressureDiff/PressureDiff.h \
    Implementations/SashWindow/SashWindow.h \
    Implementations/Temperature/Temperature.h \
    MachineStateProxy.h \
    MachineData.h \
    MachineDefaultParameters.h \
    MachineEnums.h \
    MachineState.h

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
    BoardIO/Drivers/SensirionSPD8xx/SensirionSPD8xx.cpp \
    BoardIO/Drivers/i2c/I2CCom.cpp

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
    BoardIO/Drivers/SensirionSPD8xx/SensirionSPD8xx.h \
    BoardIO/Drivers/i2c/I2CCom.h

## Default rules for deployment.
#unix {
#    target.path = $$[QT_INSTALL_PLUGINS]/generic
#}
#!isEmpty(target.path): INSTALLS += target
