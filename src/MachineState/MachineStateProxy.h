#pragma once

#include <QObject>
#include <QScopedPointer>
#include <QThread>
#include <QTimer>

#include "MachineEnums.h"

class MachineState;
class MachineData;

class QQmlEngine;
class QJSEngine;

class MachineStateProxy : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int count
               READ getCount
               NOTIFY countChanged)

    Q_ENUM(MachineEnums::EnumItemState);

public:
    explicit MachineStateProxy(QObject *parent = nullptr);
    ~MachineStateProxy();

    static QObject *singletonProvider(QQmlEngine *qmlEngine, QJSEngine *);

    int getCount() const;

signals:

    void countChanged(int count);

public slots:
    void initSingleton();
    void setup(QObject *pData);
    void stop();

private slots:
    void doStopping();

private:
    QScopedPointer<QTimer>          m_timerEventForMachineState;
    QScopedPointer<QThread>         m_machineStateThread;
    QScopedPointer<MachineState>    m_machineState;

    MachineData*                    pMachineData;
    int m_count;
};

