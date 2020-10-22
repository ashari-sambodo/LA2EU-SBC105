#include "QGpioSysfs.h"

QGpioSysfs::QGpioSysfs()
{

}

QGpioSysfs::~QGpioSysfs()
{
}

void QGpioSysfs::setup(int pin, int direction)
{
#ifndef __arm__
    printf("QGpioSysfs::setup pin %d direction %d\n", pin, direction);
    fflush(stdout);
    return;
#endif
    //unexport first if directory exist
    QString oldpath = "/sys/class/gpio/gpio" + QString::number(pin);
    QFileInfo checkFile(oldpath);
    if(checkFile.exists()){
        QFile sysFile("/sys/class/gpio/unexport");
        if(!sysFile.open(QIODevice::WriteOnly | QIODevice::Text)){
            //            qDebug() << "QGpioSysfs::setup Can not open sysfs file";
            return;
        }
        QTextStream stream(&sysFile);
        stream << QString::number(pin);
        //        qDebug() << "QGpioSysfs::setup Gpio unexport success " << pin;
    }

    //export, kernel will make gpio regarding the gpio pin
    QFile sysFile("/sys/class/gpio/export");
    if(!sysFile.open(QIODevice::WriteOnly | QIODevice::Text)){
        //        qDebug() << "QGpioSysfs::setup Can not open sysfs file";
        return;
    }

    //export gpio pin
    gpioPin = pin;
    QString gpioPinText(QString::number(gpioPin));
    QTextStream stream(&sysFile);
    stream << gpioPinText;
    sysFile.close();
    gpioPath = "/sys/class/gpio/gpio";
    gpioPath.append(QString::number(gpioPin));

    //set gpio direction
    QSharedPointer<QFile> sysGpioDirection;
    sysGpioDirection.reset(new QFile());
    sysGpioDirection->setFileName(gpioPath + "/direction");
    if(!sysGpioDirection->open(QIODevice::ReadWrite | QIODevice::Text)){
        //        qDebug() << "QGpioSysfs::setup Can not open sysfs file gpio direction " << sysGpioDirection->fileName();
        return;
    }
    QTextStream streamDirection(sysGpioDirection.data());
    streamDirection << (direction == 1 ? "out" : "in");
    streamDirection.flush();
    //    sysGpioDirection->close();

    //set default value to low
    sysGpioValue.reset(new QFile());
    sysGpioValue->setFileName(gpioPath + "/value");
    if(!sysGpioValue->open(QIODevice::ReadWrite | QIODevice::Text)){
//        qDebug() << "QGpioSysfs::setup Can not open sysfs file gpio value";
        return;
    }
    QTextStream streamValue(sysGpioValue.data());
    streamValue << "0";
    streamValue.flush();
    //    sysGpioValue->close();

//    qDebug() << "QGpioSysfs::setup Gpio sys setup finished of gpio " << pin;
}

void QGpioSysfs::setValue(int value)
{
#ifndef __arm__
    //    printf("QGpioSysfs::setValue", value);
    //    fflush(stdout);
    this->value = value;
    return;
#endif
    QTextStream stream(sysGpioValue.data());
    stream.seek(0);
    stream << QString::number(value);
    stream.flush();
}

int QGpioSysfs::getValue()
{
#ifndef __arm__
    //    printf("QGpioSysfs::getValue", value);
    //    fflush(stdout);
    return value;
#endif
    QTextStream stream(sysGpioValue.data());
    stream.seek(0);
    QString valStr = stream.read(1);

    if(valStr == "1") value = 1;
    else value = 0;
    return value;
}
