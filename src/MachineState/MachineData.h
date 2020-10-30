#pragma once

#include <QObject>

class QQmlEngine;
class QJSEngine;

class MachineData : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int count
               READ getDataCount
               //               WRITE setDataCount
               NOTIFY dataCountChanged)

    Q_PROPERTY(int machineState
               READ getDataMachineState
               //               WRITE setDataWorkerState
               NOTIFY dataMachineStateChanged)

    Q_PROPERTY(bool hasStopped
               READ getDataHasStopped
               WRITE setDataHasStopped
               NOTIFY hasStoppedChanged)

public:
    explicit MachineData(QObject *parent = nullptr);
    ~MachineData();

    static QObject *singletonProvider(QQmlEngine *qmlEngine, QJSEngine *);
    static void singletonDelete();

    Q_INVOKABLE int getDataMachineState() const;
    void setDataMachineState(int machineState);

    int getDataCount() const;
    void setDataCount(int count);

    bool getDataHasStopped() const;

    void setDataHasStopped(bool hasStopped);

public slots:
    void initSingleton();

signals:
    void dataMachineStateChanged(int machineState);

    void dataCountChanged(int count);

    void hasStoppedChanged(bool hasStopped);

private:
    int m_machineState;

    int m_count;
    bool m_hasStopped;
};

