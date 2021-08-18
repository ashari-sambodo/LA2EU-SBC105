﻿import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

import UI.CusCom 1.0
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Full Calibrate Sensor"

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
                    id: headerApp
                    anchors.fill: parent
                    title: qsTr(viewApp.title)
                }//
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                /// Handle sub menu with StackView

                ColumnLayout {
                    anchors.fill: parent

                    Item {
                        Layout.fillWidth: true
                        Layout.minimumHeight: 200

                        PageIndicator {
                            id: calibrationPhasePageIndicator
                            anchors.centerIn: parent
                            count: 2
                            //                            currentIndex: menuItemView.currentIndex > 3 ? 1 : 0

                            property var title: [qsTr("Cabinet"), qsTr("Microprocessor ADC")]

                            delegate: Rectangle {
                                implicitWidth: 250
                                implicitHeight: 50
                                radius: 10
                                color: "#0F2952"

                                opacity: index === calibrationPhasePageIndicator.currentIndex ? 0.95 : pressed ? 0.7 : 0.45

                                TextApp {
                                    anchors.fill: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: (index + 1) + ") " + calibrationPhasePageIndicator.title[index]
                                }//

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        calibrationPhasePageIndicator.currentIndex = index
                                        if(menuStackView.depth > 1) menuStackView.clear()
                                        if (index == 0){
                                            menuStackView.replace(menuGridViewComponent, {"model": props.menuModelCabinet}, StackView.PopTransition)
                                        }
                                        else if(index == 1) {
                                            menuStackView.replace(menuGridViewComponent, {"model": props.menuModelMicroADC}, StackView.PushTransition)
                                        }
                                    }//
                                }//
                            }//
                        }//
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        StackView {
                            id: menuStackView
                            anchors.fill: parent
                        }//
                    }//
                }//

                /// Menu Component
                Component {
                    id: menuGridViewComponent

                    Item {
                        property alias model: menuItemView.model
                        property alias currentIndex: menuItemView.currentIndex
                        property alias listviewContentX: menuItemView.contentX

                        ListView {
                            id: menuItemView
                            anchors.fill: parent
                            //                            height: 250
                            //                            width: parent.width
                            //                            anchors.verticalCenter: parent.verticalCenter
                            clip: true
                            snapMode: ListView.SnapToItem
                            flickableDirection: Flickable.AutoFlickIfNeeded
                            orientation: ListView.Horizontal

                            ScrollBar.horizontal: ScrollBar{}

                            //                                    highlightMoveDuration: 1000
                            //                                    highlightMoveVelocity: -1
                            //                                    highlightRangeMode: ListView.ApplyRange

                            delegate: Item{
                                height: 250
                                width: 250
                                opacity:  iconMouseArea.pressed ? 0.5 : 1

                                ColumnLayout{
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 0

                                    //                            Rectangle {
                                    //                                anchors.fill: parent
                                    //                            }

                                    Item {
                                        id: picIconItem
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true

                                        //                Rectangle{anchors.fill: parent}

                                        Image {
                                            id: picIconImage
                                            source: modelData.micon ? modelData.micon : ""
                                            fillMode: Image.PreserveAspectFit
                                            anchors.fill: parent
                                        }

                                        Loader {
                                            id: badgeLoader
                                            anchors.right: parent.right
                                            active: modelData.badge === 1
                                            sourceComponent: TextApp {
                                                id: badgeText
                                                padding: 2
                                                text: modelData.badgeText

                                                Rectangle {
                                                    z: -1
                                                    color: "#27ae60"
                                                    anchors.fill: parent
                                                    radius: 5
                                                }//
                                            }//
                                        }//
                                    }//

                                    Item {
                                        id: iconTextItem
                                        Layout.minimumHeight: parent.height* 0.35
                                        Layout.fillWidth: true

                                        //                Rectangle{anchors.fill: parent}

                                        Text {
                                            id: iconText
                                            text: modelData.mtitle ? ((index + 1) + ") " + modelData.mtitle) : ""
                                            height: parent.height
                                            width: parent.width
                                            wrapMode: Text.WordWrap
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignTop
                                            color: "#dddddd"
                                            font.pixelSize: 20
                                        }//
                                    }//
                                }//

                                MouseArea{
                                    id: iconMouseArea
                                    anchors.fill: parent
                                    onClicked: {
                                        if (modelData.mtype === "submenu") {
                                            menuStackView.push(menuGridViewComponent, {"model": modelData.submenu})
                                        }else {
                                            props.lastSelectedMenuIndex = index
                                            props.openPage(modelData.pid, modelData.mlink, modelData.mtitle)
                                        }
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
                                if(menuStackView.depth > 1) {
                                    menuStackView.pop()
                                }
                                else {
                                    var intent = IntentApp.create(uri, {})
                                    finishView(intent)
                                }
                            }//
                        }//
                    }//
                }//
            }//
        }//

        QtObject {
            id: props

            function openPage(pid, uri, title){

                if (pid === 'meaifanom'){
                    let calibrateReq = props.calibrateReqValues['measure']['ifa']['nominal']

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      'grid': props.meaIfaNominalGrid,
                                                      'fanDutyCycle': props.fanDutyCycleNominal,
                                                      'calibrateReq': calibrateReq
                                                  })
                    startView(intent)
                }
                else if (pid === 'meaifamin'){
                    let calibrateReq = props.calibrateReqValues['measure']['ifa']['minimum']

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      //                                                      'grid': grid,
                                                      'grid': props.meaIfaMinimumGrid,
                                                      'fanDutyCycle': props.fanDutyCycleMinimum,
                                                      'calibrateReq': calibrateReq
                                                  })
                    startView(intent)
                }
                else if (pid === 'meaifastb'){
                    let calibrateReq = props.calibrateReqValues['measure']['ifa']['stb']

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      'grid': props.meaIfaStandbyGrid,
                                                      'fanDutyCycle': props.fanDutyCycleStandby,
                                                      'calibrateReq': calibrateReq
                                                  })
                    startView(intent)
                }
                else if (pid === 'meadfanom'){
                    let calibrateReq = props.calibrateReqValues['measure']['dfa']['nominal']

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      'grid': props.meaDfaNominalGrid,
                                                      'fanDutyCycle': props.fanDutyCycleNominal,
                                                      'calibrateReq': calibrateReq
                                                  })
                    startView(intent)
                }
                else if (pid === 'senconst'){
                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      "sensorConstant": props.sensorConstant
                                                  })
                    startView(intent)
                }
                else if (pid === 'adcz'){

                    let intent = IntentApp.create(uri,{"pid": pid})
                    startView(intent)
                }
                else if (pid === 'adcm'){
                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      "measureUnit": props.measurementUnit,
                                                      "sensorAdcZero": props.sensorAdcZero,
                                                      "sensorVelMinimum": props.sensorVelMinimum / 100,
                                                      "sensorVelLowAlarm": props.sensorVelLowAlarm / 100,
                                                      'fanDutyCycle': props.fanDutyCycleMinimum
                                                  })
                    startView(intent)
                }
                else if (pid === 'adcn'){

                    if(props.calibNewSensorConst && (!props.calibNewAdcZero || !props.calibNewAdcMin)){
                        const message = "<b>" + qsTr("You have changed the sensor constant.") + "</b>" + "<br><br>" +
                                      qsTr("It's mandatory to re-calibrate ADC Zero and Minimum before going to ADC Nominal!")
                        showDialogMessage(qsTr("Notification"), message, dialogAlert, function(){}, false)
                        return
                    }
                    else if(!props.calibNewAdcMin){
                        const message = "<b>" + qsTr("ADC Minimum not calibrated yet!") + "</b>" + "<br><br>" +
                                      qsTr("It's mandatory to calibrate ADC Minimum before going to ADC Nominal!")
                        showDialogMessage(qsTr("Notification"), message, dialogAlert, function(){}, false)
                        return
                    }

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      "measureUnit": props.measurementUnit,
                                                      "sensorAdcZero": props.sensorAdcZero,
                                                      "sensorAdcMinimum": props.sensorAdcMinimum,
                                                      "sensorVelMinimum": props.sensorVelMinimum / 100,
                                                      "sensorVelNominal": props.sensorVelNominal / 100,
                                                      "sensorVelNominalDfa": props.sensorVelNominalDfa / 100,
                                                      'fanDutyCycle': props.fanDutyCycleNominal
                                                  })
                    startView(intent)
                }
                else {
                    let intent = IntentApp.create(uri, {"pid": pid})
                    startView(intent)
                }
            }//

            function initCalibrateSpecs(profile){
                let meaUnitStr = props.measurementUnit ? 'imp' : 'metric'

                /// inflow
                for (const label of ['nominal', 'minimum', 'stb']){
                    //                    //console.debug(item)
                    props.calibrateReqValues['measure']['ifa'][label]['volume']             = profile['airflow']['ifa']['dim'][label][meaUnitStr]['volume']
                    props.calibrateReqValues['measure']['ifa'][label]['velocity']           = profile['airflow']['ifa']['dim'][label][meaUnitStr]['velocity']
                    props.calibrateReqValues['measure']['ifa'][label]['velocityTol']        = profile['airflow']['ifa']['dim'][label][meaUnitStr]['velocityTol']
                    props.calibrateReqValues['measure']['ifa'][label]['velocityTolLow']     = profile['airflow']['ifa']['dim'][label][meaUnitStr]['velocityTolLow']
                    props.calibrateReqValues['measure']['ifa'][label]['velocityTolHigh']    = profile['airflow']['ifa']['dim'][label][meaUnitStr]['velocityTolHigh']
                    props.calibrateReqValues['measure']['ifa'][label]['openingArea']        = profile['airflow']['ifa']['dim'][label][meaUnitStr]['openingArea']
                    props.calibrateReqValues['measure']['ifa'][label]['gridCount']          = profile['airflow']['ifa']['dim']['gridCount']
                }//

                if (MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD) {
                    props.fanDutyCycleNominal = MachineData.getFanPrimaryNominalDutyCycleField()
                    props.fanDutyCycleMinimum = MachineData.getFanPrimaryMinimumDutyCycleField()
                    props.fanDutyCycleStandby = MachineData.getFanPrimaryStandbyDutyCycleField()
                }
                else if(MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FACTORY){
                    props.fanDutyCycleNominal = MachineData.getFanPrimaryNominalDutyCycleFactory()
                    props.fanDutyCycleMinimum = MachineData.getFanPrimaryMinimumDutyCycleFactory()
                    props.fanDutyCycleStandby = MachineData.getFanPrimaryStandbyDutyCycleFactory()
                }
                else{
                    props.fanDutyCycleNominal = profile['airflow']['ifa']['dim']['nominal']['fanDutyCycle']
                    props.fanDutyCycleMinimum = profile['airflow']['ifa']['dim']['minimum']['fanDutyCycle']
                    props.fanDutyCycleStandby = profile['airflow']['ifa']['dim']['stb']['fanDutyCycle']
                }

                /// downflow
                props.calibrateReqValues['measure']['dfa']['nominal']['velocity']          = profile['airflow']['dfa']['nominal'][meaUnitStr]['velocity']
                props.calibrateReqValues['measure']['dfa']['nominal']['velocityTol']       = profile['airflow']['dfa']['nominal'][meaUnitStr]['velocityTol']
                props.calibrateReqValues['measure']['dfa']['nominal']['velocityTolLow']    = profile['airflow']['dfa']['nominal'][meaUnitStr]['velocityTolLow']
                props.calibrateReqValues['measure']['dfa']['nominal']['velocityTolHigh']   = profile['airflow']['dfa']['nominal'][meaUnitStr]['velocityTolHigh']
                props.calibrateReqValues['measure']['dfa']['nominal']['velDevp']           = profile['airflow']['dfa']['nominal']['velDevp']
                props.calibrateReqValues['measure']['dfa']['nominal']['grid']['count']     = profile['airflow']['dfa']['nominal']['grid']['count']
                props.calibrateReqValues['measure']['dfa']['nominal']['grid']['columns']   = profile['airflow']['dfa']['nominal']['grid']['columns']

                //                ///demo
                //                props.fanDutyCycleNominal = 5
                //                props.fanDutyCycleMinimum = 3
                //                props.fanDutyCycleStandby = 1

            }//

            /// Just remember, which last menu index number was selected
            /// this required to modified badge status on each menu item
            property int lastSelectedMenuIndex: 0

            property var menuModelCabinet: [
                {
                    mtype      : "menu",
                    mtitle     : qsTr("Measure Inflow Nominal"),
                    micon      : "qrc:/UI/Pictures/menu/ifa_dim_nom_measure.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureInflowDimSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid        : "meaifanom",
                },
                {
                    mtype      : "menu",
                    mtitle     : qsTr("Measure Inflow Minimum"),
                    micon      : "qrc:/UI/Pictures/menu/ifa_dim_min_measure.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureInflowDimSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid         : "meaifamin",
                },
                {
                    mtype         : "menu",
                    mtitle     : qsTr("Measure Inflow Standby"),
                    micon      : "qrc:/UI/Pictures/menu/ifa_dim_stb_measure.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureInflowDimSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid         : "meaifastb",
                },
                {
                    mtype         : "menu",
                    mtitle     : qsTr("Measure Downflow"),
                    micon      : "qrc:/UI/Pictures/menu/dfa_measure.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureDownflowSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid         : "meadfanom",
                },
            ]//
            property var menuModelMicroADC: [
                {
                    mtype      : "menu",
                    mtitle     : qsTr("Sensor Constant"),
                    micon      : "qrc:/UI/Pictures/menu/Set-Constant.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/SensorConstantSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid        : "senconst",
                },
                {
                    mtype      : "menu",
                    mtitle     : qsTr("ADC Zero (IF0)"),
                    micon      : "qrc:/UI/Pictures/menu/Zero-Sensor.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/ADCZeroSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid        : "adcz",
                },
                {
                    mtype      : "menu",
                    mtitle     : qsTr("ADC Minimum (IF1)"),
                    micon      : "qrc:/UI/Pictures/menu/Calibrate-Sensor.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/ADCMinimumSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid        : "adcm",
                },
                {
                    mtype      : "menu",
                    mtitle     : qsTr("ADC Nominal (IF2)"),
                    micon      : "qrc:/UI/Pictures/menu/Calibrate-Sensor.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/ADCNominalSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid        : "adcn",
                }
            ]//

            property var calibrateReqValues: {
                "measure": {
                    "ifa": {
                        "nominal": {
                            "volume": 0,
                            "velocity": 0,
                            "velocityTol": 0,
                            "velocityTolLow": 0,
                            "velocityTolHigh": 0,
                            "openingArea": 0,
                            "gridCount": 0,
                        },
                        "minimum": {
                            "volume": 0,
                            "velocity": 0,
                            "velocityTol": 0,
                            "velocityTolLow": 0,
                            "velocityTolHigh": 0,
                            "openingArea": 0,
                            "gridCount": 0,
                        },
                        "stb": {
                            "volume": 0,
                            "velocity": 0,
                            "velocityTol": 0,
                            "velocityTolLow": 0,
                            "velocityTolHigh": 0,
                            "openingArea": 0,
                            "gridCount": 0,
                        }
                    },//
                    "dfa": {
                        "nominal": {
                            "velocity": 0,
                            "velocityTol": 0,
                            "velocityTolLow": 0,
                            "velocityTolHigh": 0,
                            "velDevp": 0, /*%*/
                            'grid': {
                                'count': 0,
                                'columns': 0,
                            }
                        },
                    }//
                },
            }//

            property int operationModeBackup: 0

            property bool calibNewInflowNom:    false
            property bool calibNewInflowMin:    false
            property bool calibNewInflowStb:    false
            property bool calibNewDownflowNom:  false
            property bool calibNewSensorConst:  false
            property bool calibNewAdcZero:      false
            property bool calibNewAdcMin:       false
            property bool calibNewAdcNom:       false

            property var meaIfaNominalGrid:     []
            property int meaIfaNominalVolume:   0
            property int meaIfaNominalVelocity: 0
            property int meaIfaNominalVolTotal: 0
            property int meaIfaNominalVolAvg:   0

            property var meaIfaMinimumGrid:     []
            property int meaIfaMinimumVolume:   0
            property int meaIfaMinimumVelocity: 0
            property int meaIfaMinimumVolTotal: 0
            property int meaIfaMinimumVolAvg:   0

            property var meaIfaStandbyGrid:     []
            property int meaIfaStandbyVolume:   0
            property int meaIfaStandbyVelocity: 0
            property int meaIfaStandbyVolTotal: 0
            property int meaIfaStandbyVolAvg:   0

            property var meaDfaNominalGrid:                 []
            property int meaDfaNominalVelocityTotal:          0
            property int meaDfaNominalVelocity:             0
            property int meaDfaNominalVelocityLowest:       0
            property int meaDfaNominalVelocityHighest:      0
            property int meaDfaNominalVelocityDeviation:    0
            property int meaDfaNominalVelocityDeviationp:   0

            property int sensorConstant: 0

            property int sensorAdcZero: 0
            property int sensorAdcMinimum: 0
            property int sensorAdcNominal: 0

            property int sensorVelStandby: 0 /*+ 40*/
            property int sensorVelMinimum: 0 /*+ 40*/
            property int sensorVelNominal: 0 /*+ 53*/

            property int sensorVelLowAlarm: 0

            property int sensorVelNominalDfa: 0 /*+ 33*/

            property int fanDutyCycleNominal: 0 /*+ 15*/
            property int fanDutyCycleMinimum: 0 /*+ 10*/
            property int fanDutyCycleStandby: 0 /*+ 5*/

            property int temperatureCalib: 0
            property int temperatureAdcCalib: 0

            property int fanRpmNominal: 0
            property int fanRpmMinimum: 0
            property int fanRpmStandby: 0

            property int measurementUnit: 0

            function saveCalibrationData(){
                //                /// demo
                //                props.fanDutyCycleNominal = 15
                //                props.fanDutyCycleMinimum = 10
                //                props.fanDutyCycleStandby = 5

                //                props.fanRpmNominal = 500
                //                props.fanRpmMinimum = 300
                //                props.fanRpmStandby = 100

                //                props.sensorConstant = 53

                //                props.sensorAdcZero     = 150
                //                props.sensorAdcMinimum  = 1000
                //                props.sensorAdcNominal  = 2000

                //                props.sensorVelMinimum      = 40
                //                props.sensorVelNominal      = 53
                //                props.sensorVelNominalDfa   = 30

                if (!props.calibNewAdcNom) {
                    //                    const message = "<b>" + qsTr("No valid calibration value!") + "</b>" + "<br><br>" +
                    //                                  qsTr("Ensure the sonsor constant and all ADC values has been calibrated.")
                    //                    viewApp.showDialogMessage(qsTr("Notification"), message, dialogAlert)
                    return
                }

                viewApp.showBusyPage(qsTr("Setting up..."), function(cycle){
                    if (cycle === 5) {

                        /// Goto finished page
                        const intent = IntentApp.create("qrc:/UI/Pages/FullCalibrateSensorPage/Pages/_FinishCalibratePage.qml", {})
                        finishView(intent);

                        //                                        viewApp.dialogObject.close()
                    }
                })

                //                console.log("grid " + props.meaIfaNominalGrid)
                //                console.log("grid " + props.meaIfaNominalVolTotal)
                //                console.log("grid " + props.meaIfaNominalVolAvg)
                //                console.log("true atau false "+ props.calibNewInflowNom)

                if (props.calibNewSensorConst) {
                    MachineAPI.setInflowSensorConstant(props.sensorConstant);
                }

                /// clear field calibration
                MachineAPI.setInflowAdcPointField(0, 0, 0)
                MachineAPI.setInflowVelocityPointField(0, 0, 0)

                /// save new full calibration data
                MachineAPI.setInflowAdcPointFactory(props.sensorAdcZero, props.sensorAdcMinimum, props.sensorAdcNominal)
                MachineAPI.setInflowVelocityPointFactory(0, props.sensorVelMinimum, props.sensorVelNominal)
                MachineAPI.setDownflowVelocityPointFactory(0, 0, props.sensorVelNominalDfa)

                MachineAPI.setInflowLowLimitVelocity(props.sensorVelLowAlarm);

                MachineAPI.setInflowTemperatureCalib(props.temperatureCalib, props.temperatureAdcCalib)

                MachineAPI.setFanPrimaryNominalDutyCycleFactory(props.fanDutyCycleNominal)
                MachineAPI.setFanPrimaryMinimumDutyCycleFactory(props.fanDutyCycleMinimum)
                MachineAPI.setFanPrimaryStandbyDutyCycleFactory(props.fanDutyCycleStandby)

                MachineAPI.setFanPrimaryNominalRpmFactory(props.fanRpmNominal)
                MachineAPI.setFanPrimaryMinimumRpmFactory(props.fanRpmMinimum)
                MachineAPI.setFanPrimaryStandbyRpmFactory(props.fanRpmStandby)


                if (props.calibNewInflowNom){
                    MachineAPI.saveInflowMeaDimNominalGrid(props.meaIfaNominalGrid,
                                                           props.meaIfaNominalVolTotal,
                                                           props.meaIfaNominalVolAvg,
                                                           props.meaIfaNominalVolume,
                                                           props.meaIfaNominalVelocity,
                                                           props.fanDutyCycleNominal,
                                                           props.fanRpmNominal)


                }

                if (props.calibNewInflowMin) {
                    MachineAPI.saveInflowMeaDimMinimumGrid(props.meaIfaMinimumGrid,
                                                           props.meaIfaMinimumVolTotal,
                                                           props.meaIfaMinimumVolAvg,
                                                           props.meaIfaMinimumVolume,
                                                           props.meaIfaMinimumVelocity,
                                                           props.fanDutyCycleMinimum,
                                                           props.fanRpmMinimum)
                }

                if (props.calibNewInflowStb) {
                    MachineAPI.saveInflowMeaDimStandbyGrid(props.meaIfaStandbyGrid,
                                                           props.meaIfaStandbyVolTotal,
                                                           props.meaIfaStandbyVolAvg,
                                                           props.meaIfaStandbyVolume,
                                                           props.meaIfaStandbyVelocity,
                                                           props.fanDutyCycleStandby,
                                                           props.fanRpmStandby)
                }

                if (props.calibNewDownflowNom) {
                    MachineAPI.saveDownflowMeaNominalGrid(props.meaDfaNominalGrid,
                                                          props.meaDfaNominalVelocityTotal,
                                                          props.meaDfaNominalVelocity,
                                                          props.meaDfaNominalVelocityLowest,
                                                          props.meaDfaNominalVelocityHighest,
                                                          props.meaDfaNominalVelocityDeviation,
                                                          props.meaDfaNominalVelocityDeviationp)
                }

                MachineAPI.initAirflowCalibrationStatus(MachineAPI.AF_CALIB_FACTORY);

                ///EVENT LOG
                const message = qsTr("User: Full calibration sensor")
                              + "("
                              + "ADC-IFZ: " + props.sensorAdcZero + ", "
                              + "ADC-IF1: " + props.sensorAdcMinimum + ", "
                              + "ADC-IF2: " + props.sensorAdcNominal + ", "
                              + "VEL-IF1: " + (props.sensorVelMinimum / 100).toFixed(2) + ", "
                              + "VEL-IF2: " + (props.sensorVelNominal / 100).toFixed(2) + ", "
                              + ")"
                MachineAPI.insertEventLog(message);
            }
        }//

        /// called Once but after onResume
        Component.onCompleted: {
            menuStackView.push(menuGridViewComponent, {"model": props.menuModelCabinet})

            props.measurementUnit = MachineData.measurementUnit

            MachineAPI.setOperationMaintenanceMode();
            //            props.operationModeBackup = MachineData.operationMode
            //            MachineAPI.setOperationMode(MachineAPI.MODE_OPERATION_MAINTENANCE)

            viewApp.showBusyPage(qsTr("Please wait!"),
                                 function onCallback(cycle){
                                     //                                    //console.debug(cycle)
                                     ///force to close
                                     if(cycle === 20) {
                                         viewApp.dialogObject.close()
                                     }

                                     if(cycle === 1) {

                                         props.sensorConstant       = MachineData.getInflowSensorConstant();
                                         props.sensorAdcZero        = MachineData.getInflowAdcPointFactory(0);
                                         props.sensorAdcMinimum     = MachineData.getInflowAdcPointFactory(1);
                                         props.sensorVelMinimum     = MachineData.getInflowVelocityPointFactory(1);
                                         props.sensorVelNominal     = MachineData.getInflowVelocityPointFactory(2);
                                         props.sensorVelNominalDfa  = MachineData.getDownflowVelocityPointFactory(2);

                                         props.sensorVelLowAlarm    = MachineData.getInflowLowLimitVelocity();

                                         props.initCalibrateSpecs(MachineData.machineProfile)
                                     }

                                     viewApp.dialogObject.close()
                                 })

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: Item {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active-" + viewApp.uri);
            }//

            /// onPause
            Component.onDestruction: {
                //                    //console.debug("StackView.DeActivating");
            }

            Connections{
                target: viewApp

                function onFinishViewReturned(intent){
                    //                        //console.debug("onFinishViewReturned-" + viewApp.uri)

                    let extradata = IntentApp.getExtraData(intent)

                    if (extradata['pid'] === 'meaifanom'){

                        //                            //console.debug(JSON.stringify(extradata['result']['grid']))
                        props.meaIfaNominalGrid             = extradata['calibrateRes']['grid']
                        props.meaIfaNominalVolume           = extradata['calibrateRes']['volume']
                        props.meaIfaNominalVolTotal         = extradata['calibrateRes']['volTotal']
                        props.meaIfaNominalVolAvg           = extradata['calibrateRes']['volAvg']

                        //                            props.meaIfaNominalVolumeLowest     = extradata['calibrateRes']['volLow']
                        //                            props.meaIfaNominalVolumeHighest    = extradata['calibrateRes']['volHigh']
                        let velocity = extradata['calibrateRes']['velocity']
                        //                            //console.debug(velocity)
                        props.meaIfaNominalVelocity = Math.round(velocity * 100)
                        //                            props.calibrateResValues['measure']['ifa']['nominal']['grid'] = extradata['calibrateRes']['grid']
                        //                            //console.debug(JSON.stringify(extradata['calibrateRes']['grid']))

                        props.fanDutyCycleNominal   = extradata['calibrateRes']['fanDucy']
                        props.fanRpmNominal         = extradata['calibrateRes']['fanRpm']

                        //                            if (props.measurementUnit) {
                        //                                velocity = Math.round(velocity) * 100
                        //                            }
                        //                            else {
                        //                                velocity = utilsApp.toFixedFloat();
                        //                            }
                        if(props.measurementUnit) velocity = Math.round(velocity)
                        props.sensorVelNominal      = Math.round(velocity * 100)

                        //                            //console.debug(props.fanDutyCycleNominal)

                        //                            //console.debug('bagde')
                        let done  = props.menuModelCabinet[props.lastSelectedMenuIndex]['badge']
                        if (!done){
                            /// set bagde value to main model
                            props.menuModelCabinet[props.lastSelectedMenuIndex]['badge'] = 1
                            /// update to current menu
                            menuStackView.currentItem.model = props.menuModelCabinet
                        }

                        props.calibNewInflowNom = true
                    }//

                    else if (extradata['pid'] === 'meaifamin'){
                        //                            //console.debug('bagde')

                        props.meaIfaMinimumGrid             = extradata['calibrateRes']['grid']
                        props.meaIfaMinimumVolume           = extradata['calibrateRes']['volume']
                        props.meaIfaMinimumVolTotal         = extradata['calibrateRes']['volTotal']
                        props.meaIfaMinimumVolAvg           = extradata['calibrateRes']['volAvg']
                        //                            props.meaIfaMinimumVolumeLowest     = extradata['calibrateRes']['volLow']
                        //                            props.meaIfaMinimumVolumeHighest    = extradata['calibrateRes']['volHigh']
                        let velocity = extradata['calibrateRes']['velocity']
                        //                            //console.debug(velocity)
                        props.meaIfaMinimumVelocity = Math.round(velocity * 100)
                        //                            props.calibrateResValues['measure']['ifa']['fail']['grid'] = extradata['calibrateRes']['grid']

                        props.fanDutyCycleMinimum   = extradata['calibrateRes']['fanDucy']
                        props.fanRpmMinimum         = extradata['calibrateRes']['fanRpm']

                        if(props.measurementUnit) velocity = Math.round(velocity)
                        props.sensorVelMinimum      = Math.round(velocity * 100)

                        let done = props.menuModelCabinet[props.lastSelectedMenuIndex]['badge']
                        if (!done){
                            /// set bagde value to main model
                            props.menuModelCabinet[props.lastSelectedMenuIndex]['badge'] = 1
                            /// update to current menu
                            menuStackView.currentItem.model = props.menuModelCabinet
                        }

                        props.calibNewInflowMin = true
                    }//

                    else if (extradata['pid'] === 'meaifastb'){
                        //                            //console.debug('bagde')

                        props.meaIfaStandbyGrid             = extradata['calibrateRes']['grid']
                        props.meaIfaStandbyVolume           = extradata['calibrateRes']['volume']
                        props.meaIfaStandbyVolTotal         = extradata['calibrateRes']['volTotal']
                        props.meaIfaStandbyVolAvg           = extradata['calibrateRes']['volAvg']
                        //                            props.meaIfaStandbyVolumeLowest     = extradata['calibrateRes']['volLow']
                        //                            props.meaIfaStandbyVolumeHighest    = extradata['calibrateRes']['volHigh']
                        let velocity = extradata['calibrateRes']['velocity']
                        //                            //console.debug(velocity)
                        props.meaIfaStandbyVelocity = Math.round(velocity * 100)

                        //                            props.calibrateResValues['measure']['ifa']['stb']['grid'] = extradata['calibrateRes']['grid']

                        props.fanDutyCycleStandby  = extradata['calibrateRes']['fanDucy']
                        props.fanRpmStandby        = extradata['calibrateRes']['fanRpm']

                        if(props.measurementUnit) velocity = Math.round(velocity)
                        props.sensorVelStandby      = Math.round(velocity * 100)

                        let done  = props.menuModelCabinet[props.lastSelectedMenuIndex]['badge']
                        if (!done){
                            /// set bagde value to main model
                            props.menuModelCabinet[props.lastSelectedMenuIndex]['badge'] = 1
                            /// update to current menu
                            menuStackView.currentItem.model = props.menuModelCabinet
                        }

                        props.calibNewInflowStb = true
                    }//

                    else if (extradata['pid'] === 'meadfanom'){

                        props.meaDfaNominalGrid                 = extradata['calibrateRes']['grid']
                        props.meaDfaNominalVelocityTotal        = Math.round(extradata['calibrateRes']['velSum'] * 100)
                        props.meaDfaNominalVelocity             = Math.round(extradata['calibrateRes']['velocity'] * 100)
                        props.meaDfaNominalVelocityLowest       = Math.round(extradata['calibrateRes']['velLow'] * 100)
                        props.meaDfaNominalVelocityHighest      = Math.round(extradata['calibrateRes']['velHigh'] * 100)
                        props.meaDfaNominalVelocityDeviation    = Math.round(extradata['calibrateRes']['velDev'] * 100)
                        props.meaDfaNominalVelocityDeviationp   = Math.round(extradata['calibrateRes']['velDevp'] * 100)

                        //                            console.log(props.meaDfaNominalVelocity)
                        //                            console.log(extradata['calibrateRes']['velLow'])
                        //                            console.log(props.meaDfaNominalVelocityLowest)
                        //                            console.log(props.meaDfaNominalVelocityHighest)
                        //                            console.log(props.meaDfaNominalVelocityDeviation)
                        //                            console.log(props.meaDfaNominalVelocityDeviationp)

                        //                            //console.debug(extradata['calibrateRes']['velDev'])
                        //                            //console.debug(extradata['calibrateRes']['velDevp'])

                        //                            //console.debug(props.meaDfaNominalVelocityDeviation)
                        //                            //console.debug(props.meaDfaNominalVelocityDeviationp)

                        //                            props.calibrateResValues['measure']['dfa']['nominal']['grid'] = extradata['calibrateRes']['grid']
                        //                            //console.debug(JSON.stringify(props.calibrateResValues['measure']['dfa']['nominal']['grid']))

                        props.fanDutyCycleNominal  = extradata['calibrateRes']['fanDucy']
                        props.fanRpmNominal        = extradata['calibrateRes']['fanRpm']

                        let velocity = extradata['calibrateRes']['velocity']
                        if(props.measurementUnit) velocity = Math.round(velocity)
                        props.sensorVelNominalDfa  = Math.round(velocity * 100)

                        let done  = props.menuModelCabinet[props.lastSelectedMenuIndex]['badge']
                        if (!done){
                            /// set bagde value to main model
                            props.menuModelCabinet[props.lastSelectedMenuIndex]['badge'] = 1
                            /// update to current menu
                            menuStackView.currentItem.model = props.menuModelCabinet
                        }

                        props.calibNewDownflowNom = true
                    }//

                    else if (extradata['pid'] === 'senconst'){
                        const sensorConst = extradata['sensorConstant'] || 0
                        let sensorConstHasChanged = false

                        if(props.sensorConstant !== sensorConst) {
                            props.sensorConstant = sensorConst
                            sensorConstHasChanged = true
                        }

                        /// if Sensor Contant changed, it will effect to ADC Values
                        /// So, required to recalibrate all the ADC point
                        if (sensorConstHasChanged) {
                            props.calibNewAdcZero   = false
                            props.calibNewAdcMin    = false
                            props.calibNewAdcNom    = false
                            ///
                            props.sensorAdcZero     = 0
                            props.sensorAdcMinimum  = 0
                            props.sensorAdcNominal  = 0
                            /// set bagde value to main model
                            props.menuModelMicroADC[props.lastSelectedMenuIndex+1]['badge'] = 0
                            props.menuModelMicroADC[props.lastSelectedMenuIndex+2]['badge'] = 0
                            props.menuModelMicroADC[props.lastSelectedMenuIndex+3]['badge'] = 0
                        }//

                        let done  = props.menuModelMicroADC[props.lastSelectedMenuIndex]['badge']
                        if (!done){
                            /// set bagde value to main model
                            props.menuModelMicroADC[props.lastSelectedMenuIndex]['badge'] = 1
                            /// update to current menu
                            menuStackView.currentItem.model = props.menuModelMicroADC
                        }

                        props.calibNewSensorConst = true
                    }//

                    else if (extradata['pid'] === 'adcz'){
                        props.sensorAdcZero = extradata['sensorAdcZero'] || 0

                        if(props.calibNewAdcMin) {
                            props.calibNewAdcMin = false
                            /// set bagde value to main model
                            props.menuModelMicroADC[props.lastSelectedMenuIndex+1]['badge'] = 0
                        }//

                        if(props.calibNewAdcNom) {
                            props.calibNewAdcNom = false
                            /// set bagde value to main model
                            props.menuModelMicroADC[props.lastSelectedMenuIndex+2]['badge'] = 0
                        }//

                        let done  = props.menuModelMicroADC[props.lastSelectedMenuIndex]['badge']
                        if (!done){
                            /// set bagde value to main model
                            props.menuModelMicroADC[props.lastSelectedMenuIndex]['badge'] = 1
                            /// update to current menu
                            menuStackView.currentItem.model = props.menuModelMicroADC
                        }

                        props.calibNewAdcZero = true
                    }//

                    else if (extradata['pid'] === 'adcm'){

                        props.sensorAdcMinimum = extradata['sensorAdcMinimum'] || 0

                        let velocity = extradata['sensorVelMinimum']
                        if(props.measurementUnit) velocity = Math.round(velocity)
                        props.sensorVelMinimum = Math.round(velocity * 100)

                        let velocityLowAlarm = extradata['sensorVelLowAlarm'] || 0
                        if(props.measurementUnit) velocityLowAlarm = Math.round(velocityLowAlarm)
                        props.sensorVelLowAlarm = Math.round(velocityLowAlarm * 100)
                        //                            console.debug("velocityLowAlarm: " + velocityLowAlarm)

                        props.fanDutyCycleMinimum = extradata['fanDutyCycleResult']
                        props.fanRpmMinimum       = extradata['fanRpmResult']

                        if(props.calibNewAdcNom) {
                            props.calibNewAdcNom = false
                            /// clear bagde value to main model
                            props.menuModelMicroADC[props.lastSelectedMenuIndex+1]['badge'] = 0
                        }

                        let done  = props.menuModelMicroADC[props.lastSelectedMenuIndex]['badge']
                        if (!done){
                            /// set bagde value to main model
                            props.menuModelMicroADC[props.lastSelectedMenuIndex]['badge'] = 1
                            /// update to current menu
                            menuStackView.currentItem.model = props.menuModelMicroADC
                        }

                        props.calibNewAdcMin = true
                    }//

                    else if (extradata['pid'] === 'adcn'){
                        props.sensorAdcNominal = extradata['sensorAdcNominal'] || 0

                        props.fanDutyCycleNominal  = extradata['fanDutyCycleResult']
                        props.fanRpmNominal        = extradata['fanRpmResult']

                        props.sensorAdcNominal      = extradata['sensorAdcNominal'] || 0

                        let velocity = extradata['sensorVelNominal']
                        if(props.measurementUnit) velocity = Math.round(velocity)
                        props.sensorVelNominal = Math.round(velocity * 100)

                        velocity = extradata['sensorVelNominalDfa']
                        if(props.measurementUnit) velocity = Math.round(velocity)
                        props.sensorVelNominalDfa   = Math.round(velocity * 100)

                        props.temperatureCalib      = extradata['temperatureCalib'] || 0
                        props.temperatureAdcCalib   = extradata['temperatureCalibAdc'] || 0

                        let done  = props.menuModelMicroADC[props.lastSelectedMenuIndex]['badge']
                        if (!done){
                            /// set bagde value to main model
                            props.menuModelMicroADC[props.lastSelectedMenuIndex]['badge'] = 1
                            /// update to current menu
                            menuStackView.currentItem.model = props.menuModelMicroADC
                        }

                        props.calibNewAdcNom = true
                        props.saveCalibrationData()
                    }//
                }//
            }//
        }//
    }//
}//