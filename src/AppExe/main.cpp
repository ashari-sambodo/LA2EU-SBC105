#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFont>
#include <QDir>
#include <QStandardPaths>
#include <QResource>
#include <QDebug>

//#include <QMovie>

#include "Modules/ExitCodeCustom/ExitCodeCustom.h"
#include "Modules/TranslatorText/TranslatorText.h"
#include "Modules/DataLog/DataLogQmlApp.h"
#include "Modules/AlarmLog/AlarmLogQmlApp.h"
#include "Modules/EventLog/EventLogQmlApp.h"
#include "Modules/UserManage/UserManageQmlApp.h"
#include "Modules/BookingSchedule/BookingScheduleQmlApp.h"
//#include "Modules/FtpServer/SimpleFtpServer.h"
#include "Modules/BluetoothFileTransfer/BluetoothFileTransfer.h"
#include "Modules/UsbCopier/UsbCopier.h"
#include "Modules/JsToText/JstoText.h"
#include "Modules/ELSgenerator/ELSgenerator.h"
#include "Modules/ImportExternalResources/RegisterExternalResources.h"

#include "Modules/NetworkManager/NetworkManagerQmlApp.h"

#include "UI/CusCom/KeyboardOnScreen/KeyboardOnScreenAdapter.h"
#include "UI/CusCom/KeyboardOnScreen/KeyboardOnScreenCaller.h"
#include "UI/CusCom/HeaderApp/HeaderAppAdapter.h"

#include "MachineProxy.h"
#include "MachineData.h"

/*
SBC101 -> LA2 Std
SBC102 ->
SBC103 -> AC2 Std
SBC104 ->
SBC105 -> LA2 EU
*/

#define APP_NAME    "SBC105"
#define APP_DOMAIN  "com"
#define APP_ORG     "escolifesciences"
#define APP_LNAME   "sbc105"

#define COMPATIBLE_FOR "LA2-EU-G4"

#ifdef __linux__

///Unix signals in Qt applications
///
#include <initializer_list>
#include <signal.h>
#include <unistd.h>

void ignoreUnixSignals(std::initializer_list<int> ignoreSignals) {
    // all these signals will be ignored.
    for (int sig : ignoreSignals)
        signal(sig, SIG_IGN);
}

void catchUnixSignals(std::initializer_list<int> quitSignals) {
    auto handler = [](int sig) -> void {
        // blocking and not aysnc-signal-safe func are valid
        printf("\nquit the application by signal(%d).\n", sig);
        QCoreApplication::quit();
    };

    sigset_t blocking_mask;
    sigemptyset(&blocking_mask);
    for (auto sig : quitSignals)
        sigaddset(&blocking_mask, sig);

    struct sigaction sa;
    sa.sa_handler = handler;
    sa.sa_mask    = blocking_mask;
    sa.sa_flags   = 0;

    for (auto sig : quitSignals)
        sigaction(sig, &sa, nullptr);
}
#endif
///

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_Use96Dpi, true);
    //    QCoreApplication::setAttribute(Qt::AA_SynthesizeMouseForUnhandledTouchEvents, false);
#ifdef __linux__
    catchUnixSignals({SIGQUIT, SIGINT, SIGTERM, SIGHUP});
#endif

    /// REGISTER APPLICATION IDENTITY
    QCoreApplication::setApplicationName(APP_NAME);
    QCoreApplication::setApplicationVersion(APP_VERSION);
    QCoreApplication::setOrganizationDomain(APP_DOMAIN);
    QCoreApplication::setOrganizationName(APP_ORG);

    /// ENSURE TARGET LOCATION IS EXIST
    /// TO STORE DATABASE
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::DataLocation);
    if(!QDir(dataPath).exists()){
        QDir().mkpath(dataPath);
    }

    /// CREATE ROOT QT APPLICATION INSTANCE
    QGuiApplication app(argc, argv);

    /// SET DEFAULT FONT
    QFont font("Noto Sans");
    QGuiApplication::setFont(font);

    /// CREATE USER INTEFACE QML ENGINE
    QQmlApplicationEngine engine;

    /// PREPARE TRANSLATOR TEXT
    TranslatorText translatorText(&engine);
    engine.rootContext()->setContextProperty("TranslatorText", &translatorText);

    /// enable import of qml component by dot
    /// (with: import UI.CusCom 1.0 vs wihout: import "../../UI/CusCom")
    engine.addImportPath("qrc:/");

