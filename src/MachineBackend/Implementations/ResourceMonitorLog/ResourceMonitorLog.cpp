//#ifdef __linux__
#include <QProcess>
//#endif

#include "ResourceMonitorLog.h"
#define DB_CONN_NAME "ResourceMonitorLogConnRoutineTask"

ResourceMonitorLog::ResourceMonitorLog(QObject *parent) : ClassManager(parent)
{

}

void ResourceMonitorLog::routineTask(int parameter)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

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

ResourceMonitorLogSql *ResourceMonitorLog::getPSqlInterface() const
{
    return pSqlInterface;
}

void ResourceMonitorLog::setPSqlInterface(ResourceMonitorLogSql *value)
{
    pSqlInterface = value;
}

void ResourceMonitorLog::checkUSdCardIndustrialType()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
#ifdef __linux__
    //    ///Must run Checker in other Thread

    QString sdCardInfo = "";

    QProcess qprocess;
    qprocess.start("cat", QStringList() << "/sys/block/mmcblk0/device/name");
    qprocess.waitForFinished();

    if(!qprocess.exitCode()){
        sdCardInfo = qprocess.readAllStandardOutput();
    }

    sdCardInfo.replace("\n", "");

    qDebug() << "sdCardInfo name" << sdCardInfo;
    if(sdCardInfo == "SA08G"){
        emit uSdCardIndustrialTypeChanged(true);
        qDebug() << "USdCardIndustrialType" << true;
    }
    else{
        emit uSdCardIndustrialTypeChanged(false);
        qDebug() << "USdCardIndustrialType" << false;
    }
#else
    emit uSdCardIndustrialTypeChanged(true);
//    qDebug() << "@@@ USdCardIndustrialType" << false;
#endif
}
