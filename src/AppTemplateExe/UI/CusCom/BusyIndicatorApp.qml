import QtQuick 2.0


Image {
    id: busyImage
    source: "BusyIndicatorApp/BusyIndicatorApp_Symbol.png"

    property alias running: animSequentialAnimation.running
    property alias loops: animSequentialAnimation.loops

    SequentialAnimation {
        id: animSequentialAnimation
        //        running: true
        //        loops: Animation.Infinite
        PropertyAnimation {target: busyImage; property: "rotation"; from: 0; to: 90}
        PauseAnimation{duration: 500}
        PropertyAnimation {target: busyImage; property: "rotation"; from: 90; to: 180}
        PauseAnimation{duration: 500}
        PropertyAnimation {target: busyImage; property: "rotation"; from: 180; to: 270}
        PauseAnimation{duration: 500}
        PropertyAnimation {target: busyImage; property: "rotation"; from: 270; to: 360}
        PauseAnimation{duration: 500}
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
