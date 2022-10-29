import QtQuick 2.0
import QtQuick.Controls 2.0

Switch {
    id: control
    opacity: enabled ? 1 : 0.5
    property bool initialized: false

    indicator: Rectangle {
        implicitWidth: 48
        implicitHeight: 20
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 13
        color: control.checked ? "#17a81a" : "#e3dac9"
        border.color: "#e3dac9"

        Rectangle {
            x: control.checked ? parent.width - width : 0
            y: parent.height / 2 - height / 2
            width: 26
            height: 26
            radius: 13
            color: control.down ? "#cccccc" : "#e3dac9"
            border.color: "#999999"
        }//
    }//
}//
