import QtQuick 2.0
import QtQuick.Controls 2.0

Button {
    id: control
    text: qsTr("Button")

    implicitHeight: 40
    implicitWidth: 100

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    font.pixelSize: 20
}
