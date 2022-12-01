#include <QJSEngine>
#include <QQmlEngine>
#include <QThread>
#include <QTimer>

#include <QtDebug>

#include "MachineBackend.h"
#include "MachineData.h"
#include "MachineProxy.h"

/// TEI = TIMER EVENT INTERVAL
#ifdef __arm__
#define TEI_FOR_WORKER 150 // ms
#else
#define TEI_FOR_WORKER 1000 // ms
#endif

static MachineProxy *s_instance = nullptr;

QObject *MachineProxy::singletonProvider(QQmlEngine *qmlEngine, QJSEngine *) {
  if (!s_instance) {
    qDebug() << "MachineData::singletonProvider::create" << s_instance;
    s_instance = new MachineProxy(qmlEngine);
  }
  return s_instance;
}

MachineProxy::MachineProxy(QObject *parent) : QObject(parent) {}

MachineProxy::~MachineProxy() { qDebug() << __FUNCTION__ << thread(); }

int MachineProxy::getCount() const { return m_count; }

void MachineProxy::initSingleton() {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
}

void MachineProxy::setup(QObject *pData) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  /// Create machine instance
  m_machineBackend.reset(new MachineBackend);

  /// Create thread where machineState will a life
  m_threadForMachineState.reset(new QThread);

  /// Create timer event for triggered any event on the machineState
  m_timerEventForMachineState.reset(new QTimer);
  m_timerEventForMachineState->setInterval(TEI_FOR_WORKER);

  pMachineData = qobject_cast<MachineData *>(pData);
  pMachineData->setMachineBackendState(MachineEnums::MACHINE_STATE_SETUP);
  m_machineBackend->setMachineData(pMachineData);

  /// Start timer event when thread was called
  QObject::connect(m_threadForMachineState.data(), &QThread::started,
                   m_timerEventForMachineState.data(),
                   QOverload<>::of(&QTimer::start));

  /// Stop timer event when thread was called
  QObject::connect(m_threadForMachineState.data(), &QThread::finished,
                   m_timerEventForMachineState.data(),
                   QOverload<>::of(&QTimer::stop));

  /// Trigger worker on starting
  QObject::connect(m_threadForMachineState.data(), &QThread::started,
                   m_machineBackend.data(),
                   [&]() { m_machineBackend->routineTask(); });

  /// stopped thread
  QObject::connect(m_machineBackend.data(), &MachineBackend::hasStopped, this,
                   &MachineProxy::doStopping);

  /// Call worker every time timer was timeout , routine task
  QObject::connect(m_timerEventForMachineState.data(), &QTimer::timeout,
                   m_machineBackend.data(), &MachineBackend::routineTask);

  /// Move the object to another thread
  m_machineBackend->moveToThread(m_threadForMachineState.data());
  m_timerEventForMachineState->moveToThread(m_threadForMachineState.data());

  /// start the thread
  m_threadForMachineState->start();
}

void MachineProxy::stop() {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  /// Send to machine statae
  QMetaObject::invokeMethod(m_machineBackend.data(), &MachineBackend::stop,
                            Qt::QueuedConnection);
}

// void MachineProxy::setMachineProfileID(const QString value)
//{
//     QMetaObject::invokeMethod(m_machineBackend.data(), [&, value](){
//         m_machineBackend->setMachineProfileID(value);
//     },
//     Qt::QueuedConnection);
// }

void MachineProxy::setLcdTouched() {
  //    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(), [&]() { m_machineBackend->setLcdTouched(); },
      Qt::QueuedConnection);
}

void MachineProxy::setLcdBrightnessLevel(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setLcdBrightnessLevel(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setLcdBrightnessDelayToDimm(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setLcdBrightnessDelayToDimm(value); },
      Qt::QueuedConnection);
}

void MachineProxy::saveLcdBrightnessLevel(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->saveLcdBrightnessLevel(value); },
      Qt::QueuedConnection);
}

void MachineProxy::saveLanguage(const QString value) {
  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->saveLanguage(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setTimeZone(const QString value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;
  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setTimeZone(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setDateTime(const QString value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;
  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setDateTime(value); },
      Qt::QueuedConnection);
}

void MachineProxy::saveTimeClockPeriod(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;
  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->saveTimeClockPeriod(value); },
      Qt::QueuedConnection);
}

void MachineProxy::deleteFileOnSystem(const QString path) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << path;
  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, path]() { m_machineBackend->deleteFileOnSystem(path); },
      Qt::QueuedConnection);
}

