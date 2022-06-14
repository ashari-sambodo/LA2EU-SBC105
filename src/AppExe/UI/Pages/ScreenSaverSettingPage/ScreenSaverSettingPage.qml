/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Screen Saver"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        /// just for development
        /// comment following line after release
        visible: true

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
                    title: qsTr("Screen Saver")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                /// fragment container
                StackView {
                    id: fragmentStackView
                    anchors.fill: parent
                    initialItem: currentValueComponent/*configureComponent*/
                }//
                /// fragment-1
                Component {
                    id: currentValueComponent
                    Item{
                        Column{
                            anchors.centerIn: parent
                            spacing: 10
                            TextApp{
                                text: qsTr("The screen saver will not be displayed if:") + "<br>" + qsTr("There is an active alarm,\
 in maintenance mode, warming up is active, UV lamp is active, experiment timer is running,\
 or the sensor has not been calibrated.")
                                width: 700
                                wrapMode: Text.WordWrap
                                horizontalAlignment: Text.AlignHCenter
                                minimumPixelSize: font.pixelSize
                            }
                            TextApp{
                                text: qsTr("Show the screen saver if the screen is not touched for the following time since the screen is locked,")
                                width: 700
                                font.italic: true
                                wrapMode: Text.WordWrap
                                horizontalAlignment: Text.AlignHCenter
                                minimumPixelSize: font.pixelSize
                            }
                            TextApp{
                                font.pixelSize: 36
                                wrapMode: Text.WordWrap
                                font.bold: true
                                text: utilsApp.strfSecsToHumanReadableShort(props.screenSaverSec)
                                width: 700
                                horizontalAlignment: Text.AlignHCenter
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        fragmentStackView.push(configureComponent)
                                    }//
                                }//
                            }//
                            TextApp{
                                width: 700
                                horizontalAlignment: Text.AlignHCenter
                                text: qsTr("Tap to change")
                                color: "#cccccc"
                                font.pixelSize: 18
                            }//
                        }
                        TextApp{
                            anchors.bottom: parent.bottom
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                            text: "*" + qsTr("You will be logged out automatically once the screensaver is active.")
                            font.pixelSize: 16
                        }
                    }//
                }//

                /// fragment-2
                Component {
                    id: configureComponent

                    Item {
                        id: configureItem

                        Loader {
                            id: configureLoader
                            anchors.fill: parent
                            asynchronous: true
                            visible: status == Loader.Ready
                            sourceComponent: Item {
                                id: container

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

                                    function generateTime(){
                                        ////console.debug("generateTime")

                                        let minutes = minutesTumbler.currentIndex;
                                        let seconds = secondsTumbler.currentIndex;
                                        props.requestTime = (minutes * 60) + seconds

                                        console.debug("the timer: " +  props.requestTime)
                                    }
                                    Column{
                                        id: column
                                        spacing: 5
                                        TextApp {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            font.pixelSize: fontMetrics.font.pixelSize
                                            text: qsTr("MM:SS")
                                        }
                                        Row {
                                            id: row

                                            Tumbler {
                                                id: minutesTumbler
                                                model: 15
                                                delegate: delegateComponent
                                                width: 100

                                                onMovingChanged: {
                                                    if (!moving) {
                                                        frame.generateTime()
                                                    }//
                                                }//
                                            }//

                                            TextApp {
                                                anchors.verticalCenter: parent.verticalCenter
                                                font.pixelSize: fontMetrics.font.pixelSize
                                                text: ":"
                                            }

                                            Tumbler {
                                                id: secondsTumbler
                                                model: 60
                                                delegate: delegateComponent
                                                width: 100

                                                onMovingChanged: {
                                                    if (!moving) {
                                                        frame.generateTime()
                                                    }//
                                                }//
                                            }//
                                        }//
                                    }//
                                }//

                                Component.onCompleted: {
                                    props.requestTime = 0

                                    let minutes = props.screenSaverSec / 60
                                    let seconds =  props.screenSaverSec % 60

                                    minutesTumbler.currentIndex = minutes
                                    secondsTumbler.currentIndex = seconds

                                    setButton.visible = true
                                }//

                                Component.onDestruction: {
                                    setButton.visible = false
                                }//
                            }//
                        }//

                        BusyIndicatorApp {
                            visible: configureLoader.status === Loader.Loading
                            anchors.centerIn: parent
                        }//
                    }//
                }//

                UtilsApp {
                    id: utilsApp
                }//

            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: MachineAPI.FOOTER_HEIGHT

                BackgroundButtonBarApp {
                    Item {
                        anchors.fill: parent
                        anchors.margins: 5

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }
                        }//
                        ButtonBarApp {
                            id: setButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            /// only visible from second fragment, set options
                            visible: false

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Set")

                            onClicked: {
                                if(props.requestTime >= 60) {
                                    if(props.requestTime !== props.screenSaverSec){
                                        MachineAPI.setScreenSaverSeconds(props.requestTime)

                                        viewApp.showBusyPage(qsTr("Setting up..."),
                                                             function onCycle(cycle){
                                                                 if (cycle === MachineAPI.BUSY_CYCLE_1) {
                                                                     fragmentStackView.pop()
                                                                     viewApp.dialogObject.close()
                                                                 }//
                                                             })
                                    }else{
                                        setButton.visible = false
                                        fragmentStackView.pop()
                                    }//
                                } else{
                                    viewApp.showDialogMessage(qsTr("Screen saver"), qsTr("The minimum setting of the screen saver timer is 60 seconds!"), dialogAlert)
                                }
                            }//
                        }//
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props
            property int requestTime: 0
            property int screenSaverSec: 0
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                props.screenSaverSec = Qt.binding(function(){return MachineData.screenSaverSeconds})
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

//        MultiPointTouchArea {
//            anchors.fill: parent

//            touchPoints: [
//                TouchPoint {id: point1},
//                TouchPoint {id: point2},
//                TouchPoint {id: point3},
//                TouchPoint {id: point4},
//                TouchPoint {id: point5}
//            ]
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "red"
//            visible: point1.pressed
//            x: point1.x - (width / 2)
//            y: point1.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "green"
//            visible: point2.pressed
//            x: point2.x - (width / 2)
//            y: point2.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "blue"
//            visible: point3.pressed
//            x: point3.x - (width / 2)
//            y: point3.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "yellow"
//            visible: point4.pressed
//            x: point4.x - (width / 2)
//            y: point4.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "cyan"
//            visible: point5.pressed
//            x: point5.x - (width / 2)
//            y: point5.y - (height / 2)
//        }//

//        Column {
//            id: counter
//            anchors.centerIn: parent

//            TextApp {
//                anchors.horizontalCenter: parent.horizontalCenter
//                text: props.count
//                font.pixelSize: 48

//                TapHandler {
//                    onTapped: {
//                        props.count = props.countDefault
//                        counterTimer.restart()
//                    }//
//                }//
//            }//

//            TextApp {
//                font.pixelSize: 14
//                text: "Press number\nto count!"
//            }//
//        }//

//        Timer {
//            id: counterTimer
//            interval: 1000; repeat: true
//            onTriggered: {
//                let count = props.count
//                if (count <= 0) {
//                    counterTimer.stop()
//                }//
//                else {
//                    count = count - 1
//                    props.count = count
//                }//
//            }//
//        }//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/
