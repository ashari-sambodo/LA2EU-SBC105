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
                id: animationImageLoaderModbusSection
                anchors.fill: parent
                anchors.margins: 10
                active: true

                sourceComponent:Image {
                    id: homepageImageSquenceModbusSection
                    source: screenColection[indexScreen]

                    cache: false


                    property int indexScreen: props.indexing
                    property var screenColection: [
                        "qrc:/Assets/QuickTourHomepage/HomeEnd.png",
                        "qrc:/Assets/QuickTourModbus/RemoteFirst.png",
                        "qrc:/Assets/QuickTourModbus/RemoteSecond.png",
                        "qrc:/Assets/QuickTourModbus/RemoteThird.png",
                        "qrc:/Assets/QuickTourModbus/Remote3_1.png",
                        "qrc:/Assets/QuickTourModbus/Remote3_2.png"
                    ]

                    Timer {
                        id: screenTimerModbusSection
                        running: autoPlay
                        interval: 3000
                        repeat: true
                        onTriggered: {
                            let indexing = homepageImageSquenceModbusSection.indexScreen
                            indexing = indexing + 1
                            props.pageIndicator = indexing
                            //homepageImageSquenceModbusSection.indexScreen = indexing
                            props.indexing = indexing
                            let maxValue = homepageImageSquenceModbusSection.screenColection.length

                            if (indexing === maxValue){
                                screenTimerModbusSection.running = false
                                props.pageIndicator = maxValue
                                control.finished()
                            }
                        }//
                    }//

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {

                            let indexing = homepageImageSquenceModbusSection.indexScreen

                            let maxValue = homepageImageSquenceModbusSection.screenColection.length

                            if (indexing < maxValue - 1){

                                indexing = indexing + 1

                                props.pageIndicator = indexing

                                props.indexing = indexing

                            }
                            else {
                                screenTimerModbusSection.running = false
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
                    count: 6
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
