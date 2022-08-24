#include "PWMpca9685.h"

using namespace std;

enum PCA9685_PWM_REG{
    PCA9685_PWM_REG_MODE1,
    PCA9685_PWM_REG_MODE2,
    PCA9685_PWM_REG_SUBADR1,
    PCA9685_PWM_REG_SUBADR2,
    PCA9685_PWM_REG_SUBADR3,
    PCA9685_PWM_REG_ALLCALLADR,
    PCA9685_PWM_REG_LED0_ON_L,
    PCA9685_PWM_REG_LED0_ON_H,
    PCA9685_PWM_REG_LED0_OFF_L,
    PCA9685_PWM_REG_LED0_OFF_H,
    PCA9685_PWM_REG_LED1_ON_L,
    PCA9685_PWM_REG_LED1_ON_H,
    PCA9685_PWM_REG_LED1_OFF_L,
    PCA9685_PWM_REG_LED1_OFF_H,
    PCA9685_PWM_REG_LED2_ON_L,
    PCA9685_PWM_REG_LED2_ON_H,
    PCA9685_PWM_REG_LED2_OFF_L,
    PCA9685_PWM_REG_LED2_OFF_H,
    PCA9685_PWM_REG_LED3_ON_L,
    PCA9685_PWM_REG_LED3_ON_H,
    PCA9685_PWM_REG_LED3_OFF_L,
    PCA9685_PWM_REG_LED3_OFF_H,
    PCA9685_PWM_REG_LED4_ON_L,
    PCA9685_PWM_REG_LED4_ON_H,
    PCA9685_PWM_REG_LED4_OFF_L,
    PCA9685_PWM_REG_LED4_OFF_H,
    PCA9685_PWM_REG_LED5_ON_L,
    PCA9685_PWM_REG_LED5_ON_H,
    PCA9685_PWM_REG_LED5_OFF_L,
    PCA9685_PWM_REG_LED5_OFF_H,
    PCA9685_PWM_REG_LED6_ON_L,
    PCA9685_PWM_REG_LED6_ON_H,
    PCA9685_PWM_REG_LED6_OFF_L,
    PCA9685_PWM_REG_LED6_OFF_H,
    PCA9685_PWM_REG_LED7_ON_L,
    PCA9685_PWM_REG_LED7_ON_H,
    PCA9685_PWM_REG_LED7_OFF_L,
    PCA9685_PWM_REG_LED7_OFF_H,
    PCA9685_PWM_REG_LED8_ON_L,
    PCA9685_PWM_REG_LED8_ON_H,
    PCA9685_PWM_REG_LED8_OFF_L,
    PCA9685_PWM_REG_LED8_OFF_H,
    PCA9685_PWM_REG_LED9_ON_L,
    PCA9685_PWM_REG_LED9_ON_H,
    PCA9685_PWM_REG_LED9_OFF_L,
    PCA9685_PWM_REG_LED9_OFF_H,
    PCA9685_PWM_REG_LED10_ON_L,
    PCA9685_PWM_REG_LED10_ON_H,
    PCA9685_PWM_REG_LED10_OFF_L,
    PCA9685_PWM_REG_LED10_OFF_H,
    PCA9685_PWM_REG_LED11_ON_L,
    PCA9685_PWM_REG_LED11_ON_H,
    PCA9685_PWM_REG_LED11_OFF_L,
    PCA9685_PWM_REG_LED11_OFF_H,
    PCA9685_PWM_REG_LED12_ON_L,
    PCA9685_PWM_REG_LED12_ON_H,
    PCA9685_PWM_REG_LED12_OFF_L,
    PCA9685_PWM_REG_LED12_OFF_H,
    PCA9685_PWM_REG_LED13_ON_L,
    PCA9685_PWM_REG_LED13_ON_H,
    PCA9685_PWM_REG_LED13_OFF_L,
    PCA9685_PWM_REG_LED13_OFF_H,
    PCA9685_PWM_REG_LED14_ON_L,
    PCA9685_PWM_REG_LED14_ON_H,
    PCA9685_PWM_REG_LED14_OFF_L,
    PCA9685_PWM_REG_LED14_OFF_H,
    PCA9685_PWM_REG_LED15_ON_L,
    PCA9685_PWM_REG_LED15_ON_H,
    PCA9685_PWM_REG_LED15_OFF_L,
    PCA9685_PWM_REG_LED15_OFF_H,
    PCA9685_PWM_REG_ALL_LED_ON_L = 250,
    PCA9685_PWM_REG_ALL_LED_ON_H,
    PCA9685_PWM_REG_ALL_LED_OFF_L,
    PCA9685_PWM_REG_ALL_LED_OFF_H,
    PCA9685_PWM_REG_PRE_SCALE,
    PCA9685_PWM_REG_TEST_MODE
};

