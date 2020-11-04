/**************************************************************************
** Copyright (C) 2019 by ESCO Global - All Rights Reserved
** http://www.escoglobal.com
**
** Unauthorized copying of this file, via any medium is strictly prohibited
** Proprietary and confidential
** Written by elect 3-12-2019
**************************************************************************/
#pragma once

#include "../ClassManager.h"
#include "BoardIO/Drivers/SensirionSPD8xx/SensirionSPD8xx.h"

class PressureDiffManager : public ClassManager
{
    Q_OBJECT
public:
    explicit PressureDiffManager(QObject *parent = nullptr);

    void routineTask(int parameter = 0) override;

    void setSubModule(SensirionSPD8xx *obj);
    void setOffsetPa(int offsetPa);

    int actualPa() const;
    int offsetPa() const;

signals:
    void actualPaChanged(int newVal);

public slots:

private:
    int m_actualPa;
    int m_offsetPa;

    SensirionSPD8xx *pSubModule;
};
