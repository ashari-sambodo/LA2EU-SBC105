/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Ahmad Qodri
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Software Update"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: Item{
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
                    id: headerApp
                    anchors.fill: parent
                    title: qsTr("Software Update")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column {
                    id: updateColumn
                    anchors.centerIn: parent
                    spacing: 0
                    Image{
                        anchors.right: parent.right
                        source: "qrc:/UI/Pictures/software-update-icon.png"
                        fillMode: Image.PreserveAspectFit
                    }
                    TextApp{
                        text: qsTr("Current")
                        verticalAlignment: Text.AlignBottom
                    }
                    TextApp{
                        id: softwareVersionText
                        text: props.currentSoftwareVersion
                        font.pixelSize: 56
                    }
                    //                    TextApp{
                    //                        id: softwareVersionInfoText
                    //                        text: qsTr("No online update available")
                    //                        color: "#929292"
                    //                        states: [
                    //                            State {
                    //                                when: props.softwareVersionInfoState == 1
                    //                                PropertyChanges { target: softwareVersionInfoText; text: qsTr("Checking...") }
                    //                            },
                    //                            State {
                    //                                when: props.softwareVersionInfoState == 2
                    //                                PropertyChanges { target: softwareVersionInfoText; text: qsTr("Available update to ") + props.availableNewSoftwareVersion }
                    //                            }
                    //                        ]
                    //                    }
                }//

                //                MouseArea{
                //                    anchors.fill:updateColumn
                //                    onClicked: {
                //                        props.softwareVersionInfoState++
                //                        if(props.softwareVersionInfoState >= 3)
                //                            props.softwareVersionInfoState = 0
                //                        //console.debug("State: ", props.softwareVersionInfoState)
                //                    }
                //                }
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
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            imageSource: "qrc:/UI/Pictures/next-step.png"
                            text: qsTr("Next")

                            onClicked: {
                                const message = qsTr("Are you sure want to continue to update?")
                                viewApp.showDialogAsk(qsTr("Notification"),
                                                      message,
                                                      viewApp.dialogInfo,
                                                      function onAccepted(){
                                                          //console.debug("SBC Update Load...")
                                                          viewApp.showBusyPage(qsTr("Load the updater..."),
                                                                               function onTriggered(cycle){
                                                                                   if(cycle === 3){
                                                                                       let exitCodeOpenUpdater = 7
                                                                                       const intent = IntentApp.create("qrc:/UI/Pages/ClosingPage/ClosingPage.qml",
                                                                                                                       {exitCode: exitCodeOpenUpdater})
                                                                                       startRootView(intent)
                                                                                   }
                                                                               })
                                                      })
                            }
                        }//
                    }//
                }//
            }
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props
            property int softwareVersionInfoState : 0
            property string currentSoftwareVersion : ""
            property string availableNewSoftwareVersion : "SBC101-1.0.0.2"
        }

        /// called Once but after onResume
        Component.onCompleted: {
            props.currentSoftwareVersion = Qt.application.name + " - " + Qt.application.version
        }//

        /// Execute This Every This Screen Active/Visible
        Loader {
            active: viewApp.stackViewStatusForeground
            sourceComponent: QtObject {

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
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
