#pragma once

#include <QObject>
#include <QDebug>
#include <QVariant>
#include <QScopedPointer>
#include "UserManageSql.h"

//class UserManageSql;

class UserManageQmlApp : public QObject
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
public:
    explicit UserManageQmlApp(QObject *parent = nullptr);

    bool getInitialized() const;
    void setInitialized(bool initialized);

    bool getLastQueryError() const;

    int getDelayEmitSignal() const;
    void setDelayEmitSignal(int delayEmitSignal);

public slots:
    void init(const QString &uniqConnectionName = QString(), const QString &fileName = QString());
    void initDefaultUserAccount();
    void addUser(const QString username,
                 const QString password,
                 int role,
                 const QString fullName,
                 const QString email);
    void updateUserExcludePassword(const QString username,
                                   int role,
                                   const QString fullName,
                                   const QString email);
    void updateUserIncludePassword(const QString username,
                                const QString password,
                                int role,
                                const QString fullName,
                                const QString email);
    void selectDescendingWithPagination(short limit, short pageNumber);
    void selectUserByUsername(const QString username);
    void deleteByUsername(const QString username);
    void deleteAll();

    void checkUsernameAvailability(const QString username);

    void setLastQueryError(bool lastQueryError);

signals:
    void initializedChanged(bool initialized);
    void selectHasDone(bool success, QVariantList dataBuffer, int total);
    void deleteHasDone(bool success, int totalAfterDelete);
    void usernameAvailabilityHasChecked(bool success, bool available, const QString username);
    void userWasAdded(bool success, const QString fullName);
    void userUpdatedExcludePassword(bool success, const QString username);
    void userUpdatedIncludePassword(bool success, const QString username);
    void userUpdated(bool success, const QString username);
    void superAdminHasInitialized(bool success, short status); /// status; 0 = already initialized, 1 = new initialized
    void userSelectedByUsernameHasExecuted(bool success, bool exist, const QVariantMap user);

    void lastQueryErrorChanged(bool lastQueryError);

    void delayEmitSignalChanged(int delayEmitSignal);

private:
    QThread *m_pThread = nullptr;
//    UserManageSql *m_pSql = nullptr;
    QScopedPointer<UserManageSql> m_pSql;

    bool m_initialized = false;
    bool m_lastQueryError = false;

    int m_delayEmitSignal = 0;
};

