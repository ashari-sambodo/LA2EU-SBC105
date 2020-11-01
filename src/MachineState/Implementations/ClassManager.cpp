/**************************************************************************
** Copyright (C) 2019 by ESCO Global - All Rights Reserved
** http://www.escoglobal.com
**
** Unauthorized copying of this file, via any medium is strictly prohibited
** Proprietary and confidential
** Written by elect 3-12-2019
**************************************************************************/
#include "ClassManager.h"

ClassManager::ClassManager(QObject *parent) : QObject(parent)
{
}

void ClassManager::exec()
{
    if(!m_eventLoop.isNull()) return;

    m_eventLoop.reset(new QEventLoop);

    /// listen then execute if any pending event task
    m_eventLoop->exec();

    emit hasComeOut();
}

void ClassManager::quit()
{
    if(!m_eventLoop.isNull()) return;

    /// quit from m_eventLoop->exec();
    m_eventLoop->quit();
}



