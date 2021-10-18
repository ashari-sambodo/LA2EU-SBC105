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

import UserManageQmlApp 1.0

import ModulesCpp.Machine 1.0
import ModulesCpp.ELSkeygen 1.0

ViewApp {
    id: viewApp
    title: "Login"

    background.sourceComponent: Item {}//

    /*    content.asynchronous: true
    content.sourceComponent: */ContentItemApp {
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
                    title: qsTr("Login")
                }//
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true


                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    Rectangle{
                        id: usernameRect
                        height:70
                        width: 400
                        color: "#0F2952"
                        radius: 10

                        RowLayout{
                            anchors.fill: usernameRect
                            spacing: 0

                            Item{
                                Layout.fillHeight: true
                                Layout.minimumWidth: 70

                                Image {
                                    id: usernameIcon
                                    source: "qrc:/UI/Pictures/user-name-icon.png"
                                    fillMode: Image.PreserveAspectFit

                                    TextApp {
                                        width: 70
                                        horizontalAlignment: Text.AlignHCenter
                                        font.pixelSize: 12
                                        minimumPixelSize: 10
                                        text: qsTr("Select user");
                                        wrapMode: Text.WordWrap
                                    }//

                                    TextApp {
                                        anchors.bottom: parent.bottom
                                        horizontalAlignment: Text.AlignHCenter
                                        font.pixelSize: 12
                                        minimumPixelSize: 10
                                        text: qsTr("Press here");
                                        wrapMode: Text.WordWrap
                                        width: 70
                                    }//
                                }//

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        const intent = IntentApp.create("qrc:/UI/Pages/LoginPage/LoginUserListPage.qml", {})
                                        startView(intent)
                                    }//
                                }//
                            }//

                            Item{
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                TextFieldApp{
                                    id: usernameTextInput
                                    placeholderText: qsTr("Username")
                                    height:parent.height
                                    width:parent.width
                                    background: Rectangle{
                                        color: "transparent"
                                        anchors.fill:parent
                                    }//
                                    onPressed: {
                                        KeyboardOnScreenCaller.openKeyboard(this, qsTr("Username"))
                                    }//
                                    onAccepted: {
                                        ////console.debug(text)
                                        props.textUsername = text
                                        if ((text == "factory") || (text == "service")) {
                                            nameRect.visible = true
                                        }
                                        else {
                                            nameRect.visible = false
                                        }
                                        //                                        //console.debug(props.textUsername)
                                    }//

                                    //                                    text: "factory"
                                }//
                            }//
                        }//

                    }//

                    Rectangle{
                        id: nameRect
                        height:70
                        width: 400
                        color: "#0F2952"
                        radius: 10
                        visible: false

                        RowLayout{
                            anchors.fill: nameRect
                            spacing: 0

                            Item{
                                Layout.fillHeight: true
                                Layout.minimumWidth: 70

                                Image {
                                    id: nameIcon
                                    source: "qrc:/UI/Pictures/user-name-icon.png"
                                    fillMode: Image.PreserveAspectFit
                                }//
                            }//

                            Item{
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                TextFieldApp{
                                    id: nameTextInput
                                    placeholderText: qsTr("Your full name")
                                    height:parent.height
                                    width:parent.width
                                    background: Rectangle{
                                        color: "transparent"
                                        anchors.fill:parent
                                    }//

                                    property string prevText: ""

                                    onPressed: {
                                        prevText = text
                                        KeyboardOnScreenCaller.openKeyboard(this, qsTr("Full name"))
                                    }//

                                    onAccepted: {
                                        ////console.debug(text)
                                        const stdName = /^([a-zA-Z]{2,}\s[a-zA-Z]{1,}'?-?[a-zA-Z]{2,}\s?([a-zA-Z]{1,})?)/
                                        if(!text.match(stdName)) {
                                            text = ""
                                            let message = qsTr("Seems like not a person's name!") + "<br><br>" + qsTr("Example: John Doe")
                                            showDialogMessage(qsTr("Login"), message, dialogAlert)
                                            return
                                        }
                                        props.textFullname = text
                                        //                                        //console.debug(props.textUsername)
                                    }//

                                    //                                    text: "factory dev"
                                }//
                            }//
                        }//

                    }//

                    Rectangle{
                        id: passwordRect
                        height:70
                        width: 400
                        radius: 10
                        color: "#0F2952"

                        RowLayout{
                            anchors.fill: passwordRect
                            spacing: 0

                            Item{
                                Layout.fillHeight: true
                                Layout.minimumWidth: 70

                                Image {
                                    id: passwordIcon
                                    source: "qrc:/UI/Pictures/user-password-icon.png"
                                    fillMode: Image.PreserveAspectFit
                                    states: [
                                        State{
                                            when: props.elsIsEnabled
                                            PropertyChanges {
                                                target: passwordIcon
                                                source: "qrc:/UI/Pictures/user-password-icon-els.png"
                                            }//
                                        }//
                                    ]

                                    TextApp {
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        font.pixelSize: 11
                                        visible: props.elsIsEnabled
                                        //                                        color: "#0F2952"
                                        text: qsTr("ELS active");
                                    }//
                                }//
                            }//

                            Item{
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                TextFieldApp{
                                    id: passwordTextInput
                                    placeholderText: qsTr("Password")
                                    height: parent.height
                                    width: parent.width
                                    echoMode: TextInput.Password
                                    background: Rectangle{
                                        color: "transparent"
                                        anchors.fill:parent
                                    }//
                                    onPressed: {
                                        KeyboardOnScreenCaller.openKeyboard(this, qsTr("Password"))
                                    }//

                                    onAccepted: {
                                        ////console.debug(text)
                                        props.textPassword = String(text)
                                        //                                        //console.debug(props.textPassword)
                                    }//
                                    //                                    text: "00019"
                                }//
                            }//
                        }//
                    }//
                }
            }////

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
                        }////

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/user-login.png"
                            text: qsTr("Login")

                            onClicked: {
                                showBusyPage(qsTr("Login in progress..."))
                                //console.debug("login")
                                //console.debug("Username: ", props.textUsername)
                                //console.debug("Password: ", props.textPassword)
                                //console.debug("Service : ", props.textPasswordService)
                                //console.debug("Factory : ", props.textPasswordFactory)
                                const strPassword = props.textPassword
                                const strService = props.textPasswordService
                                const strFactory = props.textPasswordFactory

                                if (props.textUsername == 'factory'){
                                    if (!strPassword.localeCompare(strFactory)) {
                                        UserSessionService.loggedIn = true
                                        UserSessionService.roleLevel = UserSessionService.roleLevelFactory
                                        UserSessionService.username = props.textUsername
                                        UserSessionService.fullname = props.textFullname + " (" + props.textUsername + ")"

                                        MachineAPI.setSignedUser(props.textUsername, UserSessionService.fullname)
                                        const message = qsTr("Login succes! username: ") + props.textUsername
                                        MachineAPI.insertEventLog(message)

                                        props.loginSuccessDialog()
                                    }
                                    else {
                                        showDialogMessage(qsTr("Login"), qsTr("Login failed: Incorrect user ID or password!"), dialogAlert)
                                        console.debug("Failed user factory")
                                        const message = qsTr("Login failed! username: ") + props.textUsername
                                        MachineAPI.insertEventLog(message)
                                    }
                                }
                                else if (props.textUsername == 'service'){
                                    if (!strPassword.localeCompare(strService)) {
                                        UserSessionService.loggedIn = true
                                        UserSessionService.roleLevel = UserSessionService.roleLevelService
                                        UserSessionService.username = props.textUsername
                                        UserSessionService.fullname = props.textFullname + " (" + props.textUsername + ")"

                                        MachineAPI.setSignedUser(props.textUsername, UserSessionService.fullname)
                                        const message = qsTr("Login succes! username: ") + props.textUsername
                                        MachineAPI.insertEventLog(message)

                                        props.loginSuccessDialog()
                                    }
                                    else {
                                        showDialogMessage(qsTr("Login"), qsTr("Login failed: Incorrect user ID or password!"), dialogAlert)
                                        console.debug("Failed user service")
                                        const message = qsTr("Login failed! username: ") + props.textUsername
                                        MachineAPI.insertEventLog(message)
                                    }
                                }
                                //                                else if ((props.textUsername == 'admin')
                                //                                         && (props.textPassword == '00001')){
                                //                                    UserSessionService.loggedIn = true
                                //                                    UserSessionService.roleLevel = UserSessionService.roleLevelAdmin
                                //                                    UserSessionService.username = props.textUsername
                                //                                    UserSessionService.fullname = props.textUsername

                                //                                    props.loginSuccessDialog()
                                //                                }

                                //                                else if ((props.textUsername == 'user')
                                //                                         && (props.textPassword == '00000')){
                                //                                    UserSessionService.loggedIn = true
                                //                                    UserSessionService.roleLevel = UserSessionService.roleLevelRegular
                                //                                    UserSessionService.username = props.textUsername
                                //                                    UserSessionService.fullname = props.textUsername

                                //                                    props.loginSuccessDialog()
                                //                                }
                                else{
                                    /// Check login with database
                                    loginDatabaseComp.createObject(viewApp,
                                                                   {
                                                                       usernameInput: props.textUsername,
                                                                       passwordInput: props.textPassword
                                                                   })
                                }//
                            }//
                        }//
                    }//
                }//
            }//
        }//

        //        Timer {
        //            id: loginPageTimeOutTimer
        //            running: true
        //            interval: 60000
        //            onTriggered: {
        //                showDialogMessage(qsTr("Session"),
        //                                  qsTr("Login session expired! back to Home Screen."),
        //                                  dialogAlert,
        //                                  function onClosed(){
        //                                      const intent = IntentApp.create(uri, {})
        //                                      finishView(intent)
        //                })
        //            }
        //        }//

        //        Connections {
        //            target: viewApp

        //            function onScreenPressed(){
        //                console.log("onScreenPressed")
        //                loginPageTimeOutTimer.restart()
        //            }//
        //        }//

        UtilsApp {
            id: utilsApp
        }//

        ELSkeygen {
            id: elsKeygen

            /// Replacement for Service Pin
            generatedKey: ""
            /// Replacement for Factory Pin
            generatedKey2: ""

            onGeneratorKeyHasFinished: {
                console.debug("generatedKey: " + generatedKey)
                console.debug("generatedKey2: " + generatedKey2)

                props.textPasswordFactory = generatedKey2
                props.textPasswordService = generatedKey
            }//
        }//

        Component {
            id: loginDatabaseComp

            Item {
                id: loginDatabaseItem

                //                Rectangle {
                //                    height: 100
                //                    width: 100
                //                    opacity: 0.5
                //                }

                property string usernameInput: ""
                property string passwordInput: ""

                //                Component.onCompleted: {
                //                    console.log(usernameInput)
                //                    console.log(passwordInput)
                //                }

                //                Component.onDestruction: {
                //                    console.log("Bye")
                //                }

                UserManageQmlApp {
                    id: userManageQml

                    onInitializedChanged: {
                        selectUserByUsername(loginDatabaseItem.usernameInput)
                    }

                    onUserSelectedByUsernameHasExecuted: {
                        if(!success){
                            //                            console.log("Not success!")
                            showDialogMessage(qsTr("Login"), qsTr("Login failed: There is problem in database transaction!"), dialogAlert)
                        }
                        else if (!exist) {
                            //                            console.log("Not exist!")
                            showDialogMessage(qsTr("Login"), qsTr("Login failed: Your user ID is not exist!"), dialogAlert)

                            const message = qsTr("Login failed! username: ") + props.textUsername
                            MachineAPI.insertEventLog(message)
                        }
                        else {
                            //                            console.log("Exist then do compare")
                            const password = user.password
                            const passwordInputMd5 = Qt.md5(loginDatabaseItem.passwordInput)

                            if (password === passwordInputMd5) {
                                UserSessionService.loggedIn  = true
                                UserSessionService.roleLevel = user.role
                                UserSessionService.username  = user.username
                                UserSessionService.fullname  = user.fullname

                                MachineAPI.setSignedUser(user.username, user.fullname)

                                const message = qsTr("Login succes! username: ") + props.textUsername
                                MachineAPI.insertEventLog(message)

                                props.loginSuccessDialog()
                            }
                            else {
                                showDialogMessage(qsTr("Login"), qsTr("Login failed: Incorrect user ID or password!"), dialogAlert)

                                const message = qsTr("Login failed! username: ") + props.textUsername
                                MachineAPI.insertEventLog(message)
                            }
                        }

                        /// self destroy
                        loginDatabaseItem.destroy()
                    }

                    Component.onCompleted: {
                        const connectionId = "loginDatabaseComp"
                        init(connectionId);
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            //            property int    countDefault: 50
            //            property int    count: 50
            property bool   elsIsEnabled : false
            property string textPassword : ""
            property string textUsername : ""
            property string textFullname : ""

            property string textPasswordService: "00009"
            property string textPasswordFactory: "00019"

            readonly property int serialLength: 8


            function loginSuccessDialog(){
                viewApp.showDialogMessage(qsTr("Notification"),
                                          qsTr("You are successfully logged in!"),
                                          viewApp.dialogInfo,
                                          function onClosed(){
                                              const intent = IntentApp.create("", {})
                                              startRootView(intent)
                                          })
            }
        }//

        /// One time executed after onResume
        Component.onCompleted: {
            /// override right swipe action
            viewApp.fnSwipedFromRightEdge = function(){}
        }////

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible:  Item {

            /// onResume
            Component.onCompleted: {
                //console.debug("StackView.Active");

                props.elsIsEnabled = MachineData.escoLockServiceEnable      /// no need binding because no need real time update

                if (props.elsIsEnabled) {
                    const serialNumberExtract = MachineData.serialNumber.split("-")    /// example: 2021-00000000 -> [2021, 00000000]
                    if (serialNumberExtract.length === 2){
                        let serialNum = serialNumberExtract[1]
                        if (serialNum.length !== props.serialLength) {
                            serialNum = utilsApp.fixStrLength(serialNum, props.serialLength, "0", 1)
                        }
                        //                        console.log("serial to be calculated: " + serialNum)

                        /// serial number not set yet, skip esco lock service
                        if(serialNum === "00000000"){
                            return
                        }

                        elsKeygen.calculateKey(serialNum)
                    }//
                }//
            }//

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }//

            Connections {
                target: viewApp

                function onFinishViewReturned(intent){
                    const extradata = IntentApp.getExtraData(intent)
                    if(extradata.userSelect) {
                        const userSelect = extradata.userSelect

                        console.log(userSelect.fullname)
                        console.log(userSelect.username)

                        /// fill up username
                        usernameTextInput.text = userSelect.username
                        props.textUsername = userSelect.username
                    }
                }//
            }//
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/
