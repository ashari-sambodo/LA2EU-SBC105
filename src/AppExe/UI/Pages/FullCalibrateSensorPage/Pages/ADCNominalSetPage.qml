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
                                                            Column{
                                                                anchors.verticalCenter: parent.verticalCenter
                                                                TextApp {
                                                                    text: "Dcy: " + props.dfaFanDutyCycleActual
                                                                }//
                                                                TextApp {
                                                                    text: "RPM: " + props.dfaFanRpmActual
                                                                }//
                                                            }//
                                                        }//
                                                    }
                                                    Item {
                                                        Layout.fillWidth: true
                                                        Layout.fillHeight: true
                                                        Image {
                                                            id: fanImage
                                                            source: "qrc:/UI/Pictures/controll/Fan_W.png"
                                                            height: parent.height
                                                            anchors.centerIn: parent
                                                            fillMode: Image.PreserveAspectFit

                                                            states: State {
                                                                name: "stateOn"
                                                                when: props.dfaFanDutyCycleActual
                                                                PropertyChanges {
                                                                    target: fanImage
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
                                                text: qsTr("Set DF Low Alarm") + ":"
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
                                                    text: props.dfaVelocityMinStrf

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
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Set Downflow Low Alarm"))
                                                    }//

                                                    onAccepted: {
                                                        const val = Number(text)
                                                        if(isNaN(val)) return

                                                        //                                                        //console.debug("val: " + val)

                                                        props.dfaVelocityMin = val
                                                        props.dfaVelocityMinStrf = text
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
                                                text: qsTr("Set DF High Alarm") + ":"
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
                                                    text: props.dfaVelocityMaxStrf

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
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Set Downflow High Alarm"))
                                                    }//

                                                    onAccepted: {
                                                        const val = Number(text)
                                                        if(isNaN(val)) return

                                                        ////console.debug("val: " + val)
                                                        props.dfaVelocityMax = val
                                                        props.dfaVelocityMaxStrf = text
                                                    }//
                                                }//
                                            }//
                                        }//
                                    }//
                                }//
                            }//
                            ////////////////////////////////
                            Item{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                ColumnLayout{
                                    anchors.fill: parent
                                    spacing: 10
                                    Item{
                                        Layout.minimumHeight: 150
                                        Layout.fillWidth: true
                                        TextApp {
                                            height: parent.height
                                            width: parent.width
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignBottom
                                            wrapMode: Text.WordWrap
                                            padding: 10
                                            text: qsTr("Downflow and Inflow fan must be at Nominal speed.")
                                        }
                                    }
                                    Item{
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        RowLayout{
                                            anchors.fill: parent
                                            Item{
                                                id: id0
                                                Layout.fillHeight: true
                                                Layout.fillWidth: true
                                                Column{
                                                    spacing: 10
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    TextApp {
                                                        wrapMode: Text.WordWrap
                                                        text: qsTr("Sensor Constant")
                                                        width: id0.width
                                                        horizontalAlignment: Text.AlignRight
                                                    }
                                                    TextApp {
                                                        wrapMode: Text.WordWrap
                                                        text: qsTr("Temperature")
                                                        width: id0.width
                                                        horizontalAlignment: Text.AlignRight
                                                    }
                                                    TextApp {
                                                        wrapMode: Text.WordWrap
                                                        text: qsTr("DF Sensor ADC")
                                                        width: id0.width
                                                        horizontalAlignment: Text.AlignHCenter
                                                    }
                                                    TextApp{
                                                        id: currentTextApp1
                                                        font.pixelSize: 52
                                                        text: props.dfaAdcActual
                                                        width: id0.width
                                                        horizontalAlignment: Text.AlignHCenter
                                                    }//
                                                }
                                            }
                                            Item{
                                                id: id1
                                                Layout.fillHeight: true
                                                Layout.fillWidth: true
                                                Column{
                                                    spacing: 10
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    TextApp {
                                                        wrapMode: Text.WordWrap
                                                        text: (": DF: %1 | IF: %2").arg(props.dfaSensorConstant).arg(props.ifaSensorConstant)
                                                    }
                                                    TextApp {
                                                        wrapMode: Text.WordWrap
                                                        text: ": " + props.temperatureActualStr
                                                    }
                                                    TextApp {
                                                        wrapMode: Text.WordWrap
                                                        text: qsTr("IF Sensor ADC")
                                                        width: id1.width
                                                        horizontalAlignment: Text.AlignHCenter
                                                    }
                                                    TextApp{
                                                        id: currentTextApp2
                                                        font.pixelSize: 52
                                                        text: props.ifaAdcActual
                                                        width: id1.width
                                                        horizontalAlignment: Text.AlignHCenter
                                                    }//
                                                }
                                            }
                                        }
                                    }
                                    Item{
                                        Layout.minimumHeight: 150
                                        Layout.fillWidth: true
                                        TextApp {
                                            height: parent.height
                                            width: parent.width
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignTop
                                            wrapMode: Text.WordWrap
                                            padding: 10
                                            text:  "* " + qsTr("Please wait until the value are stable")
                                            font.italic: true
                                            color: "#cda776"
                                        }
                                    }
                                }
                            }//
                            ////////////////////////////////////
                            Item {
                                id: rightContentItem2
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
                                                                when: props.ifaFanDutyCycleActual
                                                                PropertyChanges {
                                                                    target: fanImage
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
                                                text: qsTr("Set IF Low Alarm") + ":"
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
                                                    text: props.ifaVelocityMinStrf

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
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Set Downflow Low Alarm"))
                                                    }//

                                                    onAccepted: {
                                                        const val = Number(text)
                                                        if(isNaN(val)) return

                                                        //                                                        //console.debug("val: " + val)

                                                        props.ifaVelocityMin = val
                                                        props.ifaVelocityMinStrf = text
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

                                            let dfaAdc = props.dfaAdcActual
                                            let dfaFanDutyCycle = props.dfaFanDutyCycleActual
                                            let dfaFanRpm = props.dfaFanRpmActual
                                            let dfaVelocityValid = (props.dfaVelocityNom > props.dfaVelocityMin && props.dfaVelocityMax > props.dfaVelocityNom) ? true : false
                                            let dfaAdcNominalValid = (dfaAdc - props.dfaSensorAdcZero) >= 80 ? true : false
                                            //let dfaAdcMinimumValid = (dfaAdc - props.sensorAdcMinimum) >= 80 ? true : false

                                            let ifaAdc = props.ifaAdcActual
                                            let ifaFanDutyCycle = props.ifaFanDutyCycleActual
                                            //let ifaFanRpm = props.ifaFanRpmActual
                                            let ifaVelocityValid = (props.ifaVelocityNom > props.ifaVelocityMin) ? true : false
                                            let ifaAdcNominalValid = (ifaAdc - props.ifaSensorAdcZero) >= 80 ? true : false
                                            //let ifaAdcMinimumValid = (ifaAdc - props.sensorAdcMinimum) >= 80 ? true : false

                                            let temperatureCalib = props.temperatureActual
                                            let temperatureCalibAdc = props.temperatureAdcActual
                                            let temperatureCalibStrf = props.temperatureActualStr

                                            //                                            ////demo
                                            //                                            adc = 2000
                                            //                                            fanDutyCycle = 50
                                            //                                            fanRpm = 700
                                            //                                            velocityValid = true
                                            //                                            adcNominalValid = true
                                            //                                            adcMinimumValid = true
                                            //                                            temperatureCalib = props.measureUnit ? 20 : 67
                                            //                                            temperatureCalibStrf = props.measureUnit ? "20°C" : "20°F"

                                            if (dfaAdcNominalValid && dfaVelocityValid && dfaFanDutyCycle &&
                                                    ifaAdcNominalValid && ifaVelocityValid && ifaFanDutyCycle) {
                                                props.calibrateDone = true
                                            }

                                            props.dfaAdcResult = dfaAdc
                                            props.dfaFanDutyCycleResult = dfaFanDutyCycle
                                            props.dfaFanRpmResult = dfaFanRpm

                                            props.ifaAdcResult = ifaAdc
                                            props.ifaFanDutyCycleResult = ifaFanDutyCycle
                                            //props.ifaFanRpmResult = ifaFanRpm

                                            props.temperatureCalib = temperatureCalib
                                            props.temperatureCalibAdc = temperatureCalibAdc
                                            props.temperatureCalibStrf = temperatureCalibStrf

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
                                                text: qsTr("Downflow vel. minimum") + ":"
                                            }//

                                            TextApp {
                                                text: props.dfaVelocityMinStrf + " " + props.measureUnitStr
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row{
                                            TextApp{
                                                width: 300
                                                text: qsTr("Downflow vel. nominal") + ":"
                                            }//

                                            TextApp {
                                                text: props.dfaVelocityNomStrf + " " + props.measureUnitStr
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row{
                                            TextApp{
                                                width: 300
                                                text: qsTr("Downflow vel. maximum") + ":"
                                            }//

                                            TextApp {
                                                text: props.dfaVelocityMaxStrf + " " + props.measureUnitStr
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            id: zeroAdcRow

                                            TextApp{
                                                width: 300
                                                text: qsTr("ADC zero") + " (DF0)" + ":"
                                            }//

                                            TextApp {
                                                text: props.dfaSensorAdcZero
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}
                                        //                                        Row {
                                        //                                            TextApp{
                                        //                                                width: 300
                                        //                                                text: qsTr("ADC minimum") + " (IF1)" + ":"
                                        //                                            }//

                                        //                                            TextApp {
                                        //                                                text: props.dfaSensorAdcMinimum
                                        //                                            }
                                        //                                        }

                                        //                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}
                                        Row {
                                            TextApp{
                                                width: 300
                                                text: qsTr("ADC nominal") + " (DF2)" + ":"
                                            }//

                                            TextApp {
                                                text: props.dfaAdcResult
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}
                                        ////////////////////////////
                                        Row{
                                            TextApp{
                                                width: 300
                                                text: qsTr("Inflow vel. minimum") + ":"
                                            }//

                                            TextApp {
                                                text: props.ifaVelocityMinStrf + " " + props.measureUnitStr
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row{
                                            TextApp{
                                                width: 300
                                                text: qsTr("Inflow vel. nominal") + ":"
                                            }//

                                            TextApp {
                                                text: props.ifaVelocityNomStrf + " " + props.measureUnitStr
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row{
                                            TextApp{
                                                width: 300
                                                text: qsTr("Inflow vel. maximum") + ":"
                                            }//

                                            TextApp {
                                                text: props.ifaVelocityMaxStrf + " " + props.measureUnitStr
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            id: zeroAdcRowIfa

                                            TextApp{
                                                width: 300
                                                text: qsTr("ADC zero") + " (IF0)" + ":"
                                            }//

                                            TextApp {
                                                text: props.ifaSensorAdcZero
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}
                                        //                                        Row {
                                        //                                            TextApp{
                                        //                                                width: 300
                                        //                                                text: qsTr("ADC minimum") + " (IF1)" + ":"
                                        //                                            }//

                                        //                                            TextApp {
                                        //                                                text: props.dfaSensorAdcMinimum
                                        //                                            }
                                        //                                        }

                                        //                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}
                                        Row {
                                            TextApp{
                                                width: 300
                                                text: qsTr("ADC nominal") + " (IF2)" + ":"
                                            }//

                                            TextApp {
                                                text: props.idfaAdcResult
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}
                                        ///////////////////////////

                                        Row {
                                            id: fanNomCalibRow

                                            TextApp{
                                                width: 300
                                                text: qsTr("Fan nominal") + " (D/F)" + ":"
                                            }//

                                            TextApp {
                                                text: props.dfaFanDutyCycleResult + "% / " + props.dfaFanRpmResult + " RPM"
                                            }//
                                        }//
                                        Row {
                                            id: fanNomCalibRowIfa

                                            TextApp{
                                                width: 300
                                                text: qsTr("Fan nominal") + " (I/F)" + ":"
                                            }//

                                            TextApp {
                                                text: props.ifaFanDutyCycleResult + "%"/* + props.ifaFanRpmResult + " RPM"*/
                                            }//
                                        }//

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            id: temperatureCalibRow

                                            TextApp{
                                                width: 300
                                                text: qsTr("Temperature calib") + ":"
                                            }//

                                            TextApp {
                                                text: props.temperatureCalibStrf + " / ADC: " + props.temperatureCalibAdc
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
                                resultiInfoText.visible = true
                                resultiInfoText.text = qsTr("The required ADC range between each point (IF0<IF1<IF2) is ") + "80"
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

                                    viewApp.showDialogAsk(qsTr("ADC Nominal"),
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
                                                                          "dfaSensorAdcNominal": props.dfaAdcResult,
                                                                          "dfaSensorVelNominal": props.dfaVelocityNom,
                                                                          "dfaFanDutyCycleResult": props.dfaFanDutyCycleResult,
                                                                          "dfaFanRpmResult": props.dfaFanRpmResult,

                                                                          "ifaSensorAdcNominal": props.ifaAdcResult,
                                                                          "ifaSensorVelNominal": props.ifaVelocityNom,
                                                                          "ifaFanDutyCycleResult": props.ifaFanDutyCycleResult,
                                                                          //"ifaFanRpmResult": props.ifaFanRpmResult,

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

            property int dfaFanDutyCycleActual: 0
            property int dfaFanRpmActual: 0
            property int ifaFanDutyCycleActual: 0
            //            property int ifaFanRpmActual: 0

            property int dfaSensorAdcZero: 0
            //            property int dfaSensorAdcMinimum: 0
            property int ifaSensorAdcZero: 0
            //            property int ifaSensorAdcMinimum: 0

            property int dfaAdcActual: 0
            property int dfaAdcResult: 0
            property int ifaAdcActual: 0
            property int ifaAdcResult: 0

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
            property real dfaVelocityNom: 0
            property string dfaVelocityNomStrf: "0"
            property real ifaVelocityNom: 0
            property string ifaVelocityNomStrf: "0"
            //
            property real dfaVelocityMin: 0
            property string dfaVelocityMinStrf: "0"
            property real ifaVelocityMin: 0
            property string ifaVelocityMinStrf: "0"

            property real dfaVelocityMax: 0
            property string dfaVelocityMaxStrf: "0"

            property int dfaFanDutyCycleInitial: 0
            property int ifaFanDutyCycleInitial: 0

            property int dfaFanDutyCycleResult: 0
            property int dfaFanRpmResult: 0
            property int ifaFanDutyCycleResult: 0
            //            property int ifaFanRpmResult: 0

            property int dfaSensorConstant: 0
            property int ifaSensorConstant: 0

            property int temperatureCalib: 0
            property int temperatureCalibAdc: 0
            property string temperatureCalibStrf: ""

            property bool calibrateDone: false
            property int stabilizingTimer : 180
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

                    props.dfaFanDutyCycleInitial = extradata['dfaFanDutyCycle'] || 0
                    props.ifaFanDutyCycleInitial = extradata['ifaFanDutyCycle'] || 0

                    props.ifaSensorAdcZero     = extradata['ifaSensorAdcZero'] || 0
                    props.dfaSensorAdcZero     = extradata['dfaSensorAdcZero'] || 0
                    //                    props.sensorAdcMinimum  = extradata['sensorAdcMinimum'] || 0

                    let ifaSensorVelMinimum = extradata['ifaSensorVelMinimum'] || 0
                    props.ifaVelocityMin = ifaSensorVelMinimum
                    props.ifaVelocityMinStrf = ifaSensorVelMinimum.toFixed(props.velocityDecimalPoint)

                    let ifaSensorVelNominal = extradata['ifaSensorVelNominal'] || 0
                    props.ifaVelocityNom = ifaSensorVelNominal
                    props.ifaVelocityNomStrf = ifaSensorVelNominal.toFixed(props.velocityDecimalPoint)


                    let dfaSensorVelMinimum = extradata['dfaSensorVelMinimum'] || 0
                    props.dfaVelocityNom = dfaSensorVelMinimum
                    props.dfaVelocityNomStrf = dfaSensorVelMinimum.toFixed(props.velocityDecimalPoint)
                    let dfaSensorVelNominal = extradata['dfaSensorVelNominal'] || 0
                    props.dfaVelocityMax = dfaSensorVelNominal
                    props.dfaVelocityNomStrf = dfaSensorVelNominal.toFixed(props.velocityDecimalPoint)
                    let dfaSensorVelMaximum = extradata['dfaSensorVelMaximum'] || 0
                    props.dfaVelocityMax = dfaSensorVelMaximum
                    props.dfaVelocityMaxStrf = dfaSensorVelMaximum.toFixed(props.velocityDecimalPoint)

                    props.dfaSensorConstant = extradata['dfaSensorConstant'] || 0
                    props.ifaSensorConstant = extradata['ifaSensorConstant'] || 0
                    //                //console.debug(props.velocity)
                    //                //console.debug(props.velocityStrf)
                }

                props.dfaFanDutyCycleActual = Qt.binding(function(){ return MachineData.fanPrimaryDutyCycle })
                props.dfaFanRpmActual = Qt.binding(function(){ return MachineData.fanPrimaryRpm })
                props.ifaFanDutyCycleActual = Qt.binding(function(){ return MachineData.fanInflowDutyCycle })
                //                props.ifaFanRpmActual = Qt.binding(function(){ return MachineData.fanPrimaryRpm })

                props.ifaAdcActual = Qt.binding(function(){ return MachineData.ifaAdcConpensation })
                props.dfaAdcActual = Qt.binding(function(){ return MachineData.dfaAdcConpensation })

                props.temperatureActual = Qt.binding(function(){ return MachineData.temperature })
                props.temperatureAdcActual = Qt.binding(function(){ return MachineData.temperatureAdc })
                props.temperatureActualStr = Qt.binding(function(){ return MachineData.temperatureValueStr })

                /// Automatically adjust the fan duty cycle
                //                    //console.debug(props.fanDutyCycleActual + " vs " + props.fanDutyCycleInitial)
                if (props.dfaFanDutyCycleActual != props.dfaFanDutyCycleInitial || props.ifaFanDutyCycleActual != props.ifaFanDutyCycleInitial) {

                    MachineAPI.setFanPrimaryDutyCycle(props.dfaFanDutyCycleInitial);
                    MachineAPI.setFanInflowDutyCycle(props.ifaFanDutyCycleInitial);

                    viewApp.showBusyPage(qsTr("Adjusting fan duty cycle..."),
                                         function onTriggered(cycle){
                                             if(cycle === 5){
                                                 // close this pop up dialog
                                                 viewApp.dialogObject.close()
                                             }
                                         })
                }
                if(!props.dfaSensorConstant && !props.ifaSensorConstant)
                    props.stabilizingTimer = 30
                else
                    props.stabilizingTimer = 180
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }//
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";formeditorZoom:1.25;height:480;width:800}
}
##^##*/
