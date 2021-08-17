pragma Singleton
import QtQuick 2.0

QtObject {
    signal vendorLogoPressandHold()

    property int alert: 0
    property string modelName: ""
    property string sourceImgLogo: "HeaderApp/Logo.png"
    property int timePeriod: 12 // 12H

    function setAlert(value){
        //        //console.debug(value)
        alert = value
    }
}
