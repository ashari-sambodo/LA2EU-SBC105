#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFont>
#include <QDir>

#include "Modules/USBStorageMount/USBStorageMount.h"
#include "Modules/FileDirUtils/FileDirUtils.h"
#include "Modules/ExitCodeCustom/ExitCodeCustom.h"
#include "Modules/NetworkManager/NetworkManager.h"
#include "Modules/TranslatorText/TranslatorText.h"

#include "UI/CusCom/KeyboardOnScreen/KeyboardOnScreenAdapter.h"

#include "MachineStateProxy.h"
#include "MachineData.h"
//#include "MachineEnums.h"

#define APP_NAME    "App Template"
#define APP_DOMAIN  "com"
#define APP_ORG     "escoglobal"
#define APP_LNAME   "sbcupdate"


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
#ifdef __linux__
    catchUnixSignals({SIGQUIT, SIGINT, SIGTERM, SIGHUP});
#endif

    /// REGISTER APPLICATION IDENTITY
    QCoreApplication::setApplicationName(APP_NAME);
    QCoreApplication::setApplicationVersion(APP_VERSION);
    QCoreApplication::setOrganizationDomain(APP_DOMAIN);
    QCoreApplication::setOrganizationName(APP_ORG);

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
    engine.rootContext()->setContextProperty("MediaUSBStoragePath", "/media/usbstorage");
    /// Path for update software
    engine.rootContext()->setContextProperty("SWUpdatePath", "/data/update");
    engine.rootContext()->setContextProperty("HWRevisionPath", "/etc/hwrevision");
    engine.rootContext()->setContextProperty("SWRevisionPath", "/etc/swrevision");
#else
    engine.rootContext()->setContextProperty("MediaUSBStoragePath", QDir::homePath() + "/dev/usbstorage");
    engine.rootContext()->setContextProperty("SWUpdatePath", QDir::homePath() + "/dev/update");
    engine.rootContext()->setContextProperty("HWRevisionPath", QDir::homePath() + "/dev/etc/hwrevision");
    engine.rootContext()->setContextProperty("SWRevisionPath", QDir::homePath() + "/dev/etc/swrevision");
#endif

    qmlRegisterType<USBStorageMount>("modules.cpp.utils", 1, 0, "USBStorageMount");

    qmlRegisterType<FileDirUtils>("modules.cpp.utils", 1, 0, "FileDirUtils");

    qmlRegisterUncreatableType<ExitCodeCustom>("modules.cpp.utils", 1, 0, "ExitCode", "Cannot implemented ExitCode");

    qmlRegisterSingletonType<NetworkManager>("modules.cpp.networkmanager", 1, 0, "NetworkManager", NetworkManager::singletonProvider);

    qmlRegisterType<KeyboardOnScreenAdapter>("UI.CusCom.KeyboardOnScreen.Adapter", 1, 0, "KeyboardOnScreenAdapter");

    qmlRegisterSingletonType<MachineStateProxy>("modules.cpp.machine", 1, 0, "MachineApi", MachineStateProxy::singletonProvider);
    qmlRegisterSingletonType<MachineData>("modules.cpp.machine", 1, 0, "MachineData", MachineData::singletonProvider);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
