#ifndef QGPIOSYSFS_H
#define QGPIOSYSFS_H

#include <QSharedPointer>
#include <QFile>
#include <QTextStream>
#include <QFileInfo>

class QGpioSysfs
{
public:
    QGpioSysfs();
    ~QGpioSysfs();

    void setup(int pin, int direction = 1);
    void setValue(int value);
    int getValue();

private:
    QSharedPointer<QFile> sysGpioValue;
    QString gpioPath;

    int gpioPin;
    int direction;
    int value;
};

#endif // QGPIOSYSFS_H
