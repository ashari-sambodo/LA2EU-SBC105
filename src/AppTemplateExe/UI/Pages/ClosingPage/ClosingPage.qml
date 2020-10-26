import QtQuick 2.0

import UI.CusCom 1.0
import modules.cpp.utils 1.0

import "../../CusCom/JS/IntentApp.js" as IntentApp

import modules.cpp.machine 1.0

ViewApp {
    id: viewApp
    title: "Closing"

    background.sourceComponent: Rectangle {
        color: "black"
    }

    content.sourceComponent: Item{
        id: containerItem
        height: viewApp.height
        width: viewApp.width

        property bool readyToQuit: false
        property bool swUpdatePathCleared: false

        Column {
            anchors.centerIn: parent

            BusyIndicatorApp {
                anchors.horizontalCenter: parent.horizontalCenter
                running: true
                loops: Animation.Infinite
            }//

            TextApp {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Closing...")
            }//
        }//

        /// OnCreated
        Component.onCompleted: {
            MachineApi.stop();
        }//

        Timer {
            id: eventTimer
            interval: 5000
            running: true
            repeat: true
            onTriggered: {
                console.log("MachineData.hasStopped: " + MachineData.hasStopped)

                containerItem.readyToQuit = MachineData.hasStopped

                if(containerItem.readyToQuit) {
                    let exitBehaviour = IntentApp.getExtraData(intent)["exitCode"]
                    exitBehaviour = exitBehaviour === undefined ? ExitCode.ECC_NORMAL_EXIT_RESTART_SBC : exitBehaviour

                    Qt.exit(exitBehaviour)
                }
            }//
        }//
    }//
}
