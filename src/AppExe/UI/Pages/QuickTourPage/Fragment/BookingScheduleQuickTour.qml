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
                        "qrc:/Assets/QuickTourEventLog/eventLog1.png",
                        "qrc:/Assets/QuickTourEventLog/eventlog2.png",
                        "qrc:/Assets/QuickTourBookingSchedule/BookingMenu.png",
                        "qrc:/Assets/QuickTourBookingSchedule/Boooking1.png",
                        "qrc:/Assets/QuickTourBookingSchedule/Boooking2.png",
                        "qrc:/Assets/QuickTourBookingSchedule/Boooking3.png",
                        "qrc:/Assets/QuickTourBookingSchedule/Boooking1.png",
                        "qrc:/Assets/QuickTourBookingSchedule/Boooking4.png",
                        "qrc:/Assets/QuickTourBookingSchedule/Boooking5.png",
                        "qrc:/Assets/QuickTourBookingSchedule/Boooking6.png",
                        "qrc:/Assets/QuickTourBookingSchedule/Booking7.png",
                        "qrc:/Assets/QuickTourBookingSchedule/Boooking8.png",
                        "qrc:/Assets/QuickTourBookingSchedule/Boooking9.png",
                        "qrc:/Assets/QuickTourBookingSchedule/Boooking10.png",
                        "qrc:/Assets/QuickTourBookingSchedule/Boooking11.png",
                        "qrc:/Assets/QuickTourBookingSchedule/Boooking12.png",
                        "qrc:/Assets/QuickTourBookingSchedule/Boooking13.png",
                        "qrc:/Assets/QuickTourBookingSchedule/Boooking13_1.png",
                        "qrc:/Assets/QuickTourBookingSchedule/Boooking14.png",
                        "qrc:/Assets/QuickTourBookingSchedule/Boooking14_1.png",
                        "qrc:/Assets/QuickTourBookingSchedule/Boooking15.png",
                        "qrc:/Assets/QuickTourBookingSchedule/Boooking16.png",
                        "qrc:/Assets/QuickTourBookingSchedule/Boooking17.png",
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
                    count: 25
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
