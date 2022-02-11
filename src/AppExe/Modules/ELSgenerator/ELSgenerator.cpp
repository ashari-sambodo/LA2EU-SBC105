#include <QCalendar>
#include <QDate>
#include <QtConcurrent/QtConcurrent>
#include "ELSgenerator.h"

ELSgenerator::ELSgenerator(QObject *parent) : QObject(parent)
{

}

QString ELSgenerator::getGeneratedKey() const
{
    return m_generatedKey;
}

QString ELSgenerator::getGeneratedKey2() const
{
    return m_generatedKey2;
}

bool ELSgenerator::getBusy() const
{
    return m_busy;
}

void ELSgenerator::setGeneratedKey(QString generatedKey)
{
    if (m_generatedKey == generatedKey)
        return;

    m_generatedKey = generatedKey;
    emit generatedKeyChanged(m_generatedKey);
}

/**
 * @brief ELSgenerator::calculateKey
 * @param serialNumber
 *
 * Calculate the key in another thread using QtConcurrent technich to prevent UI Thread from freezing
 * with this technic is not possible to cancel the process
 * we expect will not bad effect to system because the calculate will not take many take
 */
void ELSgenerator::calculateKey(QString serialNumber, const QString &targetDate)
{
    qDebug() << metaObject()->className() << __func__;
    QtConcurrent::run([&, serialNumber, targetDate]{
        setBusy(true);
        QString elsPinStr, elsPinStr2;
        bool success = getEscoLockServicePIN(serialNumber, &elsPinStr, &elsPinStr2, targetDate);

        qDebug() << metaObject()->className() << __func__ << success << "elsPinStr" << elsPinStr << elsPinStr2;

        setGeneratedKey(elsPinStr);
        setGeneratedKey2(elsPinStr2);

        setBusy(false);
        emit generatorKeyHasFinished(success);
    });
}

void ELSgenerator::setBusy(bool busy)
{
    if (m_busy == busy)
        return;

    m_busy = busy;
    emit busyChanged(m_busy);
}

void ELSgenerator::setGeneratedKey2(QString generatedKey2)
{
    if (m_generatedKey2 == generatedKey2)
        return;

    m_generatedKey2 = generatedKey2;
    emit generatedKey2Changed(m_generatedKey2);
}

unsigned int ELSgenerator::calculateCRCcode(char *data, int length)
{
    unsigned int crcTable[256];
    unsigned int index1 = 0, index2 = 0, index3 = 0;
    unsigned char index4=0;
    unsigned int crc = 0;
    unsigned int STD_POLY  = 0xA001;

    for (index3 = 0; index3 < 256; index3++) {
        index2 = index3;
        for (index1 = 0; index1 < 8; index1++) {
            if ((index2 & 1) != 0)
                index2 = (index2 >> 1) ^ STD_POLY;
            else index2 = index2 >> 1;
        }
        crcTable[index3] = static_cast<unsigned int>(index2);
    }

    for (index4 = 0; index4 < length; index4++) {
        crc = (crc >> 8) ^ (crcTable[(crc & 0xFF) ^ (data[index4] & 0xFF)] & 0xFFFF);
    }
    return crc;
}

