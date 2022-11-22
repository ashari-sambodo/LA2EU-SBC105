/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Reset Field Calibration"

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
                    title: qsTr("Reset Field Calibration")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                Rectangle{
                    width: 700
                    height: parent.height
                    anchors.centerIn: parent
                    color: "transparent"
                    TextApp{
                        width: parent.width
                        height: parent.height
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        padding: 10
                        wrapMode: Text.WordWrap
                        minimumPixelSize: 20
                        text: qsTr("By resetting the Field Calibration, all field calibration data will be lost and the cabinet will use the full calibration data instead.") + "<br><br>" +
                              qsTr("Press the '%1' button to perform the reset.").arg(resetBtn.text)
                    }
                }//
            }//
            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 70

                BackgroundButtonBarApp {
                    Item {
                        anchors.fill: parent
                        anchors.margins: 5

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                let intent = IntentApp.create(uri, {})
                                finishView(intent)
                            }//
                        }//

                        ButtonBarApp {
                            id: resetBtn
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Reset")

                            onClicked: {
                                const message = qsTr("You will reset Field Calibration data, and use Full Calibration data instead.") + "<br>"
                                              + qsTr("Are you sure to continue?")
                                var autoClose = false
                                viewApp.showDialogAsk(qsTr("Reset Field Calibration"),
                                                      message,
                                                      viewApp.dialogAlert,
                                                      function onAccepted(){
                                                          props.performReset()
                                                      }, function onRejected(){
                                                          return;
                                                      }, function(){}, autoClose)


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

            function performReset(){
                showBusyPage(qsTr("Resetting..."),
                             function onCallback(seconds){
                                 if (seconds >= MachineAPI.BUSY_CYCLE_2){
                                     /// Back to Main Screen
                                     const intent = IntentApp.create("", {})
                                     startRootView(intent)
                                 }
                             })//

                ///// INFLOW
                /// clear field calibration
                MachineAPI.setInflowAdcPointField       (0, 0, 0)
                MachineAPI.setInflowVelocityPointField  (0, 0, 0)
                ///// DOWNFLOW
                /// clear field calibration
                // MachineAPI.setDownflowAdcPointField     (0, 0, 0)
                MachineAPI.setDownflowVelocityPointField(0, 0, 0)

                MachineAPI.initAirflowCalibrationStatus(MachineAPI.AF_CALIB_FACTORY);

                //Reset State "Done" at Airflow Calibration
                MachineAPI.setAirflowFactoryCalibrationState(0, true);
                MachineAPI.setAirflowFactoryCalibrationState(1, true);
                MachineAPI.setAirflowFactoryCalibrationState(2, true);
                MachineAPI.setAirflowFactoryCalibrationState(3, true);

                MachineAPI.setAdcFactoryCalibrationState(0, true);
                MachineAPI.setAdcFactoryCalibrationState(1, true);
                MachineAPI.setAdcFactoryCalibrationState(2, true);
                MachineAPI.setAdcFactoryCalibrationState(3, true);

                /// Reset the Field calibration state
                MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowDimNominal, false)
                MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowSecNominal, false)
                MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_DownflowNominal, false)
                MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_AdcNominal, false)
            }
        }//

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible:  QtObject {

            /// onResume
            Component.onCompleted: {
                // //console.debug("StackView.Active");
                let fixedPoint = 2
                const measureIsImperial = MachineData.measurementUnit
                if(measureIsImperial) {
                    fixedPoint = 0
                    props.meaUnitStr = "fpm"
                    props.tempUnitStr = "°F"
                }

                //                ///// DOWNFLOW
                //                adcDfa3TextField.text = MachineData.getDownflowAdcPointField(MachineAPI.POINT_NOMINAL)
                //                //                adcDfa2TextField.text = MachineData.getDownflowAdcPointField(MachineAPI.POINT_POWER_SAVE)
                //                adcDfa1TextField.text = MachineData.getDownflowAdcPointField(MachineAPI.POINT_MINIMUM)
                //                adcDfa0TextField.text = MachineData.getDownflowAdcPointField(MachineAPI.POINT_ZERO)

                //                dfaNomTextField.text = (MachineData.getDownflowVelocityPointField(MachineAPI.POINT_NOMINAL)/100).toFixed(fixedPoint)
                //                //                dfaPSTextField.text = (MachineData.getDownflowVelocityPointField(MachineAPI.POINT_POWER_SAVE)/100).toFixed(fixedPoint)
                //                dfaMinTextField.text = (MachineData.getDownflowVelocityPointField(MachineAPI.POINT_MINIMUM)/100).toFixed(fixedPoint)

                //                dfaFanNomTextField.text = MachineData.getFanPrimaryNominalDutyCycleField()
                //                //                dfaFanPSTextField.text = MachineData.getFanPrimaryPowerSaveDutyCycleField()
                //                dfaFanMinTextField.text = MachineData.getFanPrimaryMinimumDutyCycleField()
                //                dfaFanStbTextField.text = MachineData.getFanPrimaryStandbyDutyCycleField()

                //                dfaFanRpmNomTextField.text = MachineData.getFanPrimaryNominalRpmField()
                //                //                dfaFanRpmPSTextField.text = MachineData.getFanPrimaryPowerSaveRpmField()
                //                dfaFanRpmMinTextField.text = MachineData.getFanPrimaryMinimumRpmField()

                //                dfaConstTextField.text = MachineData.getDownflowSensorConstant()

                //                ///// INFLOW
                //                adcIfa3TextField.text = MachineData.getInflowAdcPointField(MachineAPI.POINT_NOMINAL)
                //                //                adcIfa2TextField.text = MachineData.getInflowAdcPointField(MachineAPI.POINT_POWER_SAVE)
                //                adcIfa1TextField.text = MachineData.getInflowAdcPointField(MachineAPI.POINT_MINIMUM)
                //                adcIfa0TextField.text = MachineData.getInflowAdcPointField(MachineAPI.POINT_ZERO)

                //                ifaNomTextField.text = (MachineData.getInflowVelocityPointField(MachineAPI.POINT_NOMINAL)/100).toFixed(fixedPoint)
                //                //                ifaPSTextField.text = (MachineData.getInflowVelocityPointField(MachineAPI.POINT_POWER_SAVE)/100).toFixed(fixedPoint)
                //                ifaMinTextField.text = (MachineData.getInflowVelocityPointField(MachineAPI.POINT_MINIMUM)/100).toFixed(fixedPoint)

                //                ifaFanNomTextField.text = MachineData.getFanInflowNominalDutyCycleField()
                //                //                ifaFanPSTextField.text = MachineData.getFanInflowPowerSaveDutyCycleField()
                //                ifaFanMinTextField.text = MachineData.getFanInflowMinimumDutyCycleField()
                //                ifaFanStbTextField.text = MachineData.getFanInflowStandbyDutyCycleField()

                //                ifaFanRpmNomTextField.text = MachineData.getFanInflowNominalRpmField()
                //                //                ifaFanRpmPSTextField.text = MachineData.getFanInflowPowerSaveRpmField()
                //                ifaFanRpmMinTextField.text = MachineData.getFanInflowMinimumRpmField()

                //                ifaConstTextField.text = MachineData.getInflowSensorConstant()

                //                ///// Temperature
                //                calibTempAdcTextField.text = MachineData.getInflowTempCalibAdc()
                //                calibTempTextField.text = MachineData.getInflowTempCalib()
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
