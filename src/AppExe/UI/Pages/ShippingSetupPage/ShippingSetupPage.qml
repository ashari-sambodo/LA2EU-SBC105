/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Shipping Setup"

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
                    title: qsTr("Shipping Setup")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 10

                        Image {
                            source: "qrc:/UI/Pictures/shipping-icon.png"
                            width: 250
                            fillMode: Image.PreserveAspectFit
                        }

                        TextApp {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 450
                            wrapMode: Text.WordWrap
                            text: qsTr("Shipping mode will affect to:") + "<br>"+
                                  "* " + qsTr("Clear all Data Log, Alarm Log and Event Log") + "<br>"+
                                  "* " + qsTr("Reset filter usage, UV usage and sash cycle") + "<br>" +
                                  "* " + qsTr("Showing installation wizard when the unit powered on")
                        }//
                    }//

                    ButtonBarApp {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 300

                        imageSource: "qrc:/UI/Pictures/checkicon.png"
                        text: qsTr("Set shipping mode")

                        onClicked: {
                            const autoClosedDialog = false;
                            showDialogAsk(qsTr("Shipping Setup"),
                                          qsTr("After success enable shipping mode, cabinet will be shutting down and only can restart when you reconnect the electricity to the cabinet"),
                                          dialogAlert,
                                          ()=>{
                                              viewApp.enabledSwipedFromLeftEdge   = false
                                              viewApp.enabledSwipedFromRightEdge  = false
                                              viewApp.enabledSwipedFromBottomEdge = false
                                              viewApp.enabledSwipedFromTopEdge    = false

                                              MachineAPI.setShippingModeEnable(true)

                                              showBusyPage(qsTr("Setting up..."),
                                                           (second)=>{
                                                               if(second === 10){
                                                                   let exitCodePowerOff = 6
                                                                   const intent = IntentApp.create("qrc:/UI/Pages/ClosingPage/ClosingPage.qml", {exitCode: exitCodePowerOff})
                                                                   startRootView(intent)
                                                               }
                                                           })
                                          },
                                          ()=>{},
                                          ()=>{},
                                          autoClosedDialog)

                        }
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
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int countDefault: 50
            property int count: 50
        }//

        /// One time executed after onResume
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
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/
