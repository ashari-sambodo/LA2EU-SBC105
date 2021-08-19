import QtQuick 2.0
import Qt.labs.platform 1.0
import Qt.labs.settings 1.1
import UI.CusCom 1.0

Item {

    Column {
        anchors.centerIn: parent
        spacing: 5

        Grid {
            anchors.horizontalCenter: parent.horizontalCenter
            columnSpacing: 10
            spacing: 5
            columns: 2

            Column {
                spacing: 5

                TextApp {
                    text: qsTr("Customer")
                }//

                TextFieldApp {
                    id: customerText
                    width: 300
                    height: 40
                    text: "WORLD-MTR"

                    onPressed: {
                        KeyboardOnScreenCaller.openKeyboard(this, qsTr("Customer"))
                    }//

                    onAccepted: {
                        text = text.toUpperCase()
                        settings.customer = text
                    }//
                }//
            }//

            Column {
                spacing: 5

                TextApp {
                    text: qsTr("Country")
                }//

                TextFieldApp {
                    id: countryText
                    width: 300
                    height: 40
                    text: "SINGAPORE"

                    onPressed: {
                        KeyboardOnScreenCaller.openKeyboard(this, qsTr("Country"))
                    }//

                    onAccepted: {
                        text = text.toUpperCase()
                        settings.country = text
                    }//
                }//
            }//

            Column {
                spacing: 5
                TextApp {
                    text: qsTr("Date")
                }//

                TextFieldApp {
                    id: dateText
                    width: 300
                    height: 40
                    text: "28-Jan-2021"

                    onPressed: {
                        KeyboardOnScreenCaller.openKeyboard(this, qsTr("Date"))
                    }//

                    onAccepted: {
                        settings.dateTest = text
                    }//
                }//
            }//

            Column {
                spacing: 5
                TextApp {
                    text: qsTr("Software version")
                }//

                TextFieldApp {
                    id: swText
                    width: 300
                    height: 40
                    text: "SBC-V1.0.0-1"
                    enabled: false

                    onPressed: {
                        KeyboardOnScreenCaller.openKeyboard(this, qsTr("Software version"))
                    }//

                    onAccepted: {
                        settings.swVersion = text
                    }//
                }//
            }//

            Column {
                spacing: 10

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Tested by")
                    }//

                    TextFieldApp {
                        id: testerNameText
                        width: 300
                        height: 40

                        onPressed: {
                            KeyboardOnScreenCaller.openKeyboard(this, qsTr("Tested by"))
                        }//

                        onAccepted: {
                            settings.testerName = text
                        }//
                    }//
                }//

                Column {
                    spacing: 5
                    anchors.horizontalCenter: parent.horizontalCenter

                    TextApp {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Draw Signature")
                    }

                    Row{
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 5

                        Rectangle {

                            height: 110
                            width: 200
                            radius: 5
                            color: "#e3dac9"

                            Image {
                                id: savedTesterSignImage
                                cache: false
                                //                        source: "file"
                                Component.onCompleted: {
                                    const path = StandardPaths.writableLocation(StandardPaths.AppLocalDataLocation) + "/fullsigntester.png"
                                    source = path
                                }//

                                function reloadImage() {
                                    var oldSource = source
                                    source = ""
                                    source = oldSource
                                }//function to refresh the source

                                //                        onStatusChanged: {
                                //                            console.log(status)
                                //                        }//
                            }//

                            CanvasDrawByMouse {
                                id: signatureTesterCanvas
                                anchors.fill: parent
                                visible: false
                            }//
                        }//

                        Column {
                            spacing: 2

                            ButtonApp {
                                id: changeTesterSignButton
                                text: qsTr("Change")
                                width: 80
                                visible: true
                                onClicked: {
                                    changeTesterSignButton.visible = false
                                    saveTesterSignButton.visible = true
                                    clearTesterSignButton.visible = true
                                    savedTesterSignImage.visible = false
                                    signatureTesterCanvas.visible = true
                                }//

                                font.pixelSize: 14
                            }//

                            ButtonApp {
                                id: saveTesterSignButton
                                text: qsTr("Save")
                                width: 80
                                visible: false
                                onClicked: {
                                    saveTesterSignButton.visible = false
                                    clearTesterSignButton.visible = false

                                    const dataUrl = signatureTesterCanvas.toDataURL()
                                    const dataUrlPayload = dataUrl.replace("data:image/png;base64,", "")
                                    settings.testerSignature = Qt.btoa(dataUrlPayload)
                                    //                            console.log("dataUrl: " + dataUrl)

                                    const url = StandardPaths.writableLocation(StandardPaths.AppLocalDataLocation)
                                    const path = utilsApp.urlToPath(String(url))
                                    const pathImage = path + "/fullsigntester.png"
                                    //                            console.log("path: " + url)
                                    //                            console.log("path: " + path)

                                    signatureTesterCanvas.save(pathImage)
                                    signatureTesterCanvas.clear()

                                    savedTesterSignImage.reloadImage()

                                    signatureTesterCanvas.visible = false
                                    savedTesterSignImage.visible = true
                                    changeTesterSignButton.visible = true
                                }//

                                font.pixelSize: 14
                            }//

                            ButtonApp {
                                id: clearTesterSignButton
                                text: qsTr("Clear")
                                width: 80
                                visible: false
                                onClicked: {
                                    signatureTesterCanvas.clear()
                                }//

                                font.pixelSize: 14
                            }//
                        }//
                    }
                }//
            }//

            Column {
                spacing: 10

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Checked by")
                    }//

                    TextFieldApp {
                        id: checkerNameText
                        width: 300
                        height: 40

                        onPressed: {
                            KeyboardOnScreenCaller.openKeyboard(this, qsTr("Checked by"))
                        }//

                        onAccepted: {
                            settings.checkerName = text
                        }//
                    }//
                }//

                Column {
                    spacing: 5
                    anchors.horizontalCenter: parent.horizontalCenter

                    TextApp {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Draw Signature")
                    }

                    Row{
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 5

                        Rectangle {

                            height: 110
                            width: 200
                            radius: 5
                            color: "#e3dac9"

                            Image {
                                id: savedChackerSignImage
                                cache: false
                                //                        source: "file"
                                Component.onCompleted: {
                                    const path = StandardPaths.writableLocation(StandardPaths.AppLocalDataLocation) + "/fullsignchecker.png"
                                    source = path
                                }//
                                function reloadImage() {
                                    var oldSource = source
                                    source = ""
                                    source = oldSource
                                }//function to refresh the source

                                //                        onStatusChanged: {
                                //                            console.log(status)
                                //                        }//
                            }//

                            CanvasDrawByMouse {
                                id: signatureChackerCanvas
                                anchors.fill: parent
                                visible: false
                            }//
                        }//

                        Column {
                            spacing: 2

                            ButtonApp {
                                id: changeCheckerSignButton
                                text: qsTr("Change")
                                width: 80
                                visible: true
                                onClicked: {
                                    changeCheckerSignButton.visible = false
                                    saveChackerSignButton.visible = true
                                    clearChackerSignButton.visible = true
                                    savedChackerSignImage.visible = false
                                    signatureChackerCanvas.visible = true
                                }//

                                font.pixelSize: 14
                            }//

                            ButtonApp {
                                id: saveChackerSignButton
                                text: qsTr("Save")
                                width: 80
                                visible: false
                                onClicked: {
                                    saveChackerSignButton.visible = false
                                    clearChackerSignButton.visible = false

                                    const dataUrl = signatureChackerCanvas.toDataURL()
                                    const dataUrlPayload = dataUrl.replace("data:image/png;base64,", "")
                                    settings.checkerSignature = Qt.btoa(dataUrlPayload)
                                    //                            console.log("dataUrl: " + dataUrl)
                                    //                            console.log("dataUrlPayload: " + dataUrlPayload)
                                    //                            console.log("dataUrlPayloadbtoa: " + Qt.btoa(dataUrlPayload))
                                    //                            console.log("dataUrlPayloadatob: " + Qt.atob(Qt.btoa(dataUrlPayload)))

                                    const url = StandardPaths.writableLocation(StandardPaths.AppLocalDataLocation)
                                    const path = utilsApp.urlToPath(String(url))
                                    const pathImage = path + "/fullsignchecker.png"
                                    //                            console.log("path: " + url)
                                    //                            console.log("path: " + path)

                                    signatureChackerCanvas.save(pathImage)
                                    signatureChackerCanvas.clear()

                                    savedChackerSignImage.reloadImage()

                                    signatureChackerCanvas.visible = false
                                    savedChackerSignImage.visible = true
                                    changeCheckerSignButton.visible = true
                                }//

                                font.pixelSize: 14
                            }//

                            ButtonApp {
                                id: clearChackerSignButton
                                text: qsTr("Clear")
                                width: 80
                                visible: false
                                onClicked: {
                                    signatureChackerCanvas.clear()
                                }//

                                font.pixelSize: 14
                            }//
                        }//
                    }
                }//
            }//
        }//

        Rectangle {
            height: 1
            width: parent.width
            color: "#e3dac9"
        }//

        TextApp {
            text: qsTr("Name and signature is not saved permanently!")
            font.pixelSize: 16
        }//
    }//

    UtilsApp {
        id: utilsApp
    }//

    Settings {
        id: settings
        category: "certification"

        property string testerName:       ""
        property string testerSignature:  ""
        property string checkerName:      ""
        property string checkerSignature: ""

        property string customer:   "WORLD"
        property string country:    "SINGAPORE"
        property string dateTest:   Qt.formatDate(new Date, "dd-MMM-yyyy")
        property string swVersion:  Qt.application.name + " - " + Qt.application.version

        Component.onCompleted: {
            customerText.text = customer
            countryText.text = country

            settings.dateTest = Qt.formatDate(new Date, "dd-MMM-yyyy")
            dateText.text = settings.dateTest
            settings.swVersion = Qt.application.name + " - " + Qt.application.version
            swText.text = settings.swVersion

            testerNameText.text = ""/*testerName*/
            checkerNameText.text = ""/*checkerName*/
        }//
    }//

    //    Settings {
    //        id: settings
    //        category: "certification"

    //        property string testerName:         ""
    //        property string testerSignature:    ""
    //        property string checkerName:        ""
    //        property string checkerSignature:   ""

    //        property string customer:   "WORLD-MTR"
    //        property string country:    "SINGAPORE"
    //        property string dateTest:   Qt.formatDate(new Date, "dd-MMM-yyyy")
    //        property string swVersion:  Qt.application.name + " - " + Qt.application.version

    //        Component.onCompleted: {
    //            customerText.text = customer
    //            countryText.text = country
    //            dateText.text = dateTest
    //            swText.text = swVersion
    //            testerNameText.text = testerName
    //            checkerNameText.text = checkerName
    //        }//
    //    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/
