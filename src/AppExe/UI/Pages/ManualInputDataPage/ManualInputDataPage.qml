/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Manual Input Calibration Point"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp{
        id: contentView
        height: viewApp.height
        width: viewApp.width

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
                    title: qsTr("Manual Input Calibration Point")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                ColumnLayout{
                    anchors.fill: parent
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        RowLayout{
                            anchors.fill: parent
                            Item{
                                id: downflowInput
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Column{
                                    spacing: 20
                                    //anchors.centerIn: parent
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    Rectangle{
                                        color: "transparent"
                                        border.width: 0
                                        height: 60
                                        width: 200
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        TextApp {
                                            text: qsTr("Downflow")
                                            height: parent.height
                                            width: parent.width
                                            font.underline: true
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignBottom
                                        }//
                                    }
                                    Row{
                                        id: downflowRow
                                        spacing: 5
                                        Column{
                                            spacing: 5
                                            Column {
                                                spacing: 5

                                                TextApp {
                                                    text: qsTr("Fan Stby")
                                                }//

                                                TextFieldApp {
                                                    id: dfaFanStandbyTextField
                                                    width: 110
                                                    height: 40

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Downflow Fan Standby (%)"))
                                                    }//

                                                    TextApp {
                                                        anchors.right: parent.right
                                                        anchors.rightMargin: 5
                                                        verticalAlignment: Text.AlignVCenter
                                                        height: parent.height
                                                        text: "%"
                                                        color: "gray"
                                                    }//
                                                }//
                                            }//
                                            Column {
                                                spacing: 5

                                                TextApp {
                                                    text: qsTr("Fan Min")
                                                }//

                                                TextFieldApp {
                                                    id: dfaFanMinTextField
                                                    width: 110
                                                    height: 40

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Downflow Fan Minimum (%)"))
                                                    }//

                                                    TextApp {
                                                        anchors.right: parent.right
                                                        anchors.rightMargin: 5
                                                        verticalAlignment: Text.AlignVCenter
                                                        height: parent.height
                                                        text: "%"
                                                        color: "gray"
                                                    }//
                                                }//
                                            }//
                                            Column {
                                                spacing: 5

                                                TextApp {
                                                    text: qsTr("Fan Nom")
                                                }//

                                                TextFieldApp {
                                                    id: dfaFanNominalTextField
                                                    width: 110
                                                    height: 40

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Downflow Fan Nominal (%)"))
                                                    }//

                                                    TextApp {
                                                        anchors.right: parent.right
                                                        anchors.rightMargin: 5
                                                        verticalAlignment: Text.AlignVCenter
                                                        height: parent.height
                                                        text: "%"
                                                        color: "gray"
                                                    }//
                                                }//
                                            }//
                                            Column {
                                                spacing: 5

                                                TextApp {
                                                    text: qsTr("Fan Max")
                                                }//

                                                TextFieldApp {
                                                    id: dfaFanMaxTextField
                                                    width: 110
                                                    height: 40

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Downflow Fan Maximum (%)"))
                                                    }//

                                                    TextApp {
                                                        anchors.right: parent.right
                                                        anchors.rightMargin: 5
                                                        verticalAlignment: Text.AlignVCenter
                                                        height: parent.height
                                                        text: "%"
                                                        color: "gray"
                                                    }//
                                                }//
                                            }//
                                        }//
                                        //////////////
                                        Column {
                                            spacing: 5

                                            Column {
                                                spacing: 5

                                                TextApp {
                                                    text: qsTr("Alarm Low")
                                                }//

                                                TextFieldApp {
                                                    id: dfaVelLowAlarmTextField
                                                    width: 110
                                                    height: 40

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Downflow Low Alarm") + " (%1)".arg(props.meaUnitStr))
                                                    }//

                                                    TextApp {
                                                        anchors.right: parent.right
                                                        anchors.rightMargin: 5
                                                        verticalAlignment: Text.AlignVCenter
                                                        height: parent.height
                                                        text: props.meaUnitStr
                                                        color: "gray"
                                                    }//
                                                }//
                                            }//
                                            Column {
                                                spacing: 5

                                                TextApp {
                                                    text: qsTr("Nominal")
                                                }//

                                                TextFieldApp {
                                                    id: dfaVelNomTextField
                                                    width: 110
                                                    height: 40

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Downflow Nominal") + " (%1)".arg(props.meaUnitStr))
                                                    }//

                                                    TextApp {
                                                        anchors.right: parent.right
                                                        anchors.rightMargin: 5
                                                        verticalAlignment: Text.AlignVCenter
                                                        height: parent.height
                                                        text: props.meaUnitStr
                                                        color: "gray"
                                                    }//
                                                }//
                                            }//

                                            Column {
                                                spacing: 5

                                                TextApp {
                                                    text: qsTr("Alarm High")
                                                }//

                                                TextFieldApp {
                                                    id: dfaVelHighAlarmTextField
                                                    width: 110
                                                    height: 40

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Downflow High Alarm") + " (%1)".arg(props.meaUnitStr))
                                                    }//

                                                    TextApp {
                                                        anchors.right: parent.right
                                                        anchors.rightMargin: 5
                                                        verticalAlignment: Text.AlignVCenter
                                                        height: parent.height
                                                        text: props.meaUnitStr
                                                        color: "gray"
                                                    }//
                                                }//
                                            }//
                                        }//
                                        ///////////////
                                        Column {
                                            spacing: 5

                                            Column{
                                                spacing: 5
                                                TextApp {
                                                    text: qsTr("Constant")
                                                }//

                                                TextFieldApp {
                                                    id: dfaSensorConstantTextField
                                                    width: 110
                                                    height: 40
                                                    validator: IntValidator{bottom: 0; top: 99;}

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Constant Downflow Sensor"))
                                                    }//
                                                }//
                                            }
                                            Column {
                                                spacing: 5

                                                TextApp {
                                                    text: qsTr("ADC DF0")
                                                }//

                                                TextFieldApp {
                                                    id: dfaAdcZeroTextField
                                                    width: 110
                                                    height: 40

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC DF0"))
                                                    }//
                                                }//
                                            }//
                                            Column {
                                                spacing: 5

                                                TextApp {
                                                    text: qsTr("ADC DF2")
                                                }//

                                                TextFieldApp {
                                                    id: dfaAdcNomTextField
                                                    width: 110
                                                    height: 40

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC DF2"))
                                                    }//
                                                }//
                                            }//
                                        }//
                                    }//
                                }//
                            }//
                            Item{
                                id: inflowInput
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Column{
                                    spacing: 20
                                    //anchors.centerIn: parent
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    Rectangle{
                                        color: "transparent"
                                        border.width: 0
                                        height: 60
                                        width: 200
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        TextApp {
                                            text: qsTr("Inflow")
                                            height: parent.height
                                            width: parent.width
                                            font.underline: true
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignBottom
                                        }//
                                    }
                                    Row{
                                        id: inflowRow
                                        spacing: 5
                                        Column{
                                            spacing: 5
                                            Column {
                                                spacing: 5

                                                TextApp {
                                                    text: qsTr("Fan Stby")
                                                }//

                                                TextFieldApp {
                                                    id: ifaFanStandbyTextField
                                                    width: 110
                                                    height: 40

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow Fan Standby (%)"))
                                                    }//

                                                    TextApp {
                                                        anchors.right: parent.right
                                                        anchors.rightMargin: 5
                                                        verticalAlignment: Text.AlignVCenter
                                                        height: parent.height
                                                        text: "%"
                                                        color: "gray"
                                                    }//
                                                }//
                                            }//
                                            Column {
                                                spacing: 5

                                                TextApp {
                                                    text: qsTr("Fan Min")
                                                }//

                                                TextFieldApp {
                                                    id: ifaFanMinTextField
                                                    width: 110
                                                    height: 40

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow Fan Minimum (%)"))
                                                    }//

                                                    TextApp {
                                                        anchors.right: parent.right
                                                        anchors.rightMargin: 5
                                                        verticalAlignment: Text.AlignVCenter
                                                        height: parent.height
                                                        text: "%"
                                                        color: "gray"
                                                    }//
                                                }//
                                            }//
                                            Column {
                                                spacing: 5

                                                TextApp {
                                                    text: qsTr("Fan Nom")
                                                }//

                                                TextFieldApp {
                                                    id: ifaFanNominalTextField
                                                    width: 110
                                                    height: 40

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow Fan Nominal (%)"))
                                                    }//

                                                    TextApp {
                                                        anchors.right: parent.right
                                                        anchors.rightMargin: 5
                                                        verticalAlignment: Text.AlignVCenter
                                                        height: parent.height
                                                        text: "%"
                                                        color: "gray"
                                                    }//
                                                }//
                                            }//
                                        }//
                                        ////////////////
                                        Column {
                                            spacing: 5

                                            Column {
                                                spacing: 5

                                                TextApp {
                                                    text: qsTr("Alarm Low")
                                                }//

                                                TextFieldApp {
                                                    id: ifaVelLowAlarmTextField
                                                    width: 110
                                                    height: 40

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow Low Alarm") + " (%1)".arg(props.meaUnitStr))
                                                    }//

                                                    TextApp {
                                                        anchors.right: parent.right
                                                        anchors.rightMargin: 5
                                                        verticalAlignment: Text.AlignVCenter
                                                        height: parent.height
                                                        text: props.meaUnitStr
                                                        color: "gray"
                                                    }//
                                                }//
                                            }//

                                            Column {
                                                spacing: 5

                                                TextApp {
                                                    text: qsTr("Nominal")
                                                }//

                                                TextFieldApp {
                                                    id: ifaVelNomTextField
                                                    width: 110
                                                    height: 40

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow Nominal") + " (%1)".arg(props.meaUnitStr))
                                                    }//

                                                    TextApp {
                                                        anchors.right: parent.right
                                                        anchors.rightMargin: 5
                                                        verticalAlignment: Text.AlignVCenter
                                                        height: parent.height
                                                        text: props.meaUnitStr
                                                        color: "gray"
                                                    }//
                                                }//
                                            }//
                                        }//
                                        //////////////////
                                        Column {
                                            spacing: 5
                                            Column{
                                                spacing: 5
                                                TextApp {
                                                    text: qsTr("Constant")
                                                }//

                                                TextFieldApp {
                                                    id: ifaSensorConstantTextField
                                                    width: 110
                                                    height: 40
                                                    validator: IntValidator{bottom: 0; top: 99;}

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Constant Inflow Sensor"))
                                                    }//
                                                }//
                                            }//
                                            Column {
                                                spacing: 5

                                                TextApp {
                                                    text: qsTr("ADC IF0")
                                                }//

                                                TextFieldApp {
                                                    id: ifaAdcZeroTextField
                                                    width: 110
                                                    height: 40

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC IF0"))
                                                    }//
                                                }//
                                            }//

                                            Column {
                                                spacing: 5

                                                TextApp {
                                                    text: qsTr("ADC IF2")
                                                }//

                                                TextFieldApp {
                                                    id: ifaAdcNomTextField
                                                    width: 110
                                                    height: 40

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC IF2"))
                                                    }//
                                                }//
                                            }//
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//
                    Item{
                        Layout.fillWidth: true
                        Layout.minimumHeight: 100

                        Row {
                            id: temperatureRow
                            spacing: 5
                            anchors.centerIn: parent
                            Column {
                                spacing: 5

                                TextApp {
                                    text: qsTr("Calib Temp")
                                }//

                                TextFieldApp {
                                    id: calibTempTextField
                                    width: 110
                                    height: 40

                                    onPressed: {
                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Calib Temperature") + " (%1)".arg(props.tempUnitStr))
                                    }//

                                    TextApp {
                                        anchors.right: parent.right
                                        anchors.rightMargin: 5
                                        verticalAlignment: Text.AlignVCenter
                                        height: parent.height
                                        text: props.tempUnitStr
                                        color: "gray"
                                    }//
                                }//
                            }//
                            Column {
                                spacing: 5

                                TextApp {
                                    text: qsTr("ADC Temp")
                                }//

                                TextFieldApp {
                                    id: calibTempAdcTextField
                                    width: 110
                                    height: 40

                                    onPressed: {
                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC Temperature"))
                                    }//
                                }//
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
                                props.confirmBackToClose()
                            }//
                        }//

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Save")

                            onClicked: {
                                showBusyPage(qsTr("Setting up..."),
                                             function onCallback(seconds){
                                                 if (seconds === 5){
                                                     let intent = IntentApp.create("qrc:/UI/Pages/ManualInputDataPage/FinishManualInputDataPage.qml", {})
                                                     finishView(intent)
                                                 }
                                             })

                                let dfaConstant     = Number(dfaSensorConstantTextField.text)
                                let ifaConstant     = Number(ifaSensorConstantTextField.text)

                                let dfaAdcZero      = Number(dfaAdcZeroTextField.text)
                                let dfaAdcNom       = Number(dfaAdcNomTextField.text)
                                //let dfaAdcMin     = Number(adcIfaMinTextField.text)
                                let ifaAdcZero      = Number(ifaAdcZeroTextField.text)
                                let ifaAdcNom       = Number(ifaAdcNomTextField.text)
                                //let ifaAdcMin     = Number(adcIfaMinTextField.text)

                                if (!((dfaAdcNom > (dfaAdcZero + 80)) && (ifaAdcNom > (ifaAdcZero + 80)))){
                                    showDialogMessage(qsTr("Attention!"),
                                                      qsTr("ADC value is not valid!"),
                                                      dialogAlert)
                                    return
                                }

                                let dfaVelLowAlarm      = Number(dfaVelLowAlarmTextField.text) * 100
                                let dfaVelHighAlarm     = Number(dfaVelHighAlarmTextField.text) * 100
                                let dfaVelNom           = Number(dfaVelNomTextField.text) * 100

                                let ifaVelLowAlarm      = Number(ifaVelLowAlarmTextField.text) * 100
                                let ifaVelNom           = Number(ifaVelNomTextField.text) * 100

                                if (!((dfaVelLowAlarm < dfaVelNom && dfaVelNom < dfaVelHighAlarm)
                                      && (ifaVelLowAlarm < ifaVelNom))){
                                    showDialogMessage(qsTr("Attention!"),
                                                      qsTr("Velocity value is not valid!"),
                                                      dialogAlert)
                                    return
                                }

                                let calibTempAdc = Number(calibTempAdcTextField.text)
                                let calibTemp    = Number(calibTempTextField.text)

                                let dfaFanStandby = Number(dfaFanStandbyTextField.text)
                                let dfaFanMinimum = Number(dfaFanMinTextField.text)
                                let dfaFanNominal = Number(dfaFanNominalTextField.text)
                                let dfaFanMaximum = Number(dfaFanMaxTextField.text)
                                let ifaFanStandby = Number(ifaFanStandbyTextField.text)
                                let ifaFanMinimum = Number(ifaFanMinTextField.text)
                                let ifaFanNominal = Number(ifaFanNominalTextField.text)

                                if (((dfaFanStandby >= dfaFanMinimum) || (dfaFanMinimum >= dfaFanNominal) || (dfaFanNominal >= dfaFanMaximum))
                                        || ((ifaFanStandby >= ifaFanMinimum) || (ifaFanMinimum >= ifaFanNominal))) {
                                    showDialogMessage(qsTr("Attention!"),
                                                      qsTr("Fan duty cycle value is not valid!"),
                                                      dialogAlert)
                                    return
                                }

                                console.debug("dfaConstant: "    + dfaConstant)
                                console.debug("ifaConstant: "    + ifaConstant)
                                console.debug("dfaAdcZero: "     + dfaAdcZero)
                                console.debug("dfaAdcNom: "      + dfaAdcNom)
                                console.debug("ifaAdcZero: "     + ifaAdcZero)
                                console.debug("ifaAdcNom: "      + ifaAdcNom)
                                console.debug("dfaVelLowAlarm: " + dfaVelLowAlarm)
                                console.debug("dfaVelHighAlarm: "+ dfaVelHighAlarm)
                                console.debug("dfaVelNom: "      + dfaVelNom)
                                console.debug("ifaVelLowAlarm: " + ifaVelLowAlarm)
                                console.debug("ifaVelNom: "      + ifaVelNom)
                                console.debug("calibTempAdc: "   + calibTempAdc)
                                console.debug("calibTemp: "      + calibTemp)

                                console.debug("dfaFanNominal: "  + dfaFanNominal)
                                console.debug("dfaFanStandby: "  + dfaFanStandby)
                                console.debug("dfaFanMinimum: "  + dfaFanMinimum)
                                console.debug("dfaFanMaximum: "  + dfaFanMaximum)
                                console.debug("ifaFanNominal: "  + ifaFanNominal)
                                console.debug("ifaFanMinimum: "  + ifaFanMinimum)
                                console.debug("ifaFanStandby: "  + ifaFanStandby)

                                /// clear field calibration
                                MachineAPI.setInflowAdcPointField       (0, 0, 0)
                                MachineAPI.setInflowVelocityPointField  (0, 0, 0)
                                MachineAPI.setDownflowAdcPointField     (0, 0, 0, 0)
                                MachineAPI.setDownflowVelocityPointField(0, 0, 0, 0)

                                /// set factory/full calibration
                                MachineAPI.setInflowSensorConstant      (ifaConstant)
                                MachineAPI.setInflowAdcPointFactory     (ifaAdcZero, 0, ifaAdcNom)
                                MachineAPI.setInflowVelocityPointFactory(0, ifaVelLowAlarm, ifaVelNom)
                                MachineAPI.setInflowLowLimitVelocity    (ifaVelLowAlarm)
                                MachineAPI.setInflowTemperatureCalib    (calibTemp, calibTempAdc)

                                MachineAPI.setDownflowSensorConstant    (dfaConstant)
                                MachineAPI.setDownflowAdcPointFactory   (dfaAdcZero, 0, dfaAdcNom, 0)
                                MachineAPI.setDownflowVelocityPointFactory(0, dfaVelLowAlarm, dfaVelNom, dfaVelHighAlarm)
                                MachineAPI.setDownflowLowLimitVelocity  (dfaVelLowAlarm)
                                MachineAPI.setDownflowHighLimitVelocity (dfaVelHighAlarm)

                                MachineAPI.setFanPrimaryNominalDutyCycleFactory(dfaFanNominal);
                                MachineAPI.setFanPrimaryMaximumDutyCycleFactory(dfaFanMaximum);
                                MachineAPI.setFanPrimaryMinimumDutyCycleFactory(dfaFanMinimum);
                                MachineAPI.setFanPrimaryStandbyDutyCycleFactory(dfaFanStandby);

                                MachineAPI.setFanInflowNominalDutyCycleFactory(ifaFanNominal);
                                MachineAPI.setFanInflowMinimumDutyCycleFactory(ifaFanMinimum);
                                MachineAPI.setFanInflowStandbyDutyCycleFactory(ifaFanStandby);

                                MachineAPI.initAirflowCalibrationStatus(MachineAPI.AF_CALIB_FACTORY);

                                //                                showBusyPage(qsTr("Setting up calibration data..."),
                                //                                             function onCallback(seconds){
                                //                                                 if (seconds === 2){
                                //                                                     MachineAPI.setOperationPreviousMode()
                                //                                                 }

                                //                                                 if (seconds >= 3){
                                //                                                     showDialogMessage(qsTr("Manual Input Calibration Point"),
                                //                                                                       qsTr("Manual calibration data has been configured!"),
                                //                                                                       dialogInfo,
                                //                                                                       function onClosed(){
                                //                                                                           const intent = IntentApp.create(uri, {})
                                //                                                                           finishView(intent)
                                //                                                                       })
                                //                                                 }
                                //                                             })
                            }//
                        }//
                    }//
                }//
            }//
        }//

        //// Put all private property inside here
        //// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property string meaUnitStr: "m/s"
            property string tempUnitStr: "°C"

            function confirmBackToClose(uriTarget){
                const message = qsTr("Close from manual input data?")
                showDialogAsk(qsTr(title),
                              message,
                              dialogAlert,
                              function onAccepted(){
                                  MachineAPI.setOperationPreviousMode()

                                  showBusyPage(qsTr("Please wait"),
                                               function onCallback(secs){
                                                   if(secs === 3) {
                                                       let intent = IntentApp.create(uri, {})
                                                       finishView(intent)
                                                   }
                                               })
                              })
            }//
        }//

        /// called Once but after onResume
        Component.onCompleted: {
            /// override gesture swipe action
            /// basicly dont allow gesture shortcut to home page during calibration
            viewApp.fnSwipedFromLeftEdge = function(){
                props.confirmBackToClose(uri)
            }

            viewApp.fnSwipedFromBottomEdge = function(){
                props.confirmBackToClose("")
            }
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible:  QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

                dfaSensorConstantTextField.text = MachineData.getDownflowSensorConstant()
                ifaSensorConstantTextField.text = MachineData.getInflowSensorConstant()

                dfaAdcZeroTextField.text     = MachineData.getDownflowAdcPointFactory(0)
                //adcIfaMinTextField.text      = MachineData.getInflowAdcPointFactory(1)
                dfaAdcNomTextField.text      = MachineData.getDownflowAdcPointFactory(2)

                ifaAdcZeroTextField.text     = MachineData.getInflowAdcPointFactory(0)
                //adcIfaMinTextField.text      = MachineData.getInflowAdcPointFactory(1)
                ifaAdcNomTextField.text      = MachineData.getInflowAdcPointFactory(2)

                let fixedPoint = 2
                const measureIsImperial = MachineData.measurementUnit
                if(measureIsImperial) {
                    fixedPoint = 0
                    props.meaUnitStr = "fpm"
                    props.tempUnitStr = "°F"
                }

                dfaVelLowAlarmTextField.text     = (MachineData.getDownflowLowLimitVelocity() / 100).toFixed(fixedPoint)
                dfaVelNomTextField.text          = (MachineData.getDownflowVelocityPointFactory(2) / 100).toFixed(fixedPoint)
                dfaVelHighAlarmTextField.text    = (MachineData.getDownflowHighLimitVelocity() / 100).toFixed(fixedPoint)

                ifaVelLowAlarmTextField.text     = (MachineData.getInflowLowLimitVelocity() / 100).toFixed(fixedPoint)
                ifaVelNomTextField.text          = (MachineData.getInflowVelocityPointFactory(2) / 100).toFixed(fixedPoint)

                calibTempAdcTextField.text = MachineData.getInflowTempCalibAdc()
                calibTempTextField.text = MachineData.getInflowTempCalib()

                dfaFanNominalTextField.text = MachineData.getFanPrimaryNominalDutyCycle()
                dfaFanMinTextField.text = MachineData.getFanPrimaryMinimumDutyCycle()
                dfaFanMaxTextField.text = MachineData.getFanPrimaryMaximumlDutyCycle()
                dfaFanStandbyTextField.text = MachineData.getFanPrimaryStandbyDutyCycle()

                ifaFanNominalTextField.text = MachineData.getFanInflowNominalDutyCycle()
                ifaFanMinTextField.text = MachineData.getFanInflowMinimumDutyCycle()
                ifaFanStandbyTextField.text = MachineData.getFanInflowStandbyDutyCycle()
            }//

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }//
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/
