import QtQuick 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import modules.cpp.utils 1.0
import modules.cpp.machine 1.0

import Qt.labs.settings 1.0

import "Components" as CusComPage

ViewApp {
    id: viewApp
    title: "Home"

    background.sourceComponent: Item {}

    content.sourceComponent: Item{
        id: containerItem
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

                RowLayout {
                    anchors.fill: parent
                    spacing: 5

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumWidth: 300

                        Item {
                            anchors.fill: parent

                            Rectangle {
                                anchors.fill: parent
                                color: "#770F2952"
                                radius: 5
                                border.width: 1
                                border.color: "gray"
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 1
                                spacing: 1

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    Image {
                                        id: logoImage
                                        anchors.fill: parent
                                        anchors.margins: 5
                                        fillMode: Image.PreserveAspectFit
                                        source: "../../Pictures/Logo_HS_W.png"
                                    }//
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    TextApp {
                                        id: cabinetClassText
                                        anchors.fill: parent
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        text: "Class II" + "<br>" + "LA2-EU"
                                    }//
                                }//
                            }//
                        }//
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Rectangle {
                            id: topBarStatusRectangle
                            anchors.fill: parent
                            radius: 5
                            //                            color: "green"
                            color: "red"
                            border.color: "gray"
                            border.width: 2

                            TextApp {
                                id: topBarStatusText
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 36
                                font.bold: true
                                //                                text: "CABINET IS SAFE"
                                text: "WARNING: AIRFLOW IS FAIL"
                            }//
                        }//
                    }//
                }//
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    anchors.fill: parent

                    Item {
                        Layout.minimumHeight: 60
                        Layout.fillWidth: true

                        RowLayout {
                            anchors.fill: parent
                            spacing: 5

                            Item {
                                Layout.fillHeight: true
                                Layout.minimumWidth: 300

                                Rectangle {
                                    anchors.fill: parent
                                    color: "#770F2952"
                                    radius: 5
                                    border.width: 1
                                    border.color: "gray"

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 1
                                        spacing: 1

                                        Item {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true

                                            TextApp {
                                                anchors.fill: parent
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                                text: "My BSC"
                                            }//
                                        }//

                                        Rectangle {
                                            Layout.minimumHeight: parent.height * 0.7
                                            Layout.minimumWidth: 1
                                            color: "gray"
                                        }//

                                        Item {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true

                                            TextApp {
                                                anchors.fill: parent
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                                elide: Text.ElideRight
                                                text: "Login"
                                            }//
                                        }//
                                    }//
                                }//
                            }//

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                Rectangle {
                                    anchors.fill: parent
                                    color: "#770F2952"
                                    radius: 5
                                    border.width: 1
                                    border.color: "gray"

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 1
                                        spacing: 1

                                        Item {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true

                                            TextApp {
                                                anchors.fill: parent
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                                elide: Text.ElideRight
                                                text: "ambient: 24^C"
                                            }//
                                        }//

                                        Rectangle {
                                            Layout.minimumHeight: parent.height * 0.7
                                            Layout.minimumWidth: 1
                                            color: "gray"
                                        }///

                                        Item {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true

                                            TextApp {
                                                anchors.fill: parent
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                                elide: Text.ElideRight
                                                text: "12:03 PM"
                                            }//
                                        }//

                                        Rectangle {
                                            Layout.minimumHeight: parent.height * 0.7
                                            Layout.minimumWidth: 1
                                            color: "gray"
                                        }//

                                        Item {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true

                                            TextApp {
                                                anchors.fill: parent
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                                elide: Text.ElideRight
                                                text: "20 Oct 2020"
                                            }//
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        RowLayout {
                            anchors.fill: parent

                            Item {
                                id: bsc3DItem
                                Layout.minimumWidth: 300
                                Layout.fillHeight: true

                                /// give the space
                            }

                            Item {
                                id: centerContentItem
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                Column{
                                    //                                    anchors.bottom: parent.bottom
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 5

                                    //                                    Repeater {
                                    //                                        model: 2

                                    Item {
                                        height: 60
                                        width: centerContentItem.width

                                        CusComPage.StatusHorizontalApp {
                                            id: sashStatus
                                            height: parent.height
                                            width: parent.width + 150
                                            x: -150
                                            contentItem.x : 150

                                            textLabel: qsTr("Sash:")
                                            textValue: "---"

                                            states: [
                                                State {
                                                    name: "A"
                                                    when: MachineData.sashWindowState === MachineApi.SASH_STATE_WORK_SSV
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Safe height")
                                                    }
                                                },
                                                State {
                                                    name: "B"
                                                    when: MachineData.sashWindowState === MachineApi.SASH_STATE_UNSAFE_SSV
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Unsafe")
                                                    }
                                                },
                                                State {
                                                    name: "C"
                                                    when: MachineData.sashWindowState === MachineApi.SASH_STATE_STANDBY_SSV
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Standby height")
                                                    }
                                                }
                                            ]
                                        }//
                                    }//

                                    Item {
                                        height: 60
                                        width: centerContentItem.width

                                        CusComPage.StatusHorizontalApp {
                                            height: parent.height
                                            width: parent.width + 150
                                            x: -150
                                            contentItem.x : 150

                                            textLabel: qsTr("Downflow:")
                                            textValue: "0.33 m/s"
                                        }//
                                    }//

                                    Item {
                                        height: 60
                                        width: centerContentItem.width

                                        CusComPage.StatusHorizontalApp {
                                            height: parent.height
                                            width: parent.width + 150
                                            x: -150
                                            contentItem.x : 150

                                            textLabel: qsTr("Inflow:")
                                            textValue: "0.42 m/s (Too Low)"

                                            hightlighted: true
                                        }//
                                    }//
                                    //                                    }//
                                }//
                            }//

                            Item {
                                Layout.fillHeight: true
                                Layout.minimumWidth: 150

                                //                                Rectangle {
                                //                                    anchors.fill: parent
                                //                                    color: "#0F2952"
                                //                                    radius: 5
                                //                                }//

                                Column{
                                    anchors.centerIn: parent
                                    spacing: 50

                                    Image {
                                        id: upSashMotorizeImage
                                        opacity: tapHandlerUp.pressed ? 0.5 : 1
                                        source: "../../Pictures/controll/Button_Up.png"

                                        MouseArea {
                                            id: tapHandlerUp
                                            anchors.fill: parent
                                            onPressAndHold: {
                                                MachineApi.setSashWindowMotorizeState(MachineApi.MOTOR_SASH_STATE_UP)
                                            }
                                            onReleased: {
                                                MachineApi.setSashWindowMotorizeState(MachineApi.MOTOR_SASH_STATE_OFF)
                                            }
                                        }

                                        //                                        TapHandler {
                                        //                                            id: tapHandlerUp
                                        //                                            onLongPressed: {
                                        //                                                console.log("onLongPressed")
                                        //                                            }//

                                        //                                            onTapped: {
                                        //                                                console.log("onTapped")
                                        //                                            }//

                                        //                                            onDoubleTapped: {
                                        //                                                console.log("onDoubleTapped")
                                        //                                            }//
                                        //                                        }//

                                        states: [
                                            State {
                                                name: "STATE_A"
                                                when: MachineData.sashWindowMotorizeState === MachineApi.MOTOR_SASH_STATE_UP
                                                PropertyChanges {
                                                    target: upSashMotorizeImage
                                                    source: "/UI/Pictures/controll/Button_Up_Run.png"
                                                }
                                            }
                                        ]
                                    }//

                                    Image {
                                        id: downSashMotorizeImage
                                        opacity: tapHandlerDown.pressed ? 0.5 : 1
                                        source: "../../Pictures/controll/Button_Down.png"

                                        MouseArea {
                                            id: tapHandlerDown
                                            anchors.fill: parent
                                            onPressAndHold: {
                                                MachineApi.setSashWindowMotorizeState(MachineApi.MOTOR_SASH_STATE_DOWN)
                                            }
                                            onReleased: {
                                                MachineApi.setSashWindowMotorizeState(MachineApi.MOTOR_SASH_STATE_OFF)
                                            }
                                        }

                                        //                                        TapHandler {
                                        //                                            id: tapHandlerDown
                                        //                                            onLongPressed: {
                                        //                                                console.log("onLongPressed")

                                        //                                            }//

                                        //                                            onTapped: {
                                        //                                                console.log("onTapped")
                                        //                                            }//

                                        //                                            onDoubleTapped: {
                                        //                                                console.log("onDoubleTapped")
                                        //                                            }//
                                        //                                        }//

                                        states: [
                                            State {
                                                name: "STATE_A"
                                                when: MachineData.sashWindowMotorizeState === MachineApi.MOTOR_SASH_STATE_DOWN
                                                PropertyChanges {
                                                    target: downSashMotorizeImage
                                                    source: "/UI/Pictures/controll/Button_Down_Run.png"
                                                }
                                            }
                                        ]
                                    }//
                                }//
                            }//
                        }//

                        /// trick to make this component upper then other content componet
                        /// including status bar
                        BiosafetyCabinetEsco {
                            id: cabinet3D
                            x : bsc3DItem.x
                            y : bsc3DItem.y
                            height: bsc3DItem.height
                            width: bsc3DItem.width

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    cabinet3D.state = cabinet3D.stateA
                                    cabinet3D.sashItem.state = cabinet3D.sashItem.stateA
                                }

                                onPressAndHold: {
                                    cabinet3D.state = cabinet3D.stateB
                                    cabinet3D.sashItem.state = cabinet3D.sashItem.stateB
                                }
                            }
                        }//
                    }//
                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 110

                Rectangle {
                    anchors.fill: parent
                    color: "#770F2952"
                    radius: 5

                    RowLayout {
                        id: footerRowLayout
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 5

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            CusComPage.ControlButtonApp {
                                anchors.centerIn: parent
                                height: parent.height
                                width: parent.width > 200 ? 200 : parent.width

                                sourceImage: "/UI/Pictures/controll/Menu_W.png"

                                tapHandler.onTapped: {

                                }
                            }//
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            CusComPage.ControlButtonApp {
                                id: fanButton
                                anchors.centerIn: parent
                                height: parent.height
                                width: parent.width > 200 ? 200 : parent.width

                                sourceImage: "/UI/Pictures/controll/Fan_W.png"
                                //                                stateInterlock: true

                                tapHandler.onTapped: {
                                    //                                    let currentState = MachineData.blowerDownflowState
                                    //                                    if (currentState) {
                                    //                                        MachineApi.setBlowerState(MachineApi.FAN_STATE_OFF);
                                    //                                    }
                                    //                                    else {
                                    //                                        MachineApi.setBlowerState(MachineApi.FAN_STATE_ON);
                                    //                                    }

                                    var intent = IntentApp.create("qrc:/UI/Pages/FanPinPage/FanPinPage.qml", {"message":""})
                                    startView(intent)
                                }

                                states: [
                                    State {
                                        name: "STATE_A"
                                        when: MachineData.blowerDownflowState
                                        PropertyChanges {
                                            target: fanButton
                                            sourceImage: "/UI/Pictures/controll/Fan_G.png"
                                        }
                                    }
                                ]
                            }//
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            CusComPage.ControlButtonApp {
                                id: lightButton
                                anchors.centerIn: parent
                                height: parent.height
                                width: parent.width > 200 ? 200 : parent.width

                                sourceImage: "/UI/Pictures/controll/Light_W.png"

                                tapHandler.onLongPressed: {
                                    let currentState = MachineData.lightState
                                    if (!currentState) {
                                        MachineApi.setLightState(!currentState);
                                    }

                                    var intent = IntentApp.create("/UI/Pages/LightIntensityPage/LightIntensityPage.qml", {"message":""})
                                    startView(intent)
                                }

                                tapHandler.onTapped: {
                                    let currentState = MachineData.lightState
                                    MachineApi.setLightState(!currentState);
                                }

                                states: [
                                    State {
                                        name: "STATE_A"
                                        when: MachineData.lightState
                                        PropertyChanges {
                                            target: lightButton
                                            sourceImage: "/UI/Pictures/controll/Light_G.png"
                                        }
                                    }
                                ]
                            }//
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            CusComPage.ControlButtonApp {
                                id: socketButton
                                anchors.centerIn: parent
                                height: parent.height
                                width: parent.width > 200 ? 200 : parent.width

                                sourceImage: "/UI/Pictures/controll/Socket_W.png"

                                tapHandler.onTapped: {
                                    let currentState = MachineData.socketState
                                    MachineApi.setSocketState(!currentState);
                                }

                                states: [
                                    State {
                                        name: "STATE_A"
                                        when: MachineData.socketState
                                        PropertyChanges {
                                            target: socketButton
                                            sourceImage: "/UI/Pictures/controll/Socket_G.png"
                                        }
                                    }
                                ]
                            }//
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            CusComPage.ControlButtonApp {
                                id: gasButton
                                anchors.centerIn: parent
                                height: parent.height
                                width: parent.width > 200 ? 200 : parent.width

                                sourceImage: "/UI/Pictures/controll/Gas_W.png"

                                tapHandler.onTapped: {
                                    let currentState = MachineData.gasState
                                    MachineApi.setGasState(!currentState);
                                }

                                states: [
                                    State {
                                        name: "STATE_A"
                                        when: MachineData.gasState
                                        PropertyChanges {
                                            target: gasButton
                                            sourceImage: "/UI/Pictures/controll/Gas_G.png"
                                        }
                                    }
                                ]
                            }//
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            CusComPage.ControlButtonApp {
                                id: uvButton
                                anchors.centerIn: parent
                                height: parent.height
                                width: parent.width > 200 ? 200 : parent.width

                                sourceImage: "/UI/Pictures/controll/UV_W.png"

                                tapHandler.onTapped: {
                                    let currentState = MachineData.uvState
                                    MachineApi.setUvState(!currentState);
                                }

                                states: [
                                    State {
                                        name: "STATE_A"
                                        when: MachineData.uvState
                                        PropertyChanges {
                                            target: uvButton
                                            sourceImage: "/UI/Pictures/controll/UV_G.png"
                                        }
                                    }
                                ]
                            }//
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            CusComPage.ControlButtonApp {
                                id: muteAlarmButton
                                anchors.centerIn: parent
                                height: parent.height
                                width: parent.width > 200 ? 200 : parent.width

                                sourceImage: "/UI/Pictures/controll/Mute_W.png"

                                tapHandler.onTapped: {
                                    let currentState = MachineData.muteAlarmState
                                    //                                    MachineApi.setSocketState(!currentState);
                                }

                                states: [
                                    State {
                                        name: "STATE_A"
                                        when: MachineData.muteAlarmState
                                        PropertyChanges {
                                            target: muteAlarmButton
                                            sourceImage: "/UI/Pictures/controll/Mute_W.png"
                                        }
                                    }
                                ]
                            }//
                        }//
                    }//
                }//
            }//

            /// Execute This Every This Screen Active/Visible
            Loader {
                active: viewApp.stackViewStatusActivating || viewApp.stackViewStatusActive
                sourceComponent: QtObject {

                    /// onResume
                    Component.onCompleted: {
                        console.log("StackView.Active");

                        //                        const xhrSWRevision = new XMLHttpRequest();
                        //                        xhrSWRevision.open("GET", "file://" + SWRevisionPath);
                        //                        xhrSWRevision.onreadystatechange = function() {
                        //                            if (xhrSWRevision.readyState === XMLHttpRequest.DONE) {
                        //                                const responseText = xhrSWRevision.responseText
                        //                                swCurrentRevisionText.text = String(responseText).trim()
                        //                                //                                console.log(responseText)
                        //                            }
                        //                            //                            else {
                        //                            //                                console.log(xhrSWRevision.readyState)
                        //                            //                            }
                        //                        }
                        //                        xhrSWRevision.send()

                        //                        const xhrHWRevision = new XMLHttpRequest;
                        //                        xhrHWRevision.open("GET", "file://" + HWRevisionPath);
                        //                        xhrHWRevision.onreadystatechange = function() {
                        //                            if (xhrHWRevision.readyState === XMLHttpRequest.DONE) {
                        //                                const responseText = xhrHWRevision.responseText
                        //                                hwCompatibilityText.text = String(responseText).trim()
                        //                                //                                console.log(responseText)
                        //                            }
                        //                            //                            else {
                        //                            //                                console.log(xhrHWRevision.readyState)
                        //                            //                            }
                        //                        }
                        //                        xhrHWRevision.send()
                    }

                    /// onPause
                    Component.onDestruction: {
                        //console.log("StackView.DeActivating");
                    }

                    /// PUT ANY DYNAMIC OBJECT MUST A WARE TO PAGE STATUS
                    /// ANY OBJECT ON HERE WILL BE DESTROYED WHEN THIS PAGE NOT IN FOREGROUND

                    //                    property int machineState: MachineData.machineState
                    //                    onMachineStateChanged: {
                    //                        //console.log("onMachineStateChanged: " + machineState)

                    //                        switch (machineState) {
                    //                        case MachineApi.MACHINE_STATE_SETUP:
                    //                            machineStateText.text = qsTr("Setup")
                    //                            break;
                    //                        case MachineApi.MACHINE_STATE_LOOP:
                    //                            machineStateText.text = qsTr("Loop")
                    //                            break;
                    //                        case MachineApi.MACHINE_STATE_STOP:
                    //                            machineStateText.text = qsTr("Stopping")
                    //                            break;
                    //                        }
                    //                    }

                    //                    property int machineCounter: MachineData.count
                    //                    onMachineCounterChanged: {
                    //                        //console.log("onMachineCounterChanged: " + machineCounter)
                    //                        countingText.text = machineCounter
                    //                    }//

                    //                    property bool machineHasStopped: MachineData.hasStopped
                    //                    onMachineHasStoppedChanged: {
                    //                        if (machineHasStopped) {
                    //                            machineStateText.text = qsTr("Stopped")
                    //                        }
                    //                    }
                }//
            }//
        }//
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:600;width:1024}
}
##^##*/

