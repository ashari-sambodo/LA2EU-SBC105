#include "DIOpca9674.h"

#define PCA9674_DIO_ADDRESS              0x20
#define PCA9674_DIO_AS_INPUT             0xff
#define PCA9674_DIO_AS_OUTPUT            0x00

using namespace std;

DIOpca9674::DIOpca9674(QObject *parent)
    : ClassDriver(parent)
{
    memset(m_registerDataBuffer, 0x00, 2);
    m_address = PCA9674_DIO_ADDRESS;
    direction = DIOpca9674_DIRECTION::DIOpca9674_DIRECTION_INPUT;
}

void DIOpca9674::setAsIO(unsigned char inputOutput)
{
    direction = inputOutput;
    //    register_data[DIOpca9674_REG::IO_DIRECTION] = input_output;
}

int DIOpca9674::testComm()
{
#ifdef DEBUG_ME
    qDebug() << "DIOpca9674::test_comm " << "called";
#endif
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_READ,
                        m_address,
                        0,
                        1,
                        0,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CCom::I2C_COMM_RESPONSE_OK)
    {
#ifdef DEBUG_ME
        qDebug() << "DIOpca9674::test_comm " << "Failed to communication DIOpca9674";
#endif
        return I2CCom::I2C_COMM_RESPONSE_ERROR;
    }
    return I2CCom::I2C_COMM_RESPONSE_OK;
}

int DIOpca9674::init()
{
    //    qDebug() << "DIOpca9674::init";
    //    //reset device
    vector<unsigned char> cmd;
    //set io as input/output
    //    cmd.clear();
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_WRITE,
                        m_address, //address
                        0, //without offset
                        1, //total of data
                        0, //offset
                        cmd);
    if(direction == DIOpca9674_DIRECTION_OUTPUT) cmd.push_back(0);    //input
    else cmd.push_back(255);                                           //output

    //call i2c object and pass command frame
    if(pI2C->writeData(cmd) != I2CCom::I2C_COMM_RESPONSE_OK)
    {
        //        qDebug() << "DIOpca9674::init " << "Failed to set io PWMpca9685";
        return I2CCom::I2C_COMM_RESPONSE_ERROR;
    }
    return I2CCom::I2C_COMM_RESPONSE_OK;
}

int DIOpca9674::polling()
{
    return updateRegBuffer();
}

int DIOpca9674::getStateIO(int channel, unsigned char *result)
{
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_READ,
                        m_address,
                        0,
                        1,
                        0,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CCom::I2C_COMM_RESPONSE_OK)
    {
#ifdef DEBUG_ME
        qDebug() << "DIOpca9674::get_io_state " << "Failed to io state DIOpca9674";
#endif
        return I2CCom::I2C_COMM_RESPONSE_ERROR;
    }

    m_registerDataBuffer[DIOpca9674_REG::IO_VALUE] = receive[0];
    *result = (~m_registerDataBuffer[DIOpca9674_REG::IO_VALUE] & (0x01 << channel)) >> channel;
    return I2CCom::I2C_COMM_RESPONSE_OK;
}

int DIOpca9674::updateRegBuffer(void)
{
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_READ,
                        m_address,
                        0,
                        1,
                        0,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CCom::I2C_COMM_RESPONSE_OK)
    {
#ifdef DEBUG_ME
        qDebug() << "DIOpca9674::update_reg_buffer " << "Failed to get update buffer DIOpca9674";
#endif
        return I2CCom::I2C_COMM_RESPONSE_ERROR;
    }

    m_registerDataBuffer[DIOpca9674_REG::IO_VALUE] = receive[0];
    return I2CCom::I2C_COMM_RESPONSE_OK;

}

int DIOpca9674::getRegBufferStateIO(int channel)
{
    return (~m_registerDataBuffer[DIOpca9674_REG::IO_VALUE] & (0x01 << channel)) >> channel;
}

void DIOpca9674::clearRegBuffer()
{
    memset(m_registerDataBuffer, 0, 5);
}
