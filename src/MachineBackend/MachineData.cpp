#include <QQmlEngine>
#include <QJSEngine>

#include <QDebug>

#include "MachineData.h"

static MachineData* s_instance = nullptr;

QObject *MachineData::singletonProvider(QQmlEngine *qmlEngine, QJSEngine *)
{
    if(!s_instance){
        qDebug() << "MachineData::singletonProvider::create" << s_instance;
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

void MachineData::initSingleton()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
}

void MachineData::setShippingModeEnable(bool shippingModeEnable)
{
    if (m_shippingModeEnable == shippingModeEnable)
        return;

    m_shippingModeEnable = shippingModeEnable;
    emit shippingModeEnableChanged(m_shippingModeEnable);
}

QString MachineData::getSbcCurrentFullMacAddress() const
{
    return m_sbcCurrentFullMacAddress;
}

void MachineData::setSbcCurrentFullMacAddress(QString sbcCurrentFullMacAddress)
{
    if(m_sbcCurrentFullMacAddress == sbcCurrentFullMacAddress)return;
    m_sbcCurrentFullMacAddress = sbcCurrentFullMacAddress;
    //    emit sbcCurrentFullMacAddressChanged(m_sbcCurrentFullMacAddress);
}

QStringList MachineData::getSbcSystemInformation() const
{
    return m_sbcSystemInformation;
}

void MachineData::setSbcSystemInformation(QStringList sbcSystemInformation)
{
    if(m_sbcSystemInformation == sbcSystemInformation)return;
    m_sbcSystemInformation = sbcSystemInformation;
}

bool MachineData::getSbcCurrentSerialNumberKnown() const
{
    return m_sbcCurrentSerialNumberKnown;
}

void MachineData::setSbcCurrentSerialNumberKnown(bool value)
{
    if(m_sbcCurrentSerialNumberKnown == value) return;
    m_sbcCurrentSerialNumberKnown = value;
}

QString MachineData::getSbcCurrentSerialNumber() const
{
    return m_sbcCurrentSerialNumber;
}

void MachineData::setSbcCurrentSerialNumber(QString value)
{
    if(m_sbcCurrentSerialNumber == value)return;
    m_sbcCurrentSerialNumber = value;
}


QStringList MachineData::getSbcCurrentSystemInformation() const
{
    return m_sbcCurrentSystemInformation;
}

void MachineData::setSbcCurrentSystemInformation(QStringList sbcCurrentSystemInformation)
{
    if(m_sbcCurrentSystemInformation == sbcCurrentSystemInformation)return;
    m_sbcCurrentSystemInformation = sbcCurrentSystemInformation;
}

ushort MachineData::getAlarmPreventMaintState() const
{
    return m_alarmPreventMaintState;
}

ushort MachineData::getAlarmPreventMaintStateEnable() const
{
    return m_alarmPreventMaintStateEnable;
}

ushort MachineData::getAlarmPreventMaintStateAck() const
{
    return m_alarmPreventMaintStateAck;
}

bool MachineData::getFanClosedLoopControlEnable() const
{
    return m_fanClosedLoopControlEnable;
}

void MachineData::setFanClosedLoopControlEnable(bool value)
{
    if(m_fanClosedLoopControlEnable == value)return;
    m_fanClosedLoopControlEnable = value;
    emit fanClosedLoopControlEnableChanged(m_fanClosedLoopControlEnable);
}

bool MachineData::getFanFanClosedLoopControlEnablePrevState() const
{
    return m_fanFanClosedLoopControlEnablePrevState;
}

void MachineData::setFanFanClosedLoopControlEnablePrevState(bool value)
{
    if(m_fanFanClosedLoopControlEnablePrevState == value)return;
    m_fanFanClosedLoopControlEnablePrevState = value;
    emit fanFanClosedLoopControlEnablePrevStateChanged(m_fanFanClosedLoopControlEnablePrevState);
}

float MachineData::getFanClosedLoopGainProportional(short index) const
{
    return m_fanClosedLoopGainProportional[index];
}

void MachineData::setFanClosedLoopGainProportional(float value, short index)
{
    if(m_fanClosedLoopGainProportional[index] == value)return;
    m_fanClosedLoopGainProportional[index] = value;
}

float MachineData::getFanClosedLoopGainIntegral(short index) const
{
    return m_fanClosedLoopGainIntegral[index];
}

void MachineData::setFanClosedLoopGainIntegral(float value, short index)
{
    if(m_fanClosedLoopGainIntegral[index] == value)return;
    m_fanClosedLoopGainIntegral[index] = value;
}

float MachineData::getFanClosedLoopGainDerivative(short index) const
{
    return m_fanClosedLoopGainDerivative[index];
}

void MachineData::setFanClosedLoopGainDerivative(float value, short index)
{
    if(m_fanClosedLoopGainDerivative[index] == value)return;
    m_fanClosedLoopGainDerivative[index] = value;
}

int MachineData::getFanClosedLoopSamplingTime() const
{
    return m_fanClosedLoopSamplingTime;
}

void MachineData::setFanClosedLoopSamplingTime(int value)
{
    if(m_fanClosedLoopSamplingTime == value)return;
    m_fanClosedLoopSamplingTime = value;
}

int MachineData::getFanClosedLoopSetpoint(short index) const
{
    return m_fanClosedLoopSetpoint[index];
}

void MachineData::setFanClosedLoopSetpoint(int value, short index)
{
    if(m_fanClosedLoopSetpoint[index] == value)return;
    m_fanClosedLoopSetpoint[index] = value;
}

ushort MachineData::getDfaVelClosedLoopResponse(short index) const
{
    if(index >= 60) return 0;
    return m_dfaVelClosedLoopResponse[index];
}

void MachineData::setDfaVelClosedLoopResponse(ushort value, short index)
{
    if(index >= 60) return;
    if(m_dfaVelClosedLoopResponse[index] == value) return;
    m_dfaVelClosedLoopResponse[index] = value;
}

ushort MachineData::getIfaVelClosedLoopResponse(short index) const
{
    if(index >= 60) return 0;
    return m_ifaVelClosedLoopResponse[index];
}

void MachineData::setIfaVelClosedLoopResponse(ushort value, short index)
{
    if(index >= 60) return;
    if(m_ifaVelClosedLoopResponse[index] == value) return;
    m_ifaVelClosedLoopResponse[index] = value;
}

bool MachineData::getClosedLoopResponseStatus() const
{
    return m_closeLoopResponseStatus;
}

void MachineData::setClosedLoopResponseStatus(bool value)
{
    if(m_closeLoopResponseStatus == value) return;
    m_closeLoopResponseStatus = value;
    emit closedLoopResponseStatusChanged(value);
}

bool MachineData::getReadClosedLoopResponse() const
{
    return m_readClosedLoopResponse;
}

void MachineData::setReadClosedLoopResponse(bool value)
{
    if(m_readClosedLoopResponse == value) return;
    m_readClosedLoopResponse = value;
}

QString MachineData::getDailyPreventMaintAckDueDate() const
{
    return m_dailyPreventMaintAckDueDate;
}

QString MachineData::getWeeklyPreventMaintAckDueDate() const
{
    return m_weeklyPreventMaintAckDueDate;
}

QString MachineData::getMonthlyPreventMaintAckDueDate() const
{
    return m_monthlyPreventMaintAckDueDate;
}

QString MachineData::getQuarterlyPreventMaintAckDueDate() const
{
    return m_quarterlyPreventMaintAckDueDate;
}

QString MachineData::getAnnuallyPreventMaintAckDueDate() const
{
    return m_annuallyPreventMaintAckDueDate;
}

QString MachineData::getBienniallyPreventMaintAckDueDate() const
{
    return m_bienniallyPreventMaintAckDueDate;
}

QString MachineData::getQuinquenniallyPreventMaintAckDueDate() const
{
    return m_quinquenniallyPreventMaintAckDueDate;
}

QString MachineData::getCanopyPreventMaintAckDueDate() const
{
    return m_canopyPreventMaintAckDueDate;
}

QString MachineData::getDailyPreventMaintLastAckDate() const
{
    return m_dailyPreventMaintLastAckDate;
}

QString MachineData::getWeeklyPreventMaintLastAckDate() const
{
    return m_weeklyPreventMaintLastAckDate;
}

QString MachineData::getMonthlyPreventMaintLastAckDate() const
{
    return m_monthlyPreventMaintLastAckDate;
}

QString MachineData::getQuarterlyPreventMaintLastAckDate() const
{
    return m_quarterlyPreventMaintLastAckDate;
}

QString MachineData::getAnnuallyPreventMaintLastAckDate() const
{
    return m_annuallyPreventMaintLastAckDate;
}

QString MachineData::getBienniallyPreventMaintLastAckDate() const
{
    return m_bienniallyPreventMaintLastAckDate;
}

QString MachineData::getQuinquenniallyPreventMaintLastAckDate() const
{
    return m_quinquenniallyPreventMaintLastAckDate;
}

QString MachineData::getCanopyPreventMaintLastAckDate() const
{
    return m_canopyPreventMaintLastAckDate;
}

//void MachineData::setMaintenanceChecklist(QJsonObject value)
//{
//    if(m_maintenanceChecklist == value)return;
//    m_maintenanceChecklist = value;
//    emit maintenanceChecklistChanged(value);
//}

void MachineData::setAlarmPreventMaintState(ushort value)
{
    if(m_alarmPreventMaintState == value)return;
    m_alarmPreventMaintState = value;
    emit alarmPreventMaintStateChanged(value);
}

void MachineData::setAlarmPreventMaintStateEnable(ushort value)
{
    if(m_alarmPreventMaintStateEnable == value)return;
    m_alarmPreventMaintStateEnable = value;
    emit alarmPreventMaintStateEnableChanged(value);
}

void MachineData::setAlarmPreventMaintStateAck(ushort value)
{
    if(m_alarmPreventMaintStateAck == value) return;
    m_alarmPreventMaintStateAck = value;
    emit alarmPreventMaintStateAckChanged(value);
}

//void MachineData::setPreventMaintChecklistNotEmpty(ushort value)
//{
//    if(m_preventMaintChecklistNotEmpty == value)return;
//    m_preventMaintChecklistNotEmpty = value;
//    emit preventMaintChecklistNotEmptyChanged(value);
//}

//void MachineData::setDailyPreventMaintAck(bool value)
//{
//    if(m_dailyPreventMaintAck == value)return;
//    m_dailyPreventMaintAck = value;
//    emit dailyPreventMaintAckChanged(value);
//}

//void MachineData::setWeeklyPreventMaintAck(bool value)
//{
//    if(m_weeklyPreventMaintAck == value)return;
//    m_weeklyPreventMaintAck = value;
//    emit weeklyPreventMaintAckChanged(value);
//}

//void MachineData::setMonthlyPreventMaintAck(bool value)
//{
//    if(m_monthlyPreventMaintAck == value)return;
//    m_monthlyPreventMaintAck = value;
//    emit monthlyPreventMaintAckChanged(value);
//}

//void MachineData::setQuarterlyPreventMaintAck(bool value)
//{
//    if(m_quarterlyPreventMaintAck == value)return;
//    m_quarterlyPreventMaintAck = value;
//    emit quarterlyPreventMaintAckChanged(value);
//}

//void MachineData::setAnnuallyPreventMaintAck(bool value)
//{
//    if(m_annuallyPreventMaintAck == value)return;
//    m_annuallyPreventMaintAck = value;
//    emit annuallyPreventMaintAckChanged(value);
//}

//void MachineData::setBienniallyPreventMaintAck(bool value)
//{
//    if(m_bienniallyPreventMaintAck == value)return;
//    m_bienniallyPreventMaintAck = value;
//    emit bienniallyPreventMaintAckChanged(value);
//}

//void MachineData::setQuinquenniallyPreventMaintAck(bool value)
//{
//    if(m_quinquenniallyPreventMaintAck == value)return;
//    m_quinquenniallyPreventMaintAck = value;
//    emit quinquenniallyPreventMaintAckChanged(value);
//}

//void MachineData::setCanopyPreventMaintAck(bool value)
//{
//    if(m_canopyPreventMaintAck == value)return;
//    m_canopyPreventMaintAck = value;
//    emit canopyPreventMaintAckChanged(value);
//}

void MachineData::setDailyPreventMaintAckDueDate(QString value)
{
    if(m_dailyPreventMaintAckDueDate == value)return;
    m_dailyPreventMaintAckDueDate = value;
    emit dailyPreventMaintAckDueDateChanged(value);
}

void MachineData::setWeeklyPreventMaintAckDueDate(QString value)
{
    if(m_weeklyPreventMaintAckDueDate == value)return;
    m_weeklyPreventMaintAckDueDate = value;
    emit weeklyPreventMaintAckDueDateChanged(value);
}

void MachineData::setMonthlyPreventMaintAckDueDate(QString value)
{
    if(m_monthlyPreventMaintAckDueDate == value)return;
    m_monthlyPreventMaintAckDueDate = value;
    emit monthlyPreventMaintAckDueDateChanged(value);
}

void MachineData::setQuarterlyPreventMaintAckDueDate(QString value)
{
    if(m_quarterlyPreventMaintAckDueDate == value)return;
    m_quarterlyPreventMaintAckDueDate = value;
    emit quarterlyPreventMaintAckDueDateChanged(value);
}

void MachineData::setAnnuallyPreventMaintAckDueDate(QString value)
{
    if(m_annuallyPreventMaintAckDueDate == value)return;
    m_annuallyPreventMaintAckDueDate = value;
    emit annuallyPreventMaintAckDueDateChanged(value);
}

void MachineData::setBienniallyPreventMaintAckDueDate(QString value)
{
    if(m_bienniallyPreventMaintAckDueDate == value)return;
    m_bienniallyPreventMaintAckDueDate = value;
    emit bienniallyPreventMaintAckDueDateChanged(value);
}

void MachineData::setQuinquenniallyPreventMaintAckDueDate(QString value)
{
    if(m_quinquenniallyPreventMaintAckDueDate == value)return;
    m_quinquenniallyPreventMaintAckDueDate = value;
    emit quinquenniallyPreventMaintAckDueDateChanged(value);
}

void MachineData::setCanopyPreventMaintAckDueDate(QString value)
{
    if(m_canopyPreventMaintAckDueDate == value)return;
    m_canopyPreventMaintAckDueDate = value;
    emit canopyPreventMaintAckDueDateChanged(value);
}

void MachineData::setDailyPreventMaintLastAckDate(QString value)
{
    if(m_dailyPreventMaintLastAckDate == value)return;
    m_dailyPreventMaintLastAckDate = value;
    emit dailyPreventMaintLastAckDateChanged(value);
}

void MachineData::setWeeklyPreventMaintLastAckDate(QString value)
{
    if(m_weeklyPreventMaintLastAckDate == value)return;
    m_weeklyPreventMaintLastAckDate = value;
    emit weeklyPreventMaintLastAckDateChanged(value);
}

void MachineData::setMonthlyPreventMaintLastAckDate(QString value)
{
    if(m_monthlyPreventMaintLastAckDate == value)return;
    m_monthlyPreventMaintLastAckDate = value;
    emit monthlyPreventMaintLastAckDateChanged(value);
}

void MachineData::setQuarterlyPreventMaintLastAckDate(QString value)
{
    if(m_quarterlyPreventMaintLastAckDate == value)return;
    m_quarterlyPreventMaintLastAckDate = value;
    emit quarterlyPreventMaintLastAckDateChanged(value);
}

void MachineData::setAnnuallyPreventMaintLastAckDate(QString value)
{
    if(m_annuallyPreventMaintLastAckDate == value)return;
    m_annuallyPreventMaintLastAckDate = value;
    emit annuallyPreventMaintLastAckDateChanged(value);
}

void MachineData::setBienniallyPreventMaintLastAckDate(QString value)
{
    if(m_bienniallyPreventMaintLastAckDate == value)return;
    m_bienniallyPreventMaintLastAckDate = value;
    emit bienniallyPreventMaintLastAckDateChanged(value);
}

void MachineData::setQuinquenniallyPreventMaintLastAckDate(QString value)
{
    if(m_quinquenniallyPreventMaintLastAckDate == value)return;
    m_quinquenniallyPreventMaintLastAckDate = value;
    emit quinquenniallyPreventMaintLastAckDateChanged(value);
}

void MachineData::setCanopyPreventMaintLastAckDate(QString value)
{
    if(m_canopyPreventMaintLastAckDate == value)return;
    m_canopyPreventMaintLastAckDate = value;
    emit canopyPreventMaintLastAckDateChanged(value);
}

void MachineData::setEth0ConName(QString value)
{
    if(m_eth0ConName == value)return;
    m_eth0ConName = value;
}

void MachineData::setEth0Ipv4Address(QString value)
{
    if(m_eth0Ipv4Address == value)return;
    m_eth0Ipv4Address = value;
}

void MachineData::setEth0ConEnabled(bool value)
{
    if(m_eth0ConEnabled == value)return;
    m_eth0ConEnabled = value;
}

QString MachineData::getEth0ConName() const
{
    return m_eth0ConName;
}

QString MachineData::getEth0Ipv4Address() const
{
    return m_eth0Ipv4Address;
}

bool MachineData::getEth0ConEnabled() const
{
    return m_eth0ConEnabled;
}

void MachineData::setWiredNetworkHasbeenConfigured(bool value)
{
    if(m_wiredNetworkHasbeenConfigured == value)return;
    m_wiredNetworkHasbeenConfigured = value;
    emit wiredNetworkHasbeenConfiguredChanged(value);
}

bool MachineData::getWiredNetworkHasbeenConfigured() const
{
    return m_wiredNetworkHasbeenConfigured;
}

void MachineData::setSvnUpdateAvailable(bool value)
{
    if(m_svnUpdateAvailable == value)return;
    m_svnUpdateAvailable = value;
    emit svnUpdateAvailableChanged(value);
}

void MachineData::setSvnUpdateSwuVersion(QString value)
{
    if(m_svnUpdateSwuVersion == value)return;
    m_svnUpdateSwuVersion = value;
    emit svnUpdateSwuVersionChanged(value);
}

void MachineData::setSvnUpdatePath(QString value)
{
    if(m_svnUpdatePath == value)return;
    m_svnUpdatePath = value;
    emit svnUpdatePathChanged(value);
}

void MachineData::setSvnUpdateHistory(QJsonObject value)
{
    if(m_svnUpdateHistory == value)return;
    m_svnUpdateHistory = value;
    emit svnUpdateHistoryChanged(value);
}

bool MachineData::getSvnUpdateAvailable() const
{
    return m_svnUpdateAvailable;
}

QString MachineData::getSvnUpdateSwuVersion() const
{
    return m_svnUpdateSwuVersion;
}

QString MachineData::getSvnUpdatePath() const
{
    return m_svnUpdatePath;
}

QJsonObject MachineData::getSvnUpdateHistory() const
{
    return m_svnUpdateHistory;
}

bool MachineData::getSvnUpdateCheckForUpdateEnable() const
{
    return m_svnUpdateCheckForUpdateEnable;
}

int MachineData::getSvnUpdateCheckForUpdatePeriod() const
{
    return m_svnUpdateCheckForUpdatePeriod;
}

void MachineData::setSvnUpdateCheckForUpdateEnable(bool value)
{
    if(m_svnUpdateCheckForUpdateEnable == value)return;
    m_svnUpdateCheckForUpdateEnable = value;
    emit svnUpdateCheckForUpdateEnableChanged(value);
}

void MachineData::setSvnUpdateCheckForUpdatePeriod(int value)
{
    if(m_svnUpdateCheckForUpdatePeriod == value)return;
    m_svnUpdateCheckForUpdatePeriod = value;
    emit svnUpdateCheckForUpdatePeriodChanged(value);
}

void MachineData::setRpListDefault(QJsonObject value)
{
    if(m_rpListDefault == value)return;
    m_rpListDefault = value;
    emit rpListDefaultChanged(value);
    qDebug() << value;
}

void MachineData::setRpListLast(QVariantList value)
{
    if(m_rpListLast == value)return;
    m_rpListLast = value;
    emit rpListLastChanged(value);
}

void MachineData::setRpListLast(short index, QString value)
{
    if(index >= m_rpListLast.length() || index < 0) return;
    if(m_rpListLast.at(index).toString() == value) return;

    QVariantList tempVarList = m_rpListLast;
    //    qDebug() << "replace index" << index << tempVarList.at(index) << "with" << value;
    //    qDebug() << "before" << tempVarList.at(index).toString();
    tempVarList.takeAt(index);
    tempVarList.insert(index, value);
    //    qDebug() << "after" << tempVarList.at(index).toString();
    setRpListLast(tempVarList);
}

QJsonObject MachineData::getRpListDefault() const
{
    return m_rpListDefault;
}

QVariantList MachineData::getRpListLast() const
{
    return m_rpListLast;
}

QString MachineData::getRpListLastAtIndex(short index) const
{
    if(index >= m_rpListLast.length() || m_rpListLast.length() < 0) return "";
    return m_rpListLast.at(index).toString();
}

void MachineData::setRpListSelected(QVariantList value)
{
    if(m_rpListSelected == value)return;
    m_rpListSelected = value;
    emit rpListSelectedChanged(value);
}

void MachineData::setRpListSelected(short index, QString value)
{
    if(index >= m_rpListSelected.length() || index < 0) return;
    if(m_rpListSelected.at(index).toString() == value) return;

    QVariantList tempVarList = m_rpListSelected;
    //    qDebug() << "replace index" << index << tempVarList.at(index) << "with" << value;
    //    qDebug() << "before" << tempVarList.at(index).toString();
    tempVarList.takeAt(index);
    tempVarList.insert(index, value);
    //    qDebug() << "after" << tempVarList.at(index).toString();
    setRpListSelected(tempVarList);
}

QVariantList MachineData::getRpListSelected() const
{
    return m_rpListSelected;
}

QString MachineData::getRpListSelectedAtIndex(short index) const
{
    if(index >= m_rpListSelected.length() || m_rpListSelected.length() < 0) return "";
    return m_rpListSelected.at(index).toString();
}

void MachineData::setKeyboardStringOnAcceptedEvent(const QString &value)
{
    emit keyboardStringOnAcceptedEventSignal(value);
    if(m_keyboardStringOnAcceptedEvent == value)return;
    m_keyboardStringOnAcceptedEvent = value;
    emit keyboardStringOnAcceptedEventChanged(value);
}

QString MachineData::getKeyboardStringOnAcceptedEvent() const
{
    return m_keyboardStringOnAcceptedEvent;
}

void MachineData::setUserLasLogin(QJsonArray value)
{
    if(m_userLastLogin == value) return;
    m_userLastLogin = value;
    emit userLastLoginChanged(value);
}

QJsonArray MachineData::getUserLastLogin() const
{
    return m_userLastLogin;
}

QString MachineData::getUsbDetectedList() const
{
    return m_usbDetectedList;
}

void MachineData::setUsbDetectedList(QString list)
{
    if(m_usbDetectedList == list)
        return;
    m_usbDetectedList = list;
    emit usbDetectedListChanged(m_usbDetectedList);
}

QString MachineData::getLastUsbDetectedName() const
{
    return m_lastUsbDetectedName;
}

void MachineData::setLastUsbDetectedName(QString name)
{
    if(m_lastUsbDetectedName == name)
        return;
    m_lastUsbDetectedName = name;
    emit lastUsbDetectedNameChanged(m_lastUsbDetectedName);
}

void MachineData::setFrontEndScreenState(short value)
{
    if(m_frontEndScreenState == value) return;
    m_frontEndScreenState = value;
    emit frontEndScreenStateChanged(value);
}

short MachineData::getFrontEndScreenState() const
{
    return m_frontEndScreenState;
}

void MachineData::setFrontEndScreenStatePrev(short value)
{
    if(m_frontEndScreenStatePrev == value) return;
    m_frontEndScreenStatePrev = value;
    emit frontEndScreenStatePrevChanged(value);
}

short MachineData::getFrontEndScreenStatePrev() const
{
    return m_frontEndScreenStatePrev;
}

void MachineData::setInstallationWizardActive(bool value)
{
    if(m_installationWizardActive == value)return;
    m_installationWizardActive = value;
    emit installationWizardActiveChanged(value);
}

bool MachineData::getInstallationWizardActive() const
{
    return m_installationWizardActive;
}

void MachineData::setCabinetUpTime(int value)
{
    if(m_cabinetUpTime == value)return;
    m_cabinetUpTime = value;
    emit cabinetUpTimeChanged(value);
}

int MachineData::getCabinetUpTime() const
{
    return m_cabinetUpTime;
}

bool MachineData::getFrontPanelSwitchInstalled() const
{
    return m_frontPanelSwitchInstalled;
}

bool MachineData::getFrontPanelSwitchState() const
{
    return m_frontPanelSwitchState;
}

short MachineData::getFrontPanelAlarm() const
{
    return m_frontPanelAlarm;
}

void MachineData::setFrontPanelSwitchInstalled(bool value)
{
    if(m_frontPanelSwitchInstalled == value) return;
    m_frontPanelSwitchInstalled = value;
    emit frontPanelSwitchInstalledChanged(value);
}

void MachineData::setFrontPanelSwitchState(bool value)
{
    if(m_frontPanelSwitchState == value) return;
    m_frontPanelSwitchState = value;
    emit frontPanelSwitchStateChanged(value);
}

void MachineData::setFrontPanelAlarm(short value)
{
    if(m_frontPanelAlarm == value) return;
    m_frontPanelAlarm = value;
    emit frontPanelAlarmChanged(value);
}

void MachineData::setRbmComPortAvailable(QString value)
{
    if(m_rbmComPortAvalaible == value) return;
    m_rbmComPortAvalaible = value;
    emit rbmComPortAvailableChanged(m_rbmComPortAvalaible);
}

void MachineData::setRbmComPortIfa(QString value)
{
    if(m_rbmComPortIfa == value) return;
    m_rbmComPortIfa = value;
    emit rbmComPortIfaChanged(m_rbmComPortIfa);
}

void MachineData::setRbmComPortDfa(QString value)
{
    if(m_rbmComPortDfa == value) return;
    m_rbmComPortDfa = value;
    emit rbmComPortDfaChanged(m_rbmComPortDfa);
}

QString MachineData::getRbmComPortAvailable() const
{
    return m_rbmComPortAvalaible;
}

QString MachineData::getRbmComPortIfa() const
{
    return m_rbmComPortIfa;
}

QString MachineData::getRbmComPortDfa() const
{
    return m_rbmComPortDfa;
}

void MachineData::setDualRbmMode(bool value)
{
    if(m_dualRbmMode == value) return;
    m_dualRbmMode = value;
    //    /emit dualRbmModeChanged(m_dualRbmMode);
}

bool MachineData::getDualRbmMode() const
{
    return m_dualRbmMode;
}

void MachineData::setSashMotorDownStuckSwitch(bool value)
{
    if(m_sashMotorDownStuckSwitch == value) return;
    m_sashMotorDownStuckSwitch = value;
    emit sashMotorDownStuckSwitchChanged(m_sashMotorDownStuckSwitch);
}

bool MachineData::getSashMotorDownStuckSwitch() const
{
    return m_sashMotorDownStuckSwitch;
}

short MachineData::getAlarmSashMotorDownStuck() const
{
    return m_alarmSashMotorDownStuck;
}

void MachineData::setAlarmSashMotorDownStuck(short value)
{
    if(m_alarmSashMotorDownStuck == value) return;
    m_alarmSashMotorDownStuck = value;
    emit alarmSashMotorDownStuckChanged(m_alarmSashMotorDownStuck);
}

void MachineData::setSashWindowSafeHeight2(bool value)
{
    if(m_sashWindowSafeHeight2 == value) return;
    m_sashWindowSafeHeight2 = value;
    emit sashWindowSafeHeight2Changed(m_sashWindowSafeHeight2);
}

bool MachineData::getSashWindowSafeHeight2() const
{
    return m_sashWindowSafeHeight2;
}

void MachineData::setSashMotorOffDelayMsec(int value)
{
    if(m_sashMotorOffDelayMsec == value)return;
    m_sashMotorOffDelayMsec = value;
    emit sashMotorOffDelayMsecChanged(value);
}

int MachineData::getSashMotorOffDelayMsec() const
{
    return m_sashMotorOffDelayMsec;
}

//void MachineData::setResourceMonitorParamsActive(bool value)
//{
//    if(m_resourceMonitorParamsActive == value) return;
//    m_resourceMonitorParamsActive = value;
//    emit resourceMonitorParamsActiveChanged(value);
//}

//bool MachineData::getResourceMonitorParamsActive() const
//{
//    return m_resourceMonitorParamsActive;
//}

void MachineData::setResourceMonitorParams(QStringList value)
{
    if(m_resourceMonitorParams == value)return;
    m_resourceMonitorParams = value;
    emit resourceMonitorParamsChanged(value);
}

QStringList MachineData::getResourceMonitorParams() const
{
    return m_resourceMonitorParams;
}

void MachineData::setHaBoardInputCh1MVolt(int value)
{
    if(m_haBoardInputCh1MVolt == value)return;
    m_haBoardInputCh1MVolt = value;
    emit haBoardInputCh1MVoltChanged(value);
}

void MachineData::setHaBoardInputCh2MVolt(int value)
{
    if(m_haBoardInputCh2MVolt == value)return;
    m_haBoardInputCh2MVolt = value;
    emit haBoardInputCh2MVoltChanged(value);
}

int MachineData::getHaBoardInputCh1MVolt() const
{
    return m_haBoardInputCh1MVolt;
}

int MachineData::getHaBoardInputCh2MVolt() const
{
    return m_haBoardInputCh2MVolt;
}



void MachineData::setDelayAlarmAirflowSec(int value)
{
    if(m_delayAlarmAirflowSec == value)return;
    m_delayAlarmAirflowSec = value;
    emit delayAlarmAirflowSecChanged(value);
}

int MachineData::getDelayAlarmAirflowSec() const
{
    return m_delayAlarmAirflowSec;
}

bool MachineData::getInflowValueHeld() const
{
    return m_inflowValueHeld;
}

void MachineData::setInflowValueHeld(bool value)
{
    qDebug() << metaObject()->className() << __func__ << value;
    if(m_inflowValueHeld == value)return;
    m_inflowValueHeld = value;
    emit inflowValueHeldChanged(value);
}

bool MachineData::getDownflowValueHeld() const
{
    return m_downflowValueHeld;
}

void MachineData::setDownflowValueHeld(bool value)
{
    qDebug() << metaObject()->className() << __func__ << value;
    if(m_downflowValueHeld == value)return;
    m_downflowValueHeld = value;
    emit downflowValueHeldChanged(value);
}

short MachineData::getCabinetWidthFeet() const
{
    return m_cabinetWidthFeet;
}

void MachineData::setCabinetWidthFeet(short value)
{
    if(m_cabinetWidthFeet == value)return;
    m_cabinetWidthFeet = value;
    emit cabinetWidthFeetChanged(value);
}

bool MachineData::getCabinetWidth3Feet() const
{
    return m_cabinetWidth3Feet;
}

void MachineData::setCabinetWidth3Feet(bool value)
{
    if(m_cabinetWidth3Feet == value)return;
    m_cabinetWidth3Feet = value;
    emit cabinetWidth3FeetChanged(value);
}

void MachineData::setUsePwmOutSignal(bool value)
{
    if(m_usePwmOutSignal == value)return;
    m_usePwmOutSignal = value;
    emit usePwmOutSignalChanged(value);
}

bool MachineData::getUsePwmOutSignal() const
{
    return m_usePwmOutSignal;
}

void MachineData::setScreenSaverSeconds(int value)
{
    if(m_screenSaverSeconds == value) return;
    m_screenSaverSeconds = value;
    emit screenSaverSecondsChanged(value);
}

int MachineData::getScreenSaverSeconds() const
{
    return m_screenSaverSeconds;
}

void MachineData::setCabinetSideType(short value)
{
    if(m_cabinetSideType == value)return;
    m_cabinetSideType = value;
    emit cabinetSideTypeChanged(value);
}

short MachineData::getCabinetSideType() const
{
    return m_cabinetSideType;
}

//void MachineData::setWifiDisabled(bool value)
//{
//    if(m_wifiDisabled == value)return;
//    m_wifiDisabled = value;
//    emit wifiDisabledChanged(value);
//}

//bool MachineData::getWifiDisabled() const
//{
//    return m_wifiDisabled;
//}

QString MachineData::getSbcSerialNumber() const
{
    return m_sbcSerialNumber;
}

void MachineData::setSbcSerialNumber(QString value)
{
    if(m_sbcSerialNumber == value)return;
    m_sbcSerialNumber = value;
}

void MachineData::setAlarmLogSpaceMaximum(int alarmLogSpaceMaximum)
{
    if (m_alarmLogSpaceMaximum == alarmLogSpaceMaximum)
        return;

    m_alarmLogSpaceMaximum = alarmLogSpaceMaximum;
    emit alarmLogSpaceMaximumChanged(m_alarmLogSpaceMaximum);
}

void MachineData::setEventLogSpaceMaximum(int eventLogSpaceMaximum)
{
    if (m_eventLogSpaceMaximum == eventLogSpaceMaximum)
        return;

    m_eventLogSpaceMaximum = eventLogSpaceMaximum;
    emit eventLogSpaceMaximumChanged(m_eventLogSpaceMaximum);
}

void MachineData::setDataLogSpaceMaximum(int dataLogSpaceMaximum)
{
    if (m_dataLogSpaceMaximum == dataLogSpaceMaximum)
        return;

    m_dataLogSpaceMaximum = dataLogSpaceMaximum;
    emit dataLogSpaceMaximumChanged(m_dataLogSpaceMaximum);
}

void MachineData::setReplaceableCompRecordSpaceMaximum(int value)
{
    if(m_replaceableCompRecordSpaceMaximum == value)return;
    m_replaceableCompRecordSpaceMaximum = value;
    emit replaceableCompRecordSpaceMaximumChanged(value);
}

void MachineData::setResourceMonitorLogSpaceMaximum(int value)
{
    if(m_resourceMonitorLogSpaceMaximum == value)return;
    m_resourceMonitorLogSpaceMaximum = value;
    emit resourceMonitorLogSpaceMaximumChanged(value);
}

bool MachineData::getShippingModeEnable() const
{
    return m_shippingModeEnable;
}

void MachineData::setWatchdogCounter(int watchdogCounter)
{
    if (m_watchdogCounter == watchdogCounter)
        return;

    m_watchdogCounter = watchdogCounter;
    emit watchdogCounterChanged(m_watchdogCounter);
}

void MachineData::setRtcActualDate(QString rtcActualDate)
{
    if (m_rtcActualDate == rtcActualDate)
        return;

    m_rtcActualDate = rtcActualDate;
    emit rtcActualDateChanged(m_rtcActualDate);
}

void MachineData::setRtcActualTime(QString rtcActualTime)
{
    if (m_rtcActualTime == rtcActualTime)
        return;

    m_rtcActualTime = rtcActualTime;
    emit rtcActualTimeChanged(m_rtcActualTime);
}

int MachineData::getDataLogSpaceMaximum() const
{
    return m_dataLogSpaceMaximum;
}

int MachineData::getAlarmLogSpaceMaximum() const
{
    return m_alarmLogSpaceMaximum;
}

int MachineData::getEventLogSpaceMaximum() const
{
    return m_eventLogSpaceMaximum;
}

int MachineData::getReplaceableCompRecordSpaceMaximum() const
{
    return m_replaceableCompRecordSpaceMaximum;
}

int MachineData::getResourceMonitorLogSpaceMaximum() const
{
    return m_resourceMonitorLogSpaceMaximum;
}

void MachineData::setVivariumMuteState(bool vivariumMuteState)
{
    if (m_vivariumMuteState == vivariumMuteState)
        return;

    m_vivariumMuteState = vivariumMuteState;
    emit vivariumMuteStateChanged(m_vivariumMuteState);
}

int MachineData::getWatchdogCounter() const
{
    return m_watchdogCounter;
}

QString MachineData::getRtcActualDate() const
{
    return m_rtcActualDate;
}

QString MachineData::getRtcActualTime() const
{
    return m_rtcActualTime;
}

void MachineData::setParticleCounterSensorFanState(short particleCounterSensorFanState)
{
    if (m_particleCounterSensorFanState == particleCounterSensorFanState)
        return;

    m_particleCounterSensorFanState = particleCounterSensorFanState;
    emit particleCounterSensorFanStateChanged(m_particleCounterSensorFanState);
}

void MachineData::setParticleCounterSensorInstalled(bool particleCounterSensorInstalled)
{
    if (m_particleCounterSensorInstalled == particleCounterSensorInstalled)
        return;

    m_particleCounterSensorInstalled = particleCounterSensorInstalled;
    emit particleCounterSensorInstalledChanged(m_particleCounterSensorInstalled);
}

bool MachineData::getVivariumMuteState() const
{
    return m_vivariumMuteState;
}

short MachineData::getParticleCounterSensorFanState() const
{
    return m_particleCounterSensorFanState;
}

void MachineData::setParticleCounterPM2_5(int particleCounterPM2_5)
{
    if (m_particleCounterPM2_5 == particleCounterPM2_5)
        return;

    m_particleCounterPM2_5 = particleCounterPM2_5;
    emit particleCounterPM2_5Changed(m_particleCounterPM2_5);
}

void MachineData::setParticleCounterPM10(int particleCounterPM10)
{
    if (m_particleCounterPM10 == particleCounterPM10)
        return;

    m_particleCounterPM10 = particleCounterPM10;
    emit particleCounterPM10Changed(m_particleCounterPM10);
}

void MachineData::setParticleCounterPM1_0(int particleCounterPM1_0)
{
    if (m_particleCounterPM1_0 == particleCounterPM1_0)
        return;

    m_particleCounterPM1_0 = particleCounterPM1_0;
    emit particleCounterPM1_0Changed(m_particleCounterPM1_0);
}

bool MachineData::getParticleCounterSensorInstalled() const
{
    return m_particleCounterSensorInstalled;
}

void MachineData::setAlarmTempHigh(short alarmTempHigh)
{
    if (m_alarmTempHigh == alarmTempHigh)
        return;

    m_alarmTempHigh = alarmTempHigh;
    emit alarmTempHighChanged(m_alarmTempHigh);
}

void MachineData::setAlarmTempLow(short alarmTempLow)
{
    if (m_alarmTempLow == alarmTempLow)
        return;

    m_alarmTempLow = alarmTempLow;
    emit alarmTempLowChanged(m_alarmTempLow);
}

void MachineData::setEnvTempHighestLimit(int envTempHighestLimit)
{
    if (m_envTempHighestLimit == envTempHighestLimit)
        return;

    m_envTempHighestLimit = envTempHighestLimit;
    emit envTempHighestLimitChanged(m_envTempHighestLimit);
}

void MachineData::setEnvTempLowestLimit(int envTempLowestLimit)
{
    if (m_envTempLowestLimit == envTempLowestLimit)
        return;

    m_envTempLowestLimit = envTempLowestLimit;
    emit envTempLowestLimitChanged(m_envTempLowestLimit);
}

int MachineData::getParticleCounterPM2_5() const
{
    return m_particleCounterPM2_5;
}

int MachineData::getParticleCounterPM10() const
{
    return m_particleCounterPM10;
}

int MachineData::getParticleCounterPM1_0() const
{
    return m_particleCounterPM1_0;
}

short MachineData::getAlarmTempHigh() const
{
    return m_alarmTempHigh;
}

short MachineData::getAlarmTempLow() const
{
    return m_alarmTempLow;
}

void MachineData::setSashCycleMeter(int sashCycleMeter)
{
    if (m_sashCycleMeter == sashCycleMeter)
        return;

    m_sashCycleMeter = sashCycleMeter;
    emit sashCycleMeterChanged(m_sashCycleMeter);
}

short MachineData::getSashCycleMotorLockedAlarm() const
{
    return m_sashCycleMotorLockedAlarm;
}

void MachineData::setSashCycleMotorLockedAlarm(short value)
{
    if(m_sashCycleMotorLockedAlarm == value) return;
    m_sashCycleMotorLockedAlarm = value;
    emit sashCycleMotorLockedAlarmChanged(m_sashCycleMotorLockedAlarm);
}

int MachineData::getEnvTempHighestLimit() const
{
    return m_envTempHighestLimit;
}

int MachineData::getEnvTempLowestLimit() const
{
    return m_envTempLowestLimit;
}

void MachineData::setFanPIN(QString fanPIN)
{
    if (m_fanPIN == fanPIN)
        return;

    m_fanPIN = fanPIN;
    emit fanPINChanged(m_fanPIN);
}

/// getSashCycleCountValid() return true if sash state has reached Standby, Fully Closed, and Fully Opened
/// getSashCycleCountValid() return false if sash state in Safe height
bool MachineData::getSashCycleCountValid() const
{
    return m_sashCycleCountValid;
}

void MachineData::setSashCycleCountValid(bool sashCycleCountValid)
{
    if(m_sashCycleCountValid == sashCycleCountValid) return;
    m_sashCycleCountValid = sashCycleCountValid;
}

int MachineData::getSashCycleMeter() const
{
    return m_sashCycleMeter;
}

void MachineData::setCabinetDisplayName(QString cabinetDisplayName)
{
    if (m_cabinetDisplayName == cabinetDisplayName)
        return;

    m_cabinetDisplayName = cabinetDisplayName;
    emit cabinetDisplayNameChanged(m_cabinetDisplayName);
}

QString MachineData::getFanPIN() const
{
    return m_fanPIN;
}

void MachineData::setEscoLockServiceEnable(int escoLockServiceEnable)
{
    if (m_escoLockServiceEnable == escoLockServiceEnable)
        return;

    m_escoLockServiceEnable = escoLockServiceEnable;
    emit escoLockServiceEnableChanged(m_escoLockServiceEnable);
}

QString MachineData::getCabinetDisplayName() const
{
    return m_cabinetDisplayName;
}

bool MachineData::getCertificationExpiredValid() const
{
    return m_certificationExpiredValid;
}

void MachineData::setCertificationExpiredCount(int certificationExpiredCount)
{
    if (m_certificationExpiredCount == certificationExpiredCount)
        return;

    m_certificationExpiredCount = certificationExpiredCount;
    emit certificationExpiredCountChanged(m_certificationExpiredCount);
}

void MachineData::setCertificationExpired(bool certificationExpired)
{
    if (m_certificationExpired == certificationExpired)
        return;

    m_certificationExpired = certificationExpired;
    emit certificationExpiredChanged(m_certificationExpired);
}

int MachineData::getCertificationExpiredCount() const
{
    return m_certificationExpiredCount;
}

void MachineData::setFanAutoWeeklyDay(int fanAutoSetWeeklyDay)
{
    if (m_fanAutoSetWeeklyDay == fanAutoSetWeeklyDay)
        return;

    m_fanAutoSetWeeklyDay = fanAutoSetWeeklyDay;
    emit fanAutoWeeklyDayChanged(m_fanAutoSetWeeklyDay);
}

int MachineData::getFanAutoEnabledOff() const
{
    return m_fanAutoSetEnabledOff;
}

void MachineData::setFanAutoEnabledOff(int fanAutoSetEnabledOff)
{
    if(m_fanAutoSetEnabledOff == fanAutoSetEnabledOff)return;
    m_fanAutoSetEnabledOff = fanAutoSetEnabledOff;
    emit fanAutoEnabledOffChanged(m_fanAutoSetEnabledOff);
}

int MachineData::getFanAutoTimeOff() const
{
    return m_fanAutoSetTimeOff;
}

void MachineData::setFanAutoTimeOff(int fanAutoSetTimeOff)
{
    if(m_fanAutoSetTimeOff == fanAutoSetTimeOff)return;
    m_fanAutoSetTimeOff = fanAutoSetTimeOff;
    emit fanAutoTimeOffChanged(m_fanAutoSetTimeOff);
}

int MachineData::getFanAutoDayRepeatOff() const
{
    return m_fanAutoSetDayRepeatOff;
}

void MachineData::setFanAutoDayRepeatOff(int fanAutoSetDayRepeatOff)
{
    if(m_fanAutoSetDayRepeatOff == fanAutoSetDayRepeatOff)return;
    m_fanAutoSetDayRepeatOff = fanAutoSetDayRepeatOff;
    emit fanAutoDayRepeatOffChanged(m_fanAutoSetDayRepeatOff);
}

int MachineData::getFanAutoWeeklyDayOff() const
{
    return m_fanAutoSetWeeklyDayOff;
}

void MachineData::setFanAutoWeeklyDayOff(int fanAutoSetWeeklyDayOff)
{
    if(m_fanAutoSetWeeklyDayOff == fanAutoSetWeeklyDayOff)return;
    m_fanAutoSetWeeklyDayOff = fanAutoSetWeeklyDayOff;
    emit fanAutoWeeklyDayOffChanged(m_fanAutoSetWeeklyDayOff);
}

short MachineData::getSecurityAccessMode() const
{
    return m_securityAccessMode;
}

void MachineData::setSecurityAccessMode(short securityAccessMode)
{
    if (m_securityAccessMode == securityAccessMode)
        return;

    m_securityAccessMode = securityAccessMode;
    emit securityAccessChanged(m_securityAccessMode);
}

QString MachineData::getDateCertificationReminder() const
{
    return m_dateCertificationReminder;
}

void MachineData::setDateCertificationReminder(QString dateCertificationReminder)
{
    if (m_dateCertificationReminder == dateCertificationReminder)
        return;

    m_dateCertificationReminder = dateCertificationReminder;
    emit dateCertificationReminderChanged(m_dateCertificationReminder);
}

bool MachineData::getCertificationExpired() const
{
    return m_certificationExpired;
}

void MachineData::setFanAutoDayRepeat(int fanAutoSetDayRepeat)
{
    if (m_fanAutoSetDayRepeat == fanAutoSetDayRepeat)
        return;

    m_fanAutoSetDayRepeat = fanAutoSetDayRepeat;
    emit fanAutoDayRepeatChanged(m_fanAutoSetDayRepeat);
}

void MachineData::setFanAutoTime(int fanAutoSetTime)
{
    if (m_fanAutoSetTime == fanAutoSetTime)
        return;

    m_fanAutoSetTime = fanAutoSetTime;
    emit fanAutoTimeChanged(m_fanAutoSetTime);
}

void MachineData::setFanAutoEnabled(int fanAutoSetEnabled)
{
    if (m_fanAutoSetEnabled == fanAutoSetEnabled)
        return;

    m_fanAutoSetEnabled = fanAutoSetEnabled;
    emit fanAutoEnabledChanged(m_fanAutoSetEnabled);
}

void MachineData::setUVAutoEnabled(int uvAutoSetEnabled)
{
    if (m_uvAutoSetEnabled == uvAutoSetEnabled)
        return;

    m_uvAutoSetEnabled = uvAutoSetEnabled;
    emit uvAutoEnabledChanged(m_uvAutoSetEnabled);
}

void MachineData::setUVAutoTime(int uvAutoSetTime)
{
    if (m_uvAutoSetTime == uvAutoSetTime)
        return;

    m_uvAutoSetTime = uvAutoSetTime;
    emit uvAutoTimeChanged(m_uvAutoSetTime);
}

void MachineData::setUVAutoDayRepeat(int uvAutoSetDayRepeat)
{
    if (m_uvAutoSetDayRepeat == uvAutoSetDayRepeat)
        return;

    m_uvAutoSetDayRepeat = uvAutoSetDayRepeat;
    emit uvAutoDayRepeatChanged(m_uvAutoSetDayRepeat);
}

void MachineData::setUVAutoWeeklyDay(int uvAutoSetWeeklyDay)
{
    if (m_uvAutoSetWeeklyDay == uvAutoSetWeeklyDay)
        return;

    m_uvAutoSetWeeklyDay = uvAutoSetWeeklyDay;
    emit uvAutoWeeklyDayChanged(m_uvAutoSetWeeklyDay);
}

int MachineData::getUVAutoEnabledOff() const
{
    return m_uvAutoSetEnabledOff;
}

void MachineData::setUVAutoEnabledOff(int uvAutoSetEnabledOff)
{
    if (m_uvAutoSetEnabledOff == uvAutoSetEnabledOff)
        return;

    m_uvAutoSetEnabledOff = uvAutoSetEnabledOff;
    emit uvAutoEnabledOffChanged(m_uvAutoSetEnabledOff);
}

int MachineData::getUVAutoTimeOff() const
{
    return m_uvAutoSetTimeOff;
}

void MachineData::setUVAutoTimeOff(int uvAutoSetTimeOff)
{
    if (m_uvAutoSetTimeOff == uvAutoSetTimeOff)
        return;

    m_uvAutoSetTimeOff = uvAutoSetTimeOff;
    emit uvAutoTimeOffChanged(m_uvAutoSetTimeOff);
}

int MachineData::getUVAutoDayRepeatOff() const
{
    return m_uvAutoSetDayRepeatOff;
}

void MachineData::setUVAutoDayRepeatOff(int uvAutoSetDayRepeatOff)
{
    if (m_uvAutoSetDayRepeatOff == uvAutoSetDayRepeatOff)
        return;

    m_uvAutoSetDayRepeatOff = uvAutoSetDayRepeatOff;
    emit uvAutoDayRepeatOffChanged(m_uvAutoSetDayRepeatOff);
}

int MachineData::getUVAutoWeeklyDayOff() const
{
    return m_uvAutoSetWeeklyDayOff;
}

void MachineData::setUVAutoWeeklyDayOff(int uvAutoSetWeeklyDayOff)
{
    if (m_uvAutoSetWeeklyDayOff == uvAutoSetWeeklyDayOff)
        return;

    m_uvAutoSetWeeklyDayOff = uvAutoSetWeeklyDayOff;
    emit uvAutoWeeklyDayOffChanged(m_uvAutoSetWeeklyDayOff);
}

int MachineData::getFanAutoEnabled() const
{
    return m_fanAutoSetEnabled;
}

int MachineData::getFanAutoTime() const
{
    return m_fanAutoSetTime;
}

int MachineData::getFanAutoDayRepeat() const
{
    return m_fanAutoSetDayRepeat;
}

int MachineData::getFanAutoWeeklyDay() const
{
    return m_fanAutoSetWeeklyDay;
}

void MachineData::setLcdBrightnessLevelDimmed(bool lcdBrightnessLevelDimmed)
{
    if (m_lcdBrightnessLevelDimmed == lcdBrightnessLevelDimmed)
        return;

    m_lcdBrightnessLevelDimmed = lcdBrightnessLevelDimmed;
    emit lcdBrightnessLevelDimmedChanged(m_lcdBrightnessLevelDimmed);
}

void MachineData::setEventLogIsFull(bool eventLogIsFull)
{
    if (m_eventLogIsFull == eventLogIsFull)
        return;

    m_eventLogIsFull = eventLogIsFull;
    emit eventLogIsFullChanged(m_eventLogIsFull);
}

int MachineData::getReplaceableCompRecordCount() const
{
    return m_replaceableCompRecordCount;
}

void MachineData::setReplaceableCompRecordCount(int value)
{
    if(m_replaceableCompRecordCount == value) return;
    m_replaceableCompRecordCount = value;
    emit replaceableCompRecordCountChanged(value);
}

bool MachineData::getReplaceableCompRecordIsFull() const
{
    return m_replaceableCompRecordIsFull;
}

void MachineData::setReplaceableCompRecordIsFull(bool value)
{
    if(m_replaceableCompRecordIsFull == value) return;
    m_replaceableCompRecordIsFull = value;
    emit replaceableCompRecordIsFullChanged(value);
}

int MachineData::getUVAutoEnabled() const
{
    return m_uvAutoSetEnabled;
}

int MachineData::getUVAutoTime() const
{
    return m_uvAutoSetTime;
}

int MachineData::getUVAutoDayRepeat() const
{
    return m_uvAutoSetDayRepeat;
}

int MachineData::getUVAutoWeeklyDay() const
{
    return m_uvAutoSetWeeklyDay;
}

bool MachineData::getLcdBrightnessLevelDimmed() const
{
    return m_lcdBrightnessLevelDimmed;
}

void MachineData::setEventLogCount(int eventLogCount)
{
    if (m_eventLogCount == eventLogCount)
        return;

    m_eventLogCount = eventLogCount;
    emit eventLogCountChanged(m_eventLogCount);
}

bool MachineData::getEventLogIsFull() const
{
    return m_eventLogIsFull;
}

void MachineData::setModbusSlaveID(short modbusSlaveID)
{
    if (m_modbusSlaveID == modbusSlaveID)
        return;

    m_modbusSlaveID = modbusSlaveID;
    emit modbusSlaveIDChanged(m_modbusSlaveID);
}

void MachineData::setModbusLatestStatus(QString modbusLatestStatus)
{
    if (m_modbusLatestStatus == modbusLatestStatus)
        return;

    m_modbusLatestStatus = modbusLatestStatus;
    emit modbusLatestStatusChanged(m_modbusLatestStatus);
}

int MachineData::getEventLogCount() const
{
    return m_eventLogCount;
}

short MachineData::getModbusSlaveID() const
{
    return m_modbusSlaveID;
}

void MachineData::setModbusAllowSetUvLight(bool modbusAllowSetUvLight)
{
    if (m_modbusAllowSetUvLight == modbusAllowSetUvLight)
        return;

    m_modbusAllowSetUvLight = modbusAllowSetUvLight;
    emit modbusAllowSetUvLightChanged(m_modbusAllowSetUvLight);
}

QString MachineData::getModbusLatestStatus() const
{
    return m_modbusLatestStatus;
}

void MachineData::setModbusAllowSetGas(bool modbusAllowGasSet)
{
    if (m_modbusAllowSetGas == modbusAllowGasSet)
        return;

    m_modbusAllowSetGas = modbusAllowGasSet;
    emit modbusAllowGasSetChanged(m_modbusAllowSetGas);
}

bool MachineData::getModbusAllowSetUvLight() const
{
    return m_modbusAllowSetUvLight;
}

void MachineData::setModbusAllowSetSocket(bool modbusAllowSetSocket)
{
    if (m_modbusAllowSetSocket == modbusAllowSetSocket)
        return;

    m_modbusAllowSetSocket = modbusAllowSetSocket;
    emit modbusAllowSetSocketChanged(m_modbusAllowSetSocket);
}

bool MachineData::getModbusAllowSetGas() const
{
    return m_modbusAllowSetGas;
}

void MachineData::setModbusAllowSetLightIntensity(bool modbusAllowSetLightIntensity)
{
    if (m_modbusAllowSetLightIntensity == modbusAllowSetLightIntensity)
        return;

    m_modbusAllowSetLightIntensity = modbusAllowSetLightIntensity;
    emit modbusAllowSetLightIntensityChanged(m_modbusAllowSetLightIntensity);
}

bool MachineData::getModbusAllowSetSocket() const
{
    return m_modbusAllowSetSocket;
}

void MachineData::setModbusAllowSetLight(bool modbusAllowSetLight)
{
    if (m_modbusAllowSetLight == modbusAllowSetLight)
        return;

    m_modbusAllowSetLight = modbusAllowSetLight;
    emit modbusAllowSetLightChanged(m_modbusAllowSetLight);
}

bool MachineData::getModbusAllowSetLightIntensity() const
{
    return m_modbusAllowSetLightIntensity;
}

void MachineData::setModbusAllowSetFan(bool modbusAllowSetFan)
{
    if (m_modbusAllowSetFan == modbusAllowSetFan)
        return;

    m_modbusAllowSetFan = modbusAllowSetFan;
    emit modbusAllowSetFanChanged(m_modbusAllowSetFan);
}

bool MachineData::getModbusAllowSetLight() const
{
    return m_modbusAllowSetLight;
}

void MachineData::setModbusAllowIpMaster(QString modbusAllowIpMaster)
{
    if (m_modbusAllowIpMaster == modbusAllowIpMaster)
        return;

    m_modbusAllowIpMaster = modbusAllowIpMaster;
    emit modbusAllowIpMasterChanged(m_modbusAllowIpMaster);
}

bool MachineData::getModbusAllowSetFan() const
{
    return m_modbusAllowSetFan;
}


MachineData::MachineData(QObject *parent) : QObject(parent)
{
    m_rpListLast.clear();
    m_rpListSelected.clear();

    for(short i=0; i< MachineEnums::RPList_Total; i++){
        m_rpListLast.append("");
        m_rpListSelected.append("");
    }
    //qDebug() << "m_rpListLast.length()" << ((m_rpListLast.length() == MachineEnums::RPList_Total) ? "Valid" : "Invalid");
}//

MachineData::~MachineData()
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
}

