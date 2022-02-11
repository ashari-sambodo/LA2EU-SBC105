#ifndef LEDPCA9633_H
#define LEDPCA9633_H

#include "../i2c/I2CPort.h"
#include "../../Drivers/ClassDriver.h"

class LEDpca9633 : public ClassDriver
{
    Q_OBJECT
public:
    explicit LEDpca9633(QObject *parent = nullptr);

    enum LEDPCA9633_LEDOUT{
        LEDPCA9633_LEDOUT_OFF,
        LEDPCA9633_LEDOUT_ON,
        LEDPCA9633_LEDOUT_PWM,
        LEDPCA9633_LEDOUT_PWM_GROUP
    };

    int init();
    int testComm();
    int polling();

    int setOutputPWM(uchar pin, int duty, bool toBuffer = false);
    int setOutputAsPWM(uchar pin, bool toBuffer = false);
    int setOutputAsPWMGroup(uchar pin, bool toBuffer = false);
    int setOutputAsDigital(uchar pin, bool state, bool toBuffer = false);

    int getMode1(uchar &mode);
    int getOutputState(uchar pin, uchar &state);
    int getOutputPWM(uchar pin, int &value);
    int getRegisters();

    void getRegBuffer_mode1(uchar &mode);
    void getRegBuffer_outputState(uchar pin, uchar &state);
    void getRegBuffer_outputPWM(uchar pin, int &value);

private:

};

/* The PCA9633 is an I2C-bus controlled 4-bit LED driver optimized for
Red/Green/Blue/Amber (RGBA) color mixing applications. Each LED output has its own
8-bit resolution (256 steps) fixed frequency Individual PWM controller that operates at
97 kHz with a duty cycle that is adjustable from 0 % to 99.6 % to allow the LED to be set
to a specific brightness value. A fifth 8-bit resolution (256 steps) Group PWM controller
has both a fixed frequency of 190 Hz and an adjustable frequency between 24 Hz to once
every 10.73 seconds with a duty cycle that is adjustable from 0 % to 99.6 % that is used to
either dim or blink all LEDs with the same value.
Each LED output can be off, on (no PWM control), set at its Individual PWM controller
value or at both Individual and Group PWM controller values. The LED output driver is
programmed to be either open-drain with a 25 mA current sink capability at 5 V or totem
pole with a 25 mA sink, 10 mA source capability at 5 V. The PCA9633 operates with a
supply voltage range of 2.3 V to 5.5 V and the outputs are 5.5 V tolerant. LEDs can be
directly connected to the LED output (up to 25 mA, 5.5 V) or controlled with external
drivers and a minimum amount of discrete components for larger current or higher voltage
LEDs.
The PCA9633 is one of the first LED controller devices in a new Fast-mode Plus (Fm+)
family. Fm+ devices offer higher frequency (up to 1 MHz) and more densely populated bus
operation (up to 4000 pF).
The active LOW Output Enable input pin (OE) allows asynchronous control of the LED
outputs and can be used to set all the outputs to a defined I2C-bus programmable logic
state. The OE can also be used to externally PWM the outputs, which is useful when
multiple devices need to be dimmed or blinked together using software control. This
feature is available for the 16-pin version only.
Software programmable LED Group and three Sub Call I2C addresses allow all or defined
groups of PCA9633 devices to respond to a common I2C address, allowing for example,
all red LEDs to be turned on or off at the same time or marquee chasing effect, thus
minimizing I2C-bus commands.
The PCA9633 is offered with 3 different I2C-bus address options: fixed I2C-bus address
(8-pin version), 4 different I2C-bus addresses from 2 programmable address pins (10-pin
version), and 126 different I2C-bus addresses from 7 programmable address pins (16-pin
version). They are software identical except for the different number of address
combinations.
The Software Reset (SWRST) Call allows the master to perform a reset of the PCA9633
through the I2C-bus, identical to the Power-On Reset (POR) that initializes the registers to
their default state causing the outputs to be set HIGH (LED off). This allows an easy and
quick way to reconfigure all device registers to the same condition.
*/

#endif // LEDPCA9633_H
