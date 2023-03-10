import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

import UI.CusCom 1.1
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Measure Downflow"

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
                    title: qsTr("Measure Downflow")
                }
            }

            /// BODY
            BodyItemApp {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent
                    spacing: 5

                    Item{
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 5

                            Item{
                                Layout.minimumHeight: 30
                                Layout.fillWidth: true

                                Row {
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 5

                                    TextApp {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: qsTr("Required velocity is")
                                    }//

                                    TextApp {
                                        id: acceptableValueText
                                        anchors.verticalCenter: parent.verticalCenter
                                        font.bold: true
                                        color: "#05c46b"
                                        text: props.velocityReq.toFixed(2) + " ± " + props.velocityReqTolerant + " m/s"

                                        states: [
                                            State {
                                                when: props.measureUnit
                                                PropertyChanges {
                                                    target: acceptableValueText
                                                    text: props.velocityReq.toFixed(0) + " ± " + props.velocityReqTolerant + " fpm"
                                                }
                                            }
                                        ]
                                        //                                        text: props.airflowBottomLimit
                                        //                                              + " < "
                                        //                                              + qsTr("Average")
                                        //                                              + " < "
                                        //                                              + props.airflowTopLimit
                                    }//
                                }
                            }//

                            Item{
                                id: gridItem
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                GridLayout {
                                    anchors.fill: parent
                                    columns: 2

                                    Rectangle{
                                        id: gridBackgroundRectangle
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        color: "transparent"
                                        border.color: "#dddddd"
                                        radius: 5

                                        Flickable {
                                            id: girdFlick
                                            anchors.centerIn: parent
                                            height: gridLoader.height > gridBackgroundRectangle.height
                                                    ? gridBackgroundRectangle.height - 10 : gridLoader.height
                                            width: gridLoader.width > gridBackgroundRectangle.width
                                                   ? gridBackgroundRectangle.width - 10 : gridLoader.width
                                            clip: true
                                            contentHeight: gridLoader.height
                                            contentWidth: gridLoader.width

                                            ScrollBar.vertical: verticalScrollBar
                                            ScrollBar.horizontal: horizontalScrollBar

                                            onContentWidthChanged: {
                                                girdFlick.contentX = props.gridLastPositionX
                                                //                                                //console.debug(girdFlick.contentX)
                                            }

                                            onContentHeightChanged: {
                                                girdFlick.contentY = props.gridLastPositionY
                                                //                                                //console.debug(girdFlick.contentX)
                                            }

                                            /// GRID
                                            Loader {
                                                id: gridLoader
                                                asynchronous: true
                                                visible: status == Loader.Ready

                                                onLoaded: {
                                                    gridLoader.item.clickedItem.connect(gridLoader.onClickedItem)
                                                }

                                                function onClickedItem(index, value, valueStrf) {
                                                    //                                            //console.debug(index)
                                                    bufferTextInput.text = valueStrf
                                                    bufferTextInput.lastIndexAccessed = index

                                                    KeyboardOnScreenCaller.openNumpad(bufferTextInput, "P-" + (index + 1))

                                                    // remembering teh last scrollview position
                                                    props.gridLastPositionX = girdFlick.contentX
                                                    props.gridLastPositionY = girdFlick.contentY
                                                }//

                                            }//
                                        }//

                                        BusyIndicatorApp {
                                            anchors.centerIn: parent
                                            visible: gridLoader.status == Loader.Loading
                                        }//

                                        TextInput {
                                            id: bufferTextInput
                                            visible: false

                                            property int lastIndexAccessed: 0

                                            //                                        Connections {
                                            //                                            target: gridLoader.item

                                            //                                            function onClickedItem(index, value, valueStrf) {
                                            //                                                //                                        //console.debug(index)
                                            //                                                bufferTextInput.text = valueStrf
                                            //                                                bufferTextInput.lastIndexAccessed = index

                                            //                                                KeyboardOnScreenCaller.openNumpad(bufferTextInput, "P-" + (index + 1))
                                            //                                            }//
                                            //                                        }//

                                            onAccepted: {
                                                //                                                //console.debug(text)
                                                let valid = Number(text)
                                                if(isNaN(valid)){
                                                    showDialogMessage(qsTr("Warning"), qsTr("Value is not valid!"), dialogAlert)
                                                    return
                                                }

                                                let index = bufferTextInput.lastIndexAccessed
                                                if(props.measureUnit){
                                                    props.airflowGridItems[index]["val"] = props.getMpsFromFpm(Number(text))
                                                    props.airflowGridItems[index]["valImp"] = Number(text)
                                                }
                                                else{
                                                    props.airflowGridItems[index]["val"] = Number(text)
                                                    props.airflowGridItems[index]["valImp"] = props.getFpmFromMps(Number(text))
                                                }
                                                props.airflowGridItems[index]["acc"] = 1

                                                props.autoSaveToDraftAfterCalculated = true
                                                helperWorkerScript.calculateGrid(props.airflowGridItems, props.velocityDecimalPoint)
                                            }//
                                        }//
                                    }//

                                    Rectangle{
                                        Layout.fillHeight: true
                                        Layout.minimumWidth: 10
                                        color: "transparent"
                                        border.color: "#dddddd"
                                        radius: 5

                                        /// Horizontal ScrollBar
                                        ScrollBar {
                                            id: verticalScrollBar
                                            anchors.fill: parent
                                            orientation: Qt.Horizontal
                                            policy: ScrollBar.AlwaysOn

                                            contentItem: Rectangle {
                                                implicitWidth: 5
                                                implicitHeight: 0
                                                radius: width / 2
                                                color: "#dddddd"
                                            }//
                                        }//
                                    }//

                                    Rectangle{
                                        Layout.minimumHeight: 10
                                        Layout.fillWidth: true
                                        color: "transparent"
                                        border.color: "#dddddd"
                                        radius: 5

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

                            Item{
                                Layout.minimumHeight: 30
                                Layout.fillWidth: true

                                Row {
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 10

                                    Repeater {
                                        model: [
                                            {color: "#e67e22", text: qsTr("Lowest")},
                                            {color: "#e74c3c", text: qsTr("Highest")},
                                            {color: "#8e44ad", text: qsTr("Entered")},
                                        ]

                                        Row {
                                            anchors.verticalCenter: parent.verticalCenter
                                            spacing: 5

                                            Rectangle {
                                                anchors.verticalCenter: parent.verticalCenter
                                                height: 20
                                                width: 20
                                                color: modelData.color
                                            }//

                                            TextApp {
                                                anchors.verticalCenter: parent.verticalCenter
                                                text: modelData.text
                                            }//
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//

                    Item {
                        id: rightContentItem
                        Layout.fillHeight: true
                        Layout.minimumWidth: parent.width * 0.25

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 5
                            Row{
                                Rectangle {
                                    //                                anchors.verticalCenter: parent.verticalCenter
                                    width: rightContentItem.width/2
                                    height: rightContentItem.height / 3 - 5
                                    color: "#0F2952"
                                    border.color: "#05c46b"
                                    radius: 5

                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 3
                                        spacing: 1

                                        Item{
                                            Layout.fillWidth: true
                                            Layout.minimumHeight: 40
                                            TextApp {
                                                width: parent.width
                                                height: parent.height
                                                wrapMode: Text.WordWrap
                                                font.pixelSize: 12
                                                minimumPixelSize: 10
                                                text: qsTr("Press here to adjust <b>%1</b> fan").arg(qsTr("Downflow"))
                                            }
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
                                                    when: props.dfaFanDutyCycleActual
                                                    PropertyChanges {
                                                        target: fanImage
                                                        source: "qrc:/UI/Pictures/controll/Fan_G.png"
                                                    }//
                                                }//
                                            }//
                                        }//

                                        TextApp {
                                            Layout.fillWidth: true
                                            text: "Dcy: " + props.dfaFanDutyCycleActual + "%"
                                        }//

                                        TextApp {
                                            Layout.fillWidth: true
                                            text: "RPM: " + props.dfaFanRpmActual
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
                                                                     if(cycle === MachineAPI.BUSY_CYCLE_3){ viewApp.dialogObject.close() }
                                                                 })
                                        }//
                                    }//
                                }//
                                Rectangle {
                                    //                                anchors.verticalCenter: parent.verticalCenter
                                    width: rightContentItem.width/2
                                    height: rightContentItem.height / 3 - 5
                                    color: "#0F2952"
                                    border.color: "#dddddd"
                                    radius: 5

                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 3
                                        spacing: 1

                                        Item{
                                            Layout.fillWidth: true
                                            Layout.minimumHeight: 40
                                            TextApp {
                                                width: parent.width
                                                height: parent.height
                                                wrapMode: Text.WordWrap
                                                font.pixelSize: 12
                                                minimumPixelSize: 10
                                                text: qsTr("Press here to adjust <b>%1</b> fan").arg(qsTr("Inflow"))
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true

                                            Image {
                                                id: ifaFanImage
                                                source: "qrc:/UI/Pictures/controll/Fan_W.png"
                                                anchors.fill: parent
                                                fillMode: Image.PreserveAspectFit

                                                states: State {
                                                    name: "stateOn"
                                                    when: props.ifaFanDutyCycleActual
                                                    PropertyChanges {
                                                        target: ifaFanImage
                                                        source: "qrc:/UI/Pictures/controll/Fan_G.png"
                                                    }//
                                                }//
                                            }//
                                        }//

                                        TextApp {
                                            Layout.fillWidth: true
                                            text: "Dcy: " + props.ifaFanDutyCycleActual + "%"
                                        }//

                                        TextApp {
                                            Layout.fillWidth: true
                                            color: MachineData.getDualRbmMode() ? "#e3dac9" : "#0F2952"
                                            text: "RPM: " + props.ifaFanRpmActual
                                        }//
                                    }//

                                    MouseArea {
                                        id: ifaFanSpeedMouseArea
                                        anchors.fill: parent
                                    }//

                                    TextInput {
                                        id: ifaFanSpeedBufferTextInput
                                        visible: false
                                        validator: IntValidator{bottom: 0; top: 99;}

                                        Connections {
                                            target: ifaFanSpeedMouseArea

                                            function onClicked() {
                                                //                                        //console.debug(index)
                                                ifaFanSpeedBufferTextInput.text = props.ifaFanDutyCycleActual

                                                KeyboardOnScreenCaller.openNumpad(ifaFanSpeedBufferTextInput, qsTr("Fan Duty Cycle") + " " + "(0-99)")
                                            }//
                                        }//

                                        onAccepted: {
                                            let val = Number(text)
                                            if(isNaN(val)) return

                                            MachineAPI.setFanInflowDutyCycle(val)

                                            viewApp.showBusyPage(qsTr("Adjusting fan duty cycle..."),
                                                                 function onTriggered(cycle){
                                                                     if(cycle === MachineAPI.BUSY_CYCLE_3){ viewApp.dialogObject.close() }
                                                                 })
                                        }//
                                    }//
                                }//
                            }
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
                                        Layout.fillWidth: true
                                        font.pixelSize: 18
                                        text: qsTr("Avg. Velocity") + ":"
                                    }//

                                    TextApp {
                                        Layout.fillWidth: true
                                        font.pixelSize: 18
                                        text: props.measureUnit ? "fpm" : "m/s"
                                    }//

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        TextField {
                                            id: averageTextField
                                            //enabled: false
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            width: parent.width - 2
                                            font.pixelSize: 24
                                            horizontalAlignment: Text.AlignHCenter
                                            color: "#dddddd"

                                            background: Rectangle {
                                                id: averageBackgroundTextField
                                                height: parent.height
                                                width: parent.width
                                                color: averageTextField.enabled ? "#55000000" : "transparent"

                                                Rectangle {
                                                    height: 1
                                                    width: parent.width
                                                    anchors.bottom: parent.bottom
                                                }//
                                                MouseArea{
                                                    id: averageTextFieldMouseArea
                                                    anchors.fill: parent
                                                }
                                            }//

                                            states: [
                                                State {
                                                    when: props.velocityAverage == 0
                                                    PropertyChanges {
                                                        target: averageBackgroundTextField
                                                        color:  averageTextField.enabled ? "#55000000" : "transparent"
                                                    }//
                                                },//
                                                State {
                                                    when: props.velocityAverage < props.velocityLowestLimit
                                                    PropertyChanges {
                                                        target: averageBackgroundTextField
                                                        color:  "#e67e22"
                                                    }//
                                                },//
                                                State {
                                                    when: props.velocityAverage > props.velocityHighestLimit
                                                    PropertyChanges {
                                                        target: averageBackgroundTextField
                                                        color:  "#e74c3c"
                                                    }//
                                                }//
                                            ]//
                                            Connections {
                                                target: averageTextFieldMouseArea

                                                function onClicked() {
                                                    KeyboardOnScreenCaller.openNumpad(averageTextField, qsTr("Avg. Velocity") + " (%1)".arg(props.measureUnit ? "fpm" : "m/s"))
                                                }//
                                            }//
                                            onAccepted: {
                                                let valid = Number(text)
                                                if(isNaN(valid)){
                                                    showDialogMessage(qsTr("Warning"), qsTr("Value is not valid!"), dialogAlert)
                                                    return
                                                }
                                                let totalIndex = props.airflowGridCount

                                                for(let index = 0; index < totalIndex; index++){
                                                    if(props.measureUnit){
                                                        props.airflowGridItems[index]["val"] = props.getMpsFromFpm(Number(text))
                                                        props.airflowGridItems[index]["valImp"] = Number(text)
                                                    }
                                                    else{
                                                        props.airflowGridItems[index]["val"] = Number(text)
                                                        props.airflowGridItems[index]["valImp"] = props.getFpmFromMps(Number(text))
                                                    }
                                                    props.airflowGridItems[index]["acc"] = 1
                                                }
                                                props.autoSaveToDraftAfterCalculated = true
                                                helperWorkerScript.calculateGrid(props.airflowGridItems, props.velocityDecimalPoint)
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
                                        Layout.fillWidth: true
                                        font.pixelSize: 18
                                        text: qsTr("Max. Deviation") + ":"
                                    }//

                                    TextApp {
                                        Layout.fillWidth: true
                                        font.pixelSize: 18
                                        text: props.measureUnit ? "fpm" : "m/s"
                                    }//

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        TextField {
                                            id: deviationTextField
                                            enabled: false
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            width: parent.width - 2
                                            font.pixelSize: 24
                                            horizontalAlignment: Text.AlignHCenter
                                            color: "#dddddd"
                                            //                                            text: "0.03 (5%)"

                                            background: Rectangle {
                                                id: deviationBackgroundTextField
                                                height: parent.height
                                                width: parent.width
                                                color: deviationTextField.enabled ? "#55000000" : "transparent"

                                                Rectangle {
                                                    height: 1
                                                    width: parent.width
                                                    anchors.bottom: parent.bottom
                                                }//

                                                states: [
                                                    State {
                                                        when: props.velocityDeviationPercent > props.deviationMaxLimit
                                                        PropertyChanges {
                                                            target: deviationBackgroundTextField
                                                            color:  "#e74c3c"
                                                        }//
                                                    }//
                                                ]//
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
                    radius: 2

                    Item {
                        anchors.fill: parent
                        anchors.margins: 5

                        Row {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 1

                            ButtonBarApp {
                                width: 194
                                anchors.verticalCenter: parent.verticalCenter

                                imageSource: "qrc:/UI/Pictures/back-step.png"
                                text: qsTr("Back")

                                onClicked: {
                                    var intent = IntentApp.create(uri, {})
                                    finishView(intent)
                                }//
                            }//

                            ButtonBarApp {
                                width: 194
                                anchors.verticalCenter: parent.verticalCenter

                                imageSource: "qrc:/UI/Pictures/draft-w-icon.png"
                                text: qsTr("Load from Draft")

                                onClicked: {
                                    const message = "<b>" + qsTr("Load grid values from draft?") + "</b>"
                                                  + "<br><br>"
                                                  + qsTr("Current values will be lost.")

                                    viewApp.showDialogAsk(qsTr("Measure Downflow"),
                                                          message,
                                                          viewApp.dialogInfo,
                                                          function onAccepted(){
                                                              props.autoSaveToDraftAfterCalculated = false
                                                              helperWorkerScript.initGridFromStringify(draftSettings.drafAirflowGridStr,
                                                                                                       props.airflowGridCount,
                                                                                                       props.velocityDecimalPoint)
                                                          })
                                }//
                            }//

                            ButtonBarApp {
                                width: 194
                                anchors.verticalCenter: parent.verticalCenter

                                imageSource: "qrc:/UI/Pictures/cancel-w-icon.png"
                                text: qsTr("Clear All")

                                onClicked: {
                                    const message = "<b>" + qsTr("Clear all values?") + "</b>"
                                                  + "<br><br>"
                                                  + qsTr("Current values and drafted values will be removed.")

                                    viewApp.showDialogAsk(qsTr("Measure Downflow"),
                                                          message,
                                                          viewApp.dialogAlert,
                                                          function onAccepted(){
                                                              props.autoSaveToDraftAfterCalculated = true
                                                              helperWorkerScript.generateGrid(props.airflowGridCount,
                                                                                              props.velocityDecimalPoint)
                                                          })
                                }//
                            }//
                        }//

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "/UI/Pictures/checkicon.png"
                            text: qsTr("Set")

                            onClicked: {
                                //let data = JSON.stringify(props.airflowGridItems)
                                ////console.debug(data)
                                if (!props.gridAcceptedAll) {
                                    viewApp.showDialogMessage(qsTr("Measure Downflow"),
                                                              qsTr("Please fill up all the fields!"),
                                                              viewApp.dialogAlert)
                                    return;
                                }

                                const velFromLowIsValid     = (props.velocityAverage < props.velocityLowestLimit) ? true : false
                                const velFromHighIsValid    = (props.velocityAverage > props.velocityHighestLimit) ? true : false
                                const devIsValid            = props.velocityDeviationPercent > props.deviationMaxLimit ? true : false

                                ////console.debug("velFromLowIsValid: " + velFromLowIsValid + " " + props.velocityAverage + " " + props.velocityLowestLimit)
                                ////console.debug("velFromHighIsValid: " + velFromHighIsValid + " " + props.velocityAverage + " " + props.velocityHighestLimit)
                                ////console.debug("devIsValid: " + devIsValid)

                                if (velFromLowIsValid || velFromHighIsValid || devIsValid) {
                                    var message = devIsValid ? qsTr("The deviation is out of specs") : qsTr("The velocity is out of specs")
                                    viewApp.showDialogMessage(qsTr("Measure Downflow"),
                                                              message,
                                                              viewApp.dialogAlert)
                                    return;
                                }

                                let result = props.getMeasureResult()
                                let intent = IntentApp.create(uri, {"pid": props.pid, "calibrateRes": result})
                                finishView(intent);
                            }//
                        }//
                    }//
                }//
            }//
        }//

        WorkerScript {
            id: helperWorkerScript
            source: "Components/WorkerScriptDonflowHelper.mjs"

            property bool hasEstablised: false
            signal establised()

            Component.onCompleted: {
                //                //console.debug("helperWorkerScript: establised")
                hasEstablised = true
                establised()
            }

            function generateGrid(count, decimals){
                sendMessage({"action": "generate", "count": count, "decimals": decimals})
            }//

            function initGrid(grid, count, decimals){
                sendMessage({"action": "init", "grid": grid, "count": count, "decimals": decimals})
            }//

            function initGridFromStringify(gridStringify, count, decimals){
                sendMessage({"action": "init", "gridStringify": gridStringify, "count": count, "decimals": decimals})
            }//

            function calculateGrid(airflowGridItems, decimals){
                sendMessage({"action": "calculate", "grid": airflowGridItems, "decimals": decimals})
            }//

            onMessage: {
                //                //console.debug(messageObject["action"])

                if (messageObject["action"] === "calculate") {
                    //                                        //console.debug(messageObject["grid"])
                    if(messageObject["status"] === "finished") {

                        let average = messageObject["avgVal"]
                        ///
                        props.velocityAverage = average
                        //                        //console.debug(props.velocityAverage)

                        /// update to view
                        if(props.measureUnit)
                            average = Math.round(average)
                        else
                            average = Number(average).toFixed(2)

                        averageTextField.text = average

                        let deviation = messageObject["maxDeviationVal"]
                        let deviationPercent = messageObject["maxDeviationPrecent"]
                        if(props.measureUnit)
                            deviation = Math.round(deviation)
                        else
                            deviation = Number(deviation).toFixed(2)
                        let deviationText = deviation + " (" + deviationPercent +"%)"
                        ///
                        props.velocityDeviation = Number(deviation)
                        props.velocityDeviationPercent = deviationPercent
                        /// update to view
                        deviationTextField.text = deviationText

                        let acceptedCount = messageObject["acceptedCount"]
                        let acceptedAll = messageObject["acceptedAll"]
                        ///
                        props.gridAcceptedCount = acceptedCount
                        props.gridAcceptedAll = acceptedAll

                        let minVal = messageObject["minVal"]
                        props.velocityLowest = minVal
                        let maxVal = messageObject["maxVal"]
                        props.velocityHighest = maxVal

                        let sumVal = messageObject["sumVal"]
                        props.velocitySum = sumVal

                        props.airflowGridItems = messageObject["grid"]
                        gridLoader.setSource("Components/MeasureAirflowGrid.qml",
                                             {
                                                 "measureUnit": props.measureUnit,
                                                 "columns": props.airflowGridColumns,
                                                 "model": messageObject["grid"],
                                                 "valueMinimum": minVal,
                                                 "valueMaximum": maxVal,
                                             })

                        /// Save to draft
                        if (props.autoSaveToDraftAfterCalculated) {
                            let gridStringify = messageObject["gridStringify"]
                            draftSettings.drafAirflowGridStr = gridStringify
                        }
                        ////console.debug(messageObject["gridStringify"])
                    }//
                }//

                else if (messageObject["action"] === "init") {
                    //                                        //console.debug(messageObject["grid"])
                    if(messageObject["status"] === "finished") {
                        props.airflowGridItems = messageObject["grid"]
                        gridLoader.setSource("Components/MeasureAirflowGrid.qml",
                                             {
                                                 "measureUnit": props.measureUnit,
                                                 "columns": props.airflowGridColumns,
                                                 "model": messageObject["grid"],
                                             })

                        ///show message
                        //                        viewApp.showDialogMessage(qsTr("Measure Downflow"),
                        //                                                  qsTr("Value from temporary storage has been loaded!"),
                        //                                                  viewApp.dialogInfo)

                        /// then calculate
                        helperWorkerScript.calculateGrid(props.airflowGridItems, props.velocityDecimalPoint)
                    }
                }

                else if (messageObject["action"] === "generate") {
                    //                                        //console.debug(messageObject["grid"])
                    if(messageObject["status"] === "finished") {
                        props.airflowGridItems = messageObject["grid"]
                        gridLoader.setSource("Components/MeasureAirflowGrid.qml",
                                             {
                                                 "measureUnit": props.measureUnit,
                                                 "columns": props.airflowGridColumns,
                                                 "model": messageObject["grid"]
                                             })

                        /// then calculate
                        helperWorkerScript.calculateGrid(props.airflowGridItems, props.velocityDecimalPoint)
                    }//
                }//
            }//
        }//

        Settings {
            id: draftSettings
            category: props.draftName

            property string drafAirflowGridStr: ""
            //            Component.onCompleted: //console.debug(drafDownflowGridStr)
        }//

        //        /// 0: airflow fix with tolerant, example: 0.30 ± 0.025, 60 ± 5
        //        /// 1: airflow have range, example: 0.27 - 0.35
        //        property int    airflowNominalInRange: 0

        QtObject {
            id: props

            property string pid: "pid"

            property string draftName: ""

            property real   velocityReq: 0.0 /*+ 0.30*/
            property real   velocityReqTolerant: 0.0 /*+ 0.025*/
            property real   velocityLowestLimit: 0.0 /*+ 0.275*/
            property real   velocityHighestLimit: 0.0 /*+ 0.325*/
            property int    deviationMaxLimit: 0 + 20

            property int    airflowGridColumns: 1
            property int    airflowGridCount: 1
            property var    airflowGridItems: []
            property real   velocitySum: 0
            property real   velocityAverage: 0
            property real   velocityLowest: 0
            property real   velocityHighest: 0
            property real   velocityDeviation: 0
            property real   velocityDeviationPercent: 0

            property int    gridAcceptedCount: 0
            property int    gridAcceptedAll: 0

            property bool   autoSaveToDraftAfterCalculated: false

            property int    dfaFanDutyCycleActual: 0
            property int    dfaFanRpmActual: 0
            property int    ifaFanDutyCycleActual: 0
            property int    ifaFanRpmActual: 0

            property int    dfaFanDutyCycleInitial: 0
            //            property int    fanDutyCycleResult: 0
            //            property int    fanRpmResult: 0
            property int    ifaFanDutyCycleInitial: 0
            //property int    fanDutyCycleResult: 0
            //property int    fanRpmResult1: 0

            /// 0: metric, m/s
            /// 1: imperial, fpm
            property int    measureUnit: 0
            /// Metric normally 2 digits after comma, ex: 0.30
            /// Imperial normally Zero digit after comma, ex: 60
            property int    velocityDecimalPoint: measureUnit ? 0 : 2

            property real   gridLastPositionX: 0
            property real   gridLastPositionY: 0

            function getMeasureResult() {
                let result = {
                    'grid':     airflowGridItems,
                    'velocity': velocityAverage,
                    'velLow':   velocityLowest,
                    'velHigh':  velocityHighest,
                    'velDev':   velocityDeviation,
                    'velDevp':  velocityDeviationPercent,
                    'velSum':   velocitySum,
                    'fanDucy':  dfaFanDutyCycleActual,
                    'fanRpm':   dfaFanRpmActual,
                    'fanDucy1':  ifaFanDutyCycleActual,
                    'fanRpm1':   ifaFanRpmActual,
                }
                return result;
            }

            /// Need some logic to anticivate if the worker script not ready yet
            function initialGrid(){
                if(helperWorkerScript.hasEstablised) {
                    doInitialGrid()
                }
                else {
                    helperWorkerScript.establised.connect(doInitialGrid)
                }
            }
            function doInitialGrid(){
                props.autoSaveToDraftAfterCalculated = false
                helperWorkerScript.initGrid(props.airflowGridItems,
                                            props.airflowGridCount,
                                            props.velocityDecimalPoint)
            }

            function getMpsFromFpm(fpm){
                return (Math.round(fpm * 0.508))/100
            }
            function getFpmFromMps(mps){
                return Math.round(mps * 196.85)
            }
        }

        /// Called once but after onResume
        Component.onCompleted: {
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {

                let extradata = IntentApp.getExtraData(intent)
                //                    //console.debug(JSON.stringify(extradata))
                if (extradata['pid'] !== undefined) {
                    //                        //console.debug(JSON.stringify(extradata))

                    headerApp.title = extradata['title']

                    props.pid = extradata['pid']

                    props.draftName = extradata['pid'] + "Draft"

                    props.measureUnit = extradata['measureUnit']

                    props.dfaFanDutyCycleInitial = extradata['dfaFanDutyCycle'] || 0
                    props.ifaFanDutyCycleInitial = extradata['ifaFanDutyCycle'] || 0

                    props.airflowGridItems = extradata['grid']
                    //                        //console.debug(JSON.stringify(props.airflowGridItems))

                    let req = extradata['calibrateReq']
                    props.velocityReq =             req['velocity']
                    props.velocityReqTolerant =     req['velocityTol']
                    props.velocityLowestLimit =     req['velocityTolLow']
                    props.velocityHighestLimit =    req['velocityTolHigh']
                    props.deviationMaxLimit =       req['velDevp']
                    props.airflowGridCount =        req['grid']['count']
                    props.airflowGridColumns =      req['grid']['columns']
                    //                        //console.debug("gridColumn:" + props.airflowGridColumn)

                    //                helperWorkerScript.establised.connect(function(){
                    //                    props.autoSaveToDraftAfterCalculated = false
                    //                    helperWorkerScript.initGrid(props.airflowGridItems,
                    //                                                props.airflowGridCount,
                    //                                                props.velocityDecimalPoint)
                    //                })

                    //                props.autoSaveToDraftAfterCalculated = false
                    //                helperWorkerScript.initGrid(props.airflowGridItems,
                    //                                            props.airflowGridCount,
                    //                                            props.velocityDecimalPoint)
                }

                props.dfaFanDutyCycleActual = Qt.binding(function(){ return MachineData.fanPrimaryDutyCycle })
                props.dfaFanRpmActual = Qt.binding(function(){ return MachineData.fanPrimaryRpm })
                props.ifaFanDutyCycleActual = Qt.binding(function(){ return MachineData.fanInflowDutyCycle })
                props.ifaFanRpmActual = Qt.binding(function(){ return MachineData.fanInflowRpm })

                /// Automatically adjust the fan duty cycle to common initial duty cycle
                if ((props.dfaFanDutyCycleActual != props.dfaFanDutyCycleInitial)
                        || (props.ifaFanDutyCycleActual != props.ifaFanDutyCycleInitial)) {

                    MachineAPI.setFanPrimaryDutyCycle(props.dfaFanDutyCycleInitial);
                    MachineAPI.setFanInflowDutyCycle(props.ifaFanDutyCycleInitial);

                    viewApp.showBusyPage(qsTr("Adjusting fan duty cycle..."),
                                         function onTriggered(cycle){
                                             if(cycle === MachineAPI.BUSY_CYCLE_3){
                                                 // generate grid
                                                 props.initialGrid()
                                                 // close this pop up dialog
                                                 viewApp.dialogObject.close()
                                             }
                                         })
                }
                else {
                    // generate grid
                    props.initialGrid()
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
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
