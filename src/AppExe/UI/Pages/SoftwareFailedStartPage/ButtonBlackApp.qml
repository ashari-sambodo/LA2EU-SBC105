import QtQuick 2.0
import UI.CusCom 1.1

Item {
    id: control
    implicitHeight: 60
    implicitWidth: 194

    property alias button : buttonRect
    property string iconSource : "qrc:/UI/Pictures/user-login.png"
    property string buttonText : "---"

    signal clicked()

    Rectangle {
        id: buttonRect
        anchors.fill: parent
        opacity: buttonMArea.pressed ? 0.5 : 1
        border.width: 1
        border.color: "#e3dac9"
        color:"transparent"
        anchors.verticalCenter: parent.verticalCenter
        Row{
            id: row2
            //anchors.fill: parent
            spacing: 0
            Image{
                id: iconBtn
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
                source: control.iconSource
            }
            TextApp{
                id: textBtn
                width: 0.65*control.width
                anchors.verticalCenter: parent.verticalCenter
                text: control.buttonText
//                font.family: "Courier";
                wrapMode: Text.WordWrap
            }
        }//
    }//
    MouseArea{
        id: buttonMArea
        anchors.fill: parent
        onClicked: {
            control.clicked()
        }//
    }//
}
