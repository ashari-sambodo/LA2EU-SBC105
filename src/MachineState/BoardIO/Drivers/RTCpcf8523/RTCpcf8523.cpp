#include "RTCpcf8523.h"

#define DEBUG_ON_INIT

#define PCF8523_m_address           0x68
#define PCF8523_MASK_SECOND_MINUTE  0x7f
#define PCF8523_MASK_HOUR_DAYS      0x3f
#define PCF8523_MASK_WDAY           0x07
#define PCF8523_MASK_MONTH          0x1f

#define PCF8523_YEAR_CENTURY        2000

enum PCF8523_REG{
    PCF8523_REG_CONTROL_1,
    PCF8523_REG_CONTROL_2,
    PCF8523_REG_CONTROL_3,
    PCF8523_REG_SECOND,
    PCF8523_REG_MINUTE,
    PCF8523_REG_HOURS,
    PCF8523_REG_DAYS,
    PCF8523_REG_WEEKDAYS,
    PCF8523_REG_MONTHS,
    PCF8523_REG_YEARS,
    PCF8523_REG_MINUTE_ALARM,
    PCF8523_REG_HOUR_ALARM,
    PCF8523_REG_DAY_ALARM,
    PCF8523_REG_WEEKDAY_ALARM,
    PCF8523_REG_OFFSET,
    PCF8523_REG_TMR_CLKOUT_CTRL,
    PCF8523_REG_TMR_A_FREQ_CTRL,
    PCF8523_REG_TMR_A_REG,
    PCF8523_REG_TMR_B_FREQ_CTRL,
    PCF8523_REG_TMR_B_REG
};

using namespace std;

RTCpcf8523::RTCpcf8523(QObject *parent)
    : ClassDriver(parent)
{
    memset(m_registerDataBuffer, 0x00, 255);
    m_address       = PCF8523_m_address;
}

int RTCpcf8523::readTimeDebug()
{
    //generate comand frame
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        7,
                        PCF8523_REG::PCF8523_REG_SECOND,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CCom::I2C_COMM_RESPONSE_OK)
    {
        return I2CCom::I2C_COMM_RESPONSE_ERROR;
    }
    //update register data
    m_registerDataBuffer[PCF8523_REG_SECOND]   = receive[0];
    m_registerDataBuffer[PCF8523_REG_MINUTE]   = receive[1];
    m_registerDataBuffer[PCF8523_REG_HOURS]    = receive[2];
    m_registerDataBuffer[PCF8523_REG_DAYS]     = receive[3];
    m_registerDataBuffer[PCF8523_REG_WEEKDAYS] = receive[4];
    m_registerDataBuffer[PCF8523_REG_MONTHS]   = receive[5];
    m_registerDataBuffer[PCF8523_REG_YEARS]    = receive[6];

    printf("Weekdays: %d Date: %02d-%02d-%d Clock: %02d:%02d:%02d\n",
           (receive[4] & PCF8523_MASK_WDAY),
            bcd_to_dec(receive[3] & PCF8523_MASK_HOUR_DAYS),
            bcd_to_dec(receive[5] & PCF8523_MASK_MONTH),
            bcd_to_dec(receive[6]) + PCF8523_YEAR_CENTURY,
            bcd_to_dec(receive[2] & PCF8523_MASK_HOUR_DAYS),
            bcd_to_dec(receive[1] & PCF8523_MASK_SECOND_MINUTE),
            bcd_to_dec(receive[0] & PCF8523_MASK_SECOND_MINUTE));
    fflush(stdout);
    return I2CCom::I2C_COMM_RESPONSE_OK;
}

int RTCpcf8523::readTimerADebug()
{
    //generate comand frame
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        1,
                        PCF8523_REG::PCF8523_REG_TMR_A_REG,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CCom::I2C_COMM_RESPONSE_OK)
    {
        return I2CCom::I2C_COMM_RESPONSE_ERROR;
    }

    printf("Counter: %d \n", receive[0]);
    fflush(stdout);

    return I2CCom::I2C_COMM_RESPONSE_OK;
}

