/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Ahmad Qodri
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

ViewApp {
    id: viewApp
    title: "User"

    background.sourceComponent: Item {}//

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
                    title: qsTr(viewApp.title)
                }//
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 70

                Rectangle {
                    anchors.fill: parent
                    color: "#0F2952"
                    //                    border.color: "#DDDDDD"
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
                                var intent = IntentApp.create(uri, {})
                                finishView(intent)
                            }//
                        }//

                        //                        ButtonBarApp {
                        //                            width: 194
                        //                            anchors.verticalCenter: parent.verticalCenter
                        //                            anchors.right: parent.right

                        //                            imageSource: "qrc:/UI/Pictures/user-login.png"
                        //                            text: qsTr("Logout")

                        //                            onClicked: {
                        //                                UserSessionService.logout()

                        //                                const intent = IntentApp.create("", {})
                        //                                startRootView(intent)
                        //                            }//
                        //                        }//
                    }//
                }//
            }//
        }//


        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        //        QtObject {
        //            id: props
        //        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }////

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
            }//

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }//
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
