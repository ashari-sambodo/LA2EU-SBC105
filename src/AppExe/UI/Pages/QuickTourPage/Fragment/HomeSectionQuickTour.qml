import QtQuick 2.14
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1

import ModulesCpp.Machine 1.0
Item {
    id: control
    signal finished()
    signal goBack()

    property bool autoPlay

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
                        id:animationGifLoader
                        anchors.fill: parent
                        //anchors.margins: 10

                        sourceComponent:AnimatedImage {
                            id: animationGif
                            anchors.fill: parent

                            cache: false

                            source: "qrc:/Assets/QuickTourGIF/HomePage.gif"

                            property int indexgif: 1

                            onPlayingChanged: {
                                if (animationGif.playing == false) {
                                    animationGifLoader.active = false
                                    animationImageLoader.active = true

                                    props.pageIndicatorGif = indexgif
                                }
                            }//

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    animationGifLoader.active = false
                                    animationImageLoader.active = true

                                    props.pageIndicatorGif = indexgif
                                }//
                            }//
                        }//
                    }//
                }
                Item {
                    height: 380
                    width: 649
                    anchors.centerIn: parent
                    Loader {
                        id: animationImageLoader
                        anchors.fill: parent
                        //anchors.margins: 10
                        active: false

                        sourceComponent:Image {
                            id: imageSquence
                            source: screenColection[indexScreen]

                            cache: false

                            property int indexScreen: props.indexing
                            property var screenColection: [
                                "qrc:/Assets/QuickTourHomepage/homepage_00.png",
                                "qrc:/Assets/QuickTourHomepage/homepage_01.png",
                                "qrc:/Assets/QuickTourHomepage/homepage_02.png",
                                "qrc:/Assets/QuickTourHomepage/homepage_03.png",
                                "qrc:/Assets/QuickTourHomepage/homepage_04.png",
                                "qrc:/Assets/QuickTourHomepage/homepage_05.png",
                                "qrc:/Assets/QuickTourHomepage/homepage_06.png",
                                "qrc:/Assets/QuickTourHomepage/homepage_07.png",
                                "qrc:/Assets/QuickTourHomepage/homepage_08.png",
                                "qrc:/Assets/QuickTourHomepage/homepage_09.png",
                                "qrc:/Assets/QuickTourHomepage/homepage_09_1.png",
                                "qrc:/Assets/QuickTourHomepage/homepage_10.png",
                            ]//

                            Timer {
                                id: screenTimer
                                running: autoPlay && props.timerRunning
                                interval: 3000
                                repeat: true
                                onTriggered: {
                                    props.indexing = imageSquence.indexScreen

                                    props.maxIndex = imageSquence.screenColection.length


                                    let indexing = imageSquence.indexScreen
                                    indexing = indexing + 1

                                    props.pageIndicator = props.pageIndicatorGif + indexing -1

                                    console.log("timerpr: " + props.pageIndicator)

                                    props.indexing = indexing

                                    let maxValue = imageSquence.screenColection.length

                                    if (indexing === maxValue){
                                        screenTimer.running = false
                                        props.pageIndicator = maxValue
                                        control.finished()
                                    }
                                    console.log("timer:" + screenTimer.running)
                                    console.log("checkboxAutoPlay:" + autoPlay)
                                }//
                            }//

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    let indexing = imageSquence.indexScreen

                                    let maxValue = imageSquence.screenColection.length

                                    if (indexing < maxValue - 1){
                                        //screenTimer.restart()
                                        indexing = indexing + 1
                                        props.pageIndicator = props.pageIndicatorGif + indexing - 1

                                        console.log("mouse: " + props.pageIndicator)

                                        props.indexing = indexing
                                    }
                                    else {
                                        screenTimer.running = false
                                        //animationImageLoaderLoginSection.active = true
                                        control.finished()
                                    }
                                }//
                            }//
                            Component.onCompleted: props.screenCollectionCount = imageSquence.screenColection.length
                        }//
                    }//
                }
            }//
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
                                return
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
                            if(animationGifLoader.active){
                                animationGifLoader.active = false
                                animationImageLoader.active = true
                                props.pageIndicatorGif = 1
                            }else{
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
                            }
                        }//
                    }//
                }//
            }//
        }//
    }//

    QtObject {
        id: props

        property int pageIndicatorGif: 0

        property int pageIndicator: 0

        property int indexing: 0

        property int maxIndex: 0
        property int screenCollectionCount: 0
        property bool timerRunning: true

    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.25;height:480;width:640}
}
##^##*/
