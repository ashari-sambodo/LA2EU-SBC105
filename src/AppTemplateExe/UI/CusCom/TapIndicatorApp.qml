import QtQuick 2.0

Item {
    id: tapIndicatorItem

    property int duration: 200
    property int delayHide: 50
    property int delayHideTime: duration + delayHide

    Rectangle {
        id: indicateRectangle
        height: 70
        width: 70
        radius: 35
        visible: false
        opacity: visible
        color: "#70dddddd"

        Behavior on opacity {
            PropertyAnimation {
                target:indicateRectangle;
                duration: tapIndicatorItem.duration;
                property: "scale";
                from: 0.7;
                to: 1.0
                //                onStopped: console.log("hello")
            }
        }

        Timer {
            id: indicatorAutoHideTimer
            running: false
            interval: tapIndicatorItem.delayHideTime
            onTriggered: {
                indicateRectangle.visible = false
                indicatorAutoHideTimer.stop()
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onPressed: {
            indicateRectangle.visible = false
            indicateRectangle.x = mouseArea.mouseX - (indicateRectangle.width / 2)
            indicateRectangle.y = mouseArea.mouseY - (indicateRectangle.height / 2)
            indicateRectangle.visible = true
            indicatorAutoHideTimer.restart()
            mouse.accepted = false
        }
    }
}
