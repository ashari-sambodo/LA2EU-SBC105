#include <QtDebug>
#include <QSerialPortInfo>
#include <QTimer>

#include "MachineState.h"
#include "MachineData.h"
#include "MachineEnums.h"
#include "MachineDefaultParameters.h"

MachineState::MachineState(QObject *parent) : QObject(parent)
{
    m_stop = false;
    m_loopStarterTaskExecute = true;
    m_stoppingExecuted = false;
}

MachineState::~MachineState()
{
    qDebug() << metaObject()->className() << __FUNCTION__<< thread();
}

void MachineState::worker()
{
    int state = pData->getMachineState();
    switch (state) {
    case MachineEnums::MACHINE_STATE_SETUP:
        setup();
        break;
    case MachineEnums::MACHINE_STATE_LOOP:
        loop();
        break;
    case MachineEnums::MACHINE_STATE_STOP:
        deallocate();
        break;
    default:
        break;
    }
}

void MachineState::setMachineData(MachineData *data)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << data << thread();
    pData = data;
}

void MachineState::setup()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    /// initial
    pData->setHasStopped(false);

    /// Permanent settings storage
    m_settings.reset(new QSettings);

    /// Blower
    {
        /// find and initializing serial port for blower
        m_blowerSerialPort.reset(new QSerialPort());
        foreach(const QSerialPortInfo &info, QSerialPortInfo::availablePorts()){
            if((info.vendorIdentifier() == BLOWER_USB_SERIAL_VID) &&
                    (info.productIdentifier() == BLOWER_USB_SERIAL_PID)){

                m_blowerSerialPort->setPort(info);

                if(m_blowerSerialPort->open(QIODevice::ReadWrite)){
                    m_blowerSerialPort->setBaudRate(QSerialPort::BaudRate::Baud4800);
                    m_blowerSerialPort->setDataBits(QSerialPort::DataBits::Data8);
                    m_blowerSerialPort->setParity(QSerialPort::Parity::NoParity);
                    m_blowerSerialPort->setStopBits(QSerialPort::StopBits::OneStop);
                }

                break;
            }
        }

        /// RBM COM Board is OK and ready to send blower paramaters
        //        if (m_blowerSerialPort->isOpen()) {
        /// initializing the blower object
        m_blowerRegalECM.reset(new BlowerRegalECM);
        /// set the serial port
        m_blowerRegalECM->setSerialComm(m_blowerSerialPort.data());
        /// we expect the first state of the the blower from not running
        /// now, we assume the response from the blower is always OK,
        /// so we dont care the return value of following API
        m_blowerRegalECM->stop();
        /// setup blower ecm by torque demand
        /// in torque mode, we just need to define the direction of rotation
        m_blowerRegalECM->setDirection(BlowerRegalECM::BLOWER_REGAL_ECM_DIRECTION_CLW);

        /// create object for state keeper
        /// ensure actuator state is what machine state requested
        m_blowerRbmDsiKeeper.reset(new BlowerRbmDsi);

        /// create timer for triggering the loop (routine task) and execute any pending request
        /// routine task and any pending task will executed by FIFO mechanism
        m_timerEventForBlowerRbmDsi.reset(new QTimer);
        m_timerEventForBlowerRbmDsi->setInterval(TEI_FOR_BLOWER_RBMDSI);

        /// create independent thread
        /// looping inside this thread will run parallel* beside machineState loop
        m_threadForBlowerRbmDsi.reset(new QThread);

        /// Start timer event when thread was started
        QObject::connect(m_threadForBlowerRbmDsi.data(), &QThread::started,
                         m_timerEventForBlowerRbmDsi.data(), [&](){
            m_timerEventForBlowerRbmDsi->start();
            qDebug() << metaObject()->className() << __FUNCTION__ << thread();
        });

        /// Stop timer event when thread was finished
        QObject::connect(m_threadForBlowerRbmDsi.data(), &QThread::finished,
                         m_timerEventForBlowerRbmDsi.data(), [&](){
            m_timerEventForBlowerRbmDsi->stop();
            qDebug() << metaObject()->className() << __FUNCTION__ << thread();
        });

        /// Enable triggerOnStarted, calling the worker of BlowerRbmDsi when thread has started
        /// This is use lambda function, this symbol [&] for pass m_blowerRbmDsi object to can captured by lambda
        /// m_blowerRbmDsi.data(), [&](){m_blowerRbmDsi->worker();});
        QObject::connect(m_threadForBlowerRbmDsi.data(), &QThread::started,
                         m_blowerRbmDsiKeeper.data(), [&](){
            m_blowerRbmDsiKeeper->worker();
        });

        /// Call routine task blower (syncronazation state)
        /// This method calling by timerEvent
        QObject::connect(m_timerEventForBlowerRbmDsi.data(), &QTimer::timeout,
                         m_blowerRbmDsiKeeper.data(), [&](){
            m_blowerRbmDsiKeeper->worker();
        });

        /// Run blower loop thread when Machine State goes to looping / routine task
        QObject::connect(this, &MachineState::loopStarted,
                         m_threadForBlowerRbmDsi.data(), [&](){
            m_threadForBlowerRbmDsi->start();
        });

        /// Do move blower routine task / looping to independent thread
        m_blowerRbmDsiKeeper->moveToThread(m_threadForBlowerRbmDsi.data());
        /// Do move timer event for blower routine task to independent thread
        /// make the timer has prescission because independent from this Macine State looping
        m_timerEventForBlowerRbmDsi->moveToThread(m_threadForBlowerRbmDsi.data());
        /// Also move all necesarry object to independent blower thread
        m_blowerSerialPort->moveToThread(m_threadForBlowerRbmDsi.data());
        m_blowerRegalECM->moveToThread(m_threadForBlowerRbmDsi.data());
        //        }
        //        else {
        //            qWarning() << __FUNCTION__ << thread() << "serial port for blower cannot be opened";
        //        }
    }

    /// Chane state to loop, routine task
    pData->setMachineState(MachineEnums::MACHINE_STATE_LOOP);
    /// GIVE A SIGNAL
    emit loopStarted();
}

void MachineState::loop()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    /// Just execute for the first cycle loop
    if (m_loopStarterTaskExecute) {
        m_loopStarterTaskExecute  = false;
        qDebug() << metaObject()->className() << __FUNCTION__ << "loopStarterTaskExecute";
    }

    /// READ_SENSOR
    /// put any read sensor routine task on here

    /// PROCESSING
    /// put any processing/machine state condition on here
    pData->setCount(pData->getCount() + 1);

    /// ACTUATOR
    /// put any actuator routine task on here

    if(m_stop){
        pData->setMachineState(MachineEnums::MACHINE_STATE_STOP);
    }
}

void MachineState::deallocate()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    /// Guard to ensure this function only executed for one time
    /// if neede to implement
    if (m_stoppingExecuted) return;
    m_stoppingExecuted = true;

    emit hasStopped();
}

/////////////////////////////////////////////////////////////////////////////////////////

void MachineState::stop()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    m_stop = true;
}
