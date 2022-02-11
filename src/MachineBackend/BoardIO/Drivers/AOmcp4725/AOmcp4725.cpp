#include "AOmcp4725.h"

#define MCP4725_AO_ADDRESS                      0x60
#define MCP4725_AO_VREF                         5000 // miliVolt
#define MCP4725_AO_RESOLUTION                   4096
#define MCP4725_AO_FAST_MODE                    0x00
#define MCP4725_AO_LOAD_EEPROM_TO_DAC_REG       0x20
#define MCP4725_AO_WRITE_DAC_EEPROM             0x60

using namespace std;

AOmcp4725::AOmcp4725(QObject *parent)
    : ClassDriver(parent)
{
    memset(m_registerDataBuffer, 0x00, 5);
    m_address = MCP4725_AO_ADDRESS;
}

int AOmcp4725::testComm()
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
    if(pI2C->readData(cmd, receive) != I2CPort::I2C_COMM_RESPONSE_OK)
    {
        //#ifdef DEBUG_ME
        //        qDebug() << "AOmcp4725::test_comm " << "Failed to communication AOmcp4725";
        //#endif
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }
    return I2CPort::I2C_COMM_RESPONSE_OK;
}

/**
 * @brief AOmcp4725::init
 * @return
 * Notice: This init use write to eeprom and dac, after this this function
 * need at least 50ms delay (from my trial) before you can use write fast mode.
 */
int AOmcp4725::init()
{
    //#ifdef DEBUG_ME
    //    qDebug() << "AOmcp4725::init ";
    //#endif
    //make sure eeprom clear
    int response = 0;
    response = setVoltDACRegEEPROM(0);
    response = setVoltDAC(0);
    return response;
}

int AOmcp4725::polling()
{
    return updateRegBuffer();
}

//int AOmcp4725::setFastMode(float volt)
//{
//    //generate input code
//    int input_code;
//    voltToInputcode(volt, &input_code);

//    //split to byte
//    unsigned char mode          = 0x00; // fast mode
//    unsigned char second_byte   = input_code & 0x00ff;
//    unsigned char first_byte    = (mode | (input_code & 0xff00)) >> 8;

//    vector<unsigned char> cmd;
//    pI2C->generate_frame(I2cCom::I2C_CMD_OPERATION_WRITE,
//                          m_address,  //m_address
//                          0,        //without offset
//                          2,        //total of data
//                          0,        //offset
//                          cmd);
//    cmd.push_back(first_byte);
//    cmd.push_back(second_byte);
//    //call i2c object and pass command frame
//    if(pI2C->write_data(cmd) < 0)
//    {
//#ifdef DEBUG_ME
//        qDebug() << "AOmcp4725::write_fast_mode " << "Failed to fast mode AOmcp4725";
//#endif
//        return -1;
//    }
//    return 0;
//}

int AOmcp4725::setVoltDAC(int mvolt, bool toBuffer)
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    //generate input code
    int inputCode;
    voltToInputcode(mvolt, &inputCode);
    //    qDebug() << "AOmcp4725::setVoltDAC inputCode: " << inputCode;

    //split to byte and combine with configuration bit
    unsigned char second_byte   = (MCP4725_AO_FAST_MODE << 4) | (inputCode >> 8);
    unsigned char third_byte    = inputCode & 0xff;
    //    qDebug() << "AOmcp4725::setVoltDAC inputCode byte: " << second_byte << "-" << third_byte;

    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_WRITE,
                        m_address,  //m_address
                        0,        //without offset
                        2,        //total of data
                        0,        //offset
                        cmd);
    cmd.push_back(second_byte);
    cmd.push_back(third_byte);
    //call i2c object and pass command frame
    if(toBuffer){
        pI2C->addOutQueue(cmd);
    }
    else{
        if(pI2C->writeData(cmd) != I2CPort::I2C_COMM_RESPONSE_OK)
        {
            //#ifdef DEBUG_ME
            //            qDebug() << "AOmcp4725::setDAC " << "Failed to fast mode AOmcp4725";
            //#endif
            return I2CPort::I2C_COMM_RESPONSE_ERROR;
        }
    }
    return I2CPort::I2C_COMM_RESPONSE_OK;
}

