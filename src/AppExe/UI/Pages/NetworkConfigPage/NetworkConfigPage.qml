import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Connectify 1.0

ViewApp {
    id: viewApp
    title: "Network"

    background.sourceComponent: Item {
        //        Rectangle{
        //            Component.onCompleted: {
        //                const extraData = IntentApp.getExtraData(intent)
        //                const message = extraData["backgroundBlack"] || 0
        //                if(message) color = "black"
        //            }
        //        }
    }

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
                    title: qsTr("Network")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent

                    Item {
                        id: leftItem
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Column{
                            visible: NetworkService.connected || NetworkService.connecting
                            anchors.centerIn: parent
                            spacing: 10

                            TextApp{
                                id: labelText
                                text: qsTr("Connected to") + ":"

                                states: [
                                    State {
                                        when: NetworkService.connecting
                                        PropertyChanges {
                                            target: labelText
                                            text: qsTr("Connecting to") + ":"
                                        }
                                    }
                                ]
                            }

                            Column {
                                spacing: 2

                                TextApp {
                                    id: currentStatusText
                                    font.pixelSize: 36
                                    wrapMode: Text.WordWrap
                                    fontSizeMode: Text.Fit
                                    text: qsTr("None")

                                    width: Math.min(controlMaxWidthText.width, leftItem.width)

                                    Text {
                                        visible: false
                                        id: controlMaxWidthText
                                        text: currentStatusText.text
                                        font.pixelSize: 36
                                    }//

                                    states: [
                                        State {
                                            when: NetworkService.connecting
                                            PropertyChanges {
                                                target: currentStatusText
                                                text: props.wifiSelectedAccessPoint
                                            }
                                        }
                                        ,
                                        State {
                                            when: NetworkService.connected
                                            PropertyChanges {
                                                target: currentStatusText
                                                text: NetworkService.connName
                                            }
                                        }
                                        ,
                                        State {
                                            when: !NetworkService.connected
                                            PropertyChanges {
                                                target: currentStatusText
                                                text: qsTr("None")
                                            }
                                        }
                                    ]
                                }//

                                TextApp {
                                    id: ipText
                                    text: ""

                                    states: [
                                        State {
                                            when: NetworkService.connected
                                            PropertyChanges {
                                                target: ipText
                                                text: NetworkService.ipv4
                                            }
                                        }
                                    ]
                                }//

                                TextApp {
                                    id: forgetText
                                    color: "gray"
                                    visible: NetworkService.connected
                                    text: qsTr("forget")

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            //                                            NetworkService.forgetConnection(NetworkService.connName)
                                            props.forgetConnection(NetworkService.connName)
                                        }
                                    }//
                                }//
                            }//
                        }//

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/UI/Pictures/wifi-no-medium.png"
                            visible: !NetworkService.connected && !NetworkService.connecting
                        }
                    }

                    Rectangle{
                        Layout.fillHeight: true
                        Layout.minimumWidth: 1
                        color:"#e3dac9"
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        ColumnLayout {
                            anchors.fill: parent

                            Rectangle{
                                Layout.minimumHeight: 50
                                Layout.fillWidth: true
                                color: "#1F95D7"
                                radius: 2

                                TextApp {
                                    anchors.fill: parent
                                    anchors.margins: 2
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    text: qsTr("Available Access Point")
                                }
                            }

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                ListView {
                                    id: itemListView
                                    anchors.fill: parent
                                    model: NetworkService.accessPointAvailable
                                    enabled: !NetworkService.connecting && !NetworkService.scanning && !NetworkService.forgettingConn
                                    //                                    model: 5
                                    spacing: 2
                                    clip: true

                                    delegate: Item{
                                        id: listItem

                                        width: itemListView.width
                                        height: 50

                                        Rectangle {anchors.fill: parent; color: "#0F2952"}

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                props.wifiSelectedAccessPoint = modelData.name

                                                if (modelData.exist === "NEW"){
                                                    if(modelData.security.length){
                                                        KeyboardOnScreenCaller.openKeyboard(passwdBufferText, qsTr("Password"))
                                                    }
                                                    else {
                                                        NetworkService.connectToNewAccessPoint(props.wifiSelectedAccessPoint)
                                                    }
                                                }
                                                else{
                                                    NetworkService.connectTo(props.wifiSelectedAccessPoint)
                                                }
                                            }//
                                        }//

                                        RowLayout {
                                            anchors.fill: parent

                                            WifiSignalApp {
                                                Layout.fillHeight: true
                                                Layout.minimumWidth: height
                                                security: modelData.security.length
                                                strength: modelData.signal
                                            }//

                                            Item {
                                                Layout.fillHeight: true
                                                Layout.fillWidth: true

                                                TextApp {
                                                    anchors.fill: parent
                                                    verticalAlignment: Text.AlignVCenter
                                                    text: modelData.name
                                                }//
                                            }//

                                            TextApp {
                                                visible: modelData.exist === "EXIST"
                                                Layout.fillHeight: true
                                                Layout.minimumWidth: height
                                                text: "X"
                                                color: "gray"
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter

                                                MouseArea {
                                                    anchors.fill: parent
                                                    onClicked: {
                                                        props.forgetConnection(modelData.name)
                                                    }//
                                                }//
                                            }//
                                        }//
                                    }//
                                }//

                                Rectangle {
                                    visible: NetworkService.scanning
                                    anchors.fill: parent
                                    color: "#AA000000"
                                    radius: 2

                                    TextApp {
                                        anchors.centerIn: parent
                                        text: qsTr("Scanning...")
                                    }//

                                    MouseArea {
                                        anchors.fill: parent
                                    }
                                }//
                            }//
                        }//
                    }//
                }//

                TextInput {
                    id: passwdBufferText
                    echoMode: TextInput.Password
                    maximumLength: 20
                    visible: false

                    onAccepted: {
                        //                        console.log(text)
                        /// wifi standard password is minimum 8 characters
                        if(text.length < 8) return
                        NetworkService.connectToNewAccessPoint(props.wifiSelectedAccessPoint, text)
                    }
                }
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
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            enabled: !NetworkService.scanning && !NetworkService.connecting

                            imageSource: "qrc:/UI/Pictures/local-wifi-update.png"
                            text: qsTr("Scan")

                            onClicked: {
                                NetworkService.readStatus()
                                NetworkService.scanAccessPoint()
                            }//
                        }//
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property string wifiSelectedAccessPoint: ""

            function forgetConnection(connName){
                showDialogAsk(qsTr("Network"), qsTr("Forget the connection?"), dialogAlert,
                              function onAccepted(){
                                  NetworkService.forgetConnection(connName)
                              })
            }
        }//

        /// One time executed after onResume
        Component.onCompleted: {
            //            NetworkService.init()
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                NetworkService.readStatus()
                NetworkService.scanAccessPoint()
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
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
