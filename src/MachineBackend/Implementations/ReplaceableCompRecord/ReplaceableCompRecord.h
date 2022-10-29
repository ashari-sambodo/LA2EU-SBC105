#pragma once

#include "../ClassManager.h"
#include "ReplaceableCompRecordSql.h"

class ReplaceableCompRecord : public ClassManager
{
    Q_OBJECT
public:
    explicit ReplaceableCompRecord(QObject *parent = nullptr);

    void routineTask(int parameter = 0 ) override;

    ReplaceableCompRecordSql *getPSqlInterface() const;
    void setPSqlInterface(ReplaceableCompRecordSql *value);

    bool getDataFromTableAtRowId(QStringList *data, short rowId);

signals:
    void rowCountChanged(int count);

private:
    ReplaceableCompRecordSql *pSqlInterface = nullptr;

    int m_rowCount = 0;

};

