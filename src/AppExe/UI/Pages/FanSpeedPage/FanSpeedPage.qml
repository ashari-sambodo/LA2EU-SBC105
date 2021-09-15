/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Fan Duty Cycle"

    background.sourceComponent: Item {}

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
                    title: qsTr("Fan Duty Cycle")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column {
                    anchors.centerIn: parent
                    spacing: 50

                    Column {
                        spacing: 10
                        TextApp {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Inflow Fan")
                        }
                        Row{
                            spacing: 20
                            TextFieldApp {
                                id: ifaDcyTextField
                                width: 70
                                height: 50
                                validator: IntValidator{bottom: 0; top: 100;}

                                TextApp {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 5
                                    verticalAlignment: Text.AlignVCenter
                                    height: parent.height
                                    text: "%"
                                    color: "gray"
                                }//

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow Fan (%)"))
                                }//
                                onAccepted: {
                                    fanInflowSlider.value = Number(text)
                                    MachineAPI.setFanInflowDutyCycle(Number(text))
                                }
                            }//
                            SliderApp {
                                id: fanInflowSlider
                                anchors.verticalCenter: parent.verticalCenter
                                width: 700
                                stepSize: 1
                                from: 0
                                to: 100
                                padding: 0

                                onValueChanged: {
                                    if (pressed) {
                                        MachineAPI.setFanInflowDutyCycle(fanInflowSlider.value)
                                        ifaDcyTextField.text = fanInflowSlider.value
                                    }//
                                }//
                            }//
                        }//
                    }//

                    Column {
                        spacing: 10
                        TextApp {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Downflow Fan")
                        }
                        Row{
                            spacing: 20
                            TextFieldApp {
                                id: dfaDcyTextField
                                width: 70
                                height: 50
                                validator: IntValidator{bottom: 0; top: 100;}

                                TextApp {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 5
                                    verticalAlignment: Text.AlignVCenter
                                    height: parent.height
                                    text: "%"
                                    color: "gray"
                                }//

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("Downflow Fan (%)"))
                                }//
                                onAccepted: {
                                    fanDownflowSlider.value = Number(text)
                                    MachineAPI.setFanPrimaryDutyCycle(Number(text))
                                }
                            }//
                            SliderApp {
                                id: fanDownflowSlider
                                anchors.verticalCenter: parent.verticalCenter
                                width: 700
                                stepSize: 1
                                from: 0
                                to: 100
                                padding: 0

                                onValueChanged: {
                                    if (pressed) {
                                        MachineAPI.setFanPrimaryDutyCycle(fanDownflowSlider.value)
                                        dfaDcyTextField.text = fanDownflowSlider.value
                                    }//
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

                            imageSource: "/UI/Pictures/back-step.png"
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

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //console.debug("StackView.Active");

                fanInflowSlider.value = MachineData.fanInflowDutyCycle
                fanDownflowSlider.value = MachineData.fanPrimaryDutyCycle
                ifaDcyTextField.text = fanInflowSlider.value
                dfaDcyTextField.text = fanDownflowSlider.value
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
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
