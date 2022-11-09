#include "ParticleCounterZH03B.h"

//RESPONSE_TIME
#define ECM_TRANS_RESPONSE_TIME                     1500 //ms
#define ECM_TRANS_RESPONSE_TIME_EACH_BUFFER         200 //ms

ParticleCounterZH03B::ParticleCounterZH03B(QObject *parent) : ClassDriver(parent)
{

}

void ParticleCounterZH03B::setSerialComm(QSerialPort *serial)
{
    serialComm = serial;
}

int ParticleCounterZH03B::setCommunicationMode(int mode)
{
    if(mode){
        return setQA();
    }
    else {
        return setStream();
    }
}

/**
 * @brief ParticleCounterZH03B::setQA
 * Set ZH03B Question and Answer Code
 *
 * @return
 */
int ParticleCounterZH03B::setQA()
{
    qDebug() << metaObject()->className() << __func__;
    if (!isPortValid()) return -1;

    uchar cmd[] = {0xFF, 0x01, 0x78, 0x41, 0x00, 0x00, 0x00, 0x00, 0x46};

    serialComm->clear();
    serialComm->write(reinterpret_cast<char*>(cmd), sizeof(cmd));
    //    serialComm->write(QByteArray("\xFF\x01\x78\x41\x00\x00\x00\x46", 8));
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
    }else return -1;
    return 0;
}

/**
 * @brief ParticleCounterZH03B::setStream
 * Set to default streaming mode of readings
 *
 * @return
 */
int ParticleCounterZH03B::setStream()
{
    qDebug() << metaObject()->className() << __func__;
    if (!isPortValid()) return -1;

    uchar cmd[] = {0xFF, 0x01, 0x78, 0x40, 0x00, 0x00, 0x00, 0x00, 0x47};
    serialComm->clear();
    serialComm->write(reinterpret_cast<char*>(cmd), sizeof(cmd));
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
    }else return -1;
    return 0;
}

/**
 * @brief ParticleCounterZH03B::setDormantMode
 * @param powerStatus
 * @return
 *
 * It's required warming up about 10 second after before sensor read stable
 * Check the datasheet
 */
int ParticleCounterZH03B::setDormantMode(int powerStatus)
{
    qDebug() << metaObject()->className() << __func__ << powerStatus;
    if (!isPortValid()) return -1;

    serialComm->flush();

    if(!powerStatus){
        uchar cmd[] = {0xFF, 0x01, 0xA7, 0x01, 0x00, 0x00, 0x00, 0x00, 0x57};

        serialComm->write(reinterpret_cast<char*>(cmd), sizeof (cmd));
        if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
            /// Still not success to understand response from sensor
            /// so, for this version we assume the command will always success executed on the sendor

            /// remeber the latest dormand mode as a fan state
            if(m_dormanModeSleepRunBuffer != powerStatus){
                m_dormanModeSleepRunBuffer = powerStatus;
            }


            //            if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            //                QByteArray response;
            //                for(int i=0; i < 3; i++){
            //                    qDebug() << metaObject()->className() << __func__ << "read";
            //                    while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
            //                        response.push_back(serialComm->read(1));
            //                        printf("%02X ", static_cast<uchar>(response.back()));
            //                        fflush(stdout);
            //                    }
            //                }

            //                qDebug() << metaObject()->className() << __func__ << "responses: ";
            //                for (int i=0; i<response.length(); i++) {
            //                    printf("%02X ", static_cast<uchar>(response.at(i)));
            //                    fflush(stdout);
            //                }
            //                printf("\n");
            //                fflush(stdout);

            //                QByteArray fanCommandOK("\xff\xa7\x01", 3);
            //                if(response == fanCommandOK){
            //                    serialComm->flush();
            //                }
            //                else return -3;
            //            }else return -2;
        }else return -1;
    }
    else {
        uchar cmd[] = {0xFF, 0x01, 0xA7, 0x00, 0x00, 0x00, 0x00, 0x00, 0x58};
        //        qDebug() << cmd << sizeof (cmd);
        serialComm->write(reinterpret_cast<char*>(cmd), sizeof (cmd));
        if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
            /// Still not success to understand response from sensor
            /// so, for this version we assume the command will always success executed on the sendor

            /// remeber the latest dormand mode as a fan state
            if(m_dormanModeSleepRunBuffer != powerStatus){
                m_dormanModeSleepRunBuffer = powerStatus;
            }

            //            if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            //                QByteArray response;
            //                for(int i=0; i < 3; i++){
            //                    qDebug() << metaObject()->className() << __func__ << "read";
            //                    while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
            //                        response.push_back(serialComm->read(1));
            //                        printf("%02X ", static_cast<uchar>(response.back()));
            //                        fflush(stdout);
            //                    }
            //                }


            //                qDebug() << metaObject()->className() << __func__;
            //                for (int i=0; i<response.length(); i++) {
            //                    printf("%02X ", static_cast<uchar>(response.at(i)));
            //                }
            //                printf("\n");
            //                fflush(stdout);

            //                QByteArray fanCommandOK("\xff\xa7\x01", 3);
            //                if(response == fanCommandOK){
            //                    serialComm->flush();
            //                }
            //                else return -3;
            //            }else return -2;
        }else return -1;
    }
    return 0;
}

