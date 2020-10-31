#pragma once

#include <QObject>
#include <QScopedPointer>


class USBStorageMount : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString targetPath READ getTargetPath WRITE setTargetPath NOTIFY targetPathChanged)
    Q_PROPERTY(QString sourceDevice READ getSourceDevice WRITE setSourceDevice NOTIFY sourceDeviceChanged)
    Q_PROPERTY(QStringList devices READ getDevices NOTIFY devicesChanged)
    Q_PROPERTY(bool bussy READ getBussy WRITE setBussy NOTIFY bussyChanged)

public:
    explicit USBStorageMount(QObject *parent = nullptr);
    ~USBStorageMount();

    QString getTargetPath() const;

    QString getSourceDevice() const;

    QStringList getDevices() const;

    bool getBussy() const;

signals:

    void targetPathChanged(QString targetPath);

    void sourceDeviceChanged(QString sourceDevice);

    void devicesChanged(QStringList devices);

    void mountFinished();

    void bussyChanged(bool bussy);

public slots:
    //    void resfreshDisk();
    //    void mount();
    void mountAllAsync();

    void setTargetPath(QString targetPath);

    void setSourceDevice(QString sourceDevice);

    void setBussy(bool bussy);

private:

    QString m_targetPath;

    QString m_sourceDevice;

    QStringList m_devices;

    //    QThread *m_thread;

    QScopedPointer<QThread> m_thread;

    bool isMounted(const QString &devpath);

    QStringList findDevices(const QString &regexpFilter = QString());

    bool mountDevice(const QString &source, const QString &target);

    bool umountDevice(const QString &mountpoint);

    bool m_bussy;
};
