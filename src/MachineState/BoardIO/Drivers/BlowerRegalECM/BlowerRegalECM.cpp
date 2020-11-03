#include <cmath>
#include "BlowerRegalECM.h"

#define ECM_CMD_REQ_DEMAND_RDM          0x45
#define ECM_CMD_REQ_TORQUE_RTQ          0x54
#define ECM_CMD_REQ_FW_VER_RFV          0x55
#define ECM_CMD_REQ_PR_VER_RPV          0x56
#define ECM_CMD_REQ_HISTORY_RHIS        0x48
#define ECM_CMD_REQ_CTRL_REV_RERV       0x49
#define ECM_CMD_REQ_CTRL_TYPE_RETP      0x4A
#define ECM_CMD_REQ_SERNUM_RSER         0x4E
#define ECM_CMD_REQ_SPEED_RSPD          0x53
#define ECM_CMD_REQ_STATUS_RSTA         0x59
#define ECM_CMD_REQ_STATUS2_RSTA2       0x5C
#define ECM_CMD_REQ_VOLT_MEA_RVO        0x57
#define ECM_CMD_REQ_SHAFT_PWR_RPWR      0x5A
#define ECM_CMD_REQ_CTRL_TEMP_RM     0x5B
#define ECM_CMD_SET_AF_DEMAND_SCFM      0x44
#define ECM_CMD_SET_SPEED_DEMAND_SSPD   0x4F
#define ECM_CMD_SET_MAX_CFM_SSCL        0x4D
#define ECM_CMD_SET_ROTATION_SDIR       0x52
#define ECM_CMD_SET_SLEW_RATE_SRAT      0x46
#define ECM_CMD_SET_BLOWER_CONST_SCON   0x41
#define ECM_CMD_SET_CUTBACK_SLOPE_SLP   0x50
#define ECM_CMD_SET_SPEED_LIMIT_SLIM    0x4C
#define ECM_CMD_SET_TORQUE_STQ          0x28
#define ECM_CMD_SET_BRAKE_SBRK          0x42
#define ECM_CMD_SET_SPEED_LOOP_SPDK     0x4B
#define ECM_CMD_START_MOTOR_GO          0x47
#define ECM_CMD_STOP_MOTOR_STOP         0x51
#define ECM_CMD_SET_ADDR_SETA           0x58
#define ECM_CMD_SET_ADDR_COND_ENUM      0x43
#define ECM_CMD_REQ_BB_INFO_RBKBX       0x5D
#define ECM_CMD_READ_EE_WORD_REEWD      0x70
#define ECM_CMD_WRITE_EE_WORD_SWEWD     0x71
#define ECM_CMD_READ_EE_PAGE_REEPG      0x72
#define ECM_CMD_WRITE_EE_PAGE_SEEPG     0x73
#define ECM_CMD_READ_EE_KEY_REEKEY      0x74
#define ECM_CMD_WRITE_EE_KEY_SEEKEY     0x75

#define ECM_MISC_CARRIAGE_RETURN_CR     0x0D
#define ECM_MISC_ACKNOWLEDGE_ACK        0x6B
#define ECM_MISC_ERROR_RESPONSE_ERR     0x21

#define ECM_DEVCODE_OUTDOOR_FAN_ODF     0x40
#define ECM_DEVCODE_DRAFT_INDUCER_DFI   0x50
#define ECM_DEVCODE_BLOWER_BLW          0x60
#define ECM_DEVCODE_ALL_DEVICE_ALL      0x70

#define ECM_MCAT_COMMAND_CM             0x01
#define ECM_MCAT_COMMAND_RES_CS         0x02
#define ECM_MCAT_REPPLY_RP              0x04
#define ECM_MCAT_REPPLY_RPX             0x0C

#define ECM_ERR_OPERAND_OUT_RNG         0x5E
#define ECM_ERR_BUFFER_FULL_XOF         0x58
#define ECM_ERR_BUFFER_OVERRUN_OFLO     0x4F
#define ECM_ERR_OPERAND_OUT             0x5E

#define ECM_PREAMBLE_BLOWER             0x61

#define ECM_BB_DECODE_VAL_MULTIPLY          29.82605
#define ECM_BB_ID_TOTAL_POWER_TIME          0
#define ECM_BB_ID_TOTAL_RUN_TIME            1
#define ECM_BB_ID_TOTAL_RUN_TIME_OVER       2
#define ECM_BB_ID_TOTAL_RUN_TIME_CUTBACK    3
#define ECM_BB_ID_TOTAL_GOOD_START          4
#define ECM_BB_ID_TEMPERATURE               5

//RESPONSE_TIME
#define ECM_TRANS_RESPONSE_TIME                     200 //ms
#define ECM_TRANS_RESPONSE_TIME_EACH_BUFFER         50 //ms

BlowerRegalECM::BlowerRegalECM(QObject *parent)
    : ClassDriver (parent)
{
    m_address           = 0;
    m_protocolVersion   = 2;
    serialComm          = nullptr;
}

BlowerRegalECM::~BlowerRegalECM()
{

}

void BlowerRegalECM::setSerialComm(QSerialPort *serial)
{
    serialComm = serial;
}

