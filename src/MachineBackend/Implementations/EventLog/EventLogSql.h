#pragma once

#include <QObject>
#include <QSqlDatabase>
#include <QVariant>
#include <QSqlQuery>
#include <QSqlError>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

class EventLogSql : public QObject
{
    Q_OBJECT
public:
    explicit EventLogSql(QObject *parent = nullptr);
    ~EventLogSql();

    bool init(const QString &uniqConnectionName = QString(), const QString &fileName = QString());
    bool queryInsert(const QVariantMap data);
    //    bool querySelect(QVariantList *data, const QString &dbQueryConfig = QString());
    bool queryDelete(const QString &dbQueryConfig = QString());
    bool queryDeleteOldestRowId();
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
        TH_LOG_CODE,
        TH_LOG_TEXT,
        TH_LOG_DESC,
        TH_LOG_CATEGORY,
        TH_USERNAME,
        TH_USERFULLNAME,
    };

};

