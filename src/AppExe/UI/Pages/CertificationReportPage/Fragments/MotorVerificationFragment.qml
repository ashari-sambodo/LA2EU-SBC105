import QtQuick 2.0
import QtQuick.Layouts 1.0
import Qt.labs.settings 1.1
import UI.CusCom 1.0
import ModulesCpp.Machine 1.0

Item {
    Column{
        anchors.centerIn: parent
        spacing: 5
        Row {
            spacing: 20

            Column {
                spacing: 5

                TextApp {
                    text: qsTr("Initial")
                }//

                Rectangle {
                    height: 2
                    width: 120
                    color: "#e3dac9"
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Fan duty cycle") + " (%)" + " / " + "RPM"
                    }//

                    Row {
                        spacing: 5

                        TextFieldApp {
                            id: initialDutyCycleTextField
                            width: 50
                            height: 40
                            //                        text: "48"
                            //colorBorder: "#f39c12"
                            //enabled: false
                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan duty cycle"))
                            }//

                            onAccepted: {
                                const val = Number(text)
                                settings.mvInitialFanDucy = val
                            }//
                        }//

                        TextFieldApp {
                            id: initialRpmTextField
                            width: 145
                            height: 40
                            //                        text: "700"

                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan RPM"))
                            }//

                            onAccepted: {
                                const val = Number(text)
                                settings.mvInitialFanRpm = val
                            }//
                        }//
                    }//
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Donwflow velocity") + " " + unitStr

                        property string unitStr: "(m/s)"

                        Component.onCompleted: {
                            unitStr = MachineData.measurementUnit ? "(fpm)" : "(m/s)"
                        }//
                    }//

                    TextFieldApp {
                        id: initialDfaTextField
                        width: 200
                        height: 40
                        //                    text: "0.33"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Donwflow velocity"))
                        }//

                        onAccepted: {
                            let value = 0.0
                            let valueImp = 0.0
                            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                                valueImp = Number(text)
                                value = utils.getMpsFromFpm(valueImp)
                            }else{
                                value = Number(text)
                                valueImp = utils.getFpmFromMps(value)
                            }

                            settings.mvInitialDfa = value.toFixed(2)
                            settings.mvInitialDfaImp = valueImp.toFixed()

                            //                        settings.mvInitialDfa = text
                        }//
                    }//
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Inflow velocity") + " " + unitStr

                        property string unitStr: "(m/s)"

                        Component.onCompleted: {
                            unitStr = MachineData.measurementUnit ? "(fpm)" : "(m/s)"
                        }//
                    }//

                    TextFieldApp {
                        id: initialIfaTextField
                        width: 200
                        height: 40
                        //                    text: "0.53"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow velocity"))
                        }//

                        onAccepted: {
                            let value = 0.0
                            let valueImp = 0.0
                            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                                valueImp = Number(text)
                                value = utils.getMpsFromFpm(valueImp)
                            }else{
                                value = Number(text)
                                valueImp = utils.getFpmFromMps(value)
                            }

                            settings.mvInitialIfa = value.toFixed(2)
                            settings.mvInitialIfaImp = valueImp.toFixed()

                            //                        settings.mvInitialIfa = text
                        }//
                    }//
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Power consumption") + " " + unitStr

                        property string unitStr: "(Watt)"
                    }//

                    TextFieldApp {
                        id: initialPowerTextField
                        width: 200
                        height: 40
                        text: "0"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Power consumption"))
                        }//

                        onAccepted: {
                            const val = Number(text)

                            settings.mvInitialPower = val
                        }
                    }//
                }//

                ButtonBarApp {
                    text: qsTr("Capture")

                    onClicked: {
                        initialDutyCycleTextField.text = MachineData.fanPrimaryDutyCycle
                        initialRpmTextField.text = MachineData.fanPrimaryRpm

                        initialDfaTextField.text = MachineData.dfaVelocityStr.split(" ")[0] || "0"
                        initialIfaTextField.text = MachineData.ifaVelocityStr.split(" ")[0] || "0"

                        settings.mvInitialFanDucy = initialDutyCycleTextField.text
                        settings.mvInitialFanRpm = initialRpmTextField.text

                        if(MachineData.measurementUnit){
                            settings.mvInitialDfaImp = initialDfaTextField.text
                            settings.mvInitialIfaImp = initialIfaTextField.text
                        }else{
                            settings.mvInitialDfa = initialDfaTextField.text
                            settings.mvInitialIfa = initialIfaTextField.text
                        }
                    }//
                }//
            }//

            Column {
                spacing: 5

                TextApp {
                    text: qsTr("Grill blocked")
                }//

                Rectangle {
                    height: 2
                    width: 120
                    color: "#e3dac9"
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Fan duty cycle") + " (%)" + " / " + "RPM"
                    }//

                    Row {
                        spacing: 5

                        TextFieldApp {
                            id: blockedDutyCycleTextField
                            width: 50
                            height: 40
                            //                        text: "48"
                            colorBorder: "#f39c12"
                            enabled: false
                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan duty cycle"))
                            }//

                            onAccepted: {
                                const val = Number(text)
                                settings.mvBlockFanDucy = val
                            }//
                        }//

                        TextFieldApp {
                            id: blockedRpmTextField
                            width: 145
                            height: 40
                            //                        text: "735"

                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan RPM"))
                            }//

                            onAccepted: {
                                const val = Number(text)
                                settings.mvBlockFanRpm = val
                            }//
                        }//
                    }//
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Donwflow velocity") + " " + unitStr

                        property string unitStr: "(m/s)"

                        Component.onCompleted: {
                            unitStr = MachineData.measurementUnit ? "(fpm)" : "(m/s)"
                        }//
                    }//

                    TextFieldApp {
                        id: blockedDfaTextField
                        width: 200
                        height: 40
                        //                    text: "0.32"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Donwflow velocity"))
                        }//

                        onAccepted: {
                            let value = 0.0
                            let valueImp = 0.0
                            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                                valueImp = Number(text)
                                value = utils.getMpsFromFpm(valueImp)
                            }else{
                                value = Number(text)
                                valueImp = utils.getFpmFromMps(value)
                            }

                            settings.mvBlockDfa = value.toFixed(2)
                            settings.mvBlockDfaImp = valueImp.toFixed()

                            //                        settings.mvBlockDfa = text
                        }//
                    }//
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Inflow velocity") + " " + unitStr

                        property string unitStr: "(m/s)"

                        Component.onCompleted: {
                            unitStr = MachineData.measurementUnit ? "(fpm)" : "(m/s)"
                        }//
                    }//

                    TextFieldApp {
                        id: blockedIfaTextField
                        width: 200
                        height: 40
                        //                    text: "0.52"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow velocity"))
                        }//

                        onAccepted: {
                            let value = 0.0
                            let valueImp = 0.0
                            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                                valueImp = Number(text)
                                value = utils.getMpsFromFpm(valueImp)
                            }else{
                                value = Number(text)
                                valueImp = utils.getFpmFromMps(value)
                            }

                            settings.mvBlockIfa = value.toFixed(2)
                            settings.mvBlockIfaImp = valueImp.toFixed()

                            //                        settings.mvBlockIfa = text
                        }//
                    }//
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Power consumption") + " " + unitStr

                        property string unitStr: "(Watt)"
                    }//

                    TextFieldApp {
                        id: blockedPowerTextField
                        width: 200
                        height: 40
                        text: "0"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Power consumption"))
                        }//

                        onAccepted: {
                            settings.mvBlockPower = text
                        }//
                    }//
                }//

                //                            Rectangle {
                //                                height: 2
                //                                width: 120
                //                                color: "#e3dac9"
                //                            }//

                ButtonBarApp {
                    text: qsTr("Capture")

                    onClicked: {
                        blockedDutyCycleTextField.text = settings.mvInitialFanDucy/*MachineData.fanPrimaryDutyCycle*/
                        blockedRpmTextField.text = MachineData.fanPrimaryRpm

                        blockedDfaTextField.text = MachineData.dfaVelocityStr.split(" ")[0] || "0"
                        blockedIfaTextField.text = MachineData.ifaVelocityStr.split(" ")[0] || "0"

                        settings.mvBlockFanDucy = blockedDutyCycleTextField.text
                        settings.mvBlockFanRpm = blockedRpmTextField.text

                        if(MachineData.measurementUnit){
                            settings.mvBlockDfaImp = blockedDfaTextField.text
                            settings.mvBlockIfaImp = blockedIfaTextField.text
                        }else{
                            settings.mvBlockDfa = blockedDfaTextField.text
                            settings.mvBlockIfa = blockedIfaTextField.text
                        }
                    }//
                }//
            }//

            Column {
                spacing: 5

                TextApp {
                    text: qsTr("Final")
                }//

                Rectangle {
                    height: 2
                    width: 120
                    color: "#e3dac9"
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Fan duty cycle") + " (%)" + " / " + "RPM"
                    }//

                    Row {
                        spacing: 5

                        TextFieldApp {
                            id: finalDutyCycleTextField
                            width: 50
                            height: 40
                            //                        text: "48"
                            colorBorder: "#f39c12"
                            enabled: false
                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan duty cycle"))
                            }//

                            onAccepted: {
                                const val = Number(text)
                                settings.mvFinalFanDucy = val
                            }//
                        }//

                        TextFieldApp {
                            id: finalRpmTextField
                            width: 145
                            height: 40
                            //                        text: "735"

                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan RPM"))
                            }//

                            onAccepted: {
                                const val = Number(text)
                                settings.mvFinalFanRpm = val
                            }//
                        }//
                    }//
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Donwflow velocity") + " " + unitStr

                        property string unitStr: "(m/s)"

                        Component.onCompleted: {
                            unitStr = MachineData.measurementUnit ? "(fpm)" : "(m/s)"
                        }//
                    }//

                    TextFieldApp {
                        id: finalDfaTextField
                        width: 200
                        height: 40
                        //                    text: "0.33"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Donwflow velocity"))
                        }//

                        onAccepted: {
                            let value = 0.0
                            let valueImp = 0.0
                            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                                valueImp = Number(text)
                                value = utils.getMpsFromFpm(valueImp)
                            }else{
                                value = Number(text)
                                valueImp = utils.getFpmFromMps(value)
                            }

                            settings.mvFinalDfa = value.toFixed(2)
                            settings.mvFinalDfaImp = valueImp.toFixed()

                            //                        settings.mvFinalDfa = text
                        }//
                    }//
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Inflow velocity") + " " + unitStr

                        property string unitStr: "(m/s)"

                        Component.onCompleted: {
                            unitStr = MachineData.measurementUnit ? "(fpm)" : "(m/s)"
                        }//
                    }//

                    TextFieldApp {
                        id: finalIfaTextField
                        width: 200
                        height: 40
                        //                    text: "0.53"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow velocity"))
                        }//

                        onAccepted: {
                            let value = 0.0
                            let valueImp = 0.0
                            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                                valueImp = Number(text)
                                value = utils.getMpsFromFpm(valueImp)
                            }else{
                                value = Number(text)
                                valueImp = utils.getFpmFromMps(value)
                            }

                            settings.mvFinalIfa = value.toFixed(2)
                            settings.mvFinalIfaImp = valueImp.toFixed()
                            //                        settings.mvFinalIfa = text
                        }//
                    }//
                }//

                ButtonBarApp {
                    text: qsTr("Capture")

                    onClicked: {
                        finalDutyCycleTextField.text = settings.mvInitialFanDucy/*MachineData.fanPrimaryDutyCycle*/
                        finalRpmTextField.text = MachineData.fanPrimaryRpm

                        finalDfaTextField.text = MachineData.dfaVelocityStr.split(" ")[0] || "0"
                        finalIfaTextField.text = MachineData.ifaVelocityStr.split(" ")[0] || "0"

                        settings.mvFinalFanDucy = finalDutyCycleTextField.text
                        settings.mvFinalFanRpm = finalRpmTextField.text

                        if(MachineData.measurementUnit){
                            settings.mvFinalDfaImp = finalDfaTextField.text
                            settings.mvFinalIfaImp = finalIfaTextField.text
                        }else{
                            settings.mvFinalDfa = finalDfaTextField.text
                            settings.mvFinalIfa = finalIfaTextField.text
                        }

                    }//
                }//
            }//
        }//
        Column{
            Rectangle {
                height: 1
                width: textId.width
                color: "#e3dac9"
            }//

            TextApp {
                id: textId
                text: "<u>"+ qsTr("Grill blocked")+"</u> "
                      + qsTr("and")
                      + " <u>" + qsTr("Final") + "</u> "
                      + qsTr("duty cycle")+ ", "+ qsTr("will be based on")
                      + " <u>"+ qsTr("Initial")+"</u> "
                      + qsTr("value")+ ". " + qsTr("They are not editable.")
                font.pixelSize: 16
            }//
        }
    }

    Settings {
        id: settings
        category: "certification"

        property int    mvInitialFanDucy: 0
        property int    mvInitialFanRpm:  0
        property string mvInitialDfa:     "0"
        property string mvInitialIfa:     "0"
        property string mvInitialDfaImp:  "0"
        property string mvInitialIfaImp:  "0"
        property string mvInitialPower:   "0"

        property int    mvBlockFanDucy:   0
        property int    mvBlockFanRpm:    0
        property string mvBlockDfa:       "0"
        property string mvBlockIfa:       "0"
        property string mvBlockDfaImp:    "0"
        property string mvBlockIfaImp:    "0"
        property string mvBlockPower:     "0"

        property int    mvFinalFanDucy:   0
        property int    mvFinalFanRpm:    0
        property string mvFinalDfa:       "0"
        property string mvFinalIfa:       "0"
        property string mvFinalDfaImp:    "0"
        property string mvFinalIfaImp:    "0"

        Component.onCompleted: {
            initialDutyCycleTextField.text = mvInitialFanDucy
            initialRpmTextField.text = mvInitialFanRpm
            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                initialDfaTextField.text = mvInitialDfaImp
                initialIfaTextField.text = mvInitialIfaImp
            }else{
                initialDfaTextField.text = mvInitialDfa
                initialIfaTextField.text = mvInitialIfa
            }
            initialPowerTextField.text = mvInitialPower

            blockedDutyCycleTextField.text = mvBlockFanDucy
            blockedRpmTextField.text = mvBlockFanRpm
            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                blockedDfaTextField.text = mvBlockDfaImp
                blockedIfaTextField.text = mvBlockIfaImp
            }else{
                blockedDfaTextField.text = mvBlockDfa
                blockedIfaTextField.text = mvBlockIfa
            }
            blockedPowerTextField.text = mvBlockPower

            finalDutyCycleTextField.text = mvFinalFanDucy
            finalRpmTextField.text = mvFinalFanRpm
            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                finalDfaTextField.text = mvFinalDfaImp
                finalIfaTextField.text = mvFinalIfaImp
            }else{
                finalDfaTextField.text = mvFinalDfa
                finalIfaTextField.text = mvFinalIfa
            }
        }//
    }//

    UtilsApp{
        id: utils
    }
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/
