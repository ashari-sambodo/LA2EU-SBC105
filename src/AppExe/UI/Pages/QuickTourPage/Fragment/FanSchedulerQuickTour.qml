import QtQuick 2.14
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1

import ModulesCpp.Machine 1.0

Item {
    id: control
    signal finished()
    signal goBack()

    property bool autoPlay: false

    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Image{
                source: "qrc:/Assets/background-qtour.png"
                anchors.centerIn: parent
                Item {
                    height: 380
                    width: 649
                    anchors.centerIn: parent
                    Loader {
                        id: animationImageLoaderSection
                        anchors.fill: parent
                        //anchors.margins: 10
                        active: true

                        sourceComponent:Image {
                            id: imageSquenceSection
                            source: screenColection[indexScreen]

                            cache: false

                            property int indexScreen: props.indexing
                            property var screenColection: [
                                "qrc:/Assets/QuickTourHomepage/homepage_00.png",
                                "qrc:/Assets/QuickTourHomepage/homepage_11.png",
                                "qrc:/Assets/QuickTourFanScheduler/fan-schedule_00.png",
                                "qrc:/Assets/QuickTourFanScheduler/fan-schedule_01.png",
                                "qrc:/Assets/QuickTourFanScheduler/fan-schedule_02.png",
                                "qrc:/Assets/QuickTourFanScheduler/fan-schedule_03.png",
                                "qrc:/Assets/QuickTourFanScheduler/fan-schedule_04.png",

                                "qrc:/Assets/QuickTourUvScheduler/uv-schedule_05.png",
                                "qrc:/Assets/QuickTourUvScheduler/uv-schedule_06.png",

                                "qrc:/Assets/QuickTourFanScheduler/fan-schedule_05.png",
                                "qrc:/Assets/QuickTourUvScheduler/uv-schedule_08.png",

                                "qrc:/Assets/QuickTourFanScheduler/fan-schedule_06.png",
                                "qrc:/Assets/QuickTourFanScheduler/fan-schedule_07.png",
                            ]//

                            Timer {
                                id: screenTimerSection
                                running: autoPlay && props.timerRunning
                                interval: 3000
                                repeat: true
                                onTriggered: {
                                    let indexing = imageSquenceSection.indexScreen
                                    let maxValue = imageSquenceSection.screenColection.length
                                    indexing = indexing + 1
                                    if (indexing === maxValue){
                                        screenTimerSection.running = false

                                        control.finished()
                                        //animationImageLoaderModbusSection.active = true
                                    }else{
                                        props.pageIndicator = indexing
                                        //imageSquenceSection.indexScreen = indexing

                                        props.indexing = indexing
                                    }//

                                    console.log("timer:" + screenTimerSection.running)
                                }//
                            }//

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {

                                    let indexing = imageSquenceSection.indexScreen

                                    let maxValue = imageSquenceSection.screenColection.length

                                    if (indexing < maxValue - 1){
                                        //screenTimerSection.restart()

                                        indexing = indexing + 1

                                        props.pageIndicator = indexing

                                        props.indexing = indexing

                                        //omepageimageSquenceSection.indexScreen = indexing
                                    }
                                    else {
                                        screenTimerSection.running = false
                                        control.finished()
                                        //animationImageLoaderModbusSection.active = true
                                    }
                                }//
                            }//
                            Component.onCompleted: props.screenCollectionCount = imageSquenceSection.screenColection.length
                        }//
                    }//
                }
            }
        }//

        Item {
            Layout.minimumHeight: 20
            Layout.fillWidth: true

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                //anchors.bottom: parent.bottom
                spacing: 3

                Rectangle {
                    //anchors.right: parent.right
                    width: 25
                    height: 20
                    color: "transparent"

                    Image {
                        id:bacwardArrow
                        anchors.fill: parent
                        source: "qrc:/UI/Pictures/backward.png"
                        opacity: clickBack.pressed ? 0.5 : 1
                    }

                    MouseArea {
                        id:clickBack
                        anchors.fill: parent

                        onClicked: {
                            if(props.indexing >= 1){
                                props.indexing = props.indexing - 1
                                props.pageIndicator = props.indexing
                            }
                            else {
                                if(control.autoPlay){
                                    props.timerRunning = false
                                    control.goBack()
                                }
                            }
                        }//
                    }//
                }//

                PageIndicator {
                    id: pageSectionIndicator
                    //anchors.verticalCenter: parent.verticalCenter
                    //anchors.horizontalCenter: parent.horizontalCenter
                    //anchors.bottom: parent.bottom
                    interactive: false
                    currentIndex: props.pageIndicator
                    count: props.screenCollectionCount
                }//

                Rectangle {
                    //anchors.left: parent.left
                    width: 25
                    height: 20
                    color: "transparent"

                    Image {
                        anchors.fill: parent
                        source: "qrc:/UI/Pictures/forward.png"
                        opacity: forwardArrow.pressed ? 0.5 : 1
                    }

                    MouseArea {
                        id:forwardArrow
                        anchors.fill: parent

                        onClicked: {
                            if (props.indexing < pageSectionIndicator.count - 1){
                                props.indexing = props.indexing + 1
                                props.pageIndicator = props.indexing
                            }
                            else {
                                if(control.autoPlay){
                                    props.timerRunning = false
                                    control.finished()
                                }else return
                            }
                        }//
                    }//
                }//
            }//
        }//
    }//

    QtObject {
        id: props
        property int pageIndicator: 0

        property int indexing: 0
        property bool timerRunning: true
        property int screenCollectionCount: 0
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
