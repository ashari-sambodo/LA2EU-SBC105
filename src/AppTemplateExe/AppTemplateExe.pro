QT += quick

TEMPLATE = app
CONFIG += c++11

VERSION = 1.0.0.1
DEFINES += APP_VERSION=\\\"$${VERSION}\\\"
TARGET = bin/apptemplate-$$VERSION

## CREATE SYMBOLIC LINK
unix {
    QMAKE_POST_LINK += $$quote(cd $$OUT_PWD/bin; ln -sf apptemplate-$$VERSION app-exe)
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
    Modules/TranslatorText/TranslatorText.h \
    Modules/ExitCodeCustom/ExitCodeCustom.h \
    Modules/FileDirUtils/FileDirUtils.h \
    Modules/NetworkManager/NetworkManager.h \
    Modules/USBStorageMount/USBStorageMount.h \
    UI/CusCom/KeyboardOnScreen/KeyboardOnScreenAdapter.h

SOURCES += \
        Modules/TranslatorText/TranslatorText.cpp \
        Modules/FileDirUtils/FileDirUtils.cpp \
        Modules/NetworkManager/NetworkManager.cpp \
        Modules/USBStorageMount/USBStorageMount.cpp \
        UI/CusCom/KeyboardOnScreen/KeyboardOnScreenAdapter.cpp \
        main.cpp

RESOURCES += qml.qrc \
    components.qrc \
    i18n.qrc

include(i18n.pri)

## Please check ISO-639 Language Codes
TRANSLATIONS = i18n/translating-qml_de.ts \
               i18n/translating-qml_zh.ts \
               i18n/translating-qml_ru.ts \
               i18n/translating-qml_ja.ts \
               i18n/translating-qml_ko.ts \
               i18n/translating-qml_ar.ts \

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += $$PWD

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
#qnx: target.path = /tmp/$${TARGET}/bin
#else: unix:!android: target.path = /opt/$${TARGET}/bin
#!isEmpty(target.path): INSTALLS += target

INCLUDEPATH += ../MachineState
win32:CONFIG(debug, debug|release) {
#    message("debug-boardIO")
    LIBS += -L../MachineState/debug -lMachineState
}
win32:CONFIG(release, debug|release) {
#    message("release-boardIO")
    LIBS += -L../MachineState/release -lMachineState
}
unix{
    message($$OUT_PWD)
    LIBS += -L$$OUT_PWD/../MachineState -lMachineState
}
