import QtQuick 2.0
import QtQuick.Layouts 1.0

import UI.CusCom 1.0

Rectangle {
    //    height: parent.height
    //    width: parent.width + 150
    //    x: -150
    color: hightlighted ? "#ff0000" : "#770F2952"
    radius: 5
    border.width: 1
    border.color: "gray"

    property bool hightlighted: false

    property alias contentItem: containerItem
    property alias textLabel: labelText.text
    property alias textValue: valueText.text

    Item {
        id: containerItem
        //        x: 150
        height: parent.height
        width: parent.parent.width

        RowLayout {
            anchors.fill: parent
            anchors.margins: 1

            Item {
                id: statusLabelItem
                Layout.fillHeight: true
                Layout.minimumWidth: 200

                TextApp {
                    id: labelText
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 36
                    text: "Label:"
                }//
            }//

            Item {
                id: statusValueItem
                Layout.fillHeight: true
                Layout.fillWidth: true

                TextApp {
                    id: valueText
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 36
                    text: "Value"
                }//
            }//
        }//
    }//
}//
