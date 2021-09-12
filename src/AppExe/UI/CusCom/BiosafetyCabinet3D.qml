/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0

Item {

    property alias  cabinetBaseItem: cabinetBaseImage
    property alias  sashImageItem: sashImage
    property alias  headerImageItem: headerImage
    property alias  frameModeSource: frameImage.source
    property alias  frameVisible: frameImage.visible
    property bool   airflowArrowActive:  false

    property string modelName : "LA2"
    readonly property string frameModeSourceA: "BiosafetyCabinet3D/pictures/BSC3D_blackframe_la.png"
    readonly property string frameModeSourceB: "BiosafetyCabinet3D/pictures/BSC3D_blackframe_ac.png"
    readonly property string frameModeSourceC: "BiosafetyCabinet3D/pictures/BSC3D_blackframe_sc.png"

    Image {
        id: cabinetBaseImage
        source: "BiosafetyCabinet3D/pictures/BSC3Dbase.png"
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit

        readonly property string stateNone:         "STATE_NONE"
        readonly property string stateAlarm:        "STATE_A"
        readonly property string stateWarn:         "STATE_B"

        states: [
            State {
                name: cabinetBaseImage.stateAlarm
                PropertyChanges {
                    target: cabinetBaseImage
                    source: "BiosafetyCabinet3D/pictures/BSC3Dbase-red.png"
                }
            },
            State {
                name: cabinetBaseImage.stateWarn
                PropertyChanges {
                    target: cabinetBaseImage
                    source: "BiosafetyCabinet3D/pictures/BSC3Dbase-orange.png"
                }
            }
        ]
    }//

    Image {
        id: frameImage
        source: frameModeSourceA
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        visible: true

        states: [
            State {
                when: modelName === "LA2" || modelName === "LA2 EU"
                PropertyChanges {
                    target: frameImage
                    source: frameModeSourceA
                }
            },
            State {
                when: modelName === "AC2"
                PropertyChanges {
                    target: frameImage
                    source: frameModeSourceB
                }
            },
            State {
                when: modelName === "SC2"
                PropertyChanges {
                    target: frameImage
                    source: frameModeSourceC
                }
            }
        ]
    }//

    Image {
        id: headerImage
        source: "BiosafetyCabinet3D/pictures/BSC3Dstatusok.png"
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        visible: false
    }//

    Item {
        id: airflowArrowItem
        anchors.fill: parent
        visible: airflowArrowActive

        Image {
            id: downflowImage
            source: "BiosafetyCabinet3D/pictures/BSC3D_arrow_df_blue.png"
            height: parent.height
            width: parent.width
            fillMode: Image.PreserveAspectFit
        }//

        Image {
            id: inflowImage
            source: "BiosafetyCabinet3D/pictures/BSC3D_arrow_if_green_elbow.png"
            height: parent.height
            width: parent.width
            fillMode: Image.PreserveAspectFit
        }//
    }//

    Image {
        id: sashImage
        source: "BiosafetyCabinet3D/pictures/BSC3D_sash_fo.png"
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit

        readonly property string stateNone:         "STATE_NONE"
        readonly property string stateSafe:         "STATE_A"
        readonly property string stateUnsafe:       "STATE_B"
        readonly property string stateStandby:      "STATE_C"
        readonly property string stateFullyClose:   "STATE_D"
        readonly property string stateFullyOpen:    "STATE_E"
        readonly property string stateUvActive:     "STATE_F"

        states: [
            State {
                name: sashImage.stateSafe
                PropertyChanges {
                    target: sashImage
                    source: "BiosafetyCabinet3D/pictures/BSC3D_sash_safe.png"
                }
            },
            State {
                name: sashImage.stateUnsafe
                PropertyChanges {
                    target: sashImage
                    source: "BiosafetyCabinet3D/pictures/BSC3D_sash_unsafe.png"
                }
            },
            State {
                name: sashImage.stateStandby
                PropertyChanges {
                    target: sashImage
                    source: "BiosafetyCabinet3D/pictures/BSC3D_sash_standby.png"
                }
            },
            State {
                name: sashImage.stateFullyClose
                PropertyChanges {
                    target: sashImage
                    source: "BiosafetyCabinet3D/pictures/BSC3D_sash_fc.png"
                }
            },
            State {
                name: sashImage.stateFullyOpen
                PropertyChanges {
                    target: sashImage
                    source: "BiosafetyCabinet3D/pictures/BSC3D_sash_fo.png"
                }
            },
            State {
                name: sashImage.stateUvActive
                PropertyChanges {
                    target: sashImage
                    source: "BiosafetyCabinet3D/pictures/BSC3D_sash_uvon.png"
                }
            }
        ]
    }//

    SequentialAnimation{
        id: airflowAnimation
        loops: Animation.Infinite
        running: airflowArrowActive

        PropertyAction{
            target: inflowImage
            property: "source"
            value: "BiosafetyCabinet3D/pictures/BSC3D_arrow_if_green.png"
        }//

        NumberAnimation{
            target: inflowImage
            property: "x"
            from: 50
            to: 0
            duration: 500
        }//

        PropertyAction{
            target: inflowImage
            property: "source"
            value: "BiosafetyCabinet3D/pictures/BSC3D_arrow_if_green_elbow.png"
        }//

        NumberAnimation{
            target: downflowImage
            properties: "y"
            from: -15
            to: 0
            duration: 500
        }//

        ScriptAction {
            script: {
                //console.debug("Arrow animation is running")
            }//
        }//

        PauseAnimation {
            duration: 5000
        }//
    }//

    //    readonly property string stateNone: "STATE_NONE"
    //    readonly property string stateA:    "STATE_A"
    //    readonly property string stateB:    "STATE_B"

    //    states: [
    //        State {
    //            name: stateA
    //            PropertyChanges {
    //                target: downflowImage
    //                visible: true
    //            }
    //            PropertyChanges {
    //                target: inflowImage
    //                visible: true
    //            }
    //            PropertyChanges {
    //                target: airflowAnimation
    //                running: true
    //            }
    //            PropertyChanges {
    //                target: headerImage
    //                visible: true
    //                source: "BiosafetyCabinet3D/pictures/BSC3Dstatusok.png"
    //            }
    //        },
    //        State {
    //            name: stateB
    //            PropertyChanges {
    //                target: downflowImage
    //                visible: true
    //            }
    //            PropertyChanges {
    //                target: inflowImage
    //                visible: true
    //            }
    //            PropertyChanges {
    //                target: airflowAnimation
    //                running: true
    //            }
    //            PropertyChanges {
    //                target: headerImage
    //                visible: true
    //                source: "BiosafetyCabinet3D/pictures/BSC3Dstatuswarning.png"
    //            }
    //        }
    //    ]
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:400}
}
##^##*/
