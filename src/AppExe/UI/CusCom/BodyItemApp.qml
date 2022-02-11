/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0

import "BodyItemApp"

Item {
    id: control

    readonly property int splashMessageTypeWarning: 1

    function showSplashMessage(message, color){
        if (message === undefined) message = "Splash Message!"
        if (color === undefined) color = "#e74c3c"

        let component = Qt.createComponent("BodyItemApp/SplashMessageApp.qml");
        let splashMessage = component.createObject(control, {"text": message, "backgroundColor": color});
    }
}