/**
 * @brief PWMpca9685::PWMpca9685
 * @param parent is object where this object created
 * set memory of register_data to 0x00
 * set default i2c m_address PCA9685 to 0x40
 * set default oscilator based on internal oscilator, value is  25.000.000 Hz
 */
PWMpca9685::PWMpca9685(QObject *parent)
    : ClassDriver(parent)
{
    memset(m_registerDataBuffer, 0x00, 256);
    m_address           = PCA9685_PWM_ADDRESS;
    m_oscillatorValue   = PCA9685_PWM_VAL_IN_OSCILATOR;
    m_oscilatorType     = TYPE_OSC_INTERNAL;
    m_frequencyPreInit  = PCA9685_PWM_VAL_FREQ_100HZ;
}

void PWMpca9685::preInitOscilatorType(int oscilator)
{
    switch (oscilator) {
    case TYPE_OSC_INTERNAL:
        m_oscillatorValue = PCA9685_PWM_VAL_EX_OSCILATOR;
        m_oscilatorType = OSC_TYPE_EXTENAL;
        break;
    default:
        m_oscillatorValue = PCA9685_PWM_VAL_IN_OSCILATOR;
        m_oscilatorType = TYPE_OSC_INTERNAL;
        break;
    }
}

/**
 * @brief PWMpca9685::test_comm
 * @return will -1 if communication i2c have problem
 * This function will create i2c frame message to read one byte on ic register, then
 * passing to i2c object, then
 * i2c object call kernel to delivery the message
 */
int PWMpca9685::testComm()
{
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        1,
                        PCA9685_PWM_REG::PCA9685_PWM_REG_MODE1,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CPort::I2C_COMM_RESPONSE_OK)
    {
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }
    return I2CPort::I2C_COMM_RESPONSE_OK;
}

int PWMpca9685::polling()
{
    return updateRegBuffer(m_countChannelsToPool);
}

void PWMpca9685::initState(short numberOfChannel)
{
    for(short i=0; i< numberOfChannel; i++)
        setPWM(i, PCA9685_PWM_VAL_FULL_DCY_OFF, ClassDriver::I2C_OUT_BUFFER);
}

/**
 * @brief PWMpca9685::init
 * @return will -1 if communication i2c have problem
 * This method set frequency PCA9685 to frequency 100Hz (Default 200Hz), then
 * make sure all output initial state is off
 */
int PWMpca9685::init()
{
    //    //set frequency
    //    setFrequency(m_frequencyPreInit);
    //    //set off all pwm value
    //    return setAllPWM(0);
    return setFrequency(m_frequencyPreInit);
}

/**
 * @brief PWMpca9685::set_frequency
 * @param frequency is new frequency want to apply, Lowest freq is 23.84Hz, highest is 1525.88Hz.
 * @return will -1 if communication i2c have problem
 */
