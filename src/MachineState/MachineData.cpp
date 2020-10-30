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
    m_machineState = 0;
    m_hasStopped = true;
    m_count = 0;
}

MachineData::~MachineData()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
}

int MachineData::getDataMachineState() const
{
    return m_machineState;
}

void MachineData::setDataMachineState(int workerState)
{
    if (m_machineState == workerState)
        return;

    m_machineState = workerState;
    emit dataMachineStateChanged(m_machineState);
}

int MachineData::getDataCount() const
{
    return m_count;
}

void MachineData::setDataCount(int count)
{
    if (m_count == count)
        return;

    m_count = count;
    emit dataCountChanged(m_count);
}

bool MachineData::getDataHasStopped() const
{
    return m_hasStopped;
}

void MachineData::setDataHasStopped(bool hasStopped)
{
    if (m_hasStopped == hasStopped)
        return;

    m_hasStopped = hasStopped;
    emit hasStoppedChanged(m_hasStopped);
}

void MachineData::initSingleton()
{
    qDebug() << metaObject()->className() << __FUNCTION__;
}
