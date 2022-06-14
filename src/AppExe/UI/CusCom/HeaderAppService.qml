pragma Singleton
import QtQuick 2.0

QtObject {
    signal vendorLogoPressandHold()

    property int alert: 0
    property bool alertBlinking: false
    property string modelName: ""
    property bool sideGlass: false
    property bool darkMode: false
    property string sourceImgLogo: darkMode ? "HeaderApp/Logo_dark.png" : "HeaderApp/Logo.png"
    property int timePeriod: 12 // 12H

    function setAlert(value){
        //        //console.debug(value)
        alert = value
    }
    function setAlertBlinking(value){
        alertBlinking = value
    }
    function setDarkMode(value){
        darkMode = value === 1
    }
}
