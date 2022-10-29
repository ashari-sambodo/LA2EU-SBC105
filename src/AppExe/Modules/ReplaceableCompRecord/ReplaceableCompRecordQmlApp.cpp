#include "ReplaceableCompRecordQmlApp.h"
#include <QThread>
#include <QEventLoop>
#include <QDate>
#include <cmath>

#include <QPdfWriter>
#include <QFile>
#include <QPainter>
#include <QDir>
#include <QStandardPaths>
#include <QTextStream>
#include <QtWidgets>
#include <QPrinter>

ReplaceableCompRecordQmlApp::ReplaceableCompRecordQmlApp(QObject *parent) : QObject(parent)
{
    checkFiles();
}

bool ReplaceableCompRecordQmlApp::getInitialized() const
{
    return m_initialized;
}

void ReplaceableCompRecordQmlApp::init(const QString &uniqConnectionName, const QString &fileName)
{
    // sanity check dont allow to double created the instance
    if (m_pThread != nullptr) return;

    m_pThread = QThread::create([&, uniqConnectionName, fileName](){
        //        qDebug() << "m_pThread::create" << thread();

        m_pSql.reset(new ReplaceableCompRecordSqlGet());
        bool initialized = m_pSql->init(uniqConnectionName, fileName);

        if(m_delayEmitSignal>0) QThread::msleep(static_cast<ulong>(m_delayEmitSignal));
        setInitialized(initialized);

        QEventLoop loop;
        //        connect(this, &ReplaceableCompRecordQmlApp::destroyed, &loop, &QEventLoop::quit);
        loop.exec();

        //        qDebug() << "m_pThread::end";
    });

    //// Tells the thread's event loop to exit with return code 0 (success).
    connect(this, &ReplaceableCompRecordQmlApp::destroyed, m_pThread, &QThread::quit);
    connect(m_pThread, &QThread::finished, m_pThread, [&](){
        qDebug() << "Thread has finished";
    });
    connect(m_pThread, &QThread::finished, m_pThread, &QThread::deleteLater);
    connect(m_pThread, &QThread::destroyed, m_pThread, [&](){
        qDebug() << "Thread will destroying";
    });
    m_pThread->start();
}

//void ReplaceableCompRecordQmlApp::insert(const QVariantMap data)
//{
//    qDebug() << __func__ << thread();
//
//    QMetaObject::invokeMethod(m_pSql.data(), [&, data](){
//        qDebug() << __func__ << thread();
//
//        bool done = m_pSql->queryInsert(data);
//        setLastQueryError(!done);
//        if(!done) {
//            qWarning() << m_pSql->lastQueryErrorStr();
//        }
//
//
//
//    });
//}