int BlowerRegalECM::getFirmwareVersion(QString &versionStr)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    //    cmd.push_back(0x61);
    //    cmd.push_back(0x08);
    //    cmd.push_back(0x02);
    //    cmd.push_back(0x01);
    //    cmd.push_back(0x55);
    //    cmd.push_back(0xDC);
    //    cmd.push_back(0x62);
    //    cmd.push_back(0x0D);
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(8);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);

    cmd.append(ECM_CMD_REQ_FW_VER_RFV);

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    //    printf("BlowerRegalECM::getFirmwareVersion Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", static_cast<uchar>(cmd.at(i)));
    //    }
    //    printf("\n");

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            //            printf("BlowerRegalECM::getFirmwareVersion Response - byte: ");
            //            for (int i=0; i<response.length(); i++) {
            //                printf("%02X ", static_cast<uchar>(response.at(i)));
            //            }
            //            printf("\n");

            if(response.length() == 14){
                if(isChecksumValid(response)){
                    versionStr.append(response.at(5));
                    versionStr.append(response.at(6));
                    versionStr.append(".");
                    versionStr.append(response.at(7));
                    versionStr.append(response.at(8));
                    versionStr.append(".");
                    versionStr.append(response.at(9));
                    versionStr.append(response.at(10));
                }else return -6;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){
                    return -5;
                }else return -4;
            }else return -3;
        }else return -2;
    }else return -1;
    return 0;
}

int BlowerRegalECM::getProgramVersion(int *pversion)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(8);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);

    cmd.append(ECM_CMD_REQ_PR_VER_RPV);

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            if(response.length() == 9){
                if(isChecksumValid(response)){
                    *pversion = response[5]; //byte 5th is a program version
                }else return -1;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){

                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

int BlowerRegalECM::getECMControlRev(int *ctrlrev)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(8);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);

    cmd.append(ECM_CMD_REQ_CTRL_REV_RERV);

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            if(response.length() == 10){
                if(isChecksumValid(response)){
                    *ctrlrev = response[6]; //byte 6th is a control version
                }else return -1;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){
                    return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

int BlowerRegalECM::getECMControlType(int *ctrltype)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(8);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);

    cmd.append(ECM_CMD_REQ_CTRL_TYPE_RETP);

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            if(response.length() == 10){
                if(isChecksumValid(response)){
                    *ctrltype = response[5]; //byte 6th is a control type
                }else return -1;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){
                    return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

/**
 * @brief BlowerRegalECM::getECMSerialNumber
 * @return status of transaction
 *
 * Lable serial number is printed base 36
 */
int BlowerRegalECM::getECMSerialNumber(int *serialNumber)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(8);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);

    cmd.append(ECM_CMD_REQ_SERNUM_RSER);

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            if(response.length() == 12){
                if(isChecksumValid(response)){
                    int serialNumber1 = (response[5] << 8) | response[8];
                    int serialNumber2 = (response[6] << 8) | response[7];
                    *serialNumber = (serialNumber1 << 16) | serialNumber2;

                    //                    printf("BlowerRegalECM::getECMSerialNumber serialNumber1: %d", serialNumber1);
                    //                    printf("BlowerRegalECM::getECMSerialNumber serialNumber2: %d", serialNumber2);
                    //                    printf("BlowerRegalECM::getECMSerialNumber serialNumber: %d", *serialNumber);
                }else return -1;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){
                    return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

/**
 * @brief BlowerRegalECM::getSpeed
 * @return
 * RPM = Speed Decimal / 22 (if device code is ODF:OUTDOOR_FAN or BLWR:BLOWER)
 * RPM = Speed Decimal (if devide code is IDF:DRAFT_INDUCER)
 */
int BlowerRegalECM::getSpeed(int *rpm)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(8);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);

    cmd.append(ECM_CMD_REQ_SPEED_RSPD);

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            if(response.length() == 10){
                if(isChecksumValid(response)){
                    int speed = (response[6] << 8) | response[5];
                    int speedRPM = speed / 22;
                    *rpm = speedRPM;

                    //                    printf("BlowerRegalECM::getSpeed speedRPM: %d\n", speedRPM);
                    //                    fflush(stdout);
                }else return -1;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){
                    return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

int BlowerRegalECM::getDemand(int * demand)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(8);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);

    cmd.append(ECM_CMD_REQ_DEMAND_RDM);

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    //    printf("BlowerRegalECM::getDemand Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", cmd.at(i));
    //    }
    //    printf("\n");

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            //            printf("BlowerRegalECM::getDemand Response - byte: ");
            //            for (int i=0; i<response.length(); i++) {
            //                printf("%02X ", response.at(i));
            //            }
            //            printf("\n");

            if(response.length() == 10){
                if(isChecksumValid(response)){
                    *demand = (response[6] << 8) | response[5];

                    //                    printf("BlowerRegalECM::getECMSerialNumber demand: %d\n", *demand);
                    //                    fflush(stdout);

                }else return -6;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){
                    return -5;
                }else return -4;
            }else return -3;
        }else return -2;
    }else return -1;
    return 0;
}

/**
 * @brief BlowerRegalECM::getVoltage
 * @param voltage
 * @return
 *
 * Voltage response optional for device codes other than DFI
 */
