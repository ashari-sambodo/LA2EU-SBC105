#include "ClassDriver.h"

ClassDriver::ClassDriver(QObject *parent) : QObject(parent)
{
    memset(m_registerDataBuffer, 0x00, 256);
    m_commStatusActual            = I2C_COMM_STATUS_NONE;
    pI2C                    = nullptr;
    m_address               = 0x00;
    m_errorComToleranceCount         = 0;
    m_errorComToleranceCountMax      = 20;
    m_idString              = "";
}

void ClassDriver::setI2C(I2CPort *pI2C)
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

int ClassDriver::commStatusActual() const
{
    return m_commStatusActual;
}

void ClassDriver::setCommStatusActual(short value)
{
    m_commStatusActual = value;
}

void ClassDriver::increaseErrorComToleranceCount(short id)
{
    if (m_errorComToleranceCount >= m_errorComToleranceCountMax) return;

    short count = m_errorComToleranceCount;
    count++;
    setErrorComToleranceCount(count, id);
}

void ClassDriver::clearErrorComToleranceCount()
{
    if(m_errorComToleranceCount > 0){
        short lastCount = m_errorComToleranceCount;
        m_errorComToleranceCount = 0;
        emit errorComToleranceCleared(lastCount);
    }
}

int ClassDriver::errorComToleranceCount() const
{
    return m_errorComToleranceCount;
}

void ClassDriver::setErrorComToleranceCount(short val, short /*id*/)
{
    if(m_errorComToleranceCount == val) return;

    m_errorComToleranceCount = val;

    //    printf("ClassDriver::setErrorComCount %d: %d\n", id, m_errorComToleranceCount);
    //    fflush(stdout);

    emit errorComToleranceCountChanged(m_errorComToleranceCount);

    if (m_errorComToleranceCount == m_errorComToleranceCountMax) {
        emit errorComToleranceReached(m_errorComToleranceCount);
    }
}

bool ClassDriver::isErrorComToleranceReached() const
{
    return m_errorComToleranceCount >= m_errorComToleranceCountMax;
}

int ClassDriver::errorComToleranceCountMax() const
{
    return m_errorComToleranceCountMax;
}

void ClassDriver::setErrorComToleranceCountMax(short errorComCountMax)
{
    m_errorComToleranceCountMax = errorComCountMax;
}

uchar ClassDriver::address() const
{
    return m_address;
}