//import QtQuick 2.8
//import QtQuick.Controls 2.0
//import QtQuick.Layouts 1.0

//import UI.CusCom 1.0
//import "../../CusCom/JS/IntentApp.js" as IntentApp

//import modules.cpp.utils 1.0
//import modules.cpp.machine 1.0

//import Qt.labs.settings 1.0

//ViewApp {
//    id: viewApp
//    title: "Home"

//    background.sourceComponent: Rectangle{
//        color: "black"
//    }

//    content.sourceComponent: Item{
//        ColumnLayout {
//            anchors.fill: parent
//            anchors.margins: 5

//            /// HEADER
//            Item {
//                id: headerItem
//                Layout.fillWidth: true
//                Layout.minimumHeight: 40

//                Rectangle {
//                    anchors.fill: parent
//                    color: "transparent"
//                    border.color: "#ffffff"
//                    border.width: 1
//                    radius: 5

//                    TextApp {
//                        anchors.centerIn: parent
//                        text: Qt.application.name + " - " + Qt.application.version
//                    }
//                }
//            }//

//            /// BODY
//            Item {
//                id: bodyItem
//                Layout.fillWidth: true
//                Layout.fillHeight: true

//                RowLayout {
//                    anchors.fill: parent

//                    Item {
//                        Layout.fillWidth: true
//                        Layout.fillHeight: true

