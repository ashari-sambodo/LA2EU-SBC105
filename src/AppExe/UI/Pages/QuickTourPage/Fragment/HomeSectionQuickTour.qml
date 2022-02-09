import QtQuick 2.14
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1

import ModulesCpp.Machine 1.0
Item {
    id: control
    signal finished()

    property bool autoPlay

    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Loader {
                id:animationGifLoader
                anchors.fill: parent
                anchors.margins: 10

                sourceComponent:AnimatedImage {
                    id: homepageGif
                    anchors.fill: parent

                    cache: false

                    source: "qrc:/Assets/QuickTourGIF/HomePage.gif"

                    property int indexgif: 1

                    onPlayingChanged: {
                        if (homepageGif.playing == false) {
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

            Loader {
                id: animationImageLoader
                anchors.fill: parent
                anchors.margins: 10
                active: false

                sourceComponent:Image {
                    id: homepageImageSquence
                    source: screenColection[indexScreen]

                    cache: false

                    property int indexScreen: props.indexing
                    property var screenColection: [
                        "qrc:/Assets/QuickTourHomepage/HomeFirst.png",
                        "qrc:/Assets/QuickTourHomepage/HomeSecond.png",
                        "qrc:/Assets/QuickTourHomepage/HomeFirst.png",
                        "qrc:/Assets/QuickTourHomepage/HomeThird.png",
                        "qrc:/Assets/QuickTourHomepage/HomeFirst.png",
                        "qrc:/Assets/QuickTourHomepage/HomeFourth.png",
                        "qrc:/Assets/QuickTourHomepage/HomeFourth_1.png",
                        "qrc:/Assets/QuickTourHomepage/HomeFirst.png",
                        "qrc:/Assets/QuickTourHomepage/HomeFourth_LampButton_dim.png",
                        "qrc:/Assets/QuickTourHomepage/HomeFourth_silder100.png",
                        "qrc:/Assets/QuickTourHomepage/HomeFourth_slider65.png",
                        "qrc:/Assets/QuickTourHomepage/HomeFourth_lamp65.png",
                        "qrc:/Assets/QuickTourHomepage/HomeFourth_v2.png",
                        "qrc:/Assets/QuickTourHomepage/HomeFifth.png",
                        "qrc:/Assets/QuickTourHomepage/HomeSixth.png",
                        "qrc:/Assets/QuickTourHomepage/HomeFifth.png",
                        "qrc:/Assets/QuickTourHomepage/HomeSeventh.png"
                    ]

                    Timer {
                        id: screenTimer
                        running: autoPlay
                        interval: 3000
                        repeat: true
                        onTriggered: {


                            props.indexing = homepageImageSquence.indexScreen

                            props.maxIndex = homepageImageSquence.screenColection.length


                            let indexing = homepageImageSquence.indexScreen
                            indexing = indexing + 1

                            props.pageIndicator = props.pageIndicatorGif + indexing -1

                            console.log("timerpr: " + props.pageIndicator)

                            props.indexing = indexing

                            let maxValue = homepageImageSquence.screenColection.length

                            if (indexing === maxValue){
                                screenTimer.running = false

                                control.finished()

                                props.pageIndicator = maxValue

                            }
                            console.log("timer:" + screenTimer.running)
                            console.log("checkboxAutoPlay:" + autoPlay)
                        }//
                    }//

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {


                            let indexing = homepageImageSquence.indexScreen

                            let maxValue = homepageImageSquence.screenColection.length

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
                }//
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
                    id: pageLoginSectionIndicator
                    //anchors.verticalCenter: parent.verticalCenter
                    //anchors.horizontalCenter: parent.horizontalCenter
                    //anchors.bottom: parent.bottom
                    interactive: true
                    currentIndex: props.pageIndicator
                    count: 17
                }//

                Rectangle {
                    //anchors.left: parent.left
                    width: 25
                    height: 20
                    color: "transparent"

                    Image {
                        anchors.fill: parent
                        source: "qrc:/UI/Pictures/forward.png"
                    }

                    MouseArea {
                        id:forwardArrow
                        anchors.fill: parent

                        onClicked: {

                            if (props.indexing < pageLoginSectionIndicator.count - 1){
                                props.indexing = props.indexing + 1
                                props.pageIndicator = props.indexing
                            }
                            else {
                                return
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

    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.25;height:480;width:640}
}
##^##*/