/**
 * @brief ParticleCounterZH03B::getQAReadSample
 * @param pm1
 * @param pm2_5
 * @param pm10
 * @return
 *
 * Q&A mode requires a command to obtain a reading sample
 * example response
 * starting, command, pm2_5h, pm2_5l, pm10h, pm10l, pm1h, pm1l, check
 * 0xFF 0x86 0x00 0x85 0x00 0x96 0x00 0x65 0xFA
 */
int ParticleCounterZH03B::getQAReadSample(int *pm1, int *pm2_5, int *pm10)
{
    //qDebug() << metaObject()->className() << __func__;
    if (!isPortValid()){
        qDebug() << "port doesnt valid";
        return -1;
    }

    serialComm->clear();

    uchar cmd[] = {0xFF, 0x01, 0x86, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79};

    serialComm->write(reinterpret_cast<char*>(cmd), sizeof(cmd));
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            //            uchar data[] = {0xFF, 0x86, 0x00, 0x47, 0x00, 0xC7, 0x03, 0x0F, 0x5A}; // for testing
            QByteArray response;
            uint checksum = 0;

            for (int i=0; i<9 ; i++) {
                serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER);
                response.push_back(serialComm->read(1));
                // response.push_back(data[i]); // for testing
                // if(!response.isEmpty()) checksum |= (uint)response.back();
            }

            //qDebug() << metaObject()->className() << __func__ << "response" << response << response.length();
            for (int i=0; i<response.length(); i++) {
                printf("%02X ", static_cast<uchar>(response.at(i)));
                fflush(stdout);
            }
            printf("\n");
            fflush(stdout);

            enum qaResponseLength {COMMON_RESPONSE_BYTE_LENGTH = 9};
            enum frameSeq{starting, command, pm2_5h, pm2_5l, pm10h, pm10l, pm1h, pm1l, check};

            if(response.length() == COMMON_RESPONSE_BYTE_LENGTH){
                if(((uchar)response.at(starting) == 0xFF) && ((uchar)response.at(command) == 0x86)){

                    //
                    for (int i=1; i<(response.length()-1); i++) {
                        checksum += (response.at(i) & 0xff);
                        //printf("%02X ", static_cast<uchar>(response.at(i)));
                        //qDebug() << i << ((uint16_t)response.at(i) & 0xff);
                        //fflush(stdout);
                    }

                    //qDebug() << metaObject()->className() << "checksum" << (uint16_t)checksum << (uint)response.back();

                    //checksum &= ~(uint)response.back();
                    checksum &= 0xff; //Keep low 8 bits only
                    checksum = ~checksum; //Negation
                    checksum += 1; //Plus 1
                    checksum &= 0xff; //Keep low 8 bits only

                    qDebug() << metaObject()->className() << "checksum" << checksum << (uint)response.back();

                    if(checksum == (uint)response.back()){
                        /// Process the data
                        *pm2_5  = (uint)((response[pm2_5h] << 8) | response[pm2_5l]);
                        *pm1    = (uint)((response[pm1h] << 8) | response[pm1l]);
                        *pm10   = (uint)((response[pm10h] << 8) | response[pm10l]);

                        //                        qDebug() << metaObject()->className() << __func__ << "pm2_5" << *pm2_5 << "pm1" << *pm1 << "pm10" << *pm10;
                    }else return -6;
                }else return -5;
            }else return -3;
        }else return -2;
    }else return -1;

    serialComm->clear();
    return 0;
}

