/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0
import "Pages/Components" as CusComPage

ViewApp {
    id: viewApp
    title: "Preventive Maintenance"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        /// just for development
        /// comment following line after release
        visible: true

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
                    title: qsTr("Preventive Maintenance")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                ColumnLayout{
                    anchors.fill: parent
                    Item{
                        Layout.minimumHeight: 40
                        Layout.fillWidth: true
                        RowLayout{
                            anchors.fill: parent
                            spacing: 2
                            Item{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                TextBoxApp{
                                    anchors.fill: parent
                                    text: qsTr("Maintenance")
                                    boxOpacity: 1
                                }
                            }
                            Item{
                                Layout.fillHeight: true
                                Layout.minimumWidth: 200
                                TextBoxApp{
                                    anchors.fill: parent
                                    text: qsTr("Ack Date")
                                    boxOpacity: 1
                                }
                            }
                            Item{
                                Layout.fillHeight: true
                                Layout.minimumWidth: 200
                                TextBoxApp{
                                    anchors.fill: parent
                                    text: qsTr("Due Date")
                                    boxOpacity: 1
                                }
                            }
                            Item{
                                Layout.fillHeight: true
                                Layout.minimumWidth: 150
                                TextBoxApp{
                                    anchors.fill: parent
                                    text: qsTr("Reminder")
                                    boxOpacity: 1
                                }
                            }

                            Item{
                                Layout.fillHeight: true
                                Layout.minimumWidth: 25
                            }
                        }//
                    }//
                    Item{
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        RowLayout {
                            anchors.fill: parent

                            Flickable {
                                id: view
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                //                        anchors.fill: parent
                                //                        anchors.margins: 2
                                contentWidth: col.width
                                contentHeight: col.height
                                property real span : contentY + height
                                clip: true

                                flickableDirection: Flickable.VerticalFlick

                                ScrollBar.vertical: verticalScrollBar.scrollBar

                                Column {
                                    id: col
                                    spacing: 2

                                    CusComPage.RowItemApp {
                                        width: view.width
                                        height: 60
                                        viewContentY: view.contentY
                                        viewSpan: view.span
                                        switchEnabled: UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin
                                        pmCode: MachineAPI.PM_DAILY_CODE

                                        label: qsTr("BSC Preventive Maintenance Daily")
                                        ackDate: props.filterDate(MachineData.dailyPreventMaintLastAckDate)
                                        dueDate: props.filterDate(MachineData.dailyPreventMaintAckDueDate)
                                        onSwitchChanged: {
                                            MachineAPI.setAlarmPreventMaintStateEnable(pmCode, value)
                                        }
                                        onButtonRowPressed: {
                                            props.openPage("daily", label, ackDate, dueDate, reminderEn, alarmActive, pmCode)
                                        }
                                        onLoaded: {
                                            enabled = Qt.binding(function(){return (prevMaint.checklist['daily'].length > 0)})
                                            reminderEn = Qt.binding(function(){return MachineData.alarmPreventMaintStateEnable & pmCode})
                                            alarmActive = Qt.binding(function(){return (MachineData.alarmPreventMaintState & pmCode)
                                                                                && !(MachineData.alarmPreventMaintStateAck & pmCode)})
                                        }
                                    }//
                                    CusComPage.RowItemApp {
                                        width: view.width
                                        height: 60
                                        viewContentY: view.contentY
                                        viewSpan: view.span
                                        switchEnabled: UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin
                                        pmCode: MachineAPI.PM_WEEKLY_CODE

                                        label: qsTr("BSC Preventive Maintenance Weekly")
                                        ackDate: props.filterDate(MachineData.weeklyPreventMaintLastAckDate)
                                        dueDate: props.filterDate(MachineData.weeklyPreventMaintAckDueDate)
                                        onSwitchChanged: {
                                            MachineAPI.setAlarmPreventMaintStateEnable(pmCode, value)
                                        }
                                        onButtonRowPressed: {
                                            props.openPage("weekly", label, ackDate, dueDate, reminderEn, alarmActive, pmCode)
                                        }
                                        onLoaded: {
                                            enabled = Qt.binding(function(){return (prevMaint.checklist['weekly'].length > 0)})
                                            reminderEn = Qt.binding(function(){return MachineData.alarmPreventMaintStateEnable & pmCode})
                                            alarmActive = Qt.binding(function(){return (MachineData.alarmPreventMaintState & pmCode)
                                                                                && !(MachineData.alarmPreventMaintStateAck & pmCode)})
                                        }
                                    }//
                                    CusComPage.RowItemApp {
                                        //enabled: false
                                        width: view.width
                                        height: 60
                                        viewContentY: view.contentY
                                        viewSpan: view.span
                                        switchEnabled: UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin
                                        pmCode: MachineAPI.PM_MONTHLY_CODE

                                        label: qsTr("BSC Preventive Maintenance Monthly")
                                        ackDate: props.filterDate(MachineData.monthlyPreventMaintLastAckDate)
                                        dueDate: props.filterDate(MachineData.monthlyPreventMaintAckDueDate)
                                        onSwitchChanged: {
                                            MachineAPI.setAlarmPreventMaintStateEnable(pmCode, value)
                                        }
                                        onButtonRowPressed: {
                                            props.openPage("monthly", label, ackDate, dueDate, reminderEn, alarmActive, pmCode)
                                        }
                                        onLoaded: {
                                            enabled = Qt.binding(function(){return (prevMaint.checklist['monthly'].length > 0)})
                                            reminderEn = Qt.binding(function(){return MachineData.alarmPreventMaintStateEnable & pmCode})
                                            alarmActive = Qt.binding(function(){return (MachineData.alarmPreventMaintState & pmCode)
                                                                                && !(MachineData.alarmPreventMaintStateAck & pmCode)})
                                        }
                                    }//
                                    CusComPage.RowItemApp {
                                        width: view.width
                                        height: 60
                                        viewContentY: view.contentY
                                        viewSpan: view.span
                                        switchEnabled: UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin
                                        pmCode: MachineAPI.PM_QUARTERLY_CODE
                                        label: qsTr("BSC Preventive Maintenance Quarterly")
                                        ackDate: props.filterDate(MachineData.quarterlyPreventMaintLastAckDate)
                                        dueDate: props.filterDate(MachineData.quarterlyPreventMaintAckDueDate)

                                        onSwitchChanged: {
                                            MachineAPI.setAlarmPreventMaintStateEnable(pmCode, value)
                                        }
                                        onButtonRowPressed: {
                                            props.openPage("quarterly", label, ackDate, dueDate, reminderEn, alarmActive, pmCode)
                                        }
                                        onLoaded: {
                                            enabled = Qt.binding(function(){return (prevMaint.checklist['quarterly'].length > 0)})
                                            reminderEn = Qt.binding(function(){return MachineData.alarmPreventMaintStateEnable & pmCode})
                                            alarmActive = Qt.binding(function(){return (MachineData.alarmPreventMaintState & pmCode)
                                                                                && !(MachineData.alarmPreventMaintStateAck & pmCode)})
                                        }

                                    }//
                                    CusComPage.RowItemApp {
                                        width: view.width
                                        height: 60
                                        viewContentY: view.contentY
                                        viewSpan: view.span
                                        switchEnabled: UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin
                                        pmCode: MachineAPI.PM_ANNUALLY_CODE

                                        label: qsTr("BSC Preventive Maintenance Annually")
                                        ackDate: props.filterDate(MachineData.annuallyPreventMaintLastAckDate)
                                        dueDate: props.filterDate(MachineData.annuallyPreventMaintAckDueDate)
                                        onSwitchChanged: {
                                            MachineAPI.setAlarmPreventMaintStateEnable(pmCode, value)
                                        }
                                        onButtonRowPressed: {
                                            props.openPage("annually", label, ackDate, dueDate, reminderEn, alarmActive, pmCode)
                                        }
                                        onLoaded: {
                                            enabled = Qt.binding(function(){return (prevMaint.checklist['annually'].length > 0)})
                                            reminderEn = Qt.binding(function(){return MachineData.alarmPreventMaintStateEnable & pmCode})
                                            alarmActive = Qt.binding(function(){return (MachineData.alarmPreventMaintState & pmCode)
                                                                                && !(MachineData.alarmPreventMaintStateAck & pmCode)})
                                        }
                                    }//
                                    CusComPage.RowItemApp {
                                        width: view.width
                                        height: 60
                                        viewContentY: view.contentY
                                        viewSpan: view.span
                                        switchEnabled: UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin
                                        pmCode: MachineAPI.PM_BIENNIALLY_CODE

                                        label: qsTr("BSC Preventive Maintenance Biennially")
                                        ackDate: props.filterDate(MachineData.bienniallyPreventMaintLastAckDate)
                                        dueDate: props.filterDate(MachineData.bienniallyPreventMaintAckDueDate)
                                        onSwitchChanged: {
                                            MachineAPI.setAlarmPreventMaintStateEnable(pmCode, value)
                                        }
                                        onButtonRowPressed: {
                                            props.openPage("biennially", label, ackDate, dueDate, reminderEn, alarmActive, pmCode)
                                        }
                                        onLoaded: {
                                            enabled = Qt.binding(function(){return (prevMaint.checklist['biennially'].length > 0)})
                                            reminderEn = Qt.binding(function(){return MachineData.alarmPreventMaintStateEnable & pmCode})
                                            alarmActive = Qt.binding(function(){return (MachineData.alarmPreventMaintState & pmCode)
                                                                                && !(MachineData.alarmPreventMaintStateAck & pmCode)})
                                        }
                                    }//
                                    CusComPage.RowItemApp {
                                        width: view.width
                                        height: 60
                                        viewContentY: view.contentY
                                        viewSpan: view.span
                                        switchEnabled: UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin
                                        pmCode: MachineAPI.PM_QUINQUENNIALLY_CODE

                                        label: qsTr("BSC Preventive Maintenance Quinquennially")
                                        ackDate: props.filterDate(MachineData.quinquenniallyPreventMaintLastAckDate)
                                        dueDate: props.filterDate(MachineData.quinquenniallyPreventMaintAckDueDate)
                                        onSwitchChanged: {
                                            MachineAPI.setAlarmPreventMaintStateEnable(pmCode, value)
                                        }
                                        onButtonRowPressed: {
                                            props.openPage("quinquennially", label, ackDate, dueDate, reminderEn, alarmActive, pmCode)
                                        }
                                        onLoaded: {
                                            enabled = Qt.binding(function(){return (prevMaint.checklist['quinquennially'].length > 0)})
                                            reminderEn = Qt.binding(function(){return MachineData.alarmPreventMaintStateEnable & pmCode})
                                            alarmActive = Qt.binding(function(){return (MachineData.alarmPreventMaintState & pmCode)
                                                                                && !(MachineData.alarmPreventMaintStateAck & pmCode)})
                                        }
                                    }//
                                    CusComPage.RowItemApp {
                                        width: view.width
                                        height: 60
                                        viewContentY: view.contentY
                                        viewSpan: view.span
                                        switchEnabled: UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin
                                        pmCode: MachineAPI.PM_CANOPY_CODE

                                        label: qsTr("Canopy Preventive Maintenance Monthly")
                                        ackDate: props.filterDate(MachineData.canopyPreventMaintLastAckDate)
                                        dueDate: props.filterDate(MachineData.canopyPreventMaintAckDueDate)
                                        onSwitchChanged: {
                                            MachineAPI.setAlarmPreventMaintStateEnable(pmCode, value)
                                        }
                                        onButtonRowPressed: {
                                            props.openPage("canopy", label, ackDate, dueDate, reminderEn, alarmActive, pmCode)
                                        }
                                        onLoaded: {
                                            enabled = Qt.binding(function(){return (prevMaint.checklist['canopy'].length > 0)})
                                            reminderEn = Qt.binding(function(){return MachineData.alarmPreventMaintStateEnable & pmCode})
                                            alarmActive = Qt.binding(function(){return (MachineData.alarmPreventMaintState & pmCode)
                                                                                && !(MachineData.alarmPreventMaintStateAck & pmCode)})
                                        }
                                    }//
                                }//
                            }//

                            ScrollBarApp {
                                id: verticalScrollBar
                                Layout.fillHeight: true
                                Layout.minimumWidth: 20
                                Layout.fillWidth: false
                            }
                        }//
                    }//
                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 70

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

        MaintenanceChecklistApp{
            id: prevMaint
            property var checklist:[]

            Component.onCompleted: {
                checklist = profiles[0]['checklist']
            }
        }

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props
            function openPage(pid, title, ackDate, dueDate, remindEn, alarmActive, pmCode){
                let checklistReq = prevMaint.checklist[pid]
                let intent = IntentApp.create("qrc:/UI/Pages/PreventiveMaintenancePage/Pages/PMChecklistPage.qml",
                                              {
                                                  'pid': pid,
                                                  'title': title,
                                                  'ackDate': ackDate,
                                                  'dueDate': dueDate,
                                                  'remindEn': remindEn,
                                                  'alarmActive': alarmActive,
                                                  'pmCode': pmCode,
                                                  'checklistReq': checklistReq
                                              })//
                startView(intent)
            }//
            function filterDate(date){
                return date.split(" ")[0]
            }
        }//

        /// One time executed after onResume
        Component.onCompleted: {
            showDialogMessage(qsTr("Preventive Maintenance"),
                              qsTr("Select preventive maintenance to view the checklists, and make an acknowledgment or snooze the reminder."),
                              dialogInfo, function onClosed(){}, false)
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

            }//

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//


/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/
