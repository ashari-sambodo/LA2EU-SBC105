import QtQuick 2.14
import UI.CusCom 1.0
import Qt.labs.settings 1.1

import ModulesCpp.Machine 1.0

Item {
    id: control

    property bool fieldOrFull

    Grid {
        anchors.centerIn: parent
        columnSpacing: 10
        spacing: 5
        columns: 2

        Column {
            spacing: 5

            TextApp {
                id: modelText
                text: qsTr("Cabinet Model")
            }//

            TextFieldApp {
                id: cabModelTextField
                width: 300
                height: 40
                //                text: "LA2-4S8 NS"

                onPressed: {
                    KeyboardOnScreenCaller.openKeyboard(this, modelText.text)
                }//

                onAccepted: {
                    settings.cabinetModel = text
                }//
            }//
        }//

        Column {
            visible: fieldOrFull
            spacing: 5

            TextApp {
                id: calibProText
                text: qsTr("Calibration Procedure")
            }//

            TextFieldApp {
                id: calibProTextField
                width: 300
                height: 40
                //                text: "LA2-4S8 NS"

                onPressed: {
                    KeyboardOnScreenCaller.openKeyboard(this, calibProText.text)
                }//

                onAccepted: {
                    settings.calibProc = text
                }//
            }//
        }//

        Column {
            spacing: 5

            TextApp {
                id: serialNumberText
                text: qsTr("Serial Number")
            }//

            TextFieldApp {
                id: serialNumberTextField
                width: 300
                height: 40
                //                text: "2021-123456"

                onPressed: {
                    KeyboardOnScreenCaller.openKeyboard(this, qsTr("Serial Number"))
                }//

                onAccepted: {
                    settings.serialNumber = text
                }//

                Component.onCompleted: {
                    text = settings.serialNumber
                }//
            }//
        }//


        Column {
            spacing: 5

            TextApp {
                id: powerRatingText
                text: qsTr("Power Rating")
            }//

            TextFieldApp {
                id: powerRatingTextField
                width: 300
                height: 40
                //                text: "120 VAC / 50Hz"

                onPressed: {
                    KeyboardOnScreenCaller.openKeyboard(this, qsTr("Power Rating"))
                }//

                onAccepted: {
                    settings.powerRating = text
                }//

                Component.onCompleted: {
                    text = settings.powerRating
                }//
            }//
        }//

        Row {
            spacing: 10

            Column {
                visible: fieldOrFull

                spacing: 5

                TextApp {
                    text: qsTr("Room Temp / Pressure")
                }//

                Row {
                    spacing: 10

                    Row {
                        spacing: 2

                        TextFieldApp {
                            id: roomTempTextField
                            width: 100
                            height: 40
                            text: "20"

                            onPressed: {
                                KeyboardOnScreenCaller.openKeyboard(this, qsTr("Temperature"))
                            }//

                            onAccepted: {
                                if(MachineData.measurementUnit){
                                    settings.tempRoomImp = Number(text)
                                    settings.tempRoom = utils.fahrenheitToCelcius(settings.tempRoomImp)
                                }
                                else{
                                    settings.tempRoom = Number(text)
                                    settings.tempRoomImp = utils.celciusToFahrenheit(settings.tempRoom)
                                }
                            }//
                        }//

                        TextApp {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "°C"

                            Component.onCompleted: {
                                text = MachineData.measurementUnit ? "°F" : "°C"
                            }
                        }//
                    }//

                    Row {
                        spacing: 2

                        TextFieldApp {
                            id: roomPressTextField
                            width: 100
                            height: 40
                            text: "1.0005"

                            onPressed: {
                                KeyboardOnScreenCaller.openKeyboard(this, qsTr("Pressure"))
                            }//

                            onAccepted: {
                                settings.pressRoom = text
                            }//

                        }//

                        TextApp {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "bar"
                        }//
                    }//
                }//
            }//
        }//

        Column {
            visible: fieldOrFull
            spacing: 5

            TextApp {
                text: qsTr("PAO concentration")
            }//

            Row {
                spacing: 2

                TextFieldApp {
                    id: paoConTextField
                    width: 200
                    height: 40
                    text: "0.0005"

                    onPressed: {
                        KeyboardOnScreenCaller.openNumpad(this, qsTr("PAO concentration"))
                    }//

                    onAccepted: {
                        settings.paoCons = text
                    }//
                }//

                TextApp {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "μg/liter"
                }//
            }//
        }//

        Column {
            visible: fieldOrFull
            spacing: 5

            TextApp {
                text: qsTr("No Laskin Nozzles")
            }//

            TextFieldApp {
                id: noLaskinTextField
                width: 100
                height: 40
                //                text: "2"

                onPressed: {
                    KeyboardOnScreenCaller.openNumpad(this, qsTr("No Laskin Nozzles"))
                }//

                onAccepted: {
                    settings.noLaskin = text
                }//
            }//
        }//

        Column {
            visible: fieldOrFull
            spacing: 5

            TextApp {
                text: qsTr("DF Particle Penetration")
            }//

            Row {
                spacing: 2

                TextFieldApp {
                    id: dfParticlePenetration
                    width: 200
                    height: 40
                    text: "0.00"

                    onPressed: {
                        KeyboardOnScreenCaller.openNumpad(this, qsTr("DF Particle Penetration"))
                    }//

                    onAccepted: {
                        settings.dfParPenet = text
                    }//
                }//

                TextApp {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "%"
                }//
            }//
        }//

        Column {
            visible: fieldOrFull
            spacing: 5

            TextApp {
                text: qsTr("Damper Opening")
            }//

            Row {
                spacing: 2

                TextFieldApp {
                    id: damOpTextField
                    width: 100
                    height: 40
                    text: "10"
                    validator: RegularExpressionValidator { regularExpression: /\d{1,2}(?:\/\d{1,2})+$/}
                    onPressed: {
                        if(MachineData.measurementUnit)
                            KeyboardOnScreenCaller.openKeyboard(this, qsTr("Damper Opening"))
                        else
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Damper Opening"))
                    }//

                    onAccepted: {
                        const value = text
                        if(MachineData.measurementUnit)
                        {
                            const damperOpenText = text.split("/")
                            if(damperOpenText.length === 2){
                                settings.damperOpenImp = value
                                settings.damperOpen = Math.round((Number(value.split("/")[0]) / Number(value.split("/")[1])) * 25.4)
                            }
                        }
                        else{
                            settings.damperOpen = value
                            settings.damperOpenImp = (Number(value)/25.4).toFixed(1)
                        }
                    }//

                    Component.onCompleted: {
                        text = MachineData.measurementUnit ? settings.damperOpenImp : settings.damperOpen
                    }//
                }//

                TextApp {
                    anchors.verticalCenter: parent.verticalCenter
                    text: MachineData.measurementUnit ? "inch" : "mm"
                }//
            }//
        }

        Column {
            visible: fieldOrFull
            spacing: 5

            TextApp {
                text: qsTr("IF Particle Penetration")
            }//

            Row {
                spacing: 2

                TextFieldApp {
                    id: ifParticlePenetration
                    width: 200
                    height: 40
                    text: "0.00"

                    onPressed: {
                        KeyboardOnScreenCaller.openNumpad(this, qsTr("IF Particle Penetration"))
                    }//

                    onAccepted: {
                        settings.ifParPenet = text
                    }//
                }//

                TextApp {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "%"
                }//
            }//
        }//
    }//

    Settings {
        id: settings
        category: "certification"

        property string cabinetModel:   MachineData.machineModelName
        property string calibProc:      ""
        property string serialNumber:   MachineData.serialNumber
        property string powerRating:    "220 VAC / 50Hz"
        property int    tempRoom:       MachineData.temperatureCelcius
        property int tempRoomImp:       utils.celciusToFahrenheit(MachineData.temperatureCelcius)
        property string pressRoom:      "1.0005"
        property string paoCons:        "0.0005"
        property string dfParPenet:     "0.0000"
        property string ifParPenet:     "0.0000"
        property int    noLaskin:       2
        property string damperOpen:     "10"
        property string damperOpenImp:  "2/5"

        Component.onCompleted: {
            cabModelTextField.text = cabinetModel
            calibProTextField.text = calibProc
            serialNumber = MachineData.serialNumber
            serialNumberTextField.text = serialNumber
            powerRatingTextField.text = powerRating
            if(MachineData.measurementUnit)
                roomTempTextField.text = tempRoomImp
            else
                roomTempTextField.text = tempRoom
            roomPressTextField.text = pressRoom
            paoConTextField.text = paoCons
            noLaskinTextField.text = noLaskin
            damOpTextField.text = MachineData.measurementUnit ? damperOpenImp : damperOpen
            dfParticlePenetration.text = dfParPenet
            ifParticlePenetration.text = ifParPenet
        }//
    }//

    UtilsApp{
        id: utils
    }

}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
