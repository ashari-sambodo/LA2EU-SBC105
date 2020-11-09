import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import modules.cpp.machine 1.0

ViewApp {
    id: viewApp
    title: "Fan Duty Cycle"

    background.sourceComponent: Item {}

    content.sourceComponent: Item{
        id: containerItem
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
                    title: qsTr(viewApp.title)
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
                            text: "Exhaust: " + blowerInflowSlider.value + "%"
                        }

                        Slider {
                            id: blowerInflowSlider
                            //                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 500
                            stepSize: 1
                            from: 0
                            to: 100

                            onValueChanged: {
                                if (pressed) {
                                    MachineApi.setBlowerInflowDutyCycle(blowerInflowSlider.value)
                                }//
                            }//
                        }//
                    }//

                    Column {

                        TextApp {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Downflow: " + blowerDownflowSlider.value + "%"
                        }

                        Slider {
                            id: blowerDownflowSlider
                            //                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 500
                            stepSize: 1
                            from: 0
                            to: 100

                            onValueChanged: {
                                if (pressed) {
                                    MachineApi.setBlowerDownflowDutyCycle(blowerDownflowSlider.value)
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
                    color: "#770F2952"
                    //                    border.color: "#ffffff"
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

        /// OnCreated
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        Loader {
            active: viewApp.stackViewStatusActivating || viewApp.stackViewStatusActive
            sourceComponent: QtObject {

                /// onResume
                Component.onCompleted: {
                    console.log("StackView.Active");

                    blowerInflowSlider.value = MachineData.blowerInflowDutyCycle
                    blowerDownflowSlider.value = MachineData.blowerDownflowDutyCycle
                }

                /// onPause
                Component.onDestruction: {
                    //console.log("StackView.DeActivating");
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
