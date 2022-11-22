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

                Rectangle {
                    id: msgInfoTextApp
                    visible: false
                    color: "#80000000"
                    TextApp {
                        //id: msgInfoTextApp
                        text: qsTr("Ensure you have removed the plastic (insulator) of the RTC Module battery!")
                        verticalAlignment: Text.AlignVCenter
                        padding: 2
                    }
                    width: childrenRect.width
                    height: childrenRect.height
                }//

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
                                   qsTr("It will prioritize to make synchronization the time with server based on Time Zone.")
                        }//
                    }//
                }//

                /// fragment-2
                Component {
                    id: calenderDateComponent

                    Item {

                        TextFieldApp{
                            id: tempYearTextField
                            color: "transparent"
                            colorBackground: "transparent"
                            colorBorder: "transparent"

                            onAccepted: {
                                console.debug(text)
                                calendarGridLoader.loaderYearTemp = text
                                calendarGridLoader.active = false
                                calendarGridLoader.active = true
                            }
                        }

                        Loader {
                            id: calendarGridLoader
                            anchors.fill: parent
                            asynchronous: true
                            visible: status == Loader.Ready

                            property string loaderYearTemp: props.yearTemp

                            sourceComponent:  CalendarGridApp {
                                id: calendar

                                Component.onCompleted: {
                                    let today = new Date()
                                    today.setHours(0, 0, 0, 0)
                                    today.setFullYear(calendarGridLoader.loaderYearTemp)

                                    targetDate = today
                                    targetMonth = today.getMonth()
                                    targetYear = calendarGridLoader.loaderYearTemp //today.getFullYear()

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
                                    olderLimit.setFullYear(2000)
                                    olderDateLimit = olderLimit
                                }//

                                onYearRectanglePressed: {
                                    KeyboardOnScreenCaller.openNumpad(tempYearTextField, qsTr("Set Year"));
                                }

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

               BackgroundButtonBarApp {
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

                        ButtonBarApp {
                            id: setButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            visible: false

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Next")

                            onClicked: {
                                //                                currentTimeZoneText.text = currentTimeZoneText.text + "AAAA-"
                                /// if this page called from welcome page
                                /// show this button to making more mantap
                                var intent = IntentApp.create(uri, {"welcomesetupdone": 1})
                                finishView(intent)
                            }//
                        }//
                    }//
                }//
            }
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props
            property string yearTemp: ""

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

                props.yearTemp = currentYear

                //console.debug("current year:", currentYear)

                const extraData = IntentApp.getExtraData(intent)
                //                console.debug("extraData", extraData)
                const thisOpenedFromWelcomePage = extraData["welcomesetup"] || false
                //                console.debug("extraData[\"welcomesetup\"]", extraData["welcomesetup"])
                //                console.debug(extraData["thisOpenedFromWelcomePage"], thisOpenedFromWelcomePage)
                if(thisOpenedFromWelcomePage) {
                    setButton.visible = true
                    msgInfoTextApp.visible = true

                    viewApp.enabledSwipedFromLeftEdge   = false
                    viewApp.enabledSwipedFromRightEdge  = false
                    viewApp.enabledSwipedFromBottomEdge = false
                }//
            }//

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
