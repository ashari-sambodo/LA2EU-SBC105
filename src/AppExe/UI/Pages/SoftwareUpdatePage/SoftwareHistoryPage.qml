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
    title: "Software Version History"

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
                    title: qsTr("Software Version History")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                Rectangle{
                    color: "#66000000"
                    anchors.fill: parent
                    radius: 5
                    border.width: 1
                    border.color: "#e3dac9"
                    z : -1
                }
                RowLayout {
                    anchors.margins: 5
                    anchors.fill: parent
                    Flickable {
                        id: view
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        //                        anchors.fill: parent
                        //                        anchors.margins: 2
                        contentWidth: col.width
                        contentHeight: col.height
                        property real span : contentY + height
                        clip: true

                        flickableDirection: Flickable.VerticalFlick

                        ScrollBar.vertical: verticalScrollBar.scrollBar
                        Column{
                            id: col
                            spacing: 10

                            Repeater{
                                id: repeater1
                                model: json.history
                                Column{
                                    Row{
                                        spacing: 10
                                        TextApp{
                                            text: "v%1".arg(modelData['version'])
                                        }//
                                        TextApp{
                                            text: "(%1)".arg(modelData['date'])
                                        }//
                                    }
                                    Row{
                                        spacing: 10
                                        Column{
                                            Image{
                                                id: image1
                                                source: "qrc:/UI/Pictures/collapse-history.png"
                                            }
                                            Image{
                                                id: image2
                                                source: "qrc:/UI/Pictures/vertical-line-history.png"
                                                height: colUpdate.height - image1.height
                                            }//
                                        }//
                                        Column{
                                            id: colUpdate
                                            Repeater{
                                                id: repeater2
                                                model: modelData['updates']
                                                Row{
                                                    spacing: 20
                                                    Row{
                                                        spacing:10
                                                        Column{
                                                            Column{
                                                                height: colUpdates1.height
                                                                clip: true
                                                                TextApp{
                                                                    text: "Brief"
                                                                    font.pixelSize: 18
                                                                }
                                                                Image{
                                                                    id: image3
                                                                    visible: modelData['brief'].length > 1
                                                                    source: "qrc:/UI/Pictures/collapse-history.png"
                                                                }
                                                                Image{
                                                                    id: image4
                                                                    visible: modelData['brief'].length > 1
                                                                    source: "qrc:/UI/Pictures/vertical-line-history.png"
                                                                    height: colUpdates1.height - (image3.height + 20)
                                                                }
                                                            }
                                                            Column{
                                                                height: colUpdates2.height
                                                                clip: true
                                                                TextApp{
                                                                    text: "Major"
                                                                    font.pixelSize: 18
                                                                }
                                                                Image{
                                                                    id: image5
                                                                    visible: modelData['major'].length > 1
                                                                    source: "qrc:/UI/Pictures/collapse-history.png"
                                                                }
                                                                Image{
                                                                    id: image6
                                                                    visible: modelData['major'].length > 1
                                                                    source: "qrc:/UI/Pictures/vertical-line-history.png"
                                                                    height: colUpdates2.height - (image5.height + 20)
                                                                }
                                                            }
                                                            Column{
                                                                height: colUpdates3.height
                                                                clip: true
                                                                TextApp{
                                                                    text: "Minor"
                                                                    font.pixelSize: 18
                                                                }
                                                                Image{
                                                                    id: image7
                                                                    visible: modelData['minor'].length > 1
                                                                    source: "qrc:/UI/Pictures/collapse-history.png"
                                                                }
                                                                Image{
                                                                    id: image8
                                                                    visible: modelData['minor'].length > 1
                                                                    source: "qrc:/UI/Pictures/vertical-line-history.png"
                                                                    height: colUpdates3.height - (image7.height + 20)
                                                                }
                                                            }
                                                            Column{
                                                                height: colUpdates4.height
                                                                clip: true
                                                                TextApp{
                                                                    text: "Patch"
                                                                    font.pixelSize: 18
                                                                }
                                                                Image{
                                                                    id: image9
                                                                    visible: modelData['patch'].length > 1
                                                                    source: "qrc:/UI/Pictures/collapse-history.png"
                                                                }
                                                                Image{
                                                                    id: image10
                                                                    visible: modelData['patch'].length > 1
                                                                    source: "qrc:/UI/Pictures/vertical-line-history.png"
                                                                    height: colUpdates4.height - (image9.height + 20)
                                                                }
                                                            }
                                                            Column{
                                                                height: colUpdates5.height
                                                                clip: true
                                                                TextApp{
                                                                    text: "Build"
                                                                    font.pixelSize: 18
                                                                }
                                                                Image{
                                                                    id: image11
                                                                    visible: modelData['build'].length > 1
                                                                    source: "qrc:/UI/Pictures/collapse-history.png"
                                                                }
                                                                Image{
                                                                    id: image12
                                                                    visible: modelData['build'].length > 1
                                                                    source: "qrc:/UI/Pictures/vertical-line-history.png"
                                                                    height: colUpdates5.height - (image11.height + 20)
                                                                }
                                                            }
                                                        }
                                                        Column{
                                                            Row{
                                                                spacing: 10
                                                                TextApp{
                                                                    text: ":"
                                                                    font.pixelSize: 18
                                                                }
                                                                Column{
                                                                    id: colUpdates1
                                                                    Repeater{
                                                                        model: modelData['brief']
                                                                        Row{
                                                                            spacing: 5
                                                                            TextApp{
                                                                                text: "-"
                                                                                font.pixelSize: 18
                                                                                color: "#BCFFFB"
                                                                            }
                                                                            TextApp{
                                                                                text: modelData
                                                                                font.pixelSize: 18
                                                                                minimumPixelSize: 18
                                                                                width: 850
                                                                                wrapMode: Text.WordWrap
                                                                                horizontalAlignment: Text.AlignJustify
                                                                                color: "#BCFFFB"
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            Row{
                                                                spacing: 10
                                                                TextApp{
                                                                    text: ":"
                                                                    font.pixelSize: 18
                                                                }
                                                                Column{
                                                                    id: colUpdates2
                                                                    Repeater{
                                                                        model: modelData['major']
                                                                        Row{
                                                                            spacing: 5
                                                                            TextApp{
                                                                                text: "-"
                                                                                font.pixelSize: 18
                                                                                color: "#BCFFFB"
                                                                            }
                                                                            TextApp{
                                                                                text: modelData
                                                                                font.pixelSize: 18
                                                                                minimumPixelSize: 18
                                                                                width: 850
                                                                                wrapMode: Text.WordWrap
                                                                                horizontalAlignment: Text.AlignJustify
                                                                                color: "#BCFFFB"
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            Row{
                                                                spacing: 10
                                                                TextApp{
                                                                    text: ":"
                                                                    font.pixelSize: 18
                                                                }
                                                                Column{
                                                                    id: colUpdates3
                                                                    Repeater{
                                                                        model: modelData['minor']
                                                                        Row{
                                                                            spacing: 5
                                                                            TextApp{
                                                                                text: "-"
                                                                                font.pixelSize: 18
                                                                                color: "#BCFFFB"
                                                                            }
                                                                            TextApp{
                                                                                text: modelData
                                                                                font.pixelSize: 18
                                                                                minimumPixelSize: 18
                                                                                width: 850
                                                                                wrapMode: Text.WordWrap
                                                                                horizontalAlignment: Text.AlignJustify
                                                                                color: "#BCFFFB"
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            Row{
                                                                spacing: 10
                                                                TextApp{
                                                                    text: ":"
                                                                    font.pixelSize: 18
                                                                }
                                                                Column{
                                                                    id: colUpdates4
                                                                    Repeater{
                                                                        model: modelData['patch']
                                                                        Row{
                                                                            spacing: 5
                                                                            TextApp{
                                                                                text: "-"
                                                                                font.pixelSize: 18
                                                                                color: "#BCFFFB"
                                                                            }
                                                                            TextApp{
                                                                                text: modelData
                                                                                font.pixelSize: 18
                                                                                minimumPixelSize: 18
                                                                                width: 850
                                                                                wrapMode: Text.WordWrap
                                                                                horizontalAlignment: Text.AlignJustify
                                                                                color: "#BCFFFB"
                                                                            }
                                                                        }
                                                                    }//
                                                                }//
                                                            }//
                                                            Row{
                                                                spacing: 10
                                                                TextApp{
                                                                    text: ":"
                                                                    font.pixelSize: 18
                                                                }
                                                                Column{
                                                                    id: colUpdates5
                                                                    Repeater{
                                                                        model: modelData['build']
                                                                        Row{
                                                                            spacing: 5
                                                                            TextApp{
                                                                                text: "-"
                                                                                font.pixelSize: 18
                                                                                color: "#BCFFFB"
                                                                            }
                                                                            TextApp{
                                                                                text: modelData
                                                                                font.pixelSize: 18
                                                                                minimumPixelSize: 18
                                                                                width: 850
                                                                                wrapMode: Text.WordWrap
                                                                                horizontalAlignment: Text.AlignJustify
                                                                                color: "#BCFFFB"
                                                                            }
                                                                        }
                                                                    }//
                                                                }//
                                                            }//
                                                        }//
                                                    }//
                                                }//
                                            }//
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//

                    ScrollBarApp {
                        id: verticalScrollBar
                        Layout.fillHeight: true
                        Layout.minimumWidth: 20
                        Layout.fillWidth: false
                    }
                }
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 70

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
                    }//
                }//
            }//
        }//

        QtObject {
            id: json
            property var history:  []//

            Component.onCompleted: {
                var jsonObject = MachineData.svnUpdateHistory
                console.debug("Software name", jsonObject['name'])

                if(jsonObject['name'] === Qt.application.name){
                    history = jsonObject['versioning']
                }
            }
        }//


        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int countDefault: 50
            property int count: 50
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
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
