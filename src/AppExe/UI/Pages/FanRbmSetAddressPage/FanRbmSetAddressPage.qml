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
    title: "FAN RBM Address"

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
                    title: qsTr("FAN RBM Address")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column{
                    anchors.centerIn: parent
                    spacing: 10
                    Column {
                        spacing: 5

                        TextApp {
                            text: qsTr("RBM Downflow Address")
                        }//

                        TextFieldApp {
                            id: dfaFanRbmAddrsTextField
                            width: 110
                            height: 40
                            //anchors.horizontalCenter: parent.horizontalCenter

                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, qsTr("RBM Downflow Address (1-254)"))
                            }//
                            onAccepted: {
                                props.dfaFanRbmAddress = Number(text)
                            }
                        }//
                    }//
                    Column {
                        spacing: 5

                        TextApp {
                            text: qsTr("RBM Inflow Address")
                        }//

                        TextFieldApp {
                            id: ifaFanRbmAddrsTextField
                            width: 110
                            height: 40
                            //anchors.horizontalCenter: parent.horizontalCenter

                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, qsTr("RBM Inflow Address (1-254)"))
                            }//
                            onAccepted: {
                                props.ifaFanRbmAddress = Number(text)
                            }
                        }//
                    }//
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
                        showBusyPage(qsTr("Setting up..."), function(seconds){
                            if(seconds === 1)
                                MachineAPI.setFanPrimaryRbmAddress(props.dfaFanRbmAddress)
                            else if(seconds === 2)
                                MachineAPI.setFanInflowRbmAddress(props.ifaFanRbmAddress)
                            else{
                                props.dfaParamChanged = false
                                props.ifaParamChanged = false
                                closeDialog();
                            }
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
            property int dfaFanRbmAddress: 0
            property int ifaFanRbmAddress: 0

            property bool dfaParamChanged: false
            property bool ifaParamChanged: false

            onDfaFanRbmAddressChanged: {
                if(dfaFanRbmAddress !== MachineData.getFanPrimaryRbmAddress())
                    dfaParamChanged = true
                else dfaParamChanged = false
            }
            onIfaFanRbmAddressChanged: {
                if(ifaFanRbmAddress !== MachineData.getFanInflowRbmAddress())
                    ifaParamChanged = true
                else ifaParamChanged = false
            }

        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                props.dfaFanRbmAddress = MachineData.getFanPrimaryRbmAddress()
                props.ifaFanRbmAddress = MachineData.getFanInflowRbmAddress()
                dfaFanRbmAddrsTextField.text = props.dfaFanRbmAddress
                ifaFanRbmAddrsTextField.text = props.ifaFanRbmAddress
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