short MachineData::getMachineBackendState() const
{
    return m_machineState;
}

void MachineData::setMachineBackendState(short workerState)
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

void MachineData::setMachineProfileID(QString value)
{
    if(m_machineProfileID == value)return;

    //    QSettings settings;
    //    settings.setValue("machProfId", value);

    m_machineProfileID = value;
    emit machineProfileIDChanged(value);
}//

QString MachineData::getMachineProfileID() const
{
    return m_machineProfileID;
}

void MachineData::setAlarmLogCount(int alarmLogCount)
{
    if (m_alarmLogCount == alarmLogCount)
        return;

    m_alarmLogCount = alarmLogCount;
    emit alarmLogCountChanged(m_alarmLogCount);
}

void MachineData::setAlarmLogIsFull(bool alarmLogIsFull)
{
    if (m_alarmLogIsFull == alarmLogIsFull)
        return;

    m_alarmLogIsFull = alarmLogIsFull;
    emit alarmLogIsFullChanged(m_alarmLogIsFull);
}

QString MachineData::getModbusAllowIpMaster() const
{
    return m_modbusAllowIpMaster;
}

void MachineData::setSerialNumber(QString serialNumber)
{
    if (m_serialNumber == serialNumber)
        return;

    m_serialNumber = serialNumber;
    emit serialNumberChanged(m_serialNumber);
}

