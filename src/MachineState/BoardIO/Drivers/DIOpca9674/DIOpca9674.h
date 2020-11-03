#ifndef DIPCA9674_H
#define DIPCA9674_H

#include "../i2c/I2CPort.h"
#include "../ClassDriver.h"

class DIOpca9674 : public ClassDriver
{
    Q_OBJECT
public:
    DIOpca9674(QObject *parent = nullptr);
    void setAsIO(unsigned char input_output);
    int testComm();
    int init();
    int polling();
    void clearRegBuffer();

    int getStateIO(int channel, unsigned char *result);

    int updateRegBuffer(void);
    int getRegBufferStateIO(int channel);

    enum DIOpca9674_DIRECTION{
        DIOpca9674_DIRECTION_INPUT,
        DIOpca9674_DIRECTION_OUTPUT
    };

private:
    int direction;

    enum DIOpca9674_REG{
        IO_VALUE
    };
};

#endif // DIPCA9674_H
