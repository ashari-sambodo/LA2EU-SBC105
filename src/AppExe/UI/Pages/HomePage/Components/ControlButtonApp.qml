import QtQuick 2.12

Item {
    id: button
    opacity: tapHandler.pressed ? 0.5 : 1

    property int stateIO
    property bool stateInterlock
    property alias sourceImage: featureImage.source

    property alias tapHandler: tapHandler

    Image {
        anchors.fill: parent
        source: !button.stateInterlock ? "/UI/Pictures/button_bg.png" : "/UI/Pictures/button_gray_bg.png"
    }//

    Image{
        id: featureImage
        anchors.fill: parent
        anchors.margins: 10
        fillMode: Image.PreserveAspectFit
        opacity: !button.stateInterlock ? 1 : 0.5
    }//

    TapHandler {
        id: tapHandler
        //        onLongPressed: {
        //             console.log("onLongPressed")
        //        }//

        //        onTapped: {
        //            console.log("onTapped")
        //        }//

        //        onDoubleTapped: {
        //            console.log("onDoubleTapped")
        //        }//
    }//
}//
