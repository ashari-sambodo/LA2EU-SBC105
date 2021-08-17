import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

import UI.CusCom 1.0
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Field Sensor Calibration"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: Item{
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
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                /// handle sub menu
                StackView {
                    id: menuStackView
                    anchors.fill: parent
                    //                    initialItem: menuGridViewComponent
                    //                    Component.onCompleted: {

                    //                    }
                }//

                Component{
                    id: menuGridViewComponent

                    Item {
                        property alias model: menuGridView.model

                        //                        ColumnLayout {
                        //                            anchors.fill: parent

                        //                            Item {
                        //                                Layout.minimumHeight: 100
                        //                                Layout.fillWidth: true

                        //                                TextApp {
                        //                                    anchors.fill: parent
                        //                                    horizontalAlignment: Text.AlignHCenter
                        //                                    verticalAlignment: Text.AlignVCenter
                        //                                    text: props.messageInfoStr
                        //                                }//
                        //                            }//

                        //                            Item {
                        //                                Layout.fillHeight: true
                        //                                Layout.fillWidth: true

                        GridView{
                            id: menuGridView
                            //                        anchors.fill: parent
                            anchors.centerIn: parent
                            /// If model lest than 4, make it centerIn of parent
                            width: count < 4 ? (count * (parent.width / 4)) : parent.width
                            height: count < 4 ? parent.height / 2 : parent.height
                            cellWidth: parent.width / 4
                            cellHeight: count < 4 ? height : height / 2
                            clip: true
                            snapMode: GridView.SnapToRow
                            flickableDirection: GridView.AutoFlickIfNeeded

                            //                        model: props.menuModel

                            //                        StackView.onStatusChanged: {
                            //                            if(StackView.status == StackView.Activating){
                            //                                model = props.menuModel
                            //                            }
                            //                        }

                            delegate: Item{
                                height: menuGridView.cellHeight
                                width: menuGridView.cellWidth
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
                                            text: modelData.mtitle ? modelData.mtitle : ""
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
                                            //                                            props.messageInfoStr = modelData.messageInfo
                                            menuStackView.push(menuGridViewComponent, {"model": modelData.submenu})
                                        }else {
                                            props.openPage(modelData.pid, modelData.mlink, modelData.mtitle)
                                        }
                                    }//
                                }//
                            }//
                        }//
                        //                            }//
                        //                        }//
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
                                    //                                    props.messageInfoStr = qsTr("Please do it in order!")
                                    menuStackView.pop()
                                }
                                else {
                                    var intent = IntentApp.create(uri, {})
                                    finishView(intent)
                                }
                            }//
                        }//

                        //                        ButtonBarApp {
                        //                            visible: menuStackView.depth == 1
                        //                            opacity: props.calibNewAdcNom ? 1 : 0.5
                        //                            width: 194
                        //                            anchors.verticalCenter: parent.verticalCenter
                        //                            anchors.right: parent.right

                        //                            imageSource: "qrc:/UI/Pictures/update.png"
                        //                            text: qsTr("Save")

                        //                            onClicked: {
                        //                                /// demo
                        //                                //                                props.fanDutyCycleNominal = 15
                        //                                //                                props.fanDutyCycleMinimum = 10
                        //                                //                                props.fanDutyCycleStandby = 5

                        //                                //                                props.fanRpmNominal = 500
                        //                                //                                props.fanRpmMinimum = 300
                        //                                //                                props.fanRpmStandby = 100

                        //                                //                                props.sensorConstant = 53

                        //                                //                                props.sensorAdcZero     = 150
                        //                                //                                props.sensorAdcMinimum  = 1000
                        //                                //                                props.sensorAdcNominal  = 2000

                        //                                //                                props.sensorVelMinimum      = 40
                        //                                //                                props.sensorVelNominal      = 53
                        //                                //                                props.sensorVelNominalDfa   = 30

                        //                                ///
                        //                                //                                //console.debug("fanDutyCycleNominal: " + props.fanDutyCycleNominal)
                        //                                //                                //console.debug("fanDutyCycleMinimum: " + props.fanDutyCycleMinimum)
                        //                                //                                //console.debug("fanDutyCycleStandby: " + props.fanDutyCycleStandby)

                        //                                //                                //console.debug("fanRpmNominal: " + props.fanRpmNominal)
                        //                                //                                //console.debug("fanRpmMinimum: " + props.fanRpmMinimum)
                        //                                //                                //console.debug("fanRpmStandby:" + props.fanRpmStandby)

                        //                                //                                //console.debug("sensorConstant: " + props.sensorConstant)

                        //                                //                                //console.debug("sensorAdcZero: " + props.sensorAdcZero)
                        //                                //                                //console.debug("sensorAdcMinimum: " + props.sensorAdcMinimum)
                        //                                //                                //console.debug("sensorAdcNominal: " + props.sensorAdcNominal)

                        //                                //                                //console.debug("sensorVelMinimum: " + props.sensorVelMinimum)
                        //                                //                                //console.debug("sensorVelNominal: " + props.sensorVelNominal)
                        //                                //                                //console.debug("sensorVelNominalDfa: " + props.sensorVelNominalDfa)
                        //                            }//
                        //                        }//
                    }//
                }//
            }//
        }//

        QtObject {
            id: props

            property int measurementUnit: 0

            function openPage(pid, uri, title){

                //                if(pid.includes("adc")) {
                //                    if (props.sensorConstant == 0) {
                //                        showDialogAsk(title, qsTr("hello"), dialogAlert)
                //                        return
                //                    }
                //                }

                if (pid === 'meaifanomdimfield'){
                    let calibrateReq = props.calibrateReqValues['measure']['ifa']['nominal']

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      //                                                      'grid': grid,
                                                      'grid': props.meaIfaNominalGrid,
                                                      'fanDutyCycle': props.fanDutyCycleNominal,
                                                      'calibrateReq': calibrateReq
                                                  })
                    startView(intent)
                }
                else if (pid === 'meaifanomsecfield'){
                    let calibrateReq = props.calibrateReqValues['measure']['ifa']['nominalsec']
                    //                    //console.debug(JSON.stringify(calibrateReq))

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      //                                                      'grid': grid,
                                                      'grid': props.meaIfaNominalSecGrid,
                                                      'fanDutyCycle': props.fanDutyCycleNominal,
                                                      'calibrateReq': calibrateReq
                                                  })
                    startView(intent)
                }
                else if (pid === 'meaifastb'){
                    let calibrateReq = props.calibrateReqValues['measure']['ifa']['stb']
                    //                    let grid = props.calibrateResValues['measure']['ifa']['stb']['grid']

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      //                                                      'grid': grid,
                                                      'grid': props.meaIfaStandbyGrid,
                                                      'fanDutyCycle': props.fanDutyCycleStandby,
                                                      'calibrateReq': calibrateReq
                                                  })
                    startView(intent)
                }
                else if (pid === 'meadfanomfield'){
                    let calibrateReq = props.calibrateReqValues['measure']['dfa']['nominal']
                    //                    let grid = props.calibrateResValues['measure']['dfa']['nominal']['grid']

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      //                                                      'grid': grid,
                                                      'grid': props.meaDfaNominalGrid,
                                                      'fanDutyCycle': props.fanDutyCycleNominal,
                                                      'calibrateReq': calibrateReq
                                                  })
                    startView(intent)
                }
                else if (pid === 'adcn'){
                    //console.debug(props.sensorVelMinimum)
                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      "measureUnit": props.measurementUnit,
                                                      "sensorAdcZero": props.sensorAdcZero,
                                                      "sensorAdcMinimum": props.sensorAdcMinimum,
                                                      "sensorVelMinimum": props.sensorVelMinimum / 100,
                                                      "sensorVelNominal": props.sensorVelNominal / 100,
                                                      "sensorVelNominalDfa": props.sensorVelNominalDfa / 100,
                                                      'fanDutyCycle': props.fanDutyCycleNominal,
                                                      'velMinAdcRef': props.sensorAdcMinimum,
                                                      'velMinRef': props.sensorVelMinimum / 100,
                                                      'velNomAdcRef': props.sensorAdcNominal,
                                                      'velNomRef': props.sensorVelNominal / 100,
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
                props.calibrateReqValues['measure']['ifa']['nominal']['volume']             = profile['airflow']['ifa']['dim']['nominal'][meaUnitStr]['volume']
                props.calibrateReqValues['measure']['ifa']['nominal']['velocity']           = profile['airflow']['ifa']['dim']['nominal'][meaUnitStr]['velocity']
                props.calibrateReqValues['measure']['ifa']['nominal']['velocityTol']        = profile['airflow']['ifa']['dim']['nominal'][meaUnitStr]['velocityTol']
                props.calibrateReqValues['measure']['ifa']['nominal']['velocityTolLow']     = profile['airflow']['ifa']['dim']['nominal'][meaUnitStr]['velocityTolLow']
                props.calibrateReqValues['measure']['ifa']['nominal']['velocityTolHigh']    = profile['airflow']['ifa']['dim']['nominal'][meaUnitStr]['velocityTolHigh']
                props.calibrateReqValues['measure']['ifa']['nominal']['openingArea']        = profile['airflow']['ifa']['dim']['nominal'][meaUnitStr]['openingArea']
                props.calibrateReqValues['measure']['ifa']['nominal']['gridCount']          = profile['airflow']['ifa']['dim']['gridCount']

                /// inflow Secondary
                props.calibrateReqValues['measure']['ifa']['nominalsec']['velocity']           = profile['airflow']['ifa']['sec']['nominal'][meaUnitStr]['velocity']
                props.calibrateReqValues['measure']['ifa']['nominalsec']['velocityTol']        = profile['airflow']['ifa']['sec']['nominal'][meaUnitStr]['velocityTol']
                props.calibrateReqValues['measure']['ifa']['nominalsec']['velocityTolLow']     = profile['airflow']['ifa']['sec']['nominal'][meaUnitStr]['velocityTolLow']
                props.calibrateReqValues['measure']['ifa']['nominalsec']['velocityTolHigh']    = profile['airflow']['ifa']['sec']['nominal'][meaUnitStr]['velocityTolHigh']
                props.calibrateReqValues['measure']['ifa']['nominalsec']['gridCount']          = profile['airflow']['ifa']['sec']['nominal']['gridCount']
                props.calibrateReqValues['measure']['ifa']['nominalsec']['correctionFactor']   = profile['airflow']['ifa']['sec']['nominal']['correctionFactor']

                /// downflow
                props.calibrateReqValues['measure']['dfa']['nominal']['velocity']          = profile['airflow']['dfa']['nominal'][meaUnitStr]['velocity']
                props.calibrateReqValues['measure']['dfa']['nominal']['velocityTol']       = profile['airflow']['dfa']['nominal'][meaUnitStr]['velocityTol']
                props.calibrateReqValues['measure']['dfa']['nominal']['velocityTolLow']    = profile['airflow']['dfa']['nominal'][meaUnitStr]['velocityTolLow']
                props.calibrateReqValues['measure']['dfa']['nominal']['velocityTolHigh']   = profile['airflow']['dfa']['nominal'][meaUnitStr]['velocityTolHigh']
                props.calibrateReqValues['measure']['dfa']['nominal']['velDevp']           = profile['airflow']['dfa']['nominal']['velDevp']
                props.calibrateReqValues['measure']['dfa']['nominal']['grid']['count']     = profile['airflow']['dfa']['nominal']['grid']['count']
                props.calibrateReqValues['measure']['dfa']['nominal']['grid']['columns']   = profile['airflow']['dfa']['nominal']['grid']['columns']

            }//

            property var menuModel: [
                {mtype         : "submenu",
                    mtitle     : "1) " + qsTr("Measure Inflow"),
                    micon      : "qrc:/UI/Pictures/menu/ifa_dimsec_measure.png",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid        : "meaifa",
                    //                mlink      :   "",
                    //                    messageInfo: qsTr("Choose a suitable method!"),
                    submenu    : [
                        {mtype         : "menu",
                            mtitle     : qsTr("DIM Method"),
                            micon      : "qrc:/UI/Pictures/menu/ifa_dim_measure.png",
                            mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureInflowDimSetPage.qml",
                            badge      : 0,
                            badgeText  : qsTr("Done"),
                            pid         : "meaifanomdimfield",
                        },
                        {mtype         : "menu",
                            mtitle     : qsTr("Secondary Method"),
                            micon      : "qrc:/UI/Pictures/menu/ifa_sec_measure.png",
                            mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureInflowSecSetPage.qml",
                            badge      : 0,
                            badgeText  : qsTr("Done"),
                            pid         : "meaifanomsecfield",
                        },
                    ]
                },
                {mtype         : "menu",
                    mtitle     : "2) " + qsTr("Measure Downflow"),
                    micon      : "qrc:/UI/Pictures/menu/dfa_measure.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureDownflowSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid         : "meadfanomfield",
                },
                {mtype         : "menu",
                    mtitle     : "3) " + qsTr("ADC Nominal (IFN)"),
                    micon      : "qrc:/UI/Pictures/menu/Calibrate-Sensor.png",
                    mlink      : "qrc:/UI/Pages/FieldCalibratePage/Pages/ADCNominalSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid         : "adcn",
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
                        "nominalsec": {
                            "correctionFactor": 0,
                            "gridCount": 0,
                            "velocity": 0,
                            "velocityTol": 0,
                            "velocityTolLow": 0,
                            "velocityTolHigh": 0,
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
            property bool calibNewInflowNomSec: false
            property bool calibNewInflowStb:    false
            property bool calibNewDownflowNom:  false
            property bool calibNewAdcNom:       false

            property var meaIfaNominalGrid: []
            property int meaIfaNominalTotal: 0
            property int meaIfaNominalAverage: 0
            property int meaIfaNominalVolume: 0
            property int meaIfaNominalVelocity: 0
            //            property int meaIfaNominalDucy: 0

            property var meaIfaNominalSecGrid: []
            property int meaIfaNominalSecTot: 0
            property int meaIfaNominalSecAvg: 0
            property int meaIfaNominalSecVelocity: 0
            //            property int meaIfaNominalSecVelocity: 0

            property var meaIfaStandbyGrid: []
            property int meaIfaStandbyVolume: 0
            property int meaIfaStandbyVelocity: 0
            property int meaIfaStandbyTotal: 0
            property int meaIfaStandbyAverage: 0

            property var meaDfaNominalGrid: []
            property int meaDfaNominalVelocity: 0
            property int meaDfaNominalVelocityTotal: 0
            property int meaDfaNominalVelocityLowest: 0
            property int meaDfaNominalVelocityHighest: 0
            property int meaDfaNominalVelocityDeviation: 0
            property int meaDfaNominalVelocityDeviationp: 0


            readonly property  int meaFieldCalibModeOn: 1

            property int sensorAdcZero: 0
            property int sensorAdcMinimum: 0
            property int sensorAdcNominal: 0

            property int sensorVelStandby: 0 /*+ 40*/
            property int sensorVelMinimum: 0 /*+ 40*/
            property int sensorVelNominal: 0 /*+ 53*/

            property int sensorVelNominalDfa: 0 /*+ 33*/

            property int fanDutyCycleNominal: 0 /*+ 15*/
            property int fanDutyCycleMinimum: 0 /*+ 15*/
            property int fanDutyCycleStandby: 0 /*+ 5*/

            property int temperatureCalib: 0
            property int temperatureAdcCalib: 0

            property int fanRpmNominal: 0
            property int fanRpmMinimum: 0
            property int fanRpmStandby: 0

            function saveCalibrationData(){
                // demo
                //                props.fanDutyCycleNominal = 15
                //                props.fanDutyCycleStandby = 5

                //                props.fanRpmNominal = 500
                //                props.fanRpmStandby = 100

                if (!props.calibNewAdcNom) {
                    //                    const message = "<b>" + qsTr("No valid calibration value!") + "</b>" + "<br><br>" +
                    //                                  qsTr("Ensure the ADC Nominal (IFN) has been calibrated.")
                    //                    viewApp.showDialogMessage(qsTr("Notification"), message, dialogAlert)
                    return
                }

                viewApp.showBusyPage(qsTr("Setting up..."), function(cycle){
                    if (cycle === 5) {

                        const intent = IntentApp.create("qrc:/UI/Pages/FullCalibrateSensorPage/Pages/_FinishCalibratePage.qml", {})
                        finishView(intent);

                        //                                        viewApp.dialogObject.close()
                    }
                })

                //console.debug("sensorAdcZero: " + props.sensorAdcZero)
                //console.debug("sensorAdcMinimum: " + props.sensorAdcMinimum)
                //console.debug("sensorAdcNominal: " + props.sensorAdcNominal)

                //console.debug("sensorVelMinimum: " + props.sensorVelMinimum)
                //console.debug("sensorVelNominal: " + props.sensorVelNominal)
                //console.debug("sensorVelNominalDfa: " + props.sensorVelNominalDfa)

                //console.debug("fanDutyCycleNominal: " + props.fanDutyCycleNominal)
                //console.debug("fanDutyCycleStandby: " + props.fanDutyCycleStandby)

                //console.debug("fanRpmNominal: " + props.fanRpmNominal)
                //console.debug("fanRpmStandby: " + props.fanRpmStandby)

                MachineAPI.setInflowAdcPointField(props.sensorAdcZero, props.sensorAdcMinimum, props.sensorAdcNominal)
                MachineAPI.setInflowVelocityPointField(0, props.sensorVelMinimum, props.sensorVelNominal)
                MachineAPI.setDownflowVelocityPointField(0, 0, props.sensorVelNominalDfa)

                MachineAPI.setInflowTemperatureCalib(props.temperatureCalib, props.temperatureAdcCalib)

                MachineAPI.setFanPrimaryNominalDutyCycleField(props.fanDutyCycleNominal)
                //                MachineAPI.setFanPrimaryMinimumDutyCycleField(props.fanDutyCycleMinimum)
                MachineAPI.setFanPrimaryStandbyDutyCycleField(props.fanDutyCycleStandby)

                MachineAPI.setFanPrimaryNominalRpmField(props.fanRpmNominal)
                //                MachineAPI.setFanPrimaryMinimumRpmField(props.fanRpmMinimum)
                MachineAPI.setFanPrimaryStandbyRpmField(props.fanRpmStandby)

                if (props.calibNewInflowNom){
                    MachineAPI.saveInflowMeaDimNominalGrid(props.meaIfaNominalGrid,
                                                           props.meaIfaNominalTotal,
                                                           props.meaIfaNominalAverage,
                                                           props.meaIfaNominalVolume,
                                                           props.meaIfaNominalVelocity,
                                                           props.fanDutyCycleNominal,
                                                           props.fanRpmNominal,
                                                           props.meaFieldCalibModeOn)
                }

                if (props.calibNewInflowNomSec){
                    MachineAPI.saveInflowMeaSecNominalGrid(props.meaIfaNominalSecGrid,
                                                           props.meaIfaNominalSecTot,
                                                           props.meaIfaNominalSecAvg,
                                                           props.meaIfaNominalSecVelocity,
                                                           props.fanDutyCycleNominal,
                                                           props.fanRpmNominal)
                }

                //                if (props.calibNewInflowStb) {
                //                    MachineAPI.saveInflowMeaDimStandbyGrid(props.meaIfaStandbyGrid,
                //                                                           props.meaIfaStandbyTotal,
                //                                                           props.meaIfaStandbyVolume,
                //                                                           props.meaIfaStandbyVelocity,
                //                                                           props.fanDutyCycleStandby)
                //                }

                if (props.calibNewDownflowNom) {
                    MachineAPI.saveDownflowMeaNominalGrid(props.meaDfaNominalGrid,
                                                          props.meaDfaNominalVelocityTotal,
                                                          props.meaDfaNominalVelocity,
                                                          props.meaDfaNominalVelocityLowest,
                                                          props.meaDfaNominalVelocityHighest,
                                                          props.meaDfaNominalVelocityDeviation,
                                                          props.meaDfaNominalVelocityDeviationp,
                                                          props.meaFieldCalibModeOn)
                }

                MachineAPI.initAirflowCalibrationStatus(MachineAPI.AF_CALIB_FIELD);

                ///EVENT LOG
                const message = qsTr("User: Field calibration sensor")
                              + "("
                              + "ADC-IFZ: " + props.sensorAdcZero + ", "
                              + "ADC-IF1: " + props.sensorAdcMinimum + ", "
                              + "ADC-IF2: " + props.sensorAdcNominal + ", "
                              + "VEL-IF1: " + (props.sensorVelMinimum / 100).toFixed(2) + ", "
                              + "VEL-IF2: " + (props.sensorVelNominal / 100).toFixed(2) + ", "
                              + ")"
                MachineAPI.insertEventLog(message);
            }//

            //            property string messageInfoStr: ""
        }//

        /// called Once but after onResume
        Component.onCompleted: {
            //            props.messageInfoStr = qsTr("Please do it in order!")
            menuStackView.push(menuGridViewComponent, {"model": props.menuModel})

            props.measurementUnit = MachineData.measurementUnit

            MachineAPI.setOperationMaintenanceMode();

            viewApp.showBusyPage(qsTr("Please wait!"),
                                 function onCallback(cycle){
                                     //                                    //console.debug(cycle)
                                     ///force to close
                                     if(cycle === 20) {
                                         viewApp.dialogObject.close()
                                     }

                                     if(cycle === 1) {
                                         props.sensorAdcZero       = MachineData.getInflowAdcPointFactory(0);
                                         props.sensorAdcMinimum    = MachineData.getInflowAdcPointFactory(1);
                                         props.sensorAdcNominal    = MachineData.getInflowAdcPointFactory(2);
                                         //
                                         props.sensorVelMinimum    = MachineData.getInflowVelocityPointFactory(1);
                                         props.sensorVelNominal    = MachineData.getInflowVelocityPointFactory(2);
                                         props.sensorVelNominalDfa = MachineData.getDownflowVelocityPointFactory(2);
                                         //
                                         props.fanDutyCycleNominal = MachineData.getFanPrimaryNominalDutyCycleFactory()
                                         //props.fanDutyCycleMinimum = MachineData.getFanPrimaryMinimumDutyCycleFactory()
                                         props.fanDutyCycleStandby = MachineData.getFanPrimaryStandbyDutyCycleFactory()

                                         props.fanRpmNominal = MachineData.getFanPrimaryNominalRpmFactory()
                                         props.fanRpmStandby = MachineData.getFanPrimaryStandbyRpmFactory()

                                         //                                         ///demo
                                         //                                         props.fanDutyCycleNominal = 15
                                         //                                         props.fanDutyCycleStandby = 5

                                         props.initCalibrateSpecs(MachineData.machineProfile)
                                     }

                                     viewApp.dialogObject.close()
                                 })

        }//

        UtilsApp {
            id: utilsApp
        }

        /// Execute This Every This Screen Active/Visible
        Loader {
            active: viewApp.stackViewStatusForeground
            sourceComponent: Item {

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

                        if (extradata['pid'] === 'meaifanomdimfield'){

                            //                            //console.debug(JSON.stringify(extradata['result']['grid']))
                            props.meaIfaNominalGrid             = extradata['calibrateRes']['grid']
                            props.meaIfaNominalVolume           = extradata['calibrateRes']['volume']
                            props.meaIfaNominalAverage          = extradata['calibrateRes']['volAvg']
                            props.meaIfaNominalTotal            = extradata['calibrateRes']['volTotal']


                            let velocity = extradata['calibrateRes']['velocity']
                            props.meaIfaNominalVelocity = velocity * 100

                            props.fanDutyCycleNominal   = extradata['calibrateRes']['fanDucy']
                            props.fanRpmNominal         = extradata['calibrateRes']['fanRpm']

                            console.log("fanDutyCycleNominal: " + props.fanDutyCycleNominal)

                            if(props.measurementUnit) velocity = Math.round(velocity)
                            props.sensorVelNominal      = velocity * 100

                            //                            //console.debug('bagde')
                            let nomDimDone  = props.menuModel[0]['submenu'][0]['badge']
                            if (!nomDimDone){
                                /// set bagde value to main model
                                props.menuModel[0]['submenu'][0]['badge'] = 1
                                /// update to current menu
                                menuStackView.currentItem.model = props.menuModel[0]['submenu']
                                /// update to parent menu
                                menuStackView.get(0)['model'] = props.menuModel
                            }

                            props.calibNewInflowNom = true
                        }//

                        else if (extradata['pid'] === 'meaifanomsecfield'){
                            //                            //console.debug('bagde')

                            props.meaIfaNominalSecGrid = extradata['calibrateRes']['grid']

                            let meaIfaNominalSecTot = extradata['calibrateRes']['velTotal'] || 0
                            props.meaIfaNominalSecTot  = meaIfaNominalSecTot * 100
                            let meaIfaNominalSecAvg  = extradata['calibrateRes']['velAvg'] || 0
                            props.meaIfaNominalSecAvg  = meaIfaNominalSecAvg * 100

                            let velocity = extradata['calibrateRes']['velocity']
                            props.meaIfaNominalSecVelocity = velocity * 100
                            //console.debug(props.meaIfaNominalSecVelocity)

                            props.fanDutyCycleNominal   = extradata['calibrateRes']['fanDucy'] || 0
                            props.fanRpmNominal         = extradata['calibrateRes']['fanRpm'] || 0

                            console.log("fanDutyCycleNominal: " + props.fanDutyCycleNominal)

                            if(props.measurementUnit) velocity = Math.round(velocity)
                            props.sensorVelNominal = velocity * 100

                            let nomSecDone = props.menuModel[0]['submenu'][1]['badge']
                            if (!nomSecDone) {
                                /// set bagde value to main model
                                props.menuModel[0]['submenu'][1]['badge'] = 1
                                /// update to current menu
                                menuStackView.currentItem.model = props.menuModel[0]['submenu']
                                /// update to parent menu
                                menuStackView.get(0)['model'] = props.menuModel
                            }

                            props.calibNewInflowNomSec = true
                        }//

                        else if (extradata['pid'] === 'meaifastb'){
                            //                            //console.debug('bagde')

                            props.meaIfaStandbyGrid = extradata['calibrateRes']['grid']
                            props.meaIfaStandbyVolume = extradata['calibrateRes']['volume']

                            let velocity = extradata['calibrateRes']['velocity']
                            //                            //console.debug(velocity)
                            props.meaIfaStandbyVelocity = velocity * 100

                            props.fanDutyCycleStandby  = extradata['calibrateRes']['fanDucy']
                            props.fanRpmStandby        = extradata['calibrateRes']['fanRpm']

                            if(props.measurementUnit) velocity = Math.round(velocity)
                            props.sensorVelStandby      = velocity * 100

                            let stbDone  = props.menuModel[0]['submenu'][2]['badge']
                            if (!stbDone) {
                                /// set bagde value to main model
                                props.menuModel[0]['submenu'][2]['badge'] = 1
                                /// update to current menu
                                menuStackView.currentItem.model = props.menuModel[0]['submenu']
                                /// update to parent menu
                                menuStackView.get(0)['model'] = props.menuModel
                            }

                            props.calibNewInflowStb = true
                        }//

                        else if (extradata['pid'] === 'meadfanomfield'){

                            props.meaDfaNominalGrid                 = extradata['calibrateRes']['grid']
                            props.meaDfaNominalVelocityTotal        = Math.round(extradata['calibrateRes']['velSum'] * 100)
                            props.meaDfaNominalVelocity             = Math.round(extradata['calibrateRes']['velocity'] * 100)
                            props.meaDfaNominalVelocityLowest       = Math.round(extradata['calibrateRes']['velLow'] * 100)
                            props.meaDfaNominalVelocityHighest      = Math.round(extradata['calibrateRes']['velHigh'] * 100)
                            props.meaDfaNominalVelocityDeviation    = Math.round(extradata['calibrateRes']['velDev'] * 100)
                            props.meaDfaNominalVelocityDeviationp   = Math.round(extradata['calibrateRes']['velDevp'] * 100)

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
                            props.sensorVelNominalDfa  = velocity * 100

                            let done  = props.menuModel[1]['badge']
                            if (!done) {
                                /// set bagde value to main model
                                props.menuModel[1]['badge'] = 1
                                /// update to current menu
                                menuStackView.currentItem.model = props.menuModel
                            }

                            props.calibNewDownflowNom = true
                        }//

                        else if (extradata['pid'] === 'adcn'){
                            props.sensorAdcNominal = extradata['sensorAdcNominal'] || 0

                            props.fanDutyCycleNominal  = extradata['fanDutyCycleResult']
                            props.fanRpmNominal        = extradata['fanRpmResult']

                            props.sensorAdcNominal     = extradata['sensorAdcNominal'] || 0
                            props.sensorAdcMinimum     = extradata['sensorAdcMinimum'] || 0

                            let velocity = extradata['sensorVelNominal']
                            if(props.measurementUnit) velocity = Math.round(velocity)
                            props.sensorVelNominal = velocity * 100

                            velocity = extradata['sensorVelNominalDfa']
                            if(props.measurementUnit) velocity = Math.round(velocity)
                            props.sensorVelNominalDfa   = velocity * 100

                            props.temperatureCalib      = extradata['temperatureCalib'] || 0
                            props.temperatureAdcCalib   = extradata['temperatureCalibAdc'] || 0

                            let done  = props.menuModel[2]['badge']
                            if (!done) {
                                /// set bagde value to main model
                                props.menuModel[2]['badge'] = 1
                                /// update to current menu
                                menuStackView.currentItem.model = props.menuModel
                            }

                            props.calibNewAdcNom = true
                            props.saveCalibrationData()
                        }//

                        let ifaDone  = props.menuModel[0]['badge']
                        if (!ifaDone) {
                            let nomDimDone  = props.menuModel[0]['submenu'][0]['badge']
                            let nomSecDone = props.menuModel[0]['submenu'][1]['badge']

                            if (nomDimDone || nomSecDone ){

                                /// set bagde value to main model
                                props.menuModel[0]['badge'] = 1
                                /// update to parent menu
                                menuStackView.get(0)['model'] = props.menuModel
                            }//
                        }//
                    }//
                }//
            }//
        }//
    }//
}//
