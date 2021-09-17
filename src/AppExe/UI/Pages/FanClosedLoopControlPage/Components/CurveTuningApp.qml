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

Item {
    id: curve

    property alias title: title.text
    property var modelX: []
    property var modelY: [0.35,0.40,0.43,0.45,0.43,0.45,0.40,0.43,0.40,0.40,0.45,0.44,0.43,0.40,0.40,0.45,0.44,0.43,0.40,0.40,0.45,0.44,0.43,0.40,0.40,0.45,0.44,0.43,0.40,0.40,0.45,0.44,0.43,0.40,0.40,0.45,0.44,0.43,0.40,0.40,0.45,0.44,0.43,0.40,0.40,0.45,0.44,0.43,0.40,0.40,0.45,0.44,0.43,0.40,0.40,0.45,0.44,0.43,0.40,0.40]
    property real kp: 0.0
    property real ki: 0.0
    property real kd: 0.0
    property real setpoint: 0.40
    property real upperY: 1.0
    property int noOfSample: 60
    property real overshoot: 0.0
    property int samplingTime:1000
    property int settlingTime: 1000
    property int riseTime: 1000

    Rectangle{
        id: control
        x: curve.x
        y: curve.y
        anchors.fill: parent
        color: "#99333333"
        border.width: 1
        z: -1
    }//
    Column{
        id: colText
        x: control.x + 5
        y: control.y + 5
        TextApp{id:title;text:"---"; font.pixelSize: 16}
        Row{
            id: rowText
            ////
            Column{
                TextApp{text:"KP"; font.pixelSize: 16}
                TextApp{text:"KI"; font.pixelSize: 16}
                TextApp{text:"KD"; font.pixelSize: 16}
            }
            Column{
                TextApp{text:": "; font.pixelSize: 16}
                TextApp{text:": "; font.pixelSize: 16}
                TextApp{text:": "; font.pixelSize: 16}
            }
            Column{
                TextApp{text:"%1".arg(curve.kp.toFixed(2)); font.pixelSize: 16}
                TextApp{text:"%1".arg(curve.ki.toFixed(2)); font.pixelSize: 16}
                TextApp{text:"%1".arg(curve.kd.toFixed(2)); font.pixelSize: 16}
            }
            ///
            Rectangle{height: rowText.height;width: 20;color: "transparent"}
            ///
            Column{
                TextApp{text:qsTr("Setpoint"); font.pixelSize: 16}
                TextApp{text:qsTr("Overshoot"); font.pixelSize: 16}
                TextApp{text:qsTr("No. of Sample"); font.pixelSize: 16}
            }
            Column{
                TextApp{text:": "; font.pixelSize: 16}
                TextApp{text:": "; font.pixelSize: 16}
                TextApp{text:": "; font.pixelSize: 16}
            }
            Column{
                TextApp{text:"%1 m/s".arg(curve.setpoint.toFixed(2)); color: setpointRect.color; font.pixelSize: 16}
                TextApp{text:"%1 m/s".arg(curve.overshoot.toFixed(2)); color: overshootRect.color; font.pixelSize: 16}
                TextApp{text:"%1".arg(curve.noOfSample); font.pixelSize: 16}
            }
            ///
            Rectangle{height: rowText.height;width: 20;color: "transparent"}
            ////
            Column{
                TextApp{text:qsTr("Sampling Time"); font.pixelSize: 16}
                TextApp{text:qsTr("Rise Time"); font.pixelSize: 16}
                TextApp{text:qsTr("Settling Time"); font.pixelSize: 16}
            }
            Column{
                TextApp{text:": "; font.pixelSize: 16}
                TextApp{text:": "; font.pixelSize: 16}
                TextApp{text:": "; font.pixelSize: 16}
            }
            Column{
                TextApp{text:"%1 ms".arg(curve.samplingTime); font.pixelSize: 16}
                TextApp{text:"%1 ms".arg(curve.riseTime); font.pixelSize: 16}
                TextApp{text:"%1 ms".arg(curve.settlingTime); font.pixelSize: 16}
            }

        }//
    }//

    Rectangle{
        id:overshootRect;
        visible:false;
        width:parent.width;
        height: 1;
        x:control.x;
        y:control.y+control.height-100;
        color:"red"
    }//

    Rectangle{
        id:setpointRect;
        visible:false;
        width:parent.width;
        height: 1;
        x:control.x;
        y:control.y+control.height-100;
        color:"green"

    }//

    Loader{
        id: canvasLoader
        active: false
        anchors.fill: parent
        sourceComponent: Canvas {
            width: parent.width; height: parent.height
            contextType: "2d"

            Path {
                id: myPath
                startX: control.x; startY: control.y+control.height

                PathCurve { x: control.x + curve.modelX[0];  y: control.y+control.height - curve.modelY[0] }
                PathCurve { x: control.x + curve.modelX[1];  y: control.y+control.height - curve.modelY[1] }
                PathCurve { x: control.x + curve.modelX[2];  y: control.y+control.height - curve.modelY[2] }
                PathCurve { x: control.x + curve.modelX[3];  y: control.y+control.height - curve.modelY[3] }
                PathCurve { x: control.x + curve.modelX[4];  y: control.y+control.height - curve.modelY[4] }
                PathCurve { x: control.x + curve.modelX[5];  y: control.y+control.height - curve.modelY[5] }
                PathCurve { x: control.x + curve.modelX[6];  y: control.y+control.height - curve.modelY[6] }
                PathCurve { x: control.x + curve.modelX[7];  y: control.y+control.height - curve.modelY[7] }
                PathCurve { x: control.x + curve.modelX[8];  y: control.y+control.height - curve.modelY[8] }
                PathCurve { x: control.x + curve.modelX[9];  y: control.y+control.height - curve.modelY[9] }
                PathCurve { x: control.x + curve.modelX[10];  y: control.y+control.height - curve.modelY[10] }
                PathCurve { x: control.x + curve.modelX[11];  y: control.y+control.height - curve.modelY[11] }
                PathCurve { x: control.x + curve.modelX[12];  y: control.y+control.height - curve.modelY[12] }
                PathCurve { x: control.x + curve.modelX[13];  y: control.y+control.height - curve.modelY[13] }
                PathCurve { x: control.x + curve.modelX[14];  y: control.y+control.height - curve.modelY[14] }
                PathCurve { x: control.x + curve.modelX[15];  y: control.y+control.height - curve.modelY[15] }
                PathCurve { x: control.x + curve.modelX[16];  y: control.y+control.height - curve.modelY[16] }
                PathCurve { x: control.x + curve.modelX[17];  y: control.y+control.height - curve.modelY[17] }
                PathCurve { x: control.x + curve.modelX[18];  y: control.y+control.height - curve.modelY[18] }
                PathCurve { x: control.x + curve.modelX[19];  y: control.y+control.height - curve.modelY[19] }
                PathCurve { x: control.x + curve.modelX[20];  y: control.y+control.height - curve.modelY[20] }
                PathCurve { x: control.x + curve.modelX[21];  y: control.y+control.height - curve.modelY[21] }
                PathCurve { x: control.x + curve.modelX[22];  y: control.y+control.height - curve.modelY[22] }
                PathCurve { x: control.x + curve.modelX[23];  y: control.y+control.height - curve.modelY[23] }
                PathCurve { x: control.x + curve.modelX[24];  y: control.y+control.height - curve.modelY[24] }
                PathCurve { x: control.x + curve.modelX[25];  y: control.y+control.height - curve.modelY[25] }
                PathCurve { x: control.x + curve.modelX[26];  y: control.y+control.height - curve.modelY[26] }
                PathCurve { x: control.x + curve.modelX[27];  y: control.y+control.height - curve.modelY[27] }
                PathCurve { x: control.x + curve.modelX[28];  y: control.y+control.height - curve.modelY[28] }
                PathCurve { x: control.x + curve.modelX[29];  y: control.y+control.height - curve.modelY[29] }
                PathCurve { x: control.x + curve.modelX[30];  y: control.y+control.height - curve.modelY[30] }
                PathCurve { x: control.x + curve.modelX[31];  y: control.y+control.height - curve.modelY[31] }
                PathCurve { x: control.x + curve.modelX[32];  y: control.y+control.height - curve.modelY[32] }
                PathCurve { x: control.x + curve.modelX[33];  y: control.y+control.height - curve.modelY[33] }
                PathCurve { x: control.x + curve.modelX[34];  y: control.y+control.height - curve.modelY[34] }
                PathCurve { x: control.x + curve.modelX[35];  y: control.y+control.height - curve.modelY[35] }
                PathCurve { x: control.x + curve.modelX[36];  y: control.y+control.height - curve.modelY[36] }
                PathCurve { x: control.x + curve.modelX[37];  y: control.y+control.height - curve.modelY[37] }
                PathCurve { x: control.x + curve.modelX[38];  y: control.y+control.height - curve.modelY[38] }
                PathCurve { x: control.x + curve.modelX[39];  y: control.y+control.height - curve.modelY[39] }
                PathCurve { x: control.x + curve.modelX[40];  y: control.y+control.height - curve.modelY[40] }
                PathCurve { x: control.x + curve.modelX[41];  y: control.y+control.height - curve.modelY[41] }
                PathCurve { x: control.x + curve.modelX[42];  y: control.y+control.height - curve.modelY[42] }
                PathCurve { x: control.x + curve.modelX[43];  y: control.y+control.height - curve.modelY[43] }
                PathCurve { x: control.x + curve.modelX[44];  y: control.y+control.height - curve.modelY[44] }
                PathCurve { x: control.x + curve.modelX[45];  y: control.y+control.height - curve.modelY[45] }
                PathCurve { x: control.x + curve.modelX[46];  y: control.y+control.height - curve.modelY[46] }
                PathCurve { x: control.x + curve.modelX[47];  y: control.y+control.height - curve.modelY[47] }
                PathCurve { x: control.x + curve.modelX[48];  y: control.y+control.height - curve.modelY[48] }
                PathCurve { x: control.x + curve.modelX[49];  y: control.y+control.height - curve.modelY[49] }
                PathCurve { x: control.x + curve.modelX[50];  y: control.y+control.height - curve.modelY[50] }
                PathCurve { x: control.x + curve.modelX[51];  y: control.y+control.height - curve.modelY[51] }
                PathCurve { x: control.x + curve.modelX[52];  y: control.y+control.height - curve.modelY[52] }
                PathCurve { x: control.x + curve.modelX[53];  y: control.y+control.height - curve.modelY[53] }
                PathCurve { x: control.x + curve.modelX[54];  y: control.y+control.height - curve.modelY[54] }
                PathCurve { x: control.x + curve.modelX[55];  y: control.y+control.height - curve.modelY[55] }
                PathCurve { x: control.x + curve.modelX[56];  y: control.y+control.height - curve.modelY[56] }
                PathCurve { x: control.x + curve.modelX[57];  y: control.y+control.height - curve.modelY[57] }
                PathCurve { x: control.x + curve.modelX[58];  y: control.y+control.height - curve.modelY[58] }
                PathCurve { x: control.x + curve.modelX[59];  y: control.y+control.height - curve.modelY[59] }
            }//

            onPaint: {
                context.strokeStyle = Qt.rgba(.9,.9,.9);
                context.path = myPath;
                context.stroke();
            }//
        }//

        Component.onCompleted: {
            var max = curve.modelY.reduce(function(a, b) {
                return Math.max(a, b);
            }, 0);
            curve.overshoot = max

            for(let i=1; i<=curve.noOfSample; i++){
                curve.modelX[i-1] = i*(control.width/curve.noOfSample)
                curve.modelY[i-1] = control.height*(curve.modelY[i-1] / curve.upperY)
            }

            overshootRect.y = (control.y+control.height) - (control.height*(max / curve.upperY))

            canvasLoader.active = true
            console.debug("height :", control.height)
            console.debug("width  :", control.width)
            console.debug("up limit vel:",curve.upperY)
            console.debug("max velocity:",max)
            console.debug("coordinat max velocity:",control.height*(max / curve.upperY))
            console.debug("sp velocity:",curve.setpoint)
            console.debug("coordinat sp velocity:",control.height*(curve.setpoint / curve.upperY))
            overshootRect.visible= true

            setpointRect.y=(control.y+control.height) - (control.height*(curve.setpoint / curve.upperY))
            setpointRect.visible=true

        }//
    }//
    Component.onCompleted: {
        //        console.debug("x:", curve.x)
        //        console.debug("y:", curve.y)
    }//
}//

