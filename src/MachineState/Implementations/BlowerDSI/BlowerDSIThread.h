#ifndef BLOWERECMCOMMWORKER_H
#define BLOWERECMCOMMWORKER_H

#include <QObject>
#include <QThread>
#include <QSharedPointer>
#include <QTimer>
#include "BlowerDSI.h"

class BlowerDSIWorker : public QObject
{
    Q_OBJECT
public:
    explicit BlowerDSIWorker(QObject *parent = nullptr);
    ~BlowerDSIWorker();
    void setBlowerECM(BlowerDSIManager *pointer);
    void setSpeed(long newVal);
    void setInterlock(long newVal);

signals:
    void speedChanged(int newVal);
    void speedRPMChanged(int newVal);
    void interlockChanged(int newVal);
    void errorComCountChanged(int newVal);

public slots:
    void setup();
    void stopEventLoopTimer();

    void _onSpeedChanged(int newVal);
    void _onSpeedRPMChanged(int newVal);
    void _onInterlockChanged(int newVal);
    void _onErrorComCountChanged(int newVal);

private:
    void loop();
    BlowerDSIManager                    *pBlowerECM;
    QSharedPointer<QTimer>              m_timerEvent;
    QSharedPointer<QTimer>              m_timerDelayEmit;

};

#endif // BLOWERECMCOMMWORKER_H