//                        Column {
//                            anchors.centerIn: parent
//                            spacing: 10

//                            Column {
//                                spacing: 2

//                                Row {

//                                    TextApp {
//                                        id: machineStateLabelText
//                                        text: "Machine state:" + " "
//                                    }//

//                                    TextApp {
//                                        id: machineStateText
//                                        text: "None"
//                                    }//

//                                }//

//                                Row {

//                                    TextApp {
//                                        id: countLabelText
//                                        text: "Machine Counting:" + " "
//                                    }//

//                                    TextApp {
//                                        id: countingText
//                                        text: "0"
//                                    }//

//                                }//

//                                ButtonBarApp {
//                                    id: startButton
//                                    text: "Start Machine"

//                                    onClicked: {
//                                        if (MachineData.hasStopped) {
//                                            MachineApi.setup(MachineData);
//                                        }
//                                    }
//                                }//

//                                ButtonBarApp {
//                                    id: stopButton
//                                    text: "Stop Machine"

//                                    onClicked: {
//                                        if (!MachineData.hasStopped) {
//                                            MachineApi.stop();
//                                        }
//                                    }
//                                }//

//                                ButtonBarApp {
//                                    id: setBlowerOnButton
//                                    text: "Set Blower ON"

//                                    onClicked: {
//                                        MachineApi.setBlowerState(20)
//                                    }
//                                }//

