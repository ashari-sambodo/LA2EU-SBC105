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

void MachineStateProxy::setBlowerDownflowDutyCycle(short state)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << state;

    /// compare with string communication
    /// this method better in error checking during compiling
    /// this method will append pending task to target object then execute on target thread
    QMetaObject::invokeMethod(m_machineState.data(), [&, state](){
        m_machineState->setBlowerDownflowDutyCycle(state);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setBlowerInflowDutyCycle(short state)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << state;

    /// compare with string communication
    /// this method better in error checking during compiling
    /// this method will append pending task to target object then execute on target thread
    QMetaObject::invokeMethod(m_machineState.data(), [&, state](){
        m_machineState->setBlowerInflowDutyCycle(state);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setLightIntensity(short lightIntensity)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << lightIntensity;

    /// compare with string communication
    /// this method better in error checking during compiling
    /// this method will append pending task to target object then execute on target thread
    QMetaObject::invokeMethod(m_machineState.data(), [&, lightIntensity](){
        m_machineState->setLightIntensity(lightIntensity);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setLightState(short lightState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << lightState;

    /// compare with string communication
    /// this method better in error checking during compiling
    /// this method will append pending task to target object then execute on target thread
    QMetaObject::invokeMethod(m_machineState.data(), [&, lightState](){
        m_machineState->setLightState(lightState);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setSocketState(short socketState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << socketState;

    /// compare with string communication
    /// this method better in error checking during compiling
    /// this method will append pending task to target object then execute on target thread
    QMetaObject::invokeMethod(m_machineState.data(), [&, socketState](){
        m_machineState->setSocketState(socketState);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setGasState(short gasState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << gasState;

    /// compare with string communication
    /// this method better in error checking during compiling
    /// this method will append pending task to target object then execute on target thread
    QMetaObject::invokeMethod(m_machineState.data(), [&, gasState](){
        m_machineState->setGasState(gasState);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setUvState(short uvState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << uvState;

    /// compare with string communication
    /// this method better in error checking during compiling
    /// this method will append pending task to target object then execute on target thread
    QMetaObject::invokeMethod(m_machineState.data(), [&, uvState](){
        m_machineState->setUvState(uvState);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setSashWindowMotorizeState(short sashMotorizeState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << sashMotorizeState;

    /// compare with string communication
    /// this method better in error checking during compiling
    /// this method will append pending task to target object then execute on target thread
    QMetaObject::invokeMethod(m_machineState.data(), [&, sashMotorizeState](){
        m_machineState->setSashMotorizeState(sashMotorizeState);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setInflowAdcPointFactory(short point, int adc)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, point, adc](){
        m_machineState->setInflowAdcPointFactory(point, adc);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setInflowAdcPointField(short point, int adc)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, point, adc](){
        m_machineState->setInflowAdcPointField(point, adc);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setInflowVelocityPointFactory(short point, float value)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, point, value](){
        m_machineState->setInflowVelocityPointFactory(point, value);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setInflowVelocityPointField(short point, float value)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, point, value](){
        m_machineState->setInflowVelocityPointField(point, value);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setInflowConstant(int ifaConstant)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, ifaConstant](){
        m_machineState->setInflowConstant(ifaConstant);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setInflowTemperatureFactory(float ifaTemperatureFactory)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, ifaTemperatureFactory](){
        m_machineState->setInflowTemperatureFactory(ifaTemperatureFactory);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setInflowTemperatureADCFactory(int ifaTemperatureADCFactory)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, ifaTemperatureADCFactory](){
        m_machineState->setInflowTemperatureADCFactory(ifaTemperatureADCFactory);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setInflowTemperatureField(float ifaTemperatureField)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, ifaTemperatureField](){
        m_machineState->setInflowTemperatureField(ifaTemperatureField);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setInflowTemperatureADCField(int ifaTemperatureADCField)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, ifaTemperatureADCField](){
        m_machineState->setInflowTemperatureADCField(ifaTemperatureADCField);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setInflowLowLimitVelocity(float ifaLowLimitVelocity)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, ifaLowLimitVelocity](){
        m_machineState->setInflowLowLimitVelocity(ifaLowLimitVelocity);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setDownflowAdcPointFactory(short point, int adc)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, point, adc](){
        m_machineState->setDownflowAdcPointFactory(point, adc);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setDownflowAdcPointField(short point, int adc)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, point, adc](){
        m_machineState->setDownflowAdcPointField(point, adc);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setDownflowVelocityPointFactory(short point, float value)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, point, value](){
        m_machineState->setDownflowVelocityPointFactory(point, value);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setDownflowVelocityPointField(short point, float value)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, point, value](){
        m_machineState->setDownflowVelocityPointField(point, value);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setDownflowConstant(int dfaConstant)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, dfaConstant](){
        m_machineState->setDownflowConstant(dfaConstant);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setDownflowTemperatureFactory(float dfaTemperatureFactory)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, dfaTemperatureFactory](){
        m_machineState->setDownflowConstant(dfaTemperatureFactory);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setDownflowTemperatureField(float dfaTemperatureField)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, dfaTemperatureField](){
        m_machineState->setDownflowConstant(dfaTemperatureField);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setDownflowTemperatureADCField(int dfaTemperatureADCField)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, dfaTemperatureADCField](){
        m_machineState->setDownflowConstant(dfaTemperatureADCField);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setDownflowTemperatureADCFactory(int dfaTemperatureADCFactory)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, dfaTemperatureADCFactory](){
        m_machineState->setDownflowConstant(dfaTemperatureADCFactory);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setDownflowLowLimitVelocity(float dfaLowLimitVelocity)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, dfaLowLimitVelocity](){
        m_machineState->setDownflowConstant(dfaLowLimitVelocity);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setDownflowHigLimitVelocity(float dfaHigLimitVelocity)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, dfaHigLimitVelocity](){
        m_machineState->setDownflowConstant(dfaHigLimitVelocity);
    },
    Qt::QueuedConnection);
}

void MachineStateProxy::setAirflowCalibration(short value)
{
    QMetaObject::invokeMethod(m_machineState.data(), [&, value](){
        m_machineState->setAirflowCalibration(value);
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
