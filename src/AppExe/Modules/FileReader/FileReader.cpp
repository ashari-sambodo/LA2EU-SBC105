#include "FileReader.h"
#include <QDir>
#include <QDebug>

FileReader::FileReader(QObject *parent) : QObject(parent)
{

}

QString FileReader::getFileOutput() const
{
    return m_fileOutput;
}

void FileReader::setFileOutput(const QString &value)
{
    if(m_fileOutput == value)return;
    m_fileOutput = value;
    emit fileOutputChanged(value);
}

void FileReader::setFilePath(QString value)
{
    if(m_filePath == value)return;
    m_filePath = value;
}

bool FileReader::readFile()
{
    if(m_filePath.isEmpty()) {
        qDebug() << "m_filePath is not set!";
        return false;
    }

    QByteArray fileData;
    QString fileString;

    QFile fileToBeRead(m_filePath);

    if(fileToBeRead.exists()){
        if(fileToBeRead.open(QIODevice::ReadOnly | QIODevice::Text)){
            fileData = fileToBeRead.readAll();
            fileString = fileData;
            fileToBeRead.close();
        }
    }else{
        qDebug() << m_filePath << "is not exist";
        return false;
    }
    setFileOutput(fileString);
    return true;
}
