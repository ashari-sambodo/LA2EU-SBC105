/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Ahmad Qodri
**/

import QtQuick 2.4
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "UV Timer"

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
                    id: headerApp
                    anchors.fill: parent
                    title: qsTr("UV Timer")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                /// fragment container
                StackView {
                    id: fragmentStackView
                    anchors.fill: parent
                    initialItem: currentValueComponent/*configureComponent*/
                }//

                /// fragment-1
                Component {
                    id: currentValueComponent

                    Item{
                        Column {
                            id: currentValueColumn
                            spacing: 5
                            anchors.centerIn: parent

                            TextApp{
                                text: qsTr("Current timer") + ":"
                            }//

                            TextApp{
                                id: currentValueText
                                font.pixelSize: 36
                                wrapMode: Text.WordWrap
                                font.bold: true
                                text: utilsApp.strfSecsToHumanReadableShort(props.uvTime * 60)
                                states: [
                                    State {
                                        when: props.uvTime == 0
                                        PropertyChanges {
                                            target: currentValueText
                                            text: qsTr("Infinite")
                                        }
                                    }
                                ]

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        fragmentStackView.push(configureComponent)
                                    }//
                                }//
                            }//

                            TextApp{
                                text: qsTr("Tap to change")
                                color: "#cccccc"
                                font.pixelSize: 18
                            }//


                        }//

                        Row {
                            spacing: 2
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            TextApp{
                                text: "*"
                                color: "#cccccc"
                            }//

                            TextApp{
                                text:  qsTr("The timer will limit the time of UV Lamp on when it is turned on by a user") + "."
                                       + "<br>"
                                       + qsTr("The UV lamp will turn off automatically after the timer has finished") + "."
                                color: "#cccccc"
                                font.pixelSize: 16
                                horizontalAlignment: Text.AlignHCenter
                            }//
                        }//
                    }

                }//

                /// fragment-2
                Component {
                    id: configureComponent

                    Item {
                        id: configureItem

                        Loader {
                            id: configureLoader
                            anchors.fill: parent
                            asynchronous: true
                            visible: status == Loader.Ready
                            sourceComponent: Item {
                                id: container

                                function formatText(count, modelData) {
                                    var data = count === 12 ? modelData + 1 : modelData;
                                    return data.toString().length < 2 ? "0" + data : data;
                                }//

                                FontMetrics {
                                    id: fontMetrics
                                    font.pixelSize: 20
                                }//

                                Component {
                                    id: delegateComponent

                                    Label {
                                        text: container.formatText(Tumbler.tumbler.count, modelData)
                                        opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font.pixelSize: fontMetrics.font.pixelSize * 1.25
                                        font.bold: Tumbler.tumbler.currentIndex == index
                                        color: "#DDDDDD"
                                    }//
                                }//

                                Frame {
                                    id: frame
                                    padding: 10
                                    anchors.centerIn: parent

                                    background: Rectangle {
                                        color: "#0F2952"
                                        radius: 5
                                        border.color: "#DDDDDD"
                                    }//

                                    function generateTime(){
                                        ////console.debug("generateTime")

                                        let hour = hoursTumbler.currentIndex;
                                        let minutes = minutesTumbler.currentIndex;
                                        props.requestTime = (hour * 60) + minutes

                                        ////console.debug("the time: " + theDateTimeStr)
                                    }
                                    Column{
                                        id: column
                                        spacing: 5
                                        TextApp {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            font.pixelSize: fontMetrics.font.pixelSize
                                            text: qsTr("HH:MM")
                                        }
                                        Row {
                                            id: row

                                            Tumbler {
                                                id: hoursTumbler
                                                model: 24
                                                delegate: delegateComponent
                                                width: 100

                                                onMovingChanged: {
                                                    if (!moving) {
                                                        frame.generateTime()
                                                    }//
                                                }//
                                            }//

                                            TextApp {
                                                anchors.verticalCenter: parent.verticalCenter
                                                font.pixelSize: fontMetrics.font.pixelSize
                                                text: ":"
                                            }

                                            Tumbler {
                                                id: minutesTumbler
                                                model: 60
                                                delegate: delegateComponent
                                                width: 100

                                                onMovingChanged: {
                                                    if (!moving) {
                                                        frame.generateTime()
                                                    }//
                                                }//
                                            }//
                                        }//
                                    }//
                                }//

                                Component.onCompleted: {
                                    props.requestTime = 0

                                    let hour = props.uvTime / 60
                                    let minutes =  props.uvTime % 60

                                    hoursTumbler.currentIndex = hour
                                    minutesTumbler.currentIndex = minutes

                                    setButton.visible = true
                                }//

                                Component.onDestruction: {
                                    setButton.visible = false
                                }//
                            }//
                        }//

                        BusyIndicatorApp {
                            visible: configureLoader.status === Loader.Loading
                            anchors.centerIn: parent
                        }//
                    }//
                }//

                UtilsApp {
                    id: utilsApp
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
                            id: backButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                if (fragmentStackView.depth > 1) {
                                    fragmentStackView.pop();
                                    return
                                }

                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }//
                        }//

                        ButtonBarApp {
                            id: setButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            /// only visible from second fragment, set options
                            visible: false

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Set")

                            onClicked: {
                                //                                props.uvTime = props.requestTime
                                //                                props.uvTimerStringUpdate()
                                //if(props.requestTime == 0) return

                                if(props.requestTime !== props.uvTime){
                                    MachineAPI.setUvTimeSave(props.requestTime)
                                    /// Disable UV Scheduler Off if UV Timer is Not Infinite
                                    if(props.requestTime > 0 && MachineData.uvAutoSetEnabledOff)
                                        MachineAPI.setUVAutoEnabledOff(false)
                                    viewApp.showBusyPage(qsTr("Setting up..."),
                                                         function onCycle(cycle){
                                                             if (cycle === MachineAPI.BUSY_CYCLE_1) {
                                                                 fragmentStackView.pop()
                                                                 viewApp.dialogObject.close()
                                                             }//
                                                         })
                                }//
                                else{
                                    setButton.visible = false
                                    fragmentStackView.pop()
                                }//
                            }//
                        }//
                    }//
                }//
            }//
        }//

        ////// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            /// hold value for new required time
            property int requestTime: 0
            property int uvTime : 0
            //            property string uvTimerString : ""

            //            function uvTimerStringUpdate(){
            //                let hour = Math.floor(props.uvTimer / 60)
            //                let minutes = Math.floor(props.uvTimer % 60)

            //                if(hour < 10) hour = "0" + hour
            //                if(minutes < 10) minutes = "0" + minutes

            //                props.uvTimerString = hour + ":" + minutes
            //            }

        }
        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                //                    props.uvTimerStringUpdate()
                props.uvTime = Qt.binding(function(){return MachineData.uvTime})
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
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
