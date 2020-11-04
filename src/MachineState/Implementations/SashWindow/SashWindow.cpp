#include "SashWindow.h"

#define SASH_BIT_STATE_FULLY_CLOSE      0b00000100
#define SASH_BIT_STATE_WORK             0b00000010
#define SASH_BIT_STATE_FULLY_OPEN       0b00000001
#define SASH_BIT_STATE_STANDBY          0b00001000
#define SASH_BIT_STATE_UNSAFE           0b00000000

SashManager::SashManager(QObject *parent)
    : ClassManager(parent)
{
    pSubModule       = nullptr;
    m_sashState         = SASH_STATE_ERROR_SENSOR_SSV;
    m_sashStateChanged  = 0;
    m_previousState     = SASH_STATE_ERROR_SENSOR_SSV;
    for (int i = 0;i < 5; i++) {
        m_mSwitchState[i] = 0;
    }

    //#ifndef __arm__
    //    m_timer = new QTimer();
    //    connect(m_timer, &QTimer::timeout, this, [=](){
    //        m_dummyStateEnabled = 1;
    //        setDummyState(EEnums::SASH_STATE_WORK_SSV);
    //    });
    //    m_timer->setInterval(5000);
    //    m_timer->setSingleShot(true);
    //    m_timer->start();
    //#endif
}

void SashManager::setSubModule(DIOpca9674 *obj)
{
    pSubModule = obj;
}

int SashManager::isSashStateChanged() const
{
    return m_sashStateChanged;
}

void SashManager::clearFlagSashStateChanged()
{
    if(m_sashStateChanged) m_sashStateChanged = 0;
}

int SashManager::previousState() const
{
    return m_previousState;
}

void SashManager::routineTask(int parameter)
{
    Q_UNUSED(parameter)
    //    qDebug() << "SashManager::worker()";
    int ival;
    ////Microswitch state
    for(int i=0; i<4; i++){

        ival = pSubModule->getRegBufferStateIO(i);
        //        //if dummy enabled
        //        if(m_dummyStateEnabled){
        //            ival = m_dummyMSwitchState[i];
        //        }

        if(m_mSwitchState[i] != ival){
            m_mSwitchState[i] = ival;

            //signal
            emit mSwitchStateChanged(i, m_mSwitchState[i]);
        }
    }
    ///

    ///Decode mSwitchState to Sash State
    ival = 0;
    for(int i=0; i<4; i++){
        ival |= m_mSwitchState[i] << i;
    }

    if(ival == SASH_BIT_STATE_FULLY_CLOSE){
        ival = SASH_STATE_FULLY_CLOSE_SSV;
    }
    else if(ival == SASH_BIT_STATE_UNSAFE){
        ival = SASH_STATE_UNSAFE_SSV;
    }
    else if(ival == SASH_BIT_STATE_STANDBY){
        ival = SASH_STATE_STANDBY_SSV;
    }
    else if(ival == SASH_BIT_STATE_WORK){
        ival = SASH_STATE_WORK_SSV;
    }
    else if(ival == SASH_BIT_STATE_FULLY_OPEN){
        ival = SASH_STATE_FULLY_OPEN_SSV;
    }else{
        ival = SASH_STATE_ERROR_SENSOR_SSV;
    }

    //Update sash state
    if(m_sashState != ival){
        m_previousState = m_sashState;
        m_sashState     = ival;

        if(!m_sashStateChanged) m_sashStateChanged = 1;

        //signal
        emit sashStateChanged(m_sashState, m_previousState);

        //        qDebug() << "m_sashState: "<< m_sashState;
        //        qDebug() << "m_mSwitchState: " << m_mSwitchState[0] << m_mSwitchState[1] << m_mSwitchState[2] << m_mSwitchState[3];
    }
    ///////////////////

    emit workerFinished();
}

int SashManager::sashState() const
{
    return m_sashState;
}
