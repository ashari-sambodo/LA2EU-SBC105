import QtQuick 2.12

Rectangle {
    //    height: 30
    //    width: parent.width
    color: "#880000"
    radius: 5
    border.width: 1
    border.color: "#dddddd"
    clip: true

    property alias text: infoText.text
    property alias textHeightArea: infoText.height
    property alias textY: infoText.y

    TextApp{
        id: infoText
        //color: "#e3dac9"
        font.pixelSize: 20
        x: 2
        width: parent.width - 4
        wrapMode: Text.WordWrap
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        //        text: "Error ini itu ini itu ini itu ini itu ini itu ini itu ini itu ini itu ini itu ini itu ini itu ini itu ini itu ini itu ini itu ini itu ini itu ini itu"
        //                                            text: "Error ini itu ini itu ini itu"

        //        Component.onCompleted: {
        //            console.log(infoText.height)
        //            console.log(infoText.parent.height)
        //        }//

        Behavior on y {
            NumberAnimation {duration: 100}
        }//

        TextMetrics {
            id: t_metrics
            font: infoText.font
            text: infoText.text
        }//

        //        states: [
        //            State {
        //                /// Sigh, does not work!
        //                when: infoText.height < infoText.parent.height
        //                PropertyChanges {
        //                    target: infoText
        //                    horizontalAlignment: Text.AlignHCenter
        //                }//
        //            }//
        //        ]
    }//

    function moveDown(){
        let pointer = infoText.height - infoText.parent.height
        //        console.log(pointer)
        //        console.log(pointer + infoText.y)
        if((pointer + infoText.y) > 0){
            infoText.y = infoText.y - t_metrics.height
        }
        else {
            infoText.y = 0
        }
    }//

    Timer {
        id: autoAnimTimer
        running: infoText.height > infoText.parent.height
        interval: 5000
        repeat: true
        onTriggered: {
            moveDown()
        }//
    }//

    //    MouseArea {
    //        anchors.fill: parent
    //        onClicked: {
    //            //                                                anim.start()
    //            autoAnimTimer.restart()
    //            moveDown()
    //        }//
    //    }//
}//
