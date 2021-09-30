/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

//import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Time Picker"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 5

            /// HEADER
            Item {
                id: headerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 60

                HeaderApp {
                    anchors.fill: parent
                    title: qsTr("Time Picker")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Item {
                    id: container
                    anchors.centerIn: parent

                    function formatText(count, modelData) {
                        var data = count === 12 ? modelData + 1 : modelData;
                        return data.toString().length < 2 ? "0" + data : data;
                    }//

                    FontMetrics {
                        id: fontMetrics
                        font.pixelSize: 20
                    }//

                    Component {
                        id: delegateComponent

                        Label {
                            text: container.formatText(Tumbler.tumbler.count, modelData)
                            opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: fontMetrics.font.pixelSize * 1.25
                            font.bold: Tumbler.tumbler.currentIndex == index
                            color: "#DDDDDD"
                        }//
                    }//

                    Frame {
                        id: frame
                        padding: 10
                        anchors.centerIn: parent

                        background: Rectangle {
                            color: "#0F2952"
                            radius: 5
                            border.color: "#DDDDDD"
                        }//
                        Column{
                            id: column
                            spacing: 5
                            TextApp {
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.pixelSize: fontMetrics.font.pixelSize
                                text: qsTr("HH:MM")
                            }
                            Row {
                                id: row

                                Tumbler {
                                    id: hoursTumbler
                                    model: props.periodMode
                                    delegate: delegateComponent
                                    width: 100
                                }//

                                TextApp {
                                    anchors.verticalCenter: parent.verticalCenter
                                    font.pixelSize: fontMetrics.font.pixelSize
                                    text: ":"
                                }

                                Tumbler {
                                    id: minutesTumbler
                                    model: 60
                                    delegate: delegateComponent
                                    width: 100
                                }//

                                Tumbler {
                                    id: amPmTumbler
                                    visible: props.periodMode === 12
                                    model: ["AM", "PM"]
                                    delegate: delegateComponent
                                    width: 100
                                }//
                            }//
                        }//
                    }//
                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 70

                Rectangle {
                    anchors.fill: parent
                    color: "#0F2952"
                    //                    border.color: "#e3dac9"
                    //                    border.width: 1
                    radius: 5

                    Item {
                        anchors.fill: parent
                        anchors.margins: 5

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                var intent
                                if(props.pid === "on" || props.pid === "off"){
                                    intent = IntentApp.create(uri,
                                                              { "set": 0,
                                                                  "pid": props.pid,
                                                                  "temp": props.temp,
                                                              })
                                }
                                else
                                    intent = IntentApp.create(uri, {"message": ""})
                                finishView(intent)
                            }
                        }//

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Set")

                            onClicked: {
                                let hour       = hoursTumbler.currentIndex
                                if (props.periodMode == 12) hour = hour + 1
                                const minute     = minutesTumbler.currentIndex
                                const period     = amPmTumbler.currentIndex ? "PM" : "AM"
                                const periodMode = props.periodMode

                                //                                console.log(uri + "hour: " + hour)
                                //                                console.log(uri + "minute: " + minute)
                                //                                console.log(uri + "period: " + period)
                                //                                console.log(uri + "periodMode: " + periodMode)
                                var intent
                                if(props.pid === "on" || props.pid === "off"){
                                    intent = IntentApp.create(uri,
                                                              {   "set":        1,
                                                                  "pid":        props.pid,
                                                                  "temp":       props.temp,
                                                                  "hour":       hour,
                                                                  "minute":     minute,
                                                                  "period":     period,
                                                                  "periodMode": periodMode})
                                }else{
                                    intent = IntentApp.create(uri,
                                                              {   "hour":       hour,
                                                                  "minute":     minute,
                                                                  "period":     period,
                                                                  "periodMode": periodMode})
                                }//
                                finishView(intent)
                            }
                        }//
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int periodMode: 24 //12h
            property int newTimeInMinutes: 0
            property string pid: "-"
            property int temp: 0
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                const extraData     = IntentApp.getExtraData(intent)
                const pid        = extraData['pid']       || "-"
                const temp       = extraData['temp']      || 0 // for temporary integer variable
                const hour       = extraData['hour']      || 0 // only support input for 24h format
                const minute     = extraData['minute']    || 0
                const period     = extraData['period']    || "AM" // AM or PM
                const periodMode = extraData['periodMode']|| 24 // 24 for 24h and 12 for 12h (AM/PM)

                props.pid = pid
                props.temp = temp

                props.periodMode = periodMode
                hoursTumbler.currentIndex = hour
                minutesTumbler.currentIndex = minute
                amPmTumbler.currentIndex = period === "PM" ? 1 : 0
            }//

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/
