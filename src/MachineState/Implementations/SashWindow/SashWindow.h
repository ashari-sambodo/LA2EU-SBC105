#pragma once

#include "../ClassManager.h"
#include "BoardIO/Drivers/DIOpca9674/DIOpca9674.h"

class SashManager : public ClassManager
{
    Q_OBJECT
public:
    explicit SashManager(QObject *parent = nullptr);

    void worker(int parameter = 0) override;

    void setSubModule(DIOpca9674 *obj);

    int isSashStateChanged() const;
    void clearFlagSashStateChanged();
    int previousState() const;
    int sashState() const;

    enum EnumItemSashState{
        SASH_STATE_ERROR_SENSOR_SSV,
        SASH_STATE_FULLY_CLOSE_SSV,
        SASH_STATE_UNSAFE_SSV,
        SASH_STATE_STANDBY_SSV,
        SASH_STATE_WORK_SSV,
        SASH_STATE_FULLY_OPEN_SSV
    };

signals:
    void sashStateChanged(int newVal, int oldVal);
    void mSwitchStateChanged(int index, int newVal);
    void workerFinished();

private:
    DIOpca9674  *pSubModule;

    int m_sashState;
    int m_mSwitchState[4];
    int m_sashStateChanged;
    int m_previousState;
};
