#include "BookingScheduleQmlApp.h"
#include "BookingScheduleSqlGet.h"
#include <QThread>
#include <QEventLoop>
#include <QDate>
#include <cmath>

#include <QPdfWriter>
#include <QFile>
#include <QPainter>
#include <QDir>
#include <QStandardPaths>

#define MAXIMUM_ALLOW_ROWS 365 * 17 /// 1 year
//#define MAXIMUM_ALLOW_ROWS 3 /// 1 year

BookingScheduleQmlApp::BookingScheduleQmlApp(QObject *parent) : QObject(parent)
{

}
bool BookingScheduleQmlApp::getInitialized() const
{
    return m_initialized;
}

bool BookingScheduleQmlApp::getLastQueryError() const
{
    return m_lastQueryError;
}

int BookingScheduleQmlApp::getDelayEmitSignal() const
{
    return m_delayEmitSignal;
}

int BookingScheduleQmlApp::getTotalRows() const
{
    return m_totalRows;
}

int BookingScheduleQmlApp::getMaximumRows() const
{
    return MAXIMUM_ALLOW_ROWS;
}

bool BookingScheduleQmlApp::isRowsHasMaximum() const
{
    return m_totalRows == MAXIMUM_ALLOW_ROWS ;
}

void BookingScheduleQmlApp::init(const QString &uniqConnectionName, const QString &fileName)
{
    // sanity check dont allow to double created the instance
    if (m_pThread != nullptr) return;

    m_pThread = QThread::create([&, uniqConnectionName, fileName](){
        //        qDebug() << "m_pThread::create" << thread();

        m_pSql.reset(new BookingScheduleSqlGet());
        bool initialized = m_pSql->init(uniqConnectionName, fileName);
        if(initialized) {
            int count = 0;
            m_pSql->queryCount(&count);
            setTotalRows(count);
        }

        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        setInitialized(initialized);

        QEventLoop loop;
        loop.exec();

        //        qDebug() << "m_pThread::end";
    });

    //// Tells the thread's event loop to exit with return code 0 (success).
    connect(this, &BookingScheduleQmlApp::destroyed, m_pThread, &QThread::quit);
    //    connect(m_pThread, &QThread::finished, m_pThread, [&](){
    //        qDebug() << "Thread has finished";
    //    });
    connect(m_pThread, &QThread::finished, m_pThread, &QThread::deleteLater);
    //    connect(m_pThread, &QThread::destroyed, m_pThread, [&](){
    //        qDebug() << "Thread will destroying";
    //    });
    m_pThread->start();
}

