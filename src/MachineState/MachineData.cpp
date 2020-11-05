#include "MachineData.h"

#include <QQmlEngine>
#include <QJSEngine>

#include <QDebug>

static MachineData* s_instance = nullptr;

QObject *MachineData::singletonProvider(QQmlEngine *qmlEngine, QJSEngine *)
{
    if(!s_instance){
        qDebug() << "MachineData::singletonProvider::create";
        s_instance = new MachineData(qmlEngine);
    }
    return s_instance;
}

void MachineData::singletonDelete()
{
    qDebug() << __FUNCTION__;
    if(s_instance){
        delete s_instance;
    }
}

MachineData::MachineData(QObject *parent) : QObject(parent)
{

}

MachineData::~MachineData()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
}

short MachineData::getMachineState() const
{
    return m_machineState;
}

void MachineData::setMachineState(short workerState)
{
    if (m_machineState == workerState)
        return;

    m_machineState = workerState;
    emit machineStateChanged(m_machineState);
}

int MachineData::getCount() const
{
    return m_count;
}

void MachineData::setCount(int count)
{
    if (m_count == count)
        return;

    m_count = count;
    emit countChanged(m_count);
}

bool MachineData::getHasStopped() const
{
    return m_hasStopped;
}

void MachineData::setHasStopped(bool hasStopped)
{
    if (m_hasStopped == hasStopped)
        return;

    m_hasStopped = hasStopped;
    emit hasStoppedChanged(m_hasStopped);
}

int MachineData::getBlowerEcmDemandMode() const
{
    return m_blowerEcmDemandMode;
}

short MachineData::getBlowerDownflowState() const
{
    return m_blowerDownflowState;
}

short MachineData::getBlowerExhaustState() const
{
    return m_blowerExhaustState;
}

short MachineData::getLightState() const
{
    return m_lightState;
}

short MachineData::getSocketState() const
{
    return m_socketState;
}

short MachineData::getGasState() const
{
    return m_gasState;
}

short MachineData::getUvState() const
{
    return m_uvState;
}

short MachineData::getMuteAlarmState() const
{
    return m_muteAlarmState;
}

short MachineData::getSashWindowState() const
{
    return m_sashWindowState;
}

short MachineData::getSashWindowMotorizeState() const
{
    return m_sashWindowMotorizeState;
}

short MachineData::getLightIntensity() const
{
    return m_lightIntensity;
}

bool MachineData::getAlarmInflowLow() const
{
    return m_alarmInflowLow;
}

bool MachineData::getAlarmSashError() const
{
    return m_alarmSashError;
}

bool MachineData::getAlarmSashUnsafe() const
{
    return m_alarmSashUnsafe;
}

bool MachineData::getAlarmDownflowLow() const
{
    return m_alarmDownflowLow;
}

bool MachineData::getAlarmDownflowHigh() const
{
    return m_alarmDownflowHigh;
}

float MachineData::getVelocityInflowMatric() const
{
    return m_velocityInflowMatric;
}

float MachineData::getVelocityDownflowMatric() const
{
    return m_velocityDownflowMatric;
}

int MachineData::getInflowAdc() const
{
    return m_ifaAdc;
}

int MachineData::getInflowAdcConpensation() const
{
    return m_ifaAdcConpensation;
}

float MachineData::getInflowVelocity() const
{
    return m_ifaVelocity;
}

float MachineData::getInflowVelocityImperial() const
{
    return m_ifaVelocityImperial;
}

int MachineData::getDownflowAdc() const
{
    return m_dfaAdc;
}

int MachineData::getDownflowAdcConpensation() const
{
    return m_dfaAdcConpensation;
}

float MachineData::getDownflowVelocity() const
{
    return m_dfaVelocity;
}

float MachineData::getDownflowVelocityImperial() const
{
    return m_dfaVelocityImperial;
}

QString MachineData::getInflowVelocityStr() const
{
    return m_dfaVelocityStr;
}

