/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

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
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Field Calibrate Sensor"

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
                    title: qsTr("Field Calibrate Sensor")
                }//
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column {
                    anchors.centerIn: parent
                    spacing: 2

                    Image {
                        id: featureImage
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: 100
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/UI/Pictures/done-green-white.png"
                    }//

                    TextApp {
                        width: 500
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        text: "Calibration has been done!"
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
                                var intent = IntentApp.create(uri, {})
                                finishView(intent)
                            }
                        }//
                    }//
                }//
            }//
        }//

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

                /// set back operation mode
                MachineAPI.setOperationPreviousMode();
                MachineAPI.setFanCloseLoopControlEnable(MachineData.fanCloseLoopControlEnablePrevState)
                if(MachineData.fanCloseLoopControlEnablePrevState)
                    MachineAPI.setFanCloseLoopControlEnablePrevState(false)
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
