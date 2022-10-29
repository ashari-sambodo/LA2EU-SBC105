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
    void usbHasMounted(QString name);
    void usbHasEjected(QString name);
    void usbDetectedListChanged(QString usbList);

private:
    void _detectUSBConnected();
    int _mountUSBToPath(QString device);
    int _unmountUSBFromPath(QString device);
    void _setUsbDetectedList(QString usbList);

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
