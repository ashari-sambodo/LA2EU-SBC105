#pragma once

#include "../ClassManager.h"
#include "DataLogSql.h"

class DataLog : public ClassManager
{
    Q_OBJECT
public:
    explicit DataLog(QObject *parent = nullptr);

    void routineTask(int parameter = 0 ) override;

    DataLogSql *getPSqlInterface() const;
    void setPSqlInterface(DataLogSql *value);

signals:
    void rowCountChanged(int count);

private:
    DataLogSql *pSqlInterface = nullptr;

    int m_rowCount = 0;

};

