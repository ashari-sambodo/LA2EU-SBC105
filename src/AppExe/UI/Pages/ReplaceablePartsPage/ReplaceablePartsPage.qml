/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Ahmad Qodri
 *  - Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
//import QuickDatalog 1.0
import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ReplaceableCompRecordQmlApp 1.0

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Replaceable Components Record"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp{
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
                    title: qsTr("Replaceable Components Record")
                }
            }

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
                        }//

                        onVerticalOvershootChanged: {
                            let value = Math.abs(verticalOvershoot)
                            ////console.debug(value)
                            if(value > 70){
                                if(!actionFlik){
                                    actionFlik = true
                                }//
                            }//
                        }//

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
                                }//
                            }//
                        }//

                        MouseArea {
                            anchors.fill: parent
                            propagateComposedEvents: false
                            z: 1

                            onReleased: {
                                if (!propagateComposedEvents) {
                                    propagateComposedEvents = true
                                }
                            }
                        }//

                        headerPositioning: ListView.OverlayHeader
                        header: Rectangle {
                            implicitHeight: 50
                            implicitWidth: parent.width
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
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: qsTr("No.")
                                    }
                                }

                                Rectangle{
                                    Layout.minimumHeight: 0.8*parent.height
                                    Layout.minimumWidth: 1
                                    color: "#e3dac9"
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 130

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: qsTr("Date")
                                    }
                                }

                                Rectangle{
                                    Layout.minimumHeight: 0.8*parent.height
                                    Layout.minimumWidth: 1
                                    color: "#e3dac9"
                                }

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 130

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: qsTr("Time (24h)")
                                    }
                                }

                                Rectangle{
                                    Layout.minimumHeight: 0.8*parent.height
                                    Layout.minimumWidth: 1
                                    color: "#e3dac9"
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 130

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: qsTr("Unit Model")
                                    }
                                }

                                Rectangle{
                                    Layout.minimumHeight: 0.8*parent.height
                                    Layout.minimumWidth: 1
                                    color: "#e3dac9"
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        wrapMode: Text.WordWrap
                                        text: qsTr("Electrical Tester")
                                    }//
                                }//

                                Rectangle{
                                    Layout.minimumHeight: 0.8*parent.height
                                    Layout.minimumWidth: 1
                                    color: "#e3dac9"
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 150

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        elide: Text.ElideMiddle
                                        text: qsTr("User")
                                    }//
                                }//
                            }//
                        }//

                        delegate: Rectangle {
                            height: 80
                            width: logListView.width
                            color: "#34495e"
                            opacity: rowLogMA.pressed ? 0.6 : 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 1

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 70

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: ((logApp.pagesCurrentNumber * logApp.pagesItemPerPage)
                                               - logApp.pagesItemPerPage) + index + 1
                                    }//
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.minimumWidth: 1
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 130

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: modelData.date
                                    }//
                                }//

                                Item{
                                    Layout.fillHeight: true
                                    Layout.minimumWidth: 1
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 130

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: modelData.time
                                    }//
                                }//

                                Item{
                                    Layout.fillHeight: true
                                    Layout.minimumWidth: 1
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 130

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: modelData.unitModel
                                    }//
                                }//

                                Item{
                                    Layout.fillHeight: true
                                    Layout.minimumWidth: 1
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    TextApp {
                                        anchors.fill: parent
                                        anchors.margins: 5
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                        text: modelData.electricalTester

                                    }//
                                }//

                                Item{
                                    Layout.fillHeight: true
                                    Layout.minimumWidth: 1
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 150

                                    TextApp {
                                        anchors.fill: parent
                                        anchors.margins: 5
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: modelData.userFullName.length ? modelData.userFullName : modelData.userName
                                    }//
                                }//
                            }//
                            MouseArea{
                                id: rowLogMA
                                anchors.fill: parent
                                propagateComposedEvents : false
                                onClicked: {
                                    if(UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin){
                                        const rowId = ((logApp.pagesCurrentNumber * logApp.pagesItemPerPage)
                                                       - logApp.pagesItemPerPage) + index + 1
                                        MachineAPI.setReplaceablePartsSelected(rowId)
                                        showBusyPage(qsTr("Please wait..."), function(cycle){
                                            //                    //console.debug(cycle + " : " + timeout)
                                            if(cycle >= MachineAPI.BUSY_CYCLE_1){
                                                const intent = IntentApp.create("qrc:/UI/Pages/ReplaceablePartsPage/ReplaceablePartsViewPage.qml",
                                                                                {"modelData": modelData})//
                                                startView(intent);
                                            }
                                        })
                                    }else{
                                        showDialogMessage(qsTr("Access denied"),
                                                          qsTr("You do not have permission to perform this action!"),
                                                          dialogAlert)
                                    }
                                }

                            }//
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
                                    text: qsTr("Seems like there's nothing in this record yet.")

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
                Layout.minimumHeight: 70

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
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }
                        }//

                        //                        Column {
                        //                            anchors.centerIn: parent
                        //                            //                            TextApp {
                        //                            //                                anchors.horizontalCenter: parent.horizontalCenter
                        //                            //                                text: qsTr("Page") + " " + logApp.pagesCurrentNumber + qsTr(" of ") + logApp.pagesTotal

                        //                            //                                MouseArea {
                        //                            //                                    anchors.fill: parent
                        //                            //                                    onClicked: {
                        //                            //                                        KeyboardOnScreenCaller.openNumpad(inputPageNumberTextInput, qsTr("Page number"));
                        //                            //                                    }
                        //                            //                                }
                        //                            //                            }//

                        //                            TextApp {
                        //                                anchors.horizontalCenter: parent.horizontalCenter
                        //                                //.pixelSize: 14
                        //                                text:  qsTr("Total:") + " " + logApp.totalItem + " " + qsTr("items")
                        //                            }//

                        //                            TextField {
                        //                                id: inputPageNumberTextInput
                        //                                visible: false
                        //                                validator: IntValidator{bottom: 1; top: logApp.pagesTotal}

                        //                                onAccepted: {
                        //                                    const number = Number(text)
                        //                                    text = ""

                        //                                    if(isNaN(number)) return
                        //                                    if(number === 0) return

                        //                                    props.showLoading(1)
                        //                                    logApp.selectDescendingWithPagination(number)
                        //                                }//
                        //                            }//
                        //                        }//

                        Row {
                            anchors.right: parent.right
                            spacing: 5

                            ButtonBarApp {
                                width: 194
                                //enabled: UserSessionService.roleLevel >= UserSessionService.roleLevelService
                                anchors.verticalCenter: parent.verticalCenter

                                imageSource: "qrc:/UI/Pictures/add-record.png"
                                text: qsTr("Add Record")

                                onClicked: {
                                    if(UserSessionService.roleLevel >= UserSessionService.roleLevelService){
                                        const intent = IntentApp.create("qrc:/UI/Pages/ReplaceablePartsPage/ReplaceablePartsAddPage.qml",
                                                                        {})//
                                        startView(intent);
                                    }else{
                                        showDialogMessage(qsTr("Access denied"),
                                                          qsTr("You do not have permission to perform this action!"),
                                                          dialogAlert)
                                    }
                                }//
                            }//

                            ButtonBarApp {
                                width: 194
                                anchors.verticalCenter: parent.verticalCenter

                                imageSource: "qrc:/UI/Pictures/settings-icon-35px.png"
                                text: qsTr("Options")

                                onClicked: {
                                    const intent = IntentApp.create("qrc:/UI/Pages/ReplaceablePartsPage/ReplaceablePartsOptions.qml",
                                                                    {
                                                                        "currentPage": Number((logApp.pagesCurrentNumber*logApp.pagesItemPerPage)/50).toFixed(),
                                                                        "totalPage": logApp.totalItem/*pagesTotal*/
                                                                    })//
                                    startView(intent);
                                }//
                            }//
                        }//
                    }//
                }//
            }//
        }//

        ReplaceableCompRecordQmlApp {
            id: logApp

            pagesItemPerPage: 50

            //delayEmitSignal: 500

            function prev(){
                props.showLoading(1)
                selectDescendingWithPagination(pagesPreviousNumber)
            }//

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
            }//

            //            onLogHasExported: {
            //                console.log("onLogHasExported")
            //                console.log(done)
            //            }

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

            function showLoading(timeout){
                showBusyPage(qsTr("Loading"), function(cycle){
                    if(cycle >= timeout){
                        MachineAPI.refreshLogRowsCount("replaceablecomprecord")
                        viewApp.closeDialog();
                    }
                })
            }//

        }//

        //        /// called Once but after onResume
//        Component.onCompleted: {
//        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                logApp.prev()
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/
