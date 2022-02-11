#pragma once

#include <QObject>

class RegisterExternalResources : public QObject
{
    Q_OBJECT
public:
    explicit RegisterExternalResources(QObject *parent = nullptr);

    Q_INVOKABLE bool importResource();
    Q_INVOKABLE bool releaseResource();
    Q_INVOKABLE bool setResourcePath(short pathCode);
    Q_INVOKABLE short getResourcePathCode();

signals:

private:
    QString m_resourcePath;
    short m_pathCode = 0;
    enum PathCode{Resource_QuickTourAsset, Resource_General};
};