//                                ButtonBarApp {
//                                    id: setBlowerOffButton
//                                    text: "Set Blower OFF"

//                                    onClicked: {
//                                        MachineApi.setBlowerState(0)
//                                    }
//                                }//
//                            }//
//                        }
//                    }

//                    Item {
//                        Layout.fillWidth: true
//                        Layout.fillHeight: true

//                        Column {
//                            anchors.centerIn: parent
//                            spacing: 5

//                            TextApp {
//                                text: qsTr("Hello World!")
//                            }

//                            Image {
//                                height: 120
//                                fillMode: Image.PreserveAspectFit
//                                source: "../../Pictures/feature-image.png"
//                            }//

//                            TextFieldApp {
//                                height: 40
//                                width: 200
//                                placeholderText: qsTr("Input Text Qwerty")

//                                onPressed: {
//                                    //                        keyboardOnScreenApp.open()
//                                    viewApp.textInputTarget = this
//                                    viewApp.openKeyboard(placeholderText)
//                                    //                        textField.undo()
//                                }

//                                onAccepted: {
//                                    //console.log("onAccepted")
//                                }
//                            }

//                            TextFieldApp {
//                                height: 40
//                                width: 200
//                                placeholderText: qsTr("Input Numpad")

//                                onPressed: {
//                                    //                        keyboardOnScreenApp.open()
//                                    viewApp.textInputTarget = this
//                                    viewApp.openNumpad(placeholderText)
//                                    //                        textField.undo()
//                                }

