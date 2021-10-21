#include "SashWindow.h"

#define DIGITAL_INPUT_PIN_MAXIMUM   6

#define SASH_BIT_STATE_FULLY_CLOSE      0b00010100
//#define SASH_BIT_STATE_FULLY_CLOSE      0b00000100
#define SASH_BIT_STATE_WORK             0b00000010
#define SASH_BIT_STATE_FULLY_OPEN       0b00000001
#define SASH_BIT_STATE_STANDBY          0b00001000
#define SASH_BIT_STATE_UNSAFE           0b00000000
#define SASH_BIT_STATE_UNSAFE_FC1       0b00000100
#define SASH_BIT_STATE_UNSAFE_FC2       0b00010000
#define SASH_BIT_STATE_WORK2            0b00100000
#define SASH_BIT_STATE_WORK12           0b00100010

SashWindow::SashWindow(QObject *parent)
    : ClassManager(parent)
{
    pSubModule              = nullptr;
    m_sashState             = SASH_STATE_FULLY_CLOSE_SSV;
    m_previousState         = SASH_STATE_FULLY_CLOSE_SSV;
    m_previousPreviousState = SASH_STATE_FULLY_CLOSE_SSV;
    m_sashStateChanged  = 0;
    m_safeSwitcher = SWITCHER_UP;
    //    for (int i = 0;i < 5; i++) {
    //        m_mSwitchState[i] = 0;
    //    }

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

void SashWindow::setSubModule(DIOpca9674 *obj)
{
    pSubModule = obj;
}

int SashWindow::isSashStateChanged() const
{
    return m_sashStateChanged;
}

void SashWindow::clearFlagSashStateChanged()
{
    if(m_sashStateChanged) m_sashStateChanged = 0;
}

int SashWindow::previousState() const
{
    return m_previousState;
}

void SashWindow::routineTask(int parameter)
{
    Q_UNUSED(parameter)
    //    qDebug() << "SashManager::worker()";
    int ival;
    int ivalState = 0;

#ifndef QT_DEBUG
    ////Microswitch state
    for(int i=0; i < DIGITAL_INPUT_PIN_MAXIMUM; i++){

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
    }///
    ///

    ///Decode mSwitchState to Sash State
    ival = 0;
    for(int i=0; i<DIGITAL_INPUT_PIN_MAXIMUM; i++){
        ival |= m_mSwitchState[i] << i;
    }

    switch (ival) {
    case SASH_BIT_STATE_FULLY_CLOSE:
        ivalState = SASH_STATE_FULLY_CLOSE_SSV;
        break;
    case SASH_BIT_STATE_UNSAFE:
    case SASH_BIT_STATE_UNSAFE_FC1:
    case SASH_BIT_STATE_UNSAFE_FC2:
        ivalState = SASH_STATE_UNSAFE_SSV;
        break;
    case SASH_BIT_STATE_STANDBY:
        ivalState = SASH_STATE_STANDBY_SSV;
        break;
    case SASH_BIT_STATE_WORK:
//        if(m_safeSwitcher == SWITCHER_UP){
//            ivalState = SASH_STATE_WORK_SSV;
//        }else{
            ivalState = SASH_STATE_UNSAFE_SSV;
//        }
        break;
    case SASH_BIT_STATE_WORK2:
        if(m_safeSwitcher == SWITCHER_DOWN){
            ivalState = SASH_STATE_WORK_SSV;
        }else{
            ivalState = SASH_STATE_UNSAFE_SSV;
        }
        break;
    case SASH_BIT_STATE_WORK12:
        ivalState = SASH_STATE_WORK_SSV;
        break;
    case SASH_BIT_STATE_FULLY_OPEN:
        ivalState = SASH_STATE_FULLY_OPEN_SSV;
        break;
    default:
        ivalState = SASH_STATE_ERROR_SENSOR_SSV;
        break;
    }//
#else
    Q_UNUSED(ival)
    if(m_dummy6StateEnable){
        if( m_mSwitchState[5] != m_dummy6State){
            m_mSwitchState[5] = m_dummy6State;
            emit mSwitchStateChanged(5, m_dummy6State);
        }
    }
    if(m_dummyStateEnable){
        ivalState = m_dummyState;
    }
#endif

    //Update sash state
    if(m_sashState != ivalState){
        if(!m_fisrtReadState) {
            m_previousPreviousState = m_previousState;
            m_previousState         = m_sashState;
            m_sashState             = ivalState;
        }
        else {
            m_fisrtReadState = true;
            m_previousPreviousState = ivalState;
            m_previousState         = ivalState;
            m_sashState             = ivalState;
        }

        if(!m_sashStateChanged) m_sashStateChanged = 1;

        //signal
        emit sashStateChanged(m_sashState, m_previousState, m_previousPreviousState);

        //        qDebug() << "m_sashState: "<< m_sashState;
        //        qDebug() << "m_mSwitchState: " << m_mSwitchState[0] << m_mSwitchState[1] << m_mSwitchState[2] << m_mSwitchState[3];
    }
    ///////////////////

    emit workerFinished();
}

int SashWindow::sashState() const
{
    return m_sashState;
}

void SashWindow::setSafeSwitcher(short value)
{
    m_safeSwitcher = value;
}

bool SashWindow::dummy6StateEnable() const
{
    return m_dummy6StateEnable;
}

void SashWindow::setDummy6StateEnable(bool dummy6StateEnable)
{
    m_dummy6StateEnable = dummy6StateEnable;
}

short SashWindow::dummy6State() const
{
    return m_dummy6State;
}

void SashWindow::setDummy6State(short dummy6State)
{
    m_dummy6State = dummy6State;
}

bool SashWindow::dummyStateEnable() const
{
    return m_dummyStateEnable;
}

void SashWindow::setDummyStateEnable(bool dummyStateEnable)
{
    m_dummyStateEnable = dummyStateEnable;
}

short SashWindow::dummyState() const
{
    return m_dummyState;
}

void SashWindow::setDummyState(short dummyState)
{
    m_dummyState = dummyState;
}

int SashWindow::previousPreviousState() const
{
    return m_previousPreviousState;
}
