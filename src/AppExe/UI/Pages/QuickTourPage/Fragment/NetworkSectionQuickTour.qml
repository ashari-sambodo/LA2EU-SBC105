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
                id: animationImageLoaderNetworkSection
                anchors.fill: parent
                anchors.margins: 10
                active: true

                sourceComponent:Image {
                    id: homepageImageSquenceNetworkSection
                    source: screenColection[indexScreen]

                    cache: false

                    property int indexScreen: props.indexing
                    property var screenColection: [
                        "qrc:/Assets/QuickTourHomepage/HomeFirst.png",
                        "qrc:/Assets/QuickTourHomepage/HomeFifth.png",
                        "qrc:/Assets/QuickTourHomepage/HomeSixth.png",
                        "qrc:/Assets/QuickTourHomepage/HomeSixth_1.png",
                        "qrc:/Assets/QuickTourWifi/Network.png",
                        "qrc:/Assets/QuickTourWifi/Network1.png",
                        "qrc:/Assets/QuickTourWifi/network2.png"
                    ]

                    Timer {
                        id: screenTimerNetworkSection
                        running: autoPlay
                        interval: 3000
                        repeat: true
                        onTriggered: {
                            let indexing = homepageImageSquenceNetworkSection.indexScreen
                            indexing = indexing + 1
                            props.pageIndicator = indexing
                            //homepageImageSquenceNetworkSection.indexScreen = indexing

                            props.indexing = indexing

                            let maxValue = homepageImageSquenceNetworkSection.screenColection.length

                            if (indexing === maxValue){
                                screenTimerNetworkSection.running = false

                                control.finished()
                                //animationImageLoaderModbusSection.active = true
                            }
                            console.log("timer:" + screenTimerNetworkSection.running)
                        }//
                    }//

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {

                            let indexing = homepageImageSquenceNetworkSection.indexScreen

                            let maxValue = homepageImageSquenceNetworkSection.screenColection.length

                            if (indexing < maxValue - 1){
                                //screenTimerNetworkSection.restart()

                                indexing = indexing + 1

                                props.pageIndicator = indexing

                                props.indexing = indexing

                                //omepageImageSquenceNetworkSection.indexScreen = indexing
                            }
                            else {
                                screenTimerNetworkSection.running = false
                                control.finished()
                                //animationImageLoaderModbusSection.active = true
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
                    id: pageLoginSectionIndicator
                    //anchors.verticalCenter: parent.verticalCenter
                    //anchors.horizontalCenter: parent.horizontalCenter
                    //anchors.bottom: parent.bottom
                    interactive: false
                    currentIndex: props.pageIndicator
                    count: 7
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
