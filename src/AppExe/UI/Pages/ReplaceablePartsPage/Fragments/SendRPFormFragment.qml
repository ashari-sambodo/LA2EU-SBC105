import QtQuick 2.0
import QtQuick.Controls 2.7
import QtQuick.Layouts 1.0
import UI.CusCom 1.1
import Qt.labs.settings 1.1
import ModulesCpp.Machine 1.0

Item {
    property bool viewOnly: false

    StackView {
        id: sectionStackView
        anchors.fill: parent
        //        initialItem: printerComponent
        //        initialItem: sendServerDoneComponent

        Component.onCompleted: {
            sectionStackView.replace(connectTargetComp)
            //                        sectionStackView.push(printerComponent)
        }//
    }//

    Component {
        id: connectTargetComp

        Item {
            Column {
                anchors.centerIn: parent
                //        columnSpacing: 10
                spacing: 10
                //        columns: 1

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Server Address")
                    }//

                    TextFieldApp {
                        id: serverIpTextField
                        width: 300
                        height: 40

                        onPressed: {
                            KeyboardOnScreenCaller.openKeyboard(this, qsTr("Server Address"))
                        }//

                        onAccepted: {
                            settingsRp.serverIPv4 = text
                        }//
                    }//
                }//

                ButtonBarApp {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Connect")
                    imageSource: "qrc:/UI/Pictures/upload-icon-35px.png"

                    onClicked: {
                        //                        sectionStackView.replace(printeToServerComponent); return
                        viewApp.showBusyPage(qsTr("Connecting..."), function onCallback(cycle){
                            if (cycle >= MachineAPI.BUSY_CYCLE_10){
                                /// time out after 3o second
                                viewApp.closeDialog()
                            }
                        })

                        let xhttpPrinter = new XMLHttpRequest()
                        const url2 = "http://" + settingsRp.serverIPv4 + "/printer/"
                        //console.log("XMLHttpRequest-url:" + url2)
                        xhttpPrinter.open("GET", url2, true);
                        //                                    xhttpPrinter.setRequestHeader('Content-Type', 'application/json');

                        xhttpPrinter.onreadystatechange = function(){
                            if(xhttpPrinter.readyState === XMLHttpRequest.DONE) {
                                const xstatus = xhttpPrinter.status
                                //console.log("XMLHttpRequest:" + xstatus)
                                //console.log(xstatus)
                                if(xstatus === 200) {
                                    viewApp.closeDialog()

                                    const reponseText = xhttpPrinter.responseText
                                    //console.log(reponseText)

                                    let model = JSON.parse(reponseText)
                                    model.unshift({"id":0, "name": "Tap here to select"});
                                    props.printerDevices = model

                                    sectionStackView.replace(printeToServerComponent)
                                }
                                else {
                                    //console.log(3)
                                    props.showDialogFailComServer()
                                }
                            }
                        }
                        xhttpPrinter.send()
                    }//
                }//
            }//

            Settings {
                id: settingsRp
                category: "rplist"

                property string serverIPv4: "127.0.0.1:8000"

                Component.onCompleted: {
                    serverIpTextField.text = serverIPv4
                }//
            }//
        }//
    }//

    Component {
        id: printeToServerComponent

        Item {
            id: printeToServerItem

            Column {
                anchors.centerIn: parent
                //        columnSpacing: 10
                spacing: 10
                //        columns: 1

                Column {
                    spacing: 5

                    /// NOT IMPLEMENTED, IT WILL RESPONSIBE BY SERVER
                    //                    Column {
                    //                        spacing: 5

                    //                        TextApp {
                    //                            text: qsTr("Test Report Template")
                    //                        }//

                    //                        ComboBoxApp {
                    //                            id: templateTestReportCombox
                    //                            width: 300
                    //                            font.pixelSize: 20

                    //                            textRole: 'name'
                    //                            model: props.testReportTemplates

                    //                            //                            model: [
                    //                            //                                {'id': 1, 'name': "LA2-4 (NSF)"},
                    //                            //                                {'id': 1, 'name': "LA2-4 (EN)"},
                    //                            //                            ]
                    //                        }//
                    //                    }//

                    Column {
                        spacing: 5

                        TextApp {
                            text: qsTr("Printer for Replaceable Components")
                        }//

                        ComboBoxApp {
                            id: printerForTestRepCompCombox
                            width: 300
                            font.pixelSize: 20

                            textRole: 'name'
                            model: props.printerDevices
                            //                            model: [
                            //                                {'id': 1, 'name': "PDF file (saved on server)"},
                            //                                {'id': 1, 'name': "Test Room - Cassete 1"},
                            //                                {'id': 1, 'name': "Test Room - Cassete 2"}
                            //                            ]
                        }//
                    }//

                    //                    Column {
                    //                        spacing: 5

                    //                        TextApp {
                    //                            text: qsTr("Printer for Certificate")
                    //                        }//

                    //                        ComboBoxApp {
                    //                            id: printerForCertCombox
                    //                            width: 300
                    //                            font.pixelSize: 20

                    //                            textRole: 'name'
                    //                            model: props.printerDevices

                    //                            //                            model: [
                    //                            //                                {'id': 1, 'name': "PDF file (saved on server)"},
                    //                            //                                {'id': 1, 'name': "Test Room - Cassete 1"},
                    //                            //                                {'id': 1, 'name': "Test Room - Cassete 2"}
                    //                            //                            ]
                    //                        }//
                    //                    }//
                }//

                ButtonBarApp {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Send")
                    imageSource: "qrc:/UI/Pictures/upload-icon-35px.png"

                    onClicked: {
                        //                        console.log(JSON.stringify(printeToServerItem.generatePayload("", "")))
                        if(/*!templateTestReportCombox.currentIndex ||*/ !printerForTestRepCompCombox.currentIndex/* || !printerForCertCombox.currentIndex*/) {
                            viewApp.showDialogMessage(qsTr("Attention!"),
                                                      qsTr("Please select the valid option for all the forms!"),
                                                      viewApp.dialogAlert)
                            return
                        }

                        viewApp.showBusyPage(qsTr("Sending..."), function onCallback(cycle){
                            if (cycle >= MachineAPI.BUSY_CYCLE_10){
                                /// time out after 3o second
                                viewApp.closeDialog()
                            }
                        })

                        //                        const template          = templateTestReportCombox.currentText
                        const printerForRepComp  = printerForTestRepCompCombox.currentText
                        //const printerForCert    = printerForCertCombox.currentText

                        const varString =   printeToServerItem.generatePayload(printerForRepComp)
                        console.log("var string " + varString)

                        let xhttpPrint = new XMLHttpRequest()
                        const url = "http://" + settingsRp.serverIPv4 + "/store-and-print/"
                        //console.log("XMLHttpRequest-url:" + url)
                        xhttpPrint.open("POST", url, true);
                        xhttpPrint.setRequestHeader('Content-Type', 'application/json');

                        xhttpPrint.onreadystatechange = function(){
                            if(xhttpPrint.readyState === XMLHttpRequest.DONE) {
                                const xstatus = xhttpPrint.status
                                //                                console.log("XMLHttpRequest:" + xstatus)
                                if(xstatus === 200 || xstatus === 201) {
                                    viewApp.closeDialog()

                                    const reponseText = xhttpPrint.responseText
                                    //                                    console.log(reponseText)

                                    viewApp.closeDialog()
                                    sectionStackView.replace(sendServerDoneComponent)
                                }
                                else {
                                    //console.log(5)
                                    //                                    console.log(xhttpPrint.responseText)
                                    //                                    props.showDialogFailComServer()
                                    viewApp.closeDialog()
                                    serverResponseMessageTextArea.text = qsTr("Failed! Because") + " " + xhttpPrint.responseText
                                    serverResponseMessageItem.visible = true
                                }//
                            }//
                        }//
                        xhttpPrint.send(JSON.stringify(varString))
                    }//
                }//
            }//

            Settings {
                id: settingsRp
                category: "rplist"

                property string serverIPv4:     "192.168.0.18:8000"
            }//

            function generatePayload(pfrc/*, pfcr*/){
                const dataRpForm = MachineData.rpListLast

                const dataRpFormStringify = JSON.stringify(dataRpForm)

                const dataPayload = {
                    "pfrc": pfrc,
                    "details": dataRpFormStringify
                }//

                return dataPayload
                ////console.log()
            }//

            Item {
                id: serverResponseMessageItem
                anchors.fill: parent
                visible: false

                Rectangle {
                    anchors.fill: parent
                    color: "#DC143C"
                    radius: 5
                }//

                ColumnLayout {
                    anchors.fill: parent

                    Rectangle {
                        Layout.minimumHeight: 30
                        Layout.fillWidth: true
                        color: "#0F2952"

                        TextApp {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("Server Response")
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        ScrollView {
                            id: view
                            anchors.fill: parent

                            TextArea {
                                id: serverResponseMessageTextArea
                                //                                    text: "TextArea\n...\n...\n...\n...\n...\n...\n"
                                font.pixelSize: 20
                                color: "#e3dac9"
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            }//
                        }//
                    }//

                    Rectangle {
                        Layout.minimumHeight: 50
                        Layout.fillWidth: true
                        color: "#0F2952"
                        opacity: serverInfoMouseArea.pressed ? 0.5 : 1

                        TextApp {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("Close")
                        }//

                        MouseArea {
                            id: serverInfoMouseArea
                            anchors.fill: parent
                            onClicked: {
                                sectionStackView.replace(connectTargetComp)
                            }//
                        }//
                    }//
                }//
            }//
        }//
    }//

    Component {
        id: sendServerDoneComponent

        Item {
            id: sendServerDoneItem

            Column {
                anchors.centerIn: parent
                spacing: 10

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "qrc:/UI/Pictures/flat-ui_printer.png"

                    Rectangle {
                        height: 10
                        width: 100
                        radius: 5
                        color: "#27ae60"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: parent.height * 0.375

                        Timer {
                            id: blinkAnimTimer
                            running: true;
                            interval: 2000
                            onTriggered: {
                                stop()
                                parent.opacity = !parent.opacity
                                interval = parent.opacity ? 2000 : 200
                                start()
                            }//
                        }//
                    }//
                }//

                Column {
                    TextApp {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Replaceable Components form data has been sent to server!")
                    }//

                    TextApp {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("It will take a moment before the document actually printed.") + "<br>" +
                              qsTr("Please check on the printer's queue if necessary.")
                    }//
                }//

                TextApp {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.underline: true
                    text: qsTr("Got problem? Send again.")

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            sectionStackView.replace(connectTargetComp, StackView.PopTransition)
                        }//
                    }//
                }//
            }//
        }//
    }//

    UtilsApp{
        id: utils
    }

    QtObject {
        id: props

        property var printerDevices: [{}]
        property var testReportTemplates: [{}]

        function showDialogFailComServer(){
            viewApp.showDialogMessage(qsTr("Attention!"),
                                      qsTr("Failed to communicate with server!"), viewApp.dialogAlert)
        }//
    }//

    Component.onCompleted: {
        //console.debug(JSON.stringify(MachineData.rpListLast))
    }
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:640}
}
##^##*/