void MachineProxy::setMuteVivariumState(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setMuteVivariumState(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setMuteAlarmState(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setMuteAlarmState(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setMuteAlarmTime(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setMuteAlarmTime(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setBuzzerState(bool value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setBuzzerState(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setBuzzerBeep() {
  QMetaObject::invokeMethod(
      m_machineBackend.data(), [&]() { m_machineBackend->setBuzzerBeep(); },
      Qt::QueuedConnection);
}

void MachineProxy::setSignedUser(const QString username, const QString fullname, short userLevel) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, username, fullname, userLevel]() {
        m_machineBackend->setSignedUser(username, fullname, userLevel);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setUserLastLogin(const QString username,
                                    const QString fullname) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, username, fullname]() {
        m_machineBackend->setUserLastLogin(username, fullname);
      },
      Qt::QueuedConnection);
}

void MachineProxy::deleteUserLastLogin(const QString username) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, username]() { m_machineBackend->deleteUserLastLogin(username); },
      Qt::QueuedConnection);
}

void MachineProxy::setDataLogEnable(bool dataLogEnable) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, dataLogEnable]() {
        m_machineBackend->setDataLogEnable(dataLogEnable);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setDataLogRunning(bool dataLogRunning) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, dataLogRunning]() {
        m_machineBackend->setDataLogRunning(dataLogRunning);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setDataLogPeriod(short dataLogPeriod) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, dataLogPeriod]() {
        m_machineBackend->setDataLogPeriod(dataLogPeriod);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setDataLogCount(int dataLogCount) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, dataLogCount]() { m_machineBackend->setDataLogCount(dataLogCount); },
      Qt::QueuedConnection);
}

void MachineProxy::setResourceMonitorLogEnable(bool value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setResourceMonitorLogEnable(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setResourceMonitorLogRunning(bool value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setResourceMonitorLogRunning(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setResourceMonitorLogPeriod(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setResourceMonitorLogPeriod(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setResourceMonitorLogCount(int value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setResourceMonitorLogCount(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setModbusSlaveID(short slaveId) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, slaveId]() { m_machineBackend->setModbusSlaveID(slaveId); },
      Qt::QueuedConnection);
}

void MachineProxy::setModbusAllowingIpMaster(const QString ipAddr) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, ipAddr]() { m_machineBackend->setModbusAllowingIpMaster(ipAddr); },
      Qt::QueuedConnection);
}

void MachineProxy::setModbusAllowSetFan(bool value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setModbusAllowSetFan(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setModbusAllowSetLight(bool value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setModbusAllowSetLight(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setModbusAllowSetLightIntensity(bool value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setModbusAllowSetLightIntensity(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setModbusAllowSetSocket(bool value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setModbusAllowSetSocket(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setModbusAllowSetGas(bool value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setModbusAllowSetGas(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setModbusAllowSetUvLight(bool value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setModbusAllowSetUvLight(value); },
      Qt::QueuedConnection);
}

void MachineProxy::insertEventLog(const QString eventText) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, eventText]() { m_machineBackend->insertEventLog(eventText); },
      Qt::QueuedConnection);
}

void MachineProxy::setUVAutoEnabled(int uvAutoSetEnabled) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << uvAutoSetEnabled;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, uvAutoSetEnabled]() {
        m_machineBackend->setUVAutoEnabled(uvAutoSetEnabled);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setUVAutoTime(int uvAutoSetTime) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << uvAutoSetTime;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, uvAutoSetTime]() { m_machineBackend->setUVAutoTime(uvAutoSetTime); },
      Qt::QueuedConnection);
}

void MachineProxy::setUVAutoDayRepeat(int uvAutoSetDayRepeat) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << uvAutoSetDayRepeat;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, uvAutoSetDayRepeat]() {
        m_machineBackend->setUVAutoDayRepeat(uvAutoSetDayRepeat);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setUVAutoWeeklyDay(int uvAutoSetWeeklyDay) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << uvAutoSetWeeklyDay;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, uvAutoSetWeeklyDay]() {
        m_machineBackend->setUVAutoWeeklyDay(uvAutoSetWeeklyDay);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setUVAutoEnabledOff(int uvAutoSetEnabledOff) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << uvAutoSetEnabledOff;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, uvAutoSetEnabledOff]() {
        m_machineBackend->setUVAutoEnabledOff(uvAutoSetEnabledOff);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setUVAutoTimeOff(int uvAutoSetTimeOff) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << uvAutoSetTimeOff;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, uvAutoSetTimeOff]() {
        m_machineBackend->setUVAutoTimeOff(uvAutoSetTimeOff);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setUVAutoDayRepeatOff(int uvAutoSetDayRepeatOff) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << uvAutoSetDayRepeatOff;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, uvAutoSetDayRepeatOff]() {
        m_machineBackend->setUVAutoDayRepeatOff(uvAutoSetDayRepeatOff);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setUVAutoWeeklyDayOff(int uvAutoSetWeeklyDayOff) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << uvAutoSetWeeklyDayOff;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, uvAutoSetWeeklyDayOff]() {
        m_machineBackend->setUVAutoWeeklyDayOff(uvAutoSetWeeklyDayOff);
      },
      Qt::QueuedConnection);
}

/// FAN ON SCHEDULER
void MachineProxy::setFanAutoEnabled(int fanAutoSetEnabled) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << fanAutoSetEnabled;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, fanAutoSetEnabled]() {
        m_machineBackend->setFanAutoEnabled(fanAutoSetEnabled);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanAutoTime(int fanAutoSetTime) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << fanAutoSetTime;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, fanAutoSetTime]() {
        m_machineBackend->setFanAutoTime(fanAutoSetTime);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanAutoDayRepeat(int fanAutoSetDayRepeat) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << fanAutoSetDayRepeat;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, fanAutoSetDayRepeat]() {
        m_machineBackend->setFanAutoDayRepeat(fanAutoSetDayRepeat);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanAutoWeeklyDay(int fanAutoSetWeeklyDay) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << fanAutoSetWeeklyDay;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, fanAutoSetWeeklyDay]() {
        m_machineBackend->setFanAutoWeeklyDay(fanAutoSetWeeklyDay);
      },
      Qt::QueuedConnection);
}
/// FAN OFF SCHEDULER
void MachineProxy::setFanAutoEnabledOff(int fanAutoSetEnabledOff) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << fanAutoSetEnabledOff;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, fanAutoSetEnabledOff]() {
        m_machineBackend->setFanAutoEnabledOff(fanAutoSetEnabledOff);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanAutoTimeOff(int fanAutoSetTimeOff) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << fanAutoSetTimeOff;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, fanAutoSetTimeOff]() {
        m_machineBackend->setFanAutoTimeOff(fanAutoSetTimeOff);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanAutoDayRepeatOff(int fanAutoSetDayRepeatOff) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << fanAutoSetDayRepeatOff;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, fanAutoSetDayRepeatOff]() {
        m_machineBackend->setFanAutoDayRepeatOff(fanAutoSetDayRepeatOff);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanAutoWeeklyDayOff(int fanAutoSetWeeklyDayOff) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << fanAutoSetWeeklyDayOff;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, fanAutoSetWeeklyDayOff]() {
        m_machineBackend->setFanAutoWeeklyDayOff(fanAutoSetWeeklyDayOff);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setEscoLockServiceEnable(int escoLockServiceEnable) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << escoLockServiceEnable;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, escoLockServiceEnable]() {
        m_machineBackend->setEscoLockServiceEnable(escoLockServiceEnable);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setCabinetDisplayName(const QString cabinetDisplayName) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << cabinetDisplayName;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, cabinetDisplayName]() {
        m_machineBackend->setCabinetDisplayName(cabinetDisplayName);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanPIN(const QString fanPIN) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << fanPIN;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, fanPIN]() { m_machineBackend->setFanPIN(fanPIN); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanPrimaryUsageMeter(int minutes) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << minutes;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, minutes]() { m_machineBackend->setFanPrimaryUsageMeter(minutes); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanInflowUsageMeter(int minutes) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << minutes;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, minutes]() { m_machineBackend->setFanInflowUsageMeter(minutes); },
      Qt::QueuedConnection);
}

