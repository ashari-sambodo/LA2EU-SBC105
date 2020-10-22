#include "MachineStateProxy.h"
#include "MachineState.h"
#include "MachineData.h"

#include "QQmlEngine"
#include "QJSEngine"

#include <QtDebug>

#ifdef __arm__
#define TIMER_INTERVAL_WORKER   150 // ms
#else
#define TIMER_INTERVAL_WORKER   1000 // ms
#endif

static MachineStateProxy* s_instance = nullptr;

QObject *MachineStateProxy::singletonProvider(QQmlEngine *qmlEngine, QJSEngine *)
{
    if(!s_instance){
        s_instance = new MachineStateProxy(qmlEngine);
    }
    return s_instance;
}

MachineStateProxy::MachineStateProxy(QObject *parent) : QObject(parent)
{
}

MachineStateProxy::~MachineStateProxy()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
}

int MachineStateProxy::getCount() const
{
    return m_count;
}

void MachineStateProxy::initSingleton()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
}

void MachineStateProxy::setup(QObject *pData)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    /// Create machine instance
    m_machineState.reset(new MachineState);

    /// Create thread where machineState will a life
    m_machineStateThread.reset(new QThread);

    /// Create timer event for triggered any event on the machineState
    m_timerEventForMachineState.reset(new QTimer);
    m_timerEventForMachineState->setInterval(TIMER_INTERVAL_WORKER);

    pMachineData = qobject_cast<MachineData*>(pData);
    m_machineState->setMachineData(pMachineData);

    /// Start timer event when thread was called
    QObject::connect(m_machineStateThread.data(), &QThread::started,
            m_timerEventForMachineState.data(), QOverload<>::of(&QTimer::start));

    /// Stop timer event when thread was called
    QObject::connect(m_machineStateThread.data(), &QThread::finished,
            m_timerEventForMachineState.data(), QOverload<>::of(&QTimer::stop));

    /// Trigger worker on starting
    QObject::connect(m_machineStateThread.data(), &QThread::started,
            m_machineState.data(), [&](){m_machineState->worker();});

    /// stopped thread
    QObject::connect(m_machineState.data(), &MachineState::hasStopped,
                     this, &MachineStateProxy::doStopping);

    /// Call worker every time timer was timeout , routine task
    QObject::connect(m_timerEventForMachineState.data(), &QTimer::timeout,
            m_machineState.data(), &MachineState::worker);

    /// Move the object to another thread
    m_machineState->moveToThread(m_machineStateThread.data());
    m_timerEventForMachineState->moveToThread(m_machineStateThread.data());

    /// start the thread
    m_machineStateThread->start();
}

void MachineStateProxy::stop()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    /// Send to machine statae
    QMetaObject::invokeMethod(m_machineState.data(),
                              &MachineState::stop,
                              Qt::QueuedConnection);
}

void MachineStateProxy::doStopping()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if (m_machineStateThread.isNull()) return;

    m_machineStateThread->quit();
    m_machineStateThread->wait();
    pMachineData->setDataHasStopped(true);
}
