/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Ahmad Qodri
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Mute Timer"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: Item{
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
                    title: qsTr("Mute Timer")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent
                    spacing: 5
                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Image{
                            source: "qrc:/UI/Pictures/mute-timer-icon.png"
                            fillMode: Image.PreserveAspectFit
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        ComboBoxApp {
                            id: comboBox
                            width: 190
                            height: 50
                            backgroundColor: "#0F2952"
                            backgroundBorderColor: "#dddddd"
                            backgroundBorderWidth: 2
                            font.pixelSize: 20
                            anchors.verticalCenter: parent.verticalCenter
                            textRole: "text"

                            model: [
                                {text: qsTr("1 Minute"),    value: 1},
                                {text: qsTr("3 Minutes"),   value: 3},
                                {text: qsTr("5 Minutes"),   value: 5},
                                {text: qsTr("10 Minutes"),  value: 10},
                                {text: qsTr("15 Minutes"),  value: 15}
                            ]

                            onActivated: {
                                ////console.debug(index)
                                ////console.debug(model[index].value)
                                let newValue = model[index].value
                                if(props.muteTimer !== newValue){

                                    props.muteTimer = newValue
                                    MachineAPI.setMuteAlarmTime(newValue)

                                    //console.debug("Mute:", props.muteTimer, "min")
                                    viewApp.showBusyPage((qsTr("Setting up mute timer...")),
                                                         function onTriggered(cycle){
                                                             if(cycle === 3){
                                                                 viewApp.dialogObject.close()}
                                                         })
                                }
                            }
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
                            }
                        }//
                    }//
                }//
            }
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props
            property int muteTimer : 0
        }

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        Loader {
            active: viewApp.stackViewStatusForeground
            sourceComponent: QtObject {

                /// onResume
                Component.onCompleted: {
                    //                    //console.debug("StackView.Active");

                    props.muteTimer = MachineData.muteAlarmTime
                    if(props.muteTimer == 3)
                        comboBox.currentIndex = 1
                    else if(props.muteTimer == 5)
                        comboBox.currentIndex = 2
                    else if(props.muteTimer == 10)
                        comboBox.currentIndex = 3
                    else if(props.muteTimer == 15)
                        comboBox.currentIndex = 4
                    else
                        comboBox.currentIndex = 0
                }

                /// onPause
                Component.onDestruction: {
                    ////console.debug("StackView.DeActivating");
                }
            }//
        }//
    }//
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.9;height:480;width:800}
}
##^##*/
