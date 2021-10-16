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
                                                                        id: dfaDcyText
                                                                        text: "Dcy: " + props.dfaFanDutyCycleActual
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
                                                                        text: "RPM: " + props.dfaFanRpmActual
                                                                        states: [
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
                                                    id: nomFieldText
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    width: parent.width - 2
                                                    font.pixelSize: 24
                                                    horizontalAlignment: Text.AlignHCenter
                                                    color: "#dddddd"
                                                    text: props.dfaSensorVelNomFieldStrf

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
                                                            when: props.dfaSensorVelNomField <= props.dfaSensorVelMinFactory ||
                                                                  props.dfaSensorVelNomField >= props.dfaSensorVelMaxFactory
                                                            PropertyChanges {
                                                                target: nomFieldText
                                                                color: "red"
                                                            }
                                                        }
                                                    ]

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Set Downflow Nominal"))
                                                    }//

                                                    onAccepted: {
                                                        const val = Number(text)
                                                        if(isNaN(val)) return

                                                        ////console.debug("val: " + val)
                                                        props.dfaSensorVelNomField = val
                                                        props.dfaSensorVelNomFieldStrf = text
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
                                                text: qsTr("DF1 Velocity") + ":"
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
                                                    text: props.dfaSensorVelMinFactoryStrf
                                                    enabled: false
                                                    background: Rectangle {
                                                        height: parent.height
                                                        width: parent.width
                                                        color: "gray"

                                                        Rectangle {
                                                            height: 1
                                                            width: parent.width
                                                            anchors.bottom: parent.bottom
                                                        }//
                                                    }//

                                                    onPressed: {
                                                        //KeyboardOnScreenCaller.openNumpad(this, qsTr("Set Downflow Nominal"))
                                                    }//

                                                    onAccepted: {
                                                        //const val = Number(text)
                                                        //if(isNaN(val)) return

                                                        ////console.debug("val: " + val)
                                                        //props.dfaSensorVelNomField = val
                                                        //props.dfaSensorVelNomFieldStrf = text
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
                                                text: qsTr("DF3 Velocity") + ":"
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
                                                    text: props.dfaSensorVelMaxFactoryStrf
                                                    enabled: false
                                                    background: Rectangle {
                                                        height: parent.height
                                                        width: parent.width
                                                        color: "gray"

                                                        Rectangle {
                                                            height: 1
                                                            width: parent.width
                                                            anchors.bottom: parent.bottom
                                                        }//
                                                    }//

                                                    onPressed: {
                                                        //KeyboardOnScreenCaller.openNumpad(this, qsTr("Set Downflow Nominal"))
                                                    }//

                                                    onAccepted: {
                                                        //const val = Number(text)
                                                        //if(isNaN(val)) return

                                                        ////console.debug("val: " + val)
                                                        //props.dfaSensorVelNomField = val
                                                        //props.dfaSensorVelNomFieldStrf = text
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
                                    //                                    Row{
                                    //                                        anchors.horizontalCenter: parent.horizontalCenter
                                    //                                        TextApp {
                                    //                                            width: 200
                                    //                                            wrapMode: Text.WordWrap
                                    //                                            text: qsTr("Sensors Constant")
                                    //                                        }
                                    //                                        TextApp {
                                    //                                            width: 200
                                    //                                            wrapMode: Text.WordWrap
                                    //                                            text: (": DF: %1 | IF: %2").arg(props.dfaSensorConstant).arg(props.ifaSensorConstant)
                                    //                                        }
                                    //                                    }
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
                                                                        id: ifaDcyText
                                                                        text: "Dcy: " + props.ifaFanDutyCycleActual
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
                                                                        text: "RPM: " + props.ifaFanRpmActual
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
                                                    id: nomFieldText1
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    width: parent.width - 2
                                                    font.pixelSize: 24
                                                    horizontalAlignment: Text.AlignHCenter
                                                    color: "#dddddd"
                                                    text: props.ifaSensorVelNomFieldStrf

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
                                                            when: props.ifaSensorVelNomField <= props.ifaSensorVelMinFactory
                                                            PropertyChanges {
                                                                target: nomFieldText1
                                                                color: "red"
                                                            }
                                                        }
                                                    ]//

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Set Inflow Nominal"))
                                                    }//

                                                    onAccepted: {
                                                        const val = Number(text)
                                                        if(isNaN(val)) return

                                                        ////console.debug("val: " + val)
                                                        props.ifaSensorVelNomField = val
                                                        props.ifaSensorVelNomFieldStrf = text
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
                                                text: qsTr("IF1 Velocity") + ":"
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
                                                    text: props.ifaSensorVelMinFactoryStrf
                                                    enabled: false
                                                    background: Rectangle {
                                                        height: parent.height
                                                        width: parent.width
                                                        color: "gray"

                                                        Rectangle {
                                                            height: 1
                                                            width: parent.width
                                                            anchors.bottom: parent.bottom
                                                        }//
                                                    }//

                                                    onPressed: {
                                                        //KeyboardOnScreenCaller.openNumpad(this, qsTr("Set Inflow Nominal"))
                                                    }//

                                                    onAccepted: {
                                                        //const val = Number(text)
                                                        //if(isNaN(val)) return

                                                        ////console.debug("val: " + val)
                                                        //props.ifaSensorVelNomField = val
                                                        //props.ifaSensorVelNomFieldStrf = text
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
                                            const ifaAdc = props.ifaAdcActual
                                            const dfaAdc = props.dfaAdcActual
                                            const ifaVelocity = props.ifaSensorVelNomField
                                            const dfaVelocity = props.dfaSensorVelNomField
                                            const ifaFanDutyCycle = props.ifaFanDutyCycleActual
                                            const ifaFanRpm = props.ifaFanRpmActual
                                            const dfaFanDutyCycle = props.dfaFanDutyCycleActual
                                            const dfaFanRpm = props.dfaFanRpmActual

                                            const ifaAdcZero = MachineData.getInflowAdcPointFactory(0)
                                            const dfaAdcZero = MachineData.getDownflowAdcPointFactory(0)

                                            let ifaAdcCalibValid = (ifaAdc - 100) >= ifaAdcZero
                                            let dfaAdcCalibValid = (dfaAdc - 100) >= dfaAdcZero
                                            let ifaVelocityValid = (ifaVelocity > props.ifaSensorVelMinFactory)
                                            let dfaVelocityValid = (dfaVelocity > props.dfaSensorVelMinFactory) && (dfaVelocity < props.dfaSensorVelMaxFactory)
                                            let ifaFanValid = (ifaFanDutyCycle > 0)&& (ifaFanRpm > 0)
                                            let dfaFanValid = (dfaFanDutyCycle > 0) && (dfaFanRpm > 0)

                                            if (ifaAdcCalibValid && dfaAdcCalibValid && ifaVelocityValid && dfaVelocityValid && ifaFanValid && dfaFanValid) {
                                                props.ifaSensorAdcNomField = ifaAdc
                                                props.ifaSensorVelNomField = ifaVelocity
                                                props.ifaSensorVelNomFieldStrf = ifaVelocity.toFixed(props.velocityDecimalPoint)
                                                props.dfaSensorAdcNomField = dfaAdc
                                                props.dfaSensorVelNomField = dfaVelocity
                                                props.dfaSensorVelNomFieldStrf = dfaVelocity.toFixed(props.velocityDecimalPoint)
                                                props.ifaFanDutyCycleField = ifaFanDutyCycle
                                                props.ifaFanRpmField = ifaFanRpm
                                                props.dfaFanDutyCycleField = dfaFanDutyCycle
                                                props.dfaFanRpmField = dfaFanRpm
                                                props.temperatureCalib = props.temperatureActual
                                                props.temperatureCalibStrf = props.temperatureActualStr
                                                props.temperatureCalibAdc = props.temperatureAdcActual
                                                props.calibrateDone = true
                                            }else{
                                                if(!ifaAdcCalibValid)   props.calibrationFailCode = 0x0001
                                                if(!dfaAdcCalibValid)   props.calibrationFailCode = 0x0002
                                                if(!ifaVelocityValid)   props.calibrationFailCode = 0x0004
                                                if(!dfaVelocityValid)   props.calibrationFailCode = 0x0008
                                                if(!ifaFanValid)        props.calibrationFailCode = 0x0010
                                                if(!dfaFanValid)        props.calibrationFailCode = 0x0020
                                                console.debug("ifaAdcCalibValid :", ifaAdcCalibValid,   ifaAdcZero, ifaAdc)
                                                console.debug("dfaAdcCalibValid :", dfaAdcCalibValid,   dfaAdcZero, dfaAdc)
                                                console.debug("dfaVelocityValid :", dfaVelocityValid,   props.ifaSensorVelMinFactory, ifaVelocity)
                                                console.debug("dfaVelocityValid :", dfaVelocityValid,   props.dfaSensorVelMinFactory, dfaVelocity, props.dfaSensorVelMaxFactory)
                                                console.debug("ifaFanValid      :", ifaFanValid,        ifaFanDutyCycle, ifaFanRpm)
                                                console.debug("dfaFanValid      :", dfaFanValid,        dfaFanDutyCycle, dfaFanRpm)

                                                console.debug("Fail Calibration Code:", props.calibrationFailCode)
                                            }

                                            fragmentStackView.replace(fragmentResultComp)
                                        }//
                                    }//

                                    //property int count: 2
                                    property int count: 180
                                    Component.onCompleted: {count = Qt.binding(function(){return props.stabilizingTimer})}
                                }//
                            }//

                            Column{
                                Row {
                                    spacing: 10
                                    TextApp{
                                        font.pixelSize: 18
                                        text: qsTr("Actual ADC (DF)") + ":"
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
                                        text: qsTr("Actual ADC (IF)") + ":"
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
                                                text: ":" + props.dfaSensorVelNomFieldStrf + " " + props.measureUnitStr
                                                font.pixelSize: 18
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}
                                        Row {
                                            TextApp{
                                                width: 300
                                                text: qsTr("Downflow ADC nominal") + " (DF2)"
                                                font.pixelSize: 18
                                            }//

                                            TextApp {
                                                text: ":" + props.dfaSensorAdcNomField
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
                                                text: ":" + props.ifaSensorVelNomFieldStrf + " " + props.measureUnitStr
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
                                                text: ":" + props.ifaSensorAdcNomField
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
                                                text: ":" + props.dfaFanDutyCycleField + "% / " + props.dfaFanRpmField + " RPM"
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
                                                text: ":" + props.ifaFanDutyCycleField + "%" + props.ifaFanRpmField + " RPM"
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
                                resultiInfoText.visible = true
                                switch(props.calibrationFailCode){
                                case 0x0001: resultiInfoText.text = qsTr("IF ADC Nominal ≥ (ADC IF0 + 100) not met!"); break
                                case 0x0002: resultiInfoText.text = qsTr("DF ADC Nominal ≥ (ADC DF0 + 100) not met!"); break
                                case 0x0004: resultiInfoText.text = qsTr("IF Vel Nominal > Vel IF1 not met!");         break
                                case 0x0008: resultiInfoText.text = qsTr("Vel DF1 < DF Vel Nominal < Vel DF3 not met!"); break
                                case 0x0010: resultiInfoText.text = qsTr("IF Fan Duty cycle or RPM not valid!");   break
                                case 0x0020: resultiInfoText.text = qsTr("DF Fan Duty cycle or RPM not valid!");   break
                                default:     resultiInfoText.text = qsTr("There may be invalid values!");   break
                                }
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
                                                                          "ifaSensorAdcNominal": props.ifaSensorAdcNomField,
                                                                          "ifaSensorVelNominal": props.ifaSensorVelNomField,
                                                                          "dfaSensorAdcNominal": props.dfaSensorAdcNomField,
                                                                          "dfaSensorVelNominal": props.dfaSensorVelNomField,
                                                                          "ifaFanDutyCycleResult": props.ifaFanDutyCycleField,
                                                                          "ifaFanRpmResult": props.ifaFanRpmField,
                                                                          "dfaFanDutyCycleResult": props.dfaFanDutyCycleField,
                                                                          "dfaFanRpmResult": props.dfaFanRpmField,
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

            property int ifaAdcActual: 0
            property int dfaAdcActual: 0

            property int ifaFanDutyCycleActual: 0
            property int ifaFanRpmActual: 0
            property int dfaFanDutyCycleActual: 0
            property int dfaFanRpmActual: 0

            property int ifaSensorAdcNomFactory: 0
            property int ifaSensorAdcNomField: 0
            //property int ifaAdcMinimumResult: 0
            property int dfaSensorAdcNomFactory: 0
            property int dfaSensorAdcNomField: 0
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
            property real   ifaSensorVelNomField: 0
            property string ifaSensorVelNomFieldStrf: "0"
            property real   ifaSensorVelNomFactory: 0
            property string ifaSensorVelNomFactoryStrf: "0"
            property real   ifaSensorVelMinFactory: 0
            property string ifaSensorVelMinFactoryStrf: "0"

            property real   dfaSensorVelNomField: 0
            property string dfaSensorVelNomFieldStrf: "0"
            property real   dfaSensorVelNomFactory: 0
            property string dfaSensorVelNomFactoryStrf: "0"
            property real   dfaSensorVelMinFactory: 0
            property string dfaSensorVelMinFactoryStrf: "0"
            property real   dfaSensorVelMaxFactory: 0
            property string dfaSensorVelMaxFactoryStrf: "0"

            property int ifaFanDutyCycleInitial: 0
            property int ifaFanDutyCycleField: 0
            property int ifaFanRpmField: 0

            property int dfaFanDutyCycleInitial: 0
            property int dfaFanDutyCycleField: 0
            property int dfaFanRpmField: 0

            property int temperatureCalib: 0
            property int temperatureCalibAdc: 0
            property string temperatureCalibStrf: ""

            property int stabilizingTimer : 180

            property bool calibrateDone: false
            property int calibrationFailCode: 0
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

                    props.ifaSensorAdcNomFactory = extradata['ifaSensorAdcNominal'] || 0
                    props.ifaSensorVelNomFactory = extradata['ifaSensorVelNominal'] || 0
                    props.ifaSensorVelMinFactory = extradata['ifaSensorVelMinimum'] || 0
                    props.ifaSensorVelNomField   = extradata['ifaSensorVelNominalField'] || 0

                    props.dfaSensorAdcNomFactory = extradata['dfaSensorAdcNominal'] || 0
                    props.dfaSensorVelNomFactory = extradata['dfaSensorVelNominal'] || 0
                    props.dfaSensorVelMinFactory = extradata['dfaSensorVelMinimum'] || 0
                    props.dfaSensorVelMaxFactory = extradata['dfaSensorVelMaximum'] || 0
                    props.dfaSensorVelNomField   = extradata['dfaSensorVelNominalField'] || 0

                    props.ifaFanDutyCycleInitial = extradata['ifaFanDutyCycle'] || 0
                    props.dfaFanDutyCycleInitial = extradata['dfaFanDutyCycle'] || 0

                    let velocity

                    velocity = props.ifaSensorVelNomFactory
                    props.ifaSensorVelNomFactoryStrf = velocity.toFixed(props.velocityDecimalPoint)
                    velocity = props.ifaSensorVelMinFactory
                    props.ifaSensorVelMinFactoryStrf = velocity.toFixed(props.velocityDecimalPoint)
                    velocity = props.ifaSensorVelNomField
                    props.ifaSensorVelNomFieldStrf = velocity.toFixed(props.velocityDecimalPoint)

                    velocity = props.dfaSensorVelNomFactory
                    props.dfaSensorVelNomFactoryStrf = velocity.toFixed(props.velocityDecimalPoint)
                    velocity = props.dfaSensorVelMinFactory
                    props.dfaSensorVelMinFactoryStrf = velocity.toFixed(props.velocityDecimalPoint)
                    velocity = props.dfaSensorVelMaxFactory
                    props.dfaSensorVelMaxFactoryStrf = velocity.toFixed(props.velocityDecimalPoint)
                    velocity = props.dfaSensorVelNomField
                    props.dfaSensorVelNomFieldStrf = velocity.toFixed(props.velocityDecimalPoint)

                }//

                /// Real-Time update
                props.ifaFanDutyCycleActual = Qt.binding(function(){ return MachineData.fanInflowDutyCycle })
                props.ifaFanRpmActual = Qt.binding(function(){ return MachineData.fanInflowRpm })
                props.dfaFanDutyCycleActual = Qt.binding(function(){ return MachineData.fanPrimaryDutyCycle })
                props.dfaFanRpmActual = Qt.binding(function(){ return MachineData.fanPrimaryRpm })
                //
                props.ifaAdcActual = Qt.binding(function(){ return MachineData.ifaAdcConpensation })
                props.dfaAdcActual = Qt.binding(function(){ return MachineData.dfaAdcConpensation })
                //
                props.temperatureActual = Qt.binding(function(){ return MachineData.temperature })
                props.temperatureActualStr = Qt.binding(function(){ return MachineData.temperatureValueStr })
                props.temperatureAdcActual = Qt.binding(function(){ return MachineData.temperatureAdc })

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
