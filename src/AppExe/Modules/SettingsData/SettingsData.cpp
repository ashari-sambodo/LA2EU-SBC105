#include <QQmlEngine>
#include <QJSEngine>

#include <QDebug>
#include "SettingsData.h"

static SettingsData* s_instance = nullptr;

QObject *SettingsData::singletonProvider(QQmlEngine *qmlEngine, QJSEngine *)
{
    if(!s_instance){
        qDebug() << "SettingsData::singletonProvider::create" << s_instance;
        s_instance = new SettingsData(qmlEngine);
    }
    return s_instance;
}

void SettingsData::singletonDelete()
{
    qDebug() << __FUNCTION__;
    if(s_instance){
        delete s_instance;
    }
}

void SettingsData::initSingleton()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
}

SettingsData::SettingsData(QObject *parent) : QObject(parent)
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    Q_UNUSED(parent)
}

SettingsData::~SettingsData()
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
}

QVariant SettingsData::value(const QString &key) const
{
    return m_settings.value(key, QVariant());
}

QString SettingsData::valueToString(const QString &key) const
{
    return m_settings.value(key, "").toString();
}

int SettingsData::valueToInt(const QString &key) const
{
    return m_settings.value(key, 0).toInt();
}

void SettingsData::setValue(const QString &key, const QVariant &value)
{
    m_settings.setValue(key, value);
}
