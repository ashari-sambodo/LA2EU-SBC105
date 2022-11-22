import QtQuick 2.12

Item {
    id: button
    opacity: controlMouseArea.pressed ? 0.5 : 1

    property bool darkMode: false

    property int stateIO
    property bool stateInterlock
    property int pressedAndHoldInterval: 1000

    property alias background: backgroundLoader

    property alias sourceImage: featureImage.source
    property alias imageFeature: featureImage

    signal clicked()
    signal pressAndHold()
    signal releasedPress()
    property bool buttonPressed: false

    Loader {
        id: backgroundLoader
        active: !darkMode
        anchors.fill: parent
        sourceComponent:  Image {
            source: !button.stateInterlock ? "../../../Pictures/button_bg.png"
                                           : "../../../Pictures/button_gray_bg.png"
        }//
    }//

    Image{
        id: featureImage
        anchors.fill: parent
        anchors.margins: 10
        fillMode: Image.PreserveAspectFit
        opacity: !button.stateInterlock ? 1 : 0.5

        Rectangle{
            visible: darkMode
            anchors.fill: parent
            color: button.stateInterlock ? "#88000000" : "#44000000"
        }
    }//

    MouseArea {
        id: controlMouseArea
        anchors.fill: parent
        pressAndHoldInterval: button.pressedAndHoldInterval
        //        onLongPressed: {
        //             //console.debug("onLongPressed")
        //        }//

        //        onTapped: {
        //            //console.debug("onTapped")
        //        }//

        //        onDoubleTapped: {
        //            //console.debug("onDoubleTapped")
        //        }//
        onReleased: button.releasedPress()

        Component.onCompleted: {
            controlMouseArea.clicked.connect(button.clicked)
            controlMouseArea.pressAndHold.connect(button.pressAndHold)
            //controlMouseArea.released.connect(button.releasedPress)
            buttonPressed = Qt.binding(function(){return pressed})
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
