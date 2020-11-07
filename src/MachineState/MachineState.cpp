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
            ////IO EXTENDER
            {
                m_boardIOExtendPca9633.reset(new LEDpca9633);
                m_boardIOExtendPca9633->setI2C(m_i2cPort.data());
                m_boardIOExtendPca9633->init();
                ///Pin 0 - PWM0 connect to LCD Brightness Control
                m_boardIOExtendPca9633->setOutputAsPWM(0);
                ///Pin 1 - PWM1 connect to Mosfet to controll watchdog gate
                //                m_boardIOExtendPca9633->setOutputAsDigital(LEDpca9633_CHANNEL_WDG, EEnums::DIG_STATE_ON);
                m_boardIOExtendPca9633->setOutputPWM(0, 5);

                //                ////MONITORING COMMUNICATION STATUS
                //                connect(m_pModule_IOExtendPca9633.data(), &LEDpca9633::errorComCountChanged,
                //                        this, &Backend::_onModuleComStatus_IOExtenderChanged);
            }

            /// Aanalog Out Board
            {
                m_boardAnalogOut1.reset(new AOmcp4725);
                m_boardAnalogOut1->setI2C(m_i2cPort.data());
                m_boardAnalogOut1->setAddress(0x61);
                m_boardAnalogOut1->init();

                /// catch error status of the board
                QObject::connect(m_boardAnalogOut1.data(), &AOmcp4725::errorComToleranceReached,
                                 this, [&](int error){
                    qDebug() << "m_boardAnalogOut1 Error changed" << error << thread();
                });
            }//

            /// Aanalog Out Board
            {
                m_boardAnalogOut2.reset(new AOmcp4725);
                m_boardAnalogOut2->setI2C(m_i2cPort.data());
                m_boardAnalogOut2->setAddress(0x60);
                m_boardAnalogOut2->init();

                /// catch error status of the board
                QObject::connect(m_boardAnalogOut2.data(), &AOmcp4725::errorComToleranceReached,
                                 this, [&](int error){
                    qDebug() << "m_boardAnalogOut2 Error changed" << error << thread();
                });
            }//

            /// DIGITAL_INPUT
            {
                m_boardDigitalInput1.reset(new DIOpca9674);
                m_boardDigitalInput1->setI2C(m_i2cPort.data());
                m_boardDigitalInput1->init();

                /// catch error status of the board
                QObject::connect(m_boardDigitalInput1.data(), &DIOpca9674::errorComToleranceReached,
                                 this, [&](int error){
                    qDebug() << "m_boardDigitalInput1 Error changed" << error << thread();
                });
            }//

            ////DIGITAL_OUTPUT/PWM
            {
                m_boardPwm1.reset(new PWMpca9685);
                m_boardPwm1->setI2C(m_i2cPort.data());
                m_boardPwm1->preInitCountChannelsToPool(8);
                m_boardPwm1->preInitFrequency(PCA9685_PWM_VAL_FREQ_100HZ);
                m_boardPwm1->init();

                ////MONITORING COMMUNICATION STATUS
                connect(m_boardPwm1.data(), &PWMpca9685::errorComToleranceReached,
                        this, [&](int error){
                    qDebug() << "m_boardPwm1 Error changed" << error << thread();
                });
            }

            /// Analog Input
            {
                m_boardAnalogInput1.reset(new AIManage);
                m_boardAnalogInput1->setupAIModule();
                m_boardAnalogInput1->setI2C(m_i2cPort.data());
                m_boardAnalogInput1->setAddress(0x69);
                m_boardAnalogInput1->init();

                //DEFINE_CHANNEL_FOR_TEMPERATURE
                m_boardAnalogInput1->setChannelDoPoll(0, true);
                m_boardAnalogInput1->setChannelDoAverage(0, true);
                m_boardAnalogInput1->setChannelSamples(0, 30);

                //DEFINE_CHANNEL_FOR_AIRFLOW
                m_boardAnalogInput1->setChannelDoPoll(1, true);
                m_boardAnalogInput1->setChannelDoAverage(1, true);
                m_boardAnalogInput1->setChannelSamples(1, 100);

                ////MONITORING COMMUNICATION STATUS
                connect(m_boardAnalogInput1.data(), &AIManage::errorComToleranceReached,
                        this, [&](int error){
                    qDebug() << "m_boardAnalogInput1 Error changed" << error << thread();
                });
            }

            /// Analog Input 2
            {
                m_boardAnalogInput2.reset(new AIManage);
                m_boardAnalogInput2->setupAIModule();
                m_boardAnalogInput2->setI2C(m_i2cPort.data());
                m_boardAnalogInput2->setAddress(0x6f);
                m_boardAnalogInput2->init();

                //DEFINE_CHANNEL_FOR_AIRFLOW
                m_boardAnalogInput2->setChannelDoPoll(0, true);
                m_boardAnalogInput2->setChannelDoAverage(0, true);
                m_boardAnalogInput2->setChannelSamples(0, 100);

                ////MONITORING COMMUNICATION STATUS
                connect(m_boardAnalogInput2.data(), &AIManage::errorComToleranceReached,
                        this, [&](int error){
                    qDebug() << "m_boardAnalogInput2 Error changed" << error << thread();
                });
            }
        }//

        /// Required object to manage communication
        /// communication will use daisy chain mechanism
        /// in one port i2c will connect to many board
        /// will use short poling mechanism to synchronization the states between machine logic and actual board
        m_boardIO.reset(new BoardIO);
        m_boardIO->setI2C(m_i2cPort.data());
        /// add any board for short polling
        {
            m_boardIO->addSlave(m_boardDigitalInput1.data());
            m_boardIO->addSlave(m_boardAnalogOut1.data());
            m_boardIO->addSlave(m_boardAnalogOut2.data());
            m_boardIO->addSlave(m_boardPwm1.data());
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

        connect(m_blowerExhaust.data(), &DeviceAnalogCom::stateChanged,
                pData, [&](int newVal){
            pData->setBlowerExhaustDutyCycle(newVal);
        });
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
        m_boardRegalECM->setDirection(BlowerRegalECM::BLOWER_REGAL_ECM_DIRECTION_CLW);
        //        m_boardRegalECM->setDirection(BlowerRegalECM::BLOWER_REGAL_ECM_DIRECTION_CCW);

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
                         pData, [&](int dutyCycle){
            qDebug() << "m_blowerDownflow::dutyCycleChanged" << thread();
            qDebug() << "m_blowerDownflow::dutyCycleChanged" << dutyCycle;
            pData->setBlowerDownflowState(dutyCycle);
            pData->setBlowerDownflowDutyCycle(dutyCycle);
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

    /// SASH
    {
        m_sashWindow.reset(new SashWindow(m_boardDigitalInput1.data()));
        m_sashWindow->setSubModule(m_boardDigitalInput1.data());

        connect(m_sashWindow.data(), &SashWindow::sashStateChanged,
                pData, [&](int newVal, int /*oldVal*/){
            pData->setSashWindowState(newVal);
        });
        //        connect(m_pSashWindow.data(), &SashWindow::mSwitchStateChanged,
        //                this, [&](int dutyCycle){
        //            qDebug() << "m_blowerDownflow::dutyCycleChanged" << thread();
        //            qDebug() << "m_blowerDownflow::dutyCycleChanged" << dutyCycle;
        //            pData->setBlowerDownflowState(dutyCycle);
        //        });
    }

    /// Sash Window Motorize
    {
        m_sasWindowMotorize.reset(new MotorizeOnRelay);
        m_sasWindowMotorize->setSubModule(m_boardPwm1.data());
        m_sasWindowMotorize->setChannelUp(4);
        m_sasWindowMotorize->setChannelDown(3);

        connect(m_sasWindowMotorize.data(), &MotorizeOnRelay::stateChanged,
                pData, [&](int newVal){
            pData->setSashWindowMotorizeState(newVal);
        });

        //        connect(m_sasWindowMotorize.data(), &MotorizeOnRelayManager::interlockUpChanged,
        //                this, &Backend::_onMotorizeSashInterlockUpChanged);
        //        connect(m_sasWindowMotorize.data(), &MotorizeOnRelayManager::interlockDownChanged,
        //                this, &Backend::_onMotorizeSashInterlockDownChanged);
    }

    /// Light Intensity
    {
        m_lightIntensity.reset(new DeviceAnalogCom);
        m_lightIntensity->setSubBoard(m_boardAnalogOut2.data());

        connect(m_lightIntensity.data(), &DeviceAnalogCom::stateChanged,
                pData, [&](int newVal){
            pData->setLightIntensity(newVal);
        });
    }

    /// Light
    {
        m_light.reset(new DigitalOut);
        m_light->setSubModule(m_boardPwm1.data());
        m_light->setChannelIO(0);

        connect(m_light.data(), &DigitalOut::stateChanged,
                pData, [&](int newVal){
            pData->setLightState(newVal);
        });

        //        connect(m_light.data(), &DigitalOut::interlockChanged,
        //                this, [&](int newVal){
        //        });
    }

    /// Socket
    {
        m_socket.reset(new DigitalOut);
        m_socket->setSubModule(m_boardPwm1.data());
        m_socket->setChannelIO(5);

        connect(m_socket.data(), &DigitalOut::stateChanged,
                pData, [&](int newVal){
            pData->setSocketState(newVal);
        });

        //        connect(m_light.data(), &DigitalOut::interlockChanged,
        //                this, [&](int newVal){
        //        });
    }

    /// Gas
    {
        m_gas.reset(new DigitalOut);
        m_gas->setSubModule(m_boardPwm1.data());
        m_gas->setChannelIO(2);

        connect(m_gas.data(), &DigitalOut::stateChanged,
                pData, [&](int newVal){
            pData->setGasState(newVal);
        });

        //        connect(m_light.data(), &DigitalOut::interlockChanged,
        //                this, [&](int newVal){
        //        });
    }

    /// UV
    {
        m_uv.reset(new DigitalOut);
        m_uv->setSubModule(m_boardPwm1.data());
        m_uv->setChannelIO(1);

        connect(m_uv.data(), &DigitalOut::stateChanged,
                pData, [&](int newVal){
            pData->setUvState(newVal);
        });

        //        connect(m_light.data(), &DigitalOut::interlockChanged,
        //                this, [&](int newVal){
        //        });
    }

    /// TEMPERATURE
    {
        m_temperature.reset(new Temperature);
        m_temperature->setSubModule(m_boardAnalogInput1.data());
        m_temperature->setChannelIO(0);

        connect(m_temperature.data(), &Temperature::celciusChanged,
                pData, [&](int newVal){
            QString valueStr = QString::asprintf("%d°C", newVal);
            pData->setTemperatureValueStr(valueStr);
        });
        //        connect(m_temperature.data(), &Temperature::adcChanged,
        //                pData, [&](int newVal){
        //            pData->setUvState(newVal);
        //        });
    }

    /// AIRFLOW_INFLOW
    {
        ////CREATE INFLOW OBJECT
        m_airflowInflow.reset(new AirflowVelocity());
        m_airflowInflow->setAIN(m_boardAnalogInput1.data());
        m_airflowInflow->setChannel(1);

        /// CONNECION
        connect(m_airflowInflow.data(), &AirflowVelocity::adcConpensationChanged,
                pData, [&](int newVal){
            pData->setInflowAdc(newVal);
        });
        connect(m_airflowInflow.data(), &AirflowVelocity::velocityChanged,
                pData, [&](double newVal){
            QString valueStr = QString::asprintf("%.2f°C", newVal);
            pData->setInflowVelocityStr(valueStr);
        });
    }

    /// AIRFLOW_DOWNFLOW
    {
        ////CREATE INFLOW OBJECT
        m_airflowDownflow.reset(new AirflowVelocity());
        m_airflowDownflow->setAIN(m_boardAnalogInput2.data());
        m_airflowDownflow->setChannel(0);

        /// CONNECION
        connect(m_airflowDownflow.data(), &AirflowVelocity::adcConpensationChanged,
                pData, [&](int newVal){
            pData->setDownflowAdc(newVal);
        });
        connect(m_airflowDownflow.data(), &AirflowVelocity::velocityChanged,
                pData, [&](double newVal){
            QString valueStr = QString::asprintf("%.2f°C", newVal);
            pData->setDownflowVelocityStr(valueStr);
        });
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
    m_sashWindow->routineTask();
    m_temperature->routineTask();
    m_airflowInflow->routineTask();
    m_airflowDownflow->routineTask();

    /// PROCESSING
    /// put any processing/machine state condition on here
    //    pData->setCount(pData->getCount() + 1);
    if (pData->getBlowerDownflowState() == MachineEnums::FAN_STATE_ON) {
        if (m_airflowInflow->velocity() <= pData->getInflowLowLimitVelocity()) {
            if (!pData->getAlarmInflowLow()) {
                pData->setAlarmInflowLow(true);
            }
        }

        if (m_airflowDownflow->velocity() <= pData->getDownflowLowLimitVelocity()) {
            if (!pData->getAlarmDownflowLow()) {
                pData->setAlarmDownfLow(true);
            }
        }
        else if (m_airflowDownflow->velocity() >= pData->getDownflowHighLimitVelocity()) {
            if (!pData->getAlarmDownflowHigh()) {
                pData->setAlarmDownfHigh(true);
            }
        }
    }
    else {
        if (pData->getAlarmInflowLow()) {
            pData->setAlarmInflowLow(false);
        }
        if (pData->getAlarmDownflowHigh()) {
            pData->setAlarmDownfHigh(false);
        }
        if (pData->getAlarmDownflowHigh()) {
            pData->setAlarmDownfHigh(false);
        }
    }

    /// ACTUATOR
    /// put any actuator routine task on here
    m_sasWindowMotorize->routineTask();
    m_blowerExhaust->routineTask();
    m_light->routineTask();
    m_socket->routineTask();
    m_gas->routineTask();
    m_uv->routineTask();

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

    m_blowerExhaust->setState(state ? 51 : 0);
    m_blowerExhaust->routineTask();

    _setBlowerDowndlowDutyCycle(state ? 24 : 0);
}

void MachineState::setBlowerDownflowDutyCycle(short state)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << state;

    _setBlowerDowndlowDutyCycle(state);
}

void MachineState::setBlowerExhaustDutyCycle(short state)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << state;

    m_blowerExhaust->setState(state);
}

