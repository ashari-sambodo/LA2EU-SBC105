#pragma once

#include <QObject>
#include "i2c/I2CPort.h"

class ClassDriver : public QObject
{
    Q_OBJECT
public:
    explicit ClassDriver(QObject *parent = nullptr);
    virtual void    setI2C(I2CPort *pI2C);
    virtual void    setAddress(uchar addr);
    virtual int     init();
    virtual int     polling();
    virtual int     testComm();
    virtual void    clearRegBuffer();

    int commStatusActual() const;
    void setCommStatusActual(short value);

    enum EnumCommunicationStatus{
        I2C_COMM_STATUS_NONE,
        I2C_COMM_OK,
        I2C_COMM_ERROR
    };

    void increaseErrorComToleranceCount();
    void clearErrorComToleranceCount();

    int errorComToleranceCount() const;
    void setErrorComToleranceCount(short val);
    bool isErrorComToleranceReached() const;

    int errorComToleranceCountMax() const;
    void setErrorComToleranceCountMax(short errorComToleranceCountMax);

    uchar address() const;

protected:
    I2CPort*        pI2C;
    uchar           m_address;
    int             m_commStatusActual;
    unsigned char   m_registerDataBuffer[255];

    short           m_errorComToleranceCount;
    short           m_errorComToleranceCountMax;

    QString         m_idString;

signals:
    void errorComToleranceCountChanged(short count);
    void errorComToleranceReached(short count);

public slots:
};
