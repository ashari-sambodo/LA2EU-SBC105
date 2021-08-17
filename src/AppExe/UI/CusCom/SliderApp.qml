/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Controls 2.0

Slider {
    id: control
    padding: 0

    background: Rectangle {
        id: controlBackground
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 500
        implicitHeight: 50
        width: control.availableWidth
        height: implicitHeight
        radius: 10
        color: "#0F2952"
        border.color: "#dddddd"
        border.width: 2
    }

    handle: Image {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        width: height
        height: control.height - (controlBackground.border.width * 2)
        source: "SliderApp/slider_handle.png"
    }
}//
