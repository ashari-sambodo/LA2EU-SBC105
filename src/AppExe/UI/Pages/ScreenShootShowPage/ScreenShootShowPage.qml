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

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Screen Capture"

    background.sourceComponent: Rectangle {
        color: "#34495e"
    }

    content.asynchronous: true
    content.sourceComponent: ContentItemApp{
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
                    title: qsTr("Screen Capture")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillHeight: true
                Layout.fillWidth: true

                Image {
                    id: getPicScreenImage
                    cache: false
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
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

                        //                        ButtonBarApp {
                        //                            visible: false
                        //                            width: 194
                        //                            anchors.right: parent.right
                        //                            anchors.verticalCenter: parent.verticalCenter

                        //                            imageSource: "qrc:/UI/Pictures/bluetooth.png"
                        //                            text: qsTr("Share via Bluetooth")

                        //                            onClicked: {
                        //                                const pictureSource = String(getPicScreenImage.source)
                        //                                const sourceFilePath = pictureSource.replace("file:///C:", "c:")
                        //                                const intent = IntentApp.create("qrc:/UI/Pages/BluetoothFileTransfer/BluetoothFileTransfer.qml",
                        //                                                                {
                        //                                                                    "sourceFilePath": sourceFilePath
                        //                                                                });
                        //                                startView(intent);
                        //                            }//
                        //                        }//

                        ButtonBarApp {
                            x: 386
                            width: 194
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/usbvia.png"
                            text: qsTr("Share via USB")

                            onClicked: {
                                let pictureSource = String(getPicScreenImage.source)
                                if (__osplatform__) {
                                    /// linux
                                    pictureSource = pictureSource.replace("file://", "")
                                }
                                else {
                                    /// windows
                                    pictureSource = pictureSource.replace("file:///C:", "c:")
                                }
                                const intent = IntentApp.create("qrc:/UI/Pages/FileManagerUsbCopyPage/FileManagerUsbCopierPage.qml",
                                                                {
                                                                    "sourceFilePath": pictureSource
                                                                });
                                startView(intent);

                                //const pictureSource = String(getPicScreenImage.source)
                                //const sourceFilePath = pictureSource.replace("file:///C:", "c:")
                                //const intent = IntentApp.create("qrc:/UI/Pages/FileManagerUsbCopyPage/FileManagerUsbCopierPage.qml",
                                //                                {
                                //                                    "sourceFilePath": sourceFilePath
                                //                                });
                                //startView(intent);
                            }//
                        }//
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property string pictureLink: ""
        }

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible:  QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

                const extradata = IntentApp.getExtraData(intent)

                const getpicture = extradata['filename'] || ""

                console.debug(getpicture)

                props.pictureLink = getpicture

                getPicScreenImage.source = getpicture
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
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
