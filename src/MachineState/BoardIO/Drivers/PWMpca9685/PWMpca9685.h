#ifndef PWMPCA9685_H
#define PWMPCA9685_H

#include <unistd.h>
#include "../i2c/I2CCom.h"
#include "../ClassDriver.h"

#define PCA9685_PWM_ADDRESS              0x40
#define PCA9685_PWM_BIT_RESTART          0x80
#define PCA9685_PWM_BIT_SLEEP            0x10
#define PCA9685_PWM_BIT_AUTOINC          0x20
#define PCA9685_PWM_BIT_ALLCAL           0x01
#define PCA9685_PWM_BIT_EX_OSCILATOR     0x50

#define PCA9685_PWM_VAL_FREQ_100HZ       100 //hz
#define PCA9685_PWM_VAL_IN_OSCILATOR     25000000
#define PCA9685_PWM_VAL_EX_OSCILATOR     1024000/*45000000*/

#define PCA9685_PWM_VAL_FULL_DCY_ON     100
#define PCA9685_PWM_VAL_FULL_DCY_OFF    0

class PWMpca9685 : public ClassDriver
{
    Q_OBJECT
public:
    PWMpca9685(QObject *parent = nullptr);

    enum OscType{
        TYPE_OSC_INTERNAL,
        OSC_TYPE_EXTENAL
    };

    enum i2cOutMethod{
      I2C_OUT_DIRECT,
      I2C_OUT_BUFFER
    };

    int init();
    int testComm();
    int polling();

    void preInitOscilatorType(int oscilator = OscType::TYPE_OSC_INTERNAL);
    void preInitFrequency(int frequencyRequest);
    void preInitCountChannelsToPool(int count);

    int setFrequency(float frequency);
    int setPWM(int channel, int duty_cycle, bool toBuffer=false);
    int setAllPWM(int duty_cycle, bool toBuffer=false);

    int getFrequency(float *result);
    int getPWM(int channel, int *result);

    int getOscilatorStatus(int *result);

    int updateRegBuffer(int channels = 8);

    float getRegBufferFrequency();
    void getRegBufferFrequencyRAW(unsigned char &data);

    int getRegBufferPWM(int channel);
    void clearRegBuffer();

private:
    unsigned char getStartAddress(int channel);
    void decToPWMRegFormat(int val, unsigned char *data);
    void PWMRegFormatToDec(unsigned char data[], int* decimal);

    int     m_oscilatorType;
    double  m_oscillatorValue;
    int     m_frequencyPreInit;
    int     m_countChannelsToPool;
};

#endif // PWMPCA9685_H
