/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0


ViewApp {
    id: viewApp
    title: "SVN Update Settings"

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
                    title: qsTr("SVN Update Settings")
                }//
            }//

            /// BODY
            Item {
                id: contentItem
                Layout.fillHeight: true
                Layout.fillWidth: true

                Row {
                    anchors.centerIn: parent
                    spacing: 5

                    Rectangle {
                        height: 100
                        width: 100
                        radius: 5
                        color: "#0F2952"
                        border.color: "#e3dac9"

                        ColumnLayout {
                            anchors.fill: parent

                            TextApp {
                                Layout.margins: 5
                                text: qsTr("Enable")
                            }//

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                SwitchApp {
                                    id: enableSwitchApp
                                    enabled: UserSessionService.roleLevel > UserSessionService.roleLevelService
                                    anchors.centerIn: parent

                                    onCheckedChanged: {
                                        //console.debug(checked)

                                        if(!initialized) return

                                        MachineAPI.setSvnUpdateCheckEnable(checked)
                                    }//
                                }//
                            }//
                        }//
                    }//

                    Rectangle {
                        height: 100
                        width: 300
                        radius: 5
                        color: "#0F2952"
                        border.color: "#e3dac9"

                        ColumnLayout {
                            anchors.fill: parent

                            TextApp {
                                Layout.margins: 5
                                text: qsTr("Check for update every")
                            }//

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                ComboBoxApp {
                                    id: periodComboBoxApp
                                    enabled: UserSessionService.roleLevel == UserSessionService.roleLevelFactory
                                    width: parent.width
                                    height: parent.height
                                    anchors.margins: 5
                                    font.pixelSize: 20

                                    textRole: "text"

                                    model: [
                                        {text: qsTr('1 minute'),    value: 1},
                                        {text: qsTr('10 minutes'),   value: 10},
                                        {text: qsTr('30 minutes'),  value: 30},
                                        {text: qsTr('1 hour'),      value: 60},
                                    ]

                                    onActivated: {
                                        MachineAPI.setSvnUpdateCheckPeriod(model[index].value)
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
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }//
                        }//
                    }//
                }//
            }//
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        //        QtObject {
        //            id: props

        //        }//

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

                enableSwitchApp.checked = MachineData.svnUpdateCheckForUpdateEnable
                enableSwitchApp.initialized = true

                const period = MachineData.svnUpdateCheckForUpdatePeriod
                let periodIndex = 0
                switch (period){
                case 10:
                    periodIndex = 1
                    break;
                case 30:
                    periodIndex = 2
                    break;
                case 60:
                    periodIndex = 3
                    break;
                }
                periodComboBoxApp.currentIndex = periodIndex
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
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/
