#include "HeaderAppAdapter.h"

static HeaderAppAdapter* s_instance = nullptr;

QObject *HeaderAppAdapter::singletonProvider(QQmlEngine *qmlEngine, QJSEngine *)
{
    if(!s_instance) {
        qDebug() << "HeaderAppProxy::singletonProvider" << s_instance;
        s_instance = new HeaderAppAdapter(qmlEngine);
    }
    return s_instance;
}

void HeaderAppAdapter::singletonDelete()
{
    qDebug() << __FUNCTION__;
    if (s_instance) {
        delete s_instance;
    }
}

HeaderAppAdapter::HeaderAppAdapter(QObject *parent) : QObject(parent)
{

}

QString HeaderAppAdapter::getModelName() const
{
    return m_modelName;
}

bool HeaderAppAdapter::getAlarm() const
{
    return m_alert;
}

QString HeaderAppAdapter::getSourceLogo() const
{
    return m_sourceLogo;
}

short HeaderAppAdapter::getTimePeriod() const
{
    return m_timePeriod;
}

void HeaderAppAdapter::setModelName(QString modelName)
{
    if (m_modelName == modelName)
        return;

    m_modelName = modelName;
    emit modelNameChanged(m_modelName);
}

void HeaderAppAdapter::setAlarm(bool alert)
{
    if (m_alert == alert)
        return;

    m_alert = alert;
    emit alarmChanged(m_alert);
}

void HeaderAppAdapter::setSourceLogo(QString sourceLogo)
{
    if (m_sourceLogo == sourceLogo)
        return;

    m_sourceLogo = sourceLogo;
    emit sourceLogoChanged(m_sourceLogo);
}

void HeaderAppAdapter::setTimePeriod(short timePeriod)
{
    if (m_timePeriod == timePeriod)
        return;

    /// only accept 12 or 24
    if (m_timePeriod == 12 || m_timePeriod == 24){}
    else {return;}

    m_timePeriod = timePeriod;
    emit timePeriodChanged(m_timePeriod);
}
