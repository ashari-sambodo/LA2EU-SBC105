/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0

import UI.CusCom 1.0
import ModulesCpp.Utils 1.0

import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

//Here is standard exit code of the main app
//enum EXIT_CUSTOM_CODE{
// ECC_NORMAL_EXIT,
// ECC_NORMAL_EXIT_RESTART_SBC = 5,
// ECC_NORMAL_EXIT_POWEROFF_SBC = 6,
// ECC_NORMAL_EXIT_OPEN_SBCUPDATE = 7,
// ECC_NORMAL_EXIT_DEV = 8
//};

ViewApp {
    id: viewApp
    title: "Closing"

    background.sourceComponent: Rectangle {
        id: bkg
        color: "black"
        opacity: 0.5

        Component.onCompleted: {
            const extraData = IntentApp.getExtraData(intent)
            const message = extraData["backgroundBlack"] || 0
            if(message) opacity = 1
        }
    }//

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        Column {
            anchors.centerIn: parent

            BusyIndicatorApp {
                anchors.horizontalCenter: parent.horizontalCenter
                running: true
                loops: Animation.Infinite

                onFullRotatedCycleChanged: {
                    let hasStopped = MachineData.hasStopped
                    //                    console.log(hasStopped)
                    if (hasStopped) {
                        const existCode = IntentApp.getExtraData(intent)["exitCode"] || 0
                        Qt.exit(existCode)
                    }
                }
            }//

            TextApp {
                anchors.horizontalCenter: parent.horizontalCenter
                text: props.messageText
            }//
        }//

        /// Variable collector
        QtObject {
            id: props

            property string messageText: qsTr("Shuting down...")

        }//

        Component.onCompleted: {
            viewApp.fnSwipedFromLeftEdge    = function(){}
            viewApp.fnSwipedFromRightEdge   = function(){}
            viewApp.fnSwipedFromBottomEdge  = function(){}

            viewApp.enabledSwipedFromLeftEdge   = false
            viewApp.enabledSwipedFromRightEdge  = false
            viewApp.enabledSwipedFromBottomEdge = false
            viewApp.enabledSwipedFromTopEdge    = false
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

                const extraData = IntentApp.getExtraData(intent)
                const message = extraData["message"] || props.messageText
                //                props.messageText = message

                MachineAPI.stop()
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
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
