#include "BlowerDSIThread.h"

#define TIMER_EVENT_MAIN 130
//#define TIMER_EVENT_MAIN 1000

BlowerDSIWorker::BlowerDSIWorker(QObject *parent)
    : QObject(parent)
{
    pBlowerECM  = nullptr;
}

BlowerDSIWorker::~BlowerDSIWorker()
{
}

void BlowerDSIWorker::setSpeed(long newVal)
{
#ifndef NO_PRINT_DEBUG
    printf("BlowerDSIWorker::setSpeed ThreadID %p\n", QThread::currentThreadId());
    fflush(stdout);
    printf("BlowerDSIWorker::setSpeed %ld\n", newVal);
    fflush(stdout);
#endif

    //    //demo
    //    emit speedChanged(newVal);
    //    return;

    if(thread() != QThread::currentThread()){
        //        printf("QMetaObject::invokeMethod::BlowerDSIWorker::setSpeed ThreadID %p\n", QThread::currentThreadId());
        //        fflush(stdout);
        //do_in_this_thread
        QMetaObject::invokeMethod(this, [=](){
            //            printf("BlowerDSIWorker::setSpeed %d in ThreadID %p\n", (int)newVal , QThread::currentThreadId());
            //            fflush(stdout);
            if(pBlowerECM == nullptr) return;
            pBlowerECM->setSpeedDutyCycle((int)newVal);
        },
        Qt::QueuedConnection);
        return;
    }

    //do_in_called_thread
    if(pBlowerECM) return;
    pBlowerECM->setSpeedDutyCycle((int)newVal);
}

void BlowerDSIWorker::setInterlock(long newVal)
{
#ifndef NO_PRINT_DEBUG
    printf("BlowerDSIWorker::setInterlock ThreadID %p\n", QThread::currentThreadId());
    fflush(stdout);
#endif

    //    //demo
    //    emit interlockChanged(newVal);
    //    return;

    if(thread() != QThread::currentThread()){
        QMetaObject::invokeMethod(this, [=](){
            if(pBlowerECM == nullptr) return;
            pBlowerECM->setInterlock((int)newVal);
        },
        Qt::QueuedConnection);
        return;
    }

    //do_in_called_thread
    if(pBlowerECM == nullptr) return;
    pBlowerECM->setSpeedDutyCycle((int)newVal);
}

void BlowerDSIWorker::setup()
{
#ifndef NO_PRINT_DEBUG
    printf("BlowerDSIWorker::start ThreadID %p\n", QThread::currentThreadId());
    fflush(stdout);
#endif

    //MANAGER_OBJECT
    if(pBlowerECM == nullptr) return;

    pBlowerECM->setup();

    connect(pBlowerECM, &BlowerDSIManager::interlockChanged,
            this, &BlowerDSIWorker::_onInterlockChanged);
    connect(pBlowerECM, &BlowerDSIManager::speedDutyCycleChanged,
            this, &BlowerDSIWorker::_onSpeedChanged);
    connect(pBlowerECM, &BlowerDSIManager::speedRPMChanged,
            this, &BlowerDSIWorker::_onSpeedRPMChanged);
    connect(pBlowerECM->getSub(), &BlowerRegalECM::errorComCountChanged,
            this, &BlowerDSIWorker::_onErrorComCountChanged);

    //EVENT_LOOP_TIMER
    m_timerEvent.reset(new QTimer(this));
    connect(m_timerEvent.data(), &QTimer::timeout,
            this, &BlowerDSIWorker::loop);
    m_timerEvent->start(TIMER_EVENT_MAIN);
}

void BlowerDSIWorker::stopEventLoopTimer()
{
    //    printf("BlowerDSIWorker::stopEventLoopTimer ThreadID %p\n", QThread::currentThreadId());
    //    fflush(stdout);

    if(thread() != QThread::currentThread()){
        QMetaObject::invokeMethod(this, [=](){

            //            printf("BlowerDSIWorker::stopEventLoopTimer ThreadID %p\n", QThread::currentThreadId());
            //            fflush(stdout);

            stopEventLoopTimer();

        }, Qt::QueuedConnection);
        return;
    }

    if(m_timerEvent.isNull()) return;
    if(m_timerEvent->isActive()) m_timerEvent->stop();
}

void BlowerDSIWorker::_onSpeedChanged(int newVal)
{
    //forwarder signal
    emit speedChanged(newVal);
}

void BlowerDSIWorker::_onSpeedRPMChanged(int newVal)
{
    //forwarder signal
    emit speedRPMChanged(newVal);
}

void BlowerDSIWorker::_onInterlockChanged(int newVal)
{
    //forwarder signal
    emit interlockChanged(newVal);
}

void BlowerDSIWorker::_onErrorComCountChanged(int newVal)
{
//    printf("BlowerDSIWorker::_onErrorComCountChanged got %d\n", newVal);
//    fflush(stdout);

    ///forwarder signal
    emit errorComCountChanged(newVal);
}

void BlowerDSIWorker::setBlowerECM(BlowerDSIManager *pointer)
{
    pBlowerECM = pointer;
}

void BlowerDSIWorker::loop()
{
    //    printf("BlowerDSIWorker::processing ThreadID %p\n", QThread::currentThreadId());
    //    fflush(stdout);
    //    printf("BlowerDSIWorker::processing Cycle Interval %d\n", m_timerEvent->interval());
    //    fflush(stdout);
    //        printf("BlowerDSIWorker::process\n");
    //        fflush(stdout);

    if(pBlowerECM == nullptr) return;
    pBlowerECM->worker();
}
