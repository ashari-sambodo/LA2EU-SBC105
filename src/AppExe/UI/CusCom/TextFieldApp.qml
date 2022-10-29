/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Controls 2.0

TextField {
    id: control
    //    placeholderText: qsTr("Enter description")

    property alias colorBackground: backgroundRect.color
    property alias colorBorder: backgroundRect.border.color

    background: Rectangle {
        id: backgroundRect
        implicitWidth: 200
        implicitHeight: 40
        radius: 5
        color: control.enabled ? "#0F2952" : "#40000000"
        border.color: "#E3DAC9"
        border.width: 2
    }

    font.pixelSize: 20
    color: "#e3dac9"

    property var _funcMoveToLeftAfterTextChanged: moveToLeftAfterTextChanged
    function moveToLeftAfterTextChanged(){
        cursorPosition = 0
    }

    onTextChanged: _funcMoveToLeftAfterTextChanged()
}