void MachineProxy::setUvUsageMeter(int minutes) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << minutes;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, minutes]() { m_machineBackend->setUvUsageMeter(minutes); },
      Qt::QueuedConnection);
}

void MachineProxy::setFilterUsageMeter(int minutes) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << minutes;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, minutes]() { m_machineBackend->setFilterUsageMeter(minutes); },
      Qt::QueuedConnection);
}

void MachineProxy::setFilterLifeCalculationMode(int value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFilterLifeCalculationMode(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setFilterLifeMinimumBlowerUsageMode(int value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFilterLifeMinimumBlowerUsageMode(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFilterLifeMaximumBlowerUsageMode(int value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFilterLifeMaximumBlowerUsageMode(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFilterLifeMinimumBlowerRpmMode(int value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFilterLifeMinimumBlowerRpmMode(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFilterLifeMaximumBlowerRpmMode(int value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFilterLifeMaximumBlowerRpmMode(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setSashCycleMeter(int sashCycleMeter) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << sashCycleMeter;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, sashCycleMeter]() {
        m_machineBackend->setSashCycleMeter(sashCycleMeter);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setEnvTempHighestLimit(int envTempHighestLimit) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << envTempHighestLimit;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, envTempHighestLimit]() {
        m_machineBackend->setEnvTempHighestLimit(envTempHighestLimit);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setEnvTempLowestLimit(int envTempLowestLimit) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << envTempLowestLimit;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, envTempLowestLimit]() {
        m_machineBackend->setEnvTempLowestLimit(envTempLowestLimit);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setParticleCounterSensorInstalled(
    bool particleCounterSensorInstalled) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << particleCounterSensorInstalled;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, particleCounterSensorInstalled]() {
        m_machineBackend->setParticleCounterSensorInstalled(
            particleCounterSensorInstalled);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setWatchdogResetterState(bool state) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << state;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, state]() { m_machineBackend->setWatchdogResetterState(state); },
      Qt::QueuedConnection);
}

void MachineProxy::refreshLogRowsCount(const QString table) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << table;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, table]() { m_machineBackend->refreshLogRowsCount(table); },
      Qt::QueuedConnection);
}

void MachineProxy::setShippingModeEnable(bool shippingModeEnable) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << shippingModeEnable;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, shippingModeEnable]() {
        m_machineBackend->setShippingModeEnable(shippingModeEnable);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setCurrentSystemAsKnown(bool value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setCurrentSystemAsKnown(value); },
      Qt::QueuedConnection);
}

void MachineProxy::readSbcCurrentFullMacAddress() {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&]() { m_machineBackend->readSbcCurrentFullMacAddress(); },
      Qt::QueuedConnection);
}

