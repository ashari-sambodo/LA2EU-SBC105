import QtQuick 2.0
import QtQuick.Controls 2.0

CheckBox {
    id: control
    font.pixelSize: 20

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: "#e3dac9"
        verticalAlignment: Text.AlignVCenter
        anchors.left: parent.left
        anchors.leftMargin: 40
        width: 200
        wrapMode: Text.WordWrap
    }//
}//
