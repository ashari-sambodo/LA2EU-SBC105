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
                        id: animationGifLoader
                        anchors.fill: parent
                        //anchors.margins: 10

                        sourceComponent:AnimatedImage {
                            id: animationGif
                            anchors.fill: parent
                            playing: props.playing

                            cache: false

                            source: screenColection[indexScreen]

                            property bool autoPlay: control.autoPlay
                            onAutoPlayChanged: {
                                props.playing = true
                            }
                            property int indexScreen: props.indexing
                            property var screenColection: [
                                "qrc:/Assets/QuickTourGIF/HomepageErrorAirflow.gif"
                            ]

                            onCurrentFrameChanged: {
                                if(animationGif.currentFrame == (animationGif.frameCount-1) && control.autoPlay){
                                    if (props.indexing < pageSectionIndicator.count -1) {
                                        let index = props.indexing
                                        index = index + 1

                                        props.indexing = index
                                        props.pageIndicator = props.indexing

                                        props.playing = true
                                    }//
                                    else{
                                        console.debug(props.indexing, props.screenCollectionCount)
                                        props.playing = false
                                    }
                                }//
                            }//
                            onPlayingChanged: {
                                if (props.playing == false && !props.isGoBack) {

                                    let index = animationGif.indexScreen
                                    index = index + 1

                                    if (autoPlay == true) {
                                        if (index == screenColection.length) {
                                            control.finished()
                                            return
                                        }//
                                        else{
                                            props.indexing = index
                                            props.playing = true
                                        }
                                    }

                                    props.pageIndicator = props.indexing
                                    //                            if (props.indexing == screenColection.length) {
                                    //                                control.finished()
                                    //                            }//
                                }//
                            }//

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    console.debug(props.indexing, props.screenCollectionCount)
                                    if (props.indexing == props.screenCollectionCount-1) {
                                        props.playing = false
                                    }//
                                    else{
                                        let index = animationGif.indexScreen
                                        index = index + 1

                                        props.indexing = index
                                        props.playing = true
                                        props.pageIndicator = props.indexing
                                    }
                                }//
                            }//
                            Component.onCompleted: {
                                props.screenCollectionCount = animationGif.screenColection.length
                                console.debug("Screen collection:", props.screenCollectionCount)
                            }
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
                            if (props.indexing > 0) {

                                let index = props.indexing
                                index = index - 1

                                props.indexing = index
                                props.pageIndicator = props.indexing

                                props.playing = true
                            }//
                            else{
                                if(control.autoPlay){
                                    props.isGoBack = true
                                    props.playing = false
                                    control.goBack()
                                }//
                            }//
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
                            //                            if(animationGifLoader.active){
                            //                                animationGifLoader.active = false
                            //                                props.pageIndicatorGif = 1
                            //                            }else{
                            if (props.indexing < pageSectionIndicator.count - 1){
                                props.indexing = props.indexing + 1
                                props.pageIndicator = props.indexing
                            }
                            else {
                                if(control.autoPlay){
                                    animationGifLoader.active = false
                                    control.finished()
                                }
                            }
                            //                            }
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
        property bool playing: true
        property int screenCollectionCount: 0
        property bool isGoBack: false

    }//
}//
