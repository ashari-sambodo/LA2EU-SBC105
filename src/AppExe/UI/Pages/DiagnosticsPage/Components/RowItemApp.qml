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
    property string value : ""
    property string value1 : ""
    property string value2 : ""

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
                Item{
                    id: value2Items
                    Layout.fillHeight: true
                    Layout.minimumWidth: parent.width * 0.40
                    visible: control.value1 !== "" && control.value2 !== ""
                    RowLayout{
                        anchors.fill: parent
                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            TextApp {
                                id: value1Text
                                height: parent.height
                                width: parent.width
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                text: control.value1
                                padding: 5
                                textFormat: Text.RichText
                            }//
                        }//
                        Rectangle{
                            Layout.minimumHeight: parent.height * 0.8
                            Layout.minimumWidth: 1
                            color: "#e3dac9"
                        }
                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            TextApp {
                                id: value2Text
                                height: parent.height
                                width: parent.width
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                                text: control.value2
                                padding: 5
                                textFormat: Text.RichText
                            }//
                        }//
                    }//
                }//
                Item {
                    id: valueItem
                    Layout.fillHeight: true
                    Layout.minimumWidth: parent.width * 0.40
                    visible: !value2Items.visible
                    TextApp {
                        id: valueText
                        height: parent.height
                        width: parent.width
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: control.value1 !== "" ? control.value1 : control.value
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
