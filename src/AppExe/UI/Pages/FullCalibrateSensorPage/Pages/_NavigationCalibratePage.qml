import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

import UI.CusCom 1.1
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Full Sensor Calibration"

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
                    title: qsTr("Full Sensor Calibration")
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
                        ColumnLayout{
                            anchors.fill: parent
                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                ListView {
                                    id: menuItemView
                                    anchors.centerIn: parent
                                    width: count < 4 ? (count * (parent.width / 4)) : parent.width
                                    height: parent.height
                                    clip: true
                                    snapMode: ListView.SnapToItem
                                    flickableDirection: Flickable.AutoFlickIfNeeded
                                    orientation: ListView.Horizontal

                                    ScrollBar.horizontal: horizontalScrollBar

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

                                                //Rectangle{anchors.fill: parent}

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

                                                //Rectangle{anchors.fill: parent}

                                                TextApp {
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
                            Rectangle{
                                id: horizontalScrollRectangle
                                Layout.minimumHeight: 10
                                Layout.fillWidth: true
                                color: "transparent"
                                border.color: "#dddddd"
                                radius: 5
                                visible: menuItemView.contentWidth > width
                                /// Horizontal ScrollBar
                                ScrollBar {
                                    id: horizontalScrollBar
                                    anchors.fill: parent
                                    orientation: Qt.Horizontal
                                    policy: ScrollBar.AlwaysOn

                                    contentItem: Rectangle {
                                        implicitWidth: 0
                                        implicitHeight: 5
                                        radius: width / 2
                                        color: "#dddddd"
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
                Layout.minimumHeight: MachineAPI.FOOTER_HEIGHT

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
                                                      'ifaFanDutyCycle': props.ifaFanDutyCycleNominal,
                                                      'dfaFanDutyCycle': props.dfaFanDutyCycleNominal,
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
                                                      'ifaFanDutyCycle': props.ifaFanDutyCycleMinimum,
                                                      'dfaFanDutyCycle': props.dfaFanDutyCycleNominal,
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
                                                      'ifaFanDutyCycle': props.ifaFanDutyCycleStandby,
                                                      'dfaFanDutyCycle': props.dfaFanDutyCycleStandby,
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
                                                      'dfaFanDutyCycle': props.dfaFanDutyCycleNominal,
                                                      'ifaFanDutyCycle': props.ifaFanDutyCycleNominal,
                                                      'calibrateReq': calibrateReq
                                                  })
                    startView(intent)
                }
                else if (pid === 'meadfamin'){
                    let calibrateReq = props.calibrateReqValues['measure']['dfa']['minimum']

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      'grid': props.meaDfaMinimumGrid,
                                                      'dfaFanDutyCycle': props.dfaFanDutyCycleMinimum,
                                                      'ifaFanDutyCycle': props.ifaFanDutyCycleNominal,
                                                      'calibrateReq': calibrateReq
                                                  })
                    startView(intent)
                }
                else if (pid === 'meadfamax'){
                    let calibrateReq = props.calibrateReqValues['measure']['dfa']['maximum']

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      'grid': props.meaDfaMaximumGrid,
                                                      'dfaFanDutyCycle': props.dfaFanDutyCycleMaximum,
                                                      'ifaFanDutyCycle': props.ifaFanDutyCycleNominal,
                                                      'calibrateReq': calibrateReq
                                                  })
                    startView(intent)
                }
                else if (pid === 'senconst'){
                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      "dfaSensorConstant": props.dfaSensorConstant,
                                                      "ifaSensorConstant": props.ifaSensorConstant
                                                  })
                    startView(intent)
                }
                else if (pid === 'adcz'){

                    let intent = IntentApp.create(uri,{"pid": pid,
                                                      "dfaSensorConstant":props.dfaSensorConstant,
                                                      "ifaSensorConstant":props.ifaSensorConstant})
                    startView(intent)
                }
                else if (pid === 'adcm'){
                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      "measureUnit": props.measurementUnit,
                                                      "ifaSensorAdcZero": props.ifaSensorAdcZero,
                                                      "ifaSensorVelMinimum": props.ifaSensorVelMinimum / 100,
                                                      "ifaSensorVelLowAlarm": props.ifaSensorVelLowAlarm / 100,
                                                      'ifaFanDutyCycle': props.ifaFanDutyCycleMinimum,
                                                      "dfaSensorAdcZero": props.dfaSensorAdcZero,
                                                      "dfaSensorVelMinimum": props.dfaSensorVelMinimum / 100,
                                                      'dfaFanDutyCycle': props.dfaFanDutyCycleMinimum,
                                                      'dfaSensorVelLowAlarm': props.dfaSensorVelLowAlarm
                                                  })
                    startView(intent)
                }
                else if (pid === 'adcn'){

                    if(props.calibNewSensorConst && (!props.calibNewAdcZero || !props.calibNewAdcMin) && MachineData.machineModelName !== "LA2 EU"){
                        const message = "<b>" + qsTr("You have changed the sensor constant.") + "</b>" + "<br><br>" +
                                      qsTr("It's mandatory to re-calibrate ADC Zero and Minimum before going to ADC Nominal!")
                        showDialogMessage(qsTr("Notification"), message, dialogAlert, function(){}, false)
                        return
                    }
                    else if(!props.calibNewAdcMin  && MachineData.machineModelName !== "LA2 EU"){
                        const message = "<b>" + qsTr("ADC Minimum not calibrated yet!") + "</b>" + "<br><br>" +
                                      qsTr("It's mandatory to calibrate ADC Minimum before going to ADC Nominal!")
                        showDialogMessage(qsTr("Notification"), message, dialogAlert, function(){}, false)
                        return
                    }

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      "measureUnit"         : props.measurementUnit,
                                                      "dfaSensorConstant"   : props.dfaSensorConstant,
                                                      "dfaSensorAdcZero"    : props.dfaSensorAdcZero,
                                                      "dfaSensorAdcMinimum" : props.dfaSensorAdcMinimum,
                                                      "dfaSensorVelMinimum" : props.dfaSensorVelMinimum / 100,
                                                      "dfaSensorVelNominal" : props.dfaSensorVelNominal / 100,
                                                      "dfaSensorVelMaximum" : props.dfaSensorVelMaximum / 100,
                                                      'dfaFanDutyCycle'     : props.dfaFanDutyCycleNominal,
                                                      "ifaSensorConstant"   : props.ifaSensorConstant,
                                                      "ifaSensorAdcZero"    : props.ifaSensorAdcZero,
                                                      "ifaSensorAdcMinimum" : props.ifaSensorAdcMinimum,
                                                      "ifaSensorVelMinimum" : props.ifaSensorVelMinimum / 100,
                                                      "ifaSensorVelNominal" : props.ifaSensorVelNominal / 100,
                                                      'ifaFanDutyCycle'     : props.ifaFanDutyCycleNominal
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

                /// INFLOW
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
                    props.ifaFanDutyCycleNominal = MachineData.getFanInflowNominalDutyCycleField()
                    props.ifaFanDutyCycleMinimum = MachineData.getFanInflowMinimumDutyCycleField()
                    props.ifaFanDutyCycleStandby = MachineData.getFanInflowStandbyDutyCycleField()
                }
                else if(MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FACTORY){
                    props.ifaFanDutyCycleNominal = MachineData.getFanInflowNominalDutyCycleFactory()
                    props.ifaFanDutyCycleMinimum = MachineData.getFanInflowMinimumDutyCycleFactory()
                    props.ifaFanDutyCycleStandby = MachineData.getFanInflowStandbyDutyCycleFactory()
                }
                else{
                    props.ifaFanDutyCycleNominal = profile['airflow']['ifa']['dim']['nominal']['fanDutyCycle'] * 10
                    props.ifaFanDutyCycleMinimum = profile['airflow']['ifa']['dim']['minimum']['fanDutyCycle'] * 10
                    props.ifaFanDutyCycleStandby = profile['airflow']['ifa']['dim']['stb']['fanDutyCycle'] * 10
                }

                console.debug("props.ifaFanDutyCycleNominal", props.ifaFanDutyCycleNominal)
                console.debug("props.ifaFanDutyCycleMinimum", props.ifaFanDutyCycleMinimum)
                console.debug("props.ifaFanDutyCycleStandby", props.ifaFanDutyCycleStandby)

                /// DOWNFLOW
                for (const label1 of ['nominal', 'minimum', 'maximum']){

                    props.calibrateReqValues['measure']['dfa'][label1]['velocity']          = profile['airflow']['dfa'][label1][meaUnitStr]['velocity']
                    props.calibrateReqValues['measure']['dfa'][label1]['velocityTol']       = profile['airflow']['dfa'][label1][meaUnitStr]['velocityTol']
                    props.calibrateReqValues['measure']['dfa'][label1]['velocityTolLow']    = profile['airflow']['dfa'][label1][meaUnitStr]['velocityTolLow']
                    props.calibrateReqValues['measure']['dfa'][label1]['velocityTolHigh']   = profile['airflow']['dfa'][label1][meaUnitStr]['velocityTolHigh']
                    props.calibrateReqValues['measure']['dfa'][label1]['velDevp']           = profile['airflow']['dfa'][label1]['velDevp']
                    props.calibrateReqValues['measure']['dfa'][label1]['grid']['count']     = profile['airflow']['dfa'][label1]['grid']['count']
                    props.calibrateReqValues['measure']['dfa'][label1]['grid']['columns']   = profile['airflow']['dfa'][label1]['grid']['columns']
                }

                if (MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD) {
                    props.dfaFanDutyCycleNominal = MachineData.getFanPrimaryNominalDutyCycleField()
                    props.dfaFanDutyCycleMinimum = MachineData.getFanPrimaryMinimumDutyCycleField()
                    props.dfaFanDutyCycleMaximum = MachineData.getFanPrimaryMaximumDutyCycleField()
                    props.dfaFanDutyCycleStandby = MachineData.getFanPrimaryStandbyDutyCycleField()
                }
                else if(MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FACTORY){
                    props.dfaFanDutyCycleNominal = MachineData.getFanPrimaryNominalDutyCycleFactory()
                    props.dfaFanDutyCycleMinimum = MachineData.getFanPrimaryMinimumDutyCycleFactory()
                    props.dfaFanDutyCycleMaximum = MachineData.getFanPrimaryMaximumDutyCycleFactory()
                    props.dfaFanDutyCycleStandby = MachineData.getFanPrimaryStandbyDutyCycleFactory()
                }
                else{
                    props.dfaFanDutyCycleNominal = profile['airflow']['dfa']['nominal']['fanDutyCycle'] * 10
                    props.dfaFanDutyCycleMinimum = profile['airflow']['dfa']['minimum']['fanDutyCycle'] * 10
                    props.dfaFanDutyCycleMaximum = profile['airflow']['dfa']['maximum']['fanDutyCycle'] * 10
                    props.dfaFanDutyCycleStandby = props.ifaFanDutyCycleStandby
                }

                console.debug("props.dfaFanDutyCycleNominal", props.dfaFanDutyCycleNominal)
                console.debug("props.dfaFanDutyCycleMinimum", props.dfaFanDutyCycleMinimum)
                console.debug("props.dfaFanDutyCycleMaximum", props.dfaFanDutyCycleMaximum)

                /////demo
                //props.fanDutyCycleNominal = 5
                //props.fanDutyCycleMinimum = 3
                //props.fanDutyCycleStandby = 1

            }//

            /// Just remember, which last menu index number was selected
            /// this required to modified badge status on each menu item
            property int lastSelectedMenuIndex: 0

            property var menuModelCabinet: [
                {
                    mtype      : "menu",
                    mtitle     : qsTr("Nominal Inflow Measurement"),
                    micon      : "qrc:/UI/Pictures/menu/ifa_dim_nom_measure.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureInflowDimSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid        : "meaifanom",
                },
                {
                    mtype      : "menu",
                    mtitle     : qsTr("Minimum Inflow Measurement"),
                    micon      : "qrc:/UI/Pictures/menu/ifa_dim_min_measure.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureInflowDimSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid         : "meaifamin",
                },
                {
                    mtype         : "menu",
                    mtitle     : qsTr("Standby Inflow Measurement"),
                    micon      : "qrc:/UI/Pictures/menu/ifa_dim_stb_measure.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureInflowDimSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid         : "meaifastb",
                },
                {
                    mtype         : "menu",
                    mtitle     : qsTr("Nominal Downflow Measurement"),
                    micon      : "qrc:/UI/Pictures/menu/dfa_nom_measure.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureDownflowSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid         : "meadfanom",
                },
                {
                    mtype         : "menu",
                    mtitle     : qsTr("Minimum Downflow Measurement"),
                    micon      : "qrc:/UI/Pictures/menu/dfa_min_measure.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureDownflowSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid         : "meadfamin",
                },
                {
                    mtype         : "menu",
                    mtitle     : qsTr("Maximum Downflow Measurement"),
                    micon      : "qrc:/UI/Pictures/menu/dfa_max_measure.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureDownflowSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid         : "meadfamax",
                },
                //                {
                //                    mtype         : "menu",
                //                    mtitle     : qsTr("Measure Downflow Standby"),
                //                    micon      : "qrc:/UI/Pictures/menu/dfa_stb_measure.png",
                //                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureDownflowSetPage.qml",
                //                    badge      : 0,
                //                    badgeText  : qsTr("Done"),
                //                    pid         : "meadfastb",
                //                },
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
                    mtitle     : qsTr("ADC Zero"),
                    micon      : "qrc:/UI/Pictures/menu/Zero-Sensor.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/ADCZeroSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid        : "adcz",
                },
                //                {
                //                    mtype      : "menu",
                //                    mtitle     : qsTr("ADC Minimum"),
                //                    micon      : "qrc:/UI/Pictures/menu/Calibrate-Sensor.png",
                //                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/ADCMinimumSetPage.qml",
                //                    badge      : 0,
                //                    badgeText  : qsTr("Done"),
                //                    pid        : "adcm",
                //                },
                {
                    mtype      : "menu",
                    mtitle     : qsTr("ADC Nominal"),
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
                        "minimum": {
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
                        "maximum": {
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
            property bool calibNewDownflowMin:  false
            property bool calibNewDownflowMax:  false
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

            property var meaDfaMinimumGrid:                 []
            property int meaDfaMinimumVelocityTotal:          0
            property int meaDfaMinimumVelocity:             0
            property int meaDfaMinimumVelocityLowest:       0
            property int meaDfaMinimumVelocityHighest:      0
            property int meaDfaMinimumVelocityDeviation:    0
            property int meaDfaMinimumVelocityDeviationp:   0

            property var meaDfaMaximumGrid:                 []
            property int meaDfaMaximumVelocityTotal:          0
            property int meaDfaMaximumVelocity:             0
            property int meaDfaMaximumVelocityLowest:       0
            property int meaDfaMaximumVelocityHighest:      0
            property int meaDfaMaximumVelocityDeviation:    0
            property int meaDfaMaximumVelocityDeviationp:   0

            property int dfaSensorConstant: 0
            property int ifaSensorConstant: 0

            property int dfaSensorAdcZero: 0
            property int dfaSensorAdcMinimum: 0
            property int dfaSensorAdcNominal: 0
            property int dfaSensorAdcMaximum: 0

            property int ifaSensorAdcZero: 0
            property int ifaSensorAdcMinimum: 0
            property int ifaSensorAdcNominal: 0

            property int dfaSensorVelStandby: 0 /*+ 40*/
            property int dfaSensorVelMinimum: 0 /*+ 40*/
            property int dfaSensorVelNominal: 0 /*+ 53*/
            property int dfaSensorVelMaximum: 0 /*+ 53*/

            property int ifaSensorVelStandby: 0 /*+ 40*/
            property int ifaSensorVelMinimum: 0 /*+ 40*/
            property int ifaSensorVelNominal: 0 /*+ 53*/

            property int dfaSensorVelLowAlarm: 0
            property int dfaSensorVelHighAlarm: 0
            property int ifaSensorVelLowAlarm: 0

            property int sensorVelNominalDfa: 0 /*+ 33*/

            property int dfaFanDutyCycleMaximum: 0 /*+ 15*/
            property int dfaFanDutyCycleNominal: 0 /*+ 15*/
            property int dfaFanDutyCycleMinimum: 0 /*+ 10*/
            property int dfaFanDutyCycleStandby: 0 /*+ 5*/
            property int ifaFanDutyCycleNominal: 0 /*+ 15*/
            property int ifaFanDutyCycleMinimum: 0 /*+ 10*/
            property int ifaFanDutyCycleStandby: 0 /*+ 5*/

            property int temperatureCalib: 0
            property int temperatureAdcCalib: 0

            property int dfaFanRpmNominal: 0
            property int dfaFanRpmMinimum: 0
            property int dfaFanRpmMaximum: 0
            property int dfaFanRpmStandby: 0

            property int ifaFanRpmNominal: 0
            property int ifaFanRpmMinimum: 0
            property int ifaFanRpmMaximum: 0
            property int ifaFanRpmStandby: 0

            property int measurementUnit: 0
            property int decimalPoint: MachineData.measurementUnit ? 0 : 2

            function saveCalibrationData(){
                //                /// demo
                //                props.fanDutyCycleNominal = 15
                //                props.fanDutyCycleMinimum = 10
                //                props.fanDutyCycleStandby = 5

                //                props.fanRpmNominal = 500
                //                props.fanRpmMinimum = 300
                //                props.fanRpmStandby = 100

                //                props.dfaSensorConstant = 53
                //                props.ifaSensorConstant = 53

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
                    if (cycle >= MachineAPI.BUSY_CYCLE_2) {
                        /// Goto finished page
                        const intent = IntentApp.create("qrc:/UI/Pages/FullCalibrateSensorPage/Pages/_FinishCalibratePage.qml", {})
                        finishView(intent);

                        //viewApp.dialogObject.close()
                    }
                })

                //console.log("grid " + props.meaIfaNominalGrid)
                //console.log("grid " + props.meaIfaNominalVolTotal)
                //console.log("grid " + props.meaIfaNominalVolAvg)
                //console.log("true atau false "+ props.calibNewInflowNom)

                if (props.calibNewSensorConst) {
                    console.debug("Saving Constant value:", props.dfaSensorConstant, props.ifaSensorConstant)
                    MachineAPI.setInflowSensorConstant(props.ifaSensorConstant);
                    MachineAPI.setDownflowSensorConstant(props.dfaSensorConstant);
                }

                ///// INFLOW
                /// clear field calibration
                MachineAPI.setInflowAdcPointField       (0, 0, 0, 0)
                MachineAPI.setInflowVelocityPointField  (0, 0, 0, 0)
                /// save new full calibration data
                MachineAPI.setInflowAdcPointFactory         (props.ifaSensorAdcZero, props.ifaSensorAdcMinimum, props.ifaSensorAdcNominal, 0)
                MachineAPI.setInflowVelocityPointFactory    (0, props.ifaSensorVelMinimum, props.ifaSensorVelNominal, 0)
                /// save alarm point
                MachineAPI.setInflowLowLimitVelocity    (props.ifaSensorVelLowAlarm);
                MachineAPI.setInflowTemperatureCalib    (props.temperatureCalib, props.temperatureAdcCalib)

                MachineAPI.setFanInflowNominalDutyCycleFactory(props.ifaFanDutyCycleNominal)
                MachineAPI.setFanInflowMinimumDutyCycleFactory(props.ifaFanDutyCycleMinimum)
                MachineAPI.setFanInflowStandbyDutyCycleFactory(props.ifaFanDutyCycleStandby)

                MachineAPI.setFanInflowNominalRpmFactory(props.ifaFanRpmNominal)
                MachineAPI.setFanInflowMinimumRpmFactory(props.ifaFanRpmMinimum)
                MachineAPI.setFanInflowStandbyRpmFactory(props.ifaFanRpmStandby)

                if (props.calibNewInflowNom){
                    MachineAPI.saveInflowMeaDimNominalGrid(props.meaIfaNominalGrid,
                                                           props.meaIfaNominalVolTotal,
                                                           props.meaIfaNominalVolAvg,
                                                           props.meaIfaNominalVolume,
                                                           props.meaIfaNominalVelocity,
                                                           props.ifaFanDutyCycleNominal,
                                                           props.ifaFanRpmNominal)
                }

                if (props.calibNewInflowMin) {
                    MachineAPI.saveInflowMeaDimMinimumGrid(props.meaIfaMinimumGrid,
                                                           props.meaIfaMinimumVolTotal,
                                                           props.meaIfaMinimumVolAvg,
                                                           props.meaIfaMinimumVolume,
                                                           props.meaIfaMinimumVelocity,
                                                           props.ifaFanDutyCycleMinimum,
                                                           props.ifaFanRpmMinimum)
                }

                if (props.calibNewInflowStb) {
                    MachineAPI.saveInflowMeaDimStandbyGrid(props.meaIfaStandbyGrid,
                                                           props.meaIfaStandbyVolTotal,
                                                           props.meaIfaStandbyVolAvg,
                                                           props.meaIfaStandbyVolume,
                                                           props.meaIfaStandbyVelocity,
                                                           props.ifaFanDutyCycleStandby,
                                                           props.ifaFanRpmStandby)
                }

                ///// DOWNFLOW
                /// clear field calibration
                MachineAPI.setDownflowAdcPointField     (0, 0, 0, 0)
                MachineAPI.setDownflowVelocityPointField(0, 0, 0, 0)
                /// save new full calibration data
                MachineAPI.setDownflowAdcPointFactory       (props.dfaSensorAdcZero, props.dfaSensorAdcMinimum, props.dfaSensorAdcNominal, props.dfaSensorAdcMaximum)
                MachineAPI.setDownflowVelocityPointFactory  (0, props.dfaSensorVelMinimum, props.dfaSensorVelNominal, props.dfaSensorVelMaximum)
                /// save alarm point
                MachineAPI.setDownflowLowLimitVelocity  (props.dfaSensorVelLowAlarm);
                MachineAPI.setDownflowHighLimitVelocity (props.dfaSensorVelHighAlarm);

                MachineAPI.setFanPrimaryMaximumDutyCycleFactory(props.dfaFanDutyCycleMaximum)
                MachineAPI.setFanPrimaryNominalDutyCycleFactory(props.dfaFanDutyCycleNominal)
                MachineAPI.setFanPrimaryMinimumDutyCycleFactory(props.dfaFanDutyCycleMinimum)
                MachineAPI.setFanPrimaryStandbyDutyCycleFactory(props.dfaFanDutyCycleStandby)

                MachineAPI.setFanPrimaryNominalRpmFactory(props.dfaFanRpmNominal)
                MachineAPI.setFanPrimaryMinimumRpmFactory(props.dfaFanRpmMinimum)
                MachineAPI.setFanPrimaryMaximumRpmFactory(props.dfaFanRpmMaximum)
                MachineAPI.setFanPrimaryStandbyRpmFactory(props.dfaFanRpmStandby)

                if (props.calibNewDownflowNom) {
                    MachineAPI.saveDownflowMeaNominalGrid(props.meaDfaNominalGrid,
                                                          props.meaDfaNominalVelocityTotal,
                                                          props.meaDfaNominalVelocity,
                                                          props.meaDfaNominalVelocityLowest,
                                                          props.meaDfaNominalVelocityHighest,
                                                          props.meaDfaNominalVelocityDeviation,
                                                          props.meaDfaNominalVelocityDeviationp,
                                                          props.dfaFanDutyCycleNominal,
                                                          props.dfaFanRpmNominal)
                }

                if (props.calibNewDownflowMin) {
                    MachineAPI.saveDownflowMeaMinimumGrid(props.meaDfaMinimumGrid,
                                                          props.meaDfaMinimumVelocityTotal,
                                                          props.meaDfaMinimumVelocity,
                                                          props.meaDfaMinimumVelocityLowest,
                                                          props.meaDfaMinimumVelocityHighest,
                                                          props.meaDfaMinimumVelocityDeviation,
                                                          props.meaDfaMinimumVelocityDeviationp,
                                                          props.dfaFanDutyCycleMinimum,
                                                          props.dfaFanRpmMinimum)
                }

                if (props.calibNewDownflowMax) {
                    MachineAPI.saveDownflowMeaMaximumGrid(props.meaDfaMaximumGrid,
                                                          props.meaDfaMaximumVelocityTotal,
                                                          props.meaDfaMaximumVelocity,
                                                          props.meaDfaMaximumVelocityLowest,
                                                          props.meaDfaMaximumVelocityHighest,
                                                          props.meaDfaMaximumVelocityDeviation,
                                                          props.meaDfaMaximumVelocityDeviationp,
                                                          props.dfaFanDutyCycleMaximum,
                                                          props.dfaFanRpmMaximum)
                }

                MachineAPI.initAirflowCalibrationStatus(MachineAPI.AF_CALIB_FACTORY);

                ///EVENT LOG
                const message = qsTr("User: Full calibration sensor")
                              + "("
                              + "ADC-DFZ: " + props.dfaSensorAdcZero + ", "
                //                              + "VEL-DF1: " + (props.dfaSensorVelMinimum / 100).toFixed(props.decimalPoint) + ", "
                              + "ADC-DF2: " + props.dfaSensorAdcNominal + ", "
                              + "VEL-DF2: " + (props.dfaSensorVelNominal / 100).toFixed(props.decimalPoint) + ", "
                              + "VEL-DF3: " + (props.dfaSensorVelMaximum / 100).toFixed(props.decimalPoint) + ", "
                              + "ADC-IFZ: " + props.ifaSensorAdcZero + ", "
                //                              + "VEL-IF1: " + (props.ifaSensorVelMinimum / 100).toFixed(props.decimalPoint) + ", "
                              + "ADC-IF2: " + props.ifaSensorAdcNominal + ", "
                              + "VEL-IF2: " + (props.ifaSensorVelNominal / 100).toFixed(props.decimalPoint)
                              + ")"
                MachineAPI.insertEventLog(message);
            }//
        }//

        /// called Once but after onResume
        Component.onCompleted: {
            menuStackView.push(menuGridViewComponent, {"model": props.menuModelCabinet})

            props.measurementUnit = MachineData.measurementUnit

            MachineAPI.setOperationMaintenanceMode();
            //            props.operationModeBackup = MachineData.operationMode
            //            MachineAPI.setOperationMode(MachineAPI.MODE_OPERATION_MAINTENANCE)
            let executed = false
            viewApp.showBusyPage(qsTr("Please wait!"),
                                 function onCallback(cycle){
                                     //                                    //console.debug(cycle)
                                     ///force to close
                                     if(cycle >= MachineAPI.BUSY_CYCLE_10) {
                                         viewApp.dialogObject.close()
                                     }

                                     if(cycle === MachineAPI.BUSY_CYCLE_1 && !executed) {

                                         props.dfaSensorConstant        = MachineData.getDownflowSensorConstant();
                                         props.dfaSensorAdcZero         = MachineData.getDownflowAdcPointFactory(0);
                                         props.dfaSensorAdcMinimum      = MachineData.getDownflowAdcPointFactory(1);
                                         props.dfaSensorAdcNominal      = MachineData.getDownflowAdcPointFactory(2);
                                         props.dfaSensorAdcMaximum      = MachineData.getDownflowAdcPointFactory(3);
                                         props.dfaSensorVelMinimum      = MachineData.getDownflowVelocityPointFactory(1);
                                         props.dfaSensorVelNominal      = MachineData.getDownflowVelocityPointFactory(2);
                                         props.dfaSensorVelMaximum      = MachineData.getDownflowVelocityPointFactory(3);
                                         props.dfaSensorVelLowAlarm     = MachineData.getDownflowLowLimitVelocity();
                                         props.dfaSensorVelHighAlarm    = MachineData.getDownflowHighLimitVelocity();

                                         props.ifaSensorConstant        = MachineData.getInflowSensorConstant();
                                         props.ifaSensorAdcZero         = MachineData.getInflowAdcPointFactory(0);
                                         props.ifaSensorAdcMinimum      = MachineData.getInflowAdcPointFactory(1);
                                         props.ifaSensorAdcNominal      = MachineData.getInflowAdcPointFactory(2);
                                         props.ifaSensorVelMinimum      = MachineData.getInflowVelocityPointFactory(1);
                                         props.ifaSensorVelNominal      = MachineData.getInflowVelocityPointFactory(2);
                                         props.ifaSensorVelLowAlarm     = MachineData.getInflowLowLimitVelocity();

                                         props.dfaFanDutyCycleNominal   = MachineData.getFanPrimaryNominalDutyCycleFactory()
                                         props.ifaFanDutyCycleNominal   = MachineData.getFanInflowNominalDutyCycleFactory()

                                         props.initCalibrateSpecs(MachineData.machineProfile)
                                         executed = true
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

                        props.ifaFanDutyCycleNominal   = extradata['calibrateRes']['fanDucy']
                        props.ifaFanRpmNominal         = extradata['calibrateRes']['fanRpm']

                        //                            if (props.measurementUnit) {
                        //                                velocity = Math.round(velocity) * 100
                        //                            }
                        //                            else {
                        //                                velocity = utilsApp.toFixedFloat();
                        //                            }
                        if(props.measurementUnit) velocity = Math.round(velocity)
                        props.ifaSensorVelNominal      = Math.round(velocity * 100)

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

                        props.ifaFanDutyCycleMinimum   = extradata['calibrateRes']['fanDucy']
                        props.ifaFanRpmMinimum         = extradata['calibrateRes']['fanRpm']

                        if(props.measurementUnit) velocity = Math.round(velocity)
                        props.ifaSensorVelMinimum      = Math.round(velocity * 100)

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

                        props.ifaFanDutyCycleStandby  = extradata['calibrateRes']['fanDucy']
                        props.ifaFanRpmStandby        = extradata['calibrateRes']['fanRpm']
                        props.dfaFanDutyCycleStandby  = extradata['calibrateRes']['fanDucy1']
                        props.dfaFanRpmStandby        = extradata['calibrateRes']['fanRpm1']

                        if(props.measurementUnit) velocity = Math.round(velocity)
                        props.ifaSensorVelStandby      = Math.round(velocity * 100)

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

                        props.dfaFanDutyCycleNominal  = extradata['calibrateRes']['fanDucy']
                        props.dfaFanRpmNominal        = extradata['calibrateRes']['fanRpm']

                        let velocity = extradata['calibrateRes']['velocity']
                        if(props.measurementUnit) velocity = Math.round(velocity)
                        props.dfaSensorVelNominal  = Math.round(velocity * 100)

                        let done  = props.menuModelCabinet[props.lastSelectedMenuIndex]['badge']
                        if (!done){
                            /// set bagde value to main model
                            props.menuModelCabinet[props.lastSelectedMenuIndex]['badge'] = 1
                            /// update to current menu
                            menuStackView.currentItem.model = props.menuModelCabinet
                        }

                        props.calibNewDownflowNom = true
                    }//
                    else if (extradata['pid'] === 'meadfamin'){

                        props.meaDfaMinimumGrid                 = extradata['calibrateRes']['grid']
                        props.meaDfaMinimumVelocityTotal        = Math.round(extradata['calibrateRes']['velSum'] * 100)
                        props.meaDfaMinimumVelocity             = Math.round(extradata['calibrateRes']['velocity'] * 100)
                        props.meaDfaMinimumVelocityLowest       = Math.round(extradata['calibrateRes']['velLow'] * 100)
                        props.meaDfaMinimumVelocityHighest      = Math.round(extradata['calibrateRes']['velHigh'] * 100)
                        props.meaDfaMinimumVelocityDeviation    = Math.round(extradata['calibrateRes']['velDev'] * 100)
                        props.meaDfaMinimumVelocityDeviationp   = Math.round(extradata['calibrateRes']['velDevp'] * 100)

                        //                            console.log(props.meaDfaMinimumVelocity)
                        //                            console.log(extradata['calibrateRes']['velLow'])
                        //                            console.log(props.meaDfaMinimumVelocityLowest)
                        //                            console.log(props.meaDfaMinimumVelocityHighest)
                        //                            console.log(props.meaDfaMinimumVelocityDeviation)
                        //                            console.log(props.meaDfaMinimumVelocityDeviationp)

                        //                            //console.debug(extradata['calibrateRes']['velDev'])
                        //                            //console.debug(extradata['calibrateRes']['velDevp'])

                        //                            //console.debug(props.meaDfaMinimumVelocityDeviation)
                        //                            //console.debug(props.meaDfaMinimumVelocityDeviationp)

                        //                            props.calibrateResValues['measure']['dfa']['minimum']['grid'] = extradata['calibrateRes']['grid']
                        //                            //console.debug(JSON.stringify(props.calibrateResValues['measure']['dfa']['minimum']['grid']))

                        props.dfaFanDutyCycleMinimum  = extradata['calibrateRes']['fanDucy']
                        props.dfaFanRpmMinimum        = extradata['calibrateRes']['fanRpm']

                        let velocity = extradata['calibrateRes']['velocity']
                        if(props.measurementUnit) velocity = Math.round(velocity)
                        props.dfaSensorVelMinimum  = Math.round(velocity * 100)

                        let done  = props.menuModelCabinet[props.lastSelectedMenuIndex]['badge']
                        if (!done){
                            /// set bagde value to main model
                            props.menuModelCabinet[props.lastSelectedMenuIndex]['badge'] = 1
                            /// update to current menu
                            menuStackView.currentItem.model = props.menuModelCabinet
                        }

                        props.calibNewDownflowMin = true
                    }//
                    else if (extradata['pid'] === 'meadfamax'){

                        props.meaDfaMaximumGrid                 = extradata['calibrateRes']['grid']
                        props.meaDfaMaximumVelocityTotal        = Math.round(extradata['calibrateRes']['velSum'] * 100)
                        props.meaDfaMaximumVelocity             = Math.round(extradata['calibrateRes']['velocity'] * 100)
                        props.meaDfaMaximumVelocityLowest       = Math.round(extradata['calibrateRes']['velLow'] * 100)
                        props.meaDfaMaximumVelocityHighest      = Math.round(extradata['calibrateRes']['velHigh'] * 100)
                        props.meaDfaMaximumVelocityDeviation    = Math.round(extradata['calibrateRes']['velDev'] * 100)
                        props.meaDfaMaximumVelocityDeviationp   = Math.round(extradata['calibrateRes']['velDevp'] * 100)

                        //                            console.log(props.meaDfaMaximumVelocity)
                        //                            console.log(extradata['calibrateRes']['velLow'])
                        //                            console.log(props.meaDfaMaximumVelocityLowest)
                        //                            console.log(props.meaDfaMaximumVelocityHighest)
                        //                            console.log(props.meaDfaMaximumVelocityDeviation)
                        //                            console.log(props.meaDfaMaximumVelocityDeviationp)

                        //                            //console.debug(extradata['calibrateRes']['velDev'])
                        //                            //console.debug(extradata['calibrateRes']['velDevp'])

                        //                            //console.debug(props.meaDfaMaximumVelocityDeviation)
                        //                            //console.debug(props.meaDfaMaximumVelocityDeviationp)

                        //                            props.calibrateResValues['measure']['dfa']['maximum']['grid'] = extradata['calibrateRes']['grid']
                        //                            //console.debug(JSON.stringify(props.calibrateResValues['measure']['dfa']['maximum']['grid']))

                        props.dfaFanDutyCycleMaximum  = extradata['calibrateRes']['fanDucy']
                        props.dfaFanRpmMaximum        = extradata['calibrateRes']['fanRpm']

                        let velocity = extradata['calibrateRes']['velocity']
                        if(props.measurementUnit) velocity = Math.round(velocity)
                        props.dfaSensorVelMaximum  = Math.round(velocity * 100)

                        let done  = props.menuModelCabinet[props.lastSelectedMenuIndex]['badge']
                        if (!done){
                            /// set bagde value to main model
                            props.menuModelCabinet[props.lastSelectedMenuIndex]['badge'] = 1
                            /// update to current menu
                            menuStackView.currentItem.model = props.menuModelCabinet
                        }

                        props.calibNewDownflowMax = true
                    }//

                    else if (extradata['pid'] === 'senconst'){
                        const dfaSensorConst = extradata['dfaSensorConstant'] || 0
                        const ifaSensorConst = extradata['ifaSensorConstant'] || 0
                        let sensorConstHasChanged = false

                        if(props.dfaSensorConstant !== dfaSensorConst) {
                            props.dfaSensorConstant = dfaSensorConst
                            sensorConstHasChanged = true
                        }
                        if(props.ifaSensorConstant !== ifaSensorConst) {
                            props.ifaSensorConstant = ifaSensorConst
                            sensorConstHasChanged = true
                        }

                        /// if Sensor Contant changed, it will effect to ADC Values
                        /// So, required to recalibrate all the ADC point
                        if (sensorConstHasChanged) {
                            props.calibNewAdcZero   = false
                            props.calibNewAdcMin    = false
                            props.calibNewAdcNom    = false
                            ///
                            props.dfaSensorAdcZero     = 0
                            props.dfaSensorAdcMinimum  = 0
                            props.dfaSensorAdcNominal  = 0
                            props.dfaSensorAdcMaximum  = 0
                            props.ifaSensorAdcZero     = 0
                            props.ifaSensorAdcMinimum  = 0
                            props.ifaSensorAdcNominal  = 0
                            /// set bagde value to main model
                            props.menuModelMicroADC[props.lastSelectedMenuIndex+1]['badge'] = 0
                            props.menuModelMicroADC[props.lastSelectedMenuIndex+2]['badge'] = 0
                            //props.menuModelMicroADC[props.lastSelectedMenuIndex+3]['badge'] = 0
                        }//

                        let done  = props.menuModelMicroADC[props.lastSelectedMenuIndex]['badge']
                        if (!done){
                            /// set bagde value to main model
                            props.menuModelMicroADC[props.lastSelectedMenuIndex]['badge'] = 1
                            /// update to current menu
                            menuStackView.currentItem.model = props.menuModelMicroADC
                        }

                        props.calibNewSensorConst = true
                        console.debug("calibNewSensorConst:", props.calibNewSensorConst, props.dfaSensorConstant, props.ifaSensorConstant)
                    }//

                    else if (extradata['pid'] === 'adcz'){
                        props.dfaSensorAdcZero = extradata['dfaSensorAdcZero'] || 0
                        props.ifaSensorAdcZero = extradata['ifaSensorAdcZero'] || 0

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
                        console.debug("calibNewAdcZero:", props.calibNewAdcZero, props.dfaSensorAdcZero, props.ifaSensorAdcZero)
                    }//

                    //                    else if (extradata['pid'] === 'adcm'){

                    //                        props.ifaSensorAdcMinimum = extradata['ifaSensorAdcMinimum'] || 0

                    //                        let velocity = extradata['ifaSensorVelMinimum']
                    //                        if(props.measurementUnit) velocity = Math.round(velocity)
                    //                        props.ifaSensorVelMinimum = Math.round(velocity * 100)

                    //                        velocity = extradata['dfaSensorVelMinimum']
                    //                        if(props.measurementUnit) velocity = Math.round(velocity)
                    //                        props.dfaSensorVelMinimum = Math.round(velocity * 100)

                    //                        let velocityLowAlarm = extradata['ifaSensorVelLowAlarm'] || 0
                    //                        if(props.measurementUnit) velocityLowAlarm = Math.round(velocityLowAlarm)
                    //                        props.ifaSensorVelLowAlarm = Math.round(velocityLowAlarm * 100)

                    //                        velocityLowAlarm = extradata['dfaSensorVelLowAlarm'] || 0
                    //                        if(props.measurementUnit) velocityLowAlarm = Math.round(velocityLowAlarm)
                    //                        props.dfaSensorVelLowAlarm = Math.round(velocityLowAlarm * 100)

                    //                        props.ifaFanDutyCycleMinimum = extradata['ifaFanDutyCycleResult']
                    //                        props.ifaFanRpmMinimum       = extradata['ifaFanRpmResult']
                    //                        props.dfaFanDutyCycleMinimum = extradata['dfaFanDutyCycleResult']
                    //                        props.dfaFanRpmMinimum       = extradata['dfaFanRpmResult']

                    //                        if(props.calibNewAdcNom) {
                    //                            props.calibNewAdcNom = false
                    //                            /// clear bagde value to main model
                    //                            props.menuModelMicroADC[props.lastSelectedMenuIndex+1]['badge'] = 0
                    //                        }

                    //                        let done  = props.menuModelMicroADC[props.lastSelectedMenuIndex]['badge']
                    //                        if (!done){
                    //                            /// set bagde value to main model
                    //                            props.menuModelMicroADC[props.lastSelectedMenuIndex]['badge'] = 1
                    //                            /// update to current menu
                    //                            menuStackView.currentItem.model = props.menuModelMicroADC
                    //                        }

                    //                        props.calibNewAdcMin = true
                    //                    }//

                    else if (extradata['pid'] === 'adcn'){
                        props.dfaSensorAdcMinimum = extradata['dfaSensorAdcMinimum'] || 0
                        props.dfaSensorAdcNominal = extradata['dfaSensorAdcNominal'] || 0
                        props.dfaSensorAdcMaximum = extradata['dfaSensorAdcMaximum'] || 0
                        props.dfaFanDutyCycleNominal  = extradata['dfaFanDutyCycleResult']
                        props.dfaFanRpmNominal        = extradata['dfaFanRpmResult']

                        props.ifaSensorAdcMinimum = extradata['ifaSensorAdcMinimum'] || 0
                        props.ifaSensorAdcNominal = extradata['ifaSensorAdcNominal'] || 0
                        props.ifaFanDutyCycleNominal  = extradata['ifaFanDutyCycleResult']
                        props.ifaFanRpmNominal    = extradata['ifaFanRpmResult']

                        if(Math.abs(props.dfaFanDutyCycleStandby - (props.dfaFanDutyCycleNominal/2)) >= 5){
                            props.dfaFanDutyCycleStandby = props.dfaFanDutyCycleNominal/2;
                        }
                        if(Math.abs(props.ifaFanDutyCycleStandby - (props.ifaFanDutyCycleNominal/2)) >= 10){
                            props.ifaFanDutyCycleStandby = props.ifaFanDutyCycleNominal/2;
                        }

                        let dfaVelocityMin = extradata['dfaSensorVelMinimum']
                        let dfaVelocityNom = extradata['dfaSensorVelNominal']
                        let dfaVelocityMax = extradata['dfaSensorVelMaximum']

                        let ifaVelocityMin = extradata['ifaSensorVelMinimum']
                        let ifaVelocityNom = extradata['ifaSensorVelNominal']

                        if(props.measurementUnit) {
                            dfaVelocityMin = Math.round(dfaVelocityMin)
                            dfaVelocityNom = Math.round(dfaVelocityNom)
                            dfaVelocityMax = Math.round(dfaVelocityMax)
                            ifaVelocityMin = Math.round(ifaVelocityMin)
                            ifaVelocityNom = Math.round(ifaVelocityNom)
                        }
                        props.dfaSensorVelMinimum = Math.round(dfaVelocityMin * 100)
                        props.dfaSensorVelNominal = Math.round(dfaVelocityNom * 100)
                        props.dfaSensorVelMaximum = Math.round(dfaVelocityMax * 100)
                        props.dfaSensorVelLowAlarm = props.dfaSensorVelMinimum
                        props.dfaSensorVelHighAlarm = props.dfaSensorVelMaximum

                        props.ifaSensorVelMinimum = Math.round(ifaVelocityMin * 100)
                        props.ifaSensorVelNominal = Math.round(ifaVelocityNom * 100)
                        props.ifaSensorVelLowAlarm = props.ifaSensorVelMinimum

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
