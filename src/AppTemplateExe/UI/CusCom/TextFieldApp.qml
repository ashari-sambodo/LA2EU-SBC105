import QtQuick 2.0
import QtQuick.Controls 2.0

TextField {
    id: control
    placeholderText: qsTr("Enter description")

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 40
        color: "#404244"
        border.color: "gray"
        radius: 5
    }

    font.pixelSize: 20
    color: "white"
}
