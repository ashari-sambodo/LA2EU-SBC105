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

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Quick Setup"

    background.sourceComponent: Rectangle {
        color: "black"
        opacity: 0.3
    }

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

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent
                    anchors.bottomMargin: 10

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumWidth: 300

                        BiosafetyCabinet3D {
                            id: cabinet3D
                            anchors.fill: parent
                            sashImageItem.state: sashImageItem.stateSafe
                            airflowArrowActive: visible

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    const intent = IntentApp.create("qrc:/UI/Pages/QuickTourPage/QuickTourPage.qml", {})
                                    startView(intent)
                                }//
                            }//
                        }//
                    }//

                    //term and Condition
                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 5
                            spacing: 10

                            TextApp {
                                Layout.alignment: Qt.AlignHCenter
                                text: qsTr("Thanks for choosing us!")
                            }//

                            Image{
                                source: "qrc:/UI/Pictures/logo/esco_lifesciences_group_white_200_80.png"
                                fillMode: Image.PreserveAspectFit
                                Layout.fillWidth: true
                                Layout.maximumHeight: 70
                            }//

                            Image {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                fillMode: Image.PreserveAspectFit
                                source: "qrc:/UI/Pictures/microbiologist_team_bgfit.png"
                            }//

                            TextApp {
                                Layout.alignment: Qt.AlignHCenter
                                text: qsTr("Let's together make this world a better place!")
                            }//

                            ButtonBarApp {
                                width: 194
                                Layout.maximumWidth: 150
                                Layout.alignment: Qt.AlignHCenter

                                imageSource: "qrc:/UI/Pictures/checkicon.png"
                                text: qsTr("Go")

                                onClicked: {
                                    MachineAPI.setShippingModeEnable(false)

                                    let exitCodePowerRestart = 5
                                    const intent = IntentApp.create("qrc:/UI/Pages/ClosingPage/ClosingPage.qml",
                                                                    {
                                                                        exitCode: exitCodePowerRestart,
                                                                        "message": qsTr("Restarting...")
                                                                    })
                                    startRootView(intent)
                                }//
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
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                viewApp.enabledSwipedFromLeftEdge   = false
                viewApp.enabledSwipedFromRightEdge  = false
                viewApp.enabledSwipedFromBottomEdge = false
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#c0c0c0";formeditorZoom:0.9;height:480;width:800}
}
##^##*/