void BookingScheduleQmlApp::insert(const QVariantMap data)
{
    qDebug() << __func__ << thread();

    QMetaObject::invokeMethod(m_pSql.data(), [&, data](){
        qDebug() << __func__ << thread();

        bool done = m_pSql->queryInsert(data);
        setLastQueryError(!done);
        if(!done) {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        /// get the total rows after delete
        int count = 0;
        m_pSql->queryCount(&count);
        setTotalRows(count);

        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit insertedHasDone(done, data);
    });
}

void BookingScheduleQmlApp::selectByDate(const QString dateStr)
{
    qDebug() << __func__ << dateStr << thread();

    QMetaObject::invokeMethod(m_pSql.data(), [&, dateStr](){
        qDebug() << __func__ << thread();

        /// get the total rows after delete
        int count = 0;
        m_pSql->queryCount(&count);
        setTotalRows(count);

        QString options = QString().asprintf(" WHERE date='%s' ORDER BY time", qPrintable(dateStr));

        QVariantList logBuffer, logReady;
        bool done = m_pSql->querySelect(&logBuffer, options);
        setLastQueryError(!done);
        if(done) {
            /// Reconstructing every item to JSON/VariantMaplist
            /// so, QML Listview ease to present the data
            QVariantMap item;
            QVariantList itemTemp;

            /// insert empty slot, so booking will displayed as a series start from 6.00 to 22.00
            QString timeStr;
            for(int i=6; i < 23; i++) {
                item.clear();

                timeStr = QString("%1:00").arg(i, 2, 10, QLatin1Char('0'));

                item.insert("rowid",     "");
                item.insert("date",      dateStr);
                item.insert("time",      timeStr);
                item.insert("bookTitle", "");
                item.insert("bookBy",    "");
                item.insert("note1",     "");
                item.insert("note2",     "");
                item.insert("note3",     "");
                item.insert("createdAt", "");

                logReady.append(item);
            }

            /// Repelace booked slot
            QTime timeParsed;
            //            qDebug() << "logBuffer" << logBuffer.length();
            for(int i=0; i < logBuffer.length(); i++){
                itemTemp = logBuffer.at(i).toList();

                item.clear();
                item.insert("rowid",     itemTemp.at(0));
                item.insert("date",      itemTemp.at(1));
                item.insert("time",      itemTemp.at(2));
                item.insert("bookTitle", itemTemp.at(3));
                item.insert("bookBy",    itemTemp.at(4));
                item.insert("note1",     itemTemp.at(5));
                item.insert("note2",     itemTemp.at(6));
                item.insert("note3",     itemTemp.at(7));
                item.insert("createdAt", itemTemp.at(8));

                timeParsed = QTime::fromString(itemTemp.at(2).toString(), "HH:mm");
                int slotIndex = timeParsed.hour();
                //                qDebug() << "slotIndex" << slotIndex;
                logReady[slotIndex-6] = item;
            }
        }
        else {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        /// total row not implemented in booking schedule
        emit selectHasDone(done, logReady, -1);

        //        qDebug() << __func__ << logReady;
    });
}

void BookingScheduleQmlApp::deleteByDateTime(const QString dateStr, const QString timeStr)
{
    QMetaObject::invokeMethod(m_pSql.data(), [&, dateStr, timeStr](){
        qDebug() << __func__ << thread();

        QString options = QString(" WHERE date='%1' AND time='%2'").arg(dateStr, timeStr);
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

void BookingScheduleQmlApp::deleteAll()
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
        setTotalRows(count);

                if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit deleteHasDone(done, count);
    });
}

void BookingScheduleQmlApp::deleteWhereOlderThanDays(int days)
{
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
        setTotalRows(count);

                if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit deleteHasDone(done, count);
    });
}

void BookingScheduleQmlApp::setLastQueryError(bool lastQueryError)
{
    if (m_lastQueryError == lastQueryError)
        return;

    m_lastQueryError = lastQueryError;
    emit lastQueryErrorChanged(m_lastQueryError);
}

void BookingScheduleQmlApp::setDelayEmitSignal(int delayEmitSignal)
{
    if (m_delayEmitSignal == delayEmitSignal)
        return;

    m_delayEmitSignal = delayEmitSignal;
    emit delayEmitSignalChanged(m_delayEmitSignal);
}

void BookingScheduleQmlApp::setInitialized(bool initialized)
{
    if (m_initialized == initialized)
        return;

    m_initialized = initialized;
    emit initializedChanged(m_initialized);
}

