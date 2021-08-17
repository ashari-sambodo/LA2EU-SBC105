#pragma once

#include "../ClassManager.h"
#include "AlarmLogSql.h"

class AlarmLog : public ClassManager
{
    Q_OBJECT
public:
    explicit AlarmLog(QObject *parent = nullptr);

    void routineTask(int parameter = 0 ) override;

    AlarmLogSql *getPSqlInterface() const;
    void setPSqlInterface(AlarmLogSql *value);

signals:
    void rowCountChanged(int count);

private:
    AlarmLogSql *pSqlInterface = nullptr;

    int m_rowCount = 0;

};

