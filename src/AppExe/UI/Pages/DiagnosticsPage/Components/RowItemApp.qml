/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0

import UI.CusCom 1.0

Item {
    id: control
    //    width: view.width
    //    height: 50

    property real viewContentY: 0
    property real viewSpan: 0

    property bool inView: y >= (viewContentY - height) && y + height <= (viewSpan + height)

    property string label
    property string value

    property alias loaderActive: paramaterLoader.active

    signal loaded()
    signal unloaded()

    visible: enabled

    Loader {
        id: paramaterLoader
        anchors.fill: parent
        asynchronous: true
        active: control.inView && control.visible && control.enabled
        sourceComponent: Item {

            Rectangle {
                anchors.fill: parent
                color: "#CC0F2952"
                radius: 5
            }
            //                                        Rectangle {height: 1; width: parent.width; anchors.bottom: parent.bottom; color: "gray"}

            RowLayout {
                anchors.fill: parent

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    //                    Rectangle {anchors.fill: parent; color: "gray"}

                    TextApp {
                        id: labelText
                        height: parent.height
                        width: parent.width
                        verticalAlignment: Text.AlignVCenter
                        text: control.label
                        padding: 5
                    }//
                }//

                Item {
                    Layout.fillHeight: true
                    //                                                Layout.fillWidth: true
                    Layout.minimumWidth: parent.width * 0.30
                    //                                                Layout.minimumWidth: 200

                    //                                                Rectangle {anchors.fill: parent; color: "yellow"}

                    TextApp {
                        id: valueText
                        height: parent.height
                        width: parent.width
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: control.value
                        padding: 5
                        textFormat: Text.RichText
                    }//
                }//
            }//

            //            Component.onCompleted: {
            //                //console.debug("Hello")
            //            }//

            Component.onDestruction: {
                control.unloaded()
            }
        }//

        onLoaded: control.loaded()
    }//
}//
