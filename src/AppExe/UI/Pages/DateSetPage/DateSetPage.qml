/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.calendar 1.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Date"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 5

            /// HEADER
            Item {
                id: headerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 60

                HeaderApp {
                    anchors.fill: parent
                    title: qsTr("Date")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                /// fragment container
                StackView {
                    id: fragmentStackView
                    anchors.fill: parent
                    initialItem: currentValueComponent
                }//

                /// fragment-1
                Component {
                    id: currentValueComponent

                    Item{
                        Column {
                            id: currentValueColumn
                            anchors.centerIn: parent
                            spacing: 5

                            TextApp{
                                text: qsTr("Current date") + ":"
                            }//

                            TextApp{
                                id: currentValueText
                                font.pixelSize: 36
                                wrapMode: Text.WordWrap
                                text: "---"

                                //                                width: Math.min(controlMaxWidthText.width, leftContentColumn.parent.width)

                                //                                Text {
                                //                                    visible: false
                                //                                    id: controlMaxWidthText
                                //                                    text: currentValueText.text
                                //                                    font.pixelSize: 36
                                //                                }//

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

                                ///////////////Timer for update current date
                                Timer{
                                    id: timeDateTimer
                                    running: true
                                    interval: 10000
                                    repeat: true
                                    triggeredOnStart: true
                                    onTriggered: {
                                        var datetime = new Date();
                                        //            dateText.text = Qt.formatDateTime(datetime, "dddd\nMMM dd yyyy")
                                        let monthText = currentValueText.monthStrings[datetime.getMonth()]
                                        let dateText = Qt.formatDateTime(datetime, "dd yyyy")

                                        currentValueText.text = monthText + " " + dateText
                                    }//
                                }//
                            }//

                            TextApp{
                                text: qsTr("Tap to change")
                                color: "#cccccc"
                            }//
                        }//

                        MouseArea {
                            anchors.fill: currentValueColumn
                            onClicked: {
                                fragmentStackView.push(calenderDateComponent)
                            }//
                        }//

                        TextApp{
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Text.AlignHCenter
                            width: 500
                            color: "#cccccc"
                            font.pixelSize: 16
                            text:  qsTr("This system has Network Time Protocol feature, pointing to time.google.com.") + "<br>" +
                                   qsTr("It will prioritize to make syncronization the time with server based on Time Zone.")
                        }//
                    }//
                }//

                /// fragment-2
                Component {
                    id: calenderDateComponent

                    Item {

                        Loader {
                            id: calendarGridLoader
                            anchors.fill: parent
                            asynchronous: true
                            visible: status == Loader.Ready
                            sourceComponent:  CalendarGridApp {
                                id: calendar

                                Component.onCompleted: {
                                    let today = new Date()
                                    today.setHours(0, 0, 0, 0)

                                    targetDate = today
                                    targetMonth = today.getMonth()
                                    targetYear = today.getFullYear()

                                    let futureLimit = new Date()
                                    futureLimit.setHours(0, 0, 0, 0)
                                    futureLimit.setDate(31)
                                    futureLimit.setMonth(Calendar.December)
                                    futureLimit.setFullYear(2050)
                                    futureDateLimit = futureLimit

                                    let olderLimit = new Date()
                                    olderLimit.setHours(0, 0, 0, 0)
                                    olderLimit.setDate(1)
                                    olderLimit.setMonth(Calendar.January)
                                    olderLimit.setFullYear(2020)
                                    olderDateLimit = olderLimit
                                }//

                                onClicked: {
                                    viewApp.showBusyPage(qsTr("Setting up..."),
                                                         function onCycle(cycle){
                                                             if (cycle >= MachineAPI.BUSY_CYCLE_3) {
                                                                 fragmentStackView.pop()
                                                                 viewApp.dialogObject.close()
                                                             }//
                                                         })

                                    let dateTime = Qt.formatDateTime(date, "yyyy-MM-dd hh:mm:ss")
                                    /// tell to machine
                                    MachineAPI.setDateTime(dateTime);
                                    MachineAPI.insertEventLog(qsTr("User: Set the date to") + " " + Qt.formatDateTime(date, "yyyy-MM-dd"))
                                }//
                            }//
                        }//

                        BusyIndicatorApp {
                            visible: calendarGridLoader.status !== Loader.Ready
                            anchors.centerIn: parent
                        }//
                    }//
                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 70

                Rectangle {
                    anchors.fill: parent
                    color: "#0F2952"
                    //                    border.color: "#e3dac9"
                    //                    border.width: 1
                    radius: 5

                    Item {
                        anchors.fill: parent
                        anchors.margins: 5

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                if (fragmentStackView.depth > 1) {
                                    fragmentStackView.pop();
                                    return
                                }

                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }
                        }//
                    }//
                }//
            }
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            //            property int counting: 0
            //            onCountingChanged: {
            //                //console.debug("counting: " + counting)
            //            }
        }

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                //                    props.counting = Qt.binding(function(){return MachineData.count})

                ///Check the year, if year < 2021 then set initial date to "2021-01-01"
                let date = new Date()
                let dateTime = Qt.formatDateTime(date, "yyyy-MM-dd hh:mm:ss")
                let strDate = dateTime.split(" ")[0]
                let currentYear = Number(strDate.split("-")[0])

                //console.debug("current year:", currentYear)

                if(currentYear < 2021){
                    let strTime = dateTime.split(" ")[1]
                    let dateTimeSet = "2021-10-01 " + strTime
                    /// tell to machine
                    MachineAPI.setDateTime(dateTimeSet);
                    MachineAPI.insertEventLog(qsTr("User: Init date time") + " " + dateTimeSet)
                    viewApp.showBusyPage(qsTr("Setting up initial date..."),
                                         function onCycle(cycle){
                                             if (cycle >= MachineAPI.BUSY_CYCLE_3) {
                                                 closeDialog()
                                             }//
                                         })
                }
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//



/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
