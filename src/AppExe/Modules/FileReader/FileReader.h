#pragma once

#include <QObject>
#include <QScopedPointer>
#include <QThread>

class FileReader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString fileOutput READ getFileOutput NOTIFY fileOutputChanged)

public:
    explicit FileReader(QObject *parent = nullptr);

    QString getFileOutput() const;
    void setFileOutput(const QString &value);

signals:
    void fileOutputChanged(const QString value);

public slots:
    void setFilePath(QString value);
    bool readFile();

private:
    QString m_fileOutput;
    QString m_filePath;
};
