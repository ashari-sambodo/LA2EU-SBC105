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
                    title: qsTr("ADC Nominal")
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
                            Item {
                                id: rightContentItem
                                Layout.fillHeight: true
                                Layout.minimumWidth: parent.width * 0.20

                                Column {
                                    //anchors.verticalCenter: parent.verticalCenter
                                    spacing: 5
                                    Rectangle{
                                        height: 40
                                        width: rightContentItem.width
                                        color: "transparent"
                                        TextApp{
                                            height: parent.height
                                            width: parent.width
                                            text: qsTr("Downflow")
                                            font.underline: true
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                    }
                                    Rectangle {
                                        //anchors.verticalCenter: parent.verticalCenter
                                        width: rightContentItem.width
                                        height: rightContentItem.height / 4 - 15
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
                                                RowLayout{
                                                    anchors.fill: parent
                                                    Item{
                                                        Layout.fillWidth: true
                                                        Layout.fillHeight: true
                                                        ColumnLayout{
                                                            anchors.fill: parent
                                                            Item{
                                                                Layout.fillWidth: true
                                                                Layout.fillHeight: true
                                                                Column{
                                                                    anchors.verticalCenter: parent.verticalCenter
                                                                    TextApp {
                                                                        text: "Dcy: " + props.dfaFanDutyCycleActual
                                                                    }//
                                                                    TextApp {
                                                                        text: "RPM: " + props.dfaFanRpmActual
                                                                    }//
                                                                }//
                                                            }
                                                        }//
                                                    }
                                                    Item {
                                                        Layout.fillWidth: true
                                                        Layout.fillHeight: true
                                                        Image {
                                                            id: fanImage1
                                                            source: "qrc:/UI/Pictures/controll/Fan_W.png"
                                                            height: parent.height
                                                            anchors.centerIn: parent
                                                            fillMode: Image.PreserveAspectFit

                                                            states: State {
                                                                name: "stateOn"
                                                                when: props.dfaFanDutyCycleActual > 0
                                                                PropertyChanges {
                                                                    target: fanImage1
                                                                    source: "qrc:/UI/Pictures/controll/Fan_G.png"
                                                                }//
                                                            }//
                                                        }//
                                                    }//
                                                }//
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
                                                    fanSpeedBufferTextInput.text = props.dfaFanDutyCycleActual

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
                                        height: rightContentItem.height / 4 - 15
                                        color: "#0F2952"
                                        border.color: "#dddddd"
                                        radius: 5

                                        ColumnLayout {
                                            anchors.fill: parent
                                            anchors.margins: 3
                                            spacing: 1

                                            TextApp {
                                                text: qsTr("Set DF Nominal") + ":"
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
                                                    text: props.dfaVelocityNomStrf

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
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Set Downflow Nominal"))
                                                    }//

                                                    onAccepted: {
                                                        const val = Number(text)
                                                        if(isNaN(val)) return

                                                        ////console.debug("val: " + val)
                                                        props.dfaVelocityNom = val
                                                        props.dfaVelocityNomStrf = text
                                                    }//
                                                }//
                                            }//
                                        }//
                                    }//
                                }//
                            }//
                            ////////////////////////////////
                            Item{
                                id: parentId
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                Column{
                                    spacing: 10
                                    anchors.centerIn: parent
                                    TextApp {
                                        width: parentId.width
                                        horizontalAlignment: Text.AlignHCenter
                                        //verticalAlignment: Text.AlignBottom
                                        wrapMode: Text.WordWrap
                                        text: qsTr("Downflow and Inflow fan must be at Nominal speed!")
                                    }
                                    Row{
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        TextApp {
                                            width: 200
                                            wrapMode: Text.WordWrap
                                            text: qsTr("Sensors Constant")
                                        }
                                        TextApp {
                                            width: 200
                                            wrapMode: Text.WordWrap
                                            text: (": DF: %1 | IF: %2").arg(props.dfaSensorConstant).arg(props.ifaSensorConstant)
                                        }
                                    }
                                    Row{
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        TextApp {
                                            width: 200
                                            wrapMode: Text.WordWrap
                                            text: qsTr("Temperature")
                                        }
                                        TextApp {
                                            width: 200
                                            wrapMode: Text.WordWrap
                                            text: ": " + props.temperatureActualStr
                                        }
                                    }
                                    Row{
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        spacing: 10
                                        Rectangle {
                                            width: 200
                                            height: 150
                                            color: "transparent"
                                            border.color: "#e3dac9"
                                            radius: 5
                                            Column{
                                                TextApp {
                                                    width: 200
                                                    height: 50
                                                    wrapMode: Text.WordWrap
                                                    text: "DF Sensor ADC:"
                                                    padding: 5
                                                }
                                                TextApp {
                                                    width: 200
                                                    height: 100
                                                    font.pixelSize: 52
                                                    wrapMode: Text.WordWrap
                                                    text: props.dfaAdcActual
                                                    padding: 5
                                                }
                                            }
                                        }
                                        Rectangle {
                                            width: 200
                                            height: 150
                                            color: "transparent"
                                            border.color: "#e3dac9"
                                            radius: 5
                                            Column{
                                                TextApp {
                                                    width: 200
                                                    height: 50
                                                    wrapMode: Text.WordWrap
                                                    text: "IF Sensor ADC:"
                                                    padding: 5
                                                }
                                                TextApp {
                                                    width: 200
                                                    height: 100
                                                    font.pixelSize: 52
                                                    wrapMode: Text.WordWrap
                                                    text: props.ifaAdcActual
                                                    padding: 5
                                                }
                                            }
                                        }
                                    }
                                    TextApp {
                                        width: parentId.width
                                        wrapMode: Text.WordWrap
                                        padding: 10
                                        text:  "* " + qsTr("Please wait until the values are stable")
                                        font.italic: true
                                        color: "#cda776"
                                        horizontalAlignment: Text.AlignHCenter
                                    }//
                                }//
                            }//
                            /////////////////////////////////
                            Item {
                                id: rightContentItem2
                                Layout.fillHeight: true
                                Layout.minimumWidth: parent.width * 0.20

                                Column {
                                    //anchors.verticalCenter: parent.verticalCenter
                                    spacing: 5
                                    Rectangle{
                                        height: 40
                                        width: rightContentItem2.width
                                        color: "transparent"
                                        TextApp{
                                            height: parent.height
                                            width: parent.width
                                            text: qsTr("Inflow")
                                            font.underline: true
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                    }
                                    Rectangle {
                                        //                                anchors.verticalCenter: parent.verticalCenter
                                        width: rightContentItem2.width
                                        height: rightContentItem2.height / 4 - 15
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
                                                RowLayout{
                                                    anchors.fill: parent
                                                    Item{
                                                        Layout.fillWidth: true
                                                        Layout.fillHeight: true
                                                        ColumnLayout{
                                                            anchors.fill: parent
                                                            Item{
                                                                Layout.fillWidth: true
                                                                Layout.fillHeight: true
                                                                Column{
                                                                    anchors.verticalCenter: parent.verticalCenter
                                                                    TextApp {
                                                                        text: "Dcy: " + props.ifaFanDutyCycleActual
                                                                    }//
                                                                    TextApp {
                                                                        text: "I"
                                                                        color: "#0F2952"
                                                                    }//
                                                                }//
                                                            }
                                                        }//
                                                    }
                                                    Item {
                                                        Layout.fillWidth: true
                                                        Layout.fillHeight: true
                                                        Image {
                                                            id: fanImage2
                                                            source: "qrc:/UI/Pictures/controll/Fan_W.png"
                                                            height: parent.height
                                                            anchors.centerIn: parent
                                                            fillMode: Image.PreserveAspectFit

                                                            states: State {
                                                                name: "stateOn"
                                                                when: props.ifaFanDutyCycleActual > 0
                                                                PropertyChanges {
                                                                    target: fanImage2
                                                                    source: "qrc:/UI/Pictures/controll/Fan_G.png"
                                                                }//
                                                            }//
                                                        }//
                                                    }//
                                                }//
                                            }//
                                        }//

                                        MouseArea {
                                            id: fanSpeedMouseArea2
                                            anchors.fill: parent
                                        }//

                                        TextInput {
                                            id: fanSpeedBufferTextInput2
                                            visible: false
                                            validator: IntValidator{bottom: 0; top: 99;}

                                            Connections {
                                                target: fanSpeedMouseArea2

                                                function onClicked() {
                                                    //                                        //console.debug(index)
                                                    fanSpeedBufferTextInput2.text = props.ifaFanDutyCycleActual

                                                    KeyboardOnScreenCaller.openNumpad(fanSpeedBufferTextInput2, qsTr("Fan Duty Cycle") + " " + "(0-99)")
                                                }//
                                            }//

                                            onAccepted: {
                                                let val = Number(text)
                                                if(isNaN(val)) return

                                                MachineAPI.setFanInflowDutyCycle(val)

                                                viewApp.showBusyPage(qsTr("Adjusting fan duty cycle..."),
                                                                     function onTriggered(cycle){
                                                                         if(cycle === 5){ viewApp.dialogObject.close() }
                                                                     })
                                            }//
                                        }
                                    }//

                                    Rectangle {
                                        //                                anchors.verticalCenter: parent.verticalCenter
                                        width: rightContentItem2.width
                                        height: rightContentItem2.height / 4 - 15
                                        color: "#0F2952"
                                        border.color: "#dddddd"
                                        radius: 5

                                        ColumnLayout {
                                            anchors.fill: parent
                                            anchors.margins: 3
                                            spacing: 1

                                            TextApp {
                                                text: qsTr("Set IF Nominal") + ":"
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
                                                    text: props.ifaVelocityNomStrf

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
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Set Inflow Nominal"))
                                                    }//

                                                    onAccepted: {
                                                        const val = Number(text)
                                                        if(isNaN(val)) return

                                                        ////console.debug("val: " + val)
                                                        props.ifaVelocityNom = val
                                                        props.ifaVelocityNomStrf = text
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
                                    Component.onCompleted: {count = Qt.binding(function(){return props.stabilizingTimer})}
                                }//
                            }//

                            Column{
                                Row {
                                    spacing: 10
                                    TextApp{
                                        font.pixelSize: 18
                                        text: qsTr("Actual ADC (D/F)") + ":"
                                        color: "#cccccc"
                                    }//

                                    TextApp{
                                        font.pixelSize: 18
                                        text: props.dfaAdcActual
                                        color: "#cccccc"
                                    }//
                                }//
                                Row {
                                    spacing: 10
                                    TextApp{
                                        font.pixelSize: 18
                                        text: qsTr("Actual ADC (I/F)") + ":"
                                        color: "#cccccc"
                                    }//

                                    TextApp{
                                        font.pixelSize: 18
                                        text: props.ifaAdcActual
                                        color: "#cccccc"
                                    }//
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
                                                text: qsTr("Downflow nominal")
                                                font.pixelSize: 18
                                            }//

                                            TextApp {
                                                text: ":" + props.dfaVelocityNomStrf + " " + props.measureUnitStr
                                                font.pixelSize: 18
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            id: zeroAdcRow

                                            TextApp{
                                                width: 300
                                                text: qsTr("Downflow ADC zero") + " (DF0)"
                                                font.pixelSize: 18
                                            }//

                                            TextApp {
                                                text: ":" + props.dfaSensorAdcZero
                                                font.pixelSize: 18
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}
                                                                               Rectangle {height: 1; width: parent.width; color: "#cccccc"}
                                        Row {
                                            TextApp{
                                                width: 300
                                                text: qsTr("Downflow ADC nominal") + " (DF2)"
                                                font.pixelSize: 18
                                            }//

                                            TextApp {
                                                text: ":" + props.dfaAdcResult
                                                font.pixelSize: 18
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}
                                        ////////////////////////////

                                        Row{
                                            TextApp{
                                                width: 300
                                                text: qsTr("Inflow nominal")
                                                font.pixelSize: 18
                                            }//

                                            TextApp {
                                                text: ":" + props.ifaVelocityNomStrf + " " + props.measureUnitStr
                                                font.pixelSize: 18
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            id: zeroAdcRowIfa

                                            TextApp{
                                                width: 300
                                                text: qsTr("Inflow ADC zero") + " (IF0)"
                                                font.pixelSize: 18
                                            }//

                                            TextApp {
                                                text: ":" + props.ifaSensorAdcZero
                                                font.pixelSize: 18
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            TextApp{
                                                width: 300
                                                text: qsTr("Inflow ADC nominal") + " (IF2)"
                                                font.pixelSize: 18
                                            }//

                                            TextApp {
                                                text: ":" + props.ifaAdcResult
                                                font.pixelSize: 18
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}
                                        ///////////////////////////

                                        Row {
                                            id: fanNomCalibRow

                                            TextApp{
                                                width: 300
                                                text: qsTr("Downflow Fan nominal")
                                                font.pixelSize: 18
                                            }//

                                            TextApp {
                                                text: ":" + props.dfaFanDutyCycleResult + "% / " + props.dfaFanRpmResult + " RPM"
                                                font.pixelSize: 18
                                            }//
                                        }//
                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}
                                        Row {
                                            id: fanNomCalibRowIfa

                                            TextApp{
                                                width: 300
                                                text: qsTr("Inflow Fan nominal")
                                                font.pixelSize: 18
                                            }//

                                            TextApp {
                                                text: ":" + props.ifaFanDutyCycleResult + "%"/* + props.ifaFanRpmResult + " RPM"*/
                                                font.pixelSize: 18
                                            }//
                                        }//

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            id: temperatureCalibRow

                                            TextApp{
                                                width: 300
                                                text: qsTr("Temperature calib")
                                                font.pixelSize: 18
                                            }//

                                            TextApp {
                                                text: ":" + props.temperatureCalibStrf + " / ADC: " + props.temperatureCalibAdc
                                                font.pixelSize: 18
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
                                                          })//
                                    return
                                }//

                                if (fragmentStackView.currentItem.idname === "result"){
                                    if(props.calibrateDone) {
                                        let intent = IntentApp.create(uri,
                                                                      {
                                                                          "pid": props.pid,
                                                                          "ifaSensorAdcNominal": props.ifaAdcNominalResult,
                                                                          "ifaSensorVelNominal": props.ifaVelocity,
                                                                          "dfaSensorAdcNominal": props.dfaAdcNominalResult,
                                                                          "dfaSensorVelNominal": props.dfaVelocity,
                                                                          "ifaFanDutyCycleResult": props.ifaFanDutyCycleResult,
                                                                          "dfaFanDutyCycleResult": props.dfaFanDutyCycleResult,
                                                                          "dfaFanRpmResult": props.dfaFanRpmResult,
                                                                          "temperatureCalib": props.temperatureCalib,
                                                                          "temperatureCalibAdc": props.temperatureCalibAdc
                                                                      })//
                                        finishView(intent);
                                        return
                                    }//
                                }//

                                var intent = IntentApp.create(uri, {})
                                finishView(intent)
                            }//
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

        QtObject {
            id: props

            property string pid: ""

            property int ifaFanDutyCycleActual: 0
            property int ifaFanRpmActual: 0
            property int dfaFanDutyCycleActual: 0
            property int dfaFanRpmActual: 0

            property int ifaAdcActual: 0
            property int dfaAdcActual: 0

            property int ifaSensorAdcZero: 0
            property int ifaAdcNominalResult: 0
            //property int ifaAdcMinimumResult: 0

            property int dfaSensorAdcZero: 0
            property int dfaAdcNominalResult: 0
            //property int dfaAdcMinimumResult: 0

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
            property real   ifaVelocity: 0
            property string ifaVelocityStrf: "0"
            property real   ifaVelocityDfaNom: 0
            property string ifaVelocityDfaNomStrf: "0"

            property real   dfaVelocity: 0
            property string dfaVelocityStrf: "0"
            property real   dfaVelocityDfaNom: 0
            property string dfaVelocityDfaNomStrf: "0"

            // Required for interpolation formula
            // a - ((x2 - x1) / (y2 - y1) * (b - y1))
            // IFF = newNomAdc - ((velocityNomAdcRef - velocityMinAdcRef) / (velocityNomRef - velocityMinRef) * (newNomVelocity - velocityMinRef))
            property real ifaVelocityNomAdcRef: 0
            property real ifaVelocityNomRef: 0
            //
            //            property real velocityMinAdcRef: 0
            //            property real velocityMinRef: 0
            property real dfaVelocityNomAdcRef: 0
            property real dfaVelocityNomRef: 0

            property int ifaFanDutyCycleInitial: 0
            property int ifaFanDutyCycleResult: 0
            //property int ifaFanRpmResult: 0

            property int dfaFanDutyCycleInitial: 0
            property int dfaFanDutyCycleResult: 0
            property int dfaFanRpmResult: 0

            property int temperatureCalib: 0
            property int temperatureCalibAdc: 0
            property string temperatureCalibStrf: ""

            property int stabilizingTimer : 180

            property bool calibrateDone: false
        }//

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

                    props.ifaFanDutyCycleInitial = extradata['ifaFanDutyCycle'] || 0
                    props.dfaFanDutyCycleInitial = extradata['dfaFanDutyCycle'] || 0

                    props.ifaSensorAdcZero     = extradata['ifaSensorAdcZero'] || 0
                    props.dfaSensorAdcZero     = extradata['dfaSensorAdcZero'] || 0

                    let ifaVelocity = extradata['ifaSensorVelNominal'] || 0
                    props.ifaVelocity = ifaVelocity
                    props.ifaVelocityStrf = ifaVelocity.toFixed(props.velocityDecimalPoint)

                    let dfaVelocity = extradata['dfaSensorVelNominal'] || 0
                    props.dfaVelocity = dfaVelocity
                    props.dfaVelocityStrf = dfaVelocity.toFixed(props.velocityDecimalPoint)

                    /// Ref. for interpolation
                    let ifaVelocityNomAdcRef = extradata['ifaVelNomAdcRef'] || 0
                    //                        //console.debug(velocityNomAdcRef)
                    props.ifaVelocityNomAdcRef = ifaVelocityNomAdcRef

                    let ifaVelocityNomRef = extradata['ifaVelNomRef'] || 0
                    //                        //console.debug(velocityNomRef)
                    props.ifaVelocityNomRef = ifaVelocityNomRef

                    ////
                    let dfaVelocityNomAdcRef = extradata['dfaVelNomAdcRef'] || 0
                    //                        //console.debug(velocityNomAdcRef)
                    props.dfaVelocityNomAdcRef = dfaVelocityNomAdcRef

                    let dfaVelocityNomRef = extradata['dfaVelNomRef'] || 0
                    //                        //console.debug(velocityNomRef)
                    props.dfaVelocityNomRef = dfaVelocityNomRef
                }//

                /// Real-Time update
                props.ifaFanDutyCycleActual = Qt.binding(function(){ return MachineData.fanInflowDutyCycle })
                //props.ifaFanRpmActual = Qt.binding(function(){ return MachineData.fanPrimaryRpm })
                props.dfaFanDutyCycleActual = Qt.binding(function(){ return MachineData.fanPrimaryDutyCycle })
                props.dfaFanRpmActual = Qt.binding(function(){ return MachineData.fanPrimaryRpm })
                //
                props.ifaAdcActual = Qt.binding(function(){ return MachineData.ifaAdcConpensation })
                props.dfaAdcActual = Qt.binding(function(){ return MachineData.dfaAdcConpensation })
                //
                props.temperatureActual = Qt.binding(function(){ return MachineData.temperature })
                props.temperatureActualStr = Qt.binding(function(){ return MachineData.temperatureValueStr })

                /// Automatically adjust the fan duty cycle
                //                    //console.debug(props.fanDutyCycleActual + " vs " + props.fanDutyCycleInitial)
                if ((props.ifaFanDutyCycleActual != props.ifaFanDutyCycleInitial)
                        || props.dfaFanDutyCycleActual != props.dfaFanDutyCycleInitial) {

                    MachineAPI.setFanInflowDutyCycle(props.ifaFanDutyCycleInitial);
                    MachineAPI.setFanPrimaryDutyCycle(props.dfaFanDutyCycleInitial);

                    viewApp.showBusyPage(qsTr("Adjusting fan duty cycle..."),
                                         function onTriggered(cycle){
                                             if(cycle === 5){
                                                 // close this pop up dialog
                                                 viewApp.dialogObject.close()
                                             }
                                         })//
                }//

                if(!MachineData.getDownflowSensorConstant() && !MachineData.getInflowSensorConstant())
                    props.stabilizingTimer = MachineData.warmingUpTime <= 180 ? MachineData.warmingUpTime : 180
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

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";formeditorZoom:0.66;height:600;width:1024}
}
##^##*/
