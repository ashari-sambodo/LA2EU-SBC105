#include "EventLogQmlApp.h"
#include <QThread>
#include <QEventLoop>
#include <QDate>
#include <cmath>

#include <QPdfWriter>
#include <QFile>
#include <QPainter>
#include <QDir>
#include <QStandardPaths>

EventLogQmlApp::EventLogQmlApp(QObject *parent) : QObject(parent)
{

}

bool EventLogQmlApp::getInitialized() const
{
    return m_initialized;
}

void EventLogQmlApp::init(const QString &uniqConnectionName, const QString &fileName)
{
    // sanity check dont allow to double created the instance
    if (m_pThread != nullptr) return;

    m_pThread = QThread::create([&, uniqConnectionName, fileName](){
        //        qDebug() << "m_pThread::create" << thread();

        m_pSql.reset(new EventLogSqlGet());
        bool initialized = m_pSql->init(uniqConnectionName, fileName);

        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        setInitialized(initialized);

        QEventLoop loop;
        //        connect(this, &EventLogQmlApp::destroyed, &loop, &QEventLoop::quit);
        loop.exec();

        //        qDebug() << "m_pThread::end";
    });

    //// Tells the thread's event loop to exit with return code 0 (success).
    connect(this, &EventLogQmlApp::destroyed, m_pThread, &QThread::quit);
    connect(m_pThread, &QThread::finished, m_pThread, [&](){
        qDebug() << "Thread has finished";
    });
    connect(m_pThread, &QThread::finished, m_pThread, &QThread::deleteLater);
    connect(m_pThread, &QThread::destroyed, m_pThread, [&](){
        qDebug() << "Thread will destroying";
    });
    m_pThread->start();
}

//void EventLogQmlApp::insert(const QVariantMap data)
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

void EventLogQmlApp::selectDescendingWithPagination(short pageNumber)
{
    qDebug() << __func__ << m_pagesItemPerPage << pageNumber << thread();

    QMetaObject::invokeMethod(m_pSql.data(), [&, pageNumber](){
        qDebug() << __func__ << thread();

        int count = 0;
        bool done = m_pSql->queryCount(&count);
        setTotalItem(count);
        /// update pages properties
        int _totalPages = std::ceil(count/(float)m_pagesItemPerPage);
        //        qDebug() << "_totalPages:" << _totalPages;
        setPagesTotal(_totalPages);

        if(count == 0){
            int _pageNumber = 1;
            setPagesCurrentNumber(_pageNumber);
            setPagesNextNumber(_pageNumber);
            setPagesPreviousNumber(_pageNumber);

            emit selectHasDone(done, QVariantList(), count);
            return ;
        }

        short offset = (m_pagesItemPerPage * pageNumber) - m_pagesItemPerPage;
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
                item.insert("rowid",        itemTemp.at(0));
                item.insert("date",         itemTemp.at(1));
                item.insert("time",         itemTemp.at(2));
                item.insert("logCode",      itemTemp.at(3));
                item.insert("logText",      itemTemp.at(4));
                item.insert("logDesc",      itemTemp.at(5));
                item.insert("logCategory",  itemTemp.at(6));
                item.insert("username",     itemTemp.at(7));
                item.insert("userfullname", itemTemp.at(8));

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

        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit selectHasDone(done, logReady, count);
    });
}

void EventLogQmlApp::deleteAll()
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

        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit deleteHasDone(done, count);
    });
}

