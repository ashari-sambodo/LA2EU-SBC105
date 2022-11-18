/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Quick Setup"

    background.sourceComponent: Rectangle {
        color: "black"
        opacity: 0.3
    }

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

            //            /// HEADER
            //            Item {
            //                id: headerItem
            //                Layout.fillWidth: true
            //                Layout.minimumHeight: 60

            //                HeaderApp {
            //                    anchors.fill: parent
            //                    title: qsTr("Welcome")
            //                }
            //            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 10

                    TextApp {
                        Layout.alignment: Qt.AlignHCenter
                        text: qsTr("Thanks for choosing us!")
                    }

                    Image{
                        source: "qrc:/UI/Pictures/logo/esco_lifesciences_group_white_200_80.png"
                        fillMode: Image.PreserveAspectFit
                        Layout.fillWidth: true
                        Layout.maximumHeight: 70
                    }//

                    Image {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/UI/Pictures/microbiologist_team_bgfit.png"
                    }//

                    ButtonBarApp {
                        Layout.maximumWidth: 150
                        Layout.alignment: Qt.AlignHCenter

                        imageSource: "qrc:/UI/Pictures/checkicon.png"
                        text: qsTr("Setup")

                        onClicked: {
                            viewApp.finishViewReturned.connect(props.onReturnFromChildPage);
                            if (props.indexSetupPage == 0) props.indexSetupPage = props.indexSetupPage + 1
                            const url = props.setupPageCollections[props.indexSetupPage]["url"]
                            const intent = IntentApp.create(url, {"welcomesetup": 1})
                            startView(intent);
                        }//
                    }//
                }//
            }//

            //            /// FOOTER
            //            Item {
            //                id: footerItem
            //                Layout.fillWidth: true
            //                Layout.minimumHeight: 70

            //                Rectangle {
            //                    anchors.fill: parent
            //                    color: "#0F2952"
            //                    //                    border.color: "#e3dac9"
            //                    //                    border.width: 1
            //                    radius: 5

            //                    Item {
            //                        anchors.fill: parent
            //                        anchors.margins: 5

            //                        //                        ButtonBarApp {
            //                        //                            width: 194
            //                        //                            anchors.verticalCenter: parent.verticalCenter

            //                        //                            imageSource: "qrc:/UI/Pictures/back-step.png"
            //                        //                            text: qsTr("Back")

            //                        //                            onClicked: {
            //                        //                                var intent = IntentApp.create(uri, {"message":""})
            //                        //                                finishView(intent)
            //                        //                            }
            //                        //                        }//


            //                    }//
            //                }//
            //            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int indexSetupPage: 1

            readonly property var setupPageCollections: [
                {"url": "none"},
                {"url": "qrc:/UI/Pages/LanguagePage/LanguagePage.qml"},
                {"url": "qrc:/UI/Pages/DateSetPage/DateSetPage.qml"},
                {"url": "qrc:/UI/Pages/TimeSetPage/TimeSetPage.qml"},
                {"url": "qrc:/UI/Pages/TimeZonePage/TimeZonePage.qml"},
                {"url": "qrc:/UI/Pages/CabinetNameSetPage/CabinetNameSetPage.qml"},
                {"url": "qrc:/UI/Pages/FieldCalibratePage/FieldCalibratePage.qml"},
                {"url": "qrc:/UI/Pages/QuickTourPage/QuickTourPage.qml"},
            ]

            function onReturnFromChildPage(returnIntent){
                viewApp.finishViewReturned.disconnect(props.onReturnFromChildPage)
                console.log("returnIntent")

                const extraData = IntentApp.getExtraData(returnIntent)
                //                console.log(JSON.stringify(extraData))
                const skipped = extraData['skip'] || false
                const wcNext = extraData['welcomesetupdone'] || false
                //                console.log("wcNext: " + wcNext)
                if (wcNext || skipped) {
                    if(indexSetupPage == (props.setupPageCollections.length - 1) || skipped) {
                        const url = "qrc:/UI/Pages/InstallationWizardPage/InstallationWizardDonePage.qml"
                        const intent = IntentApp.create(url, {})
                        startRootView(intent);
                        return
                    }
                    //                    console.log("next")
                    indexSetupPage = indexSetupPage + 1
                    if(indexSetupPage >= props.setupPageCollections.length) {
                        indexSetupPage = 0
                    }
                    else if(indexSetupPage < props.setupPageCollections.length) {
                        viewApp.finishViewReturned.connect(props.onReturnFromChildPage);
                        const url = props.setupPageCollections[props.indexSetupPage]["url"]
                        const intent = IntentApp.create(url, {"welcomesetup": 1})
                        startView(intent);
                    }
                }
                else {
                    //                     console.log("back")
                    if (indexSetupPage > 0) indexSetupPage = indexSetupPage - 1
                    if (indexSetupPage != 0){
                        viewApp.finishViewReturned.connect(props.onReturnFromChildPage);
                        const url = props.setupPageCollections[props.indexSetupPage]["url"]
                        const intent = IntentApp.create(url, {"welcomesetup": 1})
                        startView(intent);
                    }
                }
                //                console.log("indexSetupPage: " + indexSetupPage)
            }//
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                viewApp.enabledSwipedFromLeftEdge   = false
                viewApp.enabledSwipedFromRightEdge  = false
                viewApp.enabledSwipedFromBottomEdge = false
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
    D{i:0;autoSize:true;formeditorColor:"#c0c0c0";formeditorZoom:0.9;height:480;width:800}
}
##^##*/
