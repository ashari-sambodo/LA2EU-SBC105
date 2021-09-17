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
    title: "Operation Mode"

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
                    title: qsTr("Operation Mode")
                }//
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Row {
                    spacing: 10
                    anchors.centerIn: parent

                    Column {
                        id: quickStartColumn
                        spacing: 0
                        opacity: quickStartMouseArea.pressed ? 0.5 : 1

                        Image{
                            source: "qrc:/UI/Pictures/User-Quickstart-Mode.png"
                            fillMode: Image.PreserveAspectFit

                            Loader{
                                active: props.operationMode == MachineAPI.MODE_OPERATION_QUICKSTART
                                anchors.verticalCenter: parent.verticalCenter
                                height: 74
                                width: 74
                                sourceComponent: checkComp
                            }//

                            MouseArea{
                                id: quickStartMouseArea
                                anchors.fill: parent
                                onClicked: {
                                    if(props.operationMode !== MachineAPI.MODE_OPERATION_QUICKSTART){

                                        const val = MachineAPI.MODE_OPERATION_QUICKSTART
                                        MachineAPI.setOperationModeSave(val);

                                        MachineAPI.insertEventLog(qsTr("User: Set operation mode to Quick Start"))

                                        //                                        props.operationMode = 1
                                        viewApp.showBusyPage(qsTr("Setting up..."),
                                                             function onTriggered(cycle){
                                                                 if(cycle === 3){
                                                                     viewApp.dialogObject.close()}
                                                             })
                                        //                                        //console.debug("mode: ", props.operationMode)
                                    }//
                                }//
                            }//
                        }//

                        TextApp{
                            width: parent.width
                            text: qsTr("Quick Start")
                            horizontalAlignment: Text.AlignHCenter
                        }//

                    }//

                    Column {
                        id: normalColumn
                        spacing: 0
                        opacity: normalMouseArea.pressed ? 0.5 : 1

                        Image{
                            source: "qrc:/UI/Pictures/User-Normal-Mode.png"
                            fillMode: Image.PreserveAspectFit

                            Loader{
                                active: props.operationMode == MachineAPI.MODE_OPERATION_NORMAL
                                anchors.verticalCenter: parent.verticalCenter
                                height: 74
                                width: 74
                                sourceComponent: checkComp
                            }//

                            MouseArea{
                                id: normalMouseArea
                                anchors.fill: parent
                                onClicked: {
                                    if(props.operationMode !== MachineAPI.MODE_OPERATION_NORMAL){
                                        //                                        props.operationMode = 0

                                        const val = MachineAPI.MODE_OPERATION_NORMAL
                                        MachineAPI.setOperationModeSave(val);

                                        MachineAPI.insertEventLog(qsTr("User: Set operation mode to Normal"))

                                        viewApp.showBusyPage(qsTr("Setting up..."),
                                                             function onTriggered(cycle){
                                                                 if(cycle === 3){
                                                                     viewApp.dialogObject.close()}
                                                             })
                                        //                                        //console.debug("mode: ", props.operationMode)
                                    }//
                                }//
                            }//
                        }//

                        TextApp{
                            width: parent.width
                            text: qsTr("Normal")
                            horizontalAlignment: Text.AlignHCenter
                        }//

                    }//

                    Column {
                        id: maintenanceColumn
                        spacing: 0
                        opacity: maintenanceMouseArea.pressed ? 0.5 : 1
                        visible: props.userRole >= UserSessionService.roleLevelService

                        Image{
                            source: "qrc:/UI/Pictures/User-Maintenance-Mode.png"
                            fillMode: Image.PreserveAspectFit

                            Loader{
                                active: props.operationMode == MachineAPI.MODE_OPERATION_MAINTENANCE
                                anchors.verticalCenter: parent.verticalCenter
                                height: 74
                                width: 74
                                sourceComponent: checkComp
                            }//

                            MouseArea{
                                id: maintenanceMouseArea
                                anchors.fill: parent
                                onClicked: {
                                    if(props.operationMode !== MachineAPI.MODE_OPERATION_MAINTENANCE){
                                        //                                        props.operationMode = 2
                                        const val = MachineAPI.MODE_OPERATION_MAINTENANCE
                                        MachineAPI.setOperationModeSave(MachineAPI.MODE_OPERATION_MAINTENANCE);

                                        MachineAPI.insertEventLog(qsTr("User: Set operation mode to Maintenance"))

                                        viewApp.showBusyPage(qsTr("Setting up..."),
                                                             function onTriggered(cycle){
                                                                 if(cycle === 3){
                                                                     viewApp.dialogObject.close()}
                                                             })
                                        //                                        //console.debug("mode: ", props.operationMode)
                                    }
                                }//
                            }//
                        }//

                        TextApp{
                            width: parent.width
                            text: qsTr("Maintenance")
                            horizontalAlignment: Text.AlignHCenter
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
                            }
                        }//
                    }//
                }//
            }//
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props
            property int operationMode : 0
            property int userRole : 0//0 guest, 1 admin, 2 service, 3 factory
        }

        Component{
            id: checkComp
            Image {
                source: "qrc:/UI/Pictures/done-green-white.png"
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }
        }

        /// OnCreated
        Component.onCompleted: {

        }//


        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

                props.operationMode = Qt.binding(function() {return MachineData.operationMode })
                props.userRole = UserSessionService.roleLevel
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
