/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0

Item {
    id: control

    property bool established: false
    signal message(variant messageObject)

    function j2s(id, obj){
        ws.sendMessage({'id': id, 'conv': 'j2s', 'data': obj})
    }

    function s2j(id, str){
        ws.sendMessage({'id': id, 'conv': 's2j', 'data': str})
    }

    function sendMessage(message){
        ws.sendMessage(message)
    }

    WorkerScript{
        id: ws
        source: "JsonStringifyApp/WorkerScript_JsonStringifyApp.js"

        //        onMessage: {
        //console.debug(messageObject['dataStr'])
        //        }//

        Component.onCompleted: {
            control.established = true
            ws.onMessage.connect(control.message)
        }//
    }//
}//
