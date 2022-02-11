/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import UserManageQmlApp 1.0

import ModulesCpp.Connectify 1.0
import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Startup"

    property int loopCycle: 0

    signal progressBarHasFull()
    onProgressBarHasFull: {
        /// Setup
        /// Header
        /// Cabinet model name
        HeaderAppService.modelName = MachineData.machineClassName + "<br>" + MachineData.machineModelName
        //        HeaderAppService.modelName = "CLASS II C1" + "<br>" + "LC1"
        //        HeaderAppService.modelName = "CLASS II A2" + "<br>" + "AC2"
        /// Set time format, 12h or 24h
        HeaderAppService.timePeriod = MachineData.timeClockPeriod
        /// Alarm/Warning/Info Notification
        MachineData.alarmsStateChanged.connect(HeaderAppService.setAlert)
        /// The following sytax is to disconnect connection
        //        MachineData.alarmsStateChanged.disconnect(HeaderAppService.setAlert)

        /// set user interface language
        /// example expected /// example en#0#English
        let langCode = MachineData.language.split("#")[0]
        TranslatorText.selectLanguage(langCode);

        NetworkService.init()
        let intent
        /// Decide next landing page
        //        const intent = IntentApp.create("qrc:/UI/Pages/CertificationShortCut/CertificationShortCut.qml", {})
        //        const intent = IntentApp.create("qrc:/UI/Pages/FullCalibrateSensorPage/FullCalibrateSensorPage.qml", {})
        //        const intent = IntentApp.create("qrc:/UI/Pages/AuxiliaryFunctionsPage/AuxiliaryFunctionsPage.qml", {})
        //        const intent = IntentApp.create("qrc:/UI/Pages/LeavePage/LeavePage.qml", {})
        //        const intent = IntentApp.create("qrc:/UI/Pages/CabinetProfilePage/CabinetProfilePage.qml", {})
        //        const intent = IntentApp.create("qrc:/UI/Pages/UserManagePage/UserManagePage.qml", {})
        //        const intent = IntentApp.create("qrc:/UI/Pages/CertificationReportPage/CertificationReportPage.qml", {"message":""})
        //        const intent = IntentApp.create("qrc:/UI/Pages/DataLogPage/DataLogSettingPage.qml", {})
        //        const intent = IntentApp.create("qrc:/UI/Pages/SerialNumberSetPage/SerialNumberSetPage.qml", {})
        //        const intent = IntentApp.create("qrc:/UI/Pages/ManualInputDataPage/GettingManualInputDataPage.qml", {})
        //        const intent = IntentApp.create("qrc:/UI/Pages/ResetParametersPage/ResetParametersPage.qml", {})

        if(MachineData.getSbcCurrentSerialNumberKnown()){
            intent = IntentApp.create("qrc:/UI/Pages/LoginPage/LoginPage.qml", {})
            if (MachineData.shippingModeEnable)
                intent = IntentApp.create("qrc:/UI/Pages/InstallationWizardPage/InstallationWizardPage.qml", {})
        }else{
            intent = IntentApp.create("qrc:/UI/Pages/SoftwareFailedStartPage/SoftwareFailedStartPage.qml", {})
        }
        startRootView(intent)
    }

    background.sourceComponent: Item {}

    content.active: true
    content.sourceComponent: ContentItemApp{
        id: contentView
        height: viewApp.height
        width: viewApp.width

        Column {
            anchors.centerIn: parent
            spacing: 20

            Image{
                source: "qrc:/UI/Pictures/logo/esco_lifesciences_group_white.png"
            }//

            ProgressBar{
                id: startupProgressBar
                anchors.horizontalCenter: parent.horizontalCenter

                background: Rectangle {
                    implicitWidth: 512
                    implicitHeight: 10
                    radius: 5
                    clip: true
                }//

                contentItem: Item {
                    implicitWidth: 250
                    implicitHeight: 10

                    Rectangle {
                        width: startupProgressBar.visualPosition * parent.width
                        height: parent.height
                        radius: 5
                        color: "#18AA00"
                    }//
                }//

                Behavior on value {
                    SequentialAnimation {
                        PropertyAnimation {
                            duration: 1000
                        }//
                        ScriptAction {
                            script: {
                                /// Progress
                                if(startupProgressBar.value === 1.0) {
                                    viewApp.progressBarHasFull()
                                }//
                            }//
                        }//
                    }//
                }//
            }//
        }//

        //// Put all private property inside here
        //// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property var profileObjectActive: null
        }

        //        /// Execute This Every This Screen Active/Visible
        //        Loader {
        //            active: viewApp.stackViewStatusForeground
        //            sourceComponent: QtObject {

        //                /// onResume
        //                Component.onCompleted: {
        //                    //                    //console.debug("StackView.Active");

        //                    //                    slider.value = MachineData.lightIntensity
        //                }//

        //                /// onPause
        //                Component.onDestruction: {
        //                    ////console.debug("StackView.DeActivating");
        //                }//
        //            }//
        //        }//

        CabinetProfilesApp {
            id: cabinetProfiles
        }//

        Settings {
            id: settings

            property string machProfId: "NONE"
        }//

        /// Ensure super admin has created
        UserManageQmlApp {
            id: userManageQml

            property bool superAdminStatus: false
            onSuperAdminHasInitialized: {
                //                console.log(success)
                //                console.log(status)
                superAdminStatus = true
            }//

            onInitializedChanged: {
                initDefaultUserAccount()
            }//
        }//

        /// Event by Timer
        Timer {
            id: eventTimer
            interval: 1000
            //            running: true
            repeat: true
            onTriggered: {
                loopCycle = loopCycle + 1

                if(loopCycle == 1){
                    MachineData.initSingleton()
                    MachineAPI.initSingleton()

                    startupProgressBar.value = 0.3
                }//

                if(loopCycle == 2){

                    //// Query current active machine profile
                    let profileIdActive = settings.machProfId
                    if(profileIdActive !== "NONE") {
                        for (const profileObj of cabinetProfiles.profiles) {
                            if (profileIdActive === profileObj['profilelId']){
                                //                                //console.debug("Found")
                                props.profileObjectActive = profileObj;
                                break;
                            }//
                        }//
                    }//

                    if(props.profileObjectActive === null){
                        /// Go to cabinetProfiles selection

                        ///stop this eventTime then open next page
                        eventTimer.stop()

                        /// Decide next page decision
                        var intent = IntentApp.create("qrc:/UI/Pages/CabinetProfilePage/CabinetProfilePage.qml", {})
                        startRootView(intent)
                    }
                    else {
                        //// Go to next phase machine startup task
                        MachineData.machineProfile = props.profileObjectActive
                        MachineData.machineClassName = props.profileObjectActive['classStr']
                        MachineData.machineModelName = props.profileObjectActive['modelStr']

                        MachineAPI.setup(MachineData)
                        HeaderAppService.sideGlass = (props.profileObjectActive['sideGlass']|| 0) > 0

                        const connectionId = "StartupPage"
                        userManageQml.init(connectionId);

                        startupProgressBar.value = 0.5
                    }
                }//

                if (loopCycle >= 3) {
                    if (userManageQml.superAdminStatus){
                        if (MachineData.machineState == MachineAPI.MACHINE_STATE_LOOP) {

                            ///stop this eventTime then open next page
                            eventTimer.stop()
                            startupProgressBar.value = 1
                        }//
                    }
                }//
            }//
        }//

        //// Execute This Every This Screen Active/Visible/Foreground
        executeOnPageVisible: QtObject {
            /// onResume
            Component.onCompleted: {
                //                console.debug("StackView.Active");

                viewApp.enabledSwipedFromLeftEdge   = false
                viewApp.enabledSwipedFromRightEdge  = false
                viewApp.enabledSwipedFromBottomEdge = false
                viewApp.enabledSwipedFromTopEdge    = false

                eventTimer.start()
            }//

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }

            /// PUT ANY DYNAMIC OBJECT MUST A WARE TO PAGE STATUS
            /// ANY OBJECT ON HERE WILL BE DESTROYED WHEN THIS PAGE NOT IN FOREGROUND
        }//

        //        /// Execute This Every This Screen Active/Visible
        //        Loader {
        //            active: viewApp.stackViewStatusForeground && parent.ready
        //            asynchronous: true
        //            sourceComponent: QtObject {

        //                /// onResume
        //                Component.onCompleted: {
        //                    console.debug("StackView.Active");
        //                    viewApp.setEnableSwiped("left", false)
        //                    viewApp.setEnableSwiped("right", false)
        //                    viewApp.setEnableSwiped("bottom", false)

        //                    eventTimer.start()
        //                }//

        //                /// onPause
        //                Component.onDestruction: {
        //                    ////console.debug("StackView.DeActivating");
        //                }
        //            }//
        //        }//
    }//
}//