//                                onAccepted: {
//                                    //console.log("onAccepted")
//                                }
//                            }

//                            ComboBoxApp {
//                                id: languageComboBox
//                                textRole: "text"
//                                font.pixelSize: 20
//                                model: [
//                                    {text: "English",  code: "en"},
//                                    {text: "Chinese",  code: "zh"},
//                                    {text: "Rusia",    code: "ru"},
//                                    {text: "Japan",    code: "ja"},
//                                    {text: "Korea",    code: "ko"},
//                                    {text: "Arabic",   code: "ar"},
//                                    {text: "Germany",  code: "de"},
//                                ]

//                                onActivated: {
//                                    let code = model[index]["code"]
//                                    TranslatorText.selectLanguage(code)
//                                    settingsLanguage.languange      = code
//                                    settingsLanguage.languangeIndex = index
//                                }

//                                Settings {
//                                    id: settingsLanguage

//                                    property string languange: "en"
//                                    property int    languangeIndex: 0
//                                }

//                                Component.onCompleted: {
//                                    let index = settingsLanguage.languangeIndex
//                                    let code = settingsLanguage.languange
//                                    TranslatorText.selectLanguage(code)

//                                    languageComboBox.currentIndex = index
//                                }//
//                            }//
//                        }//
//                    }//
//                }//
//            }//

