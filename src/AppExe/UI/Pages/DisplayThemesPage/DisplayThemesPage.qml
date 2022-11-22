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
    title: "Display Themes"

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
                    id: headerApp
                    anchors.fill: parent
                    title: qsTr("Display Themes")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Row {
                    anchors.centerIn: parent
                    spacing: 20

                    Repeater {
                        id: optionsRepeater
                        //                        model: props.modelDisplayTheme

                        Column {
                            Image {
                                anchors.horizontalCenter: parent.horizontalCenter
                                opacity: mouseArea.pressed ? 0.7 : 1
                                source: modelData.imgSrc
                                //                                opacity:

                                Loader{
                                    active: modelData.active
                                    sourceComponent: Image {
                                        source: "qrc:/UI/Pictures/checkicon.png"
                                    }//
                                }//

                                MouseArea {
                                    id: mouseArea
                                    anchors.fill: parent
                                    onClicked: {
                                        if (modelData.active) return
                                        props.setDisplayTheme(index)
                                    }//
                                }//
                            }//

                            TextApp {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.text
                            }//
                        }//
                    }//
                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: MachineAPI.FOOTER_HEIGHT

                BackgroundButtonBarApp {
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
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int displayTheme: 0

            property var modelDisplayTheme: [
                {text: qsTr("Normal"),  imgSrc: "qrc:/UI/Pictures/dark/theme-normal.png", active: 0},
                {text: qsTr("Dark"),    imgSrc: "qrc:/UI/Pictures/dark/theme-dark.png",    active: 0}
            ]

            function setDisplayTheme(unit){
                const unitStr = unit ? qsTr("Dark") : qsTr("Normal")
                const message = "<b>" + qsTr("Change display theme to ") + unitStr + "?"

                const autoClose = false
                showDialogAsk(qsTr(title), message,  dialogAlert, function(){
                    //                    //console.debug(unit)
                    doSetDisplayTheme(unit)
                },
                function onRejected(){},
                function onClosed(){},
                autoClose)
            }

            function doSetDisplayTheme(unit){
                /// tell to machine
                MachineAPI.setDisplayTheme(unit)

                const message = unit ? qsTr("User: Set display theme to Dark") : qsTr("User: Set display theme to Normal")
                MachineAPI.insertEventLog(unit)

                /// show busy
                viewApp.showBusyPage(qsTr("Setting up..."),
                                     function onCycle(cycle){
                                         if (cycle === MachineAPI.BUSY_CYCLE_1) {
                                             props.modelDisplayTheme[1]['active'] = 0
                                             props.modelDisplayTheme[0]['active'] = 0

                                             if (props.displayTheme) props.modelDisplayTheme[1]['active'] = 1
                                             else props.modelDisplayTheme[0]['active'] = 1

                                             optionsRepeater.model = props.modelDisplayTheme

                                             viewApp.dialogObject.close()
                                         }//
                                     })
            }
        }

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible:  QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

                props.displayTheme = Qt.binding(function(){return MachineData.displayTheme})
                //                    //console.debug(props.displayTheme)

                if (props.displayTheme) props.modelDisplayTheme[1]['active'] = 1
                else props.modelDisplayTheme[0]['active'] = 1

                optionsRepeater.model = props.modelDisplayTheme
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
