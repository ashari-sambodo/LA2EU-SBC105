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
    title: "Sash Motor Off Fully Closed Delay"

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
                    title: qsTr("Sash Motor Off Fully Closed Delay")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent
                    spacing: 10
                    Item{
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Image{
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            source: "qrc:/UI/Pictures/sash-fully-closed-delay-icon.png"
                            height: 200
                            fillMode: Image.PreserveAspectFit
                        }//
                    }
                    Item{
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Column{
                            id: sashOffDelayColumn
                            anchors.verticalCenter: parent.verticalCenter
                            TextApp{
                                text: qsTr("Current")
                                verticalAlignment: Text.AlignBottom
                            }//

                            TextApp{
                                id: sashOffDelayText
                                text: qsTr("%1 ms").arg(props.sashMotorOffDelay)
                                font.pixelSize: 56
                            }//

                            TextApp{
                                text: "(" + qsTr("Tap to change") + ")"
                                color: "#929292"
                            }//
                        }
                        MouseArea{
                            id: sashOffDelayMouseArea
                            anchors.fill: sashOffDelayColumn
                        }//
                        TextInput{
                            id: sashOffDelayBufferTextInput
                            visible: false

                            Connections{
                                target: sashOffDelayMouseArea
                                function onClicked(){
                                    sashOffDelayBufferTextInput.text = props.sashMotorOffDelay
                                    //sashOffDelayBufferTextInput.text = props.sashOffDelay
                                    KeyboardOnScreenCaller.openNumpad(sashOffDelayBufferTextInput, qsTr("Delay (ms)"))
                                }//
                            }

                            onAccepted: {
                                let value = Number(text)

                                if(value >= 0){
                                    if(props.sashMotorOffDelay != value){
                                        props.sashMotorOffDelay = value
                                        //console.debug("Serial Number: ", props.sashOffDelay)

                                        MachineAPI.setSashMotorOffDelayMsec(value)

                                        viewApp.showBusyPage(qsTr("Setting Delay..."),
                                                             function onTriggered(cycle){
                                                                 if(cycle === MachineAPI.BUSY_CYCLE_1){
                                                                     viewApp.dialogObject.close()}
                                                             })
                                    }
                                }
                                else {
                                    const autoClosed = false
                                    viewApp.showDialogMessage(qsTr("Sash Motor Off Fully Closed Delay"),
                                                              qsTr("Invalid entered value!"),
                                                              viewApp.dialogAlert,
                                                              function onClosed(){},
                                                              autoClosed)
                                }//
                            }//
                        }//
                    }
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

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props
            //property string sashOffDelay : ""
            property int sashMotorOffDelay : 0
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

                    //props.sashOffDelay = MachineData.sashOffDelay
                    props.sashMotorOffDelay = MachineData.sashMotorOffDelayMsec
                }

                /// onPause
                Component.onDestruction: {
                    ////console.debug("StackView.DeActivating");
                }
            }//
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/
