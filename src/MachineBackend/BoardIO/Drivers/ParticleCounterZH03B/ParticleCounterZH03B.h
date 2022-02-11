/***
 * Author: Heri Cahyono
 * July 2021
 *
 * ref: https://github.com/Theoi-Meteoroi/Winsen_ZH03B/blob/master/Python3/ZH03B_lib.py
 **/

#pragma once

#include <QDebug>
#include "../ClassDriver.h"
#include <QtSerialPort/QSerialPort>

class ParticleCounterZH03B : public ClassDriver
{
    Q_OBJECT
public:
    explicit ParticleCounterZH03B(QObject *parent = nullptr);

    void setSerialComm(QSerialPort * serial);

    int setCommunicationMode(int mode);
    int setQA();
    int setStream();
    int setDormantMode(int powerStatus);

    int getQAReadSample(int *pm1, int *pm2_5, int *pm10);
    int getReadSample(int *pm1, int *pm2_5, int *pm10);

    bool getFanStateBuffer() const;

private:
    QSerialPort * serialComm; //forwardPointer

    bool m_dormanModeSleepRunBuffer = true; /// by default the sensor will be automaticly running when turned on
    int m_comunicationMode = 0; /// 0 = stream mode, 1 = Q&A Mode
};

