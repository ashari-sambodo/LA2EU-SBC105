import QtQuick 2.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import modules.cpp.machine 1.0

ViewApp {
    id: viewApp
    title: "Startup"

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
                text: qsTr("Starting...")
            }//
        }//

        /// OnCreated
        Component.onCompleted: {
            MachineData.initSingleton()
            MachineApi.initSingleton()
        }//

        /// Event by Timer
        Timer {
            id: eventTimer
            interval: 5000
            running: true
            repeat: true
            onTriggered: {
                var intent = IntentApp.create("qrc:/UI/Pages/HomePage/HomePage.qml", {"message":""})
                startRootView(intent)
            }//
        }//
    }//
}
