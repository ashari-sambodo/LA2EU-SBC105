/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/
pragma Singleton

import QtQuick 2.0

Item {

    readonly property int roleLevelGuest:   0
    readonly property int roleLevelOperator: 1
    readonly property int roleLevelSupervisor:  2
    readonly property int roleLevelAdmin:   3
    readonly property int roleLevelService: 4
    readonly property int roleLevelFactory: 5

    property bool   loggedIn:     false
    property string username:   ""
    property int    roleLevel:  0
    property string fullname:   ""

    signal askedForLogin()

    function logout(){
        loggedIn  = false
        username  = ""
        roleLevel = 0
        fullname  = ""
    }
}
