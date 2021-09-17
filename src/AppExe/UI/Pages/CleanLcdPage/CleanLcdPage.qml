import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Clean LCD"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        ColumnLayout {
            id: contentColumnLayout
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
                    title: qsTr("Clean LCD")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Column {
                            id: featureColumn
                            anchors.centerIn: parent

                            Image {
                                source: "qrc:/UI/Pictures/clean-lcd-icon.png"
                            }//

                            TextApp {
                                text: qsTr("Press here to start")
                            }//
                        }//

                        //                        TapHandler {
                        //                            target: featureColumn
                        //                            onTapped: {
                        //                                cleanLcdBlockLoader.active = true
                        //                            }//
                        //                        }//

                        MouseArea {
                            anchors.fill: featureColumn
                            onClicked: {
                                cleanLcdBlockLoader.active = true
                            }//
                        }//
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Column {
                            id: rightColumn
                            anchors.centerIn: parent

                            ColumnLayout {
                                TextApp {
                                    id: tipText
                                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                    Layout.maximumWidth: rightColumn.parent.width - 5

                                    text: qsTr("Attention!") + "<br>" +
                                          "# " + qsTr("Recommended to wipe the surface with a lint-free microfiber cloth") + "<br>" +
                                          "# " + qsTr("Never directly apply cleaning solution to the screen") + "<br>" +
                                          "# " + qsTr("Do not use the moist section of the cloth to clean the corners of the screen") + "<br>" +
                                          "# " + qsTr("Start in the center and gently wipe the screen in circular motion") + "<br>" +
                                          "# " + qsTr("After started, screen will goes blank then back to normal after 15 seconds") + "<br>"
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
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }
                        }//
                    }//
                }//
            }//
        }//

        /// When clean is running
        /// Block the entire screen
        Loader {
            id: cleanLcdBlockLoader
            anchors.fill: parent
            active: false
            sourceComponent: Rectangle {
                id: cleanBlockRect
                color: "#2c3e50" /// mignight-blue

                property int duration: 15

                TextApp {
                    anchors.centerIn: parent
                    text: cleanBlockRect.duration
                }//

                Timer {
                    interval: 1000
                    repeat: true
                    running: true
                    onTriggered: {
                        if (cleanBlockRect.duration <= 0){
                            cleanLcdBlockLoader.active = false
                        }
                        else {
                            let val = cleanBlockRect.duration
                            cleanBlockRect.duration = val - 1
                        }//
                    }//
                }//

                /// block all touch interaction up to here
                //                MouseArea {
                //                    anchors.fill: parent
                //                }//

                //                DragHandler{

                //                }

                //                MultiPointTouchArea {
                //                    anchors.fill: parent

                //                    touchPoints: [
                //                        TouchPoint {id: point1},
                //                        TouchPoint {id: point2},
                //                        TouchPoint {id: point3},
                //                        TouchPoint {id: point4},
                //                        TouchPoint {id: point5}
                //                    ]
                //                }

                //                Rectangle {
                //                    width: 100; height: 100
                //                    radius: width
                //                    opacity: 0.7
                //                    color: "red"
                //                    x: point1.x - (width / 2)
                //                    y: point1.y - (height / 2)
                //                }//

                //                Rectangle {
                //                    width: 100; height: 100
                //                    radius: width
                //                    opacity: 0.7
                //                    color: "green"
                //                    x: point2.x - (width / 2)
                //                    y: point2.y - (height / 2)
                //                }//

                //                Rectangle {
                //                    width: 100; height: 100
                //                    radius: width
                //                    opacity: 0.7
                //                    color: "blue"
                //                    x: point3.x - (width / 2)
                //                    y: point3.y - (height / 2)
                //                }//

                //                Rectangle {
                //                    width: 100; height: 100
                //                    radius: width
                //                    opacity: 0.7
                //                    color: "yellow"
                //                    x: point4.x - (width / 2)
                //                    y: point4.y - (height / 2)
                //                }//

                //                Rectangle {
                //                    width: 100; height: 100
                //                    radius: width
                //                    opacity: 0.7
                //                    color: "cyan"
                //                    x: point5.x - (width / 2)
                //                    y: point5.y - (height / 2)
                //                }

                Component.onCompleted: {
                    /// During cleaning LCD, oveeride gestureSwipedUp() called by main.qml
                    viewApp.fnSwipedFromLeftEdge = function(){}
                    viewApp.fnSwipedFromRightEdge = function(){}
                    viewApp.enabled = false
                    //                    contentColumnLayout.visible = false
                }//

                Component.onDestruction: {
                    /// reactive gesture swiped up
                    viewApp.fnSwipedFromLeftEdge = null
                    viewApp.fnSwipedFromRightEdge = null
                    viewApp.enabled = true
                }//
            }//
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        //        QtObject {
        //            id: props
        //        }

        /// called Once but after onResume
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
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
