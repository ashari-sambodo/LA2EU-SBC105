/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Certification Remainder"

    background.sourceComponent: Item {
        //        color: "#34495e"
    }//

    content.asynchronous: true
    content.sourceComponent: ContentItemApp{
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
                    anchors.fill: parent
                    title: qsTr("Certification Remainder")
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

                    TextApp{
                        text: qsTr("Certification remainder date")
                        color: "#cccccc"
                    }//

                    TextApp{
                        id: currentValueText
                        font.pixelSize: 36
                        wrapMode: Text.WordWrap
                        text: props.targetDate
                    }//

                    TextApp{
                        text: qsTr("Tap here to set")
                        color: "#cccccc"
                        font.pixelSize: 14
                    }//
                }//

                MouseArea {
                    anchors.fill: currentValueColumn
                    onClicked: {
                        //                                contentStackView.push(calenderDateComponent)
                        viewApp.finishViewReturned.connect(props.onReturnFromCalendarPage);
                        const intent = IntentApp.create("qrc:/UI/Pages/CalendarPage/CalendarPage.qml",
                                                        {
                                                            "selectDateAndReturn": true
                                                        })
                        startView(intent)
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

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/cancel-w-icon.png"
                            text: qsTr("Disable")

                            onClicked: {
                                showDialogAsk(qsTr("Certificate Reminder"),
                                              qsTr("Are you sure to disable certificate dua date remainder?") + "<br><br>" +
                                              qsTr("Never show remainder notification."),
                                              dialogAlert,
                                              function onAccepted(){
                                                  let noneCertDate = ""
                                                  MachineAPI.setDateCertificationRemainder(noneCertDate)

                                                  showBusyPage(qsTr("Setting up..."),
                                                               function onCycle(cycle){
                                                                   if (cycle >= MachineAPI.BUSY_CYCLE_1){
                                                                       props.targetDate = MachineData.dateCertificationRemainder

                                                                       console.log("targetDateLength: " + props.targetDate.length)
                                                                       if(props.targetDate.length == 0) {
                                                                           props.targetDate = "---"
                                                                       }

                                                                       viewApp.closeDialog()
                                                                   }
                                                               })
                                              })
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

            property string targetDate: ""

            function onReturnFromCalendarPage(returnIntent){
                viewApp.finishViewReturned.disconnect(props.onReturnFromCalendarPage)

                const extraData = IntentApp.getExtraData(returnIntent)
                const calendar = extraData['calendar'] || false
                if (calendar) {
                    props.targetDate = calendar['date']
                    currentValueText.text = Qt.formatDate(new Date(props.targetDate), "dd MMM yyyy")

                    MachineAPI.setDateCertificationRemainder(props.targetDate)

                    showBusyPage(qsTr("Setting up..."),
                                 function onCycle(cycle){
                                     if (cycle >= MachineAPI.BUSY_CYCLE_1){
                                         viewApp.closeDialog()
                                     }
                                 })
                }//
            }//
        }//

        /// One time executed after onResume
        Component.onCompleted: {
            props.targetDate = MachineData.dateCertificationRemainder

            console.log("targetDateLength: " + props.targetDate.length)

            if(props.targetDate.length == 0) {
                currentValueText.text = "---"
            } else {
                currentValueText.text = Qt.formatDate(new Date(props.targetDate), "dd MMM yyyy")
            }
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/
