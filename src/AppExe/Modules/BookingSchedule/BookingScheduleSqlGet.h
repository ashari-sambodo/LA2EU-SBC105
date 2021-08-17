#pragma once

#include <QSqlDatabase>
#include <QVariant>
#include <QSqlQuery>
#include <QSqlError>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>


class BookingScheduleSqlGet : public QObject
{
public:
    BookingScheduleSqlGet();
    ~BookingScheduleSqlGet();

    bool init(const QString &uniqConnectionName = QString(), const QString &fileName = QString());
    bool queryInsert(const QVariantMap data);
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
        TH_TIMESTAMP,
        TH_DATESCHEDULE,
        TH_TIMESCHEDULE,
        TH_BOOKTITLESCHEDULE,
        TH_BOOKBYSCHEDULE,
        TH_NOTEFIRSTSCHEDULE,
        TH_NOTESECONDSCHEDULE,
        TH_NOTETHIRDSCHEDULE,
        TH_CREATEDATSCHEDULE

    };
};
