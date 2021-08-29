#include "DataLogSqlGet.h"

#define DEFAULT_CONNECTION_NAME             "DATALOG_DB"
#define DEFAULT_DB_FILENAME                 "datalog.db"

#define DB_QUERY_INIT "\
CREATE TABLE IF NOT EXISTS datalog_V1 \
(date TEXT,\
 time TEXT,\
 temp TXT,\
 dfa TXT,\
 dfaAdc INT,\
 dfaFanDcy INT,\
 dfaFanRPM INT,\
 ifa TXT,\
 ifaAdc INT,\
 ifaFanDcy INT)"

#define DB_QUERY_ADD                        "INSERT INTO datalog_V1 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"

#define DB_QUERY_DELETE                     "DELETE FROM datalog_V1"
#define DB_QUERY_COUNT_ROWS                 "SELECT COUNT(*) FROM datalog_V1"

#define DB_QUERY_SELECT                     "SELECT rowid,* FROM datalog_V1"

DataLogSqlGet::DataLogSqlGet()
{

}

DataLogSqlGet::~DataLogSqlGet()
{
    QSqlDatabase::removeDatabase(m_connectionName);
}

bool DataLogSqlGet::init(const QString &uniqConnectionName, const QString &fileName)
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

bool DataLogSqlGet::queryInsert(const QVariantMap data)
{
    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    bool prepared = query.prepare(DB_QUERY_ADD);
    Q_UNUSED(prepared)
    qDebug() << prepared;

    query.addBindValue(data["date"].toString());
    query.addBindValue(data["time"].toString());
    query.addBindValue(data["temp"].toString());
    query.addBindValue(data["dfa"].toString());
    query.addBindValue(data["dfaAdc"].toInt());
    query.addBindValue(data["dfaFanDcy"].toInt());
    query.addBindValue(data["dfaFanRPM"].toInt());
    query.addBindValue(data["ifa"].toString());
    query.addBindValue(data["ifaAdc"].toInt());
    query.addBindValue(data["ifaFanDcy"].toInt());

    qDebug() << query.lastQuery();

    if(query.exec()) {
        success = true;
    }
    else {
        qDebug() << "error";
    }
    m_queryLastErrorStr = query.lastError().text();
    qDebug() << m_queryLastErrorStr;
    return success;
}

bool DataLogSqlGet::querySelect(QVariantList *data, const QString &dbQueryConfig)
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
            dataItem.push_back(query.value(TableHeaderEnum::TH_TIMESTAMP));
            dataItem.push_back(query.value(TableHeaderEnum::TH_DATELOG));
            dataItem.push_back(query.value(TableHeaderEnum::TH_TIMELOG));
            dataItem.push_back(query.value(TableHeaderEnum::TH_TEMP));
            dataItem.push_back(query.value(TableHeaderEnum::TH_DFA));
            dataItem.push_back(query.value(TableHeaderEnum::TH_DFA_ADC));
            dataItem.push_back(query.value(TableHeaderEnum::TH_DFA_FAN_DCY));
            dataItem.push_back(query.value(TableHeaderEnum::TH_DFA_FAN_RPM));
            dataItem.push_back(query.value(TableHeaderEnum::TH_IFA));
            dataItem.push_back(query.value(TableHeaderEnum::TH_IFA_ADC));
            dataItem.push_back(query.value(TableHeaderEnum::TH_IFA_FAN_DCY));

            data->push_back(dataItem);
        }
    }
    //    else{
    //        qWarning() << __func__ << query.lastError().text();
    //    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

bool DataLogSqlGet::queryDelete(const QString &dbQueryConfig)
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

bool DataLogSqlGet::queryCount(int *count)
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

QString DataLogSqlGet::lastQueryErrorStr() const
{
    return m_queryLastErrorStr;
}
