#include <QProcess>
#include <QStandardPaths>
#include <QThread>
#include "CheckSWUpdate.h"
#include <QJsonDocument>
#include <QJsonParseError>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonArray>

#define URL_AUTO_UPDATE "electronics.escoglobal.com:8080/Factory-Production-Line-1/Project_SBC_Software/Auto_Update/"
#define USERNAME "escog4.devices"
#define PASSWORD "BSCg42022"

/// Comment this for Release version
#define TESTING

CheckSWUpdate::CheckSWUpdate(QObject *parent) : ClassManager(parent)
{
    QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    qDebug() << targetDir;
    QString targetLocation = targetDir + QString("/swupdate");
    QDir dir(targetLocation);
    if(!dir.exists())
        dir.mkpath(".");
}//

/*
 * https://embeddedartistry.com/blog/2017/12/07/use-semantic-versioning-and-give-your-version-numbers-meaning/
*/
void CheckSWUpdate::routineTask(int parameter)
{
    Q_UNUSED(parameter)
    if(!m_checkForSWUpdateEnable){m_processRunning = false; return;}

#ifdef __linux__

    m_processRunning = true;

    QProcess qprocess;

    ////// Check Network connectivity
    qprocess.start("nmcli -t dev");
    qprocess.waitForFinished();

    QString output = qprocess.readAllStandardOutput();
    QStringList devicesStatus = output.split("\n").filter(":connected");
    devicesStatus = devicesStatus.filter("wifi");
    //    qDebug() << __func__ << devicesStatus;
    if (!devicesStatus.isEmpty())
        m_networkConnected = true;
    else
        m_networkConnected = false;

    if(!m_networkConnected){m_processRunning = false; return;}

    QString urlAutoUpdate = URL_AUTO_UPDATE;
    QString urlAuthentication = QString("http://%1:%2@").arg(USERNAME, PASSWORD);
    QString swLatestVersion = "sw-latest-version";
    QString swLatestVersionTemp = swLatestVersion + "_temp";

    QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    targetDir += "/swupdate";

    ///Check Software Filename Update
    QString url =  urlAuthentication + urlAutoUpdate + swLatestVersion;

    QString cmd = QString("wget -P %1 %2").arg(targetDir).arg(url);

    QString swuFileName = "";
    QString oldSwuFileName = "";

    QFile updateFile(targetDir + "/" + swLatestVersion);

    if(updateFile.exists()){
        /// Check if the existing update file is valid
        /// and get the current swu file name
        if(_isSwLatestVersionFileValid(updateFile, swuFileName)){
            oldSwuFileName = swuFileName;
            /// there have been previous updates
            m_initialUpdate = false;
            /// download the new update file from SVN
            /// download as temp file
            cmd = QString("wget -O %1 %2").arg((targetDir + "/" + swLatestVersionTemp), url);
        }
        else{
            /// no previous update have been performed
            m_initialUpdate = true;
            /// Remove the existing update file due to invalid
            updateFile.remove();
        }//
        qDebug() << "m_initialUpdate" << m_initialUpdate << "oldSwuFileName" << oldSwuFileName;
    }//

    qDebug() << cmd;
    qprocess.start(cmd);
    qprocess.waitForFinished(); /// wait about maximum 30 seconds
    output = qprocess.readAllStandardOutput();
    int exitCode = qprocess.exitCode();
    qDebug() << "1" << output;
    qDebug() << "Exit Code:" << exitCode;

    /// If sw-latest-version downloaded successfully
    /// Check the downloaded file
    if(!exitCode){
        QString swuFileNameTemp = "";
        QString targetDirOfUpdateFileTemp = targetDir + "/" + swLatestVersionTemp;

        QFile updateFileTemp(targetDirOfUpdateFileTemp);

        qDebug() << "File temp exist" << updateFileTemp.exists();
        qDebug() << "m_initialUpdate" << m_initialUpdate;

        if(m_initialUpdate){
            if(updateFile.exists()){
                /// Check if the update file is valid
                if(_isSwLatestVersionFileValid(updateFile, swuFileName)){
                    qDebug() << updateFile.fileName() << "is valid";
                }
                else
                    qDebug() << updateFile.fileName() << "is not valid!";
                qDebug() << "swuFileName" << swuFileName;
            }//
        }//
        else{
            if(updateFileTemp.exists()){
                /// Check if the update file is valid
                if(_isSwLatestVersionFileValid(updateFileTemp, swuFileNameTemp)){
                    qDebug() << updateFileTemp.fileName() << "is valid";
                }
                else
                    qDebug() << updateFileTemp.fileName() << "is not valid!";
                qDebug() << "swuFileNameTemp" << swuFileNameTemp;
            }//
        }//
        bool isChecksumMatched = true;
        if(!_isNewSoftwareVersionValid(isChecksumMatched)) {
            qDebug() << "New software is invalid!";
            m_processRunning = false;
            return;
        }//
        qDebug() << "Checksum matched" << isChecksumMatched;

#ifdef TESTING
        m_newSoftwareVersionRelease = true;
#endif

        /// Proceed only if release flag is true
        if(m_newSoftwareVersionRelease){
            /// Download new swu file
            /// Create a temp file
            QString swuUrl = m_newSoftwareSwuUrl;
            QString swuFileNametoBeDownloaded = swuUrl.split("/")[swuUrl.split("/").length()-1];

            bool swuFileToBeDownloadedExist = QFile().exists(targetDir + QString("/%1").arg(swuFileNametoBeDownloaded));

            /// Double check the md5 checksum
            /// Check the actual md5 checksum of the existing swu file in local repository
            /// is it matched with md5 checksum on sw-latest-version?
            if(isChecksumMatched){
                if(swuFileToBeDownloadedExist){
                    QString actualChecksum = _fileChecksum(targetDir + QString("/%1").arg(swuFileNametoBeDownloaded));
                    qDebug() << "actualChecksum" << actualChecksum;
                    qDebug() << "m_newSoftwareSwuMd5Sum" << m_newSoftwareSwuMd5Sum;

                    isChecksumMatched = actualChecksum == m_newSoftwareSwuMd5Sum;

                    qDebug() << "swuFileToBeDownloadedExist and the match of md5 checksum is" << isChecksumMatched;
                }//
            }//

            if(swuFileToBeDownloadedExist && isChecksumMatched){
                qDebug() <<  swuFileNametoBeDownloaded << "is available on local repository";
                qDebug() << "No need to re-download!";

                m_processRunning = false;
                return;
            }//

            url = urlAuthentication + swuUrl;
            cmd = QString("wget -O %1 %2").arg((targetDir + QString("/%1_temp").arg(swuFileNametoBeDownloaded)), url);
            qDebug() << cmd;
            qprocess.start(cmd);
            qprocess.waitForFinished(60000); /// wait about maximum 1 minute

            int exitCode = qprocess.exitCode();
            output = qprocess.readAllStandardOutput();
            qDebug() << "2" << output;
            qDebug() << "Exit Code:" << exitCode;

            /// If Downloaded successfully
            /// Continue to download the history file
            if(!exitCode){
                /// Check file integgrity
                QString actualChecksum = _fileChecksum(targetDir + QString("/%1_temp").arg(swuFileNametoBeDownloaded));
                qDebug() << "actualChecksum" << actualChecksum;
                qDebug() << "m_newSoftwareSwuMd5Sum" << m_newSoftwareSwuMd5Sum;
                if(actualChecksum != m_newSoftwareSwuMd5Sum){
                    /// File checksum doesn't match
                    /// delete file
                    if(QFile().remove(targetDir + QString("/%1_temp").arg(swuFileNametoBeDownloaded))){
                        qDebug() <<  targetDir + QString("/%1_temp").arg(swuFileNametoBeDownloaded) << "deleted successfully";
                    }
                    m_processRunning = false;
                    return;
                }//

                /// Delete the old swu and history file if exist
                QFile oldFileSwu(targetDir + QString("/%1").arg(oldSwuFileName));

                if(oldFileSwu.exists()){
                    qDebug() << "Delete oldSwuFileName:" << oldFileSwu.fileName();
                    if(oldFileSwu.remove())
                        qDebug() << oldSwuFileName << "deleted successfully";
                }//
                /// Rename swu temp file
                QFile newFileSwu(targetDir + QString("/%1_temp").arg(swuFileNametoBeDownloaded));
                if(newFileSwu.exists()){
                    QString newFileSwuName = newFileSwu.fileName();
                    qDebug() << "Renaming" << newFileSwuName << "to" << newFileSwuName.replace("_temp", "");
                    if(newFileSwu.rename(newFileSwuName.replace("_temp", "")))
                        qDebug() << newFileSwu << "renamed successfully";
                }//

                QString historyStr = "";
                QFile historyFile(targetDir + QString("/%1").arg("history"));

                exitCode = _downloadHistoryFile();

                if(!exitCode){
                    if(historyFile.exists())
                    {
                        if(historyFile.open(QIODevice::ReadOnly | QIODevice::Text)){
                            QByteArray fileData;
                            fileData = historyFile.readAll();
                            historyStr = fileData;

                            historyFile.close();
                        }
                    }//
                    if(historyStr != ""){
                        /// Reset The SWUpdate Available
                        emit swUpdateAvailableReset();
                        /// Set the SWUpdate Available
                        /// Remove "BSC-LA2_VA2-"  and ".swu" as the software Update name and version
                        QString swUpdateNameVersion = swuFileNametoBeDownloaded;
                        swUpdateNameVersion = swUpdateNameVersion.replace(".swu","");
                        short length = swUpdateNameVersion.split("-").length();
                        swUpdateNameVersion = swUpdateNameVersion.split("-")[length-2] + " - " + swUpdateNameVersion.split("-")[length-1];
                        emit swUpdateAvailable(swUpdateNameVersion, (targetDir + QString("/%1").arg(swuFileNametoBeDownloaded)), getSwUpdateHistory());

                        /// Replace the old sw-latest-version file with the sw-latest-version_temp file
                        qDebug() << "Delete" << updateFile.fileName();
                        if(updateFile.remove()){
                            qDebug() << updateFile.fileName() << "deleted successfully";
                            qDebug() << "Rename" << updateFileTemp.fileName() << "to" << updateFile.fileName();
                            if(updateFileTemp.rename(updateFile.fileName())){
                                qDebug() << "Renaming successful";
                            }//
                        }//
                    }//
                }//
            }//
            else{
                qDebug() << "Failed to download *.swu file!";
                qDebug() << "Ensure the URL is available!";
            }//
        }//
    }//

#endif

    m_processRunning = false;
}//

