import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import modules.cpp.machine 1.0

ViewApp {
    id: viewApp
    title: "Fan PIN"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: Item{
        id: containerItem
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
                    title: qsTr(viewApp.title)
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
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Grid {
                            id: placeHolderPinGrid
                            anchors.centerIn: parent
                            spacing: 5
                            columns: 5

                            Repeater {
                                model: 5

                                Rectangle {
                                    height: 50
                                    width: 50
                                    radius: 50
                                    color: "#20ffffff"
                                    border.width: 1
                                    border.color: "#ffffff"
                                }//
                            }//
                        }//

                        Grid {
                            x: placeHolderPinGrid.x
                            y: placeHolderPinGrid.y
                            spacing: 5
                            columns: 5

                            Repeater {
                                id: fillPinRepeater
                                model: []

                                Rectangle {
                                    height: 50
                                    width: 50
                                    radius: 50
                                    color: "#aaffffff"
                                    border.width: 1
                                    border.color: "#ffffff"
                                }//
                            }//
                        }//

                    }//

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Grid {
                            anchors.centerIn: parent
                            spacing: 5

                            Repeater {
                                model: ["1","2","3","4","5","6","7","8","9","0", "BS", "C"]

                                Rectangle {
                                    height: 100
                                    width: 100
                                    radius: 50
                                    color: mouseArea.pressed ? "#70ffffff" : "#20ffffff"
                                    border.width: 1
                                    border.color: "#ffffff"

                                    TextApp {
                                        anchors.fill: parent
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font.pixelSize: 24
                                        text: modelData
                                    }//

                                    MouseArea {
                                        id: mouseArea
                                        anchors.fill: parent
                                        onClicked: {
                                            let fillModel = fillPinRepeater.model

                                            if (modelData == "BS") {
                                                fillModel.pop()
                                            }
                                            else if (modelData == "C") {
                                                fillModel = []
                                            }
                                            else {
                                                if (fillModel.length === 5 ){
                                                    let inPin = fillModel
                                                    containerItem.authentication(inPin)
                                                }
                                                else {
                                                    fillModel.push(modelData)
                                                    if (fillModel.length === 5 ){
                                                        let inPin = fillModel
                                                        containerItem.authentication(inPin)
                                                    }
                                                }
                                            }

                                            fillPinRepeater.model = fillModel
                                        }
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
                    color: "#770F2952"
                    //                    border.color: "#ffffff"
                    //                    border.width: 1
                    radius: 5

                    Item {
                        anchors.fill: parent
                        anchors.margins: 5

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }
                        }//
                    }//
                }//
            }
        }//

        function authentication(pin) {
            if (pin.join("") === "12345") {
                containerItem.setBlowerState()
            }
            else {
                dialogNotify.open()
            }
        }

        function setBlowerState() {
            let currentState = MachineData.blowerDownflowState
            if (currentState) {
                MachineApi.setBlowerState(MachineApi.FAN_STATE_OFF);
            }
            else {
                MachineApi.setBlowerState(MachineApi.FAN_STATE_ON);
            }

            var intent = IntentApp.create(uri, {"message":""})
            finishView(intent)
        }

        /// Dialog
        DialogApp {
            id: dialogNotify

            contentItem.title: qsTr("Warning")
            contentItem.text: qsTr("PIN does not match")
            contentItem.dialogType: contentItem.dialogTypeWarning
            contentItem.standardButton: contentItem.standardButtonClose

            onRejected: {
                fillPinRepeater.model = []
            }
        }

        /// OnCreated
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        Loader {
            active: viewApp.stackViewStatusActivating || viewApp.stackViewStatusActive
            sourceComponent: QtObject {

                /// onResume
                Component.onCompleted: {
                    console.log("StackView.Active");
                }

                /// onPause
                Component.onDestruction: {
                    //console.log("StackView.DeActivating");
                }//
            }//
        }//
    }//
}//



/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
