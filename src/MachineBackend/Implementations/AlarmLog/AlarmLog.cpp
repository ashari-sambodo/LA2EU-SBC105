#include "AlarmLog.h"
#define DB_CONN_NAME "AlarmLogConnRoutineTask"

AlarmLog::AlarmLog(QObject *parent) : ClassManager(parent)
{

}

void AlarmLog::routineTask(int parameter)
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

AlarmLogSql* AlarmLog::getPSqlInterface() const
{
    return pSqlInterface;
}

void AlarmLog::setPSqlInterface(AlarmLogSql *value)
{
     pSqlInterface = value;
}
