import QtQuick 2.0

Canvas {
    id: drawCanvas

    property int prevX
    property int prevY
    property int lineWidth: 2
    property string drawColor: "#000000"

    property bool firstLoad: true
    property var arrpoints : []

    MouseArea {
        id: mousearea
        anchors.fill: parent
        onPressed: {drawCanvas.prevX = mouseX ; drawCanvas.prevY = mouseY}
        onPositionChanged: drawCanvas.requestPaint()
    }//

    onPaint: {
        var ctx = drawCanvas.getContext("2d");
        ctx.beginPath();
        ctx.strokeStyle = drawColor
        ctx.lineWidth = lineWidth
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
