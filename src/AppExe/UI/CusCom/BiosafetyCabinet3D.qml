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
    property bool sideGlass : false
    property string pictureFolder: HeaderAppService.darkMode ? "pictures_dark" : (sideGlass ? "pictures_sdglass" : "pictures")
    readonly property string frameModeSourceA: "BiosafetyCabinet3D/%1/BSC3D_blackframe_la.png".arg(pictureFolder)
    readonly property string frameModeSourceB: "BiosafetyCabinet3D/%1/BSC3D_blackframe_ac.png".arg(pictureFolder)
    readonly property string frameModeSourceC: "BiosafetyCabinet3D/%1/BSC3D_blackframe_sc.png".arg(pictureFolder)

    Image {
        id: cabinetBaseImage
        source: "BiosafetyCabinet3D/%1/BSC3Dbase.png".arg(pictureFolder)
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
                    source: "BiosafetyCabinet3D/%1/BSC3Dbase-red.png".arg(pictureFolder)
                }
            },
            State {
                name: cabinetBaseImage.stateWarn
                PropertyChanges {
                    target: cabinetBaseImage
                    source: "BiosafetyCabinet3D/%1/BSC3Dbase-orange.png".arg(pictureFolder)
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
        source: "BiosafetyCabinet3D/%1/BSC3Dstatusok.png".arg(pictureFolder)
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
            source: "BiosafetyCabinet3D/%1/BSC3D_arrow_df_green.png".arg(pictureFolder)
            height: parent.height
            width: parent.width
            fillMode: Image.PreserveAspectFit
        }//

        Image {
            id: inflowImage
            source: "BiosafetyCabinet3D/%1/BSC3D_arrow_if_green_elbow.png".arg(pictureFolder)
            height: parent.height
            width: parent.width
            fillMode: Image.PreserveAspectFit
        }//
    }//

    Image {
        id: sashImage
        source: "BiosafetyCabinet3D/%1/BSC3D_sash_fo.png".arg(pictureFolder)
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
                    source: "BiosafetyCabinet3D/%1/BSC3D_sash_safe.png".arg(pictureFolder)
                }
            },
            State {
                name: sashImage.stateUnsafe
                PropertyChanges {
                    target: sashImage
                    source: "BiosafetyCabinet3D/%1/BSC3D_sash_unsafe.png".arg(pictureFolder)
                }
            },
            State {
                name: sashImage.stateStandby
                PropertyChanges {
                    target: sashImage
                    source: "BiosafetyCabinet3D/%1/BSC3D_sash_standby.png".arg(pictureFolder)
                }
            },
            State {
                name: sashImage.stateFullyClose
                PropertyChanges {
                    target: sashImage
                    source: "BiosafetyCabinet3D/%1/BSC3D_sash_fc.png".arg(pictureFolder)
                }
            },
            State {
                name: sashImage.stateFullyOpen
                PropertyChanges {
                    target: sashImage
                    source: "BiosafetyCabinet3D/%1/BSC3D_sash_fo.png".arg(pictureFolder)
                }
            },
            State {
                name: sashImage.stateUvActive
                PropertyChanges {
                    target: sashImage
                    source: "BiosafetyCabinet3D/%1/BSC3D_sash_uvon.png".arg(pictureFolder)
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
            value: "BiosafetyCabinet3D/%1/BSC3D_arrow_if_green.png".arg(pictureFolder)
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
            value: "BiosafetyCabinet3D/%1/BSC3D_arrow_if_green_elbow.png".arg(pictureFolder)
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
    //                source: "BiosafetyCabinet3D/%1/BSC3Dstatusok.png".arg(pictureFolder)
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
    //                source: "BiosafetyCabinet3D/%1/BSC3Dstatuswarning.png".arg(pictureFolder)
    //            }
    //        }
    //    ]
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:400}
}
##^##*/