void BookingScheduleQmlApp::exportData(const QString targetDate,
                                       const QString exportedDateTime,
                                       const QString serialNumber,
                                       const QString cabinetModel)
{
    QMetaObject::invokeMethod(m_pSql.data(), [
                              &,
                              targetDate,
                              exportedDateTime,
                              serialNumber,
                              cabinetModel](){

        qDebug() << __func__ << targetDate << thread();

        ///get week number
        QDate qTargetDate = QDate::fromString(targetDate, "yyyy-MM-dd");
        short weekNumber = qTargetDate.weekNumber();
        /// there is 1 week diferent from USA week standard, because diffrent start day of week
        weekNumber = weekNumber + 1;
        short dayOfWeek = qTargetDate.dayOfWeek() - 1;
        QString startDateOfWeek = qTargetDate.addDays(-dayOfWeek).toString("yyyy-MM-dd");
        QString endDateOfWeek = qTargetDate.addDays(6-dayOfWeek).toString("yyyy-MM-dd");
        qDebug() << startDateOfWeek << endDateOfWeek;

        int count = 0;
        QVariantList logReady;

        ///DATABASE QUERY SECTION
        {
            bool done = m_pSql->queryCount(&count);
            if(count == 0){
                emit dataHasExported(false, "No log available yet");
                return ;
            }

            /// filter
            QString options = QString("  WHERE date >= '%1' AND date <= '%2' ORDER BY date, time").arg(startDateOfWeek, endDateOfWeek);

            QVariantList logBuffer;
            done = m_pSql->querySelect(&logBuffer, options);
            if(done) {

                /// Reconstructing every item to JSON/VariantMaplist
                /// so, QML Listview ease to present the data
                QVariantMap item;
                QVariantList itemTemp;

                QDate incStartDate = QDate::fromString(startDateOfWeek, "yyyy-MM-dd");
                for (int k=0; k<7; k++) {
                    /// insert empty slot, so booking will displayed as a series start from 6.00 to 22.00
                    for(int i=6; i < 23; i++) {
                        item.clear();

                        item.insert("rowid",     "");
                        item.insert("date",      incStartDate.addDays(k).toString("yyyy-MM-dd"));
                        item.insert("time",      QString("%1:00").arg(i, 2, 10, QLatin1Char('0')));
                        item.insert("bookTitle", "");
                        item.insert("bookBy",    "");
                        item.insert("note1",     "");
                        item.insert("note2",     "");
                        item.insert("note3",     "");
                        item.insert("createdAt", "");

                        logReady.append(item);
                    }
                }
                //                qDebug() << "logReady: " << logReady.length();
                //                qDebug() << "logBuffer: " << logBuffer.length();

                /// Repelace booked slot
                QDateTime dateTimeParsed;
                for(int i=0; i < logBuffer.length(); i++){
                    itemTemp = logBuffer.at(i).toList();

                    item.clear();
                    item.insert("rowid",     itemTemp.at(0));
                    item.insert("date",      itemTemp.at(1));
                    item.insert("time",      itemTemp.at(2));
                    item.insert("bookTitle", itemTemp.at(3));
                    item.insert("bookBy",    itemTemp.at(4));
                    item.insert("note1",     itemTemp.at(5));
                    item.insert("note2",     itemTemp.at(6));
                    item.insert("note3",     itemTemp.at(7));
                    item.insert("createdAt", itemTemp.at(8));

                    QString dateTimeSlotStr = QString("%1 %2").arg(itemTemp.at(1).toString(), itemTemp.at(2).toString());
                    dateTimeParsed = QDateTime::fromString(dateTimeSlotStr, "yyyy-MM-dd HH:mm");
                    int slotDateIndex = (dateTimeParsed.date().dayOfWeek() - 1) * 17;
                    int slotHourIndex = dateTimeParsed.time().hour() - 6;
                    qDebug() << "slotDateIndex: " << slotDateIndex << "slotIndex: " << slotHourIndex;
                    logReady[slotDateIndex + slotHourIndex] = item;
                    qDebug() << "logReady-replace" << logReady[slotDateIndex + slotHourIndex];
                }
            }
            else {
                qWarning() << m_pSql->lastQueryErrorStr();
                emit dataHasExported(false, m_pSql->lastQueryErrorStr());
                return;
            }
        }

        //        /// Demo Data
        //        QVariantMap item;
        //        /// 119 slots / week
        //        for(int i=0; i < 119; i++){
        //            item.clear();
        //            item.insert("date",      QString("2021-04-12"));
        //            item.insert("time",      QString("09:00"));
        //            item.insert("bookTitle", QString("Heri's Time"));
        //            item.insert("bookBy",    QString("Heri Cahyono"));
        //            item.insert("note1",     QString("I'm not a perfect person"));
        //            item.insert("note2",     QString("There's many thins I wish didn't do"));
        //            item.insert("note3",     QString("ABCDEFGHIJKLMNOPQRSTUPWYZASBC"));
        //            item.insert("createdAt", QString("2021-04-11 08:15:00"));

        //            logReady.append(item);
        //        }

        /// GENERATE PDF FILE SECTION
        QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
        qDebug() << targetDir;

        QString fileName = targetDir + QString("/booking_wk%1.pdf").arg(weekNumber);
        QFile pdfFile(fileName);
        bool fileIsOK = pdfFile.open(QIODevice::WriteOnly);
        //        qDebug() << fileIsOK;
        if(!fileIsOK){
            emit dataHasExported(false, tr("Failed to initiate file"));
            return ;
        }

        QScopedPointer<QPdfWriter> pPdfWriter(new QPdfWriter(&pdfFile));
        pPdfWriter->setPageSize(QPageSize(QPageSize::A4));
        pPdfWriter->setResolution(300); // Set the resolution of the paper to 300, so its pixels are 3508X2479

        int margins = 30;
        pPdfWriter->setPageMargins(QMargins(margins, margins, margins, margins));

        QScopedPointer<QPainter> pPdfPainter(new QPainter(pPdfWriter.data()));
        QRect rect(0, 0, pPdfWriter->width(), pPdfWriter->height());

        short pagesItemPerPage = 17;
        int totalPagesNeedToExport = std::ceil(((float) logReady.length()) / ((float)pagesItemPerPage));
        QFont font;
        for (int j=0; j<totalPagesNeedToExport; j++){
            /// Consider to create new page
            if(j) pPdfWriter->newPage();

            int textMarginTop   = 0;
            int textHeightRect  = 50;

            QTextOption textOption(Qt::AlignHCenter | Qt::AlignVCenter);
            textOption.setWrapMode(QTextOption::WordWrap);

            font.setPointSize(14);
            pPdfPainter->setFont(font);

            /// Title
            rect.setRect(0, textMarginTop, pPdfWriter->width(), textHeightRect + 100);
            pPdfPainter->drawText(rect, QString("Booking Schedule for Week %1").arg(weekNumber), textOption);
            textMarginTop = textMarginTop + textHeightRect + 100;

            font.setPointSize(8);
            pPdfPainter->setFont(font);
            ///DOCUMENT ID
            textOption.setAlignment(Qt::AlignLeft);
            rect.setRect(0, textMarginTop, 250, textHeightRect);
            pPdfPainter->drawText(rect, QString("Exported at"),
                                  textOption);
            rect.setRect(250, textMarginTop, 500, textHeightRect);
            pPdfPainter->drawText(rect, QString(exportedDateTime).prepend(": "),
                                  textOption);
            textMarginTop = textMarginTop + textHeightRect;

            rect.setRect(0, textMarginTop, 250, textHeightRect);
            pPdfPainter->drawText(rect, QString("Cabinet serial"),
                                  textOption);
            rect.setRect(250, textMarginTop, 500, textHeightRect);
            pPdfPainter->drawText(rect, QString(serialNumber).prepend(": "),
                                  textOption);
            textMarginTop = textMarginTop + textHeightRect;
            rect.setRect(0, textMarginTop, 250, textHeightRect);
            pPdfPainter->drawText(rect, QString("Cabinet model"),
                                  textOption);
            rect.setRect(250, textMarginTop, 500, textHeightRect);
            pPdfPainter->drawText(rect, QString(cabinetModel).prepend(": "),
                                  textOption);
            textMarginTop = textMarginTop + textHeightRect + 10;

            /// TABLE HEADER
            int textWidthRectColumn1 = 250;
            int textWidthRectColumn2 = 200;
            int textWidthRectColumn3 = 350;
            int textWidthRectColumn4 = 350;
            int textWidthRectColumn6 = 250;
            int textWidthRectColumn5 = pPdfWriter->width() -
                    (textWidthRectColumn6
                     + textWidthRectColumn4
                     + textWidthRectColumn3
                     + textWidthRectColumn2
                     + textWidthRectColumn1);

            int colBegin1 = 0;
            int colBegin2 = textWidthRectColumn1;
            int colBegin3 = colBegin2 + textWidthRectColumn2;
            int colBegin4 = colBegin3 + textWidthRectColumn3;
            int colBegin5 = colBegin4 + textWidthRectColumn4;
            int colBegin6 = colBegin5 + textWidthRectColumn5;

            textOption.setAlignment(Qt::AlignHCenter | Qt::AlignVCenter);

            rect.setRect(colBegin1, textMarginTop, pPdfWriter->width(), textHeightRect);
            pPdfPainter->fillRect(rect, QBrush(Qt::cyan));

            rect.setRect(colBegin1, textMarginTop, textWidthRectColumn1, textHeightRect);
            pPdfPainter->drawRect(rect);
            pPdfPainter->drawText(rect, QString::fromLocal8Bit("Date"), textOption);

            rect.setRect(colBegin2, textMarginTop, textWidthRectColumn2, textHeightRect);
            pPdfPainter->drawRect(rect);
            pPdfPainter->drawText(rect, QString::fromLocal8Bit("Time"), textOption);

            rect.setRect(colBegin3, textMarginTop, textWidthRectColumn3, textHeightRect);
            pPdfPainter->drawRect(rect);
            pPdfPainter->drawText(rect, QString::fromLocal8Bit("Title"), textOption);

            rect.setRect(colBegin4, textMarginTop, textWidthRectColumn4, textHeightRect);
            pPdfPainter->drawRect(rect);
            pPdfPainter->drawText(rect, QString::fromLocal8Bit("User"), textOption);

            rect.setRect(colBegin5, textMarginTop, textWidthRectColumn5, textHeightRect);
            pPdfPainter->drawRect(rect);
            pPdfPainter->drawText(rect, QString::fromLocal8Bit("Note"), textOption);

            rect.setRect(colBegin6, textMarginTop, textWidthRectColumn6, textHeightRect);
            pPdfPainter->drawRect(rect);
            pPdfPainter->drawText(rect, QString::fromLocal8Bit("Created at"), textOption);

            textMarginTop = textMarginTop + textHeightRect;
            textHeightRect = textHeightRect * 3;

            /// TABLE CONTENT
            QString textContent;
            QVariantMap dataHolderMap;
            qDebug() << logReady.length();

            int pageSection = j * pagesItemPerPage;
            int pageSectionLimit  = j * pagesItemPerPage + pagesItemPerPage;
            pageSectionLimit = pageSectionLimit > logReady.length() ? logReady.length() : pageSectionLimit;

            for (int i=pageSection; i<pageSectionLimit; i++) {
                dataHolderMap = logReady.at(i).toMap();
                //                qDebug() << dataHolderMap;

                rect.setRect(colBegin1, textMarginTop, pPdfWriter->width(), textHeightRect);
                pPdfPainter->fillRect(rect, QBrush(i % 2 ? Qt::lightGray : Qt::transparent));

                pPdfPainter->fillRect(rect, QBrush(Qt::transparent));

                rect.setRect(colBegin1, textMarginTop, textWidthRectColumn1, textHeightRect);
                pPdfPainter->drawRect(rect);
                textContent = dataHolderMap.value("date").toString();
                pPdfPainter->drawText(rect, textContent, textOption);

                rect.setRect(colBegin2, textMarginTop, textWidthRectColumn2, textHeightRect);
                pPdfPainter->drawRect(rect);
                textContent = dataHolderMap.value("time").toString();
                pPdfPainter->drawText(rect, textContent, textOption);

                rect.setRect(colBegin3, textMarginTop, textWidthRectColumn3, textHeightRect);
                pPdfPainter->drawRect(rect);
                textContent = dataHolderMap.value("bookTitle").toString();
                pPdfPainter->drawText(rect, textContent, textOption);

                rect.setRect(colBegin4, textMarginTop, textWidthRectColumn4, textHeightRect);
                pPdfPainter->drawRect(rect);
                textContent = dataHolderMap.value("bookBy").toString();
                pPdfPainter->drawText(rect, textContent, textOption);

                rect.setRect(colBegin5, textMarginTop, textWidthRectColumn5, textHeightRect);
                pPdfPainter->drawRect(rect);
                textContent = dataHolderMap.value("note1").toString();
                textContent.append("\n");
                textContent.append(dataHolderMap.value("note2").toString());
                textContent.append("\n");
                textContent.append(dataHolderMap.value("note3").toString());
                QRect rectNote(colBegin5 + 10, textMarginTop, textWidthRectColumn5, textHeightRect);
                textOption.setAlignment(Qt::AlignLeft);
                pPdfPainter->drawText(rectNote, textContent, textOption);

                rect.setRect(colBegin6, textMarginTop, textWidthRectColumn6, textHeightRect);
                pPdfPainter->drawRect(rect);
                textContent = dataHolderMap.value("createdAt").toString();
                textOption.setAlignment(Qt::AlignHCenter | Qt::AlignVCenter);
                pPdfPainter->drawText(rect, textContent, textOption);

                textMarginTop = textMarginTop + textHeightRect;
            }

            /// page indicator
            textOption.setAlignment(Qt::AlignHCenter | Qt::AlignVCenter);
            rect.setRect(0, pPdfWriter->height() - textHeightRect, pPdfWriter->width(), textHeightRect);
            textContent = QString("Page %1 of %2").arg(j+1).arg(totalPagesNeedToExport);
            pPdfPainter->drawText(rect, textContent, textOption);
        }

        pPdfPainter.reset();
        pPdfWriter.reset();
        pdfFile.close();

        emit dataHasExported(true, pdfFile.fileName());
    });
}

void BookingScheduleQmlApp::setTotalRows(int totalRow)
{
    if (m_totalRows == totalRow)
        return;

    m_totalRows = totalRow;
    emit totalRowsChanged(m_totalRows);
}
