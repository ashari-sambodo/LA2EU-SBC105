/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Reset Fan Meter"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        visible: true

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
                    title: qsTr("Reset Fan Meter")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column {
                    id: currentValueColumn
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        text: qsTr("Current meter usage")
                        color: "#cccccc"
                    }//

                    TextApp {
                        id: currentValueText
                        font.pixelSize: 36
                        wrapMode: Text.WordWrap
                        text: utils.strfMinToHumanReadableShort(props.currentMeterDfa)
                    }//

                    TextApp {
                        text: qsTr("Counting by minute")
                        color: "#cccccc"
                        font.pixelSize: 16
                    }//

                    TextApp{
                        text: qsTr("Tap here to set")
                        color: "#cccccc"
                        font.pixelSize: 16
                    }//
                }//

                MouseArea {
                    anchors.fill: currentValueColumn
                    onClicked: {
                        KeyboardOnScreenCaller.openNumpad(newValueTextField, qsTr("Reset Fan Meter (minutes)"))
                    }//
                }//

                TextFieldApp {
                    id: newValueTextField
                    visible: false

                    onAccepted: {
                        let val = Number(text)
                        MachineAPI.setFanPrimaryUsageMeter(val)

                        showBusyPage(qsTr("Setting up..."), function(cycle){
                            if(cycle === MachineAPI.BUSY_CYCLE_1) {
                                closeDialog()
                            }
                        })
                    }
                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: MachineAPI.FOOTER_HEIGHT

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
                    }//
                }//
            }//
        }//

        UtilsApp {
            id: utils
        }//

        //// Put all private property inside here
        //// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int currentMeterDfa: 0
            property int currentMeterIfa: 0
        }

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

                props.currentMeterDfa = Qt.binding(function(){ return MachineData.fanPrimaryUsageMeter })
                props.currentMeterIfa = Qt.binding(function(){ return MachineData.fanInflowUsageMeter })
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
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/
