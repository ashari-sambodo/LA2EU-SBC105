#ifndef QGPIOSYSFS_H
#define QGPIOSYSFS_H

#include <QScopedPointer>
#include <QString>
class QFile;

class QGpioSysfs
{
public:
    QGpioSysfs();
    ~QGpioSysfs();

    void setup(int pin, int m_direction = 1);
    void setState(bool m_state);
    bool getState() const;
    int getStateActual();

private:
    QScopedPointer<QFile> m_pSysGpioValue;
    QString m_gpioPath;

    short m_gpioPin;
    short m_direction;
    bool  m_state;
};

#endif // QGPIOSYSFS_H
