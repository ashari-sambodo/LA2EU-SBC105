#include "ClassDriver.h"

ClassDriver::ClassDriver(QObject *parent) : QObject(parent)
{
    memset(m_registerDataBuffer, 0x00, 255);
    m_commStatus            = I2C_COMM_STATUS_NONE;
    pI2C                    = nullptr;
    m_address               = 0x00;
    m_errorComCount         = 0;
    m_errorComCountMax      = 2;
    m_idString              = "";
}

void ClassDriver::setI2C(I2CCom *pI2C)
{
    this->pI2C = pI2C;
}

void ClassDriver::setAddress(uchar addr)
{
    m_address = addr;
}

int ClassDriver::init()
{
    return 0;
}

int ClassDriver::polling()
{
    return 0;
}

int ClassDriver::testComm()
{
    return 0;
}

void ClassDriver::clearRegBuffer()
{

}

int ClassDriver::commStatus() const
{
    return m_commStatus;
}

void ClassDriver::setCommStatus(int value)
{
    m_commStatus = value;
}

int ClassDriver::errorComCount() const
{
    return m_errorComCount;
}

void ClassDriver::setErrorComCount(int val)
{
    if(val > m_errorComCountMax) return;
    else if(m_errorComCount == val) return;
    m_errorComCount = val;

    //    printf("ClassDriver::setErrorComCount %d\n", m_errorComCount);
    //    fflush(stdout);

    emit errorComCountChanged(m_errorComCount);
}

int ClassDriver::errorComCountMax() const
{
    return m_errorComCountMax;
}

void ClassDriver::setErrorComCountMax(int errorComCountMax)
{
    m_errorComCountMax = errorComCountMax;
}

uchar ClassDriver::address() const
{
    return m_address;
}
