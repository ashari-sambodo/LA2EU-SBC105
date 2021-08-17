/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Ahmad Qodri
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Post Purge Time"

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
                    title: qsTr("Post Purge Time")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column{
                    anchors.centerIn: parent
                    spacing: 10

                    Row{
                        spacing: 10
                        anchors.horizontalCenter: parent.horizontalCenter

                        Image{
                            source: "qrc:/UI/Pictures/warmup-option-icon.png"
                            fillMode: Image.PreserveAspectFit
                        }

                        ComboBoxApp {
                            id: comboBox
                            width: 190
                            height: 50
                            backgroundColor: "#0F2952"
                            backgroundBorderColor: "#dddddd"
                            backgroundBorderWidth: 2
                            font.pixelSize: 20
                            anchors.verticalCenter: parent.verticalCenter
                            textRole: "text"

                            model: [
                                {text: qsTr("Disabled"),    value: 0},
                                {text: qsTr("1 Minute"),    value: 1},
                                {text: qsTr("3 Minutes"),   value: 3},
                                {text: qsTr("5 Minutes"),   value: 5}
                            ]

                            onActivated: {
                                ////console.debug(index)
                                ////console.debug(model[index].value)
                                let newValue = model[index].value
                                if(props.postpurgeTimer !== newValue){
                                    //                                    props.postpurgeTimer = newValue
                                    MachineAPI.setPostPurgeTimeSave(newValue)
                                    //console.debug("Postpurge: ", props.postpurgeTimer , " min")
                                    viewApp.showBusyPage((qsTr("Setting Post purge timer...")),
                                                         function onTriggered(cycle){
                                                             if(cycle === 3){
                                                                 viewApp.dialogObject.close()}
                                                         })
                                }
                            }

                            //                            Component.onCompleted: {
                            //                                if(props.postpurgeTimer == 1)
                            //                                    currentIndex = 0
                            //                                else if(props.postpurgeTimer == 3)
                            //                                    currentIndex = 1
                            //                                else if(props.postpurgeTimer == 5)
                            //                                    currentIndex = 2
                            //                                else currentIndex = 0
                            //                            }
                        }//
                    }//

                    TextApp{
                        width: 500
                        text: qsTr("After user turned off the internal fan, there will be a post purge period before actually turned off. This to ensure that all contaminants are purged from the work zone.")
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignJustify
                    }//

                    //                    TextApp{
                    //                        width: 500
                    //                        color: "#929292"
                    //                        text: qsTr("Note:\nSystem does not have a tool to measure actual contaminants.\nUser can clean manually during this period.")
                    //                        wrapMode: Text.WordWrap
                    //                        horizontalAlignment: Text.AlignJustify
                    //                    }
                }
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

            property int postpurgeTimer: 1
        }

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        Loader {
            active: viewApp.stackViewStatusForeground
            sourceComponent: QtObject {

                /// onResume
                Component.onCompleted: {
                    //                    //console.debug("StackView.Active");

                    props.postpurgeTimer = MachineData.postPurgingTime
                    if(props.postpurgeTimer == 1)
                        comboBox.currentIndex = 1
                    else if(props.postpurgeTimer == 3)
                        comboBox.currentIndex = 2
                    else if(props.postpurgeTimer == 5)
                        comboBox.currentIndex = 3
                    else comboBox.currentIndex = 0
                }

                /// onPause
                Component.onDestruction: {
                    ////console.debug("StackView.DeActivating");
                }
            }//
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/
