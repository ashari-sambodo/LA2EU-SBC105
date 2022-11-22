import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Logout Time"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        /// just for development
        /// comment following line after release
        visible: true

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
                    title: qsTr("Logout Time")
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
                                text: qsTr("Current") + ":"
                            }//

                            TextApp{
                                id: currentValueText
                                font.pixelSize: 36
                                wrapMode: Text.WordWrap
                                font.bold: true
                                text: utilsApp.strfSecsToHumanReadableShort(props.logoutTime)
                                states: [
                                    State {
                                        when: props.logoutTime == 0
                                        PropertyChanges {
                                            target: currentValueText
                                            text: qsTr("Disable")
                                        }
                                    }
                                ]

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        //                                        if(UserSessionService.roleLevel > UserSessionService.roleLevelOperator)
                                        fragmentStackView.push(configureComponent)
                                        //                                        else{
                                        //                                            showDialogMessage(qsTr("Access Denied"),
                                        //                                                              qsTr("You do not have permission to perform this action!"),
                                        //                                                              dialogAlert)
                                        //                                        }
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
                                text:  qsTr("You will be automatically logged out if there is no activity on the screen for a logout time") + "."
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

                                        let minutes = minutesTumbler.currentIndex;
                                        let seconds = secondsTumbler.currentIndex;
                                        props.requestTime = (minutes * 60) + seconds
                                    }
                                    Column{
                                        id: column
                                        spacing: 5
                                        TextApp {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            font.pixelSize: fontMetrics.font.pixelSize
                                            text: qsTr("MM:SS")
                                        }
                                        Row {
                                            id: row

                                            Tumbler {
                                                id: minutesTumbler
                                                model: 30
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
                                                id: secondsTumbler
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
                                    props.requestTime = props.logoutTime//0

                                    let minutes = props.logoutTime / 60
                                    let seconds =  props.logoutTime % 60

                                    minutesTumbler.currentIndex = minutes
                                    secondsTumbler.currentIndex = seconds

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
                Layout.minimumHeight: 70

                BackgroundButtonBarApp {
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
                                if(props.requestTime < 60 && props.requestTime != 0){
                                    showDialogMessage(qsTr("Logout Time"),
                                                      qsTr("Logout time is invalid!") + "<br>"
                                                      + qsTr("The minimum setting is 1 minute or set to 0 to disable the logout time."),
                                                      dialogAlert)
                                    return
                                }
                                console.debug("Logout Time", props.logoutTime)
                                console.debug("Request Time", props.requestTime)

                                if(props.requestTime == props.logoutTime){
                                    setButton.visible = false
                                    fragmentStackView.pop()
                                    return
                                }//

                                MachineAPI.setLogoutTime(props.requestTime)

                                MachineAPI.insertEventLog(qsTr("User: Set logout time to '%1'").arg(utilsApp.strfSecsToHumanReadableShort(props.requestTime)))

                                viewApp.showBusyPage(qsTr("Setting up..."),
                                                     function onCycle(cycle){
                                                         if (cycle >= MachineAPI.BUSY_CYCLE_1
                                                                 || MachineData.logoutTime == props.requestTime) {
                                                             fragmentStackView.pop()
                                                             viewApp.dialogObject.close()
                                                         }//
                                                     })

                            }//
                        }//
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int requestTime: 0
            property int logoutTime : 0
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                props.logoutTime = Qt.binding(function(){return MachineData.logoutTime})
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

//        MultiPointTouchArea {
//            anchors.fill: parent

//            touchPoints: [
//                TouchPoint {id: point1},
//                TouchPoint {id: point2},
//                TouchPoint {id: point3},
//                TouchPoint {id: point4},
//                TouchPoint {id: point5}
//            ]
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "red"
//            visible: point1.pressed
//            x: point1.x - (width / 2)
//            y: point1.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "green"
//            visible: point2.pressed
//            x: point2.x - (width / 2)
//            y: point2.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "blue"
//            visible: point3.pressed
//            x: point3.x - (width / 2)
//            y: point3.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "yellow"
//            visible: point4.pressed
//            x: point4.x - (width / 2)
//            y: point4.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "cyan"
//            visible: point5.pressed
//            x: point5.x - (width / 2)
//            y: point5.y - (height / 2)
//        }//

//        Column {
//            id: counter
//            anchors.centerIn: parent

//            TextApp {
//                anchors.horizontalCenter: parent.horizontalCenter
//                text: props.count
//                font.pixelSize: 48

//                TapHandler {
//                    onTapped: {
//                        props.count = props.countDefault
//                        counterTimer.restart()
//                    }//
//                }//
//            }//

//            TextApp {
//                font.pixelSize: 14
//                text: "Press number\nto count!"
//            }//
//        }//

//        Timer {
//            id: counterTimer
//            interval: 1000; repeat: true
//            onTriggered: {
//                let count = props.count
//                if (count <= 0) {
//                    counterTimer.stop()
//                }//
//                else {
//                    count = count - 1
//                    props.count = count
//                }//
//            }//
//        }//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/