QString MachineData::getDownflowVelocityStr() const
{
    return m_dfaVelocityStr;
}

int MachineData::getTemperatureAdc() const
{
    return m_temperatureAdc;
}

QString MachineData::getTemperatureValueStr() const
{
    return m_temperatureValueStr;
}

short MachineData::getMeasurementUnit() const
{
    return m_measurementUnit;
}

void MachineData::initSingleton()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
}

void MachineData::setDownflowTemperatureADCFactory(int dfaTemperatureADCFactory)
{
    m_dfaTemperatureADCFactory = dfaTemperatureADCFactory;
}

void MachineData::setDownflowTemperatureADCField(int dfaTemperatureADCField)
{
    m_dfaTemperatureADCField = dfaTemperatureADCField;
}

void MachineData::setDownflowTemperatureField(double dfaTemperatureField)
{
    m_dfaTemperatureField = dfaTemperatureField;
}

void MachineData::setDownflowTemperatureFactory(double dfaTemperatureFactory)
{
    m_dfaTemperatureFactory = dfaTemperatureFactory;
}

void MachineData::setBlowerEcmDemandMode(int blowerEcmDemandMode)
{
    if (m_blowerEcmDemandMode == blowerEcmDemandMode)
        return;

    m_blowerEcmDemandMode = blowerEcmDemandMode;
    emit blowerEcmDemandModeChanged(m_blowerEcmDemandMode);
}

void MachineData::setBlowerDownflowState(short blowerDownflowState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if (m_blowerDownflowState == blowerDownflowState)
        return;

    m_blowerDownflowState = blowerDownflowState;
    emit blowerDownflowStateChanged(m_blowerDownflowState);
}

void MachineData::setBlowerExhaustState(short blowerExhaustState)
{
    if (m_blowerExhaustState == blowerExhaustState)
        return;

    m_blowerExhaustState = blowerExhaustState;
    emit blowerExhaustStateChanged(m_blowerExhaustState);
}

void MachineData::setLightState(short lightState)
{
    if (m_lightState == lightState)
        return;

    m_lightState = lightState;
    emit lightStateChanged(m_lightState);
}

void MachineData::setSocketState(short socketState)
{
    if (m_socketState == socketState)
        return;

    m_socketState = socketState;
    emit lightStateChanged(m_socketState);
}

void MachineData::setGasState(short gasState)
{
    if (m_gasState == gasState)
        return;

    m_gasState = gasState;
    emit gasStateChanged(m_gasState);
}

void MachineData::setUvState(short uvState)
{
    if (m_uvState == uvState)
        return;

    m_uvState = uvState;
    emit uvStateChanged(m_uvState);
}

void MachineData::setMuteAlarmState(short muteAlarmState)
{
    if (m_muteAlarmState == muteAlarmState)
        return;

    m_muteAlarmState = muteAlarmState;
    emit muteAlarmStateChanged(m_muteAlarmState);
}

void MachineData::setSashWindowState(short sashWindowState)
{
    if (m_sashWindowState == sashWindowState)
        return;

    m_sashWindowState = sashWindowState;
    emit sashWindowStateChanged(m_sashWindowState);
}

void MachineData::setSashWindowMotorizeState(short sashMotorizeState)
{
    if (m_sashWindowMotorizeState == sashMotorizeState)
        return;

    m_sashWindowMotorizeState = sashMotorizeState;
    emit sashWindowMotorizeStateChanged(m_sashWindowMotorizeState);
}

void MachineData::setLightIntensity(short lightIntensity)
{
    if (m_lightIntensity == lightIntensity)
        return;

    m_lightIntensity = lightIntensity;
    emit lightIntensityChanged(m_lightIntensity);
}

void MachineData::setAlarmInflowLow(bool alarmInflowLow)
{
    if (m_alarmInflowLow == alarmInflowLow)
        return;

    m_alarmInflowLow = alarmInflowLow;
    emit alarmInflowLowChanged(m_alarmInflowLow);
}

