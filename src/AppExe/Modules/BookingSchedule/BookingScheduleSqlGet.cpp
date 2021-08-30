#include "BookingScheduleSqlGet.h"

#define DEFAULT_CONNECTION_NAME             "BOOKING_SCHEDULE"
#define DEFAULT_DB_FILENAME                 "bookingschedule.db"

#define DB_QUERY_INIT                       "\
CREATE TABLE IF NOT EXISTS bookingschedule_V1 \
(date TEXT, time TEXT, bookTitle TEXT, bookBy TEXT, note1 TEXT, note2 TEXT, note3 TEXT, createdAt TEXT)"

#define DB_QUERY_ADD                        "INSERT INTO bookingschedule_V1 VALUES (?, ?, ?, ?, ?, ?, ?, ?)"

#define DB_QUERY_DELETE                     "DELETE FROM bookingschedule_V1"
#define DB_QUERY_COUNT_ROWS                 "SELECT COUNT(*) FROM bookingschedule_V1"

#define DB_QUERY_SELECT                     "SELECT rowid,* FROM bookingschedule_V1"

BookingScheduleSqlGet::BookingScheduleSqlGet()
{

}

BookingScheduleSqlGet::~BookingScheduleSqlGet()
{
  QSqlDatabase::removeDatabase(m_connectionName);
}

bool BookingScheduleSqlGet::init(const QString &uniqConnectionName, const QString &fileName)
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

bool BookingScheduleSqlGet::queryInsert(const QVariantMap data)
{
    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    bool prepared = query.prepare(DB_QUERY_ADD);
    Q_UNUSED(prepared)
    //    qDebug() << prepared;

    query.addBindValue(data["date"].toString());
    query.addBindValue(data["time"].toString());
    query.addBindValue(data["bookTitle"].toString());
    query.addBindValue(data["bookBy"].toString());
    query.addBindValue(data["note1"].toString());
    query.addBindValue(data["note2"].toString());
    query.addBindValue(data["note3"].toString());
    query.addBindValue(data["createdAt"].toString());

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

bool BookingScheduleSqlGet::querySelect(QVariantList *data, const QString &dbQueryConfig)
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

            dataItem.push_back(query.value(TableHeaderEnum::TH_ROWID));
            dataItem.push_back(query.value(TableHeaderEnum::TH_TIMESTAMP));
            dataItem.push_back(query.value(TableHeaderEnum::TH_DATESCHEDULE));
            dataItem.push_back(query.value(TableHeaderEnum::TH_TIMESCHEDULE));
            dataItem.push_back(query.value(TableHeaderEnum::TH_BOOKTITLESCHEDULE));
            dataItem.push_back(query.value(TableHeaderEnum::TH_BOOKBYSCHEDULE));
            dataItem.push_back(query.value(TableHeaderEnum::TH_NOTEFIRSTSCHEDULE));
            dataItem.push_back(query.value(TableHeaderEnum::TH_NOTESECONDSCHEDULE));
            dataItem.push_back(query.value(TableHeaderEnum::TH_NOTETHIRDSCHEDULE));
            dataItem.push_back(query.value(TableHeaderEnum::TH_CREATEDATSCHEDULE));

            data->push_back(dataItem);
        }
    }
    //    else{
    //        qWarning() << __func__ << query.lastError().text();
    //    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

bool BookingScheduleSqlGet::queryDelete(const QString &dbQueryConfig)
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

bool BookingScheduleSqlGet::queryCount(int *count)
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

QString BookingScheduleSqlGet::lastQueryErrorStr() const
{
     return m_queryLastErrorStr;
}
