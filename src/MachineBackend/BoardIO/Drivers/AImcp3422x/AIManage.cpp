#include "AIManage.h"

#define MAXIMUM_ADC_RESOLUTION 4095

AIManage::AIManage(QObject *parent)
    : ClassDriver(parent)
{
    channelIndex        = 0;

    for (int i=0; i< AI_MAX_CHANNELS; i++) {
        channelsDoPoll[i]       = 0;
        channelsDoAverage[i]    = 0;
        channelsMaxSamples[i]   = 0;
        channelsADC[i]          = 0;
        channelsmVolt[i]        = 0;
        channelTotalADC[i]      = 0;
    }

    //    for (int i=0; i<5; i++) {
    //        channelsSamples[0].push_back(i);
    //        channelsSamples[1].push_back(i);
    //    }
}

void AIManage::setupAIModule()
{
    m_pAIModule.reset(new AImcp342x);
}

void AIManage::setChannelDoPoll(int channel, int poll)
{
    channelsDoPoll[channel] = poll;
}

void AIManage::setChannelDoAverage(int channel, int average)
{
    channelsDoAverage[channel] = average;
}

void AIManage::setChannelSamples(int channel, int number)
{
    channelsMaxSamples[channel] = number;
}

void AIManage::setI2C(I2CPort *pI2C)
{
    m_pAIModule->setI2C(pI2C);
}

void AIManage::setAddress(uchar addr)
{
    m_address = addr;
    m_pAIModule->setAddress(addr);
}

int AIManage::testComm()
{
    //    printf("AIManage::testComm\n");
    //    fflush(stdout);
    return m_pAIModule->testComm();
}

int AIManage::init()
{
    channelIndex = 0;
    m_pAIModule->setConfigChannel(0);
    return m_pAIModule->init();
}

int AIManage::polling()
{
    int response    = 0;
    int index       = channelIndex;

    if(channelsDoPoll[index]){

        int adc     = 0;
        response    = m_pAIModule->getValue(&adc, index);

        /// Mapping 0~8191 to 0~4095
        adc = map(adc, 0, 8191, 0, MAXIMUM_ADC_RESOLUTION);

        if(response == 0){
            if(m_pAIModule->isConversionUpdated()){
                if(channelsDoAverage[index] == 1){
                    //Average without lag time
                    //                        printf("AIManage::read channel 0 average\n");
                    //                        fflush(stdout);

                    if(channelsSamples[index].length() >= channelsMaxSamples[index]){
                        channelTotalADC[index] = channelTotalADC[index] - channelsSamples[index].front();
                        channelsSamples[index].pop_front();
                        nextChannel();

                        //                        printf("ADC Full Samples ms: %lld\n", elapsedTime.elapsed());
                        //                        fflush(stdout);
                    }

                    channelsSamples[index].push_back(adc);

                    //                    printf("channel %d Size of %d\n", channelIndex, channelsSamples[channelIndex].size());
                    //                    fflush(stdout);

                    channelTotalADC[index]   = channelTotalADC[index] + adc;
                    channelsADC[index]       = qRound(static_cast<double>(channelTotalADC[index]) / (static_cast<double>(channelsSamples[index].length())));
                    channelsmVolt[index]     = /*m_pAIModule->*/convertADCtomVolt(channelsADC[index]);
                    //channelsmA[index]        = m_pAIModule->convertADCtomA(channelsADC[index]);

                }else{
                    //without moving average
                    channelsADC[channelIndex]       = adc;
                    channelsmVolt[index]            = /*m_pAIModule->*/convertADCtomVolt(channelsADC[index]);
                    //channelsmA[index]               = m_pAIModule->convertADCtomA(channelsADC[index]);
                    nextChannel();
                }
            }
        }
    }
    else{
        nextChannel();
    }

    return response;
}

void AIManage::nextChannel()
{
    //    printf("AIManage::nextChannel\n");
    //    fflush(stdout);

    int newIndex = channelIndex;
    for(int i=0; i < AI_MAX_CHANNELS; i++){

        if(newIndex < (AI_MAX_CHANNELS - 1)) newIndex++;
        else newIndex = 0;

        if(channelsDoPoll[newIndex] == 1){
            //            printf("AIManage::channelSwitcher current = %d next = %d\n", channelIndex, newIndex);
            //            fflush(stdout);
            //            qDebug() << "AIManage::channelSwitch prev index channel: "<< channelIndex << " new index channel"<< newIndex;
            channelIndex = newIndex;
            //switch channel
            m_pAIModule->setConfigChannel(static_cast<uchar>(channelIndex));
            m_pAIModule->sendConfig();
            break;
        }
    }
    //    printf("AIManage::nextChannel end\n");
    //    fflush(stdout);
}