void CheckSWUpdate::setCheckForSWUpdateEnable(bool value)
{
    if(m_checkForSWUpdateEnable == value)return;
    m_checkForSWUpdateEnable = value;
}//

bool CheckSWUpdate::getCheckForSWUpdateEnable() const
{
    return m_checkForSWUpdateEnable;
}//

/// \brief CheckSWUpdate::setCurrentSoftwareVersion
/// \param swVersion : Software Name and Version (e.g., SBC101-1.0.0)
/// \return false swVersion is invalid, otherwise true
bool CheckSWUpdate::setCurrentSoftwareVersion(QString swVersion)
{
    short versionDigitLength = 0;
    swVersion.replace(" ", "");
    bool isSWVersionValid = swVersion.split("-").length() == 2;// Check software name
    if(isSWVersionValid){
        versionDigitLength = swVersion.split("-")[1].split(".").length();
        isSWVersionValid &= (versionDigitLength == 3 || versionDigitLength == 4); // Check version number
    }
    if(!isSWVersionValid) return false;

    m_currentSoftwareName = swVersion.split("-")[0];
    m_currentSoftwareVersion = swVersion.split("-")[1];

    m_currentMajorVersion = m_currentSoftwareVersion.split(".")[0].toInt();
    m_currentMinorVersion = m_currentSoftwareVersion.split(".")[1].toInt();
    m_currentPatchVersion = m_currentSoftwareVersion.split(".")[2].toInt();
    if(versionDigitLength == 4)
        m_currentBuildVersion = m_currentSoftwareVersion.split(".")[3].toInt();

    qDebug() << "Software Name & Version is set:" << m_currentSoftwareName << m_currentSoftwareVersion;

    return true;
}//

