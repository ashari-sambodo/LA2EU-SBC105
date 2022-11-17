import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
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
                    title: qsTr("ADC Zero")
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
                                id: leftContentItem
                                Layout.fillHeight: true
                                Layout.minimumWidth: parent.width * 0.22
                                Column{
                                    spacing: 5
                                    anchors.centerIn: parent
                                    Rectangle{
                                        color: "transparent"
                                        border.width: 0
                                        height: 40
                                        width: 200
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        Rectangle {
                                            color: "#80000000"
                                            anchors.centerIn: parent
                                            radius: 2
                                            TextApp {
                                                //id: msgInfoTextApp
                                                text: qsTr("Downflow")
                                                verticalAlignment: Text.AlignVCenter
                                                padding: 2
                                            }
                                            width: childrenRect.width
                                            height: childrenRect.height
                                        }//
                                    }
                                    Rectangle {
                                        width: 220
                                        height: 150
                                        color: "#0F2952"
                                        border.color: "#dddddd"
                                        radius: 5
                                        ColumnLayout {
                                            anchors.fill: parent
                                            anchors.margins: 2
                                            spacing: 1
                                            Item{
                                                Layout.fillWidth: true
                                                Layout.minimumHeight: 30
                                                TextApp {
                                                    visible: false
                                                    width: parent.width
                                                    height: parent.height
                                                    font.pixelSize: 14
                                                    text: qsTr("Tap here to turn off the Fan")
                                                    wrapMode: Text.WordWrap
                                                }
                                            }

                                            Item {
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true

                                                Image {
                                                    id: fanImage1
                                                    source: "qrc:/UI/Pictures/controll/Fan_W.png"
                                                    //anchors.fill: parent
                                                    height: 70
                                                    fillMode: Image.PreserveAspectFit
                                                    anchors.centerIn: parent

                                                    states: State {
                                                        name: "stateOn"
                                                        when: props.dfaFanDutyCycleActual
                                                        PropertyChanges {
                                                            target: fanImage1
                                                            source: "qrc:/UI/Pictures/controll/Fan_G.png"
                                                        }//
                                                    }//
                                                }//
                                            }//

                                            TextApp {
                                                text: "Dcy: " + utilsApp.getFanDucyStrf(props.dfaFanDutyCycleActual) + "%"
                                            }//

                                            TextApp {
                                                color: MachineData.cabinetWidth3Feet ? "#0F2952" : "#e3dac9"
                                                text: "RPM: " + props.dfaFanRpmActual
                                            }//
                                        }//

                                        MouseArea {
                                            enabled: false
                                            anchors.fill: parent
                                            onClicked: {

                                                MachineAPI.setFanPrimaryDutyCycle(0);

                                                viewApp.showBusyPage(qsTr("Switching off DF fan..."),
                                                                     function onTriggered(cycle){
                                                                         if(cycle === MachineAPI.BUSY_CYCLE_2){
                                                                             viewApp.dialogObject.close()
                                                                         }
                                                                     })
                                            }//
                                        }//
                                    }//
                                }//
                            }//

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
                                        text: qsTr("Downflow and Exhaust fan should be OFF!")
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

                            Item {
                                id: rightContentItem
                                Layout.fillHeight: true
                                Layout.minimumWidth: parent.width * 0.22
                                Column{
                                    spacing: 5
                                    anchors.centerIn: parent
                                    Rectangle{
                                        color: "transparent"
                                        border.width: 0
                                        height: 40
                                        width: 200
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        Rectangle {
                                            color: "#80000000"
                                            anchors.centerIn: parent
                                            radius: 2
                                            TextApp {
                                                //id: msgInfoTextApp
                                                text: qsTr("Inflow")
                                                verticalAlignment: Text.AlignVCenter
                                                padding: 2
                                            }
                                            width: childrenRect.width
                                            height: childrenRect.height
                                        }//
                                    }
                                    Rectangle {
                                        width: 220
                                        height: 150
                                        color: "#0F2952"
                                        border.color: "#dddddd"
                                        radius: 5
                                        ColumnLayout {
                                            anchors.fill: parent
                                            anchors.margins: 2
                                            spacing: 1

                                            Item{
                                                Layout.fillWidth: true
                                                Layout.minimumHeight: 30
                                                TextApp {
                                                    visible: false
                                                    width: parent.width
                                                    height: parent.height
                                                    font.pixelSize: 14
                                                    text: qsTr("Tap here to turn off the Fan")
                                                    wrapMode: Text.WordWrap
                                                }
                                            }

                                            Item {
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true

                                                Image {
                                                    id: fanImage2
                                                    source: "qrc:/UI/Pictures/controll/Fan_W.png"
                                                    //anchors.fill: parent
                                                    height: 70
                                                    fillMode: Image.PreserveAspectFit
                                                    anchors.centerIn: parent

                                                    states: State {
                                                        name: "stateOn"
                                                        when: props.ifaFanDutyCycleActual
                                                        PropertyChanges {
                                                            target: fanImage2
                                                            source: "qrc:/UI/Pictures/controll/Fan_G.png"
                                                        }//
                                                    }//
                                                }//
                                            }//

                                            TextApp {
                                                text: "Dcy: " + utilsApp.getFanDucyStrf(props.ifaFanDutyCycleActual) + "%"
                                            }//

                                            TextApp {
                                                text: "RPM: " + props.ifaFanRpmActual
                                                color: MachineData.getDualRbmMode() ? "#e3dac9" : "#0F2952"
                                            }//
                                        }//

                                        MouseArea {
                                            enabled: false
                                            anchors.fill: parent
                                            onClicked: {

                                                MachineAPI.setFanInflowDutyCycle(0);

                                                viewApp.showBusyPage(qsTr("Switching off IF fan..."),
                                                                     function onTriggered(cycle){
                                                                         if(cycle === MachineAPI.BUSY_CYCLE_2){
                                                                             viewApp.dialogObject.close()
                                                                         }
                                                                     })
                                            }//
                                        }//
                                    }//
                                }
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
                                text: qsTr("Please wait for %1").arg(utilsApp.strfSecsToHumanReadable(props.stabilizingTimer)) + ":"
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
                                            let ifaAdc = props.ifaAdcActual
                                            //                                            /// demo
                                            //                                            adc = 100

                                            if (dfaAdc > 0 && ifaAdc > 0) {
                                                // analog input have minimum constant adc value on each port
                                                // known value is about 5 to 8
                                                // if the value is <= zero (0) that mean there are some trouble in a port

                                                props.calibrateDone = true
                                            }

                                            props.dfaAdcResult = dfaAdc
                                            props.ifaAdcResult = ifaAdc

                                            fragmentStackView.replace(fragmentResultComp)
                                        }
                                    }//

                                    //                                    property int count: 2
                                    property int count: props.stabilizingTimer

                                    //Component.onCompleted: {count = Qt.binding(function(){return props.stabilizingTimer})}
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
                                }
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
                                }
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
                                    text: qsTr("DF ADC Zero") + ":"
                                }//

                                TextApp{
                                    font.bold: true
                                    text: props.dfaAdcResult
                                }//
                            }//

                            Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                            Row {
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 10

                                TextApp{
                                    text: qsTr("IF ADC Zero") + ":"
                                }//

                                TextApp{
                                    font.bold: true
                                    text: props.ifaAdcResult
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
                                        let intent = IntentApp.create(uri, {
                                                                          "pid": props.pid,
                                                                          "dfaSensorAdcZero": props.dfaAdcResult,
                                                                          "ifaSensorAdcZero": props.ifaAdcResult
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

        UtilsApp {
            id: utilsApp
        }//

        /// Private property
        QtObject{
            id: props

            property string pid: ""

            property int dfaSensorConstant : 0
            property int ifaSensorConstant : 0

            property int dfaFanDutyCycleActual: 0
            property int dfaFanRpmActual: 0
            property int ifaFanDutyCycleActual: 0
            property int ifaFanRpmActual: 0

            property int dfaAdcActual: 0
            property int dfaAdcResult: 0
            property int ifaAdcActual: 0
            property int ifaAdcResult: 0

            property int temperatureActual: 0
            property string temperatureActualStr: "0°C"

            property bool calibrateDone: false

            property int stabilizingTimer: 180
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
                    props.dfaSensorConstant = extradata['dfaSensorConstant'] || 0
                    props.ifaSensorConstant = extradata['ifaSensorConstant'] || 0
                }

                props.dfaFanDutyCycleActual = Qt.binding(function(){ return MachineData.fanPrimaryDutyCycle })
                props.dfaFanRpmActual       = Qt.binding(function(){ return MachineData.fanPrimaryRpm })
                props.ifaFanDutyCycleActual = Qt.binding(function(){ return MachineData.fanInflowDutyCycle })
                props.ifaFanRpmActual = Qt.binding(function(){ return MachineData.fanInflowRpm })

                props.dfaAdcActual = Qt.binding(function() { return MachineData.dfaAdcConpensation })
                props.ifaAdcActual = Qt.binding(function() { return MachineData.ifaAdcConpensation })

                props.temperatureActual = Qt.binding(function(){ return MachineData.temperature })
                props.temperatureActualStr = Qt.binding(function(){ return MachineData.temperatureValueStr })

                /// Automatically turned off the blower
                MachineAPI.setFanPrimaryDutyCycle(0);
                MachineAPI.setFanInflowDutyCycle(0);

                viewApp.showBusyPage(qsTr("Turning off the fan..."),
                                     function onTriggered(cycle){
                                         if(cycle === MachineAPI.BUSY_CYCLE_2){
                                             viewApp.dialogObject.close()
                                         }
                                     })

                if(!props.dfaSensorConstant && !props.ifaSensorConstant)
                    props.stabilizingTimer = 60 // Degree C Sensor
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
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
