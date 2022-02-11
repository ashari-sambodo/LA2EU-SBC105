#include "UsbCopier.h"
#include <QDir>
#include <QFile>
#include <QtConcurrent/QtConcurrent>

#define DEFAULT_CHUNK_SIZE 1024 * 1024 * 1; /// 1MB
//#define DEFAULT_CHUNK_SIZE 1024 * 1; /// 1 KB

UsbCopier::UsbCopier(QObject *parent) : QObject(parent)
{
    m_chunkSize = DEFAULT_CHUNK_SIZE;
    m_progressInPercent = 0;
    m_cancel = false;
    m_copying = false;
}

UsbCopier::~UsbCopier()
{
    m_cancel = true;
}

int UsbCopier::getProgressInPercent() const
{
    return m_progressInPercent;
}

void UsbCopier::copy(const QString source, const QString destination, bool withMd5Sum)
{
    qDebug()<<"copy from"<< source << "to" << destination;
    QFuture<void> future = QtConcurrent::run([&, source, destination]{
        setCopying(true);
        //        bool copied = QFile::copy(source, destination);
        /// remove destination if exist
        if(QFile::exists(destination)){
            QFile::remove(destination);
        }

        QFile srcFile(source);
        if (!srcFile.open(QIODevice::ReadOnly)){
            qWarning() << "failed to open source file";

            emit fileHasCopied(false, source, destination);
            setCopying(false);

            return ;
        }

        QFile dstFile(destination);
        if (!dstFile.open(QIODevice::WriteOnly)){
            qWarning() << "failed to initiate destination file";

            emit fileHasCopied(false, source, destination);
            setCopying(false);

            return ;
        }

        /// copy the content in portion of chuck file (buffer)
        qint64 fSize = srcFile.size();
        qint64 fSizeInfo = fSize;
        while (fSize) {
            /// read from source
            const auto data = srcFile.read(m_chunkSize);
            /// write to destination
            const auto _written = dstFile.write(data);
            /// calculate progress
            if (data.size() == _written) {
                fSize -= data.size();
            }
            else {
                qWarning() << "failed to write";
                break;
            }
            int percent = 100 - qRound(((qreal(fSize) / qreal(fSizeInfo)) * 100.0));
            qDebug() << fSize <<  percent;
            setProgressInPercent(percent);

            if (m_cancel) {
                break;
            }

            QThread::msleep(500);
        }

        if(withMd5Sum){
            qDebug() << metaObject()->className() << __func__ << "gen-md5sumhex";
            /// generate the md5sum for error check and validation
            QCryptographicHash hash(QCryptographicHash::Md5);
            srcFile.seek(0); /// this veri important to set position cursor and make hashing correct
            if (hash.addData(&srcFile)) {
                QString md5sumhex = QLatin1String(hash.result().toHex());
                qDebug() << metaObject()->className() << __func__ << "md5sumhex" << md5sumhex;

                QFile fileMd5Sum(destination + ".md5");
                if(fileMd5Sum.open(QIODevice::WriteOnly)){
                    QTextStream textStrem(&fileMd5Sum);
                    textStrem << md5sumhex;
                }
                fileMd5Sum.close();
            }
        }

        srcFile.close();
        dstFile.close();

        emit fileHasCopied(fSize == 0, source, destination);
        setCopying(false);
    });
}

void UsbCopier::setProgressInPercent(int progressInPercent)
{
    if (m_progressInPercent == progressInPercent)
        return;

    m_progressInPercent = progressInPercent;
    emit progressInPercentChanged(m_progressInPercent);
}

bool UsbCopier::getCopying() const
{
    return m_copying;
}

void UsbCopier::setCancel()
{
    m_cancel = true;
}

void UsbCopier::setCopying(bool copying)
{
    if (m_copying == copying)
        return;

    m_copying = copying;
    emit copyingChanged(m_copying);
}
