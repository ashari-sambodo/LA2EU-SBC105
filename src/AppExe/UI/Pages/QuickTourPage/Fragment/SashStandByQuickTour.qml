import QtQuick 2.14
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0

import ModulesCpp.Machine 1.0
Item {
    id: control
    signal finished()

    property bool autoPlay: false

    Loader {
        id:animationGifSecondLoader
        anchors.fill: parent
        anchors.margins: 10
        active: true


        sourceComponent:AnimatedImage {
            id: homepageGifErrorAirflow
            anchors.fill: parent

            cache: false

            source: "qrc:/Assets/QuickTourGIF/QuickTourStandby.gif"/*"qrc:/UI/Pages/QuickTourPage/QuickTourGIF/QuickTourStandby.gif"*/

            property bool autoPlay: control.autoPlay
            onAutoPlayChanged: {
                homepageGifErrorAirflow.playing = true
            }

            onPlayingChanged: {
                if (homepageGifErrorAirflow.playing == false) {

                    if (autoPlay == true){
                        control.finished()
                    }
                }
            }//

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    animationGifSecondLoader.active = false
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
