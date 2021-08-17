import QtQuick 2.14
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0

import ModulesCpp.Machine 1.0
Item {
    id: control
    signal finished()

    Loader {
        id:animationGifSecondLoader
        anchors.fill: parent
        anchors.margins: 10
        active: true


        sourceComponent:AnimatedImage {
            id: homepageGifErrorAirflow
            anchors.fill: parent

            cache: false

            source: "qrc:/Assets/QuickTourGIF/HomepageErrorUnsafe.gif"

            //            onPlayingChanged: {
            //                if (homepageGifErrorAirflow.playing == false) {
            //                    animationGifSecondLoader.active = false
            //                    //animationImageLoader.active = true
            //                }
            //            }//
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
