/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Ahmad Qodri
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Cabinet Name"

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
                    id: headerApp
                    anchors.fill: parent
                    title: qsTr("Cabinet Name")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Row{
                    id: cabinetNameRow
                    anchors.centerIn: parent
                    spacing: 0
                    Image{
                        id: cabinetNameIcon
                        source: "qrc:/UI/Pictures/cabinet-name-icon.png"
                        fillMode: Image.PreserveAspectFit
                    }
                    Column{
                        anchors.verticalCenter: parent.verticalCenter
                        TextApp{
                            text: qsTr("Current")
                            verticalAlignment: Text.AlignBottom
                        }
                        TextApp{
                            id: cabinetNameText
                            text: props.cabinetName
                            font.pixelSize: 56
                        }
                        TextApp{
                            text: "(" + qsTr("Tap to change") + ")"
                            color: "#dddddd"
                        }
                    }
                }
                MouseArea{
                    id: cabinetNameMouseArea
                    anchors.fill: cabinetNameRow
                }

                TextInput{
                    id: cabinetNameBufferTextInput
                    visible: false
                    maximumLength: 10

                    Connections{
                        target: cabinetNameMouseArea
                        function onClicked(){
                            //cabinetNameBufferTextInput.text = props.cabinetName
                            KeyboardOnScreenCaller.openKeyboard(cabinetNameBufferTextInput, qsTr("Cabinet Name (Max. 10 Characters)"))
                        }//
                    }//

                    onAccepted: {
                        if((cabinetNameBufferTextInput.length !== 0) && (props.cabinetName !== cabinetNameBufferTextInput.text)){
                            //console.debug("Cabinet name: ", props.cabinetName)

                            MachineAPI.setCabinetDisplayName(cabinetNameBufferTextInput.text);

                            viewApp.showBusyPage(qsTr("Setting up..."),
                                                 function onTriggered(cycle){
                                                     if(cycle >= MachineAPI.BUSY_CYCLE_1){
                                                         viewApp.closeDialog()
                                                     }
                                                 })
                        }
                    }
                }
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
                                var intent = IntentApp.create(uri, {})
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

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props
            property string cabinetName : "BSC123456"
        }

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                props.cabinetName = Qt.binding(function(){return MachineData.cabinetDisplayName})
                cabinetNameBufferTextInput.text = props.cabinetName

                const extraData = IntentApp.getExtraData(intent)
                const thisOpenedFromWelcomePage = extraData["walcomesetup"] || false
                if(thisOpenedFromWelcomePage) {
                    setButton.visible = true
                }
            }//

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }//
        }//
    }//
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
