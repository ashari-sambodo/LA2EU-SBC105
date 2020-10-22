#include "MachineState.h"
#include "MachineData.h"
#include "MachineEnums.h"
#include "MachineDefaultParameters.h"

#include <QThread>
#include <QtDebug>

MachineState::MachineState(QObject *parent) : QObject(parent)
{
    m_stop = false;
    loopStarterTaskExecute = true;
    stoppingExecuted = false;
}

MachineState::~MachineState()
{
    qDebug() << metaObject()->className() << __FUNCTION__<< thread();
}

void MachineState::worker()
{
    int state = pData->getDataMachineState();
    switch (state) {
    case MachineEnums::MACHINE_STATE_SETUP:
        setup();
        break;
    case MachineEnums::MACHINE_STATE_LOOP:
        loop();
        break;
    case MachineEnums::MACHINE_STATE_STOPPING:
        stopping();
        break;
    default:
        break;
    }
}

void MachineState::setMachineData(MachineData *data)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << data << thread();
    pData = data;
}

void MachineState::setup()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    /// Chane state to loop, routine task
    pData->setDataMachineState(MachineEnums::MACHINE_STATE_LOOP);
    /// GIVE A SIGNAL
    emit loopStarted();
}

void MachineState::loop()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    /// Just execute for the first cycle loop
    if (loopStarterTaskExecute) {
       loopStarterTaskExecute  = false;
       qDebug() << metaObject()->className() << __FUNCTION__ << "loopStarterTaskExecute";
    }

    /// READ_SENSOR
    /// put any read sensor routine task on here

    /// PROCESSING
    /// put any processing/machine state condition on here
    pData->setDataCount(pData->getDataCount() + 1);

    /// ACTUATOR
    /// put any actuator routine task on here

    if(m_stop){
        pData->setDataMachineState(MachineEnums::MACHINE_STATE_STOPPING);
    }
}

void MachineState::stopping()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    /// Guard to ensure this function only executed for one time
    /// if neede to implement
    if (stoppingExecuted) return;
    stoppingExecuted = true;

    emit hasStopped();
    QThread::currentThread()->quit();
}

/////////////////////////////////////////////////////////////////////////////////////////

void MachineState::stop()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    m_stop = true;
}
