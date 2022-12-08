/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtQml.Models 2.1

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

import "Components" as CusComPage

ViewApp {
    id: viewApp
    title: "Diagnostics"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

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
                    title: qsTr("Diagnostics")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent

                    Flickable {
                        id: view
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        //                        anchors.fill: parent
                        //                        anchors.margins: 2
                        contentWidth: col.width
                        contentHeight: col.height
                        property real span : contentY + height
                        clip: true

                        flickableDirection: Flickable.VerticalFlick

                        ScrollBar.vertical: verticalScrollBar.scrollBar

                        Column {
                            id: col
                            spacing: 2

                            CusComPage.RowItemApp {
                                id: serialNumber
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Serial number")

                                onLoaded: {
                                    //                                //console.debug("onLoaded")
                                    value = MachineData.serialNumber
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: softwareVersion
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Software version")

                                onLoaded: {
                                    value = Qt.application.name + " - " + Qt.application.version
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: oparationMode
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Operation mode")

                                onLoaded: {
                                    value = Qt.binding(function(){
                                        switch (MachineData.operationMode){
                                        case MachineAPI.MODE_OPERATION_QUICKSTART:
                                            return qsTr("Quick Start")
                                        case MachineAPI.MODE_OPERATION_NORMAL:
                                            return qsTr("Normal")
                                        case MachineAPI.MODE_OPERATION_MAINTENANCE:
                                            return qsTr("Maintenance")
                                        }
                                    })
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: sashState
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Sash state")

                                onLoaded: {
                                    value = Qt.binding(function(){
                                        switch (MachineData.sashWindowState){
                                        case MachineAPI.SASH_STATE_WORK_SSV:
                                            return qsTr("Safe height")
                                        case MachineAPI.SASH_STATE_UNSAFE_SSV:
                                            return qsTr("Unsafe height")
                                        case MachineAPI.SASH_STATE_FULLY_CLOSE_SSV:
                                            return qsTr("Fully close")
                                        case MachineAPI.SASH_STATE_FULLY_OPEN_SSV:
                                            return qsTr("Fully open")
                                        case MachineAPI.SASH_STATE_STANDBY_SSV:
                                            return qsTr("Standby height")
                                        default:
                                            return qsTr("Unknown")
                                        }
                                    })
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: fanState
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Fan state (DF | IF)")

                                onLoaded: {
                                    if(MachineData.cabinetWidth3Feet)
                                        value1 = Qt.binding(function(){
                                            return "" + utilsApp.getFanDucyStrf(MachineData.fanPrimaryDutyCycle) + " %"
                                        })
                                    else
                                        value1 = Qt.binding(function(){
                                            return "" + utilsApp.getFanDucyStrf(MachineData.fanPrimaryDutyCycle) + " % / " + MachineData.fanPrimaryRpm + " RPM"
                                        })
                                    if(MachineData.getDualRbmMode()){
                                        value2 = Qt.binding(function(){
                                            return "" + utilsApp.getFanDucyStrf(MachineData.fanInflowDutyCycle) + " % / " + MachineData.fanInflowRpm + " RPM"
                                        })
                                    }
                                    else
                                        value2 = Qt.binding(function(){ return "" + utilsApp.getFanDucyStrf(MachineData.fanInflowDutyCycle) + " % "})

                                }//

                                onUnloaded: {
                                    value1 = ""
                                    value2 = ""
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: fanUsageMeter
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Fan usage meter (DF | IF)")

                                onLoaded: {
                                    value1 = Qt.binding(function(){
                                        let meterDfa = MachineData.fanPrimaryUsageMeter * 60
                                        if (meterDfa === 0) return qsTr("Never used")
                                        return utilsApp.strfSecsToHumanReadableShort(meterDfa)
                                    })
                                    value2= Qt.binding(function(){
                                        let meterIfa = MachineData.fanInflowUsageMeter * 60
                                        if (meterIfa === 0) return qsTr("Never used")
                                        return utilsApp.strfSecsToHumanReadableShort(meterIfa)
                                    })
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: filterLife
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Filter life")

                                onLoaded: {
                                    value = Qt.binding(function(){
                                        return MachineData.filterLifePercent + " %"
                                                + " "
                                                + "(" + utilsApp.strfSecsToHumanReadableShort(MachineData.filterLifeMinutes * 60)
                                                + ")"
                                    })
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: uvLife
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("UV life")

                                onLoaded: {
                                    value = Qt.binding(function(){
                                        return MachineData.uvLifePercent + "%"
                                                + " "
                                                + "(" + utilsApp.strfSecsToHumanReadableShort(MachineData.uvLifeMinutes * 60)
                                                + ")"
                                    })
                                }
                                //                                visible: enabled
                                enabled: props.uvInstalled
                            }//

                            CusComPage.RowItemApp {
                                id: uvTimer
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("UV timer")

                                onLoaded: {
                                    value = utilsApp.strfSecsToHumanReadableShort(MachineData.uvTime * 60)
                                }

                                //                                visible: enabled
                                enabled: props.uvInstalled
                            }//

                            /// Visible when the unit has motorize window
                            CusComPage.RowItemApp {
                                id: sashMotorize
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Sash cycle meter")

                                onLoaded: {
                                    value = Qt.binding(function(){
                                        return (MachineData.sashCycleMeter/10).toFixed(1)
                                    })
                                }

                                enabled: props.sashWindowMotorizeInstalled
                            }//

                            CusComPage.RowItemApp {
                                id: tempAmbient
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Temperature ambient")

                                onLoaded: {
                                    value = Qt.binding(function(){return MachineData.temperatureValueStr})
                                }

                                onUnloaded: {
                                    value = ""
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: tempAmbientADC
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Temperature ADC")

                                onLoaded: {
                                    value = Qt.binding(function(){return MachineData.temperatureAdc})
                                }

                                onUnloaded: {
                                    value = ""
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: tempAmbientCalib
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Temperature calibration")

                                onLoaded: {
                                    value = Qt.binding(function(){
                                        if(MachineData.measurementUnit)
                                            return MachineData.getDownflowTempCalib()+ "°F"
                                        else
                                            return MachineData.getDownflowTempCalib()+ "°C"
                                    })
                                }

                                onUnloaded: {
                                    value = ""
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: tempAmbientCalibADC
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Temperature calibration ADC")

                                onLoaded: {
                                    value = Qt.binding(function(){return MachineData.getDownflowTempCalibAdc() /*+ " | " + MachineData.getInflowTempCalibAdc()*/})
                                }

                                onUnloaded: {
                                    value = ""
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: ifaADC
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("ADC A/F Actual (DF | IF)")

                                onLoaded: {
                                    value1 = Qt.binding(function(){return MachineData.dfaAdcConpensation})
                                    value2 = Qt.binding(function(){return MachineData.ifaAdcConpensation})
                                }

                                onUnloaded: {
                                    value1 = ""
                                    value2 = ""
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: ifnADC
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("ADC A/F Nominal (DF | IF)")

                                onLoaded: {
                                    if (MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD) {
                                        value1 = MachineData.getDownflowAdcPointField(2);
                                        value2 = MachineData.getInflowAdcPointField(2);
                                    }
                                    else {
                                        value1 = MachineData.getDownflowAdcPointFactory(2)
                                        value2 = MachineData.getInflowAdcPointFactory(2)
                                    }
                                }

                            }//

                            //                            CusComPage.RowItemApp {
                            //                                id: iffADC
                            //                                width: view.width
                            //                                height: 50
                            //                                viewContentY: view.contentY
                            //                                viewSpan: view.span

                            //                                label: qsTr("ADC A/F Fail (DF | IF)")

                            //                                onLoaded: {
                            //                                    if (MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD) {
                            //                                        value1 = MachineData.getDownflowAdcPointField(1)
                            //                                        value2 = MachineData.getInflowAdcPointField(1);
                            //                                    }
                            //                                    else {
                            //                                        value1 = MachineData.getDownflowAdcPointFactory(1)
                            //                                        value2 = MachineData.getInflowAdcPointFactory(1)
                            //                                    }
                            //                                }
                            //                            }//

                            CusComPage.RowItemApp {
                                id: if2ADC
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("ADC A/F 2 (DF | IF)")

                                onLoaded: {
                                    value1 = MachineData.getDownflowAdcPointFactory(2)
                                    value2 = MachineData.getInflowAdcPointFactory(2)
                                }//
                            }//

                            //                            CusComPage.RowItemApp {
                            //                                id: if1ADC
                            //                                width: view.width
                            //                                height: 50
                            //                                viewContentY: view.contentY
                            //                                viewSpan: view.span

                            //                                label: qsTr("ADC A/F 1 (DF | IF)")

                            //                                onLoaded: {
                            //                                    value1 = MachineData.getDownflowAdcPointFactory(1)
                            //                                    value2 = MachineData.getInflowAdcPointFactory(1);
                            //                                }
                            //                            }//

                            CusComPage.RowItemApp {
                                id: if0ADC
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("ADC A/F 0 (DF | IF)")

                                onLoaded: {
                                    value1 = MachineData.getDownflowAdcPointFactory(0)
                                    value2 = MachineData.getInflowAdcPointFactory(0);
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: dfmVel
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("VEL A/F High Alarm (DF)")

                                onLoaded: {
                                    let velocityIfa = 0
                                    let velocityDfa = MachineData.getDownflowHighLimitVelocity() / 100
                                    //                                    if (MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD) {
                                    //                                        //velocityIfa = MachineData.getInflowVelocityPointField(1) / 100
                                    //                                        velocityDfa = MachineData.getDownflowVelocityPointField(3) / 100
                                    //                                    }
                                    //                                    else {
                                    //                                        //velocityIfa = MachineData.getInflowVelocityPointFactory(1) / 100
                                    //                                        velocityDfa = MachineData.getDownflowVelocityPointFactory(3) / 100
                                    //                                    }

                                    //let velocityIfaStr = ""
                                    let velocityDfaStr = ""

                                    if (MachineData.measurementUnit) {
                                        /// imperial
                                        //velocityIfaStr = velocityIfa.toFixed() + " fpm"
                                        velocityDfaStr = velocityDfa.toFixed() + " fpm"
                                    }
                                    else {
                                        /// metric
                                        //velocityIfaStr = velocityIfa.toFixed(2) + " m/s"
                                        velocityDfaStr = velocityDfa.toFixed(2) + " m/s"
                                    }

                                    value = velocityDfaStr
                                    //value2 = velocityIfaStr
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: ifnVel
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("VEL A/F Nominal (DF | IF)")

                                onLoaded: {
                                    let velocityIfa = 0
                                    let velocityDfa = 0
                                    if (MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD) {
                                        velocityIfa = MachineData.getInflowVelocityPointField(2) / 100
                                        velocityDfa = MachineData.getDownflowVelocityPointField(2) / 100
                                    }
                                    else {
                                        velocityIfa = MachineData.getInflowVelocityPointFactory(2) / 100
                                        velocityDfa = MachineData.getDownflowVelocityPointFactory(2) / 100
                                    }

                                    let velocityIfaStr = ""
                                    let velocityDfaStr = ""

                                    if (MachineData.measurementUnit) {
                                        /// imperial
                                        velocityIfaStr = velocityIfa.toFixed() + " fpm"
                                        velocityDfaStr = velocityDfa.toFixed() + " fpm"
                                    }
                                    else {
                                        /// metric
                                        velocityIfaStr = velocityIfa.toFixed(2) + " m/s"
                                        velocityDfaStr = velocityDfa.toFixed(2) + " m/s"
                                    }

                                    value1 = velocityDfaStr
                                    value2 = velocityIfaStr
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: iffVel
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("VEL A/F Low Alarm (DF | IF)")

                                onLoaded: {
                                    let velocityDfa = MachineData.getDownflowLowLimitVelocity() / 100
                                    let velocityIfa = MachineData.getInflowLowLimitVelocity() / 100

                                    //                                    if (MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD) {
                                    //                                        velocityDfa = MachineData.getDownflowVelocityPointField(1) / 100
                                    //                                        velocityIfa = MachineData.getInflowVelocityPointField(1) / 100
                                    //                                    }
                                    //                                    else {
                                    //                                        velocityDfa = MachineData.getDownflowVelocityPointFactory(1) / 100
                                    //                                        velocityIfa = MachineData.getInflowVelocityPointFactory(1) / 100
                                    //                                    }

                                    let velocityIfaStr = ""
                                    let velocityDfaStr = ""
                                    if (MachineData.measurementUnit) {
                                        /// imperial
                                        velocityDfaStr = velocityDfa.toFixed() + " fpm"
                                        velocityIfaStr = velocityIfa.toFixed() + " fpm"
                                    }
                                    else {
                                        /// metric
                                        velocityDfaStr = velocityDfa.toFixed(2) + " m/s"
                                        velocityIfaStr = velocityIfa.toFixed(2) + " m/s"
                                    }

                                    value1 = velocityDfaStr
                                    value2 = velocityIfaStr
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: df3Vel
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("VEL A/F 3 (DF)")

                                onLoaded: {
                                    let velocityDfa = 0
                                    //let velocityIfa = 0

                                    //velocityIfa = MachineData.getInflowVelocityPointFactory(2) / 100
                                    velocityDfa = MachineData.getDownflowVelocityPointFactory(3) / 100

                                    //let velocityIfaStr = ""
                                    let velocityDfaStr = ""
                                    if (MachineData.measurementUnit) {
                                        /// imperial
                                        //velocityIfaStr = velocityIfa.toFixed() + " fpm"
                                        velocityDfaStr = velocityDfa.toFixed() + " fpm"
                                    }
                                    else {
                                        /// metric
                                        //velocityIfaStr = velocityIfa.toFixed(2) + " m/s"
                                        velocityDfaStr = velocityDfa.toFixed(2) + " m/s"
                                    }

                                    value = velocityDfaStr
                                    //value2 = velocityIfaStr
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: if2Vel
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("VEL A/F 2 (DF | IF)")

                                onLoaded: {
                                    let velocityDfa = 0
                                    let velocityIfa = 0

                                    velocityIfa = MachineData.getInflowVelocityPointFactory(2) / 100
                                    velocityDfa = MachineData.getDownflowVelocityPointFactory(2) / 100

                                    let velocityIfaStr = ""
                                    let velocityDfaStr = ""
                                    if (MachineData.measurementUnit) {
                                        /// imperial
                                        velocityIfaStr = velocityIfa.toFixed() + " fpm"
                                        velocityDfaStr = velocityDfa.toFixed() + " fpm"
                                    }
                                    else {
                                        /// metric
                                        velocityIfaStr = velocityIfa.toFixed(2) + " m/s"
                                        velocityDfaStr = velocityDfa.toFixed(2) + " m/s"
                                    }

                                    value1 = velocityDfaStr
                                    value2 = velocityIfaStr
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: if1Vel
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("VEL A/F 1 (DF | IF)")

                                onLoaded: {
                                    let velocityDfa = 0
                                    let velocityIfa = 0

                                    velocityIfa = MachineData.getInflowVelocityPointFactory(1) / 100
                                    velocityDfa = MachineData.getDownflowVelocityPointFactory(1) / 100

                                    let velocityIfaStr = ""
                                    let velocityDfaStr = ""
                                    if (MachineData.measurementUnit) {
                                        /// imperial
                                        velocityIfaStr = velocityIfa.toFixed() + " fpm"
                                        velocityDfaStr = velocityDfa.toFixed() + " fpm"
                                    }
                                    else {
                                        /// metric
                                        velocityIfaStr = velocityIfa.toFixed(2) + " m/s"
                                        velocityDfaStr = velocityDfa.toFixed(2) + " m/s"
                                    }

                                    value1 = velocityDfaStr
                                    value2 = velocityIfaStr
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: ifaSensorConstVel
                                enabled: (MachineData.getDownflowSensorConstant() > 0 || MachineData.getInflowSensorConstant() > 0)
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Sensor Contant (DF | IF)")

                                onLoaded: {
                                    value = MachineData.getDownflowSensorConstant() + " | " + MachineData.getInflowSensorConstant()
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: fanDutyCycleNom
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Fan Nominal (DF | IF)")

                                onLoaded: {
                                    if (MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD) {
                                        const ducyDfa = MachineData.getFanPrimaryNominalDutyCycleField()
                                        const rpmDfa = MachineData.getFanPrimaryNominalRpmField()
                                        const ducyIfa = MachineData.getFanInflowNominalDutyCycleField()
                                        const rpmIfa = MachineData.getFanInflowNominalRpmField()
                                        if(MachineData.cabinetWidth3Feet)
                                            value1 = utilsApp.getFanDucyStrf(ducyDfa) + " %"
                                        else
                                            value1 = utilsApp.getFanDucyStrf(ducyDfa) + " %" + " / " + rpmDfa + " RPM"
                                        if(MachineData.getDualRbmMode())
                                            value2 = utilsApp.getFanDucyStrf(ducyIfa) + " %" + " / " + rpmIfa + " RPM"
                                        else
                                            value2 = utilsApp.getFanDucyStrf(ducyIfa) + " %"
                                    }
                                    else {
                                        const ducyDfa = MachineData.getFanPrimaryNominalDutyCycleFactory()
                                        const rpmDfa = MachineData.getFanPrimaryNominalRpmFactory()
                                        const ducyIfa = MachineData.getFanInflowNominalDutyCycleFactory()
                                        const rpmIfa = MachineData.getFanInflowNominalRpmFactory()

                                        if(MachineData.cabinetWidth3Feet)
                                            value1 = utilsApp.getFanDucyStrf(ducyDfa) + " %"
                                        else
                                            value1 = utilsApp.getFanDucyStrf(ducyDfa) + " %" + " / " + rpmDfa + " RPM"
                                        if(MachineData.getDualRbmMode())
                                            value2 = utilsApp.getFanDucyStrf(ducyIfa) + " %" + " / " + rpmIfa + " RPM"
                                        else
                                            value2 = utilsApp.getFanDucyStrf(ducyIfa) + " %"
                                    }
                                }
                            }//

                            //                            CusComPage.RowItemApp {
                            //                                id: fanDutyCycleMin
                            //                                width: view.width
                            //                                height: 50
                            //                                viewContentY: view.contentY
                            //                                viewSpan: view.span

                            //                                label: qsTr("Fan Minimum (DF | IF)")

                            //                                onLoaded: {
                            //                                    if (MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD) {
                            //                                        const ducyDfa = MachineData.getFanPrimaryMinimumDutyCycleField()
                            //                                        const rpmDfa = MachineData.getFanPrimaryMinimumRpmField()
                            //                                        const ducyIfa = MachineData.getFanInflowMinimumDutyCycleField()

                            //                                        value1 = utilsApp.getFanDucyStrfducyDfa + " %" + " / " + rpmDfa + " RPM"
                            //                                        value2 = utilsApp.getFanDucyStrfducyIfa + " RPM"
                            //                                    }//
                            //                                    else {
                            //                                        const ducyDfa = MachineData.getFanPrimaryMinimumDutyCycleFactory()
                            //                                        const rpmDfa = MachineData.getFanPrimaryMinimumRpmFactory()
                            //                                        const ducyIfa = MachineData.getFanInflowMinimumDutyCycleFactory()

                            //                                        value1 = utilsApp.getFanDucyStrfducyDfa + " %" + " / " + rpmDfa + " RPM"
                            //                                        value2 = utilsApp.getFanDucyStrfducyIfa + " RPM"
                            //                                    }//
                            //                                }//
                            //                            }//

                            CusComPage.RowItemApp {
                                id: fanStandbyDutyCycle
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Fan Standby (DF | IF)")

                                onLoaded: {
                                    if (MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD) {
                                        const ducyDfa = MachineData.getFanPrimaryStandbyDutyCycleField()
                                        const rpmDfa = MachineData.getFanPrimaryStandbyRpmField()
                                        const ducyIfa = MachineData.getFanInflowStandbyDutyCycleField()
                                        const rpmIfa = MachineData.getFanInflowStandbyRpmField()
                                        if(MachineData.cabinetWidth3Feet)
                                            value1 = utilsApp.getFanDucyStrf(ducyDfa) + " %"
                                        else
                                            value1 = utilsApp.getFanDucyStrf(ducyDfa) + " %" + " / " + rpmDfa + " RPM"
                                        if(MachineData.getDualRbmMode())
                                            value2 = utilsApp.getFanDucyStrf(ducyIfa) + " %" + " / " + rpmIfa + " RPM"
                                        else
                                            value2 = utilsApp.getFanDucyStrf(ducyIfa) + " %"
                                    }
                                    else {
                                        const ducyDfa = MachineData.getFanPrimaryStandbyDutyCycleFactory()
                                        const rpmDfa = MachineData.getFanPrimaryStandbyRpmFactory()
                                        const ducyIfa = MachineData.getFanInflowStandbyDutyCycleFactory()
                                        const rpmIfa = MachineData.getFanInflowStandbyRpmFactory()
                                        if(MachineData.cabinetWidth3Feet)
                                            value1 = utilsApp.getFanDucyStrf(ducyDfa) + " %"
                                        else
                                            value1 = utilsApp.getFanDucyStrf(ducyDfa) + " %" + " / " + rpmDfa + " RPM"
                                        if(MachineData.getDualRbmMode())
                                            value2 = utilsApp.getFanDucyStrf(ducyIfa) + " %" + " / " + rpmIfa + " RPM"
                                        else
                                            value2 = utilsApp.getFanDucyStrf(ducyIfa) + " %"
                                    }
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: fanDutyCycleNomFactory
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Fan A/F 2 (DF | IF)")

                                onLoaded: {
                                    const ducyDfa = MachineData.getFanPrimaryNominalDutyCycleFactory()
                                    const rpmDfa = MachineData.getFanPrimaryNominalRpmFactory()
                                    const ducyIfa = MachineData.getFanInflowNominalDutyCycleFactory()
                                    const rpmIfa = MachineData.getFanInflowNominalRpmFactory()

                                    if(MachineData.cabinetWidth3Feet)
                                        value1 = utilsApp.getFanDucyStrf(ducyDfa) + " %"
                                    else
                                        value1 = utilsApp.getFanDucyStrf(ducyDfa) + " %" + " / " + rpmDfa + " RPM"
                                    if(MachineData.getDualRbmMode())
                                        value2 = utilsApp.getFanDucyStrf(ducyIfa) + " %" + " / " + rpmIfa + " RPM"
                                    else
                                        value2 = utilsApp.getFanDucyStrf(ducyIfa) + " %"
                                }
                            }//

                            //                            CusComPage.RowItemApp {
                            //                                id: fanDutyCycleMinFactory
                            //                                width: view.width
                            //                                height: 50
                            //                                viewContentY: view.contentY
                            //                                viewSpan: view.span

                            //                                label: qsTr("Fan A/F 1 (DF | IF)")

                            //                                onLoaded: {
                            //                                    const ducyDfa = MachineData.getFanPrimaryMinimumDutyCycleFactory()
                            //                                    const rpmDfa = MachineData.getFanPrimaryMinimumRpmFactory()
                            //                                    const ducyIfa = MachineData.getFanInflowMinimumDutyCycleFactory()

                            //                                    value1 = ducyDfa + " %" + " / " + rpmDfa + " RPM"
                            //                                    value2 = ducyIfa + " RPM"
                            //                                }
                            //                            }//

                            CusComPage.RowItemApp {
                                id: fanDutyCycleStbFactory
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Fan A/F S (DF | IF)")

                                onLoaded: {
                                    const ducyDfa = MachineData.getFanPrimaryStandbyDutyCycleFactory()
                                    const rpmDfa = MachineData.getFanPrimaryStandbyRpmFactory()
                                    const ducyIfa = MachineData.getFanInflowStandbyDutyCycleFactory()
                                    const rpmIfa = MachineData.getFanInflowStandbyRpmFactory()
                                    if(MachineData.cabinetWidth3Feet)
                                        value1 = utilsApp.getFanDucyStrf(ducyDfa) + " %"
                                    else
                                        value1 = utilsApp.getFanDucyStrf(ducyDfa) + " %" + " / " + rpmDfa + " RPM"
                                    if(MachineData.getDualRbmMode())
                                        value2 = utilsApp.getFanDucyStrf(ducyIfa) + " %" + " / " + rpmIfa + " RPM"
                                    else
                                        value2 = utilsApp.getFanDucyStrf(ducyIfa) + " %"
                                }
                            }//

                            CusComPage.RowItemApp {
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Exhaust Free Relay Contact")

                                property bool connected: false
                                value: connected ? "ON" : "OFF"

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.exhaustContactState })
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//
                            CusComPage.RowItemApp {
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Alarm Free Relay Contact")

                                property bool connected: false
                                value: connected ? "ON" : "OFF"

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.alarmContactState })
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//
                            CusComPage.RowItemApp {
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("M-Switch S1")

                                property bool connected: false
                                value: connected ? "ON" : "OFF"

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.magSW1State })
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//

                            CusComPage.RowItemApp {
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("M-Switch S2a")

                                property bool connected: false
                                value: connected ? "ON" : "OFF"

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.magSW2State })
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//
                            CusComPage.RowItemApp {
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("M-Switch S2b")
                                value: connected ? "ON" : "OFF"

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.magSW6State })
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//
                            CusComPage.RowItemApp {
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("M-Switch S3")

                                property bool connected: false
                                value: connected ? "ON" : "OFF"

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.magSW3State })
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//

                            CusComPage.RowItemApp {
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("M-Switch S4")

                                property bool connected: false
                                value: connected ? "ON" : "OFF"

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.magSW5State})
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//

                            CusComPage.RowItemApp {
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("M-Switch S5")
                                value: connected ? "ON" : "OFF"

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.magSW4State })
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//

                            CusComPage.RowItemApp {
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("M-Switch S6")
                                value: connected ? "ON" : "OFF"

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.sashMotorDownStuckSwitch })
                                }

                                onUnloaded: {
                                    connected = false
                                }//
                            }//
                            CusComPage.RowItemApp {
                                enabled: MachineData.frontPanelSwitchInstalled
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("M-Switch S7")
                                value: connected ? "ON" : "OFF"

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.frontPanelAlarm === MachineAPI.ALARM_ACTIVE_STATE})
                                }

                                onUnloaded: {
                                    connected = false
                                }//
                            }//
                            CusComPage.RowItemApp {
                                enabled: MachineData.seasFlapInstalled
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Seas Flap Exhaust")
                                value: connected ? "Fail" : "OK"

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.seasFlapAlarmPressure === MachineAPI.ALARM_ACTIVE_STATE})
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: moduleHdbInput
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Module - Hybrid Digital/Input")
                                value: connected ? qsTr("OK") : qsTr("Fail")

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.boardStatusHybridDigitalInput })
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: moduleHdbOutput
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Module - Hybrid Digital/Output")
                                value: connected ? qsTr("OK") : qsTr("Fail")

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.boardStatusHybridDigitalRelay })
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: moduleHabInput
                                //enabled: !MachineData.cabinetWidth3Feet
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Module - Hybrid Analog/Input")
                                value: connected ? qsTr("OK") : qsTr("Fail")

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.boardStatusHybridAnalogInput })
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: moduleHabOutputLight
                                //enabled: !MachineData.cabinetWidth3Feet
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Module - Hybrid Analog/Output")
                                value: connected ? qsTr("OK") : qsTr("Fail")

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.boardStatusHybridAnalogOutput})
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: moduleAnalogInput
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Module - Analog Input")
                                value: connected ? qsTr("OK") : qsTr("Fail")

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.boardStatusAnalogInput})
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//
                            CusComPage.RowItemApp {
                                id: moduleAnalogInput1
                                enabled: false
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Module - Analog Input 2")
                                value: connected ? qsTr("OK") : qsTr("Fail")

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.boardStatusAnalogInput1})
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//
                            CusComPage.RowItemApp {
                                id: moduleAnalogOuput
                                enabled: MachineData.cabinetWidth3Feet && !MachineData.usePwmOutSignal
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Module - Analog Output")
                                value: connected ? qsTr("OK") : qsTr("Fail")

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.boardStatusAnalogOutput})
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: modulePwmOutput
                                enabled: MachineData.usePwmOutSignal
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Module - PWM Output")
                                value: connected ? qsTr("OK") : qsTr("Fail")

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.boardStatusPWMOutput})
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: moduleRbmCom
                                enabled: !MachineData.cabinetWidth3Feet
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Module - RBM Com ") + (MachineData.getDualRbmMode() ? "(DF | IF)" : "(DF)")
                                value1: connected1 ? qsTr("OK") : qsTr("Fail")
                                value2: MachineData.getDualRbmMode() ? (connected2 ? qsTr("OK") : qsTr("Fail")) : ""

                                property bool connected1: false
                                property bool connected2: false

                                onLoaded: {
                                    connected1 = Qt.binding(function() { return MachineData.boardStatusRbmCom})
                                    if(MachineData.getDualRbmMode())
                                        connected2 = Qt.binding(function() { return MachineData.boardStatusRbmCom2})
                                }

                                onUnloaded: {
                                    connected1 = false
                                    connected2 = false
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: moduleCtpRtc
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Module - Real Time Clock")
                                value: connected ? qsTr("OK") : qsTr("Fail")

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.boardStatusCtpRtc })
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: moduleCtpIo
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Module - I/O Expander")
                                value: connected ? qsTr("OK") : qsTr("Fail")

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.boardStatusCtpIoe })
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: modulePtb
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Module - Pressure Sensor")
                                value: connected ? qsTr("OK") : qsTr("Fail")

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.boardStatusPressureDiff })
                                }

                                onUnloaded: {
                                    connected = false
                                }

                                //                                visible: enabled
                                enabled: props.seasInstalled
                            }//

                            CusComPage.RowItemApp {
                                id: envTempLimit
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Environmental temperature range")

                                onLoaded: {
                                    /// in celcius
                                    let lowest = MachineData.envTempLowestLimit
                                    let highest = MachineData.envTempHighestLimit

                                    /// 1: imperial 0: metric
                                    const meaUnit = MachineData.measurementUnit /// 1 imperial 0 metric
                                    if (meaUnit) {
                                        value = Number(lowest).toFixed() + "°F" + " - " + Number(highest).toFixed() + "°F"
                                    }
                                    else {
                                        value = Number(lowest).toFixed() + "°C" + " - " + Number(highest).toFixed() + "°C"
                                    }//
                                }//
                            }//

                            CusComPage.RowItemApp {
                                id: particleCounter
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Particel counter (μg/m3)")

                                value: "PM2.5: " + particleCounterPM2_5 +
                                       " | PM1.0: " + particleCounterPM1_0 +
                                       " | PM10: " + particleCounterPM10

                                property int particleCounterPM2_5:  0
                                property int particleCounterPM1_0:  0
                                property int particleCounterPM10:   0

                                onLoaded: {
                                    particleCounterPM2_5 = Qt.binding(function(){return MachineData.particleCounterPM2_5})
                                    particleCounterPM1_0 = Qt.binding(function(){return MachineData.particleCounterPM1_0})
                                    particleCounterPM10 = Qt.binding(function(){return MachineData.particleCounterPM10})
                                }//

                                //                                visible: enabled
                                enabled: props.particleCounterSensorInstalled
                            }//

                            CusComPage.RowItemApp {
                                id: particleCounterFanState
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Particel counter state")

                                onLoaded: {
                                    value = Qt.binding(function(){ return MachineData.particleCounterSensorFanState ? qsTr("Running") : "Sleep"})
                                }//

                                //                                visible: enabled
                                enabled: props.particleCounterSensorInstalled
                            }//

                            CusComPage.RowItemApp {
                                id: rtcWatchdogCount
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Watchdog counter")

                                onLoaded: {
                                    value = Qt.binding(function(){ return MachineData.watchdogCounter})
                                }//
                            }//

                            CusComPage.RowItemApp {
                                id: rtcDateTimeActual
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("RTC Date & Time")

                                onLoaded: {
                                    value = Qt.binding(function(){ return MachineData.rtcActualDate + " " + MachineData.rtcActualTime})
                                }//
                            }//
                        }//
                    }//

                    ScrollBarApp {
                        id: verticalScrollBar
                        Layout.fillHeight: true
                        Layout.minimumWidth: 20
                        Layout.fillWidth: false
                    }
                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: MachineAPI.FOOTER_HEIGHT

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
                                var intent = IntentApp.create(uri, {})
                                finishView(intent)
                            }
                        }//
                    }//
                }//
            }//
        }//

        UtilsApp {
            id: utilsApp
        }//

        QtObject {
            id: props

            property bool particleCounterSensorInstalled: false
            property bool seasInstalled: false
            property bool uvInstalled: false
            property bool sashWindowMotorizeInstalled: false
        }//

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                props.particleCounterSensorInstalled = Qt.binding(function(){return MachineData.particleCounterSensorInstalled})
                props.seasInstalled = Qt.binding(function(){return MachineData.seasInstalled})
                props.uvInstalled = Qt.binding(function(){return MachineData.uvInstalled})
                props.sashWindowMotorizeInstalled = Qt.binding(function(){return MachineData.sashWindowMotorizeInstalled})

            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

