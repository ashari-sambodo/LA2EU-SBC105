import QtQuick 2.12
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import Qt.labs.platform 1.0

import UI.CusCom 1.1
import UI.CusCom.KeyboardOnScreen 1.0
import UI.CusCom.HeaderApp.Adapter 1.0

import "UI/CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 1024
    height: 600
    //    width: 800
    //    height: 480
    title: Qt.application.name + "-" + Qt.application.version
    color: "#000000"

    property int stackViewDepth: mainStackView.depth

    Item{
        id: mainItem
        anchors.fill: parent

        Image {
            id: backgroundImage
            source: "qrc:/UI/Pictures/Background-Blue.png"

            Loader {
                anchors.fill: parent
                active: MachineData.alarmsState
                sourceComponent: Rectangle {
                    id: backgroundOverlay
                    anchors.fill: parent
                    color: "red"
                    opacity: 0.7

                    /// blinking
                    SequentialAnimation {
                        running: true
                        loops: Animation.Infinite
                        ScriptAction {
                            script: {
                                backgroundOverlay.color = "red"
                                if(!MachineData.muteAlarmState) MachineAPI.setBuzzerState(1)
                            }//
                        }//

                        PauseAnimation {
                            duration: 2000
                        }//

                        ScriptAction {
                            script: {
                                backgroundOverlay.color = "black"
                                if(!MachineData.muteAlarmState) MachineAPI.setBuzzerState(0)
                            }//
                        }//

                        PauseAnimation {
                            duration: 1000
                        }//
                    }//

                    Component.onDestruction: {
                        MachineAPI.setBuzzerState(false)
                    }//
                }//
            }//
        }//

        StackViewApp {
            id: mainStackView
            anchors.fill: parent

            property string homeURL: UserSessionService.loggedIn ? "qrc:/UI/Pages/_HomePage/HomePage.qml" : "qrc:/UI/Pages/LoginPage/LoginPage.qml"

            Component.onCompleted: {
                var intent = IntentApp.create("qrc:/UI/Pages/__StartupPage/StartupPage.qml", {})
                mainStackView.push(intent.uri, {"uri": intent.uri, "intent": intent})
            }//

            Connections {
                target: mainStackView.currentItem

                function onStartView(newIntent) {
                    //                //console.debug("onStartView: " + newIntent)
                    //                //console.debug("onStartView-intent: " + newIntent.uri)
                    mainStackView.push(newIntent.uri, {"uri": newIntent.uri, "intent": newIntent})
                }

                function onStartRootView(newIntent) {
                    //                //console.debug("onstartRootView: " + newIntent)
                    //                //console.debug("onstartRootView-intent: " + newIntent.uri)

                    mainStackView.clear()
                    if(newIntent.uri === "") {
                        newIntent.uri = mainStackView.homeURL
                    }
                    mainStackView.push(newIntent.uri, {"uri": newIntent.uri,  "intent": newIntent})
                }//

                function onFinishView(intentResultFinishView) {
                    //                //console.debug("onFinishView: " + intentResultFinishView)
                    //                //console.debug("onFinishView-intent: " + intentResultFinishView.uri)
                    //                //console.debug("onFinishView-depth: " + mainStackView.depth)

                    if (intentResultFinishView.uri === mainStackView.currentItem.uri) {
                        if (mainStackView.depth > 1){
                            mainStackView.pop()
                            mainStackView.currentItem.finishViewReturned(intentResultFinishView)
                        } else {
                            var intentHome = IntentApp.create(mainStackView.homeURL, {})
                            mainStackView.replace(intentHome.uri, {"uri": intentHome.uri, "intent": intentHome})
                        }//
                    }//
                    else {
                        /// current page want to finished
                        /// but also want to open new page
                        mainStackView.replace(intentResultFinishView.uri, {"uri": intentResultFinishView.uri, "intent": intentResultFinishView})
                    }//
                }//
            }//
        }//
    }//

    ///Grab Screen
    Connections {
        target: HeaderAppService

        function onVendorLogoPressandHold(){
            if(UserSessionService.loggedIn){
                //console.log("Grab screen capture")
                mainItem.grabToImage(function(result) {
                    //let date = new Date()
                    //let dateTimeStr = Qt.formatDateTime(date, "yyyyMMddhhmmss")

                    //console.log("Grab result")
                    const appLocalDataLocation = StandardPaths.writableLocation(StandardPaths.AppLocalDataLocation)
                    //console.log("appDataLocation: " + appLocalDataLocation)
                    let fileName = appLocalDataLocation + "/screenpic.png"
                    if (__osplatform__) {
                        /// linux
                        fileName = fileName.replace("file://", "")
                        const res = result.saveToFile(fileName);
                        fileName = "file://" + fileName
                    }
                    else {
                        /// windows
                        fileName = fileName.replace("file:///C:", "c:")
                        const res = result.saveToFile(fileName);
                        fileName = "file:///" + fileName
                    }

                    console.log("Grab " + fileName)
                    //                console.log(res)
                    const intent = IntentApp.create("qrc:/UI/Pages/ScreenShootShowPage/ScreenShootShowPage.qml", {"filename": fileName})
                    mainStackView.push(intent.uri, {"uri": intent.uri, "intent": intent})
                });
            }
        }
    }

    /// User Session
    Connections {
        target: UserSessionService

        function onAskedForLogin(){
            //            //console.debug("onAskedForLogin")

            if (!UserSessionService.loggedIn) {
                const intent = IntentApp.create("qrc:/UI/Pages/LoginPage/LoginPage.qml", {})
                mainStackView.currentItem.startView(intent);
            }
            else {
                const intent = IntentApp.create("qrc:/UI/Pages/LoginPage/LoggedInPage.qml", {})
                mainStackView.currentItem.startView(intent);
            }
        }//
    }//

    /// Keyboard On Screen
    Loader {
        id: kosLoader
        anchors.fill: parent
        active: false
        visible: false
        asynchronous: true

        onLoaded: kosLoader.item.visible = true

        readonly property string urlKeyboard:   "qrc:/UI/CusCom/KeyboardOnScreen/KeyboardOnScreenApp.qml"
        readonly property string urlNumpad:     "qrc:/UI/CusCom/KeyboardOnScreen/NumpadOnScreenApp.qml"

        /// listen if any textfield want need onscreen keyboard
        Connections {
            target: KeyboardOnScreenCaller

            function onOpenKeyboardRequested() {

                MachineAPI.setFrontEndScreenState(MachineAPI.ScreenState_KeyboardOnScreen)
                //                //console.debug(KeyboardOnScreenCaller.title())
                //                //console.debug(KeyboardOnScreenCaller.targetTextInput().text)

                if (!kosLoader.active
                        || (kosLoader.source != kosLoader.urlKeyboard)) {
                    kosLoader.setSource(kosLoader.urlKeyboard, {
                                            "visible":       false,
                                            "title":         KeyboardOnScreenCaller.title(),
                                            "text":          KeyboardOnScreenCaller.targetTextInput().text,
                                            "echoMode":      KeyboardOnScreenCaller.targetTextInput().echoMode,
                                            "validator":     KeyboardOnScreenCaller.targetTextInput().validator,
                                            "maximumLength": KeyboardOnScreenCaller.targetTextInput().maximumLength,
                                        })
                    kosLoader.active = true
                }
                else {
                    kosLoader.item.title     = KeyboardOnScreenCaller.title()
                    kosLoader.item.text      = KeyboardOnScreenCaller.targetTextInput().text
                    kosLoader.item.echoMode  = KeyboardOnScreenCaller.targetTextInput().echoMode
                    kosLoader.item.validator = KeyboardOnScreenCaller.targetTextInput().validator
                    kosLoader.item.inputMask        = KeyboardOnScreenCaller.targetTextInput().inputMask
                    kosLoader.item.maximumLength    = KeyboardOnScreenCaller.targetTextInput().maximumLength
                }
                kosLoader.visible = true
            }

            function onOpenNumpadRequested() {
                MachineAPI.setFrontEndScreenState(MachineAPI.ScreenState_KeyboardOnScreen)
                //                //console.debug(KeyboardOnScreenCaller.title())
                //                //console.debug(KeyboardOnScreenCaller.targetTextInput().text)

                if (!kosLoader.active
                        || (kosLoader.source != kosLoader.urlNumpad)) {
                    //                    //console.debug(KeyboardOnScreenCaller.targetTextInput().text)
                    kosLoader.setSource(kosLoader.urlNumpad, {
                                            "visible":      false,
                                            "title":        KeyboardOnScreenCaller.title(),
                                            "text":         KeyboardOnScreenCaller.targetTextInput().text,
                                            "validator":    KeyboardOnScreenCaller.targetTextInput().validator,
                                        })
                    kosLoader.active = true
                }
                else {
                    kosLoader.item.title     = KeyboardOnScreenCaller.title()
                    kosLoader.item.text      = KeyboardOnScreenCaller.targetTextInput().text
                    kosLoader.item.validator = KeyboardOnScreenCaller.targetTextInput().validator
                    kosLoader.item.inputMask = KeyboardOnScreenCaller.targetTextInput().inputMask
                }
                kosLoader.visible = true
            }
        }//

        /// Return value from keyboard
        Connections{
            target: kosLoader.item

            function onHideClicked() {
                kosLoader.visible = false
                MachineAPI.setFrontEndScreenState(MachineData.frontEndScreenStatePrev)
            }

            function onEnterClicked(textValue) {
                KeyboardOnScreenCaller.targetTextInput().text = textValue
                KeyboardOnScreenCaller.targetTextInput().accepted()
                kosLoader.visible = false

                MachineAPI.setFrontEndScreenState(MachineData.frontEndScreenStatePrev)
            }
        }//

        /// Destroy Keyboard instance when page changed
        Connections{
            target: mainStackView

            function onCurrentItemChanged() {
                //                //console.debug("Connections-onCurrentItemChanged")
                if(kosLoader.active){
                    kosLoader.active = false
                }
            }
        }//

        /// show loading during load the object in background thread
        Loader {
            id: mainLoader
            anchors.fill: parent
            active: kosLoader.visible && kosLoader.status == Loader.Loading
            sourceComponent: Rectangle {
                color: "#77000000"

                BusyIndicatorApp {
                    anchors.centerIn: parent
                    playing: mainLoader.active
                    //                    height: 100
                    //                    width: 100
                }//

                /// Just for blocking the overlapping mouse area interaction
                MouseArea {
                    anchors.fill: parent
                }//
            }
        }//
    }//

    /// Gesture
    Loader {
        id: leftEdgeGesture
        enabled: mainStackView.currentItem ? mainStackView.currentItem.enabledSwipedFromLeftEdge : false
        active: enabled && !lockScreenLoader.active && MachineData.getSbcCurrentSerialNumberKnown()
        visible: active
        anchors.verticalCenter: parent.verticalCenter
        sourceComponent: Item {
            height: 70
            width: 40

            Rectangle{
                color: "#7f8c8d"
                radius: width
                height: 70
                width: 2
                anchors.verticalCenter: parent.verticalCenter
            }//

            SwipeAreaApp {
                anchors.fill: parent
                flickableDirection: Flickable.HorizontalFlick
                contentWidth: iconLeftRect.width
                contentHeight: iconLeftRect.height
                //                debugSwipe: true
                swipeOffset: 70

                Rectangle {
                    id: iconLeftRect
                    height: 70
                    width: 70
                    radius: 5
                    color: "#55000000"
                    x: -width

                    Image {
                        id: iconLeftImage
                        anchors.centerIn: parent
                        source: "qrc:/UI/Pictures/back-step.png"
                    }//
                }//

                onSwipeRight: {
                    if(mainStackView.busy) return

                    //                if (!lockScreenLoader.active) {
                    //                    //console.debug("mainStackView.currentItem.uri: " + mainStackView.currentItem.uri)
                    if(typeof mainStackView.currentItem.fnSwipedFromLeftEdge == "function"){
                        //                    //console.debug("fnGestureSwipedUp")
                        mainStackView.currentItem.fnSwipedFromLeftEdge()
                    }//
                    else if (mainStackView.depth > 1){
                        var intent = IntentApp.create(mainStackView.currentItem.uri, {})
                        mainStackView.currentItem.finishView(intent)
                    }//
                    //                }
                }
            }//
        }//
    }//
    ///
    Loader {
        id: rightEdgeGesture
        enabled: mainStackView.currentItem ? mainStackView.currentItem.enabledSwipedFromRightEdge : false
        active: enabled && !lockScreenLoader.active && MachineData.getSbcCurrentSerialNumberKnown()
        visible: active
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        sourceComponent: Item {
            height: 70
            width: 40

            Rectangle{
                color: "#7f8c8d"
                radius: width
                height: 70
                width: 2
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }

            SwipeAreaApp {
                anchors.fill: parent
                contentWidth: iconRightRect.width
                contentHeight: iconRightRect.height
                //                debugSwipe: true
                swipeOffset: 70

                Rectangle {
                    id: iconRightRect
                    height: 70
                    width: 70
                    radius: 5
                    color: "#55000000"
                    x: 70

                    Image {
                        id: iconRightImage
                        anchors.centerIn: parent
                        source: "qrc:/UI/Pictures/home-dashboard-icon-35px.png"
                    }//
                }//

                onSwipeLeft: {
                    if(mainStackView.busy) return

                    //                    //console.debug("mainStackView.currentItem.uri: " + mainStackView.currentItem.uri)
                    if (mainStackView.currentItem.uri === mainStackView.homeURL){
                        /// No Action
                    }
                    else if(typeof mainStackView.currentItem.fnSwipedFromRightEdge == "function"){
                        mainStackView.currentItem.fnSwipedFromRightEdge()
                    }//
                    else {
                        //                    var intent = IntentApp.create(mainStackView.homeURL, {"isPageAsPop": true})
                        var intent = IntentApp.create(mainStackView.homeURL, {})
                        mainStackView.currentItem.startView(intent)
                    }//
                }//
            }//
        }//
    }//
    ///
    Loader {
        id: bottomEdgeGesture
        enabled: mainStackView.currentItem ? mainStackView.currentItem.enabledSwipedFromBottomEdge : false
        active: enabled && !lockScreenLoader.active && MachineData.getSbcCurrentSerialNumberKnown()
        visible: active
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        sourceComponent: Item {
            height: 40
            width: 70
            //            Rectangle{
            //                anchors.fill: parent
            //            }
            Rectangle{
                color: "#7f8c8d"
                radius: width
                height: 5
                width: 70
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
            }//

            SwipeVAreaApp {
                anchors.fill: parent
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                contentWidth: iconBottomRect.width
                contentHeight: iconBottomRect.height
                //                debugSwipe: true
                swipeOffset: 70

                Rectangle {
                    id: iconBottomRect
                    height: 70
                    width: window.width
                    x: -(window.width / 2) + 35
                    radius: 5
                    color: "#55000000"
                    y: height

                    Image {
                        id: iconBottomImage
                        anchors.centerIn: parent
                        source: "qrc:/UI/Pictures/home-dashboard-icon-35px.png"
                    }//
                }//

                onSwipeUp: {
                    if(mainStackView.busy) return

                    //                    //console.debug("mainStackView.currentItem.uri: " + mainStackView.currentItem.uri)
                    if (mainStackView.currentItem.uri === mainStackView.homeURL){
                        /// No Action
                    }
                    else if(typeof mainStackView.currentItem.fnSwipedFromBottomEdge == "function"){
                        //                    //console.debug("fnGestureSwipedUp")
                        mainStackView.currentItem.fnSwipedFromBottomEdge()
                    }//
                    else {
                        //                    //console.debug("gestureSwipedUp")
                        //                        var intent = IntentApp.create(mainStackView.homeURL, {})
                        //                        mainStackView.currentItem.startRootView(intent)
                        mainStackView.clear()
                        const intent = IntentApp.create(mainStackView.homeURL, {})
                        mainStackView.push(intent.uri, {"uri": intent.uri,  "intent": intent})
                    }//
                }//
            }//
        }//
    }//
    ///
    Loader {
        id: topEdgeGesture
        enabled: mainStackView.currentItem ? mainStackView.currentItem.enabledSwipedFromTopEdge : false
        active: enabled && !lockScreenLoader.active && MachineData.getSbcCurrentSerialNumberKnown()
        visible: active
        anchors.horizontalCenter: parent.horizontalCenter
        sourceComponent: Item {
            height: 40
            width: 70

            Rectangle{
                color: "#7f8c8d"
                radius: width
                height: 2
                width: 70
                anchors.horizontalCenter: parent.horizontalCenter
            }//

            SwipeVAreaApp {
                anchors.fill: parent
                contentWidth: iconTopRect.width
                contentHeight: iconTopRect.height
                //                debugSwipe: true
                swipeOffset: 70

                Rectangle {
                    id: iconTopRect
                    height: 70
                    width: window.width
                    radius: 5
                    color: "#55000000"
                    y: -height
                    x: -(window.width / 2) + 35

                    Image {
                        id: iconTopImage
                        anchors.centerIn: parent
                        source: "qrc:/UI/Pictures/lock-icon-35px.png"
                    }//
                }//

                onSwipeBottom: {
                    if(mainStackView.busy) return
                    if (!lockScreenLoader.active) lockScreenLoader.active = true
                }//
            }//
        }//
    }//
    /// LockScreen
    Loader {
        id: lockScreenLoader
        anchors.fill: parent
        active: false
        sourceComponent: Item {
            id: backgroundLockRectangle

            Flickable{
                anchors.fill: parent
                flickableDirection: Flickable.VerticalFlick

                onSwipeUp: {
                    lockScreenLoader.active = false
                }

                signal swipeUp()
                signal swipeBottom()

                property int swipeOffset: 100
                property bool swiped: false

                onVerticalOvershootChanged: {
                    if((verticalOvershoot > 0)
                            && (verticalOvershoot > swipeOffset)
                            && !swiped){
                        //                        //console.debug("swipe up")
                        swiped = true
                        swipeUp()
                    }

                    if((verticalOvershoot < 0)
                            && (verticalOvershoot < -swipeOffset)
                            && !swiped){
                        //                        //console.debug("swipe bottom")
                        swiped = true
                        swipeBottom()
                    }
                    if((verticalOvershoot == 0) && (swiped)) swiped = false
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        lockScreenBackgroundRect.visible = true
                        delayToOpenScreenSaverLoader.active = false
                        backgroundlLockTimer.restart()
                    }
                }

                Rectangle {
                    id: lockScreenBackgroundRect
                    visible: false
                    anchors.fill: parent
                    color: "#aa000000"

                    Column {
                        anchors.centerIn: parent
                        spacing: 5

                        Image {
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: "qrc:/UI/Pictures/lock-screen-icon.png"
                        }

                        TextApp {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Slide up to unlock!")
                        }//
                    }//
                }//
            }//

            Component.onCompleted: {
                lockScreenBackgroundRect.visible = true
                backgroundlLockTimer.start()

                mainStackView.currentItem.screenLocked(true)
            }//

            Component.onDestruction: {
                mainStackView.currentItem.screenLocked(false)
            }//

            Timer {
                id: backgroundlLockTimer
                interval: 5000
                onTriggered: {
                    lockScreenBackgroundRect.visible = false
                    delayToOpenScreenSaverLoader.active = true
                }//
            }//

            ///Open screen saver page after LCD Dimmed if all
            Loader {
                id: delayToOpenScreenSaverLoader
                active: false
                sourceComponent: Timer {
                    id: delayToOpenScreenSaverTimer
                    //interval: 5000
                    interval: MachineData.screenSaverSeconds * 1000 /// auto log out after 30 minutes if there is no interuption condition
                    running: true
                    onTriggered: {
                        //                        console.log("delayToOpenScreenSaverLoader")
                        /// except the following condition

                        if(MachineData.operationMode === MachineAPI.MODE_OPERATION_MAINTENANCE){
                            //                console.log("MachineData.operationMode")
                            return
                        }
                        if(mainStackView.currentItem.uri !== mainStackView.homeURL){
                            mainStackView.clear()
                            const intent = IntentApp.create(mainStackView.homeURL, {})
                            mainStackView.push(intent.uri, {"uri": intent.uri,  "intent": intent})

                            delayToOpenScreenSaverTimer.restart();
                            return
                        }
                        if(MachineData.alarmsState){
                            //                console.log("MachineData.alarmsState")
                            return
                        }
                        if(MachineData.warmingUpActive){
                            //                console.log("MachineData.warmingUpActive")
                            return
                        }
                        if (MachineData.uvState) {
                            //                console.log("MachineData.uvState")
                            return
                        }
                        if (ExperimentTimerService.isRunning) {
                            //                console.log("ExperimentTimerService.isRunning")
                            return
                        }
                        if (!MachineData.airflowCalibrationStatus && (MachineData.fanPrimaryState || MachineData.fanPrimaryState)) {
                            //                console.log("MachineData.airflowCalibrationStatus")
                            return
                        }
                        if (mainStackView.currentItem.ignoreScreenSaver) {
                            //                console.log("mainStackView.currentItem.ignoreScreenSave")
                            return
                        }

                        mainStackView.clear()
                        const intent = IntentApp.create("qrc:/UI/Pages/ScreenSaverPage/ScreenSaverPage.qml", {})
                        mainStackView.push(intent.uri, {"uri": intent.uri,  "intent": intent})

                        delayToOpenScreenSaverLoader.active = false
                    }//
                }//
            }//
        }//
    }//

    Loader{
        id: svnUpdateLoader
        enabled: UserSessionService.roleLevel >= UserSessionService.roleLevelFactory
        width: parent.width
        height: 110
        anchors.bottomMargin: 5
        anchors.bottom: parent.bottom
        clip: true
        active: false
        sourceComponent: Rectangle{
            id: svnUpdateRect
            y: svnUpdateLoader.height
            width: svnUpdateLoader.width
            height: svnUpdateLoader.height
            color: "#BB0F2952"
            border.width: 1
            border.color: "#BB777777"
            radius: 5

            property bool showState: false

            TextApp {
                width: parent.width
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("New Software update is available on SVN server.") + "<br>"
                      + (!svnUpdateLoader.enabled ? qsTr("To update, please Login as factory, then go to Software Update!")
                                                  : qsTr("To update, please go to Software Update page!"))

            }//

            Timer{
                id: svnRectTimer
                interval: 50
                repeat: true
                running: true
                onTriggered: {
                    //console.debug("onTriggered!!!")
                    if(svnUpdateRect.y > 0 && !svnUpdateRect.showState){
                        svnUpdateRect.y = svnUpdateRect.y - 5
                    }else if(svnUpdateRect.y < svnUpdateLoader.height && svnUpdateRect.showState){
                        svnUpdateRect.y = svnUpdateRect.y + 5
                    }
                    else{
                        const temp = svnUpdateRect.showState
                        svnUpdateRect.showState = !svnUpdateRect.showState;
                        running = false
                        if(temp) svnUpdateLoader.active = false
                    }
                }
            }

            MouseArea{
                anchors.fill: parent
                preventStealing: true
                onClicked: {
                    //svnUpdateRect.y = svnUpdateLoader.height
                    svnRectTimer.running = true
                }
            }
        }
        //onActiveChanged: console.debug("Active:", active)
    }//

    Loader{
        id: expTimeoutLoader
        enabled: UserSessionService.roleLevel > UserSessionService.roleLevelGuest
        width: parent.width
        height: 110
        anchors.bottomMargin: 5
        anchors.bottom: parent.bottom
        clip: true
        active: false
        sourceComponent: Rectangle{
            id: expTimeoutRect
            y: expTimeoutLoader.height
            width: expTimeoutLoader.width
            height: expTimeoutLoader.height
            color: "#BB0F2952"
            border.width: 1
            border.color: "#BB777777"
            radius: 5

            property bool showState: false

            TextApp {
                width: parent.width
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("The experiment timer has been completed!") + "<br>"
                      + (!expTimeoutLoader.enabled ? qsTr("Login and Press this notification to acknowledge.")
                                                   : qsTr("Press this notification to acknowledge."))

            }//

            Timer{
                id: expTimeoutRectTimer
                interval: 50
                repeat: true
                running: true
                onTriggered: {
                    //console.debug("onTriggered!!!")
                    if(expTimeoutRect.y > 0 && !expTimeoutRect.showState){
                        expTimeoutRect.y = expTimeoutRect.y - 5
                    }else if(expTimeoutRect.y < expTimeoutLoader.height && expTimeoutRect.showState){
                        expTimeoutRect.y = expTimeoutRect.y + 5
                    }
                    else{
                        const temp = expTimeoutRect.showState
                        expTimeoutRect.showState = !expTimeoutRect.showState;
                        running = false
                        if(temp) expTimeoutLoader.active = false
                    }
                }
            }

            MouseArea{
                anchors.fill: parent
                preventStealing: true
                onClicked: {
                    //expTimeoutRect.y = expTimeoutLoader.height
                    expTimeoutRectTimer.running = true
                    ExperimentTimerService.timeout = false
                    MachineAPI.setAlarmExperimentTimerIsOver(MachineAPI.ALARM_NORMAL_STATE)
                }
            }
        }
        //onActiveChanged: console.debug("Active:", active)
    }//

    Loader{
        id: usbNotifLoader
        enabled: UserSessionService.roleLevel == UserSessionService.roleLevelAdmin
        width: 655//parent.width
        height: 50
        anchors.bottomMargin: MachineData.frontEndScreenState === MachineAPI.ScreenState_Home ? 120 : 80
        anchors.bottom: parent.bottom
        //anchors.centerIn: parent
        anchors.horizontalCenter: parent.horizontalCenter
        clip: true
        active: false

        property string text: ""

        sourceComponent: Rectangle {
            id: usbNotifRect
            y: usbNotifLoader.height
            width: usbNotifLoader.width
            height: usbNotifLoader.height
            color: "#BB0F2952"
            opacity: 0.95
            border.width: 1
            border.color: "#BB777777"
            radius: 5

            property bool showState: false

            TextApp {
                width: parent.width
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: usbNotifLoader.text
            }//

            Timer {
                id: autocloseTimer1
                interval: 2000
                running: usbNotifLoader.active
                onTriggered: {
                    running = false
                    usbNotifTimer.running = true
                }//
            }//

            Timer{
                id: usbNotifTimer
                interval: 50
                repeat: true
                running: true
                onTriggered: {
                    //console.debug("onTriggered!!!")
                    if(usbNotifRect.y > 0 && !usbNotifRect.showState){
                        usbNotifRect.y = usbNotifRect.y - 5
                    }else if(usbNotifRect.y < usbNotifLoader.height && usbNotifRect.showState){
                        usbNotifRect.y = usbNotifRect.y + 5
                    }
                    else{
                        const temp = usbNotifRect.showState
                        usbNotifRect.showState = !usbNotifRect.showState;
                        running = false
                        if(temp) usbNotifLoader.active = false
                    }
                }
            }//

            MouseArea{
                anchors.fill: parent
                preventStealing: true
                onClicked: {
                    //svnUpdateRect.y = svnUpdateLoader.height
                    usbNotifTimer.running = true
                }
            }

            Timer{
                id: usbNotifRemovePopupTimer
                interval: 3000
                repeat: true
                running: true
                onTriggered: {
                    usbNotifTimer.running = true
                    running = false
                }//
            }//

            Component.onCompleted: {
                usbNotifRemovePopupTimer.running = true
            }//
        }//
        //            onActiveChanged: {
        //                removeEjectPopupTimer.running = true
        //            }
    }//

    //// Touch or Mouse pressed indicator
    //// Show circle item on the touched/pressed point
    TapIndicatorApp {
        id: tapIndicatorItem
        anchors.fill: parent

        onPressed: {
            mainStackView.currentItem.screenPressed()
            MachineAPI.setLcdTouched();
        }//
    }//

    /// Monitor All Keys Event from Keyboard
    TextInput {
        id: globalTextInput
        enabled: (MachineData.frontEndScreenState === MachineAPI.ScreenState_ReplaceableComponent
                 || MachineData.frontEndScreenState === MachineAPI.ScreenState_SerialNumber)
        visible: false
        focus: false

        Connections{
            target: tapIndicatorItem
            function onPressed(){
                if(globalTextInput.enabled){
                    globalTextInput.focus = true
                    console.debug("globalTextInput.focus = true")
                }
                else{
                    if(globalTextInput.focus){
                        globalTextInput.focus = false
                        console.debug("globalTextInput.focus = false")
                    }//
                }//
            }//
        }//
        /// onFocusChanged: console.debug("FOCUSED CHANGED !!!!!!!!!", focus)
        onAccepted: {
            MachineAPI.setKeyboardStringOnAcceptedEvent(text)
            //            console.debug("Text Generated:", text)
            globalTextInput.clear()
            //            console.debug("Text Cleared:", text)
        }//
        //        Keys.onPressed: {
        //            if(Number(event.key) == Number(Qt.Key_Down))
        //                accepted()
        //            //console.log("Key="+event.key+" "+event.text);
        //        }
        Keys.onReleased: {
            if(Number(event.key) == Number(Qt.Key_Down))
                accepted()
            //console.log("Key="+event.key+" "+event.text);
        }
        //        Component.onCompleted: {

        //        }
    }//


    QtObject{
        id: props

        property bool lcdBacklightDimmed: MachineData.lcdBrightnessLevelDimmed

        function showSvnUpdateAvailable(newAvailable){
            if(!newAvailable || (MachineData.machineState != MachineAPI.MACHINE_STATE_LOOP))return
            svnUpdateLoader.active = true;
        }//
        function showExpTimeoutLoader(status){
            if(status !== MachineAPI.ALARM_ACTIVE_STATE || (MachineData.machineState != MachineAPI.MACHINE_STATE_LOOP))return
            expTimeoutLoader.active = true;
        }//

        function usbHasMounted(name){
            console.debug("USB Has Mounted")
            //            usbName = name
            const text = qsTr("USB drive \"%1\" has been detected").arg(name)
            usbNotifLoader.text = text
            usbNotifLoader.active = true
        }//

        function usbHasEjected(name){
            console.debug("USB Has Ejected")
            //            usbName = name
            const text = qsTr("The \"%1\" can now be safely remove from the cabinet").arg(name)
            usbNotifLoader.text = text
            usbNotifLoader.active = true
        }//

        function globalTextInputEnableFocus(screenState){
            if(screenState === MachineAPI.ScreenState_ReplaceableComponent
                             || screenState === MachineAPI.ScreenState_SerialNumber)
                globalTextInput.focus = true
            else
                globalTextInput.focus = false
        }

        onLcdBacklightDimmedChanged: {
            //        console.debug("onLcdBacklightDimmedChanged: " + lcdBacklightDimmed)
            if(lcdBacklightDimmed && !lockScreenLoader.active && MachineData.getSbcCurrentSerialNumberKnown()) {
                lockScreenLoader.active = true
            }
        }

        Component.onCompleted: {
            MachineData.svnUpdateAvailableChanged.connect(props.showSvnUpdateAvailable)
            MachineData.alarmExperimentTimerIsOverChanged.connect(props.showExpTimeoutLoader)
            MachineData.usbHasMounted.connect(props.usbHasMounted)
            MachineData.usbHasEjected.connect(props.usbHasEjected)

            MachineData.frontEndScreenStateChanged.connect(props.globalTextInputEnableFocus)
        }
    }//
}//

/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}
}
##^##*/
