#pragma once

#include <QSqlDatabase>
#include <QVariant>
#include <QSqlQuery>
#include <QSqlError>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

class AlarmLogSqlGet : public QObject
{
public:
    explicit AlarmLogSqlGet(QObject *parent = nullptr);
    ~AlarmLogSqlGet();

    bool init(const QString &uniqConnectionName = QString(), const QString &fileName = QString());
    //    bool queryInsert(const QVariantMap data);
    bool querySelect(QVariantList *data, const QString &dbQueryConfig = QString());
    bool queryDelete(const QString &dbQueryConfig = QString());
    bool queryCount(int *count);

    QString lastQueryErrorStr() const;

private:
    QString m_connectionName;
    QString m_dbLocation;
    QString m_queryLastErrorStr;

    enum TableHeaderEnum {
        TH_ROWID,
        TH_DATELOG,
        TH_TIMELOG,
        TH_ALARM_CODE,
        TH_PRIORITY,
        TH_ALARM_TEXT,
        TH_ACKTIME,
        TH_ACKBY,
        TH_ACKNOTE,
        TH_USERNAME,
        TH_USERFULLNAME,
    };
};

