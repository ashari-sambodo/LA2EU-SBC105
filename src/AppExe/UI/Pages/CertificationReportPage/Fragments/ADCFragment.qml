import QtQuick 2.0
import UI.CusCom 1.0

import Qt.labs.settings 1.1

import ModulesCpp.Machine 1.0

Item {


    Column {
        anchors.centerIn: parent
        spacing: 5

        Column {
            TextApp {
                text: qsTr("Sensor (VDC): Press and type the value from Volt Meter!")
            }//

            TextApp {
                text: qsTr("ADC Actual (IFA): Ensure blower is ON, then press it to re-capturing!")
            }//
        }//

        Rectangle {
            width: parent.width
            height: 1
            color: "#e3dac9"
        }//

        Grid{
            spacing: 10

            Rectangle {
                //            height: children[0].height + 10
                //            width: children[0].width + 10
                height: 110
                width: 150
                color: "#aaf39c12"
                radius: 5
                border.width: 1
                border.color: "#f39c12"

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        text: qsTr("Sensor\n(VDC)")
                    }//

                    TextFieldApp {
                        id: sensorVoltageTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        //                    enabled: false
                        colorBorder: "#f39c12"
                        //                text: "10"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Sensor voltage (VDC)"))
                        }//

                        onAccepted: {
                            settings.sensorVdc = text
                        }//
                    }//
                }//
            }

            Rectangle {
                //            height: children[0].height + 10
                //            width: children[0].width + 10
                height: 110
                width: 150
                color: "#aaf39c12"
                radius: 5
                border.width: 1
                border.color: "#f39c12"

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        id: adcActualText
                        text: qsTr("ADC Actual\n(IFA)")
                    }//

                    TextFieldApp {
                        id: adcActualTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        colorBorder: "#f39c12"
                        //                text: "2021-123456"
                    }//
                }//

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        //                                console.log("onClicked")
                        adcActualTextField.text = MachineData.ifaAdcConpensation
                        settings.adcActual = MachineData.ifaAdcConpensation
                    }//
                }//
            }//

            Rectangle {
                //            height: children[0].height + 10
                //            width: children[0].width + 10
                height: 110
                width: 150
                color: "#aa0F2952"
                radius: 5
                border.width: 1
                border.color: "#e3dac9"

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        id: modelText
                        text: qsTr("ADC Min\nField (IFF)")
                    }//

                    TextFieldApp {
                        id: adcMinTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        //                text: "LA2-4S8 NS"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC Minimum - Field (IFF)"))
                        }//

                        onAccepted: {
                            settings.adcMinField = text
                        }//
                    }//
                }//
            }//

            Rectangle {
                //            height: children[0].height + 10
                //            width: children[0].width + 10
                height: 110
                width: 150
                color: "#aa0F2952"
                radius: 5
                border.width: 1
                border.color: "#e3dac9"

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        id: calibProText
                        text: qsTr("ADC Nominal\nField (IFN)")
                    }//

                    TextFieldApp {
                        id: adcNomTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        //                text: "LA2-4S8 NS"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this,  qsTr("ADC Nominal - Field (IFN)"))
                        }//

                        onAccepted: {
                            settings.adcNomField = text
                        }//
                    }//
                }//
            }//

            Rectangle {
                //            height: children[0].height + 10
                //            width: children[0].width + 10
                height: 110
                width: 150
                color: "#aa0F2952"
                radius: 5
                border.width: 1
                border.color: "#e3dac9"

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        text: qsTr("ADC Zero\nFactory (IF0)")
                    }//

                    TextFieldApp {
                        id: adcZeroFactoryTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        //                text: "120 VAC / 50Hz"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC Zero - Factory (IF0)"))
                        }//

                        onAccepted: {
                            settings.adcZeroFac = text
                        }//
                    }//
                }//
            }//

            Rectangle {
                //            height: children[0].height + 10
                //            width: children[0].width + 10
                height: 110
                width: 150
                color: "#aa0F2952"
                radius: 5
                border.width: 1
                border.color: "#e3dac9"

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        text: qsTr("ADC Min\nFactory (IF1)")
                    }//

                    TextFieldApp {
                        id: adcMinFactoryTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        //                text: "0.0005"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC Minimum - Factory (IF1)"))
                        }//

                        onAccepted: {
                            settings.adcMinFac = text
                        }//
                    }//
                }//
            }//

            Rectangle {
                //            height: children[0].height + 10
                //            width: children[0].width + 10
                height: 110
                width: 150
                color: "#aa0F2952"
                radius: 5
                border.width: 1
                border.color: "#e3dac9"

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        text: qsTr("ADC Nom\nFactory (IF2)")
                    }//

                    TextFieldApp {
                        id: adcNomFactoryTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        //                text: "2"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC Nominal - Factory (IF2)"))
                        }//

                        onAccepted: {
                            settings.adcNomFac = text
                        }//
                    }//
                }//
            }//

            Rectangle {
                //            height: children[0].height + 10
                //            width: children[0].width + 10
                height: 110
                width: 150
                color: "#aa0F2952"
                radius: 5
                border.width: 1
                border.color: "#e3dac9"

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        text: qsTr("\nIF2 - IF1")
                    }//

                    TextFieldApp {
                        id: adcRangeTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        //                text: "10"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC Range"))
                        }//

                        onAccepted: {
                            settings.adcRangeFac = text
                        }//
                    }//
                }//
            }//

            Rectangle {
                //            height: children[0].height + 10
                //            width: children[0].width + 10
                height: 110
                width: 150
                color: "#aa0F2952"
                radius: 5
                border.width: 1
                border.color: "#e3dac9"

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        text: qsTr("Sensor\nConstant")
                    }//

                    TextFieldApp {
                        id: sensorConstantTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        //                text: "10"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Sensor Constant"))
                        }//

                        onAccepted: {
                            settings.sensorConst = text
                        }//
                    }//
                }//
            }//

            Rectangle {
                //            height: children[0].height + 10
                //            width: children[0].width + 10
                height: 110
                width: 150
                color: "#aa0F2952"
                radius: 5
                border.width: 1
                border.color: "#e3dac9"

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        text: qsTr("Calibration\nTemp") + " (" + degreeMeaStr + ")"

                        property int degreeMea: 0
                        property string degreeMeaStr: degreeMea ? "°F" : "°C"

                        Component.onCompleted: {
                            degreeMea = MachineData.measurementUnit
                        }//
                    }//

                    TextFieldApp {
                        id: calibTempTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        //                text: "10"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Calibration Temp"))
                        }//

                        onAccepted: {
                            settings.calibTemp = text
                        }//
                    }//
                }//
            }//

            Rectangle {
                //            height: children[0].height + 10
                //            width: children[0].width + 10
                height: 110
                width: 150
                color: "#aa0F2952"
                radius: 5
                border.width: 1
                border.color: "#e3dac9"

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        text: qsTr("Calibration\nTemp ADC")
                    }//

                    TextFieldApp {
                        id: calibTempAdcTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        //                text: "10"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Calibration Temp ADC"))
                        }//

                        onAccepted: {
                            settings.calibTempAdc = text
                        }//
                    }//
                }//
            }//
        }//
    }

    /*
      Author: Heri Cahyono
      Change to not editable except sensor VDC
    */

    Settings {
        id: settings
        category: "certification"

        property string sensorVdc: "0"
        property int adcActual: 0

        Component.onCompleted: {
            sensorVoltageTextField.text     = sensorVdc
            adcActualTextField.text         = MachineData.ifaAdcConpensation
            adcMinTextField.text            = MachineData.getInflowAdcPointFactory(1)
            adcNomTextField.text            = MachineData.getInflowAdcPointFactory(2)
            adcNomFactoryTextField.text     = MachineData.getInflowAdcPointFactory(2)
            adcMinFactoryTextField.text     = MachineData.getInflowAdcPointFactory(1)
            adcZeroFactoryTextField.text    = MachineData.getInflowAdcPointFactory(0)
            sensorConstantTextField.text    = MachineData.getInflowSensorConstant()
            calibTempTextField.text         = MachineData.getInflowTempCalib()
            calibTempAdcTextField.text      = MachineData.getInflowTempCalibAdc()

            adcRangeTextField.text          = MachineData.getInflowAdcPointFactory(2) - MachineData.getInflowAdcPointFactory(1)
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:600;width:640}
}
##^##*/
