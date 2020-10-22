import QtQuick 2.0
import "Dialog"

Item {
    id: root
    anchors.fill: parent
    visible: false

    function open() {
        visible = true
    }

    function close() {
        visible = false
    }

    onVisibleChanged: {
        if (visible) opened()
        else close()
    }

    signal clickedAtBackground()
    signal accepted()
    signal rejected()

    signal opened()
    signal closed()

    property alias contentItem: dialogContentApp

    Rectangle {
        anchors.fill: parent
        opacity: 0.8
        color: "black"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.clickedAtBackground()
        }
    }

    DialogContentApp {
        id: dialogContentApp
    }

    Component.onCompleted: {
        dialogContentApp.accepted.connect(root.accepted)
        dialogContentApp.rejected.connect(root.rejected)
        dialogContentApp.accepted.connect(root.close)
        dialogContentApp.rejected.connect(root.close)
    }
}
