#include "ReplaceableCompRecordSql.h"

#define DEFAULT_CONNECTION_NAME             "ReplaceableCompRecord_DB"
#define DEFAULT_DB_LOCATION                 "replaceablecomprecord.db"

#define DB_QUERY_INIT "\
CREATE TABLE IF NOT EXISTS replaceablecomprecord_V1 \
(unitModel TEXT,\
 unitSerialNumber TEXT,\
 date TEXT,\
 time TEXT,\
 userManualCode TEXT,\
 userManualVersion TEXT,\
 electricalPanel TEXT,\
 electricalPanelSerialNumber TEXT,\
 electricalTester TEXT,\
 sbcSet1Name TEXT,\
 sbcSet2Name TEXT,\
 sbcSet3Name TEXT,\
 sbcSet4Name TEXT,\
 sbcSet5Name TEXT,\
 sbcSet6Name TEXT,\
 sbcSet7Name TEXT,\
 sbcSet8Name TEXT,\
 sbcSet9Name TEXT,\
 sbcSet10Name TEXT,\
 sbcSet11Name TEXT,\
 sbcSet12Name TEXT,\
 sbcSet13Name TEXT,\
 sbcSet14Name TEXT,\
 sbcSet15Name TEXT,\
 sbcSet1Code TEXT,\
 sbcSet2Code TEXT,\
 sbcSet3Code TEXT,\
 sbcSet4Code TEXT,\
 sbcSet5Code TEXT,\
 sbcSet6Code TEXT,\
 sbcSet7Code TEXT,\
 sbcSet8Code TEXT,\
 sbcSet9Code TEXT,\
 sbcSet10Code TEXT,\
 sbcSet11Code TEXT,\
 sbcSet12Code TEXT,\
 sbcSet13Code TEXT,\
 sbcSet14Code TEXT,\
 sbcSet15Code TEXT,\
 sbcSet1Qty TEXT,\
 sbcSet2Qty TEXT,\
 sbcSet3Qty TEXT,\
 sbcSet4Qty TEXT,\
 sbcSet5Qty TEXT,\
 sbcSet6Qty TEXT,\
 sbcSet7Qty TEXT,\
 sbcSet8Qty TEXT,\
 sbcSet9Qty TEXT,\
 sbcSet10Qty TEXT,\
 sbcSet11Qty TEXT,\
 sbcSet12Qty TEXT,\
 sbcSet13Qty TEXT,\
 sbcSet14Qty TEXT,\
 sbcSet15Qty TEXT,\
 sbcSet1SN TEXT,\
 sbcSet2SN TEXT,\
 sbcSet3SN TEXT,\
 sbcSet4SN TEXT,\
 sbcSet5SN TEXT,\
 sbcSet6SN TEXT,\
 sbcSet7SN TEXT,\
 sbcSet8SN TEXT,\
 sbcSet9SN TEXT,\
 sbcSet10SN TEXT,\
 sbcSet11SN TEXT,\
 sbcSet12SN TEXT,\
 sbcSet13SN TEXT,\
 sbcSet14SN TEXT,\
 sbcSet15SN TEXT,\
 sbcSet1SW TEXT,\
 sbcSet2SW TEXT,\
 sbcSet3SW TEXT,\
 sbcSet4SW TEXT,\
 sbcSet5SW TEXT,\
 sbcSet6SW TEXT,\
 sbcSet7SW TEXT,\
 sbcSet8SW TEXT,\
 sbcSet9SW TEXT,\
 sbcSet10SW TEXT,\
 sbcSet11SW TEXT,\
 sbcSet12SW TEXT,\
 sbcSet13SW TEXT,\
 sbcSet14SW TEXT,\
 sbcSet15SW TEXT,\
 sbcSet1Check TEXT,\
 sbcSet2Check TEXT,\
 sbcSet3Check TEXT,\
 sbcSet4Check TEXT,\
 sbcSet5Check TEXT,\
 sbcSet6Check TEXT,\
 sbcSet7Check TEXT,\
 sbcSet8Check TEXT,\
 sbcSet9Check TEXT,\
 sbcSet10Check TEXT,\
 sbcSet11Check TEXT,\
 sbcSet12Check TEXT,\
 sbcSet13Check TEXT,\
 sbcSet14Check TEXT,\
 sbcSet15Check TEXT,\
 sensor1Name TEXT,\
 sensor2Name TEXT,\
 sensor3Name TEXT,\
 sensor4Name TEXT,\
 sensor5Name TEXT,\
 sensor1Code TEXT,\
 sensor2Code TEXT,\
 sensor3Code TEXT,\
 sensor4Code TEXT,\
 sensor5Code TEXT,\
 sensor1Qty TEXT,\
 sensor2Qty TEXT,\
 sensor3Qty TEXT,\
 sensor4Qty TEXT,\
 sensor5Qty TEXT,\
 sensor1SN TEXT,\
 sensor2SN TEXT,\
 sensor3SN TEXT,\
 sensor4SN TEXT,\
 sensor5SN TEXT,\
 sensor1Const TEXT,\
 sensor2Const TEXT,\
 sensor3Const TEXT,\
 sensor4Const TEXT,\
 sensor5Const TEXT,\
 sensor1Check TEXT,\
 sensor2Check TEXT,\
 sensor3Check TEXT,\
 sensor4Check TEXT,\
 sensor5Check TEXT,\
 uvLED1Name TEXT,\
 uvLED2Name TEXT,\
 uvLED3Name TEXT,\
 uvLED4Name TEXT,\
 uvLED5Name TEXT,\
 uvLED6Name TEXT,\
 uvLED1Code TEXT,\
 uvLED2Code TEXT,\
 uvLED3Code TEXT,\
 uvLED4Code TEXT,\
 uvLED5Code TEXT,\
 uvLED6Code TEXT,\
 uvLED1Qty TEXT,\
 uvLED2Qty TEXT,\
 uvLED3Qty TEXT,\
 uvLED4Qty TEXT,\
 uvLED5Qty TEXT,\
 uvLED6Qty TEXT,\
 uvLED1SN TEXT,\
 uvLED2SN TEXT,\
 uvLED3SN TEXT,\
 uvLED4SN TEXT,\
 uvLED5SN TEXT,\
 uvLED6SN TEXT,\
 uvLED1Check TEXT,\
 uvLED2Check TEXT,\
 uvLED3Check TEXT,\
 uvLED4Check TEXT,\
 uvLED5Check TEXT,\
 uvLED6Check TEXT,\
 psu1Name TEXT,\
 psu2Name TEXT,\
 psu3Name TEXT,\
 psu4Name TEXT,\
 psu5Name TEXT,\
 psu1Code TEXT,\
 psu2Code TEXT,\
 psu3Code TEXT,\
 psu4Code TEXT,\
 psu5Code TEXT,\
 psu1Qty TEXT,\
 psu2Qty TEXT,\
 psu3Qty TEXT,\
 psu4Qty TEXT,\
 psu5Qty TEXT,\
 psu1SN TEXT,\
 psu2SN TEXT,\
 psu3SN TEXT,\
 psu4SN TEXT,\
 psu5SN TEXT,\
 psu1Check TEXT,\
 psu2Check TEXT,\
 psu3Check TEXT,\
 psu4Check TEXT,\
 psu5Check TEXT,\
 mcbEMI1Name TEXT,\
 mcbEMI2Name TEXT,\
 mcbEMI3Name TEXT,\
 mcbEMI4Name TEXT,\
 mcbEMI5Name TEXT,\
 mcbEMI1Code TEXT,\
 mcbEMI2Code TEXT,\
 mcbEMI3Code TEXT,\
 mcbEMI4Code TEXT,\
 mcbEMI5Code TEXT,\
 mcbEMI1Qty TEXT,\
 mcbEMI2Qty TEXT,\
 mcbEMI3Qty TEXT,\
 mcbEMI4Qty TEXT,\
 mcbEMI5Qty TEXT,\
 mcbEMI1SN TEXT,\
 mcbEMI2SN TEXT,\
 mcbEMI3SN TEXT,\
 mcbEMI4SN TEXT,\
 mcbEMI5SN TEXT,\
 mcbEMI1Check TEXT,\
 mcbEMI2Check TEXT,\
 mcbEMI3Check TEXT,\
 mcbEMI4Check TEXT,\
 mcbEMI5Check TEXT,\
 contactSw1Name TEXT,\
 contactSw2Name TEXT,\
 contactSw3Name TEXT,\
 contactSw4Name TEXT,\
 contactSw5Name TEXT,\
 contactSw1Code TEXT,\
 contactSw2Code TEXT,\
 contactSw3Code TEXT,\
 contactSw4Code TEXT,\
 contactSw5Code TEXT,\
 contactSw1Qty TEXT,\
 contactSw2Qty TEXT,\
 contactSw3Qty TEXT,\
 contactSw4Qty TEXT,\
 contactSw5Qty TEXT,\
 contactSw1SN TEXT,\
 contactSw2SN TEXT,\
 contactSw3SN TEXT,\
 contactSw4SN TEXT,\
 contactSw5SN TEXT,\
 contactSw1Check TEXT,\
 contactSw2Check TEXT,\
 contactSw3Check TEXT,\
 contactSw4Check TEXT,\
 contactSw5Check TEXT,\
 bMotor1Name TEXT,\
 bMotor2Name TEXT,\
 bMotor3Name TEXT,\
 bMotor4Name TEXT,\
 bMotor5Name TEXT,\
 bMotor1Code TEXT,\
 bMotor2Code TEXT,\
 bMotor3Code TEXT,\
 bMotor4Code TEXT,\
 bMotor5Code TEXT,\
 bMotor1Qty TEXT,\
 bMotor2Qty TEXT,\
 bMotor3Qty TEXT,\
 bMotor4Qty TEXT,\
 bMotor5Qty TEXT,\
 bMotor1SNMotor TEXT,\
 bMotor2SNMotor TEXT,\
 bMotor3SNMotor TEXT,\
 bMotor4SNMotor TEXT,\
 bMotor5SNMotor TEXT,\
 bMotor1SNBlower TEXT,\
 bMotor2SNBlower TEXT,\
 bMotor3SNBlower TEXT,\
 bMotor4SNBlower TEXT,\
 bMotor5SNBlower TEXT,\
 bMotor1SW TEXT,\
 bMotor2SW TEXT,\
 bMotor3SW TEXT,\
 bMotor4SW TEXT,\
 bMotor5SW TEXT,\
 bMotor1Check TEXT,\
 bMotor2Check TEXT,\
 bMotor3Check TEXT,\
 bMotor4Check TEXT,\
 bMotor5Check TEXT,\
 capInd1Name TEXT,\
 capInd2Name TEXT,\
 capInd3Name TEXT,\
 capInd4Name TEXT,\
 capInd5Name TEXT,\
 capInd1Code TEXT,\
 capInd2Code TEXT,\
 capInd3Code TEXT,\
 capInd4Code TEXT,\
 capInd5Code TEXT,\
 capInd1Qty TEXT,\
 capInd2Qty TEXT,\
 capInd3Qty TEXT,\
 capInd4Qty TEXT,\
 capInd5Qty TEXT,\
 capInd1SN TEXT,\
 capInd2SN TEXT,\
 capInd3SN TEXT,\
 capInd4SN TEXT,\
 capInd5SN TEXT,\
 capInd1Check TEXT,\
 capInd2Check TEXT,\
 capInd3Check TEXT,\
 capInd4Check TEXT,\
 capInd5Check TEXT,\
 custom1Name TEXT,\
 custom2Name TEXT,\
 custom3Name TEXT,\
 custom4Name TEXT,\
 custom5Name TEXT,\
 custom6Name TEXT,\
 custom7Name TEXT,\
 custom8Name TEXT,\
 custom1Code TEXT,\
 custom2Code TEXT,\
 custom3Code TEXT,\
 custom4Code TEXT,\
 custom5Code TEXT,\
 custom6Code TEXT,\
 custom7Code TEXT,\
 custom8Code TEXT,\
 custom1Qty TEXT,\
 custom2Qty TEXT,\
 custom3Qty TEXT,\
 custom4Qty TEXT,\
 custom5Qty TEXT,\
 custom6Qty TEXT,\
 custom7Qty TEXT,\
 custom8Qty TEXT,\
 custom1SN TEXT,\
 custom2SN TEXT,\
 custom3SN TEXT,\
 custom4SN TEXT,\
 custom5SN TEXT,\
 custom6SN TEXT,\
 custom7SN TEXT,\
 custom8SN TEXT,\
 custom1Check TEXT,\
 custom2Check TEXT,\
 custom3Check TEXT,\
 custom4Check TEXT,\
 custom5Check TEXT,\
 custom6Check TEXT,\
 custom7Check TEXT,\
 custom8Check TEXT,\
 filter1Name TEXT,\
 filter2Name TEXT,\
 filter3Name TEXT,\
 filter4Name TEXT,\
 filter5Name TEXT,\
 filter1Code TEXT,\
 filter2Code TEXT,\
 filter3Code TEXT,\
 filter4Code TEXT,\
 filter5Code TEXT,\
 filter1Qty TEXT,\
 filter2Qty TEXT,\
 filter3Qty TEXT,\
 filter4Qty TEXT,\
 filter5Qty TEXT,\
 filter1SN TEXT,\
 filter2SN TEXT,\
 filter3SN TEXT,\
 filter4SN TEXT,\
 filter5SN TEXT,\
 filter1Size TEXT,\
 filter2Size TEXT,\
 filter3Size TEXT,\
 filter4Size TEXT,\
 filter5Size TEXT,\
 filter1Check TEXT,\
 filter2Check TEXT,\
 filter3Check TEXT,\
 filter4Check TEXT,\
 filter5Check TEXT,\
 userName TEXT,\
 userFullName TEXT)"//366

