#ifndef AIMANAGE_H
#define AIMANAGE_H

#include <QVector>
#include <QSharedPointer>
#include "../i2c/I2CPort.h"
#include "AImcp342x.h"
#include "../ClassDriver.h"

#define AI_SAMPLES_TOTAL_MAX        200
#define AI_SAMPLES_TOTAL_DEFAULT    10
#define AI_MAX_CHANNELS             4
#define AI_MAX_VOLTAGE              5000

class AIManage : public ClassDriver
{
    Q_OBJECT
public:
    AIManage(QObject *parent = nullptr);

    void setupAIModule();
    void setAIModule(AImcp342x * pObject);
    void setChannelDoPoll(int channel, int poll);
    void setChannelDoAverage(int channel, int average);
    void setChannelSamples(int channel, int number);

    void setI2C(I2CPort *pI2C);
    void setAddress(uchar addr);
    int testComm();
    int init();
    int polling();

    int getADC(int channel) const;
    int getmVolt(int channel) const;
    double getmA(int channel) const;

    void _debugPrintDataAIConfig();

private:
    QSharedPointer<AImcp342x> m_pAIModule;

    int channelIndex;
    int channelsDoPoll[AI_MAX_CHANNELS];
    int channelsDoAverage[AI_MAX_CHANNELS];
    int channelsMaxSamples[AI_MAX_CHANNELS];
    int channelsADC[AI_MAX_CHANNELS];
    int     channelsmVolt[AI_MAX_CHANNELS];
    double  channelsmA[AI_MAX_CHANNELS];
    int     channelTotalADC[AI_MAX_CHANNELS];
    QVector<int> channelsSamples[AI_MAX_CHANNELS];

    void nextChannel();
    int meanValues(std::vector<int> &values);
    int medianSampleADC(QVector<int> &samples);
};

#endif // AIMANAGE_H
