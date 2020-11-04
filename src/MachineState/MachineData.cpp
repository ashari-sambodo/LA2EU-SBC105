#include "MachineData.h"

#include <QQmlEngine>
#include <QJSEngine>

#include <QDebug>

static MachineData* s_instance = nullptr;

QObject *MachineData::singletonProvider(QQmlEngine *qmlEngine, QJSEngine *)
{
    if(!s_instance){
        qDebug() << "MachineData::singletonProvider::create";
        s_instance = new MachineData(qmlEngine);
    }
    return s_instance;
}

void MachineData::singletonDelete()
{
    qDebug() << __FUNCTION__;
    if(s_instance){
        delete s_instance;
    }
}

MachineData::MachineData(QObject *parent) : QObject(parent)
{

}

MachineData::~MachineData()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
}

short MachineData::getMachineState() const
{
    return m_machineState;
}

void MachineData::setMachineState(short workerState)
{
    if (m_machineState == workerState)
        return;

    m_machineState = workerState;
    emit machineStateChanged(m_machineState);
}

int MachineData::getCount() const
{
    return m_count;
}

void MachineData::setCount(int count)
{
    if (m_count == count)
        return;

    m_count = count;
    emit countChanged(m_count);
}

bool MachineData::getHasStopped() const
{
    return m_hasStopped;
}

void MachineData::setHasStopped(bool hasStopped)
{
    if (m_hasStopped == hasStopped)
        return;

    m_hasStopped = hasStopped;
    emit hasStoppedChanged(m_hasStopped);
}

int MachineData::getBlowerEcmDemandMode() const
{
    return m_blowerEcmDemandMode;
}

short MachineData::getBlowerDownflowState() const
{
    return m_blowerDownflowState;
}

short MachineData::getBlowerExhaustState() const
{
    return m_blowerExhaustState;
}

short MachineData::getLightState() const
{
    return m_lightState;
}

short MachineData::getSocketState() const
{
    return m_socketState;
}

short MachineData::getGasState() const
{
    return m_gasState;
}

short MachineData::getUvState() const
{
    return m_uvState;
}

short MachineData::getMuteAlarmState() const
{
    return m_muteAlarmState;
}

short MachineData::getSashWindowState() const
{
    return m_sashWindowState;
}

short MachineData::getSashMotorizeState() const
{
    return m_sashMotorizeState;
}

short MachineData::getLightIntensity() const
{
    return m_lightIntensity;
}

bool MachineData::getAlarmInflowLow() const
{
    return m_alarmInflowLow;
}

bool MachineData::getAlarmSashError() const
{
    return m_alarmSashError;
}

bool MachineData::getAlarmSashUnsafe() const
{
    return m_alarmSashUnsafe;
}

bool MachineData::getAlarmDownflowLow() const
{
    return m_alarmDownflowLow;
}

bool MachineData::getAlarmDownflowHigh() const
{
    return m_alarmDownflowHigh;
}

float MachineData::getVelocityInflowMatric() const
{
    return m_velocityInflowMatric;
}

float MachineData::getVelocityDownflowMatric() const
{
    return m_velocityDownflowMatric;
}

void MachineData::initSingleton()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
}

void MachineData::setBlowerEcmDemandMode(int blowerEcmDemandMode)
{
    if (m_blowerEcmDemandMode == blowerEcmDemandMode)
        return;

    m_blowerEcmDemandMode = blowerEcmDemandMode;
    emit blowerEcmDemandModeChanged(m_blowerEcmDemandMode);
}

void MachineData::setBlowerDownflowState(short blowerDownflowState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if (m_blowerDownflowState == blowerDownflowState)
        return;

    m_blowerDownflowState = blowerDownflowState;
    emit blowerDownflowStateChanged(m_blowerDownflowState);
}

void MachineData::setBlowerExhaustState(short blowerExhaustState)
{
    if (m_blowerExhaustState == blowerExhaustState)
        return;

    m_blowerExhaustState = blowerExhaustState;
    emit blowerExhaustStateChanged(m_blowerExhaustState);
}