void MachineState::setLightIntensity(short lightIntensity)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << lightIntensity;

    m_lightIntensity->setState(lightIntensity);
}

void MachineState::setLightState(short lightState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << lightState;

    m_light->setState(lightState);
}

void MachineState::setSocketState(short socketState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << socketState;

    m_socket->setState(socketState);
}

void MachineState::setGasState(short gasState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << gasState;

    m_gas->setState(gasState);
}

void MachineState::setUvState(short uvState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << uvState;

    m_uv->setState(uvState);
}

void MachineState::setSashMotorizeState(short state)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << state;

    m_sasWindowMotorize->setState(state);
    m_sasWindowMotorize->routineTask();
}

void MachineState::_setBlowerDowndlowDutyCycle(short dutyCycle)
{
    /// Then turned on downflow blower
    /// append pending task to target object and target thread
    QMetaObject::invokeMethod(m_blowerDownflow.data(),[&, dutyCycle]{
        m_blowerDownflow->setDutyCycle(dutyCycle);
    },
    Qt::QueuedConnection);
}

void MachineState::setInflowAdcPointFactory(short point, int adc)
{
    m_airflowInflow->setAdcPoint(point, adc);
    pData->setInflowAdcPointFactory(point, adc);
}

void MachineState::setInflowAdcPointField(short point, int adc)
{

}