int BlowerRegalECM::getVoltage(int *voltage)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(8);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);

    cmd.append(ECM_CMD_REQ_VOLT_MEA_RVO);

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    //    printf("BlowerRegalECM::getVoltage Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", cmd.at(i));
    //    }
    //    printf("\n");

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            //            printf("BlowerRegalECM::getVoltage Response - byte: ");
            //            for (int i=0; i<response.length(); i++) {
            //                printf("%02X ", response.at(i));
            //            }
            //            printf("\n");

            if(response.length() == 10){
                if(isChecksumValid(response)){
                    *voltage = (response[6] << 8) | response[5];

                    //                    printf("BlowerRegalECM::getVoltage voltage: %d", *voltage);
                    //                    fflush(stdout);
                }else return -1;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){
                    return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

/**
 * @brief BlowerRegalECM::getStatusByte
 * @param otmp  = Control Temeprature above threshold
 * @param ramp  = Airflow demmand is moving toward objective
 * @param start = Start procedure active
 * @param run   = Start successful and above stall speed
 * @param cutbk = Speed is above programmed linit
 * @param stall = start procedure failed or speed too low, Rest by transition to Run or Stop
 * @param ras   = Risk Addressed State UL (UL related check fault) Motor locked-out
 * @param brake = Motor brake is active
 * @return
 */
int BlowerRegalECM::getStatusByte(int *otmp, int *ramp, int *start, int *run, int *cutbk, int *stall, int *ras, int *brake)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(8);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);

    cmd.append(ECM_CMD_REQ_STATUS_RSTA);

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            if(response.length() == 9){
                if(isChecksumValid(response)){
                    int status = response[5];

                    *brake  = status >> 7;
                    *ras    = (status & 0b01000000) >> 6;
                    *stall  = (status & 0b00100000) >> 5;
                    *cutbk  = (status & 0b00010000) >> 4;
                    *run    = (status & 0b00001000) >> 3;
                    *start  = (status & 0b00000100) >> 2;
                    *ramp   = (status & 0b00000010) >> 1;
                    *otmp   = status & 0b00000001;

                    //                    printf("BlowerRegalECM::getStatusByte "
                    //                           "brake: %d - ras: %d - stall: %d - "
                    //                           "cutbk: %d - run: %d - start: %d - "
                    //                           "ramp: %d - otmp: %d", *brake, *ras, *stall, *cutbk, *run, *start, *ramp, *otmp);
                }else return -1;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){
                    return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

/**
 * @brief BlowerRegalECM::getStatusAdditionalInfo
 * @param rbc               = Bit0-Bit9 RBC internal status codes
 * @param brownout          = Brownout - Supply voltage too low
 * @param osc               = Running on internal oscilator
 * @param reverseRotation   = Reverse rotation detected
 * @return
 */
int BlowerRegalECM::getStatusAdditionalInfo(int *rbc, int *brownout, int *osc, int *reverseRotation)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(8);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);

    cmd.append(ECM_CMD_REQ_STATUS2_RSTA2);

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            if(response.length() == 10){
                if(isChecksumValid(response)){
                    int status = (response[6] << 8) | response[5];

                    *rbc                = status & 0b0000001111111111;
                    *brownout           = (status & 0b0010000000000000) >> 13;
                    *osc                = (status & 0b0100000000000000) >> 14;
                    *reverseRotation    = (status & 0b1000000000000000) >> 15;

                    //                    printf("BlowerRegalECM::getStatusAdditionalInfo "
                    //                           "rbc: %d - brownout: %d - osc: %d - reverseRotation: %d", *rbc, *brownout, *osc, *reverseRotation);

                }else return -1;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){
                    return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}
/**
 * @brief BlowerRegalECM::getHistory
 * @param powerLevel
 * 0    = Unconfigured
 * 1    = Regal-Beloit Corporation
 * 2    = T.B.D
 * 3    = T.B.D
 * 4-E  = T.B.D
 * @param motorMode
 * 0    = Unconfigured
 * 1    = T.B.D
 * 2    = 1/4 HP
 * 3    = 1/3 HP
 * 4    = 1/2 HP
 * 5    = 3/4 HP
 * 6    = 1 HP
 * 7    = T.B.D
 * 8    = T.B.D
 * 9    = T.B.D
 * A    = T.B.D
 * B-E  = T.B.D
 * @return
 */
