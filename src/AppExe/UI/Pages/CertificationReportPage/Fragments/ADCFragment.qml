import QtQuick 2.0
import UI.CusCom 1.0

import Qt.labs.settings 1.1

import ModulesCpp.Machine 1.0

Item {


    Column {
        id: columnMain
        anchors.centerIn: parent
        spacing: 5

        Column {
            TextApp {
                text: qsTr("Sensor (VDC): Press and type the value from Volt Meter!")
                padding: 2
                width: columnMain.width
            }//
            //            TextApp {
            //                text: qsTr("ADC Actual (IFA): Ensure blower is ON, then press it to re-capturing!")
            //            }//
        }//

        Rectangle {
            width: parent.width
            height: 1
            color: "#e3dac9"
        }//

        Grid{
            spacing: 10
            columns: 6
            /// DOWNFLOW
            Rectangle {
                height: 110
                width: 150
                color: /*"#aaf39c12"*/"#aa0F2952"
                radius: 5
                border.width: 1
                border.color: /*"#f39c12"*/"#e3dac9"

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        text: qsTr("DF Sensor") + "<br>" + qsTr("(VDC)")
                        padding: 2
                        width: 150
                    }//

                    TextFieldApp {
                        id: dfaSensorVoltageTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        //                    enabled: false
                        colorBorder: "#e3dac9"
                        //                text: "10"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("DF Sensor voltage (VDC)"))
                        }//

                        onAccepted: {
                            settings.dfaSensorVdc = text
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
                        id: dfaAdcActualText
                        text: qsTr("DF ADC Actual") + "<br>" + qsTr("(DFA)")
                        padding: 2
                        width: 150
                    }//

                    TextFieldApp {
                        id: dfaAdcActualTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "gray"
                        text: props.dfaAdcActual

                        Component.onCompleted: {
                            text = Qt.binding(function(){return props.dfaAdcActual})
                        }
                    }//
                }//

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        //console.log("onClicked")
                        dfaAdcActualTextField.text = props.dfaAdcActual
                        //settings.adcActual = MachineData.ifaAdcConpensation
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
                        text: qsTr("DF ADC Nom")+"<br>"+qsTr("Field (DFN)")
                        padding: 2
                        width: 150
                    }//

                    TextFieldApp {
                        id: dfaAdcNomTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "gray"
                        //                text: "LA2-4S8 NS"

                        onPressed: {
                            //KeyboardOnScreenCaller.openNumpad(this,  qsTr("DF ADC Nominal - Field (DFN)"))
                        }//

                        onAccepted: {
                            //settings.adcNomField = text
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
                        text: qsTr("DF ADC Zero") + "<br>" + qsTr("Factory (DF0)")
                        padding: 2
                        width: 150
                    }//

                    TextFieldApp {
                        id: dfaAdcZeroFactoryTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "gray"
                        //                text: "120 VAC / 50Hz"

                        onPressed: {
                            //KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC Zero - Factory (IF0)"))
                        }//

                        onAccepted: {
                            //settings.adcZeroFac = text
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
                        text: qsTr("DF ADC Nom") + "<br>" + qsTr("Factory (DF2)")
                        padding: 2
                        width: 150
                    }//

                    TextFieldApp {
                        id: dfaAdcNomFactoryTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "gray"
                        //                text: "2"

                        onPressed: {
                            //KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC Nominal - Factory (IF2)"))
                        }//

                        onAccepted: {
                            //settings.adcNomFac = text
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
                        text: "<br>" + qsTr("DF2 - DF0")
                        padding: 2
                        width: 150
                    }//

                    TextFieldApp {
                        id: dfaAdcRangeTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "gray"
                        //                text: "10"

                        onPressed: {
                            //KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC Range"))
                        }//

                        onAccepted: {
                            //settings.adcRangeFac = text
                        }//
                    }//
                }//
            }//

            ///INFLOW
            Rectangle {
                //            height: children[0].height + 10
                //            width: children[0].width + 10
                height: 110
                width: 150
                color: /*"#aaf39c12"*/"#aa0F2952"
                radius: 5
                border.width: 1
                border.color: /*"#f39c12"*/"#e3dac9"

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        text: qsTr("IF Sensor") + "<br>" + qsTr("(VDC)")
                        padding: 2
                        width: 150
                    }//

                    TextFieldApp {
                        id: ifaSensorVoltageTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        //                    enabled: false
                        colorBorder: "#e3dac9"
                        //                text: "10"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("IF Sensor voltage (VDC)"))
                        }//

                        onAccepted: {
                            settings.ifaSensorVdc = text
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
                        id: ifaAdcActualText
                        text: qsTr("IF ADC Actual") + "<br>" + qsTr("(IFA)")
                        padding: 2
                        width: 150
                    }//

                    TextFieldApp {
                        id: ifaAdcActualTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "gray"
                        text: props.ifaAdcActual

                        Component.onCompleted: {
                            text = Qt.binding(function(){return props.ifaAdcActual})
                        }
                    }//
                }//

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        //console.log("onClicked")
                        ifaAdcActualTextField.text = props.ifaAdcActual
                        //settings.adcActual = MachineData.ifaAdcConpensation
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
                        text: qsTr("IF ADC Nom")+"<br>"+qsTr("Field (IFN)")
                        padding: 2
                        width: 150
                    }//

                    TextFieldApp {
                        id: ifaAdcNomTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "gray"
                        //                text: "LA2-4S8 NS"

                        onPressed: {
                            //KeyboardOnScreenCaller.openNumpad(this,  qsTr("DF ADC Nominal - Field (DFN)"))
                        }//

                        onAccepted: {
                            //settings.adcNomField = text
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
                        text: qsTr("IF ADC Zero") + "<br>" + qsTr("Factory (IF0)")
                        padding: 2
                        width: 150
                    }//

                    TextFieldApp {
                        id: ifaAdcZeroFactoryTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "gray"
                        //                text: "120 VAC / 50Hz"

                        onPressed: {
                            //KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC Zero - Factory (IF0)"))
                        }//

                        onAccepted: {
                            //settings.adcZeroFac = text
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
                        text: qsTr("IF ADC Nom") + "<br>" + qsTr("Factory (IF2)")
                        padding: 2
                        width: 150
                    }//

                    TextFieldApp {
                        id: ifaAdcNomFactoryTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "gray"
                        //                text: "2"

                        onPressed: {
                            //KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC Nominal - Factory (IF2)"))
                        }//

                        onAccepted: {
                            //settings.adcNomFac = text
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
                        text: "<br>" + qsTr("IF2 - IF0")
                        padding: 2
                        width: 150
                    }//

                    TextFieldApp {
                        id: ifaAdcRangeTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "gray"
                        //                text: "10"

                        onPressed: {
                            //KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC Range"))
                        }//

                        onAccepted: {
                            //settings.adcRangeFac = text
                        }//
                    }//
                }//
            }//

            ///GENERAL
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
                        text: qsTr("DF Sensor")+"<br>"+qsTr("Constant")
                        padding: 2
                        width: 150
                    }//

                    TextFieldApp {
                        id: dfaSensorConstantTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "gray"
                        //                text: "10"

                        onPressed: {
                            //KeyboardOnScreenCaller.openNumpad(this, qsTr("Sensor Constant"))
                        }//

                        onAccepted: {
                            //settings.sensorConst = text
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
                        text: qsTr("IF Sensor")+"<br>"+qsTr("Constant")
                        padding: 2
                        width: 150
                    }//

                    TextFieldApp {
                        id: ifaSensorConstantTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "gray"
                        //                text: "10"

                        onPressed: {
                            //KeyboardOnScreenCaller.openNumpad(this, qsTr("Sensor Constant"))
                        }//

                        onAccepted: {
                            //settings.sensorConst = text
                        }//
                    }//
                }//
            }//
            Rectangle {
                //height: children[0].height + 10
                //width: children[0].width + 10
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
                        text: qsTr("Calibration")+"<br>"+qsTr("Temp") + " (" + degreeMeaStr + ")"
                        padding: 2
                        width: 150
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
                        colorBackground: "gray"
                        //                text: "10"

                        onPressed: {
                            //KeyboardOnScreenCaller.openNumpad(this, qsTr("Calibration Temp"))
                        }//

                        onAccepted: {
                            //settings.calibTemp = text
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
                        text: qsTr("Calibration") + "<br>" + qsTr("Temp ADC")
                        padding: 2
                        width: 150
                    }//

                    TextFieldApp {
                        id: calibTempAdcTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "gray"
                        //text: "10"

                        onPressed: {
                            //KeyboardOnScreenCaller.openNumpad(this, qsTr("Calibration Temp ADC"))
                        }//

                        onAccepted: {
                            //settings.calibTempAdc = text
                        }//
                    }//
                }//
            }//
        }//
    }//

    QtObject{
        id: props
        property int dfaAdcActual: 0
        property int ifaAdcActual: 0

        onDfaAdcActualChanged: {
            settings.dfaAdcActual = dfaAdcActual
        }
        onIfaAdcActualChanged: {
            settings.ifaAdcActual = ifaAdcActual
        }
        Component.onCompleted: {
            dfaAdcActual = Qt.binding(function(){return MachineData.dfaAdcConpensation})
            ifaAdcActual = Qt.binding(function(){return MachineData.ifaAdcConpensation})
        }
    }

    /*
      Author: Heri Cahyono
      Change to not editable except sensor VDC
    */

    Settings {
        id: settings
        category: "certification"

        property string dfaSensorVdc: "0"
        property string ifaSensorVdc: "0"
        property int dfaAdcActual: 0
        property int ifaAdcActual: 0

        Component.onCompleted: {
            /// DOWNFLOW
            dfaSensorVoltageTextField.text  = dfaSensorVdc
            dfaAdcActual                    = MachineData.dfaAdcConpensation
            dfaAdcActualTextField.text      = dfaAdcActual
            dfaAdcNomTextField.text         = MachineData.getDownflowAdcPointFactory(2)
            dfaAdcZeroFactoryTextField.text = MachineData.getDownflowAdcPointFactory(0)
            dfaAdcNomFactoryTextField.text  = MachineData.getDownflowAdcPointFactory(2)
            dfaAdcRangeTextField.text       = MachineData.getDownflowAdcPointFactory(2) - MachineData.getDownflowAdcPointFactory(0)
            /// INFLOW
            ifaSensorVoltageTextField.text  = dfaSensorVdc
            ifaAdcActual                    = MachineData.ifaAdcConpensation
            ifaAdcActualTextField.text      = ifaAdcActual
            ifaAdcNomTextField.text         = MachineData.getInflowAdcPointFactory(2)
            ifaAdcZeroFactoryTextField.text = MachineData.getInflowAdcPointFactory(0)
            ifaAdcNomFactoryTextField.text  = MachineData.getInflowAdcPointFactory(2)
            ifaAdcRangeTextField.text       = MachineData.getInflowAdcPointFactory(2) - MachineData.getInflowAdcPointFactory(0)
            /// GENERAL
            dfaSensorConstantTextField.text = MachineData.getDownflowSensorConstant()
            ifaSensorConstantTextField.text = MachineData.getInflowSensorConstant()
            calibTempTextField.text         = MachineData.getInflowTempCalib()
            calibTempAdcTextField.text      = MachineData.getInflowTempCalibAdc()
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:600;width:640}
}
##^##*/
