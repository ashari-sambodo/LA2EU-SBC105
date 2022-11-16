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

                                            Item{
                                                Layout.fillWidth: true
                                                Layout.minimumHeight: 30
                                                TextApp {
                                                    width: parent.width
                                                    height: parent.height
                                                    font.pixelSize: 14
                                                    text: qsTr("Tap here to adjust")
                                                    wrapMode: Text.WordWrap
                                                }
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
                                                                        id: dfaDcyText
                                                                        text: qsTr("Dcy: ") + utilsApp.getFanDucyStrf(props.dfaFanDutyCycleActual) + "%"
                                                                        states: [
                                                                            State {
                                                                                when: props.dfaFanDutyCycleActual == 0
                                                                                PropertyChanges {
                                                                                    target: dfaDcyText
                                                                                    color: "red"
                                                                                }
                                                                            }//
                                                                        ]//
                                                                    }//
                                                                    TextApp {
                                                                        id: dfaRpmText
                                                                        text: qsTr("RPM: ") + props.dfaFanRpmActual
                                                                        states: [
                                                                            State {
                                                                                when: MachineData.cabinetWidth3Feet
                                                                                PropertyChanges {
                                                                                    target: dfaRpmText
                                                                                    color: "#0F2952"
                                                                                }
                                                                            },//
                                                                            State {
                                                                                when: props.dfaFanRpmActual == 0
                                                                                PropertyChanges {
                                                                                    target: dfaRpmText
                                                                                    color: "red"
                                                                                }
                                                                            }//
                                                                        ]//
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
                                            //validator: IntValidator{bottom: 0; top: 99;}

                                            Connections {
                                                target: fanSpeedMouseArea

                                                function onClicked() {
                                                    //                                        //console.debug(index)
                                                    fanSpeedBufferTextInput.text = utilsApp.getFanDucyStrf(props.dfaFanDutyCycleActual)

                                                    KeyboardOnScreenCaller.openNumpad(fanSpeedBufferTextInput, qsTr("Fan Duty Cycle") + " " + "(0-99)")
                                                }//
                                            }//

                                            onAccepted: {
                                                let val = Number(text)*10
                                                if(isNaN(val) || val > 990 || val < 0) return

                                                MachineAPI.setFanPrimaryDutyCycle(val)

                                                viewApp.showBusyPage(qsTr("Adjusting fan duty cycle..."),
                                                                     function onTriggered(cycle){
                                                                         if(cycle === MachineAPI.BUSY_CYCLE_2){ viewApp.dialogObject.close() }
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
                                            id: colLeft
                                            anchors.fill: parent
                                            anchors.margins: 3
                                            spacing: 1

                                            TextApp {
                                                width: colLeft.width
                                                font.pixelSize: 18
                                                text: qsTr("Minimum Downflow") + ":"
                                            }//

                                            TextApp {
                                                width: colLeft.width
                                                font.pixelSize: 18
                                                text: props.measureUnitStr
                                            }//

                                            Item {
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true

                                                TextField {
                                                    id: dfaNomText
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

                                                    states: [
                                                        State {
                                                            when: props.dfaVelocityMin <= 0
                                                            PropertyChanges {
                                                                target: dfaNomText
                                                                color: "red"
                                                            }
                                                        }
                                                    ]//

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Minimum Downflow"))
                                                    }//

                                                    onAccepted: {
                                                        const val = Number(text)
                                                        if(isNaN(val)) return

                                                        ////console.debug("val: " + val)
                                                        props.dfaVelocityMin = val
                                                        props.dfaVelocityMinStrf = text
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
                                                width: colLeft.width
                                                font.pixelSize: 18
                                                text: qsTr("Low Downflow Alarm") + ":"
                                            }//

                                            TextApp {
                                                width: colLeft.width
                                                font.pixelSize: 18
                                                text: props.measureUnitStr
                                            }//

                                            Item {
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true

                                                TextField {
                                                    id: dfaMinText
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

                                                    states: [
                                                        State {
                                                            when: props.dfaVelocityLowAlarm <= 0
                                                            PropertyChanges {
                                                                target: dfaMinText
                                                                color: "red"
                                                            }
                                                        }
                                                    ]//

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Low Downflow Alarm"))
                                                    }//

                                                    onAccepted: {
                                                        const val = Number(text)
                                                        if(isNaN(val)) return

                                                        //                                                        //console.debug("val: " + val)

                                                        props.dfaVelocityLowAlarm = val
                                                        props.dfaVelocityLowAlarmStrf = text
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
                                        text: qsTr("Downflow and Inflow fan must be at Minimum speed!")
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
                                                    text: qsTr("DF Sensor ADC:")
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
                                                    text: qsTr("IF Sensor ADC:")
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

                                            Item{
                                                Layout.fillWidth: true
                                                Layout.minimumHeight: 30
                                                TextApp {
                                                    width: parent.width
                                                    height: parent.height
                                                    font.pixelSize: 14
                                                    text: qsTr("Tap here to adjust")
                                                    wrapMode: Text.WordWrap
                                                }
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
                                                                        id: ifaDcyText
                                                                        text: qsTr("Dcy: ") + utilsApp.getFanDucyStrf(props.ifaFanDutyCycleActual) + "%"
                                                                        states: [
                                                                            State {
                                                                                when: props.ifaFanDutyCycleActual == 0
                                                                                PropertyChanges {
                                                                                    target: ifaDcyText
                                                                                    color: "red"
                                                                                }
                                                                            }//
                                                                        ]//
                                                                    }//
                                                                    TextApp {
                                                                        id: ifaRpmText
                                                                        text: qsTr("RPM: ") + props.ifaFanRpmActual
                                                                        color: MachineData.getDualRbmMode() ? "#e3dac9" : "#0F2952"
                                                                        states: [
                                                                            State {
                                                                                when: props.ifaFanRpmActual == 0
                                                                                PropertyChanges {
                                                                                    target: ifaRpmText
                                                                                    color: MachineData.getDualRbmMode() ? "red" : "#0F2952"
                                                                                }
                                                                            }//
                                                                        ]//
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
                                            //validator: IntValidator{bottom: 0; top: 99;}

                                            Connections {
                                                target: fanSpeedMouseArea2

                                                function onClicked() {
                                                    //                                        //console.debug(index)
                                                    fanSpeedBufferTextInput2.text = utilsApp.getFanDucyStrf(props.ifaFanDutyCycleActual)

                                                    KeyboardOnScreenCaller.openNumpad(fanSpeedBufferTextInput2, qsTr("Fan Duty Cycle") + " " + "(0-99)")
                                                }//
                                            }//

                                            onAccepted: {
                                                let val = Number(text)*10
                                                if(isNaN(val) || val > 990 || val < 0) return

                                                MachineAPI.setFanInflowDutyCycle(val)

                                                viewApp.showBusyPage(qsTr("Adjusting fan duty cycle..."),
                                                                     function onTriggered(cycle){
                                                                         if(cycle === MachineAPI.BUSY_CYCLE_2){ viewApp.dialogObject.close() }
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
                                            id: colRight
                                            anchors.fill: parent
                                            anchors.margins: 3
                                            spacing: 1

                                            TextApp {
                                                width: colRight.width
                                                font.pixelSize: 18
                                                text: qsTr("Minimum Inflow") + ":"
                                            }//

                                            TextApp {
                                                width: colRight.width
                                                font.pixelSize: 18
                                                text: props.measureUnitStr
                                            }//

                                            Item {
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true

                                                TextField {
                                                    id: ifaNomText
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
                                                    states: [
                                                        State {
                                                            when: props.ifaVelocityMin <= 0
                                                            PropertyChanges {
                                                                target: ifaNomText
                                                                color: "red"
                                                            }
                                                        }
                                                    ]//
                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Minimum Inflow"))
                                                    }//

                                                    onAccepted: {
                                                        const val = Number(text)
                                                        if(isNaN(val)) return

                                                        ////console.debug("val: " + val)
                                                        props.ifaVelocityMin = val
                                                        props.ifaVelocityMinStrf = text
                                                    }//
                                                }//
                                            }//
                                        }//
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
                                                width: colRight.width
                                                font.pixelSize: 18
                                                text: qsTr("Low Inflow Alarm") + ":"
                                            }//

                                            TextApp {
                                                width: colRight.width
                                                font.pixelSize: 18
                                                text: props.measureUnitStr
                                            }//

                                            Item {
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true

                                                TextField {
                                                    id: ifaMinText
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    width: parent.width - 2
                                                    font.pixelSize: 24
                                                    horizontalAlignment: Text.AlignHCenter
                                                    color: "#dddddd"
                                                    text: props.ifaVelocityLowAlarmStrf

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
                                                    states: [
                                                        State {
                                                            when: props.ifaVelocityLowAlarm <= 0
                                                            PropertyChanges {
                                                                target: ifaMinText
                                                                color: "red"
                                                            }
                                                        }
                                                    ]//
                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Low Inflow Alarm"))
                                                    }//

                                                    onAccepted: {
                                                        const val = Number(text)
                                                        if(isNaN(val)) return

                                                        //                                                        //console.debug("val: " + val)

                                                        props.ifaVelocityLowAlarm = val
                                                        props.ifaVelocityLowAlarmStrf = text
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

                                            let dfaAdc = props.dfaAdcActual
                                            let dfaFanDutyCycle = props.dfaFanDutyCycleActual
                                            let dfaFanRpm = props.dfaFanRpmActual
                                            let dfaAdcValid = (adc - 0) >= 80 ? true : false
                                            let dfaVelocityValid = props.dfaVelocityMin > 0 ? true : false
                                            ///
                                            let ifaAdc = props.ifaAdcActual
                                            let ifaFanDutyCycle = props.ifaFanDutyCycleActual
                                            let ifaFanRpm = props.ifaFanRpmActual
                                            let ifaAdcValid = (adc - 0) >= 80 ? true : false
                                            let ifaVelocityValid = props.ifaVelocityMin > 0 ? true : false

                                            //                                            console.log("adcMin: " + adc)

                                            //demo
                                            //                                            adc = 1000
                                            //                                            fanDutyCycle = 30
                                            //                                            fanRpm = 500
                                            //                                            adcValid = true
                                            //                                            velocityValid = true

                                            if (dfaAdcValid && dfaVelocityValid && dfaFanDutyCycle
                                                    && ifaAdcValid && ifaVelocityValid && ifaFanDutyCycle) {
                                                props.calibrateDone = true
                                            }else{
                                                //                                                if(!dfaAdcNominalValid) props.calibrationFailCode = 0x0001
                                                if(!dfaVelocityValid)   props.calibrationFailCode = 0x0002
                                                if(!dfaFanDutyCycle)    props.calibrationFailCode = 0x0004
                                                //                                                if(!ifaAdcNominalValid) props.calibrationFailCode = 0x0008
                                                if(!ifaVelocityValid)   props.calibrationFailCode = 0x0010
                                                if(!ifaFanDutyCycle)    props.calibrationFailCode = 0x0020
                                                if(!dfaFanRpm)          props.calibrationFailCode = 0x0040
                                                if(!ifaFanRpm && MachineData.getDualRbmMode()) props.calibrationFailCode = 0x0080
                                                //                                                console.debug("dfaAdcNominalValid   :", dfaAdcNominalValid, props.dfaSensorAdcZero, props.dfaAdcActual)
                                                console.debug("dfaVelocityValid     :", dfaVelocityValid,   props.dfaVelocityMin/*, props.dfaVelocityNom, props.dfaVelocityMax*/)
                                                console.debug("dfaFanDutyCycle      :", dfaFanDutyCycle,    props.dfaFanDutyCycleActual)
                                                //                                                console.debug("ifaAdcNominalValid   :", ifaAdcNominalValid, props.ifaSensorAdcZero, props.ifaAdcActual)
                                                console.debug("ifaVelocityValid     :", ifaVelocityValid,   props.ifaVelocityMin/*, props.ifaVelocityNom*/)
                                                console.debug("ifaFanDutyCycle      :", ifaFanDutyCycle,    props.ifaFanDutyCycleActual)
                                                console.debug("dfaFanRpm            :", dfaFanRpm,          props.dfaFanRpmActual)
                                                console.debug("ifaFanRpm            :", dfaFanRpm,          props.ifaFanRpmActual)
                                                console.debug("Fail Calibration Code:", props.calibrationFailCode)
                                            }//

                                            props.dfaAdcResult = dfaAdc
                                            props.dfaFanDutyCycleResult = dfaFanDutyCycle
                                            props.dfaFanRpmResult = dfaFanRpm
                                            props.ifaAdcResult = ifaAdc
                                            props.ifaFanDutyCycleResult = ifaFanDutyCycle
                                            props.ifaFanRpmResult = ifaFanRpm

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
                                                text: qsTr("Minimum Velocity (DF | IF)")
                                                font.pixelSize: 18
                                            }//

                                            TextApp {
                                                text: ": (%1 %2 | %3 %2)".arg(props.dfaVelocityMinStrf).arg(props.measureUnitStr).arg(props.ifaVelocityMinStrf)
                                                font.pixelSize: 18
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row{
                                            TextApp{
                                                width: 300
                                                text: qsTr("Low Velocity alarm (DF | IF)")
                                                font.pixelSize: 18
                                            }//

                                            TextApp {
                                                text: ": (%1 %2 | %3 %2)".arg(props.dfaVelocityLowAlarmStrf).arg(props.measureUnitStr).arg(props.ifaVelocityLowAlarmStrf)
                                                font.pixelSize: 18
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row{
                                            TextApp{
                                                width: 300
                                                text: qsTr("ADC Minimum (DF | IF)")
                                                font.pixelSize: 18
                                            }//

                                            TextApp {
                                                text: ": (%1 | %2)".arg(props.dfaAdcResult).arg(props.ifaAdcResult)
                                                font.pixelSize: 18
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row{
                                            TextApp{
                                                width: 300
                                                text: qsTr("Minimum Fan Duty Cycle (DF | IF)")
                                                font.pixelSize: 18
                                            }//

                                            TextApp {
                                                text: ": (%1% | %2%)".arg(props.dfaFanDutyCycleResult).arg(props.ifaFanDutyCycleResult)
                                                font.pixelSize: 18
                                            }
                                        }

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
                                                                          "dfaSensorAdcMinimum": props.dfaAdcResult,
                                                                          "dfaSensorVelMinimum": props.dfaVelocityMin,
                                                                          "dfaSensorVelLowAlarm": props.dfaVelocityLowAlarm,
                                                                          "dfaFanDutyCycleResult": props.dfaFanDutyCycleResult,
                                                                          "dfaFanRpmResult": props.dfaFanRpmResult,
                                                                          "ifaSensorAdcMinimum": props.ifaAdcResult,
                                                                          "ifaSensorVelMinimum": props.ifaVelocityMin,
                                                                          "ifaSensorVelLowAlarm": props.ifaVelocityLowAlarm,
                                                                          "ifaFanDutyCycleResult": props.ifaFanDutyCycleResult,
                                                                          "ifaFanRpmResult": props.ifaFanRpmResult,
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

        UtilsApp {
            id: utilsApp
        }//

        /// Private property
        QtObject{
            id: props

            property string pid: ""

            property int dfaFanDutyCycleActual: 0
            property int dfaFanRpmActual: 0
            property int ifaFanDutyCycleActual: 0
            property int ifaFanRpmActual: 0

            property int dfaSensorAdcZero: 0
            property int ifaSensorAdcZero: 0

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

            property real dfaVelocityMin: 0
            property string dfaVelocityMinStrf: "0"
            property real ifaVelocityMin: 0
            property string ifaVelocityMinStrf: "0"

            property real dfaVelocityLowAlarm: 0
            property string dfaVelocityLowAlarmStrf: "0"
            property real ifaVelocityLowAlarm: 0
            property string ifaVelocityLowAlarmStrf: "0"

            property int dfaFanDutyCycleInitial: 0
            property int ifaFanDutyCycleInitial: 0

            property int dfaFanDutyCycleResult: 0
            property int dfaFanRpmResult: 0
            property int ifaFanDutyCycleResult: 0
            property int ifaFanRpmResult: 0

            property bool calibrateDone: false
            property int calibrationFailCode: 0

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

                        props.dfaFanDutyCycleInitial = extradata['dfaFanDutyCycle'] || 0

                        props.dfaSensorAdcZero = extradata['dfaSensorAdcZero'] || 0

                        let velocityMin = extradata['dfaSensorVelMinimum'] || 0
                        props.dfaVelocityMin = velocityMin
                        props.dfaVelocityMinStrf = velocityMin.toFixed(props.velocityDecimalPoint)

                        let velocityAlarm = extradata['dfaSensorVelLowAlarm'] || 0
                        props.dfaVelocityLowAlarm = velocityAlarm
                        props.dfaVelocityLowAlarmStrf = velocityAlarm.toFixed(props.velocityDecimalPoint)

                        /////////
                        props.ifaFanDutyCycleInitial = extradata['ifaFanDutyCycle'] || 0

                        props.ifaSensorAdcZero = extradata['ifaSensorAdcZero'] || 0

                        velocityMin = extradata['ifaSensorVelMinimum'] || 0
                        props.ifaVelocityMin = velocityMin
                        props.ifaVelocityMinStrf = velocityMin.toFixed(props.velocityDecimalPoint)

                        velocityAlarm = extradata['ifaSensorVelLowAlarm'] || 0
                        props.ifaVelocityLowAlarm = velocityAlarm
                        props.ifaVelocityLowAlarmStrf = velocityAlarm.toFixed(props.velocityDecimalPoint)

                        //                //console.debug(props.velocity)
                        //                //console.debug(props.velocityStrf)
                    }

                    props.dfaFanDutyCycleActual = Qt.binding(function(){ return MachineData.fanPrimaryDutyCycle })
                    props.dfaFanRpmActual = Qt.binding(function(){ return MachineData.fanPrimaryRpm })

                    props.dfaAdcActual = Qt.binding(function(){ return MachineData.dfaAdcConpensation })
                    ////
                    props.ifaFanDutyCycleActual = Qt.binding(function(){ return MachineData.fanInflowDutyCycle })
                    props.ifaFanRpmActual = Qt.binding(function(){ return MachineData.fanInflowRpm })

                    props.ifaAdcActual = Qt.binding(function(){ return MachineData.dfaAdcConpensation })

                    props.temperatureActual = Qt.binding(function(){ return MachineData.temperature })
                    props.temperatureActualStr = Qt.binding(function(){ return MachineData.temperatureValueStr })

                    /// Automatically adjust the fan duty cycle
                    if (props.dfaFanDutyCycleActual != props.dfaFanDutyCycleInitial
                            || props.ifaFanDutyCycleActual != props.ifaFanDutyCycleInitial) {

                        MachineAPI.setFanPrimaryDutyCycle(props.dfaFanDutyCycleInitial);
                        MachineAPI.setFanInflowDutyCycle(props.ifaFanDutyCycleInitial);

                        viewApp.showBusyPage(qsTr("Adjusting fan duty cycle..."),
                                             function onTriggered(cycle){
                                                 if(cycle === MachineAPI.BUSY_CYCLE_2){
                                                     // close this pop up dialog
                                                     viewApp.dialogObject.close()
                                                 }
                                             })
                    }

                    if(!props.dfaSensorConstant && !props.ifaSensorConstant)
                        props.stabilizingTimer = 60 // Degree C Sensor
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
