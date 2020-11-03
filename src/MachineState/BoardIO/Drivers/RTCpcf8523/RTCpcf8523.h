#ifndef RTCPCF8523_H
#define RTCPCF8523_H

#include "../i2c/I2CPort.h"
#include "../../Drivers/ClassDriver.h"

#define PCF8523_TIMER_SOURCE_FREQ_US    0x00 // 4.096 kHz   //uS
#define PCF8523_TIMER_SOURCE_FREQ_MS    0x01 // 64 Hz       //mS
#define PCF8523_TIMER_SOURCE_FREQ_S     0x02 // 1 Hz        //S
#define PCF8523_TIMER_SOURCE_FREQ_M     0x03 // 1/60        //Minute
#define PCF8523_TIMER_SOURCE_FREQ_H     0x07 // 1/3600      //Hour

#define PCF8523_TIMER_MODE_INT_PERMANENT 0x00
#define PCF8523_TIMER_MODE_INT_PULSE     0x80

#define PCF8523_TIMER_A_MODE_DISABLED   0b00
#define PCF8523_TIMER_A_MODE_COUNTDOWN  0b01
#define PCF8523_TIMER_A_MODE_WATCHDOG   0b10

#define PCF8523_CLOCKOUT_CTRL_32768     0b000
#define PCF8523_CLOCKOUT_CTRL_16384     0b001
#define PCF8523_CLOCKOUT_CTRL_8192      0b010
#define PCF8523_CLOCKOUT_CTRL_4096      0b011
#define PCF8523_CLOCKOUT_CTRL_1024      0b100
#define PCF8523_CLOCKOUT_CTRL_32        0b101
#define PCF8523_CLOCKOUT_CTRL_1         0b110
#define PCF8523_CLOCKOUT_CTRL_DISABLED  0b111

class RTCpcf8523 : public ClassDriver
{
    Q_OBJECT
public:
    RTCpcf8523(QObject *parent = nullptr);

    int init();
    int testComm();
    int polling();

    int setClock(int hour, int minute, int second = 0, bool toBuffer = false);
    int setDate(int weekday, int day, int month, int year, bool toBuffer = false);
    int setWday(int wday, bool toBuffer = false);
    int setModePowerSwitch(int mode = 0, bool toBuffer = false);
    int setClockOutCtrl(int val, bool toBuffer = false);
    int setClearInterrupt(bool toBuffer = false);
    int setTimerAMode(int val, bool toBuffer = false);
    int setTimerAInteruptEnable(int val, bool toBuffer = false);
    int setTimerFreqCtrl(int val, bool toBuffer = false);
    int setTimerAModeInterrupt(int val, bool toBuffer = false);
    int setTimerACount(int val, bool toBuffer = false);
    int getClock(int& hour, int& minute, int& second);
    int getDate(int& wday, int& day, int& month, int& year);
    int getTimerACount(int &count);

    void getRegBuffer_TimerACount(int &count);
    void getRegBuffer_Clock(int& hour, int& minute, int& second);
    void getRegBuffer_Date(int& wday, int& day, int& month, int& year);

    int readTimeDebug();
    int readTimerADebug();

private:
    int bcd_to_dec(unsigned char val);
    unsigned char dec_to_bcd(int val);
};

#endif // RTCPCF8523_H
