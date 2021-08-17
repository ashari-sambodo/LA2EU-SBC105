#pragma once

#include <QObject>

#include <QQmlEngine>
#include <QJSEngine>

#include <QDebug>

class HeaderAppAdapter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString modelName
               READ getModelName
               WRITE setModelName
               NOTIFY modelNameChanged)

    Q_PROPERTY(bool alarm
               READ getAlarm
               WRITE setAlarm
               NOTIFY alarmChanged)

    Q_PROPERTY(QString sourceLogo
               READ getSourceLogo
               WRITE setSourceLogo
               NOTIFY sourceLogoChanged)

    /// 12 for 12h
    /// 24 for 24h
    Q_PROPERTY(short timePeriod
               READ getTimePeriod
               WRITE setTimePeriod
               NOTIFY timePeriodChanged)

public:
    static QObject *singletonProvider(QQmlEngine *qmlEngine, QJSEngine *);
    static void singletonDelete();

    explicit HeaderAppAdapter(QObject *parent = nullptr);

    QString getModelName() const;

    bool getAlarm() const;

    QString getSourceLogo() const;

    short getTimePeriod() const;
    void setTimePeriod(short timePeriod);

public slots:
    void setModelName(QString modelName);

    void setAlarm(bool alarm);

    void setSourceLogo(QString sourceLogo);

signals:

    void modelNameChanged(QString modelName);

    void alarmChanged(bool alarm);

    void sourceLogoChanged(QString sourceLogo);

    void timePeriodChanged(short timePeriod);

private:
    QString m_modelName;
    bool m_alert = false;
    QString m_sourceLogo = "HeaderApp/Logo.png";
    short m_timePeriod = 12; ///12h
};

