WorkerScript.onMessage = function(msg) {
    //    //console.debug(msg)

    if (msg.action === 'init') {
        ///USER LEVEL
        let userRole_GUEST      = 0
        let userRole_USER       = 1
        let userRole_ADMIN      = 2
        let userRole_SUPERADMIN = 3
        let userRole_SERVICE    = 4
        let userRole_FACTORY    = 5

        //USER_ROLE
        let userRole = msg.userlevel
        //DUAL RBM
        let dualRbmMode = msg.dualRbmEnable

        //MENU_MODEL
        let menuGroupModel = []
        //MENU_INDICATOR
        let menuIndicator = []

        let menu = [[]]
        let index = 0

        const itemPerPage = 7

        //OPERATOR_MENU
        if(userRole >= userRole_GUEST){

            menu = [[]]
            index = 0

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Experiment Timer"),
                                 micon     : "qrc:/UI/Pictures/menu/Experiment-Timer.png",
                                 mlink     : "qrc:/UI/Pages/ExperimentTimerPage/ExperimentTimerPage.qml"
                                 //                                 mlink     : "qrc:/UI/Pages/FtpFileSharePage/FtpFileSharePage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Light Intensity"),
                                 micon     : "qrc:/UI/Pictures/menu/Light-Intensity.png",
                                 mlink     : "qrc:/UI/Pages/LightIntensityPage/LightIntensityPage.qml"
                             })

            //            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            //            menu[index].push({mtype        : "menu",
            //                                 mtitle    : qsTr("Curve Test"),
            //                                 micon     : "qrc:/UI/Pictures/menu/Light-Intensity.png",
            //                                 mlink     : "qrc:/UI/Pages/BlankPage/BlankPage.qml"
            //                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("LCD"),
                                 micon     : "qrc:/UI/Pictures/menu/Adjust-Brightness.png",
                                 mlink     : "qrc:/UI/Pages/LcdBrightnessPage/LcdBrightnessPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Clean LCD"),
                                 micon     : "qrc:/UI/Pictures/menu/Clear-LCD.png",
                                 mlink     : "qrc:/UI/Pages/CleanLcdPage/CleanLcdPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Screen Saver"),
                                 micon     : "qrc:/UI/Pictures/menu/screensaver.png",
                                 mlink     : "qrc:/UI/Pages/ScreenSaverSettingPage/ScreenSaverSettingPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Languages"),
                                 micon     : "qrc:/UI/Pictures/menu/Language.png",
                                 mlink     : "qrc:/UI/Pages/LanguagePage/LanguagePage.qml"
                             })
            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Booking Schedule"),
                                 micon      :   "qrc:/UI/Pictures/booking_schedule.png",
                                 mlink      :   "qrc:/UI/Pages/BookingSchedule/BookingSchedule.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Diagnostics"),
                                 micon     : "qrc:/UI/Pictures/menu/Diagnostics.png",
                                 mlink     : "qrc:/UI/Pages/DiagnosticsPage/DiagnosticsPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Data Log"),
                                 micon     : "qrc:/UI/Pictures/menu/log-button_2.png",
                                 mlink     : "qrc:/UI/Pages/DataLogPage/DataLogPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Alarm Log"),
                                 micon     : "qrc:/UI/Pictures/menu/log-button_2.png",
                                 mlink     : "qrc:/UI/Pages/AlarmLogPage/AlarmLogPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Event Log"),
                                 micon     : "qrc:/UI/Pictures/menu/log-button_2.png",
                                 mlink     : "qrc:/UI/Pages/EventLogPage/EventLogPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("UV Timer"),
                                 micon     : "qrc:/UI/Pictures/menu/UV_Timer.png",
                                 mlink     : "qrc:/UI/Pages/UVTimerSetPage/UVTimerSetPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Network"),
                                 micon     : "qrc:/UI/Pictures/menu/wifi.png",
                                 mlink     : "qrc:/UI/Pages/NetworkConfigPage/NetworkConfigPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Mute Timer"),
                                 micon     : "qrc:/UI/Pictures/menu/Mute Timer.png",
                                 mlink     : "qrc:/UI/Pages/MuteTimerSetPage/MuteTimerSetPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Fan Scheduler"),
                                 micon     : "qrc:/UI/Pictures/menu/Fan_Schedule.png",
                                 mlink     : "qrc:/UI/Pages/FanSchedulerPage/FanSchedulerPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("UV Scheduler"),
                                 micon     : "qrc:/UI/Pictures/menu/UV_Sched.png",
                                 mlink     : "qrc:/UI/Pages/UVSchedulerPage/UVSchedulerPage.qml"
                             })

            //MENU_INDICATOR
            menuIndicator.push(qsTr("User"))
            //PUSH_TO_MENU_MODEL
            menuGroupModel.push(menu)
            //            //console.debug(menu)
            //            //console.debug(menuGroupModel)
            //                //console.debug(menuGroupModel.length)
        }

        //ADMIN_MENU
        if(userRole >= userRole_ADMIN){

            menu = [[]]
            index = 0

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Shut down"),
                                 micon     : "qrc:/UI/Pictures/menu/Shutdown.png",
                                 mlink     : "qrc:/UI/Pages/LeavePage/LeavePage.qml"
                                 //                                             mlink      : "FanInputPin"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Users"),
                                 micon      :   "qrc:/UI/Pictures/menu/User Mgnt.png",
                                 mlink      :   "qrc:/UI/Pages/UserManagePage/UserManagePage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Cabinet Name"),
                                 micon      :   "qrc:/UI/Pictures/menu/Cabinet Name.png",
                                 mlink      :   "qrc:/UI/Pages/CabinetNameSetPage/CabinetNameSetPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Time Zone"),
                                 micon      :   "qrc:/UI/Pictures/menu/Time Zone.png",
                                 mlink      :   "qrc:/UI/Pages/TimeZonePage/TimeZonePage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype       :   "menu",
                                 mtitle   :   qsTr("Date"),
                                 micon    :   "qrc:/UI/Pictures/menu/Set-Date.png",
                                 mlink    :   "qrc:/UI/Pages/DateSetPage/DateSetPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        :   "menu",
                                 mtitle    :   qsTr("Time"),
                                 micon     :   "qrc:/UI/Pictures/menu/Set-Time.png",
                                 mlink     :   "qrc:/UI/Pages/TimeSetPage/TimeSetPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Fan PIN"),
                                 micon      :   "qrc:/UI/Pictures/menu/Blower PIN.png",
                                 mlink      :   "qrc:/UI/Pages/FanPinSetPage/FanPinSetPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Operation Mode"),
                                 micon      :   "qrc:/UI/Pictures/menu/Set-User-Mode.png",
                                 mlink      :   "qrc:/UI/Pages/OperationModePage/OperationModePage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Airflow Monitor"),
                                 micon      :   "qrc:/UI/Pictures/menu/Airflow-Monitor.png",
                                 mlink      :   "qrc:/UI/Pages/AirflowMonitorPage/AirflowMonitorPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Warmup Time"),
                                 micon      :   "qrc:/UI/Pictures/menu/Warm-Up.png",
                                 mlink      :   "qrc:/UI/Pages/WarmupSetPage/WarmupSetPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Post Purge Time"),
                                 micon      :   "qrc:/UI/Pictures/menu/Post-Purge.png",
                                 mlink      :   "qrc:/UI/Pages/PostPurgeSetPage/PostPurgeSetPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Remote Modbus"),
                                 micon      :   "qrc:/UI/Pictures/menu/Remote ModBus.png",
                                 mlink      :   "qrc:/UI/Pages/RemoteModbusPage/RemoteModbusPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Security Level"),
                                 micon     : "qrc:/UI/Pictures/security_level.png",
                                 mlink     : "qrc:/UI/Pages/SecurityLevelSetPage/SecurityLevelSetPage.qml"
                                 //                                 mlink     : "qrc:/UI/Pages/FtpFileSharePage/FtpFileSharePage.qml"
                             })

            //MENU_INDICATOR
            menuIndicator.push(qsTr("Admin"))
            //PUSH_TO_MENU_MODEL
            menuGroupModel.push(menu)
        }

        //SERVICE_MENU
        if(userRole >= userRole_SERVICE){
            menu = [[]]
            index = 0

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Fan Speed"),
                                 micon     : "qrc:/UI/Pictures/menu/set-fan-speed.png",
                                 mlink     : "qrc:/UI/Pages/FanSpeedPage/FanSpeedPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Measurement Unit"),
                                 micon      :   "qrc:/UI/Pictures/menu/Measurement-Unit.png",
                                 mlink      :   "qrc:/UI/Pages/MeasurementUnitPage/MeasurementUnitPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Field Sensor Calibration"),
                                 micon      :   "qrc:/UI/Pictures/menu/Field-Calibration.png",
                                 mlink      :   "qrc:/UI/Pages/FieldCalibratePage/FieldCalibratePage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Full Sensor Calibration"),
                                 micon      :   "qrc:/UI/Pictures/menu/Calibrate-Sensor.png",
                                 mlink      :   "qrc:/UI/Pages/FullCalibrateSensorPage/FullCalibrateSensorPage.qml"
                             })

            if(msg["seasInstalled"] !== undefined){
                if(msg["seasInstalled"] === true){
                    if(menu[index].length > itemPerPage) {index++; menu.push([])}
                    menu[index].push({mtype        : "menu",
                                         mtitle    : qsTr("Built-in SEAS Alarm"),
                                         micon     : "qrc:/UI/Pictures/seas_alarm.png",
                                         mlink     : "qrc:/UI/Pages/SeasAlarmSetPointPage/SeasAlarmSetPointPage.qml"
                                         //                                 mlink     : "qrc:/UI/Pages/FtpFileSharePage/FtpFileSharePage.qml"
                                     })
                }
            }


            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Certification Reminder"),
                                 micon     : "qrc:/UI/Pictures/reminder_date.png",
                                 mlink     : "qrc:/UI/Pages/CertificationReminderDatePage/CertificationReminderDatePage.qml"
                                 //                                             mlink      : "FanInputPin"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Certification Summary"),
                                 micon      :   "qrc:/UI/Pictures/menu/cert_report_icon_full.png",
                                 mlink      :   "qrc:/UI/Pages/CertificationShortCut/CertificationShortCut.qml" /*"qrc:/UI/Pages/CertificationReportPage/CertificationReportPage.qml"*/
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Manual Input Calibration Point"),
                                 micon      :   "qrc:/UI/Pictures/menu/Manual-Input-Data.png",
                                 mlink      :   "qrc:/UI/Pages/ManualInputDataPage/GettingManualInputDataPage.qml"
                             })

            //            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            //            menu[index].push({mtype         :   "menu",
            //                                 mtitle     :   qsTr("Installation Wizard"),
            //                                 micon      :   "qrc:/UI/Pictures/menu/Installation Wizard.png",
            //                                 mlink      :   "qrc:/UI/Pages/InstallationWizardPage/InstallationWizardPage.qml"
            //                             })

            ////////////////////////////////
            /// SUB_RESET_MENU
            let resetMenu = []
            resetMenu.push({mtype         :   "menu",
                               mtitle     :   qsTr("Reset Filter Life Meter"),
                               micon      :   "qrc:/UI/Pictures/menu/Reset-Filter-Odometer.png",
                               mlink      :   "qrc:/UI/Pages/ResetFilterLifePage/ResetFilterLifePage.qml"
                           })

            resetMenu.push({mtype         :   "menu",
                               mtitle     :   qsTr("Reset Fan Usage Meter"),
                               micon      :   "qrc:/UI/Pictures/menu/Reset-Blower-Odometer.png",
                               mlink      :   "qrc:/UI/Pages/ResetBlowerMeterPage/ResetBlowerMeterPage.qml"
                           })

            if(msg["uvInstalled"] !== undefined){
                if(msg["uvInstalled"] === true){
                    //IF_UV_AVAILBALE_IN_THIS_UNIT
                    resetMenu.push({mtype         :   "menu",
                                       mtitle     :   qsTr("Reset UV Life Meter"),
                                       micon      :   "qrc:/UI/Pictures/menu/Reset-UV-Lamp-Odometer.png",
                                       mlink      :   "qrc:/UI/Pages/ResetUvLifePage/ResetUvLifePage.qml"
                                   })
                }
            }

            if (msg["sashWindowMotorizeInstalled"] !== undefined){
                //                console.log(msg["sashWindowMotorizeInstalled"])
                if (msg["sashWindowMotorizeInstalled"] === true){
                    resetMenu.push({mtype         :   "menu",
                                       mtitle     :   qsTr("Reset Sash Cycle Meter"),
                                       micon      :   "qrc:/UI/Pictures/menu/Reset-Sash-Cycle-Odometer.png",
                                       mlink      :   "qrc:/UI/Pages/ResetSashCycleMeterPage/ResetSashCycleMeterPage.qml"
                                   })
                }
            }

            ///////////////////////////////

            /// PUT TO ACTUAL MENU
            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "submenu",
                                 mtitle     :   qsTr("Reset Parameters"),
                                 micon      :   "qrc:/UI/Pictures/menu/Reset-Default.png",
                                 mlink      :   "",
                                 sub        :   resetMenu
                             })
            ///

            //            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            //            menu[index].push({mtype         :   "menu",
            //                                 mtitle     :   qsTr("Bluetooth"),
            //                                 micon      :   "qrc:/UI/Pictures/menu/Reset-Default.png",
            //                                 mlink      :   "qrc:/UI/Pages/BluetoothPage/BluetoothPage.qml"
            //                             })

            //            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            //            menu[index].push({mtype         :   "menu",
            //                                 mtitle     :   qsTr("Reset Parameters"),
            //                                 micon      :   "qrc:/UI/Pictures/menu/Reset-Default.png",
            //                                 mlink      :   "qrc:/UI/Pages/ResetParametersPage/ResetParametersPage.qml",
            //                             })
            if(dualRbmMode){
                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype        :   "menu",
                                     mtitle    :   qsTr("RBM Com Port"),
                                     micon     :   "qrc:/UI/Pictures/menu/RBM_Com_Port.png",
                                     mlink     :   "qrc:/UI/Pages/RbmComPortConfigPage/RbmComPortConfigPage.qml"
                                 })
            }

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Fan Closed Loop Control"),
                                 micon      :   "qrc:/UI/Pictures/menu/fan-auto-control.png",
                                 mlink      :   "qrc:/UI/Pages/FanClosedLoopControlPage/FanClosedLoopControlPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Shipping Setup"),
                                 micon      :   "qrc:/UI/Pictures/menu/shipping-menu.png",
                                 mlink      :   "qrc:/UI/Pages/ShippingSetupPage/ShippingSetupPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        :   "menu",
                                 mtitle    :   qsTr("Software Update"),
                                 micon     :   "qrc:/UI/Pictures/menu/Software-Update.png",
                                 mlink     :   "qrc:/UI/Pages/SoftwareUpdatePage/SoftwareUpdatePage.qml"
                             })

            //MENU_INDICATOR
            menuIndicator.push(qsTr("Service"))
            //PUSH_TO_MENU_MODEL
            menuGroupModel.push(menu)
        }

        //FACTORY_MENU
        if(userRole >= userRole_FACTORY){

            menu = [[]]
            index = 0

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        :   "menu",
                                 mtitle    :   qsTr("Delay Airflow Alarm"),
                                 micon     :   "qrc:/UI/Pictures/menu/af_alarm_delay.png",
                                 //mlink     :   "CabinetSelectOptionPage"
                                 mlink       : "qrc:/UI/Pages/DelayAlarmAirflowPage/DelayAlarmAirflowPage.qml"
                             })
            if (msg["sashWindowMotorizeInstalled"] !== undefined){
                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype        :   "menu",
                                     mtitle    :   qsTr("Sash Motor Off Delay"),
                                     micon     :   "qrc:/UI/Pictures/menu/sash_close-delay.png",
                                     //mlink     :   "CabinetSelectOptionPage"
                                     mlink       : "qrc:/UI/Pages/SashMotorOffFullyClosedDelay/SashMotorOffFullyClosedDelay.qml"
                                 })
            }
            //

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        :   "menu",
                                 mtitle    :   qsTr("Serial Number"),
                                 micon     :   "qrc:/UI/Pictures/menu/BSC_Serial.png",
                                 //                                            mlink     :   "CabinetSelectOptionPage"
                                 mlink       : "qrc:/UI/Pages/SerialNumberSetPage/SerialNumberSetPage.qml"
                             })
            //

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Environmental Temperature Limit"),
                                 micon      :   "qrc:/UI/Pictures/menu/Env-Temp-Limit.png",
                                 mlink      :   "qrc:/UI/Pages/TemperatureAmbOperationSetPage/TemperatureAmbOperationSetPage.qml"
                                 //                                 mlink      :   "qrc:/UI/Pages/ReplaceablePartsPage/ReplaceablePartsPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("ESCO Lock Service"),
                                 micon      :   "qrc:/UI/Pictures/menu/Esco_Lock.png",
                                 mlink      :   "qrc:/UI/Pages/EscoLockServicePage/EscoLockServicePage.qml"
                             })
            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Auxiliary Functions"),
                                 micon      :   "qrc:/UI/Pictures/menu/Auxiliary F.png",
                                 mlink      :   "qrc:/UI/Pages/AuxiliaryFunctionsPage/AuxiliaryFunctionsPage.qml"
                                 //                                 mlink      :   "qrc:/UI/Pages/ReplaceablePartsPage/ReplaceablePartsPage.qml"
                             })
            //
            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        :   "menu",
                                 mtitle    :   qsTr("Cabinet Model"),
                                 micon     :   "qrc:/UI/Pictures/menu/Select-Cabinet-Model.png",
                                 mlink     :   "qrc:/UI/Pages/CabinetProfilePage/CabinetProfilePage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        :   "menu",
                                 mtitle    :   qsTr("RTC Watchdog Test"),
                                 micon     :   "qrc:/UI/Pictures/menu/rtc-watchdog-test-menu.png",
                                 mlink     :   "qrc:/UI/Pages/RtcWatchdogTestPage/RtcWatchdogTestPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        :   "menu",
                                 mtitle    :   qsTr("System Information"),
                                 micon     :   "qrc:/UI/Pictures/menu/microprocessor-device.png",
                                 mlink     :   "qrc:/UI/Pages/SystemInformationPage/SystemInformationPage.qml"
                             })


            //
            //            let calibrateSensor
            //            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            //            menu[index].push({mtype        :   "menu",
            //                                 mtitle    :   "StringsApp.str37",
            //                                 micon     :   "qrc:/picture/menu/Calibrate-Sensor.png",
            //                                 mlink     :   "CalibrateSensorPage"
            //                             })
            //            //
            //            let haveFanStandby = true
            //            if(haveFanStandby){
            //                if(menu[index].length > itemPerPage) {index++; menu.push([])}
            //                menu[index].push({mtype        :   "menu",
            //                                     mtitle    :   "StringsApp.str105",
            //                                     micon     :   "qrc:/picture/menu/Set-Standby-Speed.png",
            //                                     mlink     :   "FanStbSetPage"
            //                                 })
            //            }
            //                if(factoryMenu[index].length > itemPerPage) {index++; factoryMenu.push([])}
            //                factoryMenu[index].push({mtype        :   "menu",
            //                                            mtitle    :   StringsApp.str290,
            //                                            micon     :   "qrc:/picture/menu/Calibrate-Sensor.png",
            //                                            mlink     :   "CalibrateSensorSecondaryPage"
            //                                        })

            //MENU_INDICATOR
            menuIndicator.push(qsTr("Factory"))
            //PUSH_TO_MENU_MODEL
            menuGroupModel.push(menu)
        }

        //        //SET_MENU_MODEL
        //        menuApp.menuGroup = menuGroupModel
        //        //SET_MENU_INDICATOR_MODEL
        //        menuApp.menuGroupIndicator = menuIndicator
        //        //
        //        menuApp.initMenu()

        //        msg.modelmenu = menuGroupModel;
        //        msg.modelmenu.sync(); /// update front end

        //        //console.debug(menuGroupModel)
        WorkerScript.sendMessage({'menu' : menuGroupModel, 'indicator' : menuIndicator})
    }
}