int BlowerRegalECM::getHistory(int *powerLevel, int *mfrMode)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(8);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);

    cmd.append(ECM_CMD_REQ_HISTORY_RHIS);

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            if(response.length() == 10){
                if(isChecksumValid(response)){
                    int history = response[5];

                    *powerLevel     = history >> 4;
                    *mfrMode      = history & 0b00001111;

                    //                    printf("BlowerRegalECM::getHistory "
                    //                           "powerLevel: %d - motorMode: %d", *powerLevel, *mfrMode);

                }else return -1;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){
                    return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

/**
 * @brief BlowerRegalECM::gatShaftPower
 * @param shaftPower
 * @return
 *
 * Power = 23100 is 100% rated shaft power, rated at 1050 RPM. This value can be larger than 100%
 */
int BlowerRegalECM::gatShaftPower(int *shaftPower)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(8);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);

    cmd.append(ECM_CMD_REQ_SHAFT_PWR_RPWR);

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            if(response.length() == 10){
                if(isChecksumValid(response)){
                    *shaftPower = (response[6] << 8) | response[5];

                    //                    printf("BlowerRegalECM::gatShaftPower "
                    //                           "shaftPower: %d", *shaftPower);
                }else return -1;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){
                    return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

/**
 * @brief BlowerRegalECM::getControlTemperature
 * @param controlTemperature
 * @return
 *
 * Temperature response not implemented in all products
 */
int BlowerRegalECM::getControlTemperature(int *controlTemperature)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(8);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);

    cmd.append(ECM_CMD_REQ_CTRL_TEMP_RM);

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            if(response.length() == 10){
                if(isChecksumValid(response)){
                    *controlTemperature = (response[6] << 8) | response[5];

                    //                    printf("BlowerRegalECM::gatShaftPower "
                    //                           "controlTemperature: %d", *controlTemperature);

                }else return -1;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){
                    return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

int BlowerRegalECM::getTotalPowerTime(int *seconds)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(9);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);

    cmd.append(ECM_CMD_REQ_BB_INFO_RBKBX);
    cmd.append(static_cast<char>(ECM_BB_ID_TOTAL_POWER_TIME));

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    //    printf("BlowerRegalECM::getTotalPowerTime Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", cmd.at(i));
    //    }
    //    printf("\n");

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            //            printf("BlowerRegalECM::getTotalPowerTime Response - byte: ");
            //            for (int i=0; i<response.length(); i++) {
            //                printf("%02X ", response.at(i));
            //            }
            //            printf("\n");

            if(response.length() == 13){
                if(isChecksumValid(response)){
                    *seconds = qRound(static_cast<double>((response[9] << 16) | (response[8] << 8) | response[7]) *  ECM_BB_DECODE_VAL_MULTIPLY);

                    //                    printf("BlowerRegalECM::getTotalPowerTime Seconds: %d\n", *seconds);
                    //                    fflush(stdout);
                }else return -1;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){
                    return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

/**
 * @brief BlowerRegalECM::setAirflowDemand
 * @param newVal
 * @return
 *
 * Airflow in CFM. Must be <= Max A set by SSCL
 */
int BlowerRegalECM::setAirflowDemand(int newVal)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(10);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);
    cmd.append(ECM_CMD_SET_AF_DEMAND_SCFM);

    cmd.append(intToQByte16(newVal));

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    //    printf("BlowerRegalECM::setAirflowDemand Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", cmd.at(i));
    //    }
    //    printf("\n");

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            //            printf("BlowerRegalECM::setAirflowDemand Response - byte: ");
            //            for (int i=0; i<response.length(); i++) {
            //                printf("%02X ", response.at(i));
            //            }
            //            printf("\n");

            if(response.length() == 10){
                if(isChecksumValid(response)){

                }else return -6;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){
                    return -5;
                }else return -4;
            }else return -3;
        }else return -2;
    }else return -1;
    return 0;
}

/**
 * @brief BlowerRegalECM::setSpeedDemand
 * @param newVal
 * @return
 * RPM = Speed Decimal / 22 (if device code is ODF:OUTDOOR_FAN or BLWR:BLOWER)
 * RPM = Speed Decimal (if devide code is IDF:DRAFT_INDUCER)
 */
