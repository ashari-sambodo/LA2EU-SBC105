#include "ReplaceableCompRecord.h"
#define DB_CONN_NAME "ReplaceableCompRecordConnRoutineTask"

ReplaceableCompRecord::ReplaceableCompRecord(QObject *parent) : ClassManager(parent)
{

}

void ReplaceableCompRecord::routineTask(int parameter)
{
    qDebug() << __func__ << thread();

    Q_UNUSED(parameter)

    if(!pSqlInterface) return;

    /// initial sql connection
    bool initialized = pSqlInterface->init(DB_CONN_NAME);
    Q_UNUSED(initialized);
    //    qDebug() << __func__ << "initialDb" << initialized << thread();

    int count;
    pSqlInterface->queryCount(&count);

    if(m_rowCount != count){
        m_rowCount = count;

        emit rowCountChanged(count);
    }

    /// wait until explicity called 'quit'
    /// here will called eventloop object and listen any event request
    exec();
}

ReplaceableCompRecordSql *ReplaceableCompRecord::getPSqlInterface() const
{
    return pSqlInterface;
}

void ReplaceableCompRecord::setPSqlInterface(ReplaceableCompRecordSql *value)
{
    pSqlInterface = value;
}

bool ReplaceableCompRecord::getDataFromTableAtRowId(QStringList *data, short rowId)
{
    //short offset = rowId;
    QString options = QString().asprintf(" WHERE ROWID = %d", rowId);
    QStringList logBuffer;
    bool done = pSqlInterface->querySelect(&logBuffer, options);
    if(done) {
        qDebug() << "logBuffer length:" << logBuffer.length();
    }
    else {
        qWarning() << pSqlInterface->lastQueryErrorStr();
    }
    *data = logBuffer;
    return done;
}//
