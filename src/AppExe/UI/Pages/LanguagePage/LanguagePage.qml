/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Language"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
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
                    anchors.fill: parent
                    title: qsTr("Language")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout{
                    anchors.fill:parent
                    spacing:5

                    Item{
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Column{
                            id: leftContentColumn
                            anchors.centerIn: parent
                            spacing: 20

                            Column {
                                spacing: 5

                                TextApp{
                                    text: qsTr("Current language") + ":"
                                }//

                                TextApp{
                                    id: currentValueText
                                    font.pixelSize: 36
                                    wrapMode: Text.WordWrap
                                    text: props.currentLanguge

                                    width: Math.min(controlMaxWidthText.width, leftContentColumn.parent.width)

                                    Text {
                                        visible: false
                                        id: controlMaxWidthText
                                        text: currentValueText.text
                                        font.pixelSize: 36
                                    }//
                                }//
                            }//

                            TextApp{
                                text: "\"" + qsTr("Hello") + "\""
                                font.italic: true
                            }
                        }//
                    }//

                    Rectangle{
                        Layout.fillHeight: true
                        Layout.minimumWidth: 1
                        color:"#e3dac9"
                    }

                    Item{
                        id: rightSideItem
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 5

                            Rectangle{
                                Layout.minimumHeight: 50
                                Layout.fillWidth: true
                                color: "#1F95D7"
                                radius: 5

                                TextApp {
                                    id: itemListHeaderText
                                    padding: 5
                                    height: parent.height
                                    width: parent.width
                                    verticalAlignment: Text.AlignVCenter
                                    text: qsTr("Choose language") + ":"
                                    elide: Text.ElideMiddle
                                }//
                            }//

                            ListView {
                                id: itemListView
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                spacing: 2
                                clip: true

                                model: props.languages

                                delegate: ItemDelegate {
                                    id: delegateItem
                                    height: 40
                                    width: itemListView.width

                                    text: modelData.language !== undefined ? modelData.language : modelData
                                    font.pixelSize: 20

                                    background: Rectangle {
                                        anchors.fill: parent
                                        color: delegateItem.pressed ? "#436397" : "#0F2952"
                                        radius: 5
                                    }//

                                    contentItem: Text {
                                        text: delegateItem.text
                                        font: delegateItem.font
                                        color: "#e3dac9"
                                        elide: Text.ElideMiddle
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                    }//

                                    onClicked: {
                                        currentValueText.text = modelData.language
                                        TranslatorText.selectLanguage(modelData.code)

                                        /// example en#0#English
                                        let langCode = modelData.code + "#" + index + "#" + modelData.language
                                        MachineAPI.saveLanguage(langCode);
                                        props.currentLanguge = modelData.language
                                    }//
                                }//
                            }//
                        }//
                    }//
                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 70

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
                                if(props.currentLanguge !== props.currentLanguge2){
                                    const intent = IntentApp.create("", {})
                                    startRootView(intent)
                                    //                                    const intent = IntentApp.create("qrc:/UI/Pages/_HomePage/HomePage.qml", {})
                                    //                                    startView(intent)
                                }else{
                                    var intent = IntentApp.create(uri, {"message":""})
                                    finishView(intent)
                                }//
                            }//
                        }//

                        ButtonBarApp {
                            id: setButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            visible: false

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Next")

                            onClicked: {
                                //                                currentTimeZoneText.text = currentTimeZoneText.text + "AAAA-"
                                /// if this page called from welcome page
                                /// show this button to making more mantap
                                var intent = IntentApp.create(uri, {"welcomesetupdone": 1})
                                finishView(intent)
                            }//
                        }//
                    }//
                }//
            }
        }//

        /// Keep it the parameters and function on private scope
        Item {
            id: props
            property variant languages:[
                {"language": "English",             "code": "en"},
                //                {"language": "Chinese (中文)",       "code": "zh"},
                //                {"language": "Finnish (Suomi)",     "code": "fi"},
                //                {"language": "French (Française)",  "code": "fr"},
                {"language": "German (Deutsche)",   "code": "de"},
                //                {"language": "Italian (Italiano)",  "code": "it"},
                //                {"language": "Japanese (日本語)",    "code": "ja"},
                //                {"language": "Korean (한국어)",      "code": "ko"},
                //                {"language": "Spanish (Español)",   "code": "es"}
            ]
            property string currentLanguge: "English"
            property string currentLanguge2 : ""
        }//

        /// called Once but after onResume
        Component.onCompleted: {
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

                /// example expected /// example en#0#English
                let lang = MachineData.language.split("#")[2]
                if (lang !== undefined) {
                    props.currentLanguge = lang
                    props.currentLanguge2 = lang
                }

                const extraData = IntentApp.getExtraData(intent)
                const thisOpenedFromWelcomePage = extraData["walcomesetup"] || false
                if(thisOpenedFromWelcomePage) {
                    setButton.visible = true
                }
            }//

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }//
        }//
    }//
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
