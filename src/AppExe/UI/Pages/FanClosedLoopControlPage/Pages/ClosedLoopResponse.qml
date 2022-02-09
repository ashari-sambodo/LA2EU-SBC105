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

import UI.CusCom 1.1
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
                        title: qsTr("Downflow")

                    }
                    CusCom.CurveTuningApp{
                        id: curve2
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        title: qsTr("Inflow")
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
                                var intent = IntentApp.create(uri,{})
                                finishView(intent)
                            }//
                        }//
                    }//
                }//
            }//
        }//

        UtilsApp{
            id: utils
        }
        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property real dfaKp: 0.0
            property real dfaKi: 0.0
            property real dfaKd: 0.0
            property real dfaSetpoint: 0.0
            property variant dfaActualVelocityModel: []
            property real ifaKp: 0.0
            property real ifaKi: 0.0
            property real ifaKd: 0.0
            property real ifaSetpoint: 0.0
            property variant ifaActualVelocityModel: []

            property int samplingTime: 0
        }//

        /// One time executed after onResume
        Component.onCompleted: {
            let decimal = MachineData.measurementUnit ? 0 : 2
            let tempDfa = MachineData.getFanClosedLoopSetpoint(0)/100
            props.dfaKp             = MachineData.getFanClosedLoopGainProportional(0)
            props.dfaKi             = MachineData.getFanClosedLoopGainIntegral(0)
            props.dfaKd             = MachineData.getFanClosedLoopGainDerivative(0)
            props.dfaSetpoint       = Number(tempDfa.toFixed(decimal))

            let tempIfa = MachineData.getFanClosedLoopSetpoint(1)/100
            props.ifaKp             = MachineData.getFanClosedLoopGainProportional(1)
            props.ifaKi             = MachineData.getFanClosedLoopGainIntegral(1)
            props.ifaKd             = MachineData.getFanClosedLoopGainDerivative(1)
            props.ifaSetpoint       = Number(tempIfa.toFixed(decimal))

            props.samplingTime      = MachineData.getFanClosedLoopSamplingTime()

            for(let i = 0; i < 60; i++){
                let dfa = MachineData.getDfaVelClosedLoopResponse(i)/100
                let ifa = MachineData.getIfaVelClosedLoopResponse(i)/100
                props.dfaActualVelocityModel[i] = Number(dfa.toFixed(decimal))
                props.ifaActualVelocityModel[i] = Number(ifa.toFixed(decimal))
            }//

            //console.debug(props.dfaActualVelocityModel)
            //console.debug(props.ifaActualVelocityModel)

            curve1.modelY       = props.dfaActualVelocityModel
            curve1.kp           = props.dfaKp
            curve1.ki           = props.dfaKi
            curve1.kd           = props.dfaKd
            curve1.setpoint     = props.dfaSetpoint
            curve1.samplingTime = props.samplingTime
            curve1.meaUnitMetric= decimal === 2 ? true : false

            curve2.modelY       = props.ifaActualVelocityModel
            curve2.kp           = props.ifaKp
            curve2.ki           = props.ifaKi
            curve2.kd           = props.ifaKd
            curve2.setpoint     = props.ifaSetpoint
            curve2.samplingTime = props.samplingTime
            curve2.meaUnitMetric= decimal === 2 ? true : false

            curve1.activate()
            curve2.activate()
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

