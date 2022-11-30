import QtQuick 2.9
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import BookingScheduleQmlApp 1.0
import ModulesCpp.Machine 1.0

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
                        spacing: 15

                        Column {
                            spacing: 2
                            TextApp {
                                height: 30
                                text: "Date" //+ ":" +  props.bookingTime + " " + props.bookingDate
                                verticalAlignment: Text.AlignVCenter
                            }//
                            TextApp {
                                height: 30
                                text: "Start Time" //+ ":" +  props.bookingTime + " " + props.bookingDate
                                verticalAlignment: Text.AlignVCenter
                            }//
                            TextApp {
                                height: 30
                                text: "End Time" //+ ":" +  props.bookingTime + " " + props.bookingDate
                                verticalAlignment: Text.AlignVCenter
                            }//
                        }//
                        Column {
                            spacing: 2
                            Rectangle {
                                color: "#80000000"
                                TextApp {
                                    text: props.bookingDate
                                    height: parent.height
                                    verticalAlignment: Text.AlignVCenter
                                    padding: 2
                                }
                                width: childrenRect.width
                                height: 30
                                radius: 2
                            }
                            Rectangle {
                                color: "#80000000"
                                TextApp {
                                    text: props.bookingTime
                                    height: parent.height
                                    verticalAlignment: Text.AlignVCenter
                                    padding: 2
                                }
                                width: childrenRect.width
                                height: 30
                                radius: 2
                            }
                            ComboBoxApp{
                                id: comboBoxApp
                                width: 90
                                height: 30
                                font.pixelSize: 20
                                popupHeight: 100
                                textRole: "text"
                                backgroundRadius: 2

                                onActivated: {
                                    props.totalHours = model[index].totalHours
                                    console.debug(model[index].text, model[index].totalHours)
                                }//
                            }//
                        }//
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

                    Column {

                        Row{
                            spacing: 3

                            TextApp {
                                text: qsTr("Booking Title")
                                font.pixelSize: 14
                            }//
                            TextApp {
                                text: qsTr(" *")
                                font.pixelSize: 14
                            }//
                        }//

                        TextFieldApp {
                            id: bookingTitleTextField
                            placeholderText: qsTr("Booking Title")
                            width: 300
                            height: 40
                            maximumLength: 30

                            onAccepted: {
                                props.checkDataValidity()
                            }
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
                            TextApp {
                                text: qsTr(" *")
                                font.pixelSize: 14
                            }//
                        }//

                        TextFieldApp {
                            id: nameTextField
                            placeholderText: qsTr("Your name")
                            width: 300
                            height: 40
                            maximumLength: 30
                            onAccepted: {
                                props.checkDataValidity()
                            }
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
                            maximumLength: 55

                            onPressed: {
                                KeyboardOnScreenCaller.openKeyboard(this,qsTr("Note-1"))
                            }
                        }//

                        TextFieldApp {
                            id: note2TextField
                            placeholderText: qsTr("Note-2")
                            width: 300
                            height: 40
                            maximumLength: 55

                            onPressed: {
                                KeyboardOnScreenCaller.openKeyboard(this,qsTr("Note-2"))
                            }
                        }//

                        TextFieldApp {
                            id: note3TextField
                            placeholderText: qsTr("Note-3")
                            width: 300
                            height: 40
                            maximumLength: 55

                            onPressed: {
                                KeyboardOnScreenCaller.openKeyboard(this,qsTr("Note-3"))
                            }//
                        }//
                    }//
                    TextApp {
                        text: "* " + qsTr("Required field")
                        font.pixelSize: 14
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
                            visible: props.dataValid

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
                    let bookingDataList = []

                    for(let i=0; i<props.totalHours; i++){
                        console.debug(i, props.model[i].text)
                        if(i>0)
                            props.bookingTime = props.model[i-1].text
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
                        console.debug(bookingData)
                        bookingDataList.push(bookingData)
                    }//

                    insertFromList(bookingDataList)
                }//

                onInsertedHasDone: {
                    console.log("Booking data has inserted!", success)

                    const bookTitle = bookingTitleTextField.text
                    const bookTime = props.bookingTime + " " + props.bookingDate
                    let strEvent = qsTr("User: Add booking schedule '%1' at '%2'").arg(bookTitle).arg(bookTime)
                    MachineAPI.insertEventLog(strEvent)

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
                }//
            }//
        }//

        UtilsApp{
            id: utilsApp
        }
        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        //        QtObject {
        //            id: props
        //        }

        QtObject {
            id: props
            property string bookingDate:  ""
            property string bookingTime:  ""
            property int totalHours: 1
            property var model: []

            property bool dataValid: false

            function checkDataValidity(){
                dataValid = (bookingTitleTextField.text !== ""
                             && nameTextField.text !== "")
            }//

            function generateModelEndTime(startTime){
                let maxHours = 23 - Number(startTime)
                let endTime = Number(startTime) + maxHours
                let model = []
                for(let i=1; i<=maxHours; i++){
                    const value = Number(startTime)+i
                    const totHours = i
                    const subModel = {text: utilsApp.fixStrLength(String(value), 2, "0", 1) + ":00", value: value, totalHours: totHours}
                    //console.debug(JSON.stringify(subModel))
                    model.push(subModel)
                }
                props.model = model
                comboBoxApp.model = model
                for(let j=0; j<model.length; j++){
                    console.debug(props.model[j].text)
                }
            }//
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
                props.generateModelEndTime(String(time).split(":")[0])//Pass only the hour

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
