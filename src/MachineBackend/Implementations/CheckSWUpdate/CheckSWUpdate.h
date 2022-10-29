#pragma once

#include <QCryptographicHash>
#include "../ClassManager.h"
#include <QJsonObject>
#include <QDir>

class CheckSWUpdate : public ClassManager
{
    Q_OBJECT
public:
    explicit CheckSWUpdate(QObject *parent = nullptr);

    void routineTask(int parameter = 0 ) override;

    void setCheckForSWUpdateEnable(bool value);
    bool getCheckForSWUpdateEnable()const;

    bool setCurrentSoftwareVersion(QString swVersion);
    bool getProcessRunning()const;

    QJsonObject getSwUpdateHistory();

    enum class ProductionLine{
        One,
        Two,
        Three,
        Four,
        Five,
        Six,
        Seven
    };

    void setProductionLine(ProductionLine value);
    void initSoftwareHistoryUrl();

signals:
    void swUpdateAvailable(QString swuVersion, QString path, QJsonObject history);
    void swUpdateAvailableReset();

private:
    bool _isNewSoftwareVersionValid(bool &checksumMatched);
    void _resetNewSoftwareVersionProfile();
    bool _isSwLatestVersionFileValid(QFile &filePath, QString &swuFileName);
    short _downloadHistoryFile();
    bool _hasNewSwuFileMd5SumChanged();

    // Returns empty QByteArray() on failure.
    bool _filesAreTheSame(const QString &fileName1, const QString &fileName2);
    QString _fileChecksum(const QString &fileName,
                            QCryptographicHash::Algorithm hashAlgorithm = QCryptographicHash::Md5);

    bool m_networkConnected = false;

    bool m_checkForSWUpdateEnable = true;
    QString m_currentSoftwareName;//SBC101
    QString m_currentSoftwareVersion;//1.0.0
    short m_currentMajorVersion = 1;
    short m_currentMinorVersion = 0;
    short m_currentPatchVersion = 0;
    short m_currentBuildVersion = 0;
    QString m_currentSoftwareSwuMd5Sum = "";

    QString m_newSoftwareName;//SBC101
    QString m_newSoftwareVersion;//1.0.0
    short m_newMajorVersion = 1;
    short m_newMinorVersion = 0;
    short m_newPatchVersion = 0;
    short m_newBuildVersion = 0;
    QString m_newSoftwareSwuUrl = "";
    QString m_newSoftwareHistoryUrl = "";
    QString m_newSoftwareSwuMd5Sum = "";
    bool m_newSoftwareVersionRelease = false;

    bool m_initialUpdate = true;
    bool m_processRunning = false;
    //    bool m_quickTourRccNeedUpdate = false;

    ProductionLine m_prodLine = ProductionLine::One;

    //    void checkQuickTourRccTempAvailability();
    //    bool matchQuickTourRccWithTemp();
    //    short downloadQuickTourRcc();
    //    QJsonObject objectFromString(const QString &in) const;
};

