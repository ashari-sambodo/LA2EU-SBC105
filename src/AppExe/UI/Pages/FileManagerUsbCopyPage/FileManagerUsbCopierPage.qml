import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import Qt.labs.folderlistmodel 2.2

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.UsbCopier 1.0
import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "USB Export"

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
                                    color: "#e3dac9"
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
                                elide: Text.ElideMiddle
                                font.pixelSize: 16
                                text: qsTr("From") + ": " + props.sourceFilePath
                            }

                            TextApp {
                                id: destinationViewText
                                width: 300
                                //                                elide: Text.ElideMiddle
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                font.pixelSize: 16
                                text: qsTr("To") + ": /" + props.destinationPath
                            }
                        }
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
                            //rootFolder: "file:///" + MediaUSBStoragePath
                            //folder: "file://" + MediaUSBStoragePath
                            //                            showFiles: false

                            function goUp(){
                                //                                console.log(folder)
                                //                                console.log(rootFolder)
                                //                                console.log(parentFolder)

                                if (folder != rootFolder) {
                                    folder = parentFolder

                                    props.destinationPath = String(folder).replace("file://", "")
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
                                        color: "#e3dac9"
                                    }

                                    TextApp {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        leftPadding: 5
                                        verticalAlignment: Text.AlignVCenter

                                        text: qsTr("Select destination")
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
                                border.color: "#e3dac9"

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
                                            }
                                        }//

                                        Rectangle {
                                            anchors.bottom: parent.bottom
                                            height: 1
                                            width: parent.width
                                        }//

                                        MouseArea {
                                            anchors.fill: parent
                                            onPressed: {
                                                if (fileIsDir) {
                                                    // console.log("fileURL: " + fileURL)
                                                    folderListModel.folder = fileURL
                                                    if (__osplatform__) {
                                                        /// linux
                                                        props.destinationPath = String(fileURL).replace("file://", "")
                                                    }
                                                    else {
                                                        /// windows
                                                        props.destinationPath = String(fileURL).replace("file:///", "")
                                                    }
                                                    props.destinationFilePath = props.destinationPath + "/" + props.sourceFileName
                                                    //props.destinationPath = String(fileURL).replace("file:///", "")
                                                    //props.destinationFilePath = props.destinationPath + "/" + props.sourceFileName
                                                }//
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

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }//
                        }//

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Put here")

                            onClicked: {
                                if (folderListModel.isNowRootFolder()){
                                    showDialogMessage(qsTr("USB Export"), qsTr("Please select valid destination!"), dialogAlert)
                                    return
                                }

                                progressBar.visible = true
                                //props.sourceFilePath = "C:/Users/electronicsengineer8/dev/usbstorage/usb-sda1/Folder1/file.mp4"
                                //props.destinationFilePath = "C:/Users/electronicsengineer8/dev/usbstorage/usb-sda1/Folder2/file.mp4"
                                //let dest = props.destinationFilePath
                                //if(dest.charAt(0)!== '/')
                                //    props.destinationFilePath = "/" + props.destinationFilePath

                                usbCopier.copy(props.sourceFilePath, props.destinationFilePath)
                                //                                var intent = IntentApp.create(uri, {"message":""})
                                //                                finishView(intent)
                            }//
                        }//
                    }//
                }//
            }//
        }//

        USBCopier {
            id: usbCopier

            onFileHasCopied: {
                //                console.log("onHasCopied")
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property string sourceFilePath: ""
            property string sourceFileName: ""
            property string destinationPath: ""
            property string destinationFilePath: ""
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
                const _sourceFilePath = extraData['sourceFilePath'] || ""

                props.sourceFilePath = _sourceFilePath

                let fileNameGet = _sourceFilePath.split("/")
                props.sourceFileName = fileNameGet[fileNameGet.length - 1]
                //                    console.log(props.sourceFileName)
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
