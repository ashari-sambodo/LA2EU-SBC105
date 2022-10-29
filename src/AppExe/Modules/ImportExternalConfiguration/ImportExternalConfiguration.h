#ifndef IMPORTEXTERNALCONFIGURATION_H
#define IMPORTEXTERNALCONFIGURATION_H

#include <QObject>
#include <QScopedPointer>
#include <QDebug>
#include <QUrl>
#include <QFile>
#include <QJsonObject>
#include <QJsonDocument>
#include <QTextStream>
#include <QString>

class ImportExternalConfiguration : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool initialized
               READ getInitialized
               //               WRITE setInitialized
               NOTIFY initializedChanged)

public:
    explicit ImportExternalConfiguration(QObject *parent = nullptr);

    bool getInitialized() const;
    void setInitialized(bool initialized);

public slots:
    void init();
    void importConfig(QString pathsource);

signals:
    void initializedChanged(bool initialized);
    void configHasBeenImported(bool state);

private:
    QThread *m_pThread = nullptr;
    QScopedPointer<ImportExternalConfiguration> m_importer;
    bool m_initialized      = false;
};

#endif // IMPORTEXTERNALCONFIGURATION_H
