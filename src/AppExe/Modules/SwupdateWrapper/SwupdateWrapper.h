/*
* (C) Copyright ${year} Nuxeo (http://nuxeo.com/) and others.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
* Contributors:
*     ...
*/

#pragma once

#include <QObject>
#include <QScopedPointer>

class SwupdateWrapper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int exitStatus READ getExitStatus WRITE setExitStatus NOTIFY exitStatusChanged)
    Q_PROPERTY(QString fileNamePath READ getFileNamePath WRITE setFileNamePath NOTIFY fileNamePathChanged)
    Q_PROPERTY(bool dryMode READ getDryMode WRITE setDryMode NOTIFY dryModeChanged)
    Q_PROPERTY(int progressPercent READ getProgressPercent WRITE setProgressPercent NOTIFY progressPercentChanged)
    Q_PROPERTY(int progressStatus READ progressStatus WRITE setProgressStatus NOTIFY progressStatusChanged)

    Q_PROPERTY(bool bussy READ getBussy WRITE setBussy NOTIFY bussyChanged)

public:
    explicit SwupdateWrapper(QObject *parent = nullptr);
    ~SwupdateWrapper();

    int getExitStatus() const;

    QString getFileNamePath() const;

    bool getDryMode() const;

    int getProgressPercent() const;

    int progressStatus() const;

    enum PROGRESS_STATUS{
        PS_IDLE,
        PS_RUN,
        PS_SUCCESS,
        PS_FAILED
    };
    Q_ENUMS(PROGRESS_STATUS);

    bool getClearDirAfterDone() const;

    bool getBussy() const;

signals:
    void messageNewReadyRead(const QString message);

    void exitStatusChanged(int exitStatus);

    void fileNamePathChanged(QString fileName);

    void dryModeChanged(bool dryMode);

    void progressPercentChanged(int progressPercent);

    void progressStatusChanged(int progressStatus);

    void bussyChanged(bool bussy);

public slots:
    void updateAsync();

    void setExitStatus(int exitStatus);

    void setFileNamePath(QString fileName);

    void setDryMode(bool dryMode);

    void setProgressPercent(int progressPercent);

    void setProgressStatus(int progressStatus);

    void setBussy(bool bussy);

private:
    void update();

   QScopedPointer<QThread> m_thread;

    int m_exitStatus;
    QString m_fileNamePath;
    bool m_dryMode;
    int m_progressPercent;
    int m_progressStatus;
    bool m_bussy;
};
