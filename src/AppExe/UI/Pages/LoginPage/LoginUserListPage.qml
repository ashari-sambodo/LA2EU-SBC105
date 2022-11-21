/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

//import UserManageQmlApp 1.0

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Users"

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
                    title: qsTr("User")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                GridView {
                    id: userGridView
                    anchors.centerIn: parent
                    height: count < 3 ? 100 : parent.height
                    width: count <= 3 ? count * (parent.width / 3) : parent.width
                    cellWidth: cellReqWidth
                    cellHeight: 100
                    clip: true
                    onModelChanged: currentIndex = -1
                    model: props.userLastLogin
                    //                    model: [
                    //                        {name: "Heri",          username: "hericahyono", role: 1},
                    //                        {name: "Cahyono",       username: "cahyonoheri", role: 1},
                    //                        //                        {name: "Ujang Gobel",   username: "herikasep", status: "Admin"},
                    //                        //                        {name: "Pangihutan",    username: "ujangheri", status: "Admin"}
                    //                    ]

                    property int cellReqWidth: parent.width / 3

                    delegate: Item {
                        width: userGridView.cellReqWidth
                        height: 100

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 2
                            color: "#0F2952"
                            radius : 5

                            RowLayout{
                                anchors.fill: parent

                                Item {
                                    Layout.fillHeight: true
                                    Layout.minimumWidth: height
                                    Layout.fillWidth: false

                                    //Rectangle {anchors.fill: parent; color: "yellow"}

                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 2
                                        spacing: 2

                                        Rectangle {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            //                                            anchors.fill: parent
                                            //                                            anchors.margins: 5
                                            color: "#555555"
                                            //                                            color: "#001F51"
                                            border.color: "#888888"
                                            border.width: 2
                                            radius: 5

                                            TextApp {
                                                id: fiturtext
                                                anchors.fill: parent
                                                anchors.margins: 5
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                text:""
                                                font.pixelSize: 50
                                                fontSizeMode: Text.Fit

                                                Component.onCompleted: {
                                                    let str = modelData.fullname || "AA";
                                                    let rstr = str.substring(0,1);
                                                    //console.debug(rstr);
                                                    fiturtext.text = rstr
                                                }//
                                            }//
                                            MouseArea {
                                                id: userDeleteList
                                                enabled: UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin
                                                anchors.fill: parent
                                                onClicked: {
                                                    deleteUserListItem.visible = !deleteUserListItem.visible
                                                }//
                                            }//
                                        }//
                                        Item{
                                            id: deleteUserListItem
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            visible: false
                                            Image{
                                                anchors.centerIn: parent
                                                source: "qrc:/UI/Pictures/user-del-favi-30px.png"
                                                opacity: deleteUserListBtnMA.pressed ? 0.5 : 1
                                                MouseArea{
                                                    id: deleteUserListBtnMA
                                                    anchors.fill: parent
                                                    onClicked: {
                                                        MachineAPI.deleteUserLastLogin(modelData.username)
                                                    }
                                                }//
                                            }//
                                        }//
                                    }//
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 5
                                        spacing: 2

                                        TextApp {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            verticalAlignment: Text.AlignVCenter
                                            elide: Text.ElideRight
                                            text:  modelData.fullname
                                        }//
                                        TextApp {
                                            Layout.minimumHeight: 20
                                            Layout.fillWidth: true
                                            verticalAlignment: Text.AlignVCenter
                                            elide: Text.ElideRight
                                            text:  modelData.username
                                            font.pixelSize: 16
                                            //font.italic: true
                                            //color: "grey"
                                        }//
                                        TextApp {
                                            Layout.minimumHeight: 20
                                            Layout.fillWidth: true
                                            verticalAlignment: Text.AlignVCenter
                                            elide: Text.ElideRight
                                            text:  qsTr("Logged in: %1").arg(modelData.login)
                                            font.pixelSize: 14
                                            color: "grey"
                                        }//
                                    }//
                                    MouseArea {
                                        id: userSelectRectMA
                                        enabled: !UserSessionService.loggedIn
                                        anchors.fill: parent
                                        onClicked: {
                                            const intent = IntentApp.create(uri,
                                                                            {"userSelect": {
                                                                                    "username": modelData.username,
                                                                                    //"role":     modelData.role,
                                                                                    "fullname": modelData.fullname,
                                                                                    //"email":    modelData.email,
                                                                                }
                                                                            })
                                            finishView(intent)
                                        }//
                                        onDoubleClicked: {

                                        }
                                    }//
                                }//
                            }//
                        }//
                    }//
                }

                Loader {
                    active: userGridView.count == 0 && props.initialized
                    anchors.centerIn: parent
                    sourceComponent: Item {

                        Column {
                            anchors.centerIn: parent
                            id: infoEmptyColumn
                            TextApp {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("Oops!")
                                font.pixelSize: 32
                            }//

                            TextApp {
                                text: qsTr("Seems like there's no user have logged in yet.")
                            }//
                        }

                        MouseArea{
                            anchors.fill: infoEmptyColumn
                            onClicked: {
                                props.reloadUser()
                            }//
                        }//

                        visible: false
                        Timer {
                            running: true
                            interval: 1000
                            onTriggered: {
                                parent.visible = true
                            }//
                        }//
                    }//
                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 70

                BackgroundButtonBarApp{
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
                            }//
                        }//
                    }//
                }//
            }//
        }//

        //        UserManageQmlApp {
        //            id: userManageQml

        //            delayEmitSignal: 500 // ms

        //            onInitializedChanged: {
        //                delayEmitSignal = 1000 //ms
        //                props.reloadUser()
        //            }//

        //            onSelectHasDone: {
        //                // console.log(total)
        //                userGridView.model = dataBuffer
        //                closeDialog()
        //            }//

        //            Component.onCompleted: {
        //                const connectionId = "LoginUserListPage"
        //                init(connectionId);

        //                showBusyPage(qsTr("Loading..."), function(cycle){
        //                    if (cycle >= MachineAPI.BUSY_CYCLE_2){
        //                        closeDialog()
        //                    }//
        //                })//
        //            }//
        //        }//

        //// Put all private property inside here
        //// if none, please comment this block to optimize the code
        QtObject {
            id: props
            property bool initialized: false
            property var userLastLogin: []
            //            function reloadUser(){
            //                showBusyPage(qsTr("Loading..."), function(cycle){
            //                    if (cycle >= MachineAPI.BUSY_CYCLE_2){
            //                        closeDialog()
            //                    }
            //                })
            //                /// get 100 users
            //                /// as a page 1
            //                //                userManageQml.selectDescendingWithPagination(100, 1);
            //            }//
        }//

        /// called Once but after onResume
        Component.onCompleted: {
            /// override right swipe action
            viewApp.fnSwipedFromRightEdge = function(){}
            props.userLastLogin = Qt.binding(function(){return MachineData.userLastLogin})
            props.initialized = true
        }//

        //        /// Execute This Every This Screen Active/Visible
        //        executeOnPageVisible: QtObject {

        //            /// onResume
        //            Component.onCompleted: {
        //                //                    console.debug("StackView.Active: " + viewApp.uri);
        //            }//

        //            /// onPause
        //            Component.onDestruction: {
        //                //                    console.debug("StackView.DeActivating:" + viewApp.uri);
        //            }//
        //        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";formeditorZoom:0.9;height:480;width:800}
}
##^##*/