bool CheckSWUpdate::getProcessRunning() const
{
    return m_processRunning;
}//

QJsonObject CheckSWUpdate::getSwUpdateHistory()
{
    QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    targetDir += "/swupdate";

    QString historyStr;
    QString historyPath = targetDir + QString("/%1").arg("history");
    //    qDebug() << historyPath;
    QFile historyFile(historyPath);
    QByteArray jsonData;

    if(historyFile.exists())
    {
        if(historyFile.open(QIODevice::ReadOnly | QIODevice::Text)){
            jsonData = historyFile.readAll();
            historyStr = jsonData;
            historyFile.close();
        }
    }//
    else{
        short exitCode = _downloadHistoryFile();
        if(!exitCode){
            if(historyFile.exists())
            {
                if(historyFile.open(QIODevice::ReadOnly | QIODevice::Text)){
                    jsonData = historyFile.readAll();
                    historyStr = jsonData;
                    historyFile.close();
                }
            }
        }
    }//

    //    qDebug() << jsonData;
    if(jsonData.isEmpty() == true) qDebug() << "Need to fill JSON data";

    //Assign the json text to a JSON object
    QJsonDocument jsonDocument = QJsonDocument::fromJson(jsonData);
    if(jsonDocument.isObject() == false) qDebug() << "It is not a JSON object";

    //Then get the main JSON object and get the datas in it
    QJsonObject object = jsonDocument.object();
    //    QJsonArray array =  object["versioning"].toArray();
    //    const QJsonObject historyJs = objectFromString(historyStr);
    //    qDebug() << object.length() << object["name"];
    //    qDebug() << array.size();
    //    for(short i=0; i<array.size(); i++)
    //        qDebug() << array.at(i);
    qDebug() << object;
    return object;
}

