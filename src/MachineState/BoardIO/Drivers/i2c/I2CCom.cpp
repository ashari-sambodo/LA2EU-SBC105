#include "I2CCom.h"

using namespace std;

/**
 * @brief i2cCom::i2cCom
 * @param parent
 */
I2CCom::I2CCom()
{
    port_number     = -1;
    path_i2c_port   = -1;
}

I2CCom::~I2CCom()
{
    closePort();
}

/**
 * @brief i2cCom::set_port_number
 * @param port
 * @return new value of port number
 */
int I2CCom::setPortNumber(const int port)
{
    //    qDebug() << "i2cCom-set_port_number "<< port;
    port_number = port;
    return port_number;
}
/**
 * @brief i2cCom::open
 * @return
 */
int I2CCom::openPort()
{
    if(port_number < 0)
    {
        return -1;
    }
    char port_path[50];
    snprintf(port_path, 50, "/dev/i2c-%d", port_number);
    if ((path_i2c_port = open(port_path, O_RDWR)) < 0) {
        return -2;
    }

    return 0;
}
/**
 * @brief i2cCom::close_port
 * @return
 */
int I2CCom::closePort()
{
    if(port_number < 0) return 0;
    close(path_i2c_port);
    return 0;
}
/**
 * @brief i2cCom::write_data
 * @param byte is sequence data want to send over i2c
 * @return
 */
int I2CCom::writeData(std::vector<unsigned char> &byte)
{
    //post must opened before
    if(path_i2c_port < 0)
    {
        return -1;
    }

    //set i2c slave address target
#ifdef __arm__
    unsigned char addr = byte[Command::ADDR];
    if(ioctl(path_i2c_port, I2C_SLAVE, addr) < 0)
    {
        return -2;
    }
#endif
    if(byte[Command::WOFFSET] == 1)
    {
        //if this not simple communication, dont remove offset byte
        byte.erase(byte.begin(), byte.begin() + Command::COUNT + 1);
    }
    else
    {
        //if this simple communication, remove offset byte
        byte.erase(byte.begin(), byte.begin()+Command::OFFSET + 1);
    }

#ifdef __arm__
    int count = byte.size();
    if(write(path_i2c_port, byte.data(), count) != count)
    {
        return -3;
    }
#endif
    //    printf("i2cCom-write_data:  0x%x", (unsigned char) addr);
    //    fflush(stdout);
    //    for (int i = 0; i < (int) byte.size(); i++) {
    //        printf(" 0x%x", (unsigned int) byte[i]);
    //        fflush(stdout);
    //    }
    //    printf("\n");
    //    fflush(stdout);
    return 0;
}

/**
 * @brief i2cCom::read_data
 * @param byte
 * @param receive
 * @return
 */
int I2CCom::readData(std::vector<unsigned char> &byte, std::vector<unsigned char> &receive)
{
    //post must opened before
    if(path_i2c_port < 0)
    {
        return -1;
    }

    //set i2c slave address target
#ifdef __arm__
    unsigned char addr = byte[Command::ADDR];
    if(ioctl(path_i2c_port, I2C_SLAVE, addr) < 0)
    {
        return -2;
    }

    //read with offset
    if (byte[Command::WOFFSET] == 1) {
        //first write offset to i2c
        if (write(path_i2c_port, &byte[Command::OFFSET], 1) != 1) {
            //            printf("i2cCom-read_data: Failed set offset Address  0x%x\n", (unsigned char) addr);
            //            fflush(stdout);
            return -3;
        }
    }
#endif
    unsigned char count = byte[Command::COUNT];
    unsigned char buffer_receive[count];
#ifdef __arm__
    if (read(path_i2c_port, buffer_receive, count) != count) {
        //        printf("i2cCom-read_data: Failed to receive data from 0x%x", (unsigned int) addr);
        //        fflush(stdout);
        return -4;
    }
#endif
    receive.clear();
    receive.assign(buffer_receive, buffer_receive + count);

    //    //check receive data
    //    printf("i2cCom-read_data: ");
    //    fflush(stdout);
    //    for (int i = 0; i < count; i++) {
    //        printf(" 0x%x", (unsigned int) receive[i]);
    //        fflush(stdout);
    //    }
    //    printf("\n");
    //    fflush(stdout);
    return 0;
}

/**
 * @brief I2cCom::generate_frame
 * @param operation : 1=read 0=write
 * @param address   : address for slave
 * @param woffset   : indetified this communication have offset or not
 * @param count     : how many data want to send/get exclude config frame
 * @param offset    : value of offset
 * @param result    : result frame command
 */
void I2CCom::generateFrame(
        unsigned char operation,
        unsigned char address,
        unsigned char woffset,
        unsigned char count,
        unsigned char offset,
        std::vector<unsigned char> &result)
{
    result.clear();
    result.push_back(operation);
    result.push_back(address);
    result.push_back(woffset);
    result.push_back(count);
    result.push_back(offset);
}

void I2CCom::addOutQueue(std::vector<unsigned char> byte)
{
    QMutexLocker locker(&mutex);
    out_queue.push(byte);
}

void I2CCom::sendOutQueue(/*std::vector<unsigned char> &addr_failed, */int count)
{
    int size;
    {
        QMutexLocker locker(&mutex);
        size = static_cast<int>(out_queue.size());
    }
    if(count == -1) count = size;
    //    qDebug() << "I2cCom::send_out_queue size: "<< size;

    for(int i=0; i < count;i++){
        vector<unsigned char> message;
        {
            QMutexLocker locker(&mutex);
            message = out_queue.front();
            out_queue.pop();
        }
        int result_comm = -1;
        int retry = 0;

        if(message[Command::RW] == I2C_CMD_OPERATION_WRITE)
        {
            //do communication
            do{
                result_comm = writeData(message);
                retry++;
            }while((retry < 2) && (result_comm < 0));
        }
        else
        {
            //dummy buffer received
            vector<unsigned char> dummy;
            //do communication
            do{
                result_comm = readData(message, dummy);
                retry++;
            }while((retry < 2) && (result_comm < 0));
        }
        //        //tell which address to commucation failed
        //        if(result_comm < 0) addr_failed.push_back(message[Command::ADDR]);
    }
}
