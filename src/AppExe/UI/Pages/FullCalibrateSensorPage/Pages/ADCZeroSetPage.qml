import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "ADC Zero"

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

                                    TextApp {
                                        wrapMode: Text.WordWrap
                                        text: qsTr("Internal fan should be turned off!")
                                    }

                                    TextApp {
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
                                Layout.fillHeight: true
                                Layout.minimumWidth: parent.width * 0.20

                                Rectangle {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width
                                    height: parent.height / 3 - 5
                                    color: "#0F2952"
                                    border.color: "#dddddd"
                                    radius: 5

                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 2
                                        spacing: 1

                                        TextApp {
                                            font.pixelSize: 14
                                            text: qsTr("Press here to turning off")
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
                                        anchors.fill: parent
                                        onClicked: {

                                            MachineAPI.setFanPrimaryDutyCycle(0);

                                            viewApp.showBusyPage(qsTr("Switching off fan..."),
                                                                 function onTriggered(cycle){
                                                                     if(cycle === 5){
                                                                         viewApp.dialogObject.close()
                                                                     }
                                                                 })
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

                                            //                                            /// demo
                                            //                                            adc = 100

                                            if (adc > 0) {
                                                // analog input have minimum constant adc value on each port
                                                // known value is about 5 to 8
                                                // if the value is <= zero (0) that mean there are some trouble in a port

                                                props.calibrateDone = true
                                            }

                                            props.adcResult = adc

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

                        Column {
                            anchors.centerIn: parent
                            spacing: 5

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

                            Row {
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 10

                                TextApp{
                                    text: qsTr("ADC Zero") + ":"
                                }//

                                TextApp{
                                    font.bold: true
                                    text: props.adcResult
                                }//
                            }//

                            Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                            //                            ButtonBarApp {
                            //                                id: okButton
                            //                                width: 194

                            //                                imageSource: "qrc:/UI/Pictures/checkicon.png"
                            //                                text: qsTr("OK")

                            //                                onClicked: {
                            //                                    if (fragmentStackView.currentItem.idname === "result"){
                            //                                        if(props.calibrateDone) {
                            //                                            let intent = IntentApp.create(uri, { "pid": props.pid, "sensorAdcZero": props.adcResult })
                            //                                            finishView(intent);
                            //                                            return
                            //                                        }
                            //                                    }

                            //                                    var intent = IntentApp.create(uri, {})
                            //                                    finishView(intent)
                            //                                }
                            //                            }//
                        }//

                        Component.onCompleted: {
                            if (!props.calibrateDone){
                                featureImage.source = "qrc:/UI/Pictures/fail-red-white.png"
                                resultStattusText.text = qsTr("Failed")
                                resultiInfoText.visible = true
                                resultiInfoText.text = qsTr("The minimum required ADC is 1")
                                        + "<br>"
                                        + qsTr("Please check the sensor input port!")
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
                                        let intent = IntentApp.create(uri, { "pid": props.pid, "sensorAdcZero": props.adcResult })
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
                                if (fragmentStackView.currentItem.idname === "started"){
                                    if (props.fanDutyCycleActual) {
                                        viewApp.showDialogMessage(qsTr("Notification"),
                                                                  qsTr("Please turned off the fan and wait until ADC has stable!"),
                                                                  viewApp.dialogAlert)

                                        return
                                    }
                                }

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

            property int adcActual: 0
            property int adcResult: 0

            property int temperatureActual: 0
            property string temperatureActualStr: "0°C"

            property bool calibrateDone: false
        }

        /// Called once but after onResume
        Component.onCompleted: {
        }//

        /// Execute This Every This Screen when Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                let extradata = IntentApp.getExtraData(intent)
                //                    //console.debug(JSON.stringify(extradata))
                if (extradata['pid'] !== undefined) {
                    //                        //console.debug(extradata['pid'])
                    props.pid = extradata['pid']
                }

                props.fanDutyCycleActual = Qt.binding(function(){ return MachineData.fanPrimaryDutyCycle })
                props.fanRpmActual = Qt.binding(function(){ return MachineData.fanPrimaryRpm })

                props.adcActual = Qt.binding(function() { return MachineData.ifaAdcConpensation })

                props.temperatureActual = Qt.binding(function(){ return MachineData.temperature })
                props.temperatureActualStr = Qt.binding(function(){ return MachineData.temperatureValueStr })

                /// Automatically turned off the blower
                MachineAPI.setFanPrimaryDutyCycle(0);

                viewApp.showBusyPage(qsTr("Turning off the fan..."),
                                     function onTriggered(cycle){
                                         if(cycle === 5){
                                             viewApp.dialogObject.close()
                                         }
                                     })
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
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