/*
import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import UI.CusCom 1.1

Item {
    StackView {
        id: sectionStackView
        anchors.fill: parent

        Component.onCompleted: {
            //            sectionStackView.push(addressTargetComp)
            sectionStackView.push(printerComponent)
        }//
    }//

    Component {
        id: addressTargetComp
        Item {
            Column {
                anchors.centerIn: parent
                //        columnSpacing: 10
                spacing: 10
                //        columns: 1

                Column {
                    spacing: 5
                    TextApp {
                        text: "Server IPv4"
                    }//

                    TextFieldApp {
                        width: 300
                        height: 40

                        onPressed: {
                            KeyboardOnScreenCaller.openKeyboard(this,"Full Name")
                        }//
                    }//
                }//

                ButtonBarApp {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Send")
                    imageSource: "qrc:/UI/Pictures/upload-icon-35px.png"

                    onClicked: {
                        sectionStackView.push(printerComponent)
                    }//
                }//
            }//
        }//
    }//

    Component {
        id: printerComponent
        Item {
            Column {
                anchors.centerIn: parent
                //        columnSpacing: 10
                spacing: 10
                //        columns: 1

                Row {
                    spacing: 5

                    Column {
                        spacing: 5

                        TextApp {
                            text: "Test Report to"
                        }//

                        Rectangle {
                            height: 100
                            width: 300
                            radius: 5
                            color: "transparent"
                            border.width: 2
                            border.color: "#e3dac9"

                            ListView {
                                id: reportToFirstListview
                                anchors.fill: parent
                                anchors.margins: 5
                                clip: true
                                spacing: 2

                                model: [
                                    {'id': 1, 'name': "PDF file (saved on server)"},
                                    {'id': 1, 'name': "Test Room - Cassete 1"},
                                    {'id': 1, 'name': "Test Room - Cassete 2"}
                                ]

                                delegate: Rectangle {
                                    height: 40
                                    width: parent.width
                                    color: "#0F2952"

                                    RowLayout{
                                        anchors.fill: parent
                                        anchors.margins: 5

                                        Text {
                                            text: modelData['name']
                                            verticalAlignment: Text.AlignVCenter
                                            anchors.margins: 5
                                            font.pixelSize: 20
                                            color: "#e3dac9"
                                            elide: Text.ElideMiddle

                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                        }//

                                        Rectangle {
                                            visible: reportToFirstListview.currentIndex == index
                                            radius: 10
                                            Layout.minimumHeight: 20
                                            Layout.minimumWidth: 20

                                            color: "#27ae60"
                                        }//
                                    }//

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            reportToFirstListview.currentIndex = index
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//

                    Column {
                        spacing: 5

                        TextApp {
                            text: "Cert Report to"
                        }//

                        Rectangle {
                            height: 100
                            width: 300
                            radius: 5
                            color: "transparent"
                            border.width: 2
                            border.color: "#e3dac9"

                            ListView {
                                id: reportToSecondListview
                                anchors.fill: parent
                                anchors.margins: 5
                                clip: true
                                spacing: 2

                                model: [
                                    {'id': 1, 'name': "PDF file (saved on server)"},
                                    {'id': 1, 'name': "Test Room - Cassete 1"},
                                    {'id': 1, 'name': "Test Room - Cassete 2"}
                                ]

                                delegate: Rectangle {
                                    height: 40
                                    width: parent.width
                                    color: "#0F2952"

                                    RowLayout{
                                        anchors.fill: parent
                                        anchors.margins: 5

                                        Text {
                                            text: modelData['name']
                                            verticalAlignment: Text.AlignVCenter
                                            anchors.margins: 5
                                            font.pixelSize: 20
                                            color: "#e3dac9"
                                            elide: Text.ElideMiddle

                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                        }//

                                        Rectangle {
                                            visible: reportToSecondListview.currentIndex == index
                                            radius: 10
                                            Layout.minimumHeight: 20
                                            Layout.minimumWidth: 20

                                            color: "#27ae60"
                                        }//
                                    }//

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            reportToSecondListview.currentIndex = index
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//
                }//

                ButtonBarApp {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Send")
                    imageSource: "qrc:/UI/Pictures/upload-icon-35px.png"

                    onClicked: {
                        ///called funtion on the root viewApp
                        showBusyPage(qsTr("Send to server..."), function(cycle){})
                    }//
                }//
            }//
        }//
    }//
}//
*/
