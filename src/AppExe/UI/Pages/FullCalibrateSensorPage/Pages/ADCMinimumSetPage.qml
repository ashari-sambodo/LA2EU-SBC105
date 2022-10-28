import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "ADC Minimum"

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
                    anchors.fill: parent
                    title: qsTr("ADC Minimum")
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
                                            }//

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
                                                text: "Dcy: " + utilsApp.getFanDucyStrf(props.fanDutyCycleActual) + "%"
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
                                                    fanSpeedBufferTextInput.text = utilsApp.getFanDucyStrf(props.fanDutyCycleActual)

                                                    KeyboardOnScreenCaller.openNumpad(fanSpeedBufferTextInput, qsTr("Fan Duty Cycle") + " " + "(0-99)")
                                                }//
                                            }//

                                            onAccepted: {
                                                let val = Number(text)*10
                                                if(isNaN(val) || val > 990 || val < 0) return

                                                MachineAPI.setFanPrimaryDutyCycle(val)

                                                viewApp.showBusyPage(qsTr("Adjusting fan duty cycle..."),
                                                                     function onTriggered(cycle){
                                                                         if(cycle === MachineAPI.BUSY_CYCLE_3){ viewApp.dialogObject.close() }
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
                                                text: qsTr("Set velocity") + ":"
                                            }//

                                            TextApp {
                                                text: props.measureUnitStr
                                            }//

                                            Item {
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true

                                                TextField {
                                                    id: velocityTextField
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    width: parent.width - 2
                                                    font.pixelSize: 24
                                                    horizontalAlignment: Text.AlignHCenter
                                                    color: "#dddddd"
                                                    validator: DoubleValidator{decimals: 2; bottom: 0.00; top: 0.55}
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
                                                        KeyboardOnScreenCaller.openNumpad(velocityTextField, qsTr("Set velocity"))
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
                                                text: qsTr("Set low alarm") + ":"
                                            }//

                                            TextApp {
                                                text: props.measureUnitStr
                                            }//

                                            Item {
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true

                                                TextField {
                                                    id: velocityLowLimitTextField
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    width: parent.width - 2
                                                    font.pixelSize: 24
                                                    horizontalAlignment: Text.AlignHCenter
                                                    color: "#dddddd"
                                                    validator: DoubleValidator{decimals: 2; bottom: 0.00; top: 0.55}
                                                    text: props.velocityLowAlarmStrf

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
                                                        KeyboardOnScreenCaller.openNumpad(velocityLowLimitTextField, qsTr("Set low alarm"))
                                                    }//

                                                    onAccepted: {
                                                        const val = Number(text)
                                                        if(isNaN(val)) return

                                                        //console.debug("val: " + val)

                                                        props.velocityLowAlarm = val
                                                        props.velocityLowAlarmStrf = text
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
                                text: qsTr("Please wait for %1, time left").arg(utilsApp.strfSecsToHumanReadable(props.stabilizingTimer)) + ":"
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
                                            let fanDutyCycle = props.fanDutyCycleActual
                                            let fanRpm = props.fanRpmActual
                                            let adcValid = (adc - props.sensorAdcZero) >= 80 ? true : false
                                            let velocityValid = props.velocity > 0 ? true : false

                                            //                                            console.log("adcMin: " + adc)

                                            //demo
                                            //                                            adc = 1000
                                            //                                            fanDutyCycle = 30
                                            //                                            fanRpm = 500
                                            //                                            adcValid = true
                                            //                                            velocityValid = true

                                            if (adcValid && velocityValid && fanDutyCycle) {
                                                props.calibrateDone = true
                                            }

                                            props.adcResult = adc
                                            props.fanDutyCycleResult = fanDutyCycle
                                            props.fanRpmResult = fanRpm

                                            fragmentStackView.replace(fragmentResultComp)
                                        }
                                    }//

                                    //                                    property int count: 2
                                    property int count: 180
                                    Component.onCompleted: {count = Qt.binding(function(){return props.stabilizingTimer})}
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

                        Column {
                            anchors.centerIn: parent
                            spacing: 2

                            Row {
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
                            }//

                            TextApp{
                                id: resultiInfoText
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
                                    text: qsTr("Velocity low alarm") + ":"
                                }//

                                TextApp {
                                    text: props.velocityLowAlarmStrf + " " + props.measureUnitStr
                                }
                            }

                            Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                            Row{
                                TextApp{
                                    width: 300
                                    text: qsTr("Velocity minimum") + ":"
                                }//

                                TextApp {
                                    text: props.velocityStrf + " " + props.measureUnitStr
                                }
                            }

                            Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                            Row {
                                TextApp{
                                    width: 300
                                    text: qsTr("ADC minimum") + " (IF1)" + ":"
                                }//

                                TextApp {
                                    text: props.adcResult
                                }
                            }

                            Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                            Row {
                                id: zeroAdcRow
                                visible: false

                                TextApp{
                                    width: 300
                                    text: qsTr("ADC zero") + " (IF0)" + ":"
                                }//

                                TextApp {
                                    text: props.sensorAdcZero
                                }
                            }

                            Rectangle {height: 1; width: parent.width; color: "#cccccc"}
                        }//

                        Component.onCompleted: {
                            if (!props.calibrateDone){
                                featureImage.source = "qrc:/UI/Pictures/fail-red-white.png"
                                resultStattusText.text = qsTr("Failed")
                                zeroAdcRow.visible = true
                                resultiInfoText.visible = true
                                resultiInfoText.text = qsTr("Required at least 80 points ADC greater than ADC zero")
                            }
                            else {
                                backButton.text = qsTr("Close")
                            }
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
                                                                          "sensorAdcMinimum": props.adcResult,
                                                                          "sensorVelMinimum": props.velocity,
                                                                          "sensorVelLowAlarm": props.velocityLowAlarm,
                                                                          "fanDutyCycleResult": props.fanDutyCycleResult,
                                                                          "fanRpmResult": props.fanRpmResult
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
            }//
        }//

        /// Private property
        QtObject{
            id: props

            property string pid: ""

            property int fanDutyCycleActual: 0
            property int fanRpmActual: 0

            property int sensorAdcZero: 0

            property int temperatureActual: 0
            property string temperatureActualStr: "0°C"

            property int adcActual: 0
            property int adcResult: 0

            /// 0: metric, m/s
            /// 1: imperial, fpm
            property int measureUnit: 0
            property string measureUnitStr: measureUnit ? "fpm" : "m/s"
            /// Metric normally 2 digits after comma, ex: 0.30
            /// Imperial normally Zero digit after comma, ex: 60
            property int velocityDecimalPoint: measureUnit ? 0 : 2

            property real velocity: 0
            property string velocityStrf: "0"

            property real velocityLowAlarm: 0
            property string velocityLowAlarmStrf: "0"

            property int fanDutyCycleInitial: 0

            property int fanDutyCycleResult: 0
            property int fanRpmResult: 0

            property bool calibrateDone: false

            property int dfaSensorConstant: 0
            property int ifaSensorConstant: 0
            property int stabilizingTimer: 180
        }

        /// Called once but after onResume
        Component.onCompleted: {
        }//

        /// Execute This Every This Screen Active/Visible
        Loader {
            active: viewApp.stackViewStatusForeground
            sourceComponent: QtObject {

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

                        props.sensorAdcZero = extradata['sensorAdcZero'] || 0

                        const velocityMin = extradata['sensorVelMinimum'] || 0
                        props.velocity = velocityMin
                        props.velocityStrf = velocityMin.toFixed(props.velocityDecimalPoint)

                        const velocityAlarm = extradata['sensorVelLowAlarm'] || 0
                        props.velocityLowAlarm = velocityAlarm
                        props.velocityLowAlarmStrf = velocityAlarm.toFixed(props.velocityDecimalPoint)

                        //                //console.debug(props.velocity)
                        //                //console.debug(props.velocityStrf)
                    }

                    props.fanDutyCycleActual = Qt.binding(function(){ return MachineData.fanPrimaryDutyCycle })
                    props.fanRpmActual = Qt.binding(function(){ return MachineData.fanPrimaryRpm })

                    props.adcActual = Qt.binding(function(){ return MachineData.ifaAdcConpensation })

                    props.temperatureActual = Qt.binding(function(){ return MachineData.temperature })
                    props.temperatureActualStr = Qt.binding(function(){ return MachineData.temperatureValueStr })

                    /// Automatically adjust the fan duty cycle
                    if (props.fanDutyCycleActual != props.fanDutyCycleInitial) {

                        MachineAPI.setFanPrimaryDutyCycle(props.fanDutyCycleInitial);

                        viewApp.showBusyPage(qsTr("Adjusting fan duty cycle..."),
                                             function onTriggered(cycle){
                                                 if(cycle === MachineAPI.BUSY_CYCLE_3){
                                                     // close this pop up dialog
                                                     viewApp.dialogObject.close()
                                                 }
                                             })
                    }

                    if(!props.dfaSensorConstant && !props.ifaSensorConstant)
                        props.stabilizingTimer = 30
                    else
                        props.stabilizingTimer = 180
                }//

                /// onPause
                Component.onDestruction: {
                    ////console.debug("StackView.DeActivating");
                }//
            }//
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.66;height:480;width:800}
}
##^##*/
