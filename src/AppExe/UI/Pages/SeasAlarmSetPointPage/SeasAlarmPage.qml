//by Fatin

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

import UI.CusCom 1.0
//import "../../../CusCom/JS/IntentApp.js" as IntentApp
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Seas Alarm Set Point"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp{
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
                    id: headerApp
                    anchors.fill: parent
                    title: qsTr("Seas Alarm Set Point")
                }
            }

            /// BODY
            BodyItemApp {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent
                    spacing: 5

                    Item{
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Column {

                            anchors.centerIn: parent
                            spacing: 7

                            TextApp {
                                text: "Actual pressure "
                                font.pixelSize: 30
                            }

                            TextApp {
                                font.pixelSize: 57
                                text: props.actualPressurePa + "Pa"
                            }

                            TextApp {
                                font.pixelSize: 17
                                text: props.actualPressure
                            }
                        }//
                    }//

                    Item {
                        id: rightContentItem
                        Layout.fillHeight: true
                        Layout.minimumWidth: parent.width * 0.20

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 5

                            Rectangle {
                                //                                anchors.verticalCenter: parent.verticalCenter
                                width: rightContentItem.width
                                height: rightContentItem.height / 3 - 5
                                color: "#0F2952"
                                border.color: "#dddddd"
                                radius: 5

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 3
                                    spacing: 1

                                    TextApp {
                                        text: qsTr("Alarm Point") + ":"
                                    }//

                                    TextApp {
                                        text: "Pa"
                                    }//

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        TextField {
                                            id: alarmSeasSetTextfield
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            width: parent.width - 2
                                            font.pixelSize: 24
                                            horizontalAlignment: Text.AlignHCenter
                                            color: "#dddddd"
                                            text: props.pressureAlarmSet

                                            background: Rectangle {
                                                //                                                id: backgroundTextField
                                                height: parent.height
                                                width: parent.width
                                                color: "#55000000"

                                                Rectangle {
                                                    height: 1
                                                    width: parent.width
                                                    anchors.bottom: parent.bottom
                                                }//
                                            }//

                                            onPressed: {
                                                KeyboardOnScreenCaller.openNumpad(alarmSeasSetTextfield, qsTr("Set Pressure Alarm Value"))
                                            }//

                                            onAccepted: {
                                                const val = Number(text)
                                                if(isNaN(val)) return

                                                props.pressureAlarmSet = val
                                                console.log("setPressureValue" + props.pressureAlarmSet)

                                                //                                                MachineAPI.setSeasPressureDiffPaLowLimit(props.pressureAlarmSet)
//                                                props.pressureStr = text
                                            }//
                                        }//
                                    }//
                                }//
                            }//

                            Rectangle {
                                //                                anchors.verticalCenter: parent.verticalCenter
                                width: rightContentItem.width
                                height: rightContentItem.height / 3 - 5
                                color: "#0F2952"
                                border.color: "#dddddd"
                                radius: 5

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 3
                                    spacing: 1

                                    TextApp {
                                        text: qsTr("Set Offset") + ":"
                                    }//

                                    TextApp {
                                        text: "Pa"
                                    }//

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        TextField {
                                            id: offsetTextfield
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            width: parent.width - 2
                                            font.pixelSize: 24
                                            horizontalAlignment: Text.AlignHCenter
                                            color: "#dddddd"
                                            text: props.offset

                                            background: Rectangle {
                                                height: parent.height
                                                width: parent.width
                                                color: "#55000000"

                                                Rectangle {
                                                    height: 1
                                                    width: parent.width
                                                    anchors.bottom: parent.bottom
                                                }//
                                            }//

                                            onPressed: {
                                                KeyboardOnScreenCaller.openNumpad(offsetTextfield, qsTr("Set Offset Reading"))
                                            }//

                                            onAccepted: {
                                                const val = Number(text)
                                                if(isNaN(val)) return

                                                props.offset = val
//                                                props.offsetStr = text

                                                //                                                MachineAPI.setSeasPressureDiffPaOffset(props.offset)
                                            }//
                                        }//
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
                    //                    border.color: "#e3dac9"
                    //                    border.width: 1
                    radius: 5

                    Item {
                        anchors.fill: parent
                        anchors.margins: 5

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:///UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                var intent = IntentApp.create(uri, {"navigation":"back"})
                                finishView(intent)
                            }
                        }//

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "/UI/Pictures/checkicon.png"
                            text: qsTr("Set")

                            onClicked: {

                                MachineAPI.setSeasPressureDiffPaLowLimit(props.pressureAlarmSet)
                                MachineAPI.setSeasPressureDiffPaOffset(props.offset)

                                const textSet = qsTr("Value has been set!!!")
                                viewApp.showBusyPage(qsTr("Setting Up"),
                                                     function onCallback(cycle){
                                                         if(cycle === 2){
                                                             //                                                             viewApp.dialogObject.close()
                                                             viewApp.showDialogMessage(qsTr("Notification"),
                                                                                       textSet,
                                                                                       viewApp.dialogInfo
                                                                                       )
                                                         }
                                                     }
                                                     );
                            }//
                        }//
                    }//
                }//
            }//
        }//

        QtObject {
            id: props

            property int pressureAlarmSet: 0
//            property string pressureStr: "0"

            property int offset : 0
//            property string offsetStr: "0"

            property int actualPressurePa: 0
            property real actualPressure: 0

//            property int measureUnit: 0
//            property string measureUnitStr: measureUnit ? "Pa" : "Inch Wg"
        }

        /// Called once but after onResume
        Component.onCompleted: {
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                props.actualPressurePa = Qt.binding(function() { return MachineData.seasPressureDiffPa})
                console.log("actualPressurePa " + props.actualPressurePa)
                props.actualPressure = Qt.binding(function() { return MachineData.seasPressureDiff})
                console.log("actual pressure ")

                props.pressureAlarmSet = MachineData.seasPressureDiffPaLowLimit
//                props.pressureAlarmSet = MachineData.seasAlarmPressureLow
                props.offset = MachineData.seasPressureDiffPaOffset
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//



