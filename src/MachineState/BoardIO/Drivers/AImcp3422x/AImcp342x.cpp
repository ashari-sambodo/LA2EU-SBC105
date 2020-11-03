#include "AImcp342x.h"

#define MCP342X_AI_ADDRESS              0x69
#define MCP342X_AI_RESOLUTION           4096
#define MCP342X_AI_LSB_12bit            1        //mV  == 1000     uV
#define MCP342X_AI_LSB_14bit            0.25     //mV  == 250      uV
#define MCP342X_AI_LSB_16bit            0.0625   //mV  == 62.5     uV
#define MCP342X_AI_LSB_18bit            0.015625 //mV  == 15.625   uV
#define MCP342X_AI_INPUT_GAIN           0.2024
#define MCP342X_AI_INPUT_GAIN_V2        0.2537
#define MCP342X_AI_VREF                 5000     //mV  == 5 Volt
#define MCP342X_AI_I_R                  0.25     //mV  == actual 0,249 KOhm

using namespace std;

AImcp342x::AImcp342x(QObject *parent)
    : ClassDriver(parent)
{
    memset(m_registerDataBuffer, 0x00, 5);
    m_address               = MCP342X_AI_ADDRESS;

    config.bits.pga         = MCP342X_AI_GAIN_x1;

    config.bits.sps         = MCP342X_AI_SPS_14bits;
    lsb_value               = MCP342X_AI_LSB_14bit;

    config.bits.conv_mode   = MCP342X_AI_CONT_CONV;
    config.bits.channel     = MCP342X_AI_CH1;
    config.bits.r_flag      = MCP342X_AI_CONV_INIT;

}

int AImcp342x::testComm()
{
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_READ,
                         m_address,
                         0,
                         1,
                         0,
                         cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) < 0)
    {
#ifdef DEBUG_ME
        qDebug() << "AImcp342x::test_comm " << "Failed to communication DIOpca9674";
#endif
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }
    return I2CPort::I2C_COMM_RESPONSE_OK;
}

int AImcp342x::init()
{
    return sendConfig();
}

void AImcp342x::setConfigChannel(uchar channel)
{
    config.bits.channel =  channel;
}

void AImcp342x::setConfigSPS(char sps)
{
    config.bits.sps = sps;

    switch (sps) {
    case MCP342X_AI_SPS_12bits:
        lsb_value = MCP342X_AI_LSB_12bit;
        break;
    case MCP342X_AI_SPS_14bits:
        lsb_value = MCP342X_AI_LSB_14bit;
        break;
    case MCP342X_AI_SPS_16bits:
        lsb_value = MCP342X_AI_LSB_16bit;
        break;
    case MCP342X_AI_SPS_18bits:
        lsb_value = MCP342X_AI_LSB_18bit;
        break;
    default:
        break;
    }
}

int AImcp342x::sendConfig()
{
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_WRITE,
                         m_address, //m_address
                         0, //without offset
                         1, //total of data
                         0, //offset
                         cmd);
    cmd.push_back(config.byte);
    //call i2c object and pass command frame
    if(pI2C->writeData(cmd) != I2CPort::I2C_COMM_RESPONSE_OK)
    {
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }
    return I2CPort::I2C_COMM_RESPONSE_OK;
}

int AImcp342x::getValue(int *adc, int channel, int *mVolt, double *mA)
{
    //send recent analog config
    sendConfig();
    //Then read conversion result
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_READ,
                         m_address,
                         0,
                         3,
                         0,
                         cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CPort::I2C_COMM_RESPONSE_OK)
    {
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }

    convertionUpdated   = 1;
    m_registerDataBuffer[2]    = receive[2];

    int channel_receive = (receive[2] & 0b01100000) >> 5;
    bool channelValid   = channel == channel_receive;

    //    printf("Channel validation %d %d is %s\n", channel, channel_receive, channelValid ? "true" : "false");
    //    fflush(stdout);

    if(channelValid) {
        convertionUpdated   = receive[2] >> 7;
        // convertion success flag: 0=convertion adc complete or 1=not complete
        if(convertionUpdated == 0){

            //            printf("Channel ADC %d is complete \n", channel);
            //            fflush(stdout);

            int value = (receive[0] << 8) | receive[1];
            *adc = value;
            if(mVolt) *mVolt = convertADCtomVolt(value);
            if(mA) *mA = convertADCtomA(value);
        }
    }
    return I2CPort::I2C_COMM_RESPONSE_OK;
}

int AImcp342x::convertADCtomVolt(int adc)
{
    if(!adc) return adc;

    double result = (double) adc;
    result *= (double) lsb_value;
    result /= MCP342X_AI_INPUT_GAIN;
    return qRound(result);

    //    return qRound(((float)adc * lsb_value)/(PGA[config.bits.pga] * MCP342X_AI_INPUT_GAIN));
}

double AImcp342x::convertADCtomA(int adc)
{
    if(!adc) return adc;

    double result = (double) adc;
    result *= (double) lsb_value;
    result /= MCP342X_AI_INPUT_GAIN;
    result /= 1000.0;
    result /= MCP342X_AI_I_R;
    result = qRound(result * 1000.0) / 1000.0;
    return result;

    //    return ((((float)adc * lsb_value)/(PGA[config.bits.pga] * MCP342X_AI_INPUT_GAIN)) / 1000.0) / MCP342X_AI_I_R;
}

bool AImcp342x::isConversionUpdated()
{
    return convertionUpdated == 0;
}

void AImcp342x::_debugPrintRegister(int index)
{
    printf("AImcp342x::_debugPrintRegister register index: %d value: %x ", index, m_registerDataBuffer[index]);
    fflush(stdout);
}

void AImcp342x::clearRegBuffer()
{
    memset(m_registerDataBuffer, 0, sizeof(m_registerDataBuffer));
}