/**
 * @brief ParticleCounterZH03B::getReadSample
 * @param pm1
 * @param pm2_5
 * @param pm10
 * @return
 * Read from stream read
 * example resposnse 42 4D 00 14 00 54 00 6E 00 7C 00 54 00 6E 00 7C 00 00 00 00 00 00 03 1F
 *
 * not tested yet, latest state this function generate error out of range (10/07/2021)
 */
int ParticleCounterZH03B::getReadSample(int *pm1, int *pm2_5, int *pm10)
{
    qDebug() << metaObject()->className() << __func__;
    return -1;

    Q_UNUSED(pm1)
    Q_UNUSED(pm2_5)
    Q_UNUSED(pm10)


    //    serialComm->flush();
    //    serialComm->clear();

    //    if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

    //        int checksumSum = 0;
    //        QByteArray response;
    //        for (int i=0; i<2 ; i++) {
    //            response.push_back(serialComm->read(1));
    //            checksumSum += response.back();
    //        }

    //        qDebug() << metaObject()->className() << __func__ << "starting";
    //        for (int i=0; i<response.length(); i++) {
    //            printf("%02X ", static_cast<uchar>(response.at(i)));
    //        }
    //        printf("\n");
    //        fflush(stdout);

    //        if(response == QByteArray("\x42\x4D", 2)){

    //            for (int i=0; i<20 ; i++) {
    //                response.push_back(serialComm->read(1));
    //                checksumSum += response.back();
    //            }

    //            qDebug() << metaObject()->className() << __func__ << "starting and data";
    //            for (int i=0; i<response.length(); i++) {
    //                printf("%02X ", static_cast<uchar>(response.at(i)));
    //            }
    //            printf("\n");
    //            fflush(stdout);

    //            int checksumSensorSum = 0;
    //            QByteArray checksumSensor;
    //            for (int i=0; i<2 ; i++) {
    //                checksumSensor += serialComm->read(1);
    //                checksumSensorSum += checksumSensor.back();
    //            }

    //            qDebug() << metaObject()->className() << __func__;
    //            for (int i=0; i<response.length(); i++) {
    //                printf("%02X ", static_cast<uchar>(checksumSensor.at(i)));
    //            }
    //            printf("\n");
    //            fflush(stdout);
    //            qDebug() << metaObject()->className() << __func__ << "checksum" << checksumSensorSum << checksumSum;

    //            if(checksumSensorSum == checksumSum){
    //                /// Process the data
    //                enum frameSeq{pm1h = 10, pm1l, pm2_5h, pm2_5l, pm10h, pm10l};

    //                *pm2_5 = (response[pm2_5h] << 8) | response[pm2_5l];
    //                *pm1 = (response[pm1h] << 8) | response[pm1l];
    //                *pm10 = (response[pm10h] << 8) | response[pm10l];

    //                qDebug() << metaObject()->className() << __func__ << "pm2_5" << pm2_5 << "pm1" << pm1 << "pm10" << pm10;
    //            }else return -3;
    //        }else return -2;
    //    }else return -1;
    //    return 0;

}

/**
 * @brief ParticleCounterZH03B::getFanStateLastRemember
 * @return
 *
 * This is not actual state from the fan in the sensor
 * I'm still have limited knowadgle to communication with sensor how to detemine thw actual stat of the fan
 * So this is just for rescue, it will remember from ParticleCounterZH03B::setDormantMode(int powerStatus)
 */
bool ParticleCounterZH03B::getFanStateBuffer() const
{
    return m_dormanModeSleepRunBuffer;
}

bool ParticleCounterZH03B::openPort()
{
    serialComm->close();
    serialComm->open(QIODevice::ReadWrite);
    if(!serialComm->isOpen()){
        return false;
    }
    return true;
}

bool ParticleCounterZH03B::isPortValid() const
{
    if (serialComm != nullptr) {
        if(serialComm->isOpen()) {
            return true;
        }
    }
    return false;
}
