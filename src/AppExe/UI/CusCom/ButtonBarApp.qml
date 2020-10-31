import QtQuick 2.6

Rectangle {
    id: control
    implicitWidth: 200
    implicitHeight: 60
    radius: 5
    border.color: "white"
    color: controlMouseArea.pressed ?  "#55ffffff" : "transparent"

    property alias imageSource: controlImage.source
    property alias text: controlText.text

    signal clicked()

    Row {

        Image {
            id: controlImage
            source: "ButtonBarApp/button-icon.png"
            width: 60
            height: 60
        }

        Text {
            id: controlText
            width: 140
            height: 60
            padding: 2
            text: qsTr("text")
            verticalAlignment: Text.AlignVCenter
            color: "white"
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
}
