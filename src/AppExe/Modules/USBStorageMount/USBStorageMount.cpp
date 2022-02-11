#include "USBStorageMount.h"
#include <QDebug>

#include <QThread>
#include <QProcess>

#include <QDir>

USBStorageMount::USBStorageMount(QObject *parent) : QObject(parent)
{
    //    m_thread = nullptr;
}

USBStorageMount::~USBStorageMount()
{
    //    if(m_thread != nullptr){
    //        m_thread->terminate();
    //    }
}

QString USBStorageMount::getTargetPath() const
{
    return m_targetPath;
}

QString USBStorageMount::getSourceDevice() const
{
    return m_sourceDevice;
}

QStringList USBStorageMount::getDevices() const
{
    return m_devices;
}

bool USBStorageMount::getBussy() const
{
    return m_bussy;
}

void USBStorageMount::mountAllAsync()
{
    //    qDebug() << __FUNCTION__ << QThread::currentThreadId();

    if(!m_thread.isNull()) if(m_thread->isRunning()) return;

    m_thread.reset(QThread::create([=]{

        /// in the embedded device, parameter sd??* is configured the system only looking for devices such as /dev/sda1, /dev/sdb1 and so on.
        /// internal storage will be mapping to /dev/mmcblk0 but external storage will be mapping to /dev/sdXX. XX is variable set by linux system.
        QStringList currentDevices = findDevices("sd??*");

#ifndef __arm__
        /// dont include main drive sda1
        /// because that one is programmer harddisk :)
        int index = currentDevices.indexOf("sda1");
        if(index >= 0){
            currentDevices.removeAt(index);
        }
#endif
        /// Cleanup
        /// Delete all the entries on the target directory
        /// if the entries not mountpoint
        foreach(QFileInfo item, QDir(m_targetPath).entryInfoList(QDir::AllEntries | QDir::NoDotAndDotDot | QDir::System)){
            //            qDebug() << "QFileInfo" << item.filePath();
            if(item.isDir()){
                /// umount all available disk
                if(isMounted(item.filePath())){
                    umountDevice(item.filePath());
                }
                /// ensure the folder want to delete is not mountpoint
                if(!isMounted(item.filePath())){
                    /// delete the folder
                    //                    qDebug() << "remove" << item.filePath();
                    QDir().rmdir(item.filePath());
                }
            }
            else {
                QFile::remove(item.filePath());
            }
        }

        /// Mount All available devices usb storage
        foreach (QString item, currentDevices) {
            bool mounted = isMounted("/dev/" + item);
            if (!mounted) {
                /// take 2 last character from device, the append to target directory
                /// example result: /media/usbstorage/disk-a1
                QDir targetDir = QDir(m_targetPath + "/disk-" + item.right(2));
                if (!targetDir.exists()){
                    targetDir.mkpath(targetDir.path());
                }
                /// do mount the device
                if (targetDir.exists()){
                    mountDevice("/dev/" + item, targetDir.path());
                }
            }
        }

        /// Give signal to tell GUI about status mounting
        if(m_devices != currentDevices){
            emit devicesChanged(currentDevices);
        }
        emit mountFinished();

    }));

    QObject::connect(m_thread.data(), &QThread::started, [=]{
        setBussy(true);
    });
    QObject::connect(m_thread.data(), &QThread::finished, [=]{
        setBussy(false);
    });
    //    QObject::connect(m_thread.data(), &QThread::finished, [=]{
    //        qDebug() << "m_thread has finished";
    //    });
    //    QObject::connect(m_thread.data(), &QThread::destroyed, [=]{
    //        qDebug() << "m_thread will destroyed";
    //    });

    m_thread->start();
}

void USBStorageMount::setTargetPath(QString targetPath)
{
    if (m_targetPath == targetPath)
        return;

    m_targetPath = targetPath;
    emit targetPathChanged(m_targetPath);
}

void USBStorageMount::setSourceDevice(QString sourceDevice)
{
    if (m_sourceDevice == sourceDevice)
        return;

    m_sourceDevice = sourceDevice;
    emit sourceDeviceChanged(m_sourceDevice);
}

void USBStorageMount::setBussy(bool bussy)
{
    if (m_bussy == bussy)
        return;

    m_bussy = bussy;
    emit bussyChanged(m_bussy);
}

bool USBStorageMount::isMounted(const QString &devpath)
{
//    qDebug() << __FUNCTION__ << QThread::currentThreadId() << devpath;

    QProcess qprocess;
    /// existCode
    /// 1 == not mounted
    /// 0 == mounted
    qprocess.start("findmnt", QStringList() << "-rno" << "SOURCE,TARGET" << devpath);
    qprocess.waitForFinished();

    bool mounted = false;
    if (qprocess.readAllStandardOutput().length()){
        mounted = true;
    }

//    qDebug() << mounted;

    return mounted;
}

QStringList USBStorageMount::findDevices(const QString &regexpFilter)
{
    //    qDebug() << __FUNCTION__ << QThread::currentThreadId() << regexpFilter;

    QProcess qprocess;
    qprocess.start("lsblk", QStringList() << "-n" << "-o" << "KNAME");
    qprocess.waitForFinished();

    //    qDebug() << "exitCode" << qprocess.exitCode();

    /// command was executed succesfully
    if (qprocess.exitCode() == QProcess::NormalExit){
        QString result = qprocess.readAllStandardOutput();
        //        qDebug() << "result" << result;

        QRegExp rx(regexpFilter);
        rx.setPatternSyntax(QRegExp::Wildcard);

        QStringList devices = result.split("\n", Qt::SkipEmptyParts).filter(rx);

        //        qDebug() << "devices"  << devices;

        return devices;
    }

    return QStringList();
}

bool USBStorageMount::mountDevice(const QString &source, const QString &target)
{
    //    qDebug() << __FUNCTION__ << source << target;

    QProcess qprocess;
    qprocess.start("mount", QStringList() << source << target);
    qprocess.waitForFinished();

    //    qDebug() << "exitCode" << qprocess.exitCode();

    if (qprocess.exitCode() == QProcess::NormalExit) {
        //        qDebug() << "result" << qprocess.readAllStandardOutput();;

        return true;
    }
    else {
        //        qDebug() << qprocess.readAllStandardError();
    }
    return false;
}

bool USBStorageMount::umountDevice(const QString &mountpoint)
{
    //    qDebug() << __FUNCTION__ << mountpoint;

    QProcess qprocess;
    qprocess.start("umount", QStringList() << mountpoint);
    qprocess.waitForFinished();

    //    qDebug() << "exitCode" << qprocess.exitCode();

    if (qprocess.exitCode() == QProcess::NormalExit) {
        //        qDebug() << "result" << qprocess.readAllStandardOutput();

        return true;
    }
    else {
        //        qDebug() << qprocess.readAllStandardError();
    }
    return false;
}
