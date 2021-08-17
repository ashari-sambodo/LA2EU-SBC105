import QtQuick 2.0

Item {
    id: control
    Image {
        id: scrollDownImage
        source: "ScrollDownNotifApp/scroll-down-icon.png"
    }//

    SequentialAnimation {
        running: control.visible
        loops: Animation.Infinite
        NumberAnimation {target: scrollDownImage; property: "y"; from: 0; to: 10; duration: 200}
        NumberAnimation {target: scrollDownImage; property: "y"; from: 10; to: 0; duration: 200}
        PauseAnimation  {duration: 2000}
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
