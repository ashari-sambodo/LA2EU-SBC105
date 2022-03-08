import QtQuick 2.9
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import BookingScheduleQmlApp 1.0

ViewApp {
    id: viewApp
    title: "Booking Schedule - Add"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp{
        id: contentView
        height: viewApp.height
        width: viewApp.width

//        visible: true

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
                    title: qsTr("Booking Schedule - Add")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column {
                    id: mainColumn
                    anchors.centerIn: parent
                    width: 300
                    spacing: 6

                    Row {
                        width: mainColumn.width
                        spacing: 10

                        Column {
                            TextApp {
                                text: "Time: " +  props.bookingTime + " " + props.bookingDate
                            }//

                            Rectangle {
                                id: rectangleDate
                                width: parent.width
                                height: 1
                                radius: 5
                                color: "#0F2952"
                                border.color: "#E3DAC9"
                                border.width: 2
                            }//
                        }//
                    }//

                    Column {

                        Row{
                            spacing: 3

                            TextApp {
                                text: qsTr("Booking Title")
                                font.pixelSize: 14
                            }//
                        }//

                        TextFieldApp {
                            id: bookingTitleTextField
                            placeholderText: qsTr("Booking Title")
                            width: 300
                            height: 40
                            maximumLength: 30

                            onPressed: {
                                KeyboardOnScreenCaller.openKeyboard(bookingTitleTextField,qsTr("Booking Title"))
                            }//
                        }//
                    }//

                    Column {

                        Row{
                            spacing: 3

                            TextApp {
                                text: qsTr("Name")
                                font.pixelSize: 14
                            }//
                        }//

                        TextFieldApp {
                            id: nameTextField
                            placeholderText: qsTr("Your name")
                            width: 300
                            height: 40
                            maximumLength: 30

                            onPressed: {
                                KeyboardOnScreenCaller.openKeyboard(nameTextField,qsTr("Name"))
                            }//
                        }//

                    }//

                    Column {
                        spacing: 2

                        TextApp {
                            text: qsTr("Note")
                            font.pixelSize: 14
                        }//

                        TextFieldApp {
                            id: note1TextField
                            placeholderText: qsTr("Note-1")
                            width: 300
                            height: 40
                            maximumLength: 30

                            onPressed: {
                                KeyboardOnScreenCaller.openKeyboard(this,qsTr("Note-1"))
                            }
                        }//

                        TextFieldApp {
                            id: note2TextField
                            placeholderText: qsTr("Note-2")
                            width: 300
                            height: 40
                            maximumLength: 30

                            onPressed: {
                                KeyboardOnScreenCaller.openKeyboard(this,qsTr("Note-2"))
                            }
                        }//

                        TextFieldApp {
                            id: note3TextField
                            placeholderText: qsTr("Note-3")
                            width: 300
                            height: 40
                            maximumLength: 30

                            onPressed: {
                                KeyboardOnScreenCaller.openKeyboard(this,qsTr("Note-3"))
                            }//
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
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }
                        }//

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Save")

                            onClicked: {
                                bookingScheduleQmlAppLoader.active = true
                            }//
                        }//
                    }//
                }//
            }//
        }//

        /// insert new booking slot
        Loader {
            id: bookingScheduleQmlAppLoader
            active: false
            sourceComponent: BookingScheduleQmlApp {
                id: bookingScheduleQmlApp

                Component.onCompleted: {
                    const connectionUniqName = "BookingAddPageDB"
                    init(connectionUniqName)
                }//

                onInitializedChanged: {
                    const createdAt = Qt.formatDateTime(new Date, "yyyy-MM-dd HH:mm:ss")

                    const bookingData = {
                        "date": props.bookingDate,
                        "time": props.bookingTime,
                        "bookTitle": bookingTitleTextField.text,
                        "bookBy": nameTextField.text,
                        "note1": note1TextField.text,
                        "note2": note2TextField.text,
                        "note3": note3TextField.text,
                        "createdAt": createdAt,
                    }

                    insert(bookingData)
                }//

                onInsertedHasDone: {
                    console.log("Booking data has inserted!")
                    showBusyPage(qsTr("Loading"), function(cycle){
                        if (cycle >= MachineAPI.BUSY_CYCLE_1) {
                            const intent = IntentApp.create(uri,
                                                            {
                                                                "bookingAdd": {
                                                                    "bookTitle" : bookingTitleTextField.text,
                                                                    "bookBy"    : nameTextField.text,
                                                                    "note1"     : note1TextField.text,
                                                                    "note2"     : note2TextField.text,
                                                                    "note3"     : note3TextField.text,
                                                                }
                                                            })
                            finishView(intent)
                        }
                    })
                }//
            }//
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        //        QtObject {
        //            id: props
        //        }

        QtObject {
            id: props
            property string bookingDate:  ""
            property string bookingTime:  ""
        }//

        /// OnCreated
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible:  QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

                const extradata = IntentApp.getExtraData(intent)

                const date    = extradata['date']     || ""
                const time    = extradata['time']     || ""
                const boTitle = extradata['boTitle']  || ""
                const name    = extradata['name']     || ""
                const note1   = extradata['note1']    || ""
                const note2   = extradata['note2']    || ""
                const note3   = extradata['note3']    || ""

                props.bookingDate = date
                props.bookingTime = time

                bookingTitleTextField.text  = boTitle
                nameTextField.text          = name
                note1TextField.text         = note1
                note2TextField.text         = note2
                note3TextField.text         = note3
            }//

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
