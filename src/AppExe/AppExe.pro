QT += quick
QT += bluetooth
QT += sql
QT += serialport
QT += serialbus
QT += websockets

TEMPLATE = app
CONFIG += c++11

VERSION = 1.0.0
DEFINES += APP_VERSION=\\\"$${VERSION}\\\"
DEFINES += INCREMENTAL_VERSION=1
TARGET = bin/sbc105-$$VERSION

## CREATE SYMBOLIC LINK
unix {
    QMAKE_POST_LINK += $$quote(cd $$OUT_PWD/bin; ln -sf sbc105-$$VERSION app-exe)
    ## rsync -lavv * root@172.16.30.210:/opt/SBCUpdate/
}
# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0


HEADERS += \
    Modules/AlarmLog/AlarmLogQmlApp.h \
    Modules/AlarmLog/AlarmLogSqlGet.h \
    Modules/BookingSchedule/BookingScheduleQmlApp.h \
    Modules/BookingSchedule/BookingScheduleSqlGet.h \
    Modules/DataLog/DataLogQmlApp.h \
    Modules/DataLog/DataLogSqlGet.h \
    Modules/ELSgenerator/ELSgenerator.h \
    Modules/EventLog/EventLogQmlApp.h \
    Modules/EventLog/EventLogSqlGet.h \
#    Modules/FtpServer/SimpleFtpServer.h \
    Modules/ImportExternalResources/RegisterExternalResources.h \
    Modules/JsToText/JstoText.h \
    Modules/NetworkManager/NetworkManagerQmlApp.h \
    Modules/TranslatorText/TranslatorText.h \
    Modules/ExitCodeCustom/ExitCodeCustom.h \
#    Modules/FileDirUtils/FileDirUtils.h \
    Modules/NetworkManager/NetworkManager.h \
#    Modules/USBStorageMount/USBStorageMount.h \
    Modules/UsbCopier/UsbCopier.h \
    Modules/UserManage/UserManageQmlApp.h \
    Modules/UserManage/UserManageSql.h \
    Modules/BluetoothFileTransfer/BluetoothFileTransfer.h \
    UI/CusCom/HeaderApp/HeaderAppAdapter.h \
    UI/CusCom/KeyboardOnScreen/KeyboardOnScreenAdapter.h \
    UI/CusCom/KeyboardOnScreen/KeyboardOnScreenCaller.h

SOURCES += \
        Modules/AlarmLog/AlarmLogQmlApp.cpp \
        Modules/AlarmLog/AlarmLogSqlGet.cpp \
    Modules/BookingSchedule/BookingScheduleQmlApp.cpp \
    Modules/BookingSchedule/BookingScheduleSqlGet.cpp \
        Modules/DataLog/DataLogQmlApp.cpp \
        Modules/DataLog/DataLogSqlGet.cpp \
    Modules/ELSgenerator/ELSgenerator.cpp \
        Modules/EventLog/EventLogQmlApp.cpp \
        Modules/EventLog/EventLogSqlGet.cpp \
#        Modules/FtpServer/SimpleFtpServer.cpp \
    Modules/ImportExternalResources/RegisterExternalResources.cpp \
    Modules/JsToText/JstoText.cpp \
        Modules/NetworkManager/NetworkManagerQmlApp.cpp \
        Modules/TranslatorText/TranslatorText.cpp \
#        Modules/FileDirUtils/FileDirUtils.cpp \
        Modules/NetworkManager/NetworkManager.cpp \
#        Modules/USBStorageMount/USBStorageMount.cpp \
    Modules/UsbCopier/UsbCopier.cpp \
        Modules/UserManage/UserManageQmlApp.cpp \
        Modules/UserManage/UserManageSql.cpp \
        Modules/BluetoothFileTransfer/BluetoothFileTransfer.cpp \
        UI/CusCom/HeaderApp/HeaderAppAdapter.cpp \
        UI/CusCom/KeyboardOnScreen/KeyboardOnScreenAdapter.cpp \
        UI/CusCom/KeyboardOnScreen/KeyboardOnScreenCaller.cpp

SOURCES += main.cpp

RESOURCES += qml.qrc \
#    QuickTourBookingSchedule.qrc \
#    QuickTourBookingSheduleThird.qrc \
#   QuickTourHomePageSecondsec.qrc \
#    QuickTourHomepage.qrc \
#    QuickTourHomepageSecond.qrc \
#    QuickTourLoginPage.qrc \
#    QuickTourPicEventLog.qrc \
#    QuickTourPicEventLogSecond.qrc \
#    QuickTourPicEventLogThird.qrc \
#    QuickTourPicture.qrc \
#    QuickTourUvScheduler.qrc \
#    QuickTourUvSchedulerSecond.qrc \
#   QuickTourPage.qrc \
#    QtGeneralResources.qrc \
#    GeneralResources.qrc \
    components.qrc \
    i18n.qrc \
    pictures.qrc \
#    quickTourBookingScheduleSecond.qrc

include(i18n.pri)

## Please check ISO-639 Language Codes
TRANSLATIONS =  i18n/translating-qml_de.ts \
                i18n/translating-qml_zh.ts \
                i18n/translating-qml_ja.ts \
                i18n/translating-qml_ko.ts \
                i18n/translating-qml_es.ts \
                i18n/translating-qml_it.ts \
                i18n/translating-qml_fr.ts \
                i18n/translating-qml_fi.ts

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += $$PWD

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
#qnx: target.path = /tmp/$${TARGET}/bin
#else: unix:!android: target.path = /opt/$${TARGET}/bin
#!isEmpty(target.path): INSTALLS += target

INCLUDEPATH += ../MachineBackend
win32:CONFIG(debug, debug|release) {
#    message("debug-boardIO")
    LIBS += -L../MachineBackend/debug -lMachineBackend
}
win32:CONFIG(release, debug|release) {
#    message("release-boardIO")
    LIBS += -L../MachineBackend/release -lMachineBackend
}
unix{
    message($$OUT_PWD)
    LIBS += -L$$OUT_PWD/../MachineBackend -lMachineBackend
}

## https://wiki.qt.io/Performance_Tip_Startup_Time
## https://www.qt.io/blog/2019/01/02/qt-applications-lto
## first test this can reduce the size up to 2MB
QMAKE_CXXFLAGS += -ltcg

## put anonymous class on header (class NameClass;) then put #include ClassName.h on implementation *.cpp
## help to reduced final binary file

#########SimpleFTPServer
#win32:CONFIG(release, debug|release): LIBS += -L$$PWD/Modules/ThirdParty/FineFTP-Server -lfineftp-server
#else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/Modules/ThirdParty/FineFTP-Server -lfineftp-server

#INCLUDEPATH += $$PWD/Modules/ThirdParty/FineFTP-Server/include
#DEPENDPATH += $$PWD/Modules/ThirdParty/FineFTP-Server/include

#win32:LIBS += -lws2_32
#win32:LIBS += -lwsock32

DISTFILES += \
    GeneralResources.qml
