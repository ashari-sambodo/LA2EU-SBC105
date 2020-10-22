import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom.KeyboardOnScreen.Adapter 1.0

Item {
    id: rootItem

    //            Binding{target: titleText; property: "text"; value: dialogApp.textTitle}
    //            Binding{target: textField; property: "text"; value: dialogApp.textInField}
    //            Binding{target: textField; property: "echoMode"; value: dialogApp.textFieldEchoMode}

    property int widthButton: rootItem.width / 10

    property var modelKey: langModelLoader.item

    property int keyType: 0
    readonly property int __keyType_Letter: 0
    readonly property int __keyType_LetterCaps: 1
    readonly property int __keyType_Symbol: 2

    signal hideClicked();
    signal enterClicked(string textValue);

    //    onCancelClicked: dialogApp.clickedNegative()
    //    onEnterClicked: dialogApp.clickedPositive(textValue)

    property bool darkMode: false

    property alias title: titleText.text
    property alias text: textField.text

    property alias echoMode: textField.echoMode
    property alias validator: textField.validator

    function open() {
        visible = true
    }

    //BACKGROUND
    Rectangle{
        anchors.fill: parent
        color: rootItem.darkMode ? "#404244" : "#ecf0f1"
    }

    ColumnLayout{
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.minimumHeight: 50

            //            Rectangle{anchors.fill: parent}

            Text{
                id: titleText
                anchors.centerIn: parent
                text: "Title Text"
                font.pixelSize: 20
                color: rootItem.darkMode ? "white" : "#666666"
            }

            MouseArea {
                anchors.fill: parent
                onPressAndHold: {
                    rootItem.darkMode = !rootItem.darkMode
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.minimumHeight: 100

            //            Rectangle{anchors.fill: parent}

            RowLayout{
                anchors.fill: parent
                spacing: 0

                Item{
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    TextField{
                        id: textField
                        anchors.fill: parent
                        anchors.margins: 2
                        font.pixelSize: 32
                        //                        validator: textFieldValidator
                        focus: true

                        selectByMouse: true

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.IBeamCursor
                            acceptedButtons: Qt.NoButton
                        }

                        background: Rectangle{
                            border.color: "gray"
                            radius: 5
                        }
                    }
                }

                Item {
                    id: tooglePassword_Item
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

                //                Item {
                //                    Layout.fillHeight: true
                //                    Layout.minimumWidth: keyboard_Item.widthButton

                //                    ButtonKeyApp{
                //                        text: ""
                //                        onClicked: {
                //                            keyboardOnScreenAdapter.setFocusItem(textField)
                //                            textField.clear()
                //                        }

                //                        Image{
                //                            anchors.centerIn: parent
                //                            source: darkMode ?
                //                                        "Pictures/round_done_white_48dp.png":
                //                                        "Pictures/round_done_black_48dp.png"

                //                        }
                //                    }
                //                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            //            Rectangle{anchors.fill: parent}

            ColumnLayout{
                anchors.fill: parent
                spacing: 0

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Row{
                        anchors.centerIn: parent
                        spacing: 0

                        Repeater{
                            model: rootItem.modelKey.firstRowModel

                            Item {
                                height: parent.parent.height
                                width: rootItem.widthButton
                                //                                width: parent.parent.width / 10

                                ButtonKeyApp{
                                    anchors.fill: parent
                                    text: firstKey
                                    onClicked: {
                                        keyboardOnScreenAdapter.setFocusItem(textField)
                                        keyboardOnScreenAdapter.sendKeyToFocusItem(text)
                                    }

                                    darkMode: rootItem.darkMode
                                }
                            }
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Row{
                        anchors.centerIn: parent
                        spacing: 0

                        Repeater{
                            //                            model: ["q","w","e","r","t","y","u","i","o","p",]
                            model: rootItem.modelKey.secondRowModel

                            Item {
                                height: parent.parent.height
                                width: rootItem.widthButton
                                //                                width: parent.parent.width / 10

                                ButtonKeyApp{
                                    anchors.fill: parent
                                    //                                    colorText: StyleApp.white
                                    text: rootItem.keyType == rootItem.__keyType_Letter ? firstKey : (rootItem.keyType == rootItem.__keyType_LetterCaps ? secondKey : thirdKey)

                                    onClicked: {
                                        keyboardOnScreenAdapter.setFocusItem(textField)
                                        keyboardOnScreenAdapter.sendKeyToFocusItem(text)
                                    }

                                    darkMode: rootItem.darkMode
                                }
                            }
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Row{
                        anchors.centerIn: parent
                        spacing: 0

                        Repeater{
                            //                            model: ["a","s","d","f","g","h","j","k","l","m",]
                            model: rootItem.modelKey.thirdRowModel

                            Item {
                                height: parent.parent.height
                                width: rootItem.widthButton
                                //                                width: parent.parent.width / 10

                                ButtonKeyApp{
                                    text: rootItem.keyType == rootItem.__keyType_Letter ? firstKey : (rootItem.keyType == rootItem.__keyType_LetterCaps ? secondKey : thirdKey)
                                    //                                    colorText: StyleApp.white

                                    onClicked: {
                                        keyboardOnScreenAdapter.setFocusItem(textField)
                                        keyboardOnScreenAdapter.sendKeyToFocusItem(text)
                                    }

                                    darkMode: rootItem.darkMode
                                }
                            }
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Row{
                        anchors.centerIn: parent
                        spacing: 0

                        Item {
                            height: parent.parent.height
                            width: rootItem.widthButton
                            //                            width: parent.parent.width / 10

                            ButtonKeyApp{
                                text: "Aa"
                                onClicked: {
                                    if(rootItem.keyType != rootItem.__keyType_LetterCaps){
                                        rootItem.keyType = rootItem.__keyType_LetterCaps
                                    }else{
                                        rootItem.keyType = rootItem.__keyType_Letter
                                    }
                                }

                                darkMode: rootItem.darkMode
                            }
                        }

                        Item {
                            id: symbolItem
                            height: parent.parent.height
                            width: rootItem.widthButton
                            //                            width: parent.parent.width / 10

                            ButtonKeyApp{
                                text: "!@#"
                                onClicked: {
                                    if(rootItem.keyType != rootItem.__keyType_Symbol){
                                        rootItem.keyType = rootItem.__keyType_Symbol
                                    }else{
                                        rootItem.keyType = rootItem.__keyType_Letter
                                    }
                                }

                                darkMode: rootItem.darkMode
                            }
                        }

                        Repeater{
                            //                            model: ["z","x","c","v","b","n"]
                            model: rootItem.modelKey.fourthRowModel

                            Item {
                                height: parent.parent.height
                                width: rootItem.widthButton
                                //                                width: parent.parent.width / 10

                                ButtonKeyApp{
                                    text: rootItem.keyType == rootItem.__keyType_Letter ? firstKey : (rootItem.keyType == rootItem.__keyType_LetterCaps ? secondKey : thirdKey)
                                    //                                    colorText: StyleApp.white

                                    onClicked: {
                                        keyboardOnScreenAdapter.setFocusItem(textField)
                                        keyboardOnScreenAdapter.sendKeyToFocusItem(text)
                                    }

                                    darkMode: rootItem.darkMode
                                }
                            }
                        }

                        Item {
                            height: parent.parent.height
                            width: rootItem.widthButton * 2
                            //                            width: parent.parent.width / 10 * 2

                            ButtonKeyApp{
                                text: ""
                                onClicked: {
                                    keyboardOnScreenAdapter.setFocusItem(textField)
                                    keyboardOnScreenAdapter.sendKeyToFocusItem("\x7f")
                                }

                                onPressAndHold: {
                                    textField.clear()
                                }

                                //                                colorText: StyleApp.white

                                Image{
                                    //                                    anchors.fill: parent
                                    //                                    anchors.margins: 5
                                    anchors.centerIn: parent
                                    source: darkMode ?
                                                "Pictures/round_backspace_white_48dp.png" :
                                                "Pictures/round_backspace_black_48dp.png"
                                }

                                darkMode: rootItem.darkMode
                            }
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Row{
                        anchors.centerIn: parent
                        spacing: 0

                        Item {
                            id: closeItem
                            height: parent.parent.height
                            width: rootItem.widthButton * 2
                            //                            width: parent.parent.width / 10 * 2

                            ButtonKeyApp{
                                text: ""
                                onClicked: {
                                    rootItem.hideClicked()
                                }

                                //                                colorText: StyleApp.white

                                Image{
                                    anchors.centerIn: parent
                                    //                                    anchors.fill: parent
                                    //                                    anchors.margins: 5
                                    //                                    fillMode: Image.PreserveAspectFit
                                    source: darkMode ?
                                                "Pictures/round_keyboard_hide_white_48dp.png" :
                                                "Pictures/round_keyboard_hide_black_48dp.png"
                                }

                                darkMode: rootItem.darkMode
                            }
                        }

                        Item {
                            id: symDotItem
                            height: parent.parent.height
                            width: rootItem.widthButton
                            //                            width: parent.parent.width / 10 * 2

                            ButtonKeyApp{
                                text: ""
                                onClicked: {
                                    textField.forceActiveFocus()
                                    textField.cursorPosition = textField.cursorPosition - 1
                                }

                                //                                colorText: StyleApp.white

                                Image{
                                    anchors.centerIn: parent
                                    //                                    anchors.fill: parent
                                    //                                    anchors.margins: 5
                                    //                                    fillMode: Image.PreserveAspectFit
                                    source: darkMode ?
                                                "Pictures/round_skip_previous_white_48dp.png" :
                                                "Pictures/round_skip_previous_black_48dp.png"
                                }

                                darkMode: rootItem.darkMode
                            }
                        }

                        Item {
                            id: spacingItem
                            height: parent.parent.height
                            width: rootItem.widthButton * 4
                            //                            width: parent.parent.width / 10 * 6

                            ButtonKeyApp{
                                text: " "
                                onClicked: {
                                    keyboardOnScreenAdapter.setFocusItem(textField)
                                    keyboardOnScreenAdapter.sendKeyToFocusItem(text)
                                }

                                darkMode: rootItem.darkMode
                            }
                        }

                        Item {
                            id: symCommaItem
                            height: parent.parent.height
                            width: rootItem.widthButton
                            //                            width: parent.parent.width / 10 * 2

                            ButtonKeyApp{
                                text: ""
                                onClicked: {
                                    textField.forceActiveFocus()
                                    textField.cursorPosition = textField.cursorPosition + 1
                                }

                                //                                colorText: StyleApp.white

                                Image{
                                    anchors.centerIn: parent
                                    //                                    anchors.fill: parent
                                    //                                    anchors.margins: 5
                                    //                                    fillMode: Image.PreserveAspectFit
                                    source: darkMode ?
                                                "Pictures/round_skip_next_white_48dp.png" :
                                                "Pictures/round_skip_next_black_48dp.png"
                                }

                                darkMode: rootItem.darkMode
                            }
                        }

                        Item {
                            id: enterItem
                            height: parent.parent.height
                            width: rootItem.widthButton * 2
                            //                            width: parent.parent.width / 10 * 2

                            ButtonKeyApp{
                                text: ""
                                onClicked: {
                                    rootItem.enterClicked(textField.text)
                                }

                                //                                colorText: StyleApp.white
                                colorBackground: "#2ecc71"

                                Image{
                                    anchors.centerIn: parent
                                    //                                    anchors.fill: parent
                                    //                                    anchors.margins: 5
                                    //                                    fillMode: Image.PreserveAspectFit
                                    source: darkMode ?
                                                "Pictures/round_done_white_48dp.png" :
                                                "Pictures/round_done_black_48dp.png"
                                }

                                darkMode: rootItem.darkMode
                            }
                        }
                    }
                }
            }
        }
    }

    Loader{
        id: langModelLoader
        source: "LanguageModels/KeyboardKeysModel_en.qml"

        //        Component.onCompleted: {
        //            console.log(keyboard_Item.modelKey.firstRowModel)
        //        }
    }

    KeyboardOnScreenAdapter{
        id: keyboardOnScreenAdapter
    }
}
