import QtQuick 2.4
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Experiment Timer"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 5

            /// HEADER
            Item {
                id: headerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 60

                HeaderApp {
                    anchors.fill: parent
                    title: qsTr("Experiment Timer")
                }//
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        StackView {
                            id: fragmentStackView
                            anchors.fill: parent
                            clip: true
                        }//

                        Component {
                            id: progressFragmentComp

                            Item {

                                property string idname: "progress"

                                Loader {
                                    id: loaderItem
                                    anchors.centerIn: parent
                                    asynchronous: true
                                    visible: status == Loader.Ready
                                    onVisibleChanged: {
                                        if (visible) loaderItem.item.requestPaint()
                                    }
                                    sourceComponent: CircularProgressBarApp {
                                        id: progressBar
                                        showBackground: true
                                        colorBackground: "#dddddd"
                                        colorCircle: "#c0392b"
                                        size: 300

                                        arcEnd: 360/100 * (100 - value)
                                        property real value: 100 - utils.getPercentOf(props.timerCount, props.timerCountTotal)

                                        Column {
                                            anchors.centerIn: parent
                                            spacing: 5

                                            TextApp {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                width: progressBar.width - progressBar.lineWidth - 30
                                                horizontalAlignment: Text.AlignHCenter
                                                text: qsTr("countdown")
                                            }

                                            TextApp {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                font.pixelSize: 52
                                                width: progressBar.width - progressBar.lineWidth - 30
                                                horizontalAlignment: Text.AlignHCenter
                                                //                                    text: "00:00:00"
                                                text: utils.strfSecsToAdaptiveHHMMSS(props.timerCount);
                                            }

                                            TextApp {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                width: progressBar.width - progressBar.lineWidth - 50
                                                horizontalAlignment: Text.AlignHCenter
                                                fontSizeMode: Text.Fit
                                                text: qsTr("Total") + " " + utils.strfSecsToHumanReadable(props.timerCountTotal)
                                            }

                                            TextApp {
                                                id: pauseFlagText
                                                visible: props.timerStatus == ExperimentTimerService.statusPause
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                font.bold: true
                                                font.pixelSize: 32
                                                width: progressBar.width - progressBar.lineWidth - 30
                                                horizontalAlignment: Text.AlignHCenter
                                                color: "#CC3333"
                                                //                                    text: "00:00:00"
                                                text: "||"

                                                SequentialAnimation {
                                                    running: props.timerStatus == ExperimentTimerService.statusPause
                                                    loops: Animation.Infinite

                                                    ScriptAction{
                                                        script: {
                                                            pauseFlagText.opacity = 0
                                                        }
                                                    }

                                                    PauseAnimation {
                                                        duration: 1000
                                                    }

                                                    ScriptAction{
                                                        script: {
                                                            pauseFlagText.opacity = 1
                                                        }
                                                    }

                                                    PauseAnimation {
                                                        duration: 1000
                                                    }
                                                }//
                                            }//
                                        }//
                                    }//

                                    UtilsApp {
                                        id: utils
                                    }//
                                }//

                                BusyIndicatorApp {
                                    anchors.centerIn: parent
                                    visible: loaderItem.status == Loader.Loading
                                }
                            }//
                        }//

                        Component {
                            id: setTimerFragmentComp

                            Item {
                                id: setTimerFragmentItem
                                property string idname: "settimer"

                                property int secondsInitial: 0

                                Loader {
                                    id: loaderItem
                                    anchors.centerIn: parent
                                    asynchronous: true
                                    visible: status == Loader.Ready
                                    sourceComponent: TimerTumblerApp {
                                        id: timerTumbler

                                        onSecondsChanged: {
                                            props.timerCountTotal = seconds
                                        }//

                                        Component.onCompleted: {
                                            init(setTimerFragmentItem.secondsInitial)
                                        }
                                    }//
                                }//

                                BusyIndicatorApp {
                                    anchors.centerIn: parent
                                    visible: loaderItem.status == Loader.Loading
                                }//
                            }//
                        }//
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Row {
                            anchors.centerIn: parent
                            spacing: 5

                            Rectangle {
                                visible: props.timerStatus
                                height: 75
                                width: 150
                                radius: 10
                                //                                color: "#2ecc71"
                                color: "#1f95d7"
                                border.color: "#34495e"
                                border.width: 3
                                opacity: stopMouseArea.pressed ? 0.5 : 1

                                Image {
                                    source: "qrc:/UI/Pictures/playcontrol/stop.png"
                                    anchors.centerIn: parent
                                    fillMode: Image.PreserveAspectFit
                                }//

                                MouseArea {
                                    id: stopMouseArea
                                    anchors.fill: parent
                                    onClicked: {
                                        //                                        props.timerStopped = true
                                        //                                        props.timerRunning = false
                                        ExperimentTimerService.stop()
                                    }//
                                }//
                            }//

                            Rectangle {
                                visible: (props.timerStatus == ExperimentTimerService.statusStop)
                                         || (props.timerStatus == ExperimentTimerService.statusPause)
                                height: 75
                                width: 150
                                radius: 10
                                color: "#1f95d7"
                                border.color: "#34495e"
                                border.width: 3
                                opacity: playMouseArea.pressed ? 0.5 : 1

                                Image {
                                    source: "qrc:/UI/Pictures/playcontrol/play.png"
                                    anchors.centerIn: parent
                                    fillMode: Image.PreserveAspectFit
                                }

                                MouseArea {
                                    id: playMouseArea
                                    anchors.fill: parent
                                    onClicked: {
                                        if (props.timerCountTotal <= 0) return

                                        if (fragmentStackView.currentItem.idname === "progress") {
                                            if (props.timerStatus == ExperimentTimerService.statusStop){
                                                let count = props.timerCountTotal
                                                ExperimentTimerService.timeout = false
                                                fragmentStackView.replace(setTimerFragmentComp, {"secondsInitial": count})
                                            }//
                                            if (props.timerStatus == ExperimentTimerService.statusPause){
                                                ExperimentTimerService.start()
                                            }
                                        }
                                        else {
                                            if (props.timerStatus == ExperimentTimerService.statusStop){
                                                ExperimentTimerService.countTotal = props.timerCountTotal
                                                fragmentStackView.replace(progressFragmentComp)
                                            }//
                                            ExperimentTimerService.start()
                                        }//
                                    }//
                                }//
                            }//

                            Rectangle {
                                visible: props.timerStatus == 1
                                height: 75
                                width: 150
                                radius: 10
                                color: "#1f95d7"
                                border.color: "#34495e"
                                border.width: 3
                                opacity: pauseMouseArea.pressed ? 0.5 : 1

                                Image {
                                    source: "qrc:/UI/Pictures/playcontrol/pause.png"
                                    anchors.centerIn: parent
                                    fillMode: Image.PreserveAspectFit
                                }

                                MouseArea {
                                    id: pauseMouseArea
                                    anchors.fill: parent
                                    onClicked: {
                                        //                                        props.timerStopped = false
                                        //                                        props.timerRunning = false
                                        ExperimentTimerService.pause()
                                    }//
                                }//
                            }//
                        }//
                    }//
                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: MachineAPI.FOOTER_HEIGHT

                Rectangle {
                    anchors.fill: parent
                    color: "#0F2952"
                    //                    border.color: "#e3dac9"
                    //                    border.width: 1
                    radius: 5

                    Item {
                        anchors.fill: parent
                        anchors.margins: 5

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }
                        }//
                    }//
                }//
            }//
        }//

        //// Put all private property inside here
        //// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int timerCountTotal: 0
            property int timerCount: 0
            property int timerStatus: 0

        }//

        /// Called once time after on resume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

                props.timerCountTotal = ExperimentTimerService.countTotal
                props.timerCount = Qt.binding(function(){ return ExperimentTimerService.count })
                props.timerStatus = Qt.binding( function() { return ExperimentTimerService.status })

                if (props.timerStatus !== ExperimentTimerService.statusStop) {
                    fragmentStackView.replace(progressFragmentComp)
                }
                else {
                    fragmentStackView.replace(setTimerFragmentComp)
                }
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";formeditorZoom:0.75;height:480;width:800}
}
##^##*/
