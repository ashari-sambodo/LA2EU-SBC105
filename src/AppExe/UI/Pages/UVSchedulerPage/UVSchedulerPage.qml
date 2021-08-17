/*
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Ahmad Qodri
 *          Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.2

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "UV Scheduler"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        /// comment this visible property for production
        //        visible: true

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
                    title: qsTr(viewApp.title)
                }
            }

            /// BODY
            Item {
                id: contentItem
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.topMargin: 5
                Layout.bottomMargin: 5

                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    Row {
                        spacing: 10

                        Item {
                            height: 100
                            width: 200
                            //                    radius: 5
                            //                    color: "#dd0F2952"
                            //                    border.color: "#dddddd"

                            Rectangle {
                                id: enableRectangle
                                anchors.fill: parent
                                color: "#0F2952"
                                border.color: "#e3dac9"
                                radius: 5
                                states: [
                                    State{
                                        when: enableSwitch.checked
                                        PropertyChanges {
                                            target: enableRectangle
                                            color: "#1e824c"
                                        }
                                    }
                                ]
                            }

                            ColumnLayout{
                                anchors.fill: parent
                                anchors.margins: 5

                                TextApp {
                                    text: qsTr("Scheduler")
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    SwitchApp{
                                        id: enableSwitch
                                        anchors.centerIn: parent

                                        onCheckedChanged: {
                                            if (!initialized) return

                                            props.enableSet = checked ? 1 : 0

                                            setButton.visible = true
                                        }//
                                    }//
                                }//
                            }//
                        }//

                        Item {
                            id: timeScheduleRect
                            height: 100
                            width: 200
                            //                    radius: 5
                            //                    color: "#dd0F2952"
                            //                    border.color: "#dddddd"
                            //                    visible: false

                            visible: enableSwitch.checked
                            //                            scale: visible ? 1.0 : 0.1
                            //                            Behavior on scale {
                            //                                NumberAnimation { duration: 100}
                            //                            }

                            Rectangle {
                                anchors.fill: parent
                                color: "#0F2952"
                                border.color: "#e3dac9"
                                radius: 5
                            }//

                            ColumnLayout{
                                anchors.fill: parent
                                anchors.margins: 5

                                TextApp {
                                    text: qsTr("Time")
                                }//

                                Item {
                                    id: uvAutoSetTimeItem
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    TextApp{
                                        id: timeText
                                        anchors.fill: parent
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font.bold: true
                                        font.pixelSize: 22
                                    }//
                                }//
                            }//

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    ////console.debug("Open time picker")
                                    finishViewReturned.connect(props.onReturnFromTimePickerPage)
                                    const intent = IntentApp.create("qrc:/UI/Pages/TimePickerPage/TimePickerPage.qml",
                                                                    {"periodMode": props.timePeriodMode
                                                                    })
                                    startView(intent)
                                }//
                            }//
                        }//
                    }//

                    Item {
                        id: repeatScheduleRect
                        height: 100
                        width: 410
                        //                    radius: 5
                        //                    color: "#dd0F2952"
                        //                    border.color: "#dddddd"
                        //                    visible: false

                        visible: enableSwitch.checked
                        //                        scale: visible ? 1.0 : 0.1
                        //                        Behavior on scale {
                        //                            NumberAnimation { duration: 100}
                        //                        }

                        Rectangle {
                            anchors.fill: parent
                            color: "#0F2952"
                            border.color: "#e3dac9"
                            radius: 5
                        }//

                        ColumnLayout{
                            anchors.fill: parent
                            anchors.margins: 5

                            TextApp {
                                text: qsTr("Repeat")
                            }//

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                ComboBoxApp {
                                    id: repeatDayComboBox
                                    anchors.fill: parent
                                    backgroundColor: "#0F2952"
                                    backgroundBorderColor: "#dddddd"
                                    backgroundBorderWidth: 2
                                    font.pixelSize: 20
                                    anchors.verticalCenter: parent.verticalCenter
                                    textRole: "text"

                                    model: [
                                        {text: qsTr("Once")},
                                        {text: qsTr("Everyday")},
                                        {text: qsTr("Weekdays - Monday to Friday")},
                                        {text: qsTr("Weekends - Saturday & Sunday")},
                                        {text: qsTr("Weekly - Monday")},
                                        {text: qsTr("Weekly - Tuesday")},
                                        {text: qsTr("Weekly - Wednesday")},
                                        {text: qsTr("Weekly - Thursday")},
                                        {text: qsTr("Weekly - Friday")},
                                        {text: qsTr("Weekly - Saturday")},
                                        {text: qsTr("Weekly - Sunday")},
                                    ]

                                    onActivated: {
                                        //                                        console.log("onActivated")
                                        props.repeatSet = index < 4 ? index : 4
                                        if (index >= 4) {
                                            props.repeatDaySet = (index - 4) + 1;
                                        }//

                                        setButton.visible = true
                                    }//

                                    //                                    Component.onCompleted: {
                                    //                                        let repeat = props.uvAutoSetDayRepeat
                                    //                                        let day = props.uvAutoSetWeeklyDay

                                    //                                        ////console.debug(repeat)
                                    //                                        ////console.debug(day)

                                    //                                        let index = repeat;
                                    //                                        if (repeat >= 4) {
                                    //                                            index = repeat + (day - 1)
                                    //                                        }//
                                    //                                        currentIndex = index
                                    //                                    }//
                                }//
                            }//
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
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }//
                        }//

                        ButtonBarApp {
                            id: setButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            visible: false

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Save")

                            onClicked: {
                                visible = false
                                MachineAPI.setUVAutoTime(props.timeSet)
                                MachineAPI.setUVAutoDayRepeat(props.repeatSet)
                                MachineAPI.setUVAutoWeeklyDay(props.repeatDaySet)
                                MachineAPI.setUVAutoEnabled(props.enableSet)

                                const message = props.enableSet ? qsTr("User: UV Scheduler enabled")
                                                                : qsTr("User: UV Scheduler disabled")
                                MachineAPI.insertEventLog(message)

                                showBusyPage(qsTr("Setting up..."), function(seconds){
                                    if (seconds === 3){
                                        closeDialog();
                                    }
                                })
                            }//
                        }//
                    }//
                }//
            }//
        }//

        UtilsApp {
            id: utilsApp
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props

            //frontend variable
            property int enableSet:    -1
            property int timeSet:      0
            property int repeatSet:    0
            property int repeatDaySet: 0

            property int timePeriodMode: 24 //12h
            property string uvAutoTimeText: ""

            function onReturnFromTimePickerPage(returnIntent){
                finishViewReturned.disconnect(onReturnFromTimePickerPage)

                const extraData  = IntentApp.getExtraData(returnIntent)
                //                console.log(extraData)
                if (extraData['hour'] === undefined) return // Do not continue proceed, user not press set button

                const hour       = extraData['hour']      || 0
                const minute     = extraData['minute']    || 0
                const period     = extraData['period']    || "AM" // AM or PM
                const periodMode = extraData['periodMode']|| 24 // 24 for 24h and 12 for 12h (AM/PM)

                //                console.log(hour + " " + minute + " "  + period + " " + periodMode)

                let minuteSchedule = utilsApp.formatClockHourMinuteToMinutes(hour, minute, period, periodMode)
                let clockSchedule = utilsApp.formatMinutesToClockHourMinuteFormat(minuteSchedule, periodMode)
                //                console.log(minuteSchedule + " - " + clockSchedule)

                timeText.text = clockSchedule
                props.timeSet = minuteSchedule

                setButton.visible = true
            }
        }//

        /// called Once but after onResume
        Component.onCompleted: {
            props.timePeriodMode = MachineData.timeClockPeriod
            const minutesSchedule = MachineData.uvAutoSetTime
            props.timeSet = minutesSchedule
            let clockFromMinutes = utilsApp.formatMinutesToClockHourMinuteFormat(minutesSchedule, props.timePeriodMode)
            //            console.log("clockFromMinutes: " + clockFromMinutes)
            timeText.text = clockFromMinutes

            let repeat = MachineData.uvAutoSetDayRepeat
            props.repeatSet = repeat
            let day = MachineData.uvAutoSetWeeklyDay
            props.repeatDaySet = day
            //                                    console.log(repeat)
            //                                    console.log(day)
            let index = repeat;
            if (repeat >= 4) {
                index = repeat + (day - 1)
            }//
            repeatDayComboBox.currentIndex = index

            enableSwitch.checked = MachineData.uvAutoSetEnabled
            enableSwitch.initialized = true
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
            }//

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }
}
/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/