//                Flickable {
//                    id: view
//                    anchors.fill: parent
//                    anchors.margins: 2
//                    contentWidth: 200
//                    contentHeight: col.height
//                    property real span : contentY + height
//                    clip: true

//                    flickableDirection: Flickable.VerticalFlick

//                    Column {
//                        id: col
//                        spacing: 2

//                        Repeater {
//                            model: 50
//                            delegate: Rectangle {
//                                width: view.width
//                                height: 50
//                                color: inView ? "blue" : "red"
//                                property bool inView: y >= (view.contentY - 50) && y + height <= (view.span + 50)

//                                onColorChanged: {
//                                    //console.debug("Color Changed at " + index)
//                                }
//                            }
//                        }
//                    }
//                }

//                Rectangle {
//                    anchors.centerIn: parent
//                    width: 200
//                    height: 200
//                    color: "yellow"

//                    Flickable {
//                        id: view
//                        anchors.fill: parent
//                        anchors.margins: 2
//                        contentWidth: 200
//                        contentHeight: col.height
//                        property real span : contentY + height

//                        Column {
//                            id: col
//                            x: 90
//                            spacing: 2

//                            Repeater {
//                                model: 50
//                                delegate: Rectangle {
//                                    width: 10
//                                    height: 10
//                                    color: inView ? "blue" : "red"
//                                    property bool inView: y >= view.contentY && y + height <= view.span
//                                }
//                            }
//                        }
//                    }
//                }

