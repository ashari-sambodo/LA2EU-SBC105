pragma Singleton
/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import ModulesCpp.Machine 1.0

Item {
    id: control

    readonly property int statusStop:  0
    readonly property int statusPlay:  1
    readonly property int statusPause: 2

    property int status: statusStop

    property bool timeout: false
    property bool isPaused: status == statusPause
    property bool isRunning: status == statusPlay

    property int count: 0
    property int countTotal: 0
    signal experminetTimerOver(bool status)

    onTimeoutChanged: {
        experminetTimerOver(timeout)
        if(timeout){
            MachineAPI.insertEventLog(qsTr("Experiment timer is completed"))
        }
    }//

    function start(){
        if(countTotal == 0) return
        if(status !== statusPause) count = countTotal
        status = statusPlay
        timeout = false
        MachineAPI.insertEventLog(qsTr("Experiment timer is started"))
    }

    function pause(){
        status = statusPause
        MachineAPI.insertEventLog(qsTr("Experiment timer is paused"))
    }

    function stop(){
        status = statusStop
        MachineAPI.insertEventLog(qsTr("Experiment timer is stopped"))
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
