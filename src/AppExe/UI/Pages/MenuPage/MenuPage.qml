import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Menu"

    background.sourceComponent: Item {
        Rectangle {anchors.fill: parent; color: "#77000000"}
    }

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
                    title: qsTr("Menu")
                }//
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                /// menu content
                SwipeAreaApp{
                    anchors.fill: parent
                    debugSwipe: true
                    onSwipeLeft: {
                        //                        console.debug(props.menuGroup[props.currentIndexMenuGroup].length)
                        //                        console.debug(props.menuGroup.length)

                        const flagIndex = props.menuGroup[props.currentIndexMenuGroup].length - 1
                        //                        console.debug(flagIndex)

                        if(props.currentIndexMenuUser !== flagIndex){
                            props.currentIndexMenuUser = props.currentIndexMenuUser + 1;
                            menuStackView.currentItem.model = props.menuGroup[props.currentIndexMenuGroup][props.currentIndexMenuUser]
                            menuStackView.currentItem.initSource()
                        }
                        else{
                            if(menuStackView.depth > 1){
                                menuStackView.pop()
                                return
                            }
                            if(props.currentIndexMenuGroup != (props.menuGroup.length - 1)){
                                props.currentIndexMenuGroup = props.currentIndexMenuGroup + 1
                                props.currentIndexMenuUser  = 0
                                menuStackView.currentItem.model = props.menuGroup[props.currentIndexMenuGroup][0]
                                menuStackView.currentItem.initSource()
                            }//
                        }//
                    }//

                    onSwipeRight: {
                        //                        console.log("props.currentIndexMenuUser" + props.currentIndexMenuUser)
                        if(props.currentIndexMenuUser != 0){
                            props.currentIndexMenuUser = props.currentIndexMenuUser - 1;
                            menuStackView.currentItem.model = props.menuGroup[props.currentIndexMenuGroup][props.currentIndexMenuUser]
                            menuStackView.currentItem.initSource()
                        }
                        else {
                            if(menuStackView.depth > 1){
                                menuStackView.pop()
                                return;
                            }
                            if(props.currentIndexMenuGroup != 0){
                                props.currentIndexMenuGroup = props.currentIndexMenuGroup - 1
                                let indexGuard = props.menuGroup[props.currentIndexMenuGroup].length - 1
                                props.currentIndexMenuUser  = indexGuard
                                menuStackView.currentItem.model = props.menuGroup[props.currentIndexMenuGroup][indexGuard]
                                menuStackView.currentItem.initSource()
                            }//
                        }//
                    }//

                    StackView{
                        id: menuStackView
                        anchors.fill: parent
                        anchors.margins: 2

                        replaceEnter: Transition{}
                        replaceExit: Transition{}

                        //                        property var modelSubMenu: []
                        //                        signal clicked(string mtype, string mlink)
                        signal clicked(variant mtype, variant mlink, variant msub)
                        onClicked:{
                            //                            //console.debug(menuStackView.modelSubMenu)
                            if(mtype === "menu"){
                                /// //console.debug("this is menu")
                                /// LOAD_PAGE
                                var intent = IntentApp.create(mlink, {})
                                startView(intent)
                            }
                            else if(mtype === "submenu"){
                                /// //console.debug("this is submenu")
                                /// SHOW_SUBMENU
                                menuStackView.push(Qt.resolvedUrl(props.gridMenuUrl), {model: msub})
                            }//
                        }//
                    }//
                }//

                PageIndicator {
                    id: indicator
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    count: props.menuGroup[props.currentIndexMenuGroup].length
                    currentIndex: props.currentIndexMenuUser

                    delegate: Rectangle {
                        height: 10
                        width: 10
                        radius: 5
                        opacity: indicator.currentIndex == index ? 1 : 0.5
                    }//
                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 70

                RowLayout {
                    anchors.fill: parent

                    Image {
                        Layout.fillHeight: true
                        Layout.minimumWidth: 120
                        source: "qrc:/UI/Pictures/HomeButton.png"
                        opacity: homeMouseArea.pressed ? 0.5 : 1

                        MouseArea {
                            id: homeMouseArea
                            anchors.fill: parent
                            onClicked: {
                                if(menuStackView.depth > 1){
                                    menuStackView.pop()
                                }else{
                                    /// I'm Done
                                    var intent = IntentApp.create(uri, {})
                                    finishView(intent)
                                }//
                            }//
                        }

                        //                        MouseArea {
                        //                            id: homeMouseArea
                        //                            anchors.fill: parent
                        //                            onClicked: {
                        //                                if(menuStackView.depth > 1){
                        //                                    menuStackView.pop()
                        //                                }else{
                        //                                    /// I'm Done
                        //                                    var intent = IntentApp.create(uri, {"message":""})
                        //                                    finishView(intent)
                        //                                }//
                        //                            }//
                        //                        }//
                    }//

                    Item{
                        id: pageIndicatorItem
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        //                        Rectangle{anchors.fill: parent; color: "red"}

                        Row {
                            id: pageIndicatorRow
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 2

                            Repeater {
                                id: pageIndicatorRepeater
                                anchors.fill: parent

                                //                                model: ["User", "Admin", "Service", "Factory"]
                                //                                model: 3
                                model: props.menuGroupIndicator

                                property int currentIndex: 0

                                Rectangle {
                                    height: 70
                                    width: pageIndicatorItem.width / pageIndicatorRepeater.count - 2
                                    color: props.currentIndexMenuGroup === index ? "#0F2952" : "transparent"
                                    radius: 5
                                    border.width: 1
                                    border.color: "#dddddd"

                                    TextApp {
                                        anchors.fill: parent
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        text: modelData
                                    }//

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            menuStackView.pop(null, StackView.Immediate)
                                            props.currentIndexMenuGroup = index
                                            props.currentIndexMenuUser = 0
                                            menuStackView.replace(null, Qt.resolvedUrl(props.gridMenuUrl),
                                                                  {model: props.menuGroup[props.currentIndexMenuGroup][props.currentIndexMenuUser]})
                                        }//
                                    }//

                                    //                                    MouseArea {
                                    //                                        anchors.fill: parent
                                    //                                        onClicked: {
                                    //                                            menuStackView.pop(null, StackView.Immediate)
                                    //                                            props.currentIndexMenuGroup = index
                                    //                                            props.currentIndexMenuUser = 0
                                    //                                            menuStackView.replace(null, Qt.resolvedUrl(gridMenuUrl),
                                    //                                                                  {model: props.menuGroup[props.currentIndexMenuGroup][props.currentIndexMenuUser]})
                                    //                                        }//
                                    //                                    }//

                                    Loader{
                                        active: props.currentIndexMenuGroup === index
                                        anchors.top: parent.top
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        sourceComponent: Rectangle {
                                            height: 5
                                            width: 50
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//

                    Image {
                        Layout.fillHeight: true
                        Layout.minimumWidth: 120
                        source: "qrc:/UI/Pictures/LoginButton.png"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                UserSessionService.askedForLogin()
                            }//
                        }//
                    }//
                }//
            }//
        }//

        ///Note: Each WorkerScript element will instantiate a separate JavaScript engine to ensure perfect isolation and thread-safety.
        ///If the impact of that results in a memory consumption that is too high for your environment, then consider sharing a WorkerScript element.
        WorkerScript {
            id: myWorker
            source: "Components/WorkerScriptCreateGridMenuModel.mjs"

            property bool established: false
            Component.onCompleted: established = true

            onMessage: {
                //                //console.debug(messageObject)

                props.menuGroup = messageObject.menu
                props.menuGroupIndicator = messageObject.indicator

                //                console.debug(JSON.stringify(messageObject.menu))
                //                console.debug(JSON.stringify(messageObject.indicator))

                props.currentIndexMenuGroup   = 0
                props.currentIndexMenuUser    = 0
                menuStackView.replace(null, Qt.resolvedUrl(props.gridMenuUrl),
                                      {model: props.menuGroup[props.currentIndexMenuGroup][props.currentIndexMenuUser]})
            }
        }//

        QtObject {
            id: props

            property string gridMenuUrl        : "Components/MenuContainer.qml"
            property var menuGroup             : [[]]
            property var menuGroupIndicator    : []
            property int currentIndexMenuGroup : 0
            property int currentIndexMenuUser  : 0

            property bool userSignedStatus: false

            property bool sashWindowMotorizeInstalled: false
            property bool uvInstalled: false
            property bool seasInstalled: false

            property bool menuHasCreated: false
        }//

        /// called Once but after onResume
        Component.onCompleted: {
            //             console.debug(uri + " " + "Component.onCompleted")
            //            //            myWorker.sendMessage({'action':'init', 'userlevel':4})
            //            myWorker.onEstablishedChanged.connect(function(){
            //                console.debug("myWorker.onEstablishedChanged.connect")
            //                myWorker.sendMessage({"action": "init",
            //                                         "userlevel": UserSessionService.roleLevel,
            //                                         "sashWindowMotorizeInstalled": props.sashWindowMotorizeInstalled
            //                                     })
            //            })
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                /// only re-fillup if this screen on state visible
                props.userSignedStatus = Qt.binding(function(){ return UserSessionService.loggedIn })
                props.sashWindowMotorizeInstalled = Qt.binding(function(){ return MachineData.sashWindowMotorizeInstalled })
                props.uvInstalled = Qt.binding(function(){ return MachineData.uvInstalled })
                props.seasInstalled = Qt.binding(function(){ return MachineData.seasInstalled })

                //                console.log("props.sashWindowMotorizeInstalled: " + props.sashWindowMotorizeInstalled)

                if (!props.menuHasCreated) {
                    props.menuHasCreated = true
                    myWorker.sendMessage({"action": "init",
                                             "userlevel": UserSessionService.roleLevel,
                                             "uvInstalled": props.uvInstalled,
                                             "sashWindowMotorizeInstalled": props.sashWindowMotorizeInstalled,
                                             "seasInstalled": props.seasInstalled
                                         })
                }
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
    D{i:0;autoSize:true;height:600;width:1024}
}
##^##*/
