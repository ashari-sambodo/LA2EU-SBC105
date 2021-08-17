#pragma once

#include <QObject>
#include <QDebug>
#include <QVariant>
#include <QScopedPointer>
#include "AlarmLogSqlGet.h"

class AlarmLogQmlApp : public QObject
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

    Q_PROPERTY(int pagesCurrentNumber
               READ getPagesCurrentNumber
               WRITE setPagesCurrentNumber
               NOTIFY pagesCurrentNumberChanged)

    Q_PROPERTY(int pagesNextNumber
               READ getPagesNextNumber
               WRITE setPagesNextNumber
               NOTIFY pagesNextNumberChanged)

    Q_PROPERTY(int pagesPreviousNumber
               READ getPagesPreviousNumber
               WRITE setPagesPreviousNumber
               NOTIFY pagesPreviousNumberChanged)

    Q_PROPERTY(int pagesTotal
               READ getPagesTotal
               WRITE setPagesTotal
               NOTIFY pagesTotalChanged)

    Q_PROPERTY(int totalItem
               READ getTotalItem
               WRITE setTotalItem
               NOTIFY totalItemChanged)

    Q_PROPERTY(int pagesItemPerPage
               READ getPagesItemPerPage
               WRITE setPagesItemPerPage
               NOTIFY pagesItemPerPageChanged)
public:
    explicit AlarmLogQmlApp(QObject *parent = nullptr);

    bool getInitialized() const;
    void setInitialized(bool initialized);

    bool getLastQueryError() const;

    int getDelayEmitSignal() const;
    int getPagesCurrentNumber() const;
    int getPagesNextNumber() const;
    int getPagesPreviousNumber() const;
    int getPagesTotal() const;
    int getTotalItem() const;
    int getPagesItemPerPage() const;

public slots:
    void init(const QString &uniqConnectionName = QString(), const QString &fileName = QString());
    //    void insert(const QVariantMap data);
    void selectDescendingWithPagination(int pageNumber);
    void deleteAll();
    void deleteWhereOlderThanDays(int days);

    void setLastQueryError(bool lastQueryError);
    void setDelayEmitSignal(int delayEmitSignal);

    void exportLogs(int pageNumber,
                    const QString exportedDateTime,
                    const QString serialNumber,
                    const QString cabinetModel,
                    int pagesCount = 1);

    void setPagesCurrentNumber(int pagesCurrentNumber);
    void setPagesNextNumber(int pagesNextNumber);
    void setPagesPreviousNumber(int pagesPreviousNumber);
    void setPagesTotal(int pagesTotal);
    void setTotalItem(int totalItem);
    void setPagesItemPerPage(int pagesItemPerPage);

signals:
    void initializedChanged(bool initialized);
    void selectHasDone(bool success, QVariantList logBuffer, int total);
    void deleteHasDone(bool success, int totalAfterDelete);

    void lastQueryErrorChanged(bool lastQueryError);
    void delayEmitSignalChanged(int delayEmitSignal);

    void pagesCurrentNumberChanged(int pagesCurrentNumber);
    void pagesNextNumberChanged(int pagesNextNumber);
    void pagesPreviousNumberChanged(int pagesPreviousNumber);
    void pagesTotalChanged(int pagesTotal);
    void totalItemChanged(int totalItem);
    void pagesItemPerPageChanged(int pagesItemPerPage);

     void logHasExported(bool done, const QString desc);

private:
    QThread *m_pThread = nullptr;
    QScopedPointer<AlarmLogSqlGet> m_pSql;
    bool m_initialized      = false;
    bool m_lastQueryError   = false;

    int m_delayEmitSignal       = 0;
    int m_pagesCurrentNumber    = 1;
    int m_pagesNextNumber       = 1;
    int m_pagesPreviousNumber   = 1;
    int m_pagesTotal            = 1;
    int m_pagesItemPerPage      = 1;
    int m_totalItem             = 0;
};