int AOmcp4725::setVoltDACRegEEPROM(int mvolt, bool toBuffer)
{
    //generate input code
    int inputCode;
    voltToInputcode(mvolt, &inputCode);
    //#ifdef DEBUG_ME
    //    qDebug() << "AOmcp4725::setVoltDACRegEEPROM " << inputCode;
    //#endif
    //split to byte
    unsigned char second_byte   = (inputCode & 0xff0) >> 4;
    unsigned char third_byte    = (inputCode & 0xf) << 4;
    //    printf("AOmcp4725::setVoltDACRegEEPROM value: %x %x\n", second_byte, third_byte);
    //    fflush(stdout);

    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_WRITE,
                        m_address,  //m_address
                        0,        //without offset
                        3,        //total of data
                        0,        //offset
                        cmd);
    cmd.push_back(MCP4725_AO_WRITE_DAC_EEPROM);
    cmd.push_back(second_byte);
    cmd.push_back(third_byte);
    //call i2c object and pass command frame
    if(toBuffer){
        pI2C->addOutQueue(cmd);
    }
    else{
        if(pI2C->writeData(cmd) != I2CPort::I2C_COMM_RESPONSE_OK)
        {
            //#ifdef DEBUG_ME
            //            qDebug() << "AOmcp4725::write_fast_mode " << "Failed to fast mode AOmcp4725";
            //#endif
            return I2CPort::I2C_COMM_RESPONSE_ERROR;
        }
    }

    return I2CPort::I2C_COMM_RESPONSE_OK;
}

int AOmcp4725::setDAC(int inputCode, bool toBuffer)
{
    //split to byte and combine with configuration bit
    unsigned char second_byte   = (MCP4725_AO_FAST_MODE << 4) | (inputCode >> 8);
    unsigned char third_byte    = inputCode & 0xff;

    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_WRITE,
                        m_address,  //m_address
                        0,        //without offset
                        2,        //total of data
                        0,        //offset
                        cmd);
    cmd.push_back(second_byte);
    cmd.push_back(third_byte);
    //call i2c object and pass command frame
    if(toBuffer){
        pI2C->addOutQueue(cmd);
    }
    else {
        if(pI2C->writeData(cmd) != I2CPort::I2C_COMM_RESPONSE_OK) {
#ifdef DEBUG_ME
            qDebug() << "AOmcp4725::setDAC " << "Failed to fast mode AOmcp4725";
#endif
            return I2CPort::I2C_COMM_RESPONSE_ERROR;
        }
    }
    return I2CPort::I2C_COMM_RESPONSE_OK;
}

int AOmcp4725::setDACRegEEPROM(int inputCode, bool toBuffer)
{
    //split to byte
    unsigned char second_byte   = (inputCode & 0xff0) >> 4;
    unsigned char third_byte    = (inputCode & 0xf) << 4;

    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_WRITE,
                        m_address,  //m_address
                        0,        //without offset
                        3,        //total of data
                        0,        //offset
                        cmd);
    cmd.push_back(MCP4725_AO_WRITE_DAC_EEPROM);
    cmd.push_back(second_byte);
    cmd.push_back(third_byte);
    //call i2c object and pass command frame
    if(toBuffer){
        pI2C->addOutQueue(cmd);
    }
    else{
        if(pI2C->writeData(cmd) != I2CPort::I2C_COMM_RESPONSE_OK){
            //#ifdef DEBUG_ME
            //            qDebug() << "AOmcp4725::write_fast_mode " << "Failed to fast mode AOmcp4725";
            //#endif
            return I2CPort::I2C_COMM_RESPONSE_ERROR;
        }
    }

    //    printf("AOmcp4725::setDACRegEEPROM cmd\n");
    //    fflush(stdout);
    //    for(int i=0; i<3; i++){
    //        printf("index: %d value: %x\n", i, cmd[i]);
    //        fflush(stdout);
    //    }

    return I2CPort::I2C_COMM_RESPONSE_OK;
}

