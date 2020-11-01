#include <QtDebug>
#include <QSerialPortInfo>

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
        if (m_blowerSerialPort->isOpen()) {
            /// initializing the blower object
            m_blowerRegalECM.reset(new BlowerRegalECM);
            /// we expect the first state of the the blower from not running
            /// now, we assume the response from the blower is always OK,
            /// so we dont care the return value of following API
            m_blowerRegalECM->stop();
            /// setup blower ecm by torque demand
            /// in torque mode, we just need to define the direction of rotation
            m_blowerRegalECM->setDirection(BlowerRegalECM::BLOWER_REGAL_ECM_DIRECTION_CLW);

            /// create object for state keeper
            /// ensure actuator state is what machine state requested
            m_blowerRbmDsi.reset(new BlowerRbmDsi);

            /// create independent thread
            /// looping inside this thread will run parallel* beside machineState loop
            m_threadForBlowerRbmDsi.reset(new QThread);

            /// create timer for triggering the loop (routine task) and execute any pending request
            /// routine task and any pending task will executed by FIFO mechanism
            m_timerEventForBlowerRbmDsi.reset(new QTimer);
            m_timerEventForBlowerRbmDsi->setInterval(TEI_FOR_BLOWER_RBMDSI);

            /// Start timer event when thread was started
            QObject::connect(m_threadForBlowerRbmDsi.data(), &QThread::started,
                             m_timerEventForBlowerRbmDsi.data(), QOverload<>::of(&QTimer::start));

            /// Stop timer event when thread was finished
            QObject::connect(m_threadForBlowerRbmDsi.data(), &QThread::finished,
                             m_timerEventForBlowerRbmDsi.data(), QOverload<>::of(&QTimer::stop));

            /// Enable triggerOnStarted, calling the worker of BlowerRbmDsi when thread has started
            /// This is use lambda function, this symbol [&] for pass m_blowerRbmDsi object to can captured by lambda
            /// m_blowerRbmDsi.data(), [&](){m_blowerRbmDsi->worker();});
            QObject::connect(m_threadForBlowerRbmDsi.data(), &QThread::started,
                             m_blowerRbmDsi.data(), [&](){m_blowerRbmDsi->worker();});
        }
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
