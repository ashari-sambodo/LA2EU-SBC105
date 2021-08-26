/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Fan PIN"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
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
                    id: headerApp
                    anchors.fill: parent
                    title: qsTr("Fan PIN")
                }//
            }//

            /// BODY
            Item {
                id: contentItem
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.topMargin: 5
                Layout.bottomMargin: 5

                //            Rectangle{anchors.fill: parent; color: "yellow"}

                RowLayout {
                    anchors.fill: parent

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        TextApp {
                            id: infoPinText
                            anchors.horizontalCenter: pinTextField.horizontalCenter
                            anchors.bottom: pinTextField.top
                            anchors.bottomMargin: 50
                            text: qsTr("Enter PIN")
                        }//

                        TextField {
                            id: pinTextField
                            //                                anchors.horizontalCenter: parent.horizontalCenter
                            anchors.centerIn: parent
                            placeholderText: "*****"
                            font.pointSize: (parent.width / 5) - 10
                            font.letterSpacing: 20
                            font.bold: true
                            color: "white"
                            echoMode: TextInput.Password
                            passwordCharacter: "*"
                            horizontalAlignment: TextInput.AlignHCenter
                            maximumLength: 5

                            background: Item {
                                id: name
                            }

                            enabled: false

                            onTextChanged: {
                                if (text.length == 5) {
                                    const pinEncode = Qt.md5(text)
                                    //                                    console.log(pinEncode)

                                    if (props.fanPIN === pinEncode){
                                        props.changeStateOfFan()
                                    }
                                    else {
                                        let attempt = props.incorrectAttemptCount
                                        attempt = attempt + 1
                                        props.incorrectAttemptCount = attempt

                                        if (attempt === 5) {
                                            showDialogMessage(qsTr("Fan PIN"),
                                                              qsTr("You have entered an incorrect pin several times!"),
                                                              dialogAlert,
                                                              function onClosed(){
                                                                  const intent = IntentApp.create(uri,[])
                                                                  finishView(intent)
                                                              })
                                        }
                                        else {
                                            text = ""
                                            showDialogMessage(qsTr("Fan PIN"),
                                                              qsTr("Incorrect PIN"),
                                                              dialogAlert)
                                        }
                                    }
                                }//
                            }//
                        }//

                        TextApp {
                            visible: pinTextField.text.length
                            anchors.horizontalCenter: pinTextField.horizontalCenter
                            anchors.top: pinTextField.bottom
                            anchors.topMargin: 50
                            text: "Clear"

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    pinTextField.clear()
                                }//
                            }//
                        }//
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Column {
                            anchors.centerIn: parent
                            spacing: 5

                            Grid {
                                anchors.horizontalCenter: parent.horizontalCenter
                                columns: 3
                                spacing: 5

                                Repeater {
                                    model: [1,2,3,4,5,6,7,8,9]

                                    Rectangle {
                                        height: 70
                                        width: 100
                                        radius: 50
                                        color: buttonMouseArea.pressed ? "#77ffffff" : "#11ffffff"
                                        border.color: "white"
                                        border.width: 2

                                        TextApp {
                                            anchors.centerIn: parent
                                            text: modelData
                                            font.pixelSize: 32
                                        }

                                        MouseArea {
                                            id: buttonMouseArea
                                            anchors.fill: parent
                                            onClicked: {
                                                pinTextField.text = pinTextField.text + modelData
                                            }
                                        }//
                                    }//
                                }//
                            }//

                            Rectangle {
                                anchors.horizontalCenter: parent.horizontalCenter
                                height: 70
                                width: 100
                                radius: 50
                                color: buttonZeroMouseArea.pressed ? "#77ffffff" : "#11ffffff"
                                border.color: "white"
                                border.width: 2

                                TextApp {
                                    anchors.centerIn: parent
                                    text: "0"
                                    font.pixelSize: 32
                                }

                                MouseArea {
                                    id: buttonZeroMouseArea
                                    anchors.fill: parent
                                    onClicked: {
                                        pinTextField.text = pinTextField.text + "0"
                                    }
                                }
                            }
                        }
                    }
                }
            }


            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 70

                Rectangle {
                    anchors.fill: parent
                    color: "#0F2952"
                    //                    border.color: "#DDDDDD"
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
                    }//
                }//
            }//
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property string fanPIN : ""
            property int fanState: 0
            property int incorrectAttemptCount: 0

            function changeStateOfFan(){
                if (props.fanState) {
                    MachineAPI.setFanState(MachineAPI.FAN_STATE_OFF);
                    props.showFanProgressSwitchingState(!props.fanState)

                    MachineAPI.insertEventLog(qsTr("User: Set Fan off"))
                }
                else {
                    MachineAPI.setFanState(MachineAPI.FAN_STATE_ON);
                    props.showFanProgressSwitchingState(!props.fanState)

                    MachineAPI.insertEventLog(qsTr("User: Set Fan on"))
                }
            }//

            function showFanProgressSwitchingState(swithTo){
                //                //console.debug("swithTo: " + swithTo)
                const message = swithTo ? qsTr("Swithcing on the fan") + "..."
                                        : qsTr("Swithcing off the fan") + "..."
                viewApp.showBusyPage(message, function(cycle){
                    if(cycle === 5){
                        viewApp.closeDialog()
                        const intent = IntentApp.create(uri,[])
                        finishView(intent)
                    }
                })
            }//
        }//

        /// OnCreated
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                props.fanPIN = MachineData.fanPIN
                console.log("MachineData.fanPIN: " + MachineData.fanPIN)
                props.fanState = Qt.binding(function(){ return MachineData.fanState })
            }//

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }//
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/
