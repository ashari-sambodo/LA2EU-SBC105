#ifndef USBAUTOMOUNT_H
#define USBAUTOMOUNT_H

#include "../ClassManager.h"

class USBAutoMount : public ClassManager
{
    Q_OBJECT
public:
    explicit USBAutoMount(QObject *parent = nullptr);

    void routineTask(int parameter = 0) override;

    void requestEjectUsb(QString device);

    //void ejectUsb(QString name);
    void ejectAllUsb();

    QString getDeviceList();

signals:
    //void usbHasDetected(QString device);
    void usbHasMounted(const QString &name);
    void usbHasEjected(const QString &name);
    void usbDetectedListChanged(const QString &usbList);

private:
    void _detectUSBConnected();
    int _mountUSBToPath(const QString &device);
    int _unmountUSBFromPath(const QString &device);
    void _setUsbDetectedList(const QString &usbList);

    enum{
        name,
        majMin,
        rm,
        size,
        ro,
        type,
        mountPoint
    };

    QStringList m_deviceList;
    QString m_deviceListStr;

    QStringList m_requestEjectList;
    QString m_requestEjectName;
};

#endif // USBAUTOMOUNT_H