int BlowerRegalECM::setSpeedDemand(int newVal)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(10);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);
    cmd.append(ECM_CMD_SET_SPEED_DEMAND_SSPD);

    cmd.append(intToQByte16(newVal));

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            if(response.length() == 10){
                if(isChecksumValid(response)){

                }else return -1;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){
                    return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

/**
 * @brief BlowerRegalECM::setTorqueDemand
 * @param newVal = 65535 = 100% torque
 * @return
 */
int BlowerRegalECM::setTorqueDemand(int newVal)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(10);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);
    cmd.append(ECM_CMD_SET_TORQUE_STQ);

    //    int torqueNew = (newVal / 100) * 65535;
    int torqueNew = torquePercentToVal(newVal);
    cmd.append(intToQByte16(torqueNew));

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            if(response.length() == 10){
                if(isChecksumValid(response)){

                }else return -1;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){
                    return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

/**
 * @brief BlowerRegalECM::setAirflowScaling
 * @param newVal = maxA sets the 100% airflow demand in CFM
 * @return
 */
int BlowerRegalECM::setAirflowScaling(int newVal)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(10);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);
    cmd.append(ECM_CMD_SET_MAX_CFM_SSCL);

    cmd.append(intToQByte16(newVal));

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    //    printf("BlowerRegalECM::setAirflowScaling Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", cmd.at(i));
    //    }
    //    printf("\n");

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            //            printf("BlowerRegalECM::setAirflowScaling Response - byte: ");
            //            for (int i=0; i<response.length(); i++) {
            //                printf("%02X ", response.at(i));
            //            }
            //            printf("\n");

            if(response.length() == 10){
                if(isChecksumValid(response)){

                }else return -1;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){
                    return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

/**
 * @brief BlowerRegalECM::setDirection
 * @param newVal; CCW = 0 ; CW = 1 ; command ignored if running or starting
 * @return
 */
int BlowerRegalECM::setDirection(int newVal)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(9);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);
    cmd.append(ECM_CMD_SET_ROTATION_SDIR);

    cmd.append(static_cast<char>(newVal));

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    //    debugPrintCommand("setDirection", cmd);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            //            debugPrintCommand("setDirectionResponse", response);

            if(response.length() == 9){
                if(isChecksumValid(response)){
                    if(response.at(4) == ECM_CMD_SET_ROTATION_SDIR){

                    }else return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

/**
 * @brief BlowerRegalECM::setSlewRate
 * @param newVal
 * @return
 *
 * Conversion : Rate = INT(3276/Time)
 * Where Time = seconds for internal demand to slew from from zero to 100%
 * Rate 0 = no slew
 */
int BlowerRegalECM::setSlewRate(int newVal)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(9);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);
    cmd.append(ECM_CMD_SET_ROTATION_SDIR);

    cmd.append(intToQByte16(newVal));

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            if(response.length() == 9){
                if(isChecksumValid(response)){
                    if(response.at(4) == ECM_CMD_SET_ROTATION_SDIR){

                    }else return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

/**
 * @brief BlowerRegalECM::setBlowerContant
 * @param A1
 * @param A2
 * @param A3
 * @param A4
 * @return
 *
 * Note: low 4 bits of a3l are not used
 */
int BlowerRegalECM::setBlowerContant(double A1, double A2, double A3, double A4)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(13);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);
    cmd.append(ECM_CMD_SET_BLOWER_CONST_SCON);

    char a1     = (char)((A1 - 1.0) * 255.0 + 0.5);
    char a2     = (char)(A2 * 255.0 + 0.5);
    char a3l    = (char)(((int)(((log(1.0/A3) / log(2.0)) / 2.0) * 4096.0)) & 240);
    char a3h    = (char)((((int)(((log(1.0/A3) / log(2.0)) / 2.0) * 4096.0)) & 65280) / 256);
    char a4     = (char)(A4 * 255.0 / 2.0 + 0.5);
    cmd.append(a1);
    cmd.append(a2);
    cmd.append(a3l);
    cmd.append(a3h);
    cmd.append(a4);

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    //    printf("BlowerRegalECM::setBlowerContant Command - byte: ");
    //    fflush(stdout);
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", cmd.at(i));
    //        fflush(stdout);
    //    }
    //    printf("\n");
    //    fflush(stdout);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            //            printf("BlowerRegalECM::setBlowerContant Response - byte: ");
            //            fflush(stdout);
            //            for (int i=0; i<response.length(); i++) {
            //                printf("%02X ", response.at(i));
            //                fflush(stdout);
            //            }
            //            printf("\n");
            //            fflush(stdout);

            if(response.length() == 13){
                if(isChecksumValid(response)){

                }else return -1;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){
                    return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

int BlowerRegalECM::setCutbackSlope(int newVal)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(9);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);
    cmd.append(ECM_CMD_SET_CUTBACK_SLOPE_SLP);

    cmd.append((char)(newVal));

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    //    printf("BlowerRegalECM::setCutbackSlope Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", cmd.at(i));
    //    }
    //    printf("\n");

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            //            printf("BlowerRegalECM::setCutbackSlope Response - byte: ");
            //            for (int i=0; i<response.length(); i++) {
            //                printf("%02X ", response.at(i));
            //            }
            //            printf("\n");

            if(response.length() == 9){
                if(isChecksumValid(response)){
                    if(response.at(4) == ECM_CMD_SET_CUTBACK_SLOPE_SLP){

                    }else return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

int BlowerRegalECM::setCutbackSpeed(int newVal)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(9);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);
    cmd.append(ECM_CMD_SET_SPEED_LIMIT_SLIM);

    int speedLimit = qRound(((double)(newVal) * 22) / 256.0);
    cmd.append((char)speedLimit);

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    //    printf("BlowerRegalECM::setCutbackSpeed Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", cmd.at(i));
    //    }
    //    printf("\n");

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            //            printf("BlowerRegalECM::setCutbackSpeed Response - byte: ");
            //            for (int i=0; i<response.length(); i++) {
            //                printf("%02X ", response.at(i));
            //            }
            //            printf("\n");

            if(response.length() == 9){
                if(isChecksumValid(response)){
                    if(response.at(4) == ECM_CMD_SET_SPEED_LIMIT_SLIM){

                    }else return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

int BlowerRegalECM::setBrakeOnOff(int newVal)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(9);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);
    cmd.append(ECM_CMD_SET_BRAKE_SBRK);

    cmd.append(intToQByte16(newVal));

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            if(response.length() == 9){
                if(isChecksumValid(response)){
                    if(response.at(4) == ECM_CMD_SET_BRAKE_SBRK){

                    }else return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

int BlowerRegalECM::setSpeedLoopConstants(int Kp, int Ki, int Kd)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(11);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);
    cmd.append(ECM_CMD_SET_SPEED_LOOP_SPDK);

    cmd.append((char)Kp);
    cmd.append((char)Ki);
    cmd.append((char)Kd);

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            if(response.length() == 11){
                if(isChecksumValid(response)){

                }else return -1;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){
                    return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

int BlowerRegalECM::stop()
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(8);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);

    cmd.append(ECM_CMD_STOP_MOTOR_STOP);

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    //    printf("BlowerRegalECM::stop Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", cmd.at(i));
    //    }
    //    printf("\n");

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            //            printf("BlowerRegalECM::stop Response - byte: ");
            //            for (int i=0; i<response.length(); i++) {
            //                printf("%02X ", response.at(i));
            //            }
            //            printf("\n");

            if(response.length() == 8){
                if(isChecksumValid(response)){

                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

int BlowerRegalECM::start()
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(8);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);

    cmd.append(ECM_CMD_START_MOTOR_GO);

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    //    printf("BlowerRegalECM::start Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", cmd.at(i));
    //    }
    //    printf("\n");

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            //            printf("BlowerRegalECM::start Response - byte: ");
            //            for (int i=0; i<response.length(); i++) {
            //                printf("%02X ", response.at(i));
            //            }
            //            printf("\n");

            if(response.length() == 8){
                if(isChecksumValid(response)){

                }else return -1;
            }
            else if (response.length() == 9){
                if(isChecksumValid(response)){
                    return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

int BlowerRegalECM::runBlowerDemoParameter()
{
    //    printf("BlowerRegalECM::runBlowerDemoParameter\n");
    //    fflush(stdout);

    //    {
    //        QByteArray cmd;
    //        cmd.append('\x61');
    //        cmd.append('\x09');
    //        cmd.append('\x02');
    //        cmd.append('\x00');
    //        cmd.append('\x52');
    //        cmd.append('\x01'); //cw
    //        cmd.append('\x1D');
    //        cmd.append('\x23');
    //        cmd.append('\x0D');

    //        debugPrintCommand("SET_DIRECTION TX", cmd);

    //        serialComm->write(cmd);
    //        if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
    //            if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

    //                QByteArray response;
    //                while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
    //                    response += serialComm->readAll();
    //                }

    //                debugPrintCommand("SET_DIRECTION RX", response);

    //            }else return -2;
    //        }else return -1;
    //    }

    //    {
    //        QByteArray cmd;
    //        cmd.append('\x61');
    //        cmd.append('\x09');
    //        cmd.append('\x02');
    //        cmd.append('\x00');
    //        cmd.append('\x4C');
    //        cmd.append('\x7D');
    //        cmd.append('\x36');
    //        cmd.append('\x93');
    //        cmd.append('\x0D');

    //        debugPrintCommand("SET_CUT_BACK_SPEED TX", cmd);

    //        serialComm->write(cmd);
    //        if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
    //            if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

    //                QByteArray response;
    //                while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
    //                    response += serialComm->readAll();
    //                }

    //                debugPrintCommand("SET_CUT_BACK_SPEED RX", response);

    //            }else return -2;
    //        }else return -1;
    //    }

    //    {
    //        QByteArray cmd;
    //        cmd.append('\x61');
    //        cmd.append('\x09');
    //        cmd.append('\x02');
    //        cmd.append('\x00');
    //        cmd.append('\x50');
    //        cmd.append('\x04');
    //        cmd.append('\x1D');
    //        cmd.append('\x22');
    //        cmd.append('\x0D');

    //        debugPrintCommand("SET_CUT_BACK_SLOPE TX", cmd);

    //        serialComm->write(cmd);
    //        if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
    //            if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

    //                QByteArray response;
    //                while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
    //                    response += serialComm->readAll();
    //                }

    //                debugPrintCommand("SET_CUT_BACK_SLOPE RX", response);

    //            }else return -2;
    //        }else return -1;
    //    }

    //    {
    //        QByteArray cmd;
    //        cmd.append('\x61');
    //        cmd.append('\x0A');
    //        cmd.append('\x02');
    //        cmd.append('\x00');
    //        cmd.append('\x4D');
    //        cmd.append('\xDC');
    //        cmd.append('\x05');
    //        cmd.append('\xCC');
    //        cmd.append('\x96');
    //        cmd.append('\x0D');

    //        debugPrintCommand("SET_MAX_AIRFLOW TX", cmd);

    //        serialComm->write(cmd);
    //        if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
    //            if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

    //                QByteArray response;
    //                while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
    //                    response += serialComm->readAll();
    //                }

    //                debugPrintCommand("SET_MAX_AIRFLOW RX", response);

    //            }else return -2;
    //        }else return -1;
    //    }

    //    {
    //        QByteArray cmd;
    //        cmd.append('\x61');
    //        cmd.append('\x0D');
    //        cmd.append('\x02');
    //        cmd.append('\x00');
    //        cmd.append('\x41');
    //        cmd.append('\xDE');
    //        cmd.append('\x78');
    //        cmd.append('\xA0');
    //        cmd.append('\x94');
    //        cmd.append('\x25');
    //        cmd.append('\x55');
    //        cmd.append('\x47');
    //        cmd.append('\x0D');

    //        debugPrintCommand("SET_BLOWER_CONST TX", cmd);

    //        serialComm->write(cmd);
    //        if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
    //            if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

    //                QByteArray response;
    //                while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
    //                    response += serialComm->readAll();
    //                }

    //                debugPrintCommand("SET_BLOWER_CONST RX", response);

    //            }else return -2;
    //        }else return -1;
    //    }

    //    {
    //        QByteArray cmd;
    //        cmd.append('\x61');
    //        cmd.append('\x0A');
    //        cmd.append('\x02');
    //        cmd.append('\x00');
    //        cmd.append('\x44');
    //        cmd.append('\xF4');
    //        cmd.append('\x01');
    //        cmd.append('\xB0');
    //        cmd.append('\xA7');
    //        cmd.append('\x0D');

    //        debugPrintCommand("SET_AF_DEMAND TX", cmd);

    //        serialComm->write(cmd);
    //        if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
    //            if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

    //                QByteArray response;
    //                while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
    //                    response += serialComm->readAll();
    //                }

    //                debugPrintCommand("SET_AF_DEMAND RX", response);

    //            }else return -2;
    //        }else return -1;
    //    }

    //    {
    //        QByteArray cmd;
    //        cmd.append('\x61');
    //        cmd.append('\x08');
    //        cmd.append('\x02');
    //        cmd.append('\x00');
    //        cmd.append('\x47');
    //        cmd.append('\xF8');
    //        cmd.append('\x54');
    //        cmd.append('\x0D');

    //        debugPrintCommand("SET_START TX", cmd);

    //        serialComm->write(cmd);
    //        if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
    //            if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

    //                QByteArray response;
    //                while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
    //                    response += serialComm->readAll();
    //                }

    //                debugPrintCommand("SET_START RX", response);

    //            }else return -2;
    //        }else return -1;
    //    }
    /////////////////////////////////////////////

    //SET_DIRECTION
    //    {
    //        QByteArray cmd;
    //        cmd.append(ECM_PREAMBLE_BLOWER);
    //        cmd.append(9);
    //        cmd.append(m_protocolVersion);
    //        cmd.append(m_address);
    //        cmd.append(ECM_CMD_SET_ROTATION_SDIR);

    //        cmd.append(1); //cw

    //        {
    //            QByteArray checksum;
    //            generateChecksum(cmd, checksum);
    //            cmd.append(checksum);
    //        }

    //        cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);


    //        debugPrintCommand("SET_DIRECTION TX", cmd);

    //        serialComm->write(cmd);
    //        if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
    //            if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

    //                QByteArray response;
    //                while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
    //                    response += serialComm->readAll();
    //                }

    //                debugPrintCommand("SET_DIRECTION RX", response);

    //            }else return -2;
    //        }else return -1;
    //    }
    //    QThread::sleep(1);

    //SET_LIMIT_SPEED
    //    {
    //        QByteArray cmd;
    //        cmd.append(ECM_PREAMBLE_BLOWER);
    //        cmd.append(9);
    //        cmd.append(m_protocolVersion);
    //        cmd.append(m_address);
    //        cmd.append(ECM_CMD_SET_SPEED_LIMIT_SLIM);

    //        cmd.append(124); //7C

    //        {
    //            QByteArray checksum;
    //            generateChecksum(cmd, checksum);
    //            cmd.append(checksum);
    //        }

    //        cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);


    //        debugPrintCommand("SET_LIMIT_SPEED TX", cmd);

    //        serialComm->write(cmd);
    //        if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
    //            if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

    //                QByteArray response;
    //                while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
    //                    response += serialComm->readAll();
    //                }

    //                debugPrintCommand("SET_LIMIT_SPEED RX", response);

    //            }else return -2;
    //        }else return -1;
    //    }
    //    QThread::sleep(1);

    //SET_CUT_BACK_SLOPE
    //    {
    //        QByteArray cmd;
    //        cmd.append(ECM_PREAMBLE_BLOWER);
    //        cmd.append(9);
    //        cmd.append(m_protocolVersion);
    //        cmd.append(m_address);
    //        cmd.append(ECM_CMD_SET_CUTBACK_SLOPE_SLP);

    //        cmd.append(5); //05

    //        {
    //            QByteArray checksum;
    //            generateChecksum(cmd, checksum);
    //            cmd.append(checksum);
    //        }

    //        cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);


    //        debugPrintCommand("SET_CUT_BACK_SLOPE TX", cmd);

    //        serialComm->write(cmd);
    //        if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
    //            if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

    //                QByteArray response;
    //                while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
    //                    response += serialComm->readAll();
    //                }

    //                debugPrintCommand("SET_CUT_BACK_SLOPE RX", response);

    //            }else return -2;
    //        }else return -1;
    //    }
    //    QThread::sleep(1);

    //SET_MAX_CFM
    //    {
    //        QByteArray cmd;
    //        cmd.append(ECM_PREAMBLE_BLOWER);
    //        cmd.append(10);
    //        cmd.append(m_protocolVersion);
    //        cmd.append(m_address);
    //        cmd.append(ECM_CMD_SET_MAX_CFM_SSCL);

    //        //max 5DC = 1500
    //        cmd.append(intToQByte(1500));

    //        {
    //            QByteArray checksum;
    //            generateChecksum(cmd, checksum);
    //            cmd.append(checksum);
    //        }

    //        cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    //        debugPrintCommand("SET_MAX_CFM TX", cmd);

    //        serialComm->write(cmd);
    //        if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
    //            if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

    //                QByteArray response;
    //                while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
    //                    response += serialComm->readAll();
    //                }

    //                debugPrintCommand("SET_MAX_CFM RX", response);

    //            }else return -2;
    //        }else return -1;
    //    }
    //    QThread::sleep(1);

    //    //SET_BLOWER_CONTANT
    //    {
    //        QByteArray cmd;
    //        cmd.append(ECM_PREAMBLE_BLOWER);
    //        cmd.append(13);
    //        cmd.append(m_protocolVersion);
    //        cmd.append(m_address);
    //        cmd.append(ECM_CMD_SET_BLOWER_CONST_SCON);

    //        cmd.append(static_cast<char>(0xF6));
    //        cmd.append(static_cast<char>(0x74));
    //        cmd.append(static_cast<char>(0x70));
    //        cmd.append(static_cast<char>(0xC5));
    //        cmd.append(static_cast<char>(0x4D));

    //        {
    //            QByteArray checksum;
    //            generateChecksum(cmd, checksum);
    //            cmd.append(checksum);
    //        }

    //        cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    //        debugPrintCommand("SET_BLOWER_CONTANT TX", cmd);

    //        serialComm->write(cmd);
    //        if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
    //            if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

    //                QByteArray response;
    //                while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
    //                    response += serialComm->readAll();
    //                }

    //                debugPrintCommand("SET_BLOWER_CONTANT RX", response);

    //            }else return -2;
    //        }else return -1;
    //    }
    //    QThread::sleep(1);

    //SET_AIRFLOW_CFM_DEMAND
    //    {
    //        QByteArray cmd;
    //        cmd.append(ECM_PREAMBLE_BLOWER);
    //        cmd.append(10);
    //        cmd.append(m_protocolVersion);
    //        cmd.append(m_address);
    //        cmd.append(ECM_CMD_SET_AF_DEMAND_SCFM);

    //        cmd.append(-5);
    //        cmd.append('\x0');

    //        {
    //            QByteArray checksum;
    //            generateChecksum(cmd, checksum);
    //            cmd.append(checksum);
    //        }

    //        cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    //        debugPrintCommand("SET_AIRFLOW_CFM_DEMAND TX", cmd);

    //        serialComm->write(cmd);
    //        if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
    //            if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

    //                QByteArray response;
    //                while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
    //                    response += serialComm->readAll();
    //                }

    //                debugPrintCommand("SET_AIRFLOW_CFM_DEMAND RX", response);

    //            }else return -2;
    //        }else return -1;
    //    }
    //    QThread::sleep(1);
    return 0;
}

int BlowerRegalECM::setAddressModule(uchar newVal)
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(ECM_PREAMBLE_BLOWER);
    cmd.append(9);
    cmd.append(m_protocolVersion);
    cmd.append(m_address);
    cmd.append(ECM_CMD_SET_ADDR_SETA);

    cmd.append(intToQByte16(newVal));

    {
        QByteArray checksum;
        generateChecksum(cmd, checksum);
        cmd.append(checksum);
    }

    cmd.append(ECM_MISC_CARRIAGE_RETURN_CR);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            if(response.length() == 9){
                if(isChecksumValid(response)){
                    if(response.at(4) == ECM_CMD_SET_ADDR_SETA){
                        m_address = newVal;
                    }else return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

int BlowerRegalECM::setAddressConditional(int /*newVal*/)
{
    return 0;
}

int BlowerRegalECM::torqueValToPercent(int newVal)
{
    return qRound(((float)newVal / 65535.0) * 100.0);
}

int BlowerRegalECM::torquePercentToVal(int newVal)
{
    return qRound(((float)newVal / 100.0) * 65535.0);
}

void BlowerRegalECM::generateChecksum(QByteArray &byte, QByteArray &checksum)
{
    //    printf("BlowerRegalECM::generateChecksum - byte: ");
    //    for (int i=0; i<byte.length(); i++) {
    //        printf("%02X ", byte.at(i));
    //    }
    //    printf("\n");

    int sum1 = 0;
    int sum2 = 0;

    for (int i=0; i<byte.length(); i++) {
        sum1 = (sum1 + byte.at(i)) % 255;
        sum2 = (sum2 + sum1) % 255;
    }

    uchar ckl, ckh;
    ckl = (uchar)(255 - ((sum1 + sum2) % 255));
    ckh = (uchar)(255 - ((sum1 + ckl) % 255));
    checksum.append((char)ckl);
    checksum.append((char)ckh);

    //    printf("BlowerRegalECM::isChecksumValid - checksum: %02X %02X \n", ckl, ckh);
}

bool BlowerRegalECM::isChecksumValid(QByteArray byte)
{
    try {
        //        printf("BlowerRegalECM::isChecksumValid - byte: ");
        //        for (int i=0; i<byte.length(); i++) {
        //            printf("%02X ", byte.at(i));
        //        }
        //        printf("\n");

        //hold_response_checksum
        QByteArray cmd_checksum;
        cmd_checksum.append(byte.at(byte.length() - 3));
        cmd_checksum.append(byte.at(byte.length() - 2));
        //        printf("BlowerRegalECM::isChecksumValid - cmd_checksum: %02X %02X \n", cmd_checksum.at(0), cmd_checksum.at(1));

        //throw_checksum_from_response
        QByteArray cmd = byte.remove((byte.length() - 3), 3);
        //        printf("BlowerRegalECM::isChecksumValid - cmd: ");
        //        for (int i=0; i<byte.length(); i++) {
        //            printf("%02X ", byte.at(i));
        //        }
        //        printf("\n");

        //generate_valid_checksum
        QByteArray valid_checksum;
        generateChecksum(cmd, valid_checksum);
        //        printf("BlowerRegalECM::isChecksumValid - valid_checksum: %02X %02X \n", valid_checksum.at(0), valid_checksum.at(1));

        //validation
        return valid_checksum == cmd_checksum;
    } catch (...) {
        //        printf("BlowerRegalECM::isChecksumValid - exception \n");
        return false;
    }
}

QByteArray BlowerRegalECM::intToQByte16(int newVal)
{
    QByteArray cmd;
    cmd.append((char)(newVal & 0x00ff));
    cmd.append((char)(newVal >> 8));
    return cmd;
}

void BlowerRegalECM::debugPrintCommand(const QString &title, const QByteArray &cmd)
{
    printf("BlowerRegalECM::debugPrintCommand %s - data: ", title.toStdString().c_str());
    for (int i=0; i<cmd.length(); i++) {
        printf("%02X ", (uchar)(cmd.at(i)));
    }
    printf("\n");
    fflush(stdout);
}

bool BlowerRegalECM::isPortValid() const
{
    if (serialComm != nullptr) {
        if(serialComm->isOpen()) {
            return true;
        }
    }
    return false;
}
