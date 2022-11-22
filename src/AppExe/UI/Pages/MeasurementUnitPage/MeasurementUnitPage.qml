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
    title: "Measurement Unit"

    background.sourceComponent: Item {}

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
                    id: headerApp
                    anchors.fill: parent
                    title: qsTr("Measurement Unit")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Row {
                    anchors.centerIn: parent
                    spacing: 10

                    Repeater {
                        id: optionsRepeater
                        //                        model: props.modelMeaUnit

                        Column {
                            Image {
                                opacity: mouseArea.pressed ? 0.7 : 1
                                source: modelData.imgSrc
                                //                                opacity:

                                Loader{
                                    active: modelData.active
                                    sourceComponent: Image {
                                        source: "qrc:/UI/Pictures/checkicon.png"
                                    }//
                                }//

                                MouseArea {
                                    id: mouseArea
                                    anchors.fill: parent
                                    onClicked: {
                                        if (modelData.active) return
                                        props.setMeasurementUnit(index)
                                    }//
                                }//
                            }//

                            TextApp {
                                text: modelData.text
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

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int measurementUnit: 0

            property var modelMeaUnit: [
                {text: qsTr("Metric"),      imgSrc: "qrc:/UI/Pictures/measure-matric-icon.png", active: 0},
                {text: qsTr("Imperial"),    imgSrc: "qrc:/UI/Pictures/measure-imp-icon.png",    active: 0}
            ]

            function setMeasurementUnit(unit){
                const unitStr = unit ? qsTr("Imperial") : qsTr("Metric")
                const message = "<b>" + qsTr("Change measurement unit to ") + unitStr + "?</b>"
                              + "<br><br>"
                              + qsTr("Change the measurement unit without re-calibrate may make the airflow value on the screen is inaccurate") + "."

                const autoClose = false
                showDialogAsk(qsTr(title), message,  dialogAlert, function(){
                    //                    //console.debug(unit)
                    doSetMeasurementUnit(unit)
                },
                function onRejected(){},
                function onClosed(){},
                autoClose)
            }

            function doSetMeasurementUnit(unit){
                /// tell to machine
                MachineAPI.setMeasurementUnit(unit)

                const message = unit ? qsTr("User: Set measurement unit to imperial") : qsTr("User: Set measurement unit to metric")
                MachineAPI.insertEventLog(unit)

                /// show busy
                viewApp.showBusyPage(qsTr("Setting up..."),
                                     function onCycle(cycle){
                                         if (cycle === MachineAPI.BUSY_CYCLE_1) {
                                             props.modelMeaUnit[1]['active'] = 0
                                             props.modelMeaUnit[0]['active'] = 0

                                             if (props.measurementUnit) props.modelMeaUnit[1]['active'] = 1
                                             else props.modelMeaUnit[0]['active'] = 1

                                             optionsRepeater.model = props.modelMeaUnit

                                             viewApp.dialogObject.close()
                                         }//
                                     })
            }
        }

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible:  QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

                props.measurementUnit = Qt.binding(function(){return MachineData.measurementUnit})
                //                    //console.debug(props.measurementUnit)

                if (props.measurementUnit) props.modelMeaUnit[1]['active'] = 1
                else props.modelMeaUnit[0]['active'] = 1

                optionsRepeater.model = props.modelMeaUnit
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
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
