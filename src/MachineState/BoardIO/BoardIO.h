#pragma once

#include <QObject>
#include <QVector>
#include <QtDebug>

#include <unistd.h>
#include "Drivers/i2c/I2CPort.h"
#include "Drivers/ClassDriver.h"

class BoardIO : public QObject
{
    Q_OBJECT
public:
    explicit BoardIO(QObject *parent = nullptr);

    void    worker(int parameter = 0);
    void    setI2C(I2CPort *pObject);
    int     addSlave(ClassDriver *pModule);

private:
    I2CPort      *pI2c;

    //MODULES
    QVector<ClassDriver*> pModules;

signals:

};
