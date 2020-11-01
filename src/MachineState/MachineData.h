#pragma once

#include <QObject>

class QQmlEngine;
class QJSEngine;

class MachineData : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int blowerEcmDemandMode
               READ getBlowerEcmDemandMode
               //               WRITE setBlowerEcmDemandMode
               NOTIFY blowerEcmDemandModeChanged)

    Q_PROPERTY(int count
               READ getCount
               //               WRITE setDataCount
               NOTIFY countChanged)

    Q_PROPERTY(int machineState
               READ getMachineState
               //               WRITE setDataWorkerState
               NOTIFY machineStateChanged)

    Q_PROPERTY(bool hasStopped
               READ getHasStopped
               WRITE setHasStopped
               NOTIFY hasStoppedChanged)

public:
    explicit MachineData(QObject *parent = nullptr);
    ~MachineData();

    static QObject *singletonProvider(QQmlEngine *qmlEngine, QJSEngine *);
    static void singletonDelete();

    Q_INVOKABLE short getMachineState() const;
    void setMachineState(short getMachineState);

    int getCount() const;
    void setCount(int count);

    bool getHasStopped() const;

    void setHasStopped(bool hasStopped);

    int getBlowerEcmDemandMode() const;

public slots:
    void initSingleton();

    void setBlowerEcmDemandMode(int blowerEcmDemandMode);

signals:
    void machineStateChanged(int machineState);

    void countChanged(int count);

    void hasStoppedChanged(bool hasStopped);

    void blowerEcmDemandModeChanged(int blowerEcmDemandMode);

private:
    ///
    short m_machineState;

    int m_count;
    bool m_hasStopped;
    int m_blowerEcmDemandMode;
};

