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
    title: "Vivarium Mute"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        /// just for development
        /// comment following line after release
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
                    title: qsTr("Vivarium Mute")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true


                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 10

                        Image {
                            source: "qrc:/UI/Pictures/vivarium-mute-ilus.png"
                            width: 250
                            fillMode: Image.PreserveAspectFit
                        }

                        TextApp {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 400
                            wrapMode: Text.WordWrap
                            text: qsTr("Basically, audible alarm is not muteable when sash alarm occurred.") + "<br><br>" +
                                  qsTr("Vivarium mute allows you to pre-mute an audio alarm and remain silent when the user move the sash to unsafe height.")
                        }//
                    }//

                    ButtonBarApp {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 300

                        imageSource: "qrc:/UI/Pictures/mute-icon-35p.png"
                        text: qsTr("Start Vivarium Mute")

                        onClicked: {
                            MachineAPI.setMuteVivariumState(true);

                            var intent = IntentApp.create(uri, {})
                            finishView(intent)
                        }
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
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int countDefault: 50
            property int count: 50
        }//

        /// One time executed after onResume
        Component.onCompleted: {

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
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.75;height:480;width:800}
}
##^##*/
