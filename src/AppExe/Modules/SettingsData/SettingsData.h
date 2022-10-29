#pragma once

#include <QObject>
#include <QSettings>

class QQmlEngine;
class QJSEngine;

class SettingsData;

class SettingsData : public QObject
{
    Q_OBJECT

    /// Q_PROPERTY data READ getData NOTIFY dataChanged

public:
    static QObject *singletonProvider(QQmlEngine *qmlEngine, QJSEngine *);
    static void singletonDelete();

    explicit SettingsData(QObject *parent = nullptr);
    ~SettingsData() override;

    Q_INVOKABLE QVariant value(const QString &key) const;
    Q_INVOKABLE QString valueToString(const QString &key) const;
    Q_INVOKABLE int valueToInt(const QString &key) const;

public slots:
    void initSingleton();

    void setValue(const QString &key, const QVariant &value);

signals:

private:
    QSettings m_settings;
};
