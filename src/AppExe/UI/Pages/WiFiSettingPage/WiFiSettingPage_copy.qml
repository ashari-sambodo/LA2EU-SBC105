import QtQuick 2.7
import QtQuick.Layouts 1.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Connectify 1.0

ViewApp {
//    id: viewApp
//    title: "WiFi"

//    background.sourceComponent: Rectangle{
//        color: "black"
//    }

//    content.asynchronous: true
//    content.sourceComponent: Item{
//        id: contentView
//        height: viewApp.height
//        width: viewApp.width

//        ColumnLayout {
//            anchors.fill: parent
//            anchors.margins: 5

//            Item {
//                id: headerItem
//                Layout.fillWidth: true
//                Layout.minimumHeight: 40

//                Rectangle {
//                    anchors.fill: parent
//                    color: "transparent"
//                    border.color: "#e3dac9"
//                    border.width: 1
//                    radius: 5

//                    TextApp {
//                        anchors.centerIn: parent
//                        text: qsTr(viewApp.title)
//                    }
//                }
//            }

//            Item {
//                id: bodyItem
//                Layout.fillWidth: true
//                Layout.fillHeight: true

//                RowLayout {
//                    anchors.fill: parent

//                    Item {
//                        id: leftContainnerItem
//                        Layout.fillWidth: true
//                        Layout.fillHeight: true

//                        Column {
//                            anchors.centerIn: parent
//                            spacing: 10

//                            TextApp {
//                                id: apLabelText
//                                width: leftContainnerItem.width
//                                horizontalAlignment: Text.AlignHCenter
//                                verticalAlignment: Text.AlignBottom
//                                text: qsTr("Connected to: ")
//                            }

//                            Column {
//                                width: leftContainnerItem.width
//                                spacing: 5

//                                TextApp {
//                                    id: apNameText
//                                    width: parent.width
//                                    horizontalAlignment: Text.AlignHCenter
//                                    font.pixelSize: 56
//                                    elide: Text.ElideMiddle
//                                    text: "NONE"
//                                }

//                                TextApp {
//                                    id: ipAddresspText
//                                    width: leftContainnerItem.width
//                                    horizontalAlignment: Text.AlignHCenter
//                                    font.pixelSize: 16
//                                    elide: Text.ElideMiddle
//                                    color: "gray"
//                                    text: "NONE"
//                                }
//                            }
//                        }
//                    }

//                    Item {
//                        Layout.fillWidth: true
//                        Layout.fillHeight: true
//                        clip: true

//                        Item {
//                            anchors.centerIn: parent
//                            width: parent.width
//                            height: ((apScanListView.count + 1) * 40) > parent.height ? parent.height : ((apScanListView.count + 1) * 40)

//                            ListView {
//                                id: apScanListView
//                                anchors.fill: parent
//                                spacing: 2

//                                property string headerText: qsTr("Choose a network:")

//                                header: Rectangle {
//                                    color: "black"
//                                    height: 40
//                                    width: parent.width

//                                    TextApp {
//                                        id: apListHeaderText
//                                        anchors.centerIn: parent
//                                        text: apScanListView.headerText
//                                    }
//                                }

//                                delegate: Item {

//                                    Rectangle{
//                                        anchors.fill: parent;
//                                        border.color: "gray"
//                                        color: connectMouseArea.pressed ? "#55ffffff" : "transparent"
//                                        radius: 5
//                                    }

//                                    height: 40
//                                    width: parent.width

//                                    RowLayout {
//                                        anchors.fill: parent

//                                        Item {
//                                            Layout.fillHeight: true
//                                            Layout.fillWidth: true

//                                            TextApp {
//                                                id: apText
//                                                anchors.fill: parent
//                                                horizontalAlignment: Text.AlignHCenter
//                                                verticalAlignment: Text.AlignVCenter
//                                                elide: Text.ElideMiddle
//                                                //                                        text: qsTr("ESCO_AP")
//                                                text: modelData
//                                            }

//                                            MouseArea {
//                                                id: connectMouseArea
//                                                anchors.fill: parent
//                                                onClicked: {
//                                                    //                                                    //console.debug("onClicked")
//                                                    const ap = String(modelData).split(":")[0]

//                                                    if (String(ap).includes(" ")){
//                                                        ////console.debug("Not Support AP Name with Space Character")
//                                                        dialogAppNotify.open()
//                                                        return
//                                                    }

//                                                    apLabelText.text = qsTr("Connecting...")
//                                                    apNameText.text = ap
//                                                    ipAddresspText.text = ""

//                                                    NetworkManager.connectAsync(ap)
//                                                }
//                                            }
//                                        }

//                                        Item {
//                                            Layout.fillHeight: true
//                                            Layout.minimumWidth: 50

//                                            Rectangle {
//                                                anchors.fill: parent
//                                                radius: 5
//                                                color: "transparent"
//                                                border.color: "gray"

//                                                TextApp {
//                                                    anchors.centerIn: parent
//                                                    text: "X"
//                                                }
//                                            }

//                                            MouseArea {
//                                                id: deleteMouseArea
//                                                anchors.fill: parent
//                                                onClicked: {
//                                                    //                                                    //console.debug("onPressAndHold")
//                                                    const ap = String(modelData).split(":")[0]
//                                                    //                                            NetworkManager.deleteConnection(ap)
//                                                    dialogAppForget.openConfirmToForgetDialog(ap)
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }

//            /// Footer
//            Item {
//                id: footerItem
//                Layout.fillWidth: true
//                Layout.minimumHeight: 70

//                Rectangle {
//                    anchors.fill: parent
//                    color: "transparent"
//                    border.color: "#e3dac9"
//                    border.width: 1
//                    radius: 5