int PWMpca9685::setFrequency(float frequency)
{ 
    //make device going to sleep
    //frequency only can set when sleep condition
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_WRITE,
                        m_address,
                        1,
                        1,
                        PCA9685_PWM_REG::PCA9685_PWM_REG_MODE1,
                        cmd);
    cmd.push_back(PCA9685_PWM_BIT_SLEEP);
    //call i2c object and pass command frame
    if(pI2C->writeData(cmd) != I2CPort::I2C_COMM_RESPONSE_OK)
    {
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }

    if(m_oscilatorType == OscType::OSC_TYPE_EXTENAL){
        vector<unsigned char> cmd;
        pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_WRITE,
                            m_address,
                            1,
                            1,
                            PCA9685_PWM_REG::PCA9685_PWM_REG_MODE1,
                            cmd);
        cmd.push_back(PCA9685_PWM_BIT_EX_OSCILATOR);
        //call i2c object and pass command frame
        if(pI2C->writeData(cmd) != I2CPort::I2C_COMM_RESPONSE_OK)
        {
            return I2CPort::I2C_COMM_RESPONSE_ERROR;
        }
    }

    // This equation comes from section 7.3.5 of the datasheet, but the rounding has been 122880
    // removed because it isn't needed. Lowest freq is 23.84, highest is 1525.88.
    int pre_scaler = (m_oscillatorValue / (4096 * frequency)) - 1;
    if(pre_scaler > 255) pre_scaler = 255;
    if(pre_scaler < 3) pre_scaler = 3;

    //frequency only can set when sleep condition
    cmd.clear();
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_WRITE,
                        m_address,
                        1,
                        1,
                        PCA9685_PWM_REG::PCA9685_PWM_REG_PRE_SCALE,
                        cmd);
    cmd.push_back(pre_scaler);
    //call i2c object and pass command frame
    if(pI2C->writeData(cmd) != I2CPort::I2C_COMM_RESPONSE_OK)
    {
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }

    //Re-enable auto increment i2c register
    cmd.clear();
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_WRITE,
                        m_address,
                        1,
                        1,
                        PCA9685_PWM_REG::PCA9685_PWM_REG_MODE1,
                        cmd);
    cmd.push_back(PCA9685_PWM_BIT_RESTART | PCA9685_PWM_BIT_AUTOINC);
    //call i2c object and pass command frame
    if(pI2C->writeData(cmd) != I2CPort::I2C_COMM_RESPONSE_OK)
    {
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }
    //required oscilator startup delay when used internal oscilator, at least 500us
    if (m_oscillatorValue == PCA9685_PWM_VAL_IN_OSCILATOR) usleep(550);
    return I2CPort::I2C_COMM_RESPONSE_OK;
}

/**
 * @brief PWMpca9685::set_pwm
 * @param channel is channel number of output PCA9685, 0 to 15
 * @param duty_cycle is new value want to apply between 0% to 100%
 * @return will -1 if communication i2c have problem
 */
int PWMpca9685::setPWM(int channel, int duty_cycle, bool toBuffer)
{
    unsigned char dcy[4] = {0, 0, 0, 0};
    decToPWMRegFormat(duty_cycle, dcy);

    unsigned char start_reg = getStartAddress(channel);

    //do set pwm
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_WRITE,
                        m_address,
                        1,
                        4,
                        start_reg,
                        cmd);
    cmd.push_back(dcy[0]);
    cmd.push_back(dcy[1]);
    cmd.push_back(dcy[2]);
    cmd.push_back(dcy[3]);
    //call i2c object and pass command frame
    if(toBuffer){
        pI2C->addOutQueue(cmd);
    }else{
        if(pI2C->writeData(cmd) != I2CPort::I2C_COMM_RESPONSE_OK)
        {
            return I2CPort::I2C_COMM_RESPONSE_ERROR;
        }
    }
    return I2CPort::I2C_COMM_RESPONSE_OK;
}

/**
 * @brief PWMpca9685::set_pwm_all
 * @param duty_cycle
 * @return
 */
int PWMpca9685::setAllPWM(int duty_cycle, bool toBuffer)
{
    unsigned char dcy[4] = {0, 0, 0, 0};
    decToPWMRegFormat(duty_cycle, dcy);

    //do set pwm
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_WRITE,
                        m_address,
                        1,
                        4,
                        PCA9685_PWM_REG_ALL_LED_ON_L,
                        cmd);
    cmd.push_back(dcy[0]);
    cmd.push_back(dcy[1]);
    cmd.push_back(dcy[2]);
    cmd.push_back(dcy[3]);
    //call i2c object and pass command frame
    if(toBuffer){
        pI2C->addOutQueue(cmd);
    }else{
        if(pI2C->writeData(cmd) != I2CPort::I2C_COMM_RESPONSE_OK)
        {
            return I2CPort::I2C_COMM_RESPONSE_ERROR;
        }
    }
    return I2CPort::I2C_COMM_RESPONSE_OK;
}

