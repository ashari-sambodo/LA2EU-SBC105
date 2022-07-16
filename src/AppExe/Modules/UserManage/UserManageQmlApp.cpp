#include "UserManageQmlApp.h"
#include <QThread>
#include <QEventLoop>
#include <QDate>
#include <QCryptographicHash>

UserManageQmlApp::UserManageQmlApp(QObject *parent) : QObject(parent)
{

}

bool UserManageQmlApp::getInitialized() const
{
    return m_initialized;
}

void UserManageQmlApp::setInitialized(bool initialized)
{
    if (m_initialized == initialized)
        return;

    m_initialized = initialized;
    emit initializedChanged(m_initialized);
}

bool UserManageQmlApp::getLastQueryError() const
{
    return m_lastQueryError;
}

void UserManageQmlApp::init(const QString &uniqConnectionName, const QString &fileName)
{
    // sanity check dont allow to double created the instance
    if (m_pThread != nullptr) return;

    m_pThread = QThread::create([&, uniqConnectionName, fileName](){
        //        qDebug() << "m_pThread::create" << thread();

        //        m_pSql = new UserManageSql();
        m_pSql.reset(new UserManageSql());
        bool initialized = m_pSql->init(uniqConnectionName, fileName);

        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);

        setInitialized(initialized);

        QEventLoop loop;
        //        connect(this, &UserManageSql::destroyed, &loop, &QEventLoop::quit);
        loop.exec();

        //        qDebug() << "m_pThread::end";
    });

    //// Tells the thread's event loop to exit with return code 0 (success).
    connect(this, &UserManageQmlApp::destroyed, m_pThread, &QThread::quit);
    //    connect(m_pThread, &QThread::finished, m_pThread, [&](){
    //        qDebug() << "Thread has finished";
    //    });
    connect(m_pThread, &QThread::finished, m_pThread, &QThread::deleteLater);
    //    connect(m_pThread, &QThread::destroyed, m_pThread, [&](){
    //        qDebug() << "Thread will destroying";
    //    });
    m_pThread->start();
}

