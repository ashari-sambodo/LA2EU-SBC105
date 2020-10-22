#ifndef I2CCOM_H
#define I2CCOM_H

#include <QObject>
#include <QMutex>
#include <queue>
#include <QMutexLocker>
#ifdef __linux__
#include <sys/ioctl.h>
#include <linux/i2c-dev.h>
#endif
#include <unistd.h>
#include <fcntl.h>

class I2CCom
{
public:
    I2CCom();
    virtual ~I2CCom();
    int setPortNumber(const int port);
    int openPort();
    int closePort();
    int writeData(std::vector<unsigned char> &byte);
    int readData(std::vector<unsigned char> &byte, std::vector<unsigned char>& receive);
    void generateFrame(unsigned char operation,
                        unsigned char address,
                        unsigned char woffset,
                        unsigned char count,
                        unsigned char offset,
                        std::vector<unsigned char>& result);

    enum I2C_CMD_OPERATION{
        I2C_CMD_OPERATION_WRITE,
        I2C_CMD_OPERATION_READ
    };

    enum I2C_SEND_MODE{
        I2C_SEND_MODE_DIRECT,
        I2C_SEND_MODE_BUFFER
    };

    enum I2C_RESPONSE_STATUS{
        I2C_COMM_RESPONSE_ERROR = -1,
        I2C_COMM_RESPONSE_OK,
    };

    void addOutQueue(std::vector<unsigned char> byte);
    void sendOutQueue(/*std::vector<unsigned char> *addr_failed = nullptr,*/ int count = -1);

private:
    int port_number;
    int path_i2c_port;
    enum Command {
        RW,
        ADDR,
        WOFFSET,
        COUNT,
        OFFSET
    };

    QMutex mutex;
    std::queue<std::vector<unsigned char>> out_queue;

};

#endif // I2CCOM_H
