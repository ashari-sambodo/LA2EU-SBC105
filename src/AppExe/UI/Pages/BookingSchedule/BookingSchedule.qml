import QtQuick 2.9
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import BookingScheduleQmlApp 1.0

ViewApp {
    id: viewApp
    title: "Booking Schedule"

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
                    title: qsTr("Booking Schedule")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    anchors.fill: parent

                    Item {
                        Layout.minimumHeight: 30
                        Layout.fillWidth: true

                        Rectangle {
                            anchors.fill: parent
                            color: "#0F2952"
                            radius: 5
                            border.color: "#E3DAC9"
                            border.width: 1

                            Row {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 10

                                TextApp {
                                    text: qsTr("Date") + ":"
                                }//

                                TextApp {
                                    text: ""

                                    Component.onCompleted: {
                                        text = Qt.binding(function(){ return Qt.formatDate(new Date(props.targetDate), "dd MMM yyyy") })
                                    }
                                }//
                            }//

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    viewApp.finishViewReturned.connect(props.onReturnFromCalendarPage);
                                    const intent = IntentApp.create("qrc:/UI/Pages/CalendarPage/CalendarPage.qml",
                                                                    {
                                                                        "selectDateAndReturn": true
                                                                    })
                                    startView(intent)
                                }
                            }
                        }//
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        ColumnLayout{
                            anchors.fill: parent
                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                ListView {
                                    id: bookingListView
                                    anchors.fill: parent
                                    clip: true
                                    //                            model: 24

                                    //                            model: [
                                    //                                {time: '00:00', },
                                    //                                {time: '01:00', slot: [
                                    //                                        {username: 'Lono'},
                                    //                                        {username: 'Sandraku'},
                                    //                                    ]},
                                    //                            ]

                                    spacing: 3
                                    orientation: ListView.Horizontal
                                    flickableDirection: Flickable.HorizontalFlick
                                    ScrollBar.horizontal: horizontalScrollBar

                                    delegate: Item {
                                        width: 200
                                        height: bookingListView.height

                                        ColumnLayout {
                                            anchors.fill: parent
                                            spacing: 3

                                            Item {
                                                Layout.minimumHeight: 60
                                                Layout.fillWidth: true

                                                Rectangle {
                                                    anchors.fill: parent
                                                    color: "#0F2952"
                                                    radius: 5
                                                    border.color: "#E3DAC9"
                                                    border.width: 1

                                                    TextApp {
                                                        anchors.centerIn: parent
                                                        text: modelData.time
                                                    }//
                                                }//
                                            }//

                                            Item {
                                                Layout.fillHeight: true
                                                Layout.fillWidth: true

                                                Rectangle {
                                                    anchors.fill: parent
                                                    color: "#2c3e50"
                                                    radius: 5
                                                    border.color: "#E3DAC9"
                                                    border.width: 1

                                                    Loader {
                                                        anchors.fill: parent
                                                        anchors.margins: 1
                                                        sourceComponent: modelData.bookTitle.length ? bookedSlotComp : availableSlotComp
                                                    }//

                                                    Component {
                                                        id: availableSlotComp
                                                        Item {
                                                            Rectangle {
                                                                anchors.centerIn: parent
                                                                height: 50
                                                                width: parent.width - 10
                                                                color: "#34495e"
                                                                radius: 5

                                                                TextApp {
                                                                    anchors.centerIn: parent
                                                                    text: qsTr("Book Now")
                                                                }//
                                                            }//

                                                            MouseArea {
                                                                anchors.fill: parent
                                                                onClicked: {
                                                                    props.bookingAdd(modelData.time)
                                                                }//
                                                            }//
                                                        }//
                                                    }//

                                                    Component {
                                                        id: bookedSlotComp

                                                        ColumnLayout{
                                                            Rectangle {
                                                                Layout.minimumHeight: 50
                                                                Layout.fillWidth: true

                                                                color: "#34495e"
                                                                radius: 5

                                                                TextApp {
                                                                    id: bookingTitleText
                                                                    anchors.fill: parent
                                                                    horizontalAlignment: Text.AlignHCenter
                                                                    verticalAlignment: Text.AlignVCenter
                                                                    text: modelData.bookTitle
                                                                }//
                                                            }//

                                                            Item {
                                                                Layout.minimumHeight: 30
                                                                Layout.fillWidth: true

                                                                TextApp {
                                                                    id: bookingUserText
                                                                    anchors.fill: parent
                                                                    horizontalAlignment: Text.AlignHCenter
                                                                    verticalAlignment: Text.AlignVCenter
                                                                    text: modelData.bookBy
                                                                }//

                                                                Rectangle {
                                                                    height: 1
                                                                    width: parent.width - 10
                                                                    color: "#34495e"
                                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                                    anchors.bottom: parent.bottom
                                                                }//
                                                            }//

                                                            Item {
                                                                Layout.fillHeight: true
                                                                Layout.fillWidth: true

                                                                //                                                    Rectangle {anchors.fill: parent; color: "#2c3e50"}
                                                                //                                                    visible: false

                                                                Column {
                                                                    width: parent.width - 10
                                                                    anchors.horizontalCenter: parent.horizontalCenter

                                                                    TextApp {
                                                                        id: note1Text
                                                                        width: parent.width
                                                                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                                                        text: modelData.note1
                                                                        font.pixelSize: 18
                                                                        color: "gray"
                                                                    }//

                                                                    Rectangle {
                                                                        height: 1
                                                                        width: parent.width - 10
                                                                        color: "#34495e"
                                                                        anchors.horizontalCenter: parent.horizontalCenter
                                                                    }//

                                                                    TextApp {
                                                                        id: note2Text
                                                                        width: parent.width
                                                                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                                                        text: modelData.note2
                                                                        font.pixelSize: 18
                                                                        color: "gray"
                                                                    }//

                                                                    Rectangle {
                                                                        height: 1
                                                                        width: parent.width - 10
                                                                        color: "#34495e"
                                                                        anchors.horizontalCenter: parent.horizontalCenter
                                                                    }//

                                                                    TextApp {
                                                                        id: note3Text
                                                                        width: parent.width
                                                                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                                                        text: modelData.note3
                                                                        font.pixelSize: 18
                                                                        color: "gray"
                                                                    }//

                                                                    Rectangle {
                                                                        height: 1
                                                                        width: parent.width - 10
                                                                        color: "#34495e"
                                                                        anchors.horizontalCenter: parent.horizontalCenter
                                                                    }//
                                                                }//
                                                            }//

                                                            Rectangle {
                                                                Layout.minimumHeight: 40
                                                                Layout.fillWidth: true

                                                                color: "#34495e"
                                                                radius: 5

                                                                TextApp {
                                                                    anchors.fill: parent
                                                                    horizontalAlignment: Text.AlignHCenter
                                                                    verticalAlignment: Text.AlignVCenter
                                                                    text: qsTr("Cancel")
                                                                    color: "gray"
                                                                }//

                                                                MouseArea {
                                                                    anchors.fill: parent
                                                                    onClicked: {
                                                                        props.bookingCancel(modelData.time)
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
                            }//
                            Rectangle{
                                id: horizontalScrollRectangle
                                Layout.minimumHeight: 10
                                Layout.fillWidth: true
                                color: "transparent"
                                border.color: "#dddddd"
                                radius: 5
                                visible: bookingListView.contentWidth > width

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
                    radius: 5

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
                            }//
                        }//

                        ButtonBarApp {
                            width: 194
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/settings-icon-35px.png"
                            text: qsTr("Options")

                            onClicked: {
                                //                                bookingScheduleQmlApp.exportLogs(props.targetDate, "", "", "")
                                viewApp.finishViewReturned.connect(props.onReturnFromBookingOptionPage);
                                const intent = IntentApp.create("qrc:/UI/Pages/BookingSchedule/BookingOptionsPage.qml", {
                                                                    "exportTargetDate": props.targetDate,
                                                                })
                                startView(intent);
                            }//
                        }//
                    }//
                }//
            }//
        }//

        BookingScheduleQmlApp {
            id: bookingScheduleQmlApp

            delayEmitSignal: 1000

            onInitializedChanged: {
                if (bookingScheduleQmlApp.isRowsHasMaximum()) {
                    const message = qsTr("Booking storage has full. Please delete some booking history!")
                    showDialogMessage(qsTr(title), message, dialogAlert, function onClosed(){
                        showBusyPage(qsTr("Loading"), function(){})
                        selectByDate(props.targetDate)
                    })
                    return
                }
                showBusyPage(qsTr("Loading"), function(){})
                selectByDate(props.targetDate)
            }//

            onSelectHasDone: {
                const keepContentX = bookingListView.contentX
                bookingListView.model = logBuffer
                bookingListView.contentX = keepContentX

                viewApp.closeDialog()
            }//

            onDeleteHasDone: {
                showBusyPage(qsTr("Loading"), function(){})
                selectByDate(props.targetDate)
            }//
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property string targetDate: ""

            property string bufferBoTitle:  ""
            property string bufferBoName:   ""
            property string bufferBoNote1:  ""
            property string bufferBoNote2:  ""
            property string bufferBoNote3:  ""

            function bookingAdd(time){
                /// don't conitnue to book if the booking row capacity reach to 365 * 17
                if (bookingScheduleQmlApp.isRowsHasMaximum()) {
                    const message = qsTr("Booking storage has full. Please delete some booking history!")
                    showDialogMessage(qsTr(title), message, dialogAlert)
                    return
                }
                viewApp.finishViewReturned.connect(props.onReturnFromBookingAddPage);
                const intent = IntentApp.create("qrc:/UI/Pages/BookingSchedule/BookingAddPage.qml",
                                                {
                                                    "date": targetDate,
                                                    "time": time,
                                                    "boTitle": bufferBoTitle,
                                                    "name": bufferBoName,
                                                    "note1": bufferBoNote1,
                                                    "note2": bufferBoNote2,
                                                    "note3": bufferBoNote3
                                                })
                startView(intent);
            }//

            function bookingCancel(time) {
                showDialogAsk("Booking Schedule", qsTr("Are you sure to cencel?"), dialogAlert, function onAccepted(){
                    showBusyPage(qsTr("Loading"), function(){})
                    bookingScheduleQmlApp.deleteByDateTime(targetDate, time)
                })
            }

            function onReturnFromCalendarPage(returnIntent){
                viewApp.finishViewReturned.disconnect(props.onReturnFromCalendarPage)

                const extraData = IntentApp.getExtraData(returnIntent)
                const calendar = extraData['calendar'] || false
                if (calendar) {
                    showBusyPage(qsTr("Loading"), function(){})
                    props.targetDate = calendar['date']
                    bookingScheduleQmlApp.selectByDate(props.targetDate)
                }
            }//

            function onReturnFromBookingAddPage(returnIntent){
                viewApp.finishViewReturned.disconnect(props.onReturnFromBookingAddPage)

                const extraData = IntentApp.getExtraData(returnIntent)
                const bookingAdd = extraData['bookingAdd'] || false
                if (bookingAdd) {
                    props.bufferBoTitle = bookingAdd['bookTitle']
                    props.bufferBoName  = bookingAdd['bookBy']
                    props.bufferBoNote1 = bookingAdd['note1']
                    props.bufferBoNote2 = bookingAdd['note2']
                    props.bufferBoNote3 = bookingAdd['note3']

                    showBusyPage(qsTr("Loading"), function(){})
                    bookingScheduleQmlApp.selectByDate(props.targetDate)
                }
            }//

            function onReturnFromBookingOptionPage(returnIntent){
                viewApp.finishViewReturned.disconnect(props.onReturnFromBookingOptionPage)

                showBusyPage(qsTr("Loading"), function(){})
                bookingScheduleQmlApp.selectByDate(props.targetDate)
            }//
        }//

        /// OnCreated
        Component.onCompleted: {
            const today = Qt.formatDate(new Date, "yyyy-MM-dd")
            props.targetDate = today

            showBusyPage(qsTr("Loading"), function(){})
            bookingScheduleQmlApp.init("uiBookingSchedule");
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible:  QtObject {
            /// onResume
            Component.onCompleted: {
                //console.debug("StackView.Active");
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
