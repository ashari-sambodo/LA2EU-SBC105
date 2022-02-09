/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import UI.CusCom 1.1

Item {
    id: control
    height: grid.height
    width: grid.width

    //    height: grid.height > control.height ? control.height - 10 : grid.height
    //    width: grid.width > control.width ? control.width - 10 : grid.width
    property alias measureUnit: grid.measureUnit
    property alias model: grid.model
    property alias columns: grid.columns

    property alias valueMinimum: grid.valueMinimum
    property alias valueMaximum: grid.valueMaximum

    signal clickedItem(int index, double value, string valueStrf)

    AirflowGridApp {
        id: grid
        measureUnit: 0
        Component.onCompleted: {
            grid.clickedItem.connect(control.clickedItem)
        }
    }//
}

//Item {
//    id: control

//    property alias model: grid.model
//    property alias columns: grid.columns

//    property alias valueMinimum: grid.valueMinimum
//    property alias valueMaximum: grid.valueMaximum

//    signal clickedItem(int index, double value, string valueStrf)

//    Flickable {
//        id: flick
//        anchors.centerIn: parent
//        height: grid.height > control.height ? control.height - 10 : grid.height
//        width: grid.width > control.width ? control.width - 10 : grid.width
//        clip: true
//        contentHeight: grid.height
//        contentWidth: grid.width

//        //                                ScrollBar.vertical: ScrollBar { }
//        //                                ScrollBar.horizontal: ScrollBar { }

//        AirflowGridApp {
//            id: grid

//            Component.onCompleted: {
//                grid.clickedItem.connect(control.clickedItem)
//            }
//        }//
//    }//
//}
