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

signals:
    void rowCountChanged(int count);

private:
    ResourceMonitorLogSql *pSqlInterface = nullptr;

    int m_rowCount = 0;

};