int RTCpcf8523::init()
{
    //    printf("RTCpcf8523::init\n");
    //    fflush(stdout);

    //check invalidate second osilation
    //generate comand frame
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        1,
                        PCF8523_REG::PCF8523_REG_SECOND,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CCom::I2C_COMM_RESPONSE_OK)
    {
        return I2CCom::I2C_COMM_RESPONSE_ERROR;
    }

    unsigned char invalid_flag = receive[0];
    if(invalid_flag & 0x80){
        //invalid second osilation
        //        printf("RTCpcf8523::init invalid_oscilation\n");
        //        fflush(stdout);
        //RESET SOFTWARE pcf8523
        //generate comand frame
        cmd.clear();
        pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_WRITE,
                            m_address,
                            1,
                            1,
                            PCF8523_REG::PCF8523_REG_CONTROL_1,
                            cmd);
        cmd.push_back(0x58);
        //call i2c object and pass command frame
        if(pI2C->writeData(cmd) != I2CCom::I2C_COMM_RESPONSE_OK)
        {
            return I2CCom::I2C_COMM_RESPONSE_ERROR;
        }

        //Re setting battery switch over Vcc << Vbat << Vth and reset value to zero (Standard Mode)
        //generate comand frame
        cmd.clear();
        pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_WRITE,
                            m_address,
                            1,
                            8,
                            PCF8523_REG::PCF8523_REG_CONTROL_3,
                            cmd);
        cmd.push_back(0x0); // power swith mode, battery switch over
        cmd.push_back(0x0); // second
        cmd.push_back(0x0); // minute
        cmd.push_back(0x0); // hour
        cmd.push_back(0x1); // day
        cmd.push_back(0x0); // wday
        cmd.push_back(0x1); // month
        cmd.push_back(0x0); // year
        //call i2c object and pass command frame
        if(pI2C->writeData(cmd) != I2CCom::I2C_COMM_RESPONSE_OK)
        {
            return I2CCom::I2C_COMM_RESPONSE_ERROR;
        }
    }
    return I2CCom::I2C_COMM_RESPONSE_OK;
}

int RTCpcf8523::setClock(int hour, int minute, int second, bool toBuffer)
{
    //formated value
    unsigned char bcd_hour = dec_to_bcd(hour);
    unsigned char bcd_min = dec_to_bcd(minute);
    unsigned char bcd_sec = dec_to_bcd(second);
    //generate comand frame
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_WRITE,
                        m_address,
                        1,
                        3,
                        PCF8523_REG::PCF8523_REG_SECOND,
                        cmd);
    cmd.push_back(bcd_sec);
    cmd.push_back(bcd_min);
    cmd.push_back(bcd_hour);
    //call i2c object and pass command frame
    if(toBuffer){
        pI2C->addOutQueue(cmd);
    }
    else{
        if(pI2C->writeData(cmd) != I2CCom::I2C_COMM_RESPONSE_OK)
        {
            return I2CCom::I2C_COMM_RESPONSE_ERROR;
        }
    }
    return I2CCom::I2C_COMM_RESPONSE_OK;
}

int RTCpcf8523::setDate(int weekday, int day, int month, int year, bool toBuffer)
{
    //formated value
    unsigned char bcd_day   = dec_to_bcd(day);
    unsigned char bcd_month = dec_to_bcd(month);
    unsigned char bcd_year  = dec_to_bcd(year - PCF8523_YEAR_CENTURY);
    //generate comand frame
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_WRITE,
                        m_address,
                        1,
                        4,
                        PCF8523_REG::PCF8523_REG_DAYS,
                        cmd);
    cmd.push_back(bcd_day);
    cmd.push_back(static_cast<unsigned char>(weekday));
    cmd.push_back(bcd_month);
    cmd.push_back(bcd_year);
    //call i2c object and pass command frame
    if(toBuffer) {
        pI2C->addOutQueue(cmd);
    }else{
        if((pI2C->writeData(cmd) != I2CCom::I2C_COMM_RESPONSE_OK))
        {
            return I2CCom::I2C_COMM_RESPONSE_ERROR;
        }
    }
    return I2CCom::I2C_COMM_RESPONSE_OK;
}