void CheckSWUpdate::setProductionLine(ProductionLine value)
{
    m_prodLine = value;
}

void CheckSWUpdate::initSoftwareHistoryUrl(){
    QByteArray jsonData;
    QString swLatestVersion ="sw-latest-version";
    QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    targetDir += "/swupdate";

    QFile updateFile(targetDir + "/" + swLatestVersion);

    if(updateFile.exists())
    {
        if(updateFile.open(QIODevice::ReadOnly | QIODevice::Text)){
            jsonData = updateFile.readAll();
            updateFile.close();
        }
    }//
    else{
        qDebug() << updateFile.fileName() << "is not exist";
        _resetNewSoftwareVersionProfile();
        return;
    }//

    if(jsonData.isEmpty() == true) qDebug() << "Need to fill JSON data";

    //Assign the json text to a JSON object
    QJsonDocument jsonDocument = QJsonDocument::fromJson(jsonData);
    if(jsonDocument.isArray() == false){
        qDebug() << "It is not a JSON Array";
        _resetNewSoftwareVersionProfile();
        return;
    }//
    //    else{
    qDebug() << "jsonDocument" << jsonDocument;
    //}

    QJsonArray jsonDataArray = jsonDocument.toVariant().toJsonArray();
    QJsonObject jsonDataObject = jsonDataArray[static_cast<short>(m_prodLine)].toObject();

    qDebug() << "jsonDataArray" << jsonDataArray;
    qDebug() << "jsonDataObject" << jsonDataObject;

    if(jsonDataObject[m_currentSoftwareName].isUndefined()){
        qDebug() << "No" << m_currentSoftwareName << "in" <<  jsonDataObject;
        _resetNewSoftwareVersionProfile();
        return;
    }
    else{
        /// Take only key m_currentSoftwareName
        jsonDataObject = jsonDataObject[m_currentSoftwareName].toObject();

        QJsonObject latestVersionObject = jsonDataObject["latestVer"].toObject();
        qDebug() << "latestVersionObject" << latestVersionObject;

        bool historyValid = !jsonDataObject["historyVerUrl"].isUndefined();

        if(historyValid){
            m_newSoftwareHistoryUrl = jsonDataObject["historyVerUrl"].toString();
        }//
    }//
}//

short CheckSWUpdate::_downloadHistoryFile()
{
    if(m_newSoftwareHistoryUrl == ""){
        qDebug() << "URL for history not defined!";
        return 0;
    }
#ifdef __linux__
    QProcess qprocess;

    QString urlAuthentication = QString("http://%1:%2@").arg(USERNAME, PASSWORD);
    QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    targetDir += "/swupdate";
    QString oldHistory = targetDir + "/history";
    QString tempHistory = targetDir + "/history_temp";

    /// Download new history
    QString url = urlAuthentication + m_newSoftwareHistoryUrl;
    QString cmd = QString("wget -O %1 %2").arg(tempHistory, url);
    qDebug() << cmd;
    qprocess.start(cmd);
    qprocess.waitForFinished(); /// wait about maximum 30 seconds

    short exitCode = qprocess.exitCode();
    qDebug() << qprocess.readAllStandardOutput();
    qDebug() << "Exit Code:" << exitCode;

    /// If Downloaded successfully
    /// Delete the old history file and Rename the history_temp file
    if(!exitCode){
        if(QFile().remove(oldHistory))
            qDebug() << oldHistory << "file deleted successfully";
        if(QFile().rename(tempHistory, oldHistory))
            qDebug() << tempHistory << "Renamed successfully";
    }//

    return exitCode;
#endif
    return 0;
}