void ReplaceableCompRecordQmlApp::selectDescendingWithPagination(short pageNumber)
{
    qDebug() << __func__ << m_pagesItemPerPage << pageNumber << thread();

    QMetaObject::invokeMethod(m_pSql.data(), [&, pageNumber](){
        qDebug() << __func__ << thread();

        int count = 0;
        bool done = m_pSql->queryCount(&count);
        setTotalItem(count);
        /// update pages properties
        int _totalPages = static_cast<int>(std::ceil(static_cast<float>(count)/static_cast<float>(m_pagesItemPerPage)));
        //        qDebug() << "_totalPages:" << _totalPages;
        setPagesTotal(static_cast<short>(_totalPages));

        if(count == 0){
            int _pageNumber = 1;
            setPagesCurrentNumber(_pageNumber);
            setPagesNextNumber(_pageNumber);
            setPagesPreviousNumber(_pageNumber);

            emit selectHasDone(done, QVariantList(), count);
            return ;
        }

        int offset = (m_pagesItemPerPage * pageNumber) - m_pagesItemPerPage;
        QString options = QString().asprintf(" ORDER BY ROWID DESC LIMIT %d OFFSET %d", m_pagesItemPerPage, offset);

        QVariantList logBuffer, logReady;
        done = m_pSql->querySelect(&logBuffer, options);
        setLastQueryError(!done);
        if(done) {
            /// Reconstructing every item to JSON/VariantMaplist
            /// so, QML Listview ease to present the data
            QVariantMap item;
            QVariantList itemTemp;
            for(int i=0; i < logBuffer.length(); i++){
                item.clear();
                itemTemp.clear();

                itemTemp = logBuffer.at(i).toList();
                //                qDebug() << itemTemp.length();
                for(short i=TableHeaderEnum::TH_ROWID; i<TableHeaderEnum::TH_Total; i++)
                    item.insert(m_tableHeaderString[i], itemTemp.at(i));

                logReady.append(item);
            }

            if(logBuffer.length()){
                setPagesCurrentNumber(pageNumber);

                /// determine what next page number
                if ((pageNumber+1)<=_totalPages) {
                    setPagesNextNumber(pageNumber+1);
                }
                else {
                    setPagesNextNumber(pageNumber);
                }

                /// determine what previous page number
                if (pageNumber>1) {
                    setPagesPreviousNumber(pageNumber-1);
                }
            }
        }
        else {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        if(m_delayEmitSignal>0) QThread::msleep(static_cast<ulong>(m_delayEmitSignal));
        emit selectHasDone(done, logReady, count);
    });
}//

void ReplaceableCompRecordQmlApp::deleteAll()
{
    qDebug() << __func__ << thread();

    QMetaObject::invokeMethod(m_pSql.data(), [&](){
        qDebug() << __func__ << thread();

        bool done = m_pSql->queryDelete();
        setLastQueryError(!done);
        if(!done) {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        /// get the total rows after delete
        int count = 0;
        m_pSql->queryCount(&count);

        if(m_delayEmitSignal>0) QThread::msleep(static_cast<ulong>(m_delayEmitSignal));
        emit deleteHasDone(done, count);
    });
}

void ReplaceableCompRecordQmlApp::deleteWhereOlderThanDays(int days)
{
    qDebug() << __func__ << thread();

    QMetaObject::invokeMethod(m_pSql.data(), [&](){
        qDebug() << __func__ << thread();

        QDate targetDate = QDate::currentDate().addDays(-days);
        QString options = QString(" WHERE %1 <= '%2'").arg(m_tableHeaderString[TH_Date], targetDate.toString("yyyy-MM-dd"));
        qDebug() << options;

        bool done = m_pSql->queryDelete(options);
        setLastQueryError(!done);

        if(!done) {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        /// get the total rows after delete
        int count = 0;
        m_pSql->queryCount(&count);

        if(m_delayEmitSignal>0) QThread::msleep(static_cast<ulong>(m_delayEmitSignal));
        emit deleteHasDone(done, count);
    });
}

void ReplaceableCompRecordQmlApp::setLastQueryError(bool lastQueryError)
{
    if (m_lastQueryError == lastQueryError)
        return;

    m_lastQueryError = lastQueryError;
    emit lastQueryErrorChanged(m_lastQueryError);
}

void ReplaceableCompRecordQmlApp::setDelayEmitSignal(int delayEmitSignal)
{
    if (m_delayEmitSignal == delayEmitSignal)
        return;

    m_delayEmitSignal = delayEmitSignal;
    emit delayEmitSignalChanged(m_delayEmitSignal);
}

void ReplaceableCompRecordQmlApp::setPagesCurrentNumber(int pagesCurrentNumber)
{
    if (m_pagesCurrentNumber == pagesCurrentNumber)
        return;

    m_pagesCurrentNumber = pagesCurrentNumber;
    emit pagesCurrentNumberChanged(static_cast<short>(m_pagesCurrentNumber));
}

void ReplaceableCompRecordQmlApp::setPagesNextNumber(int pagesNextNumber)
{
    if (m_pagesNextNumber == pagesNextNumber)
        return;

    m_pagesNextNumber = pagesNextNumber;
    emit pagesNextNumberChanged(m_pagesNextNumber);
}

void ReplaceableCompRecordQmlApp::setPagesPreviousNumber(int pagesPreviousNumber)
{
    if (m_pagesPreviousNumber == pagesPreviousNumber)
        return;

    m_pagesPreviousNumber = pagesPreviousNumber;
    emit pagesPreviousNumberChanged(m_pagesPreviousNumber);
}

void ReplaceableCompRecordQmlApp::setPagesTotal(short pagesTotal)
{
    if (m_pagesTotal == pagesTotal)
        return;

    m_pagesTotal = pagesTotal;
    emit pagesTotalChanged(static_cast<short>(m_pagesTotal));
}

void ReplaceableCompRecordQmlApp::setTotalItem(int totalItem)
{
    if (m_totalItem == totalItem)
        return;

    m_totalItem = totalItem;
    emit totalItemChanged(m_totalItem);
}

void ReplaceableCompRecordQmlApp::exportLogs(int startPageNumber,
                                            const QString exportedDateTime,
                                            const QString formRpRev,
                                            const QString formRpPath,
                                            int endPageNumber)
{
    qDebug() << __func__ << startPageNumber << endPageNumber << exportedDateTime << formRpRev << formRpPath << thread();

    QMetaObject::invokeMethod(m_pSql.data(), [
                              &,
                              startPageNumber,
                              exportedDateTime,
                              formRpRev,
                              formRpPath,
                              endPageNumber](){

        qDebug() << __func__ << startPageNumber << endPageNumber << exportedDateTime << formRpRev << formRpPath << thread();

        int count = 0;
        int totalPages = 0;
        QStringList logReady;

        ///DATABASE QUERY SECTION
        {
            bool done = m_pSql->queryCount(&count);
            if(count == 0){
                emit logHasExported(false, "No log available yet");
                return ;
            }

            /// update pages properties
            totalPages = static_cast<int>(std::ceil(static_cast<float>(count)/static_cast<float>(m_pagesItemPerPage)));
            int totalItemNeedToExport = m_pagesItemPerPage * endPageNumber;
            int offset = (m_pagesItemPerPage * startPageNumber) - m_pagesItemPerPage;
            qDebug() << "totalPages" << totalPages << "totalItemNeedToExport" << totalItemNeedToExport << "offset" << offset;
            QString options = QString().asprintf(" ORDER BY ROWID DESC LIMIT %d OFFSET %d", totalItemNeedToExport, offset);
            qDebug() << options;

            QStringList logBuffer;
            done = m_pSql->querySelect(&logBuffer, options);
            if(done) {
                logReady = logBuffer;
                qDebug() << "logReady length:" << logReady.length();
            }
            else {
                qWarning() << m_pSql->lastQueryErrorStr();
                emit logHasExported(false, m_pSql->lastQueryErrorStr());
                return;
            }
        }

        /// GENERATE HTML FILE
        setPrintContent(logReady, exportedDateTime, formRpRev,
                        formRpPath, startPageNumber, endPageNumber, totalPages);


        /// GENERATE PDF FILE SECTION
        QString dateTime = QDateTime::currentDateTime().toString("yyyyMMdd_hhmmss");
        QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
        QString fileName = targetDir + QString("/report/ReplaceableCompRecord_P%1-%2of%3_%4.pdf").arg(startPageNumber).arg(endPageNumber).arg(totalPages).arg(dateTime);
        qDebug() << fileName;

        QFile pdfFile(fileName);
        bool fileIsOK = pdfFile.open(QIODevice::WriteOnly);
        qDebug() << "File is OK:" << fileIsOK;

        if(!fileIsOK){
            emit logHasExported(false, tr("Failed to initiate file"));
            return ;
        }

        qDebug() << "start print pdf";

        QPrinter printer(QPrinter::PrinterResolution);
        QMarginsF margins = QMarginsF(10, 10, 5, 5);
        printer.setOutputFormat(QPrinter::PdfFormat);
        printer.setPageMargins(margins, QPageLayout::Unit::Millimeter);
        printer.setPageSize(QPageSize(QPageSize::A4));
        printer.setColorMode(QPrinter::Color);
        printer.setOutputFileName(fileName);

        QString tempS;
        tempS = targetDir + "/report/script/rp.html";

        QFile html(tempS);
        html.open(QFile::ReadOnly | QFile::Text);
        QTextStream streamHtml(&html);

        QFile css(targetDir + "/report/script/layout-rp.css");
        css.open(QFile::ReadOnly | QFile::Text);
        QTextStream streamCss(&css);

        QTextDocument doc;
        doc.setDefaultStyleSheet(streamCss.readAll());
        doc.setHtml(streamHtml.readAll());
        doc.setDefaultFont(QFont());
        doc.setPageSize(printer.pageLayout().paintRectPixels(100).size());///100dpi
        //        doc.setPageSize(printer.pageRect().size());
        doc.print(&printer);

        pdfFile.close();

        emit logHasExported(true, pdfFile.fileName());
    });
}

void ReplaceableCompRecordQmlApp::setPrintContent(const QStringList &content, const QString exportDateTime, const QString formRpRev,
                                                 const QString formRpPath, int startPage, int endPage, int maxPage)
{
    qDebug() << __func__ << startPage << endPage << maxPage << content << thread();
    QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    qDebug() << targetDir;
    QFile html(targetDir + "/report/script/rp.html");

    if (html.exists()) {
        html.open(QFile::WriteOnly | QFile::Text);
        QTextStream streamHtml(&html);
        QStringList list;
        QStringList listTemp;

        if(((endPage + 1) - startPage) > maxPage){
            qDebug() << "End Page number not valid!";
            return;
        }

        list.append("<!DOCTYPE html>");
        list.append("<html>");
        list.append("<head>");
        list.append("<title>REPLACEABLE COMPONENTS RECORD FORM G4</title>");
        list.append("<style>");
        list.append("</style>");
        list.append("</head>");
        list.append("<body>");

        listTemp.clear();
        for (int i = startPage; i <= endPage; i++) {
            //list.append(_docPdfHeader());
            listTemp.append(_docPdf(exportDateTime, formRpRev,
                                    content, formRpPath, i-startPage,
                                    i, maxPage));
            //list.append(_docPdfFooter(i, maxPage));
        }//
        //qDebug() << "listTemp.length()" << listTemp.length();
        for(short i=0; i<listTemp.length(); i++){
            //qDebug() << "split" << i;
            if(i == listTemp.length()-1){
                /// Remove Page Break at the last page
                QString content = listTemp.at(i);
                QString splitStr = "<div class='pageBreak'></div>";
                QString content1 = content.split(splitStr)[0];
                QString content2 = content.split(splitStr)[1];
                content = content1 + "\n" + splitStr + "\n" + content2;
                list.append(content);
            }//
            else{
                list.append(listTemp.at(i));
            }//
        }//

        list.append("</body>");
        list.append("</html>");
        streamHtml << list.join("\n");
        html.close();
    }else{
        qDebug() << targetDir + "/report/script/rp.html" << "not ready!";
    }
}

//QString ReplaceableCompRecordQmlApp::_docPdfHeader(const QString exportDateTime, const QString serial)
//{
//    qDebug() << __func__ << exportDateTime << serial << thread();

//    QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
//    QString imgDir = targetDir + "/report/resource/esco_life_blue.png";
//    QString head;
//    QStringList list;

//    list.append(QString("<table id='headerTable' cellspacing=0 width=100%>"));
//    list.append(QString("   <tr>"));
//    list.append(QString("       <th align=left width=120><img src='%1' width=100 height=40></img></th>").arg(imgDir));
//    list.append(QString("       <th>%1<br>S/N: %2<br>Equipment: Healthcare Platform Isolator</td>").arg(exportDateTime, serial));
//    list.append(QString("   </tr>"));
//    list.append(QString("</table>"));
//    //    list.append(QString("\n<hr>"));

//    head = list.join("\n");
//    return head;
//}//

QString ReplaceableCompRecordQmlApp::_docPdf(const QString exportDateTime, const QString formRpRev,
                                            const QStringList &content, const QString formRpPath,
                                            int row, int page, int maxPage)
{
    qDebug() << __func__ << formRpRev << formRpPath << row << content << thread();

    Q_UNUSED(page)
    Q_UNUSED(maxPage)

    QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    //QString logoPath = targetDir + "/report/resource/esco_life_blue.png";

    QString docPdfStr;
    QStringList list;
    QStringList lis;
    QString strs;

    strs = content.at(row);
    lis = strs.split("$");
    qDebug() << "Lis" << lis.length() << lis;

    QString rpTemplatePath = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/report/script/rp-temp.html";
    QFile rpTemplate(rpTemplatePath);
    rpTemplate.open(QIODevice::Text | QIODevice::ReadOnly);
    QString rpText = rpTemplate.readAll();

    const int totalParameter = TH_Total;

    QString checked = "<img src=\":/UI/Pictures/checked.png\" alt=\"Checked\" style=\"width:13px;height:13px;\">";
    QString unChecked = "<img src=\":/UI/Pictures/unchecked.png\" alt=\"Checked\" style=\"width:13px;height:13px;\">";

    short allCheckParameter[TH_Total]={
        TH_SBCSet1Check,
        TH_SBCSet2Check,
        TH_SBCSet3Check,
        TH_SBCSet4Check,
        TH_SBCSet5Check,
        TH_SBCSet6Check,
        TH_SBCSet7Check,
        TH_SBCSet8Check,
        TH_SBCSet9Check,
        TH_SBCSet10Check,//10
        TH_SBCSet11Check,
        TH_SBCSet12Check,
        TH_SBCSet13Check,
        TH_SBCSet14Check,
        TH_SBCSet15Check,
        //
        TH_Sensor1Check,
        TH_Sensor2Check,
        TH_Sensor3Check,
        TH_Sensor4Check,
        TH_Sensor5Check,//20
        //
        TH_UVLED1Check,
        TH_UVLED2Check,
        TH_UVLED3Check,
        TH_UVLED4Check,
        TH_UVLED5Check,
        TH_UVLED6Check,
        //
        TH_PSU1Check,
        TH_PSU2Check,
        TH_PSU3Check,
        TH_PSU4Check,//30
        TH_PSU5Check,
        //
        TH_MCBEMI1Check,
        TH_MCBEMI2Check,
        TH_MCBEMI3Check,
        TH_MCBEMI4Check,
        TH_MCBEMI5Check,
        //
        TH_ContactSw1Check,
        TH_ContactSw2Check,
        TH_ContactSw3Check,
        TH_ContactSw4Check,//40
        TH_ContactSw5Check,
        //
        TH_BMotor1Check,
        TH_BMotor2Check,
        TH_BMotor3Check,
        TH_BMotor4Check,
        TH_BMotor5Check,
        //
        TH_CapInd1Check,
        TH_CapInd2Check,
        TH_CapInd3Check,
        TH_CapInd4Check,//50
        TH_CapInd5Check,
        //
        TH_Custom1Check,
        TH_Custom2Check,
        TH_Custom3Check,
        TH_Custom4Check,
        TH_Custom5Check,
        TH_Custom6Check,
        TH_Custom7Check,
        TH_Custom8Check,
        //
        TH_Filter1Check,//60
        TH_Filter2Check,
        TH_Filter3Check,
        TH_Filter4Check,
        TH_Filter5Check,//64
    };
    short allQtyParameter[TH_Total]={
        TH_SBCSet1Qty,
        TH_SBCSet2Qty,
        TH_SBCSet3Qty,
        TH_SBCSet4Qty,
        TH_SBCSet5Qty,
        TH_SBCSet6Qty,
        TH_SBCSet7Qty,
        TH_SBCSet8Qty,
        TH_SBCSet9Qty,
        TH_SBCSet10Qty,//10
        TH_SBCSet11Qty,
        TH_SBCSet12Qty,
        TH_SBCSet13Qty,
        TH_SBCSet14Qty,
        TH_SBCSet15Qty,
        //
        TH_Sensor1Qty,
        TH_Sensor2Qty,
        TH_Sensor3Qty,
        TH_Sensor4Qty,
        TH_Sensor5Qty,//20
        //
        TH_UVLED1Qty,
        TH_UVLED2Qty,
        TH_UVLED3Qty,
        TH_UVLED4Qty,
        TH_UVLED5Qty,
        TH_UVLED6Qty,
        //
        TH_PSU1Qty,
        TH_PSU2Qty,
        TH_PSU3Qty,
        TH_PSU4Qty,//30
        TH_PSU5Qty,
        //
        TH_MCBEMI1Qty,
        TH_MCBEMI2Qty,
        TH_MCBEMI3Qty,
        TH_MCBEMI4Qty,
        TH_MCBEMI5Qty,
        //
        TH_ContactSw1Qty,
        TH_ContactSw2Qty,
        TH_ContactSw3Qty,
        TH_ContactSw4Qty,//40
        TH_ContactSw5Qty,
        //
        TH_BMotor1Qty,
        TH_BMotor2Qty,
        TH_BMotor3Qty,
        TH_BMotor4Qty,
        TH_BMotor5Qty,
        //
        TH_CapInd1Qty,
        TH_CapInd2Qty,
        TH_CapInd3Qty,
        TH_CapInd4Qty,//50
        TH_CapInd5Qty,
        //
        TH_Custom1Qty,
        TH_Custom2Qty,
        TH_Custom3Qty,
        TH_Custom4Qty,
        TH_Custom5Qty,
        TH_Custom6Qty,
        TH_Custom7Qty,
        TH_Custom8Qty,
        //
        TH_Filter1Qty,//60
        TH_Filter2Qty,
        TH_Filter3Qty,
        TH_Filter4Qty,
        TH_Filter5Qty,//64
    };

    /// Generate Regex String
    QString replacementText[totalParameter];
    short j = 0, k = 0;
    for(short i=TH_UnitModel; i<totalParameter; i++){
        if(i == allCheckParameter[j]){
            replacementText[i-1] = lis.at(i).toInt() > 0 ? checked : unChecked;
            j++;
        }else if(i == allQtyParameter[k]){
            replacementText[i-1] = lis.at(i).toInt() > 0 ? lis.at(i) : "";
            k++;
        }else{
            replacementText[i-1] = lis.at(i);
        }
        qDebug() << i-1 << lis.at(i);
    }//

    QRegularExpression regex;

    for(int i=TH_UnitModel; i<totalParameter; i++){
        if(i > TH_Filter5Check) break;
        regex.setPattern("#@" + QString::number(i) + "@#");
        rpText.replace(regex, replacementText[i-1]);
        //qDebug() << "#@" + QString::number(i) + "@#" << replacementText[i-1];
    }
    //qDebug() << "-> 1";
    /// Footer
    regex.setPattern("#@PRINTED@#");
    rpText.replace(regex, exportDateTime);
    //qDebug() << "-> 2";
    regex.setPattern("#@FM-ELQ-REV@#");
    rpText.replace(regex, formRpRev);
    //qDebug() << "-> 3";
    regex.setPattern("#@FM-ELQ-PATH@#");
    rpText.replace(regex, formRpPath);
    //qDebug() << "-> 4";
    docPdfStr = rpText;

    return docPdfStr;
}//

//QString ReplaceableCompRecordQmlApp::_docPdfFooter(int page, int maxPage)
//{
//    qDebug() << __func__ << page << maxPage << thread();

//    QString head;
//    QStringList list;

//    list.append("<table id='footerTable' cellspacing=0 width=100%>");
//    list.append("   <tr>");
//    list.append("       <th>Page "+ QString::number(page) +" of "+ QString::number(maxPage) +"</th>");
//    list.append("   </tr>");
//    list.append("</table>\n");

//    head = list.join("\n");
//    return head;
//}//

void ReplaceableCompRecordQmlApp::checkFiles()
{
    QString d, currentPath = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    QDir dir;

    d = currentPath + "/report";
    if (!dir.exists(d)) {
        dir.mkdir(d);
    }

    d = currentPath + "/report/resource";
    if (!dir.exists(d)) {
        dir.mkdir(d);
    }

    d = currentPath + "/report/script";
    if (!dir.exists(d)) {
        dir.mkdir(d);
    }

#ifdef __arm__
    {
        m_qprocess.start("rootrw");
        m_qprocess.waitForFinished();
        QString oldFile, newFile;

        oldFile = "/usr/local/bin/fremove";
        newFile = ":/Generic/fremove";
        if(!filesAreIdentical(oldFile, newFile) || !QFile().exists(oldFile)){
            QFile().remove(oldFile);
            if(QFile().copy(newFile, oldFile))
            {
                QString cmd = "chmod +x " + oldFile;
                m_qprocess.start(cmd);
                m_qprocess.waitForFinished();
                qDebug() << oldFile << "exitCode" << m_qprocess.exitCode();
            }//
        }//
        m_qprocess.start("rootro");
        m_qprocess.waitForFinished();
    }//
#endif

    QString a, b;

    //    {
    //        a = currentPath + "/report/resource/esco_life_blue.png";
    //        QFile file(a);
    //        b = ":/UI/Pictures/logo/esco_lifesciences_group_blue.png";
    //        if (!file.exists()) {
    //            QFile::copy(b, a);
    //        }else{
    //            if(!filesAreIdentical(a, b)){
    //#ifdef __arm__
    //                m_qprocess.start("fremove", QStringList() << a);
    //#else
    //                QFile().remove(a);
    //                m_qprocess.start("del", QStringList() << "-f" << a);
    //#endif
    //                m_qprocess.waitForFinished();
    //                if(!m_qprocess.exitCode()){
    //                    QFile::copy(b, a);
    //                }
    //            }
    //        }
    //    }

    QFile html(currentPath + "/report/script/rp.html");
    {
        //if (!html.exists()) {
        html.open(QFile::WriteOnly | QFile::Text);
        QTextStream streamHtml(&html);
        streamHtml << "This file is generated by Qt\n";
        html.close();
    }

    a = currentPath + "/report/script/rp-temp.html";
    QFile html1(a);
    b = ":/Generic/rp-temp.html";
    if (!html1.exists()) {
        QFile::copy(b, a);
    }else{
        if(!filesAreIdentical(a, b)){
#ifdef __arm__
            m_qprocess.start("rm -f " +  a);
#else
            QFile().remove(a);
            m_qprocess.start("del", QStringList() << "-f" << a);
#endif
            m_qprocess.waitForFinished();
            if(!m_qprocess.exitCode()){
                QFile::copy(b, a);
            }
        }
    }

    a = currentPath + "/report/script/layout-rp.css";
    QFile css(a);
    b = ":/Generic/layout-rp.css";
    if (!css.exists()) {
        QFile::copy(b, a);
    }else{
        if(!filesAreIdentical(a, b)){
#ifdef __arm__
            m_qprocess.start("rm -f " + a);
#else
            QFile().remove(a);
            m_qprocess.start("del", QStringList() << "-f" << a);
#endif
            m_qprocess.waitForFinished();
            if(!m_qprocess.exitCode()){
                QFile::copy(b, a);
            }
        }//
    }//

#ifdef __arm__
    ///Remove All Remaining PDF File
    a = currentPath + "/report/*.pdf";
    m_qprocess.start("rm -f " + a);
#endif
}//

void ReplaceableCompRecordQmlApp::setPagesItemPerPage(int pagesItemPerPage)
{
    if(pagesItemPerPage == 0) pagesItemPerPage = 1;
    if (m_pagesItemPerPage == pagesItemPerPage)
        return;

    m_pagesItemPerPage = pagesItemPerPage;
    emit pagesItemPerPageChanged(m_pagesItemPerPage);
}

void ReplaceableCompRecordQmlApp::setInitialized(bool initialized)
{
    if (m_initialized == initialized)
        return;

    m_initialized = initialized;
    emit initializedChanged(m_initialized);
}

bool ReplaceableCompRecordQmlApp::getLastQueryError() const
{
    return m_lastQueryError;
}

int ReplaceableCompRecordQmlApp::getDelayEmitSignal() const
{
    return m_delayEmitSignal;
}

int ReplaceableCompRecordQmlApp::getPagesCurrentNumber() const
{
    return m_pagesCurrentNumber;
}

int ReplaceableCompRecordQmlApp::getPagesNextNumber() const
{
    return m_pagesNextNumber;
}

int ReplaceableCompRecordQmlApp::getPagesPreviousNumber() const
{
    return m_pagesPreviousNumber;
}

int ReplaceableCompRecordQmlApp::getPagesTotal() const
{
    return m_pagesTotal;
}

int ReplaceableCompRecordQmlApp::getTotalItem() const
{
    return m_totalItem;
}

int ReplaceableCompRecordQmlApp::getPagesItemPerPage() const
{
    return m_pagesItemPerPage;
}

bool ReplaceableCompRecordQmlApp::filesAreIdentical(const QString filePath1, const QString filePath2)
{
    return _fileChecksum(filePath1) == _fileChecksum(filePath2);
}//

// Returns empty QByteArray() on failure.
QByteArray ReplaceableCompRecordQmlApp::_fileChecksum(const QString &fileName,
                                                    QCryptographicHash::Algorithm hashAlgorithm)
{
    QFile f(fileName);
    if (f.open(QFile::ReadOnly)) {
        QCryptographicHash hash(hashAlgorithm);
        if (hash.addData(&f)) {
            return hash.result();
        }
    }
    return QByteArray();
}
