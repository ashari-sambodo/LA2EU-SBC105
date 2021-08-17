#include "ParticleCounter.h"

ParticleCounter::ParticleCounter(QObject *parent) : ClassManager(parent)
{

}

void ParticleCounter::routineTask(int parameter)
{
    //    qDebug() << metaObject()->className() << __func__;
    Q_UNUSED(parameter);

    if(!pModule) return;

    int fanStateParticleCountActual = pModule->getFanStateBuffer();
    if(m_fanStatePaCo != fanStateParticleCountActual){
        m_fanStatePaCo = fanStateParticleCountActual;

        emit fanStatePaCoChanged(m_fanStatePaCo);
    }

    if(m_fanStatePaCoReq != fanStateParticleCountActual){
        /// send the command to actual sensor
        pModule->setDormantMode(m_fanStatePaCoReq);
    }


    int pm1_0 = 0, pm2_5 = 0, pm10 = 0;
    if (m_fanStatePaCo){
        int resp = pModule->getQAReadSample(&pm1_0, &pm2_5, &pm10);

        //    qDebug() << metaObject()->className() << __func__ << "resp" << resp;

        if(resp == 0){
            if(m_pm1_0 != pm1_0){
                m_pm1_0 = pm1_0;

                emit pm1_0Changed(m_pm1_0);
            }

            if(m_pm2_5 != pm2_5){
                m_pm2_5 = pm2_5;

                emit pm2_5Changed(m_pm2_5);
            }

            if(m_pm10 != pm10){
                m_pm10 = pm10;

                emit pm10Changed(m_pm10);
            }
        }
    }
    else {
        if(m_pm1_0 != pm1_0){
            m_pm1_0 = pm1_0;

            emit pm1_0Changed(m_pm1_0);
        }

        if(m_pm2_5 != pm2_5){
            m_pm2_5 = pm2_5;

            emit pm2_5Changed(m_pm2_5);
        }

        if(m_pm10 != pm10){
            m_pm10 = pm10;

            emit pm10Changed(m_pm10);
        }
    }
}

void ParticleCounter::setSubModule(ParticleCounterZH03B *module)
{
    pModule = module;
}

void ParticleCounter::setFanStatePaCo(short state)
{
    if(m_fanStatePaCoReq == state) return;
    m_fanStatePaCoReq = state;
    //    qDebug() << metaObject()->className() << __func__ << state;
}