bool ELSgenerator::getEscoLockServicePIN(QString serialNumber,
                                         QString *generatedPin,
                                         QString *generatedPin2,
                                         QString targetDate = QString())
{
    int temp, i=0, j=0;
    char string_PIN[17];
    unsigned char data_PIN[17];
    char serialNumber_temp[9];
    char serialNumber8Digits[9];
    unsigned char SN[9];
    unsigned int crcValue;
    int year = 2010, month = 1;
    int dayOfWeek=0, day=0, weekNumber=0;
    bool isValid = false;

    qstrcpy(serialNumber_temp, serialNumber.toStdString().c_str());

    // if date manually input
    if (targetDate.length()) {
        QDate manualDate = QDate::fromString(targetDate, "yyyy-MM-dd");
        qDebug() << metaObject()->className() << __func__ << "manualDate" << manualDate;

        if(manualDate.isValid()) {
            dayOfWeek = manualDate.dayOfWeek();
            if(dayOfWeek == Qt::Sunday) dayOfWeek = 0;
            day     = manualDate.day();
            month   = manualDate.month();
            year    = manualDate.year();
        }
        else {
            return false;
        }
    }
    else {
        //get date
        dayOfWeek = QDate::currentDate().dayOfWeek();
        if(dayOfWeek == Qt::Sunday)dayOfWeek = 0;
        day     = QDate::currentDate().day();
        month   = QDate::currentDate().month();
        year    = QDate::currentDate().year();
    }

    QCalendar calender;
    isValid = calender.isDateValid(year,month,day);

    if(isValid){
        weekNumber = calculateNoOfWeekInYear(dayOfWeek, day, month, year);
        qDebug() << metaObject()->className() << __func__ << "SN: "<<serialNumber_temp;
        qDebug() << metaObject()->className() << __func__ << "DOW:"<<dayOfWeek<<" D:"<<day<<" M:"<<month<<" Y:"<<year;
        qDebug() << metaObject()->className() << __func__ << "WEEK: "<<weekNumber;

        ////get device Serial number
        ////Serial Number Format XXXXXX
        ////Because of SN of Pharma product contains only 6 digits, then need to add 2 leading zero to make it complete as 8 digits SN
        //        serialNumber8Digits[0]='0';
        //        serialNumber8Digits[1]='0';
        memcpy(&serialNumber8Digits, serialNumber_temp, 8);
        serialNumber8Digits[8] = '\0'; //Ensure the char arry has termination
        ////eliminate non number char and convert to '0'
        //        for(i = 0; i < 8; i++) {
        //            if(serialNumber8Digits[i] < '0' || serialNumber8Digits[i]>'9')
        //                serialNumber8Digits[i] = '0';
        //            //       qDebug() << serialNumber8Digits[i];
        //        }

        //        serialNumber = QString::fromLocal8Bit(serialNumber8Digits);

        //        QByteArray ba = serialNumber.toLocal8Bit();
        //        const char *c_str2 = ba.data();

        //convert char to integer
        for(i = 0; i < 8; i++) {
            SN[i] = static_cast<unsigned char>(serialNumber8Digits[i])-48;
            //       qDebug() << SN[i];
        }

        //year
        temp = year - 2010;

        if(temp <= 10) {
            data_PIN[1] = static_cast<unsigned char>(temp);
            data_PIN[0] = 1;
        } else if(temp <= 20) {
            data_PIN[1] = static_cast<unsigned char>(temp) - 10;
            data_PIN[0] = 2;
        } else if(temp <= 30) {
            data_PIN[1] = static_cast<unsigned char>(temp) - 20;
            data_PIN[0] = 3;
        } else if(temp <= 40) {
            data_PIN[1] = static_cast<unsigned char>(temp) - 30;
            data_PIN[0] = 4;
        } else if(temp <= 50) {
            data_PIN[1] = static_cast<unsigned char>(temp) - 40;
            data_PIN[0] = 5;
        } else if(temp <= 60) {
            data_PIN[1] = static_cast<unsigned char>(temp) - 50;
            data_PIN[0] = 6;
        } else if(temp <= 70) {
            data_PIN[1] = static_cast<unsigned char>(temp) - 60;
            data_PIN[0] = 7;
        } else if(temp <= 80) {
            data_PIN[1] = static_cast<unsigned char>(temp) - 70;
            data_PIN[0] = 8;
        } else if(temp <= 90) {
            data_PIN[1] = static_cast<unsigned char>(temp) - 80;
            data_PIN[0] = 9;
        }

        /*/Month
           //    if(month < 10) {
           //        data_PIN[3] = static_cast<unsigned char>(month);
           //        data_PIN[2] = 0;
           //    } else {
           //        data_PIN[3] = static_cast<unsigned char>(month) - 10;
           //        data_PIN[2] = 1;
           //    }*/

        //WEEK
        data_PIN[3] = static_cast<unsigned char>(weekNumber % 10);
        data_PIN[2] = static_cast<unsigned char>(weekNumber / 10);

        //Date
        data_PIN[5] = 0;
        data_PIN[4] = 0;

        //Constant
        data_PIN[7] = 1;
        data_PIN[6] = 2;

        //Serial Number
        for(i = 8; i < 16; i++) {
            memcpy(&data_PIN[i], &SN[j], 1);
            j++;
        }
        for(i = 0; i < 16; i++) {
            integerToString(data_PIN[i], &string_PIN[i], 1);
        }

        crcValue = calculateCRCcode(string_PIN, 16);

        char elsPin1[6], elsPin2[6];
        integerToString(crcValue + static_cast<unsigned int>(key1SpecialNumber), elsPin1, 5);
        integerToString(crcValue + static_cast<unsigned int>(key2SpecialNumber), elsPin2, 5);

        qDebug() << metaObject()->className() << __func__ << "elsPin1" << elsPin1;
        qDebug() << metaObject()->className() << __func__ << "elsPin2" << elsPin2;

        generatedPin->append(QString::fromLocal8Bit(elsPin1, 6));
        generatedPin2->append(QString::fromLocal8Bit(elsPin2, 6));

        return true;
    }
    return false;
}

int ELSgenerator::calculateNoOfWeekInYear(int dayOfWeek, int day, int month, int year)
{
    int numberOfCurrentDayInYear = 0;
    int leap = 0;
    int temp1 = 0;
    int temp2 = 0;
    int week = 0;

    unsigned char daytab[2][13]  =  {
        {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31},
        {0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
    };

    temp1 = month;
    //    if (year is not divisible by 4) then (it is a common year)
    //    else if (year is not divisible by 100) then (it is a leap year)
    //    else if (year is not divisible by 400) then (it is a common year)
    //    else (it is a leap year)
    QCalendar calender;
    leap = calender.isLeapYear(year); //(year % 4 == 0) && (year % 100 != 0) || year % 400 == 0;
    qDebug() << "Leap Year: " << (leap ? "true" : "false");

    while(temp1){
        if(temp1 == month)numberOfCurrentDayInYear += day;
        else numberOfCurrentDayInYear += daytab[leap][temp1];
        temp1--;
    }

    if(dayOfWeek == Qt::Saturday){
        temp2 = (numberOfCurrentDayInYear % 7);
        week = (numberOfCurrentDayInYear / 7);
        if(temp2 > 0 && week == 0)
            week = 1;
        else if(temp2 > 0 && week > 0)
            week += 1;
    }else{
        temp2 = (numberOfCurrentDayInYear + (Qt::Saturday - dayOfWeek)) % 7;
        week = (numberOfCurrentDayInYear + (Qt::Saturday - dayOfWeek)) / 7;
        if(temp2 > 0 && week == 0)
            week = 1;
        else if(temp2 > 0 && week > 0)
            week += 1;
    }
    return week;
}

void ELSgenerator::integerToString(unsigned int number, char *string, unsigned char noOfDigits)
{
    string[noOfDigits] = '\0';
    /* Extract each digit from right to left and store the ASCII value
           corresponding to extracted digit in String */
    while((number) && (noOfDigits > 0)) {
        string[--noOfDigits] = '0' + number % 10;
        number = number/10;
    }

    /* Fill remaining digits by ASCII code '0' */
    while(noOfDigits)
        string[--noOfDigits] = '0';

}