//            /// FOOTER
//            Item {
//                id: footerItem
//                Layout.fillWidth: true
//                Layout.minimumHeight: 70

//                Rectangle {
//                    anchors.fill: parent
//                    color: "transparent"
//                    border.color: "#ffffff"
//                    border.width: 1
//                    radius: 5

//                    Item {
//                        anchors.fill: parent
//                        anchors.margins: 5

//                        Row {
//                            anchors.verticalCenter: parent.verticalCenter
//                            spacing: 1

//                            //                            Component.onCompleted: {
//                            //                                console.log("width: " + parent.width)
//                            //                            }

//                            ButtonBarApp {
//                                width: 194
//                                imageSource: "../../Pictures/restart-red-icon.png"
//                                text: qsTr("Restart")

//                                onClicked: {
//                                    //                                Qt.exit(ExitCode.ECC_NORMAL_EXIT)
//                                    var intent = IntentApp.create("/UI/Pages/ClosingPage/ClosingPage.qml", {
//                                                                      "exitCode": ExitCode.ECC_NORMAL_EXIT_RESTART_SBC
//                                                                  })
//                                    startRootView(intent)
//                                }
//                            }

//                            ButtonBarApp {
//                                width: 194

//                                imageSource: "../../Pictures/restart-red-icon.png"
//                                text: qsTr("Software update")

//                                onClicked: {
//                                    //                                Qt.exit(ExitCode.ECC_NORMAL_EXIT)
//                                    var intent = IntentApp.create("/UI/Pages/ClosingPage/ClosingPage.qml", {
//                                                                      "exitCode": ExitCode.ECC_NORMAL_EXIT_OPEN_SBCUPDATE
//                                                                  })
//                                    startRootView(intent)
//                                }
//                            }

//                            ButtonBarApp {
//                                width: 194
//                                imageSource: "../../Pictures/restart-red-icon.png"
//                                text: qsTr("Reload")

