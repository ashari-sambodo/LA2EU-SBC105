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
                    title: qsTr(viewApp.title)
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Row{
                    anchors.centerIn: parent
                    spacing: 10

                    Column {
                        spacing: 5

                        TextApp {
                            text: qsTr("Constant")
                        }//

                        TextFieldApp {
                            id: sensorConstantTextField
                            width: 100
                            height: 40
                            validator: IntValidator{bottom: 0; top: 99;}

                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, qsTr("Constant"))
                            }//
                        }//
                    }//

                    Column {
                        spacing: 5

                        Column {
                            spacing: 5

                            TextApp {
                                text: qsTr("ADC IF0")
                            }//

                            TextFieldApp {
                                id: adcIfaZeroTextField
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
                                text: qsTr("ADC IF1")
                            }//

                            TextFieldApp {
                                id: adcIfaMinTextField
                                width: 110
                                height: 40

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC IF1"))
                                }//
                            }//
                        }//

                        Column {
                            spacing: 5

                            TextApp {
                                text: qsTr("ADC IF2")
                            }//

                            TextFieldApp {
                                id: adcIfaNomTextField
                                width: 110
                                height: 40

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC IF2"))
                                }//
                            }//
                        }//
                    }//

                    Column {
                        spacing: 5

                        Column {
                            spacing: 5

                            TextApp {
                                text: qsTr("IF Alarm")
                            }//

                            TextFieldApp {
                                id: velIfaAlarmTextField
                                width: 110
                                height: 40

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow Alarm"))
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
                                text: qsTr("IF Min")
                            }//

                            TextFieldApp {
                                id: velIfaMinTextField
                                width: 110
                                height: 40

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow Mininum"))
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
                                text: qsTr("IF Nom")
                            }//

                            TextFieldApp {
                                id: velIfaNomTextField
                                width: 110
                                height: 40

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow Nominal"))
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
                                text: qsTr("DF Nom")
                            }//

                            TextFieldApp {
                                id: velDfaNomTextField
                                width: 110
                                height: 40

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("Downflow Nominal"))
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

                    Column {
                        spacing: 5

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
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("Calib Temperature"))
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
                    }//

                    Column {
                        spacing: 5

                        Column {
                            spacing: 5

                            TextApp {
                                text: qsTr("Fan Nom")
                            }//

                            TextFieldApp {
                                id: fanNominalTextField
                                width: 110
                                height: 40

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan Nominal"))
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
                                id: fanMinimumTextField
                                width: 110
                                height: 40

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan Minimum"))
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
                                text: qsTr("Fan Stby")
                            }//

                            TextFieldApp {
                                id: fanStandbyTextField
                                width: 110
                                height: 40

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan Standby"))
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
                }//

                //                RowLayout {
                //                    anchors.fill: parent

                //                    Item {
                //                        Layout.fillHeight: true
                //                        Layout.fillWidth: true
                //                    }//

                //                    Item {
                //                        Layout.fillHeight: true
                //                        Layout.fillWidth: true
                //                    }//
                //                }//
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

                                let contant      = Number(sensorConstantTextField.text)

                                let adcIfaZero   = Number(adcIfaZeroTextField.text)
                                let adcIfaMin    = Number(adcIfaMinTextField.text)
                                let adcIfaNom    = Number(adcIfaNomTextField.text)

                                if (!((adcIfaZero < adcIfaMin)
                                      && (adcIfaZero < adcIfaNom)
                                      && (adcIfaMin < adcIfaNom))){
                                    showDialogMessage(qsTr("Attention!"),
                                                      qsTr("ADC value is not valid!"),
                                                      dialogAlert)
                                    return
                                }

                                let velIfaAlarm  = Number(velIfaAlarmTextField.text) * 100
                                let velIfaMin    = Number(velIfaMinTextField.text) * 100
                                let velIfaNom    = Number(velIfaNomTextField.text) * 100
                                let velDfaNom    = Number(velDfaNomTextField.text) * 100

                                if (!((velIfaMin < velIfaNom)
                                      && (velDfaNom < velIfaNom))){
                                    showDialogMessage(qsTr("Attention!"),
                                                      qsTr("Velocity value is not valid!"),
                                                      dialogAlert)
                                    return
                                }

                                let calibTempAdc = Number(calibTempAdcTextField.text)
                                let calibTemp    = Number(calibTempTextField.text)

                                let fanNominal = Number(fanNominalTextField.text)
                                let fanMinimum = Number(fanMinimumTextField.text)
                                let fanStandby = Number(fanStandbyTextField.text)

                                if (fanStandby >= fanNominal || fanMinimum >= fanNominal) {
                                    showDialogMessage(qsTr("Attention!"),
                                                      qsTr("Fan duty cycle value is not valid!"),
                                                      dialogAlert)
                                    return
                                }

                                console.debug("contant: "       + contant)
                                console.debug("adcIfaZero: "    + adcIfaZero)
                                console.debug("adcIfaMin: "     + adcIfaMin)
                                console.debug("adcIfaNom: "     + adcIfaNom)
                                console.debug("velIfaAlarm: "   + velIfaAlarm)
                                console.debug("velIfaMin: "     + velIfaMin)
                                console.debug("velIfaNom: "     + velIfaNom)
                                console.debug("velDfaNom: "     + velDfaNom)
                                console.debug("calibTempAdc: "  + calibTempAdc)
                                console.debug("calibTemp: "     + calibTemp)
                                console.debug("fanNominal: "    + fanNominal)
                                console.debug("fanMinimum: "    + fanMinimum)
                                console.debug("fanStandby: "    + fanStandby)

                                /// clear field calibration
                                MachineAPI.setInflowAdcPointField(0, 0, 0)
                                MachineAPI.setInflowVelocityPointField(0, 0, 0)

                                /// set factory/full calibration
                                MachineAPI.setInflowSensorConstant(contant)
                                MachineAPI.setInflowAdcPointFactory(adcIfaZero, adcIfaMin, adcIfaNom)
                                MachineAPI.setInflowVelocityPointFactory(0, velIfaMin, velIfaNom)
                                MachineAPI.setDownflowVelocityPointFactory(0, 0, velDfaNom)
                                MachineAPI.setInflowLowLimitVelocity(velIfaAlarm)
                                MachineAPI.setInflowTemperatureCalib(calibTemp, calibTempAdc)

                                MachineAPI.setFanPrimaryNominalDutyCycleFactory(fanNominal);
                                MachineAPI.setFanPrimaryMinimumDutyCycleFactory(fanMinimum);
                                MachineAPI.setFanPrimaryStandbyDutyCycleFactory(fanStandby);

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
            }
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

                sensorConstantTextField.text = MachineData.getInflowSensorConstant()

                adcIfaZeroTextField.text     = MachineData.getInflowAdcPointFactory(0)
                adcIfaMinTextField.text      = MachineData.getInflowAdcPointFactory(1)
                adcIfaNomTextField.text      = MachineData.getInflowAdcPointFactory(2)

                let fixedPoint = 2
                const measureIsImperial = MachineData.measurementUnit
                if(measureIsImperial) {
                    fixedPoint = 0
                    props.meaUnitStr = "fpm"
                    props.tempUnitStr = "°F"
                }

                velIfaMinTextField.text   = (MachineData.getInflowVelocityPointFactory(1) / 100).toFixed(fixedPoint)
                velIfaAlarmTextField.text = (MachineData.getInflowLowLimitVelocity() / 100).toFixed(fixedPoint)
                velIfaNomTextField.text   = (MachineData.getInflowVelocityPointFactory(2) / 100).toFixed(fixedPoint)
                velDfaNomTextField.text   = (MachineData.getDownflowVelocityPointFactory(2) / 100).toFixed(fixedPoint)

                calibTempAdcTextField.text = MachineData.getInflowTempCalibAdc()
                calibTempTextField.text = MachineData.getInflowTempCalib()

                fanNominalTextField.text = MachineData.getFanPrimaryNominalDutyCycle()
                fanMinimumTextField.text = MachineData.getFanPrimaryMinimumDutyCycle()
                fanStandbyTextField.text = MachineData.getFanPrimaryStandbyDutyCycle()
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
