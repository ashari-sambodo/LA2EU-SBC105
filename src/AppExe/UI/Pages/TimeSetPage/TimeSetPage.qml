import QtQuick 2.4
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Time"

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
                    title: qsTr("Time")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                /// fragment container
                StackView {
                    id: fragmentStackView
                    anchors.fill: parent
                    initialItem: currentValueComponent/*configureComponent*/
                }//

                /// fragment-1
                Component {
                    id: currentValueComponent

                    Item{
                        Column {
                            id: currentValueColumn
                            anchors.centerIn: parent
                            spacing: 5

                            TextApp{
                                text: qsTr("Current time") + ":"
                            }//

                            Row {
                                spacing: 10

                                TextApp{
                                    id: currentValueText
                                    font.pixelSize: 36
                                    wrapMode: Text.WordWrap
                                    text: "---"

                                    //                                width: Math.min(controlMaxWidthText.width, leftContentColumn.parent.width)

                                    //                                Text {
                                    //                                    visible: false
                                    //                                    id: controlMaxWidthText
                                    //                                    text: currentValueText.text
                                    //                                    font.pixelSize: 36
                                    //                                }//

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            fragmentStackView.push(configureComponent)
                                        }//
                                    }//

                                    /// Timer for update current value
                                    Timer{
                                        id: timeDateTimer
                                        running: true
                                        interval: 1000
                                        repeat: true
                                        triggeredOnStart: true
                                        onTriggered: {
                                            var datetime = new Date();
                                            currentValueText.text = Qt.formatDateTime(datetime, props.currentTimeStrf)
                                        }//
                                    }//
                                }//

                                TextApp {
                                    text: "/"
                                    font.pixelSize: 36
                                }//

                                TextApp {
                                    text: props.currentTimePeriod == 24 ? "24h" : "12h"
                                    font.pixelSize: 36

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            fragmentStackView.push(configureFormatComponent)
                                        }//
                                    }//
                                }//
                            }//

                            TextApp{
                                text: qsTr("Tap to change")
                                color: "#cccccc"
                            }//
                        }//

                        TextApp{
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Text.AlignHCenter
                            width: 500
                            color: "#cccccc"
                            font.pixelSize: 16
                            text:  qsTr("This system has Network Time Protocol feature, pointing to time.google.com.") + "<br>" +
                                   qsTr("It will prioritize to make syncronization the time with server based on Time Zone.")
                        }//
                    }//
                }//

                /// fragment-2
                Component {
                    id: configureComponent

                    Item {
                        id: configureItem

                        Loader {
                            id: configureLoader
                            anchors.fill: parent
                            asynchronous: true
                            visible: status == Loader.Ready
                            sourceComponent: Item {
                                id: container

                                function formatText(count, modelData) {
                                    var data = count === 12 ? modelData + 1 : modelData;
                                    return data.toString().length < 2 ? "0" + data : data;
                                }//

                                FontMetrics {
                                    id: fontMetrics
                                    font.pixelSize: 20
                                }//

                                Component {
                                    id: delegateComponent

                                    Label {
                                        text: container.formatText(Tumbler.tumbler.count, modelData)
                                        opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font.pixelSize: fontMetrics.font.pixelSize * 1.25
                                        font.bold: Tumbler.tumbler.currentIndex == index
                                        color: "#e3dac9"
                                    }//
                                }//

                                Frame {
                                    id: frame
                                    padding: 10
                                    anchors.centerIn: parent

                                    background: Rectangle {
                                        color: "#0F2952"
                                        radius: 5
                                        border.color: "#e3dac9"
                                    }//

                                    function generateTime(){
                                        //                                        //console.debug("generateTime")

                                        let hour = hoursTumbler.currentIndex;
                                        let minutes = minutesTumbler.currentIndex;

                                        if (props.currentTimePeriod == 12) {
                                            hour = hour + 1
                                            if (amPmTumbler.currentIndex) {
                                                /// PM
                                                if(hour !== 12) {
                                                    hour = hour + 12
                                                }
                                            } else {
                                                /// AM
                                                if (hour === 12){
                                                    hour = hour - 12
                                                }
                                            }
                                        }

                                        let theTime = new Date()
                                        theTime.setHours(hour, minutes, 0)

                                        let theDateTimeStr = Qt.formatDateTime(theTime, "yyyy-MM-dd hh:mm:ss")
                                        props.requestTime = theDateTimeStr

                                        //                                        //console.debug("the time: " + theDateTimeStr)
                                    }
                                    Column{
                                        id: column
                                        spacing: 5
                                        TextApp {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            font.pixelSize: fontMetrics.font.pixelSize
                                            text: qsTr("HH:MM")
                                        }
                                        Row {
                                            id: row

                                            Tumbler {
                                                id: hoursTumbler
                                                model: props.currentTimePeriod
                                                delegate: delegateComponent
                                                width: 100

                                                onMovingChanged: {
                                                    if (!moving) {
                                                        frame.generateTime()
                                                    }//
                                                }//
                                            }//

                                            TextApp {
                                                anchors.verticalCenter: parent.verticalCenter
                                                font.pixelSize: fontMetrics.font.pixelSize
                                                text: ":"
                                            }

                                            Tumbler {
                                                id: minutesTumbler
                                                model: 60
                                                delegate: delegateComponent
                                                width: 100

                                                onMovingChanged: {
                                                    if (!moving) {
                                                        frame.generateTime()
                                                    }//
                                                }//
                                            }//

                                            Tumbler {
                                                id: amPmTumbler
                                                visible: props.currentTimePeriod == 12
                                                model: ["AM", "PM"]
                                                delegate: delegateComponent
                                                width: 100

                                                onMovingChanged: {
                                                    if (!moving) {
                                                        frame.generateTime()
                                                    }//
                                                }//
                                            }//
                                        }//
                                    }//
                                }//

                                Component.onCompleted: {
                                    props.requestTime = null
                                    setButton.visible = true

                                    let time = new Date()

                                    let hour = time.getHours()
                                    if (props.currentTimePeriod == 12) {
                                        if (hour >= 12) {
                                            hour = hour - 12
                                            amPmTumbler.currentIndex = 1
                                        }
                                        hour = hour - 1
                                    }

                                    let minute = time.getMinutes()

                                    hoursTumbler.currentIndex = hour
                                    minutesTumbler.currentIndex = minute
                                }//

                                Component.onDestruction: {
                                    setButton.visible = false
                                }//
                            }//
                        }//

                        BusyIndicatorApp {
                            visible: configureLoader.status === Loader.Loading
                            anchors.centerIn: parent
                        }//
                    }//
                }//

                /// fragment-3
                Component {
                    id: configureFormatComponent

                    Item {

                        Loader {
                            id: configureLoader
                            anchors.fill: parent
                            asynchronous: true
                            visible: status == Loader.Ready
                            sourceComponent: Item {
                                id: container

                                function formatText(count, modelData) {
                                    var data = count === 12 ? modelData + 1 : modelData;
                                    return data.toString().length < 2 ? "0" + data : data;
                                }//

                                FontMetrics {
                                    id: fontMetrics
                                    font.pixelSize: 20
                                }//

                                Component {
                                    id: delegateComponent

                                    Label {
                                        text: container.formatText(Tumbler.tumbler.count, modelData)
                                        opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font.pixelSize: fontMetrics.font.pixelSize * 1.25
                                        font.bold: Tumbler.tumbler.currentIndex == index
                                        color: "#e3dac9"
                                    }//
                                }//

                                Frame {
                                    id: frame
                                    padding: 10
                                    anchors.centerIn: parent

                                    background: Rectangle {
                                        color: "#0F2952"
                                        radius: 5
                                        border.color: "#e3dac9"
                                    }//

                                    Tumbler {
                                        id: periodTumbler
                                        model: ["12h", "24h"]
                                        delegate: delegateComponent

                                        onMovingChanged: {
                                            if (!moving) {
                                                if (currentIndex){
                                                    props.requestPeriodTime = 24
                                                }
                                                else {
                                                    props.requestPeriodTime = 12
                                                }
                                            }//
                                        }//
                                    }//
                                }//

                                Component.onCompleted: {
                                    props.requestPeriodTime = null
                                    setButton.visible = true

                                    if (props.currentTimePeriod == 24) {
                                        periodTumbler.currentIndex = 1
                                    } else {
                                        periodTumbler.currentIndex = 0
                                    }
                                }//

                                Component.onDestruction: {
                                    setButton.visible = false
                                }//
                            }//
                        }//

                        BusyIndicatorApp {
                            visible: configureLoader.status === Loader.Loading
                            anchors.centerIn: parent
                        }//
                    }//
                }//

            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: MachineAPI.FOOTER_HEIGHT

                BackgroundButtonBarApp {
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
                                if (fragmentStackView.depth > 1) {
                                    fragmentStackView.pop();
                                    return
                                }

                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }//
                        }//

                        ButtonBarApp {
                            id: setButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            /// only visible from second fragment, set options
                            visible: false

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Set")

                            onClicked: {

                                if(props.requestTime !== null) {
                                    MachineAPI.setDateTime(props.requestTime);
                                    const timeStr = String(props.requestTime).split(" ")[1]
                                    MachineAPI.insertEventLog(qsTr("User: Set the time to") + " " + timeStr)
                                }

                                if(props.requestPeriodTime !== null) {

                                    props.currentTimePeriod = props.requestPeriodTime

                                    let timeFormatStr = "h:mm:ss AP"
                                    if (props.currentTimePeriod === 24) timeFormatStr = "hh:mm:ss"
                                    props.currentTimeStrf = timeFormatStr

                                    headerApp.setTimePeriod(props.requestPeriodTime)
                                    headerApp.forceUpdateCurrentTime()

                                    MachineAPI.saveTimeClockPeriod(props.requestPeriodTime);

                                    const timePerStr = props.currentTimePeriod === 24 ? qsTr("User: Set the time to 24h") : qsTr("User: Set the time to 12h")
                                    MachineAPI.insertEventLog(timePerStr)
                                }

                                viewApp.showBusyPage(qsTr("Setting up..."),
                                                     function onCycle(cycle){
                                                         if (cycle === MachineAPI.BUSY_CYCLE_3) {
                                                             fragmentStackView.pop()
                                                             viewApp.dialogObject.close()
                                                         }//
                                                     })
                            }
                        }//
                    }//
                }//
            }//
        }//

        ////// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            /// hold value for new required time
            property var requestTime: null
            property var requestPeriodTime: null

            property int currentTimePeriod: 12 //12h
            property string currentTimeStrf: "h:mm:ss AP"
        }

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

                props.currentTimePeriod = MachineData.timeClockPeriod

                if (props.currentTimePeriod == 24) {
                    props.currentTimeStrf = "hh:mm:ss"
                }
                else {
                    props.currentTimeStrf = "h:mm:ss AP"
                }
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
