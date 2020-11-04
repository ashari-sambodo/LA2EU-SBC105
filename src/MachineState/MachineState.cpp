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

    /// BoardIO
    {
        /// Board IO use i2c port for communication
        /// setup i2c port
        m_i2cPort.reset(new I2CPort);
        /// define which i2c port number want to use
        /// ESCO OS Y313 has allocated i2cport number 4 for board communication
        m_i2cPort->setPortNumber(4);
        m_i2cPort->openPort();

        /// Initializing every required board
        {
            /// Aanalog Out Board
            m_boardAnalogOut1.reset(new AOmcp4725);
            m_boardAnalogOut1->setI2C(m_i2cPort.data());
            m_boardAnalogOut1->setAddress(0x61);
            m_boardAnalogOut1->init();

            /// catch error status of the board
            QObject::connect(m_boardAnalogOut1.data(), &AOmcp4725::errorComToleranceReached,
                             this, [&](int error){
                qDebug() << "Error changed" << error << thread();
            });
        }

        /// Required object to manage communication
        /// communication will use daisy chain mechanism
        /// in one port i2c will connect to many board
        /// will use short poling mechanism to synchronization the states between machine logic and actual board
        m_boardIO.reset(new BoardIO);
        m_boardIO->setI2C(m_i2cPort.data());
        /// add any board for short polling
        {
            m_boardIO->addSlave(m_boardAnalogOut1.data());
        }
        /// setup thread and timer interupt for board IO
        {
            /// create timer for triggering the loop (routine task) and execute any pending request
            /// routine task and any pending task will executed by FIFO mechanism
            m_timerInterruptForBoardIO.reset(new QTimer);
            m_timerInterruptForBoardIO->setInterval(TEI_FOR_BOARD_IO);

            /// create independent thread
            /// looping inside this thread will run parallel* beside machineState loop
            m_threadForBoardIO.reset(new QThread);

            /// Start timer event when thread was started
            QObject::connect(m_threadForBoardIO.data(), &QThread::started,
                             m_timerInterruptForBoardIO.data(), [&](){
                //                qDebug() << "m_timerInterruptForBoardIO::started" << thread();
                m_timerInterruptForBoardIO->start();
            });

            /// Stop timer event when thread was finished
            QObject::connect(m_threadForBoardIO.data(), &QThread::finished,
                             m_timerInterruptForBoardIO.data(), [&](){
                //                qDebug() << "m_timerInterruptForBoardIO::finished" << thread();
                m_timerInterruptForBoardIO->stop();
            });

            /// Enable triggerOnStarted, calling the worker of BlowerRbmDsi when thread has started
            /// This is use lambda function, this symbol [&] for pass m_boardIO object to can captured by lambda
            QObject::connect(m_threadForBoardIO.data(), &QThread::started,
                             m_boardIO.data(), [&](){
                //                qDebug() << "m_boardIO::started" << thread();
                m_boardIO->worker();
            });

            /// Call routine task blower (syncronazation state)
            /// This method calling by timerEvent
            QObject::connect(m_timerInterruptForBoardIO.data(), &QTimer::timeout,
                             m_boardIO.data(), [&](){
                //                qDebug() << "m_boardIO::timeout" << thread();
                m_boardIO->worker();
            });

            /// Run loop thread when Machine State goes to looping / routine task
            QObject::connect(this, &MachineState::loopStarted,
                             m_threadForBoardIO.data(), [&](){
                //                qDebug() << "m_threadForBoardIO::loopStarted" << thread();
                m_threadForBoardIO->start();
            });

            /// Do move blower routine task / looping to independent thread
            m_boardIO->moveToThread(m_threadForBoardIO.data());
            /// Do move timer event for blower routine task to independent thread
            /// make the timer has prescission because independent from this Macine State looping
            m_timerInterruptForBoardIO->moveToThread(m_threadForBoardIO.data());
        }
    }

    /// Blower Exhaust
    {
        m_blowerExhaust.reset(new DeviceAnalogCom);
        m_blowerExhaust->setSubBoard(m_boardAnalogOut1.data());
    }

    /// Blower Downflow
    {
        /// find and initializing serial port for blower
        m_serialPort1.reset(new QSerialPort());
        foreach(const QSerialPortInfo &info, QSerialPortInfo::availablePorts()){
            if((info.vendorIdentifier() == BLOWER_USB_SERIAL_VID) &&
                    (info.productIdentifier() == BLOWER_USB_SERIAL_PID)){

                m_serialPort1->setPort(info);

                if(m_serialPort1->open(QIODevice::ReadWrite)){
                    m_serialPort1->setBaudRate(QSerialPort::BaudRate::Baud4800);
                    m_serialPort1->setDataBits(QSerialPort::DataBits::Data8);
                    m_serialPort1->setParity(QSerialPort::Parity::NoParity);
                    m_serialPort1->setStopBits(QSerialPort::StopBits::OneStop);
                }

                break;
            }
        }

        /// RBM COM Board is OK and ready to send blower paramaters
        if (!m_serialPort1->isOpen()) {
            qWarning() << __FUNCTION__ << thread() << "serial port for blower cannot be opened";
        }
        /// initializing the blower object
        m_boardRegalECM.reset(new BlowerRegalECM);
        /// set the serial port
        m_boardRegalECM->setSerialComm(m_serialPort1.data());
        /// we expect the first state of the the blower from not running
        /// now, we assume the response from the blower is always OK,
        //        /// so we dont care the return value of following API
        m_boardRegalECM->stop();
        /// setup blower ecm by torque demand
        /// in torque mode, we just need to define the direction of rotation
        //        m_blowerRegalECM->setDirection(BlowerRegalECM::BLOWER_REGAL_ECM_DIRECTION_CLW);
        m_boardRegalECM->setDirection(BlowerRegalECM::BLOWER_REGAL_ECM_DIRECTION_CCW);

        /// create object for state keeper
        /// ensure actuator state is what machine state requested
        m_blowerDownflow.reset(new BlowerRbmDsi);

        /// pass the virtual object sub module board
        m_blowerDownflow->setSubModule(m_boardRegalECM.data());

        /// create timer for triggering the loop (routine task) and execute any pending request
        /// routine task and any pending task will executed by FIFO mechanism
        m_timerInterruptForBlowerRbmDsi.reset(new QTimer);
        m_timerInterruptForBlowerRbmDsi->setInterval(TEI_FOR_BLOWER_RBMDSI);

        /// create independent thread
        /// looping inside this thread will run parallel* beside machineState loop
        m_threadForBlowerRbmDsi.reset(new QThread);

        /// Start timer event when thread was started
        QObject::connect(m_threadForBlowerRbmDsi.data(), &QThread::started,
                         m_timerInterruptForBlowerRbmDsi.data(), [&](){
            //            qDebug() << "m_timerEventForBlowerRbmDsi::started" << thread();
            m_timerInterruptForBlowerRbmDsi->start();
        });

        /// Stop timer event when thread was finished
        QObject::connect(m_threadForBlowerRbmDsi.data(), &QThread::finished,
                         m_timerInterruptForBlowerRbmDsi.data(), [&](){
            //            qDebug() << "m_timerEventForBlowerRbmDsi::finished" << thread();
            m_timerInterruptForBlowerRbmDsi->stop();
        });

        /// Enable triggerOnStarted, calling the worker of BlowerRbmDsi when thread has started
        /// This is use lambda function, this symbol [&] for pass m_blowerRbmDsi object to can captured by lambda
        /// m_blowerRbmDsi.data(), [&](){m_blowerRbmDsi->worker();});
        QObject::connect(m_threadForBlowerRbmDsi.data(), &QThread::started,
                         m_blowerDownflow.data(), [&](){
            m_blowerDownflow->routineTask();
        });

        /// Call routine task blower (syncronazation state)
        /// This method calling by timerEvent
        QObject::connect(m_timerInterruptForBlowerRbmDsi.data(), &QTimer::timeout,
                         m_blowerDownflow.data(), [&](){
            //            qDebug() << "m_blowerRbmDsi::timeout" << thread();
            m_blowerDownflow->routineTask();
        });

        /// Run blower loop thread when Machine State goes to looping / routine task
        QObject::connect(this, &MachineState::loopStarted,
                         m_threadForBlowerRbmDsi.data(), [&](){
            //            qDebug() << "m_threadForBlowerRbmDsi::loopStarted" << thread();
            m_threadForBlowerRbmDsi->start();
        });

        QObject::connect(m_blowerDownflow.data(), &BlowerRbmDsi::dutyCycleChanged,
                         this, [&](int dutyCycle){
            qDebug() << "m_blowerDownflow::dutyCycleChanged" << thread();
            qDebug() << "m_blowerDownflow::dutyCycleChanged" << dutyCycle;
            pData->setBlowerDownflowState(dutyCycle);
        });

        /// Do move blower routine task / looping to independent thread
        m_blowerDownflow->moveToThread(m_threadForBlowerRbmDsi.data());
        /// Do move timer event for blower routine task to independent thread
        /// make the timer has prescission because independent from this Macine State looping
        m_timerInterruptForBlowerRbmDsi->moveToThread(m_threadForBlowerRbmDsi.data());
        /// Also move all necesarry object to independent blower thread
        m_serialPort1->moveToThread(m_threadForBlowerRbmDsi.data());
        m_boardRegalECM->moveToThread(m_threadForBlowerRbmDsi.data());
    }

    /// Chane state to loop, routine task
    pData->setMachineState(MachineEnums::MACHINE_STATE_LOOP);
    /// GIVE A SIGNAL
    emit loopStarted();

    //    pData->setAlarmDownfLow(true);
}

