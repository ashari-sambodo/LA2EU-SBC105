/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0

import UI.CusCom 1.1

Item {
    id: control
    //    width: view.width
    //    height: 50

    property real viewContentY: 0
    property real viewSpan: 0

    property bool inView: y >= (viewContentY - height) && y + height <= (viewSpan + height)

    property int pmCode: 0
    property string label
    property string ackDate
    property string dueDate
    property bool reminderEn
    property bool alarmActive: false
    property alias loaderActive: paramaterLoader.active

    property bool switchEnabled: true

    signal loaded()
    signal unloaded()
    signal switchChanged(bool value)
    signal buttonRowPressed()

    visible: enabled

    Loader {
        id: paramaterLoader
        anchors.fill: parent
        asynchronous: true
        active: control.inView && control.visible && control.enabled
        sourceComponent: Item {

            Rectangle {
                anchors.fill: parent
                opacity: btnRow.pressed ? 0.5 : 1
                color: control.alarmActive ? "#CCB33939" : "#CC0F2952"
                radius: 5
                MouseArea{
                    id: btnRow
                    anchors.fill: parent
                    onClicked: {
                        control.buttonRowPressed()
                    }
                }
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
                    Layout.minimumWidth: 200
                    //                                                Layout.minimumWidth: 200

                    //                                                Rectangle {anchors.fill: parent; color: "yellow"}

                    TextApp {
                        height: parent.height
                        width: parent.width
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: control.ackDate
                        padding: 5
                        textFormat: Text.RichText
                    }//
                }//
                Item {
                    Layout.fillHeight: true
                    //                                                Layout.fillWidth: true
                    Layout.minimumWidth: 200
                    //                                                Layout.minimumWidth: 200

                    //                                                Rectangle {anchors.fill: parent; color: "yellow"}

                    TextApp {
                        height: parent.height
                        width: parent.width
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: control.dueDate
                        padding: 5
                        textFormat: Text.RichText
                    }//
                }//
                Item {
                    Layout.fillHeight: true
                    Layout.minimumWidth: 150

                    SwitchApp {
                        anchors.centerIn: parent
                        enabled: control.switchEnabled
                        checked: control.reminderEn

                        property bool origin: control.reminderEn

                        onCheckedChanged: {
                            if(!initialized) return
                            //                            //                                            console.log("onCheckedChanged:" + checked)

                            //                            let tempAux = props.auxNew
                            //                            tempAux = tempAux.filter(function(value, index, arr){
                            //                                return value.aux !== modelData.id;
                            //                            })

                            if(origin != checked) {
                                console.debug("Value switched!")
                                control.switchChanged(checked)
                                //                                tempAux.push({aux: modelData.id, installed: checked})
                            }
                            //                            props.auxNew = tempAux
                            //                            //                                            console.log(props.auxNew.length)
                        }//

                        Component.onCompleted: {
                            /*checked = control.reminderEn
                            origin  = control.reminderEn*/
                            initialized = true
                        }//
                    }//
                    //                    TextApp {
                    //                        height: parent.height
                    //                        width: parent.width
                    //                        verticalAlignment: Text.AlignVCenter
                    //                        horizontalAlignment: Text.AlignHCenter
                    //                        text: control.reminderEn
                    //                        padding: 5
                    //                        textFormat: Text.RichText
                    //                    }//
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
