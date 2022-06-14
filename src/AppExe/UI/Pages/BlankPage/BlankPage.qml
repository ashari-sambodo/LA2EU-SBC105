/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Blank Page"

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
                    title: qsTr("Blank Page")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true


                //                RowLayout {
                //                    anchors.fill: parent

                //                    CurveTestPage{
                //                        id: curve1
                //                        Layout.fillHeight: true
                //                        Layout.fillWidth: true
                //                        title: qsTr("Downflow")
                //                    }
                //                    CurveTestPage{
                //                        id: curve2
                //                        Layout.fillHeight: true
                //                        Layout.fillWidth: true
                //                        title: qsTr("Inflow")
                //                    }//
                //                }//
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

//        MultiPointTouchArea {
//            anchors.fill: parent

//            touchPoints: [
//                TouchPoint {id: point1},
//                TouchPoint {id: point2},
//                TouchPoint {id: point3},
//                TouchPoint {id: point4},
//                TouchPoint {id: point5}
//            ]
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "red"
//            visible: point1.pressed
//            x: point1.x - (width / 2)
//            y: point1.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "green"
//            visible: point2.pressed
//            x: point2.x - (width / 2)
//            y: point2.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "blue"
//            visible: point3.pressed
//            x: point3.x - (width / 2)
//            y: point3.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "yellow"
//            visible: point4.pressed
//            x: point4.x - (width / 2)
//            y: point4.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "cyan"
//            visible: point5.pressed
//            x: point5.x - (width / 2)
//            y: point5.y - (height / 2)
//        }//

//        Column {
//            id: counter
//            anchors.centerIn: parent

//            TextApp {
//                anchors.horizontalCenter: parent.horizontalCenter
//                text: props.count
//                font.pixelSize: 48

//                TapHandler {
//                    onTapped: {
//                        props.count = props.countDefault
//                        counterTimer.restart()
//                    }//
//                }//
//            }//

//            TextApp {
//                font.pixelSize: 14
//                text: "Press number\nto count!"
//            }//
//        }//

//        Timer {
//            id: counterTimer
//            interval: 1000; repeat: true
//            onTriggered: {
//                let count = props.count
//                if (count <= 0) {
//                    counterTimer.stop()
//                }//
//                else {
//                    count = count - 1
//                    props.count = count
//                }//
//            }//
//        }//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/
