#ifndef AIMCP342X_H
#define AIMCP342X_H

#include "../i2c/I2CPort.h"
#include "../ClassDriver.h"

//conversion bit: bit 7
#define MCP342X_AI_CONV_INIT             0x01
#define MCP342X_AI_CONV_RDY              0x00

//channel selection bits: bit 6 and 5
#define MCP342X_AI_CH1                   0x00
#define MCP342X_AI_CH2                   0x01
#define MCP342X_AI_CH3                   0x02
#define MCP342X_AI_CH4                   0x03

//conversion mode bit: bit 4
#define MCP342X_AI_CONT_CONV             0x01
#define MCP342X_AI_SINGLE_CONV           0x00

//sample rate selection bits :bit 3 and bit 2
#define MCP342X_AI_SPS_12bits            0x00
#define MCP342X_AI_SPS_14bits            0x01
#define MCP342X_AI_SPS_16bits            0x02
#define MCP342X_AI_SPS_18bits            0x03

//gain selection bits: bit 1 and bit 0
#define MCP342X_AI_GAIN_x1               0x00
#define MCP342X_AI_GAIN_x2               0x01
#define MCP342X_AI_GAIN_x4               0x02
#define MCP342X_AI_GAIN_x8               0x03

class AImcp342x : public ClassDriver
{
    Q_OBJECT
public:
    AImcp342x(QObject *parent = nullptr);
    int testComm();
    int init();

    void    setConfigChannel(uchar channel);
    void    setConfigSPS(char sps);
    int     sendConfig();
    int     getValue(int *adc, int channel, int *mVolt = nullptr, double *mA = nullptr);
    int     convertADCtomVolt(int adc);
    double  convertADCtomA(int adc);
    bool    isConversionUpdated();
    void    clearRegBuffer();
    unsigned char  getConfigSPS() const;

    void _debugPrintRegister(int index);

private:
    union{
        struct
        {
            unsigned char pga       : 2;
            unsigned char sps       : 2;
            unsigned char conv_mode : 1;
            unsigned char channel   : 2;
            unsigned char r_flag    : 1;
        }bits;
        unsigned char byte;
    }config;

    float PGA[4] = {1.0, 2.0, 4.0, 8.0};
    float lsb_value;
    int convertionUpdated;
};

#endif // AIMCP342X_H
