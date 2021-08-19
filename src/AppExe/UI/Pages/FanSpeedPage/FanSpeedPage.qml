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

                        TextApp {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Exhaust: " + fanInflowSlider.value + "%"
                        }

                        Slider {
                            id: fanInflowSlider
                            //                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 500
                            stepSize: 1
                            from: 0
                            to: 100

                            onValueChanged: {
                                if (pressed) {
                                    MachineAPI.setFanInflowDutyCycle(fanInflowSlider.value)
                                }//
                            }//
                        }//
                    }//

                    Column {

                        TextApp {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Downflow: " + fanDownflowSlider.value + "%"
                        }

                        Slider {
                            id: fanDownflowSlider
                            //                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 500
                            stepSize: 1
                            from: 0
                            to: 100

                            onValueChanged: {
                                if (pressed) {
                                    MachineAPI.setFanPrimaryDutyCycle(fanDownflowSlider.value)
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
