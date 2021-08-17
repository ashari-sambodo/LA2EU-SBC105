pragma Singleton
/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0

Item {
    id: control

    readonly property int statusStop:  0
    readonly property int statusPlay:  1
    readonly property int statusPause: 2

    property int status: 0

    property bool timeout: false
    property bool isPaused: status == statusPause
    property bool isRunning: status == statusPlay

    property int count: 0
    property int countTotal: 0

    function start(){
        if(countTotal == 0) return
        if(status !== statusPause) count = countTotal
        status = statusPlay
        timeout = false
    }

    function pause(){
        status = statusPause
    }

    function stop(){
        status = statusStop
    }

    Timer {
        id: timer
        running: status == statusPlay
        interval: 1000
        repeat: true
        onTriggered: {
            if(count <= 0) {
                status = statusStop
                timeout = true
            }
            else {
                count = count - 1
            }
        }//
    }//
}//
