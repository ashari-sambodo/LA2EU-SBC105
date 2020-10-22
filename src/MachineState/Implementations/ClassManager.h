/**************************************************************************
** Copyright (C) 2019 by ESCO Global - All Rights Reserved
** http://www.escoglobal.com
**
** Unauthorized copying of this file, via any medium is strictly prohibited
** Proprietary and confidential
** Written by elect 3-12-2019
**************************************************************************/
#ifndef OBJECTMANAGER_H
#define OBJECTMANAGER_H

#include <QObject>

class ClassManager : public QObject
{
    Q_OBJECT
public:
    explicit ClassManager(QObject *parent = nullptr);

    virtual void worker(int parameter = 0) = 0;

    virtual void worker() = 0;

};

#endif // OBJECTMANAGER_H
