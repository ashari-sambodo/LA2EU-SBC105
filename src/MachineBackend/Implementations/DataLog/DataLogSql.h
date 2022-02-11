#pragma once
#include <QSqlDatabase>
#include <QVariant>
#include <QSqlQuery>
#include <QSqlError>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

class DataLogSql : public QObject
{
public:
    explicit DataLogSql(QObject *parent = nullptr);
    ~DataLogSql();

    bool init(const QString &uniqConnectionName = QString(), const QString &fileName = QString());
    bool queryInsert(const QVariantMap data);
    //    bool querySelect(QVariantList *data, const QString &dbQueryConfig = QString());
    bool queryDelete(const QString &dbQueryConfig = QString());
    bool queryCount(int *count);

    QString lastQueryErrorStr() const;

private:
    QString m_connectionName;
    QString m_dbLocation;
    QString m_queryLastErrorStr;

    enum TableHeaderEnum {
        TH_DATELOG,
        TH_TIMELOG,
        TH_TEMP,
        TH_DFA,
        TH_DFA_ADC,
        TH_DFA_FAN_DCY,
        TH_DFA_FAN_RPM,
        TH_IFA,
        TH_IFA_ADC,
        TH_IFA_FAN_DCY,
    };
};
