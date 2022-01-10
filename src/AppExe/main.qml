import QtQuick 2.12
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import Qt.labs.platform 1.0

import UI.CusCom 1.0
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

            property string homeURL: "qrc:/UI/Pages/_HomePage/HomePage.qml"

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
            }

            function onEnterClicked(textValue) {
                KeyboardOnScreenCaller.targetTextInput().text = textValue
                KeyboardOnScreenCaller.targetTextInput().accepted()
                kosLoader.visible = false
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
            anchors.fill: parent
            active: kosLoader.visible && kosLoader.status == Loader.Loading
            sourceComponent: Rectangle {
                color: "#77000000"

                BusyIndicatorApp {
                    anchors.centerIn: parent
                    height: 100
                    width: 100
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
                x: -(window.width / 2) + 35

                Rectangle {
                    id: iconTopRect
                    height: 70
                    width: 70
                    radius: 5
                    color: "#55000000"
                    y: -height

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
                    interval: 1800000 /// auto log out after 30 minutes if there is no interuption condition
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

    property bool lcdBacklightDimmed: MachineData.lcdBrightnessLevelDimmed
    onLcdBacklightDimmedChanged: {
        //        console.debug("onLcdBacklightDimmedChanged: " + lcdBacklightDimmed)
        if(lcdBacklightDimmed && !lockScreenLoader.active && MachineData.getSbcCurrentSerialNumberKnown()) {
            lockScreenLoader.active = true
        }
    }
}//

/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}
}
##^##*/
