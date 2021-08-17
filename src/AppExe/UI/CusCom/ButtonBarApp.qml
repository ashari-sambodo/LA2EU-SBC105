import QtQuick 2.12

Item {
    id: control
    implicitWidth: 200
    implicitHeight: 60
    //    radius: 5
    //    border.color: "#dddddd"
    //    color: controlMouseArea.pressed ?  "#55ffffff" : "transparent"
    opacity: controlMouseArea.pressed || !enabled ?  0.5 : 1

    property alias imageSource: controlImage.source
    property alias text: controlText.text

    signal clicked()

    Image {
        anchors.fill: parent
        source: "ButtonBarApp/buttonBarBackground.png"
    }

    Row {

        Image {
            id: controlImage
            source: "ButtonBarApp/button-icon.png"
            width: 60
            height: 60
        }

        Text {
            id: controlText
            //            width: 140
            width: control.width * 0.70 - 5
            height: 60
            padding: 2
            text: qsTr("text")
            verticalAlignment: Text.AlignVCenter
            color: "#dddddd"
            font.pixelSize: 20
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
        }
    }

    MouseArea {
        id: controlMouseArea
        anchors.fill: parent
        onClicked: control.clicked()
    }

    //    TapHandler {
    //        onTapped: control.clicked()
    //    }
}
