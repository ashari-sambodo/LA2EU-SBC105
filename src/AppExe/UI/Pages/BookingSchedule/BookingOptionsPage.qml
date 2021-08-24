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

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import BookingScheduleQmlApp 1.0

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Booking Options"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        /// please comment for production
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
                    title: qsTr(viewApp.title)
                }//
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Flow {
                    anchors.centerIn: parent
                    width: 305
                    spacing: 5

                    Rectangle {
                        height: 100
                        width: 305
                        radius: 5
                        color: "#0F2952"
                        border.color: "#e3dac9"

                        ColumnLayout {
                            anchors.fill: parent

                            TextApp {
                                Layout.margins: 5
                                text: qsTr("Export") + " " + qsTr("(Week: ") + props.exportTargetWeek + ")"
                            }//

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                RowLayout {
                                    anchors.fill: parent

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        visible: false
                                        Image {
                                            anchors.centerIn: parent
                                            source: "qrc:/UI/Pictures/pdf-export-bt.png"
                                        }//

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                props.exportToWhat = props.exportToPdfBluetooth
                                                bookingScheduleQmlApp.exportAsDocument()
                                            }//
                                        }//
                                    }//

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true

                                        Image {
                                            anchors.centerIn: parent
                                            source: "qrc:/UI/Pictures/pdf-export-usb.png"
                                        }//

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                props.exportToWhat = props.exportToPdfUSB

                                                const message = "<b>" + qsTr("Have you insert usb drive?") + "</b>"
                                                              + "<br><br>"
                                                              + qsTr("USB port can be found on top of the cabinet, near by power inlet.")
                                                const autoclosed = false
                                                showDialogAsk(qsTr(viewApp.title), message, dialogAlert,
                                                              function onAccepted(){
                                                                  bookingScheduleQmlApp.exportAsDocument()
                                                              },
                                                              function(){}, function(){}, autoclosed)
                                            }//
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//

                    Rectangle {
                        height: 100
                        width: 305
                        radius: 5
                        color: "#0F2952"
                        border.color: "#e3dac9"
                        //                        visible: false

                        ColumnLayout {
                            anchors.fill: parent

                            TextApp {
                                Layout.margins: 5
                                text: qsTr("Delete older log start from")
                            }//

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                RowLayout {
                                    anchors.fill: parent

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true

                                        ComboBoxApp {
                                            anchors.fill: parent
                                            anchors.margins: 5
                                            font.pixelSize: 20

                                            textRole: "text"

                                            model: [
                                                {text: qsTr('Today (Clear All)'),   value: 0},
                                                {text: qsTr('Yesterday'),           value: 1},
                                                {text: qsTr('1 week ago'),       value: 7},
                                                {text: qsTr('1 month ago'),      value: 30},
                                                {text: qsTr('1 year ago'),       value: 365},
                                            ]

                                            onActivated: {
                                                props.deleteWhereOlderThanDays = model[index].value
                                                notifAnima.start()
                                            }//
                                        }//
                                    }//

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.minimumWidth: parent.height

                                        Rectangle {
                                            anchors.fill: parent
                                            anchors.margins: 2
                                            color: "transparent"
                                            border.color: "#e3dac9"
                                            radius: 5

                                            Image {
                                                id: deleteImage
                                                source: "qrc:/UI/Pictures/trash-icon-35px.png"
                                                anchors.fill: parent
                                                fillMode: Image.PreserveAspectFit

                                                SequentialAnimation {
                                                    id: notifAnima

                                                    NumberAnimation {
                                                        target: deleteImage
                                                        property: "scale"
                                                        from: 1
                                                        to: 0.7
                                                        duration: 200
                                                        easing.type: Easing.InOutQuad
                                                        onStopped: deleteImage.scale = 1
                                                    }//

                                                    ScriptAction {
                                                        script: deleteImage.scale = 1
                                                    }//
                                                }//
                                            }//
                                        }//

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                const message = "<b>" + qsTr("Delete the log?") + "</b>"
                                                              + "<br><br>"
                                                              + qsTr("This process can not be undone and not recoverable.")

                                                showDialogAsk(qsTr(title),
                                                              message,
                                                              dialogAlert,
                                                              function onAccepted(){
                                                                  //console.debug("yes Delete")
                                                                  bookingScheduleQmlApp.deleteData()
                                                              });
                                            }//
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//

                    Rectangle {
                        height: 40
                        width: 305
                        radius: 5
                        color: "#0F2952"
                        border.color: "#e3dac9"

                        TextApp {
                            anchors.fill: parent
                            anchors.margins: 5
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("Storage") + ": " + bookingScheduleQmlApp.totalRows + "/" + bookingScheduleQmlApp.getMaximumRows()
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

        /// Database connection
        BookingScheduleQmlApp {
            id: bookingScheduleQmlApp
            onInitializedChanged: {
                //                console.debug("BookingScheduleQmlApp: " + initialized)
                viewApp.closeDialog()
            }//

            Component.onCompleted: {
                viewApp.showBusyPage(qsTr("Please wait"))
                const uniqConnectionName = "UiBookingForOptions"
                init(uniqConnectionName);
            }//

            function exportAsDocument(){
                const message = qsTr("Generating") + "..."
                viewApp.showBusyPage(message)

                const _targetDate   = props.exportTargetDate;
                const _cabinetModel = MachineData.machineModelName;
                const _serialNumber = MachineData.serialNumber;
                const _exportedDate = Qt.formatDateTime(new Date, "dd-MMM-yyyy hh:mm:ss")

                exportData(_targetDate, _exportedDate, _serialNumber, _cabinetModel)
            }//

            onDataHasExported: {
                viewApp.showDialogMessage(qsTr(title),
                                  qsTr("The document has been generated"),
                                  dialogInfo,
                                  function onClosed(){
                                      let urlContext = "qrc:/UI/Pages/FileManagerUsbCopyPage/FileManagerUsbCopierPage.qml";
                                      if(props.exportToWhat == props.exportToPdfBluetooth){
                                          urlContext = "qrc:/UI/Pages/BluetoothFileTransfer/BluetoothFileTransfer.qml"
                                      }

                                      const intent = IntentApp.create(urlContext, {"sourceFilePath": desc})
                                      startView(intent);
                                  })
            }//

            function deleteData() {
                const message = qsTr("Deleting") + "..."
                viewApp.showBusyPage(message)

                deleteWhereOlderThanDays(props.deleteWhereOlderThanDays)
            }//

            onDeleteHasDone: {
                viewApp.showDialogMessage(qsTr(title), qsTr("The log has been deleted!"), dialogInfo)
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int deleteWhereOlderThanDays: 0

            property string exportTargetDate: ""
            property int    exportTargetWeek: 0

            readonly property int exportToPdfUSB: 0
            readonly property int exportToPdfBluetooth: 1
            property int exportToWhat: 0
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                const extraData = IntentApp.getExtraData(intent)
                props.exportTargetDate = extraData['exportTargetDate'] || ""
                if(props.exportTargetDate.length) {
                    const theDate = new Date(props.exportTargetDate)
                    const onejan = new Date(theDate.getFullYear(), 0, 1);
                    const week = Math.ceil( (((theDate.getTime() - onejan.getTime()) / 86400000) + onejan.getDay() + 1) / 7 );

                    //                    console.log("week:" + week)
                    props.exportTargetWeek = week
                }
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
    D{i:0;autoSize:true;formeditorColor:"#808080";formeditorZoom:1.75;height:480;width:800}
}
##^##*/
