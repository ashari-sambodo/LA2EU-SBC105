/**************************************************************************
** Copyright (C) 2019 by ESCO Global - All Rights Reserved
** http://www.escoglobal.com
**
** Unauthorized copying of this file, via any medium is strictly prohibited
** Proprietary and confidential
** Written by elect 3-12-2019
**************************************************************************/
#include "PressureDiff.h"

PressureDiffManager::PressureDiffManager(QObject *parent)
    : ClassManager (parent)
{
    m_actualPa = 0;
    m_offsetPa = 0;
}

void PressureDiffManager::routineTask(int parameter)
{
    Q_UNUSED(parameter)
    //GET_VALUE_FROM_MODULE
    int ival;
    ival = pSubModule->diffPressurePa() + m_offsetPa;
    if(m_actualPa != ival){
        //STORE_LATEST_VALUE
        m_actualPa = ival;

        //EMIT_SIGNAL_CHANGED
        emit actualPaChanged(m_actualPa);
    }
}

void PressureDiffManager::setSubModule(SensirionSPD8xx *obj)
{
    pSubModule = obj;
}

void PressureDiffManager::setOffsetPa(int offsetPa)
{
    m_offsetPa = offsetPa;
}

int PressureDiffManager::actualPa() const
{
    return m_actualPa;
}

int PressureDiffManager::offsetPa() const
{
    return m_offsetPa;
}
