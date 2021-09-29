#pragma once

#include "../ClassManager.h"
#include "BoardIO/Drivers/DIOpca9674/DIOpca9674.h"

class SashWindow : public ClassManager
{
    Q_OBJECT
public:
    explicit SashWindow(QObject *parent = nullptr);

    void routineTask(int parameter = 0) override;

    void setSubModule(DIOpca9674 *obj);

    int isSashStateChanged() const;
    void clearFlagSashStateChanged();
    int previousState() const;
    int previousPreviousState() const;
    int sashState() const;

    enum EnumItemSashState {
        SASH_STATE_ERROR_SENSOR_SSV,
        SASH_STATE_FULLY_CLOSE_SSV,
        SASH_STATE_UNSAFE_SSV,
        SASH_STATE_STANDBY_SSV,
        SASH_STATE_WORK_SSV,
        SASH_STATE_FULLY_OPEN_SSV
    };

    bool dummy6StateEnable() const;
    void setDummy6StateEnable(bool dummy6StateEnable);
    short dummy6State() const;
    void setDummy6State(short dummy6State);

    bool dummyStateEnable() const;
    void setDummyStateEnable(bool dummyStateEnable);

    short dummyState() const;
    void setDummyState(short dummyState);

signals:
    void sashStateChanged(int newVal, int oldVal, int oldOldVal);
    void mSwitchStateChanged(int index, int newVal);
    void workerFinished();

private:
    DIOpca9674  *pSubModule;

    int m_sashState;
    //    int m_mSwitchState[4];
    int m_mSwitchState[6] = {0, 0, 0, 0, 0, 0};
    int m_sashStateChanged;
    int m_previousState;
    int m_previousPreviousState;

    bool m_dummy6StateEnable = false;
    short m_dummy6State = 0;

    bool m_dummyStateEnable = false;
    short m_dummyState = 0;

    //    bool m_dummyStateEnable = true;
    //    short m_dummyState = SASH_STATE_WORK_SSV;
    //    short m_dummyState = SASH_STATE_FULLY_CLOSE_SSV;
    //    short m_dummyState = SASH_STATE_UNSAFE_SSV;

    bool m_fisrtReadState = false;

};