void EventLogQmlApp::deleteWhereOlderThanDays(int days)
{
    qDebug() << __func__ << thread();

    QMetaObject::invokeMethod(m_pSql.data(), [&](){
        qDebug() << __func__ << thread();

        QDate targetDate = QDate::currentDate().addDays(-days);
        QString options = QString(" WHERE date <= '%1'").arg(targetDate.toString("yyyy-MM-dd"));
        qDebug() << options;

        bool done = m_pSql->queryDelete(options);
        setLastQueryError(!done);

        if(!done) {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        /// get the total rows after delete
        int count = 0;
        m_pSql->queryCount(&count);

        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit deleteHasDone(done, count);
    });
}

void EventLogQmlApp::setLastQueryError(bool lastQueryError)
{
    if (m_lastQueryError == lastQueryError)
        return;

    m_lastQueryError = lastQueryError;
    emit lastQueryErrorChanged(m_lastQueryError);
}

void EventLogQmlApp::setDelayEmitSignal(int delayEmitSignal)
{
    if (m_delayEmitSignal == delayEmitSignal)
        return;

    m_delayEmitSignal = delayEmitSignal;
    emit delayEmitSignalChanged(m_delayEmitSignal);
}

void EventLogQmlApp::setPagesCurrentNumber(int pagesCurrentNumber)
{
    if (m_pagesCurrentNumber == pagesCurrentNumber)
        return;

    m_pagesCurrentNumber = pagesCurrentNumber;
    emit pagesCurrentNumberChanged(m_pagesCurrentNumber);
}

void EventLogQmlApp::setPagesNextNumber(int pagesNextNumber)
{
    if (m_pagesNextNumber == pagesNextNumber)
        return;

    m_pagesNextNumber = pagesNextNumber;
    emit pagesNextNumberChanged(m_pagesNextNumber);
}

void EventLogQmlApp::setPagesPreviousNumber(int pagesPreviousNumber)
{
    if (m_pagesPreviousNumber == pagesPreviousNumber)
        return;

    m_pagesPreviousNumber = pagesPreviousNumber;
    emit pagesPreviousNumberChanged(m_pagesPreviousNumber);
}

void EventLogQmlApp::setPagesTotal(short pagesTotal)
{
    if (m_pagesTotal == pagesTotal)
        return;

    m_pagesTotal = pagesTotal;
    emit pagesTotalChanged(m_pagesTotal);
}

void EventLogQmlApp::setTotalItem(int totalItem)
{
    if (m_totalItem == totalItem)
        return;

    m_totalItem = totalItem;
    emit totalItemChanged(m_totalItem);
}

void EventLogQmlApp::exportLogs(int pageNumber,
                                const QString exportedDateTime,
                                const QString serialNumber,
                                const QString cabinetModel,
                                int pagesCount)
{
    qDebug() << __func__ << thread();

    QMetaObject::invokeMethod(m_pSql.data(), [
                              &,
                              pageNumber,
                              exportedDateTime,
                              serialNumber,
                              cabinetModel,
                              pagesCount](){

        qDebug() << __func__ << pageNumber << thread();

        int count = 0;
        int totalPages = 0;
        QVariantList logReady;

        ///DATABASE QUERY SECTION
        {
            bool done = m_pSql->queryCount(&count);
            if(count == 0){
                emit logHasExported(false, "No log available yet");
                return ;
            }

            /// update pages properties
            totalPages = std::ceil(count/(float)m_pagesItemPerPage);
            int totalItemNeedToExport = m_pagesItemPerPage * pagesCount;
            short offset = (m_pagesItemPerPage * pageNumber) - m_pagesItemPerPage;
            QString options = QString().asprintf(" ORDER BY ROWID DESC LIMIT %d OFFSET %d", totalItemNeedToExport, offset);

            QVariantList logBuffer;
            done = m_pSql->querySelect(&logBuffer, options);
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

                    //            item.insert("rowid",        itemTemp.at(0));
                    item.insert("rowNo",        ((pageNumber * m_pagesItemPerPage) - m_pagesItemPerPage) + i + 1);
                    item.insert("date",         itemTemp.at(1));
                    item.insert("time",         itemTemp.at(2));
                    item.insert("logCode",      itemTemp.at(3));
                    item.insert("logText",      itemTemp.at(4));
                    item.insert("logDesc",      itemTemp.at(5));
                    item.insert("logCategory",  itemTemp.at(6));
                    item.insert("username",     itemTemp.at(7));
                    item.insert("userfullname", itemTemp.at(8));

                    logReady.append(item);
                }
            }
            else {
                qWarning() << m_pSql->lastQueryErrorStr();
                emit logHasExported(false, m_pSql->lastQueryErrorStr());
                return;
            }
        }

        /// GENERATE PDF FILE SECTION
        QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
        qDebug() << targetDir;

        QString dateTime = QDateTime::currentDateTime().toString("yyyyMMdd_hhmmss");
        QString fileName = targetDir + QString("/EventLog_P%1-%2of%3_%4.pdf").arg(pageNumber).arg(pageNumber + pagesCount - 1).arg(totalPages).arg(dateTime);
        //        QString fileName = targetDir + QString("/eventlog_p%1-%2of%3.pdf").arg(pageNumber).arg(pageNumber + pagesCount - 1).arg(totalPages);
        QFile pdfFile(fileName);
        bool fileIsOK = pdfFile.open(QIODevice::WriteOnly);
        qDebug() << fileIsOK;
        if(!fileIsOK){
            emit logHasExported(false, tr("Failed to initiate file"));
            return ;
        }

        QScopedPointer<QPdfWriter> pPdfWriter(new QPdfWriter(&pdfFile));
        pPdfWriter->setPageSize(QPageSize(QPageSize::A4));
        pPdfWriter->setResolution(300); // Set the resolution of the paper to 300, so its pixels are 3508X2479

        int margins = 30;
        pPdfWriter->setPageMargins(QMargins(margins, margins, margins, margins));

        QScopedPointer<QPainter> pPdfPainter(new QPainter(pPdfWriter.data()));
        QRect rect(0, 0, pPdfWriter->width(), pPdfWriter->height());

        int totalPagesNeedToExport = std::ceil(((float) logReady.length()) / ((float)m_pagesItemPerPage));
        for (int j=0; j<totalPagesNeedToExport; j++){
            /// Consider to create new page
            if(j) pPdfWriter->newPage();

            int textMarginTop   = 0;
            int textHeightRect  = 55;

            QTextOption textOption(Qt::AlignHCenter | Qt::AlignVCenter);
            textOption.setWrapMode(QTextOption::WordWrap);

            QFont font;
            font.setPointSize(14);
            QFontMetrics metrics = QFontMetrics(font);
            pPdfPainter->setFont(font);

            /// Title
            rect.setRect(0, textMarginTop, pPdfWriter->width(), textHeightRect + 100);
            pPdfPainter->drawText(rect, QString("Event Log"), textOption);
            textMarginTop = textMarginTop + textHeightRect + 100;

            font.setPointSize(8);
            pPdfPainter->setFont(font);
            ///DOCUMENT ID
            textOption.setAlignment(Qt::AlignLeft);
            rect.setRect(0, textMarginTop, 250, textHeightRect);
            pPdfPainter->drawText(rect, QString("Exported at"),
                                  textOption);
            rect.setRect(250, textMarginTop, 400, textHeightRect);
            pPdfPainter->drawText(rect, QString(exportedDateTime).prepend(": "),
                                  textOption);
            textMarginTop = textMarginTop + textHeightRect;

            rect.setRect(0, textMarginTop, 250, textHeightRect);
            pPdfPainter->drawText(rect, QString("Cabinet Serial"),
                                  textOption);
            rect.setRect(250, textMarginTop, 400, textHeightRect);
            pPdfPainter->drawText(rect, QString(serialNumber).prepend(": "),
                                  textOption);
            textMarginTop = textMarginTop + textHeightRect;
            rect.setRect(0, textMarginTop, 250, textHeightRect);
            pPdfPainter->drawText(rect, QString("Cabinet Model"),
                                  textOption);
            rect.setRect(250, textMarginTop, 400, textHeightRect);
            pPdfPainter->drawText(rect, QString(cabinetModel).prepend(": "),
                                  textOption);
            textMarginTop = textMarginTop + textHeightRect + 10;

            /// TABLE HEADER
            int textWidthRectColumn1 = 150;
            int textWidthRectColumn2 = 250;
            int textWidthRectColumn3 = 250;
            int textWidthRectColumn5 = 450;
            int textWidthRectColumn4 = pPdfWriter->width() - textWidthRectColumn1 - textWidthRectColumn2 - textWidthRectColumn3 - textWidthRectColumn5;

            int colBegin1 = 0;
            int colBegin2 = textWidthRectColumn1;
            int colBegin3 = colBegin2 + textWidthRectColumn2;
            int colBegin4 = colBegin3 + textWidthRectColumn3;
            int colBegin5 = colBegin4 + textWidthRectColumn4;

            textOption.setAlignment(Qt::AlignHCenter | Qt::AlignVCenter);

            rect.setRect(colBegin1, textMarginTop, pPdfWriter->width(), textHeightRect);
            pPdfPainter->fillRect(rect, QBrush(Qt::cyan));

            pPdfPainter->fillRect(rect, QBrush(Qt::transparent));
            rect.setRect(colBegin1, textMarginTop, textWidthRectColumn1, textHeightRect);
            pPdfPainter->drawRect(rect);
            pPdfPainter->drawText(rect, QString::fromLocal8Bit("No"), textOption);

            rect.setRect(colBegin2, textMarginTop, textWidthRectColumn2, textHeightRect);
            pPdfPainter->drawRect(rect);
            pPdfPainter->drawText(rect, QString::fromLocal8Bit("Date"), textOption);

            rect.setRect(colBegin3, textMarginTop, textWidthRectColumn3, textHeightRect);
            pPdfPainter->drawRect(rect);
            pPdfPainter->drawText(rect, QString::fromLocal8Bit("Time(24h)"), textOption);

            rect.setRect(colBegin4, textMarginTop, textWidthRectColumn4, textHeightRect);
            pPdfPainter->drawRect(rect);
            pPdfPainter->drawText(rect, QString::fromLocal8Bit("Event"), textOption);

            rect.setRect(colBegin5, textMarginTop, textWidthRectColumn5, textHeightRect);
            pPdfPainter->drawRect(rect);
            pPdfPainter->drawText(rect, QString::fromLocal8Bit("User"), textOption);
            ///
            //    pPdfPainter->setPen(QPen(Qt::red));
            //    pPdfPainter->drawLine(QLine(0, 200, pPdfWriter->width(), 200));

            textMarginTop = textMarginTop + textHeightRect;

            /// TABLE CONTENT
            QString textContent;
            QVariantMap dataHolderMap;
            qDebug() << logReady.length();

            int pageSection = j * m_pagesItemPerPage;
            int pageSectionLimit  = j * m_pagesItemPerPage + m_pagesItemPerPage;
            pageSectionLimit = pageSectionLimit > logReady.length() ? logReady.length() : pageSectionLimit;

            for (int i=pageSection; i<pageSectionLimit; i++) {
                dataHolderMap = logReady.at(i).toMap();
                //            qDebug() << dataHolderMap;

                rect.setRect(colBegin1, textMarginTop, pPdfWriter->width(), textHeightRect);
                pPdfPainter->fillRect(rect, QBrush(i % 2 ? Qt::lightGray : Qt::transparent));

                pPdfPainter->fillRect(rect, QBrush(Qt::transparent));
                rect.setRect(colBegin1, textMarginTop, textWidthRectColumn1, textHeightRect);
                pPdfPainter->drawRect(rect);
                textContent = dataHolderMap.value("rowNo").toString();
                pPdfPainter->drawText(rect, textContent, textOption);

                rect.setRect(colBegin2, textMarginTop, textWidthRectColumn2, textHeightRect);
                pPdfPainter->drawRect(rect);
                textContent = dataHolderMap.value("date").toString();
                pPdfPainter->drawText(rect, textContent, textOption);

                rect.setRect(colBegin3, textMarginTop, textWidthRectColumn3, textHeightRect);
                pPdfPainter->drawRect(rect);
                textContent = dataHolderMap.value("time").toString();
                pPdfPainter->drawText(rect, textContent, textOption);

                rect.setRect(colBegin4, textMarginTop, textWidthRectColumn4, textHeightRect);
                pPdfPainter->drawRect(rect);
                textContent = dataHolderMap.value("logText").toString();
                //            textContent = QString("1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30");
                //            qDebug() << textWidthRectColumn4;
                textContent = metrics.elidedText(textContent, Qt::ElideMiddle, 360);
                QRect rectEvent(colBegin4 + 10, textMarginTop, textWidthRectColumn4, textHeightRect);
                textOption.setAlignment(Qt::AlignLeft);
                pPdfPainter->drawText(rectEvent, textContent, textOption);

                rect.setRect(colBegin5, textMarginTop, textWidthRectColumn5, textHeightRect);
                pPdfPainter->drawRect(rect);
                textContent = dataHolderMap.value("userfullname").toString();
                textContent = metrics.elidedText(textContent, Qt::ElideMiddle, 150);
                textOption.setAlignment(Qt::AlignHCenter | Qt::AlignVCenter);
                pPdfPainter->drawText(rect, textContent, textOption);

                textMarginTop = textMarginTop + textHeightRect;
            }

            /// page indicator
            textOption.setAlignment(Qt::AlignHCenter | Qt::AlignVCenter);
            rect.setRect(0, pPdfWriter->height() - textHeightRect, pPdfWriter->width(), textHeightRect);
            textContent = QString("Page %1 of %2").arg(pageNumber + j).arg(totalPages);
            pPdfPainter->drawText(rect, textContent, textOption);
        }

        pPdfPainter.reset();
        pPdfWriter.reset();
        pdfFile.close();

        emit logHasExported(true, pdfFile.fileName());
    });
}

