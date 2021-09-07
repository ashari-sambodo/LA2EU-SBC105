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
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Closed Loop Control Tuning"

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
                    title: qsTr("Closed Loop Control Tuning")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.topMargin: 5
                Layout.bottomMargin: 5
                Column{
                    anchors.centerIn: parent
                    Row{
                        spacing: 20
                        Column{
                            spacing: 5
                            TextApp {
                                id: textTitleDfa
                                text: qsTr("Downflow")
                            }//
                            Rectangle{
                                id: rectDfaParameters
                                height: colDfaParameters.height + 10
                                width: colDfaParameters.width + 10
                                color: "#0F2952"
                                radius: 5
                                border.color: "#e3dac9"
                                Column{
                                    id: colDfaParameters
                                    spacing: 5
                                    anchors.centerIn: parent
                                    Column{
                                        spacing: 5
                                        TextApp {
                                            id: textSubTitleDfaKp
                                            text: qsTr("Gain Proportional")
                                        }//

                                        TextFieldApp {
                                            id: dfaTextFieldKp
                                            width: 110
                                            height: 40
                                            validator: IntValidator{bottom: 0; top: 10;}

                                            onPressed: {
                                                KeyboardOnScreenCaller.openNumpad(this, "%1 (%2)".arg(textSubTitleDfaKp.text).arg(textTitleDfa.text))
                                            }//
                                        }//
                                    }
                                    Column{
                                        spacing: 5
                                        TextApp {
                                            id: textSubTitleDfaKi
                                            text: qsTr("Gain Integral")
                                        }//

                                        TextFieldApp {
                                            id: dfaTextFieldKi
                                            width: 110
                                            height: 40
                                            validator: IntValidator{bottom: 0; top: 1;}
                                            onPressed: {
                                                KeyboardOnScreenCaller.openNumpad(this, "%1 (%2)".arg(textSubTitleDfaKi.text).arg(textTitleDfa.text))
                                            }//
                                        }//
                                    }
                                    Column{
                                        spacing: 5
                                        TextApp {
                                            id: textSubTitleDfaKd
                                            text: qsTr("Gain Derivatif")
                                        }//

                                        TextFieldApp {
                                            id: dfaTextFieldKd
                                            width: 110
                                            height: 40
                                            validator: IntValidator{bottom: 0; top: 10;}
                                            onPressed: {
                                                KeyboardOnScreenCaller.openNumpad(this, "%1 (%2)".arg(textSubTitleDfaKd.text).arg(textTitleDfa.text))
                                            }//
                                        }//
                                    }
                                }//
                            }//
                        }//
                        Column{
                            spacing: 5
                            TextApp {
                                id: textTitleIfa
                                text: qsTr("Inflow")
                            }//
                            Rectangle{
                                id: rectIfaParameters
                                height: colIfaParameters.height + 10
                                width: colIfaParameters.width + 10
                                color: "#0F2952"
                                radius: 5
                                border.color: "#e3dac9"
                                Column{
                                    id: colIfaParameters
                                    clip: true
                                    spacing: 5
                                    anchors.centerIn: parent
                                    Column{
                                        spacing: 5
                                        TextApp {
                                            id: textSubTitleIfaKp
                                            text: qsTr("Gain Proportional")
                                        }//

                                        TextFieldApp {
                                            id: ifaTextFieldKp
                                            width: 110
                                            height: 40
                                            validator: IntValidator{bottom: 0; top: 10;}

                                            onPressed: {
                                                KeyboardOnScreenCaller.openNumpad(this, "%1 (%2)".arg(textSubTitleIfaKp.text).arg(textTitleIfa.text))
                                            }//
                                        }//
                                    }
                                    Column{
                                        spacing: 5
                                        TextApp {
                                            id: textSubTitleIfaKi
                                            text: qsTr("Gain Integral")
                                        }//

                                        TextFieldApp {
                                            id: ifaTextFieldKi
                                            width: 110
                                            height: 40
                                            validator: IntValidator{bottom: 0; top: 10;}

                                            onPressed: {
                                                KeyboardOnScreenCaller.openNumpad(this, "%1 (%2)".arg(textSubTitleIfaKi.text).arg(textTitleIfa.text))
                                            }//
                                        }//
                                    }
                                    Column{
                                        spacing: 5
                                        TextApp {
                                            id: textSubTitleIfaKd
                                            text: qsTr("Gain Derivatif")
                                        }//

                                        TextFieldApp {
                                            id: ifaTextFieldKd
                                            width: 110
                                            height: 40
                                            validator: IntValidator{bottom: 0; top: 10;}

                                            onPressed: {
                                                KeyboardOnScreenCaller.openNumpad(this, "%1 (%2)".arg(textSubTitleIfaKd.text).arg(textTitleIfa.text))
                                            }//
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//
                    Column{
                        spacing: 5
                        TextApp {
                            id: textSubTitleTs
                            text: qsTr("Sampling Time (ms)")
                        }//

                        TextFieldApp {
                            id: textFieldTs
                            width: 110
                            height: 40
                            validator: IntValidator{bottom: 0; top: 10000;}

                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, "%1".arg(textSubTitleTs.text))
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
                        ButtonBarApp {
                            id: setButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            visible: props.parametersChanged

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Save")

                            onClicked: {
                                visible = false

                                const message = qsTr("User: Closed loop paramters changed")
                                MachineAPI.insertEventLog(message)

                                showBusyPage(qsTr("Setting up..."), function(seconds){
                                    if (seconds === 3){
                                        props.parametersChanged = false
                                        closeDialog();
                                    }//
                                })
                            }//
                        }//
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property bool dfaKpChanged:    false
            property bool dfaKiChanged:    false
            property bool dfaKdChanged:    false
            property bool ifaKpChanged:    false
            property bool ifaKiChanged:    false
            property bool ifaKdChanged:    false
            property bool onTsChanged:     false

            property real gainProportionalDfa:   0.0
            property real gainIntegralDfa:       0.0
            property real gainDerivatifDfa:      0.0
            property real gainProportionalIfa:   0.0
            property real gainIntegralIfa:       0.0
            property real gainDerivatifIfa:      0.0
            property int samplingTime:           1000

            onGainProportionalDfaChanged: {gainProportionalDfa !== MachineData.getFanClosedLoopGainProportional(0) ? dfaKpChanged = true : dfaKpChanged = false}
            onGainIntegralDfaChanged: {gainIntegralDfa !== MachineData.getFanClosedLoopGainIntegral(0) ? dfaKiChanged = true : dfaKiChanged = false}
            onGainDerivatifDfaChanged: {gainDerivatifDfa !== MachineData.getFanClosedLoopGainDerivatif(0) ? dfaKdChanged = true : dfaKdChanged = false}
            onGainProportionalIfaChanged: {gainProportionalIfa !== MachineData.getFanClosedLoopGainProportional(1) ? ifaKpChanged = true : ifaKpChanged = false}
            onGainIntegralIfaChanged: {gainIntegralIfa !== MachineData.getFanClosedLoopGainIntegral(1) ? ifaKiChanged = true : ifaKiChanged = false}
            onGainDerivatifIfaChanged: {gainDerivatifIfa !== MachineData.getFanClosedLoopGainDerivatif(1) ? ifaKdChanged = true : ifaKdChanged = false}

        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                props.gainProportionalDfa = MachineData.getFanClosedLoopGainProportional(0)
                props.gainIntegralDfa = MachineData.getFanClosedLoopGainIntegral(0)
                props.gainDerivatifDfa = MachineData.getFanClosedLoopGainDerivatif(0)
                props.gainProportionalIfa = MachineData.getFanClosedLoopGainProportional(1)
                props.gainIntegralIfa = MachineData.getFanClosedLoopGainIntegral(1)
                props.gainDerivatifIfa = MachineData.getFanClosedLoopGainDerivatif(1)
                props.samplingTime = MachineData.getFanClosedLoopSamplingTime()

                dfaTextFieldKp.text = props.gainProportionalDfa
                dfaTextFieldKi.text = props.gainIntegralDfa
                dfaTextFieldKd.text = props.gainDerivatifDfa
                ifaTextFieldKp.text = props.gainProportionalIfa
                ifaTextFieldKi.text = props.gainIntegralIfa
                ifaTextFieldKd.text = props.gainDerivatifIfa
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

