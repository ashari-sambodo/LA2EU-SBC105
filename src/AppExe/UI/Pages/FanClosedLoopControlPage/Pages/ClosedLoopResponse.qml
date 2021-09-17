/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7

import UI.CusCom 1.0
import "../../../CusCom/JS/IntentApp.js" as IntentApp
import "../Components" as CusCom
import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Closed Loop System Response"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        /// just for development
        /// comment following line after release
        visible: true

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
                    title: qsTr("Closed Loop System Response")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Loader {
                            id: dfaLoader
                            active: false
                            anchors.fill: parent
                            sourceComponent: CusCom.CurveTuningApp{
                                id: curve1
                                anchors.fill: parent
                                title: qsTr("Downflow")
                                modelY: props.dfaActualVelocity
                                kp: props.dfaKp
                                ki: props.dfaKi
                                kd: props.dfaKd
                                setpoint: props.dfaSetpoint
                                samplingTime: props.samplingTime
                            }
                        }
                    }
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Loader {
                            id: ifaLoader
                            active: false
                            anchors.fill: parent
                            sourceComponent: CusCom.CurveTuningApp{
                                id: curve2
                                anchors.fill: parent
                                title: qsTr("Inflow")
                                modelY: props.ifaActualVelocity
                                kp: props.ifaKp
                                ki: props.ifaKi
                                kd: props.ifaKd
                                setpoint: props.ifaSetpoint
                                samplingTime: props.samplingTime
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

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property real dfaKp: 0.0
            property real dfaKi: 0.0
            property real dfaKd: 0.0
            property real dfaSetpoint: 0.0
            property var dfaActualVelocity: []
            property real ifaKp: 0.0
            property real ifaKi: 0.0
            property real ifaKd: 0.0
            property real ifaSetpoint: 0.0
            property var ifaActualVelocity: []

            property int samplingTime: 0
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                dfaLoader.active= true
                ifaLoader.active= true
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

