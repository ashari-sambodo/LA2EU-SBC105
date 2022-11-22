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

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0
import ModulesCpp.FileReader 1.0

ViewApp {
    id: viewApp
    title: "Software License"

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
                    title: qsTr("Software License")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                Rectangle{
                    color: "#66000000"
                    anchors.fill: parent
                    radius: 5
                    border.width: 1
                    border.color: "#e3dac9"
                    z : -1
                }
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 5

                    Flickable {
                        id: view
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        //                        anchors.fill: parent
                        //                        anchors.margins: 2
                        contentWidth: content.width
                        contentHeight: content.height
                        property real span : contentY + height
                        clip: true

                        flickableDirection: Flickable.VerticalFlick
                        ScrollBar.vertical: verticalScrollBar.scrollBar
                        TextApp {
                            id: content
                            width: parent.width
                            //height: parent.height
                            leftPadding: 150
                            topPadding: 10
                            rightPadding: 10
                            bottomPadding: 10
                            wrapMode: Text.WrapAnywhere
                            text: props.textToDisplay1 + "\n\n\n" + props.textToDisplay2
                        }//
                    }//
                    ScrollBarApp {
                        id: verticalScrollBar
                        Layout.fillHeight: true
                        Layout.minimumWidth: 20
                        Layout.fillWidth: false
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
                            id: setButton
                            width: 194
                            visible: false
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Next")

                            onClicked: {
                                //                                currentTimeZoneText.text = currentTimeZoneText.text + "AAAA-"
                                /// if this page called from welcome page
                                /// show this button to making more mantap
                                var intent = IntentApp.create(uri, {"welcomesetupdone": 1})
                                finishView(intent)
                            }//
                        }//
                    }//
                }//
            }//
        }//

        FileReader{
            id: lgpl3

            onFileOutputChanged: {
                props.textToDisplay1 = value;
            }

            Component.onCompleted: {
                setFilePath(":/UI/Pages/SoftwareLicensePage/lgpl-3.0.txt")
                readFile()
            }
        }

        FileReader{
            id: gpl3

            onFileOutputChanged: {
                props.textToDisplay2 = value;
            }

            Component.onCompleted: {
                setFilePath(":/UI/Pages/SoftwareLicensePage/gpl-3.0.txt")
                readFile()
            }
        }

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property string textToDisplay1: ""
            property string textToDisplay2: ""

        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                const extraData = IntentApp.getExtraData(intent)
                const thisOpenedFromWelcomePage = extraData["welcomesetup"] || false
                if(thisOpenedFromWelcomePage) {
                    setButton.visible = true

                    viewApp.enabledSwipedFromLeftEdge   = false
                    viewApp.enabledSwipedFromRightEdge  = false
                    viewApp.enabledSwipedFromBottomEdge = false
                }//
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
