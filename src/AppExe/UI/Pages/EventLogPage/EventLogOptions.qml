/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

import EventLogQmlApp 1.0

ViewApp {
    id: viewApp
    title: "Event Log Options"

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
                    anchors.fill: parent
                    title: qsTr("Event Log Options")
                }//
            }//

            /// BODY
            Item {
                id: contentItem
                Layout.fillHeight: true
                Layout.fillWidth: true

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
                                text: qsTr("Export")
                            }//

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                RowLayout {
                                    anchors.fill: parent

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true

                                        Image {
                                            anchors.centerIn: parent
                                            source: "qrc:/UI/Pictures/pdf-export-bt.png"
                                        }//

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                props.exportToWhat = props.exportToPdfBluetooth
                                                KeyboardOnScreenCaller.openNumpad(exportNumberPageTextEdit, qsTr("Page to Export (ex. 1 or 1-10, max. 10 pages/export)"))
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
                                                                  KeyboardOnScreenCaller.openNumpad(exportNumberPageTextEdit, qsTr("Page to Export (ex. 1 or 1-10, max. 10 pages per export)"))
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
                                                                  dbConnectForDelete.active = true
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
                            text: qsTr("Storage") + ": " + props.countRows + "/" + props.countRowsMax
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
                            }//
                        }//
                    }//
                }//
            }//
        }//

        /// Database connection for delete the log
        Loader {
            id: dbConnectForDelete
            active: false
            sourceComponent: EventLogQmlApp {
                onInitializedChanged: {
                    //                //console.debug("DataLogQmlApp: " + initialized)
                    const message = qsTr("Deleting") + "..."
                    showBusyPage(message)

                    deleteWhereOlderThanDays(props.deleteWhereOlderThanDays)
                }

                onDeleteHasDone: {
                    //                    //console.debug(success)
                    //                    //console.debug(totalAfterDelete)
                    MachineAPI.refreshLogRowsCount("eventlog")

                    showDialogMessage(qsTr(title), qsTr("The log has been deleted!"), dialogInfo,
                                      function onClosed(){
                                        showBusyPage(qsTr("Please wait.."), function onCallback(second){
                                            if(second === 3) {
                                                closeDialog()
                                            }
                                        })
                                      })
                }

                Component.onCompleted: {
                    const uniqConnectionName = "eventLogUIforDelete"
                    init(uniqConnectionName);
                }//
            }//
        }//

        ///TextBuffer
        TextField {
            id: exportNumberPageTextEdit
            visible: false

            onAccepted: {
                const rangePagePattern = /^\d{1,}-\d{1,}$/
                const singlePagePattern = /^\d{1,}$/

                let newInput = text
                if (newInput.match(rangePagePattern)) {
                    //                    console.log(rangePagePattern)

                    const rangeNumber = newInput.split("-")
                    const startNumber = Number(rangeNumber[0]) || 0
                    const endNumber   = Number(rangeNumber[1]) || 0
                    //                    console.log("startNumber: " + startNumber)
                    //                    console.log("endNumber: " + endNumber)

                    if (startNumber < 1){
                        showDialogMessage(qsTr(title), qsTr("Invalid input!"), dialogAlert)
                        return
                    }
                    if ((startNumber > endNumber) || (endNumber > props.currentTotalPage)) {
                        showDialogMessage(qsTr(title), qsTr("Invalid input!"), dialogAlert)
                        return
                    }
                    if ((endNumber - startNumber + 1) > 10) {
                        showDialogMessage(qsTr(title), qsTr("Invalid input!"), dialogAlert)
                        return
                    }

                    props.startPageNumberExport = startNumber
                    props.endPageNumberExport = endNumber

                    dbConnectForExport.active = true
                }
                else if(newInput.match(singlePagePattern)) {
                    //                    console.log(singlePagePattern)

                    const pageNumber = Number(newInput)
                    if (pageNumber < 1){
                        showDialogMessage(qsTr(title), qsTr("Invalid input!"), dialogAlert)
                        return
                    }
                    if (pageNumber > props.currentTotalPage){
                        showDialogMessage(qsTr(title), qsTr("Invalid input!"), dialogAlert)
                        return
                    }

                    props.startPageNumberExport = pageNumber
                    props.endPageNumberExport = pageNumber

                    dbConnectForExport.active = true
                }
                else {
                    text = "1"
                }
            }//
        }//

        /// Database connection for export the log
        Loader {
            id: dbConnectForExport
            active: false
            sourceComponent: EventLogQmlApp {
                pagesItemPerPage: 50
                onInitializedChanged: {
                    //console.debug("DataLogQmlApp: " + initialized)
                    const message = qsTr("Generating") + "..."
                    showBusyPage(message)

                    const _startPageNumber  = props.startPageNumberExport;
                    const _endPageNumber    = props.endPageNumberExport;
                    const _cabinetModel     = MachineData.machineModelName;
                    const _serialNumber     = MachineData.serialNumber;
                    const _exportedDate     = Qt.formatDateTime(new Date, "dd-MMM-yyyy hh:mm:ss")

                    exportLogs(_startPageNumber, _exportedDate, _serialNumber, _cabinetModel, _endPageNumber)
                }

                onLogHasExported: {
                    //                    console.log("onLogHasExported: " + done)
                    //                    console.log("onLogHasExported:" + desc)

                    showDialogMessage(qsTr(title),
                                      qsTr("The document has been generated"),
                                      dialogInfo,
                                      function onClosed(){
                                          let urlContext = "qrc:/UI/Pages/FileManagerUsbCopyPage/FileManagerUsbCopierPage.qml";
                                          if(props.exportToWhat == props.exportToPdfBluetooth){
                                              urlContext = "qrc:/UI/Pages/BluetoothFileTransfer/BluetoothFileTransfer.qml"
                                          }
                                          const intent = IntentApp.create(urlContext,
                                                                          {
                                                                              "sourceFilePath": desc
                                                                          })
                                          startView(intent);
                                          dbConnectForExport.active = false
                                      })
                }

                Component.onCompleted: {
                    showBusyPage(qsTr("Please wait"))
                    const uniqConnectionName = "eventLogUIforExport"
                    init(uniqConnectionName);
                }//
            }//
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int deleteWhereOlderThanDays: 0

            property int currentNumberPage: 0
            property int currentTotalPage:  0

            property int startPageNumberExport: 1
            property int endPageNumberExport:   1

            readonly property int exportToPdfUSB: 0
            readonly property int exportToPdfBluetooth: 1
            property int exportToWhat: 0

            property int countRows: 0
            property int countRowsMax: 0
        }//

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible:  QtObject {

            /// onResume
            Component.onCompleted: {
                // console.debug("StackView.Active");
                props.countRows = Qt.binding(()=>{return MachineData.eventLogCount})
                props.countRowsMax = MachineData.eventLogSpaceMaximum

                const extraData = IntentApp.getExtraData(intent)
                props.currentNumberPage     = extraData['currentPage']  || 1
                props.currentTotalPage      = extraData['totalPage']    || 1
                props.startPageNumberExport = extraData['currentPage']  || 1
                props.endPageNumberExport   = extraData['currentPage']  || 1

                exportNumberPageTextEdit.text = props.currentNumberPage
            }//

            /// onPause
            Component.onDestruction: {
                //console.debug("StackView.DeActivating");
            }//
        }//
    }//
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:2;height:480;width:800}
}
##^##*/