int MachineData::getAlarmLogCount() const
{
    return m_alarmLogCount;
}

bool MachineData::getAlarmLogIsFull() const
{
    return m_alarmLogIsFull;
}

short MachineData::getFanPrimaryState() const
{
    return m_fanPrimaryState;
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

short MachineData::getSashWindowPrevState() const
{
    return m_sashWindowPrevState;
}

short MachineData::getSashWindowMotorizeState() const
{
    return m_sashWindowMotorizeState;
}

short MachineData::getExhaustContactState() const
{
    return m_exhaustContactState;
}

short MachineData::getAlarmContactState() const
{
    return m_alarmContactState;
}

short MachineData::getLightIntensity() const
{
    return m_lightIntensity;
}

short MachineData::getAlarmInflowLow() const
{
    return m_alarmInflowLow;
}

short MachineData::getAlarmSash() const
{
    return m_alarmSash;
}

//bool MachineData::getAlarmDownflowLow() const
//{
//    return m_alarmDownflowLow;
//}

//bool MachineData::getAlarmDownflowHigh() const
//{
//    return m_alarmDownflowHigh;
//}

int MachineData::getTemperatureAdc() const
{
    return m_temperatureAdc;
}

QString MachineData::getTemperatureValueStrf() const
{
    return m_temperatureValueStrf;
}

short MachineData::getMeasurementUnit() const
{
    return m_measurementUnit;
}

void MachineData::setMuteAlarmTime(int muteAlarmTime)
{
    if (m_muteAlarmTime == muteAlarmTime)
        return;

    m_muteAlarmTime = muteAlarmTime;
    emit muteAlarmTimeChanged(m_muteAlarmTime);
}

void MachineData::setMuteAlarmCountdown(int muteAlarmCountdown)
{
    if (m_muteAlarmCountdown == muteAlarmCountdown)
        return;

    m_muteAlarmCountdown = muteAlarmCountdown;
    emit muteAlarmCountdownChanged(m_muteAlarmCountdown);
}

void MachineData::setFanPrimaryUsageMeter(int fanPrimaryUsageMeter)
{
    if (m_fanPrimaryUsageMeter == fanPrimaryUsageMeter)
        return;

    m_fanPrimaryUsageMeter = fanPrimaryUsageMeter;
    //    qDebug() << __func__ <<  m_fanPrimaryUsageMeter;
    emit fanPrimaryUsageMeterChanged(m_fanPrimaryUsageMeter);
}
void MachineData::setFanInflowUsageMeter(int fanInflowUsageMeter)
{
    if (m_fanInflowUsageMeter == fanInflowUsageMeter)
        return;

    m_fanInflowUsageMeter = fanInflowUsageMeter;
    //    qDebug() << __func__ <<  m_fanInflowUsageMeter;
    emit fanInflowUsageMeterChanged(m_fanInflowUsageMeter);
}

QString MachineData::getSerialNumber() const
{
    return m_serialNumber;
}

int MachineData::getMuteAlarmTime() const
{
    return m_muteAlarmTime;
}

int MachineData::getMuteAlarmCountdown() const
{
    return m_muteAlarmCountdown;
}

void MachineData::setSeasPressureDiffPaOffset(short seasPressureDiffPaOffset)
{
    if (m_seasPressureDiffPaOffset == seasPressureDiffPaOffset)
        return;

    m_seasPressureDiffPaOffset = seasPressureDiffPaOffset;
    emit seasPressureDiffPaOffsetChanged(m_seasPressureDiffPaOffset);
}

int MachineData::getFanPrimaryUsageMeter() const
{
    return m_fanPrimaryUsageMeter;
}
int MachineData::getFanInflowUsageMeter() const
{
    return m_fanInflowUsageMeter;
}

void MachineData::setSeasAlarmPressureLow(short seasAlarmPressureLow)
{
    if (m_seasAlarmPressureLow == seasAlarmPressureLow)
        return;

    m_seasAlarmPressureLow = seasAlarmPressureLow;
    emit seasAlarmPressureLowChanged(m_seasAlarmPressureLow);
}

short MachineData::getSeasPressureDiffPaOffset() const
{
    return m_seasPressureDiffPaOffset;
}

void MachineData::setSeasPressureDiffPaLowLimit(int seasPressureDiffPaLowLimit)
{
    if (m_seasPressureDiffPaLowLimit == seasPressureDiffPaLowLimit)
        return;

    m_seasPressureDiffPaLowLimit = seasPressureDiffPaLowLimit;
    emit seasPressureDiffPaLowLimitChanged(m_seasPressureDiffPaLowLimit);
}

void MachineData::setSeasPressureDiffStrf(QString seasPressureDiffStr)
{
    if (m_seasPressureDiffStr == seasPressureDiffStr)
        return;

    m_seasPressureDiffStr = seasPressureDiffStr;
    emit seasPressureDiffStrChanged(m_seasPressureDiffStr);
}

short MachineData::getSeasFlapAlarmPressure() const
{
    return m_seasFlapAlarmPressure;
}

void MachineData::setSeasFlapAlarmPressure(short seasFlapAlarmPressure)
{
    if(m_seasFlapAlarmPressure == seasFlapAlarmPressure)return;
    m_seasFlapAlarmPressure = seasFlapAlarmPressure;
    emit seasFlapAlarmPressureChanged(m_seasFlapAlarmPressure);
}

short MachineData::getAlarmSeasPressureLow() const
{
    return m_seasAlarmPressureLow;
}

int MachineData::getSeasPressureDiffPaLowLimit() const
{
    return m_seasPressureDiffPaLowLimit;
}

void MachineData::setSeasPressureDiff(int seasPressureDiff)
{
    if (m_seasPressureDiff == seasPressureDiff)
        return;

    m_seasPressureDiff = seasPressureDiff;
    emit seasPressureDiffChanged(m_seasPressureDiff);
}

QString MachineData::getSeasPressureDiffStr() const
{
    return m_seasPressureDiffStr;
}

void MachineData::setSeasPressureDiffPa(int seasPressureDiffPa)
{
    if (m_seasPressureDiffPa == seasPressureDiffPa)
        return;

    m_seasPressureDiffPa = seasPressureDiffPa;
    emit seasPressureDiffPaChanged(m_seasPressureDiffPa);
}

int MachineData::getSeasPressureDiff() const
{
    return m_seasPressureDiff;
}

void MachineData::setSeasInstalled(bool seasInstalled)
{
    if (m_seasInstalled == seasInstalled)
        return;

    m_seasInstalled = seasInstalled;
    emit seasInstalledChanged(m_seasInstalled);
}

int MachineData::getSeasPressureDiffPa() const
{
    return m_seasPressureDiffPa;
}

void MachineData::setPowerOutageUvState(short powerOutageUvState)
{
    if (m_powerOutageUvState == powerOutageUvState)
        return;

    m_powerOutageUvState = powerOutageUvState;
    emit powerOutageUvStateChanged(m_powerOutageUvState);
}

bool MachineData::getSeasFlapInstalled() const
{
    return m_seasFlapInstalled;
}

void MachineData::setSeasFlapInstalled(bool seasFlapInstalled)
{
    if (m_seasFlapInstalled == seasFlapInstalled)
        return;

    m_seasFlapInstalled = seasFlapInstalled;
    emit powerOutageUvStateChanged(m_seasFlapInstalled);
}

bool MachineData::getSeasInstalled() const
{
    return m_seasInstalled;
}

//short MachineData::getPowerOutageLightState() const
//{
//    return m_powerOutageLightState;
//}

//void MachineData::setPowerOutageLightState(short powerOutageLightState)
//{
//    if (m_powerOutageLightState == powerOutageLightState)
//        return;

//    m_powerOutageLightState = powerOutageLightState;
//    emit powerOutageLightStateChanged(m_powerOutageLightState);
//}

short MachineData::getPowerOutageUvState() const
{
    return m_powerOutageUvState;
}

void MachineData::setPowerOutageFanState(short powerOutageFanState)
{
    if (m_powerOutageFanState == powerOutageFanState)
        return;

    m_powerOutageFanState = powerOutageFanState;
    emit powerOutageFanStateChanged(m_powerOutageFanState);
}

void MachineData::setPowerOutageRecoverTime(QString powerOutageRecoverTime)
{
    if (m_powerOutageRecoverTime == powerOutageRecoverTime)
        return;

    m_powerOutageRecoverTime = powerOutageRecoverTime;
    emit powerOutageRecoverTimeChanged(m_powerOutageRecoverTime);
}

short MachineData::getPowerOutageFanState() const
{
    return m_powerOutageFanState;
}

void MachineData::setPowerOutageTime(QString powerOutageTime)
{
    if (m_powerOutageTime == powerOutageTime)
        return;

    m_powerOutageTime = powerOutageTime;
    emit powerOutageTimeChanged(m_powerOutageTime);
}

void MachineData::setPowerOutage(bool powerOutage)
{
    if (m_powerOutage == powerOutage)
        return;

    m_powerOutage = powerOutage;
    emit powerOutageChanged(m_powerOutage);
}

QString MachineData::getPowerOutageTime() const
{
    return m_powerOutageTime;
}

QString MachineData::getPowerOutageRecoverTime() const
{
    return m_powerOutageRecoverTime;
}

void MachineData::setFilterLifeMinutes(int filterLifeMinutes)
{
    if (m_filterLifeMinutes == filterLifeMinutes)
        return;

    m_filterLifeMinutes = filterLifeMinutes;
    emit filterLifeMinutesChanged(m_filterLifeMinutes);
}

void MachineData::setFilterLifePercent(short filterLifePercent)
{
    if (m_filterLifePercent == filterLifePercent)
        return;

    m_filterLifePercent = filterLifePercent;
    emit filterLifePercentChanged(m_filterLifePercent);
}

void MachineData::setFilterLifeRpm(int value)
{
    if(m_filterLifeRpm == value) return;
    m_filterLifeRpm = value;
    emit filterLifeRpmChanged(value);
}

void MachineData::setFilterLifeCalculationMode(int value)
{
    if(m_filterLifeCalculationMode == value) return;
    m_filterLifeCalculationMode = value;
    emit filterLifeCalculationModeChanged(value);
}

void MachineData::setFilterLifeMinimumBlowerUsageMode(int value)
{
    if(m_filterLifeMinimumBlowerUsageMode == value) return;
    m_filterLifeMinimumBlowerUsageMode = value;
    emit filterLifeMinimumBlowerUsageModeChanged(value);
}

void MachineData::setFilterLifeMaximumBlowerUsageMode(int value)
{
    if(m_filterLifeMaximumBlowerUsageMode == value) return;
    m_filterLifeMaximumBlowerUsageMode = value;
    emit filterLifeMaximumBlowerUsageModeChanged(value);
}

void MachineData::setFilterLifeMinimumBlowerRpmMode(int value)
{
    if(m_filterLifeMinimumBlowerRpmMode == value) return;
    m_filterLifeMinimumBlowerRpmMode = value;
    emit filterLifeMinimumBlowerRpmModeChanged(value);
}

void MachineData::setFilterLifeMaximumBlowerRpmMode(int value)
{
    if(m_filterLifeMaximumBlowerRpmMode == value) return;
    m_filterLifeMaximumBlowerRpmMode = value;
    emit filterLifeMaximumBlowerRpmModeChanged(value);
}

int MachineData::getFilterLifeRpm() const
{
    return m_filterLifeRpm;
}

int MachineData::getFilterLifeCalculationMode() const
{
    return m_filterLifeCalculationMode;
}

int MachineData::getFilterLifeMinimumBlowerUsageMode() const
{
    return m_filterLifeMinimumBlowerUsageMode;
}

int MachineData::getFilterLifeMaximumBlowerUsageMode() const
{
    return m_filterLifeMaximumBlowerUsageMode;
}

int MachineData::getFilterLifeMinimumBlowerRpmMode() const
{
    return m_filterLifeMinimumBlowerRpmMode;
}

int MachineData::getFilterLifeMaximumBlowerRpmMode() const
{
    return m_filterLifeMaximumBlowerRpmMode;
}

bool MachineData::getPowerOutage() const
{
    return m_powerOutage;
}

void MachineData::setPostPurgingCountdown(int postPurgingCountdown)
{
    if (m_postPurgingCountdown == postPurgingCountdown)
        return;

    m_postPurgingCountdown = postPurgingCountdown;
    emit postPurgingCountdownChanged(m_postPurgingCountdown);
}

int MachineData::getFilterLifeMinutes() const
{
    return m_filterLifeMinutes;
}

short MachineData::getFilterLifePercent() const
{
    return m_filterLifePercent;
}

void MachineData::setPostPurgingTime(int postPurgingTime)
{
    if (m_postPurgingTime == postPurgingTime)
        return;

    m_postPurgingTime = postPurgingTime;
    emit postPurgingTimeChanged(m_postPurgingTime);
}

int MachineData::getPostPurgingCountdown() const
{
    return m_postPurgingCountdown;
}

void MachineData::setPostPurgingActive(bool postPurgingActive)
{
    if (m_postPurgingActive == postPurgingActive)
        return;

    m_postPurgingActive = postPurgingActive;
    emit postPurgingActiveChanged(m_postPurgingActive);
}

int MachineData::getPostPurgingTime() const
{
    return m_postPurgingTime;
}

void MachineData::setAlarmBoardComError(short alarmBoardComError)
{
    if (m_alarmBoardComError == alarmBoardComError)
        return;

    m_alarmBoardComError = alarmBoardComError;
    emit alarmBoardComErrorChanged(m_alarmBoardComError);
}

short MachineData::getAlarmDownflowLow() const
{
    return m_alarmDownflowLow;
}

void MachineData::setAlarmDownflowLow(short alarmDownflowLow)
{
    if (m_alarmDownflowLow == alarmDownflowLow)
        return;

    m_alarmDownflowLow = alarmDownflowLow;
    emit alarmDownflowLowChanged(m_alarmDownflowLow);
}

short MachineData::getAlarmDownflowHigh() const
{
    return m_alarmDownflowHigh;
}

void MachineData::setAlarmDownflowHigh(short alarmDownflowHigh)
{
    if (m_alarmDownflowHigh == alarmDownflowHigh)
        return;

    m_alarmDownflowHigh = alarmDownflowHigh;
    emit alarmDownflowHighChanged(m_alarmDownflowHigh);
}

void MachineData::setAlarmsState(bool alarmsState)
{
    if (m_alarmsState == alarmsState)
        return;

    m_alarmsState = alarmsState;
    emit alarmsStateChanged(m_alarmsState);
}

void MachineData::setUvLifePercent(short uvLifePercent)
{
    if (m_uvLifePercent == uvLifePercent)
        return;

    m_uvLifePercent = uvLifePercent;
    emit uvLifePercentChanged(m_uvLifePercent);
}

void MachineData::setUvLifeMinutes(int uvLifeMinutes)
{
    if (m_uvLifeMinutes == uvLifeMinutes)
        return;

    m_uvLifeMinutes = uvLifeMinutes;
    emit uvLifeMinutesChanged(m_uvLifeMinutes);
}

short MachineData::getUvLifePercent() const
{
    return m_uvLifePercent;
}

void MachineData::setUvTimeActive(bool uvTimeActive)
{
    if (m_uvTimeActive == uvTimeActive)
        return;

    m_uvTimeActive = uvTimeActive;
    emit uvTimeActiveChanged(m_uvTimeActive);
}

void MachineData::setUvTime(int uvTime)
{
    if (m_uvTime == uvTime)
        return;

    m_uvTime = uvTime;
    emit uvTimeChanged(m_uvTime);
}

void MachineData::setUvTimeCountdown(int uvTimeCountdown)
{
    if (m_uvTimeCountdown == uvTimeCountdown)
        return;

    m_uvTimeCountdown = uvTimeCountdown;
    emit uvTimeCountdownChanged(m_uvTimeCountdown);
}

void MachineData::setWarmingUpActive(bool warmingUpActive)
{
    if (m_warmingUpActive == warmingUpActive)
        return;

    m_warmingUpActive = warmingUpActive;
    emit warmingUpActiveChanged(m_warmingUpActive);
}

bool MachineData::getWarmingUpExecuted() const
{
    return m_warmingUpStateExecuted;
}

void MachineData::setWarmingUpExecuted(bool warmingUpExecuted)
{
    if(m_warmingUpStateExecuted == warmingUpExecuted) return;
    m_warmingUpStateExecuted = warmingUpExecuted;
    emit warmingUpExecutedChanged(m_warmingUpStateExecuted);
}

void MachineData::setWarmingUpTime(int warmingUpTime)
{
    if (m_warmingUpTime == warmingUpTime)
        return;

    m_warmingUpTime = warmingUpTime;
    emit warmingUpTimeChanged(m_warmingUpTime);
}

void MachineData::setWarmingUpCountdown(int warmingUpCountdown)
{
    if (m_warmingUpCountdown == warmingUpCountdown)
        return;

    m_warmingUpCountdown = warmingUpCountdown;
    emit warmingUpCountdownChanged(m_warmingUpCountdown);
}

bool MachineData::getPostPurgingActive() const
{
    return m_postPurgingActive;
}

short MachineData::getAlarmBoardComError() const
{
    return m_alarmBoardComError;
}

bool MachineData::getAlarmsState() const
{
    return m_alarmsState;
}

int MachineData::getUvLifeMinutes() const
{
    return m_uvLifeMinutes;
}

bool MachineData::getUvTimeActive() const
{
    return m_uvTimeActive;
}

int MachineData::getUvTime() const
{
    return m_uvTime;
}

int MachineData::getUvTimeCountdown() const
{
    return m_uvTimeCountdown;
}

void MachineData::setSashWindowMotorizeUpInterlocked(bool sashWindowMotorizeUpInterlocked)
{
    if (m_sashWindowMotorizeUpInterlocked == sashWindowMotorizeUpInterlocked)
        return;

    m_sashWindowMotorizeUpInterlocked = sashWindowMotorizeUpInterlocked;
    emit sashWindowMotorizeUpInterlockedChanged(m_sashWindowMotorizeUpInterlocked);
}

void MachineData::setSashWindowMotorizeDownInterlocked(bool sashWindowMotorizeDownInterlocked)
{
    if (m_sashWindowMotorizeDownInterlocked == sashWindowMotorizeDownInterlocked)
        return;

    m_sashWindowMotorizeDownInterlocked = sashWindowMotorizeDownInterlocked;
    emit sashWindowMotorizeDownInterlockedChanged(m_sashWindowMotorizeDownInterlocked);
}

void MachineData::setSashWindowMotorizeInstalled(bool sashWindowMotorizeInstalled)
{
    if (m_sashWindowMotorizeInstalled == sashWindowMotorizeInstalled)
        return;

    m_sashWindowMotorizeInstalled = sashWindowMotorizeInstalled;
    emit sashWindowMotorizeInstalledChanged(m_sashWindowMotorizeInstalled);
}

void MachineData::setOperationMode(short operationMode)
{
    if (m_operationMode == operationMode)
        return;

    m_operationMode = operationMode;
    emit operationModeChanged(m_operationMode);
}

bool MachineData::getWarmingUpActive() const
{
    return m_warmingUpActive;
}

int MachineData::getWarmingUpTime() const
{
    return m_warmingUpTime;
}

int MachineData::getWarmingUpCountdown() const
{
    return m_warmingUpCountdown;
}

bool MachineData::getSashWindowMotorizeUpInterlocked() const
{
    return m_sashWindowMotorizeUpInterlocked;
}

bool MachineData::getSashWindowMotorizeDownInterlocked() const
{
    return m_sashWindowMotorizeDownInterlocked;
}

bool MachineData::getSashWindowMotorizeInstalled() const
{
    return m_sashWindowMotorizeInstalled;
}

void MachineData::setTempAmbientStatus(short tempAmbientStatus)
{
    if (m_tempAmbientStatus == tempAmbientStatus)
        return;

    m_tempAmbientStatus = tempAmbientStatus;
    emit tempAmbientStatusChanged(m_tempAmbientStatus);
}

void MachineData::setFanPrimaryInterlocked(short fanPrimaryInterlocked)
{
    if (m_fanPrimaryInterlocked == fanPrimaryInterlocked)
        return;

    m_fanPrimaryInterlocked = fanPrimaryInterlocked;
    emit fanPrimaryInterlockedChanged(m_fanPrimaryInterlocked);
}

short MachineData::getFanInflowState() const
{
    return m_fanInflowState;
}

void MachineData::setFanInflowState(short fanInflowState)
{
    if (m_fanInflowState == fanInflowState)
        return;

    m_fanInflowState = fanInflowState;
    emit fanInflowStateChanged(m_fanInflowState);
}

bool MachineData::getFanInflowInterlocked() const
{
    return m_fanInflowInterlocked;
}

void MachineData::setFanInflowInterlocked(short fanInflowInterlocked)
{
    if (m_fanInflowInterlocked == fanInflowInterlocked)
        return;

    m_fanInflowInterlocked = fanInflowInterlocked;
    emit fanInflowInterlockedChanged(m_fanInflowInterlocked);
}

void MachineData::setUvInstalled(bool uvInstalled)
{
    if (m_uvInstalled == uvInstalled)
        return;

    m_uvInstalled = uvInstalled;
    emit uvInstalledChanged(m_uvInstalled);
}

void MachineData::setGasInstalled(bool gasInstalled)
{
    if (m_gasInstalled == gasInstalled)
        return;

    m_gasInstalled = gasInstalled;
    emit gasInstalledChanged(m_gasInstalled);
}

bool MachineData::getUvInstalled() const
{
    return m_uvInstalled;
}

void MachineData::setSocketInstalled(bool socketInstalled)
{
    if (m_socketInstalled == socketInstalled)
        return;

    m_socketInstalled = socketInstalled;
    emit socketInstalledChanged(m_socketInstalled);
}

bool MachineData::getGasInstalled() const
{
    return m_gasInstalled;
}

void MachineData::setSocketInterlocked(bool socketInterlocked)
{
    if (m_socketInterlocked == socketInterlocked)
        return;

    m_socketInterlocked = socketInterlocked;
    emit socketInterlockedChanged(m_socketInterlocked);
}

void MachineData::setLightInterlocked(bool lightInterlocked)
{
    if (m_lightInterlocked == lightInterlocked)
        return;

    m_lightInterlocked = lightInterlocked;
    emit lightInterlockedChanged(m_lightInterlocked);
}

void MachineData::setGasInterlocked(bool gasInterlocked)
{
    if (m_gasInterlocked == gasInterlocked)
        return;

    m_gasInterlocked = gasInterlocked;
    emit gasInterlockedChanged(m_gasInterlocked);
}

void MachineData::setUvInterlocked(bool uvInterlocked)
{
    if (m_uvInterlocked == uvInterlocked)
        return;

    m_uvInterlocked = uvInterlocked;
    emit uvInterlockedChanged(m_uvInterlocked);
}

void MachineData::setDataLogIsFull(bool dataLogIsFull)
{
    if (m_dataLogIsFull == dataLogIsFull)
        return;

    m_dataLogIsFull = dataLogIsFull;
    emit dataLogIsFullChanged(m_dataLogIsFull);
}

bool MachineData::getResourceMonitorLogEnable() const
{
    return m_resourceMonitorLogEnable;
}

bool MachineData::getResourceMonitorLogRunning() const
{
    return m_resourceMonitorLogRunning;
}

short MachineData::getResourceMonitorLogPeriod() const
{
    return m_resourceMonitorLogPeriod;
}

int MachineData::getResourceMonitorLogCount() const
{
    return m_resourceMonitorLogCount;
}

bool MachineData::getResourceMonitorLogIsFull() const
{
    return m_resourceMonitorLogIsFull;
}

void MachineData::setResourceMonitorLogEnable(bool value)
{
    if(m_resourceMonitorLogEnable == value)return;
    m_resourceMonitorLogEnable = value;
    emit resourceMonitorLogEnableChanged(value);
}

void MachineData::setResourceMonitorLogRunning(bool value)
{
    if(m_resourceMonitorLogRunning == value)return;
    m_resourceMonitorLogRunning = value;
    emit resourceMonitorLogRunningChanged(value);
}

void MachineData::setResourceMonitorLogCount(int value)
{
    if(m_resourceMonitorLogCount == value)return;
    m_resourceMonitorLogCount = value;
    emit resourceMonitorLogCountChanged(value);
}

void MachineData::setResourceMonitorLogPeriod(short value)
{
    if(m_resourceMonitorLogPeriod == value)return;
    m_resourceMonitorLogPeriod = value;
    emit resourceMonitorLogPeriodChanged(value);
}

void MachineData::setResourceMonitorLogIsFull(bool value)
{
    if(m_resourceMonitorLogIsFull == value)return;
    m_resourceMonitorLogIsFull = value;
    emit resourceMonitorLogIsFullChanged(value);
}

short MachineData::getOperationMode() const
{
    return m_operationMode;
}

short MachineData::getTempAmbientStatus() const
{
    return m_tempAmbientStatus;
}

bool MachineData::getFanPrimaryInterlocked() const
{
    return m_fanPrimaryInterlocked;
}

bool MachineData::getSocketInstalled() const
{
    return m_socketInstalled;
}

bool MachineData::getLightInterlocked() const
{
    return m_lightInterlocked;
}

bool MachineData::getSocketInterlocked() const
{
    return m_socketInterlocked;
}

bool MachineData::getGasInterlocked() const
{
    return m_gasInterlocked;
}

bool MachineData::getUvInterlocked() const
{
    return m_uvInterlocked;
}

void MachineData::setDataLogPeriod(short dataLogPeriod)
{
    if (m_dataLogPeriod == dataLogPeriod)
        return;

    m_dataLogPeriod = dataLogPeriod;
    emit dataLogPeriodChanged(m_dataLogPeriod);
}

bool MachineData::getDataLogIsFull() const
{
    return m_dataLogIsFull;
}

void MachineData::setDataLogCount(int dataLogCount)
{
    if (m_dataLogCount == dataLogCount)
        return;

    m_dataLogCount = dataLogCount;
    emit dataLogCountChanged(m_dataLogCount);
}

int MachineData::getDataLogCount() const
{
    return m_dataLogCount;
}

void MachineData::setDataLogEnable(bool dataLogEnable)
{
    if (m_dataLogEnable == dataLogEnable)
        return;

    m_dataLogEnable = dataLogEnable;
    emit dataLogEnableChanged(m_dataLogEnable);
}

void MachineData::setDataLogRunning(bool dataLogRunning)
{
    if (m_dataLogRunning == dataLogRunning)
        return;

    m_dataLogRunning = dataLogRunning;
    emit dataLogRunningChanged(m_dataLogRunning);
}

short MachineData::getDataLogPeriod() const
{
    return m_dataLogPeriod;
}

void MachineData::setBoardStatusCtpRtc(bool boardStatusCtpRtc)
{
    if (m_boardStatusCtpRtc == boardStatusCtpRtc)
        return;

    m_boardStatusCtpRtc = boardStatusCtpRtc;
    emit boardStatusCtpRtcChanged(m_boardStatusCtpRtc);
}

void MachineData::setBoardStatusCtpIoe(bool boardStatusCtpIoe)
{
    if (m_boardStatusCtpIoe == boardStatusCtpIoe)
        return;

    m_boardStatusCtpIoe = boardStatusCtpIoe;
    emit boardStatusCtpIoeChanged(m_boardStatusCtpIoe);
}


void MachineData::setBoardStatusParticleCounter(bool boardStatusParticleCounter)
{
    if(m_boardStatusParticleCounter == boardStatusParticleCounter)
        return;
    m_boardStatusParticleCounter = boardStatusParticleCounter;
    emit boardStatusParticleCounterChanged(m_boardStatusParticleCounter);
}

bool MachineData::getBoardStatusParticleCounter() const
{
    return m_boardStatusParticleCounter;
}

bool MachineData::getBoardStatusPWMOutput() const
{
    return m_boardStatusPWMOutput;
}

void MachineData::setBoardStatusPWMOutput(bool boardStatusPWMOutput)
{
    if(m_boardStatusPWMOutput == boardStatusPWMOutput) return;
    m_boardStatusPWMOutput = boardStatusPWMOutput;
    emit boardStatusPWMOutputChanged(m_boardStatusPWMOutput);
}

bool MachineData::getDataLogEnable() const
{
    return m_dataLogEnable;
}

bool MachineData::getDataLogRunning() const
{
    return m_dataLogRunning;
}

bool MachineData::getMagSW1State() const
{
    return m_magSwitchState[0];
}

bool MachineData::getMagSW2State() const
{
    return m_magSwitchState[1];
}

bool MachineData::getMagSW3State() const
{
    return m_magSwitchState[2];
}

bool MachineData::getMagSW4State() const
{
    return m_magSwitchState[3];
}

bool MachineData::getMagSW5State() const
{
    return m_magSwitchState[4];
}

bool MachineData::getMagSW6State() const
{
    return m_magSwitchState[5];
}

void MachineData::setBoardStatusPressureDiff(bool boardStatusPressureDiff)
{
    if (m_boardStatusPressureDiff == boardStatusPressureDiff)
        return;

    m_boardStatusPressureDiff = boardStatusPressureDiff;
    emit boardStatusPressureDiffChanged(m_boardStatusPressureDiff);
}

bool MachineData::getBoardStatusCtpRtc() const
{
    return m_boardStatusCtpRtc;
}

bool MachineData::getBoardStatusCtpIoe() const
{
    return m_boardStatusCtpIoe;
}

void MachineData::setBoardStatusRbmCom(bool boardStatusRbmCom)
{
    if (m_boardStatusRbmCom == boardStatusRbmCom)
        return;

    m_boardStatusRbmCom = boardStatusRbmCom;
    emit boardStatusRbmComChanged(m_boardStatusRbmCom);
}

bool MachineData::getBoardStatusRbmCom2() const
{
    return m_boardStatusRbmCom2;
}

void MachineData::setBoardStatusRbmCom2(bool boardStatusRbmCom2)
{
    if (m_boardStatusRbmCom2 == boardStatusRbmCom2)
        return;

    m_boardStatusRbmCom2 = boardStatusRbmCom2;
    emit boardStatusRbmCom2Changed(m_boardStatusRbmCom2);
}

bool MachineData::getBoardStatusPressureDiff() const
{
    return m_boardStatusPressureDiff;
}

void MachineData::setBoardStatusHybridAnalogOutput(bool boardStatusHybridAnalogOutput)
{
    if (m_boardStatusHybridAnalogOutput == boardStatusHybridAnalogOutput)
        return;

    m_boardStatusHybridAnalogOutput = boardStatusHybridAnalogOutput;
    emit boardStatusHybridAnalogOutputChanged(m_boardStatusHybridAnalogOutput);
}

bool MachineData::getBoardStatusAnalogOutput() const
{
    return m_boardStatusAnalogOutput;
}

void MachineData::setBoardStatusAnalogOutput(bool boardStatusAnalogOutput)
{
    if(m_boardStatusAnalogOutput == boardStatusAnalogOutput)return;
    m_boardStatusAnalogOutput = boardStatusAnalogOutput;
    emit boardStatusAnalogOutputChanged(m_boardStatusAnalogOutput);
}

bool MachineData::getBoardStatusRbmCom() const
{
    return m_boardStatusRbmCom;
}

bool MachineData::getBoardStatusHybridAnalogInput() const
{
    return m_boardStatusHybridAnalogInput;
}

void MachineData::setBoardStatusHybridAnalogInput(bool boardStatusHybridAnalogInput)
{
    if (m_boardStatusHybridAnalogInput == boardStatusHybridAnalogInput)
        return;

    m_boardStatusHybridAnalogInput = boardStatusHybridAnalogInput;
    emit boardStatusHybridAnalogInputChanged(m_boardStatusHybridAnalogInput);
}

bool MachineData::getBoardStatusAnalogInput() const
{
    return m_boardStatusAnalogInput;
}

void MachineData::setBoardStatusAnalogInput(bool boardStatusAnalogInput)
{
    if (m_boardStatusAnalogInput == boardStatusAnalogInput)
        return;

    m_boardStatusAnalogInput = boardStatusAnalogInput;
    emit boardStatusAnalogInputChanged(m_boardStatusAnalogInput);
}

bool MachineData::getBoardStatusAnalogInput1() const
{
    return m_boardStatusAnalogInput1;
}

void MachineData::setBoardStatusAnalogInput1(bool boardStatusAnalogInput1)
{
    if(m_boardStatusAnalogInput1 == boardStatusAnalogInput1)return;
    m_boardStatusAnalogInput1 = boardStatusAnalogInput1;
    emit boardStatusAnalogInput1Changed(m_boardStatusAnalogInput1);
}
///

bool MachineData::getBoardStatusHybridAnalogOutput() const
{
    return m_boardStatusHybridAnalogOutput;
}


void MachineData::setBoardStatusHybridDigitalInput(bool boardStatusHybridDigitalInput)
{
    if (m_boardStatusHybridDigitalInput == boardStatusHybridDigitalInput)
        return;

    m_boardStatusHybridDigitalInput = boardStatusHybridDigitalInput;
    emit boardStatusHybridDigitalInputChanged(m_boardStatusHybridDigitalInput);
}

void MachineData::setBoardStatusHybridDigitalRelay(bool boardStatusHybridDigitalRelay)
{
    if (m_boardStatusHybridDigitalRelay == boardStatusHybridDigitalRelay)
        return;

    m_boardStatusHybridDigitalRelay = boardStatusHybridDigitalRelay;
    emit boardStatusHybridDigitalRelayChanged(m_boardStatusHybridDigitalRelay);
}

bool MachineData::getBoardStatusHybridDigitalInput() const
{
    return m_boardStatusHybridDigitalInput;
}

void MachineData::setFanPrimaryStandbyDutyCycleField(short fanPrimaryStandbyDutyCycleField)
{
    if (m_fanPrimaryStandbyDutyCycleField == fanPrimaryStandbyDutyCycleField)
        return;

    m_fanPrimaryStandbyDutyCycleField = fanPrimaryStandbyDutyCycleField;
    //    emit fanPrimaryStandbyDutyCycleFieldChanged(m_fanPrimaryStandbyDutyCycleField);
}

void MachineData::setFanPrimaryStandbyRpmField(int fanPrimaryStandbyRpmField)
{
    if (m_fanPrimaryStandbyRpmField == fanPrimaryStandbyRpmField)
        return;

    m_fanPrimaryStandbyRpmField = fanPrimaryStandbyRpmField;
    //    emit fanPrimaryStandbyRpmFieldChanged(m_fanPrimaryStandbyRpmField);
}

short MachineData::getFanInflowDutyCycle() const
{
    return m_fanInflowDutyCycle;
}

int MachineData::getFanInflowRpm() const
{
    return m_fanInflowRpm;
}

short MachineData::getFanInflowNominalDutyCycle() const
{
    return m_fanInflowNominalDutyCycle;
}

int MachineData::getFanInflowNominalRpm() const
{
    return m_fanInflowNominalRpm;
}

short MachineData::getFanInflowMinimumDutyCycle() const
{
    return m_fanInflowMinimumDutyCycle;
}

int MachineData::getFanInflowMinimumRpm() const
{
    return m_fanInflowMinimumRpm;
}

short MachineData::getFanInflowStandbyDutyCycle() const
{
    return m_fanInflowStandbyDutyCycle;
}

int MachineData::getFanInflowStandbyRpm() const
{
    return m_fanInflowStandbyRpm;
}

short MachineData::getFanInflowNominalDutyCycleFactory() const
{
    return m_fanInflowNominalDutyCycleFactory;
}

int MachineData::getFanInflowNominalRpmFactory() const
{
    return m_fanInflowNominalRpmFactory;
}

short MachineData::getFanInflowNominalDutyCycleField() const
{
    return m_fanInflowNominalDutyCycleField;
}

int MachineData::getFanInflowNominalRpmField() const
{
    return m_fanInflowNominalRpmField;
}

short MachineData::getFanInflowMinimumDutyCycleFactory() const
{
    return m_fanInflowMinimumDutyCycleFactory;
}

int MachineData::getFanInflowMinimumRpmFactory() const
{
    return m_fanInflowMinimumRpmFactory;
}

short MachineData::getFanInflowMinimumDutyCycleField() const
{
    return m_fanInflowMinimumDutyCycleField;
}

int MachineData::getFanInflowMinimumRpmField() const
{
    return m_fanInflowMinimumRpmField;
}

short MachineData::getFanInflowStandbyDutyCycleFactory() const
{
    return m_fanInflowStandbyDutyCycleFactory;
}

int MachineData::getFanInflowStandbyRpmFactory() const
{
    return m_fanInflowStandbyRpmFactory;
}

short MachineData::getFanInflowStandbyDutyCycleField() const
{
    return m_fanInflowStandbyDutyCycleField;
}

int MachineData::getFanInflowStandbyRpmField() const
{
    return m_fanInflowStandbyRpmField;
}

void MachineData::setFanInflowDutyCycle(short value)
{
    if(m_fanInflowDutyCycle == value) return;
    m_fanInflowDutyCycle = value;
    emit fanInflowDutyCycleChanged(m_fanInflowDutyCycle);
}

void MachineData::setFanInflowRpm(int value)
{
    if(m_fanInflowRpm == value) return;
    m_fanInflowRpm = value;
    emit fanInflowRpmChanged(m_fanInflowRpm);
}

void MachineData::setFanInflowNominalDutyCycle(short value)
{
    if(m_fanInflowNominalDutyCycle == value) return;
    m_fanInflowNominalDutyCycle = value;
}

void MachineData::setFanInflowNominalRpm(short value)
{
    if(m_fanInflowNominalRpm == value) return;
    m_fanInflowNominalRpm = value;
}

void MachineData::setFanInflowMinimumDutyCycle(short value)
{
    if(m_fanInflowMinimumDutyCycle == value) return;
    m_fanInflowMinimumDutyCycle = value;
}

void MachineData::setFanInflowMinimumRpm(short value)
{
    if(m_fanInflowMinimumRpm == value) return;
    m_fanInflowMinimumRpm = value;
}

void MachineData::setFanInflowStandbyDutyCycle(short value)
{
    if(m_fanInflowStandbyDutyCycle == value) return;
    m_fanInflowStandbyDutyCycle = value;
}

void MachineData::setFanInflowStandbyRpm(int fanInflowStandbyRpm)
{
    if(m_fanInflowStandbyRpm == fanInflowStandbyRpm) return;
    m_fanInflowStandbyRpm = fanInflowStandbyRpm;
}

void MachineData::setFanInflowNominalDutyCycleFactory(short fanInflowNominalDutyCycleFactory)
{
    if(m_fanInflowNominalDutyCycleFactory == fanInflowNominalDutyCycleFactory) return;
    m_fanInflowNominalDutyCycleFactory = fanInflowNominalDutyCycleFactory;
}

void MachineData::setFanInflowNominalRpmFactory(int fanInflowNominalRpmFactory)
{
    if(m_fanInflowNominalRpmFactory == fanInflowNominalRpmFactory) return;
    m_fanInflowNominalRpmFactory = fanInflowNominalRpmFactory;
}

void MachineData::setFanInflowNominalDutyCycleField(short fanInflowNominalDutyCycleField)
{
    if(m_fanInflowNominalDutyCycleField == fanInflowNominalDutyCycleField) return;
    m_fanInflowNominalDutyCycleField = fanInflowNominalDutyCycleField;
}

void MachineData::setFanInflowNominalRpmField(int fanInflowNominalRpmField)
{
    if(m_fanInflowNominalRpmField == fanInflowNominalRpmField) return;
    m_fanInflowNominalRpmField = fanInflowNominalRpmField;
}

void MachineData::setFanInflowMinimumDutyCycleFactory(short fanInflowMinimumDutyCycleFactory)
{
    if(m_fanInflowMinimumDutyCycleFactory == fanInflowMinimumDutyCycleFactory) return;
    m_fanInflowMinimumDutyCycleFactory = fanInflowMinimumDutyCycleFactory;
}

void MachineData::setFanInflowMinimumRpmFactory(int fanInflowMinimumRpmFactory)
{
    if(m_fanInflowMinimumRpmFactory == fanInflowMinimumRpmFactory) return;
    m_fanInflowMinimumRpmFactory = fanInflowMinimumRpmFactory;
}

void MachineData::setFanInflowMinimumDutyCycleField(short fanInflowMinimumDutyCycleField)
{
    if(m_fanInflowMinimumDutyCycleField == fanInflowMinimumDutyCycleField) return;
    m_fanInflowMinimumDutyCycleField = fanInflowMinimumDutyCycleField;
}

void MachineData::setFanInflowMinimumRpmField(int fanInflowMinimumRpmField)
{
    if(m_fanInflowMinimumRpmField == fanInflowMinimumRpmField) return;
    m_fanInflowMinimumRpmField = fanInflowMinimumRpmField;
}

void MachineData::setFanInflowStandbyDutyCycleFactory(short fanInflowStandbyDutyCycleFactory)
{
    if(m_fanInflowStandbyDutyCycleFactory == fanInflowStandbyDutyCycleFactory) return;
    m_fanInflowStandbyDutyCycleFactory = fanInflowStandbyDutyCycleFactory;
}

void MachineData::setFanInflowStandbyRpmFactory(int fanInflowStandbyRpmFactory)
{
    if(m_fanInflowStandbyRpmFactory == fanInflowStandbyRpmFactory) return;
    m_fanInflowStandbyRpmFactory = fanInflowStandbyRpmFactory;
}

void MachineData::setFanInflowStandbyDutyCycleField(short fanInflowStandbyDutyCycleField)
{
    if(m_fanInflowStandbyDutyCycleField == fanInflowStandbyDutyCycleField) return;
    m_fanInflowStandbyDutyCycleField = fanInflowStandbyDutyCycleField;
}

void MachineData::setFanInflowStandbyRpmField(int fanInflowStandbyRpmField)
{
    if(m_fanInflowStandbyRpmField == fanInflowStandbyRpmField) return;
    m_fanInflowStandbyRpmField = fanInflowStandbyRpmField;
}

void MachineData::setAirflowFactoryCalibrationState(int index, bool state)
{
   if(index < 0 || index >= MachineEnums::CalFactoryState_Total)return;
   if(m_airflowFactoryCalibrationState[index] == state) return;
   m_airflowFactoryCalibrationState[index] = state;
}

bool MachineData::getAirflowFactoryCalibrationState(int index)
{
   if(index < 0 || index >= MachineEnums::CalFactoryState_Total)return false;
   return m_airflowFactoryCalibrationState[index];
}

void MachineData::setAirflowFieldCalibrationState(short index, bool value)
{
    if(index < 0 || index >= MachineEnums::CalFieldState_Total)return;
    if(m_airflowFieldCalibrationState[index] == value) return;
    m_airflowFieldCalibrationState[index] = value;
}

bool MachineData::getAirflowFieldCalibrationState(short index)
{
    if(index < 0 || index >= MachineEnums::CalFieldState_Total)return false;
    return m_airflowFieldCalibrationState[index];
}

//
void MachineData::setMagSWState(short index, bool value)
{
    if(index > 5) return;
    if(m_magSwitchState[index] == value) return;

    m_magSwitchState[index] = value;

    emit magSWStateChanged(index, value);
}

void MachineData::setMeasurementUnitDuringCalib(short measurementUnitDuringCalib)
{
    if (m_measurementUnitDuringCalib == measurementUnitDuringCalib)
        return;

    m_measurementUnitDuringCalib = measurementUnitDuringCalib;
    emit measurementUnitDuringCalibChanged(m_measurementUnitDuringCalib);
}

void MachineData::setTemperatureCelcius(short temperatureCelcius)
{
    if (m_temperatureCelcius == temperatureCelcius)
        return;

    m_temperatureCelcius = temperatureCelcius;
    emit temperatureAdcChanged(m_temperatureCelcius);
}

void MachineData::setFanPrimaryStandbyDutyCycleFactory(short fanPrimaryStandbyDutyCycleFactory)
{
    if (m_fanPrimaryStandbyDutyCycleFactory == fanPrimaryStandbyDutyCycleFactory)
        return;

    m_fanPrimaryStandbyDutyCycleFactory = fanPrimaryStandbyDutyCycleFactory;
    //    emit fanPrimaryStandbyDutyCycleFactoryChanged(m_fanPrimaryStandbyDutyCycleFactory);
}

void MachineData::setFanPrimaryStandbyRpmFactory(int fanPrimaryStandbyRpmFactory)
{
    if (m_fanPrimaryStandbyRpmFactory == fanPrimaryStandbyRpmFactory)
        return;

    m_fanPrimaryStandbyRpmFactory = fanPrimaryStandbyRpmFactory;
    //        emit fanPrimaryStandbyRpmFactoryChanged(m_fanPrimaryStandbyRpmFactory);
}

void MachineData::setFanPrimaryNominalDutyCycleField(short fanPrimaryNominalDutyCycleField)
{
    if (m_fanPrimaryNominalDutyCycleField == fanPrimaryNominalDutyCycleField)
        return;

    m_fanPrimaryNominalDutyCycleField = fanPrimaryNominalDutyCycleField;
    //    emit fanPrimaryNominalDutyCycleFieldChanged(m_fanPrimaryNominalDutyCycleField);
}

void MachineData::setFanPrimaryNominalRpmField(int fanPrimaryNominalRpmField)
{
    if (m_fanPrimaryNominalRpmField == fanPrimaryNominalRpmField)
        return;

    m_fanPrimaryNominalRpmField = fanPrimaryNominalRpmField;
    //    emit fanPrimaryNominalRpmFieldChanged(m_fanPrimaryNominalRpmField);
}

void MachineData::setFanPrimaryMinimumDutyCycleFactory(short fanPrimaryMinimumDutyCycleFactory)
{
    if (m_fanPrimaryMinimumDutyCycleFactory == fanPrimaryMinimumDutyCycleFactory)
        return;

    m_fanPrimaryMinimumDutyCycleFactory = fanPrimaryMinimumDutyCycleFactory;
}

void MachineData::setFanPrimaryMinimumRpmFactory(int fanPrimaryMinimumRpmFactory)
{
    if (m_fanPrimaryMinimumRpmFactory == fanPrimaryMinimumRpmFactory)
        return;

    m_fanPrimaryMinimumRpmFactory = fanPrimaryMinimumRpmFactory;
}

void MachineData::setFanPrimaryMinimumDutyCycleField(short fanPrimaryMinimumDutyCycleField)
{
    if (m_fanPrimaryMinimumDutyCycleField == fanPrimaryMinimumDutyCycleField)
        return;

    m_fanPrimaryMinimumDutyCycleField = fanPrimaryMinimumDutyCycleField;
}

void MachineData::setFanPrimaryMinimumRpmField(int fanPrimaryMinimumRpmField)
{
    if (m_fanPrimaryMinimumRpmField == fanPrimaryMinimumRpmField)
        return;

    m_fanPrimaryMinimumRpmField = fanPrimaryMinimumRpmField;
}

void MachineData::setFanPrimaryNominalDutyCycleFactory(short fanPrimaryNominalDutyCycleFactory)
{
    if (m_fanPrimaryNominalDutyCycleFactory == fanPrimaryNominalDutyCycleFactory)
        return;

    m_fanPrimaryNominalDutyCycleFactory = fanPrimaryNominalDutyCycleFactory;
    //    emit fanPrimaryNominalDutyCycleFactoryChanged(m_fanPrimaryNominalDutyCycleFactory);
}

void MachineData::setFanPrimaryNominalRpmFactory(int fanPrimaryNominalRpmFactory)
{
    if (m_fanPrimaryNominalRpmFactory == fanPrimaryNominalRpmFactory)
        return;

    m_fanPrimaryNominalRpmFactory = fanPrimaryNominalRpmFactory;
    //    emit fanPrimaryNominalRpmFactoryChanged(m_fanPrimaryNominalRpmFactory);
}

void MachineData::setTemperature(short temperature)
{
    if (m_temperature == temperature)
        return;

    m_temperature = temperature;
    emit temperatureChanged(m_temperature);
}

bool MachineData::getBoardStatusHybridDigitalRelay() const
{
    return m_boardStatusHybridDigitalRelay;
}

short MachineData::getFanPrimaryStandbyDutyCycleField() const
{
    return m_fanPrimaryStandbyDutyCycleField;
}

int MachineData::getFanPrimaryStandbyRpmField() const
{
    return m_fanPrimaryStandbyRpmField;
}

short MachineData::getMeasurementUnitDuringCalib() const
{
    return m_measurementUnitDuringCalib;
}

short MachineData::getTemperatureCelcius() const
{
    return m_temperatureCelcius;
}

short MachineData::getFanPrimaryStandbyDutyCycleFactory() const
{
    return m_fanPrimaryStandbyDutyCycleFactory;
}

int MachineData::getFanPrimaryStandbyRpmFactory() const
{
    return m_fanPrimaryStandbyRpmFactory;
}

short MachineData::getFanPrimaryNominalDutyCycleField() const
{
    return m_fanPrimaryNominalDutyCycleField;
}

int MachineData::getFanPrimaryNominalRpmField() const
{
    return m_fanPrimaryNominalRpmField;
}

short MachineData::getFanPrimaryNominalDutyCycleFactory() const
{
    return m_fanPrimaryNominalDutyCycleFactory;
}

int MachineData::getFanPrimaryNominalRpmFactory() const
{
    return m_fanPrimaryNominalRpmFactory;
}

short MachineData::getFanPrimaryMinimumDutyCycleFactory() const
{
    return m_fanPrimaryMinimumDutyCycleFactory;
}

int MachineData::getFanPrimaryMinimumRpmFactory() const
{
    return m_fanPrimaryMinimumRpmFactory;
}

short MachineData::getFanPrimaryMinimumDutyCycleField() const
{
    return m_fanPrimaryNominalDutyCycleField;
}

int MachineData::getFanPrimaryMinimumRpmField() const
{
    return m_fanPrimaryNominalRpmField;
}

int MachineData::getFanPrimaryStandbyRpm() const
{
    return m_fanPrimaryStandbyRpm;
}

short MachineData::getFanPrimaryMaximumDutyCycleFactory() const
{
    return m_fanPrimaryMaximumDutyCycleFactory;
}

int MachineData::getFanPrimaryMaximumRpmFactory() const
{
    return m_fanPrimaryMaximumRpmFactory;
}

short MachineData::getFanPrimaryMaximumDutyCycleField() const
{
    return m_fanPrimaryMaximumDutyCycleField;
}

int MachineData::getFanPrimaryMaximumRpmField() const
{
    return m_fanPrimaryMaximumRpmField;
}

short MachineData::getTemperature() const
{
    return m_temperature;
}

///AIRFLOW MONITOR
bool MachineData::getAirflowMonitorEnable() const
{
    return m_airflowMonitorEnable;
}

void MachineData::setAirflowMonitorEnable(bool airflowMonitorEnable)
{
    if(m_airflowMonitorEnable == airflowMonitorEnable) return;
    m_airflowMonitorEnable = airflowMonitorEnable;
    emit airflowMonitorEnableChanged(m_airflowMonitorEnable);
}

//AIRFLOW INFLOW
int MachineData::getInflowAdc() const
{
    return m_ifaAdc;
}
int MachineData::getInflowAdcConpensation() const
{
    return m_ifaAdcConpensation;
}
QString MachineData::getInflowVelocityStr() const
{
    return m_ifaVelocityStr;
}
//
int MachineData::getInflowLowLimitVelocity() const
{
    return m_ifaLowLimitVelocity;
}
short MachineData::getInflowSensorConstant()
{
    return m_ifaConstant;
}
int MachineData::getInflowTempCalib()
{
    return m_ifaTemperatureCalib;
}
int MachineData::getInflowTempCalibAdc()
{
    return m_ifaTemperatureCalibAdc;
}
int MachineData::getInflowAdcPointFactory(short point)
{
    return m_ifaAdcPointFactory[point];
}
int MachineData::getInflowVelocityPointFactory(short point)
{
    return m_ifaVelocityPointFactory[point];
}
int MachineData::getInflowAdcPointField(short point)
{
    return m_ifaAdcPointField[point];
}
int MachineData::getInflowVelocityPointField(short point)
{
    return m_ifaVelocityPointField[point];
}
//
//
void MachineData::setInflowVelocity(int ifaVelocity)
{
    if (m_ifaVelocity == ifaVelocity)
        return;

    m_ifaVelocity = ifaVelocity;
    emit ifaVelocityChanged(m_ifaVelocity);
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
void MachineData::setInflowVelocityStr(QString ifaVelocityStr)
{
    if (m_ifaVelocityStr == ifaVelocityStr)
        return;

    m_ifaVelocityStr = ifaVelocityStr;
    emit ifaVelocityStrChanged(m_ifaVelocityStr);
}
//
void MachineData::setInflowLowLimitVelocity(int ifaLowLimitVelocity)
{
    if (m_ifaLowLimitVelocity == ifaLowLimitVelocity)
        return;

    m_ifaLowLimitVelocity = ifaLowLimitVelocity;
}
void MachineData::setInflowSensorConstant(short value)
{
    if (m_ifaConstant == value)
        return;

    m_ifaConstant = value;
    //    emit ifaAdcConpensationChanged(m_ifaAdcConpensation);
}
void MachineData::setInflowTempCalib(short value)
{
    if (m_ifaTemperatureCalib == value)
        return;

    m_ifaTemperatureCalib = value;
}

void MachineData::setInflowTempCalibAdc(short value)
{
    if (m_ifaTemperatureCalibAdc == value)
        return;

    m_ifaTemperatureCalibAdc = value;
}
void MachineData::setInflowAdcPointFactory(short point, int value)
{
    if (m_ifaAdcPointFactory[point] == value)
        return;

    m_ifaAdcPointFactory[point] = value;
    //    emit ifaAdcConpensationChanged(m_ifaAdcConpensation);
}
void MachineData::setInflowVelocityPointFactory(short point, int value)
{
    if (m_ifaVelocityPointFactory[point] == value)
        return;

    m_ifaVelocityPointFactory[point] = value;
    //    emit ifaAdcConpensationChanged(m_ifaAdcConpensation);
}
void MachineData::setInflowAdcPointField(short point, int value)
{
    if (m_ifaAdcPointField[point] == value)
        return;

    m_ifaAdcPointField[point] = value;
    //    emit ifaAdcConpensationChanged(m_ifaAdcConpensation);
}
void MachineData::setInflowVelocityPointField(short point, int value)
{
    if (m_ifaVelocityPointField[point] == value)
        return;

    m_ifaVelocityPointField[point] = value;
    //    emit ifaAdcConpensationChanged(m_ifaAdcConpensation);
}


//
///AIRFLOW DOWNFLOW
int MachineData::getDownflowVelocity() const
{
    return m_dfaVelocity;
}
int MachineData::getDownflowAdc() const
{
    return m_dfaAdc;
}
int MachineData::getDownflowAdcConpensation() const
{
    return m_dfaAdcConpensation;
}
QString MachineData::getDownflowVelocityStr() const
{
    return m_dfaVelocityStr;
}
//
int MachineData::getDownflowLowLimitVelocity() const
{
    return m_dfaLowLimitVelocity;
}

int MachineData::getDownflowHighLimitVelocity() const
{
    return m_dfaHighLimitVelocity;
}
short MachineData::getDownflowSensorConstant()
{
    return m_dfaConstant;
}
int MachineData::getDownflowTempCalib()
{
    return m_dfaTemperatureCalib;
}
int MachineData::getDownflowTempCalibAdc()
{
    return m_dfaTemperatureCalibAdc;
}
int MachineData::getDownflowAdcPointFactory(short point)
{
    return m_dfaAdcPointFactory[point];
}
int MachineData::getDownflowVelocityPointFactory(short point)
{
    return m_dfaVelocityPointFactory[point];
}
int MachineData::getDownflowAdcPointField(short point)
{
    return m_dfaAdcPointField[point];
}
int MachineData::getDownflowVelocityPointField(short point)
{
    return m_dfaVelocityPointField[point];
}
//
//
void MachineData::setDownflowVelocity(int dfaVelocity)
{
    if (m_dfaVelocity == dfaVelocity)
        return;

    m_dfaVelocity = dfaVelocity;
    emit dfaVelocityChanged(m_dfaVelocity);
}
void MachineData::setDownflowAdc(int dfaAdc)
{
    if (m_dfaAdc == dfaAdc)
        return;

    m_dfaAdc = dfaAdc;
    emit dfaAdcChanged(m_dfaAdc);
}
void MachineData::setDownflowAdcConpensation(int dfaAdcConpensation)
{
    if (m_dfaAdcConpensation == dfaAdcConpensation)
        return;

    m_dfaAdcConpensation = dfaAdcConpensation;
    emit dfaAdcConpensationChanged(m_dfaAdcConpensation);
}
void MachineData::setDownflowVelocityStr(QString dfaVelocityStr)
{
    if (m_dfaVelocityStr == dfaVelocityStr)
        return;

    m_dfaVelocityStr = dfaVelocityStr;
    emit dfaVelocityStrChanged(m_dfaVelocityStr);
}
//
void MachineData::setDownflowLowLimitVelocity(int dfaLowLimitVelocity)
{
    if (m_dfaLowLimitVelocity == dfaLowLimitVelocity)
        return;

    m_dfaLowLimitVelocity = dfaLowLimitVelocity;
}

void MachineData::setDownflowHighLimitVelocity(int ifaHighLimitVelocity)
{
    if (m_dfaHighLimitVelocity == ifaHighLimitVelocity)
        return;

    m_dfaHighLimitVelocity = ifaHighLimitVelocity;
}
void MachineData::setDownflowSensorConstant(short value)
{
    if (m_dfaConstant == value)
        return;

    m_dfaConstant = value;
    //    emit dfaAdcConpensationChanged(m_dfaAdcConpensation);
}
void MachineData::setDownflowTempCalib(short value)
{
    if (m_dfaTemperatureCalib == value)
        return;

    m_dfaTemperatureCalib = value;
}

void MachineData::setDownflowTempCalibAdc(short value)
{
    if (m_dfaTemperatureCalibAdc == value)
        return;

    m_dfaTemperatureCalibAdc = value;
}
void MachineData::setDownflowAdcPointFactory(short point, int value)
{
    if (m_dfaAdcPointFactory[point] == value)
        return;

    m_dfaAdcPointFactory[point] = value;
    //    emit dfaAdcConpensationChanged(m_dfaAdcConpensation);
}
void MachineData::setDownflowVelocityPointFactory(short point, int value)
{
    if (m_dfaVelocityPointFactory[point] == value)
        return;

    m_dfaVelocityPointFactory[point] = value;
    //    emit dfaAdcConpensationChanged(m_dfaAdcConpensation);
}
void MachineData::setDownflowAdcPointField(short point, int value)
{
    if (m_dfaAdcPointField[point] == value)
        return;

    m_dfaAdcPointField[point] = value;
    //    emit dfaAdcConpensationChanged(m_dfaAdcConpensation);
}
void MachineData::setDownflowVelocityPointField(short point, int value)
{
    if (m_dfaVelocityPointField[point] == value)
        return;

    m_dfaVelocityPointField[point] = value;
    //    emit dfaAdcConpensationChanged(m_dfaAdcConpensation);
}
//
/// AIRFLOW CALIBRATION STATUS
void MachineData::setInflowCalibrationStatus(short inflowCalibrationMode)
{
    if (m_inflowCalibrationStatus == inflowCalibrationMode)
        return;

    m_inflowCalibrationStatus = inflowCalibrationMode;
    emit inflowCalibrationStatusChanged(m_inflowCalibrationStatus);
}
short MachineData::getInflowCalibrationStatus() const
{
    return m_inflowCalibrationStatus;
}
void MachineData::setDownflowCalibrationStatus(short downflowCalibrationMode)
{
    if (m_downflowCalibrationStatus == downflowCalibrationMode)
        return;

    m_downflowCalibrationStatus = downflowCalibrationMode;
    emit downflowCalibrationStatusChanged(m_downflowCalibrationStatus);
}
short MachineData::getDownflowCalibrationStatus() const
{
    return m_downflowCalibrationStatus;
}
void MachineData::setAirflowCalibrationStatus(short airflowCalibrationMode)
{
    if (m_airflowCalibrationStatus == airflowCalibrationMode)
        return;

    m_airflowCalibrationStatus = airflowCalibrationMode;
    emit airflowCalibrationStatusChanged(m_airflowCalibrationStatus);
}
short MachineData::getAirflowCalibrationStatus() const
{
    return m_airflowCalibrationStatus;
}


///////////
void MachineData::setFanPrimaryRpm(int value)
{
    if (m_fanPrimaryRpm == value)
        return;

    m_fanPrimaryRpm = value;
    emit fanPrimaryRpmChanged(m_fanPrimaryRpm);
}

void MachineData::setFanPrimaryMaximumDutyCycle(short value)
{
    if (m_fanPrimaryMaximumDutyCycle == value)
        return;

    m_fanPrimaryMaximumDutyCycle = value;
    //emit fanPrimaryMaximumDutyCycleChanged(m_fanPrimaryMaximumDutyCycle);
}

void MachineData::setFanPrimaryMaximumRpm(short value)
{
    if (m_fanPrimaryMaximumRpm == value)
        return;

    m_fanPrimaryMaximumRpm = value;
    //emit fanPrimaryMaximumRpmChanged(m_fanPrimaryMaximumRpm);
}

void MachineData::setFanPrimaryNominalDutyCycle(short value)
{
    if (m_fanPrimaryNominalDutyCycle == value)
        return;

    m_fanPrimaryNominalDutyCycle = value;
    //    emit fanPrimaryNominalDutyCycleChanged(m_fanPrimaryNominalDutyCycle);
}

void MachineData::setFanPrimaryNominalRpm(short value)
{
    if (m_fanPrimaryNominalRpm == value)
        return;

    m_fanPrimaryNominalRpm = value;
    //    emit fanPrimaryNominalRpmChanged(m_fanPrimaryNominalRpm);
}

void MachineData::setFanPrimaryMinimumDutyCycle(short value)
{
    if (m_fanPrimaryMinimumDutyCycle == value)
        return;

    m_fanPrimaryMinimumDutyCycle = value;
    //    emit fanPrimaryMinimumDutyCycleChanged(m_fanPrimaryMinimumDutyCycle);
}

void MachineData::setFanPrimaryMinimumRpm(short value)
{
    if (m_fanPrimaryMinimumRpm == value)
        return;

    m_fanPrimaryMinimumRpm = value;
    //    emit fanPrimaryMinimumRpmChanged(m_fanPrimaryMinimumRpm);
}

void MachineData::setFanPrimaryStandbyDutyCycle(short value)
{
    if (m_fanPrimaryStandbyDutyCycle == value)
        return;

    m_fanPrimaryStandbyDutyCycle = value;
    //    emit fanPrimaryStandbyDutyCycleChanged(m_fanPrimaryStandbyDutyCycle);
}

void MachineData::setFanPrimaryStandbyRpm(int fanPrimaryStandbyRpm)
{
    if (m_fanPrimaryStandbyRpm == fanPrimaryStandbyRpm)
        return;

    m_fanPrimaryStandbyRpm = fanPrimaryStandbyRpm;
    //    emit fanPrimaryStandbyRpmChanged(m_fanPrimaryStandbyRpm);
}

void MachineData::setFanPrimaryMaximumDutyCycleFactory(short fanPrimaryMaximumDutyCycleFactory)
{
    if (m_fanPrimaryMaximumDutyCycleFactory == fanPrimaryMaximumDutyCycleFactory)
        return;

    m_fanPrimaryMaximumDutyCycleFactory = fanPrimaryMaximumDutyCycleFactory;
}

void MachineData::setFanPrimaryMaximumRpmFactory(int fanPrimaryMaximumRpmFactory)
{
    if (m_fanPrimaryMaximumRpmFactory == fanPrimaryMaximumRpmFactory)
        return;

    m_fanPrimaryMaximumRpmFactory = fanPrimaryMaximumRpmFactory;
}

void MachineData::setFanPrimaryMaximumDutyCycleField(short fanPrimaryMaximumDutyCycleField)
{
    if (m_fanPrimaryMaximumDutyCycleField == fanPrimaryMaximumDutyCycleField)
        return;

    m_fanPrimaryMaximumDutyCycleField = fanPrimaryMaximumDutyCycleField;
}

void MachineData::setFanPrimaryMaximumRpmField(int fanPrimaryMaximumRpmField)
{
    if (m_fanPrimaryMaximumRpmField == fanPrimaryMaximumRpmField)
        return;

    m_fanPrimaryMaximumRpmField = fanPrimaryMaximumRpmField;
}

int MachineData::getInflowVelocity() const
{
    return m_ifaVelocity;
}

void MachineData::setMachineProfileName(QString machineProfileName)
{
    if (m_machineProfileName == machineProfileName)
        return;

    m_machineProfileName = machineProfileName;
    emit machineProfileNameChanged(m_machineProfileName);
}

QJsonObject MachineData::getMachineProfile() const
{
    return m_machineProfile;
}

void MachineData::setMachineProfile(QJsonObject machineProfile)
{
    if (m_machineProfile == machineProfile)
        return;

    m_machineProfile = machineProfile;
    emit machineProfileChanged(m_machineProfile);
}

int MachineData::getFanPrimaryRpm() const
{
    return m_fanPrimaryRpm;
}

short MachineData::getFanPrimaryMaximumlDutyCycle() const
{
    return m_fanPrimaryMaximumDutyCycle;
}

int MachineData::getFanPrimaryMaximumRpm() const
{
    return m_fanPrimaryMaximumRpm;
}

short MachineData::getFanPrimaryNominalDutyCycle() const
{
    return m_fanPrimaryNominalDutyCycle;
}

int MachineData::getFanPrimaryNominalRpm() const
{
    return m_fanPrimaryNominalRpm;
}

short MachineData::getFanPrimaryMinimumDutyCycle() const
{
    return m_fanPrimaryMinimumDutyCycle;
}

int MachineData::getFanPrimaryMinimumRpm() const
{
    return m_fanPrimaryMinimumRpm;
}

short MachineData::getFanPrimaryStandbyDutyCycle() const
{
    return m_fanPrimaryStandbyDutyCycle;
}

void MachineData::setTimeClockPeriod(short timeClockPeriod)
{
    if (m_timeClockPeriod == timeClockPeriod)
        return;

    m_timeClockPeriod = timeClockPeriod;
    emit timeClockPeriodChanged(m_timeClockPeriod);
}

QString MachineData::getMachineProfileName() const
{
    return m_machineProfileName;
}

void MachineData::setTimeZone(QString timeZone)
{
    if (m_timeZone == timeZone)
        return;

    m_timeZone = timeZone;
    emit timeZoneChanged(m_timeZone);
}

short MachineData::getTimeClockPeriod() const
{
    return m_timeClockPeriod;
}

void MachineData::setLanguage(QString language)
{
    if (m_language == language)
        return;

    m_language = language;
    emit languageChanged(m_language);
}

QString MachineData::getTimeZone() const
{
    return m_timeZone;
}

void MachineData::setLcdBrightnessDelayToDimm(short lcdBrightnessDelayToDimm)
{
    if (m_lcdBrightnessDelayToDimm == lcdBrightnessDelayToDimm)
        return;

    m_lcdBrightnessDelayToDimm = lcdBrightnessDelayToDimm;
    emit lcdBrightnessDelayToDimmChanged(m_lcdBrightnessDelayToDimm);
}

QString MachineData::getLanguage() const
{
    return m_language;
}

void MachineData::setLcdBrightnessLevelUser(short lcdBrightnessLevelUser)
{
    if (m_lcdBrightnessLevelUser == lcdBrightnessLevelUser)
        return;

    m_lcdBrightnessLevelUser = lcdBrightnessLevelUser;
    emit lcdBrightnessLevelUserChanged(m_lcdBrightnessLevelUser);
}

void MachineData::setLcdBrightnessLevel(short lcdBrightnessLevel)
{
    if (m_lcdBrightnessLevel == lcdBrightnessLevel)
        return;

    m_lcdBrightnessLevel = lcdBrightnessLevel;
    emit lcdBrightnessLevelChanged(m_lcdBrightnessLevel);
}

short MachineData::getLcdBrightnessDelayToDimm() const
{
    return m_lcdBrightnessDelayToDimm;
}

void MachineData::setMachineModelName(QString unitModelName)
{
    if (m_unitModelName == unitModelName)
        return;

    m_unitModelName = unitModelName;
    emit machineModelNameChanged(m_unitModelName);
}

void MachineData::setFanPrimaryDutyCycle(short value)
{
    if (m_fanPrimaryDutyCycle == value)
        return;

    m_fanPrimaryDutyCycle = value;
    emit fanPrimaryDutyCycleChanged(m_fanPrimaryDutyCycle);
}

QString MachineData::getMachineModelName() const
{
    return m_unitModelName;
}

//int MachineData::getUnitModelID() const
//{
//    return m_unitModelID;
//}

QString MachineData::getMachineClassName() const
{
    return m_unitClassName;
}

void MachineData::setMachineClassName(QString unitClassName)
{
    if (m_unitClassName == unitClassName)
        return;

    m_unitClassName = unitClassName;
    emit machineClassNameChanged(m_unitClassName);
}

short MachineData::getLcdBrightnessLevelUser() const
{
    return m_lcdBrightnessLevelUser;
}

short MachineData::getLcdBrightnessLevel() const
{
    return m_lcdBrightnessLevel;
}

void MachineData::setFanPrimaryState(short fanPrimaryState)
{
    if (m_fanPrimaryState == fanPrimaryState)
        return;

    m_fanPrimaryState = fanPrimaryState;
    emit fanPrimaryStateChanged(m_fanPrimaryState);
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
    emit socketStateChanged(m_socketState);
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

short MachineData::getSashWindowStateSample(short index) const
{
    if(index >= 5)return 0;
    return m_sashWindowStateSample[index];
}

void MachineData::setSashWindowStateSample(short sashWindowState, short index)
{
    if(index >= 5)return;
    if (m_sashWindowStateSample[index] == sashWindowState)
        return;

    m_sashWindowStateSample[index] = sashWindowState;
}

bool MachineData::getSashWindowStateChangedValid() const
{
    return m_sashWindowStateChangedValid;
}

void MachineData::setSashWindowStateChangedValid(bool value)
{
    if (m_sashWindowStateChangedValid == value)
        return;

    m_sashWindowStateChangedValid = value;
}

short MachineData::getFanState() const
{
    return m_fanState;
}

void MachineData::setFanState(short fanState)
{
    if(m_fanState == fanState) return;
    m_fanState = fanState;
    emit fanStateChanged(m_fanState);
}

void MachineData::setSashWindowPrevState(short sashMotorizeState)
{
    if (m_sashWindowPrevState == sashMotorizeState)
        return;

    m_sashWindowPrevState = sashMotorizeState;
    emit sashWindowPrevStateChanged(m_sashWindowPrevState);
}

void MachineData::setSashWindowMotorizeState(short sashMotorizeState)
{
    if (m_sashWindowMotorizeState == sashMotorizeState)
        return;

    m_sashWindowMotorizeState = sashMotorizeState;
    emit sashWindowMotorizeStateChanged(m_sashWindowMotorizeState);
}

void MachineData::setExhaustContactState(short exhaustContactState)
{
    if (m_exhaustContactState == exhaustContactState)
        return;

    m_exhaustContactState = exhaustContactState;
    emit exhaustContactStateChanged(m_exhaustContactState);
}

void MachineData::setAlarmContactState(short alarmContactState)
{
    if (m_alarmContactState == alarmContactState)
        return;

    m_alarmContactState = alarmContactState;
    emit alarmContactStateChanged(m_alarmContactState);
}

void MachineData::setLightIntensity(short lightIntensity)
{
    if (m_lightIntensity == lightIntensity)
        return;

    m_lightIntensity = lightIntensity;
    emit lightIntensityChanged(m_lightIntensity);
}

void MachineData::setAlarmInflowLow(short alarmInflowLow)
{
    if (m_alarmInflowLow == alarmInflowLow)
        return;

    m_alarmInflowLow = alarmInflowLow;
    emit alarmInflowLowChanged(m_alarmInflowLow);
}

void MachineData::setAlarmSash(short alarmSash)
{
    if (m_alarmSash == alarmSash)
        return;

    m_alarmSash = alarmSash;
    emit alarmSashChanged(m_alarmSash);
}

short MachineData::getAlarmStandbyFanOff() const
{
    return m_alarmStandbyFanOff;
}

void MachineData::setAlarmStandbyFanOff(short alarm)
{
    if (m_alarmStandbyFanOff == alarm)
        return;

    m_alarmStandbyFanOff = alarm;
    emit alarmStandbyFanOffChanged(m_alarmStandbyFanOff);
}

short MachineData::getAlarmExperimentTimerIsOver() const
{
    return m_alarmExperimentTimerIsOver;
}

void MachineData::setAlarmExperimentTimerIsOver(short value)
{
    if(m_alarmExperimentTimerIsOver == value)return;
    m_alarmExperimentTimerIsOver = value;
    emit alarmExperimentTimerIsOverChanged(value);
}

void MachineData::setTemperatureAdc(int temperatureAdc)
{
    if (m_temperatureAdc == temperatureAdc)
        return;

    m_temperatureAdc = temperatureAdc;
    emit temperatureAdcChanged(m_temperatureAdc);
}

void MachineData::setTemperatureValueStrf(QString temperatureValueStrf)
{
    if (m_temperatureValueStrf == temperatureValueStrf)
        return;

    m_temperatureValueStrf = temperatureValueStrf;
    emit temperatureValueStrfChanged(m_temperatureValueStrf);
}

void MachineData::setMeasurementUnit(short measurementUnit)
{
    if (m_measurementUnit == measurementUnit)
        return;

    m_measurementUnit = measurementUnit;
    emit measurementUnitChanged(m_measurementUnit);
}

short MachineData::getFanPrimaryDutyCycle() const
{
    return m_fanPrimaryDutyCycle;
}


int MachineData::getEscoLockServiceEnable() const
{
    return m_escoLockServiceEnable;
}

void MachineData::setCertificationExpiredValid(bool certificationExpiredValid)
{
    if (m_certificationExpiredValid == certificationExpiredValid)
        return;

    m_certificationExpiredValid = certificationExpiredValid;
    emit certificationExpiredValidChanged(m_certificationExpiredValid);
}