void UserManageQmlApp::initDefaultUserAccount()
{
    //    QMetaObject::invokeMethod(m_pSql, [&](){
    QMetaObject::invokeMethod(m_pSql.data(),
                              [&](){
        //        qDebug() << __func__ << thread();

        QString options = QString(" WHERE username='supervisor'");

        QVariantList dataBuffer;
        int statusCreation = 0;
        bool done = m_pSql->querySelect(&dataBuffer, options);
        setLastQueryError(!done);
        if(done) {
            if (!dataBuffer.length()) {
                /// no super admin yet, let's create new
                QVariantMap data;
                QString password = QString(QCryptographicHash::hash("00005", QCryptographicHash::Md5).toHex());
                data.insert("username", "supervisor");
                data.insert("password", password);
                data.insert("role",     3);
                data.insert("active",   1);
                data.insert("fullname", "Supervisor");
                data.insert("email",    "supervisor@mail.com");
                data.insert("createdAt", QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss"));

                bool done = m_pSql->queryInsert(data);

                /// Create admin
                data.clear();
                password = QString(QCryptographicHash::hash("00001", QCryptographicHash::Md5).toHex());
                data.insert("username", "admin");
                data.insert("password", password);
                data.insert("role",     2);
                data.insert("active",   1);
                data.insert("fullname", "Administrator");
                data.insert("email",    "admin@mail.com");
                data.insert("createdAt", QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss"));

                done = m_pSql->queryInsert(data);

                /// Create operator
                data.clear();
                password = QString(QCryptographicHash::hash("00000", QCryptographicHash::Md5).toHex());
                data.insert("username", "operator");
                data.insert("password", password);
                data.insert("role",     1);
                data.insert("active",   1);
                data.insert("fullname", "Operator");
                data.insert("email",    "operator@mail.com");
                data.insert("createdAt", QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss"));

                done = m_pSql->queryInsert(data);


                setLastQueryError(!done);
                if(!done) {
                    qWarning() << m_pSql->lastQueryErrorStr();
                }
                else {
                    statusCreation = 1; // create new
                }
            }
        }
        else {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        emit superAdminHasInitialized(done, statusCreation);
    });
}

void UserManageQmlApp::addUser(const QString username,
                               const QString password,
                               int role,
                               const QString fullName,
                               const QString email)
{
    QMetaObject::invokeMethod(m_pSql.data(),
                              [&, username, password, role, fullName, email](){
        //        qDebug() << __func__ << thread();

        QVariantMap data;
        data.insert("username", username);
        data.insert("password", password);
        data.insert("role",     role);
        data.insert("active",   1);
        data.insert("fullname", fullName);
        data.insert("email",    email);
        data.insert("createdAt", QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss"));

        bool done = m_pSql->queryInsert(data);
        setLastQueryError(!done);
        if(!done) {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        /// give some dalay to make ui more interactive
        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit userWasAdded(done, fullName);
    });

}

void UserManageQmlApp::updateUserExcludePassword(const QString username,
                                                 int role,
                                                 const QString fullName,
                                                 const QString email)
{
    QMetaObject::invokeMethod(m_pSql.data(),
                              [&, username, role, fullName, email](){
        qDebug() << __func__ << thread();

        bool done = true;
        done &= m_pSql->queryUpdateUserRole(role, username);
        qDebug() << done;
        done &= m_pSql->queryUpdateUserFullname(fullName, username);
        qDebug() << done;
        done &= m_pSql->queryUpdateUserEmail(email, username);
        qDebug() << done;

        if(!done) {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        /// give some dalay to make ui more interactive
        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit userUpdatedExcludePassword(done, username);
        emit userUpdated(done, username);
    });
}

void UserManageQmlApp::updateUserIncludePassword(const QString username,
                                                 const QString password,
                                                 int role,
                                                 const QString fullName,
                                                 const QString email)
{
    QMetaObject::invokeMethod(m_pSql.data(),
                              [&, username, password, role, fullName, email](){
        qDebug() << __func__ << thread();


        bool done = true;
        done &= m_pSql->queryUpdateUserPassword(password, username);
        done &= m_pSql->queryUpdateUserRole(role, username);
        done &= m_pSql->queryUpdateUserFullname(fullName, username);
        done &= m_pSql->queryUpdateUserEmail(email, username);

        if(!done) {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        /// give some dalay to make ui more interactive
        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit userUpdatedIncludePassword(done, username);
        emit userUpdated(done, username);
    });
}

void UserManageQmlApp::selectDescendingWithPagination(short limit, short pageNumber)
{
    qDebug() << __func__ << limit << pageNumber << thread();

    QMetaObject::invokeMethod(m_pSql.data(),
                              [&, limit, pageNumber](){
        qDebug() << __func__ << thread();

        int count = 0;
        m_pSql->queryCount(&count);

        short offset = (limit * pageNumber) - limit;
        QString options = QString().asprintf(" ORDER BY ROWID DESC LIMIT %d OFFSET %d", limit, offset);

        QVariantList dataBuffer, dataReady;
        bool done = m_pSql->querySelect(&dataBuffer, options);
        setLastQueryError(!done);
        if(done) {
            /// Reconstructing every item to JSON/VariantMaplist
            /// so, QML Listview ease to present the data
            QVariantMap item;
            QVariantList itemTemp;
            for(int i=0; i < dataBuffer.length(); i++){
                item.clear();
                itemTemp.clear();

                itemTemp = dataBuffer.at(i).toList();
                //                qDebug() << itemTemp.length();

                item.insert("username", itemTemp.at(0));
                item.insert("password", itemTemp.at(1));
                item.insert("role",     itemTemp.at(2));
                item.insert("active",   itemTemp.at(3));
                item.insert("fullname", itemTemp.at(4));
                item.insert("email",    itemTemp.at(5));
                item.insert("createdAt",itemTemp.at(6));
                item.insert("lastLogin",itemTemp.at(7));

                dataReady.append(item);
            }
        }
        else {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        /// give some dalay to make ui more interactive
        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit selectHasDone(done, dataReady, count);
    });
}

void UserManageQmlApp::selectUserByUsername(const QString username)
{
    QMetaObject::invokeMethod(m_pSql.data(),
                              [&, username](){
        qDebug() << __func__ << thread();

        int count = 0;
        m_pSql->queryCount(&count);

        QString options = QString(" WHERE username='%1'").arg(username);

        QVariantList dataBuffer;
        QVariantMap item;
        bool done = m_pSql->querySelect(&dataBuffer, options);
        setLastQueryError(!done);
        if(done) {
            /// Reconstructing every item to JSON/VariantMaplist
            /// so, QML Listview ease to present the data
            QVariantList itemTemp;
            if(dataBuffer.length() > 0){

                itemTemp = dataBuffer.at(0).toList();
                //                qDebug() << itemTemp.length();

                item.insert("username", itemTemp.at(0));
                item.insert("password", itemTemp.at(1));
                item.insert("role",     itemTemp.at(2));
                item.insert("active",   itemTemp.at(3));
                item.insert("fullname", itemTemp.at(4));
                item.insert("email",    itemTemp.at(5));
                item.insert("createdAt",itemTemp.at(6));
                item.insert("lastLogin",itemTemp.at(7));
            }
        }
        else {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        /// give some dalay to make ui more interactive
        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit userSelectedByUsernameHasExecuted(done, dataBuffer.length(), item);
    });
}

void UserManageQmlApp::deleteByUsername(const QString username)
{
    qDebug() << __func__ << thread();

    QMetaObject::invokeMethod(m_pSql.data(),
                              [&, username](){
        qDebug() << __func__ << thread();

        QString options = QString(" WHERE username='%1'").arg(username);
        bool done = m_pSql->queryDelete(options);
        setLastQueryError(!done);
        if(!done) {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        /// get the total rows after delete
        int count = 0;
        m_pSql->queryCount(&count);

        /// give some dalay to make ui more interactive
        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit deleteHasDone(done, count);
    });
}

void UserManageQmlApp::deleteAll()
{
    qDebug() << __func__ << thread();

    QMetaObject::invokeMethod(m_pSql.data(),
                              [&](){
        qDebug() << __func__ << thread();

        bool done = m_pSql->queryDelete();
        setLastQueryError(!done);
        if(!done) {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        /// get the total rows after delete
        int count = 0;
        m_pSql->queryCount(&count);

        /// give some dalay to make ui more interactive
        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit deleteHasDone(done, count);
    });
}

void UserManageQmlApp::checkUsernameAvailability(const QString username)
{
    QMetaObject::invokeMethod(m_pSql.data(),
                              [&, username](){
        qDebug() << __func__ << thread();


        QString options = QString(" WHERE username='%1'").arg(username);

        QVariantList dataBuffer;
        bool done = m_pSql->querySelect(&dataBuffer, options);
        setLastQueryError(!done);
        if(!done) {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        /// give some dalay to make ui more interactive
        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit usernameAvailabilityHasChecked(done, dataBuffer.length() == 0, username);
    });
}

void UserManageQmlApp::setLastQueryError(bool lastQueryError)
{
    if (m_lastQueryError == lastQueryError)
        return;

    m_lastQueryError = lastQueryError;
    emit lastQueryErrorChanged(m_lastQueryError);
}

int UserManageQmlApp::getDelayEmitSignal() const
{
    return m_delayEmitSignal;
}

void UserManageQmlApp::setDelayEmitSignal(int delayEmitSignal)
{
    m_delayEmitSignal = delayEmitSignal;
}
