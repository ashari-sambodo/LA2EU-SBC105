/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0

Loader {
    id: control
    //    property alias sourceComponent: control.sourceComponent
    //    property alias status: control.status
    //    property alias asynchronous: control.asynchronous

    //    // to ensure the loader content not visible until loader item has ready
    //    property bool forceVisibleContentItem: true

    //    Loader {
    //        id: control
    //        anchors.fill: parent
    //        visible: (status == Loader.Ready) || forceVisibleContentItem
    //    }

    onLoaded: control.item.visible = true

    Image {
        visible: status == Loader.Loading
        anchors.centerIn: parent
        source: "LoaderItemApp/loading.png"
    }
}