void EventLogQmlApp::setPagesItemPerPage(int pagesItemPerPage)
{
    if(pagesItemPerPage == 0) pagesItemPerPage = 1;
    if (m_pagesItemPerPage == pagesItemPerPage)
        return;

    m_pagesItemPerPage = pagesItemPerPage;
    emit pagesItemPerPageChanged(m_pagesItemPerPage);
}

void EventLogQmlApp::setInitialized(bool initialized)
{
    if (m_initialized == initialized)
        return;

    m_initialized = initialized;
    emit initializedChanged(m_initialized);
}

bool EventLogQmlApp::getLastQueryError() const
{
    return m_lastQueryError;
}

int EventLogQmlApp::getDelayEmitSignal() const
{
    return m_delayEmitSignal;
}

int EventLogQmlApp::getPagesCurrentNumber() const
{
    return m_pagesCurrentNumber;
}

int EventLogQmlApp::getPagesNextNumber() const
{
    return m_pagesNextNumber;
}

int EventLogQmlApp::getPagesPreviousNumber() const
{
    return m_pagesPreviousNumber;
}

int EventLogQmlApp::getPagesTotal() const
{
    return m_pagesTotal;
}

int EventLogQmlApp::getTotalItem() const
{
    return m_totalItem;
}

int EventLogQmlApp::getPagesItemPerPage() const
{
    return m_pagesItemPerPage;
}