void MachineData::setAlarmSashError(bool alarmSashError)
{
    if (m_alarmSashError == alarmSashError)
        return;

    m_alarmSashError = alarmSashError;
    emit alarmSashErrorChanged(m_alarmSashError);
}

void MachineData::setAlarmSashUnsafe(bool alarmSashUnsafe)
{
    if (m_alarmSashUnsafe == alarmSashUnsafe)
        return;

    m_alarmSashUnsafe = alarmSashUnsafe;
    emit alarmSashUnsafeChanged(m_alarmSashUnsafe);
}

void MachineData::setAlarmDownfLow(bool alarmDownflowLow)
{
    if (m_alarmDownflowLow == alarmDownflowLow)
        return;

    m_alarmDownflowLow = alarmDownflowLow;
    emit alarmDownflowHighChanged(m_alarmDownflowLow);
}

void MachineData::setAlarmDownfHigh(bool alarmDownflowHigh)
{
    if (m_alarmDownflowHigh == alarmDownflowHigh)
        return;

    m_alarmDownflowHigh = alarmDownflowHigh;
    emit alarmDownflowHighChanged(m_alarmDownflowHigh);
}

void MachineData::setVelocityInflowMatric(float velocityInflowMatric)
{
    //    qWarning("Floating point comparison needs context sanity check");
    if (qFuzzyCompare(1 + m_velocityInflowMatric, 1 + velocityInflowMatric))
        return;

    m_velocityInflowMatric = velocityInflowMatric;
    emit velocityInflowMatricChanged(m_velocityInflowMatric);
}

void MachineData::setVelocityDownflowMatric(float velocityDownflowMatric)
{
    //        qWarning("Floating point comparison needs context sanity check");
    if (qFuzzyCompare(1 + m_velocityDownflowMatric, 1 + velocityDownflowMatric))
        return;

    m_velocityDownflowMatric = velocityDownflowMatric;
    emit velocityDownflowMatricChanged(m_velocityDownflowMatric);
}

void MachineData::setInflowAdc(int ifaAdc)
{
    if (m_ifaAdc == ifaAdc)
        return;

    m_ifaAdc = ifaAdc;
    emit ifaAdcChanged(m_ifaAdc);
}

void MachineData::setInflowAdcConpensation(int ifaAdcConpensation)
{
    if (m_ifaAdcConpensation == ifaAdcConpensation)
        return;

    m_ifaAdcConpensation = ifaAdcConpensation;
    emit ifaAdcConpensationChanged(m_ifaAdcConpensation);
}

void MachineData::setInflowVelocity(float ifaVelocity)
{
    //    qWarning("Floating point comparison needs context sanity check");
    if (qFuzzyCompare(1+m_ifaVelocity, 1+ifaVelocity))
        return;

    m_ifaVelocity = ifaVelocity;
    emit ifaVelocityChanged(m_ifaVelocity);
}

void MachineData::setInflowVelocityImperial(float ifaVelocityImperial)
{
    qWarning("Floating point comparison needs context sanity check");
    if (qFuzzyCompare(1+m_ifaVelocityImperial, 1+ifaVelocityImperial))
        return;

    m_ifaVelocityImperial = ifaVelocityImperial;
    emit ifaVelocityImperialChanged(m_ifaVelocityImperial);
}

void MachineData::setDownflowAdc(int dfaAdc)
{
    if (m_dfaAdc == dfaAdc)
        return;

    m_dfaAdc = dfaAdc;
    emit ifaAdcChanged(m_dfaAdc);
}

void MachineData::setDownflowAdcConpensation(int dfaAdcConpensation)
{
    if (m_dfaAdcConpensation == dfaAdcConpensation)
        return;

    m_dfaAdcConpensation = dfaAdcConpensation;
    emit dfaAdcConpensationChanged(m_dfaAdcConpensation);
}

