#include <QFile>
#include <QTextStream>
#include <QFileInfo>
#include "QGpioSysfs.h"

QGpioSysfs::QGpioSysfs()
{

}

QGpioSysfs::~QGpioSysfs()
{
    if(!m_pSysGpioValue.isNull()){
        if(m_pSysGpioValue->isOpen()){
            QTextStream stream(m_pSysGpioValue.data());
            stream.seek(0);
            stream << QString::number(0);
            stream.flush();
        }
    }
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
    m_gpioPin = pin;
    QString gpioPinText(QString::number(m_gpioPin));
    QTextStream stream(&sysFile);
    stream << gpioPinText;
    sysFile.close();
    m_gpioPath = "/sys/class/gpio/gpio";
    m_gpioPath.append(QString::number(m_gpioPin));

    //set gpio direction
    QScopedPointer<QFile> sysGpioDirection;
    sysGpioDirection.reset(new QFile());
    sysGpioDirection->setFileName(m_gpioPath + "/direction");
    if(!sysGpioDirection->open(QIODevice::ReadWrite | QIODevice::Text)){
        //        qDebug() << "QGpioSysfs::setup Can not open sysfs file gpio direction " << sysGpioDirection->fileName();
        return;
    }
    QTextStream streamDirection(sysGpioDirection.data());
    streamDirection << (direction == 1 ? "out" : "in");
    streamDirection.flush();
    //    sysGpioDirection->close();

    //set default value to low
    m_pSysGpioValue.reset(new QFile());
    m_pSysGpioValue->setFileName(m_gpioPath + "/value");
    if(!m_pSysGpioValue->open(QIODevice::ReadWrite | QIODevice::Text)){
        //        qDebug() << "QGpioSysfs::setup Can not open sysfs file gpio value";
        return;
    }
    QTextStream streamValue(m_pSysGpioValue.data());
    streamValue << "0";
    streamValue.flush();
    //    sysGpioValue->close();

    //    qDebug() << "QGpioSysfs::setup Gpio sys setup finished of gpio " << pin;
}

void QGpioSysfs::setState(bool value)
{
#ifndef __arm__
    //    printf("QGpioSysfs::setValue", value);
    //    fflush(stdout);
    this->m_state = value;
    return;
#endif
    if(m_state == value) return;
    m_state = value;

    QTextStream stream(m_pSysGpioValue.data());
    stream.seek(0);
    stream << QString::number(value ? 1 : 0);
    stream.flush();
}

bool QGpioSysfs::getState() const
{
    return m_state;
}

int QGpioSysfs::getStateActual()
{
#ifndef __arm__
    //    printf("QGpioSysfs::getValue", value);
    //    fflush(stdout);
    return m_state;
#endif
    QTextStream stream(m_pSysGpioValue.data());
    stream.seek(0);
    QString valStr = stream.read(1);

    if(valStr == "1") m_state = 1;
    else m_state = 0;
    return m_state;
}
