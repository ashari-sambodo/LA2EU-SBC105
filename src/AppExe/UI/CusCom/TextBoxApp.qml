/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Ahmad Qodri
**/

import QtQuick 2.12
Item{
    property alias text : text_id.text
    property alias fontSize : text_id.font.pixelSize
    property alias textColor : text_id.color
    property alias boxOpacity : rectangle.opacity
    property alias padding : text_id.padding
    property alias boxColor: rectangle.color
    property alias boxBorderColor: rectangle.border.color
    property alias radius: rectangle.radius
    property alias boxBorderWidth: rectangle.border.width

    implicitWidth: 80
    implicitHeight: 25

    Rectangle {
        id: rectangle
        width: parent.width
        height: parent.height
        color: "#1F95D7"
        border.color: "#88133966"
        border.width: 1
        opacity: 0.85
        radius: 2
    }

    TextApp{
        id: text_id
        height: rectangle.height
        width: rectangle.width
        text:"text"
        fontSizeMode: Text.Fit
        minimumPixelSize: 20
        //        elide: Text.ElideRight
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

}
