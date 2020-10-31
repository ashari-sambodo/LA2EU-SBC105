#include "SwupdateWrapper.h"

#include <QThread>
#include <QProcess>
#include <QDebug>
#include <QEventLoop>

#include <QRegularExpression>

#include <QDir>


SwupdateWrapper::SwupdateWrapper(QObject *parent) : QObject(parent)
{
    m_exitStatus = 0;
    m_fileNamePath = "";
    m_dryMode = false;
    m_progressPercent = 0;
    m_progressStatus = PROGRESS_STATUS::PS_IDLE;
}

/**
 * @brief SwupdateWrapper::~SwupdateWrapper
 *
 * TODO: need to proper mechanism to cancel updating prosesse
 * I have try to just terminate the thread, but program going crash
 * I suspect there is effect from qprocess and event loop
 */
SwupdateWrapper::~SwupdateWrapper()
{
    //    if(m_thread != nullptr){
    //        m_thread->terminate();
    //    }
}

int SwupdateWrapper::getExitStatus() const
{
    return m_exitStatus;
}

QString SwupdateWrapper::getFileNamePath() const
{
    return m_fileNamePath;
}

bool SwupdateWrapper::getDryMode() const
{
    return m_dryMode;
}

int SwupdateWrapper::getProgressPercent() const
{
    return m_progressPercent;
}

int SwupdateWrapper::progressStatus() const
{
    return m_progressStatus;
}

bool SwupdateWrapper::getBussy() const
{
    return m_bussy;
}

void SwupdateWrapper::updateAsync()
{
    //    qDebug() << __FUNCTION__ << QThread::currentThreadId() << m_fileNamePath;

    if(!m_thread.isNull()) if(m_thread->isRunning()) return;

    m_thread.reset(QThread::create([=]{

        //        qDebug() << __FUNCTION__;
        //        QThread::sleep(5);

        update();

    }));

    QObject::connect(m_thread.data(), &QThread::started, [=]{
        setBussy(true);
    });
    QObject::connect(m_thread.data(), &QThread::finished, [=]{
        setBussy(false);
    });
    //    QObject::connect(m_thread.data(), &QThread::finished, [=]{
    //        qDebug() << "m_thread has finished";
    //    });
    //    QObject::connect(m_thread.data(), &QThread::destroyed, [=]{
    //        qDebug() << "m_thread will destroyed";
    //    });

    m_thread->start();

    //    /// Don't allow multiple calling
    //    if (m_thread != nullptr){
    //        if (m_thread->isRunning()){
    //            return;
    //        }
    //    }

    //    m_thread = QThread::create([=]{
    //        //        qDebug() << __FUNCTION__ << QThread::currentThreadId();
    //        updateSync();
    //    });

    //    QObject::connect(m_thread, &QThread::finished, m_thread, &QThread::deleteLater);
    //    QObject::connect(m_thread, &QThread::destroyed, [=]{m_thread = nullptr;});

    //    m_thread->start();
}

void SwupdateWrapper::setExitStatus(int exitStatus)
{
    if (m_exitStatus == exitStatus)
        return;

    m_exitStatus = exitStatus;
    emit exitStatusChanged(m_exitStatus);
}

void SwupdateWrapper::setFileNamePath(QString fileName)
{
    if (m_fileNamePath == fileName)
        return;

    m_fileNamePath = fileName;
    emit fileNamePathChanged(m_fileNamePath);
}

void SwupdateWrapper::setDryMode(bool dryMode)
{
    if (m_dryMode == dryMode)
        return;

    m_dryMode = dryMode;
    emit dryModeChanged(m_dryMode);
}

void SwupdateWrapper::setProgressPercent(int progressPercent)
{
    if (m_progressPercent == progressPercent)
        return;

    m_progressPercent = progressPercent;
    emit progressPercentChanged(m_progressPercent);
}

void SwupdateWrapper::setProgressStatus(int progressStatus)
{
    if (m_progressStatus == progressStatus)
        return;

    m_progressStatus = progressStatus;
    emit progressStatusChanged(m_progressStatus);
}

