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

                //                Column {
                Row{
                    spacing: 10
                    Column{
                        spacing: 5
                        TextApp {
                            text: qsTr("DF Dcy") + "(%)" + "/" + "RPM"
                        }//

                        Row {
                            spacing: 5

                            TextFieldApp {
                                id: dfaInitialDutyCycleTextField
                                width: 50
                                height: 40
                                //                        text: "48"
                                //colorBorder: "#f39c12"
                                //enabled: false
                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("DF Fan duty cycle"))
                                }//

                                onAccepted: {
                                    const val = Number(text)
                                    settings.mvInitialFanDucyDfa = val
                                }//
                            }//

                            TextFieldApp {
                                id: dfaInitialRpmTextField
                                width: 70
                                height: 40
                                //                        text: "700"

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("DF Fan RPM"))
                                }//

                                onAccepted: {
                                    const val = Number(text)
                                    settings.mvInitialFanRpmDfa = val
                                }//
                            }//
                        }//
                    }//
                    Column{
                        spacing: 5
                        TextApp {
                            text: qsTr("IF Dcy") + "(%)" + "/" + "RPM"
                        }//

                        Row {
                            spacing: 5

                            TextFieldApp {
                                id: ifaInitialDutyCycleTextField
                                width: 50
                                height: 40
                                //                        text: "48"
                                //colorBorder: "#f39c12"
                                //enabled: false
                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("IF Fan duty cycle"))
                                }//

                                onAccepted: {
                                    const val = Number(text)
                                    settings.mvInitialFanDucyIfa = val
                                }//
                            }//

                            TextFieldApp {
                                id: ifaInitialRpmTextField
                                width: 70
                                height: 40
                                //                        text: "700"

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("IF Fan RPM"))
                                }//

                                onAccepted: {
                                    const val = Number(text)
                                    settings.mvInitialFanRpmIfa = val
                                }//
                            }//
                        }//
                    }//
                }//
                //                }//

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
                        dfaInitialDutyCycleTextField.text = MachineData.fanPrimaryDutyCycle
                        dfaInitialRpmTextField.text = MachineData.fanPrimaryRpm
                        ifaInitialDutyCycleTextField.text = MachineData.fanInflowDutyCycle
                        ifaInitialRpmTextField.text = MachineData.fanInflowRpm

                        initialDfaTextField.text = MachineData.dfaVelocityStr.split(" ")[0] || "0"
                        initialIfaTextField.text = MachineData.ifaVelocityStr.split(" ")[0] || "0"

                        settings.mvInitialFanDucyDfa = dfaInitialDutyCycleTextField.text
                        settings.mvInitialFanRpmDfa = dfaInitialRpmTextField.text
                        settings.mvInitialFanDucyIfa = ifaInitialDutyCycleTextField.text
                        settings.mvInitialFanRpmIfa = ifaInitialRpmTextField.text

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

                //                Column {
                Row{
                    spacing: 10
                    Column{
                        spacing: 5
                        TextApp {
                            text: qsTr("DF Dcy") + "(%)" + "/" + "RPM"
                        }//

                        Row {
                            spacing: 5

                            TextFieldApp {
                                id: dfaBlockedDutyCycleTextField
                                width: 50
                                height: 40
                                //                        text: "48"
                                colorBackground: "gray"
                                enabled: false
                                onPressed: {
                                    //KeyboardOnScreenCaller.openNumpad(this, qsTr("DF Fan duty cycle"))
                                }//

                                onAccepted: {
                                    //const val = Number(text)
                                    //settings.mvBlockFanDucyDfa = val
                                }//
                            }//

                            TextFieldApp {
                                id: dfaBlockedRpmTextField
                                width: 70
                                height: 40
                                //                        text: "700"

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("DF Fan RPM"))
                                }//

                                onAccepted: {
                                    const val = Number(text)
                                    settings.mvBlockFanRpmDfa = val
                                }//
                            }//
                        }//
                    }//
                    Column{
                        spacing: 5
                        TextApp {
                            text: qsTr("IF Dcy") + "(%)" + "/" + "RPM"
                        }//

                        Row {
                            spacing: 5

                            TextFieldApp {
                                id: ifaBlockedDutyCycleTextField
                                width: 50
                                height: 40
                                //                        text: "48"
                                colorBackground: "gray"
                                enabled: false
                                onPressed: {
                                    ///KeyboardOnScreenCaller.openNumpad(this, qsTr("IF Fan duty cycle"))
                                }//

                                onAccepted: {
                                    ///const val = Number(text)
                                    //settings.mvBlockFanDucyIfa = val
                                }//
                            }//

                            TextFieldApp {
                                id: ifaBlockedRpmTextField
                                width: 70
                                height: 40
                                //                        text: "700"

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("IF Fan RPM"))
                                }//

                                onAccepted: {
                                    const val = Number(text)
                                    settings.mvBlockFanRpmIfa = val
                                }//
                            }//
                        }//
                    }//
                }//
                //                }//

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
                        dfaBlockedDutyCycleTextField.text = settings.mvInitialFanDucyDfa/*MachineData.fanPrimaryDutyCycle*/
                        dfaBlockedRpmTextField.text = MachineData.fanPrimaryRpm
                        ifaBlockedDutyCycleTextField.text = settings.mvInitialFanDucyIfa/*MachineData.fanPrimaryDutyCycle*/
                        ifaBlockedRpmTextField.text = MachineData.fanInflowRpm

                        blockedDfaTextField.text = MachineData.dfaVelocityStr.split(" ")[0] || "0"
                        blockedIfaTextField.text = MachineData.ifaVelocityStr.split(" ")[0] || "0"

                        settings.mvBlockFanDucyDfa = dfaBlockedDutyCycleTextField.text
                        settings.mvBlockFanRpmDfa = dfaBlockedRpmTextField.text
                        settings.mvBlockFanDucyIfa = ifaBlockedDutyCycleTextField.text
                        settings.mvBlockFanRpmIfa = ifaBlockedRpmTextField.text

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

                //                Column {
                Row{
                    spacing: 10
                    Column{
                        spacing: 5
                        TextApp {
                            text: qsTr("DF Dcy") + "(%)" + "/" + "RPM"
                        }//

                        Row {
                            spacing: 5

                            TextFieldApp {
                                id: dfaFinalDutyCycleTextField
                                width: 50
                                height: 40
                                //                        text: "48"
                                colorBackground: "gray"
                                enabled: false
                                onPressed: {
                                    //KeyboardOnScreenCaller.openNumpad(this, qsTr("DF Fan duty cycle"))
                                }//

                                onAccepted: {
                                   // const val = Number(text)
                                    //settings.mvFinalFanDucyDfa = val
                                }//
                            }//

                            TextFieldApp {
                                id: dfaFinalRpmTextField
                                width: 70
                                height: 40
                                //                        text: "700"

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("DF Fan RPM"))
                                }//

                                onAccepted: {
                                    const val = Number(text)
                                    settings.mvFinalFanRpmDfa = val
                                }//
                            }//
                        }//
                    }//
                    Column{
                        spacing: 5
                        TextApp {
                            text: qsTr("IF Dcy") + "(%)" + "/" + "RPM"
                        }//

                        Row {
                            spacing: 5

                            TextFieldApp {
                                id: ifaFinalDutyCycleTextField
                                width: 50
                                height: 40
                                //                        text: "48"
                                colorBackground: "gray"
                                enabled: false
                                onPressed: {
                                    //KeyboardOnScreenCaller.openNumpad(this, qsTr("IF Fan duty cycle"))
                                }//

                                onAccepted: {
                                    //const val = Number(text)
                                    //settings.mvFinalFanDucyIfa = val
                                }//
                            }//

                            TextFieldApp {
                                id: ifaFinalRpmTextField
                                width: 70
                                height: 40
                                //                        text: "700"

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("IF Fan RPM"))
                                }//

                                onAccepted: {
                                    const val = Number(text)
                                    settings.mvFinalFanRpmIfa = val
                                }//
                            }//
                        }//
                    }//
                }//
                //                }//

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
                        dfaFinalDutyCycleTextField.text = settings.mvInitialFanDucyDfa/*MachineData.fanPrimaryDutyCycle*/
                        dfaFinalRpmTextField.text = MachineData.fanPrimaryRpm
                        ifaFinalDutyCycleTextField.text = settings.mvInitialFanDucyIfa/*MachineData.fanPrimaryDutyCycle*/
                        ifaFinalRpmTextField.text = MachineData.fanInflowRpm

                        finalDfaTextField.text = MachineData.dfaVelocityStr.split(" ")[0] || "0"
                        finalIfaTextField.text = MachineData.ifaVelocityStr.split(" ")[0] || "0"

                        settings.mvFinalFanDucyDfa = dfaFinalDutyCycleTextField.text
                        settings.mvFinalFanRpmDfa = dfaFinalRpmTextField.text
                        settings.mvFinalFanDucyIfa = ifaFinalDutyCycleTextField.text
                        settings.mvFinalFanRpmIfa = ifaFinalRpmTextField.text

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

        property int    mvInitialFanDucyDfa: 0
        property int    mvInitialFanRpmDfa:  0
        property int    mvInitialFanDucyIfa: 0
        property int    mvInitialFanRpmIfa:  0
        property string mvInitialDfa:     "0"
        property string mvInitialIfa:     "0"
        property string mvInitialDfaImp:  "0"
        property string mvInitialIfaImp:  "0"
        property string mvInitialPower:   "0"

        property int    mvBlockFanDucyDfa:   0
        property int    mvBlockFanRpmDfa:    0
        property int    mvBlockFanDucyIfa:   0
        property int    mvBlockFanRpmIfa:    0
        property string mvBlockDfa:       "0"
        property string mvBlockIfa:       "0"
        property string mvBlockDfaImp:    "0"
        property string mvBlockIfaImp:    "0"
        property string mvBlockPower:     "0"

        property int    mvFinalFanDucyDfa:   0
        property int    mvFinalFanRpmDfa:    0
        property int    mvFinalFanDucyIfa:   0
        property int    mvFinalFanRpmIfa:    0
        property string mvFinalDfa:       "0"
        property string mvFinalIfa:       "0"
        property string mvFinalDfaImp:    "0"
        property string mvFinalIfaImp:    "0"

        Component.onCompleted: {
            dfaInitialDutyCycleTextField.text = mvInitialFanDucyDfa
            dfaInitialRpmTextField.text = mvInitialFanRpmDfa
            ifaInitialDutyCycleTextField.text = mvInitialFanDucyIfa
            ifaInitialRpmTextField.text = mvInitialFanRpmIfa

            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                initialDfaTextField.text = mvInitialDfaImp
                initialIfaTextField.text = mvInitialIfaImp
            }else{
                initialDfaTextField.text = mvInitialDfa
                initialIfaTextField.text = mvInitialIfa
            }
            initialPowerTextField.text = mvInitialPower

            dfaBlockedDutyCycleTextField.text = mvBlockFanDucyDfa
            dfaBlockedRpmTextField.text = mvBlockFanRpmDfa
            ifaBlockedDutyCycleTextField.text = mvBlockFanDucyIfa
            ifaBlockedRpmTextField.text = mvBlockFanRpmIfa
            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                blockedDfaTextField.text = mvBlockDfaImp
                blockedIfaTextField.text = mvBlockIfaImp
            }else{
                blockedDfaTextField.text = mvBlockDfa
                blockedIfaTextField.text = mvBlockIfa
            }
            blockedPowerTextField.text = mvBlockPower

            dfaFinalDutyCycleTextField.text = mvFinalFanDucyDfa
            dfaFinalRpmTextField.text = mvFinalFanRpmDfa
            ifaFinalDutyCycleTextField.text = mvFinalFanDucyIfa
            ifaFinalRpmTextField.text = mvFinalFanRpmIfa
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
