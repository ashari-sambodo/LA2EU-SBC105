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
    title: "Blank Page"

    background.sourceComponent: Rectangle {
        color: "#000000"
    }

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        /// Actual Content
        Loader {
            id: actualContentLoader
            anchors.fill: parent

            //            Component.onCompleted: {
            //                source = "Fragments/ScreenSaverGeneral.qml"
            //                source = "Fragments/ScreenSaverNormal.qml"
            //                source = "Fragments/ScreenSaverStandby.qml"
            //            }//

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    const intent = IntentApp.create("")
                    startRootView(intent)
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property bool alarmsState: false
            onAlarmsStateChanged: {
                /// Alarm occured, go back to home screen to show alarm details
                const intent = IntentApp.create("")
                startRootView(intent)
            }//
        }//

        /// One time executed at startup
        //        Component.onCompleted: {
        //            console.debug("Loaded");
        //        }//

        //// Execute This Every This Screen Active/Visible/Foreground
        executeOnPageVisible: QtObject {
            /// onResume
            Component.onCompleted: {
                //                console.debug("StackView.Active");

                viewApp.enabledSwipedFromLeftEdge   = false
                viewApp.enabledSwipedFromRightEdge  = false
                viewApp.enabledSwipedFromBottomEdge = false
                viewApp.enabledSwipedFromTopEdge    = false

                //                console.log(MachineData.fanState)
                if ((MachineData.fanState === MachineAPI.FAN_STATE_ON)
                        && !MachineData.alarmsState){
                    actualContentLoader.setSource("Fragments/ScreenSaverNormal.qml")
                }
                else if (MachineData.fanState === MachineAPI.FAN_STATE_STANDBY){
                    actualContentLoader.setSource("Fragments/ScreenSaverStandby.qml")
                }
                else {
                    actualContentLoader.setSource("Fragments/ScreenSaverGeneral.qml")
                }

                props.alarmsState = Qt.binding(function(){ return MachineData.alarmsState })

                //                UserSessionService.logout();
                //                MachineAPI.setSignedUser("", "", 0);
            }//

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }//
        }//
    }//

    onScreenLocked: {
        if (!locked) {
            /// Automaticly go back to home screen if screen unlocked
            const intent = IntentApp.create("")
            startRootView(intent)
        }//
    }//
}//
