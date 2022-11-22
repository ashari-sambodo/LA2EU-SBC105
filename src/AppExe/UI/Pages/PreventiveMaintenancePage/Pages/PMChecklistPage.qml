/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7

import UI.CusCom 1.1
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "PM Checklist Page"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        /// just for development
        /// comment following line after release
        visible: true

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
                    title: props.title
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                ColumnLayout{
                    anchors.fill: parent
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.topMargin: 10
                        Layout.leftMargin: 20
                        ListView {
                            id: checkListview
                            anchors.fill: parent
                            flickableDirection: Flickable.VerticalFlick
                            clip: true
                            //model: props.checklist
                            delegate: Rectangle{
                                width: bodyItem.width
                                height: 40
                                color: "transparent"
                                RowLayout {
                                    anchors.fill: parent
                                    Item{
                                        Layout.fillHeight: true
                                        Layout.minimumWidth: 40
                                        CheckBox {
                                            id: policyCheckBox
                                            anchors.centerIn: parent
                                            enabled: !props.userIsAdmin
                                                     && (props.userIsSupv ? props.allowSupvToAcknowledge : true)
                                            font.pixelSize: 20
                                            onCheckedChanged: {
                                                props.calculateCheckState(index, checked)
                                            }
                                        }//
                                    }//

                                    Item{
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        TextApp {
                                            width: parent.width
                                            height: parent.height
                                            text: modelData
                                            verticalAlignment: Text.AlignVCenter
                                        }//
                                    }//
                                }//
                            }
                        }//
                    }
                    Item{
                        id: body2
                        Layout.fillWidth: true
                        Layout.minimumHeight: bodyItem.height/4
                        Layout.leftMargin: 20
                        Layout.rightMargin: 20
                        Rectangle{
                            anchors.fill: parent
                            color: "#55000000"
                            radius: 5
                        }
                        Column{
                            spacing: 5
                            Row{
                                spacing: 5
                                CheckBox {
                                    id: ackCbox
                                    enabled: (props.allChecked == props.checkState
                                             && !props.userIsAdmin
                                             && (props.userIsSupv ? props.allowSupvToAcknowledge : true))
                                    opacity: enabled ? 1: 0.5
                                    //anchors.centerIn: parent
                                    font.pixelSize: 20
                                    onCheckedChanged: {
                                        //props.calculateCheckState(index, checked)
                                        if(checked == props.acknowledge) return
                                        if(checked){
                                            showDialogAsk(props.title,
                                                          qsTr("By making this acknowledgment, you agree that you have completed the preventive maintenance according to the checklist provided.")
                                                          + "<br>"
                                                          + qsTr("You can't reset the acknowledgment date after it is set."),
                                                          dialogAlert,
                                                          function onAccepted(){
                                                              props.acknowledge = checked
                                                              MachineAPI.setAlarmPreventMaintStateAck(props.pmCode, checked, false)
                                                              showBusyPage(qsTr("Acknowledge..."), function onCallback(cycle){
                                                                  var intent = IntentApp.create(uri, {"message":""})
                                                                  finishView(intent)
                                                              })
                                                          },
                                                          function onRejected(){
                                                              checked = !checked
                                                          },
                                                          function onClosed(){},
                                                          false);
                                        }
                                    }
                                }//
                                TextApp{
                                    height: ackCbox.height
                                    opacity: props.allChecked == props.checkState ? 1: 0.5
                                    text: qsTr("Acknowledge")
                                    font.bold: true
                                    font.underline: true
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }//
                            TextApp{
                                leftPadding: 10
                                rightPadding: 10
                                width: body2.width
                                //color: "#cccccc"
                                text: qsTr("Last preventive maintenance acknowledgment" + ": <b>%1</b>".arg(props.ackDate))
                            }
                            TextApp{
                                leftPadding: 10
                                rightPadding: 10
                                width: body2.width
                                //color: "#cccccc"
                                text: qsTr("Please carry out preventive maintenance before" + ": <b>%1</b>".arg(props.dueDate))
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
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }
                        }//
                        ButtonBarApp {
                            id: snoozeBtn
                            enabled: props.alarmActive && !props.userIsAdmin && (props.userIsSupv ? props.allowSupvToAcknowledge : true)
                            visible: enabled
                            width: 194
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/alert-snooze.png"
                            text: qsTr("Snooze")

                            onClicked: {
                                MachineAPI.setAlarmPreventMaintStateAck(props.pmCode, true, true)
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }
                        }//
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props
            property string title: ""
            property string pid: ""
            property var checklistTemp: []
            property var checklist: []

            property string ackDate: ""
            property string dueDate: ""
            property bool remindEn: false
            property bool alarmActive: false
            property int pmCode: 0

            property int allChecked: 0
            property int checkState: 0

            property bool acknowledge: false

            property bool userIsSupv: UserSessionService.roleLevel == UserSessionService.roleLevelSupervisor
            property bool userIsAdmin: UserSessionService.roleLevel == UserSessionService.roleLevelAdmin
            property bool allowSupvToAcknowledge: false

            function calculateCheckState(bit, checked){
                if(checked)// bit set
                {
                    checkState |= 1 << bit;
                }
                else// bit clear
                {
                    checkState &= ~(1 << bit);
                }
            }//
            onCheckStateChanged: console.debug("CheckState :", checkState)
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                let extradata = IntentApp.getExtraData(intent)
                if (extradata['pid'] !== undefined) {
                    props.pid = extradata['pid']
                    props.title = extradata['title'] || ""
                    props.checklistTemp = extradata['checklistReq'] || ""
                    for(let i=0; i<props.checklistTemp.length; i++){
                        if(props.checklistTemp[i] !== ""){
                            props.checklist.push(props.checklistTemp[i])
                            if(!props.allChecked)
                                props.allChecked |= 1
                            else
                                props.allChecked = (props.allChecked << 1) | 1
                        }//
                    }//
                    props.ackDate = extradata['ackDate'] || ""
                    props.dueDate = extradata['dueDate'] || ""
                    props.remindEn = extradata['remindEn'] || false
                    props.alarmActive = extradata['alarmActive'] || false
                    props.pmCode = extradata['pmCode'] || 0

                    console.debug(props.checklist.length, props.allChecked)
                    console.debug(props.ackDate, props.dueDate, props.remindEn)

                    props.allowSupvToAcknowledge = (props.pid == "daily"
                            || props.pid == "weekly"
                            || props.pid == "monthly"
                            || props.pid == "quarterly"
                            || props.pid == "canopy")
                }

                //listviewLoader.active = true
                checkListview.model = props.checklist
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

//        MultiPointTouchArea {
//            anchors.fill: parent

//            touchPoints: [
//                TouchPoint {id: point1},
//                TouchPoint {id: point2},
//                TouchPoint {id: point3},
//                TouchPoint {id: point4},
//                TouchPoint {id: point5}
//            ]
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "red"
//            visible: point1.pressed
//            x: point1.x - (width / 2)
//            y: point1.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "green"
//            visible: point2.pressed
//            x: point2.x - (width / 2)
//            y: point2.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "blue"
//            visible: point3.pressed
//            x: point3.x - (width / 2)
//            y: point3.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "yellow"
//            visible: point4.pressed
//            x: point4.x - (width / 2)
//            y: point4.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "cyan"
//            visible: point5.pressed
//            x: point5.x - (width / 2)
//            y: point5.y - (height / 2)
//        }//

//        Column {
//            id: counter
//            anchors.centerIn: parent

//            TextApp {
//                anchors.horizontalCenter: parent.horizontalCenter
//                text: props.count
//                font.pixelSize: 48

//                TapHandler {
//                    onTapped: {
//                        props.count = props.countDefault
//                        counterTimer.restart()
//                    }//
//                }//
//            }//

//            TextApp {
//                font.pixelSize: 14
//                text: "Press number\nto count!"
//            }//
//        }//

//        Timer {
//            id: counterTimer
//            interval: 1000; repeat: true
//            onTriggered: {
//                let count = props.count
//                if (count <= 0) {
//                    counterTimer.stop()
//                }//
//                else {
//                    count = count - 1
//                    props.count = count
//                }//
//            }//
//        }//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/
