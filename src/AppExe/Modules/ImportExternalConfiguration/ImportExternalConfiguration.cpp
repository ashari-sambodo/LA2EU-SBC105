#include "ImportExternalConfiguration.h"
#include <QStandardPaths>
#include <QPdfWriter>
#include <QFile>
#include <QPainter>
#include <QDir>
#include <QStandardPaths>
#include <QTextStream>
#include <QProcess>
#include <QtConcurrent/QtConcurrent>
#include <QCoreApplication>
#include <QSettings>


ImportExternalConfiguration::ImportExternalConfiguration(QObject *parent) : QObject(parent)
{

}

bool ImportExternalConfiguration::getInitialized() const
{
    return m_initialized;
}

void ImportExternalConfiguration::setInitialized(bool initialized)
{
    if (m_initialized == initialized)
        return;

    m_initialized = initialized;
    emit initializedChanged(m_initialized);
}

void ImportExternalConfiguration::init()
{
    // sanity check dont allow to double created the instance
    //m_pThread = new QThread();
    if (m_pThread != nullptr){
        qDebug() << __func__ << "Thread still here";
        return;
    }

    m_pThread = QThread::create([&](){
        //        qDebug() << "m_pThread::create" << thread();

        m_importer.reset(new ImportExternalConfiguration());

        setInitialized(true);

        QEventLoop loop;
        //        connect(this, &DataLogQmlApp::destroyed, &loop, &QEventLoop::quit);
        loop.exec();

        //        qDebug() << "m_pThread::end";
    });

    //// Tells the thread's event loop to exit with return code 0 (success).
    connect(this, &ImportExternalConfiguration::destroyed, m_pThread, &QThread::quit);
    connect(m_pThread, &QThread::finished, [](){
        qDebug() << "Thread has finished";
    });
    //connect(m_pThread, &QThread::finished, m_pThread, &QThread::deleteLater);
    connect(m_pThread, &QThread::destroyed, [](){
        qDebug() << "Thread will destroying";
        //setInitialized(false);
    });

    m_pThread->start();
}

void ImportExternalConfiguration::importConfig(QString path)
{
    QMetaObject::invokeMethod(m_importer.data(), [&, path](){
        bool state = true;
        qDebug() << __func__ << path;

        QString appName = QCoreApplication::applicationName();
        QString confName = appName + ".conf";
        Q_UNUSED(confName)
        qDebug() << "Application name:" << appName;

        if(path.contains(confName))
        {
#ifdef __linux__
            QProcess qprocess;
            //        qprocess.start("rootrw");
            //        qprocess.waitForFinished();

            QString configLocation = "/home/root/.config/escolifesciences/" + confName;

            if(QFile::exists(configLocation)){
                QFile::remove(configLocation);
            }

            state = QFile::copy(path, configLocation);

            //        qprocess.start("rootro");
            //        qprocess.waitForFinished();

            /// Reset the following parameters

            QSettings settings;
            QString year_sn = QDate::currentDate().toString("yyyy-000000");

            settings.setValue("sbcSN", "0000000000000001");
            settings.setValue("sbcSysInfo", "sysInfo:sbc");
            settings.setValue("serNum", year_sn);
#endif
        }
        else{
            qDebug() << "Config name invalid! must be" << confName;
            state = false;
        }
        emit configHasBeenImported(state);
    });
}
