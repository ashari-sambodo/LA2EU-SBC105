#include "MachineStateProxy.h"
#include "MachineState.h"
#include "MachineData.h"

#include "QQmlEngine"
#include "QJSEngine"

#include <QtDebug>

/// TEI = TIMER EVENT INTERVAL
#ifdef __arm__
#define TEI_FOR_WORKER   150 // ms
#else
#define TEI_FOR_WORKER   1000 // ms
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
    m_threadForMachineState.reset(new QThread);

    /// Create timer event for triggered any event on the machineState
    m_timerEventForMachineState.reset(new QTimer);
    m_timerEventForMachineState->setInterval(TEI_FOR_WORKER);

    pMachineData = qobject_cast<MachineData*>(pData);
    pMachineData->setMachineState(MachineEnums::MACHINE_STATE_SETUP);
    m_machineState->setMachineData(pMachineData);

    /// Start timer event when thread was called
    QObject::connect(m_threadForMachineState.data(), &QThread::started,
                     m_timerEventForMachineState.data(), QOverload<>::of(&QTimer::start));

    /// Stop timer event when thread was called
    QObject::connect(m_threadForMachineState.data(), &QThread::finished,
                     m_timerEventForMachineState.data(), QOverload<>::of(&QTimer::stop));

    /// Trigger worker on starting
    QObject::connect(m_threadForMachineState.data(), &QThread::started,
                     m_machineState.data(), [&](){m_machineState->worker();});

    /// stopped thread
    QObject::connect(m_machineState.data(), &MachineState::hasStopped,
                     this, &MachineStateProxy::doStopping);

    /// Call worker every time timer was timeout , routine task
    QObject::connect(m_timerEventForMachineState.data(), &QTimer::timeout,
                     m_machineState.data(), &MachineState::worker);

    /// Move the object to another thread
    m_machineState->moveToThread(m_threadForMachineState.data());
    m_timerEventForMachineState->moveToThread(m_threadForMachineState.data());

    /// start the thread
    m_threadForMachineState->start();
}

void MachineStateProxy::stop()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    /// Send to machine statae
    QMetaObject::invokeMethod(m_machineState.data(),
                              &MachineState::stop,
                              Qt::QueuedConnection);
}

void MachineStateProxy::setBlowerState(short state)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << state;

    /// compare with string communication
    /// this method better in error checking during compiling
    /// this method will append pending task to target object then execute on target thread
    QMetaObject::invokeMethod(m_machineState.data(), [&, state](){
        m_machineState->setBlowerState(state);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::doStopping()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if (m_threadForMachineState.isNull()) return;

    m_threadForMachineState->quit();
    m_threadForMachineState->wait();
    pMachineData->setHasStopped(true);
}