/**
 * @brief PWMpca9685::get_live
 * @param result indication of oscilator is running, not sleep
 * @return will -1 if communication i2c have problem
 */
int PWMpca9685::getOscilatorStatus(int *result)
{
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        1,
                        PCA9685_PWM_REG_MODE1,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CPort::I2C_COMM_RESPONSE_OK)
    {
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }

    //don't sleep device
    if(receive[0] & PCA9685_PWM_BIT_SLEEP) *result = 0;
    else *result = 1;

    return I2CPort::I2C_COMM_RESPONSE_OK;
}

/**
 * @brief PWMpca9685::update_reg_buffer
 * @return
 */
int PWMpca9685::updateRegBuffer(int channels)
{
    //read register control until register pwm channel nth
    //calculate how many byte register want to get
    //    unsigned char count = PCA9685_PWM_REG_LED7_OFF_H + 1;
    unsigned char count = (channels * 4 + 4) + 6;
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        count,
                        PCA9685_PWM_REG_MODE1,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CPort::I2C_COMM_RESPONSE_OK)
    {
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }

    //copy received byte to holding array
    copy(receive.begin(), receive.end(), m_registerDataBuffer);

    //read register prescale
    cmd.clear();
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        1,
                        PCA9685_PWM_REG_PRE_SCALE,
                        cmd);
    //make buffer received message
    receive.clear();
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CPort::I2C_COMM_RESPONSE_OK)
    {
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }

    //copy received byte to holding array
    copy(receive.begin(), receive.end(), m_registerDataBuffer + PCA9685_PWM_REG_PRE_SCALE + 1);
    return I2CPort::I2C_COMM_RESPONSE_OK;
}

/**
 * @brief PWMpca9685::get_reg_buffer_frequency
 * @return
 */
float PWMpca9685::getRegBufferFrequency()
{
    return (m_oscillatorValue / (m_registerDataBuffer[PCA9685_PWM_REG_PRE_SCALE] + 1)) / 4096;
}

void PWMpca9685::getRegBufferFrequencyRAW(unsigned char &data)
{
    data = m_registerDataBuffer[PCA9685_PWM_REG_PRE_SCALE];
}

int PWMpca9685::getRegBufferPWM(int channel)
{
    int index = getStartAddress(channel);
    unsigned char pwm_reg[4] = {m_registerDataBuffer[index+0], m_registerDataBuffer[index+1], m_registerDataBuffer[index+2], m_registerDataBuffer[index+3]};
    int result;
    PWMRegFormatToDec(pwm_reg, &result);
    return result;
}

void PWMpca9685::clearRegBuffer()
{
    memset(m_registerDataBuffer, 0, 256);
}

/**
 * @brief PWMpca9685::get_frequency
 * @param result pointer to save value of frequency
 * @return communication status failed
 */
int PWMpca9685::getFrequency(float *result)
{
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        1,
                        PCA9685_PWM_REG_PRE_SCALE,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CPort::I2C_COMM_RESPONSE_OK)
    {
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }

    // prescale to frequency
    float val = (m_oscillatorValue / receive[0] / 4096);
    //rounded value to two digits behind comma
    *result = qRound(val * 100.00) / 100.00;
    return I2CPort::I2C_COMM_RESPONSE_OK;
}

/**1017,25260417
 * @brief PWMpca9685::get_pwm
 * @param channel selection whic one want to get output value
 * @param result is pointer to save value of pwm
 * @return communication status
 */
int PWMpca9685::getPWM(int channel, int *result)
{
    unsigned char start_reg = getStartAddress(channel);
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        4,
                        start_reg,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CPort::I2C_COMM_RESPONSE_OK)
    {
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }
    unsigned char pwm_reg[4] = {receive[0], receive[1], receive[2], receive[3]};
    PWMRegFormatToDec(pwm_reg, result);
    return I2CPort::I2C_COMM_RESPONSE_OK;
}

