#pragma once

#include <QObject>
#include <QScopedPointer>
#include <QDebug>

class UsbCopier : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int progressInPercent
               READ getProgressInPercent
               WRITE setProgressInPercent
               NOTIFY progressInPercentChanged)

    Q_PROPERTY(bool copying
               READ getCopying
               WRITE setCopying
               NOTIFY copyingChanged)
public:
    explicit UsbCopier(QObject *parent = nullptr);
    ~UsbCopier();

    int getProgressInPercent() const;
    void setProgressInPercent(int progressInPercent);

    bool getCopying() const;
    void setCopying(bool copying);

public slots:
    void copy(const QString source, const QString destination, bool withMd5Sum = true);
    void remove(const QString source);
    void setCancel();

signals:
    void fileHasCopied(bool copied, const QString source, const QString destination);

    void progressInPercentChanged(int progressInPercent);

    void copyingChanged(bool copying);

private:
    qint64 m_chunkSize;
    int m_progressInPercent;
    bool m_cancel;
    bool m_copying;
};

