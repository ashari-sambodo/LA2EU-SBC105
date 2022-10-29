/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0

//import UI.CusCom.HeaderApp.Adapter 1.0

Item {
    id: control

    property string title: "Title"
    property alias textModelName: modelNameText.text

    property alias sourceLogo: logoImage.source

    signal clickedAtAlert()

    property alias contentTitleBox: titleBoxLoader
    property alias contentDateTime: dateTimeLoader

    function setTimePeriod(period) {
        HeaderAppService.timePeriod = period
    }//

    signal forceUpdateCurrentTime()

    RowLayout {
        anchors.fill: parent
        spacing: 5

        Item {
            Layout.fillHeight: true
            Layout.minimumWidth: 300

            Item {
                anchors.fill: parent

                //                Rectangle {
                //                    anchors.fill: parent
                //                    color: "#0F2952"
                //                    radius: 5
                //                    border.width: 1
                //                    border.color: "#e3dac9"
                //                }//

                Image {
                    id: vendorBgImage
                    source: "HeaderApp/header-bg-vendor.png"
                    anchors.fill: parent
                    //                    fillMode: Image.PreserveAspectFit

                    states: [
                        State {
                            when: HeaderAppService.alert
                            PropertyChanges {
                                target: vendorBgImage
                                source: "HeaderApp/header-red-bg-vendor.png"
                            }//
                        }//
                    ]
                }//

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 1
                    spacing: 1

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Image {
                            id: logoImage
                            anchors.fill: parent
                            anchors.margins: 5
                            fillMode: Image.PreserveAspectFit
                            source: HeaderAppService.sourceImgLogo
                            opacity: vendorMArea.pressed ? 0.8 : 1
                        }//

                        MouseArea {
                            id: vendorMArea
                            anchors.fill: parent
                            onPressAndHold: {
                                HeaderAppService.vendorLogoPressandHold()
                            }
                        }
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Text {
                            id: modelNameText
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "#e3dac9"
                            font.pixelSize: 20
                            //                            text: "Class II<br>LA2"
                            text: HeaderAppService.modelName
                        }//
                    }//
                }//
            }//
        }//

        Item {
            Layout.fillHeight: true
            Layout.minimumWidth: 90
            visible: HeaderAppService.alert

            Rectangle {
                id: topBarAlarmRectangle
                anchors.fill: parent
                radius: 5
                color: "#55000000"
                //                color: "transparent"
                border.color: "#e3dac9"
                border.width: 1

                AnimatedImage {
                    id: bellImage
                    anchors.fill: parent
                    anchors.margins: 2
                    //                    source: "HeaderApp/AlarmOn.png"
                    source: "HeaderApp/AlarmOnAnim.gif"
                    fillMode: Image.PreserveAspectFit
                }//

                Timer {
                    running: parent.visible && !bellImage.playing
                    interval: 5000
                    onTriggered: {
                        //                        console.log("Belll Bell")
                        bellImage.playing = true
                    }//
                }//

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        bellImage.playing = true
                        control.clickedAtAlert
                    }//
                }//
            }//
        }//

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
            visible: titleBoxLoader.active

            Loader {
                id: titleBoxLoader
                anchors.fill: parent
                sourceComponent: Item {
                    id: topBarStatusRectangle
                    anchors.fill: parent
                    //                    radius: 5
                    //                    color: "#0F2952"
                    //                            color: "red"
                    //                    border.color: "#e3dac9"
                    //                    border.width: 1

                    Image {
                        id: menuBgImage
                        source: "HeaderApp/header-bg-menu.png"
                        anchors.fill: parent
                        //                        fillMode: Image.PreserveAspectFit

                        states: [
                            State {
                                when: HeaderAppService.alert
                                PropertyChanges {
                                    target: menuBgImage
                                    source: "HeaderApp/header-red-bg-menu.png"
                                }//
                            }//
                        ]
                    }

                    Text {
                        id: topBarStatusText
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: "#e3dac9"
                        font.pixelSize: 20
                        text: control.title
                        font.bold: true
                        wrapMode: Text.WordWrap
                        //                        text: "Title"
                        //                                text: "WARNING: AIRFLOW IS FAIL"
                    }//
                }//
            }//
        }//

        Item {
            Layout.fillHeight: true
            Layout.minimumWidth: 100
            visible: dateTimeLoader.active

            Loader {
                id: dateTimeLoader
                anchors.fill: parent
                sourceComponent: Item {
                    id: topBarClockRectangle
                    //                    anchors.fill: parent
                    //                    radius: 5
                    //                    color: "#0F2952"
                    //                            color: "red"
                    //                    border.color: "#dddddd"
                    //                    border.width: 1

                    Image {
                        id: timeBgImage
                        source: "HeaderApp/header-bg-time.png"
                        anchors.fill: parent
                        //                        fillMode: Image.PreserveAspectFit

                        states: [
                            State {
                                when: HeaderAppService.alert
                                PropertyChanges {
                                    target: timeBgImage
                                    source: "HeaderApp/header-red-bg-time.png"
                                }//
                            }//
                        ]
                    }//

                    Text {
                        id: topBarClockText
                        anchors.fill: parent
                        anchors.margins: 5
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: "#e3dac9"
                        font.pixelSize: 20
                        fontSizeMode: Text.Fit
                        text: "---"
                        //                                text: "WARNING: AIRFLOW IS FAIL"
                    }//

                    ///////////////Timer for update current clock and date
                    Timer{
                        id: timeDateTimer
                        running: true
                        interval: 10000
                        repeat: true
                        triggeredOnStart: true
                        onTriggered: {
                            var datetime = new Date();
                            //            dateText.text = Qt.formatDateTime(datetime, "dddd\nMMM dd yyyy")
                            let date = Qt.formatDateTime(datetime, "MMM dd yyyy")

                            let timeFormatStr = "h:mm AP"
                            if (HeaderAppService.timePeriod === 24) timeFormatStr = "hh:mm"

                            let clock = Qt.formatDateTime(datetime, timeFormatStr)

                            topBarClockText.text = date + "<br>" + clock
                        }//
                    }//

                    Connections {
                        target: control

                        function onForceUpdateCurrentTime(){
                            timeDateTimer.restart()
                        }//
                    }//
                }//
            }//
        }//
    }//
}//
/*##^##
Designer {
    D{i:0;autoSize:true;height:60;width:1024}
}
##^##*/
