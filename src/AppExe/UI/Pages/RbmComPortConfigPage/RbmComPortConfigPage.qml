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

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "RBM Com Port"

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
                    title: qsTr("RBM Com Port")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                RowLayout{
                    anchors.fill: parent
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Column{
                            anchors.centerIn: parent
                            spacing: 10
                            TextApp{
                                text: qsTr("Downflow Fan Port:")
                            }
                            Rectangle{
                                width: 190
                                height: 50
                                color: "transparent"
                                TextApp{
                                    width: parent.width
                                    height: parent.height
                                    text: MachineData.rbmComPortDfa
                                    font.bold: true
                                    //verticalAlignment: Text.AlignVCenter
                                }
                            }
                            TextApp{
                                text: qsTr("Configure Port:")
                            }
                            ComboBoxApp {
                                id: comboBox1
                                width: 190
                                height: 50
                                backgroundColor: "#0F2952"
                                backgroundBorderColor: "#dddddd"
                                backgroundBorderWidth: 2
                                font.pixelSize: 20
                                //anchors.horizontalCenter: parent.horizontalCenter
                                textRole: "text"

                                onActivated: {
                                    console.debug(model[index].text)
                                    props.rbmComPortDfa = model[index].text
                                }//

                                Component.onCompleted: {
                                    model = Qt.binding(function(){return props.modelList})
                                }//
                            }//
                        }//
                    }//
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Column{
                            anchors.centerIn: parent
                            spacing: 10
                            TextApp{
                                text: qsTr("Inflow Fan Port:")
                            }
                            Rectangle{
                                width: 190
                                height: 50
                                color: "transparent"
                                TextApp{
                                    width: parent.width
                                    height: parent.height
                                    font.bold: true
                                    text: MachineData.rbmComPortIfa
                                    //verticalAlignment: Text.AlignVCenter
                                }
                            }
                            TextApp{
                                text: qsTr("Configure Port:")
                            }
                            ComboBoxApp {
                                id: comboBox2
                                width: 190
                                height: 50
                                backgroundColor: "#0F2952"
                                backgroundBorderColor: "#dddddd"
                                backgroundBorderWidth: 2
                                font.pixelSize: 20
                                anchors.horizontalCenter: parent.horizontalCenter
                                textRole: "text"

                                onActivated: {
                                    console.debug(model[index].text)
                                    props.rbmComPortIfa = model[index].text
                                }

                                Component.onCompleted: {
                                    model = Qt.binding(function(){return props.modelList})
                                }
                            }//
                        }//
                    }//
                }//
                TextApp {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text:  "*" + qsTr("New configuration will be applied after system restart") + "."
                           + "<br>"
                           + qsTr("The system will be restarted after you click the 'Save' button") + "."
                    color: "#cccccc"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
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
                    }//
                }//

                ButtonBarApp {
                    id: setButton
                    width: 194
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    visible: false

                    imageSource: "qrc:/UI/Pictures/checkicon.png"
                    text: qsTr("Save")

                    onClicked: {
                        viewApp.showBusyPage(qsTr("Setting up..."), function(seconds){
                            if(props.dfaParamChanged)
                                MachineAPI.setRbmComPortDfa(props.rbmComPortDfa)
                            if(props.ifaParamChanged)
                                MachineAPI.setRbmComPortIfa(props.rbmComPortIfa)
                            if (seconds === 3) {
                                const intent = IntentApp.create("qrc:/UI/Pages/ClosingPage/ClosingPage.qml", {})
                                startRootView(intent)
                            }//
                        })//
                    }//
                    Component.onCompleted: visible = Qt.binding(function(){return (props.dfaParamChanged || props.ifaParamChanged)})
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props
            property string rbmComPortDfa: ""
            property string rbmComPortIfa: ""

            property var modelList: [{text: "USB0"}, {text: "USB1"}]

            property bool dfaParamChanged: false
            property bool ifaParamChanged: false
        }//

        /// One time executed after onResume
        Component.onCompleted: {
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                ////console.debug("StackView.Active");
                MachineAPI.scanRbmComPortAvalaible(true)

                props.rbmComPortDfa = MachineData.rbmComPortDfa
                props.rbmComPortIfa = MachineData.rbmComPortIfa

                props.dfaParamChanged = Qt.binding(function(){return props.rbmComPortDfa !== MachineData.rbmComPortDfa})
                props.ifaParamChanged = Qt.binding(function(){return props.rbmComPortIfa !== MachineData.rbmComPortIfa})
                props.modelList = Qt.binding(function(){
                    var availableStr = MachineData.rbmComPortAvailable
                    var lengthList = availableStr.split("#").length
                    var availableList = []
                    for(let i=0; i<lengthList; i++){
                        let str = availableStr.split("#")[i]
                        availableList.push({text: str})
                        //console.debug(i, str)
                    }//
                    return availableList
                })//
                //console.debug(props.modelList)
            }//

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
                MachineAPI.scanRbmComPortAvalaible(false)
            }
        }//
    }//
}//


/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/
