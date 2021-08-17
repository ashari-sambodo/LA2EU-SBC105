import QtQuick 2.14
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0

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
                active: true

                sourceComponent:AnimatedImage {
                    id: homepageGif
                    anchors.fill: parent

                    cache: false

                    source: screenColection[indexScreen]

                    property bool autoPlay: control.autoPlay
                    onAutoPlayChanged: {
                        homepageGif.playing = true
                    }

                    property int indexScreen: props.indexing
                    property var screenColection: [

                        "qrc:/Assets/QuickTourGestureNav/GestureNavigationButtom.gif",
                        "qrc:/Assets/QuickTourGestureNav/GestureNavigationLeft.gif",
                        "qrc:/Assets/QuickTourGestureNav/GestureNavigationRight.gif",
                        "qrc:/Assets/QuickTourGestureNav/GestureNavigationUp.gif"
                    ]

                    onPlayingChanged: {
                        if (homepageGif.playing == false) {

                            let index = homepageGif.indexScreen
                            index = index + 1

                            if (autoPlay == true) {
                                props.indexing = index
                                homepageGif.playing = true
                            }

                            props.pageIndicator = props.indexing

                            if (props.indexing == 4) {
                                control.finished()
                            }//
                        }//
                    }//

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            let index = homepageGif.indexScreen
                            index = index + 1

                            props.indexing = index

                            homepageGif.playing = true

                            props.pageIndicator = props.indexing

                            if (props.indexing == 4) {
                                control.finished()
                            }//
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
                            if (props.indexing > 0) {

                                let index = props.indexing
                                index = index - 1

                                props.indexing = index
                                props.pageIndicator = props.indexing

                                homepageGif.playing = true
                            }//
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
                    count: 4
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

                            if (props.indexing < pageLoginSectionIndicator.count -1) {

                                let index = props.indexing
                                index = index + 1

                                props.indexing = index
                                props.pageIndicator = props.indexing

                                homepageGif.playing = true
                            }//
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

        //rproperty int maxIndex: value

    }//
}//
