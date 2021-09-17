/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Heri Cahyono
 *  - Ahmad Qodri
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7

import UI.CusCom 1.0
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0
import ModulesCpp.RegisterExternalResources 1.0
import "../Components" as CusCom

ViewApp {
    id: viewApp
    title: "Close Loop Tuning Help"

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
                    title: qsTr("Close Loop Tuning Help")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                ColumnLayout{
                    anchors.fill: parent
                    spacing: 10
                    Item{
                        id: response
                        Layout.minimumHeight: 280
                        Layout.fillWidth: true

                        RowLayout{
                            anchors.fill: parent
                            Item{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                Image{
                                    id: pidCurve1
                                    asynchronous: true
                                    anchors.centerIn: parent
                                    height: parent.height
                                    anchors.margins: 10
                                    source: "qrc:/UI/Pictures/pid/Respons_PID_Controller.png"
                                    fillMode: Image.PreserveAspectFit
                                    opacity: mouseAreaCurve1.pressed ? 0.6 : 1
                                    MouseArea{
                                        id: mouseAreaCurve1
                                        enabled: __osplatform__ ? false : true
                                        anchors.fill: parent
                                        onClicked: {
                                            props.showInfo(6, qsTr("Manual tuning"))
                                        }
                                    }//
                                }//
                            }
                            Item{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                enabled: __osplatform__
                                visible: __osplatform__
                                CusCom.PidTuningAnimationApp{
                                    id: pidCurve2
                                    anchors.centerIn: parent
                                    height: parent.height
                                    anchors.margins: 10
                                    running: __osplatform__
                                    opacity: mouseAreaCurve2.pressed ? 0.6 : 1
                                    MouseArea{
                                        id: mouseAreaCurve2
                                        anchors.fill: parent
                                        onClicked: {
                                            props.showInfo(6, qsTr("Manual tuning"))
                                        }
                                    }//
                                }//
                            }//
                        }//
                    }//
                    Item{
                        id: table
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        property var tableWidth : [135,113,123,144,195,182]
                        Column{
                            anchors.centerIn: parent
                            TextApp{
                                font.pixelSize: 18
                                text: qsTr("Effect of increasing a parameter independently.")
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Row{
                                Repeater{
                                    model: ["Parameters", "Rise time", "Overshoot", "Settling time", "Steady-state error", "Stability"]

                                    Rectangle{
                                        id: rectTableTitle
                                        height: 30
                                        width: table.tableWidth[index]
                                        color: "#33000000"
                                        border.width: 1
                                        border.color: "#e3dac9"
                                        TextApp{
                                            id: textTitle
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: modelData
                                            padding: 5
                                            font.bold: true
                                            color: index > 0 ? "#00E0FF" : "#e3dac9"
                                            font.pixelSize: 18
                                        }//
                                        MouseArea{
                                            id: tableTitleMa
                                            enabled: index > 0
                                            anchors.fill: parent
                                            onClicked: {
                                                props.showInfo(index, modelData)
                                            }//
                                        }//
                                    }//
                                }//
                            }//
                            Row{
                                Repeater{
                                    model: ["Kp", "Decrease", "Increase", "Small change", "Decrease", "Degrade"]
                                    Rectangle{
                                        height: 30
                                        width: table.tableWidth[index]
                                        color: "#33000000"
                                        border.width: 1
                                        border.color: "#e3dac9"
                                        TextApp{
                                            height: parent.height
                                            width: parent.width
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            text: modelData
                                            padding: 5
                                            font.bold: index === 0 ? true : false
                                            font.pixelSize: 18
                                            minimumPixelSize: 16
                                            fontSizeMode: Text.Fit
                                        }//
                                    }//
                                }//
                            }//
                            Row{
                                Repeater{
                                    model: ["Ki", "Decrease", "Increase", "Increase", "Eliminate", "Degrade"]
                                    Rectangle{
                                        height: 30
                                        width: table.tableWidth[index]
                                        color: "#33000000"
                                        border.width: 1
                                        border.color: "#e3dac9"
                                        TextApp{
                                            height: parent.height
                                            width: parent.width
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            text: modelData
                                            padding: 5
                                            font.bold: index === 0 ? true : false
                                            font.pixelSize: 18
                                            minimumPixelSize: 16
                                            fontSizeMode: Text.Fit
                                        }//
                                    }//
                                }//
                            }//
                            Row{
                                Repeater{
                                    model: ["Kd", "Minor change", "Decrease", "Decrease", "No effect in theory", "Improve if Kd small"]
                                    Rectangle{
                                        height: 30
                                        width: table.tableWidth[index]
                                        color: "#33000000"
                                        border.width: 1
                                        border.color: "#e3dac9"
                                        TextApp{
                                            height: parent.height
                                            width: parent.width
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            text: modelData
                                            padding: 5
                                            font.bold: index === 0 ? true : false
                                            font.pixelSize: 18
                                            minimumPixelSize: 16
                                            fontSizeMode: Text.Fit
                                        }//
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

        RegisterExResources {
            id: registerExResources
        }

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props
            //property bool init: false

            function showInfo(index, title){
                let msg = ""
                switch(index){
                case 1: msg = "<i>" + qsTr("The time it takes for the plant output to rise beyond 90% of the desired level for the first time.") + "</i>"; break
                case 2: msg = "<i>" + qsTr("How much the the peak level is higher than the steady state, normalized against the steady state.") + "</i>"; break
                case 3: msg = "<i>" + qsTr("The time it takes for the system to converge to its steady state.") + "</i>"; break
                case 4: msg = "<i>" + qsTr("The difference between the steady-state output and the desired output.") + "</i>"; break
                case 5: msg = "<i>" + qsTr("The ability of the controller to keep its output at the setpoint value") + "</i>"; break
                case 6: msg = "<i>" + qsTr("1) Set Ki and Kd values to zero.")
                        + "<br>" + qsTr("2) Increase the Kp until the loop gets its best performance.")
                        + "<br>" + qsTr("3) Increase the Ki until any offset corrected, be careful too much Ki will cause instability.")
                        + "<br>" + qsTr("4) Increase Kd (if required), until the loop is acceptably quick to reach the setpoint after a load disturbance.")
                        + "</i>"; break
                default: break
                }
                showDialogMessage(title, msg, dialogInfo, undefined, false)
            }
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

            }//

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
                registerExResources.releaseResource();
            }//
        }//
    }//
}//
