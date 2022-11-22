/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *      - Ahmad Qodri
 *          * initial code
 *      - Heri cahyono
 *          * Add column for number of Row
 *          * Pagination mechanism
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import DataLogQmlApp 1.0
import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Data Log"

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
                    title: qsTr("Data Log")
                }//
            }//

            /// BODY
            Item {
                id: contentItem
                Layout.fillHeight: true
                Layout.fillWidth: true

                RowLayout {
                    anchors.fill: parent
                    spacing: 5

                    ListView {
                        id: logListView
                        //                        anchors.fill: parent
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        spacing: 1
                        clip: true

                        ScrollBar.vertical: scrollBarApp.scrollBar

                        property bool prevFlik: false
                        property bool nextFlik: false
                        property bool actionFlik: false

                        //
                        //  Slot called when the flick has started
                        //
                        onFlickStarted: {
                            //                        //console.debug("onFlickStarted")
                            prevFlik = atYBeginning
                            nextFlik = atYEnd
                        }

                        onVerticalOvershootChanged: {
                            let value = Math.abs(verticalOvershoot)
                            ////console.debug(value)
                            if(value > 70){
                                if(!actionFlik){
                                    actionFlik = true
                                }
                            }
                        }

                        //
                        //  Slot called when the flick has finished
                        //
                        onFlickEnded: {
                            //                        //console.debug("onFlickEnded")
                            if (atYBeginning && prevFlik) {
                                if(actionFlik) {
                                    actionFlik = false
                                    //                                    //console.debug("Prev")
                                    logApp.prev()
                                }
                            }
                            else if (atYEnd && nextFlik) {
                                if(actionFlik) {
                                    actionFlik = false
                                    //                                    //console.debug("Next")
                                    logApp.next()
                                }
                            }
                        }

                        headerPositioning: ListView.OverlayHeader
                        header: Rectangle {
                            height: 50
                            width: logListView.width
                            color: "#0F2952"
                            z: 100

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 1

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 70

                                    TextApp {
                                        //anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: qsTr("No.")
                                        width: parent.width
                                        height: parent.height
                                        padding: 5
                                    }
                                }

                                Rectangle{
                                    Layout.minimumHeight: 0.8*parent.height
                                    Layout.minimumWidth: 1
                                    color: "#e3dac9"
                                }

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    TextApp {
                                        //anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: qsTr("Date")
                                        width: parent.width
                                        height: parent.height
                                        padding: 5
                                    }
                                }

                                Rectangle{
                                    Layout.minimumHeight: 0.8*parent.height
                                    Layout.minimumWidth: 1
                                    color: "#e3dac9"
                                }

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    TextApp {
                                        //anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: qsTr("Time (24h)")
                                        width: parent.width
                                        height: parent.height
                                        padding: 5
                                    }
                                }

                                Rectangle{
                                    Layout.minimumHeight: 0.8*parent.height
                                    Layout.minimumWidth: 1
                                    color: "#e3dac9"
                                }

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    TextApp {
                                        //anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: qsTr("Temp")                                        
                                        width: parent.width
                                        height: parent.height
                                        padding: 5
                                    }
                                }

                                Rectangle{
                                    Layout.minimumHeight: 0.8*parent.height
                                    Layout.minimumWidth: 1
                                    color: "#e3dac9"
                                }

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    TextApp {
                                        //anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: qsTr("Downflow")
                                        width: parent.width
                                        height: parent.height
                                        padding: 5
                                    }
                                }

                                Rectangle{
                                    Layout.minimumHeight: 0.8*parent.height
                                    Layout.minimumWidth: 1
                                    color: "#e3dac9"
                                }

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    TextApp {
                                        //anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: qsTr("Inflow")
                                        width: parent.width
                                        height: parent.height
                                        padding: 5
                                    }//
                                }//
                            }//
                        }//

                        delegate: Rectangle {
                            height: 50
                            width: logListView.width
                            color: "#34495e"

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 1

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 70

                                    TextApp {
                                        //anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: ((logApp.pagesCurrentNumber * logApp.pagesItemPerPage)
                                               - logApp.pagesItemPerPage) + index + 1
                                        width: parent.width
                                        height: parent.height
                                        padding: 5
                                    }
                                }

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    TextApp {
                                        //anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: modelData.date                                        
                                        width: parent.width
                                        height: parent.height
                                        padding: 5
                                    }
                                }

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    TextApp {
                                        //anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: modelData.time
                                        width: parent.width
                                        height: parent.height
                                        padding: 5
                                    }
                                }

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    TextApp {
                                        //anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: modelData.temp
                                        width: parent.width
                                        height: parent.height
                                        padding: 5
                                    }
                                }

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    TextApp {
                                        //anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: modelData.dfa
                                        width: parent.width
                                        height: parent.height
                                        padding: 5
                                    }
                                }

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    TextApp {
                                        //anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: modelData.ifa
                                        width: parent.width
                                        height: parent.height
                                        padding: 5
                                    }
                                }
                            }
                        }//

                        onContentYChanged: {
                            if (scrollDownNotifApp.visible){
                                scrollDownNotifApp.visible = false
                            }
                        }//

                        ScrollDownNotifApp {
                            id: scrollDownNotifApp
                            height: 60
                            width: 60
                            visible: false
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                        }//

                        Loader {
                            active: logListView.count == 0
                            anchors.centerIn: parent
                            sourceComponent: Column {
                                TextApp {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: qsTr("Oops!")
                                    font.pixelSize: 32

                                    MouseArea{
                                        anchors.fill: parent
                                        onClicked: logApp.prev()
                                    }//
                                }//

                                TextApp {
                                    text: qsTr("Seems like there's nothing in this log yet.")

                                    MouseArea{
                                        anchors.fill: parent
                                        onClicked: logApp.prev()
                                    }//
                                }//

                                visible: false
                                Timer {
                                    running: true
                                    interval: 1000
                                    onTriggered: {
                                        parent.visible = true
                                    }//
                                }//
                            }//
                        }//
                    }//

                    ScrollBarApp {
                        id: scrollBarApp
                        Layout.fillWidth: false
                        Layout.minimumWidth: 15
                        Layout.fillHeight: true
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
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                var intent = IntentApp.create(uri, {})
                                finishView(intent)
                            }
                        }//

                        Column {
                            anchors.centerIn: parent
                            TextApp {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("Page") + " " + logApp.pagesCurrentNumber + qsTr(" of ") + logApp.pagesTotal

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        KeyboardOnScreenCaller.openNumpad(inputPageNumberTextInput, qsTr("Page number"));
                                    }
                                }
                            }//

                            TextApp {
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.pixelSize: 14
                                text: " (" + qsTr("Total log is ") + logApp.totalItem + " " + qsTr("items") + ")"
                            }//

                            TextField {
                                id: inputPageNumberTextInput
                                visible: false
                                validator: IntValidator{bottom: 1; top: logApp.pagesTotal}

                                onAccepted: {
                                    const number = Number(text)
                                    text = ""

                                    if(isNaN(number)) return
                                    if(number === 0) return

                                    props.showLoading(1)
                                    logApp.selectDescendingWithPagination(number)
                                }//
                            }//
                        }//

                        ButtonBarApp {
                            width: 194
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/settings-icon-35px.png"
                            text: qsTr("Options")

                            onClicked: {
                                const intent = IntentApp.create("qrc:/UI/Pages/DataLogPage/DataLogSettingPage.qml", {
                                                                    "currentPage": logApp.pagesCurrentNumber,
                                                                    "totalPage": logApp.pagesTotal
                                                                })
                                startView(intent);
                            }//
                        }//
                    }//
                }//
            }//
        }//

        DataLogQmlApp {
            id: logApp

            pagesItemPerPage: 50

            //            delayEmitSignal: 500

            function prev(){
                props.showLoading(1)
                selectDescendingWithPagination(pagesPreviousNumber)
            }

            function next() {
                props.showLoading(1)
                if(logListView.count < pagesItemPerPage) {
                    props.pageKeepScrollPosition = true
                }
                selectDescendingWithPagination(pagesNextNumber)
            }

            onInitializedChanged: {
                //                delayEmitSignal = 100
                //                console.debug("AlarmLogQmlApp: " + initialized)
                next()
            }

            onSelectHasDone: {
                //                //console.debug("onSelectHasDone: " + JSON.stringify(logBuffer[0]))
                //                console.debug(logBuffer.length)
                if(total == 0){
                    logListView.model = logBuffer
                }
                else {
                    const contentYPosition = logListView.contentY
                    //console.debug("contentYPosition: " + contentYPosition)

                    logListView.model = []
                    logListView.model = logBuffer

                    if(props.pageKeepScrollPosition) {
                        if(logBuffer.length >= logListView.count){
                            logListView.contentY = contentYPosition
                        }
                    }

                    if(props.pageKeepScrollPosition) props.pageKeepScrollPosition = false

                    if(!logListView.atYEnd) {
                        scrollDownNotifApp.visible = true
                    }
                }
            }

            Component.onCompleted: {
                props.showLoading(1)
                init();
            }//
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property bool pageKeepScrollPosition: false

            //            property var modelDatalog:[
            //                {"date": "2021-01-19", "time":"00:00", "temp": "25°C", "ifa":"0.53 m/s", "dfa":"0.33 m/s"},
            //                {"date": "2021-01-19", "time":"00:00", "temp": "25°C", "ifa":"0.53 m/s", "dfa":"0.33 m/s"},
            //                {"date": "2021-01-19", "time":"00:00", "temp": "25°C", "ifa":"0.53 m/s", "dfa":"0.33 m/s"},
            //                {"date": "2021-01-19", "time":"00:00", "temp": "25°C", "ifa":"0.53 m/s", "dfa":"0.33 m/s"},
            //                {"date": "2021-01-19", "time":"00:00", "temp": "25°C", "ifa":"0.53 m/s", "dfa":"0.33 m/s"},
            //            ]

            function showLoading(timeout){
                showBusyPage(qsTr("Loading"), function(cycle){
                    //                    //console.debug(cycle + " : " + timeout)
                    if(cycle >= timeout){
                        //                        //console.debug("timeout")
                        MachineAPI.refreshLogRowsCount("datalog")
                        viewApp.closeDialog();
                    }
                })
            }
        }

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
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
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/
