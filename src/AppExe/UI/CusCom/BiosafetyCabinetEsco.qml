import QtQuick 2.0

Item {

    property alias sashItem: sashImage

    Image {
        id: cabinetBaseImage
        source: "BiosafetyCabinetEsco/pictures/BSC3Dbase.png"
        height: parent.height
        width: parent.width
    }

    Image {
        id: frameImage
        source: "BiosafetyCabinetEsco/pictures/BSC3D_blackframe_la.png"
        height: parent.height
        width: parent.width
    }

    Image {
        id: headerImage
        source: "BiosafetyCabinetEsco/pictures/BSC3Dstatusok.png"
        height: parent.height
        width: parent.width
        visible: false
    }

    Image {
        id: downflowImage
        source: "BiosafetyCabinetEsco/pictures/BSC3D_arrow_df_blue.png"
        height: parent.height
        width: parent.width
        visible: false
    }

    Image {
        id: inflowImage
        source: "BiosafetyCabinetEsco/pictures/BSC3D_arrow_if_green_elbow.png"
        height: parent.height
        width: parent.width
        visible: false
    }

    Image {
        id: sashImage
        source: "BiosafetyCabinetEsco/pictures/BSC3D_sash_safe.png"
        height: parent.height
        width: parent.width

        readonly property string stateNone: "STATE_NONE"
        readonly property string stateA:    "STATE_A"
        readonly property string stateB:    "STATE_B"
        readonly property string stateC:    "STATE_C"
        readonly property string stateD:    "STATE_D"
        readonly property string stateE:    "STATE_E"

        states: [
            State {
                name: sashImage.stateA
                PropertyChanges {
                    target: sashImage
                    source: "BiosafetyCabinetEsco/pictures/BSC3D_sash_safe.png"
                }
            },
            State {
                name: sashImage.stateB
                PropertyChanges {
                    target: sashImage
                    source: "BiosafetyCabinetEsco/pictures/BSC3D_sash_unsafe.png"
                }
            },
            State {
                name: sashImage.stateC
                PropertyChanges {
                    target: sashImage
                    source: "BiosafetyCabinetEsco/pictures/BSC3D_sash_standby.png"
                }
            },
            State {
                name: sashImage.stateD
                PropertyChanges {
                    target: sashImage
                    source: "BiosafetyCabinetEsco/pictures/BSC3D_sash_fc.png"
                }
            },
            State {
                name: sashImage.stateE
                PropertyChanges {
                    target: sashImage
                    source: "BiosafetyCabinetEsco/pictures/BSC3D_sash_fo.png"
                }
            }
        ]
    }

    SequentialAnimation{
        id: airflowAnimation
        loops: Animation.Infinite
        running: false

        PropertyAction{
            target: inflowImage
            property: "source"
            value: "BiosafetyCabinetEsco/pictures/BSC3D_arrow_if_green.png"
        }

        NumberAnimation{
            target: inflowImage
            property: "x"
            from: 50
            to: 0
            duration: 500
        }

        PropertyAction{
            target: inflowImage
            property: "source"
            value: "BiosafetyCabinetEsco/pictures/BSC3D_arrow_if_green_elbow.png"
        }

        NumberAnimation{
            target: downflowImage
            properties: "y"
            from: -15
            to: 0
            duration: 500
        }

        //        ScriptAction {
        //            script: {
        //                console.log("Hello World")
        //            }
        //        }

        PauseAnimation {
            duration: 3000
        }
    }

    readonly property string stateNone: "STATE_NONE"
    readonly property string stateA:    "STATE_A"
    readonly property string stateB:    "STATE_B"

    states: [
        State {
            name: stateA
            PropertyChanges {
                target: downflowImage
                visible: true
            }
            PropertyChanges {
                target: inflowImage
                visible: true
            }
            PropertyChanges {
                target: airflowAnimation
                running: true
            }
            PropertyChanges {
                target: headerImage
                visible: true
                source: "BiosafetyCabinetEsco/pictures/BSC3Dstatusok.png"
            }
        },
        State {
            name: stateB
            PropertyChanges {
                target: downflowImage
                visible: true
            }
            PropertyChanges {
                target: inflowImage
                visible: true
            }
            PropertyChanges {
                target: airflowAnimation
                running: true
            }
            PropertyChanges {
                target: headerImage
                visible: true
                source: "BiosafetyCabinetEsco/pictures/BSC3Dstatuswarning.png"
            }
        }
    ]
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:400}
}
##^##*/
