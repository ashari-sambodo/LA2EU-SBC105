/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0

Grid{
    id: pointCalGrid
    spacing: 2
    columns: 7

    property real valueMinimum: 0.33
    property real valueMaximum: 0.35

    property alias model: gridRepeater.model

    signal clickedItem(int index, double value, string valSf)

    Repeater{
        id: gridRepeater
        model: [
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
            //            {value: 0.33, valSf: "0.33", acc: 0},
        ]

        Rectangle{
            id: gridRect
            height: 80
            width: 100
            radius: 5
            //            color: modelData.acc ? "#95a5a6" : "#ecf0f1"
            color: modelData.acc ? "#8e44ad" : "#7f8c8d"

            ColumnLayout{
                anchors.fill: parent
                spacing: 0

                Rectangle{
                    id: boxHeaderRectangle
                    Layout.fillWidth: true
                    Layout.minimumHeight: 30
                    color: "#2ecc71"
                    //                    color: modelData.value === valueMinimum ? "#e74c3c"
                    //                                                                 : (modelData.value === valueMaximum ? "#e67e22" : "#2ecc71")
                    Text{
                        id: titleTextApp
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: "P-" + (index + 1)
                        font.pixelSize: 20
                        color: "#dddddd"
                    }

                    Component.onCompleted: {
                        let value = modelData.value

                        //console.debug("modelData:" + value)
                        //console.debug(pointCalGrid.valueMinimum)
                        //console.debug(pointCalGrid.valueMaximum)

                        let colorHeader = "#27ae60"
                        if (value <= pointCalGrid.valueMinimum) {
                            colorHeader = "#e67e22"
                        }
                        else if (value >= pointCalGrid.valueMaximum) {
                            colorHeader = "#e74c3c"
                        }

                        boxHeaderRectangle.color = colorHeader
                    }
                }

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Text{
                        id: containtTextApp
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 32
                        text: modelData.valSf
                        color: "#dddddd"
                    }
                }
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    //console.debug("Press")
                    pointCalGrid.clickedItem(index, modelData.value, modelData.valSf)
                }
            }
        }
    }
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
