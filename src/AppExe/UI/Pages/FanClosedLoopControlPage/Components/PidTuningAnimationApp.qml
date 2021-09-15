import QtQuick 2.0
import UI.CusCom 1.0

Item {
    id: control
    //anchors.fill: parent
    implicitHeight: 300
    implicitWidth: 400
    enabled: true

    property bool running: false

    property int delayPerFrame: 100
    property int delayAfterComplete: 2500
    property int noOfFrames: 250

    property string imageSource: "qrc:/GeneralResources/Animation/TuningPID/frame_%1_delay-%2s.gif"
    property int imageSourceState: 0
    property int state : 0

    onEnabledChanged: {
        if(!enabled){
            timer.running = false
            timer1.running = false
            image.visible = false
        }
    }
    //0:2.50s,99:2.00s,174:2.00s,249:2.50s
    //    Image{
    //        visible: control.running
    //        source: "qrc:/GeneralResources/Animation/TuningPID/frame_bkg.png"
    //        fillMode: Image.PreserveAspectFit
    //        height: control.height
    //    }
    Image{
        id: image
        //asynchronous: true
        visible: control.running
        source: imageSource.arg(utils.fixStrLength(String(imageSourceState), 3, "0", 1)).arg((imageSourceState == 0 || imageSourceState == 249) ? "2.50" : ((imageSourceState == 99 || imageSourceState == 174) ? "2.00" : "0.05"))
        onSourceChanged: console.debug(source)
        fillMode: Image.PreserveAspectFit
        height: control.height
    }

    Timer {
        id: timer
        running: control.running
        interval: delayPerFrame
        repeat: true
        onTriggered: {
            state++
            if(state == noOfFrames-1){
                imageSourceState = state;
                delayAfterComplete = 2500
                timer1.running = true
                running = false
            }
            else
            {
                if(state == 0 || state == 99 || state == 174){
                    if(state == 0)
                        delayAfterComplete = 2500
                    else if (state == 99  || state == 174)
                        delayAfterComplete = 2000
                    timer1.running = true
                    running = false
                }
                imageSourceState = state;
            }//
        }//
    }//
    Timer {
        id: timer1
        running: false
        interval: delayAfterComplete
        repeat: false
        onTriggered: {
            if(state == (noOfFrames - 1)){
                imageSourceState = 0
                state = 0
            }
            timer.running = true
            running = false
        }//
        onRunningChanged: {
            //            if(running)image.visible = false
            //            else image.visible = true
        }
    }//

    UtilsApp{
        id: utils
    }
}//