//                                onClicked: {
//                                    //                                Qt.exit(ExitCode.ECC_NORMAL_EXIT)
//                                    var intent = IntentApp.create("/UI/Pages/ClosingPage/ClosingPage.qml", {
//                                                                      "exitCode": ExitCode.ECC_NORMAL_EXIT
//                                                                  })
//                                    startRootView(intent)
//                                }
//                            }
//                        }

//                        ButtonBarApp {
//                            width: 194
//                            anchors.right: parent.right
//                            anchors.verticalCenter: parent.verticalCenter

//                            imageSource: "/UI/Pictures/local-wifi-update.png"
//                            text: qsTr("WiFi Setting")

//                            onClicked: {
//                                var intent = IntentApp.create("/UI/Pages/WiFiSettingPage/WiFiSettingPage.qml", {"message":""})
//                                startView(intent)
//                            }
//                        }//
//                    }//
//                }//
//            }//

//            /// Execute This Every This Screen Active/Visible
//            Loader {
//                active: viewApp.stackViewStatusActivating || viewApp.stackViewStatusActive
//                sourceComponent: QtObject {

//                    /// onResume
//                    Component.onCompleted: {
//                        console.log("StackView.Active");

//                        //                        const xhrSWRevision = new XMLHttpRequest();
//                        //                        xhrSWRevision.open("GET", "file://" + SWRevisionPath);
//                        //                        xhrSWRevision.onreadystatechange = function() {
//                        //                            if (xhrSWRevision.readyState === XMLHttpRequest.DONE) {
//                        //                                const responseText = xhrSWRevision.responseText
//                        //                                swCurrentRevisionText.text = String(responseText).trim()
//                        //                                //                                console.log(responseText)
//                        //                            }
//                        //                            //                            else {
//                        //                            //                                console.log(xhrSWRevision.readyState)
//                        //                            //                            }
//                        //                        }
//                        //                        xhrSWRevision.send()

//                        //                        const xhrHWRevision = new XMLHttpRequest;
//                        //                        xhrHWRevision.open("GET", "file://" + HWRevisionPath);
//                        //                        xhrHWRevision.onreadystatechange = function() {
//                        //                            if (xhrHWRevision.readyState === XMLHttpRequest.DONE) {
//                        //                                const responseText = xhrHWRevision.responseText
//                        //                                hwCompatibilityText.text = String(responseText).trim()
//                        //                                //                                console.log(responseText)
//                        //                            }
//                        //                            //                            else {
//                        //                            //                                console.log(xhrHWRevision.readyState)
//                        //                            //                            }
//                        //                        }
//                        //                        xhrHWRevision.send()
//                    }

//                    /// onPause
//                    Component.onDestruction: {
//                        //console.log("StackView.DeActivating");
//                    }

//                    /// PUT ANY DYNAMIC OBJECT MUST A WARE TO PAGE STATUS
//                    /// ANY OBJECT ON HERE WILL BE DESTROYED WHEN THIS PAGE NOT IN FOREGROUND

//                    property int machineState: MachineData.machineState
//                    onMachineStateChanged: {
//                        //console.log("onMachineStateChanged: " + machineState)

//                        switch (machineState) {
//                        case MachineApi.MACHINE_STATE_SETUP:
//                            machineStateText.text = qsTr("Setup")
//                            break;
//                        case MachineApi.MACHINE_STATE_LOOP:
//                            machineStateText.text = qsTr("Loop")
//                            break;
//                        case MachineApi.MACHINE_STATE_STOP:
//                            machineStateText.text = qsTr("Stopping")
//                            break;
//                        }
//                    }

//                    property int machineCounter: MachineData.count
//                    onMachineCounterChanged: {
//                        //console.log("onMachineCounterChanged: " + machineCounter)
//                        countingText.text = machineCounter
//                    }//

//                    //                    property bool machineHasStopped: MachineData.hasStopped
//                    //                    onMachineHasStoppedChanged: {
//                    //                        if (machineHasStopped) {
//                    //                            machineStateText.text = qsTr("Stopped")
//                    //                        }
//                    //                    }
//                }//
//            }//
//        }//
//    }
//}

///*##^##
//Designer {
//    D{i:0;autoSize:true;height:600;width:1024}
//}
//##^##*/
