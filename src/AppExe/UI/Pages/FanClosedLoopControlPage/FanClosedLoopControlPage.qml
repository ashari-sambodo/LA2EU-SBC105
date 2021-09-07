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

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Fan Closed Loop Control"

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
                    title: qsTr("Fan Closed Loop Control")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
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
                                    text: qsTr("Control mode")
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    SwitchApp{
                                        id: enableSwitch
                                        anchors.centerIn: parent

                                        onCheckedChanged: {
                                            if (!initialized) return

                                            props.enableSet = checked ? true : false
                                            if(props.enableSet != props.prevEnableSet)
                                                setButton.visible = true
                                            else
                                                setButton.visible = false
                                        }//
                                        Component.onCompleted: {
                                            checked = Qt.binding(function(){return props.enableSet})
                                        }
                                    }//
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
                            }
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
                                MachineAPI.setFanClosedLoopControlEnable(props.enableSet)

                                const message = props.enableSet ? qsTr("User: Closed loop control enabled")
                                                                : qsTr("User: Closed loop control disabled")
                                MachineAPI.insertEventLog(message)

                                showBusyPage(qsTr("Setting up..."), function(seconds){
                                    if (seconds === 3){
                                        props.prevEnableSet = props.enableSet
                                        closeDialog();
                                    }//
                                })
                            }//
                        }//
                        ButtonBarApp {
                            id: tunningButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            visible: !setButton.visible && MachineData.fanClosedLoopControlEnable

                            imageSource: "qrc:/UI/Pictures/tuning.png"
                            text: qsTr("Tuning")

                            onClicked: {
                                var intent = IntentApp.create("qrc:/UI/Pages/FanClosedLoopControlPage/ClosedLoopTunning.qml", {"message":""})
                                startView(intent)
                            }//
                        }//
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property bool enableSet: false
            property bool prevEnableSet: false
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                props.enableSet = Qt.binding(function(){return MachineData.fanClosedLoopControlEnable})
                props.prevEnableSet = props.enableSet
                enableSwitch.initialized = true
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

