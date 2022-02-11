/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

ColumnLayout {
    //    implicitWidth: 20
    //    implicitHeight: 50
    spacing: 2

    property alias scrollBar: scrollBarItem

    Rectangle {
        Layout.fillWidth: true
        Layout.minimumHeight: 15
        Layout.minimumWidth: 15
        color: "#0F2952"
        border.color: "#e3dac9"
        radius: 2

        Image {
            source: "ScrollBarApp/scroll_up_icon.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            anchors.margins: 5
        }//

        MouseArea {
            anchors.fill: parent
            onClicked: {
                scrollBarItem.decrease()
            }//
        }//
    }//

    Rectangle {
        Layout.fillHeight: true
        Layout.fillWidth: true
        color: "#2c3e50"
        radius: 2

        ScrollBar {
            id: scrollBarItem
            anchors.fill: parent
            policy: ScrollBar.AlwaysOn
            interactive: true

            contentItem: Rectangle {
                implicitWidth: 5
                implicitHeight: 100
                radius: 2
                color: "#0F2952"
                //                border.color: "#e3dac9"
            }//

            //            Component.onCompleted: {
            //                console.log("active: " + active)
            //                console.log("interactive: " + interactive)
            //            }//

            //            onPressedChanged: //console.debug("hello")
        }//
    }//

    Rectangle {
        Layout.fillWidth: true
        Layout.minimumHeight: 15
        Layout.minimumWidth: 15
        color: "#0F2952"
        border.color: "#e3dac9"
        radius: 2

        Image {
            source: "ScrollBarApp/scroll_bottom_icon.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            anchors.margins: 5
        }//

        MouseArea {
            anchors.fill: parent
            onClicked: {
                scrollBarItem.increase()
            }//
        }//
    }//
}

/*##^##
Designer {
    D{i:0;formeditorZoom:4;height:200}
}
##^##*/
