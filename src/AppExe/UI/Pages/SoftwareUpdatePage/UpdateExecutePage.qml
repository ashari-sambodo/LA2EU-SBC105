import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.2

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Swupdate 1.0
import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Update"

    background.sourceComponent: Rectangle{
        color: "black"
    }

    content.sourceComponent: Item{
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 5

            Item {
                id: headerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 40

                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.color: "#ffffff"
                    border.width: 1
                    radius: 5

                    TextApp {
                        anchors.centerIn: parent
                        text: qsTr(viewApp.title)
                    }
                }
            }

            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    id: topColumnLayout
                    anchors.fill: parent

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Column {
                            anchors.centerIn: parent
                            spacing: 5

                            Image {
                                id: ilusImage
                                source: "../../Pictures/progress-blue-green"
                                //                                transformOrigin: Item.Center
                                //                                rotation: 180

                                //                                SequentialAnimation {
                                //                                    id: ilusAnimation
                                //                                    running: true
                                //                                    loops: Animation.Infinite

                                //                                    RotationAnimator {
                                //                                        target: ilusImage;
                                //                                        from: 0;
                                //                                        to: 360;
                                //                                        duration: 500
                                //                                    }

                                //                                    PauseAnimation {
                                //                                        duration: 3000
                                //                                    }
                                //                                }
                            }

                            TextApp {
                                id: progressText
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("Starting...")
                            }

                            TextApp {
                                id: warnText
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("Don't turn off the device")
                            }
                        }
                    }//

                    Item {
                        id: bottomContainterItem
                        Layout.fillWidth: true
                        Layout.minimumHeight: topColumnLayout.height * 0.40
                        visible: false

                        Column {
                            anchors.centerIn: parent
                            spacing: 5

                            TextApp {
                                text: qsTr("Log: ")
                            }

                            Rectangle {
                                height: bottomContainterItem.height * 0.80
                                width: bottomContainterItem.width
                                radius: 5
                                color: "transparent"
                                border.color: "white"

                                ScrollView {
                                    id: logScrollView
                                    anchors.fill: parent

                                    TextArea {
                                        id: logTextArea
                                        color: "white"
                                        readOnly: true
                                        font.pixelSize: 20
                                    }
                                }
                            }
                        }
                    }//
                }
            }

            /// Footer
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 70

                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.color: "#ffffff"
                    border.width: 1
                    radius: 5

                    Item {
                        anchors.fill: parent
                        anchors.margins: 5

                        ButtonBarApp {
                            id: backButtonBarApp
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "../../Pictures/back-step"
                            text: qsTr("Back")

                            onClicked: {
                                if (swupdate.progressStatus == SWUpdate.PS_RUN) {
                                    //                                    dialog.accepted.connect(onDialogAccepted)
                                    showDialogMessage(qsTr("Attention"),
                                                      qsTr("This process cannot be undone!"),
                                                      dialogAlert)
                                    return
                                }

                                callFinishView()
                            }

                            //                            function onDialogAccepted(){
                            //                                dialog.accepted.disconnect(onDialogAccepted)
                            //                                callFinishView()
                            //                            }

                            function callFinishView(){
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }
                        }//

                        ButtonBarApp {
                            id: restartButton
                            visible: false
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "../../Pictures/restart-red-icon.png"
                            text: qsTr("Restart")

                            onClicked: {
                                const exitCodeRestart = 5
                                var intent = IntentApp.create("qrc:/UI/Pages/ClosingPage/ClosingPage.qml", {"exitCode":exitCodeRestart})
                                startRootView(intent)
                            }
                        }//
                    }
                }//
            }
        }

        //        /// Dialog
        //        DialogApp {
        //            id: dialogApp

        //            contentItem.title: qsTr("Attention")
        //            contentItem.text: qsTr("This process cannot be undone")
        //            contentItem.dialogType: contentItem.dialogTypeWarning
        //            contentItem.standardButton: contentItem.standardButtonClose
        //        }//

        /// OnCreated
        /// Called this one time once this page has created
        Component.onCompleted: {
            const fileNamePath = IntentApp.getExtraData(intent)["selectedSoftwarePath"]
            const fileName = IntentApp.getExtraData(intent)["selectedSoftwareName"]
            const dryMode = IntentApp.getExtraData(intent)["dryMode"]

            console.debug(fileNamePath)
            console.debug(fileName)

            swupdate.dryMode = dryMode !== undefined ? dryMode : false

            /// Demo
            /// comment this on production unit
            //            swupdate.dryMode = true

            swupdate.fileNamePath = fileNamePath
            swupdate.updateAsync();
        }//

        /// SWUpdate
        SWUpdate {
            id: swupdate

            onMessageNewReadyRead: {
                //                console.log("onMessageNewReadyRead")
                logTextArea.append(message)
            }//

            onProgressStatusChanged: {
                switch (progressStatus) {
                case SWUpdate.PS_FAILED:
                    //                    console.log("SWUpdate.PS_FAILED")
                    ilusImage.source = "../../Pictures/fail-red-white"
                    progressText.text = qsTr("Failed")
                    warnText.visible = false;
                    restartButton.visible = false
                    bottomContainterItem.visible = true
                    break
                case SWUpdate.PS_SUCCESS:
                    //                    console.log("SWUpdate.PS_SUCCESS")
                    ilusImage.source = "../../Pictures/done-green-white"
                    progressText.text = qsTr("Done")
                    warnText.visible = false;
                    restartButton.visible = true
                    bottomContainterItem.visible = true

                    /// Switch Off All Output
                    MachineAPI.setAllOutputShutdown();

                    MachineAPI.setSvnUpdateHasBeenApplied()
                    break
                case SWUpdate.PS_RUN:
                    //                    console.log("SWUpdate.PS_RUN")
                    ilusImage.source = "../../Pictures/progress-blue-green"
                    progressText.text = qsTr("Starting")
                    warnText.visible = true;
                    restartButton.visible = false
                    bottomContainterItem.visible = false
                    break
                }
            }

            onProgressPercentChanged: {
                progressText.text = qsTr("Updating...") + progressPercent + "%"
            }
        }//

    }//
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