int AIManage::meanValues(std::vector<int> &values)
{
    //    qDebug() << "AIManage::meanValues() " << values.size();
    if(values.empty()) return -1;
    //    qDebug()<< "AIManage::meanValues() before";
    //    for(uint i=0; i<values.size(); i++){
    //        qDebug()<< values.at(i);
    //    }
    std::sort(values.begin(), values.end());
    //    qDebug()<< "AIManage::meanValues()";
    //    for(uint i=0; i<values.size(); i++){
    //        qDebug()<< values.at(i);
    //    }
    //    qDebug()<< "AIManage::meanValues()#######################";
    int indexCenter = values.size()/2;
    //    qDebug() << "AIManage::meanValues()index "<< index;
    if(values.size() % 2){
        //even
        return values.at(indexCenter);
    }
    //odd
    double temp = static_cast<double>(values.at(indexCenter) + values.at(indexCenter - 1));
    return qRound(temp/2);
}

int AIManage::medianSampleADC(QVector<int> &samples)
{
    int length = samples.length();
    if(length == 0) return -1;

    //    printf(" Before sorting ");
    //    for(int i=0; i<samples.size(); i++){
    //        printf(" %d ", samples.at(i));
    //    }
    //    printf("\n");
    //    fflush(stdout);

    std::sort(samples.begin(), samples.end());

    //    printf(" After sorting ");
    //    for(int i=0; i<samples.size(); i++){
    //        printf(" %d ", samples.at(i));
    //    }
    //    printf("\n");
    //    fflush(stdout);

    int center = length / 2;
    if(length % 2){
        return samples[center];
    }
    double temp = (samples[center] + samples[center - 1]) / 2.0;
    return qRound(temp);
}

int AIManage::getADC(int channel) const
{
    return channelsADC[channel];
}

int AIManage::getAdcMap(int channel, unsigned char m_maxAdcResBits) const
{
    unsigned char mcp432xConfigSps = m_pAIModule->getConfigSPS();
    unsigned char mcp432xMaxAdcResBits = 0;
    int adcOri = channelsADC[channel];
    int adcMap = 0;

    if(mcp432xConfigSps == MCP342X_AI_SPS_12bits)
        mcp432xMaxAdcResBits = 11;     /// Actual output adc from mcp432x = mcp432xConfigSps_bits - 1
    else if(mcp432xConfigSps == MCP342X_AI_SPS_14bits)
        mcp432xMaxAdcResBits = 13;     /// Actual output adc from mcp432x = mcp432xConfigSps_bits - 1
    else if(mcp432xConfigSps == MCP342X_AI_SPS_16bits)
        mcp432xMaxAdcResBits = 15;     /// Actual output adc from mcp432x = mcp432xConfigSps_bits - 1
    else if(mcp432xConfigSps == MCP342X_AI_SPS_18bits)
        mcp432xMaxAdcResBits = 17;     /// Actual output adc from mcp432x = mcp432xConfigSps_bits - 1
    else
        return adcOri;

    /// Set Minimum Mapping to 10 bits (1024)
    if(m_maxAdcResBits < 10 || m_maxAdcResBits >= mcp432xMaxAdcResBits) return adcOri;

    adcMap = static_cast<int>(map(adcOri, 0, getMaxDecFromBits(mcp432xMaxAdcResBits), 0, getMaxDecFromBits(m_maxAdcResBits)));
    return adcMap;
}

int AIManage::getmVolt(int channel) const
{
    return channelsmVolt[channel];
}

double AIManage::getmA(int channel) const
{
    return channelsmA[channel];
}

void AIManage::_debugPrintDataAIConfig()
{
    m_pAIModule->_debugPrintRegister(2);
}

AImcp342x *AIManage::getPAIModule() const
{
    return m_pAIModule.data();
}

long AIManage::map(long x, long in_min, long in_max, long out_min, long out_max) const
{
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

long AIManage::getMaxDecFromBits(unsigned char bits) const
{
    long _bit = 0;

    if(_bit > 0) _bit |= 1;

    for(short i = 0; i < bits; i++){
        _bit = (_bit << 1) | 1;
    }

    return _bit;
}

int AIManage::convertADCtomVolt(int adc)
{
    /// 4095 -> 10.118 Volt
    return map(adc, 0, MAXIMUM_ADC_RESOLUTION, 0, 10118);
}

