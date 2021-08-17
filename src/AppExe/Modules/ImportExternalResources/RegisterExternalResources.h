#pragma once

#include <QObject>

class RegisterExternalResources : public QObject
{
    Q_OBJECT
public:
    explicit RegisterExternalResources(QObject *parent = nullptr);

    Q_INVOKABLE bool importResource();
    Q_INVOKABLE bool releaseResource();

signals:

private:
    QString m_resourcePath;

};

