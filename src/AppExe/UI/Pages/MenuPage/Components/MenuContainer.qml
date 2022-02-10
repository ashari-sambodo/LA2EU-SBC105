/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0

Item {
    id: control
    property var model: []

    function initSource(){
        gridLoader.setSource("GridMenu.qml", {"model": model})
    }

    signal clicked(variant mtype, variant mlink, variant msub)
    onClicked: {
        control.parent.clicked(mtype, mlink, msub)
    }

    Loader{
        id: gridLoader
        anchors.fill: parent
        asynchronous: true
        visible: status == Loader.Ready

        onLoaded: {
            gridLoader.item.clicked.connect(control.clicked)
        }

        scale: visible ? 1.0 : 0.9
        Behavior on scale {
            NumberAnimation { duration: 100}
        }//
    }//

    AnimatedImage {
        visible: gridLoader.status == Loader.Loading
        playing: visible
        anchors.centerIn: parent
        source: "qrc:/UI/CusCom/BusyIndicatorApp/esco_loading_150x150.gif"
        cache: false
        onFrameChanged: {
            console.debug("Menu Container Loader", currentFrame)
        }
    }

    Component.onCompleted: {
        initSource()
    }
}