int RTCpcf8523::setWday(int wday, bool toBuffer)
{
    //generate comand frame
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_WRITE,
                        m_address,
                        1,
                        1,
                        PCF8523_REG::PCF8523_REG_WEEKDAYS,
                        cmd);
    cmd.push_back(static_cast<unsigned char>(wday));
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

int RTCpcf8523::setModePowerSwitch(int mode, bool toBuffer)
{
    //generate comand frame
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_WRITE,
                        m_address,
                        1,
                        1,
                        PCF8523_REG::PCF8523_REG_CONTROL_3,
                        cmd);
    cmd.push_back(static_cast<unsigned char>(mode));
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

int RTCpcf8523::setClockOutCtrl(int val, bool toBuffer)
{
    //generate comand frame
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        1,
                        PCF8523_REG::PCF8523_REG_TMR_CLKOUT_CTRL,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CCom::I2C_COMM_RESPONSE_OK)
    {
        return I2CCom::I2C_COMM_RESPONSE_ERROR;
    }

    //SAVE_TO_REGISTER_HOLDER
    m_registerDataBuffer[PCF8523_REG::PCF8523_REG_TMR_CLKOUT_CTRL] = receive[0];

    //MASKING_VALUE
    int maskRegCtrl = m_registerDataBuffer[PCF8523_REG::PCF8523_REG_TMR_CLKOUT_CTRL] & 0b11000111;
    int newRegCtrl = maskRegCtrl | (val << 3);

    //SET_TO_NEW_VALUE
    //generate comand frame
    cmd.clear();
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_WRITE,
                        m_address,
                        1,
                        1,
                        PCF8523_REG::PCF8523_REG_TMR_CLKOUT_CTRL,
                        cmd);
    cmd.push_back(static_cast<unsigned char>(newRegCtrl));
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

int RTCpcf8523::setClearInterrupt(bool toBuffer)
{
    //generate comand frame
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        1,
                        PCF8523_REG::PCF8523_REG_CONTROL_2,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(toBuffer){
        pI2C->addOutQueue(cmd);
    }else{
        vector<unsigned char> receive;
        //call i2c object and pass command frame
        if(pI2C->readData(cmd, receive) != I2CCom::I2C_COMM_RESPONSE_OK)
        {
            return I2CCom::I2C_COMM_RESPONSE_ERROR;
        }
        //update_holding_register
        m_registerDataBuffer[PCF8523_REG::PCF8523_REG_CONTROL_2] = receive[0];
    }
    return I2CCom::I2C_COMM_RESPONSE_OK;
}

int RTCpcf8523::setTimerAMode(int val, bool toBuffer)
{
    //generate comand frame
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        1,
                        PCF8523_REG::PCF8523_REG_TMR_CLKOUT_CTRL,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CCom::I2C_COMM_RESPONSE_OK)
    {
        return I2CCom::I2C_COMM_RESPONSE_ERROR;
    }

    //SAVE_TO_REGISTER_HOLDER
    m_registerDataBuffer[PCF8523_REG::PCF8523_REG_TMR_CLKOUT_CTRL] = receive[0];

    //MASKING_VALUE
    int maskRegCtrl = m_registerDataBuffer[PCF8523_REG::PCF8523_REG_TMR_CLKOUT_CTRL] & 0b11111001;
    int newRegCtrl = maskRegCtrl | (val << 1);

    //SET_TO_NEW_VALUE
    //generate comand frame
    cmd.clear();
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_WRITE,
                        m_address,
                        1,
                        1,
                        PCF8523_REG::PCF8523_REG_TMR_CLKOUT_CTRL,
                        cmd);
    cmd.push_back(static_cast<unsigned char>(newRegCtrl));
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

