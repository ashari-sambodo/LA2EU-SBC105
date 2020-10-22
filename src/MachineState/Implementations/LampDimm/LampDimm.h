#ifndef LAMPDIMMMANAGER_H
#define LAMPDIMMMANAGER_H

#include "../ClassManager.h"
#include "BoardIO/Drivers/AOmcp4725/AOmcp4725.h"

class LampDimmManager : public ClassManager
{
    Q_OBJECT
public:
    explicit LampDimmManager(QObject *parent = nullptr);

    void worker(int parameter = 0) override;

    void setSubModule(AOmcp4725 *obj);
    void setIntensity(int val);

signals:
    void intensityChanged(int newVal);
    void adcChanged(int newVal);

private:
    AOmcp4725 * pSubModule;

    int m_intensity;
    int m_adc;
    int m_adcRequest;

    int adcToIntensity(int adc);
    int intensityToAdc(int percent);
    int mapToVal(int val, int inMin, int inMax, int outMin, int outMax);
};

#endif // LAMPDIMMMANAGER_H
