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
    title: "System Information"

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
                    title: qsTr("System Information")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                RowLayout {
                    anchors.fill: parent
                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        ColumnLayout{
                            anchors.fill: parent
                            Item{
                                Layout.minimumHeight: 40
                                Layout.fillWidth: true
                                Rectangle{
                                    anchors.fill: parent
                                    color: "#0F2952"
                                    radius: 5
                                }
                                TextApp{
                                    height: parent.height
                                    width: parent.width
                                    text: qsTr("Current System")
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                            Item{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                Rectangle{
                                    id: rect1
                                    anchors.fill: parent
                                    color:"#22000000"
                                }
                                ColumnLayout{
                                    anchors.fill: parent
                                    Item{
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        RowLayout{
                                            anchors.fill: parent
                                            Flickable {
                                                id: flick1
                                                Layout.fillHeight: true
                                                Layout.fillWidth: true
                                                //                        anchors.fill: parent
                                                //                        anchors.margins: 2
                                                contentWidth: sysInfo1.width
                                                contentHeight: sysInfo1.height
                                                clip: true

                                                flickableDirection: Flickable.VerticalFlick

                                                ScrollBar.vertical: verticalScrollBar1
                                                ScrollBar.horizontal: horizontalScrollBar1

                                                TextApp{
                                                    id: sysInfo1
                                                    padding: 5
                                                    //height: parent.height
                                                    //width: parent.width
                                                    text: "---"
                                                }
                                            }
                                            Rectangle{
                                                visible: sysInfo1.height > parent.height
                                                Layout.fillHeight: true
                                                Layout.minimumWidth: 10
                                                color: "transparent"
                                                border.color: "#dddddd"
                                                radius: 5

                                                /// Horizontal ScrollBar
                                                ScrollBar {
                                                    id: verticalScrollBar1
                                                    anchors.fill: parent
                                                    orientation: Qt.Horizontal
                                                    policy: ScrollBar.AlwaysOn

                                                    contentItem: Rectangle {
                                                        implicitWidth: 5
                                                        implicitHeight: 0
                                                        radius: width / 2
                                                        color: "#dddddd"
                                                    }//
                                                }//
                                            }//
                                        }
                                    }
                                    Rectangle{
                                        visible: sysInfo1.width > parent.width
                                        Layout.minimumHeight: 10
                                        Layout.fillWidth: true
                                        color: "transparent"
                                        border.color: "#dddddd"
                                        radius: 5

                                        /// Horizontal ScrollBar
                                        ScrollBar {
                                            id: horizontalScrollBar1
                                            anchors.fill: parent
                                            orientation: Qt.Horizontal
                                            policy: ScrollBar.AlwaysOn

                                            contentItem: Rectangle {
                                                implicitWidth: 0
                                                implicitHeight: 5
                                                radius: width / 2
                                                color: "#dddddd"
                                            }//
                                        }//
                                    }//
                                }//
                                Component.onCompleted: {
                                    let sysInfo = ""
                                    sysInfo = MachineData.getSbcCurrentSystemInformation()

                                    sysInfo1.text = sysInfo
                                }
                            }
                        }//
                    }//
                    Rectangle{
                        Layout.fillHeight: true
                        Layout.minimumWidth: 1
                        color: "#e3dac9"
                    }
                    Item {
                        id: registeredItem
                        visible: !MachineData.getSbcCurrentSerialNumberKnown()

                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        ColumnLayout{
                            anchors.fill: parent
                            Item{
                                Layout.minimumHeight: 40
                                Layout.fillWidth: true
                                Rectangle{
                                    anchors.fill: parent
                                    color: "#0F2952"
                                    radius: 5
                                }
                                TextApp{
                                    height: parent.height
                                    width: parent.width
                                    text: qsTr("Registered System")
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                            Item{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                Rectangle{
                                    id: rect2
                                    anchors.fill: parent
                                    color:"#22000000"
                                }
                                ColumnLayout{
                                    anchors.fill: parent
                                    Item{
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        RowLayout{
                                            anchors.fill: parent
                                            Flickable {
                                                id: flick2
                                                Layout.fillHeight: true
                                                Layout.fillWidth: true
                                                contentWidth: sysInfo2.width
                                                contentHeight: sysInfo2.height
                                                clip: true

                                                flickableDirection: Flickable.VerticalFlick

                                                ScrollBar.vertical: verticalScrollBar2
                                                ScrollBar.horizontal: horizontalScrollBar2

                                                TextApp{
                                                    id: sysInfo2
                                                    padding: 5
                                                    //height: parent.height
                                                    //width: parent.width
                                                    text: "---"
                                                }
                                            }
                                            Rectangle{
                                                visible: sysInfo2.height > parent.height
                                                Layout.fillHeight: true
                                                Layout.minimumWidth: 10
                                                color: "transparent"
                                                border.color: "#dddddd"
                                                radius: 5

                                                /// Horizontal ScrollBar
                                                ScrollBar {
                                                    id: verticalScrollBar2
                                                    anchors.fill: parent
                                                    orientation: Qt.Horizontal
                                                    policy: ScrollBar.AlwaysOn

                                                    contentItem: Rectangle {
                                                        implicitWidth: 5
                                                        implicitHeight: 0
                                                        radius: width / 2
                                                        color: "#dddddd"
                                                    }//
                                                }//
                                            }//
                                        }
                                    }
                                    Rectangle{
                                        visible: sysInfo2.width > parent.width
                                        Layout.minimumHeight: 10
                                        Layout.fillWidth: true
                                        color: "transparent"
                                        border.color: "#dddddd"
                                        radius: 5

                                        /// Horizontal ScrollBar
                                        ScrollBar {
                                            id: horizontalScrollBar2
                                            anchors.fill: parent
                                            orientation: Qt.Horizontal
                                            policy: ScrollBar.AlwaysOn

                                            contentItem: Rectangle {
                                                implicitWidth: 0
                                                implicitHeight: 5
                                                radius: width / 2
                                                color: "#dddddd"
                                            }//
                                        }//
                                    }//
                                }//
                                Component.onCompleted: {
                                    let sysInfo = ""
                                    sysInfo = MachineData.getSbcSystemInformation()
                                    sysInfo2.text = sysInfo
                                }
                            }
                        }//
                    }//
                    //
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
                            visible: !MachineData.getSbcCurrentSerialNumberKnown()
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            imageSource: "qrc:/UI/Pictures/reset-save-60px.png"
                            text: qsTr("Configure")

                            onClicked: {
                                const message = qsTr("Configure the current system to be registered system?") + "<br>" +
                                              qsTr("The system will restart after this action!")
                                showDialogAsk(qsTr("Configure system"),
                                              message,
                                              dialogAlert,
                                              function onAccepted(){
                                                  MachineAPI.setCurrentSystemAsKnown(true);
                                                  showBusyPage(qsTr("Please wait"),
                                                               function onCallback(secs){
                                                                   if(secs === 5) {
                                                                       const intent = IntentApp.create("qrc:/UI/Pages/ClosingPage/ClosingPage.qml", {})
                                                                       startRootView(intent)
                                                                   }
                                                               })
                                              },
                                              undefined,
                                              undefined,
                                              undefined,
                                              10
                                              )
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
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {
            /// onResume
            Component.onCompleted: {

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
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/