int AOmcp4725::getDAC(int *result_adc, int *result_mvolt)
{
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
        //#ifdef DEBUG_ME
        //        qDebug() << "AOmcp4725::update_reg_buffer " << "Failed to get update buffer AOmcp4725";
        //#endif
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }

    //marge byte to word to see original value
    int inputcode = (receive[1] << 4) | (receive[2] >> 4);
    *result_adc = inputcode;
    //convert to voltage
    if(result_mvolt) inputcodeToMiliVolt(inputcode, result_mvolt);
    return I2CPort::I2C_COMM_RESPONSE_OK;
}

int AOmcp4725::getDACRegEEPROM(int *result_adc, int *result_mvolt)
{
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_READ,
                        m_address,
                        0,
                        5,
                        0,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CPort::I2C_COMM_RESPONSE_OK)
    {
        //#ifdef DEBUG_ME
        //        qDebug() << "AOmcp4725::update_reg_buffer " << "Failed to get update buffer AOmcp4725";
        //#endif
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }

    //marge byte to word to see original value
    int inputcode = ((receive[3] & 0x0f) << 8) | receive[4];
    *result_adc = inputcode;
    //convert to voltage
    if(result_mvolt) inputcodeToMiliVolt(inputcode, result_mvolt);
    return I2CPort::I2C_COMM_RESPONSE_OK;
}

int AOmcp4725::updateRegBuffer()
{
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_READ,
                        m_address,
                        0,
                        5,
                        0,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CPort::I2C_COMM_RESPONSE_OK)
    {
        //#ifdef DEBUG_ME
        //        qDebug() << "AOmcp4725::update_reg_buffer " << "Failed to get update buffer AOmcp4725";
        //#endif
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }

    //    printf("AOmcp4725::updateRegBuffer receive\n");
    //    fflush(stdout);
    //    for(int i=0; i<5; i++){
    //        printf("index: %d value: %x\n", i, receive[i]);
    //        fflush(stdout);
    //    }

    //update register buffer
    copy(receive.begin(), receive.end(), m_registerDataBuffer);
    return I2CPort::I2C_COMM_RESPONSE_OK;
}

void AOmcp4725::getRegBufferDAC(int *dac, int *mvolt)
{
    //marge byte to word to see original value
    *dac = (m_registerDataBuffer[1] << 4) | (m_registerDataBuffer[2] >> 4);

    if(mvolt == nullptr) return;

    //convert to voltage
    inputcodeToMiliVolt(*dac, mvolt);
}

void AOmcp4725::getRegBufferDACRegEEPROM(int *dac, int *mvolt)
{
    //marge byte to word to see original value
    *dac = ((m_registerDataBuffer[3] & 0x0f) << 4) | m_registerDataBuffer[4];

    if(mvolt == nullptr) return;

    //convert to voltage
    inputcodeToMiliVolt(*dac, mvolt);
}

void AOmcp4725::clearRegBuffer()
{
    memset(m_registerDataBuffer, 0, 5);
}

void AOmcp4725::_debugPrintRawDAC()
{
    printf("AOmcp4725::_debugPrintRawDAC register\n");
    fflush(stdout);
    for(int i=0; i<5; i++){
        printf("index: %d value: %x\n", i, m_registerDataBuffer[i]);
        fflush(stdout);
    }
}

void AOmcp4725::voltToInputcode(int value, int *result)
{
    *result = qRound((float)((MCP4725_AO_RESOLUTION - 1 ) * value) / (float) MCP4725_AO_VREF);
    if(*result > 4095) *result = 4095;
    else if(*result < 0) *result = 0;
}

void AOmcp4725::inputcodeToMiliVolt(int inputcode, int *result)
{
    if(inputcode > (MCP4725_AO_RESOLUTION - 1 )) inputcode = (MCP4725_AO_RESOLUTION - 1 );
    else if(inputcode < 0) inputcode = 0;

    *result = qRound(((float)(inputcode * MCP4725_AO_VREF)) / (float)(MCP4725_AO_RESOLUTION - 1 ));
}
