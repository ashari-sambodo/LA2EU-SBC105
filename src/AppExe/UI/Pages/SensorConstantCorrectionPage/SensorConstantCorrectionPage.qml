import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Sensor Constant Correction"

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
                    title: qsTr("Sensor Constant Correction")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                Rectangle{
                    anchors.fill: parent
                    color: "#20000000"
                }
                RowLayout{
                    anchors.fill: parent
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        TextApp{
                            width: parent.width
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            textFormat: Text.RichText
                            padding: 5
                            horizontalAlignment: Text.AlignJustify
                            text: qsTr("The default value of the current sensor constant is <b>%1</b>,").arg(MachineData.getInflowSensorConstant()) + " "
                                  + qsTr("this value is a constant when the sensor operates at a calibrated temperature of <b>%1</b>.").arg(props.tempCalibStrf) + "<br>"
                                  + qsTr("The constant of the air flow sensor may be different for different ambient temperatures.")
                                  + "<ul><li>"
                                  + qsTr("Adjust sensor constant <i>%1</i> if ambient temperature is greater than calibration temperature.").arg(highTextField.text)
                                  + "</li><li>"
                                  + qsTr("Adjust sensor constant <i>%1</i> if ambient temperature is less than calibration temperature.").arg(lowTextField.text)
                                  + "</li><li>"
                                  + qsTr("Adjust the constant value until the displayed airflow velocity value matches or is close to the actual value.")
                                  + "</li></ul>"
                            wrapMode: Text.WordWrap
                        }//
                    }//

                    Rectangle{
                        Layout.fillHeight: true
                        Layout.minimumWidth: 1
                        color:"#e3dac9"
                    }
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Column{
                            Rectangle {
                                color: "#80000000"
                                Row{
                                    TextApp {
                                        //id: msgInfoTextApp
                                        text: qsTr("Inflow")
                                        //verticalAlignment: Text.AlignVCenter
                                        padding: 2
                                        width: 150
                                    }
                                    TextApp{
                                        text: ":"
                                    }

                                    TextApp {
                                        id: inflowText
                                        text: MachineData.ifaVelocityStr
                                        //verticalAlignment: Text.AlignVCenter
                                        padding: 2
                                    }
                                }
                                width: childrenRect.width
                                height: childrenRect.height
                                radius: 2
                            }
                            Rectangle {
                                color: "#80000000"
                                Row{
                                    TextApp {
                                        //id: msgInfoTextApp
                                        text: qsTr("Downflow")
                                        //verticalAlignment: Text.AlignVCenter
                                        padding: 2
                                        width: 150
                                    }
                                    TextApp{
                                        text: ":"
                                    }
                                    //                                Rectangle {
                                    //                                    color: "#80000000"
                                    TextApp {
                                        width: inflowText.width
                                        text: MachineData.dfaVelocityStr
                                        //verticalAlignment: Text.AlignVCenter
                                        padding: 2
                                    }
                                }
                                width: childrenRect.width
                                height: childrenRect.height
                                radius: 2
                            }
                            Rectangle {
                                color: "#80000000"
                                Row{
                                    TextApp {
                                        //id: msgInfoTextApp
                                        text: qsTr("Temperature")
                                        //verticalAlignment: Text.AlignVCenter
                                        padding: 2
                                        width: 150
                                    }
                                    TextApp{
                                        text: ":"
                                    }
                                    //                                Rectangle {
                                    //                                    color: "#80000000"
                                    TextApp {
                                        width: inflowText.width
                                        text: MachineData.temperatureValueStr
                                        //verticalAlignment: Text.AlignVCenter
                                        padding: 2
                                    }
                                }
                                width: childrenRect.width
                                height: childrenRect.height
                                radius: 2
                            }
                        }//

                        Row{
                            anchors.centerIn: parent
                            spacing: 10
                            Column{
                                id: colText
                                spacing: 5
                                TextApp{
                                    height: 50
                                    //width: colText.width
                                    horizontalAlignment: Text.AlignRight
                                    verticalAlignment: Text.AlignVCenter
                                    text: qsTr("Status")
                                }//
                                TextApp{
                                    id: highTextField
                                    height: 50
                                    //width: colText.width
                                    horizontalAlignment: Text.AlignRight
                                    verticalAlignment: Text.AlignVCenter
                                    text: qsTr("High Temperature Zone")
                                }//
                                TextApp{
                                    id: lowTextField
                                    height: 50
                                    //width: colText.width
                                    horizontalAlignment: Text.AlignRight
                                    verticalAlignment: Text.AlignVCenter
                                    text: qsTr("Low Temperature Zone")
                                }//
                            }//
                            Column{
                                spacing: 5
                                ComboBoxApp{
                                    id: comboBox
                                    width: 190
                                    height: 50
                                    backgroundColor: "#0F2952"
                                    backgroundBorderColor: "#dddddd"
                                    backgroundBorderWidth: 2
                                    font.pixelSize: 20
                                    //anchors.verticalCenter: parent.verticalCenter
                                    textRole: "text"

                                    model: [
                                        {text: qsTr("Disable"), value: 0},
                                        {text: qsTr("Enable"),  value: 1}
                                    ]

                                    onActivated: {
                                        ////console.debug(index)
                                        ////console.debug(model[index].value)
                                        let newValue = model[index].value
                                        props.sensorCorrEnable = newValue
                                        props.isThereChanges()
                                    }//
                                }//
                                TextFieldApp{
                                    width: 190
                                    height: 50
                                    validator: IntValidator {}
                                    onPressed: {
                                        KeyboardOnScreenCaller.openNumpad(this, highTextField.text)
                                    }//
                                    onAccepted: {
                                        props.highZoneConst = Number(text)
                                        props.isThereChanges()
                                    }//
                                    Component.onCompleted: {
                                        text = MachineData.sensorConstCorrHighZone
                                    }//
                                }//
                                TextFieldApp{
                                    width: 190
                                    height: 50
                                    validator: IntValidator {}
                                    onPressed: {
                                        KeyboardOnScreenCaller.openNumpad(this, lowTextField.text)
                                    }//
                                    onAccepted: {
                                        props.lowZoneConst = Number(text)
                                        props.isThereChanges()
                                    }//
                                    Component.onCompleted: {
                                        text = MachineData.sensorConstCorrLowZone
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
                    //border.color: "#e3dac9"
                    //border.width: 1
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
                            visible: props.needSave
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Set")

                            onClicked: {
                                MachineAPI.setSensorConstCorrEnable(props.sensorCorrEnable)
                                MachineAPI.setSensorConstCorrHighZone(props.highZoneConst)
                                MachineAPI.setSensorConstCorrLowZone(props.lowZoneConst)

                                const string = qsTr("Set sensor const correction")
                                const string1 = qsTr("(En:%1, Hi:%2, Lo:%3)").arg(props.sensorCorrEnable).arg(props.highZoneConst).arg(props.lowZoneConst)

                                MachineAPI.insertEventLog(string + " " + string1)

                                viewApp.showBusyPage(qsTr("Setting up..."),
                                                     function onTriggered(cycle){
                                                         if(cycle === MachineAPI.BUSY_CYCLE_1){
                                                             props.isThereChanges()
                                                             viewApp.dialogObject.close()}
                                                     })//
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

            property bool sensorCorrEnable: false
            property int highZoneConst: 50
            property int lowZoneConst: 50

            property bool needSave: false

            property string tempUnitStr: MachineData.measurementUnit ? "°F" : "°C"
            property string tempCalibStrf: "25°C"

            function isThereChanges() {
                if(sensorCorrEnable != MachineData.sensorConstCorrEnable
                        || highZoneConst != MachineData.sensorConstCorrHighZone
                        || lowZoneConst != MachineData.sensorConstCorrLowZone)
                    needSave = true
                else
                    needSave = false
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
                props.sensorCorrEnable = MachineData.sensorConstCorrEnable
                comboBox.currentIndex = props.sensorCorrEnable

                props.highZoneConst = MachineData.sensorConstCorrHighZone
                props.lowZoneConst = MachineData.sensorConstCorrLowZone

                props.tempCalibStrf = MachineData.getInflowTempCalib() + props.tempUnitStr
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

///The default value of the current sensor constant is <b>%1</b>, this value is a constant when the sensor operates at a calibrated temperature of <b>%2</b>°C.
///The constant of the esco air flow sensor may be different for different ambient temperatures.
///This sensor constant correction allows the sensor to operate properly when the ambient temperature is greater or less than the calibrated temperature.

///<ul><li>Adjust sensor constant high temperature zone if ambient temperature is greater than calibration temperature.</li>
///<li>Adjust sensor constant low temperature zone if ambient temperature is less than calibration temperature.</li>
///<li>Adjust the constant value until the displayed velocity value matches or is close to the actual value.</li></ul>
