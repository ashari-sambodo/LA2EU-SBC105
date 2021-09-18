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
                    CusCom.CurveTuningApp{
                        id: curve1
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        //enabled: false
                        //visible: false
                        title: qsTr("Downflow")

                    }
                    CusCom.CurveTuningApp{
                        id: curve2
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        //enabled: false
                        //visible: false
                        title: qsTr("Inflow")
                        //                        modelY: props.ifaActualVelocity
                        //                        kp: props.ifaKp
                        //                        ki: props.ifaKi
                        //                        kd: props.ifaKd
                        //                        setpoint: props.ifaSetpoint
                        //                        samplingTime: props.samplingTime
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
            property var dfaActualVelocityModel: []
            property real ifaKp: 0.0
            property real ifaKi: 0.0
            property real ifaKd: 0.0
            property real ifaSetpoint: 0.0
            property var ifaActualVelocityModel: []

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
                let extradata = IntentApp.getExtraData(intent)

                props.dfaKp             = extradata['dfaKp'] || 0
                props.dfaKi             = extradata['dfaKi'] || 0
                props.dfaKd             = extradata['dfaKd'] || 0
                props.dfaSetpoint       = extradata['dfaSetpoint'] || 0
                props.dfaActualVelocityModel = extradata['dfaModel'] || 0

                props.ifaKp             = extradata['ifaKp'] || 0
                props.ifaKi             = extradata['ifaKi'] || 0
                props.ifaKd             = extradata['ifaKd'] || 0
                props.ifaSetpoint       = extradata['ifaSetpoint'] || 0
                props.ifaActualVelocityModel = extradata['ifaModel'] || 0

                props.samplingTime      = extradata['samplingTime'] || 0

                //curve1.modelY       = props.dfaActualVelocityModel
                curve1.kp           = props.dfaKp
                curve1.ki           = props.dfaKi
                curve1.kd           = props.dfaKd
                curve1.setpoint     = props.dfaSetpoint
                curve1.samplingTime = props.samplingTime

                //curve2.modelY       = props.ifaActualVelocityModel
                curve2.kp           = props.ifaKp
                curve2.ki           = props.ifaKi
                curve2.kd           = props.ifaKd
                curve2.setpoint     = props.ifaSetpoint
                curve2.samplingTime = props.samplingTime

                curve1.activate()
                curve2.activate()
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