bool CheckSWUpdate::_hasNewSwuFileMd5SumChanged()
{
    QString swLatestVersion = "sw-latest-version";
    //QString swLatestVersionTemp = swLatestVersion + "_temp";

    QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    targetDir += "/swupdate";

    if(!QFile().exists(targetDir + QString("/%1").arg(swLatestVersion))
            /*|| !QFile().exists(targetDir + QString("/%1").arg(swLatestVersionTemp))*/){
        qDebug() << swLatestVersion << /*"or" << swLatestVersionTemp <<*/ "is not exist!";
        return false;
    }

    QByteArray jsonData;

    QFile updateFile(targetDir + "/" + swLatestVersion);

    if(updateFile.exists())
    {
        if(updateFile.open(QIODevice::ReadOnly | QIODevice::Text)){
            jsonData = updateFile.readAll();
            updateFile.close();
        }
    }//
    else{
        qDebug() << updateFile.fileName() << "is not exist";
        //_resetNewSoftwareVersionProfile();
        return false;
    }//

    if(jsonData.isEmpty() == true) qDebug() << "Need to fill JSON data";

    //Assign the json text to a JSON object
    QJsonDocument jsonDocument = QJsonDocument::fromJson(jsonData);
    if(jsonDocument.isArray() == false){
        qDebug() << "It is not a JSON Array";
        //_resetNewSoftwareVersionProfile();
        return false;
    }//
    //    else{
    qDebug() << "jsonDocument" << jsonDocument;
    //}

    QJsonArray jsonDataArray = jsonDocument.toVariant().toJsonArray();
    QJsonObject jsonDataObject = jsonDataArray[static_cast<short>(m_prodLine)].toObject();

    qDebug() << "jsonDataArray" << jsonDataArray;
    qDebug() << "jsonDataObject" << jsonDataObject;

    if(jsonDataObject[m_currentSoftwareName].isUndefined()){
        qDebug() << "No" << m_currentSoftwareName << "in" <<  jsonDataObject;
        //_resetNewSoftwareVersionProfile();
        return false;
    }
    else{
        /// Take only key m_currentSoftwareName
        jsonDataObject = jsonDataObject[m_currentSoftwareName].toObject();

        QJsonObject latestVersionObject = jsonDataObject["latestVer"].toObject();
        qDebug() << "latestVersionObject" << latestVersionObject;

        bool latestVerMd5SumValid = !jsonDataObject["latestVerMd5Sum"].isUndefined();

        if(latestVerMd5SumValid){
            m_currentSoftwareSwuMd5Sum = jsonDataObject["latestVerMd5Sum"].toString();
        }//
    }//
    qDebug() << "Compare checksum:" << m_currentSoftwareSwuMd5Sum << m_newSoftwareSwuMd5Sum;

    return m_currentSoftwareSwuMd5Sum != m_newSoftwareSwuMd5Sum;
}//

///
/// \brief CheckSWUpdate::_isNewSoftwareVersionValid
/// \param oldVersion : SBCVWW-X.Y.Z.Build
/// \param newVersion : SBCVWW-X.Y.Z.Build
/// \return
/*
## V 	-> Production line (1-7)
## WW 	-> Software sequence number (01-99)
## X 	-> Major version
## Y 	-> Minor version
## Z 	-> Patch version
## B 	-> Build (leave empty for build 0)
/// */

