#include "ResourceMonitorLogSqlGet.h"

#define DEFAULT_CONNECTION_NAME             "RESOURCEMONITORLOG_DB"
#define DEFAULT_DB_FILENAME                 "resourcemonitorlog.db"

#define DB_QUERY_INIT                       "\
CREATE TABLE IF NOT EXISTS resourcemonitorlog_V2 \
(date TEXT, time TEXT, cpuUsage TXT, memUsage TXT, cpuTemp TXT, sdCardLife)"

#define DB_QUERY_ADD                        "INSERT INTO resourcemonitorlog_V2 VALUES (?, ?, ?, ?, ?, ?)"

#define DB_QUERY_DELETE                     "DELETE FROM resourcemonitorlog_V2"
#define DB_QUERY_COUNT_ROWS                 "SELECT COUNT(*) FROM resourcemonitorlog_V2"

#define DB_QUERY_SELECT                     "SELECT rowid,* FROM resourcemonitorlog_V2"

ResourceMonitorLogSqlGet::ResourceMonitorLogSqlGet()
{

}

ResourceMonitorLogSqlGet::~ResourceMonitorLogSqlGet()
{
    QSqlDatabase::removeDatabase(m_connectionName);
}

bool ResourceMonitorLogSqlGet::init(const QString &uniqConnectionName, const QString &fileName)
{
    m_connectionName = uniqConnectionName.isEmpty() ? DEFAULT_CONNECTION_NAME : uniqConnectionName;

    QSqlDatabase m_dataBase;
    m_dataBase = QSqlDatabase::addDatabase("QSQLITE", m_connectionName);

    QString targetLocation = fileName;
    if(!QDir().exists(targetLocation)) {
        QString dataPath = QStandardPaths::writableLocation(QStandardPaths::DataLocation);
        targetLocation = dataPath + "/" + DEFAULT_DB_FILENAME;
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

bool ResourceMonitorLogSqlGet::queryInsert(const QVariantMap data)
{
    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    bool prepared = query.prepare(DB_QUERY_ADD);
    Q_UNUSED(prepared);
    //    qDebug() << prepared;

    query.addBindValue(data["date"].toString());
    query.addBindValue(data["time"].toString());
    query.addBindValue(data["cpuUsage"].toString());
    query.addBindValue(data["memUsage"].toString());
    query.addBindValue(data["cpuTemp"].toString());
    query.addBindValue(data["sdCardLife"].toString());

    //    qDebug() << query.lastQuery();

    if(query.exec()) {
        success = true;
    }
    //    else {
    //        //        qDebug() << "error";
    //    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

bool ResourceMonitorLogSqlGet::querySelect(QVariantList *data, const QString &dbQueryConfig)
{
    //    qDebug () << __FUNCTION__ << QThread::currentThreadId();

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

            /// ignore timestamp
            dataItem.push_back(query.value(TableHeaderEnum::TH_ROWID));
            dataItem.push_back(query.value(TableHeaderEnum::TH_DATELOG));
            dataItem.push_back(query.value(TableHeaderEnum::TH_TIMELOG));
            dataItem.push_back(query.value(TableHeaderEnum::TH_CPU_USAGE));
            dataItem.push_back(query.value(TableHeaderEnum::TH_MEM_USAGE));
            dataItem.push_back(query.value(TableHeaderEnum::TH_CPU_TEMP));
            dataItem.push_back(query.value(TableHeaderEnum::TH_SD_CARD_LIFE));

            data->push_back(dataItem);
        }
    }
    //    else{
    //        qWarning() << __func__ << query.lastError().text();
    //    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

bool ResourceMonitorLogSqlGet::queryDelete(const QString &dbQueryConfig)
{
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

bool ResourceMonitorLogSqlGet::queryCount(int *count)
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

QString ResourceMonitorLogSqlGet::lastQueryErrorStr() const
{
    return m_queryLastErrorStr;
}
