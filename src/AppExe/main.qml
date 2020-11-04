import QtQuick 2.12
import QtQuick.Window 2.2
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import UI.CusCom.KeyboardOnScreen 1.0

import "UI/CusCom/JS/IntentApp.js" as IntentApp

import modules.cpp.machine 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 1024
    height: 600
    //    width: 800
    //    height: 480
    title: Qt.application.name + "-" + Qt.application.version
    color: "#000000"

    background: Image {
        id: backgroundImage
        source: "/UI/Pictures/Background-Blue.png"

        Loader {
            anchors.fill: parent
            active: MachineData.alarmDownflowHigh
                    || MachineData.alarmDownflowLow
                    || MachineData.alarmInflowLow
                    || MachineData.alarmSashUnsafe
                    || MachineData.alarmSashError
            sourceComponent: Rectangle {
                id: backgroundOverlay
                anchors.fill: parent
                color: "red"
                opacity: 0.6

                /// blinking
                SequentialAnimation {
                    running: true
                    loops: Animation.Infinite
                    ScriptAction {
                        script: {
                            backgroundOverlay.color = "red"
                        }//
                    }//

                    PauseAnimation {
                        duration: 2000
                    }//

                    ScriptAction {
                        script: {
                            backgroundOverlay.color = "black"
                        }
                    }//

                    PauseAnimation {
                        duration: 1000
                    }//
                }//
            }//
        }//
    }

    StackViewApp {
        id: mainStackView
        anchors.fill: parent

        property string homeURL: "/UI/Pages/HomePage/HomePage.qml"

        initialItem: "/UI/Pages/StartupPage/StartupPage.qml"

        Connections{
            target: mainStackView.currentItem

            function onStartView(newIntent) {
                //                console.log("onStartView: " + newIntent)
                //                console.log("onStartView-intent: " + newIntent.uri)
                mainStackView.push(newIntent.uri, {"uri": newIntent.uri, "intent": newIntent})
            }

            function onStartRootView(newIntent) {
                //                console.log("onstartRootView: " + newIntent)
                //                console.log("onstartRootView-intent: " + newIntent.uri)

                if (mainStackView.depth > 1){
                    mainStackView.pop(null)
                }

                /// IF LAST CURENT ITEM IS THE SAME WITH TARGET URI
                /// DON'T RELOAD
                if (mainStackView.currentItem.uri !== newIntent.uri){
                    mainStackView.replace(newIntent.uri, {"uri": newIntent.uri,  "intent": newIntent})
                } else {
                    /// put object intent from previous page to current page
                    /// in case the current view needs onViewResult
                    mainStackView.currentItem.intent = newIntent;
                }
            }

            function onFinishView(newIntent) {
                //                console.log("onFinishView: " + newIntent)
                //                console.log("onFinishView-intent: " + newIntent.uri)
                //                console.log("onFinishView-depth: " + mainStackView.depth)
                if (mainStackView.depth > 1){
                    mainStackView.pop()
                    mainStackView.currentItem.intent = newIntent
                } else {
                    var intentHome = IntentApp.create(mainStackView.homeURL, {})
                    mainStackView.replace(intentHome.uri, {"uri": intentHome.uri, "intent": intentHome})
                }
            }

            function onOpenKeyboard(title) {
                //                console.log("onOpenKeyboard")
                keyboardOnScreenLoader.open(title)
                //                numpadOnScreenLoader.open()
            }

            function onOpenNumpad(title) {
                //                console.log("onOpenNumpad")
                keyboardOnScreenLoader.openNumpad(title)
            }
        }
    }

    /// Keyboard On Screen
    Loader {
        id: keyboardOnScreenLoader
        anchors.fill: parent
        active: false
        visible: false
        asynchronous: true
        sourceComponent: {}

        /// QWERTY Keyboard
        Component {
            id: keyboardOnScreenComponent

            KeyboardOnScreenApp {
                id: keyboardOnScreenApp
                //                visible: false
                //                anchors.fill: parent
                visible: keyboardOnScreenLoader.visible
                         && (keyboardOnScreenLoader.status == Loader.Ready)

                onVisibleChanged: {
                    if(visible){
                        title       = keyboardOnScreenLoader.title
                        text        = mainStackView.currentItem.textInputTarget.text
                        echoMode    = mainStackView.currentItem.textInputTarget.echoMode
                        validator   = mainStackView.currentItem.textInputTarget.validator
                    }
                }

                onHideClicked: {
                    keyboardOnScreenLoader.visible = false
                }

                onEnterClicked: {
                    try{
                        mainStackView.currentItem.funcOnKeyboardEntered(textValue)
                    } catch (e){
                        /// ignore error
                    }
                    mainStackView.currentItem.textInputTarget.accepted()
                    keyboardOnScreenLoader.visible = false
                }

                //                Component.onCompleted: {
                //                    visible = true
                //                }

                Component.onDestruction: {
                    //                console.log("keyboardOnScreenApp-onDestruction")
                }
            }
        }//

        /// Numpad Keyboard
        Component {
            id: numpadOnScreenComponent

            NumpadOnScreenApp {
                id: numpadOnScreenApp
                //                visible: false
                //                anchors.fill: parent
                visible: keyboardOnScreenLoader.visible
                         && (keyboardOnScreenLoader.status == Loader.Ready)

                onVisibleChanged: {
                    if(visible){
                        title       = keyboardOnScreenLoader.title
                        text        = mainStackView.currentItem.textInputTarget.text
                        validator   = mainStackView.currentItem.textInputTarget.validator
                    }
                }

                onHideClicked: {
                    keyboardOnScreenLoader.visible = false
                }

                onEnterClicked: {
                    try{
                        mainStackView.currentItem.funcOnKeyboardEntered(textValue)
                    } catch (e){
                        /// ignore error
                    }
                    mainStackView.currentItem.textInputTarget.accepted()
                    keyboardOnScreenLoader.visible = false
                }

                //                Component.onCompleted: {
                //                    visible = true
                //                }

                Component.onDestruction: {
                    //                console.log("keyboardOnScreenApp-onDestruction")
                }
            }
        }//

        function open(titlefield) {

            keyboardOnScreenLoader.sourceComponent = keyboardOnScreenComponent

            title = titlefield
            if(!active) active = true
            if(!visible) visible = true
        }

        function openNumpad(titlefield){

            keyboardOnScreenLoader.sourceComponent = numpadOnScreenComponent

            title = titlefield
            if(!active) active = true
            if(!visible) visible = true
        }

        /// TextField title text
        property string title: ""

        /// Busy Load Indicator
        BusyIndicatorApp {
            anchors.centerIn: parent
            height: 100
            width: 100
            fillMode: Image.PreserveAspectFit
            visible: keyboardOnScreenLoader.status == Loader.Loading
        }

        /// Destroy Keyboard instance when page changed
        Connections{
            target: mainStackView

            function onCurrentItemChanged() {
                //                console.log("Connections-onCurrentItemChanged")
                if(keyboardOnScreenLoader.active){
                    keyboardOnScreenLoader.active = false
                }
            }
        }
    }


    /// Touch or Mouse pressed indicator
    /// Show circle item on the touched/pressed point
    TapIndicatorApp {
        id: tapIndicatorItem
        anchors.fill: parent

        //        states: [
        //            State {
        //                when: controlDrawer.visible
        //                PropertyChanges {
        //                    target: tapIndicatorItem
        //                    parent: controlDrawer.contentItem
        //                }
        //            }
        //        ]
    }
}
