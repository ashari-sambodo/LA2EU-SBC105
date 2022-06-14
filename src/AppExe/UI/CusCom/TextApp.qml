import QtQuick 2.7

Text {
    id: textApp
    text: qsTr("text")
    color: HeaderAppService.darkMode ? "#B2A18D" : "#e3dac9"
    //color: "#decab0"
    font.pixelSize: 20
    fontSizeMode: Text.Fit // Define the width to enable this feature
    minimumPixelSize: 14
}//
