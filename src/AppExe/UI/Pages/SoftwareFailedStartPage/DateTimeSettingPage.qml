import QtQuick 2.4
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.calendar 1.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Date & Time Setting"

    background.sourceComponent:
        Rectangle{color: "black"}

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
                RowLayout{
                    anchors.fill: parent
                    spacing: 5
                    Rectangle {
                        Layout.minimumWidth: parent.width/4
                        Layout.fillHeight: true
                        color: "transparent"
                        border.color: "#e3dac9"
                        border.width: 1
                        radius: 5
                        RowLayout{
                            anchors.fill: parent
                            clip: true
                            anchors.margins: 5
                            spacing: 5
                            Item{
                                Layout.fillHeight: true
                                Layout.minimumWidth: parent.width*0.70
                                Image{
                                    width: parent.width
                                    fillMode: Image.PreserveAspectFit
                                    anchors.verticalCenter: parent.verticalCenter
                                    source:"qrc:/UI/Pictures/logo/esco-logo-50px.png"
                                }
                            }
                            Item{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                TextApp{
                                    height: parent.height
                                    width: parent.width
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: MachineData.serialNumber.replace("-", "-\n")
                                    minimumPixelSize: 16
                                    fontSizeMode: Text.Fit
                                    //                                    font.family: "Courier";
                                }
                            }
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "transparent"
                        border.color: "#e3dac9"
                        border.width: 1
                        radius: 5
                        TextApp{
                            height: parent.height
                            width: parent.width
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: viewApp.title
                            font.bold: true
                            //                            font.family: "Courier";
                            font.pixelSize: 20
                        }
                    }
                    Rectangle {
                        Layout.minimumWidth: parent.width/4
                        Layout.fillHeight: true
                        color: "transparent"
                        border.color: "#e3dac9"
                        border.width: 1
                        radius: 5
                        TextApp{
                            id: topBarClockText
                            anchors.fill: parent
                            anchors.margins: 5
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            fontSizeMode: Text.Fit
                            text: "Auto Shut down<br>in %1 %2".arg(props.shutDownCountDownTimer).arg(props.shutDownCountDownTimer>1 ? "seconds" : "second")
                            //                            font.family: "Courier";
                        }//
                    }//
                }//
                Timer {
                    id: backgroundShutDownTimer
                    running: false
                    repeat: true
                    interval: 1000
                    onTriggered: {
                        if(--props.shutDownCountDownTimer == 0){
                            let exitCodePowerOff = 6
                            const intent = IntentApp.create("qrc:/UI/Pages/ClosingPage/ClosingPage.qml", {exitCode: exitCodePowerOff, backgroundBlack: 1})
                            startRootView(intent)
                        }
                        //                        var datetime = new Date();
                        //                        //            dateText.text = Qt.formatDateTime(datetime, "dddd\nMMM dd yyyy")
                        //                        let date = Qt.formatDateTime(datetime, "ddd MMM dd yyyy")

                        //                        let timeFormatStr = "hh:mm"
                        //                        if (HeaderAppService.timePeriod === 24) timeFormatStr = "hh:mm"
                        //                        let clock = Qt.formatDateTime(datetime, timeFormatStr)

                        //                        topBarClockText.text = date + "<br>" + clock
                    }//
                }//
                Component.onCompleted: {
                    backgroundShutDownTimer.running = true
                }
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                /// fragment container
                StackView {
                    id: fragmentStackView
                    anchors.fill: parent
                    initialItem: currentValueItem/*configureComponent*/
                }//

                /// fragment-1
                Item {
                    id: currentValueItem
                    RowLayout{
                        anchors.fill: parent
                        Item{
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Column {
                                id: currentValueTimeColumn
                                anchors.centerIn: parent
                                spacing: 5

                                TextApp{
                                    text: ("Current time") + ":"
                                }//

                                Row {
                                    spacing: 10

                                    TextApp{
                                        id: currentValueTimeText
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
                                    text: ("Tap to change")
                                    color: "#cccccc"
                                }//
                            }//
                        }//
                        Item{
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Column {
                                id: currentValueDateColumn
                                anchors.centerIn: parent
                                spacing: 5

                                TextApp{
                                    text: ("Current date") + ":"
                                }//

                                TextApp{
                                    id: currentValueDateText
                                    font.pixelSize: 36
                                    wrapMode: Text.WordWrap
                                    text: "---"

                                    property var monthStrings: [
                                        ("January"),
                                        ("Fabruary"),
                                        ("March"),
                                        ("April"),
                                        ("May"),
                                        ("June"),
                                        ("July"),
                                        ("August"),
                                        ("September"),
                                        ("October"),
                                        ("November"),
                                        ("December")
                                    ]
                                }//

                                TextApp{
                                    text: ("Tap to change")
                                    color: "#cccccc"
                                }//
                            }//

                            MouseArea {
                                anchors.fill: currentValueDateColumn
                                onClicked: {
                                    fragmentStackView.push(calenderDateComponent)
                                }//
                            }//
                        }//
                        Component.onCompleted: {
                            console.debug("Component.onCompleted")
                        }
                    }//
                    /// Timer for update current value
                    Timer{
                        id: timeTimer
                        running: true
                        interval: 1000
                        repeat: true
                        triggeredOnStart: true
                        onTriggered: {
                            var datetime = new Date();
                            ///time
                            currentValueTimeText.text = Qt.formatDateTime(datetime, props.currentTimeStrf)
                            ///date
                            let monthText = currentValueDateText.monthStrings[datetime.getMonth()]
                            let dateText = Qt.formatDateTime(datetime, "dd yyyy")

                            currentValueDateText.text = monthText + " " + dateText
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
                                        color: "#333333"
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
                        Component.onCompleted: {
                            console.debug("Component.onCompleted")
                            props.fragmentState = props.setTime
                        }
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
                                        color: "#333333"
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
                        Component.onCompleted: {
                            console.debug("Component.onCompleted")
                            props.fragmentState = props.setTimeFormat
                        }
                    }//
                }//

                /// fragment 4
                Component {
                    id: calenderDateComponent

                    Item {

                        Loader {
                            id: calendarGridLoader
                            anchors.fill: parent
                            asynchronous: true
                            visible: status == Loader.Ready
                            sourceComponent:  CalendarGridApp {
                                id: calendar
                                colorGridRect: "#333333"
                                Component.onCompleted: {
                                    let today = new Date()
                                    today.setHours(0, 0, 0, 0)

                                    targetDate = today
                                    targetMonth = today.getMonth()
                                    targetYear = today.getFullYear()

                                    let futureLimit = new Date()
                                    futureLimit.setHours(0, 0, 0, 0)
                                    futureLimit.setDate(31)
                                    futureLimit.setMonth(Calendar.December)
                                    futureLimit.setFullYear(2050)
                                    futureDateLimit = futureLimit

                                    let olderLimit = new Date()
                                    olderLimit.setHours(0, 0, 0, 0)
                                    olderLimit.setDate(1)
                                    olderLimit.setMonth(Calendar.January)
                                    olderLimit.setFullYear(2020)
                                    olderDateLimit = olderLimit
                                }//

                                onClicked: {
                                    viewApp.showBusyPage(("Setting up..."),
                                                         function onCycle(cycle){
                                                             if (cycle === 5) {
                                                                 fragmentStackView.pop()
                                                                 viewApp.dialogObject.close()
                                                             }//
                                                         })

                                    let dateTime = Qt.formatDateTime(date, "yyyy-MM-dd hh:mm:ss")
                                    /// tell to machine
                                    MachineAPI.setDateTime(dateTime);
                                    MachineAPI.insertEventLog(("User: Set the date to") + " " + Qt.formatDateTime(date, "yyyy-MM-dd"))
                                }//
                            }//
                        }//

                        BusyIndicatorApp {
                            visible: calendarGridLoader.status !== Loader.Ready
                            anchors.centerIn: parent
                        }//
                        Component.onCompleted: {
                            console.debug("Component.onCompleted")
                            props.fragmentState = props.setDate
                        }
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
                    color: "transparent"
                    //                    border.color: "#e3dac9"
                    //                    border.width: 1
                    radius: 5

                    Item {
                        anchors.fill: parent
                        anchors.margins: 5

                        ButtonBlackApp{
                            id: backButton
                            iconSource: "qrc:/UI/Pictures/back-step.png"
                            buttonText: "Back"
                            onClicked: {
                                if(props.fragmentState == props.currentDateTime){
                                    const intent = IntentApp.create("qrc:/UI/Pages/SoftwareFailedStartPage/SoftwareFailedStartPage.qml", {
                                                                        shutDownCountDownTimer: props.shutDownCountDownTimer,
                                                                        fromDateTimePage: 1})
                                    startRootView(intent)
                                }else{
                                    props.fragmentState = props.currentDateTime
                                    fragmentStackView.pop()
                                }
                            }
                        }

                        ButtonBlackApp{
                            id: setButton
                            visible: props.fragmentState == props.setTime || props.fragmentState == props.setTimeFormat
                            iconSource: "qrc:/UI/Pictures/checkicon.png"
                            buttonText: "Set"
                            anchors.right: parent.right
                            onClicked: {
                                if(props.requestTime !== null) {
                                    console.debug("Set time")
                                    MachineAPI.setDateTime(props.requestTime);
                                    const timeStr = String(props.requestTime).split(" ")[1]
                                    MachineAPI.insertEventLog(("User: Set the time to") + " " + timeStr)
                                }

                                if(props.requestPeriodTime !== null) {
                                    console.debug("Set time format")
                                    props.currentTimePeriod = props.requestPeriodTime

                                    let timeFormatStr = "h:mm:ss AP"
                                    if (props.currentTimePeriod === 24) timeFormatStr = "hh:mm:ss"
                                    props.currentTimeStrf = timeFormatStr

                                    HeaderAppService.timePeriod = props.requestPeriodTime

                                    MachineAPI.saveTimeClockPeriod(props.requestPeriodTime)

                                    const timePerStr = props.currentTimePeriod === 24 ? ("User: Set the time to 24h") : ("User: Set the time to 12h")
                                    MachineAPI.insertEventLog(timePerStr)
                                }

                                viewApp.showBusyPage(("Setting up..."),
                                                     function onCycle(cycle){
                                                         if (cycle === 5) {
                                                             fragmentStackView.pop()
                                                             viewApp.dialogObject.close()
                                                         }//
                                                     })
                            }
                        }
                    }//
                }//
            }//
        }//

        ////// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props
            property int shutDownCountDownTimer: 0
            /// hold value for new required time
            property var requestTime: null
            property var requestPeriodTime: null

            property int currentTimePeriod: 12 //12h
            property string currentTimeStrf: "h:mm:ss AP"

            property int fragmentState              : currentDateTime
            readonly property int currentDateTime   : 0
            readonly property int setTime           : 1
            readonly property int setTimeFormat     : 1
            readonly property int setDate           : 2
        }

        /// called Once but after onResume
        Component.onCompleted: {
            const extraData = IntentApp.getExtraData(intent)
            const message = extraData["shutDownCountDownTimer"] || 0
            props.shutDownCountDownTimer = message
            console.debug("shutDownCountDownTimer:", props.shutDownCountDownTimer)
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
