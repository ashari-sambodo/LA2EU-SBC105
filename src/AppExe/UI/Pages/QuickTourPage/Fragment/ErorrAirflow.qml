import QtQuick 2.14
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1

import ModulesCpp.Machine 1.0
Item {
    id: control
    signal finished()

    property bool autoPlay: false

    Loader {
        id:animationGifLoader
        anchors.fill: parent
        anchors.margins: 10
        active: true

        sourceComponent:AnimatedImage {
            id: homepageGif
            anchors.fill: parent
            //playing: true

            cache: false

            property bool autoPlay: control.autoPlay

            onAutoPlayChanged: {
                homepageGif.playing = true
            }

            source: "qrc:/Assets/QuickTourGIF/HomepageErrorAirflow.gif"

            onPlayingChanged: {
                if (homepageGif.playing == false) { 
                    if(autoPlay == true){
                        control.finished()
                    }
                }//
            }//

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    animationGifLoader.active = false
                    control.finished()
                }//
            }//
        }//
    }//

    PageIndicator {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        interactive: true
        //currentIndex: props.pageIndicator
        count: 1
    }
}//
