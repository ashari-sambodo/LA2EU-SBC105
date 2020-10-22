#include "LEDpca9633.h"

#define LEDPCA9633_ADDR 0x62

/* AI[2:0] = 000 is used when the same
 * register must be accessed several
 * times during a single I2C-bus
 * communication, for example,
 * changes the brightness of a single LED.
 * Data is overwritten each time
 * the register is accessed during a write operation
*/
#define LEDPCA9633_AUTO_INC_NO                  0b00000000
/* AI[2:0] = 100 is used when all
 * the registers must be sequentially
 * accessed, for example,power-up programming.
 */
#define LEDPCA9633_AUTO_INC_OPT_1               0b10000000
/* AI[2:0] = 101 is used when the
 * four LED drivers must be individually
 * programmed with different values during
 * the same I2C-bus communication,
 * for example, changing color setting to
 * another color setting.
*/
#define LEDPCA9633_AUTO_INC_OPT_2               0b10100000
/* AI[2:0] = 110 is used when the LED
 * drivers must be globally programmed
 * with different settings during the
 * same I2C-bus communication, for example,
 * global brightness or blinking change
*/
#define LEDPCA9633_AUTO_INC_OPT_3               0b11000000
/* AI[2:0] = 111 is used when individual
 * and global changes must be performed
 * during the same I2C-bus communication,
 * for example, changing a color and
 * global brightness at the same time
*/
#define LEDPCA9633_AUTO_INC_OPT_4               0b11100000

enum LEDPCA9633_REGISTER{
    LEDPCA9633_REG_MODE1,
    LEDPCA9633_REG_MODE2,
    LEDPCA9633_REG_PWM0,
    LEDPCA9633_REG_PWM1,
    LEDPCA9633_REG_PWM2,
    LEDPCA9633_REG_PWM3,
    LEDPCA9633_REG_GRPPWM,
    LEDPCA9633_REG_GRPFREQ,
    LEDPCA9633_REG_LEDOUT,
    LEDPCA9633_REG_SUBADDR1,
    LEDPCA9633_REG_SUBADDR2,
    LEDPCA9633_REG_SUBADDR3,
    LEDPCA9633_REG_ALLCALLADR,
};

using namespace std;

LEDpca9633::LEDpca9633(QObject *parent)
    : ClassDriver (parent)
{
    m_address = LEDPCA9633_ADDR;
}

/**
 * @brief LEDpca9633::init
 * @return
 * It takes 500 µs max. for the oscillator
 * to be up and running once SLEEP bit has been
 * set to logic 0. Timings on LEDn outputs are
 * not guaranteed if PWMx, GRPPWM or GRPFREQ
 * registers are accessed within the 500 µs window
 */
int LEDpca9633::init()
{
    //SINGLE REGISTER TRANSACTION
    //SET REGISTER MODE 1 TO
    // - SLEEP to Normal Mode
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_WRITE,
                        m_address,
                        1,
                        1,
                        LEDPCA9633_REGISTER::LEDPCA9633_REG_MODE1,
                        cmd);
    // WAKEUP OSCILATOR
    // TURN OFF ALL CALL
    cmd.push_back(0x00);
    //call i2c object and pass command frame
    if(pI2C->writeData(cmd) != I2CCom::I2C_COMM_RESPONSE_OK)
    {
        return I2CCom::I2C_COMM_RESPONSE_ERROR;
    }
    return I2CCom::I2C_COMM_RESPONSE_OK;
}

int LEDpca9633::testComm()
{
    uchar mode;
    return getMode1(mode);
}

int LEDpca9633::polling()
{
    return getRegisters();
}

/**
 * @brief LEDpca9633::setOutputPWM
 * @param pin
 * @param duty
 * @return
 *
 * A 97 kHz fixed frequency signal is used for each output.
 * Duty cycle is controlled through 256 linear steps from
 * 00h (0 % duty cycle = LED output off) to FFh
 * (99.6 % duty cycle = LED output at maximum brightness).
 * Applicable to LED outputs programmed with LDRx = 10 or 11 (LEDOUT register).
 * duty_cycle = IDC[0:7] / 256
 */