#define DB_QUERY_ADD "\
INSERT INTO replaceablecomprecord_V1 VALUES \
(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,\
 ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,\
 ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,\
 ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,\
 ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,\
 ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,\
 ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,\
 ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"

#define DB_QUERY_DELETE                 "DELETE FROM replaceablecomprecord_V1"
#define DB_QUERY_DELETE_OLDEST_ROWID    "DELETE FROM replaceablecomprecord_V1 WHERE ROWID = (SELECT ROWID FROM replaceablecomprecord_V1 ORDER BY ROWID LIMIT 1)"
#define DB_QUERY_COUNT_ROWS             "SELECT COUNT(*) FROM replaceablecomprecord_V1"
#define DB_QUERY_SELECT                 "SELECT rowid,* FROM replaceablecomprecord_V1"

ReplaceableCompRecordSql::ReplaceableCompRecordSql(QObject *parent) : QObject(parent)
{

}

ReplaceableCompRecordSql::~ReplaceableCompRecordSql()
{
    QSqlDatabase::removeDatabase(m_connectionName);
}

bool ReplaceableCompRecordSql::init(const QString &uniqConnectionName, const QString &fileName)
{
    qDebug () << __FUNCTION__ << thread();

    m_connectionName = uniqConnectionName.isEmpty() ? DEFAULT_CONNECTION_NAME : uniqConnectionName;

    QSqlDatabase m_dataBase;
    m_dataBase = QSqlDatabase::addDatabase("QSQLITE", m_connectionName);

    QString targetLocation = fileName;
    if(fileName.isEmpty()) {
        QString dataPath = QStandardPaths::writableLocation(QStandardPaths::DataLocation);
        targetLocation = dataPath + "/" + DEFAULT_DB_LOCATION;
        //qDebug() << defaultTargetLocation;
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

bool ReplaceableCompRecordSql::queryInsert(const QVariantMap data)
{
    qDebug () << __FUNCTION__ << thread();

    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    bool prepared = query.prepare(DB_QUERY_ADD);
    Q_UNUSED(prepared)
    //    qDebug() << prepared;

    for(short i=TableHeaderEnum::TH_UnitModel; i<TableHeaderEnum::TH_Total; i++)
        query.addBindValue(data[m_tableHeaderString[i]].toString());

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

bool ReplaceableCompRecordSql::querySelect(QStringList *data, const QString &dbQueryConfig)
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
        QStringList dataItem;
        while(query.next()){
            //qDebug() << "query" << query.size();
            for(short i=TableHeaderEnum::TH_ROWID; i<TableHeaderEnum::TH_Total; i++)
                dataItem.append(query.value(i).toString());
        }//
        *data = dataItem;
    }//
    //    else{
    //        qWarning() << __func__ << query.lastError().text();
    //    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

bool ReplaceableCompRecordSql::queryCount(int *count)
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

QString ReplaceableCompRecordSql::lastQueryErrorStr() const
{
    return m_queryLastErrorStr;
}

QString ReplaceableCompRecordSql::getParameterStringFromIndex(short value)
{
    //    qDebug () << __FUNCTION__ << value << thread();
    /// Row Id not used
    return m_tableHeaderString[value];
}

short ReplaceableCompRecordSql::getParameterIndexFromString(const QString value)
{
    short index = 0;
    for(short i=0; i<TH_Total; i++){
        if(m_tableHeaderString[i] == value){
            index = i;
            break;
        }
    }//
    return index;
}

short ReplaceableCompRecordSql::getMaximumParameter() const
{
    return (TH_Total);
}//

bool ReplaceableCompRecordSql::queryDelete(const QString &dbQueryConfig)
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

bool ReplaceableCompRecordSql::queryDeleteOldestRowId()
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
