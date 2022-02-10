/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0

Item {
    id: control
    visible: false

    function open() {
        control.visible = true
    }

    function close() {
        control.visible = false
    }

    onVisibleChanged: {
        if (!visible){
            control.closed()
        }
    }

    signal fullRotated(int cycle)
    signal rotationChanged(int cycle)
    signal closed()

    property string title:      ""
    property bool   running:    false
    property int    loops:      Animation.Infinite

    //    Component.onDestruction: {
    //        //console.debug("onDestruction")
    //    }

    /// Delay to wait save
    Loader {
        id: bussyLoader
        anchors.fill: parent
        active: control.visible
        visible: active
        sourceComponent: Rectangle {
            color: "#DD000000"

            Column {
                anchors.centerIn: parent

                BusyIndicatorApp {
                    anchors.horizontalCenter: parent.horizontalCenter

                    running: control.running
                    loops: control.loops

                    onFullRotated: {
                        control.fullRotated(cycle)
                    }//
                    onRotationChanged: {
                        control.rotationChanged(cycle)
                    }
                }//

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#e3dac9"
                    font.pixelSize: 20
                    text: control.title
                }//
            }//

            /// Just for blocking the overlapping mouse area actions
            MouseArea {
                anchors.fill: parent
            }//
        }//
    }//
}//
