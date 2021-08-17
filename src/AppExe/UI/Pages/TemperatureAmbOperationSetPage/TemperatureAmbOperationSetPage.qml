/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Environmental Temperature Limit"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        /// just for development
        /// comment following line after release
        //        visible: true

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
                    title: qsTr("Environmental Temperature Limit")
                }//
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Row {
                            id: lowesLimitRow
                            anchors.centerIn: parent

                            Image {
                                source: "qrc:/UI/Pictures/temp-opration-limit-lowest.png"
                            }

                            Column {
                                //                            id: currentValueColumn
                                spacing: 5

                                TextApp {
                                    text: qsTr("Low limit")
                                    color: "#cccccc"
                                }//

                                TextApp {
                                    id: currentLowestText
                                    font.pixelSize: 36
                                    wrapMode: Text.WordWrap
                                    //                                    text: "0°"
                                    //                                text:  props.lifeMeter + "%" + " (" + utils.strfMinToHumanReadableShort(props.currentMeter) + ")"
                                }//

                                TextApp{
                                    text: qsTr("Tap here to set")
                                    color: "#cccccc"
                                    font.pixelSize: 16
                                }//
                            }//
                        }

                        MouseArea {
                            anchors.fill: lowesLimitRow
                            onClicked: {
                                KeyboardOnScreenCaller.openNumpad(lowestLimitNewTextField, qsTr("Lowest Limit") + " " +  props.measurementUnitStr)
                            }//
                        }//

                        TextFieldApp {
                            id: lowestLimitNewTextField
                            visible: false
                            validator: IntValidator {bottom: -40; top: 176} /// 80 degreeC

                            onAccepted: {
                                //                                console.log(text)
                                let val = Number(text)
                                props.lowestLimitNew = props.measurementUnit
                                        ? Number(Number(utilsApp.fahrenheitToCelcius(val)).toFixed())
                                        : val
                                currentLowestText.text = props.measurementUnit ? val + "°F" : val + "°C"
                            }
                        }//
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Row {
                            id: highestLimitRow
                            anchors.centerIn: parent

                            Image {
                                source: "qrc:/UI/Pictures/temp-opration-limit-highest.png"
                            }

                            Column {
                                //                            id: currentValueColumn
                                spacing: 5

                                TextApp {
                                    text: qsTr("High limit")
                                    color: "#cccccc"
                                }//

                                TextApp {
                                    id: currentHighestText
                                    font.pixelSize: 36
                                    wrapMode: Text.WordWrap
                                    //                                    text: "80°"
                                    //                                text:  props.lifeMeter + "%" + " (" + utils.strfMinToHumanReadableShort(props.currentMeter) + ")"
                                }//

                                TextApp{
                                    text: qsTr("Tap here to set")
                                    color: "#cccccc"
                                    font.pixelSize: 16
                                }//
                            }//

                        }

                        MouseArea {
                            anchors.fill: highestLimitRow
                            onClicked: {
                                KeyboardOnScreenCaller.openNumpad(highestLimitNewTextField, qsTr("Highest Limit") + " " +  props.measurementUnitStr)
                            }//
                        }//

                        TextFieldApp {
                            id: highestLimitNewTextField
                            visible: false
                            validator: IntValidator {bottom: -40; top: 176} /// 80 degreeC

                            onAccepted: {
                                //                                console.log(text)
                                let val = Number(text)
                                props.highestLimitNew = props.measurementUnit
                                        ? Number(Number(utilsApp.fahrenheitToCelcius(val)).toFixed())
                                        : val
                                currentHighestText.text = props.measurementUnit ? val + "°F" : val + "°C"
                            }
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
                                console.debug("lowestLimitNew: " + props.lowestLimitNew)
                                console.debug("highestLimitNew: " + props.highestLimitNew)

                                if ((props.lowestLimitNew != props.lowestLimitMachine)
                                        || (props.highestLimitNew != props.highestLimitMachine)){

                                    console.debug("lowestLimitNew: " + lowestLimitNew)
                                    console.debug("highestLimitNew: " + highestLimitNew)

                                    /// send to backend
                                    MachineAPI.setEnvTempLowestLimit(lowestLimitNew);
                                    MachineAPI.setEnvTempHighestLimit(highestLimitNew);

                                    showBusyPage(qsTr("Setting up..."), function(cycle){
                                        if(cycle === 3) {
                                            var intent = IntentApp.create(uri, {})
                                            finishView(intent)
                                        }
                                    })
                                }
                                else {
                                    var intent = IntentApp.create(uri, {})
                                    finishView(intent)
                                }
                            }//
                        }//

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            visible: (props.lowestLimitNew != props.lowestLimitMachine)
                                     || (props.highestLimitNew != props.highestLimitMachine)

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Save")

                            onClicked: {
                                console.debug("lowestLimitNew: " + props.lowestLimitNew)
                                console.debug("highestLimitNew: " + props.highestLimitNew)

                                if (props.lowestLimitNew >= props.highestLimitNew) {
                                    showDialogMessage(qsTr("Environmental Temperature Limit"),
                                                      qsTr("Invalid input range!<br>Highest limit value should be higher than lowest limit value."),
                                                      dialogAlert)
                                }//
                                else {
                                    /// send to backend
                                    MachineAPI.setEnvTempLowestLimit(props.lowestLimitNew);
                                    MachineAPI.setEnvTempHighestLimit(props.highestLimitNew);

                                    showBusyPage(qsTr("Setting up..."), function(cycle){
                                        if(cycle === 3) {
                                            closeDialog()
                                        }
                                    })
                                }
                            }//
                        }//
                    }//
                }//
            }//
        }//

        UtilsApp {
            id: utilsApp
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int measurementUnit: 0
            property string measurementUnitStr: "°F"

            property int lowestLimitNew: 0
            property int highestLimitNew: 0

            property int lowestLimitMachine: 0
            property int highestLimitMachine: 0
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                /// 1: imperial
                /// 0: metric
                const meaUnit = MachineData.measurementUnit
                props.measurementUnit = meaUnit
                props.measurementUnitStr = meaUnit ? "°F" : "°C"

                props.lowestLimitNew = MachineData.envTempLowestLimit
                props.highestLimitNew = MachineData.envTempHighestLimit

                props.lowestLimitMachine = Qt.binding(function(){return MachineData.envTempLowestLimit})
                props.highestLimitMachine = Qt.binding(function(){return MachineData.envTempHighestLimit})

                let val = props.measurementUnit
                    ? Number(Number(utilsApp.celciusToFahrenheit(MachineData.envTempLowestLimit)).toFixed())
                    : MachineData.envTempLowestLimit
                currentLowestText.text = props.measurementUnit ? val + "°F" : val + "°C"
                lowestLimitNewTextField.text = val

                val = props.measurementUnit
                    ? Number(Number(utilsApp.celciusToFahrenheit(MachineData.envTempHighestLimit)).toFixed())
                    : MachineData.envTempHighestLimit
                currentHighestText.text = props.measurementUnit ? val + "°F" : val + "°C"
                highestLimitNewTextField.text = val
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
