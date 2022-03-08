/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Ahmad Qodri
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Airflow Monitor"

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
                    anchors.fill: parent
                    title: qsTr("Airflow Monitor")
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
                            source: "qrc:/UI/Pictures/airflow_monitor_page.png"
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
                                {text: qsTr("Disable"), value: 0},
                                {text: qsTr("Enable"),  value: 1}
                            ]

                            onActivated: {
                                let newValue = model[index].value
                                var message = ""
                                if(newValue !== props.airflowMonitorEnable){
                                    if(newValue === 0)
                                        message = qsTr("By Disabling the Airflow Monitor, the Airflow measurement value will not be displayed on Homescreen and the Airflow Alarm will be disabled!")
                                    else
                                        message = qsTr("By Enabling the Airflow Monitor, the Airflow measurement value will be displayed on Homescreen and the Airflow Alarm will be enabled")
                                    const autoclosed = true
                                    showDialogAsk(qsTr("Airflow Monitor"), message, (newValue ? dialogInfo : dialogAlert),
                                                  function onAccepted(){
                                                      MachineAPI.setAirflowMonitorEnable(newValue)

                                                      var string = newValue ? qsTr("Enabling") : qsTr("Disabling")
                                                      viewApp.showBusyPage((string + " " + qsTr("Airflow Monitor...")),
                                                                           function(cycle){
                                                                               if(cycle >= MachineAPI.BUSY_CYCLE_1){
                                                                                   comboBox.currentIndex = props.airflowMonitorEnable
                                                                                   viewApp.closeDialog();
                                                                               }
                                                                           })
                                                  },
                                                  function(){//onRejected
                                                      comboBox.currentIndex = props.airflowMonitorEnable
                                                  }, function(){//onClosed
                                                      comboBox.currentIndex = props.airflowMonitorEnable
                                                  }, autoclosed, 10)
                                }
                            }
                            //                            Component.onCompleted: {
                            //                                currentIndex = props.elsIsEnabled
                            //                            }
                        }//
                    }//
                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: MachineAPI.FOOTER_HEIGHT

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
                    }//
                }//
            }
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int airflowMonitorEnable: 0
        }

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

                props.airflowMonitorEnable = Qt.binding(function(){return MachineData.airflowMonitorEnable})
                comboBox.currentIndex = props.airflowMonitorEnable
            }//

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }//
        }//
    }//
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
