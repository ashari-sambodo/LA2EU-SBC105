#include "JstoText.h"
#include <QStandardPaths>
#include <QtConcurrent/QtConcurrent>

JstoText::JstoText(QObject *parent) : QObject(parent)
{

}

bool JstoText::getInProgress() const
{
    return m_inProgress;
}

bool JstoText::getNoError() const
{
    return m_noError;
}

void JstoText::write(const QJsonObject json, const QString targetName)
{
    QtConcurrent::run([&, json, targetName]{
        m_noError = true;
        setInProgress(true);
        bool ok = writeSync(json, targetName);

        QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
        QString finalFile = targetDir + "/" + targetName;
        emit exportFinished(ok, finalFile);
        setNoError(ok);
    });
}

void JstoText::setInProgress(bool inProgress)
{
    if (m_inProgress == inProgress)
        return;

    m_inProgress = inProgress;
    emit inProgressChanged(m_inProgress);
}

void JstoText::setNoError(bool noError)
{
    if (m_noError == noError)
        return;

    m_noError = noError;
    emit noErrorChanged(m_noError);
}

bool JstoText::writeSync(const QJsonObject value, const QString targetName)
{    
    //    QFile fileText ("C:/Users/Esco/Desktop/text.txt");
    QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    //    qDebug() << targetDir;

    QString fileName = targetDir + "/" + targetName;
    QFile fileText(fileName);
    if(fileText.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out (&fileText);

        QJsonDocument doc(value);
        QByteArray docByteArray = doc.toJson(QJsonDocument::Compact);
        QString strJson = QLatin1String(docByteArray);
        out << strJson;

        fileText.close();
        return true;
    }
    return false;
}
