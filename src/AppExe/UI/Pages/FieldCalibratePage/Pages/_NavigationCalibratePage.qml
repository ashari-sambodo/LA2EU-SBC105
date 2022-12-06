import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

import UI.CusCom 1.1
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
                    title: qsTr("Field Sensor Calibration")
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
                                            text: (index + 1) + ") " + (modelData.mtitle ? modelData.mtitle : "")
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
                                                      'ifaFanDutyCycle': props.ifaFanDutyCycleNominal,
                                                      'dfaFanDutyCycle': props.dfaFanDutyCycleNominal,
                                                      'calibrateReq': calibrateReq
                                                  })
                    startView(intent)
                }//
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
                                                      'ifaFanDutyCycle': props.ifaFanDutyCycleNominal,
                                                      'dfaFanDutyCycle': props.dfaFanDutyCycleNominal,
                                                      'calibrateReq': calibrateReq
                                                  })
                    startView(intent)
                }//
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
                                                      'ifaFanDutyCycle': props.ifaFanDutyCycleStandby,
                                                      'dfaFanDutyCycle': props.dfaFanDutyCycleStandby,
                                                      'calibrateReq': calibrateReq
                                                  })
                    startView(intent)
                }//
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
                                                      'dfaFanDutyCycle': props.dfaFanDutyCycleNominal,
                                                      'ifaFanDutyCycle': props.ifaFanDutyCycleNominal,
                                                      'calibrateReq': calibrateReq
                                                  })
                    startView(intent)
                }//
                else if (pid === 'adcn'){
                    //console.debug(props.sensorVelMinimum)
                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      "measureUnit":        props.measurementUnit,
                                                      "ifaSensorAdcNominal": props.ifaSensorAdcNominal,
                                                      "ifaSensorVelNominal": props.ifaSensorVelNominal / 100,
                                                      "ifaSensorVelMinimum": props.ifaSensorVelMinimum / 100,
                                                      "ifaSensorVelNominalField": props.ifaSensorVelNominalField / 100,

                                                      "dfaSensorAdcNominal": props.dfaSensorAdcNominal,
                                                      "dfaSensorVelNominal": props.dfaSensorVelNominal / 100,
                                                      "dfaSensorVelMinimum": props.dfaSensorVelMinimum / 100,
                                                      "dfaSensorVelMaximum": props.dfaSensorVelMaximum / 100,
                                                      "dfaSensorVelNominalField": props.dfaSensorVelNominalField / 100,

                                                      'ifaFanDutyCycle':    props.ifaFanDutyCycleNominalField,
                                                      'dfaFanDutyCycle':    props.dfaFanDutyCycleNominalField,
                                                  })//
                    startView(intent)
                }//
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
                    mtitle     : qsTr("Inflow Measurement"),
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
                    mtitle     : qsTr("Downflow Measurement"),
                    micon      : "qrc:/UI/Pictures/menu/dfa_measure.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureDownflowSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid         : "meadfanomfield",
                },
                {mtype         : "menu",
                    mtitle     : qsTr("ADC Nominal (IFN)"),
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

            /// INFLOW
            property int ifaSensorAdcZero: 0
            property int ifaSensorAdcMinimum: 0
            property int ifaSensorAdcNominal: 0

            property int ifaSensorVelStandby: 0 /*+ 40*/
            property int ifaSensorVelMinimum: 0 /*+ 40*/
            property int ifaSensorVelNominal: 0 /*+ 53*/
            property int ifaSensorVelNominalField: 0 /*+ 53*/

            property int ifaFanDutyCycleNominal: 0 /*+ 15*/
            property int ifaFanDutyCycleMinimum: 0 /*+ 15*/
            property int ifaFanDutyCycleStandby: 0 /*+ 5*/
            property int ifaFanDutyCycleNominalField: 0 /*+ 15*/

            property int ifaFanRpmNominal: 0
            property int ifaFanRpmMinimum: 0
            property int ifaFanRpmStandby: 0

            /// DOWNFLOW
            property int dfaSensorAdcZero: 0
            property int dfaSensorAdcMinimum: 0
            property int dfaSensorAdcNominal: 0
            property int dfaSensorAdcMaximum: 0

            property int dfaSensorVelStandby: 0 /*+ 40*/
            property int dfaSensorVelMinimum: 0 /*+ 33*/
            property int dfaSensorVelNominal: 0 /*+ 33*/
            property int dfaSensorVelMaximum: 0 /*+ 33*/
            property int dfaSensorVelNominalField: 0 /*+ 33*/

            property int dfaFanDutyCycleNominal: 0 /*+ 15*/
            property int dfaFanDutyCycleMinimum: 0 /*+ 15*/
            property int dfaFanDutyCycleMaximum: 0 /*+ 15*/
            property int dfaFanDutyCycleStandby: 0 /*+ 5*/
            property int dfaFanDutyCycleNominalField: 0 /*+ 15*/

            property int temperatureCalib: 0
            property int temperatureAdcCalib: 0

            property int dfaFanRpmNominal: 0
            property int dfaFanRpmMinimum: 0
            property int dfaFanRpmStandby: 0

            property int decimalPoint: MachineData.measurementUnit ? 0 : 2

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
                    if (cycle >= MachineAPI.BUSY_CYCLE_2) {

                        const intent = IntentApp.create("qrc:/UI/Pages/FullCalibrateSensorPage/Pages/_FinishCalibratePage.qml", {})
                        finishView(intent);

                        //                                        viewApp.dialogObject.close()
                    }
                })//
                //                console.debug("############################################")
                //                console.debug("ifaSensorAdcZero: " + props.ifaSensorAdcZero)
                //                console.debug("ifaSensorAdcMinimum: " + props.ifaSensorAdcMinimum)
                //                console.debug("ifaSensorAdcNominal: " + props.ifaSensorAdcNominal)

                //                console.debug("ifaSensorVelMinimum: " + props.ifaSensorVelMinimum)
                //                console.debug("ifaSensorVelNominal: " + props.ifaSensorVelNominal)

                //                console.debug("ifaFanDutyCycleNominal: " + props.ifaFanDutyCycleNominal)

                //                console.debug("dfaSensorAdcZero: " + props.dfaSensorAdcZero)
                //                console.debug("dfaSensorAdcMinimum: " + props.dfaSensorAdcMinimum)
                //                console.debug("dfaSensorAdcNominal: " + props.dfaSensorAdcNominal)
                //                console.debug("dfaSensorAdcMaximum: " + props.dfaSensorAdcMaximum)

                //                console.debug("dfaSensorVelMinimum: " + props.dfaSensorVelMinimum)
                //                console.debug("dfaSensorVelNominal: " + props.dfaSensorVelNominal)
                //                console.debug("dfaSensorVelMaximum: " + props.dfaSensorVelMaximum)

                //                console.debug("dfaFanDutyCycleNominal: " + props.dfaFanDutyCycleNominal)

                //                console.debug("temperatureCalib: " + props.temperatureCalib)
                //                console.debug("temperatureAdcCalib: " + props.temperatureAdcCalib)

                //// INFLOW
                MachineAPI.setInflowAdcPointField(props.ifaSensorAdcZero, props.ifaSensorAdcMinimum, props.ifaSensorAdcNominal)
                MachineAPI.setInflowVelocityPointField(0, props.ifaSensorVelMinimum, props.ifaSensorVelNominal)

                MachineAPI.setInflowTemperatureCalib(props.temperatureCalib, props.temperatureAdcCalib)
                MachineAPI.setFanInflowNominalDutyCycleField(props.ifaFanDutyCycleNominal)
                //MachineAPI.setFanInflowMinimumDutyCycleField(props.fanDutyCycleMinimum)
                //MachineAPI.setFanInflowStandbyDutyCycleField(props.ifaFanDutyCycleStandby)

                MachineAPI.setFanInflowNominalRpmField(props.ifaFanRpmNominal)
                //MachineAPI.setFanInflowMinimumRpmField(props.fanRpmMinimum)
                //MachineAPI.setFanInflowStandbyRpmField(props.dfaFanRpmStandby)

                //// DOWNFLOW
                MachineAPI.setDownflowAdcPointField(props.dfaSensorAdcZero, props.dfaSensorAdcMinimum, props.dfaSensorAdcNominal, props.dfaSensorAdcMaximum)
                MachineAPI.setDownflowVelocityPointField(0, props.dfaSensorVelMinimum, props.dfaSensorVelNominal, props.dfaSensorVelMaximum)

                MachineAPI.setFanPrimaryNominalDutyCycleField(props.dfaFanDutyCycleNominal)
                //MachineAPI.setFanPrimaryMinimumDutyCycleField(props.fanDutyCycleMinimum)
                //MachineAPI.setFanPrimaryStandbyDutyCycleField(props.dfaFanDutyCycleStandby)

                MachineAPI.setFanPrimaryNominalRpmField(props.dfaFanRpmNominal)
                //MachineAPI.setFanPrimaryMinimumRpmField(props.fanRpmMinimum)
                //MachineAPI.setFanPrimaryStandbyRpmField(props.dfaFanRpmStandby)

                console.debug("calibNewInflowNom",       props.calibNewInflowNom)
                console.debug("calibNewInflowNomSec",    props.calibNewInflowNomSec)
                console.debug("calibNewDownflowNom",     props.calibNewDownflowNom)

                if (props.calibNewInflowNom){
                    console.debug("meaIfaNominalGrid",      props.meaIfaNominalGrid)
                    console.debug("meaIfaNominalTotal",     props.meaIfaNominalTotal)
                    console.debug("meaIfaNominalAverage",   props.meaIfaNominalAverage)
                    console.debug("meaIfaNominalVolume",     props.meaIfaNominalVolume)
                    console.debug("meaIfaNominalVelocity",  props.meaIfaNominalVelocity)
                    console.debug("ifaFanDutyCycleNominal", props.ifaFanDutyCycleNominal)
                    console.debug("ifaFanRpmNominal",       props.ifaFanRpmNominal)
                    console.debug("meaFieldCalibModeOn",    props.meaFieldCalibModeOn)

                    MachineAPI.saveInflowMeaDimNominalGrid(props.meaIfaNominalGrid,
                                                           props.meaIfaNominalTotal,
                                                           props.meaIfaNominalAverage,
                                                           props.meaIfaNominalVolume,
                                                           props.meaIfaNominalVelocity,
                                                           props.ifaFanDutyCycleNominal,
                                                           props.ifaFanRpmNominal,//0
                                                           props.meaFieldCalibModeOn)
                }//

                if (props.calibNewInflowNomSec){
                    console.debug("meaIfaNominalSecGrid",   props.meaIfaNominalSecGrid)
                    console.debug("meaIfaNominalSecTot",    props.meaIfaNominalSecTot)
                    console.debug("meaIfaNominalSecAvg",    props.meaIfaNominalSecAvg)
                    console.debug("meaIfaNominalSecVelocity", props.meaIfaNominalSecVelocity)
                    console.debug("ifaFanDutyCycleNominal", props.ifaFanDutyCycleNominal)
                    console.debug("ifaFanRpmNominal",       props.ifaFanRpmNominal)
                    MachineAPI.saveInflowMeaSecNominalGrid(props.meaIfaNominalSecGrid,
                                                           props.meaIfaNominalSecTot,
                                                           props.meaIfaNominalSecAvg,
                                                           props.meaIfaNominalSecVelocity,
                                                           props.ifaFanDutyCycleNominal,
                                                           props.ifaFanRpmNominal)//0
                }//

                //                if (props.calibNewInflowStb) {
                //                    MachineAPI.saveInflowMeaDimStandbyGrid(props.meaIfaStandbyGrid,
                //                                                           props.meaIfaStandbyTotal,
                //                                                           props.meaIfaStandbyVolume,
                //                                                           props.meaIfaStandbyVelocity,
                //                                                           props.fanDutyCycleStandby)
                //                }

                if (props.calibNewDownflowNom) {
                    console.debug("meaDfaNominalGrid",          props.meaDfaNominalGrid)
                    console.debug("meaDfaNominalVelocityTotal", props.meaDfaNominalVelocityTotal)
                    console.debug("meaDfaNominalVelocity",      props.meaDfaNominalVelocity)
                    console.debug("meaDfaNominalVelocityLowest", props.meaDfaNominalVelocityLowest)
                    console.debug("meaDfaNominalVelocityHighest", props.meaDfaNominalVelocityHighest)
                    console.debug("meaDfaNominalVelocityDeviation", props.meaDfaNominalVelocityDeviation)
                    console.debug("meaDfaNominalVelocityDeviationp", props.meaDfaNominalVelocityDeviationp)
                    console.debug("dfaFanDutyCycleNominal",     props.dfaFanDutyCycleNominal)
                    console.debug("dfaFanRpmNominal",           props.dfaFanRpmNominal)
                    console.debug("meaFieldCalibModeOn",        props.meaFieldCalibModeOn)

                    MachineAPI.saveDownflowMeaNominalGrid(props.meaDfaNominalGrid,
                                                          props.meaDfaNominalVelocityTotal,
                                                          props.meaDfaNominalVelocity,
                                                          props.meaDfaNominalVelocityLowest,
                                                          props.meaDfaNominalVelocityHighest,
                                                          props.meaDfaNominalVelocityDeviation,
                                                          props.meaDfaNominalVelocityDeviationp,
                                                          props.dfaFanDutyCycleNominal,
                                                          props.dfaFanRpmNominal,//0
                                                          props.meaFieldCalibModeOn)
                }//

                MachineAPI.initAirflowCalibrationStatus(MachineAPI.AF_CALIB_FIELD);

                ///EVENT LOG
                const message = qsTr("User: Field calibration sensor")
                              + "("
                              + "ADC-IF2: " + props.ifaSensorAdcNominal + ", "
                              + "VEL-IF2: " + (props.ifaSensorVelNominal / 100).toFixed(props.decimalPoint) + ", "
                              + "ADC-DF2: " + props.dfaSensorAdcNominal + ", "
                              + "VEL-DF2: " + (props.dfaSensorVelNominal / 100).toFixed(props.decimalPoint) + ", "
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
            let executed = false
            viewApp.showBusyPage(qsTr("Please wait!"),
                                 function onCallback(cycle){
                                     //                                    //console.debug(cycle)
                                     ///force to close
                                     if(cycle === MachineAPI.BUSY_CYCLE_10) {
                                         viewApp.dialogObject.close()
                                     }//

                                     if(cycle >= MachineAPI.BUSY_CYCLE_1 && !executed) {
                                         //// INFLOW
                                         props.ifaSensorAdcZero       = MachineData.getInflowAdcPointFactory(0);
                                         props.ifaSensorAdcMinimum    = MachineData.getInflowAdcPointFactory(1);
                                         props.ifaSensorAdcNominal    = MachineData.getInflowAdcPointFactory(2);
                                         //
                                         props.ifaSensorVelMinimum    = MachineData.getInflowVelocityPointFactory(1);
                                         props.ifaSensorVelNominal    = MachineData.getInflowVelocityPointFactory(2);
                                         props.ifaSensorVelNominalField= MachineData.getInflowVelocityPointField(2) ?
                                                     MachineData.getInflowVelocityPointField(2) : props.ifaSensorVelNominal

                                         props.ifaFanDutyCycleNominal = MachineData.getFanInflowNominalDutyCycleFactory()
                                         //props.ifaFanDutyCycleMinimum = MachineData.getFanPrimaryMinimumDutyCycleFactory()
                                         props.ifaFanDutyCycleStandby = MachineData.getFanInflowStandbyDutyCycleFactory()
                                         props.ifaFanDutyCycleNominalField = MachineData.getFanInflowNominalDutyCycleField() ?
                                                     MachineData.getFanInflowNominalDutyCycleField() : props.ifaFanDutyCycleNominal

                                         props.ifaFanRpmNominal = MachineData.getFanInflowNominalRpmFactory()
                                         props.ifaFanRpmStandby = MachineData.getFanInflowStandbyRpmFactory()

                                         //// DOWNFLOW
                                         props.dfaSensorAdcZero       = MachineData.getDownflowAdcPointFactory(0);
                                         props.dfaSensorAdcMinimum    = MachineData.getDownflowAdcPointFactory(1);
                                         props.dfaSensorAdcNominal    = MachineData.getDownflowAdcPointFactory(2);
                                         props.dfaSensorAdcMaximum    = MachineData.getDownflowAdcPointFactory(3);
                                         //
                                         props.dfaSensorVelMinimum    = MachineData.getDownflowVelocityPointFactory(1);
                                         props.dfaSensorVelNominal    = MachineData.getDownflowVelocityPointFactory(2);
                                         props.dfaSensorVelMaximum    = MachineData.getDownflowVelocityPointFactory(3);
                                         props.dfaSensorVelNominalField = MachineData.getDownflowVelocityPointField(2) ?
                                                     MachineData.getDownflowVelocityPointField(2) : props.dfaSensorVelNominal

                                         props.dfaFanDutyCycleNominal = MachineData.getFanPrimaryNominalDutyCycleFactory()
                                         //props.dfaFanDutyCycleMinimum = MachineData.getFanPrimaryMinimumDutyCycleFactory()
                                         props.dfaFanDutyCycleStandby = MachineData.getFanPrimaryStandbyDutyCycleFactory()
                                         props.dfaFanDutyCycleNominalField = MachineData.getFanPrimaryNominalDutyCycleField() ?
                                                     MachineData.getFanPrimaryNominalDutyCycleField() : props.dfaFanDutyCycleNominal

                                         props.dfaFanRpmNominal = MachineData.getFanPrimaryNominalRpmFactory()
                                         props.dfaFanRpmStandby = MachineData.getFanPrimaryStandbyRpmFactory()

                                         props.temperatureCalib = MachineData.getInflowTempCalib()
                                         props.temperatureAdcCalib = MachineData.getInflowTempCalibAdc()

                                         props.initCalibrateSpecs(MachineData.machineProfile)

                                         //                                         console.debug("***************************************")
                                         //                                         console.debug("ifaSensorAdcZero: " + props.ifaSensorAdcZero)
                                         //                                         console.debug("ifaSensorAdcMinimum: " + props.ifaSensorAdcMinimum)
                                         //                                         console.debug("ifaSensorAdcNominal: " + props.ifaSensorAdcNominal)

                                         //                                         console.debug("ifaSensorVelMinimum: " + props.ifaSensorVelMinimum)
                                         //                                         console.debug("ifaSensorVelNominal: " + props.ifaSensorVelNominal)

                                         //                                         console.debug("ifaFanDutyCycleNominal: " + props.ifaFanDutyCycleNominal)

                                         //                                         console.debug("dfaSensorAdcZero: " + props.dfaSensorAdcZero)
                                         //                                         console.debug("dfaSensorAdcMinimum: " + props.dfaSensorAdcMinimum)
                                         //                                         console.debug("dfaSensorAdcNominal: " + props.dfaSensorAdcNominal)
                                         //                                         console.debug("dfaSensorAdcMaximum: " + props.dfaSensorAdcMaximum)

                                         //                                         console.debug("dfaSensorVelMinimum: " + props.dfaSensorVelMinimum)
                                         //                                         console.debug("dfaSensorVelNominal: " + props.dfaSensorVelNominal)
                                         //                                         console.debug("dfaSensorVelMaximum: " + props.dfaSensorVelMaximum)

                                         //                                         console.debug("dfaFanDutyCycleNominal: " + props.dfaFanDutyCycleNominal)

                                         //                                         console.debug("temperatureCalib: " + props.temperatureCalib)
                                         //                                         console.debug("temperatureAdcCalib: " + props.temperatureAdcCalib)
                                         executed = false
                                     }//

                                     viewApp.dialogObject.close()
                                 })//
        }//

        UtilsApp {
            id: utilsApp
        }//

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

                            props.ifaFanDutyCycleNominal   = extradata['calibrateRes']['fanDucy']
                            props.ifaFanRpmNominal         = extradata['calibrateRes']['fanRpm']

                            //console.log("fanDutyCycleNominal: " + props.fanDutyCycleNominal)

                            if(props.measurementUnit) velocity = Math.round(velocity)
                            props.ifaSensorVelNominal      = velocity * 100

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

                            props.ifaFanDutyCycleNominal   = extradata['calibrateRes']['fanDucy'] || 0
                            props.ifaFanRpmNominal         = extradata['calibrateRes']['fanRpm'] || 0

                            //console.log("fanDutyCycleNominal: " + props.fanDutyCycleNominal)

                            if(props.measurementUnit) velocity = Math.round(velocity)
                            props.ifaSensorVelNominal = velocity * 100

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

                            props.ifaFanDutyCycleStandby  = extradata['calibrateRes']['fanDucy']
                            props.ifaFanRpmStandby        = extradata['calibrateRes']['fanRpm']

                            if(props.measurementUnit) velocity = Math.round(velocity)
                            props.ifaSensorVelStandby      = velocity * 100

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

                            props.dfaFanDutyCycleNominal  = extradata['calibrateRes']['fanDucy']
                            props.dfaFanRpmNominal        = extradata['calibrateRes']['fanRpm']

                            let velocity = extradata['calibrateRes']['velocity']
                            if(props.measurementUnit) velocity = Math.round(velocity)
                            props.dfaSensorVelNominal  = velocity * 100

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
                            props.ifaSensorAdcNominal = extradata['ifaSensorAdcNominal'] || 0
                            let ifaVelocity = extradata['ifaSensorVelNominal']
                            if(props.measurementUnit) ifaVelocity = Math.round(ifaVelocity)
                            props.ifaSensorVelNominal = ifaVelocity * 100

                            props.dfaSensorAdcNominal = extradata['dfaSensorAdcNominal'] || 0
                            let dfaVelocity = extradata['dfaSensorVelNominal']
                            if(props.measurementUnit) dfaVelocity = Math.round(dfaVelocity)
                            props.dfaSensorVelNominal = dfaVelocity * 100

                            props.ifaFanDutyCycleNominal  = extradata['ifaFanDutyCycleResult']
                            props.ifaFanRpmNominal        = extradata['ifaFanRpmResult']
                            props.dfaFanDutyCycleNominal  = extradata['dfaFanDutyCycleResult']
                            props.dfaFanRpmNominal        = extradata['dfaFanRpmResult']

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
