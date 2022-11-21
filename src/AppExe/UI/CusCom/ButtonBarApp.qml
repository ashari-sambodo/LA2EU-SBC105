import QtQuick 2.12
import ModulesCpp.Machine 1.0

Item {
    id: control
    implicitWidth: 200
    implicitHeight: MachineAPI.FOOTER_HEIGHT-10
    //    radius: 5
    //    border.color: "#dddddd"
    //    color: controlMouseArea.pressed ?  "#55ffffff" : "transparent"
    opacity: controlMouseArea.pressed || !enabled ?  0.5 : 1

    property alias imageSource: controlImage.source
    property alias text: controlText.text
    property bool darkMode: MachineData.displayTheme === MachineAPI.THEME_DARK

    signal clicked()

    Image {
        enabled: !control.darkMode
        visible: enabled
        anchors.fill: parent
        source: "ButtonBarApp/buttonBarBackground.png"
    }
    Rectangle{
        enabled: control.darkMode
        visible: enabled
        anchors.fill: parent
        color: "black"
        border.width: 1
        border.color: (MachineData.alarmsState && MachineData.alarmFrontEndBackground) ? "red" : "#B2A18D"
    }

    Row {

        Image {
            id: controlImage
            source: "ButtonBarApp/button-icon.png"
            width: MachineAPI.FOOTER_HEIGHT-10
            height: MachineAPI.FOOTER_HEIGHT-10
            Rectangle{
                visible: control.darkMode
                color: "#44000000"
                anchors.fill: parent
                anchors.margins: 1
            }
        }

        Text {
            id: controlText
            //            width: 140
            width: control.width * 0.70 - 5
            height: MachineAPI.FOOTER_HEIGHT-10
            padding: 2
            text: qsTr("text")
            verticalAlignment: Text.AlignVCenter
            color: control.darkMode ? "#B2A18D" : "#dddddd"
            font.pixelSize: 20
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
        }
    }

    MouseArea {
        id: controlMouseArea
        anchors.fill: parent
        onClicked: control.clicked()
    }

    //    TapHandler {
    //        onTapped: control.clicked()
    //    }
}