bool CheckSWUpdate::_isNewSoftwareVersionValid(bool &checksumMatched)
{
    if(m_newSoftwareName == ""
            || m_newSoftwareVersion == ""
            || m_newMajorVersion == 0
            || m_newSoftwareSwuUrl == ""
            || m_newSoftwareHistoryUrl == ""){
        qDebug() << "There is an invalid parameter:" << m_newSoftwareName << m_newSoftwareVersion << m_newMajorVersion << m_newSoftwareSwuUrl << m_newSoftwareHistoryUrl;
        return false;
    }

    if(m_newSoftwareName != m_currentSoftwareName){
        qDebug() << "Different software name" << m_newSoftwareName << m_currentSoftwareName;
        return false;
    }

    short currentVersion = (m_currentMajorVersion * 1000) + (m_currentMinorVersion * 100) + (m_currentPatchVersion * 10) + m_currentBuildVersion;
    short newVersion = (m_newMajorVersion * 1000) + (m_newMinorVersion * 100) + (m_newPatchVersion * 10) + m_newBuildVersion;

    if(newVersion <= currentVersion) {
        if(newVersion == currentVersion){
            qDebug() << "Same software version" << newVersion << currentVersion;
            qDebug() << "Checking file checksum...";
            /// Compare latestVerMd5Sum in sw-latest-version and in sw-latest-version_temp
            /// if they are the same, then new software version seems no need to download again
            /// But need to compare this md5 checksum on sw-latest-version with the actual file on local repo
            if(!_hasNewSwuFileMd5SumChanged()){
                checksumMatched = true;
                /// At the first time after sd card flashed
                /// Only consider the Software Version
                /// Return false if there is no *.swu file in the local repository yet
                QString swuUrl = m_newSoftwareSwuUrl;
                QString swuFileNametoBeDownloaded = swuUrl.split("/")[swuUrl.split("/").length()-1];
                QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
                targetDir += "/swupdate";

                bool swuFileToBeDownloadedExist = QFile().exists(targetDir + QString("/%1").arg(swuFileNametoBeDownloaded));
                if(!swuFileToBeDownloadedExist){
                    qDebug() << "Return false: there is no *.swu file in the local repository yet";
                    qDebug() << "Software version is the same, no need to update";
                    return false;
                }
            }else{
                checksumMatched = false;
                qDebug() << "Checksum swu file is different.";
                qDebug() << "Need to download the new swu file";
            }
        }
        if(newVersion < currentVersion){
            qDebug() << "Downgrade version is not allowed!";
            return false;
        }
    }//

    return true;
}//

void CheckSWUpdate::_resetNewSoftwareVersionProfile()
{
    m_newSoftwareName = "";
    m_newMajorVersion = 0;
    m_newMinorVersion = 0;
    m_newPatchVersion = 0;
    m_newBuildVersion = 0;
    m_newSoftwareVersion = "";
    m_newSoftwareSwuUrl = "";
    m_newSoftwareSwuMd5Sum = "";
    m_newSoftwareHistoryUrl = "";
    m_newSoftwareVersionRelease = false;
}

