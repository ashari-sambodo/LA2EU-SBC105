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

import UI.CusCom 1.0
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

                                label: qsTr("Fan state")

                                onLoaded: {
                                    value = Qt.binding(function(){
                                        return MachineData.fanPrimaryDutyCycle + "% / " + MachineData.fanPrimaryRpm + " RPM"
                                    })
                                }

                                onUnloaded: {
                                    value = ""
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: fanUsage
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Fan usage meter")

                                onLoaded: {
                                    value = Qt.binding(function(){
                                        let meter = MachineData.fanUsageMeter * 60
                                        if (meter === 0) return qsTr("Never used")
                                        return utilsApp.strfSecsToHumanReadableShort(meter)
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
                                        return MachineData.filterLifePercent + "%"
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
                                            return MachineData.getInflowTempCalib()+ "°F"
                                        else
                                            return MachineData.getInflowTempCalib()+ "°C"
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
                                    value = Qt.binding(function(){return MachineData.getInflowTempCalibAdc()})
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

                                label: qsTr("ADC IFA")

                                onLoaded: {
                                    value = Qt.binding(function(){return MachineData.ifaAdcConpensation})
                                }

                                onUnloaded: {
                                    value = ""
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: ifnADC
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("ADC IFN")

                                onLoaded: {
                                    if (MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD) {
                                        value = MachineData.getInflowAdcPointField(2);
                                    }
                                    else {
                                        value = MachineData.getInflowAdcPointFactory(2);
                                    }
                                }

                            }//

                            CusComPage.RowItemApp {
                                id: iffADC
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("ADC IFF")

                                onLoaded: {
                                    if (MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD) {
                                        value = MachineData.getInflowAdcPointField(1);
                                    }
                                    else {
                                        value = MachineData.getInflowAdcPointFactory(1);
                                    }
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: if2ADC
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("ADC IF2")

                                onLoaded: {
                                    value = MachineData.getInflowAdcPointFactory(2);
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: if1ADC
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("ADC IF1")

                                onLoaded: {
                                    value = MachineData.getInflowAdcPointFactory(1);
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: if0ADC
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("ADC IF0")

                                onLoaded: {
                                    value = MachineData.getInflowAdcPointFactory(0);
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: ifnVel
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("VEL IFN")

                                onLoaded: {
                                    let velocity = 0
                                    if (MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD) {
                                        velocity = MachineData.getInflowVelocityPointField(2) / 100
                                    }
                                    else {
                                        velocity = MachineData.getInflowVelocityPointFactory(2) / 100
                                    }

                                    let velocityStr = ""
                                    if (MachineData.measurementUnit) {
                                        /// imperial
                                        velocityStr = velocity.toFixed() + " fpm"
                                    }
                                    else {
                                        /// metric
                                        velocityStr = velocity.toFixed(2) + " m/s"
                                    }

                                    value = velocityStr
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: iffVel
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("VEL IFF")

                                onLoaded: {
                                    let velocity = 0
                                    if (MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD) {
                                        velocity = MachineData.getInflowVelocityPointField(1) / 100
                                    }
                                    else {
                                        velocity = MachineData.getInflowVelocityPointFactory(1) / 100
                                    }

                                    let velocityStr = ""
                                    if (MachineData.measurementUnit) {
                                        /// imperial
                                        velocityStr = velocity.toFixed() + " fpm"
                                    }
                                    else {
                                        /// metric
                                        velocityStr = velocity.toFixed(2) + " m/s"
                                    }

                                    value = velocityStr
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: if2Vel
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("VEL IF2")

                                onLoaded: {
                                    let velocity = 0
                                    velocity = MachineData.getInflowVelocityPointFactory(2) / 100

                                    let velocityStr = ""
                                    if (MachineData.measurementUnit) {
                                        /// imperial
                                        velocityStr = velocity.toFixed() + " fpm"
                                    }
                                    else {
                                        /// metric
                                        velocityStr = velocity.toFixed(2) + " m/s"
                                    }

                                    value = velocityStr
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: if1Vel
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("VEL IF1")

                                onLoaded: {
                                    let velocity = 0
                                    velocity = MachineData.getInflowVelocityPointFactory(1) / 100

                                    let velocityStr = ""
                                    if (MachineData.measurementUnit) {
                                        /// imperial
                                        velocityStr = velocity.toFixed() + " fpm"
                                    }
                                    else {
                                        /// metric
                                        velocityStr = velocity.toFixed(2) + " m/s"
                                    }

                                    value = velocityStr
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: dfnVel
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("VEL DFN")

                                onLoaded: {
                                    let velocity = 0
                                    if (MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD) {
                                        velocity = MachineData.getDownflowVelocityPointField(2) / 100
                                    }
                                    else {
                                        velocity = MachineData.getDownflowVelocityPointFactory(2) / 100
                                    }

                                    let velocityStr = ""
                                    if (MachineData.measurementUnit) {
                                        /// imperial
                                        velocityStr = velocity.toFixed() + " fpm"
                                    }
                                    else {
                                        /// metric
                                        velocityStr = velocity.toFixed(2) + " m/s"
                                    }

                                    value = velocityStr
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: df2Vel
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("VEL DF2")

                                onLoaded: {
                                    let velocity = 0
                                    velocity = MachineData.getDownflowVelocityPointFactory(2) / 100

                                    let velocityStr = ""
                                    if (MachineData.measurementUnit) {
                                        /// imperial
                                        velocityStr = velocity.toFixed() + " fpm"
                                    }
                                    else {
                                        /// metric
                                        velocityStr = velocity.toFixed(2) + " m/s"
                                    }

                                    value = velocityStr
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: ifaSensorConstVel
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Sensor Contant")

                                onLoaded: {
                                    value = MachineData.getInflowSensorConstant()
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: fanDutyCycleNom
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Fan Nominal")

                                onLoaded: {
                                    if (MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD) {
                                        const ducy = MachineData.getFanPrimaryNominalDutyCycleField()
                                        const rpm = MachineData.getFanPrimaryNominalRpmField()

                                        value = ducy + "%" + " / " + rpm + " RPM"
                                    }
                                    else {
                                        const ducy = MachineData.getFanPrimaryNominalDutyCycleFactory()
                                        const rpm = MachineData.getFanPrimaryNominalRpmFactory()

                                        value = ducy + "%" + " / " + rpm + " RPM"
                                    }
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: fanDutyCycleMin
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Fan Minimum")

                                onLoaded: {
                                    if (MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD) {
                                        const ducy = MachineData.getFanPrimaryMinimumDutyCycleField()
                                        const rpm = MachineData.getFanPrimaryMinimumRpmField()

                                        value = ducy + "%" + " / " + rpm + " RPM"
                                    }//
                                    else {
                                        const ducy = MachineData.getFanPrimaryMinimumDutyCycleFactory()
                                        const rpm = MachineData.getFanPrimaryMinimumRpmFactory()

                                        value = ducy + "%" + " / " + rpm + " RPM"
                                    }//
                                }//
                            }//

                            CusComPage.RowItemApp {
                                id: fanStandbyDutyCycle
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Fan Standby")

                                onLoaded: {
                                    if (MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD) {
                                        const ducy = MachineData.getFanPrimaryStandbyDutyCycleField()
                                        const rpm = MachineData.getFanPrimaryStandbyRpmField()

                                        value = ducy + "%" + " / " + rpm + " RPM"
                                    }
                                    else {
                                        const ducy = MachineData.getFanPrimaryStandbyDutyCycleFactory()
                                        const rpm = MachineData.getFanPrimaryStandbyRpmFactory()

                                        value = ducy + "%" + " / " + rpm + " RPM"
                                    }
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: fanDutyCycleNomFactory
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Fan IF2")

                                onLoaded: {
                                    const ducy = MachineData.getFanPrimaryNominalDutyCycleFactory()
                                    const rpm = MachineData.getFanPrimaryNominalRpmFactory()

                                    value = ducy + "%" + " / " + rpm + " RPM"
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: fanDutyCycleMinFactory
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Fan IF1")

                                onLoaded: {
                                    const ducy = MachineData.getFanPrimaryMinimumDutyCycleFactory()
                                    const rpm = MachineData.getFanPrimaryMinimumRpmFactory()

                                    value = ducy + "%" + " / " + rpm + " RPM"
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: fanDutyCycleStbFactory
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Fan IFS")

                                onLoaded: {
                                    const ducy = MachineData.getFanPrimaryStandbyDutyCycleFactory()
                                    const rpm = MachineData.getFanPrimaryStandbyRpmFactory()

                                    value = ducy + "%" + " / " + rpm + " RPM"
                                }
                            }//

                            //                            CusComPage.RowItemApp {
                            //                                id: rtcTime
                            //                                width: view.width
                            //                                height: 50
                            //                                viewContentY: view.contentY
                            //                                viewSpan: view.span

                            //                                label: qsTr("RTC Time")

                            //                                onValueChanged: {
                            //                                    //console.debug("value changed in diagnostics")
                            //                                }

                            //                                Loader {
                            //                                    active: parent.loaderActive
                            //                                    sourceComponent: QtObject{
                            //                                        Component.onCompleted: {
                            //                                            rtcTime.value = Qt.binding(function(){return MachineData.count})
                            //                                        }//
                            //                                    }//
                            //                                }//
                            //                            }//

                            //                            CusComPage.RowItemApp {
                            //                                id: rtcWatchdog
                            //                                width: view.width
                            //                                height: 50
                            //                                viewContentY: view.contentY
                            //                                viewSpan: view.span

                            //                                label: qsTr("Watchdog")

                            //                                Loader {
                            //                                    active: parent.loaderActive
                            //                                    sourceComponent: QtObject{
                            //                                        Component.onCompleted: {
                            //                                            rtcWatchdog.value = Qt.binding(function(){return MachineData.count})
                            //                                        }//
                            //                                    }//
                            //                                }//
                            //                            }//

                            CusComPage.RowItemApp {
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("M-Switch S1")

                                property bool connected: false
                                value: connected ? 1 : 0

                                onLoaded: {
                                    connected = Qt.binding(function() { return !MachineData.magSW1State })
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

                                label: qsTr("M-Switch S2")

                                property bool connected: false
                                value: connected ? 1 : 0

                                onLoaded: {
                                    connected = Qt.binding(function() { return !MachineData.magSW2State })
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
                                value: connected ? 1 : 0

                                onLoaded: {
                                    connected = Qt.binding(function() { return !MachineData.magSW3State })
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
                                value: connected ? 1 : 0

                                onLoaded: {
                                    connected = Qt.binding(function() { return !MachineData.magSW5State})
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
                                value: connected ? 1 : 0

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return !MachineData.magSW4State })
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
                                value: connected ? 1 : 0

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return !MachineData.magSW6State })
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//
                            CusComPage.RowItemApp {
                                visible: MachineData.seasFlapInstalled
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
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Module - Hybrid Analog/Output (Light)")
                                value: connected ? qsTr("OK") : qsTr("Fail")

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.boardStatusHybridAnalogOutput1 })
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: moduleHabOutputFan
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Module - Hybrid Analog/Output (Fan Inflow)")
                                value: connected ? qsTr("OK") : qsTr("Fail")

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.boardStatusHybridAnalogOutput2 })
                                }

                                onUnloaded: {
                                    connected = false
                                }
                            }//

                            CusComPage.RowItemApp {
                                id: moduleRbmCom
                                width: view.width
                                height: 50
                                viewContentY: view.contentY
                                viewSpan: view.span

                                label: qsTr("Module - RBM Com")
                                value: connected ? qsTr("OK") : qsTr("Fail")

                                property bool connected: false

                                onLoaded: {
                                    connected = Qt.binding(function() { return MachineData.boardStatusRbmCom })
                                }

                                onUnloaded: {
                                    connected = false
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
