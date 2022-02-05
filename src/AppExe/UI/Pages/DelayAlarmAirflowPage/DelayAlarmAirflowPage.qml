/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Ahmad Qodri
**/

import QtQuick 2.14
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Delay Airflow Alarm"

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
                    title: qsTr("Delay Airflow Alarm")
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
                            source: "qrc:/UI/Pictures/af-alarm-delay-icon.png"
                            height: 200
                            fillMode: Image.PreserveAspectFit
                        }//
                    }
                    Item{
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Column{
                            id: dlyAirfailColumn
                            anchors.verticalCenter: parent.verticalCenter
                            TextApp{
                                text: qsTr("Current")
                                verticalAlignment: Text.AlignBottom
                            }//

                            TextApp{
                                id: dlyAirfailText
                                text: qsTr("%1 ms").arg(props.delayAirflowAlarm)
                                font.pixelSize: 56
                            }//

                            TextApp{
                                text: "(" + qsTr("Tap to change") + ")"
                                color: "#929292"
                            }//
                        }
                        MouseArea{
                            id: dlyAirfailMouseArea
                            anchors.fill: dlyAirfailColumn
                        }//
                        TextInput{
                            id: dlyAirfailBufferTextInput
                            visible: false

                            Connections{
                                target: dlyAirfailMouseArea
                                function onClicked(){
                                    dlyAirfailBufferTextInput.text = props.delayAirflowAlarm
                                    //dlyAirfailBufferTextInput.text = props.dlyAirfail
                                    KeyboardOnScreenCaller.openNumpad(dlyAirfailBufferTextInput, qsTr("Delay (ms)"))
                                }//
                            }

                            onAccepted: {
                                let value = Number(text)

                                if(value >= 0){
                                    if(props.delayAirflowAlarm != value){
                                        props.delayAirflowAlarm = value
                                        //console.debug("Serial Number: ", props.dlyAirfail)

                                        MachineAPI.setDelayAlarmAirflowMsec(value)

                                        viewApp.showBusyPage(qsTr("Setting Delay..."),
                                                             function onTriggered(cycle){
                                                                 if(cycle >= 2){
                                                                     viewApp.dialogObject.close()}
                                                             })
                                    }
                                }
                                else {
                                    const autoClosed = false
                                    viewApp.showDialogMessage(qsTr("Delay Airflow Alarm"),
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
            //property string dlyAirfail : ""
            property int delayAirflowAlarm : 0
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

                    //props.dlyAirfail = MachineData.dlyAirfail
                    props.delayAirflowAlarm = MachineData.delayAlarmAirflowMsec
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