void MachineData::setDownflowVelocity(float dfaVelocity)
{
    //    qWarning("Floating point comparison needs context sanity check");
    if (qFuzzyCompare(1+m_dfaVelocity, 1+dfaVelocity))
        return;

    m_dfaVelocity = dfaVelocity;
    emit dfaVelocityChanged(m_dfaVelocity);
}

void MachineData::setDownflowVelocityImperial(float dfaVelocityImperial)
{
    //    qWarning("Floating point comparison needs context sanity check");
    if (qFuzzyCompare(1+m_dfaVelocityImperial, 1+dfaVelocityImperial))
        return;

    m_dfaVelocityImperial = dfaVelocityImperial;
    emit dfaVelocityImperialChanged(m_dfaVelocityImperial);
}

void MachineData::setInflowVelocityStr(QString ifaVelocityStr)
{
    if (m_ifaVelocityStr == ifaVelocityStr)
        return;

    m_ifaVelocityStr = ifaVelocityStr;
    emit ifaVelocityStrChanged(m_ifaVelocityStr);
}

void MachineData::setDownflowVelocityStr(QString dfaVelocityStr)
{
    if (m_dfaVelocityStr == dfaVelocityStr)
        return;

    m_dfaVelocityStr = dfaVelocityStr;
    emit dfaVelocityStrChanged(m_dfaVelocityStr);
}

void MachineData::setTemperatureAdc(int temperatureAdc)
{
    if (m_temperatureAdc == temperatureAdc)
        return;

    m_temperatureAdc = temperatureAdc;
    emit temperatureAdcChanged(m_temperatureAdc);
}

void MachineData::setTemperatureValueStr(QString temperatureValueStr)
{
    if (m_temperatureValueStr == temperatureValueStr)
        return;

    m_temperatureValueStr = temperatureValueStr;
    emit temperatureValueStrChanged(m_temperatureValueStr);
}

void MachineData::setMeasurementUnit(short measurementUnit)
{
    if (m_measurementUnit == measurementUnit)
        return;

    m_measurementUnit = measurementUnit;
    emit measurementUnitChanged(m_measurementUnit);
}

void MachineData::setDownflowTemperatureADC(int dfaTemperatureADC)
{
    m_dfaTemperatureADC = dfaTemperatureADC;
}

void MachineData::setDownflowTemperature(double dfaTemperature)
{
    m_dfaTemperature = dfaTemperature;
}

int MachineData::getDownflowTemperatureADC() const
{
    return m_dfaTemperatureADC;
}

double MachineData::getDownflowTemperature() const
{
    return m_dfaTemperature;
}

int MachineData::getDownflowTemperatureADCFactory() const
{
    return m_dfaTemperatureADCFactory;
}

double MachineData::getDownflowTemperatureFactory() const
{
    return m_dfaTemperatureFactory;
}

int MachineData::getDownflowTemperatureADCField() const
{
    return m_dfaTemperatureADCField;
}

double MachineData::getDownflowTemperatureField() const
{
    return m_dfaTemperatureField;
}

double MachineData::getDownflowHighLimitVelocity() const
{
    return m_dfaHigLimitVelocity;
}

void MachineData::setDownflowHigLimitVelocity(double dfaHigLimitVelocity)
{
    m_dfaHigLimitVelocity = dfaHigLimitVelocity;
}

double MachineData::getDownflowLowLimitVelocity() const
{
    return m_dfaLowLimitVelocity;
}

void MachineData::setDownflowLowLimitVelocity(double dfaLowLimitVelocity)
{
    m_dfaLowLimitVelocity = dfaLowLimitVelocity;
}

double MachineData::getInflowLowLimitVelocity() const
{
    return m_ifaLowLimitVelocity;
}

void MachineData::setInflowLowLimitVelocity(double ifaLowLimitVelocity)
{
    m_ifaLowLimitVelocity = ifaLowLimitVelocity;
}

