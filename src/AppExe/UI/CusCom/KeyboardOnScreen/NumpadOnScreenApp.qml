import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom.KeyboardOnScreen.Adapter 1.0

Item {
    id: rootItem

    property alias title: titleText.text
    property alias text: textField.text
    property alias validator: textField.validator
    property alias inputMask: textField.inputMask
    property alias echoMode: textField.echoMode

    property int widthButton: rootItem.width / 10
    property bool visibilityButton: false

    signal hideClicked();
    signal enterClicked(string textValue);

    function open() {
        visible = true
    }

    //BACKGROUND
    Rectangle{
        anchors.fill: parent
        color: rootItem.darkMode ? "#404244" : "#ecf0f1"
    }

    property bool darkMode: true

    // Block any clicked action outside button
    MouseArea {
        anchors.fill: parent
    }

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 5
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.minimumHeight: 50

            //            Rectangle{anchors.fill: parent}

            Text{
                id: titleText
                anchors.centerIn: parent
                text: "Title Text"
                font.pixelSize: 24
                color: rootItem.darkMode ? "#dddddd" : "#666666"
            }

            MouseArea {
                anchors.fill: parent
                onPressAndHold: {
                    rootItem.darkMode = !rootItem.darkMode
                }
            }
        }

        Item{
            Layout.fillWidth: true
            Layout.minimumHeight: 100

            RowLayout{
                anchors.fill: parent
                spacing: 0
                Item{
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    TextField{
                        id: textField
                        anchors.fill: parent
                        focus: true
                        font.pixelSize: 32

                        selectByMouse: true

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.IBeamCursor
                            acceptedButtons: Qt.NoButton
                        }

                        background: Rectangle {
                            anchors.fill: parent
                            radius: 5
                            color: "#e3dac9"
                        }

                        onAccepted: {
                            enterClicked(text)
                        }

                        onPressAndHold: {
                            selectWord()
                        }

                        onVisibleChanged: {
                            //                            //console.debug("onVisibleChanged")
                            if (visible) {
                                textField.forceActiveFocus()
                                delaySetFocusTimer.start()
                            }
                        }

                        Timer {
                            id: delaySetFocusTimer
                            interval: 200
                            onTriggered: {
                                textField.forceActiveFocus()
                                textField.selectAll()
                            }
                        }
                    }
                }

                Item {
                    id: tooglePassword_Item
                    visible: visibilityButton
                    Layout.fillHeight: true
                    Layout.minimumWidth: rootItem.widthButton

                    ButtonKeyApp{
                        text: ""
                        onClicked: {
                            if(textField.echoMode != TextInput.Password){
                                textField.echoMode = TextInput.Password
                            }else{
                                textField.echoMode =  TextInput.Normal
                            }
                        }

                        Image{
                            anchors.centerIn: parent
                            source: textField.echoMode == TextInput.Password ?
                                        (darkMode ?
                                             "Pictures/round_visibility_off_white_48dp.png":
                                             "Pictures/round_visibility_off_black_48dp.png") :
                                        (darkMode ?
                                             "Pictures/round_visibility_white_48dp.png":
                                             "Pictures/round_visibility_black_48dp.png")

                        }

                        darkMode: rootItem.darkMode
                    }
                }
            }
        }

        Item{
            Layout.fillWidth: true
            Layout.fillHeight: true

            //            Rectangle{anchors.fill: parent}

            Grid{
                id: keyGrid
                anchors.centerIn: parent

                Repeater{
                    model: [
                        {text:"7",      modeView: "text",    colorCustom: "",           imgWhite:"", imgDark:""},
                        {text:"8",      modeView: "text",    colorCustom: "",           imgWhite:"", imgDark:""},
                        {text:"9",      modeView: "text",    colorCustom: "",           imgWhite:"", imgDark:""},
                        {text:"-",      modeView: "text",    colorCustom: "",           imgWhite:"", imgDark:""},
                        {text:"4",      modeView: "text",    colorCustom: "",           imgWhite:"", imgDark:""},
                        {text:"5",      modeView: "text",    colorCustom: "",           imgWhite:"", imgDark:""},
                        {text:"6",      modeView: "text",    colorCustom: "",           imgWhite:"", imgDark:""},
                        {text:"+",      modeView: "text",    colorCustom: "",           imgWhite:"", imgDark:""},
                        {text:"1",      modeView: "text",    colorCustom: "",           imgWhite:"", imgDark:""},
                        {text:"2",      modeView: "text",    colorCustom: "",           imgWhite:"", imgDark:""},
                        {text:"3",      modeView: "text",    colorCustom: "",           imgWhite:"", imgDark:""},
                        {text:"BS",     modeView: "image",   colorCustom: "",           imgWhite:"Pictures/round_backspace_white_48dp.png",        imgDark:"Pictures/round_backspace_black_48dp.png", },
                        {text:"Hide",   modeView: "image",   colorCustom: "",           imgWhite:"Pictures/round_keyboard_hide_white_48dp.png",    imgDark:"Pictures/round_keyboard_hide_black_48dp.png", },
                        {text:"0",      modeView: "text",    colorCustom: "",           imgWhite:"", imgDark:""},
                        {text:".",      modeView: "text",    colorCustom: "",           imgWhite:"", imgDark:""},
                        {text:"Enter",  modeView: "image",   colorCustom: "#2ecc71",    imgWhite:"Pictures/round_done_white_48dp.png",             imgDark:"Pictures/round_done_black_48dp.png", }
                    ]

                    Item{
                        height: keyGrid.parent.height / 4
                        width: keyGrid.parent.width / 4

                        ButtonKeyApp {
                            id: button
                            text: modelData["modeView"] === "image" ? " " : modelData["text"]
                            anchors.fill: parent

                            onClicked: {
                                rootItem.keyClicked(modelData["text"])
                            }

                            onPressAndHold: {
                                rootItem.keyPressAndHold(modelData["text"])
                            }

                            darkMode: rootItem.darkMode

                            Loader{
                                active: modelData["modeView"] === "image"
                                anchors.centerIn: parent
                                sourceComponent: Image{
                                    //                                    anchors.centerIn: parent
                                    fillMode: Image.PreserveAspectFit
                                    source: darkMode ? modelData["imgWhite"] : modelData["imgDark"]
                                }
                            }

                            Component.onCompleted: {
                                if (modelData["colorCustom"].length) {
                                    colorBackground = modelData["colorCustom"]
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    //    TapHandler {
    //        id: keyboardTapHandler
    //        onTapped: {
    //            //console.debug("Keyboard Tapped")
    //            autocloseTimer.restart()
    //        }//
    //    }//

    MouseArea {
        id: keyboardTouchHandler
        anchors.fill: parent
        onPressed: {
            autocloseTimer.restart()
            mouse.accepted = false
        }
    }

    Timer {
        id: autocloseTimer
        interval: 30000
        running: rootItem.visible
        onTriggered: {
            rootItem.hideClicked()
        }//
    }//

    function keyPressAndHold(keyID){
        //        //console.debug(keyID)

        keyboardOnScreenAdapter.setFocusItem(textField)
        if(keyID === "BS"){
            textField.clear()
        }
    }

    function keyClicked(keyID){
        //        //console.debug(keyID)

        keyboardOnScreenAdapter.setFocusItem(textField)

        if(keyID === "Enter"){
            rootItem.enterClicked(textField.text)
        }
        else if(keyID === "Hide"){
            rootItem.hideClicked()
        }
        else if(keyID === "BS"){
            keyboardOnScreenAdapter.sendBackspaceToFocusItem()
        }
        else{
            keyboardOnScreenAdapter.sendKeyToFocusItem(keyID)
        }
    }

    KeyboardOnScreenAdapter{
        id: keyboardOnScreenAdapter
    }
    Component.onCompleted: {
        visibilityButton = textField.echoMode == TextInput.Password
    }
}
