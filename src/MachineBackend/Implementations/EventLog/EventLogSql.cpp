#include "EventLogSql.h"

#define DEFAULT_CONNECTION_NAME             "EVENTLOG_DB"
#define DEFAULT_DB_LOCATION                 "eventlog.db"

#define DB_QUERY_INIT "\
CREATE TABLE IF NOT EXISTS eventlog_V1 \
(date TEXT,\
 time TEXT,\
 logCode INT,\
 logText TEXT,\
 logDesc TEXT,\
 logCategory TEXT,\
 username TEXT,\
 userfullname TEXT)"

#define DB_QUERY_ADD "\
INSERT INTO eventlog_V1 VALUES (?, ?, ?, ?, ?, ?, ?, ?)"

#define DB_QUERY_DELETE                     "DELETE FROM eventlog_V1"
#define DB_QUERY_DELETE_OLDEST_ROWID        "DELETE FROM eventlog_V1 WHERE ROWID = (SELECT ROWID FROM eventlog_V1 ORDER BY ROWID LIMIT 1)"
#define DB_QUERY_COUNT_ROWS                 "SELECT COUNT(*) FROM eventlog_V1"

//#define DB_QUERY_SELECT                     "SELECT rowid,* FROM eventlog_V1"

EventLogSql::EventLogSql(QObject *parent) : QObject(parent)
{

}

EventLogSql::~EventLogSql()
{
    QSqlDatabase::removeDatabase(m_connectionName);
}

bool EventLogSql::init(const QString &uniqConnectionName, const QString &fileName)
{
    qDebug () << __FUNCTION__ << thread();

    m_connectionName = uniqConnectionName.isEmpty() ? DEFAULT_CONNECTION_NAME : uniqConnectionName;

    QSqlDatabase m_dataBase;
    m_dataBase = QSqlDatabase::addDatabase("QSQLITE", m_connectionName);

    QString targetLocation = fileName;
    if(fileName.isEmpty()) {
        QString dataPath = QStandardPaths::writableLocation(QStandardPaths::DataLocation);
        targetLocation = dataPath + "/" + DEFAULT_DB_LOCATION;
        //        qDebug() << defaultTargetLocation;
    }
    m_dataBase.setDatabaseName(targetLocation);

    if(m_dataBase.open()){
        QSqlQuery query(QSqlDatabase::database(m_connectionName));
        if(query.exec(DB_QUERY_INIT)){
            return true;
        }
    }
    //    qDebug() << m_dataBase.lastError().text();
    m_queryLastErrorStr = m_dataBase.lastError().text();
    return false;
}

bool EventLogSql::queryInsert(const QVariantMap data)
{
    qDebug () << __FUNCTION__ << thread();

    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    bool prepared = query.prepare(DB_QUERY_ADD);
    Q_UNUSED(prepared)
//    qDebug() << prepared;

    query.addBindValue(data["date"].toString());
    query.addBindValue(data["time"].toString());
    query.addBindValue(data["logCode"].toInt());
    query.addBindValue(data["logText"].toString());
    query.addBindValue(data["logDesc"].toString());
    query.addBindValue(data["logCategory"].toString());
    query.addBindValue(data["username"].toString());
    query.addBindValue(data["userfullname"].toString());

    //    qDebug() << query.lastQuery();

    if(query.exec()) {
        success = true;
    }
    //    else {
    //        qWarning() << query.lastError().text();
    //    }
    m_queryLastErrorStr = query.lastError().text();
    //     qDebug() << m_queryLastErrorStr;
    return success;
}

bool EventLogSql::queryCount(int *count)
{
    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    bool prepared = query.prepare(DB_QUERY_COUNT_ROWS);
    Q_UNUSED(prepared)

    if(query.exec()){
        success = true;
        query.next();
        *count = query.value(0).toInt();
    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

QString EventLogSql::lastQueryErrorStr() const
{
    return m_queryLastErrorStr;
}

bool EventLogSql::queryDelete(const QString &dbQueryConfig)
{
    qDebug () << __FUNCTION__ << thread();

    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    QString statement(DB_QUERY_DELETE);
    statement.append(dbQueryConfig);
    bool prepared = query.prepare(statement);
    Q_UNUSED(prepared)

    if(query.exec()){
        success = true;
    }
    //    else{
    //        qWarning() << __func__  << query.lastError();
    //    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

bool EventLogSql::queryDeleteOldestRowId()
{
    qDebug () << __FUNCTION__ << thread();

    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    QString statement(DB_QUERY_DELETE_OLDEST_ROWID);

    qDebug() << statement;

    bool prepared = query.prepare(statement);
    Q_UNUSED(prepared)

    if(query.exec()){
        success = true;
    }
    else{
        qWarning() << __func__  << query.lastError();
    }
    qDebug() << success;
    m_queryLastErrorStr = query.lastError().text();
    return success;
}
