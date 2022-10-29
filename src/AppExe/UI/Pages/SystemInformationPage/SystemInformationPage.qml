/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "System Information"

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
                    title: qsTr("System Information")
                }
            }

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
                        Loader{
                            active: props.compCompleted && Loader.Ready
                            anchors.fill: parent
                            sourceComponent: ColumnLayout{
                                anchors.fill: parent
                                Item{
                                    Layout.minimumHeight: 40
                                    Layout.fillWidth: true
                                    Rectangle{
                                        anchors.fill: parent
                                        color: "#0F2952"
                                        radius: 5
                                    }
                                    TextApp{
                                        height: parent.height
                                        width: parent.width
                                        text: qsTr("Current System")
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                                Item{
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    Rectangle{
                                        id: rect1
                                        anchors.fill: parent
                                        color:"#22000000"
                                    }
                                    ColumnLayout{
                                        anchors.fill: parent
                                        Item{
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            RowLayout{
                                                anchors.fill: parent
                                                Flickable {
                                                    id: flick1
                                                    Layout.fillHeight: true
                                                    Layout.fillWidth: true
                                                    contentWidth: col1.width
                                                    contentHeight: col1.height
                                                    clip: true

                                                    flickableDirection: Flickable.VerticalFlick

                                                    ScrollBar.vertical: verticalScrollBar1
                                                    Column {
                                                        id: col1
                                                        spacing: 2
                                                        width: flick1.width
                                                        Repeater{
                                                            model: props.modelLength1
                                                            Row{
                                                                width: flick1.width
                                                                TextApp{
                                                                    id: name1
                                                                    padding: 5
                                                                    //height: parent.height
                                                                    width: flick1.width * 0.3
                                                                    text: "---"
                                                                    wrapMode: Text.WordWrap
                                                                    font.capitalization: Font.Capitalize
                                                                }
                                                                TextApp{
                                                                    padding: 5
                                                                    text: ":"
                                                                }
                                                                TextApp{
                                                                    id: value1
                                                                    padding: 5
                                                                    width: flick1.width * 0.7
                                                                    text: "---"
                                                                    wrapMode: Text.WordWrap
                                                                }
                                                                Component.onCompleted:{
                                                                    let sysInfo = props.sbcCurSysInfo[index]
                                                                    let textSysInfo = String(typeof sysInfo !== 'undefined' ? sysInfo : "---:---")
                                                                    let text1 = textSysInfo.split(":")[0]
                                                                    let text2 = textSysInfo.split(":")[1]
                                                                    if(text2.charAt(0) === ' ')
                                                                    {
                                                                        text2 = text2.substring(1);
                                                                    }
                                                                    name1.text = text1
                                                                    value1.text = text2
                                                                    //console.debug(name1.text)
                                                                    //console.debug(value1.text)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                Rectangle{
                                                    visible: col1.height > parent.height
                                                    Layout.fillHeight: true
                                                    Layout.minimumWidth: 10
                                                    color: "transparent"
                                                    border.color: "#dddddd"
                                                    radius: 5

                                                    /// Horizontal ScrollBar
                                                    ScrollBar {
                                                        id: verticalScrollBar1
                                                        anchors.fill: parent
                                                        orientation: Qt.Horizontal
                                                        policy: ScrollBar.AlwaysOn

                                                        contentItem: Rectangle {
                                                            implicitWidth: 5
                                                            implicitHeight: 0
                                                            radius: width / 2
                                                            color: "#dddddd"
                                                        }//
                                                    }//
                                                }//
                                            }//
                                        }//
                                    }//
                                    Component.onCompleted: {

                                    }//
                                }//
                            }//
                        }//
                    }//
                    Rectangle{
                        Layout.fillHeight: true
                        Layout.minimumWidth: 1
                        color: "#e3dac9"
                    }
                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        visible: !MachineData.getSbcCurrentSerialNumberKnown()
                        Loader{
                            active: props.compCompleted && Loader.Ready
                            anchors.fill: parent
                            sourceComponent: ColumnLayout{
                                anchors.fill: parent
                                Item{
                                    Layout.minimumHeight: 40
                                    Layout.fillWidth: true
                                    Rectangle{
                                        anchors.fill: parent
                                        color: "#0F2952"
                                        radius: 5
                                    }
                                    TextApp{
                                        height: parent.height
                                        width: parent.width
                                        text: qsTr("Registered System")
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                                Item{
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    Rectangle{
                                        id: rect2
                                        anchors.fill: parent
                                        color:"#22000000"
                                    }
                                    ColumnLayout{
                                        anchors.fill: parent
                                        Item{
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            RowLayout{
                                                anchors.fill: parent
                                                Flickable {
                                                    id: flick2
                                                    Layout.fillHeight: true
                                                    Layout.fillWidth: true
                                                    contentWidth: col2.width
                                                    contentHeight: col2.height
                                                    clip: true

                                                    flickableDirection: Flickable.VerticalFlick

                                                    ScrollBar.vertical: verticalScrollBar2
                                                    Column {
                                                        id: col2
                                                        spacing: 2
                                                        width: flick2.width
                                                        Repeater{
                                                            model: props.modelLength2
                                                            Row{
                                                                spacing: 0
                                                                width: flick2.width
                                                                TextApp{
                                                                    id: name2
                                                                    padding: 5
                                                                    //height: parent.height
                                                                    width: flick2.width * 0.3
                                                                    text: "---"
                                                                    wrapMode: Text.WordWrap
                                                                    font.capitalization: Font.Capitalize
                                                                }

                                                                TextApp{
                                                                    text: ":"
                                                                }
                                                                TextApp{
                                                                    id: value2
                                                                    padding: 5
                                                                    width: flick2.width * 0.7
                                                                    text: "---"
                                                                    wrapMode: Text.WordWrap
                                                                }
                                                                Component.onCompleted:{
                                                                    var sysInfo = props.sbcSysInfo[index]
                                                                    var textSysInfo = String(typeof sysInfo !== 'undefined' ? sysInfo : "---:---")
                                                                    let text1 = textSysInfo.split(":")[0]
                                                                    let text2 = textSysInfo.split(":")[1]
                                                                    if(text2.charAt(0) === ' ')
                                                                    {
                                                                        text2 = text2.substring(1);
                                                                    }
                                                                    name2.text = text1
                                                                    value2.text = text2
                                                                    //console.debug(name2.text)
                                                                    //console.debug(value2.text)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                Rectangle{
                                                    visible: col2.height > parent.height
                                                    Layout.fillHeight: true
                                                    Layout.minimumWidth: 10
                                                    color: "transparent"
                                                    border.color: "#dddddd"
                                                    radius: 5

                                                    /// Horizontal ScrollBar
                                                    ScrollBar {
                                                        id: verticalScrollBar2
                                                        anchors.fill: parent
                                                        orientation: Qt.Horizontal
                                                        policy: ScrollBar.AlwaysOn

                                                        contentItem: Rectangle {
                                                            implicitWidth: 5
                                                            implicitHeight: 0
                                                            radius: width / 2
                                                            color: "#dddddd"
                                                        }//
                                                    }//
                                                }//
                                            }//
                                        }//
                                    }//
                                    Component.onCompleted: {

                                    }//
                                }//
                            }//
                        }
                    }//
                    //
                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 70

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

                        Row{
                            spacing: 5
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            ButtonBarApp {
                                visible: !configureButton.visible
                                width: 194
                                anchors.verticalCenter: parent.verticalCenter
                                //anchors.right: parent.right
                                imageSource: "qrc:/UI/Pictures/reset-save-60px.png"
                                text: qsTr("Export Configuration")

                                onClicked: {
                                    console.debug(Qt.application.name)
                                    let fileSource = "/home/root/.config/escolifesciences/%1.conf".arg(Qt.application.name)
                                    const intent = IntentApp.create("qrc:/UI/Pages/FileManagerUsbCopyPage/FileManagerUsbCopierPage.qml",
                                                                    {
                                                                        "sourceFilePath": fileSource,
                                                                        "dontRmFile": 1,
                                                                    });
                                    startView(intent);
                                }
                            }//
                            ButtonBarApp {
                                visible: !configureButton.visible
                                width: 194
                                anchors.verticalCenter: parent.verticalCenter
                                //anchors.right: parent.right
                                imageSource: "qrc:/UI/Pictures/reset-save-60px.png"
                                text: qsTr("Import Configuration")

                            onClicked: {
                                console.debug("this pressed")
                                const intent = IntentApp.create("qrc:/UI/Pages/SystemInformationPage/ChooseConfigFilePage.qml", {})
                                startView(intent)
                            }
                        }//
                        }

                        ButtonBarApp {
                            id: configureButton
                            visible: !MachineData.getSbcCurrentSerialNumberKnown()
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            imageSource: "qrc:/UI/Pictures/reset-save-60px.png"
                            text: qsTr("Configure")

                            onClicked: {
                                const message = qsTr("Configure the current system to be registered system?") + "<br>" +
                                              qsTr("The system will restart after this action!")
                                showDialogAsk(qsTr("Configure system"),
                                              message,
                                              dialogAlert,
                                              function onAccepted(){
                                                  MachineAPI.setCurrentSystemAsKnown(true);
                                                  showBusyPage(qsTr("Please wait"),
                                                               function onCallback(cycle){
                                                                   if(cycle >= MachineAPI.BUSY_CYCLE_2) {
                                                                       const intent = IntentApp.create("qrc:/UI/Pages/ClosingPage/ClosingPage.qml", {})
                                                                       startRootView(intent)
                                                                   }
                                                               })
                                              },
                                              undefined,
                                              undefined,
                                              undefined,
                                              10
                                              )//
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
            property bool compCompleted: false
            property var sbcSysInfo: []
            property var sbcCurSysInfo: []
            property int modelLength1: 0
            property int modelLength2: 0
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {
            /// onResume
            Component.onCompleted: {
                props.sbcSysInfo = MachineData.getSbcSystemInformation();
                props.sbcCurSysInfo = MachineData.getSbcCurrentSystemInformation();

                props.modelLength1 = props.sbcCurSysInfo.length
                props.modelLength2 = props.sbcSysInfo.length
                props.compCompleted = true

            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//


/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/
