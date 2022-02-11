#pragma once

#include "../ClassManager.h"
#include "EventLogSql.h"

class EventLog : public ClassManager
{
    Q_OBJECT
public:
    explicit EventLog(QObject *parent = nullptr);

    void routineTask(int parameter = 0 ) override;

    EventLogSql *getPSqlInterface() const;
    void setPSqlInterface(EventLogSql *value);

signals:
    void rowCountChanged(int count);

private:
    EventLogSql *pSqlInterface = nullptr;

    int m_rowCount = 0;

};

