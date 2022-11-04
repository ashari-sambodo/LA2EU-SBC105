/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import Qt.labs.calendar 1.0

Item {
    id: control

    signal clicked(var date)

    property alias targetDate: monthGrid.targetDate
    property alias targetMonth: monthGrid.month
    property alias targetYear: monthGrid.year

    property bool hightlightedToday: true
    property string colorGridRect: "#0F2952"
    property alias olderDateLimit: monthGrid.dateLowestLimit
    property alias futureDateLimit: monthGrid.dateHightestLimit

    signal yearRectanglePressed()

    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        RowLayout {
            Layout.fillWidth: true
            Layout.minimumHeight: 50
            spacing: 5

            Rectangle {
                Layout.fillHeight: true
                Layout.minimumWidth: 80
                color: leftArrowMouseArea.pressed ? "#1F95D7" : colorGridRect
                border.color: "#dddddd"
                radius: 5

                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/UI/Pictures/back-step.png"
                }//

                MouseArea {
                    id: leftArrowMouseArea
                    anchors.fill: parent
                    onClicked: {
                        monthGrid.prevMonth()
                    }//
                }//
            }//

            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: colorGridRect
                border.color: "#dddddd"
                radius: 5

                Text {
                    anchors.fill: parent
                    anchors.margins: 2
                    text: monthGrid.monthStrings[monthGrid.month]
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#dddddd"
                }//
            }//
            Rectangle {
                Layout.fillHeight: true
                Layout.minimumWidth: 80
                color: rightArrowMouseArea.pressed ? "#1F95D7" : colorGridRect
                border.color: "#dddddd"
                radius: 5

                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/UI/Pictures/next-step.png"
                }//

                MouseArea {
                    id: rightArrowMouseArea
                    anchors.fill: parent
                    onClicked: {
                        monthGrid.nextMonth()
                    }//
                }//
            }//
            Rectangle {
                Layout.fillHeight: true
                Layout.minimumWidth: 80
                color: leftArrowMouseArea1.pressed ? "#1F95D7" : colorGridRect
                border.color: "#dddddd"
                radius: 5

                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/UI/Pictures/back-step.png"
                }//

                MouseArea {
                    id: leftArrowMouseArea1
                    anchors.fill: parent
                    onClicked: {
                        monthGrid.prevYear()
                    }//
                }//
            }//
            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: colorGridRect
                border.color: "#dddddd"
                radius: 5

                Text {
                    anchors.fill: parent
                    text: monthGrid.year
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#dddddd"
                }//

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        yearRectanglePressed()
                    }
                }

            }//

            Rectangle {
                Layout.fillHeight: true
                Layout.minimumWidth: 80
                color: rightArrowMouseArea1.pressed ? "#1F95D7" : colorGridRect
                border.color: "#dddddd"
                radius: 5

                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/UI/Pictures/next-step.png"
                }//

                MouseArea {
                    id: rightArrowMouseArea1
                    anchors.fill: parent
                    onClicked: {
                        monthGrid.nextYear()
                    }//
                }//
            }//
        }//

        Item {
            id: dayOfWeekRow
            Layout.fillWidth: true
            Layout.minimumHeight: 30
            //                        locale: monthGrid.locale

            Row {
                anchors.centerIn: parent

                Repeater {
                    model: [
                        qsTr("Sunday"),
                        qsTr("Monday"),
                        qsTr("Tuesday"),
                        qsTr("Wednesday"),
                        qsTr("Thursday"),
                        qsTr("Friday"),
                        qsTr("Saturday")
                    ]

                    Rectangle {
                        width: dayOfWeekRow.width / 7
                        height: dayOfWeekRow.height
                        color: colorGridRect
                        border.color: "#dddddd"
                        radius: 5

                        Text {
                            text: modelData
                            font.pixelSize: 20
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "#dddddd"
                            elide: Text.ElideRight
                        }//
                    }//
                }//
            }//
        }//

        MonthGrid {
            id: monthGrid
            month: Calendar.January
            year: 2000
            locale: Qt.locale("en_US")
            //                        locale: Qt.locale("ja_JP")
            font.pixelSize: 20
            spacing: 2

            Layout.fillWidth: true
            Layout.fillHeight: true

            delegate: ItemDelegate {
                id: itemDelegate
                enabled: model.month === monthGrid.month

                /// solved the not consistent rectangle area
                /// when this component created by asyncronous
                height: (monthGrid.height / 6) - 1
                width: (monthGrid.width / 7) - 1

                background: Rectangle {
                    anchors.fill: parent
                    color: itemDelegate.pressed ? "#1F95D7" : colorGridRect
                    border.color: "#dddddd"
                    opacity: model.month === monthGrid.month ? 1 : 0.5
                    radius: 5
                }//

                Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    opacity: model.month === monthGrid.month ? 1 : 0.5
                    text: model.day
                    font: monthGrid.font
                    color: "#dddddd"
                }//

                Rectangle {
                    height: 5
                    width: parent.width - 10
                    //                    radius: 5
                    color: "#27ae60"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 2
                    visible: model.today
                }//

                onClicked: {
                    let selectDate = new Date()
                    selectDate.setDate(model.day)
                    selectDate.setMonth(model.month)
                    selectDate.setFullYear(model.year)
                    //                    //console.debug(Qt.formatDate(selectDate, "yyyy-MMM-dd"))
                    control.clicked(selectDate)
                }
            }//
            //        onClicked: {
            //            //console.debug(Qt.formatDate(date, "dd MMM yyyy"))
            //        }

            property var monthStrings: [
                qsTr("January"),
                qsTr("February"),
                qsTr("March"),
                qsTr("April"),
                qsTr("May"),
                qsTr("June"),
                qsTr("July"),
                qsTr("August"),
                qsTr("September"),
                qsTr("October"),
                qsTr("November"),
                qsTr("December")
            ]

            property var targetDate:  null
            property var dateHightestLimit: null
            property var dateLowestLimit: null

            function nextMonth(){
                let tempMonth = new Date(targetDate)
                tempMonth.setMonth(tempMonth.getMonth() + 1)

                //                //console.debug(Qt.formatDate(tempMonth, "dd MM yyyy"))

                if (dateHightestLimit !== null) {
                    //                    //console.debug(Qt.formatDate(dateHightestLimit, "dd MM yyyy"))
                    if(tempMonth > dateHightestLimit) return
                }

                //                //console.debug(Qt.formatDate(tempMonth, "dd MM yyyy"))

                targetDate = tempMonth
                monthGrid.month = tempMonth.getMonth()
                monthGrid.year = tempMonth.getFullYear()
            }//

            function prevMonth(){
                let tempMonth = new Date(targetDate)
                tempMonth.setMonth(tempMonth.getMonth() - 1)

                //                //console.debug(Qt.formatDate(tempMonth, "dd MM yyyy"))

                if (dateLowestLimit !== null) {
                    if(tempMonth < dateLowestLimit) return
                }

                //                //console.debug(Qt.formatDate(tempMonth, "dd MM yyyy"))

                targetDate = tempMonth
                monthGrid.month = tempMonth.getMonth()
                monthGrid.year = tempMonth.getFullYear()
            }//
            function nextYear(){
                let tempYear = new Date(targetDate)
                tempYear.setFullYear(tempYear.getFullYear() + 1)

                //                //console.debug(Qt.formatDate(tempYear, "dd MM yyyy"))

                if (dateHightestLimit !== null) {
                    //                    //console.debug(Qt.formatDate(dateHightestLimit, "dd MM yyyy"))
                    if(tempYear > dateHightestLimit) return
                }

                //                //console.debug(Qt.formatDate(tempYear, "dd MM yyyy"))

                targetDate = tempYear
                monthGrid.month = tempYear.getMonth()
                monthGrid.year = tempYear.getFullYear()
            }//

            function prevYear(){
                let tempYear = new Date(targetDate)
                tempYear.setFullYear(tempYear.getFullYear() - 1)

                //                //console.debug(Qt.formatDate(tempYear, "dd MM yyyy"))

                if (dateLowestLimit !== null) {
                    if(tempYear < dateLowestLimit) return
                }

                //                //console.debug(Qt.formatDate(tempYear, "dd MM yyyy"))

                targetDate = tempYear
                monthGrid.month = tempYear.getMonth()
                monthGrid.year = tempYear.getFullYear()
            }//
            //        Component.onCompleted: {
            //            currentDate = new Date()
            //            currentDate.setHours(0, 0, 0, 0)

            //            monthGrid.month = monthGrid.currentDate.getMonth()
            //            monthGrid.year = monthGrid.currentDate.getFullYear()

            //            dateHightestLimit = new Date()
            //            dateHightestLimit.setHours(0, 0, 0, 0)
            //            dateHightestLimit.setDate(31)
            //            dateHightestLimit.setMonth(Calendar.December)
            //            dateHightestLimit.setFullYear(2021)

            //            dataLowestLimit = new Date()
            //            dataLowestLimit.setHours(0, 0, 0, 0)
            //            dataLowestLimit.setDate(1)
            //            dataLowestLimit.setMonth(Calendar.January)
            //            dataLowestLimit.setFullYear(2020)
            //        }//
        }//
    }//
}
/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
