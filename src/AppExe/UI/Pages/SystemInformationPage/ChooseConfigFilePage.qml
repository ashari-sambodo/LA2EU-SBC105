/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Ahmad Qodri
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7
import Qt.labs.folderlistmodel 2.2

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.UsbCopier 1.0
import ModulesCpp.Machine 1.0
//import ModulesCpp.ImportExternalConfiguration 1.0

ViewApp {
    id: viewApp

    title: "USB Import"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        /// just for development
        /// comment following line after release
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
                    title: qsTr("USB Import")
                }//
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Column {
                            anchors.centerIn: parent
                            spacing: 5

                            Image {
                                anchors.horizontalCenter: parent.horizontalCenter
                                source: "qrc:/UI/Pictures/copy-thumbnail.png"
                            }

                            ProgressBar {
                                id: progressBar
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: 300
                                height: 20
                                to: 100
                                value: usbCopier.progressInPercent
                                visible: false

                                background: Rectangle {
                                    implicitWidth: 300
                                    implicitHeight: 10
                                    color: "#effffd"
                                    radius: 2
                                    clip: true
                                }//

                                contentItem: Item {
                                    implicitWidth: 250
                                    implicitHeight: 10

                                    Rectangle {
                                        width: progressBar.visualPosition * parent.width
                                        height: parent.height
                                        radius: 2
                                        color: "#18AA00"
                                    }//

                                    Text {
                                        anchors.centerIn: parent
                                        text: progressBar.value + "%"
                                    }
                                }//
                            }//
                            TextApp {
                                id: sourceViewText
                                width: 300
                                //elide: Text.ElideMiddle
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                font.pixelSize: 16
                                text: qsTr("From") + ": " + props.sourceFilePath
                            }

                            TextApp {
                                id: destinationViewText
                                width: 300
                                elide: Text.ElideMiddle
                                //wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                font.pixelSize: 16
                                text: qsTr("To") + ": " + props.destinationPath
                            }
                        }//
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        enabled: !usbCopier.copying

                        /// Handle File and Directory Model
                        FolderListModel {
                            id: folderListModel
                            showDirs: true
                            showDirsFirst: true
                            nameFilters: [ props.fileFilter ]
                            //rootFolder: "file:///" + MediaUSBStoragePath
                            //folder: "file://" + MediaUSBStoragePath
                            //                            showFiles: false

                            function goUp(){
                                //                                console.log(folder)
                                //                                console.log(rootFolder)
                                //                                console.log(parentFolder)

                                if (folder != rootFolder) {
                                    folder = parentFolder

                                    props.sourcePath = String(folder).replace("file://", "")
                                }
                            }

                            function isNowRootFolder(){
                                return folder === rootFolder
                            }
                            Component.onCompleted: {
                                if (__osplatform__) {
                                    /// linux
                                    rootFolder = "file://" + MediaUSBStoragePath
                                    folder = rootFolder
                                }
                                else {
                                    /// windows
                                    rootFolder = "file:///" + MediaUSBStoragePath
                                    folder = rootFolder
                                }
                            }
                        }//

                        /// File-Manager Presentation

                        ColumnLayout {
                            anchors.fill: parent

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.minimumHeight: 40
                                color:dstMouseArea.pressed ? "#000000" : /*"#55000000"*/"#1F95D7"
                                border.color: "white"
                                radius: 5

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 0

                                    Image {
                                        Layout.fillHeight: true
                                        Layout.maximumWidth: height
                                        source: "qrc:/UI/Pictures/up-side.png"
                                    }//

                                    Rectangle {
                                        Layout.fillHeight: true
                                        Layout.minimumWidth: 1
                                        color: "#effffd"
                                    }

                                    TextApp {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        leftPadding: 5
                                        verticalAlignment: Text.AlignVCenter

                                        text: qsTr("Select Config file")
                                    }//
                                }//

                                MouseArea {
                                    id: dstMouseArea
                                    anchors.fill: parent
                                    onClicked: {
                                        folderListModel.goUp()
                                    }
                                }

                            }//

                            Rectangle {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                radius: 5
                                color: "#55000000"
                                border.color: "#effffd"

                                ListView {
                                    id: fileManagerListView
                                    anchors.fill: parent

                                    clip: true
                                    model: folderListModel

                                    TextApp {
                                        anchors.centerIn: parent
                                        visible: fileManagerListView.count == 0
                                        text: qsTr("Empty")
                                    }//

                                    delegate: Item {
                                        height: 40
                                        width: fileManagerListView.width

                                        RowLayout {
                                            anchors.fill: parent
                                            spacing: 0

                                            Image {
                                                id: iconImage
                                                Layout.minimumHeight: 40
                                                Layout.minimumWidth: 40
                                                source: fileIsDir ? "qrc:/UI/Pictures/fileIsDir" : "qrc:/UI/Pictures/file-icon"
                                            }

                                            TextApp {
                                                Layout.fillHeight: true
                                                Layout.fillWidth: true
                                                verticalAlignment: Text.AlignVCenter
                                                text: fileName
                                                elide: Text.ElideRight
                                            }
                                            Item{
                                                visible: String(props.fileSelected) == String(fileName)
                                                Layout.minimumHeight: 40
                                                Layout.minimumWidth: 40
                                                Image {
                                                    id: selectedIcon
                                                    anchors.fill: parent
                                                    source: "qrc:/UI/Pictures/checkicon.png"
                                                }
                                            }
                                        }//

                                        Rectangle {
                                            anchors.bottom: parent.bottom
                                            height: 1
                                            width: parent.width
                                        }//

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                console.log("fileURL: " + fileUrl, "filename:", fileName)
                                                if (fileIsDir) {
                                                    folderListModel.folder = fileUrl
                                                }
                                                if (__osplatform__) {
                                                    /// linux
                                                    props.sourcePath = String(fileUrl).replace("file://", "")
                                                }
                                                else {
                                                    /// windows
                                                    props.sourcePath = String(fileUrl).replace("file:///", "")
                                                }
                                                props.sourceFilePath = props.sourcePath

                                                const extension = props.sourceFilePath.split('.').pop();

                                                if(extension === "conf"/* || extension === "CONF"*/){
                                                    props.fileSelected = fileName
                                                    importButton.visible = true
                                                }
                                                else
                                                    importButton.visible = false

                                                //console.debug("sourceFilePath: " + props.sourceFilePath)
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
                            id: importButton
                            visible: false
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Import")

                            onClicked: {
                                let re = /(?:\.([^.]+))?$/;
                                let extension = re.exec(props.sourceFilePath)[1]
                                console.debug("Extension:", extension)

                                if (String(extension) != String("conf")/* && String(extension) != String("CONF")*/){
                                    showDialogMessage(qsTr("USB Import"), qsTr("Please select valid source file!"), dialogAlert)
                                    return
                                }

                                const message = qsTr("Are you sure want to import %1 as a new settings?").arg(props.fileSelected)
                                viewApp.showDialogAsk(qsTr("Notification"),
                                                      message,
                                                      viewApp.dialogInfo,
                                                      function onAccepted(){
                                                          viewApp.showBusyPage(qsTr("Copying..."), function onCallback(cycle){
                                                              if (cycle === 1){
                                                                  if(!progressBar.visible) progressBar.visible = true

                                                                  usbCopier.copy(props.sourceFilePath, props.destinationFilePath, false)
                                                                  viewApp.closeDialog()
                                                              }
                                                          })
                                                      }, function(){}, function(){}, true, 5)//

                            }//
                        }//
                    }//
                }//
            }//
        }//

        USBCopier {
            id: usbCopier

            onFileHasCopied: {
                MachineAPI.setSomeSettingsAfterExtConfigImported()
                viewApp.showDialogMessage(qsTr("Import"),
                                          qsTr("New Configuration file has been imported"),
                                          viewApp.dialogInfo,
                                          function onClosed(){
                                              const intent = IntentApp.create("qrc:/UI/Pages/ClosingPage/ClosingPage.qml", {})
                                              startView(intent);
                                          })
            }//
        }//
        //        ImportExternalConfiguration{
        //            id: importConfig
        //        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property string sourceFilePath: ""
            property string sourcePath: ""
            property string fileSelected: ""

            property string fileFilter: "%1.conf".arg(Qt.application.name)
            property string destinationPath: "/home/root/.config/escolifesciences/"
            property string destinationFilePath: destinationPath + "%1".arg(fileFilter)
        }//

        /// One time executed after onResume
        Component.onCompleted: {
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {

            }//
            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//
