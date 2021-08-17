import QtQuick 2.14
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
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
                id: animationImageLoaderEventlogSection
                anchors.fill: parent
                anchors.margins: 10
                active: true

                sourceComponent:Image {
                    id: homepageImageSquenceEventlogSection
                    source: screenColection[indexScreen]
                    cache: false

                    property int indexScreen: props.indexing
                    property var screenColection: [
                        "qrc:/Assets/QuickTourHomepage/HomeEnd.png",
                        "qrc:/Assets/QuickTourEventLog/eventLog1.png",
                        "qrc:/Assets/QuickTourEventLog/eventlog2.png",
                        "qrc:/Assets/QuickTourEventLog/eventlog3.png",
                        "qrc:/Assets/QuickTourEventLog/eventlog4.png",
                        "qrc:/Assets/QuickTourEventLog/eventlog5.png",
                        "qrc:/Assets/QuickTourEventLog/eventlog5_1.png",
                        "qrc:/Assets/QuickTourEventLog/eventlog5_1_1.png",
                        "qrc:/Assets/QuickTourEventLog/eventlog5_2.png",
                        "qrc:/Assets/QuickTourEventLog/eventlog5_3.png",
                        "qrc:/Assets/QuickTourEventLog/eventlog6.png",
                        "qrc:/Assets/QuickTourEventLog/eventlog7.png",
                        "qrc:/Assets/QuickTourEventLog/eventlog8.png",
                        "qrc:/Assets/QuickTourEventLog/eventlog7_1.png",
                        "qrc:/Assets/QuickTourEventLog/Frame7.png",
                        "qrc:/Assets/QuickTourEventLog/evenlog10.png",
                        "qrc:/Assets/QuickTourEventLog/eventLog7_2.png",
                        "qrc:/Assets/QuickTourEventLog/eventLog7_4.png",
                        "qrc:/Assets/QuickTourEventLog/eventLog7_5.png",
                        "qrc:/Assets/QuickTourEventLog/eventLog7_6.png",
                        "qrc:/Assets/QuickTourEventLog/eventlog7_7.png",
                        "qrc:/Assets/QuickTourEventLog/eventlog7_8.png",
                        "qrc:/Assets/QuickTourEventLog/eventlog7.png",
                        "qrc:/Assets/QuickTourEventLog/evenlog9.png",
                        "qrc:/Assets/QuickTourBluetooth/evenlgo9_1.png",
                        "qrc:/Assets/QuickTourBluetooth/eventlog9_2.png",
                        "qrc:/Assets/QuickTourBluetooth/eventlog9_3.png",
                        "qrc:/Assets/QuickTourBluetooth/eventlog9_4.png",
                        "qrc:/Assets/QuickTourBluetooth/eventlog9_5.png",
                        "qrc:/Assets/QuickTourBluetooth/eventlog9_6.png"
                    ]

                    Timer {
                        id: screenTimerEventlogSection
                        running: autoPlay
                        interval: 3000
                        repeat: true
                        onTriggered: {
                            let indexing = homepageImageSquenceEventlogSection.indexScreen
                            indexing = indexing + 1

                            props.pageIndicator = indexing
                            props.indexing = indexing

                            //                            homepageImageSquenceEventlogSection.indexScreen = indexing

                            let maxValue = homepageImageSquenceEventlogSection.screenColection.length

                            if (indexing === maxValue){
                                screenTimerEventlogSection.running = false

                                props.pageIndicator = maxValue

                                control.finished()

                            }
                            console.log("timer:" + screenTimerEventlogSection.running)
                        }//
                    }//

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {

                            let indexing = homepageImageSquenceEventlogSection.indexScreen

                            let maxValue = homepageImageSquenceEventlogSection.screenColection.length

                            if (indexing < maxValue - 1){
                                //screenTimerEventlogSection.restart()

                                indexing = indexing + 1
                                props.pageIndicator = indexing

                                props.indexing = indexing
                                //homepageImageSquenceEventlogSection.indexScreen = indexing
                            }
                            else {
                                screenTimerEventlogSection.running = false
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
                    count: 30
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
