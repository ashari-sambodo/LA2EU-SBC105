/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Ahmad Qodri
**/

import QtQuick 2.14
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Serial Number"

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
                    title: qsTr("Serial Number")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column {
                    id: serialNumberColumn
                    anchors.centerIn: parent
                    spacing: 0

                    Image{
                        anchors.right: parent.right
                        source: "qrc:/UI/Pictures/serial-number-icon.png"
                        fillMode: Image.PreserveAspectFit
                    }//

                    TextApp{
                        text: qsTr("Current")
                        verticalAlignment: Text.AlignBottom
                    }//

                    TextApp{
                        id: serialNumberText
                        text: props.serialNumber
                        font.pixelSize: 56
                    }//

                    TextApp{
                        text: "(" + qsTr("Tap to change") + ")"
                        color: "#929292"
                    }//
                }//

                MouseArea{
                    id: serialNumberMouseArea
                    anchors.fill: serialNumberColumn
                }//

                TextInput{
                    id: serialNumberBufferTextInput
                    visible: false
                    validator: RegularExpressionValidator { regularExpression: /\d{4}(?:-\d{5,8})+$/}

                    Connections{
                        target: serialNumberMouseArea
                        function onClicked(){
                            serialNumberBufferTextInput.text = props.serialNumber
                            //serialNumberBufferTextInput.text = props.serialNumber
                            KeyboardOnScreenCaller.openNumpad(serialNumberBufferTextInput, qsTr("Serial Number"))
                        }//
                    }//

                    onAccepted: {
                        let regex = /\d{4}(?:-\d{6})+$/

                        if(serialNumberBufferTextInput.text.match(regex)){
                            if(props.serialNumber !== text){
                                props.serialNumber = text
                                //console.debug("Serial Number: ", props.serialNumber)

                                MachineAPI.setSerialNumber(text)

                                viewApp.showBusyPage(qsTr("Setting Serial Number..."),
                                                     function onTriggered(cycle){
                                                         if(cycle === MachineAPI.BUSY_CYCLE_1){
                                                             viewApp.dialogObject.close()}
                                                     })
                            }
                        }
                        else {
                            const autoClosed = false
                            viewApp.showDialogMessage(qsTr("Serial Number"),
                                                      qsTr("Invalid Serial Number!. Make sure the format is YYYY-XXXXXX"),
                                                      viewApp.dialogAlert,
                                                      function onClosed(){},
                                                      autoClosed)
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
            }
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props
            property string serialNumber : ""
        }

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        Loader {
            active: viewApp.stackViewStatusForeground
            sourceComponent: QtObject {

                /// onResume
                Component.onCompleted: {
                    //                    //console.debug("StackView.Active");

                    props.serialNumber = MachineData.serialNumber
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
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/