/**
 * @brief PWMpca9685::get_start_m_address
 * @param channel
 * @return
 */
unsigned char PWMpca9685::getStartAddress(int channel)
{
    unsigned char start_reg = PCA9685_PWM_REG_LED0_ON_L;
    switch (channel) {
    case 0:
        start_reg = PCA9685_PWM_REG_LED0_ON_L;
        break;
    case 1:
        start_reg = PCA9685_PWM_REG_LED1_ON_L;
        break;
    case 2:
        start_reg = PCA9685_PWM_REG_LED2_ON_L;
        break;
    case 3:
        start_reg = PCA9685_PWM_REG_LED3_ON_L;
        break;
    case 4:
        start_reg = PCA9685_PWM_REG_LED4_ON_L;
        break;
    case 5:
        start_reg = PCA9685_PWM_REG_LED5_ON_L;
        break;
    case 6:
        start_reg = PCA9685_PWM_REG_LED6_ON_L;
        break;
    case 7:
        start_reg = PCA9685_PWM_REG_LED7_ON_L;
        break;
    case 8:
        start_reg = PCA9685_PWM_REG_LED8_ON_L;
        break;
    case 9:
        start_reg = PCA9685_PWM_REG_LED9_ON_L;
        break;
    case 10:
        start_reg = PCA9685_PWM_REG_LED10_ON_L;
        break;
    case 11:
        start_reg = PCA9685_PWM_REG_LED11_ON_L;
        break;
    case 12:
        start_reg = PCA9685_PWM_REG_LED12_ON_L;
        break;
    case 13:
        start_reg = PCA9685_PWM_REG_LED13_ON_L;
        break;
    case 14:
        start_reg = PCA9685_PWM_REG_LED14_ON_L;
        break;
    case 15:
        start_reg = PCA9685_PWM_REG_LED15_ON_L;
        break;
    }
    return start_reg;
}


/**
 * @brief PWMpca9685::dec_to_pwm_reg_format
 * @param val
 * @param data
 */
void PWMpca9685::decToPWMRegFormat(int val, unsigned char *data)
{
    uint16_t cnt_on = 0;
    uint16_t cnt_off = 0;

    if (val == 0) {
        cnt_off = 4096;
        data[2] = cnt_off;
        data[3] = cnt_off >> 8;
    } else if (val == 100) {
        cnt_on = 4096;
        data[0] = cnt_on;
        data[1] = cnt_on >> 8;
    } else {
        cnt_off = qRound(val * (4096 - 1) / 100.0);
        data[2] = cnt_off;
        data[3] = cnt_off >> 8;
    }
}

/**
 * @brief PWMpca9685::pwm_reg_format_to_dec
 * @param data
 * @param decimal
 */
void PWMpca9685::PWMRegFormatToDec(unsigned char data[], int *decimal)
{
    uint16_t pwm_on = data[1] << 8 | data[0];
    uint16_t pwm_off = data[3] << 8 | data[2];

    //    qDebug() << "PWMpca9685::pwm_reg_format_to_dec: input array " << data[0] <<"-"<< data[1] <<"-"<<data[2] <<"-"<<data[3];
    //    qDebug() << "PWMpca9685::pwm_reg_format_to_dec: input " << pwm_on <<" "<< pwm_off;

    if(pwm_on >= 4095){
        *decimal = 100;
    }else if(pwm_off >= 4095){
        *decimal = 0;
    }else{
        *decimal = (int) qRound((float)(pwm_off * 100) / 4095);
    }

    //    qDebug() << "PWMpca9685::pwm_reg_format_to_dec: " << *decimal;
}

void PWMpca9685::preInitFrequency(int frequencyRequest)
{
    m_frequencyPreInit = frequencyRequest;
}

void PWMpca9685::preInitCountChannelsToPool(int count)
{
    m_countChannelsToPool = count;
}
