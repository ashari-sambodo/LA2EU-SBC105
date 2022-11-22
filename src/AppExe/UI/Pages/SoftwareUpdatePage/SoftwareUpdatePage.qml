/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Ahmad Qodri
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Utils 1.0
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
                        opacity: softVerMouseArea.pressed ? 0.5 : 1
                        text: props.currentSoftwareVersion
                        font.pixelSize: 56
                        layer.enabled: true
                        layer.effect: DropShadow {
                            verticalOffset: 2
                            color: "#80000000"
                            radius: 1
                            samples: 3
                        }

                        MouseArea{
                            id: softVerMouseArea
                            enabled: /*MachineData.escoLockServiceEnable
                                     && */UserSessionService.roleLevel == UserSessionService.roleLevelFactory && false
                            anchors.fill: parent
                            onClicked: {
                                let intent = IntentApp.create("qrc:/UI/Pages/SoftwareUpdatePage/SoftwareHistoryPage.qml", {})
                                startView(intent)
                            }
                        }
                    }
                    TextApp{
                        visible: softVerMouseArea.enabled
                        text: qsTr("Tap to view version history")
                        color: "#cccccc"
                    }
                    Rectangle{
                        color: "transparent"
                        height: 10
                        width: 1
                    }
                    TextApp{
                        id: softwareVersionInfoText
                        visible: UserSessionService.roleLevel == UserSessionService.roleLevelFactory
                        text: ""
                        color: "#BCFFFB"
                        font.italic: true
                        font.pixelSize: 18
                        states: [
                            State {
                                when: props.svnUpdateAvailable
                                PropertyChanges {
                                    target: softwareVersionInfoText
                                    text: qsTr("New update software version is currently available on SVN server") +
                                          "<br>%1<br>%2".arg(props.svnUpdateSwuVersion).arg(qsTr("Press <b>SVN Update</b> to perform the update!"))
                                }
                            },
                            State {
                                when: !props.svnUpdateAvailable
                                PropertyChanges { target: softwareVersionInfoText; text: qsTr("No SVN update available.") }
                            }
                        ]
                    }
                    Rectangle{
                        color: "transparent"
                        height: 10
                        width: 1
                    }
                    Rectangle{
                        id: svnUpdateRect
                        //anchors.topMargin: 10
                        width: svnUpdateText.width +10
                        height: 50
                        visible: UserSessionService.roleLevel == UserSessionService.roleLevelFactory
                        color: "#88999999"
                        border.width: 1
                        border.color: "#88BCFFFB"
                        radius: 5
                        opacity: svnUpdateMA.pressed ? 0.5 : 1

                        TextApp{
                            id: svnUpdateText
                            height: parent.height
                            padding: 5
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("SVN Update Settings")
                        }

                        MouseArea{
                            id: svnUpdateMA
                            anchors.fill: parent
                            onClicked: {
                                let intent = IntentApp.create("qrc:/UI/Pages/SoftwareUpdatePage/SvnUpdateSettingsPage.qml", {})
                                startView(intent)
                            }
                        }
                    }
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
                        //https://stackoverflow.com/questions/4686464/how-can-i-show-the-wget-progress-bar-only
                        Row{
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            spacing: 5
                            ButtonBarApp {
                                visible: UserSessionService.roleLevel == UserSessionService.roleLevelFactory && props.svnUpdateAvailable
                                width: 194
                                imageSource: "qrc:/UI/Pictures/svnupdate.png"
                                text: qsTr("SVN Update")

                                onClicked: {
                                    const message = qsTr("Are you sure want to continue to update?")
                                    viewApp.showDialogAsk(qsTr("Notification"),
                                                          message,
                                                          viewApp.dialogInfo,
                                                          function onAccepted(){
                                                              console.debug(MachineData.svnUpdateSwuVersion, MachineData.svnUpdatePath)
                                                              const selectedSoftwarePath = MachineData.svnUpdatePath
                                                              const selectedSoftwareName = props.svnUpdateSwuVersion
                                                              const isFileExist = fileDirUtils.isExist(MachineData.svnUpdatePath)
                                                              if(!isFileExist) {
                                                                  showDialogMessage(qsTr("Warning"),
                                                                                    qsTr("Software update file path is not exist!"),
                                                                                    dialogAlert)
                                                                  return
                                                              }

                                                              //console.debug("SBC Update Load...")
                                                              viewApp.showBusyPage(qsTr("Load the updater..."),
                                                                                   function onTriggered(cycle){
                                                                                       if(cycle >= MachineAPI.BUSY_CYCLE_1){
                                                                                           let newIntent = IntentApp.create("qrc:/UI/Pages/SoftwareUpdatePage/UpdateExecutePage.qml", {
                                                                                                                                "selectedSoftwarePath": selectedSoftwarePath,
                                                                                                                                "selectedSoftwareName": selectedSoftwareName,
                                                                                                                                //"dryMode": true,
                                                                                                                            })
                                                                                           startView(newIntent)
                                                                                       }//
                                                                                   })//
                                                          })//
                                }//
                            }//
                            ButtonBarApp {
                                width: 194
                                //anchors.verticalCenter: parent.verticalCenter
                                //anchors.right: parent.right
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
                                                                                       if(cycle >= MachineAPI.BUSY_CYCLE_1){
                                                                                           let exitCodeOpenUpdater = 7
                                                                                           const intent = IntentApp.create("qrc:/UI/Pages/ClosingPage/ClosingPage.qml",
                                                                                                                           {exitCode: exitCodeOpenUpdater})
                                                                                           startRootView(intent)
                                                                                       }
                                                                                   })
                                                          })
                                }
                            }//
                        }
                    }//
                }//
            }
        }//

        FileDirUtils {
            id: fileDirUtils
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props
            property int softwareVersionInfoState : 0
            property string currentSoftwareVersion : ""
            property string svnUpdateSwuVersion : "SBC101-1.0.0.1"
            property bool svnUpdateAvailable: false
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
                    props.svnUpdateAvailable = Qt.binding(function(){return MachineData.svnUpdateAvailable})
                    props.svnUpdateSwuVersion = Qt.binding(function(){return MachineData.svnUpdateSwuVersion})

                    MachineAPI.checkSoftwareVersionHistory()
                }//

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
