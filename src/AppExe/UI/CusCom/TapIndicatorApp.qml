import QtQuick 2.12

Item {
    id: tapIndicatorItem

    property int duration: 100
    property int delayHide: 50
    property int delayHideTime: duration + delayHide

    signal pressed()

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
                from: 0.9;
                to: 1.0
                //                onStopped: //console.debug("hello")
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

    //    TapHandler {
    //        id: tapHandler
    //        onPressedChanged: {
    //            if(pressed) {
    //                indicateRectangle.visible = false
    //                indicateRectangle.x = tapHandler.point.position.x - (indicateRectangle.width / 2)
    //                indicateRectangle.y = tapHandler.point.position.y - (indicateRectangle.height / 2)
    //                indicateRectangle.visible = true
    //                indicatorAutoHideTimer.restart()

    //                tapIndicatorItem.pressed()
    //            }//
    //        }//

    //        //        onTapped: {
    //        //            //console.debug("tapped", eventPoint.event.device.name,
    //        //                        "button", eventPoint.event.button,
    //        //                        "@", eventPoint.scenePosition)
    //        //        }//
    //    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        propagateComposedEvents: true
        onPressed: {
            indicateRectangle.visible = false
            indicateRectangle.x = mouseArea.mouseX - (indicateRectangle.width / 2)
            indicateRectangle.y = mouseArea.mouseY - (indicateRectangle.height / 2)
            indicateRectangle.visible = true
            indicatorAutoHideTimer.restart()

            tapIndicatorItem.pressed()

            mouse.accepted = false
        }
    }
}