void MachineData::setLightState(short lightState)
{
    if (m_lightState == lightState)
        return;

    m_lightState = lightState;
    emit lightStateChanged(m_lightState);
}

void MachineData::setSocketState(short socketState)
{
    if (m_socketState == socketState)
        return;

    m_socketState = socketState;
    emit lightStateChanged(m_socketState);
}

void MachineData::setGasState(short gasState)
{
    if (m_gasState == gasState)
        return;

    m_gasState = gasState;
    emit gasStateChanged(m_gasState);
}

void MachineData::setUvState(short uvState)
{
    if (m_uvState == uvState)
        return;

    m_uvState = uvState;
    emit uvStateChanged(m_uvState);
}

void MachineData::setMuteAlarmState(short muteAlarmState)
{
    if (m_muteAlarmState == muteAlarmState)
        return;

    m_muteAlarmState = muteAlarmState;
    emit muteAlarmStateChanged(m_muteAlarmState);
}

void MachineData::setSashWindowState(short sashWindowState)
{
    if (m_sashWindowState == sashWindowState)
        return;

    m_sashWindowState = sashWindowState;
    emit sashWindowStateChanged(m_sashWindowState);
}

void MachineData::setSashMotorizeState(short sashMotorizeState)
{
    if (m_sashMotorizeState == sashMotorizeState)
        return;

    m_sashMotorizeState = sashMotorizeState;
    emit sashMotorizeStateChanged(m_sashMotorizeState);
}

void MachineData::setLightIntensity(short lightIntensity)
{
    if (m_lightIntensity == lightIntensity)
        return;

    m_lightIntensity = lightIntensity;
    emit lightIntensityChanged(m_lightIntensity);
}

void MachineData::setAlarmInflowLow(bool alarmInflowLow)
{
    if (m_alarmInflowLow == alarmInflowLow)
        return;

    m_alarmInflowLow = alarmInflowLow;
    emit alarmInflowLowChanged(m_alarmInflowLow);
}

void MachineData::setAlarmSashError(bool alarmSashError)
{
    if (m_alarmSashError == alarmSashError)
        return;

    m_alarmSashError = alarmSashError;
    emit alarmSashErrorChanged(m_alarmSashError);
}

void MachineData::setAlarmSashUnsafe(bool alarmSashUnsafe)
{
    if (m_alarmSashUnsafe == alarmSashUnsafe)
        return;

    m_alarmSashUnsafe = alarmSashUnsafe;
    emit alarmSashUnsafeChanged(m_alarmSashUnsafe);
}

void MachineData::setAlarmDownfLow(bool alarmDownflowLow)
{
    if (m_alarmDownflowLow == alarmDownflowLow)
        return;

    m_alarmDownflowLow = alarmDownflowLow;
    emit alarmDownflowHighChanged(m_alarmDownflowLow);
}

void MachineData::setAlarmDownfHigh(bool alarmDownflowHigh)
{
    if (m_alarmDownflowHigh == alarmDownflowHigh)
        return;

    m_alarmDownflowHigh = alarmDownflowHigh;
    emit alarmDownflowHighChanged(m_alarmDownflowHigh);
}

void MachineData::setVelocityInflowMatric(float velocityInflowMatric)
{
    //    qWarning("Floating point comparison needs context sanity check");
    if (qFuzzyCompare(1 + m_velocityInflowMatric, 1 + velocityInflowMatric))
        return;

    m_velocityInflowMatric = velocityInflowMatric;
    emit velocityInflowMatricChanged(m_velocityInflowMatric);
}

void MachineData::setVelocityDownflowMatric(float velocityDownflowMatric)
{
    //        qWarning("Floating point comparison needs context sanity check");
    if (qFuzzyCompare(1 + m_velocityDownflowMatric, 1 + velocityDownflowMatric))
        return;

    m_velocityDownflowMatric = velocityDownflowMatric;
    emit velocityDownflowMatricChanged(m_velocityDownflowMatric);
}
