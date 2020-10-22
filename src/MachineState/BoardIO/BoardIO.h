#pragma once

#include <QObject>
#include <QVector>

#include <unistd.h>
#include "Drivers/i2c/I2CCom.h"
#include "Drivers/ClassDriver.h"

class BoardIO : public QObject
{
    Q_OBJECT
public:
    explicit BoardIO(QObject *parent = nullptr);

    void    worker(int parameter = 0);
    void    setI2C(I2CCom *pObject);
    int     addModule(ClassDriver *pModule);

private:
    I2CCom      *pI2c;

    //MODULES
    QVector<ClassDriver*> pModules;

signals:

};
