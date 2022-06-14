import QtQuick 2.0
import ModulesCpp.Machine 1.0

Rectangle {
    anchors.fill: parent
    color: HeaderAppService.darkMode ? "black" : "#0F2952"
    border.color: (MachineData.alarmsState && MachineData.alarmFrontEndBackground)? "red" : "#B2A18D"
    border.width: HeaderAppService.darkMode ? 1 : 0
    radius: 5
}