void MachineProxy::setAlarmPreventMaintStateEnable(ushort pmCode, bool value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << pmCode << value;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, pmCode, value]() {
        m_machineBackend->setAlarmPreventMaintStateEnable(pmCode, value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setAlarmPreventMaintStateAck(ushort pmCode, bool value,
                                                bool snooze) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << pmCode << value;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, pmCode, value, snooze]() {
        m_machineBackend->setAlarmPreventMaintStateAck(pmCode, value, snooze);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setEth0ConName(const QString value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setEth0ConName(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setEth0Ipv4Address(const QString value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setEth0Ipv4Address(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setEth0ConEnabled(bool value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setEth0ConEnabled(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setWiredNetworkHasbeenConfigured(bool value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setWiredNetworkHasbeenConfigured(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::initWiredConnectionStaticIP() {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&]() { m_machineBackend->initWiredConnectionStaticIP(); },
      Qt::QueuedConnection);
}

void MachineProxy::setSvnUpdateHasBeenApplied() {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&]() { m_machineBackend->setSvnUpdateHasBeenApplied(); },
      Qt::QueuedConnection);
}

void MachineProxy::setSvnUpdateCheckEnable(bool value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setSvnUpdateCheckEnable(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setSvnUpdateCheckPeriod(int value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setSvnUpdateCheckPeriod(value); },
      Qt::QueuedConnection);
}

void MachineProxy::checkSoftwareVersionHistory() {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&]() { m_machineBackend->checkSoftwareVersionHistory(); },
      Qt::QueuedConnection);
}

// void MachineProxy::initReplaceablePartsSettings()
//{
//     QMetaObject::invokeMethod(m_machineBackend.data(), [&](){
//         m_machineBackend->initReplaceablePartsSettings();
//     },
//     Qt::QueuedConnection);
// }

void MachineProxy::setReplaceablePartsSettings(short index,
                                               const QString value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, index, value]() {
        m_machineBackend->setReplaceablePartsSettings(index, value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setReplaceablePartsSelected(short descRowId) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, descRowId]() {
        m_machineBackend->setReplaceablePartsSelected(descRowId);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setKeyboardStringOnAcceptedEvent(const QString value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setKeyboardStringOnAcceptedEvent(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::resetReplaceablePartsSettings() {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&]() { m_machineBackend->resetReplaceablePartsSettings(); },
      Qt::QueuedConnection);
}

void MachineProxy::insertReplaceableComponentsForm() {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&]() { m_machineBackend->insertReplaceableComponentsForm(); },
      Qt::QueuedConnection);
}

void MachineProxy::requestEjectUsb(QString usbName) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, usbName]() { m_machineBackend->requestEjectUsb(usbName); },
      Qt::QueuedConnection);
}

void MachineProxy::setFrontEndScreenState(short value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFrontEndScreenState(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setInstallationWizardActive(bool value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setInstallationWizardActive(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setSomeSettingsAfterExtConfigImported() {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&]() { m_machineBackend->setSomeSettingsAfterExtConfigImported(); },
      Qt::QueuedConnection);
}

void MachineProxy::setAllOutputShutdown() {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&]() { m_machineBackend->setAllOutputShutdown(); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanClosedLoopControlEnable(bool value, bool ignoreFanSpeed) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value, ignoreFanSpeed]() { m_machineBackend->setFanClosedLoopControlEnable(value, ignoreFanSpeed); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanClosedLoopControlEnablePrevState(bool value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanClosedLoopControlEnablePrevState(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanClosedLoopSamplingTime(int value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFanClosedLoopSamplingTime(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanClosedLoopGainIntegralDfa(float value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanClosedLoopGainIntegralDfa(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanClosedLoopGainProportionalDfa(float value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanClosedLoopGainProportionalDfa(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanClosedLoopGainDerivativeDfa(float value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanClosedLoopGainDerivativeDfa(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanClosedLoopGainIntegralIfa(float value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanClosedLoopGainIntegralIfa(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanClosedLoopGainProportionalIfa(float value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanClosedLoopGainProportionalIfa(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanClosedLoopGainDerivativeIfa(float value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanClosedLoopGainDerivativeIfa(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setReadClosedLoopResponse(bool value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setReadClosedLoopResponse(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setFrontPanelSwitchInstalled(bool value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFrontPanelSwitchInstalled(value); },
      Qt::QueuedConnection);
}

void MachineProxy::scanRbmComPortAvalaible(bool value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->scanRbmComPortAvalaible(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setRbmComPortIfa(QString value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setRbmComPortIfa(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setRbmComPortDfa(QString value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setRbmComPortDfa(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setSashMotorOffDelayMsec(int value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setSashMotorOffDelayMsec(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setDelayAlarmAirflowSec(int value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setDelayAlarmAirflowSec(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setScreenSaverSeconds(int value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setScreenSaverSeconds(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setCabinetSideType(short value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setCabinetSideType(value); },
      Qt::QueuedConnection);
}

// void MachineProxy::setWifiDisabled(bool value)
//{
//     QMetaObject::invokeMethod(m_machineBackend.data(), [&, value](){
//         m_machineBackend->setWifiDisabled(value);
//     },
//     Qt::QueuedConnection);
// }

void MachineProxy::setLogoutTime(int value)
{
    QMetaObject::invokeMethod(m_machineBackend.data(), [&, value](){
            m_machineBackend->setLogoutTime(value);
        },
        Qt::QueuedConnection);
}

void MachineProxy::setCFR21Part11Enable(bool value)
{
    QMetaObject::invokeMethod(m_machineBackend.data(), [&, value](){
            m_machineBackend->setCFR21Part11Enable(value);
        },
        Qt::QueuedConnection);
}

void MachineProxy::setDisplayTheme(short value)
{
    QMetaObject::invokeMethod(m_machineBackend.data(), [&, value](){
        m_machineBackend->setDisplayTheme(value);
    },
    Qt::QueuedConnection);
}

void MachineProxy::setAlarmFrontEndBackground(bool value)
{
    QMetaObject::invokeMethod(m_machineBackend.data(), [&, value](){
        m_machineBackend->setAlarmFrontEndBackground(value);
    },
    Qt::QueuedConnection);
}


void MachineProxy::setAlarmExperimentTimerIsOver(short value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setAlarmExperimentTimerIsOver(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setOperationModeSave(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setOperationModeSave(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setOperationMaintenanceMode() {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&]() { m_machineBackend->setOperationMaintenanceMode(); },
      Qt::QueuedConnection);
}

void MachineProxy::setOperationPreviousMode() {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&]() { m_machineBackend->setOperationPreviousMode(); },
      Qt::QueuedConnection);
}

void MachineProxy::setSecurityAccessModeSave(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setSecurityAccessModeSave(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setDateCertificationReminder(const QString value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setDateCertificationReminder(value); },
      Qt::QueuedConnection);
}

// void MachineProxy::saveMachineProfile(const QJsonObject value)
//{
//     //    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
//     //    qDebug() << value;
//     /// compare with string communication
//     /// this method better in error checking during compiling
//     /// this method will append pending task to target object then execute on
//     target thread QMetaObject::invokeMethod(m_machineState.data(), [&,
//     value](){
//         m_machineState->saveMachineProfile(value);
//     },
//     Qt::QueuedConnection);
// }

// void MachineProxy::readMachineProfile()
//{
//     //    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
//     //    qDebug() << value;
//     /// compare with string communication
//     /// this method better in error checking during compiling
//     /// this method will append pending task to target object then execute on
//     target thread QMetaObject::invokeMethod(m_machineState.data(), [&](){
//         m_machineState->readMachineProfile();
//     },
//     Qt::QueuedConnection);
// }

void MachineProxy::setMeasurementUnit(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setMeasurementUnit(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setSerialNumber(QString value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setSerialNumber(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanState(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFanState(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanPrimaryDutyCycle(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFanPrimaryDutyCycle(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanInflowDutyCycle(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFanInflowDutyCycle(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanInflowNominalDutyCycleFactory(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanInflowNominalDutyCycleFactory(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanInflowNominalRpmFactory(int value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFanInflowNominalRpmFactory(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanInflowMinimumDutyCycleFactory(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanInflowMinimumDutyCycleFactory(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanInflowMinimumRpmFactory(int value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFanInflowMinimumRpmFactory(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanInflowStandbyDutyCycleFactory(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanInflowStandbyDutyCycleFactory(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanInflowStandbyRpmFactory(int value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFanInflowStandbyRpmFactory(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanInflowNominalDutyCycleField(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanInflowNominalDutyCycleField(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanInflowNominalRpmField(int value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFanInflowNominalRpmField(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanInflowMinimumDutyCycleField(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanInflowMinimumDutyCycleField(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanInflowMinimumRpmField(int value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFanInflowMinimumRpmField(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanInflowStandbyDutyCycleField(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanInflowStandbyDutyCycleField(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanInflowStandbyRpmField(int value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFanInflowStandbyRpmField(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanPrimaryMaximumDutyCycleFactory(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanPrimaryMaximumDutyCycleFactory(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanPrimaryMaximumRpmFactory(int value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFanPrimaryMaximumRpmFactory(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanPrimaryNominalDutyCycleFactory(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanPrimaryNominalDutyCycleFactory(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanPrimaryNominalRpmFactory(int value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFanPrimaryNominalRpmFactory(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanPrimaryMinimumDutyCycleFactory(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanPrimaryMinimumDutyCycleFactory(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanPrimaryMinimumRpmFactory(int value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFanPrimaryMinimumRpmFactory(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanPrimaryStandbyDutyCycleFactory(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanPrimaryStandbyDutyCycleFactory(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanPrimaryStandbyRpmFactory(int value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFanPrimaryStandbyRpmFactory(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanPrimaryMaximumDutyCycleField(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanPrimaryMaximumDutyCycleField(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanPrimaryMaximumRpmField(int value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFanPrimaryMaximumRpmField(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanPrimaryNominalDutyCycleField(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanPrimaryNominalDutyCycleField(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanPrimaryNominalRpmField(int value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFanPrimaryNominalRpmField(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanPrimaryMinimumDutyCycleField(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanPrimaryMinimumDutyCycleField(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanPrimaryMinimumRpmField(int value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFanPrimaryMinimumRpmField(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setFanPrimaryStandbyDutyCycleField(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setFanPrimaryStandbyDutyCycleField(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setFanPrimaryStandbyRpmField(int value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << value;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setFanPrimaryStandbyRpmField(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setLightIntensity(short lightIntensity) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << lightIntensity;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, lightIntensity]() {
        m_machineBackend->setLightIntensity(lightIntensity);
      },
      Qt::QueuedConnection);
}

void MachineProxy::saveLightIntensity(short lightIntensity) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << lightIntensity;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, lightIntensity]() {
        m_machineBackend->saveLightIntensity(lightIntensity);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setLightState(short lightState) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << lightState;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, lightState]() { m_machineBackend->setLightState(lightState); },
      Qt::QueuedConnection);
}

void MachineProxy::setSocketInstalled(short value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setSocketInstalled(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setSocketState(short socketState) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << socketState;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, socketState]() { m_machineBackend->setSocketState(socketState); },
      Qt::QueuedConnection);
}

void MachineProxy::setGasInstalled(short value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setGasInstalled(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setGasState(short gasState) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << gasState;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, gasState]() { m_machineBackend->setGasState(gasState); },
      Qt::QueuedConnection);
}

void MachineProxy::setUvInstalled(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setUvInstalled(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setUvState(short uvState) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << uvState;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, uvState]() { m_machineBackend->setUvState(uvState); },
      Qt::QueuedConnection);
}

void MachineProxy::setUvTimeSave(int minutes) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, minutes]() { m_machineBackend->setUvTimeSave(minutes); },
      Qt::QueuedConnection);
}

void MachineProxy::setWarmingUpTimeSave(short seconds) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, seconds]() { m_machineBackend->setWarmingUpTimeSave(seconds); },
      Qt::QueuedConnection);
}

void MachineProxy::setPostPurgeTimeSave(short seconds) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, seconds]() { m_machineBackend->setPostPurgeTimeSave(seconds); },
      Qt::QueuedConnection);
}

void MachineProxy::setSashMotorizeInstalled(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setSashMotorizeInstalled(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setSashWindowMotorizeState(short sashMotorizeState) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();
  qDebug() << sashMotorizeState;

  /// compare with string communication
  /// this method better in error checking during compiling
  /// this method will append pending task to target object then execute on
  /// target thread
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, sashMotorizeState]() {
        m_machineBackend->setSashMotorizeState(sashMotorizeState);
      },
      Qt::DirectConnection);
}

void MachineProxy::setSeasFlapInstalled(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setSeasFlapInstalled(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setSeasBuiltInInstalled(short value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setSeasBuiltInInstalled(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setSeasPressureDiffPaLowLimit(int value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setSeasPressureDiffPaLowLimit(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setSeasPressureDiffPaOffset(int value) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setSeasPressureDiffPaOffset(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setAirflowMonitorEnable(bool airflowMonitorEnable) {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, airflowMonitorEnable]() {
        m_machineBackend->setAirflowMonitorEnable(airflowMonitorEnable);
      },
      Qt::QueuedConnection);
}

void MachineProxy::saveInflowMeaDimNominalGrid(const QJsonArray grid, int total,
                                               int average, int volume,
                                               int velocity, int ducy, int rpm,
                                               int fullField) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, grid, total, average, volume, velocity, ducy, rpm, fullField]() {
        m_machineBackend->saveInflowMeaDimNominalGrid(
            grid, total, average, volume, velocity, ducy, rpm, fullField);
      },
      Qt::QueuedConnection);
}

void MachineProxy::saveInflowMeaDimMinimumGrid(const QJsonArray grid, int total,
                                               int average, int volume,
                                               int velocity, int ducy,
                                               int rpm) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, grid, total, average, volume, velocity, ducy, rpm]() {
        m_machineBackend->saveInflowMeaDimMinimumGrid(
            grid, total, average, volume, velocity, ducy, rpm);
      },
      Qt::QueuedConnection);
}

void MachineProxy::saveInflowMeaDimStandbyGrid(const QJsonArray grid, int total,
                                               int average, int volume,
                                               int velocity, int ducy,
                                               int rpm) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, grid, total, average, volume, velocity, ducy, rpm]() {
        m_machineBackend->saveInflowMeaDimStandbyGrid(
            grid, total, average, volume, velocity, ducy, rpm);
      },
      Qt::QueuedConnection);
}



void MachineProxy::setInflowSensorConstant(short value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setInflowSensorConstant(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setInflowSensorConstantTemporary(short value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setInflowSensorConstantTemporary(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setInflowTemperatureCalib(short value, int adc) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value, adc]() {
        m_machineBackend->setInflowTemperatureCalib(value, adc);
      },
      Qt::QueuedConnection);
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value, adc]() {
        m_machineBackend->setDownflowTemperatureCalib(value, adc);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setInflowAdcPointFactory(int pointZero, int pointMin,
                                            int pointNom) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, pointZero, pointMin, pointNom]() {
        m_machineBackend->setInflowAdcPointFactory(pointZero, pointMin,
                                                   pointNom);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setInflowAdcPointFactory(int point, int value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, point, value]() {
        m_machineBackend->setInflowAdcPointFactory(point, value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setInflowVelocityPointFactory(int pointZero, int pointMin,
                                                 int pointNom) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, pointZero, pointMin, pointNom]() {
        m_machineBackend->setInflowVelocityPointFactory(pointZero, pointMin,
                                                        pointNom);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setInflowVelocityPointFactory(int point, int value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, point, value]() {
        m_machineBackend->setInflowVelocityPointFactory(point, value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setInflowAdcPointField(int pointZero, int pointMin,
                                          int pointNom) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, pointZero, pointMin, pointNom]() {
        m_machineBackend->setInflowAdcPointField(pointZero, pointMin, pointNom);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setInflowAdcPointField(int point, int value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, point, value]() {
        m_machineBackend->setInflowAdcPointField(point, value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setInflowVelocityPointField(int pointZero, int pointMin,
                                               int pointNom) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, pointZero, pointMin, pointNom]() {
        m_machineBackend->setInflowVelocityPointField(pointZero, pointMin,
                                                      pointNom);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setInflowVelocityPointField(int point, int value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, point, value]() {
        m_machineBackend->setInflowVelocityPointField(point, value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setInflowLowLimitVelocity(short value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setInflowLowLimitVelocity(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setDownflowSensorConstantTemporary(short value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() {
        m_machineBackend->setDownflowSensorConstantTemporary(value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setDownflowSensorConstant(short value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setDownflowSensorConstant(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setDownflowAdcPointFactory(int pointZero, int pointMin,
                                              int pointNom, int pointMax) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, pointZero, pointMin, pointNom, pointMax]() {
        m_machineBackend->setDownflowAdcPointFactory(pointZero, pointMin,
                                                     pointNom, pointMax);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setDownflowAdcPointFactory(int point, int value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, point, value]() {
        m_machineBackend->setDownflowAdcPointFactory(point, value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setDownflowVelocityPointFactory(int pointZero, int pointMin,
                                                   int pointNom, int pointMax) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, pointZero, pointMin, pointNom, pointMax]() {
        m_machineBackend->setDownflowVelocityPointFactory(pointZero, pointMin,
                                                          pointNom, pointMax);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setDownflowVelocityPointFactory(int point, int value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, point, value]() {
        m_machineBackend->setDownflowVelocityPointFactory(point, value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setDownflowAdcPointField(int pointZero, int pointMin,
                                            int pointNom, int pointMax) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, pointZero, pointMin, pointNom, pointMax]() {
        m_machineBackend->setDownflowAdcPointField(pointZero, pointMin,
                                                   pointNom, pointMax);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setDownflowAdcPointField(int point, int value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, point, value]() {
        m_machineBackend->setDownflowAdcPointField(point, value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setDownflowVelocityPointField(int pointZero, int pointMin,
                                                 int pointNom, int pointMax) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, pointZero, pointMin, pointNom, pointMax]() {
        m_machineBackend->setDownflowVelocityPointField(pointZero, pointMin,
                                                        pointNom, pointMax);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setDownflowVelocityPointField(int point, int value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, point, value]() {
        m_machineBackend->setDownflowVelocityPointField(point, value);
      },
      Qt::QueuedConnection);
}

void MachineProxy::setDownflowLowLimitVelocity(short value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setDownflowLowLimitVelocity(value); },
      Qt::QueuedConnection);
}

void MachineProxy::setDownflowHighLimitVelocity(short value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->setDownflowHighLimitVelocity(value); },
      Qt::QueuedConnection);
}

void MachineProxy::saveDownflowMeaNominalGrid(const QJsonArray grid, int total,
                                              int velocity, int velocityLowest,
                                              int velocityHighest,
                                              int deviation, int deviationp,
                                              int ducy, int rpm,
                                              int fullField) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, grid, total, velocity, velocityLowest, velocityHighest, deviation,
       deviationp, ducy, rpm, fullField]() {
        m_machineBackend->saveDownflowMeaNominalGrid(
            grid, total, velocity, velocityLowest, velocityHighest, deviation,
            deviationp, ducy, rpm, fullField);
      },
      Qt::QueuedConnection);
}

void MachineProxy::saveDownflowMeaMinimumGrid(const QJsonArray grid, int total,
                                              int velocity, int velocityLowest,
                                              int velocityHighest,
                                              int deviation, int deviationp,
                                              int ducy, int rpm) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, grid, total, velocity, velocityLowest, velocityHighest, deviation,
       deviationp, ducy, rpm]() {
        m_machineBackend->saveDownflowMeaMinimumGrid(
            grid, total, velocity, velocityLowest, velocityHighest, deviation,
            deviationp, ducy, rpm);
      },
      Qt::QueuedConnection);
}

void MachineProxy::saveDownflowMeaMaximumGrid(const QJsonArray grid, int total,
                                              int velocity, int velocityLowest,
                                              int velocityHighest,
                                              int deviation, int deviationp,
                                              int ducy, int rpm) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, grid, total, velocity, velocityLowest, velocityHighest, deviation,
       deviationp, ducy, rpm]() {
        m_machineBackend->saveDownflowMeaMaximumGrid(
            grid, total, velocity, velocityLowest, velocityHighest, deviation,
            deviationp, ducy, rpm);
      },
      Qt::QueuedConnection);
}

void MachineProxy::initAirflowCalibrationStatus(short value) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, value]() { m_machineBackend->initAirflowCalibrationStatus(value); },
      Qt::QueuedConnection);
}

void MachineProxy::saveInflowMeaSecNominalGrid(const QJsonArray grid, int total,
                                               int average, int velocity,
                                               int ducy, int rpm) {
  QMetaObject::invokeMethod(
      m_machineBackend.data(),
      [&, grid, total, average, velocity, ducy, rpm]() {
        m_machineBackend->saveInflowMeaSecNominalGrid(grid, total, average,
                                                      velocity, ducy, rpm);
      },
      Qt::QueuedConnection);
}

void MachineProxy::initFanConfigurationStatus(short value)
{
    QMetaObject::invokeMethod(m_machineBackend.data(), [&, value](){
        m_machineBackend->initFanConfigurationStatus(value);
    },
    Qt::QueuedConnection);
}

void MachineProxy::setAirflowFactoryCalibrationState(int index, bool state)
{
    QMetaObject::invokeMethod(m_machineBackend.data(), [&, index, state](){
        m_machineBackend->setAirflowFactoryCalibrationState(index, state);
    },
    Qt::QueuedConnection);
}

void MachineProxy::setAirflowFieldCalibrationState(int index, bool state)
{
    QMetaObject::invokeMethod(m_machineBackend.data(), [&, index, state](){
        m_machineBackend->setAirflowFieldCalibrationState(index, state);
    },
    Qt::QueuedConnection);
}

void MachineProxy::doStopping() {
  qDebug() << metaObject()->className() << __FUNCTION__ << thread();

  if (m_threadForMachineState.isNull())
    return;

  m_threadForMachineState->quit();
  bool threadQuitWell = m_threadForMachineState->wait();
  qDebug() << "m_threadForMachineState::wait" << threadQuitWell;
  pMachineData->setHasStopped(true);
}