int RTCpcf8523::setTimerAInteruptEnable(int val, bool toBuffer)
{
    //generate comand frame
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        1,
                        PCF8523_REG::PCF8523_REG_CONTROL_2,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CCom::I2C_COMM_RESPONSE_OK)
    {
        return I2CCom::I2C_COMM_RESPONSE_ERROR;
    }

    //SAVE_TO_REGISTER_HOLDER
    m_registerDataBuffer[PCF8523_REG::PCF8523_REG_CONTROL_2] = receive[0];

    //MASKING_VALUE
    int maskRegCtrl = m_registerDataBuffer[PCF8523_REG::PCF8523_REG_CONTROL_2] & 0b11111011;
    int newRegCtrl = maskRegCtrl | (val << 2);

    //SET_TO_NEW_VALUE
    //generate comand frame
    cmd.clear();
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_WRITE,
                        m_address,
                        1,
                        1,
                        PCF8523_REG::PCF8523_REG_CONTROL_2,
                        cmd);
    cmd.push_back(static_cast<unsigned char>(newRegCtrl));
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

int RTCpcf8523::setTimerFreqCtrl(int val, bool toBuffer)
{
    //generate comand frame
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_WRITE,
                        m_address,
                        1,
                        1,
                        PCF8523_REG::PCF8523_REG_TMR_A_FREQ_CTRL,
                        cmd);
    cmd.push_back(static_cast<unsigned char>(val));
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

int RTCpcf8523::setTimerAModeInterrupt(int val, bool toBuffer)
{
    //generate comand frame
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        1,
                        PCF8523_REG::PCF8523_REG_TMR_CLKOUT_CTRL,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CCom::I2C_COMM_RESPONSE_OK)
    {
        return I2CCom::I2C_COMM_RESPONSE_ERROR;
    }

    //SAVE_TO_REGISTER_HOLDER
    m_registerDataBuffer[PCF8523_REG::PCF8523_REG_TMR_CLKOUT_CTRL] = receive[0];

    //MASKING_VALUE
    int maskRegCtrl = m_registerDataBuffer[PCF8523_REG::PCF8523_REG_TMR_CLKOUT_CTRL] & 0b01111111;
    int newRegCtrl = maskRegCtrl | val;

    //SET_TO_NEW_VALUE
    //generate comand frame
    cmd.clear();
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_WRITE,
                        m_address,
                        1,
                        1,
                        PCF8523_REG::PCF8523_REG_TMR_CLKOUT_CTRL,
                        cmd);
    cmd.push_back(static_cast<unsigned char>(newRegCtrl));
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

int RTCpcf8523::setTimerACount(int val, bool toBuffer)
{
    //generate comand frame
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_WRITE,
                        m_address,
                        1,
                        1,
                        PCF8523_REG::PCF8523_REG_TMR_A_REG,
                        cmd);
    cmd.push_back(static_cast<unsigned char>(val));
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

int RTCpcf8523::getClock(int &hour, int &minute, int &second)
{
    //generate comand frame
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        3,
                        PCF8523_REG::PCF8523_REG_SECOND,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CCom::I2C_COMM_RESPONSE_OK)
    {
        return I2CCom::I2C_COMM_RESPONSE_ERROR;
    }
    //update register data
    m_registerDataBuffer[PCF8523_REG_SECOND]   = receive[0];
    m_registerDataBuffer[PCF8523_REG_MINUTE]   = receive[1];
    m_registerDataBuffer[PCF8523_REG_HOURS]    = receive[2];

    //fill to buffer getter
    hour    = bcd_to_dec(m_registerDataBuffer[PCF8523_REG_HOURS]   & PCF8523_MASK_HOUR_DAYS);
    minute  = bcd_to_dec(m_registerDataBuffer[PCF8523_REG_MINUTE]  & PCF8523_MASK_SECOND_MINUTE);
    second  = bcd_to_dec(m_registerDataBuffer[PCF8523_REG_SECOND]  & PCF8523_MASK_SECOND_MINUTE);

    return I2CCom::I2C_COMM_RESPONSE_OK;
}

