/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0

Item {
    id: control
    implicitHeight: 50
    implicitWidth: 500

    anchors.horizontalCenter: parent.horizontalCenter

    property alias text: messageText.text
    property bool warning: false

    property alias autoCloseTimer: closeTimer.running
    property alias backgroundColor: backgroundRectangle.color

    Rectangle {
        id: backgroundRectangle
        implicitHeight: 50
        implicitWidth: 500
        color: warning ? "#e74c3c" : "#6E6D6D"
        radius: 5

        RowLayout {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 2

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true

                Text {
                    id: messageText
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 20
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                    color: "#dddddd"
                    text: "text"
                }//
            }//

            Rectangle {
                Layout.fillHeight: true
                Layout.minimumWidth: 1
                color: "#dddddd"
            }///

            Item {
                Layout.fillHeight: true
                Layout.minimumWidth: 20

                Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 20
                    color: "#dddddd"
                    text: "X"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        closeTimer.stop()
                        control.destroy()
                    }//
                }//
            }//
        }//

        visible: false
        scale: visible ? 1.0 : 0.8
        Behavior on scale {
            NumberAnimation { duration: 100}
        }//

        Component.onCompleted: {
            visible = true
        }//

        Rectangle{
            height: parent.height
            width: parent.width
            color: "#AA000000"
            radius: 5
            z: -1
            x: 3
            y: 3
        }
    }//

    Timer {
        id: closeTimer
        interval: 2000
        running: true
        onTriggered: {
            control.destroy()
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
