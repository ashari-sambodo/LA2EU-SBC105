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

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Curve Test"

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
                    title: qsTr("Curve Test")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Rectangle{
                    id: ref
                    anchors.fill: parent
                    color: "#99333333"
                    border.width: 1
                    property var modelX: []
                    property var modelY: [0.45,0.44,0.43,0.40,0,40,0.45,0.44,0.43,0.40,0,40,0.45,0.44,0.43,0.40,0,40,0.45,0.44,0.43,0.40,0,40,0.45,0.44,0.43,0.40,0,40,0.45,0.44,0.43,0.40,0,40,0.45,0.44,0.43,0.40,0,40,0.45,0.44,0.43,0.40,0,40,0.45,0.44,0.43,0.40,0,40,0.45,0.44,0.43,0.40,0,40]
                    property real setpoint: 0.45
                    property real upperY: 1.0

                    Rectangle{id:overshootRect;visible:false;width:parent.width;height: 1;x:ref.x;y:ref.y+ref.height-100;color:"red"}
                    Rectangle{id:setpointRect;visible:false;width:parent.width;height: 1;x:ref.x;y:ref.y+ref.height-100;color:"green"}
                    Loader{
                        id: canvasLoader
                        active: false
                        anchors.fill: parent
                        sourceComponent: Canvas {
                            width: parent.width; height: parent.height
                            contextType: "2d"

                            Path {
                                id: myPath
                                startX: ref.x; startY: ref.y+ref.height

                                PathCurve { x: ref.x + ref.modelX[0];  y: ref.y+ref.height - ref.modelY[0] }
                                PathCurve { x: ref.x + ref.modelX[1];  y: ref.y+ref.height - ref.modelY[1] }
                                PathCurve { x: ref.x + ref.modelX[2];  y: ref.y+ref.height - ref.modelY[2] }
                                PathCurve { x: ref.x + ref.modelX[3];  y: ref.y+ref.height - ref.modelY[3] }
                                PathCurve { x: ref.x + ref.modelX[4];  y: ref.y+ref.height - ref.modelY[4] }
                                PathCurve { x: ref.x + ref.modelX[5];  y: ref.y+ref.height - ref.modelY[5] }
                                PathCurve { x: ref.x + ref.modelX[6];  y: ref.y+ref.height - ref.modelY[6] }
                                PathCurve { x: ref.x + ref.modelX[7];  y: ref.y+ref.height - ref.modelY[7] }
                                PathCurve { x: ref.x + ref.modelX[8];  y: ref.y+ref.height - ref.modelY[8] }
                                PathCurve { x: ref.x + ref.modelX[9];  y: ref.y+ref.height - ref.modelY[9] }
                                PathCurve { x: ref.x + ref.modelX[10];  y: ref.y+ref.height - ref.modelY[10] }
                                PathCurve { x: ref.x + ref.modelX[11];  y: ref.y+ref.height - ref.modelY[11] }
                                PathCurve { x: ref.x + ref.modelX[12];  y: ref.y+ref.height - ref.modelY[12] }
                                PathCurve { x: ref.x + ref.modelX[13];  y: ref.y+ref.height - ref.modelY[13] }
                                PathCurve { x: ref.x + ref.modelX[14];  y: ref.y+ref.height - ref.modelY[14] }
                                PathCurve { x: ref.x + ref.modelX[15];  y: ref.y+ref.height - ref.modelY[15] }
                                PathCurve { x: ref.x + ref.modelX[16];  y: ref.y+ref.height - ref.modelY[16] }
                                PathCurve { x: ref.x + ref.modelX[17];  y: ref.y+ref.height - ref.modelY[17] }
                                PathCurve { x: ref.x + ref.modelX[18];  y: ref.y+ref.height - ref.modelY[18] }
                                PathCurve { x: ref.x + ref.modelX[19];  y: ref.y+ref.height - ref.modelY[19] }
                                PathCurve { x: ref.x + ref.modelX[20];  y: ref.y+ref.height - ref.modelY[20] }
                                PathCurve { x: ref.x + ref.modelX[21];  y: ref.y+ref.height - ref.modelY[21] }
                                PathCurve { x: ref.x + ref.modelX[22];  y: ref.y+ref.height - ref.modelY[22] }
                                PathCurve { x: ref.x + ref.modelX[23];  y: ref.y+ref.height - ref.modelY[23] }
                                PathCurve { x: ref.x + ref.modelX[24];  y: ref.y+ref.height - ref.modelY[24] }
                                PathCurve { x: ref.x + ref.modelX[25];  y: ref.y+ref.height - ref.modelY[25] }
                                PathCurve { x: ref.x + ref.modelX[26];  y: ref.y+ref.height - ref.modelY[26] }
                                PathCurve { x: ref.x + ref.modelX[27];  y: ref.y+ref.height - ref.modelY[27] }
                                PathCurve { x: ref.x + ref.modelX[28];  y: ref.y+ref.height - ref.modelY[28] }
                                PathCurve { x: ref.x + ref.modelX[29];  y: ref.y+ref.height - ref.modelY[29] }
                                PathCurve { x: ref.x + ref.modelX[30];  y: ref.y+ref.height - ref.modelY[30] }
                                PathCurve { x: ref.x + ref.modelX[31];  y: ref.y+ref.height - ref.modelY[31] }
                                PathCurve { x: ref.x + ref.modelX[32];  y: ref.y+ref.height - ref.modelY[32] }
                                PathCurve { x: ref.x + ref.modelX[33];  y: ref.y+ref.height - ref.modelY[33] }
                                PathCurve { x: ref.x + ref.modelX[34];  y: ref.y+ref.height - ref.modelY[34] }
                                PathCurve { x: ref.x + ref.modelX[35];  y: ref.y+ref.height - ref.modelY[35] }
                                PathCurve { x: ref.x + ref.modelX[36];  y: ref.y+ref.height - ref.modelY[36] }
                                PathCurve { x: ref.x + ref.modelX[37];  y: ref.y+ref.height - ref.modelY[37] }
                                PathCurve { x: ref.x + ref.modelX[38];  y: ref.y+ref.height - ref.modelY[38] }
                                PathCurve { x: ref.x + ref.modelX[39];  y: ref.y+ref.height - ref.modelY[39] }
                                PathCurve { x: ref.x + ref.modelX[40];  y: ref.y+ref.height - ref.modelY[40] }
                                PathCurve { x: ref.x + ref.modelX[41];  y: ref.y+ref.height - ref.modelY[41] }
                                PathCurve { x: ref.x + ref.modelX[42];  y: ref.y+ref.height - ref.modelY[42] }
                                PathCurve { x: ref.x + ref.modelX[43];  y: ref.y+ref.height - ref.modelY[43] }
                                PathCurve { x: ref.x + ref.modelX[44];  y: ref.y+ref.height - ref.modelY[44] }
                                PathCurve { x: ref.x + ref.modelX[45];  y: ref.y+ref.height - ref.modelY[45] }
                                PathCurve { x: ref.x + ref.modelX[46];  y: ref.y+ref.height - ref.modelY[46] }
                                PathCurve { x: ref.x + ref.modelX[47];  y: ref.y+ref.height - ref.modelY[47] }
                                PathCurve { x: ref.x + ref.modelX[48];  y: ref.y+ref.height - ref.modelY[48] }
                                PathCurve { x: ref.x + ref.modelX[49];  y: ref.y+ref.height - ref.modelY[49] }
                            }

                            onPaint: {
                                context.strokeStyle = Qt.rgba(.9,.9,.9);
                                context.path = myPath;
                                context.stroke();
                            }//
                        }//
                        Component.onCompleted: {
                            var max = ref.modelY.reduce(function(a, b) {
                                return Math.max(a, b);
                            }, 0);
                            overshootRect.y = (ref.y+ref.height) - max

                            for(let i=1; i<=50; i++){
                                ref.modelX[i-1] = i*(ref.width/50)
                                ref.modelY[i-1] = ref.height*(ref.modelY[i-1]/ref.upperY)
                            }

                            canvasLoader.active = true

                            console.debug(max)
                            overshootRect.visible= true

                            setpointRect.y=(ref.y+ref.height) - (ref.height*(ref.setpoint / ref.upperY))
                            setpointRect.visible=true

                        }//
                    }//
                }

                //                RowLayout {
                //                    anchors.fill: parent

                //                    Item {
                //                        Layout.fillHeight: true
                //                        Layout.fillWidth: true

                //                    }//

                //                    Item {
                //                        Layout.fillHeight: true
                //                        Layout.fillWidth: true
                //                    }
                //                    //
                //                }//
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
