#include "EventLogSqlGet.h"

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

//#define DB_QUERY_ADD "INSERT INTO eventlog_V1 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"

#define DB_QUERY_DELETE                     "DELETE FROM eventlog_V1"
#define DB_QUERY_COUNT_ROWS                 "SELECT COUNT(*) FROM eventlog_V1"

#define DB_QUERY_SELECT                     "SELECT rowid,* FROM eventlog_V1"

EventLogSqlGet::EventLogSqlGet(QObject *parent) : QObject(parent)
{

}

EventLogSqlGet::~EventLogSqlGet()
{
    qDebug() << "~EventLogSqlGet";
    QSqlDatabase::removeDatabase(m_connectionName);
}

bool EventLogSqlGet::init(const QString &uniqConnectionName, const QString &fileName)
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

//bool EventLogSqlGet::queryInsert(const QVariantMap data)
//{
//    qDebug () << __FUNCTION__ << thread();

//    bool success = false;

//    QSqlQuery query(QSqlDatabase::database(m_connectionName));

//    bool prepared = query.prepare(DB_QUERY_ADD);
//    Q_UNUSED(prepared);
//    //    qDebug() << prepared;

//    query.addBindValue(data["date"].toString());
//    query.addBindValue(data["time"].toString());
//    query.addBindValue(data["alarmCode"].toString());
//    query.addBindValue(data["priority"].toInt());
//    query.addBindValue(data["alarmText"].toString());
//    query.addBindValue(data["ackTime"].toString());
//    query.addBindValue(data["ackBy"].toString());
//    query.addBindValue(data["ackNote"].toString());
//    query.addBindValue(data["username"].toString());
//    query.addBindValue(data["userfullname"].toString());

//    //    qDebug() << query.lastQuery();

//    if(query.exec()) {
//        success = true;
//    }
//    //    else {
//    //        //        qDebug() << "error";
//    //    }
//    m_queryLastErrorStr = query.lastError().text();
//    return success;
//}

bool EventLogSqlGet::querySelect(QVariantList *data, const QString &dbQueryConfig)
{
    qDebug () << __FUNCTION__ << thread();

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    QString statement(DB_QUERY_SELECT);
    statement.append(dbQueryConfig);
    bool prepared = query.prepare(statement);
    Q_UNUSED(prepared)
    //    qDebug() << prepared << query.lastQuery();

    bool success = false;
    if(query.exec()){
        success = true;
        while(query.next()){
            QVariantList dataItem;

            //            qDebug() << "query" << query.size();

            dataItem.push_back(query.value(TableHeaderEnum::TH_ROWID));
            dataItem.push_back(query.value(TableHeaderEnum::TH_DATELOG));
            dataItem.push_back(query.value(TableHeaderEnum::TH_TIMELOG));
            dataItem.push_back(query.value(TableHeaderEnum::TH_LOG_CODE));
            dataItem.push_back(query.value(TableHeaderEnum::TH_LOG_TEXT));
            dataItem.push_back(query.value(TableHeaderEnum::TH_LOG_DESC));
            dataItem.push_back(query.value(TableHeaderEnum::TH_LOG_CATEGORY));
            dataItem.push_back(query.value(TableHeaderEnum::TH_USERNAME));
            dataItem.push_back(query.value(TableHeaderEnum::TH_USERFULLNAME));

            data->push_back(dataItem);
        }
    }
    //    else{
    //        qWarning() << __func__ << query.lastError().text();
    //    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

bool EventLogSqlGet::queryDelete(const QString &dbQueryConfig)
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

bool EventLogSqlGet::queryCount(int *count)
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

QString EventLogSqlGet::lastQueryErrorStr() const
{
    return m_queryLastErrorStr;
}
