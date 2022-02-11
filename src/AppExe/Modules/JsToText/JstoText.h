//#ifndef JSTOTEXT_H
//#define JSTOTEXT_H

#pragma once

#include <QObject>
#include <QScopedPointer>
#include <QDebug>
#include <QUrl>
#include <QFile>
#include <QJsonObject>
#include <QJsonDocument>
#include <QTextStream>
#include <QString>

class JstoText : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool inProgress
               READ getInProgress
               WRITE setInProgress
               NOTIFY inProgressChanged)

    Q_PROPERTY(bool noError
               READ getNoError
               WRITE setNoError
               NOTIFY noErrorChanged)

public:
    explicit JstoText(QObject *parent = nullptr);

    bool getInProgress() const;

    bool getNoError() const;

public slots:
    void write(const QJsonObject json, const QString targetName);

    void setInProgress(bool inProgress);
    void setNoError(bool noError);

signals:
    void exportFinished(bool done, const QString path);

    void inProgressChanged(bool inProgress);

    void noErrorChanged(bool noError);

private:
    bool writeSync(const QJsonObject value, const QString targetName);

    bool m_inProgress = false;
    bool m_noError = true;
};

//#endif // JSTOTEXT_H
