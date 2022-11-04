#include <QProcess>
#include <QStandardPaths>
#include <QDir>
#include <QThread>

#include "USBAutoMount.h"

USBAutoMount::USBAutoMount(QObject *parent) : ClassManager(parent)
{

}

void USBAutoMount::routineTask(int parameter)
{
    Q_UNUSED(parameter)

    _detectUSBConnected();
    //getDeviceList();
}

void USBAutoMount::requestEjectUsb(QString device)
{
    qDebug() << __func__ << device;
    m_requestEjectList.append(device);
}

//void USBAutoMount::ejectUsb(QString device)
//{
//    _unmountUSBFromPath(device);
//}

void USBAutoMount::ejectAllUsb()
{
    for(int i = 0; i < m_deviceList.length(); i++){
        _unmountUSBFromPath(m_deviceList[i]);
    }
}

QString USBAutoMount::getDeviceList()
{
    //qDebug() << __func__ << m_deviceList.join(",");
    return m_deviceListStr; //m_deviceList.join(",");
}

void USBAutoMount::_detectUSBConnected()
{
    //qDebug() << __func__ ;
    QProcess qprocess;
    QString output;
#ifdef __linux__
    qprocess.start("lsblk"); //list available disk
    qprocess.waitForFinished();

    output = qprocess.readAllStandardOutput();
    //#else //For debug only
    //output = "NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT\nsda           8:0    1  7.3G  0 disk \n`-sda1        8:1    1  7.3G  0 part \nmmcblk0     179:0    0  7.4G  0 disk \n|-mmcblk0p1 179:1    0   64M  0 part /boot\n|-mmcblk0p2 179:2    0    1G  0 part /\n|-mmcblk0p3 179:3    0    1G  0 part \n|-mmcblk0p4 179:4    0    1K  0 part \n`-mmcblk0p5 179:5    0  5.3G  0 part /data\n";
    //output = "NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT\nsda           8:0    1  7.3G  0 disk \n`-sda1        8:1    1  7.3G  0 part /tmp/media/usb-sda1\nsdb           8:16   1  7.4G  0 disk \n`-sdb1        8:17   1  7.4G  0 part /tmp/media/usb-sdb1\nmmcblk0     179:0    0  7.4G  0 disk \n|-mmcblk0p1 179:1    0   64M  0 part /boot\n|-mmcblk0p2 179:2    0    1G  0 part /\n|-mmcblk0p3 179:3    0    1G  0 part \n|-mmcblk0p4 179:4    0    1K  0 part \n`-mmcblk0p5 179:5    0  5.3G  0 part /data\n";
#endif
    //qDebug() << output;

    //Debug Output
    QStringList listDevices = output.split("\n");

    QStringList deviceList;
    QStringList deviceList_Temp;

    //qDebug() << "Start ListDevices";
    for(int i = 1; i < listDevices.length() - 1; i ++){
        QStringList detailDevices;
        //qDebug() << listDevices[i];
        detailDevices = listDevices[i].split(QRegExp("\\s+"), Qt::SplitBehaviorFlags::SkipEmptyParts);

        //qDebug() << detailDevices;

        if(detailDevices[name].contains(QRegExp("sd[a-z]+\\d+"))){ //Check name sd[a-z][number]
            if(detailDevices[type] == "part"){ // check device partition and mount status
                detailDevices[name].remove(0, 2);
                //deviceList.append(detailDevices[name]);
                deviceList_Temp.append(detailDevices[name]);

                if(detailDevices.length() == mountPoint){
                    //Dont mount if device name still same after unmount
                    bool mount = true;
                    for(int j = 0; j < m_requestEjectList.length(); j++){
                        //qDebug() << "request Eject: " << m_requestEjectList[j];
                        if(detailDevices[name] == m_requestEjectList[j]){
                            mount = false;
                        }
                    }
                    if(mount){
                        //qDebug() << "Mount " << detailDevices[name] << "To Directory";
                        deviceList.append(detailDevices[name]);
                        /*int code = */_mountUSBToPath(detailDevices[name]);
                        //if(code == 0)
                        //    deviceList.append(detailDevices[name]);
                    }
                    else{
                        //qDebug() << "cant mount because prev. has ejected";
                        //qDebug() << "plug out and plug in for get access again";
                    }
                }
                else if(detailDevices.length() == mountPoint + 1){ //If already mounted
                    //qDebug() << "device already mounted";
                    deviceList.append(detailDevices[name]);
                    for(int a = 0; a < m_requestEjectList.length(); a++){
                        if(m_requestEjectList[a] == detailDevices[name]){
                            _unmountUSBFromPath(m_requestEjectList[a]);
                            break;
                        }
                    }
                    //if(m_requestEjectName == detailDevices[name]){
                    //    _unmountUSBFromPath(m_requestEjectName);
                    //}
                }
                else{
                    //qDebug() << "something wrong";
                }
            }

            else {
                //qDebug() << "something wrong";
            }
        }
    }

    //Update to global variable
    m_deviceList = deviceList;

    QString devListStr = m_deviceList.join(",");
    _setUsbDetectedList(devListStr);
    //qDebug() << "Stop ListDevices";

    //Check device list name, match or not with eject list
    //if already gone, remove from eject list
    QStringList m_requestEjectListTemp = m_requestEjectList;
    for(int k = 0; k < m_requestEjectListTemp.length(); k++){
        bool remove = true;
        for(int m = 0; m < deviceList_Temp.length(); m++){
            if(m_requestEjectListTemp[k] != deviceList_Temp[m]){
                //remove from eject list
                remove = true;
            }
            else{
                remove = false;
            }
        }

        if(remove){
            for(int n = 0; n < m_requestEjectList.length(); n++){
                if(m_requestEjectList[n] == m_requestEjectListTemp[k]){
                    m_requestEjectList.removeAt(n);
                    break;
                }
            }
        }
        //m_requestEjectListTemp.removeAt(k);
    }
}

int USBAutoMount::_mountUSBToPath(const QString &device)
{

    QProcess qprocess;
    QString cmd = QString("systemctl start usb-mount@%1.service").arg(device);
    Q_UNUSED(cmd)
    int exitCode = -1;

#ifdef __linux__
    qprocess.start(cmd);
    qprocess.waitForFinished();
    exitCode = qprocess.exitCode();
    if(exitCode == 0){
        emit usbHasMounted(device);
    }
#endif
    //emit usbHasMounted(device);
    return exitCode;
    //emit usbHasMounted(device);
    //qDebug() << "Exit Code:" << exitCode;
}

int USBAutoMount::_unmountUSBFromPath(const QString &device)
{
    qDebug() << __func__ << device;
    QProcess qprocess;
    QString cmd = QString("systemctl stop usb-mount@%1.service").arg(device);
    Q_UNUSED(cmd)
    int exitCode = -1;

#ifdef __linux__
    qprocess.start(cmd);
    qprocess.waitForFinished();
    exitCode = qprocess.exitCode();
    if(exitCode == 0){
        emit usbHasEjected(device);
    }
#endif
    //emit usbHasEjected(device);
    return exitCode;
    //    m_requestEjectName = "";
    //qDebug() << "Exit Code:" << exitCode;
}

void USBAutoMount::_setUsbDetectedList(const QString &usbList)
{
    if(m_deviceListStr == usbList)
        return;
    m_deviceListStr = usbList;
    emit usbDetectedListChanged(m_deviceListStr);
}
