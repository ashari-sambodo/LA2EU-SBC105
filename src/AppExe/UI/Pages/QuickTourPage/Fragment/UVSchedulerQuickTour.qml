import QtQuick 2.14
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1

import ModulesCpp.Machine 1.0

Item {
    id: control
    signal finished()

    property bool autoPlay: false

    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Loader {
                id: animationImageLoaderLoginSection
                anchors.fill: parent
                anchors.margins: 10
                active: true

                sourceComponent:Image {
                    id: homepageImageSquenceLoginSection
                    source: screenColection[indexScreen]

                    cache: false


                    property int indexScreen: props.indexing
                    property var screenColection: [
                        "qrc:/Assets/QuickTourHomepage/HomeFirst.png",
                        "qrc:/Assets/QuickTourHomepage/HomeEnd.png",
                        "qrc:/Assets/QuickTourUvScheduler/UvScheduler_1.png",
                        "qrc:/Assets/QuickTourUvScheduler/UvScheduler_2.png",
                        "qrc:/Assets/QuickTourUvScheduler/UvScheduler_3.png",
                        "qrc:/Assets/QuickTourUvScheduler/UvScheduler_4.png",
                        "qrc:/Assets/QuickTourUvScheduler/UvScheduler_5.png",
                        "qrc:/Assets/QuickTourUvScheduler/UvScheduler_6.png",
                        "qrc:/Assets/QuickTourUvScheduler/UvScheduler_7.png",
                        "qrc:/Assets/QuickTourUvScheduler/UvScheduler_8.png",
                        "qrc:/Assets/QuickTourUvScheduler/UvScheduler_9.png",
                        "qrc:/Assets/QuickTourUvScheduler/UvScheduler_10.png",
                        "qrc:/Assets/QuickTourUvScheduler/UvScheduler_11.png",
                        "qrc:/Assets/QuickTourUvScheduler/UvScheduler_12.png",
                        "qrc:/Assets/QuickTourUvScheduler/UvScheduler_14.png",
                        "qrc:/Assets/QuickTourUvScheduler/UvScheduler_13.png",
                        "qrc:/Assets/QuickTourUvScheduler/UvScheduler_15.png",
                        "qrc:/Assets/QuickTourUvScheduler/UvScheduler_16.png",
                        "qrc:/Assets/QuickTourUvScheduler/UvScheduler_17.png",
                        "qrc:/Assets/QuickTourUvScheduler/UvScheduler_18.png",
                        "qrc:/Assets/QuickTourUvScheduler/UvScheduler_19.png"
                    ]

                    Timer {
                        id: screenTimerLoginSection
                        running: autoPlay
                        //interval: 3000
                        interval: 3000
                        repeat: true
                        onTriggered: {
                            let indexing = homepageImageSquenceLoginSection.indexScreen
                            indexing = indexing + 1

                            props.pageIndicator = indexing

                            //homepageImageSquenceLoginSection.indexScreen = indexing
                            props.indexing = indexing

                            let maxValue = homepageImageSquenceLoginSection.screenColection.length

                            if (indexing === maxValue){
                                screenTimerLoginSection.running = false
                                //animationImageLoaderNetworkSection.active = true

                                props.pageIndicator = maxValue

                                control.finished()

                            }
                            //                            console.log("timer:" + screenTimerLoginSection.running)
                        }//
                    }//

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {

                            let indexing = homepageImageSquenceLoginSection.indexScreen

                            let maxValue = homepageImageSquenceLoginSection.screenColection.length

                            if (indexing < maxValue - 1){

                                indexing = indexing + 1

                                props.pageIndicator = indexing


                                props.indexing = indexing
                            }
                            else {
                                screenTimerLoginSection.running = false

                                control.finished()
                                //animationImageLoaderNetworkSection.active = true

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
                    count: 21
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
        property int pageIndicator: 0

        property int indexing: 0
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
