/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
//import "../../CusCom/JS/IntentApp.js" as IntentApp
import "../../../CusCom/JS/IntentApp.js" as IntentApp

//import BookingScheduleQmlApp 1.0

import ModulesCpp.Machine 1.0

import Qt.labs.settings 1.1

import ModulesCpp.JstoText 1.0

Item {
    id: bodyItem
    Layout.fillWidth: true
    Layout.fillHeight: true

    Flow {
        anchors.centerIn: parent
        width: 305
        spacing: 5

        Rectangle {
            height: 100
            width: 305
            radius: 5
            color: "#0F2952"
            border.color: "#e3dac9"

            ColumnLayout {
                anchors.fill: parent

                TextApp {
                    Layout.margins: 5
                    text: "Export Via"
                    //                                text: qsTr("Export") + " " + qsTr("(Week: ") + props.exportTargetWeek + ")"
                }//

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    RowLayout {
                        anchors.fill: parent

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            visible: false
                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/UI/Pictures/pdf-export-bt.png"
                            }//

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    props.exportToWhat = props.exportToPdfBluetooth

                                    let fileName = String(MachineData.cabinetDisplayName).replace(" ", "_")
                                    let serialNumber = String(MachineData.serialNumber)
                                    if(serialNumber.length === 0) serialNumber = "00000"

                                    let targetFileName = fileName + "_" + serialNumber + "_full" + ".txt"

                                    const jsonObj = bodyItem.generatePayload()
                                    jstoText.write(jsonObj, targetFileName)

                                }//
                            }//
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/UI/Pictures/pdf-export-usb.png"
                            }//

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {

                                    props.exportToWhat = props.exportToPdfUSB

                                    const message = "<b>" + qsTr("Have you insert usb drive?") + "</b>"
                                                  + "<br><br>"
                                                  + qsTr("USB port can be found on top of the cabinet, near by power inlet.")
                                    const autoclosed = false
                                    showDialogAsk(qsTr("Export"), message, dialogAlert,
                                                  function onAccepted(){

                                                      let fileName = String(MachineData.cabinetDisplayName).replace(" ", "_")
                                                      let serialNumber = String(MachineData.serialNumber)
                                                      if(serialNumber.length === 0) serialNumber = "00000"

                                                      let targetFileName = fileName + "_" + serialNumber + "_full" + ".txt"

                                                      const jsonObj = bodyItem.generatePayload()
                                                      jstoText.write(jsonObj, targetFileName)
                                                  },
                                                  function(){}, function(){}, autoclosed)
                                }//
                            }//
                        }//
                    }//
                }//
            }//
        }//
    }//

    JstoText {
        id: jstoText

        onExportFinished: {
            if (done) {
                viewApp.showDialogMessage(qsTr("Export"),
                                          qsTr("The document has been generated."),
                                          viewApp.dialogInfo,
                                          function onClosed(){
                                              let urlContext = "qrc:/UI/Pages/FileManagerUsbCopyPage/FileManagerUsbCopierPage.qml";
                                              if(props.exportToWhat == props.exportToPdfBluetooth){
                                                  urlContext = "qrc:/UI/Pages/BluetoothFileTransfer/BluetoothFileTransfer.qml"
                                              }

                                              const intent = IntentApp.create(urlContext, {"sourceFilePath": path})
                                              viewApp.startView(intent);
                                          })
                //             console.log (path)
            }
            else {
                viewApp.showDialogMessage(qsTr("Export"),
                                          qsTr("Failed when creating document"))
            }
        }
    }

    Settings {
        id: settingsGeneral

        ////////// INFLOW
        property string ifaCalGridNom: "[]"
        //metric
        property int    ifaCalGridNomTot: 0
        property int    ifaCalGridNomAvg: 0
        property int    ifaCalGridNomVol: 0
        property int    ifaCalGridNomVel: 0
        //imperial
        property int    ifaCalGridNomTotImp: 0
        property int    ifaCalGridNomAvgImp: 0
        property int    ifaCalGridNomVolImp: 0
        property int    ifaCalGridNomVelImp: 0
        //
        property int    ifaCalGridNomDcy: 0
        property int    ifaCalGridNomRpm: 0
        ///___________________________________
        property string ifaCalGridMin: "[]"
        //metric
        property int    ifaCalGridMinTot: 0
        property int    ifaCalGridMinAvg: 0
        property int    ifaCalGridMinVol: 0
        property int    ifaCalGridMinVel: 0
        //imperial
        property int    ifaCalGridMinTotImp: 0
        property int    ifaCalGridMinAvgImp: 0
        property int    ifaCalGridMinVolImp: 0
        property int    ifaCalGridMinVelImp: 0
        //
        property int    ifaCalGridMinDcy: 0
        property int    ifaCalGridMinRpm: 0
        ///___________________________________
        property string ifaCalGridStb: "[]"
        //metric
        property int    ifaCalGridStbTot: 0
        property int    ifaCalGridStbAvg: 0
        property int    ifaCalGridStbVol: 0
        property int    ifaCalGridStbVel: 0
        //imperial
        property int    ifaCalGridStbTotImp: 0
        property int    ifaCalGridStbAvgImp: 0
        property int    ifaCalGridStbVolImp: 0
        property int    ifaCalGridStbVelImp: 0
        //
        property int    ifaCalGridStbDcy: 0
        property int    ifaCalGridStbRpm: 0
        ///___________________________________
        ////////// DOWNFLOW
        property string dfaCalGridNom:          "[]"
        //metric
        property int    dfaCalGridNomVel:       0
        property int    dfaCalGridNomVelTot:    0
        property int    dfaCalGridNomVelDev:    0
        property int    dfaCalGridNomVelDevp:   0
        property int    dfaCalGridNomVelHigh:   0
        property int    dfaCalGridNomVelLow:    0
        //imperial
        property int    dfaCalGridNomVelImp:       0
        property int    dfaCalGridNomVelTotImp:    0
        property int    dfaCalGridNomVelDevImp:    0
        //        property int    dfaCalGridNomVelDevp:   0
        property int    dfaCalGridNomVelHighImp:   0
        property int    dfaCalGridNomVelLowImp:    0
        property int    dfaCalGridNomDcy: 0
        property int    dfaCalGridNomRpm: 0
        ///_________________________________
        property string dfaCalGridMin:          "[]"
        //metric
        property int    dfaCalGridMinVel:       0
        property int    dfaCalGridMinVelTot:    0
        property int    dfaCalGridMinVelDev:    0
        property int    dfaCalGridMinVelDevp:   0
        property int    dfaCalGridMinVelHigh:   0
        property int    dfaCalGridMinVelLow:    0
        //imperial
        property int    dfaCalGridMinVelImp:       0
        property int    dfaCalGridMinVelTotImp:    0
        property int    dfaCalGridMinVelDevImp:    0
        //                property int    dfaCalGridMinVelDevp:   0
        property int    dfaCalGridMinVelHighImp:   0
        property int    dfaCalGridMinVelLowImp:    0

        property int    dfaCalGridMinDcy: 0
        property int    dfaCalGridMinRpm: 0
        ///_________________________________
        property string dfaCalGridMax:          "[]"
        //metric
        property int    dfaCalGridMaxVel:       0
        property int    dfaCalGridMaxVelTot:    0
        property int    dfaCalGridMaxVelDev:    0
        property int    dfaCalGridMaxVelDevp:   0
        property int    dfaCalGridMaxVelHigh:   0
        property int    dfaCalGridMaxVelLow:    0
        //imperial
        property int    dfaCalGridMaxVelImp:       0
        property int    dfaCalGridMaxVelTotImp:    0
        property int    dfaCalGridMaxVelDevImp:    0
        //                property int    dfaCalGridMaxVelDevp:   0
        property int    dfaCalGridMaxVelHighImp:   0
        property int    dfaCalGridMaxVelLowImp:    0

        property int    dfaCalGridMaxDcy: 0
        property int    dfaCalGridMaxRpm: 0
        ///_________________________________
    }//

    Settings {
        id: settingsCert
        category: "certification"

        property string serverIPv4:         "127.0.0.1:8000"

        property string cabinetModel:       MachineData.machineModelName
        property int    cabinetSize:        MachineData.machineProfile['width']['feet']
        property string calibProc:          ""
        property string serialNumber:       ""
        property string powerRating:        "220 VAC / 50Hz"
        property int    tempRoom:           MachineData.temperatureCelcius
        property int    tempRoomImp:        utils.celciusToFahrenheit(MachineData.temperatureCelcius)
        property string pressRoom:          "1.0005"
        property string paoCons:            "0.0005"
        property string dfParPenet:         "0.0000"
        property string ifParPenet:         "0.0000"
        property int    noLaskin:           2
        property string    damperOpen:         "10"
        property string    damperOpenImp:         "2/5"

        property int    mvInitialFanDucyDfa:   0
        property int    mvInitialFanRpmDfa:    0
        property int    mvInitialFanDucyIfa:   0
        property int    mvInitialFanRpmIfa:    0
        //metric
        property string mvInitialDfa:       "0"
        property string mvInitialIfa:       "0"
        //imperial
        property string mvInitialDfaImp:    "0"
        property string mvInitialIfaImp:    "0"
        //
        property string mvInitialPower:     "0"

        property int    mvBlockFanDucyDfa:     0
        property int    mvBlockFanRpmDfa:      0
        property int    mvBlockFanDucyIfa:     0
        property int    mvBlockFanRpmIfa:      0
        //metric
        property string mvBlockDfa:         "0"
        property string mvBlockIfa:         "0"
        //imperial
        property string mvBlockDfaImp:      "0"
        property string mvBlockIfaImp:      "0"
        property string mvBlockPower:       "0"

        property int    mvFinalFanDucyDfa:     0
        property int    mvFinalFanRpmDfa:      0
        property int    mvFinalFanDucyIfa:     0
        property int    mvFinalFanRpmIfa:      0
        //metric
        property string mvFinalDfa:         "0"
        property string mvFinalIfa:         "0"
        //imperial
        property string mvFinalDfaImp:      "0"
        property string mvFinalIfaImp:      "0"

        property string dfaSensorVdc:   "0"
        property int dfaAdcActual:      -1
        property string ifaSensorVdc:   "0"
        property int ifaAdcActual:      -1

        property string testerName:         ""
        property string testerSignature:    ""
        property string checkerName:        ""
        property string checkerSignature:   ""

        property string customer:           "WORLD-MTR"
        property string country:            "SINGAPORE"
        property string dateTest:           Qt.formatDate(new Date, "dd-MMM-yyyy")
        property string swVersion:          Qt.application.name + " - " + Qt.application.version

    }//

    function generatePayload(){
        let dataTestReport = {
            "cabinet_model":        settingsCert.cabinetModel,
            "cabinet_size":         settingsCert.cabinetSize,
            "sash_opening":         MachineData.machineProfile['sashWindow'],
            "docpro":               settingsCert.calibProc,
            "serial_number":        settingsCert.serialNumber,
            "test_date":            settingsCert.dateTest,
            "customer":             settingsCert.customer,
            "country":              settingsCert.country,
            "power_rating":         settingsCert.powerRating,

            "mea_unit":             MachineData.measurementUnit ? "IMP" : "MTR",

            "tested_by":            settingsCert.testerName,
            "t_signature":          settingsCert.testerSignature,
            "checked_by":           settingsCert.checkerName,
            "c_signature":          settingsCert.checkerSignature === "" ? " " : settingsCert.checkerSignature,

            "sw_ver":               settingsCert.swVersion,

            "room_temp":            MachineData.measurementUnit ? settingsCert.tempRoomImp : settingsCert.tempRoomImp,
            "room_press":           settingsCert.pressRoom,

            "pao_con":              settingsCert.paoCons,
            "df_par_penet":         settingsCert.dfParPenet,
            "if_par_penet":         settingsCert.ifParPenet,

            "noz_laskin":           settingsCert.noLaskin,
            "damper_opening":       MachineData.measurementUnit ? settingsCert.damperOpenImp : settingsCert.damperOpen,

            "grid_ifa_nom":         settingsGeneral.ifaCalGridNom,
            "grid_ifa_nom_total":   MachineData.measurementUnit ? settingsGeneral.ifaCalGridNomTotImp : settingsGeneral.ifaCalGridNomTot,
            "grid_ifa_nom_avg":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridNomAvgImp : settingsGeneral.ifaCalGridNomAvg,
            "grid_ifa_nom_vel":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridNomVelImp : settingsGeneral.ifaCalGridNomVel,
            "ducy_nom_ifa":             settingsGeneral.ifaCalGridNomDcy,
            "rpm_nom_ifa":             settingsGeneral.ifaCalGridNomRpm,

            "grid_ifa_fail":        settingsGeneral.ifaCalGridMin,
            "grid_ifa_fail_total":  MachineData.measurementUnit ? settingsGeneral.ifaCalGridMinTotImp : settingsGeneral.ifaCalGridMinTot,
            "grid_ifa_fail_avg":    MachineData.measurementUnit ? settingsGeneral.ifaCalGridMinAvgImp : settingsGeneral.ifaCalGridMinAvg,
            "grid_ifa_fail_vel":    MachineData.measurementUnit ? settingsGeneral.ifaCalGridMinVelImp : settingsGeneral.ifaCalGridMinVel,
            "ducy_fail_ifa":            settingsGeneral.ifaCalGridMinDcy,
            "rpm_fail_ifa":            settingsGeneral.ifaCalGridMinRpm,

            "grid_ifa_stb":         settingsGeneral.ifaCalGridStb,
            "grid_ifa_stb_total":   MachineData.measurementUnit ? settingsGeneral.ifaCalGridStbTotImp : settingsGeneral.ifaCalGridStbTot,
            "grid_ifa_stb_avg":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridStbAvgImp : settingsGeneral.ifaCalGridStbAvg,
            "grid_ifa_stb_vel":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridStbVelImp : settingsGeneral.ifaCalGridStbVel,
            "ducy_stb_ifa":             settingsGeneral.ifaCalGridStbDcy,
            "rpm_stb_ifa":             settingsGeneral.ifaCalGridStbRpm,

            "grid_dfa_nom":         settingsGeneral.dfaCalGridNom,
            "grid_dfa_nom_avg":     MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelImp : settingsGeneral.dfaCalGridNomVel,
            "grid_dfa_nom_total":   MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelTotImp : settingsGeneral.dfaCalGridNomVelTot,
            "grid_dfa_nom_dev":     MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelDevImp : settingsGeneral.dfaCalGridNomVelDev,
            "grid_dfa_nom_devp":    settingsGeneral.dfaCalGridNomVelDevp,
            "grid_dfa_nom_lowest":  MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelLowImp : settingsGeneral.dfaCalGridNomVelLow,
            "grid_dfa_nom_highest": MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelHighImp : settingsGeneral.dfaCalGridNomVelHigh,
            "grid_dfa_nom_count":   MachineData.machineProfile['airflow']['dfa']['nominal']['grid']['count'],
            "grid_dfa_nom_columns": MachineData.machineProfile['airflow']['dfa']['nominal']['grid']['columns'],
            "ducy_nom_dfa":         settingsGeneral.dfaCalGridNomDcy,
            "rpm_nom_dfa":          settingsGeneral.dfaCalGridNomRpm,

            "grid_dfa_min":         settingsGeneral.dfaCalGridMin,
            "grid_dfa_min_avg":     MachineData.measurementUnit ? settingsGeneral.dfaCalGridMinVelImp : settingsGeneral.dfaCalGridMinVel,
            "grid_dfa_min_total":   MachineData.measurementUnit ? settingsGeneral.dfaCalGridMinVelTotImp : settingsGeneral.dfaCalGridMinVelTot,
            "grid_dfa_min_dev":     MachineData.measurementUnit ? settingsGeneral.dfaCalGridMinVelDevImp : settingsGeneral.dfaCalGridMinVelDev,
            "grid_dfa_min_devp":    settingsGeneral.dfaCalGridMinVelDevp,
            "grid_dfa_min_lowest":  MachineData.measurementUnit ? settingsGeneral.dfaCalGridMinVelLowImp : settingsGeneral.dfaCalGridMinVelLow,
            "grid_dfa_min_highest": MachineData.measurementUnit ? settingsGeneral.dfaCalGridMinVelHighImp : settingsGeneral.dfaCalGridMinVelHigh,
            "grid_dfa_min_count":   MachineData.machineProfile['airflow']['dfa']['minimum']['grid']['count'],
            "grid_dfa_min_columns": MachineData.machineProfile['airflow']['dfa']['minimum']['grid']['columns'],
            "ducy_min_dfa":         settingsGeneral.dfaCalGridMinDcy,
            "rpm_min_dfa":          settingsGeneral.dfaCalGridMinRpm,

            "grid_dfa_max":         settingsGeneral.dfaCalGridMax,
            "grid_dfa_max_avg":     MachineData.measurementUnit ? settingsGeneral.dfaCalGridMaxVelImp : settingsGeneral.dfaCalGridMaxVel,
            "grid_dfa_max_total":   MachineData.measurementUnit ? settingsGeneral.dfaCalGridMaxVelTotImp : settingsGeneral.dfaCalGridMaxVelTot,
            "grid_dfa_max_dev":     MachineData.measurementUnit ? settingsGeneral.dfaCalGridMaxVelDevImp : settingsGeneral.dfaCalGridMaxVelDev,
            "grid_dfa_max_devp":    settingsGeneral.dfaCalGridMaxVelDevp,
            "grid_dfa_max_lowest":  MachineData.measurementUnit ? settingsGeneral.dfaCalGridMaxVelLowImp : settingsGeneral.dfaCalGridMaxVelLow,
            "grid_dfa_max_highest": MachineData.measurementUnit ? settingsGeneral.dfaCalGridMaxVelHighImp : settingsGeneral.dfaCalGridMaxVelHigh,
            "grid_dfa_max_count":   MachineData.machineProfile['airflow']['dfa']['maximum']['grid']['count'],
            "grid_dfa_max_columns": MachineData.machineProfile['airflow']['dfa']['maximum']['grid']['columns'],
            "ducy_max_dfa":         settingsGeneral.dfaCalGridMaxDcy,
            "rpm_max_dfa":          settingsGeneral.dfaCalGridMaxRpm,

            "adc_iff":              MachineData.getInflowAdcPointFactory(1),
            "adc_ifn":              MachineData.getInflowAdcPointFactory(2),
            "adc_ifa":              settingsCert.ifaAdcActual,
            "adc_if0":              MachineData.getInflowAdcPointFactory(0),
            "adc_if1":              MachineData.getInflowAdcPointFactory(1),
            "adc_if2":              MachineData.getInflowAdcPointFactory(2),
            "adc_range_ifa":            MachineData.getInflowAdcPointFactory(2) - MachineData.getInflowAdcPointFactory(0),

            "adc_dff":              MachineData.getDownflowAdcPointFactory(1),
            "adc_dfn":              MachineData.getDownflowAdcPointFactory(2),
            "adc_dfa":              settingsCert.dfaAdcActual,
            "adc_df0":              MachineData.getDownflowAdcPointFactory(0),
            "adc_df1":              MachineData.getDownflowAdcPointFactory(1),
            "adc_df2":              MachineData.getDownflowAdcPointFactory(2),
            "adc_range_dfa":            MachineData.getDownflowAdcPointFactory(2) - MachineData.getDownflowAdcPointFactory(0),

            "calib_temp_adc":       MachineData.getInflowTempCalibAdc(),
            "calib_temp":           MachineData.getInflowTempCalib(),

            "sensor_voltage_dfa":       settingsCert.dfaSensorVdc,
            "sensor_voltage_ifa":       settingsCert.ifaSensorVdc,
            "sensor_constant_dfa":      MachineData.getDownflowSensorConstant(),
            "sensor_constant_ifa":      MachineData.getInflowSensorConstant(),

            "mv_initial_ducy_dfa":      settingsCert.mvInitialFanDucyDfa,
            "mv_initial_rpm_dfa":       settingsCert.mvInitialFanRpmDfa,
            "mv_initial_ducy_ifa":      settingsCert.mvInitialFanDucyIfa,
            "mv_initial_rpm_ifa":       settingsCert.mvInitialFanRpmIfa,
            "mv_initial_downflow":  MachineData.measurementUnit ? settingsCert.mvInitialDfaImp : settingsCert.mvInitialDfa,
            "mv_initial_inflow":    MachineData.measurementUnit ? settingsCert.mvInitialIfaImp : settingsCert.mvInitialIfa,
            "mv_initial_power":     settingsCert.mvInitialPower,

            "mv_blocked_ducy_dfa":      settingsCert.mvBlockFanDucyDfa,
            "mv_blocked_rpm_dfa":       settingsCert.mvBlockFanRpmDfa,
            "mv_blocked_ducy_ifa":      settingsCert.mvBlockFanDucyIfa,
            "mv_blocked_rpm_ifa":       settingsCert.mvBlockFanRpmIfa,
            "mv_blocked_downflow":  MachineData.measurementUnit ? settingsCert.mvBlockDfaImp : settingsCert.mvBlockDfa,
            "mv_blocked_inflow":    MachineData.measurementUnit ? settingsCert.mvBlockIfaImp : settingsCert.mvBlockIfa,
            "mv_blocked_power":     settingsCert.mvBlockPower,

            "mv_final_ducy_dfa":        settingsCert.mvFinalFanDucyDfa,
            "mv_final_rpm_dfa":         settingsCert.mvFinalFanRpmDfa,
            "mv_final_ducy_ifa":        settingsCert.mvFinalFanDucyIfa,
            "mv_final_rpm_ifa":         settingsCert.mvFinalFanRpmIfa,
            "mv_final_downflow":    MachineData.measurementUnit ? settingsCert.mvFinalDfaImp : settingsCert.mvFinalDfa,
            "mv_final_inflow":      MachineData.measurementUnit ? settingsCert.mvFinalIfaImp : settingsCert.mvFinalIfa,

            /*"fan_hp":             MachineData.machineProfile['fan']['horsePower'],
            "fan_rot":              MachineData.machineProfile['fan']['direction'],
            "fan_hsl":              MachineData.machineProfile['fan']['highSpeedLimit'],
            "fan_max_airvol":       MachineData.machineProfile['fan']['maxAirVolume'],
            "fan_const_a1":         MachineData.machineProfile['fan']['constant']['a1'],
            "fan_const_a2":         MachineData.machineProfile['fan']['constant']['a2'],
            "fan_const_a3":         MachineData.machineProfile['fan']['constant']['a3'],
            "fan_const_a4":         MachineData.machineProfile['fan']['constant']['a4']*/

            "fhp":                 Qt.md5(MachineData.machineProfile['fan']['horsePower']),
            "frot":                Qt.md5(MachineData.machineProfile['fan']['direction']),
            "fhsl":                Qt.md5(MachineData.machineProfile['fan']['highSpeedLimit']),
            "fmxvol":              Qt.md5(MachineData.machineProfile['fan']['maxAirVolume']),
            "fcoa1":               Qt.md5(MachineData.machineProfile['fan']['constant']['a1']),
            "fcoa2":               Qt.md5(MachineData.machineProfile['fan']['constant']['a2']),
            "fcoa3":               Qt.md5(MachineData.machineProfile['fan']['constant']['a3']),
            "fcoa4":               Qt.md5(MachineData.machineProfile['fan']['constant']['a4']),

            "cabinet_name":        MachineData.cabinetDisplayName
        }//

        return dataTestReport
    }//

    UtilsApp{
        id: utils
    }

    QtObject{
        id: props

        readonly property int exportToPdfUSB: 0
        readonly property int exportToPdfBluetooth: 1
        property int exportToWhat: 0
    }//
}//



/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#c0c0c0";formeditorZoom:0.75;height:480;width:800}
}
##^##*/
