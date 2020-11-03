#ifndef AOMCP4725_H
#define AOMCP4725_H

#include "../i2c/I2CPort.h"
#include "../ClassDriver.h"

class AOmcp4725 : public ClassDriver
{
    Q_OBJECT
public:
    AOmcp4725(QObject *parent = nullptr);

    enum i2cOutMethod{
      I2C_OUT_DIRECT,
      I2C_OUT_BUFFER
    };

    int testComm();
    int init();
    int polling();

    //    int setFastMode(float volt);
    int setVoltDAC(int mvolt, bool toBuffer=false);
    int setVoltDACRegEEPROM(int mvolt, bool toBuffer=false);
    int setDAC(int inputCode, bool toBuffer=false);
    int setDACRegEEPROM(int inputCode, bool toBuffer=false);

    int getDAC(int *result_adc, int *result_mvolt = nullptr);
    int getDACRegEEPROM(int *result_adc, int *result_mvolt = nullptr);

    int updateRegBuffer();
    void getRegBufferDAC(int *dac, int *mvolt=nullptr);
    void getRegBufferDACRegEEPROM(int *dac, int *mvolt=nullptr);
    void clearRegBuffer();

    void _debugPrintRawDAC();

private:
    void voltToInputcode(int value, int *result);
    void inputcodeToMiliVolt(int inputcode, int *result);

};

#endif // AOMCP4725_H