//                ListView {
//                    id: list
//                    anchors.fill: parent
//                    clip: true
//                    model: 1000
//                    cacheBuffer:0
//                    delegate: Rectangle {
//                        id: dg
//                        property int yoff: Math.round(dg.y - list.contentY)
//                        property bool isFullyVisible: (yoff > list.y && yoff + height < list.y + list.height)
//                        border.color: Qt.darker(color, 1.2)
//                        color: isFullyVisible ? "#ccffcc" : "#fff"
//                        height: Math.random() * 200
//                        width: parent.width
//                        Text {text: "Fully visible:" + isFullyVisible  ; anchors.centerIn: parent}
//                    }
//                }

//                ListView {
//                    height: 100
//                    width: 100
//                    model: 5
//                    delegate: Component {
//                         {
//                            sourceComponent: Component {
//                                Text {
//                                    text: index

//                                    Component.onCompleted: {
//                                        //console.debug("Hello")
//                                    }
//                                }    //okay
//                            }
//                        }
//                    }
//                }

//                Column {
//                    anchors.centerIn: parent

//                    TextApp {
//                        anchors.horizontalCenter: parent.horizontalCenter
//                        text: lightIntensitySlider.value + "%"
//                    }

//                    Slider {
//                        id: lightIntensitySlider
//                        anchors.horizontalCenter: parent.horizontalCenter
//                        width: 500
//                        stepSize: 5
//                        from: 30
//                        to: 100

//                        onValueChanged: {
//                            if (pressed) {
//                                MachineProxy.setLightIntensity(value)
//                            }
//                        }
//                    }
//                }

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:3000;width:800}
}
##^##*/
