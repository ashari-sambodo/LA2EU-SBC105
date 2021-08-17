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
    title: "Light Intensity"

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
                    anchors.fill: parent
                    title: qsTr("Light Intensity")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column {
                    anchors.centerIn: parent
                    spacing: 20

                    TextApp {
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 32
                        text: slider.value + "%"
                    }//

                    SliderApp {
                        id: slider
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 500
                        stepSize: 5
                        from: 30
                        to: 100
                        padding: 0

                        Image {
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/UI/Pictures/brightness_lowest_icon.png"
                        }

                        Image {
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/UI/Pictures/brightness_highest_icon.png"
                        }

                        onValueChanged: {
                            if (pressed) {
                                MachineAPI.setLightIntensity(slider.value)
                            }//
                        }//

                        onPressedChanged: {
                            if (!pressed) {
                                //                                //console.debug("released")
                                MachineAPI.saveLightIntensity(slider.value)

                                MachineAPI.insertEventLog(qsTr("User: Set Light intensity to") + " " + slider.value + "%")
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
        Loader {
            active: viewApp.stackViewStatusForeground
            sourceComponent: QtObject {

                /// onResume
                Component.onCompleted: {
                    //                    //console.debug("StackView.Active");

                    slider.value = MachineData.lightIntensity
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