//                    Item {
//                        anchors.fill: parent
//                        anchors.margins: 5

//                        ButtonBarApp {
//                            anchors.left: parent.left
//                            anchors.verticalCenter: parent.verticalCenter

//                            imageSource: "../../Pictures/back-step"
//                            text: qsTr("Back")

//                            onClicked: {
//                                var intent = IntentApp.create(uri, {"message":""})
//                                finishView(intent)

//                                //                                apScanListView.model = apScanListView.count - 1
//                                //                                viewApp.textInputTarget = this
//                                //                                viewApp.openKeyboard(qsTr("WiFi Password"))
//                            }
//                        }

//                        ButtonBarApp {
//                            anchors.right: parent.right
//                            anchors.verticalCenter: parent.verticalCenter

//                            imageSource: "../../Pictures/local-wifi-update"
//                            text: qsTr("Scan")

//                            onClicked: {
//                                //                                apScanListView.model = apScanListView.count + 1
//                                NetworkManager.scanAsync()
//                            }
//                        }
//                    }
//                }//
//            }//
//        }//

//        /// Called once this page has ready
//        /// viewOnComplete
//        Component.onCompleted: {
//            /// auto call scanAsync after read status finished
//            connectionsNetworkManagerScanAfterReadStatus.enabled = true
//            /// Do Read status
//            NetworkManager.readStatusAsync()
//        }

//        /// Dialog
//        DialogApp {
//            id: dialogAppNotify

//            contentItem.title: qsTr("Warning")
//            contentItem.text: qsTr("Does not support access point names with spaces!")
//            contentItem.dialogType: contentItem.dialogTypeWarning
//            contentItem.standardButton: contentItem.standardButtonClose

//        }

//        /// Dialog Forget
//        DialogApp {
//            id: dialogAppForget
//            anchors.fill: parent

//            /////////
//            property string apToForget: ""

//            function openConfirmToForgetDialog(value) {

//                apToForget = value

//                dialogAppForget.contentItem.title = qsTr("Forget Network")
//                dialogAppForget.contentItem.text = qsTr("Are your sure want to forget this network?")
//                dialogAppForget.contentItem.dialogType = dialogAppForget.contentItem.dialogTypeWarning
//                dialogAppForget.contentItem.standardButton = dialogAppForget.contentItem.standardButtonCancelOK
//                dialogAppForget.funcOnAccepted = onConfirmToForgetAccepted
//                dialogAppForget.open()

//            }//

//            function onConfirmToForgetAccepted() {
//                //                //console.debug("onConfirmToDeteleAccepted")
//                NetworkManager.deleteConnectionAsync(apToForget)
//            }//

//            ////////
//            function openInfoDialog(message) {
//                dialogAppForget.contentItem.title = qsTr("Info")
//                dialogAppForget.contentItem.text = message
//                dialogAppForget.contentItem.dialogType = dialogAppForget.contentItem.dialogTypeInfo
//                dialogAppForget.contentItem.standardButton = dialogAppForget.contentItem.standardButtonClose
//                dialogAppForget.open()
//            }//

//            ///////
//            onClosed: funcOnAccepted = function(){}
//            property var funcOnAccepted: function(){}
//            onAccepted: funcOnAccepted()
//        }//

//        /// Connect to singleton NetworkManager object
//        /// monitor if access point list has changed
//        Connections {
//            id: connectionsNetworkManager
//            target: NetworkManager

//            function onAcceessPointListNameChanged(aps) {
//                apScanListView.model = aps
//            }

//            function onPasswordAsked(apName) {
//                viewApp.funcOnKeyboardEntered = function(password){
//                    NetworkManager.connectAsync(apName, password)
//                }
//                viewApp.textInputTarget = wifiPasswordTextInput
//                viewApp.openKeyboard(qsTr("WiFi Password"))
//            }

//            function onReadStatusFinished(){
//                //                //console.debug("onReadStatusFinished")
//                //                //console.debug(NetworkManager.connectedStatus)
//                //                //console.debug(NetworkManager.accessPoint)
//                apLabelText.text = qsTr("Connected to")
//                if (NetworkManager.connectedStatus){
//                    apNameText.text = NetworkManager.accessPoint
//                    ipAddresspText.text = NetworkManager.ipv4
//                } else {
//                    apNameText.text = qsTr("NONE")
//                    ipAddresspText.text = ""
//                }
//            }

//            function onScanningStatusChanged(value){
//                if(value) {
//                    /// under scanning wifi access point
//                    apScanListView.headerText = qsTr("Choose a network: (scanning...)")
//                }
//                else {
//                    if (NetworkManager.acceessPointListName.length){
//                        apScanListView.headerText = qsTr("Choose a network: ")
//                    } else {
//                        apScanListView.headerText = qsTr("Choose a network: (not found)")
//                    }
//                }
//            }

//            function onDeletionFinished(status, apName){
//                if(status === NetworkManager.NME_SUCCESS) {
//                    dialogAppForget.openInfoDialog(qsTr("The network has been forgotten"))
//                }
//                else {
//                    dialogAppForget.openInfoDialog(qsTr("Failed because it has never been connected to this network or other unknown reasons"))
//                }
//            }
//        }

//        Connections {
//            id: connectionsNetworkManagerScanAfterReadStatus
//            target: NetworkManager
//            enabled: false

//            function onReadStatusFinished(){
//                //                //console.debug("onReadStatusFinished")
//                /// Just enable for onetime
//                enabled = false
//                /// auto calling scanAsync job
//                NetworkManager.scanAsync()
//            }
//        }//

//        /// TextInput Proxy for WiFi Password
//        TextInput {
//            id: wifiPasswordTextInput
//            visible: false
//            echoMode: TextInput.Password
//        }
//    }//
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
