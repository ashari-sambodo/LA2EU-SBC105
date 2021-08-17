import QtQuick 2.0

Item {

    //    Rectangle {
    //        anchors.fill: parent
    //        color: "black"
    //    }

    Rectangle {
        id: backgroundHorizontalRect
        y: (parent.height - height) / 2
        height: parent.height / 5
        width: parent.width
        color: "#ff9900"

        Image {
            anchors.centerIn: parent
            height: parent.height - 50
            fillMode: Image.PreserveAspectFit
            source: "qrc:/UI/Pictures/escologo.png"
        }//
    }//

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: {
            if (barPosition == 4){
                barPosition = 0
            }
            else {
                barPosition = barPosition + 1
            }
            backgroundHorizontalRect.y = backgroundHorizontalRect.height * barPosition
        }
    }

    property int barPosition: -1
}



/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#000000";height:480;width:800}
}
##^##*/