int RTCpcf8523::getDate(int& wday, int &day, int &month, int &year)
{
    //generate comand frame
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        4,
                        PCF8523_REG::PCF8523_REG_DAYS,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CCom::I2C_COMM_RESPONSE_OK)
    {
        return I2CCom::I2C_COMM_RESPONSE_ERROR;
    }
    //update register data
    m_registerDataBuffer[PCF8523_REG_DAYS]     = receive[0];
    m_registerDataBuffer[PCF8523_REG_WEEKDAYS] = receive[1];
    m_registerDataBuffer[PCF8523_REG_MONTHS]   = receive[2];
    m_registerDataBuffer[PCF8523_REG_YEARS]    = receive[3];

    //fill to beffer getter
    wday    = bcd_to_dec(m_registerDataBuffer[PCF8523_REG_WEEKDAYS] & PCF8523_MASK_WDAY);
    day     = bcd_to_dec(m_registerDataBuffer[PCF8523_REG_DAYS] & PCF8523_MASK_HOUR_DAYS);
    month   = bcd_to_dec(m_registerDataBuffer[PCF8523_REG_MONTHS] & PCF8523_MASK_MONTH);
    year    = bcd_to_dec(m_registerDataBuffer[PCF8523_REG_YEARS]) + PCF8523_YEAR_CENTURY;

    return I2CCom::I2C_COMM_RESPONSE_OK;
}

int RTCpcf8523::getTimerACount(int &count)
{
    //generate comand frame
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        1,
                        PCF8523_REG::PCF8523_REG_TMR_A_REG,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CCom::I2C_COMM_RESPONSE_OK)
    {
        return I2CCom::I2C_COMM_RESPONSE_ERROR;
    }

    //update register data
    m_registerDataBuffer[PCF8523_REG_TMR_A_REG]     = receive[0];
    count = m_registerDataBuffer[PCF8523_REG_TMR_A_REG];

    return I2CCom::I2C_COMM_RESPONSE_OK;
}

void RTCpcf8523::getRegBuffer_TimerACount(int &count)
{
    count = m_registerDataBuffer[PCF8523_REG_TMR_A_REG];
}

void RTCpcf8523::getRegBuffer_Clock(int &hour, int &minute, int &second)
{
    hour    = bcd_to_dec(m_registerDataBuffer[PCF8523_REG_HOURS]   & PCF8523_MASK_HOUR_DAYS);
    minute  = bcd_to_dec(m_registerDataBuffer[PCF8523_REG_MINUTE]  & PCF8523_MASK_SECOND_MINUTE);
    second  = bcd_to_dec(m_registerDataBuffer[PCF8523_REG_SECOND]  & PCF8523_MASK_SECOND_MINUTE);
}

void RTCpcf8523::getRegBuffer_Date(int &wday, int &day, int &month, int &year)
{
    wday    = bcd_to_dec(m_registerDataBuffer[PCF8523_REG_WEEKDAYS] & PCF8523_MASK_WDAY);
    day     = bcd_to_dec(m_registerDataBuffer[PCF8523_REG_DAYS] & PCF8523_MASK_HOUR_DAYS);
    month   = bcd_to_dec(m_registerDataBuffer[PCF8523_REG_MONTHS] & PCF8523_MASK_MONTH);
    year    = bcd_to_dec(m_registerDataBuffer[PCF8523_REG_YEARS]) + PCF8523_YEAR_CENTURY;
}

int RTCpcf8523::testComm()
{
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CCom::I2C_CMD_OPERATION_READ,
                        m_address,
                        1,
                        1,
                        PCF8523_REG::PCF8523_REG_CONTROL_1,
                        cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CCom::I2C_COMM_RESPONSE_OK)
    {
        return I2CCom::I2C_COMM_RESPONSE_ERROR;
    }
    return I2CCom::I2C_COMM_RESPONSE_OK;
}

int RTCpcf8523::polling()
{
    int response;
    ////GET DATE
    {
        int wday, day, month, year;
        response = getDate(wday, day, month, year);
    }
    ////GET TIME
    {
        int hour, minute, second;
        response = getClock(hour, minute, second);
    }
    ////GET TIMER COUNTDOWN - WATCHDOG
    {
        int countdown;
        response = getTimerACount(countdown);
    }
    return response;
}

int RTCpcf8523::bcd_to_dec(unsigned char val)
{
    return (((val & 0xf0) >> 4) * 10) + (val & 0x0f);
}

unsigned char RTCpcf8523::dec_to_bcd(int val)
{
    return static_cast<unsigned char>(((val / 10 ) << 4) | (val % 10));
}
