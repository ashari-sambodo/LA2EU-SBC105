import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0

GridLayout {
    columns: 2

    property alias loader: gridLoader
    property alias visibleVerticalScroll: verticalScrollRectangle.visible
    property alias visibleHorizontalScroll: horizontalScrollRectangle.visible

    Rectangle{
        id: gridBackgroundRectangle
        Layout.fillHeight: true
        Layout.fillWidth: true
        color: "transparent"
        border.color: "#dddddd"
        radius: 5

        Flickable {
            id: girdFlick
            anchors.centerIn: parent
            height: gridLoader.height > gridBackgroundRectangle.height
                    ? gridBackgroundRectangle.height - 10 : gridLoader.height
            width: gridLoader.width > gridBackgroundRectangle.width
                   ? gridBackgroundRectangle.width - 10 : gridLoader.width
            clip: true
            contentHeight: gridLoader.height
            contentWidth: gridLoader.width

            ScrollBar.vertical: verticalScrollBar
            ScrollBar.horizontal: horizontalScrollBar

            /// GRID
            Loader {
                id: gridLoader
                asynchronous: true
                visible: status == Loader.Ready

            }//
        }//

        BusyIndicatorApp {
            anchors.centerIn: parent
            visible: gridLoader.status == Loader.Loading
        }//
    }//

    Rectangle{
        id: verticalScrollRectangle
        Layout.fillHeight: true
        Layout.minimumWidth: 10
        color: "transparent"
        border.color: "#dddddd"
        radius: 5

        /// Vertical ScrollBar
        ScrollBar {
            id: verticalScrollBar
            anchors.fill: parent
            orientation: Qt.Horizontal
            policy: ScrollBar.AlwaysOn

            contentItem: Rectangle {
                implicitWidth: 5
                implicitHeight: 0
                radius: width / 2
                color: "#dddddd"
            }//
        }//
    }//

    Rectangle{
        id: horizontalScrollRectangle
        Layout.minimumHeight: 10
        Layout.fillWidth: true
        color: "transparent"
        border.color: "#dddddd"
        radius: 5

        /// Horizontal ScrollBar
        ScrollBar {
            id: horizontalScrollBar
            anchors.fill: parent
            orientation: Qt.Horizontal
            policy: ScrollBar.AlwaysOn

            contentItem: Rectangle {
                implicitWidth: 0
                implicitHeight: 5
                radius: width / 2
                color: "#dddddd"
            }//
        }//
    }//
}//
