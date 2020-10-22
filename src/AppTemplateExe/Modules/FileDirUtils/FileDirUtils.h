#pragma once

#include <QObject>
#include <QScopedPointer>
#include <QThread>

class FileDirUtils : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool bussy READ getBussy WRITE setBussy NOTIFY bussyChanged)
public:
    explicit FileDirUtils(QObject *parent = nullptr);

    bool getBussy() const;

signals:
    void clearDirFinished(bool done);

    void bussyChanged(bool bussy);

public slots:
    bool link(const QString source, const QString target);

    bool clearDir(const QString path);

    bool isExist(const QString path);

    void clearDirAsync(const QString &path);

    void setBussy(bool bussy);

    QString qurlToLocalFile(const QString urlString);

private:
    QScopedPointer<QThread> m_thread;
    bool m_bussy;
};
