import QtQuick 2.0
import QtQuick.Layouts 1.0
import UI.CusCom 1.1

Rectangle {
    radius: 5
    color: "#db6400"
    border.color: "#e3dac9"

    property alias text: textApp.text

    RowLayout {
        anchors.fill: parent

        Item {
            Layout.fillHeight: true
            Layout.minimumWidth: height

            Image {
                source: "qrc:/UI/Pictures/badge-warning.png"
                anchors.centerIn: parent
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            TextApp {
                id: textApp
                anchors.fill: parent
                anchors.margins: 2
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                //                wrapMode: Text.WordWrap

                text: "Data log is full!"
            }
        }//
    }//
}//