int MachineData::getInflowTemperatureADCField() const
{
    return m_ifaTemperatureADCField;
}

void MachineData::setInflowTemperatureADCField(int ifaTemperatureADCField)
{
    m_ifaTemperatureADCField = ifaTemperatureADCField;
}

double MachineData::getInflowTemperatureField() const
{
    return m_ifaTemperatureField;
}

void MachineData::setInflowTemperatureField(double ifaTemperatureField)
{
    m_ifaTemperatureField = ifaTemperatureField;
}

int MachineData::getInflowTemperatureADCFactory() const
{
    return m_ifaTemperatureADCFactory;
}

void MachineData::setInflowTemperatureADCFactory(int ifaTemperatureADCFactory)
{
    m_ifaTemperatureADCFactory = ifaTemperatureADCFactory;
}

double MachineData::getInflowTemperatureFactory() const
{
    return m_ifaTemperatureFactory;
}

void MachineData::setInflowTemperatureFactory(double ifaTemperatureFactory)
{
    m_ifaTemperatureFactory = ifaTemperatureFactory;
}

int MachineData::getInflowTemperatureADC() const
{
    return m_ifaTemperatureADC;
}

void MachineData::setInflowTemperatureADC(int ifaTemperatureADC)
{
    m_ifaTemperatureADC = ifaTemperatureADC;
}

double MachineData::getInflowTemperature() const
{
    return m_ifaTemperature;
}

void MachineData::setInflowTemperature(double ifaTemperature)
{
    m_ifaTemperature = ifaTemperature;
}

int MachineData::getInflowConstant() const
{
    return m_ifaConstant;
}

void MachineData::setInflowConstant(int ifaConstant)
{
    m_ifaConstant = ifaConstant;
}


void MachineData::setInflowAdcPoint(short point, int adc)
{
    if(m_dfaAdcPoint[point] == adc) return;
    m_dfaAdcPoint[point] = adc;
}

void MachineData::setInflowAdcPointFactory(short point, int adc)
{
    if(m_ifaAdcPointFactory[point] == adc) return;
    m_ifaAdcPointFactory[point] = adc;
}

void MachineData::setInflowAdcPointField(short point, int adc)
{
    if(m_ifaAdcPointField[point] == adc) return;
    m_ifaAdcPointField[point] = adc;
}

void MachineData::setInflowVelocityPoint(short point, float value)
{
    m_dfaVelocityPoint[point] = value;
}

void MachineData::setInflowVelocityPointFactory(short point, float value)
{
    m_dfaVelocityPointFactory[point] = value;
}

void MachineData::setInflowVelocityPointField(short point, float value)
{
    m_dfaVelocityPointField[point] = value;
}

void MachineData::setDownflowAdcPoint(short point, int adc)
{
    if(m_dfaAdcPoint[point] == adc) return;
    m_dfaAdcPoint[point] = adc;
}

void MachineData::setDownflowAdcPointFactory(short point, int adc)
{
    if(m_dfaAdcPointFactory[point] == adc) return;
    m_dfaAdcPointFactory[point] = adc;
}

void MachineData::setDownflowAdcPointField(short point, int adc)
{
    if(m_dfaAdcPointField[point] == adc) return;
    m_dfaAdcPointField[point] = adc;
}

void MachineData::setDownflowVelocityPoint(short point, float value)
{
    m_dfaVelocityPoint[point] = value;
}

void MachineData::setDownflowVelocityPointFactory(short point, float value)
{
    m_dfaVelocityPointFactory[point] = value;
}

void MachineData::setDownflowVelocityPointField(short point, float value)
{
    m_dfaVelocityPointField[point] = value;
}

int MachineData::getDownflowConstant() const
{
    return m_dfaConstant;
}

void MachineData::setDownflowConstant(int dfaConstant)
{
    m_dfaConstant = dfaConstant;
}
