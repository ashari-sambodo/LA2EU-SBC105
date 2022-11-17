
import QtQuick 2.0

Canvas {
    id: drawCanvas

    property int prevX
    property int prevY
    property int lineWidth: 4
    property string drawColor: "#000000"

    property bool firstLoad: true
    property var arrpoints : []


    MouseArea {
        id: mousearea
        anchors.fill: parent
        onPressed: {
            //console.debug("start x:%1,y:%2".arg(mouseX).arg(mouseY))
            drawCanvas.prevX = mouseX
            drawCanvas.prevY = mouseY
        }
        onPositionChanged: {
            drawCanvas.requestPaint()
        }
    }//

    onPaint: {
        var ctx = drawCanvas.getContext("2d");
        ctx.beginPath();
        ctx.strokeStyle = drawColor
        ctx.lineWidth = lineWidth
        ctx.lineJoin = "round"
        //console.debug("x:%1,y%2: x1:%3,y1:%4".arg(prevX).arg(prevY).arg(mousearea.mouseX).arg(mousearea.mouseY))
        ctx.moveTo(prevX, prevY);
        ctx.lineTo(mousearea.mouseX, mousearea.mouseY);
        ctx.stroke();
        ctx.closePath();
        prevX = mousearea.mouseX;
        prevY = mousearea.mouseY;
    }//

    function clear(){
        var ctx = drawCanvas.getContext('2d')
        ctx.reset()
        drawCanvas.requestPaint()
    }//
}//

//Canvas {
//    id: drawCanvas
//    property int prevX
//    property int prevY
//    property int lineWidth: 4
//    property color drawColor: "#000000"

//    MouseArea {
//        id:mousearea
//        anchors.fill: parent
//        onPressed: {prevX = mouseX ; prevY = mouseY}
//        onPositionChanged: requestPaint();
//    }

//    onPaint: {
//        var ctx = getContext('2d');
//        ctx.beginPath();
//        ctx.strokeStyle = drawColor
//        ctx.lineWidth = lineWidth
//        ctx.moveTo(prevX, prevY);
//        ctx.lineTo(mousearea.mouseX, mousearea.mouseY);
//        ctx.stroke();
//        ctx.closePath();
//        prevX = mousearea.mouseX;
//        prevY = mousearea.mouseY;
//    }

//    function clear(){
//        var ctx = drawCanvas.getContext('2d')
//        ctx.reset()
//        drawCanvas.requestPaint()
//    }//
//}
