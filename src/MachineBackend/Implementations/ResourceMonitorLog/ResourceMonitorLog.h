#pragma once

#include "../ClassManager.h"
#include "ResourceMonitorLogSql.h"

class ResourceMonitorLog : public ClassManager
{
    Q_OBJECT
public:
    explicit ResourceMonitorLog(QObject *parent = nullptr);

    void routineTask(int parameter = 0 ) override;

    ResourceMonitorLogSql *getPSqlInterface() const;
    void setPSqlInterface(ResourceMonitorLogSql *value);

    void checkUSdCardIndustrialType();

signals:
    void rowCountChanged(int count);
    void uSdCardIndustrialTypeChanged(bool value);

private:
    ResourceMonitorLogSql *pSqlInterface = nullptr;

    int m_rowCount = 0;

};