int LEDpca9633::setOutputPWM(uchar pin, int duty, bool toBuffer)
{
    int dutyScaleCount = qRound(static_cast<double>(duty * 255) / 100.0);

    //    printf("LEDpca9633::setOutputPWM pin: %d dutyScale: %d = %2X = %d\n", pin, dutyScale, ~dutyScale, static_cast<uchar>(~dutyScale));
    //    fflush(stdout);

    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_WRITE,
                        m_address,
                        1,
                        1,
                        LEDPCA9633_REGISTER::LEDPCA9633_REG_PWM0 + pin,
                        cmd);
    cmd.push_back(static_cast<uchar>(~dutyScaleCount));
    //call i2c object and pass command frame
    if(toBuffer){
        pI2C->addOutQueue(cmd);
    }else{
        if(pI2C->writeData(cmd) != I2CCom::I2C_COMM_RESPONSE_OK)
        {
            return I2CCom::I2C_COMM_RESPONSE_ERROR;
        }
    }
    return I2CCom::I2C_COMM_RESPONSE_OK;
}

int LEDpca9633::setOutputAsPWM(uchar pin, bool toBuffer)
{
    //AWARE WITH OTHER PIN STATE
    m_registerDataBuffer[LEDPCA9633_REG_LEDOUT] &= ~(0b00000011 << (pin * 2));
    m_registerDataBuffer[LEDPCA9633_REG_LEDOUT] |= LEDPCA9633_LEDOUT_PWM << (pin * 2);

    //    printf("LEDpca9633::setOutputAsPWM %02X\n", m_registerDataBuffer[LEDPCA9633_REG_LEDOUT]);
    //    fflush(stdout);

    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_WRITE,
                        m_address,
                        1,
                        1,
                        LEDPCA9633_REGISTER::LEDPCA9633_REG_LEDOUT,
                        cmd);
    cmd.push_back(m_registerDataBuffer[LEDPCA9633_REG_LEDOUT]);
    //call i2c object and pass command frame
    if(toBuffer){
        pI2C->addOutQueue(cmd);
    }else{
        if(pI2C->writeData(cmd) != I2CCom::I2C_COMM_RESPONSE_OK)
        {
            return I2CCom::I2C_COMM_RESPONSE_ERROR;
        }
    }

    return I2CCom::I2C_COMM_RESPONSE_OK;
}

int LEDpca9633::setOutputAsPWMGroup(uchar pin, bool toBuffer)
{
    //AWARE WITH OTHER PIN STATE
    //OUTPUT IS INVERT VALUE
    m_registerDataBuffer[LEDPCA9633_REG_LEDOUT] &= ~(0b00000011 << (pin * 2));
    m_registerDataBuffer[LEDPCA9633_REG_LEDOUT] |= LEDPCA9633_LEDOUT_PWM_GROUP << (pin * 2);

    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_WRITE,
                        m_address,
                        1,
                        1,
                        LEDPCA9633_REGISTER::LEDPCA9633_REG_LEDOUT,
                        cmd);
    cmd.push_back(m_registerDataBuffer[LEDPCA9633_REG_LEDOUT]);
    //call i2c object and pass command frame
    if(toBuffer){
        pI2C->addOutQueue(cmd);
    }else{
        if(pI2C->writeData(cmd) != I2CCom::I2C_COMM_RESPONSE_OK)
        {
            return I2CCom::I2C_COMM_RESPONSE_ERROR;
        }
    }
    return I2CCom::I2C_COMM_RESPONSE_OK;
}

int LEDpca9633::setOutputAsDigital(uchar pin, bool state, bool toBuffer)
{
    //AWARE WITH OTHER PIN STATE
    //OUTPUT IS INVERT VALUE
    m_registerDataBuffer[LEDPCA9633_REG_LEDOUT] &= ~(0b00000011 << (pin * 2));
    m_registerDataBuffer[LEDPCA9633_REG_LEDOUT] |= !state << (pin * 2);

    //    printf("LEDpca9633::setOutputAsDigital %02X\n", m_registerDataBuffer[LEDPCA9633_REG_LEDOUT]);
    //    fflush(stdout);

    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_WRITE,
                        m_address,
                        1,
                        1,
                        LEDPCA9633_REGISTER::LEDPCA9633_REG_LEDOUT,
                        cmd);
    cmd.push_back(m_registerDataBuffer[LEDPCA9633_REG_LEDOUT]);
    //call i2c object and pass command frame
    if(toBuffer){
        pI2C->addOutQueue(cmd);
    }else{
        if(pI2C->writeData(cmd) != I2CCom::I2C_COMM_RESPONSE_OK)
        {
            return I2CCom::I2C_COMM_RESPONSE_ERROR;
        }
    }
    return I2CCom::I2C_COMM_RESPONSE_OK;
}

