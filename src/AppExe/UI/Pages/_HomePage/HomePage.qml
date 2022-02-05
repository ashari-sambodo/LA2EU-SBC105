import QtQuick 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Utils 1.0
import ModulesCpp.Machine 1.0
import ModulesCpp.Connectify 1.0

import "Components" as CusComPage

ViewApp {
    id: viewApp
    title: "Home"

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
                    title: qsTr("Home")

                    contentDateTime.active: false

                    contentTitleBox.sourceComponent: Item{
                        id: headerStatusItem

                        Rectangle {
                            id: headerBackgroundRectangle
                            anchors.fill: parent
                            color: "#db6400"
                            radius: 5
                            border.width: 3
                            border.color: "#dddddd"

                            Image {
                                id: headerBgImage
                                anchors.fill: parent
                                source: "qrc:/UI/Pictures/header-red-bg.png"
                                visible: false
                            }

                            TextApp {
                                id: headerStatusText
                                anchors.fill: parent
                                anchors.margins: 5
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                text: qsTr("FAN OFF")
                                font.pixelSize: 32
                                font.bold: true
                                fontSizeMode: Text.Fit
                            }//
                        }//

                        states: [
                            State {
                                when: props.alarmBoardComError
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: MODULE NOT RESPONDING ")
                                }//
                            }//
                            ,
                            State {
                                when: props.alarmFrontPanel
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: FRONT PANEL OPENED")
                                }//
                            }//
                            ,
                            State {
                                when: props.modeIsMaintenance
                                PropertyChanges {
                                    target: headerBackgroundRectangle
                                    color: "#db6400"
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("MAINTENANCE")
                                }//
                            }//
                            ,
                            State {
                                when: props.sashCycleLockedAlarm
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: SASH MOTOR LOCKED")
                                }//
                            }//
                            ,
                            State {
                                when: props.sashCycleStopCaution
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("STOP USING SASH MOTOR")
                                }//
                            }//
                            ,
                            State {
                                when: props.sashCycleReplaceCaution
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("REPLACE SASH MOTOR")
                                }//
                            }//
                            ,
                            State {
                                when: props.alarmSashMotorDownStuck
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: SASH DOWN STUCK")
                                }//
                            }//
                            ,
                            State {
                                when: props.alarmSashError
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: SASH ERROR")
                                }//
                            }//
                            ,
                            State {
                                when: props.alarmSashUnsafe || props.alarmSashFullyOpen
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: SASH UNSAFE")
                                }//
                            }//
                            ,
                            State {
                                when: !props.sensorCalibrated
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("SENSOR UNCALIBRATED")
                                }//
                            }//
                            ,
                            State {
                                when: props.alarmTempHigh == MachineAPI.ALARM_ACTIVE_STATE
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ENVIRONMENTAL TEMPERATURE TOO HIGH")
                                }//
                            }//
                            ,
                            State {
                                when: props.alarmTempLow == MachineAPI.ALARM_ACTIVE_STATE
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ENVIRONMENTAL TEMPERATURE TOO LOW")
                                }//
                            }//
                            ,
                            State {
                                when: props.alarmStandbyFanOff
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: TURN ON FAN")
                                }//
                            }//
                            ,
                            State {
                                when: (props.alarmDownflowLow == MachineAPI.ALARM_ACTIVE_STATE) &&
                                      (props.alarmInflowLow == MachineAPI.ALARM_ACTIVE_STATE)
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: AIRFLOW LOW")
                                }//
                            }//
                            ,
                            State {
                                when: (((props.alarmDownflowLow == MachineAPI.ALARM_ACTIVE_STATE) ||
                                        (props.alarmDownflowHigh == MachineAPI.ALARM_ACTIVE_STATE)) &&
                                       (props.alarmInflowLow == MachineAPI.ALARM_ACTIVE_STATE))
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: AIRFLOW FAIL")
                                }//
                            }//
                            ,
                            State {
                                when: props.alarmDownflowLow == MachineAPI.ALARM_ACTIVE_STATE
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: DOWNFLOW LOW")
                                }//
                            }//
                            ,
                            State {
                                when: props.alarmDownflowHigh == MachineAPI.ALARM_ACTIVE_STATE
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: DOWNFLOW HIGH")
                                }//
                            }//
                            ,
                            State {
                                when: props.alarmInflowLow == MachineAPI.ALARM_ACTIVE_STATE
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: INFLOW LOW")
                                }//
                            }//
                            ,
                            State {
                                when: props.alarmSeasTooPositive || props.alarmSeasFlapTooPositive
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: EXHAUST FAIL")
                                }//
                            }//
                            ,
                            State {
                                when: props.warmingUpActive
                                PropertyChanges {
                                    target: headerBackgroundRectangle
                                    color: "#db6400"
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("WARMING-UP")
                                          + " (" + utils.strfSecsToAdaptiveHHMMSS(props.warmingUpCountdown) + ")"
                                }//
                            }//
                            ,
                            State {
                                when: props.postPurgeActive
                                PropertyChanges {
                                    target: headerBackgroundRectangle
                                    color: "#db6400"
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("POST PURGING")
                                          + " (" + utils.strfSecsToAdaptiveHHMMSS(props.postPurgeCountdown) + ")"
                                }//
                            }//
                            ,
                            State {
                                when: (props.sashWindowState == MachineAPI.SASH_STATE_FULLY_CLOSE_SSV) && !props.uvState
                                PropertyChanges {
                                    target: headerBackgroundRectangle
                                    color: "#4b1263"
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("UV OFF")
                                }//
                            }//
                            ,
                            State {
                                when: (props.sashWindowState == MachineAPI.SASH_STATE_FULLY_CLOSE_SSV) && props.uvState
                                PropertyChanges {
                                    target: headerBackgroundRectangle
                                    color: "#8E44AD"
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("UV ON")
                                }//
                            }//
                            ,
                            State {
                                when: props.fanState == MachineAPI.FAN_STATE_STANDBY
                                PropertyChanges {
                                    target: headerBackgroundRectangle
                                    color: "#2980b9"
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("STANDBY")
                                }//
                            }//
                            ,
                            State {
                                when: props.fanState == MachineAPI.FAN_STATE_ON
                                PropertyChanges {
                                    target: headerBackgroundRectangle
                                    color: "#18AA00"
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("CABINET IS SAFE")
                                }//
                            }//
                        ]//
                    }//
                }//
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    anchors.fill: parent

                    Item {
                        id: secondTopBarSpace
                        Layout.minimumHeight: 60
                        Layout.fillWidth: true

                        /// give the space for secondTopBar
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        RowLayout {
                            anchors.fill: parent

                            Item {
                                id: bsc3DItem
                                Layout.minimumWidth: 300
                                Layout.fillHeight: true

                                /// give the space
                            }

                            Item {
                                id: centerContentItem
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                Column{
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 5

                                    Loader {
                                        //                                        id: seasStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            //                                            id: seasStatus
                                            height: 40
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5
                                            //                                            color: "#18AA00" /// green // good
                                            //                                            color: "#f39c12" // Moderate
                                            //                                            color: "#d35400" /// orange / unheatly for sensityv
                                            //                                            color: "#c0392b" /// red / unhelty

                                            textLabel: qsTr("Particle (μg/m3)") + ":"
                                            //                                            textValue: props.seasPressureStr /*"-20 Pa"*/
                                            textValue: "PM2.5: " + props.particleCounterPM2_5 +
                                                       " | PM1.0: " + props.particleCounterPM1_0 +
                                                       " | PM10: " + props.particleCounterPM10

                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                    const intent = IntentApp.create("qrc:/UI/Pages/ParticleCounterInfoPage/ParticleCounterInfoPage.qml", {})
                                                    startView(intent)
                                                }
                                            }
                                        }//
                                        visible: active
                                        //                                        active: true
                                        active: {
                                            if(props.particleCounterSensorInstalled){
                                                if (props.fanState) {
                                                    if (!props.alarmBoardComError) {
                                                        return true
                                                    }
                                                }
                                            }
                                            return false
                                        }//
                                    }//

                                    Loader {
                                        id: timerStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: timerStatus
                                            height: 40
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5

                                            textLabel: qsTr("Timer") + ":"
                                            textValue: utils.strfSecsToHumanReadable(props.expTimerCount)

                                            states: [
                                                State {
                                                    when: props.expTimerTimeout
                                                    PropertyChanges {
                                                        target: timerStatus
                                                        color: "#c0392b"
                                                        textValue: qsTr("Time is up!")
                                                    }
                                                },
                                                State {
                                                    when: props.expTimerIsPaused
                                                    PropertyChanges {
                                                        target: timerStatus
                                                        color: "#db6400"
                                                    }
                                                }
                                            ]

                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                    var intent = IntentApp.create("qrc:/UI/Pages/ExperimentTimerPage/ExperimentTimerPage.qml")
                                                    startView(intent)
                                                }
                                            }
                                        }//
                                        visible: active
                                        active: {
                                            if (!props.alarmBoardComError) {
                                                if(props.expTimerActive) {
                                                    return true
                                                }
                                            }
                                            return false
                                        }//
                                    }//

                                    Loader {
                                        id: muteTimeStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: muteTimeStatus
                                            height: 40
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width
                                            hightlighted: true

                                            textLabel: props.vivariumMuteState ? qsTr("Vivarium mute:") : qsTr("Alarm muted:")
                                            textValue: utils.strfSecsToHumanReadableShort(props.muteAlarmTimeCountdown) /*+ " (Vivarium)"*/
                                        }//
                                        visible: active
                                        active: {
                                            if (!props.alarmBoardComError) {
                                                if(props.muteAlarmState){
                                                    return true
                                                }
                                            }
                                            return false
                                        }//
                                    }//

                                    Loader {
                                        id: seasStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: seasStatus
                                            height: 40
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5

                                            textLabel: qsTr("Exhaust") + ":"
                                            textValue: props.seasPressureStr /*"-20 Pa"*/

                                            states: [
                                                State {
                                                    when: props.alarmSeasTooPositive
                                                    PropertyChanges {
                                                        target: seasStatus
                                                        textValue: props.seasPressureStr + " (" + qsTr("Too high") + ")"
                                                    }
                                                    PropertyChanges {
                                                        target: seasStatus
                                                        hightlighted: true
                                                    }
                                                }
                                            ]
                                        }//
                                        visible: active
                                        active: {
                                            if(props.seasInstalled  && props.airflowMonitorEnable){
                                                if (!props.alarmBoardComError) {
                                                    if(props.fanState) {
                                                        return true
                                                    }
                                                }
                                            }
                                            return false
                                        }//
                                    }//

                                    Loader {
                                        id: sashStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: sashStatus
                                            height: 60
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5

                                            textLabel: qsTr("Sash") + ":"
                                            textValue: "---"

                                            states: [
                                                State {
                                                    when: (props.sashWindowState === MachineAPI.SASH_STATE_UNSAFE_SSV)
                                                          && props.alarmSashUnsafe
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Unsafe height")
                                                    }
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        hightlighted: true
                                                    }
                                                },
                                                State {
                                                    when: (props.sashWindowState === MachineAPI.SASH_STATE_FULLY_OPEN_SSV)
                                                          && props.alarmSashFullyOpen
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Fully open")
                                                    }
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        hightlighted: true
                                                    }
                                                },
                                                State {
                                                    when: (props.sashWindowState === MachineAPI.SASH_STATE_FULLY_OPEN_SSV)
                                                          && props.alarmSashUnknown
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Unknown")
                                                    }
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        hightlighted: true
                                                    }
                                                },
                                                State {
                                                    when: props.sashWindowState === MachineAPI.SASH_STATE_WORK_SSV
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Safe height")
                                                    }
                                                },
                                                State {
                                                    when: props.sashWindowState === MachineAPI.SASH_STATE_UNSAFE_SSV
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Unsafe height")
                                                    }
                                                },
                                                State {
                                                    when: props.sashWindowState === MachineAPI.SASH_STATE_FULLY_CLOSE_SSV
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Fully close")
                                                    }
                                                },
                                                State {
                                                    when: props.sashWindowState === MachineAPI.SASH_STATE_STANDBY_SSV
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Standby height")
                                                    }
                                                },
                                                State {
                                                    when: props.sashWindowState === MachineAPI.SASH_STATE_FULLY_OPEN_SSV
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Fully open")
                                                    }
                                                },
                                                State {
                                                    when: props.sashWindowState === MachineAPI.SASH_STATE_ERROR_SENSOR_SSV
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Unknown")
                                                    }
                                                }
                                            ]//
                                        }//

                                        visible: active
                                        active: {
                                            if (!props.alarmBoardComError) {
                                                return true
                                            }
                                            return false
                                        }//
                                    }//

                                    Loader {
                                        id: filterLifeStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: filterLifeStatus
                                            height: 40
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5

                                            textLabel: qsTr("Filter Life") + ":"
                                            textValue: props.filterLifePercent + "%"
                                        }//
                                        visible: active
                                        active: {
                                            if (!props.alarmsState) {
                                                if(props.fanState == MachineAPI.FAN_STATE_ON){
                                                    return true
                                                }
                                            }
                                            return false
                                        }//
                                    }//

                                    Loader {
                                        id: downflowStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: downflowStatus
                                            height: 60
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5

                                            textLabel: qsTr("Downflow") + ":"
                                            textValue: props.downflowStr

                                            states: [
                                                State {
                                                    when: !props.sensorCalibrated
                                                    PropertyChanges {
                                                        target: downflowStatus
                                                        textValue: qsTr("Uncalibrated")
                                                    }//
                                                }//
                                                ,
                                                State {
                                                    when: props.warmingUpActive
                                                    PropertyChanges {
                                                        target: downflowStatus
                                                        textValue: qsTr("Warming up")
                                                    }//
                                                    PropertyChanges {
                                                        target: downflowStatus
                                                        color: "#db6400"
                                                    }
                                                }//
                                                ,
                                                State {
                                                    when: props.alarmDownflowLow == MachineAPI.ALARM_ACTIVE_STATE
                                                    PropertyChanges {
                                                        target: downflowStatus
                                                        textValue: props.downflowStr + " (" + qsTr("Too Low") + ")"
                                                    }//
                                                    PropertyChanges {
                                                        target: downflowStatus
                                                        hightlighted: true
                                                    }//
                                                }//
                                                ,

                                                State {
                                                    when: props.alarmDownflowHigh == MachineAPI.ALARM_ACTIVE_STATE
                                                    PropertyChanges {
                                                        target: downflowStatus
                                                        textValue: props.downflowStr + " (" + qsTr("Too High") + ")"
                                                    }//
                                                    PropertyChanges {
                                                        target: downflowStatus
                                                        hightlighted: true
                                                    }//
                                                }//
                                                ,
                                                State {
                                                    when: (props.alarmDownflowLow == MachineAPI.ALARM_NORMAL_STATE)
                                                          && (props.alarmDownflowHigh == MachineAPI.ALARM_NORMAL_STATE)
                                                          && ((props.alarmTempHigh == MachineAPI.ALARM_NORMAL_STATE)
                                                              && (props.alarmTempLow == MachineAPI.ALARM_NORMAL_STATE))
                                                    PropertyChanges {
                                                        target: downflowStatus
                                                        color: "#4ECC44"
                                                    }//
                                                }//
                                            ]//
                                        }//

                                        visible: active
                                        active: {
                                            if (!props.alarmBoardComError  && props.airflowMonitorEnable) {
                                                if(props.fanState == MachineAPI.FAN_STATE_ON){
                                                    if (props.sashWindowState == MachineAPI.SASH_STATE_WORK_SSV){
                                                        return true
                                                    }
                                                    if (props.modeIsMaintenance){
                                                        return true
                                                    }
                                                }
                                            }
                                            return false
                                        } //
                                    }//

                                    Loader {
                                        id: inflowStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: inflowStatus
                                            height: 60
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5

                                            textLabel: qsTr("Inflow") + ":"
                                            textValue: props.inflowStr

                                            states: [
                                                State {
                                                    when: !props.sensorCalibrated
                                                    PropertyChanges {
                                                        target: inflowStatus
                                                        textValue: qsTr("Uncalibrated")
                                                    }//
                                                }//
                                                ,
                                                State {
                                                    when: props.warmingUpActive
                                                    PropertyChanges {
                                                        target: inflowStatus
                                                        textValue: qsTr("Warming up")
                                                    }
                                                    PropertyChanges {
                                                        target: inflowStatus
                                                        color: "#db6400"
                                                    }
                                                }
                                                ,
                                                State {
                                                    when: props.alarmInflowLow == MachineAPI.ALARM_ACTIVE_STATE
                                                    PropertyChanges {
                                                        target: inflowStatus
                                                        textValue: props.inflowStr + " (" + qsTr("Too Low") + ")"
                                                    }//
                                                    PropertyChanges {
                                                        target: inflowStatus
                                                        hightlighted: true
                                                    }//
                                                }//
                                                ,
                                                State {
                                                    when:(props.alarmInflowLow == MachineAPI.ALARM_NORMAL_STATE)
                                                         && ((props.alarmTempHigh == MachineAPI.ALARM_NORMAL_STATE)
                                                             && (props.alarmTempLow == MachineAPI.ALARM_NORMAL_STATE))
                                                    PropertyChanges {
                                                        target: inflowStatus
                                                        color: "#279F40"
                                                    }//
                                                }//
                                            ]//
                                        }//
                                        visible: active
                                        active: {
                                            if (!props.alarmBoardComError && props.airflowMonitorEnable) {
                                                if(props.fanState == MachineAPI.FAN_STATE_ON){
                                                    if (props.sashWindowState == MachineAPI.SASH_STATE_WORK_SSV){
                                                        return true
                                                    }
                                                    if (props.modeIsMaintenance){
                                                        return true
                                                    }
                                                }
                                            }
                                            return false
                                        }//
                                    }//

                                    Loader {
                                        id: airfloMonitorStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: airfloMonitorStatus
                                            height: 60
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5

                                            textLabel: qsTr("A/F Monitor") + ":"
                                            textValue:  qsTr("Disabled")
                                        }//
                                        visible: active
                                        active: {
                                            if (!props.airflowMonitorEnable) {
                                                if(props.fanState == MachineAPI.FAN_STATE_ON){
                                                    if (props.sashWindowState == MachineAPI.SASH_STATE_WORK_SSV){
                                                        return true
                                                    }
                                                    if (props.modeIsMaintenance){
                                                        return true
                                                    }
                                                }
                                            }
                                            return false
                                        }//
                                    }//

                                    Loader {
                                        id: uvLifeStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: uvLifeStatus
                                            height: 40
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width

                                            textLabel: qsTr("UV Life") + ":"
                                            textValue: props.uvLifePercent + "%"
                                        }//
                                        visible: active
                                        active: {
                                            if (!props.alarmBoardComError) {
                                                if(props.sashWindowState == MachineAPI.SASH_STATE_FULLY_CLOSE_SSV){
                                                    return true
                                                }
                                            }
                                            return false
                                        }//
                                    }//

                                    Loader {
                                        id: uvTimeStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: uvTimeStatus
                                            height: 60
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5

                                            textLabel: qsTr("UV Time") + ":"
                                            textValue: MachineData.uvTime ? utils.strfSecsToHHMMSS(props.uvTimeCountDown) : qsTr("Infinite")

                                            states: [
                                                State {
                                                    when: props.uvState
                                                    PropertyChanges {
                                                        target: uvTimeStatus
                                                        color: "#8E44AD"
                                                    }//
                                                }//
                                            ]//

                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                    const intent = IntentApp.create("qrc:/UI/Pages/UVTimerSetPage/UVTimerSetPage.qml", {})
                                                    startView(intent)
                                                }//
                                            }//
                                        }//

                                        visible: active
                                        active: {
                                            if (!props.alarmBoardComError) {
                                                if(props.sashWindowState == MachineAPI.SASH_STATE_FULLY_CLOSE_SSV){
                                                    return true
                                                }
                                            }//
                                            return false
                                        }//
                                    }//

                                    Loader {
                                        id: moduleErrorStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: moduleErrorStatus
                                            height: 150
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5
                                            hightlighted: true

                                            textLabel: ""
                                            textValue: ""

                                            Column {
                                                x: 150
                                                spacing: 10

                                                TextApp {
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    text: qsTr("ATTENTION !!!")
                                                    font.pixelSize: 24
                                                }//

                                                TextApp {
                                                    width: moduleErrorStatus.width - 150
                                                    wrapMode: Text.WordWrap
                                                    minimumPixelSize: 20
                                                    font.pixelSize: 24
                                                    text: qsTr("System was detecting a communication problem between main-board and module-board.") + "<br><br>" +
                                                          qsTr("Call your authorized field service technician!")
                                                }//
                                            }//
                                        }//

                                        visible: active
                                        active: {
                                            if (props.alarmBoardComError) {
                                                return true
                                            }
                                            return false
                                        }//
                                    }//
                                    Loader {
                                        id: frontPanelAlarmLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: frontPanelAlarmStatus
                                            height: 150
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5
                                            hightlighted: true

                                            textLabel: ""
                                            textValue: ""

                                            Column {
                                                x: 150
                                                spacing: 10

                                                TextApp {
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    text: "<b>" + qsTr("ATTENTION !!!") + "</b>"
                                                    font.pixelSize: 24
                                                }//

                                                TextApp {
                                                    width: frontPanelAlarmStatus.width - 150
                                                    wrapMode: Text.WordWrap
                                                    font.pixelSize: 24
                                                    minimumPixelSize: 20
                                                    text: qsTr("The front panel is open while the sash is not fully close!") + "<br>" +
                                                          qsTr("It's not safe if you want to open the Main Door.") + "<br>" +
                                                          qsTr("Please set the sash to fully close.")
                                                }//
                                            }//
                                        }//

                                        visible: active
                                        active: {
                                            if (props.alarmFrontPanel && !props.alarmBoardComError) {
                                                return true
                                            }
                                            return false
                                        }//
                                    }//
                                }//
                            }//

                            /// Motorize Sash Button
                            Loader {
                                Layout.fillHeight: true
                                Layout.minimumWidth: 150
                                sourceComponent: Item{
                                    Column{
                                        anchors.centerIn: parent
                                        spacing: 50

                                        CusComPage.ControlButtonApp {
                                            id: sashMotorUpButton
                                            height: 100
                                            width: 150

                                            sourceImage: "qrc:/UI/Pictures/controll/Button_Up.png"
                                            imageFeature.anchors.margins: 1

                                            background.sourceComponent: Item{}

                                            stateInterlock: props.sashMotorizeUpInterlocked
                                            stateIO: props.sashMotorizeState == MachineAPI.MOTOR_SASH_STATE_UP

                                            onClicked: {
                                                if (stateInterlock) {
                                                    showDialogMessage(qsTr("Warning"), qsTr("Interlocked!"), dialogAlert)
                                                    return
                                                }//

                                                if(props.sashMotorizeState) {
                                                    MachineAPI.setSashWindowMotorizeState(MachineAPI.MOTOR_SASH_STATE_OFF)
                                                    MachineAPI.insertEventLog(qsTr("User: Set sash motorize stop"))
                                                    return
                                                }
                                                MachineAPI.setSashWindowMotorizeState(MachineAPI.MOTOR_SASH_STATE_UP)
                                                MachineAPI.insertEventLog(qsTr("User: Set sash motorize up"))
                                            }//

                                            onPressAndHold: {
                                                if (stateInterlock) return
                                                MachineAPI.setSashWindowMotorizeState(MachineAPI.MOTOR_SASH_STATE_UP)

                                                MachineAPI.insertEventLog(qsTr("User: Set sash motorize up"))
                                            }//

                                            //                                            onReleasedPress: {
                                            //                                                if (stateInterlock) return
                                            //                                                MachineAPI.setSashWindowMotorizeState(MachineAPI.MOTOR_SASH_STATE_OFF)

                                            //                                                MachineAPI.insertEventLog(qsTr("User: Set sash motorize off"))
                                            //                                            }//

                                            states: [
                                                State {
                                                    when: sashMotorUpButton.stateInterlock
                                                    PropertyChanges {
                                                        target: sashMotorUpButton
                                                        sourceImage: "qrc:/UI/Pictures/controll/Button_Up_Gray.png"
                                                    }
                                                }
                                                ,
                                                State {
                                                    when: sashMotorUpButton.stateIO
                                                    PropertyChanges {
                                                        target: sashMotorUpButton
                                                        sourceImage: "qrc:/UI/Pictures/controll/Button_Up_Run.png"
                                                    }
                                                }
                                            ]
                                        }//

                                        CusComPage.ControlButtonApp {
                                            id: sashMotorDownButton
                                            height: 100
                                            width: 150

                                            sourceImage: "qrc:/UI/Pictures/controll/Button_Down.png"
                                            imageFeature.anchors.margins: 1

                                            background.sourceComponent: Item{}

                                            stateInterlock: props.sashMotorizeDownInterlocked
                                            stateIO: props.sashMotorizeState == MachineAPI.MOTOR_SASH_STATE_DOWN

                                            onClicked: {
                                                if (stateInterlock) {
                                                    showDialogMessage(qsTr("Warning"), qsTr("Interlocked!"), dialogAlert)
                                                    return
                                                }//
                                                //console.debug("On DOWN Pressed!")
                                                //props.buttonSashMotorizedDownPressed = true;
                                                if(props.sashMotorizeState) {
                                                    MachineAPI.setSashWindowMotorizeState(MachineAPI.MOTOR_SASH_STATE_OFF)
                                                    MachineAPI.insertEventLog(qsTr("User: Set sash motorize stop"))
                                                    return
                                                }
                                                //MachineAPI.setButtonSashMotorizedPressed(true)
                                                //MachineAPI.setSashWindowMotorizeState(MachineAPI.MOTOR_SASH_STATE_DOWN)
                                                //MachineAPI.insertEventLog(qsTr("User: Set sash motorize down"))
                                            }//

                                            onPressAndHold: {
                                                if (stateInterlock) return
                                                //console.debug("On DOWN Pressed!")
                                                //props.buttonSashMotorizedDownPressed = true;
                                                //MachineAPI.setButtonSashMotorizedPressed(true)
                                                MachineAPI.setSashWindowMotorizeState(MachineAPI.MOTOR_SASH_STATE_DOWN)

                                                MachineAPI.insertEventLog(qsTr("User: Set sash motorize down"))
                                            }//

                                            onReleasedPress: {
                                                if (stateInterlock) return
                                                //console.debug("On DOWN Released!")
                                                //props. = false;
                                                //MachineAPI.setButtonSashMotorizedPressed(false)
                                                MachineAPI.setSashWindowMotorizeState(MachineAPI.MOTOR_SASH_STATEbuttonSashMotorizedDownPressed_OFF)

                                                MachineAPI.insertEventLog(qsTr("User: Set sash motorize stop"))
                                            }//

                                            states: [
                                                State {
                                                    when: sashMotorDownButton.stateInterlock
                                                    PropertyChanges {
                                                        target: sashMotorDownButton
                                                        sourceImage: "qrc:/UI/Pictures/controll/Button_Down_Gray.png"
                                                    }
                                                }
                                                ,
                                                State {
                                                    when: sashMotorDownButton.stateIO
                                                    PropertyChanges {
                                                        target: sashMotorDownButton
                                                        sourceImage: "qrc:/UI/Pictures/controll/Button_Down_Run.png"
                                                    }
                                                }
                                            ]
                                        }//
                                    }//
                                }//

                                visible: active
                                active: {
                                    if (props.sashMotorizeInstalled) {
                                        return true
                                    }
                                    return false
                                }//
                            }//
                        }//

                        /// methode to make this component upper then other content componet
                        /// including status bar
                        BiosafetyCabinet3D {
                            id: cabinet3D
                            x : bsc3DItem.x
                            y : bsc3DItem.y
                            height: bsc3DItem.height
                            width: bsc3DItem.width
                            modelName: MachineData.machineModelName
                            sideGlass: HeaderAppService.sideGlass

                            function updateCabinetBaseItem(){
                                if(props.alarmsState){
                                    return cabinet3D.cabinetBaseItem.stateAlarm
                                }
                                if (props.warmingUpActive) {
                                    return cabinet3D.cabinetBaseItem.stateWarn
                                }
                                return cabinet3D.cabinetBaseItem.stateNone
                            }//

                            function updateHeaderIcon(){
                                if (props.fanState == MachineAPI.FAN_STATE_ON){
                                    if(!props.modeIsMaintenance){
                                        if(!props.warmingUpActive){
                                            if(props.sensorCalibrated) {
                                                if (!props.alarmsState) {
                                                    return true
                                                }
                                            }
                                        }
                                    }
                                }
                                return false
                            }//

                            function updateSashItem(){
                                switch (props.sashWindowState){
                                case MachineAPI.SASH_STATE_FULLY_CLOSE_SSV:
                                    if(props.uvState) return cabinet3D.sashImageItem.stateUvActive
                                    return cabinet3D.sashImageItem.stateFullyClose
                                case MachineAPI.SASH_STATE_WORK_SSV:
                                    return cabinet3D.sashImageItem.stateSafe
                                case MachineAPI.SASH_STATE_UNSAFE_SSV:
                                    return cabinet3D.sashImageItem.stateUnsafe
                                case MachineAPI.SASH_STATE_FULLY_OPEN_SSV:
                                    return cabinet3D.sashImageItem.stateFullyOpen
                                case MachineAPI.SASH_STATE_STANDBY_SSV:
                                    return cabinet3D.sashImageItem.stateStandby
                                default:
                                    return cabinet3D.sashImageItem.stateNone
                                }
                            }//

                            airflowArrowActive: arrrowActive && contentView.visible
                            property bool arrrowActive: false
                            function updateAirflowArrow(){
                                switch(props.fanState){
                                case MachineAPI.FAN_STATE_ON:
                                case MachineAPI.FAN_STATE_STANDBY:
                                    return true;
                                default:
                                    return false;
                                }
                            }//

                            Component.onCompleted: {
                                sashImageItem.state = Qt.binding(updateSashItem)
                                arrrowActive = Qt.binding(updateAirflowArrow)
                                headerImageItem.visible = Qt.binding(updateHeaderIcon)
                                cabinetBaseItem.state = Qt.binding(updateCabinetBaseItem)
                            }//

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    //                                    var intent = IntentApp.create("qrc:/UI/Pages/DiagnosticsPage/DiagnosticsPage.qml")
                                    var intent = IntentApp.create(/*"qrc:/UI/Pages/CertificationReportPage/CertificationReportPage.qml"*/"qrc:/UI/Pages/ShortCutMenuPage/ShortCutMenuPage.qml")
                                    startView(intent)
                                }//
                            }//

                            /// Badge Notification
                            Column {
                                spacing: 2

                                Loader {
                                    active: props.certfRemExpiredValid && (props.certfRemExpiredCount < 30)
                                    sourceComponent: CusComPage.BadgeNotificationApp{
                                        height: 40
                                        width: cabinet3D.width
                                        text: {
                                            if (props.certfRemExpiredCount < 1){
                                                return qsTr("Cert. due date has passed!")
                                            }
                                            else {
                                                let dayText = props.certfRemExpiredCount > 1 ? qsTr("days") : qsTr("day")
                                                return qsTr("Cert. due date in") + " " + props.certfRemExpiredCount + " " + dayText
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            enabled:props.certfRemExpiredCount < 1
                                            onClicked: {
                                                showDialogMessage(qsTr("Certification Remainder"),
                                                                  qsTr("Certification due date has passed on ") + props.certfRemExpiredDate + "<br><br>"+
                                                                  qsTr("Please contact your cabinet service reresentative!"),
                                                                  dialogAlert)
                                            }//
                                        }//
                                    }//
                                }//

                                Loader {
                                    //                                    active: false
                                    active: props.datalogIsFull
                                    sourceComponent: CusComPage.BadgeNotificationApp{
                                        height: 40
                                        width: cabinet3D.width

                                        text: qsTr("Datalog is full!")
                                    }//
                                }//

                                Loader {
                                    active: false
                                    sourceComponent: CusComPage.BadgeNotificationApp{
                                        height: 40
                                        width: cabinet3D.width

                                        text: qsTr("Event log is full!")
                                    }//
                                }//

                                Loader {
                                    active: false
                                    sourceComponent: CusComPage.BadgeNotificationApp{
                                        height: 40
                                        width: cabinet3D.width

                                        text: qsTr("Alarm log is full!")
                                    }//
                                }//
                            }//
                        }//
                    }//
                }//

                /// methode to make this component upper then other (centerContentItem) content componet
                /// but the position still what I want ^_^
                RowLayout {
                    id: secondTopBar
                    x: secondTopBarSpace.x
                    y: secondTopBarSpace.y
                    height: secondTopBarSpace.height
                    width: secondTopBarSpace.width
                    spacing: 5

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumWidth: 300

                        Rectangle {
                            anchors.fill: parent
                            color: "#0F2952"
                            radius: 5
                            border.width: 1
                            border.color: "#dddddd"

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 1
                                spacing: 1

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    TextApp {
                                        id: cabinetDisplayName
                                        anchors.fill: parent
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                        text: props.cabinetDisplayName
                                    }//
                                }//

                                Rectangle {
                                    Layout.minimumHeight: parent.height * 0.7
                                    Layout.minimumWidth: 1
                                    color: "gray"
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    //                                    Image {
                                    //                                        height: parent.height
                                    //                                        fillMode: Image.PreserveAspectFit
                                    //                                        source: "qrc:/UI/Pictures/user-icon-dark-35px.png"
                                    //                                    }//

                                    TextApp {
                                        anchors.fill: parent
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                        elide: Text.ElideMiddle
                                        text: props.loginFullname
                                    }//

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            //                                                    props.goToLogin()
                                            UserSessionService.askedForLogin()
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 1

                            /// Long information
                            Loader {
                                id: textTeleprompterLoader
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                z: tempClockDate.z + 1
                                sourceComponent: Item {
                                    height: textTeleprompterLoader.height
                                    width: textTeleprompterLoader.width

                                    TextTeleprompter {
                                        id: textTeleprompter
                                        height: textHeightArea
                                        width: textTeleprompterLoader.width
                                        //                                            text: qsTr("The sash height is not in the normal working height (Safe height).\nSet it back to normal working height!")
                                        //                                            text: qsTr("The inflow value is too low!\nPotentially reducing the protecttive capabilities of the cabinet.\nEnsure that sensors and ventilation paths are not obstructed.")

                                        states: [
                                            State {
                                                when: props.sashCycleLockedAlarm
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The sash motor cycle has exceeded the maximum operating limit!.\nSash motor has been locked.\nPlease contact your service engineer to do maintenance.")
                                                }
                                            }//
                                            ,
                                            State {
                                                when: props.sashCycleStopCaution
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The use of the sash motor is almost at maximum use!.\nStop using sash motor!.\nPlease contact your service engineer to do maintenance.")
                                                }
                                            }//
                                            ,
                                            State {
                                                when: props.sashCycleReplaceCaution
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The use of the sash motor is almost at maximum use!.\nReplace the sash motor!.\nPlease contact your service engineer to do maintenance.")
                                                }//
                                            }//
                                            ,
                                            State {
                                                when: props.alarmSash >= MachineAPI.ALARM_SASH_ACTIVE_UNSAFE_STATE
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The sash height is not in the normal working height (Safe height).\nSet it back to normal working height!")
                                                }
                                            },
                                            State {
                                                when: (props.alarmDownflowLow == MachineAPI.ALARM_ACTIVE_STATE) &&
                                                      (props.alarmInflowLow == MachineAPI.ALARM_ACTIVE_STATE)
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The Airflow velocity is too low!\nPotentially reducing the protective capabilities of the cabinet.\nEnsure that sensors, grill and ventilation paths are not obstructed.")
                                                }
                                            },
                                            State {
                                                when: (((props.alarmDownflowLow == MachineAPI.ALARM_ACTIVE_STATE) ||
                                                        (props.alarmDownflowHigh == MachineAPI.ALARM_ACTIVE_STATE)) &&
                                                       (props.alarmInflowLow == MachineAPI.ALARM_ACTIVE_STATE))
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The Airflow velocity failed!\nPotentially reducing the protective capabilities of the cabinet.\nEnsure that sensors, grill and ventilation paths are not obstructed.")
                                                }
                                            },
                                            State {
                                                when: props.alarmDownflowLow == MachineAPI.ALARM_ACTIVE_STATE
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The Downflow velocity is too low!\nPotentially reducing the protective capabilities of the cabinet.\nEnsure that sensors, grill and ventilation paths are not obstructed.")
                                                }
                                            },
                                            State {
                                                when: props.alarmInflowLow == MachineAPI.ALARM_ACTIVE_STATE
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The inflow velocity is too low!\nPotentially reducing the protective capabilities of the cabinet.\nEnsure that sensors, grill and ventilation paths are not obstructed.")
                                                }
                                            },
                                            State {
                                                when: props.alarmDownflowHigh == MachineAPI.ALARM_ACTIVE_STATE
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The Downflow velocity is too high!\nPotentially reducing the protective capabilities of the cabinet.\nEnsure that sensors, grill and ventilation paths are not obstructed.")
                                                }
                                            },
                                            State {
                                                when: props.alarmSeasTooPositive
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The exhaust pressure is too high!\nPotentially reducing the protective capabilities of the cabinet.\nEnsure that exhaust fan is in nominal speed and damper is opened.")
                                                }
                                            },
                                            State {
                                                when: props.alarmSeasFlapTooPositive
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The exhaust pressure is too high!\nPotentially reducing the protective capabilities of the cabinet.\nEnsure that exhaust fan is in nominal speed and damper is opened.")
                                                }
                                            },
                                            State {
                                                when: (props.alarmTempHigh == MachineAPI.ALARM_ACTIVE_STATE)
                                                      || (props.alarmTempLow == MachineAPI.ALARM_ACTIVE_STATE)
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The environmental temperature was out off range!%1\n The ideal environmental temperature is between ").arg((MachineData.getDownflowSensorConstant() === 0 || MachineData.getDownflowSensorConstant() === 0) ? "" : "\nPottentially reduce the reading accuration of the airflow sensor(s).")
                                                          + props.tempAmbientLowStrf + " - " + props.tempAmbientHighStrf + "."
                                                }
                                            },
                                            State {
                                                when: props.alarmStandbyFanOff
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The Fan should be operating at standby speed during in sash standby height!\n Please switch on the Fan by pressing the Fan button")
                                                }
                                            }//
                                        ]//
                                    }//

                                    Timer {
                                        id: delayHeightTimer
                                        interval: 10000 // 10s
                                        running: true; repeat: false
                                        onTriggered: {
                                            textTeleprompter.height = textTeleprompterLoader.height
                                        }
                                    }

                                    MouseArea {
                                        id: expandCollapseInfoTextMouseArea
                                        anchors.fill: parent
                                        onClicked: {
                                            if(textTeleprompter.height == textTeleprompter.textHeightArea){
                                                textTeleprompter.height = textTeleprompterLoader.height
                                                textTeleprompter.textY = 0
                                                delayHeightTimer.stop()
                                                return
                                            }
                                            textTeleprompter.height = textTeleprompter.textHeightArea
                                            textTeleprompter.textY = 0
                                            delayHeightTimer.restart()
                                        }//
                                    }//
                                }//

                                visible: active
                                active: {
                                    if (props.alarmsState) {
                                        if (props.alarmSash >= MachineAPI.ALARM_SASH_ACTIVE_UNSAFE_STATE) {
                                            return true
                                        }
                                        else if (props.alarmInflowLow == MachineAPI.ALARM_ACTIVE_STATE) {
                                            return true
                                        }
                                        else if (props.alarmDownflowLow == MachineAPI.ALARM_ACTIVE_STATE || props.alarmDownflowHigh == MachineAPI.ALARM_ACTIVE_STATE) {
                                            return true
                                        }
                                        else if (props.alarmSeasTooPositive) {
                                            return true
                                        }
                                        else if (props.alarmSeasFlapTooPositive) {
                                            return true
                                        }
                                        else if ((props.alarmTempHigh == MachineAPI.ALARM_ACTIVE_STATE)
                                                 || (props.alarmTempLow == MachineAPI.ALARM_ACTIVE_STATE)){
                                            return true
                                        }
                                        else if (props.alarmStandbyFanOff) {
                                            return true
                                        }
                                        else if (props.sashCycleLockedAlarm || props.sashCycleStopCaution || props.sashCycleReplaceCaution) {
                                            return true
                                        }
                                    }
                                    return false
                                }//
                            }//

                            /// Temp - Clock - Date
                            Rectangle {
                                id: tempClockDate
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                color: "#0F2952"
                                radius: 5
                                border.width: 1
                                border.color: "#dddddd"

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 1
                                    spacing: 1

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.minimumWidth: height

                                        WifiSignalApp {
                                            anchors.fill: parent
                                            dissconnect: !NetworkService.connected
                                            strength: 100 // dummy Value signal strength

                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                    const intent = IntentApp.create("qrc:/UI/Pages/NetworkConfigPage/NetworkConfigPage.qml", {})
                                                    startView(intent)
                                                }
                                            }
                                        }
                                    }

                                    Rectangle {
                                        Layout.minimumHeight: parent.height * 0.7
                                        Layout.minimumWidth: 1
                                        color: "gray"
                                    }///

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true

                                        TextApp {
                                            id: tempAmbientText
                                            anchors.fill: parent
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                            elide: Text.ElideRight
                                            text: qsTr("Temp") + ": " + props.temperatureStrf

                                            states: [
                                                State {
                                                    when: props.tempAmbientStatus == MachineAPI.TEMP_AMB_LOW /*|| true*/
                                                    PropertyChanges {
                                                        target: tempAmbientText
                                                        text: qsTr("Temp") + ": " + props.temperatureStrf + " " + qsTr("(Too low)")
                                                    }
                                                    PropertyChanges {
                                                        target: tempAmbientText
                                                        color: "#db6400"
                                                    }
                                                },
                                                State {
                                                    when: props.tempAmbientStatus == MachineAPI.TEMP_AMB_HIGH /*|| true*/
                                                    PropertyChanges {
                                                        target: tempAmbientText
                                                        text: qsTr("Temp") + ": " + props.temperatureStrf + " " + qsTr("(Too high)")
                                                    }
                                                    PropertyChanges {
                                                        target: tempAmbientText
                                                        color: "#db6400"
                                                    }
                                                }
                                            ]
                                        }//
                                    }//

                                    Rectangle {
                                        Layout.minimumHeight: parent.height * 0.7
                                        Layout.minimumWidth: 1
                                        color: "gray"
                                    }///

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true

                                        TextApp {
                                            id: currentTimeText
                                            anchors.fill: parent
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                            elide: Text.ElideRight
                                            text: "12:00 PM"
                                        }//
                                    }//

                                    Rectangle {
                                        Layout.minimumHeight: parent.height * 0.7
                                        Layout.minimumWidth: 1
                                        color: "gray"
                                    }//

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true

                                        TextApp {
                                            id: currentDateText
                                            anchors.fill: parent
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                            elide: Text.ElideRight
                                            text: "---"
                                        }//

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                const intent = IntentApp.create("qrc:/UI/Pages/CalendarPage/CalendarPage.qml", {})
                                                startView(intent)
                                            }//
                                        }//
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
                Layout.minimumHeight: 110

                Rectangle {
                    anchors.fill: parent
                    color: "#0F2952"
                    radius: 5

                    RowLayout {
                        id: footerRowLayout
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 5

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            CusComPage.ControlButtonApp {
                                id: menuControlButton
                                anchors.fill: parent

                                sourceImage: "qrc:/UI/Pictures/controll/Menu_W.png"

                                states: [
                                    State {
                                        when: stackViewDepth > 1
                                        PropertyChanges {
                                            target: menuControlButton
                                            sourceImage: "qrc:/UI/Pictures/back-step-100.png"
                                        }
                                    }
                                ]

                                function callMenuControlButton (){
                                    MachineAPI.setBuzzerBeep();

                                    if (stackViewDepth > 1) {
                                        const intent = IntentApp.create(uri, {})
                                        finishView(intent)
                                        return
                                    }

                                    const intent = IntentApp.create("qrc:/UI/Pages/MenuPage/MenuPage.qml")
                                    //                                    const intent = IntentApp.create("qrc:/UI/Pages/TimePickerPage/TimePickerPage.qml", {"periodMode": 12})
                                    startView(intent)
                                }//

                                onClicked: {

                                    //                                    if (props.checkModerateLevel() || props.checkSecureLevel()){
                                    //                                        return
                                    //                                    }
                                    //                                    else {

                                    if (!UserSessionService.loggedIn) {
                                        //                                        console.log(props.securityAccessLevel )
                                        switch (props.securityAccessLevel) {
                                        case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                            callMenuControlButton()
                                            break;
                                        case MachineAPI.MODE_SECURITY_ACCESS_MODERATE:
                                        case MachineAPI.MODE_SECURITY_ACCESS_SECURE:
                                            UserSessionService.askedForLogin()
                                            break;
                                        }//
                                    }//

                                    else {
                                        callMenuControlButton()
                                    }//
                                }//
                            }//
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            CusComPage.ControlButtonApp {
                                id: fanButton
                                anchors.fill: parent

                                sourceImage: "qrc:/UI/Pictures/controll/Fan_W.png"

                                Loader {
                                    active: MachineData.fanAutoSetEnabled || MachineData.fanAutoSetEnabledOff
                                    anchors.left: parent.left
                                    anchors.leftMargin: 5
                                    anchors.top: parent.top
                                    anchors.topMargin: 5
                                    sourceComponent: Image {
                                        opacity: props.fanInterlocked ? 0.5 : 1
                                        source: "qrc:/UI/Pictures/controll/output-schedulle-icon.png"
                                    }//
                                }//

                                function callFanButton() {
                                    ///Check the PIN
                                    if(props.fanPIN != "dcddb75469b4b4875094e14561e573d8") {
                                        const intent = IntentApp.create("qrc:/UI/Pages/FanPinPage/FanPinPage.qml", {})
                                        startView(intent);
                                        return
                                    }

                                    if (props.fanState) {
                                        showDialogAsk(qsTr("Attention!"), qsTr("Turn off the Fan?"),
                                                      dialogAlert,
                                                      function onAccepted(){
                                                          MachineAPI.setFanState(MachineAPI.FAN_STATE_OFF);
                                                          props.showFanProgressSwitchingState(!props.fanState)

                                                          MachineAPI.insertEventLog(qsTr("User: Set Fan off"))
                                                      });
                                    }
                                    else {
                                        if((props.sashWindowState === MachineAPI.SASH_STATE_STANDBY_SSV) && (MachineData.operationMode !== MachineAPI.MODE_OPERATION_MAINTENANCE))
                                            MachineAPI.setFanState(MachineAPI.FAN_STATE_STANDBY);
                                        else
                                            MachineAPI.setFanState(MachineAPI.FAN_STATE_ON);
                                        props.showFanProgressSwitchingState(!props.fanState)

                                        MachineAPI.insertEventLog(qsTr("User: Set Fan on"))
                                    }
                                }//

                                onClicked: {
                                    MachineAPI.setBuzzerBeep();

                                    if (stateInterlock) {
                                        showDialogMessage(qsTr("Warning"), qsTr("Interlocked!"), dialogAlert)
                                        return
                                    }

                                    if (!UserSessionService.loggedIn) {
                                        switch(props.securityAccessLevel) {

                                        case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                        case MachineAPI.MODE_SECURITY_ACCESS_MODERATE:
                                            callFanButton()
                                            break;
                                        case MachineAPI.MODE_SECURITY_ACCESS_SECURE:
                                            UserSessionService.askedForLogin()
                                            break;
                                        }
                                    }
                                    else {
                                        callFanButton()
                                    }//
                                }//

                                onPressAndHold: {
                                    MachineAPI.setBuzzerBeep();

                                    if (!UserSessionService.loggedIn) {
                                        switch(props.securityAccessLevel) {

                                        case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                        case MachineAPI.MODE_SECURITY_ACCESS_MODERATE:
                                            let intent1;
                                            if(props.modeIsMaintenance)
                                                intent1 = IntentApp.create("qrc:/UI/Pages/FanSpeedPage/FanSpeedPage.qml", {})
                                            else
                                                intent1 = IntentApp.create("qrc:/UI/Pages/FanSchedulerPage/FanSchedulerPage.qml", {})
                                            const intent = intent1
                                            startView(intent)
                                            break;
                                        case MachineAPI.MODE_SECURITY_ACCESS_SECURE:
                                            UserSessionService.askedForLogin()
                                            break;
                                        }
                                    }
                                    else {
                                        let intent1;
                                        if(props.modeIsMaintenance)
                                            intent1 = IntentApp.create("qrc:/UI/Pages/FanSpeedPage/FanSpeedPage.qml", {})
                                        else
                                            intent1 = IntentApp.create("qrc:/UI/Pages/FanSchedulerPage/FanSchedulerPage.qml", {})
                                        const intent = intent1
                                        startView(intent)
                                    }//
                                }//

                                stateInterlock: props.fanInterlocked

                                states: [
                                    State {
                                        when: props.fanState == MachineAPI.FAN_STATE_ON
                                        PropertyChanges {
                                            target: fanButton
                                            sourceImage: "qrc:/UI/Pictures/controll/Fan_G.png"
                                        }
                                    },
                                    State {
                                        when: props.fanState == MachineAPI.FAN_STATE_STANDBY
                                        PropertyChanges {
                                            target: fanButton
                                            sourceImage: "qrc:/UI/Pictures/controll/STB_G.png"
                                        }
                                    }//
                                ]//
                            }//
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            CusComPage.ControlButtonApp {
                                id: lightButton
                                anchors.fill: parent

                                sourceImage: "qrc:/UI/Pictures/controll/Light_W.png"

                                TextApp {
                                    visible: props.lampState
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                    anchors.top: parent.top
                                    anchors.topMargin: 5
                                    text: props.lampIntensity + "%"
                                }//

                                function callLightButtonOnHold() {
                                    let currentState = MachineData.lightState
                                    if (!currentState) {
                                        MachineAPI.setLightState(!currentState);
                                    }

                                    var intent = IntentApp.create("qrc:/UI/Pages/LightIntensityPage/LightIntensityPage.qml", {})
                                    startView(intent)
                                }//

                                function callLightButton (){
                                    MachineAPI.setBuzzerBeep();

                                    if (stateInterlock) {
                                        showDialogMessage(qsTr("Warning"), qsTr("Interlocked!"), dialogAlert)
                                        return
                                    }//

                                    let currentState = MachineData.lightState
                                    MachineAPI.setLightState(!currentState);

                                    const str = !currentState ? qsTr("User: Set LED light on") : qsTr("User: Set LED light off")
                                    MachineAPI.insertEventLog(str)
                                }

                                onPressAndHold: {

                                    if (!UserSessionService.loggedIn) {
                                        switch(props.securityAccessLevel) {

                                        case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                        case MachineAPI.MODE_SECURITY_ACCESS_MODERATE:
                                            callLightButtonOnHold()
                                            break;
                                        case MachineAPI.MODE_SECURITY_ACCESS_SECURE:
                                            UserSessionService.askedForLogin()
                                            break;
                                        }
                                    }
                                    else {
                                        callLightButtonOnHold()
                                    }//
                                }//

                                onClicked: {

                                    if (!UserSessionService.loggedIn) {
                                        switch(props.securityAccessLevel) {

                                        case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                        case MachineAPI.MODE_SECURITY_ACCESS_MODERATE:
                                            callLightButton()
                                            break;
                                        case MachineAPI.MODE_SECURITY_ACCESS_SECURE:
                                            UserSessionService.askedForLogin()
                                            break;
                                        }
                                    }
                                    else {
                                        callLightButton()
                                    }//
                                }//

                                stateInterlock: props.lampInterlocked

                                states: [
                                    State {
                                        when: props.lampState
                                        PropertyChanges {
                                            target: lightButton
                                            sourceImage: "qrc:/UI/Pictures/controll/Light_G.png"
                                        }//
                                    }//
                                ]
                            }//
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            visible: props.socketInstalled
                            //                            visible: false

                            Loader {
                                active: props.socketInstalled
                                anchors.fill: parent
                                sourceComponent: CusComPage.ControlButtonApp {
                                    id: socketButton
                                    anchors.fill: parent

                                    sourceImage: "qrc:/UI/Pictures/controll/Socket_W.png"

                                    function callSocketButton() {
                                        MachineAPI.setBuzzerBeep();

                                        if (stateInterlock) {
                                            showDialogMessage(qsTr("Warning"), qsTr("Interlocked!"), dialogAlert)
                                            return
                                        }//

                                        let currentState = MachineData.socketState
                                        MachineAPI.setSocketState(!currentState);

                                        const str = !currentState ? qsTr("User: Set Socket on") : qsTr("User: Set Socket off")
                                        MachineAPI.insertEventLog(str)
                                    }//


                                    onClicked: {

                                        if (!UserSessionService.loggedIn) {
                                            switch(props.securityAccessLevel) {

                                            case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                            case MachineAPI.MODE_SECURITY_ACCESS_MODERATE:
                                                callSocketButton()
                                                break;
                                            case MachineAPI.MODE_SECURITY_ACCESS_SECURE:
                                                UserSessionService.askedForLogin()
                                                break;
                                            }
                                        }
                                        else {
                                            callSocketButton()
                                        }//
                                    }//

                                    stateInterlock: props.socketInterlocked

                                    states: [
                                        State {
                                            when: props.socketState
                                            PropertyChanges {
                                                target: socketButton
                                                sourceImage: "qrc:/UI/Pictures/controll/Socket_G.png"
                                            }
                                        }
                                    ]
                                }//
                            }
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            visible: props.gasInstalled
                            //                            visible: false

                            Loader {
                                active: props.gasInstalled
                                anchors.fill: parent
                                sourceComponent: CusComPage.ControlButtonApp {
                                    id: gasButton
                                    anchors.fill: parent

                                    sourceImage: "qrc:/UI/Pictures/controll/Gas_W.png"

                                    function callGasButton(){
                                        MachineAPI.setBuzzerBeep();

                                        if (stateInterlock) {
                                            showDialogMessage(qsTr("Warning"), qsTr("Interlocked!"), dialogAlert)
                                            return
                                        }//

                                        let currentState = MachineData.gasState
                                        MachineAPI.setGasState(!currentState);

                                        const str = !currentState ? qsTr("User: Set Gas on") : qsTr("User: Set Gas off")
                                        MachineAPI.insertEventLog(str)
                                    }//

                                    onClicked: {
                                        if (!UserSessionService.loggedIn) {
                                            switch(props.securityAccessLevel) {

                                            case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                            case MachineAPI.MODE_SECURITY_ACCESS_MODERATE:
                                                callGasButton()
                                                break;
                                            case MachineAPI.MODE_SECURITY_ACCESS_SECURE:
                                                UserSessionService.askedForLogin()
                                                break;
                                            }
                                        }
                                        else {
                                            callGasButton()
                                        }//
                                    }//

                                    stateInterlock: props.gasInterlocked

                                    states: [
                                        State {
                                            when: props.gasState
                                            PropertyChanges {
                                                target: gasButton
                                                sourceImage: "qrc:/UI/Pictures/controll/Gas_G.png"
                                            }//
                                        }//
                                    ]
                                }//
                            }//
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            //                            visible: false
                            visible: props.uvInstalled

                            Loader {
                                active: props.uvInstalled
                                anchors.fill: parent
                                sourceComponent: CusComPage.ControlButtonApp {
                                    id: uvButton
                                    anchors.fill: parent

                                    sourceImage: "qrc:/UI/Pictures/controll/UV_W.png"

                                    Loader {
                                        active: MachineData.uvAutoSetEnabled || MachineData.uvAutoSetEnabledOff
                                        anchors.left: parent.left
                                        anchors.leftMargin: 5
                                        anchors.top: parent.top
                                        anchors.topMargin: 5
                                        sourceComponent:  Image {
                                            opacity: props.uvInterlocked ? 0.5 : 1
                                            source: "qrc:/UI/Pictures/controll/output-schedulle-icon.png"
                                        }//
                                    }//

                                    function callUVbutton(){
                                        MachineAPI.setBuzzerBeep();

                                        if (stateInterlock) {
                                            showDialogMessage(qsTr("Warning"), qsTr("Interlocked!"), dialogAlert)
                                            return
                                        }

                                        let currentState = MachineData.uvState
                                        MachineAPI.setUvState(!currentState);

                                        const str = !currentState ? qsTr("User: Set UV light on") : qsTr("User: Set UV light off")
                                        MachineAPI.insertEventLog(str)
                                    }//

                                    onClicked: {
                                        if (!UserSessionService.loggedIn) {
                                            switch(props.securityAccessLevel) {

                                            case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                            case MachineAPI.MODE_SECURITY_ACCESS_MODERATE:
                                                callUVbutton()
                                                break;
                                            case MachineAPI.MODE_SECURITY_ACCESS_SECURE:
                                                UserSessionService.askedForLogin()
                                                break;
                                            }
                                        }
                                        else {
                                            callUVbutton()
                                        }//
                                    }//

                                    onPressAndHold: {
                                        MachineAPI.setBuzzerBeep();

                                        if (!UserSessionService.loggedIn) {
                                            switch(props.securityAccessLevel) {

                                            case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                            case MachineAPI.MODE_SECURITY_ACCESS_MODERATE:
                                                const intent = IntentApp.create("qrc:/UI/Pages/UVSchedulerPage/UVSchedulerPage.qml", {})
                                                startView(intent)
                                                break;
                                            case MachineAPI.MODE_SECURITY_ACCESS_SECURE:
                                                UserSessionService.askedForLogin()
                                                break;
                                            }
                                        }
                                        else {
                                            const intent = IntentApp.create("qrc:/UI/Pages/UVSchedulerPage/UVSchedulerPage.qml", {})
                                            startView(intent)
                                        }//
                                    }//

                                    stateInterlock: props.uvInterlocked || (props.sashWindowState !== MachineAPI.SASH_STATE_FULLY_CLOSE_SSV)

                                    states: [
                                        State {
                                            when: props.uvState
                                            PropertyChanges {
                                                target: uvButton
                                                sourceImage: "qrc:/UI/Pictures/controll/UV_G.png"
                                            }
                                        }
                                    ]
                                }//
                            }//
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            CusComPage.ControlButtonApp {
                                id: muteAlarmButton
                                anchors.fill: parent
                                //stateInterlock: !props.alarmsState

                                sourceImage: "qrc:/UI/Pictures/controll/Mute_W.png"

                                function callMuteAlarmButton () {
                                    if (!props.alarmsState) {
                                        showDialogMessage(qsTr("Audible Alarm"), qsTr("There's no audible alarm."), dialogAlert)
                                        return
                                    }
                                    else if (props.alarmSashFullyOpen
                                             || props.alarmBoardComError
                                             || (props.alarmInflowLow == MachineAPI.ALARM_ACTIVE_STATE)
                                             || (props.alarmDownflowLow == MachineAPI.ALARM_ACTIVE_STATE)
                                             || (props.alarmDownflowHigh == MachineAPI.ALARM_ACTIVE_STATE)
                                             || props.alarmSeasTooPositive
                                             || props.alarmSeasFlapTooPositive
                                             || props.alarmFrontPanel) {
                                        MachineAPI.setMuteAlarmState(!props.muteAlarmState)
                                    }
                                    else {
                                        if(props.vivariumMuteState)
                                            MachineAPI.setMuteVivariumState(false)
                                        else
                                            showDialogMessage(qsTr("Audible Alarm"),
                                                              qsTr("This audible alarm can not be muted!"), dialogAlert)
                                    }//
                                }//

                                onPressAndHold: {
                                    if (!UserSessionService.loggedIn) {
                                        switch(props.securityAccessLevel) {

                                        case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                        case MachineAPI.MODE_SECURITY_ACCESS_MODERATE:
                                            const intent = IntentApp.create("qrc:/UI/Pages/VivariumMuteSetPage/VivariumMuteSetPage.qml", {})
                                            startView(intent)
                                            break;
                                        case MachineAPI.MODE_SECURITY_ACCESS_SECURE:
                                            UserSessionService.askedForLogin()
                                            break;
                                        }
                                    }
                                    else {
                                        const intent = IntentApp.create("qrc:/UI/Pages/VivariumMuteSetPage/VivariumMuteSetPage.qml", {})
                                        startView(intent)
                                    }//
                                }

                                onClicked: {
                                    MachineAPI.setBuzzerBeep();

                                    if (!UserSessionService.loggedIn) {
                                        switch(props.securityAccessLevel) {

                                        case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                        case MachineAPI.MODE_SECURITY_ACCESS_MODERATE:
                                            callMuteAlarmButton()
                                            break;
                                        case MachineAPI.MODE_SECURITY_ACCESS_SECURE:
                                            UserSessionService.askedForLogin()
                                            break;
                                        }
                                    }
                                    else {
                                        callMuteAlarmButton()
                                    }//
                                }//

                                states: [
                                    State {
                                        when: props.muteAlarmState
                                        PropertyChanges {
                                            target: muteAlarmButton
                                            sourceImage: "qrc:/UI/Pictures/controll/Mute_G.png"
                                        }
                                    }
                                ]
                            }//
                        }//
                    }//
                }//
            }//
        }//

        //// Timer for update current clock and date
        Timer{
            id: timeDateTimer
            interval: 10000
            repeat: true
            running: contentView.visible
            triggeredOnStart: true
            onTriggered: {
                var datetime = new Date();
                //            dateText.text = Qt.formatDateTime(datetime, "dddd\nMMM dd yyyy")
                let date = Qt.formatDateTime(datetime, "MMM dd yyyy")
                currentDateText.text = date

                let timeFormatStr = "h:mm AP"
                if (HeaderAppService.timePeriod === 24) timeFormatStr = "hh:mm"

                let clock = Qt.formatDateTime(datetime, timeFormatStr)
                currentTimeText.text = clock
            }//
        }//

        UtilsApp {
            id: utils
        }//

        QtObject {
            id: props

            property bool currentPageIsForground: false

            property int    expTimerCount: 0
            property bool   expTimerIsRunning: false
            property bool   expTimerIsPaused: false
            property bool   expTimerTimeout: false
            property bool   expTimerActive: false

            property string temperatureStrf: "--"

            property string downflowStr: "--"
            property string inflowStr: "--"

            property int sashWindowState: 0
            property int sashCycle: 0
            property bool sashCycleLockedAlarm: false
            property bool sashCycleStopCaution: false
            property bool sashCycleReplaceCaution: false

            property bool fanInterlocked: false
            property int  fanState: 0

            property bool lampInterlocked: false
            property int  lampState: 0
            property int  lampIntensity: 0

            property bool socketInstalled: false
            property bool socketInterlocked: false
            property int  socketState: 0

            property bool gasInstalled: false
            property bool gasInterlocked: false
            property int  gasState: 0

            property bool uvInstalled: false
            property bool uvInterlocked: false
            property int  uvState: 0

            property bool sashMotorizeInstalled: false
            property bool sashMotorizeUpInterlocked: false
            property bool sashMotorizeDownInterlocked: false
            property int  sashMotorizeState: 0

            property bool    seasFlapInstalled: false
            //            property string  seasPressureStr: "---"
            property bool    alarmSeasFlapTooPositive: false

            property bool    seasInstalled: false
            property string  seasPressureStr: "---"
            property bool    alarmSeasTooPositive: false

            property int uvTimeCountDown: 180
            property int uvLifePercent: 100

            property int filterLifePercent: 100

            property bool muteIsAvailable: false
            property int  muteAlarmState: 0
            property int  muteAlarmTimeCountdown: 0
            property bool vivariumMuteState: false

            property string loginUsername: ""
            property string loginFullname: ""

            property bool datalogIsFull: false
            property bool eventlogIsFull: false
            property bool alarmlogIsFull: false

            property string certfRemExpiredDate: ""
            property bool certfRemExpiredValid: false
            property bool certfRemExpiredDue: false
            property int  certfRemExpiredCount: 0

            property bool alarmsState: false

            property int  alarmSash: 0
            property bool alarmSashUnsafe: false
            property bool alarmSashError: false
            property bool alarmSashFullyOpen: false
            property bool alarmSashUnknown: false
            property int  alarmInflowLow: 0
            property int  alarmDownflowLow: 0
            property int  alarmDownflowHigh: 0
            property int  alarmTempHigh: 0
            property int  alarmTempLow: 0
            property int alarmStandbyFanOff: 0
            property int alarmFrontPanel: 0
            //            onAlarmInflowLowChanged: console.log("alarmInflowLow: " + alarmInflowLow)

            property bool alarmBoardComError: false

            property bool warmingUpActive: false
            property int  warmingUpCountdown: 180

            property bool postPurgeActive: false
            property int  postPurgeCountdown: 180

            property int tempAmbientStatus: 0
            property string tempAmbientLowStrf: "18°C"
            property string tempAmbientHighStrf: "30°C"

            property bool sensorCalibrated: false

            property bool powerOutage: false

            property bool modeIsMaintenance: false

            property int securityAccessLevel: 0

            property string cabinetDisplayName: "BSC Lab-1"

            property string fanPIN: ""

            property bool particleCounterSensorInstalled:  false
            property int particleCounterPM2_5:  0
            property int particleCounterPM1_0:  0
            property int particleCounterPM10:   0

            //            property bool buttonSashMotorizedDownPressed : false;
            property bool airflowMonitorEnable: true
            property bool alarmSashMotorDownStuck: false

            function showFanProgressSwitchingState(swithTo){
                //                //console.debug("swithTo: " + swithTo)
                const message = swithTo ? qsTr("Switching on the fan") + "..."
                                        : qsTr("Switching off the fan") + "..."
                viewApp.showBusyPage(message, function(cycle){
                    if(cycle === 5){
                        viewApp.closeDialog()
                    }
                })
            }//
            //            onButtonSashMotorizedDownPressedChanged: {
            //                if(!buttonSashMotorizedDownPressed){
            //                    console.debug("On Release Press!")
            //                    MachineAPI.setSashWindowMotorizeState(MachineAPI.MOTOR_SASH_STATE_OFF)
            //                MachineAPI.insertEventLog(qsTr("User: Set sash motorize stop"))
            //                }
            //            }//
        }//

        //        /// One time executed at startup
        //        Component.onCompleted: {

        //        }//

        //// Execute This Every This Screen Active/Visible/Foreground
        executeOnPageVisible: QtObject {
            /// onResume
            Component.onCompleted: {
                //                console.debug("StackView.Active");
                //                    //console.debug("stackViewDepth: " + stackViewDepth)

                props.securityAccessLevel = Qt.binding(function() {return MachineData.securityAccessMode })

                props.temperatureStrf = Qt.binding(function() { return MachineData.temperatureValueStr })

                props.expTimerCount = Qt.binding( function() { return ExperimentTimerService.count })
                props.expTimerIsRunning = Qt.binding( function() { return ExperimentTimerService.isRunning})
                props.expTimerIsPaused = Qt.binding( function() { return ExperimentTimerService.isPaused})
                props.expTimerTimeout = Qt.binding( function() { return ExperimentTimerService.timeout})
                props.expTimerActive = props.expTimerIsRunning || props.expTimerIsPaused

                props.downflowStr = Qt.binding(function(){ return MachineData.dfaVelocityStr })
                props.inflowStr = Qt.binding(function(){ return MachineData.ifaVelocityStr })

                props.alarmsState = Qt.binding(function(){ return MachineData.alarmsState })

                props.alarmBoardComError = Qt.binding(function(){ return MachineData.alarmBoardComError === MachineAPI.ALARM_ACTIVE_STATE })

                props.alarmSash = Qt.binding(function(){ return MachineData.alarmSash })
                props.alarmSashUnsafe = Qt.binding(function(){ return MachineData.alarmSash === MachineAPI.ALARM_SASH_ACTIVE_UNSAFE_STATE })
                props.alarmSashError = Qt.binding(function(){ return MachineData.alarmSash === MachineAPI.ALARM_SASH_ACTIVE_ERROR_STATE })
                props.alarmSashFullyOpen = Qt.binding(function(){ return MachineData.alarmSash === MachineAPI.ALARM_SASH_ACTIVE_FO_STATE })
                props.alarmSashUnknown = Qt.binding(function(){ return MachineData.alarmSash === MachineAPI.ALARM_SASH_ACTIVE_ERROR_STATE })

                props.alarmInflowLow = Qt.binding(function(){ return MachineData.alarmInflowLow})
                props.alarmDownflowLow = Qt.binding(function(){ return MachineData.alarmDownflowLow})
                props.alarmDownflowHigh = Qt.binding(function(){ return MachineData.alarmDownflowHigh})

                props.alarmTempHigh = Qt.binding(function(){ return MachineData.alarmTempHigh})
                props.alarmTempLow = Qt.binding(function(){ return MachineData.alarmTempLow})

                props.sashWindowState = Qt.binding(function(){ return MachineData.sashWindowState})

                props.alarmStandbyFanOff = Qt.binding(function(){ return MachineData.alarmStandbyFanOff === MachineAPI.ALARM_ACTIVE_STATE})
                props.alarmFrontPanel = Qt.binding(function(){ return MachineData.frontPanelAlarm === MachineAPI.ALARM_ACTIVE_STATE})

                props.fanInterlocked = Qt.binding(function(){ return MachineData.fanPrimaryInterlocked })
                props.fanState = Qt.binding(function(){
                    return MachineData.fanState
                })

                props.lampInterlocked = Qt.binding(function(){ return MachineData.lightInterlocked })
                props.lampState = Qt.binding(function(){ return MachineData.lightState })
                props.lampIntensity = Qt.binding(function(){ return MachineData.lightIntensity })

                props.socketInstalled = MachineData.socketInstalled
                props.socketInterlocked = Qt.binding(function(){ return MachineData.socketInterlocked })
                props.socketState = Qt.binding(function(){ return MachineData.socketState })

                props.gasInstalled = MachineData.gasInstalled
                props.gasInterlocked = Qt.binding(function(){ return MachineData.gasInterlocked })
                props.gasState = Qt.binding(function(){ return MachineData.gasState })

                props.uvInstalled = MachineData.uvInstalled
                props.uvInterlocked = Qt.binding(function(){ return MachineData.uvInterlocked })
                props.uvState = Qt.binding(function(){ return MachineData.uvState })

                //                    props.muteIsAvailable = Qt.binding(function(){ return MachineData.muteAlarmState })
                props.muteAlarmState = Qt.binding(function(){ return MachineData.muteAlarmState })
                props.muteAlarmTimeCountdown = Qt.binding(function(){ return MachineData.muteAlarmCountdown })
                props.vivariumMuteState = Qt.binding(function(){ return MachineData.vivariumMuteState })

                props.filterLifePercent = Qt.binding(function(){ return MachineData.filterLifePercent })

                props.sensorCalibrated = MachineData.airflowCalibrationStatus

                props.sashMotorizeInstalled = Qt.binding(function(){return MachineData.sashWindowMotorizeInstalled})
                props.sashMotorizeDownInterlocked = Qt.binding(function(){return MachineData.sashWindowMotorizeDownInterlocked})
                props.sashMotorizeUpInterlocked = Qt.binding(function(){return MachineData.sashWindowMotorizeUpInterlocked})
                props.sashMotorizeState = Qt.binding(function(){return MachineData.sashWindowMotorizeState})
                if(props.sashMotorizeInstalled){
                    props.sashCycle = Qt.binding(function(){ return MachineData.sashCycleMeter/10})
                    props.sashCycleLockedAlarm = Qt.binding(function(){return MachineData.sashCycleMotorLockedAlarm === MachineAPI.ALARM_ACTIVE_STATE})
                    props.sashCycleStopCaution = Qt.binding(function(){return ((MachineData.sashCycleMeter/10) > 15500) && props.sashMotorizeState})
                    props.sashCycleReplaceCaution = Qt.binding(function(){return ((MachineData.sashCycleMeter/10) > 15000) && props.sashMotorizeState})
                }

                ///PARTICLE COUNTER
                props.particleCounterSensorInstalled = Qt.binding(function(){return MachineData.particleCounterSensorInstalled})
                props.particleCounterPM2_5 = Qt.binding(function(){return MachineData.particleCounterPM2_5})
                props.particleCounterPM1_0 = Qt.binding(function(){return MachineData.particleCounterPM1_0})
                props.particleCounterPM10 = Qt.binding(function(){return MachineData.particleCounterPM10})

                props.seasInstalled = MachineData.seasInstalled
                if(props.seasInstalled){
                    props.seasPressureStr = Qt.binding(function(){ return MachineData.seasPressureDiffStr })
                    props.alarmSeasTooPositive = Qt.binding(function(){ return MachineData.seasAlarmPressureLow === MachineAPI.ALARM_ACTIVE_STATE })
                }

                props.seasFlapInstalled = MachineData.seasFlapInstalled
                if(props.seasFlapInstalled){
                    //                    props.seasPressureStr = Qt.binding(function(){ return MachineData.seasPressureDiffStr })
                    props.alarmSeasFlapTooPositive = Qt.binding(function(){ return MachineData.seasFlapAlarmPressure === MachineAPI.ALARM_ACTIVE_STATE })
                }

                props.warmingUpActive = Qt.binding(function(){ return MachineData.warmingUpActive });
                props.warmingUpCountdown = Qt.binding(function(){ return MachineData.warmingUpCountdown });

                props.uvTimeCountDown = Qt.binding(function(){ return MachineData.uvTimeCountdown });
                props.uvLifePercent = Qt.binding( function(){ return MachineData.uvLifePercent });

                props.postPurgeActive = Qt.binding(function(){ return MachineData.postPurgingActive });
                props.postPurgeCountdown = Qt.binding(function(){ return MachineData.postPurgingCountdown });

                props.tempAmbientStatus = Qt.binding(function(){ return MachineData.tempAmbientStatus} )

                props.modeIsMaintenance = Qt.binding(function(){ return MachineData.operationMode === MachineAPI.MODE_OPERATION_MAINTENANCE })

                props.datalogIsFull = Qt.binding(function() { return MachineData.dataLogIsFull })
                //                    props.eventlogIsFull = Qt.binding(function() { return MachineData.dataLogIsFull })
                //                    props.alarmlogIsFull = Qt.binding(function() { return MachineData.dataLogIsFull })

                /// certificatio reminder
                props.certfRemExpiredDate = Qt.binding(function() { return MachineData.dateCertificationRemainder })
                props.certfRemExpiredValid = Qt.binding(function() { return MachineData.certificationExpiredValid })
                props.certfRemExpiredDue = Qt.binding(function() { return MachineData.certificationExpired })
                //                console.log("nilai certif " + props.certfRemExpired)
                props.certfRemExpiredCount = Qt.binding(function(){ return MachineData.certificationExpiredCount})

                ///
                props.cabinetDisplayName = Qt.binding(function(){ return MachineData.cabinetDisplayName})

                ///
                props.fanPIN = Qt.binding(function() { return MachineData.fanPIN })

                props.airflowMonitorEnable = Qt.binding(function(){return MachineData.airflowMonitorEnable})

                props.alarmSashMotorDownStuck = Qt.binding(function(){ return MachineData.alarmSashMotorDownStuck === MachineAPI.ALARM_ACTIVE_STATE })

                props.tempAmbientHighStrf =  Qt.binding(function(){ return "%1°%2".arg(MachineData.envTempHighestLimit).arg(MachineData.measurementUnit ? "F" : "C")})
                props.tempAmbientLowStrf =  Qt.binding(function(){ return "%1°%2".arg(MachineData.envTempLowestLimit).arg(MachineData.measurementUnit ? "F" : "C")})

                /// show dialog progress when fan state will be switching
                MachineData.fanSwithingStateTriggered.connect(props.showFanProgressSwitchingState)

                /// Power outage
                props.powerOutage = MachineData.powerOutage
                if(props.powerOutage && MachineData.getSbcCurrentSerialNumberKnown()) {
                    const powerOutageTime = MachineData.powerOutageTime
                    const powerOutageRecoverTime = MachineData.powerOutageRecoverTime

                    //force clear power outage variable
                    //avoid the dialog show again
                    MachineData.powerOutage = 0

                    /// SHOW DIALOG POWER OUTAGE NOTIFICATION
                    var messageFan = "<b>" +  qsTr("Power failure has been detected while previous fan state is on!") + "</b>" + "<br>"
                            +  qsTr("Potential release contamination into the room.") + "<br>"
                            +  qsTr("Failure at") + " " + powerOutageTime + "<br>"
                            +  qsTr("Recover at") + " " + powerOutageRecoverTime + "<br>"

                    var messageUV = "<b>" +  qsTr("Power failure has been detected while previous UV decontamination is in progress!") + "</b>" + "<br>"
                            +  qsTr("Failure at") + " " + powerOutageTime + "<br>"
                            +  qsTr("Recover at") + " " + powerOutageRecoverTime + "<br>"

                    const powerOutageFanOrUV = MachineData.powerOutageUvState
                    //                        //console.debug("powerOutageFanOrUV:" + powerOutageFanOrUV)
                    var message = powerOutageFanOrUV ? messageUV : messageFan

                    const autoClosed = false
                    viewApp.showDialogMessage(qsTr("Be Careful!"),
                                              message,
                                              viewApp.dialogAlert,
                                              function ignoreOnClosed(){},
                                              autoClosed,
                                              "qrc:/UI/Pictures/power-outage-icon.png")
                }

                if (UserSessionService.loggedIn){
                    props.loginUsername = UserSessionService.username
                    props.loginFullname = UserSessionService.fullname
                }
                else {
                    props.loginUsername = qsTr("Login")
                    props.loginFullname = qsTr("Login")
                }

                timeDateTimer.restart()
            }//

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");

                /// THIS PAGE IS INVISIBLE,
                /// TO PREVENT UNWANTED BEHAVIOUR, DISCONNECT THE SIGNAL
                MachineData.fanSwithingStateTriggered.disconnect(props.showFanProgressSwitchingState)

                //                    props.currentPageIsForground = false
            }

            /// PUT ANY DYNAMIC OBJECT MUST A WARE TO PAGE STATUS
            /// ANY OBJECT ON HERE WILL BE DESTROYED WHEN THIS PAGE NOT IN FOREGROUND
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#c0c0c0";formeditorZoom:1.1;height:600;width:1024}
}
##^##*/
