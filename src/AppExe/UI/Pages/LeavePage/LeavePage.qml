/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Shut down"

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
                    title: qsTr("Shut down")
                }//
            }//

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

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/UI/Pictures/warning-sign-2x.png"
                        }//
                    }

                    Item {
                        id: rightItem
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Rectangle {
                            y: descWrapColumn.y - 5
                            height: descWrapColumn.height + 10
                            width: descWrapColumn.width + 10
                            radius: 5
                            color: "#b5740d"
                        }//

                        Column {
                            id: descWrapColumn
                            anchors.centerIn: parent
                            spacing: 5

                            Column {
                                id: descColumn
                                spacing: 2

                                TextApp {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.bold: true
                                    text: qsTr("Attention!")
                                }//

                                Rectangle {height: 1; width: parent.width; color: "gray"}

                                TextApp {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: rightItem.width - 10
                                    minimumPixelSize: 20
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignJustify
                                    rightPadding: 5
                                    text: qsTr("This action only needed if you want to take out the electricity to the unit.")
                                }//

                                Rectangle {height: 1; width: parent.width; color: "gray"}

                                TextApp {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: rightItem.width - 10
                                    minimumPixelSize: 20
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignJustify
                                    rightPadding: 5
                                    text: qsTr("This to ensure all the tasks will be stopped properly and not caused disk error.")
                                }//

                                Rectangle {height: 1; width: parent.width; color: "gray"}

                                TextApp {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: rightItem.width - 10
                                    minimumPixelSize: 20
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignJustify
                                    rightPadding: 5
                                    text: qsTr("System will automatically turn off all the output, then go to black screen.")
                                }//

                                Rectangle {height: 1; width: parent.width; color: "gray"}

                                TextApp {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: rightItem.width - 10
                                    minimumPixelSize: 20
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignJustify
                                    rightPadding: 5
                                    text: qsTr("After black screen about 5 seconds, you can actually take out the electricity.")
                                }//
                                Rectangle {height: 1; width: parent.width; color: "gray"}
                                TextApp {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: rightItem.width - 10
                                    minimumPixelSize: 20
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignJustify
                                    rightPadding: 5
                                    text: qsTr("If you intend to turn on the unit again, please plug it off and plug in back the power.")
                                }//
                                Rectangle {height: 1; width: parent.width; color: "gray"}
                            }

                            Row {
                                CheckBox {
                                    id: policyCheckBox
                                    font.pixelSize: 20
                                }//

                                TextApp {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("Yes, I'm ready to turned off the unit")
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
                Layout.minimumHeight: MachineAPI.FOOTER_HEIGHT

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
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            enabled: policyCheckBox.checked

                            imageSource: "qrc:/UI/Pictures/turnoff-red-icon.png"
                            text: qsTr("Shut down")

                            onClicked: {
                                MachineAPI.insertEventLog("User: Set Shutting down");

                                viewApp.showBusyPage(qsTr("Please wait..."), function onCallback(cycle){
                                    if(cycle === MachineAPI.BUSY_CYCLE_1){
                                        let exitCodePowerOff = 6
                                        const intent = IntentApp.create("qrc:/UI/Pages/ClosingPage/ClosingPage.qml",
                                                                        {
                                                                            exitCode: exitCodePowerOff
                                                                        })
                                        startRootView(intent)
                                    }
                                })
                            }//
                        }//
                    }//
                }//
            }//
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        //        QtObject {
        //            id: props
        //        }

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/
