#pragma once

#include <QObject>
#include <QDebug>
#include <QVariant>
#include <QScopedPointer>
#include "BookingScheduleSqlGet.h"

class BookingScheduleSqlGet;

class BookingScheduleQmlApp : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool initialized
               READ getInitialized
               //               WRITE setInitialized
               NOTIFY initializedChanged)

    Q_PROPERTY(bool lastQueryError
               READ getLastQueryError
               WRITE setLastQueryError
               NOTIFY lastQueryErrorChanged)

    Q_PROPERTY(int delayEmitSignal
               READ getDelayEmitSignal
               WRITE setDelayEmitSignal
               NOTIFY delayEmitSignalChanged)

    Q_PROPERTY(int totalRows
               READ getTotalRows
               WRITE setTotalRows
               NOTIFY totalRowsChanged)

public:
    explicit BookingScheduleQmlApp(QObject *parent = nullptr);

    bool getInitialized() const;
    bool getLastQueryError() const;
    int getDelayEmitSignal() const;
    int getTotalRows() const;

    Q_INVOKABLE int getMaximumRows() const;
    Q_INVOKABLE bool isRowsHasMaximum() const;

public slots:
    void init(const QString &uniqConnectionName = QString(), const QString &fileName = QString());
    void insert(const QVariantMap data);
    void insertFromList(const QVariantList dataList);
    void selectByDate(const QString dateStr);
    void deleteByDateTime(const QString dateStr, const QString timeStr);
    void deleteAll();
    void deleteWhereOlderThanDays(int days);

    void setLastQueryError(bool lastQueryError);
    void setDelayEmitSignal(int delayEmitSignal);
    void setInitialized(bool initialized);

    void exportData(const QString targetDate,
                    const QString exportedDateTime,
                    const QString serialNumber,
                    const QString cabinetModel);

    void setTotalRows(int totalRow);

signals:
    void initializedChanged(bool initialized);
    void selectHasDone(bool success, QVariantList logBuffer, int total);
    void deleteHasDone(bool success, int totalAfterDelete);
    void insertedHasDone(bool success, QVariantMap data);
    void insertedHasDone(bool success, QVariantList data);

    void lastQueryErrorChanged(bool lastQueryError);

    void delayEmitSignalChanged(int delayEmitSignal);

    void dataHasExported(bool done, const QString desc);

    void totalRowsChanged(int totalRow);

private:
    QThread *m_pThread = nullptr;
    QScopedPointer<BookingScheduleSqlGet> m_pSql;
    bool m_initialized = false;
    bool m_lastQueryError = false;

    int m_delayEmitSignal = 0;
    int m_totalRows = 0;
};
