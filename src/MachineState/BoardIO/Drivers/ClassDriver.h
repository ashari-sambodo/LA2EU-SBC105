#pragma once

#include <QObject>
#include "i2c/I2CCom.h"

class ClassDriver : public QObject
{
    Q_OBJECT
public:
    explicit ClassDriver(QObject *parent = nullptr);
    virtual void    setI2C(I2CCom *pI2C);
    virtual void    setAddress(uchar addr);
    virtual int     init();
    virtual int     polling();
    virtual int     testComm();
    virtual void    clearRegBuffer();

    int commStatus() const;
    void setCommStatus(int value);

    enum EnumCommunicationStatus{
        I2C_COMM_STATUS_NONE,
        I2C_COMM_OK,
        I2C_COMM_ERROR
    };

    int errorComCount() const;
    void setErrorComCount(int val);

    int errorComCountMax() const;
    void setErrorComCountMax(int errorComCountMax);

    uchar address() const;

protected:
    I2CCom*         pI2C;
    uchar           m_address;
    int             m_commStatus;
    unsigned char   m_registerDataBuffer[255];

    int            m_errorComCount;
    int            m_errorComCountMax;

    QString         m_idString;

signals:
    void errorComCountChanged(int count);

public slots:
};
