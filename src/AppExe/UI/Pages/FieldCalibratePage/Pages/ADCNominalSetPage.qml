import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "ADC Nominal"

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
                    title: qsTr(viewApp.title)
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                StackView {
                    id: fragmentStackView
                    anchors.fill: parent
                    initialItem: fragmentStartedComp/*calibStabilizationComp*//*fragmentResultComp*/
                }//

                // Started
                Component {
                    id: fragmentStartedComp

                    Item {
                        property string idname: "started"

                        RowLayout {
                            anchors.fill: parent

                            Item{
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                Column{
                                    id: parameterColumn
                                    anchors.centerIn: parent
                                    spacing: 10

                                    TextApp{
                                        text: qsTr("Temperature calib") + ": " + props.temperatureActualStr
                                    }//

                                    Column {
                                        TextApp{
                                            text: qsTr("Airflow sensor ADC") + ":"
                                        }//

                                        TextApp{
                                            font.pixelSize: 18
                                            text:  "* " + qsTr("Please wait until the value stabilizes")
                                            color: "#DEB887"
                                        }//

                                        TextApp{
                                            id: currentTextApp
                                            font.pixelSize: 52
                                            text: props.adcActual
                                        }//

                                    }//
                                }//
                            }//


                            Item {
                                id: rightContentItem
                                Layout.fillHeight: true
                                Layout.minimumWidth: parent.width * 0.20

                                Column {
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 5

                                    Rectangle {
                                        //                                anchors.verticalCenter: parent.verticalCenter
                                        width: rightContentItem.width
                                        height: rightContentItem.height / 3 - 5
                                        color: "#0F2952"
                                        border.color: "#dddddd"
                                        radius: 5

                                        ColumnLayout {
                                            anchors.fill: parent
                                            anchors.margins: 3
                                            spacing: 1

                                            TextApp {
                                                font.pixelSize: 14
                                                text: qsTr("Press here to adjust")
                                            }

                                            Item {
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true

                                                Image {
                                                    id: fanImage
                                                    source: "qrc:/UI/Pictures/controll/Fan_W.png"
                                                    anchors.fill: parent
                                                    fillMode: Image.PreserveAspectFit

                                                    states: State {
                                                        name: "stateOn"
                                                        when: props.fanDutyCycleActual
                                                        PropertyChanges {
                                                            target: fanImage
                                                            source: "qrc:/UI/Pictures/controll/Fan_G.png"
                                                        }//
                                                    }//
                                                }//
                                            }//

                                            TextApp {
                                                text: "Dcy: " + props.fanDutyCycleActual
                                            }//

                                            TextApp {
                                                text: "RPM: " + props.fanRpmActual
                                            }//
                                        }//

                                        MouseArea {
                                            id: fanSpeedMouseArea
                                            anchors.fill: parent
                                        }//

                                        TextInput {
                                            id: fanSpeedBufferTextInput
                                            visible: false
                                            validator: IntValidator{bottom: 0; top: 99;}

                                            Connections {
                                                target: fanSpeedMouseArea

                                                function onClicked() {
                                                    //                                        //console.debug(index)
                                                    fanSpeedBufferTextInput.text = props.fanDutyCycleActual

                                                    KeyboardOnScreenCaller.openNumpad(fanSpeedBufferTextInput, qsTr("Fan Duty Cycle") + " " + "(0-99)")
                                                }//
                                            }//

                                            onAccepted: {
                                                let val = Number(text)
                                                if(isNaN(val)) return

                                                MachineAPI.setFanPrimaryDutyCycle(val)

                                                viewApp.showBusyPage(qsTr("Adjusting fan duty cycle..."),
                                                                     function onTriggered(cycle){
                                                                         if(cycle === 5){ viewApp.dialogObject.close() }
                                                                     })
                                            }//
                                        }
                                    }//

                                    Rectangle {
                                        //                                anchors.verticalCenter: parent.verticalCenter
                                        width: rightContentItem.width
                                        height: rightContentItem.height / 3 - 5
                                        color: "#0F2952"
                                        border.color: "#dddddd"
                                        radius: 5

                                        ColumnLayout {
                                            anchors.fill: parent
                                            anchors.margins: 3
                                            spacing: 1

                                            TextApp {
                                                text: qsTr("Set inflow") + ":"
                                            }//

                                            TextApp {
                                                text: props.measureUnitStr
                                            }//

                                            Item {
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true

                                                TextField {
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    width: parent.width - 2
                                                    font.pixelSize: 24
                                                    horizontalAlignment: Text.AlignHCenter
                                                    color: "#dddddd"
                                                    text: props.velocityStrf

                                                    background: Rectangle {
                                                        height: parent.height
                                                        width: parent.width
                                                        color: "#55000000"

                                                        Rectangle {
                                                            height: 1
                                                            width: parent.width
                                                            anchors.bottom: parent.bottom
                                                        }//
                                                    }//

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Set inflow"))
                                                    }//

                                                    onAccepted: {
                                                        const val = Number(text)
                                                        if(isNaN(val)) return

                                                        //                                                        //console.debug("val: " + val)

                                                        props.velocity = val
                                                        props.velocityStrf = text
                                                    }//
                                                }//
                                            }//
                                        }//

                                        //                                MouseArea {
                                        //                                    anchors.fill: parent
                                        //                                    onClicked: {
                                        //                                        //                                        witBusyPageBlockApp.open()
                                        //                                    }//
                                        //                                }//
                                    }//

                                    Rectangle {
                                        //                                anchors.verticalCenter: parent.verticalCenter
                                        width: rightContentItem.width
                                        height: rightContentItem.height / 3 - 5
                                        color: "#0F2952"
                                        border.color: "#dddddd"
                                        radius: 5

                                        ColumnLayout {
                                            anchors.fill: parent
                                            anchors.margins: 3
                                            spacing: 1

                                            TextApp {
                                                text: qsTr("Set downflow") + ":"
                                            }//

                                            TextApp {
                                                text: props.measureUnitStr
                                            }//

                                            Item {
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true

                                                TextField {
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    width: parent.width - 2
                                                    font.pixelSize: 24
                                                    horizontalAlignment: Text.AlignHCenter
                                                    color: "#dddddd"
                                                    text: props.velocityDfaNomStrf

                                                    background: Rectangle {
                                                        height: parent.height
                                                        width: parent.width
                                                        color: "#55000000"

                                                        Rectangle {
                                                            height: 1
                                                            width: parent.width
                                                            anchors.bottom: parent.bottom
                                                        }//
                                                    }//

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Set downflow"))
                                                    }//

                                                    onAccepted: {
                                                        const val = Number(text)
                                                        if(isNaN(val)) return

                                                        //                                                        //console.debug("val: " + val)

                                                        props.velocityDfaNom = val
                                                        props.velocityDfaNomStrf = text
                                                    }//
                                                }//
                                            }//
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//
                }//

                // Stabilizing
                Component {
                    id: fragmentStabilizationComp

                    Item {
                        property string idname: "stabilized"

                        Column {
                            id: parameterColumn
                            anchors.centerIn: parent
                            spacing: 5

                            TextApp {
                                text: qsTr("Stabilizing the ADC")
                            }//

                            TextApp {
                                text: qsTr("Please wait for 3 minutes, time left") + ":"
                            }//

                            TextApp {
                                id: waitTimeText
                                font.pixelSize: 52

                                Component.onCompleted: {
                                    text = utilsApp.strfSecsToMMSS(countTimer.count)
                                }//

                                Timer {
                                    id: countTimer
                                    interval: 1000
                                    running: true; repeat: true
                                    onTriggered: {
                                        if(count > 0) {
                                            count = count - 1
                                            waitTimeText.text = utilsApp.strfSecsToMMSS(countTimer.count)
                                        }
                                        else {
                                            running = false

                                            let adc = props.adcActual
                                            ////                                            //demo
                                            //                                            adc = 2010

                                            let fanDutyCycle = props.fanDutyCycleActual
                                            let fanRpm = props.fanRpmActual
                                            let temperatureCalib = props.temperatureActual
                                            let temperatureCalibAdc = props.temperatureAdcActual
                                            let temperatureCalibStrf = props.temperatureActualStr

                                            let velocityValid = props.velocity > props.velocityMinRef ? true : false


                                            // a - ((x2 - x1) / (y2 - y1) * (b - y1))
                                            // IFF = newNomAdc - ((velocityNomAdcRef - velocityMinAdcRef) / (velocityNomRef - velocityMinRef) * (newNomVelocity - velocityMinRef))
                                            let adcMinimumInterpolation = utilsApp.interpolation(adc, props.velocity,
                                                                                                 props.velocityMinAdcRef, props.velocityMinRef,
                                                                                                 props.velocityNomAdcRef, props.velocityNomRef)

                                            let adcCalibValid;
                                            adcCalibValid = adc > 0
                                            adcCalibValid = adcCalibValid && (adcMinimumInterpolation > props.sensorAdcZero)
                                            /// consider if the adc required different with previous adc calibration
                                            /// this based on sentinel micro logic, but in this system will not consider taht
                                            //                                            adcCalibValid = adcCalibValid && (Math.abs(props.velocityNomAdcRef - adc) >= 2)

                                            //                                            //console.debug("adcCalibValid: " + adcCalibValid)

                                            //                                            //console.debug("a: " + adc
                                            //                                                          + " b: " + props.velocity
                                            //                                                          + " x1: " + props.velocityMinAdcRef
                                            //                                                          + " y1: " + props.velocityMinRef
                                            //                                                          + " x2: " + props.velocityNomAdcRef
                                            //                                                          + " y2: " + props.velocityNomRef)
                                            //                                            //console.debug("adcInterpolation: " + adcMinimumInterpolation)

                                            //                                            /// Demo
                                            //                                            fanDutyCycle = 50
                                            //                                            fanRpm = 700
                                            //                                            velocityValid = true
                                            //                                            temperatureCalib = props.measureUnit ? 20 : 67
                                            //                                            temperatureCalibStrf = props.measureUnit ? "20°C" : "20°F"

                                            props.adcNominalResult = adc
                                            props.adcMinimumResult = adcMinimumInterpolation
                                            props.fanDutyCycleResult = fanDutyCycle
                                            props.fanRpmResult = fanRpm
                                            props.temperatureCalib = temperatureCalib
                                            props.temperatureCalibAdc = temperatureCalibAdc
                                            props.temperatureCalibStrf = temperatureCalibStrf

                                            if (adc && adcCalibValid && velocityValid && fanDutyCycle && fanRpm) {
                                                props.calibrateDone = true
                                            }

                                            fragmentStackView.replace(fragmentResultComp)
                                        }
                                    }//

                                    //                                    property int count: 2
                                    property int count: 180
                                }//
                            }//

                            Row {
                                spacing: 10
                                TextApp{
                                    font.pixelSize: 18
                                    text: qsTr("Actual ADC") + ":"
                                    color: "#cccccc"
                                }//

                                TextApp{
                                    font.pixelSize: 18
                                    text: props.adcActual
                                    color: "#cccccc"
                                }//
                            }//
                        }//

                        UtilsApp {
                            id: utilsApp
                        }//

                        Component.onCompleted: {
                            setButton.visible = false
                        }//
                    }//
                }//

                // Result
                Component {
                    id: fragmentResultComp

                    Item {
                        property string idname: "result"

                        RowLayout {
                            anchors.fill: parent

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                Flickable {
                                    id: resultDetailFlickable
                                    anchors.centerIn: parent
                                    height: Math.min(parent.height, resultDetailColumn.height)
                                    width: Math.min(parent.width, resultDetailColumn.width)
                                    clip: true

                                    contentWidth: resultDetailColumn.width
                                    contentHeight: resultDetailColumn.height

                                    ScrollBar.vertical: verticalScrollBar.scrollBar

                                    Column {
                                        id: resultDetailColumn
                                        spacing: 2

                                        Row{
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            Image {
                                                id: featureImage
                                                height: 100
                                                fillMode: Image.PreserveAspectFit
                                                source: "qrc:/UI/Pictures/done-green-white.png"
                                            }//

                                            TextApp{
                                                id: resultStattusText
                                                anchors.verticalCenter: parent.verticalCenter
                                                font.bold: true
                                                text: qsTr("Done")
                                            }//
                                        }

                                        TextApp{
                                            id: resultiInfoText
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            width: 400
                                            wrapMode: Text.WordWrap
                                            visible: false
                                            color: "#ff0000"
                                            padding: 5

                                            Rectangle {
                                                z: -1
                                                anchors.fill: parent
                                                radius: 5
                                                opacity: 0.5
                                            }
                                        }//

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row{
                                            TextApp{
                                                width: 300
                                                text: qsTr("Inflow vel. nominal") + ":"
                                            }//

                                            TextApp {
                                                text: props.velocityStrf + " " + props.measureUnitStr
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row{
                                            TextApp{
                                                width: 300
                                                text: qsTr("Downflow vel. nominal") + ":"
                                            }//

                                            TextApp {
                                                text: props.velocityDfaNomStrf + " " + props.measureUnitStr
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            TextApp{
                                                width: 300
                                                text: qsTr("ADC nominal") + " (IFN)" + ":"
                                            }//

                                            TextApp {
                                                text: props.adcNominalResult
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            TextApp{
                                                width: 300
                                                text: qsTr("ADC minimum") + " (IFF)" + ":"
                                            }//

                                            TextApp {
                                                text: props.adcMinimumResult
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            TextApp{
                                                width: 300
                                                text: qsTr("ADC Zero") + ":"
                                            }//

                                            TextApp {
                                                text: props.sensorAdcZero
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            id: temperatureCalibRow

                                            TextApp{
                                                width: 300
                                                text: qsTr("Temperature calib") + ":"
                                            }//

                                            TextApp {
                                                text: props.temperatureCalibStrf
                                            }//
                                        }//

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            id: fanNomCalibRow

                                            TextApp{
                                                width: 300
                                                text: qsTr("Fan nominal") + ":"
                                            }//

                                            TextApp {
                                                text: props.fanDutyCycleResult + "% / " + props.fanRpmResult + " RPM"
                                            }//
                                        }//

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}
                                    }//
                                }//
                            }//

                            ScrollBarApp {
                                id: verticalScrollBar
                                Layout.fillHeight: true
                                Layout.fillWidth: false
                                Layout.minimumWidth: 20
                                visible: resultDetailFlickable.contentHeight > resultDetailFlickable.height
                            }//
                        }//

                        Component.onCompleted: {
                            if (!props.calibrateDone){
                                featureImage.source = "qrc:/UI/Pictures/fail-red-white.png"
                                resultStattusText.text = qsTr("Failed")
                                //                                resultiInfoText.visible = true
                                //                                resultiInfoText.text = qsTr("There no much ADC value dirrefent from full calibration. No need field calibration.")
                            }
                            else {
                                backButton.text = qsTr("Save")
                            }
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
                            id: backButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                if (fragmentStackView.currentItem.idname === "stabilized"){

                                    viewApp.showDialogAsk(qsTr("Notification"),
                                                          qsTr("Cancel this process?"),
                                                          viewApp.dialogAlert,
                                                          function onAccepted(){
                                                              //                                                              //console.debug("Y")
                                                              var intent = IntentApp.create(uri, {})
                                                              finishView(intent)
                                                          })

                                    return
                                }

                                if (fragmentStackView.currentItem.idname === "result"){
                                    if(props.calibrateDone) {
                                        let intent = IntentApp.create(uri,
                                                                      {
                                                                          "pid": props.pid,
                                                                          "sensorAdcNominal": props.adcNominalResult,
                                                                          "sensorVelNominal": props.velocity,
                                                                          "sensorVelNominalDfa": props.velocityDfaNom,
                                                                          "sensorAdcMinimum": props.adcMinimumResult,
                                                                          "fanDutyCycleResult": props.fanDutyCycleResult,
                                                                          "fanRpmResult": props.fanRpmResult,
                                                                          "temperatureCalib": props.temperatureCalib,
                                                                          "temperatureCalibAdc": props.temperatureCalibAdc
                                                                      })
                                        finishView(intent);
                                        return
                                    }
                                }

                                var intent = IntentApp.create(uri, {})
                                finishView(intent)
                            }
                        }//

                        ButtonBarApp {
                            id: setButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Set")

                            onClicked: {
                                fragmentStackView.replace(fragmentStabilizationComp)
                            }//
                        }//
                    }//
                }//
            }
        }//

        QtObject {
            id: props

            property string pid: ""

            property int fanDutyCycleActual: 0
            property int fanRpmActual: 0

            property int adcActual: 0

            property int sensorAdcZero: 0

            property int adcNominalResult: 0
            property int adcMinimumResult: 0

            property int temperatureActual: 0
            property int temperatureAdcActual: 0
            property string temperatureActualStr: "0°C"

            /// 0: metric, m/s
            /// 1: imperial, fpm
            property int measureUnit: 0
            property string measureUnitStr: measureUnit ? "fpm" : "m/s"
            /// Metric normally 2 digits after comma, ex: 0.30
            /// Imperial normally Zero digit after comma, ex: 60
            property int velocityDecimalPoint: measureUnit ? 0 : 2

            // Nominal
            property real   velocity: 0
            property string velocityStrf: "0"

            property real   velocityDfaNom: 0
            property string velocityDfaNomStrf: "0"

            // Required for interpolation formula
            // a - ((x2 - x1) / (y2 - y1) * (b - y1))
            // IFF = newNomAdc - ((velocityNomAdcRef - velocityMinAdcRef) / (velocityNomRef - velocityMinRef) * (newNomVelocity - velocityMinRef))
            property real velocityNomAdcRef: 0
            property real velocityNomRef: 0
            //
            property real velocityMinAdcRef: 0
            property real velocityMinRef: 0

            property int fanDutyCycleInitial: 0
            property int fanDutyCycleResult: 0
            property int fanRpmResult: 0

            property int temperatureCalib: 0
            property int temperatureCalibAdc: 0
            property string temperatureCalibStrf: ""

            property bool calibrateDone: false
        }

        /// Called once but after onResume
        Component.onCompleted: {
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

                let extradata = IntentApp.getExtraData(intent)
                //                    //console.debug(JSON.stringify(extradata))
                if (extradata['pid'] !== undefined) {
                    //                        //console.debug(extradata['pid'])
                    props.pid = extradata['pid']

                    props.measureUnit = extradata['measureUnit']

                    props.fanDutyCycleInitial = extradata['fanDutyCycle'] || 0

                    props.sensorAdcZero     = extradata['sensorAdcZero'] || 0

                    let velocity = extradata['sensorVelNominal'] || 0
                    props.velocity = velocity
                    props.velocityStrf = velocity.toFixed(props.velocityDecimalPoint)

                    let velocityDfaNominal = extradata['sensorVelNominalDfa'] || 0
                    props.velocityDfaNom = velocityDfaNominal
                    props.velocityDfaNomStrf = velocityDfaNominal.toFixed(props.velocityDecimalPoint)

                    /// Ref. for interpolation
                    let velocityNomAdcRef = extradata['velNomAdcRef'] || 0
                    //                        //console.debug(velocityNomAdcRef)
                    props.velocityNomAdcRef = velocityNomAdcRef

                    let velocityNomRef = extradata['velNomRef'] || 0
                    //                        //console.debug(velocityNomRef)
                    props.velocityNomRef = velocityNomRef

                    let velocityMinAdcRef = extradata['velMinAdcRef'] || 0
                    //                        //console.debug(velocityMinAdcRef)
                    props.velocityMinAdcRef = velocityMinAdcRef

                    let velocityMinRef = extradata['velMinRef'] || 0
                    //                        //console.debug(velocityMinRef)
                    props.velocityMinRef = velocityMinRef
                }//

                /// Real-Time update
                props.fanDutyCycleActual = Qt.binding(function(){ return MachineData.fanPrimaryDutyCycle })
                props.fanRpmActual = Qt.binding(function(){ return MachineData.fanPrimaryRpm })
                //
                props.adcActual = Qt.binding(function(){ return MachineData.ifaAdcConpensation })
                //
                props.temperatureActual = Qt.binding(function(){ return MachineData.temperature })
                props.temperatureActualStr = Qt.binding(function(){ return MachineData.temperatureValueStr })

                /// Automatically adjust the fan duty cycle
                //                    //console.debug(props.fanDutyCycleActual + " vs " + props.fanDutyCycleInitial)
                if (props.fanDutyCycleActual != props.fanDutyCycleInitial) {

                    MachineAPI.setFanPrimaryDutyCycle(props.fanDutyCycleInitial);

                    viewApp.showBusyPage(qsTr("Adjusting fan duty cycle..."),
                                         function onTriggered(cycle){
                                             if(cycle === 5){
                                                 // close this pop up dialog
                                                 viewApp.dialogObject.close()
                                             }
                                         })
                }//
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
    D{i:0;autoSize:true;formeditorColor:"#808080";formeditorZoom:0.66;height:600;width:1024}
}
##^##*/