int LEDpca9633::getMode1(uchar &mode)
{
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        1,
                        LEDPCA9633_REG_MODE1,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CCom::I2C_COMM_RESPONSE_OK)
    {
        return I2CCom::I2C_COMM_RESPONSE_ERROR;
    }

    m_registerDataBuffer[LEDPCA9633_REG_MODE1] = receive[0];
    mode = m_registerDataBuffer[LEDPCA9633_REG_MODE1];

    return I2CCom::I2C_COMM_RESPONSE_OK;
}

int LEDpca9633::getOutputState(uchar pin, uchar &state)
{
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        1,
                        LEDPCA9633_REG_LEDOUT,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CCom::I2C_COMM_RESPONSE_OK)
    {
        return I2CCom::I2C_COMM_RESPONSE_ERROR;
    }

    m_registerDataBuffer[LEDPCA9633_REG_LEDOUT] = receive[0];
    state = (m_registerDataBuffer[LEDPCA9633_REG_LEDOUT] >> (pin * 2)) & 0b00000011;

    return I2CCom::I2C_COMM_RESPONSE_OK;
}
/**
 * @brief LEDpca9633::getOutputPWM
 * @param pin
 * @param value
 * @return
 */
int LEDpca9633::getOutputPWM(uchar pin, int &value)
{
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        1,
                        LEDPCA9633_REG_PWM0 + pin,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CCom::I2C_COMM_RESPONSE_OK)
    {
        return I2CCom::I2C_COMM_RESPONSE_ERROR;
    }

    ////SAVE TO MEMORY
    m_registerDataBuffer[LEDPCA9633_REG_PWM0 + pin] = receive[0];
    ////CONVERT FROM COUNTING TO DUTY CYCLE
    value = qRound(static_cast<double>((255 - receive[0]) / 255) * 100.0);

    return I2CCom::I2C_COMM_RESPONSE_OK;
}

/**
 * @brief LEDpca9633::getRegisters
 * @return response of i2c communication if communication is sync,
 * if communication is async/toBuffer return will always ok
 */
int LEDpca9633::getRegisters()
{
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        LEDPCA9633_REG_LEDOUT + 1,
                        LEDPCA9633_AUTO_INC_OPT_1,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CCom::I2C_COMM_RESPONSE_OK)
    {
        return I2CCom::I2C_COMM_RESPONSE_ERROR;
    }

    ////SAVE TO MEMORY
    int i = 0;
    foreach (uchar data, receive){
        m_registerDataBuffer[i] = data;
        i++;
        //        printf("LEDpca9633::getRegisters 0x%X\n", data);
        //        fflush(stdout);
    }

    return I2CCom::I2C_COMM_RESPONSE_OK;
}

void LEDpca9633::getRegBuffer_mode1(uchar &mode)
{
    mode = m_registerDataBuffer[LEDPCA9633_REG_MODE1];
}

/**
 * @brief LEDpca9633::getRegBuffer_outputState
 * 0b00 is Pin as just digital output with real value is ON, need invert the return value
 * 0b01 is Pin as just digital output with real value is OFF, need invert the return value
 * 0b10 is Pin as PWM output with real value depending to LEDPCA9633_REG_PWMx
 * 0b11 is Pin as PWM Group output with real value depending to LEDPCA9633_REG_GRPPWM
 * @param pin is select which pin want to check
 * @param state is the result of the register value
 */
void LEDpca9633::getRegBuffer_outputState(uchar pin, uchar &state)
{
    state = (m_registerDataBuffer[LEDPCA9633_REG_LEDOUT] >> (pin * 2)) & 0b00000011;
    //if the pin as a digital output, need invert the return value
    state = state <= 1 ? (state ? 0 : 1) : state;
}

void LEDpca9633::getRegBuffer_outputPWM(uchar pin, int &value)
{
    ////CONVERT FROM COUNTING TO DUTY CYCLE
    value = qRound(((255.0 - static_cast<double>(m_registerDataBuffer[LEDPCA9633_REG_PWM0 + pin]/*0xE5*//*229*/)) / 255.0) * 100.0);
}
