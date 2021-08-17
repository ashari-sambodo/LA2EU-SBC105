#pragma once

#include <QObject>
#include <QDebug>

class ELSgenerator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString generatedKey
               READ getGeneratedKey
               WRITE setGeneratedKey
               NOTIFY generatedKeyChanged)

    Q_PROPERTY(QString generatedKey2
               READ getGeneratedKey2
               WRITE setGeneratedKey2
               NOTIFY generatedKey2Changed)

    Q_PROPERTY(bool busy
               READ getBusy
               WRITE setBusy
               NOTIFY busyChanged)
public:
    explicit ELSgenerator(QObject *parent = nullptr);

    QString getGeneratedKey() const;
    QString getGeneratedKey2() const;

    bool getBusy() const;

public slots:
    void setGeneratedKey(QString generatedKey);
    void setGeneratedKey2(QString generatedKey2);
    void calculateKey(QString serialNumber, const QString &targetDate = QString());

    void setBusy(bool busy);

signals:
    void generatedKeyChanged(QString generatedKey);
    void generatedKey2Changed(QString generatedKey2);
    void generatorKeyHasFinished(bool generated);

    void busyChanged(bool busy);

private:
    unsigned int calculateCRCcode(char *data, int length);
    bool getEscoLockServicePIN(QString serialNumber, QString *generatedPin, QString *generatedPin2, QString targetDate);
    int calculateNoOfWeekInYear(int dayOfWeek, int day, int month, int year);
    void integerToString(unsigned int number, char* string, unsigned char noOfDigits);

    QString m_generatedKey;
    QString m_generatedKey2;

    int key1SpecialNumber = 0;
    int key2SpecialNumber = 19;
    bool m_busy = false;
};