void SwupdateWrapper::setBussy(bool bussy)
{
    if (m_bussy == bussy)
        return;

    m_bussy = bussy;
    emit bussyChanged(m_bussy);
}

void SwupdateWrapper::update()
{
    //    qDebug() << __FUNCTION__ << QThread::currentThreadId() << m_fileNamePath;

    setProgressStatus(PROGRESS_STATUS::PS_RUN);

    QStringList arguments;
    if(m_dryMode){
        arguments << "-v" << "-d" << m_fileNamePath ;
    }
    else {
        arguments << "-v" << m_fileNamePath ;
    }

    QEventLoop loop;
    QProcess qprocess;

    /// Send messsage every once output from child prosess is ready
    //    QObject::connect(&qprocess, &QProcess::readyReadStandardOutput, [&qprocess, this]{
    //        QString message = qprocess.readAll();

    //        SwupdateWrapper *swu = this;
    //        swu->emit messageNewReadyRead(message);

    //        if (message.contains("Swupdate was successful !")) {

    //        }

    //        if (message.contains("Swupdate *failed* !")) {

    //        }

    //    });
    /// Quit from looping after child process finished
    QObject::connect(&qprocess, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
                     [&qprocess, &loop, this](int exitCode, QProcess::ExitStatus /*exitStatus*/){
        //        qDebug() << "exitCode" << exitCode;

        QString message = qprocess.readAll();
        SwupdateWrapper *swu = this;
        swu->emit messageNewReadyRead(message);

        if (exitCode) {
            //            qDebug() << "SWUpdate Failed !";
            swu->setProgressStatus(PROGRESS_STATUS::PS_FAILED);
        }
        else {
            //            qDebug() << "SWUpdate Success !";
            swu->setProgressStatus(PROGRESS_STATUS::PS_SUCCESS);
        }

        //        if (message.contains("Swupdate was successful !")) {
        //            qDebug() << "SWUpdate Success !";
        //            swu->setProgressStatus(PROGRESS_STATUS::PS_SUCCESS);
        //        }
        //        else if (message.contains("Swupdate *failed* !")) {
        //            qDebug() << "SWUpdate Failed !";
        //            swu->setProgressStatus(PROGRESS_STATUS::PS_FAILED);
        //        }

        loop.exit(exitCode);
    });

    /// Merge Standard message output and Error message output become one
    qprocess.setProcessChannelMode(QProcess::MergedChannels);

    /// swupdate-client <imagefile> -v -d
    /// -v : verbose the message
    /// -d : with this if just to simulate the updating image process, not persistent to storage
    //    qprocess.start("swupdate-client", arguments);

    /// Block until finished
    /// but not blocked the signal traffic

    QProcess qprocessSwuprogress;

    /// Send messsage every once output from child prosess is ready
    QObject::connect(&qprocessSwuprogress, &QProcess::readyReadStandardOutput, [&qprocessSwuprogress, this]{
        QString message = qprocessSwuprogress.readAll();
        //        qDebug() << "progress-message:";
        //        qDebug() << message;

        /// with regex version, we can use regex,
        /// bellow will get wich digit word has symbol percent (%)
        QRegularExpression regex("\\d+%");
        QString percent = regex.match(message).captured().remove("%");

        //        qDebug() << "progress:";
        //        qDebug().nospace() << percent << "%";

        SwupdateWrapper *swu = this;
        swu->setProgressPercent(percent.toInt());
        //        this->emit messageNewReadyRead(message);
    });
    /// Quit from looping after child process finished
    QObject::connect(&qprocess, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
                     [&qprocessSwuprogress](int /*exitCode*/, QProcess::ExitStatus /*exitStatus*/){
        qprocessSwuprogress.close();
    });

    /// Merge Standard message output and Error message output become one
    qprocessSwuprogress.setProcessChannelMode(QProcess::MergedChannels);

    /// swupdate-client <imagefile> -v -d
    /// -v : verbose the message
    /// -d : with this if just to simulate the updating image process, not persistent to storage
    qprocess.start("swupdate-client", arguments);
    qprocessSwuprogress.start("swupdate-progress");

    loop.exec();
}
