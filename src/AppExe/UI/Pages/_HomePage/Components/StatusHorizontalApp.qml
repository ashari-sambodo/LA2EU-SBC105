/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0

import UI.CusCom 1.1

Rectangle {
    //    height: parent.height
    //    width: parent.width + 150
    //    x: -150
    color: hightlighted ? "#DA0000" : "#0F2952"
    radius: 5
    border.width: 2
    border.color: "#777777"

    property bool hightlighted: false

    property alias contentItem: contentView
    property alias textLabel: labelText.text
    property alias textValue: valueText.text
    property alias textValueFormat: valueText.textFormat

    Item {
        id: contentView
        height: parent.height
        width: parent.width

        RowLayout {
            anchors.fill: parent
            anchors.margins: 1

            Item {
                id: statusLabelItem
                Layout.fillHeight: true
                Layout.minimumWidth: 200

                TextApp {
                    id: labelText
                    height: parent.height
                    width: parent.width
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 36
                    fontSizeMode: Text.Fit
                    text: "Label:"
                }//
            }//

            Item {
                id: statusValueItem
                Layout.fillHeight: true
                Layout.fillWidth: true

                TextApp {
                    id: valueText
                    height: parent.height
                    width: parent.width
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 36
                    fontSizeMode: Text.Fit
                    text: "Value"
                }//
            }//
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
