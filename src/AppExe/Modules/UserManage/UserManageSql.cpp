#include "UserManageSql.h"

#define DEFAULT_CONNECTION_NAME             "USERMANAGE_DB"
#define DEFAULT_DB_FILENAME                 "usermanage.db"

#define DB_QUERY_INIT                       "\
CREATE TABLE IF NOT EXISTS usermanage_V1 \
(username TEXT, password TEXT, role INT, active INT, fullname TEXT, email TEXT, createdAt TEXT, lastLogin TEXT)"

#define DB_QUERY_ADD                        "INSERT INTO usermanage_V1 VALUES (?, ?, ?, ?, ?, ?, ?, ?)"

#define DB_QUERY_UPDATE_FULLNAME            "UPDATE usermanage_V1 SET fullname = ? WHERE username = ?"
#define DB_QUERY_UPDATE_EMAIL               "UPDATE usermanage_V1 SET email = ? WHERE username = ?"
#define DB_QUERY_UPDATE_ROLE                "UPDATE usermanage_V1 SET role = ? WHERE username = ?"
#define DB_QUERY_UPDATE_PASSWORD            "UPDATE usermanage_V1 SET password = ? WHERE username = ?"
#define DB_QUERY_UPDATE_LASTLOGIN           "UPDATE usermanage_V1 SET lastLogin = ? WHERE username = ?"

#define DB_QUERY_DELETE                     "DELETE FROM usermanage_V1"
#define DB_QUERY_COUNT_ROWS                 "SELECT COUNT(*) FROM usermanage_V1"

#define DB_QUERY_SELECT_WITH_OFFSET_LIMIT_ASC        "SELECT * FROM usermanage_V1 ORDER BY ROWID ASC LIMIT :limit OFFSET :offset;"
#define DB_QUERY_SELECT_WITH_OFFSET_LIMIT_DESC       "SELECT * FROM usermanage_V1 ORDER BY ROWID DESC LIMIT :limit OFFSET :offset;"

#define DB_QUERY_SELECT                     "SELECT * FROM usermanage_V1"

UserManageSql::UserManageSql(QObject *parent) : QObject(parent)
{

}

UserManageSql::~UserManageSql()
{
    qDebug() << "~UserManageSql";
    QSqlDatabase::removeDatabase(m_connectionName);
}

bool UserManageSql::init(const QString &uniqConnectionName, const QString &fileName)
{
    m_connectionName = uniqConnectionName.isEmpty() ? DEFAULT_CONNECTION_NAME : uniqConnectionName;

    QSqlDatabase m_dataBase;
    m_dataBase = QSqlDatabase::addDatabase("QSQLITE", m_connectionName);

    QString targetLocation = fileName;
    if(!QFile(targetLocation).exists()) {
        QString dataPath = QStandardPaths::writableLocation(QStandardPaths::DataLocation);
        targetLocation = dataPath + "/" + DEFAULT_DB_FILENAME;
        //        qDebug() << targetLocation;
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

bool UserManageSql::queryInsert(const QVariantMap data)
{
    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    bool prepared = query.prepare(DB_QUERY_ADD);
    Q_UNUSED(prepared)
    //    qDebug() << prepared;

    query.addBindValue(data["username"].toString());
    query.addBindValue(data["password"].toString());
    query.addBindValue(data["role"].toInt());
    query.addBindValue(data["active"].toInt());
    query.addBindValue(data["fullname"].toString());
    query.addBindValue(data["email"].toString());
    query.addBindValue(data["createdAt"].toString());
    query.addBindValue("NA");

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

bool UserManageSql::querySelect(QVariantList *data, const QString &dbQueryConfig)
{
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
            dataItem.push_back(query.value(TableHeaderEnum::TH_USERNAME));

            dataItem.push_back(query.value(TableHeaderEnum::TH_PASSWORD));
            dataItem.push_back(query.value(TableHeaderEnum::TH_ROLE));
            dataItem.push_back(query.value(TableHeaderEnum::TH_ACTIVE));
            dataItem.push_back(query.value(TableHeaderEnum::TH_FULLNAME));
            dataItem.push_back(query.value(TableHeaderEnum::TH_EMAIL));
            dataItem.push_back(query.value(TableHeaderEnum::TH_CREATED_AT));
            dataItem.push_back(query.value(TableHeaderEnum::TH_LAST_LOGIN));

            data->push_back(dataItem);
        }
    }
    //    else{
    //        qWarning() << __func__ << query.lastError().text();
    //    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

bool UserManageSql::queryDelete(const QString &dbQueryConfig)
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

bool UserManageSql::queryCount(int *count)
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

bool UserManageSql::queryUpdateUserFullname(const QString value, const QString username)
{
    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    bool prepared = query.prepare(DB_QUERY_UPDATE_FULLNAME);
    Q_UNUSED(prepared);

    query.addBindValue(value);
    query.addBindValue(username);
    qDebug() << query.lastQuery();

    if (query.exec()) {
        success = true;
    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

bool UserManageSql::queryUpdateUserEmail(const QString value, const QString username)
{
    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    bool prepared = query.prepare(DB_QUERY_UPDATE_EMAIL);
    Q_UNUSED(prepared);

    query.addBindValue(value);
    query.addBindValue(username);
    qDebug() << query.lastQuery();

    if (query.exec()) {
        success = true;
    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

bool UserManageSql::queryUpdateUserRole(int value, const QString username)
{
    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    bool prepared = query.prepare(DB_QUERY_UPDATE_ROLE);
    Q_UNUSED(prepared);

    query.addBindValue(value);
    query.addBindValue(username);
    qDebug() << query.lastQuery();

    if (query.exec()) {
        success = true;
    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

bool UserManageSql::queryUpdateUserPassword(const QString value, const QString username)
{
    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    bool prepared = query.prepare(DB_QUERY_UPDATE_PASSWORD);
    Q_UNUSED(prepared);

    query.addBindValue(value);
    query.addBindValue(username);
    qDebug() << query.lastQuery();

    if (query.exec()) {
        success = true;
    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

bool UserManageSql::queryUpdateUserLastLogin(const QString value, const QString username)
{
    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    bool prepared = query.prepare(DB_QUERY_UPDATE_LASTLOGIN);
    Q_UNUSED(prepared);

    query.addBindValue(value);
    query.addBindValue(username);
    qDebug() << query.lastQuery();

    if (query.exec()) {
        success = true;
    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

QString UserManageSql::lastQueryErrorStr() const
{
    return m_queryLastErrorStr;
}
