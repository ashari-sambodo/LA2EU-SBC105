/**************************************************************************
** Copyright (C) 2019 by ESCO Global - All Rights Reserved
** http://www.escoglobal.com
**
** Unauthorized copying of this file, via any medium is strictly prohibited
** Proprietary and confidential
** Written by elect 3-12-2019
**************************************************************************/
#pragma once

#include <QObject>
#include <QScopedPointer>
#include <QEventLoop>

class ClassManager : public QObject
{
    Q_OBJECT
public:
    explicit ClassManager(QObject *parent = nullptr);

    virtual void routineTask(int parameter = 0) = 0;

    /// pure virtual function
    //    virtual void worker() = 0;

    /// exec(); This for easy implementing independent thread looping
    /// if the worker dont use triggered by timer event
    /// so, the thread will keep looping inside exec()
    /// to listen if any pending task called from outside class
    /// this method should be called from signal thread::started
    void exec();
    /// quit(); This for tell to exec() want to stopping the looping
    void quit();

signals:
    void hasComeOut();

private:
    QScopedPointer<QEventLoop> m_eventLoop;
};
