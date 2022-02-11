/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Controls 2.0

Button {
    id: control

    property bool darkMode: true

    property alias colorBackground: backgroundRect.color

    anchors.fill: parent
    anchors.margins: 2
    background: Rectangle{
        id: backgroundRect
        radius: 5
        border.color: "gray"
        border.width: 1
        color: control.down ? "#3498db" : (control.darkMode ? "#666666" : "#dddddd")
    }

    contentItem: Text {
        text: control.text
        font: control.font
        color: control.darkMode ? "#dddddd" : "#666666"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    text: "Text"
    font.pixelSize: 32
    focusPolicy: Qt.NoFocus
}