void MachineState::loop()
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    /// Just execute for the first cycle loop
    if (m_loopStarterTaskExecute) {
        m_loopStarterTaskExecute  = false;
        qInfo() << metaObject()->className() << __FUNCTION__ << "loopStarterTaskExecute";
    }

    /// READ_SENSOR
    /// put any read sensor routine task on here

    /// PROCESSING
    /// put any processing/machine state condition on here
    pData->setCount(pData->getCount() + 1);

    /// ACTUATOR
    /// put any actuator routine task on here
    m_blowerExhaust->routineTask();

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

    m_threadForBoardIO->quit();
    m_threadForBoardIO->wait();

    m_threadForBlowerRbmDsi->quit();
    m_threadForBlowerRbmDsi->wait();

    emit hasStopped();
}

/////////////////////////////////////////////////// API Group for General Object Operation

void MachineState::stop()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    m_stop = true;
}

////////////////////////////////////////////////// API Group for specific cabinet

void MachineState::setBlowerState(short state)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << state;

    _setBlowerDutyCycle(state ? 30 : 0);
}

void MachineState::_setBlowerDutyCycle(short dutyCycle)
{
    /// Turn on blower exhaust first
    m_blowerExhaust->setState(dutyCycle);
    m_blowerExhaust->routineTask();

    /// Then turned on downflow blower
    /// append pending task to target object and target thread
    QMetaObject::invokeMethod(m_blowerDownflow.data(),[&, dutyCycle]{
        m_blowerDownflow->setDutyCycle(dutyCycle);
    },
    Qt::QueuedConnection);
}
