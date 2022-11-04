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

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Seas Alarm Set Point"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: Item{
        id: contentView
        height: viewApp.height
        width: viewApp.width

        StackViewApp {
            id: stackView
            anchors.fill: parent

            Component.onCompleted: {
                var intent = IntentApp.create("qrc:/UI/Pages/SeasAlarmSetPointPage/_GettingStartedSeasAlarmPage.qml", {})
                stackView.push(intent.uri, {"uri": intent.uri, "intent": intent})
            }

            Connections{
                target: stackView.currentItem

                function onStartView(newIntent) {
                    //                //console.debug("onStartView: " + newIntent)
                    //                //console.debug("onStartView-intent: " + newIntent.uri)
                    stackView.push(newIntent.uri, {"uri": newIntent.uri, "intent": newIntent})
                }

                function onStartRootView(newIntent) {
                    //                //console.debug("onstartRootView: " + newIntent)
                    //                //console.debug("onstartRootView-intent: " + newIntent.uri)

                    if (stackView.depth > 1){
                        stackView.pop(null)
                    }

                    if (stackView.currentItem.uri !== newIntent.uri){
                        stackView.replace(newIntent.uri, {"uri": newIntent.uri,  "intent": newIntent})
                    } else {
                        /// IF LAST CURENT ITEM IS THE SAME WITH TARGET URI
                        /// DON'T RELOAD
                        /// put object intent from previous page to current page
                        /// in case the current view needs onViewResult
                        stackView.currentItem.intent = newIntent;
                    }
                }

                function onFinishView(intentResultFinishView) {
                    if (intentResultFinishView.uri === stackView.currentItem.uri) {
                        if (stackView.depth > 1){
                            stackView.pop()
                            stackView.currentItem.finishViewReturned(intentResultFinishView)
                            //                            stackView.pop()
                            //                            stackView.currentItem.intentResultFinishView = intentResultFinishView
                        } else {
                            /// Back to Main Menu
                            let intent = IntentApp.create(uri, {})
                            finishView(intent)
                        }
                    }
                    else {
                        /// current page want to finished
                        /// but also want to open new page
                        stackView.replace(intentResultFinishView.uri, {"uri": intentResultFinishView.uri, "intent": intentResultFinishView})
                    }//
                }//
            }//
        }//

        QtObject {
            id: props

            property string pgStart: "qrc:/UI/Pages/SeasAlarmSetPointPage/_GettingStartedSeasAlarmPage.qml"
            property string pgEnd: "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/_FinishCalibratePage.qml"

            function confirmBackToClose(){
                const currentPage = stackView.currentItem.uri
                if ((currentPage === props.pgStart) || (currentPage === props.pgEnd)) {
                    /// Back to Main Menu
                    let intent = IntentApp.create(uri, {})
                    finishView(intent)
                }
                else {
                    const message = qsTr("Exit from sensor calibration?")
                    let executed = false
                    showDialogAsk(qsTr(title),
                                  message,
                                  dialogAlert,
                                  function onAccepted(){
                                      showBusyPage(qsTr("Please wait"),
                                                   function onCallback(cycle){
                                                       if(cycle === MachineAPI.BUSY_CYCLE_1 && !executed) {
                                                           //                                                           MachineAPI.setOperationMode(props.operationModeBackup)
                                                           MachineAPI.setOperationPreviousMode()
                                                           executed = true
                                                       }
                                                       if(cycle === MachineAPI.BUSY_CYCLE_2) {
                                                           /// Back to Main Menu
                                                           let intent = IntentApp.create(uri, {})
                                                           finishView(intent)
                                                       }
                                                   })
                                  })
                }
            }
        }//

        /// called Once but after onResume
        Component.onCompleted: {
            /// override gesture swipe action
            /// basicly dont allow gesture shortcut to home page during calibration
            viewApp.fnSwipedFromLeftEdge = function(){
                props.confirmBackToClose()
            }

            viewApp.fnSwipedFromBottomEdge = function(){
                const currentPage = stackView.currentItem.uri
                if ((currentPage === props.pgStart) || (currentPage === props.pgStart)) {
                    /// Back to Main Menu
                    let intent = IntentApp.create(uri, {})
                    finishView(intent)
                }
                else {
                    const message = qsTr("Exit from sensor calibration?")
                    let executed = false
                    showDialogAsk(qsTr(title),
                                  message,
                                  dialogAlert,
                                  function onAccepted() {
                                      showBusyPage(qsTr("Please wait"),
                                                   function onCallback(cycle){
                                                       if(cycle === MachineAPI.BUSY_CYCLE_1 && !executed) {
                                                           //                                                           MachineAPI.setOperationMode(props.operationModeBackup)
                                                           MachineAPI.setOperationPreviousMode()
                                                           MachineAPI.setInflowSensorConstantTemporary(MachineData.getInflowSensorConstant())
                                                           executed = true
                                                       }
                                                       if(cycle >= MachineAPI.BUSY_CYCLE_2) {
                                                           const intent = IntentApp.create("", {})
                                                           startRootView(intent)
                                                       }
                                                   })
                                  })
                }
            }
        }//

        /// Execute This Every This Screen Active/Visible
        Loader {
            active: viewApp.stackViewStatusForeground
            sourceComponent: QtObject {

                /// onResume
                Component.onCompleted: {
                    //                    //console.debug("StackView.Active");
                }

                /// onPause
                Component.onDestruction: {
                    ////console.debug("StackView.DeActivating");
                }
            }//
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.5;height:480;width:800}
}
##^##*/
