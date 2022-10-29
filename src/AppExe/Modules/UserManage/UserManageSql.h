#pragma once

#include <QObject>

#include <QSqlDatabase>
#include <QVariant>
#include <QSqlQuery>
#include <QSqlError>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

class UserManageSql : public QObject
{
    Q_OBJECT
public:
    explicit UserManageSql(QObject *parent = nullptr);
    ~UserManageSql();

    bool init(const QString &uniqConnectionName = QString(), const QString &fileName = QString());
    bool queryInsert(const QVariantMap data);
    bool querySelect(QVariantList *data, const QString &dbQueryConfig = QString());
    bool queryDelete(const QString &dbQueryConfig = QString());
    bool queryCount(int *count);

    bool queryUpdateUserUsername(const QString value, const QString username);
    bool queryUpdateUserFullname(const QString value, const QString username);
    bool queryUpdateUserEmail(const QString value, const QString username);
    bool queryUpdateUserRole(int value, const QString username);
    bool queryUpdateUserPassword(const QString value, const QString username);
    bool queryUpdateUserLastLogin(const QString value, const QString username);

    QString lastQueryErrorStr() const;

private:
    QString m_connectionName;
    QString m_dbLocation;
    QString m_queryLastErrorStr;

    enum TableHeaderEnum {
        TH_USERNAME,
        TH_PASSWORD,
        TH_ROLE,
        TH_ACTIVE,
        TH_FULLNAME,
        TH_EMAIL,
        TH_CREATED_AT,
        TH_LAST_LOGIN,
    };

};