#ifdef __arm__
    /// Path for usb mounting
    engine.rootContext()->setContextProperty("MediaUSBStoragePath", "/tmp/media");
    /// Path for update software
    engine.rootContext()->setContextProperty("SWUpdatePath", "/data/update");
    engine.rootContext()->setContextProperty("HWRevisionPath", "/etc/hwrevision");
    engine.rootContext()->setContextProperty("SWRevisionPath", "/etc/swrevision");
#else
    QString path = QString(QDir::homePath() + "/dev/usbstorage").replace("C:", "c:"); /// Folder list model, generate drive letter with lower case
    engine.rootContext()->setContextProperty("MediaUSBStoragePath", path);
    engine.rootContext()->setContextProperty("SWUpdatePath", QDir::homePath() + "/dev/update");
    engine.rootContext()->setContextProperty("HWRevisionPath", QDir::homePath() + "/dev/etc/hwrevision");
    engine.rootContext()->setContextProperty("SWRevisionPath", QDir::homePath() + "/dev/etc/swrevision");
#endif

    qmlRegisterUncreatableType<ExitCodeCustom>("ModulesCpp.Utils", 1, 0, "ExitCode", "Cannot implemented ExitCode");
    qmlRegisterSingletonType<NetworkManagerQmlApp>("ModulesCpp.Connectify", 1, 0, "NetworkService", NetworkManagerQmlApp::singletonProvider);

    qmlRegisterType<DataLogQmlApp>("DataLogQmlApp", 1, 0, "DataLogQmlApp");
    qmlRegisterType<AlarmLogQmlApp>("AlarmLogQmlApp", 1, 0, "AlarmLogQmlApp");
    qmlRegisterType<EventLogQmlApp>("EventLogQmlApp", 1, 0, "EventLogQmlApp");
    qmlRegisterType<UserManageQmlApp>("UserManageQmlApp", 1, 0, "UserManageQmlApp");
    qmlRegisterType<BookingScheduleQmlApp>("BookingScheduleQmlApp", 1, 0, "BookingScheduleQmlApp");
    qmlRegisterType<UsbCopier>("ModulesCpp.UsbCopier", 1, 0, "USBCopier");
    qmlRegisterType<BluetoothFileTransfer>("ModulesCpp.BluetoothTransfer", 1, 0, "BluetoothTransfer");
    qmlRegisterType<JstoText>("ModulesCpp.JstoText", 1, 0, "JstoText");
    qmlRegisterType<ELSgenerator>("ModulesCpp.ELSkeygen", 1, 0, "ELSkeygen");
    qmlRegisterType<RegisterExternalResources>("ModulesCpp.RegisterExternalResources", 1, 0, "RegisterExResources");

    qmlRegisterSingletonType<MachineProxy>("ModulesCpp.Machine", 1, 0, "MachineAPI", MachineProxy::singletonProvider);
    qmlRegisterSingletonType<MachineData>("ModulesCpp.Machine", 1, 0, "MachineData", MachineData::singletonProvider);

    qmlRegisterType<KeyboardOnScreenAdapter>("UI.CusCom.KeyboardOnScreen.Adapter", 1, 0, "KeyboardOnScreenAdapter");
    KeyboardOnScreenCaller keyboardOnScreenCaller;
    engine.rootContext()->setContextProperty("KeyboardOnScreenCaller", &keyboardOnScreenCaller);

    qmlRegisterSingletonType<HeaderAppAdapter>("UI.CusCom.HeaderApp.Adapter", 1, 0, "HeaderAppAdapter", HeaderAppAdapter::singletonProvider);

#ifdef QT_RELEASE
    engine.rootContext()->setContextProperty("__release__", 1);
#else
    engine.rootContext()->setContextProperty("__release__", 0);
#endif

    /// CRATE VIEW ENGINE
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
