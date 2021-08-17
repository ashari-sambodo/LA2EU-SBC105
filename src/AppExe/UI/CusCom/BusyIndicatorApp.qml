/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0


Image {
    id: busyImage
    source: "BusyIndicatorApp/BusyIndicatorApp_Symbol.png"

    property int fullRotatedCycle: 0
    signal fullRotated(int cycle)

    property alias running: animSequentialAnimation.running
    property alias loops: animSequentialAnimation.loops

    SequentialAnimation {
        id: animSequentialAnimation
        //        running: true
        //        loops: Animation.Infinite
        PropertyAnimation {duration: 500; target: busyImage; property: "rotation"; from: 0; to: 360}
        PauseAnimation{duration: 500}
        //        PropertyAnimation {duration: 150; target: busyImage; property: "rotation"; from: 0; to: 90}
        //        PauseAnimation{duration: 125}
        //        PropertyAnimation {duration: 125; target: busyImage; property: "rotation"; from: 90; to: 180}
        //        PauseAnimation{duration: 125}
        //        PropertyAnimation {duration: 125; target: busyImage; property: "rotation"; from: 180; to: 270}
        //        PauseAnimation{duration: 125}
        //        PropertyAnimation {duration: 125; target: busyImage; property: "rotation"; from: 270; to: 360}
        //        PauseAnimation{duration: 125}
        ScriptAction{
            script: {
                fullRotatedCycle = fullRotatedCycle + 1
                busyImage.fullRotated(fullRotatedCycle)
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
