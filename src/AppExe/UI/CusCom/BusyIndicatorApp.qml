/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0


AnimatedImage{
    id: busyAnim
    source: "BusyIndicatorApp/esco_loading_150x150.gif"
    playing: running && visible
    cache: false

    property int fullRotatedCycle: 0
    signal fullRotated(int cycle)
    signal rotationChanged(int cycle)

    property bool running: false
    property int loops: 1

    onCurrentFrameChanged: {
        if(busyAnim.currentFrame == (busyAnim.frameCount-1)){
            busyAnim.fullRotatedCycle += 1
            busyAnim.fullRotated(fullRotatedCycle)
        }
        //        busyAnim.rotationChanged(fullRotatedCycle)
        //        console.debug("frameCount:", busyAnim.frameCount, busyAnim.currentFrame)
    }
    //Component.onCompleted: console.debug("frameCount:", busyAnim.frameCount)
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