void MachineState::setInflowVelocityPointFactory(short point, float value)
{
    m_airflowInflow->setVelocityPoint(point, value);
    pData->setInflowVelocityPointFactory(point, value);
}

void MachineState::setInflowVelocityPointField(short point, float value)
{

}

void MachineState::setInflowConstant(int ifaConstant)
{
    m_airflowInflow->setConstant(ifaConstant);
    pData->setDownflowConstant(ifaConstant);
}

void MachineState::setInflowTemperatureFactory(double ifaTemperatureFactory)
{

}

void MachineState::setInflowTemperatureADCFactory(int ifaTemperatureADCFactory)
{

}

void MachineState::setInflowTemperatureField(double ifaTemperatureField)
{

}

void MachineState::setInflowTemperatureADCField(int ifaTemperatureADCField)
{

}

void MachineState::setInflowLowLimitVelocity(double ifaLowLimitVelocity)
{
    pData->setInflowLowLimitVelocity(ifaLowLimitVelocity);
}

void MachineState::setDownflowAdcPointFactory(short point, int adc)
{
    m_airflowDownflow->setAdcPoint(point, adc);
    pData->setDownflowAdcPointFactory(point, adc);
}

void MachineState::setDownflowAdcPointField(short point, int adc)
{

}

void MachineState::setDownflowVelocityPointFactory(short point, float value)
{
    m_airflowDownflow->setVelocityPoint(point, value);
    pData->setDownflowVelocityPointFactory(point, value);
}

void MachineState::setDownflowVelocityPointField(short point, float value)
{

}

void MachineState::setDownflowConstant(int dfaConstant)
{

}

void MachineState::setDownflowTemperatureFactory(double dfaTemperatureFactory)
{

}

void MachineState::setDownflowTemperatureField(double dfaTemperatureField)
{

}

void MachineState::setDownflowTemperatureADCField(int dfaTemperatureADCField)
{

}

void MachineState::setDownflowTemperatureADCFactory(int dfaTemperatureADCFactory)
{

}

void MachineState::setDownflowLowLimitVelocity(double dfaLowLimitVelocity)
{
    pData->setDownflowLowLimitVelocity(dfaLowLimitVelocity);
}

void MachineState::setDownflowHigLimitVelocity(double dfaHigLimitVelocity)
{
    pData->setDownflowHigLimitVelocity(dfaHigLimitVelocity);
}

void MachineState::setAirflowCalibration(short value)
{
    m_airflowDownflow->initScope();
    m_airflowInflow->initScope();
}
