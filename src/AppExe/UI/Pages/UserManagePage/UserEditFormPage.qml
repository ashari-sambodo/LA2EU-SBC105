import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.9

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import UserManageQmlApp 1.0

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Edit User"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp{
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
                    title: qsTr(viewApp.title)
                }
            }

            // BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent
                    anchors.bottomMargin: 10

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumWidth: 300

                        Flickable {
                            anchors.fill: parent
                            contentHeight: formColumn.height
                            contentWidth: formColumn.width
                            clip: true

                            flickableDirection: Flickable.VerticalFlick

                            Column {
                                id: formColumn
                                spacing: 5

                                Column {

                                    Row {
                                        TextApp {
                                            text: qsTr("Full Name")
                                            font.pixelSize: 14
                                        }

                                        TextApp {
                                            id: fullnameWarningText
                                            text: " | " +  qsTr("Invalid!")
                                            font.pixelSize: 14
                                            color: "orange"
                                            visible: false
                                            font.italic: true
                                        }//
                                    }

                                    TextFieldApp {
                                        id: fullnameTextField
                                        placeholderText: qsTr("Full Name")
                                        width: 299
                                        height: 40
                                        font.pixelSize: 20
                                        maximumLength:  50

                                        property bool isValid: false
                                        property bool isNeedUpdate: false

                                        background: Rectangle {
                                            anchors.fill: parent
                                            radius: 5
                                            color: "#0F2952"
                                            border.color: "#E3DAC9"
                                            border.width: 2
                                        }

                                        onPressed: {
                                            KeyboardOnScreenCaller.openKeyboard(fullnameTextField, qsTr("Full Name"))
                                        }//

                                        onAccepted: {
                                            let newText = text
                                            if ((newText.length < 2) || (newText === "  ")) {
                                                isValid = false
                                                fullnameWarningText.visible = true
                                            }
                                            else {
                                                isValid = true
                                                fullnameWarningText.visible = false
                                            }//

                                            if(isValid) {
                                                if (props.origin_fullname !== text) {
                                                    isNeedUpdate = true
                                                }//
                                            }//
                                        }//
                                    }//
                                }// full name

                                Column {

                                    Row{
                                        TextApp {
                                            text: qsTr("Username")
                                            font.pixelSize: 14
                                        }//

                                        TextApp {
                                            id: usernameWarningText
                                            text: " | " +  qsTr("Not editable!")
                                            font.pixelSize: 14
                                            color: "orange"
                                            visible: true
                                            font.italic: true
                                        }//
                                    }//

                                    TextFieldApp {
                                        id: usernameTextField
                                        placeholderText: qsTr("Username")
                                        width: 299
                                        height: 40
                                        font.pixelSize: 20
                                        maximumLength:  20
                                        enabled: false

                                        property bool isValid: false
                                        property bool isNeedUpdate: false

                                        background: Rectangle {
                                            anchors.fill: parent
                                            radius: 5
                                            color: "#0F2952"
                                            border.color: "#E3DAC9"
                                            border.width: 2
                                        }//

                                        //                                        onPressed: {
                                        //                                            KeyboardOnScreenCaller.openKeyboard(usernameTextField, qsTr("User Name"))
                                        //                                        }//

                                        //                                        onAccepted: {
                                        //                                            //                                            console.log("Hello")
                                        //                                            const pattern = /^[a-zA-Z\-]+$/;
                                        //                                            const newText = text
                                        //                                            if(newText.match(pattern)) {
                                        //                                                isValid = true
                                        //                                                usernameWarningText.visible = false
                                        //                                            }
                                        //                                            else {
                                        //                                                isValid = false
                                        //                                                usernameWarningText.visible = true
                                        //                                            }

                                        //                                            if(isValid) {
                                        //                                                if (props.origin_username !== text) {
                                        //                                                    isNeedUpdate = true
                                        //                                                }//
                                        //                                            }//
                                        //                                        }
                                    }//
                                }// username

                                Column {

                                    Row{
                                        spacing: 3

                                        TextApp {
                                            text: qsTr("New Password")
                                            font.pixelSize: 14
                                        }//

                                        TextApp {
                                            id: passwordWarningText
                                            text: " | " +  qsTr("Min. length is") + " " + props.passwordMinimumLength
                                            font.pixelSize: 14
                                            color: "orange"
                                            visible: false
                                            font.italic: true
                                        }//
                                    }//

                                    TextFieldApp {
                                        id: passwordTextField
                                        placeholderText: qsTr("Create New Password")
                                        width: 299
                                        height: 40
                                        font.pixelSize: 20
                                        maximumLength: 20

                                        property bool isValid: false
                                        property bool isNeedUpdate: false

                                        background: Rectangle {
                                            id:rectanglePassword
                                            anchors.fill: parent
                                            radius: 5
                                            color: "#0F2952"
                                            border.color: "#E3DAC9"
                                            border.width: 2
                                        }//

                                        echoMode: TextFieldApp.Password

                                        onAccepted: {
                                            if (passwordTextField.text.length == 0){
                                                isNeedUpdate = false
                                                isValid = false
                                                passwordWarningText.visible = false
                                                return;
                                            }

                                            if(passwordTextField.text.length < props.passwordMinimumLength) {
                                                //console.debug("true")
                                                passwordWarningText.visible = true
                                                isValid = false
                                                isNeedUpdate = false
                                            }
                                            else {
                                                //console.debug("false")
                                                passwordWarningText.visible = false
                                                isValid = true
                                                isNeedUpdate = true
                                            }

                                        }

                                        onPressed: {
                                            KeyboardOnScreenCaller.openKeyboard(passwordTextField, qsTr("Create New Password"))
                                        }//
                                    }//

                                }// New Password

                                Column {

                                    Row{
                                        spacing: 3

                                        TextApp {
                                            text: qsTr("Confirm Password")
                                            font.pixelSize: 14
                                        }

                                        TextApp {
                                            id:confirmPassWarningText
                                            text: " | " + qsTr("Not match!")
                                            font.pixelSize: 14
                                            color: "red"
                                            visible: false
                                            font.italic: true
                                        }
                                    }


                                    TextFieldApp {
                                        id: passwordConfirmTextField
                                        placeholderText: qsTr("Retype New Password")
                                        width: 299
                                        height: 40
                                        font.pixelSize: 20
                                        maximumLength: 20
                                        echoMode : TextFieldApp.Password

                                        property bool isValid: false

                                        background: Rectangle {
                                            id: rectangleConfirmPass
                                            anchors.fill: parent
                                            radius: 5
                                            color: "#0F2952"
                                            border.color: "#E3DAC9"
                                            border.width: 2
                                        }//

                                        onAccepted: {
                                            if(passwordTextField.text == passwordConfirmTextField.text)
                                            {
                                                //console.debug("true")
                                                confirmPassWarningText.visible = false
                                                isValid = true
                                            }
                                            else
                                            {
                                                //console.debug("false")
                                                confirmPassWarningText.visible = true
                                                isValid = false
                                            }
                                        }//

                                        onPressed: {
                                            KeyboardOnScreenCaller.openKeyboard(passwordConfirmTextField, qsTr("Retype New Password"))
                                        }//
                                    }//

                                }// Confirm Password

                                Column {

                                    Row {
                                        spacing: 5

                                        TextApp{
                                            text: qsTr("Email")
                                            font.pixelSize: 14
                                        }//

                                        TextApp{
                                            id:textEmailWarning
                                            text: " | " + qsTr("Invalid!")
                                            font.pixelSize: 12
                                            font.italic: true
                                            color: "orange"

                                            visible: false
                                        }//
                                    }//

                                    TextFieldApp {
                                        placeholderText: "email@example.com"
                                        id: emailTextField
                                        width: 299
                                        height: 40
                                        font.pixelSize: 20
                                        maximumLength:  50

                                        property bool isValid: false
                                        property bool isNeedUpdate: false

                                        background: Rectangle {
                                            id:rectangleEmail
                                            anchors.fill: parent
                                            radius: 5
                                            color: "#0F2952"
                                            border.color: "#E3DAC9"
                                            border.width: 2
                                        }//

                                        //validator: RegExpValidator { regExp: /\w+([-+."]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/ }

                                        onAccepted: {
                                            //var mailformat = /^[a-zA-Z0-9.!#$%&"*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
                                            var mailformat = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/; ///^[a-zA-Z0-9.!#$%&"*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
                                            if(emailTextField.text.match(mailformat)) {
                                                //console.debug("true")
                                                textEmailWarning.visible = false
                                                isValid = true
                                            }
                                            else {
                                                textEmailWarning.visible = true
                                                isValid = false
                                            }

                                            if(isValid) {
                                                if (props.origin_fullname !== text) {
                                                    isNeedUpdate = true
                                                }//
                                            }//
                                        }

                                        onPressed: {
                                            KeyboardOnScreenCaller.openKeyboard(emailTextField, qsTr("Email"))
                                        }//
                                    }//

                                }// email

                                Column {

                                    Row {
                                        TextApp{
                                            text: qsTr("User Level")
                                            font.pixelSize: 16
                                        }//
                                    }//

                                    ComboBoxApp {
                                        id: userLevelComboBox
                                        width: 299
                                        height: 40
                                        font.pixelSize: 18

                                        property bool isNeedUpdate: false

                                        background: Rectangle {
                                            anchors.fill: parent
                                            radius: 5
                                            color: "#0F2952"
                                            border.color: "#E3DAC9"
                                            border.width: 2
                                        }//

                                        model:  UserSessionService.roleLevel >= UserSessionService.roleLevelSAdmin ?
                                                    ["Operator", "Administrator", "Supervisor"] :
                                                    ["Operator", "Administrator"]

                                        onActivated: {
                                            //console.log(props.origin_role)
                                            if(props.origin_role != index){
                                                isNeedUpdate = true
                                            }
                                            else {
                                                isNeedUpdate = false
                                            }
                                        }
                                    }//
                                }// user level
                            }//
                        }//
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Column {
                            anchors.centerIn: parent
                            spacing: 10

                            Rectangle {
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: 150
                                height: 150
                                color: "#0f2952"
                                radius: 10
                                border.color: "#e3dac9"
                                border.width: 5

                                TextApp {
                                    id: initialText
                                    text: "f"
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    font.pixelSize: width - 10
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    fontSizeMode: Text.Fit
                                }//
                            }//

                            TextApp {
                                id: fullNameText
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Full name"
                                font.pixelSize: 28
                                font.bold: true
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
                                var intent = IntentApp.create(uri, {})
                                finishView(intent)
                            }//
                        }//

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/edit-user-iscon-35px.png"
                            text: qsTr("Update")

                            onClicked: {
                                //                                console.debug(fullnameTextField.isValid)
                                //                                console.debug(usernameTextField.isValid)
                                //                                console.debug(passwordTextField.isValid)
                                //                                console.debug(passwordConfirmTextField.isValid)
                                //                                console.debug(emailTextField.isValid)

                                if (fullnameTextField.isNeedUpdate
                                        || usernameTextField.isNeedUpdate
                                        || passwordTextField.isNeedUpdate
                                        || emailTextField.isNeedUpdate
                                        || userLevelComboBox.isNeedUpdate) {

                                    if ((passwordTextField.length > 0) || (passwordConfirmTextField.length > 0)){
                                        if (!passwordTextField.isValid || !passwordConfirmTextField.isValid) {
                                            showDialogMessage(qsTr("Edit User"),
                                                              qsTr("There is invalid value!"),
                                                              dialogAlert)
                                            return
                                        }
                                    }

                                    if (!fullnameTextField.isValid
                                            || !usernameTextField.isValid
                                            || !emailTextField.isValid) {

                                        showDialogMessage(qsTr("Edit User"),
                                                          qsTr("There is invalid value!"),
                                                          dialogAlert)
                                        return
                                    }

                                    showBusyPage(qsTr("Please wait"))
                                    if (passwordTextField.isNeedUpdate){
                                        userManageQml.updateUserIncludePassword(
                                                    Qt.md5(passwordTextField.text),
                                                    usernameTextField.text,
                                                    userLevelComboBox.currentIndex + 1,
                                                    fullnameTextField.text,
                                                    emailTextField.text)
                                    }
                                    else {
                                        userManageQml.updateUserExcludePassword(
                                                    usernameTextField.text,
                                                    userLevelComboBox.currentIndex + 1,
                                                    fullnameTextField.text,
                                                    emailTextField.text)
                                    }
                                }
                                else {
                                    showDialogMessage(qsTr("Edit User"),
                                                      qsTr("There are no new values that need to updated!"),
                                                      dialogInfo)
                                }
                            }//
                        }//
                    }//
                }//
            }//
        }//

        UserManageQmlApp {
            id: userManageQml

            delayEmitSignal: 500 // ms

            onInitializedChanged: {
                delayEmitSignal = 1000 //ms
                closeDialog()
            }

            onUserUpdated: {
                if(!success) {
                    showDialogMessage(qsTr("Edit User"), qsTr("There is problem during editing user in database!"), dialogAlert)
                    return
                }

                showDialogMessage(qsTr("Edit User"), qsTr("User has updated successfully!"), dialogInfo,
                                  function onClosed(){
                                      var intent = IntentApp.create(uri, {"hiReload": true})
                                      finishView(intent)
                                  })
            }

            Component.onCompleted: {
                const connectionId = "UserEditFormPage"
                init(connectionId);

                showBusyPage(qsTr("Loading..."), function(seconds){
                    if (seconds === 10){
                        closeDialog()
                    }
                })
            }//
        }//

        // Put all private property inside here
        // if none, please comment this block to optimize the code
        QtObject {
            id: props

	    property int passwordMinimumLength: 5
            property string origin_fullname:   ""
            property string origin_email:      ""
            property string origin_username:   ""
            property int    origin_role:       0
        }//

        /// OnCreated
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

                const extradata = IntentApp.getExtraData(intent)

                const fullname  = extradata['fullname'] || ""
                const email     = extradata['email']    || ""
                const username  = extradata['username'] || ""
                const role      = extradata['role'] || 1

                initialText.text = fullname.substring(0,1)
                fullNameText.text = fullname

                fullnameTextField.text = fullname
                fullnameTextField.isValid = true

                emailTextField.text = email
                emailTextField.isValid = true

                usernameTextField.text = username
                usernameTextField.isValid = true

                userLevelComboBox.currentIndex = role - 1

                props.origin_fullname   = fullname
                props.origin_email      = email
                props.origin_username   = username
                props.origin_role       = role - 1
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
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/
