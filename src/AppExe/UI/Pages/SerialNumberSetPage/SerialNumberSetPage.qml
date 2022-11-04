/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Ahmad Qodri
**/

import QtQuick 2.14
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Serial Number"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: Item{
        id: contentView
        height: viewApp.height
        width: viewApp.width

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 5

            /// HEADER
            Item {
                id: headerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 60

                HeaderApp {
                    id: headerApp
                    anchors.fill: parent
                    title: qsTr("Serial Number")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column {
                    id: serialNumberColumn
                    anchors.centerIn: parent
                    spacing: 0

                    Image{
                        anchors.right: parent.right
                        source: "qrc:/UI/Pictures/serial-number-icon.png"
                        fillMode: Image.PreserveAspectFit
                    }//

                    TextApp{
                        text: qsTr("Current")
                        verticalAlignment: Text.AlignBottom
                    }//

                    TextApp{
                        id: serialNumberText
                        text: props.serialNumber
                        font.pixelSize: 56

                    }//

                    TextApp{
                        text: "(" + qsTr("Tap to change") + ")"
                        color: "#929292"
                    }//
                }//

                MouseArea{
                    id: serialNumberMouseArea
                    anchors.fill: serialNumberColumn
                }//

                TextInput{
                    id: serialNumberBufferTextInput
                    visible: false
                    //validator: RegularExpressionValidator { regularExpression: /\d{4}(?:-\d{5,8})+$/}

                    Connections{
                        target: serialNumberMouseArea
                        function onClicked(){
                            serialNumberBufferTextInput.text = props.serialNumber
                            //serialNumberBufferTextInput.text = props.serialNumber
                            //                            KeyboardOnScreenCaller.openNumpad(serialNumberBufferTextInput, qsTr("Serial Number"))
                            KeyboardOnScreenCaller.openKeyboard(serialNumberBufferTextInput, qsTr("Serial Number"))
                        }//
                    }//

                    onAccepted: {
                        let regex = /\d{4}(?:-\d{6})+$/
                        let serialNumberValid = true;
                        let serialStr = String(text)
                        let textLength = serialStr.split("-").length
                        console.debug(serialStr, textLength)
                        if(textLength < 2 || textLength > 3) serialNumberValid = false
                        else{
                            let str1, str2
                            let isStr1Valid, isStr2Valid = true
                            str1 = String(serialStr.split("-")[0]) + "-" + String(serialStr.split("-")[1])
                            isStr1Valid = str1.match(regex)

                            if(textLength === 3){
                                str2 = String(serialStr.split("-")[2])
                                if(str2.charAt(0) !== "R")
                                    isStr2Valid = false
                            }//
                            if(!isStr1Valid || !isStr2Valid){
                                serialNumberValid = false
                            }
                            //                            console.debug(str1, str2)
                            //                            console.debug(isStr1Valid, isStr2Valid)
                        }//

                        if(serialNumberValid){
                            if(props.serialNumber !== text){
                                props.serialNumber = text
                                //console.debug("Serial Number: ", props.serialNumber)

                                MachineAPI.setSerialNumber(text)

                                viewApp.showBusyPage(qsTr("Setting Serial Number..."),
                                                     function onTriggered(cycle){
                                                         if(cycle >= MachineAPI.BUSY_CYCLE_1){
                                                             viewApp.dialogObject.close()}
                                                     })
                            }
                        }
                        else {
                            const autoClosed = false
                            viewApp.showDialogMessage(qsTr("Serial Number"),
                                                      qsTr("Invalid Serial Number!. Make sure the format is YYYY-XXXXXX or YYYY-XXXXXX-R"),
                                                      viewApp.dialogAlert,
                                                      function onClosed(){},
                                                      autoClosed)
                        }
                    }//
                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: MachineAPI.FOOTER_HEIGHT

                Rectangle {
                    anchors.fill: parent
                    color: "#0F2952"
                    //                    border.color: "#e3dac9"
                    //                    border.width: 1
                    radius: 5

                    Item {
                        anchors.fill: parent
                        anchors.margins: 5

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }
                        }//
                    }//
                }//
            }
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props
            property string serialNumber : ""

            function onNewQRCodeDataAccepted(value){
                console.debug("Incoming QRCode data:", value)
                const lengthData = String(value).split("#").length
                let key1, key2
                let val1, val2
                if(lengthData == 2){
                    // For Unit Model and Electrical FocusPanel
                    // Use this format in QR Code
                    // Model LA2-4S#SN 2022-002101
                    // Panel EP-A-LA2-001#SN EP.11290/22
                    key1 = String(value).split("#")[0].split(" ")[0]
                    key2 = String(value).split("#")[1].split(" ")[0]
                    val1 = String(value).split("#")[0].split(" ")[1]
                    val2 = String(value).split("#")[1].split(" ")[1]

                    const keyValid = (key1 === "Model") && (key2 === "SN")
                    const val1Valid = true
                    const val2Valid = (val2.split("-")[0].length === 4 && val2.split("-")[1].length === 6)
                    if(keyValid && val1Valid && val2Valid){
                        MachineAPI.setSerialNumber(val2)
                    }//
                    else{
                        console.debug("invalid key or value!")
                    }//

                    console.debug("key1", key1, "key2", key2)
                    console.debug("val1", String(value).split("#")[0].split(" ")[1], "val2", String(value).split("#")[1].split(" ")[1])
                    return
                }//
                else{
                    console.debug("Invalid Value")
                }
            }//
        }//

        /// called Once but after onResume
        Component.onCompleted: {
            MachineAPI.setFrontEndScreenState(MachineAPI.ScreenState_SerialNumber)
        }//

        /// Execute This Every This Screen Active/Visible
        Loader {
            active: viewApp.stackViewStatusForeground
            sourceComponent: QtObject {

                /// onResume
                Component.onCompleted: {
                    ////console.debug("StackView.Active");
                    props.serialNumber = Qt.binding(function(){return MachineData.serialNumber})
                    MachineData.keyboardStringOnAcceptedEventSignal.connect(props.onNewQRCodeDataAccepted)
                }//

                /// onPause
                Component.onDestruction: {
                    ////console.debug("StackView.DeActivating");
                    MachineData.keyboardStringOnAcceptedEventSignal.disconnect(props.onNewQRCodeDataAccepted)

                    MachineAPI.setFrontEndScreenState(MachineAPI.ScreenState_Other)
                }
            }//
        }//
    }//
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/