bool CheckSWUpdate::_isSwLatestVersionFileValid(QFile &file, QString &swuFileName)
{
    QByteArray jsonData;

    if(file.exists())
    {
        if(file.open(QIODevice::ReadOnly | QIODevice::Text)){
            jsonData = file.readAll();
            file.close();
        }
    }//
    else{
        qDebug() << file.fileName() << "is not exist";
        _resetNewSoftwareVersionProfile();
        return false;
    }//

    if(jsonData.isEmpty() == true) qDebug() << "Need to fill JSON data";

    //Assign the json text to a JSON object
    QJsonDocument jsonDocument = QJsonDocument::fromJson(jsonData);
    if(jsonDocument.isArray() == false){
        qDebug() << "It is not a JSON Array";
        _resetNewSoftwareVersionProfile();
        return false;
    }//
    //    else{
    qDebug() << "jsonDocument" << jsonDocument;
    //}

    QJsonArray jsonDataArray = jsonDocument.toVariant().toJsonArray();
    QJsonObject jsonDataObject = jsonDataArray[static_cast<short>(m_prodLine)].toObject();

    qDebug() << "jsonDataArray" << jsonDataArray;
    qDebug() << "jsonDataObject" << jsonDataObject;

    if(jsonDataObject[m_currentSoftwareName].isUndefined()){
        qDebug() << "No" << m_currentSoftwareName << "in" <<  jsonDataObject;
        _resetNewSoftwareVersionProfile();
        return false;
    }
    else{
        /// Take only key m_currentSoftwareName
        jsonDataObject = jsonDataObject[m_currentSoftwareName].toObject();

        QJsonObject latestVersionObject = jsonDataObject["latestVer"].toObject();
        qDebug() << "latestVersionObject" << latestVersionObject;
        /// Check every key
        bool versionValid = !jsonDataObject["latestVer"].isUndefined();
        versionValid &= !latestVersionObject["major"].isUndefined();
        versionValid &= !latestVersionObject["minor"].isUndefined();
        versionValid &= !latestVersionObject["patch"].isUndefined();
        versionValid &= !latestVersionObject["build"].isUndefined();
        versionValid &= !jsonDataObject["latestVerUrl"].isUndefined();
        versionValid &= !jsonDataObject["latestVerMd5Sum"].isUndefined();
        versionValid &= !jsonDataObject["historyVerUrl"].isUndefined();
        versionValid &= !jsonDataObject["swDesc"].isUndefined();
        versionValid &= !jsonDataObject["release"].isUndefined();

        QString swuFileNameTemp;
        if(versionValid){
            //            m_newSoftwareVersionRelease = jsonDataObject["release"].toBool();
            //            versionValid &= m_newSoftwareVersionRelease;
            //            if(versionValid){
            QString swuUrl = jsonDataObject["latestVerUrl"].toString();
            swuFileNameTemp = swuUrl.split("/")[swuUrl.split("/").length()-1];

            QString swNameVersion = QString("%1-%2.").arg(m_currentSoftwareName, QString::number(latestVersionObject["major"].toInt()));
            swNameVersion += QString("%1.%2").arg(QString::number(latestVersionObject["minor"].toInt()), QString::number(latestVersionObject["patch"].toInt()));
            versionValid &= swuFileNameTemp.contains(swNameVersion);

            if(!versionValid){
                qDebug() << "New software version is invalid because of software name and version is not matched with swu file name in latestVerUrl";
                qDebug() << "swNameVersion"<< swNameVersion;
                qDebug() << "latestVerUrl" << jsonDataObject["latestVerUrl"].toString();
            }//
            //        }//
        }//

        if(!versionValid){
            //qDebug() << jsonDataObject["release"].toBool();
            qDebug() << jsonDataObject["latestVer"].toObject();
            qDebug() << jsonDataObject["latestVerUrl"].toString();
            qDebug() << jsonDataObject["historyVerUrl"].toString();
            qDebug() << jsonDataObject["swDesc"].toString();
            qDebug() << "version is invalid!";
            _resetNewSoftwareVersionProfile();
            return false;
        }//
        else{
            m_newSoftwareName = m_currentSoftwareName;
            m_newMajorVersion = latestVersionObject["major"].toInt();
            m_newMinorVersion = latestVersionObject["minor"].toInt();
            m_newPatchVersion = latestVersionObject["patch"].toInt();
            m_newBuildVersion = latestVersionObject["build"].toInt();
            m_newSoftwareVersion = QString("%1.%2").arg(QString::number(m_newMajorVersion), QString::number(m_newMinorVersion));
            m_newSoftwareVersion += QString(".%1").arg(QString::number(m_newPatchVersion));
            m_newSoftwareSwuUrl = jsonDataObject["latestVerUrl"].toString();
            m_newSoftwareSwuMd5Sum = jsonDataObject["latestVerMd5Sum"].toString();
            m_newSoftwareHistoryUrl = jsonDataObject["historyVerUrl"].toString();
            m_newSoftwareVersionRelease = jsonDataObject["release"].toBool();

            swuFileName = swuFileNameTemp;
            if(m_newSoftwareVersionRelease)
                qDebug() << "New Software version is valid:" << m_newSoftwareName << "-" <<  m_newSoftwareVersion;
            else
                qDebug() << "New Software version is not release version:" << m_newSoftwareName << "-" <<  m_newSoftwareVersion;
        }//
    }//

    return true;
}//

bool CheckSWUpdate::_filesAreTheSame(const QString &fileName1, const QString &fileName2)
{
    return _fileChecksum(fileName1) == _fileChecksum(fileName2);
}

// Returns empty QByteArray() on failure.
QString CheckSWUpdate::_fileChecksum(const QString &fileName, QCryptographicHash::Algorithm hashAlgorithm)
{
    QProcess qprocess;
    QString output;
    QString cmd;
    QString app = "md5sum";
    if(hashAlgorithm == QCryptographicHash::Sha256){
        app = "sha256sum";
    }//
    else if(hashAlgorithm == QCryptographicHash::Sha1){
        app = "sha1sum";
    }
    //    cmd = QString("%1").arg(app);
    qprocess.start(app, QStringList() << fileName);
    qprocess.waitForFinished();
    if(!qprocess.exitCode()){
        output = qprocess.readAllStandardOutput();
        if(output.split(" ").length() > 1)
            output = output.split(" ")[0];
    }
    qDebug() << cmd;
    qDebug() << output;
    return output;
}//


