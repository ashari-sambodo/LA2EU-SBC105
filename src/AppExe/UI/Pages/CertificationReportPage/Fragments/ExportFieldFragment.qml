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

import UI.CusCom 1.1
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

                                    let targetFileName = fileName + "_" + serialNumber + "_field" + ".txt"

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

                                                      let targetFileName = fileName + "_" + serialNumber + "_field" + ".txt"

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

    /// directly access to file settings
    Settings {
        id: settingsGeneral

        property string ifaCalGridNomFil:   "[]"
        //metric
        property int    ifaCalGridNomTotFil: 0
        property int    ifaCalGridNomAvgFil: 0
        property int    ifaCalGridNomVolFil: 0
        property int    ifaCalGridNomVelFil: 0
        //Imperial
        property int    ifaCalGridNomTotFilImp: 0
        property int    ifaCalGridNomAvgFilImp: 0
        property int    ifaCalGridNomVolFilImp: 0
        property int    ifaCalGridNomVelFilImp: 0
        //
        property int    ifaCalGridNomDcyFil: 0

        property string ifaCalGridNomSecFil:    "[]"
        //metric
        property int    ifaCalGridNomTotSecFil: 0
        property int    ifaCalGridNomAvgSecFil: 0
        property int    ifaCalGridNomVelSecFil: 0
        //Imperial
        property int    ifaCalGridNomTotSecFilImp: 0
        property int    ifaCalGridNomAvgSecFilImp: 0
        property int    ifaCalGridNomVelSecFilImp: 0
        //
        property int    ifaCalGridNomDcySecFil: 0

        property string dfaCalGridNomFil:          "[]"
        //metric
        property int    dfaCalGridNomVelFil:       0
        property int    dfaCalGridNomVelTotFil:    0
        property int    dfaCalGridNomVelDevFil:    0
        property int    dfaCalGridNomVelDevpFil:   0
        property int    dfaCalGridNomVelHighFil:   0
        property int    dfaCalGridNomVelLowFil:    0
        //Imperial
        property int    dfaCalGridNomVelFilImp:       0
        property int    dfaCalGridNomVelTotFilImp:    0
        property int    dfaCalGridNomVelDevFilImp:    0
        //        property int    dfaCalGridNomVelDevpFil:   0
        property int    dfaCalGridNomVelHighFilImp:   0
        property int    dfaCalGridNomVelLowFilImp:    0
    }//

    Settings {
        id: settingsCert
        category: "certification"

        property string cabinetModel:       MachineData.machineModelName
        property int    cabinetSize:        MachineData.machineProfile['width']['feet']
        property string calibProc:          ""
        property string serialNumber:       ""
        property string powerRating:        "220 VAC / 50Hz"

        property string testerNameField:         ""
        property string testerSignatureField:    ""
        property string checkerNameField:        ""
        property string checkerSignatureField:   ""

        property string customer:           "WORLD-MTR"
        property string country:            "SINGAPORE"
        property string dateTest:           Qt.formatDate(new Date, "dd-MMM-yyyy")
        property string swVersion:          Qt.application.name + " - " + Qt.application.version
    }//

    function generatePayload(trt, pftr, pfcr){
        let dataTestReport = {
            "calib_fil":            true, /// this field calibration

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

            "tested_by":            settingsCert.testerNameField,
            "t_signature":          settingsCert.testerSignatureField,
            "checked_by":           settingsCert.checkerNameField,
            "c_signature":          settingsCert.checkerSignatureField === "" ? " " : settingsCert.checkerSignatureField,

            "sw_ver":               settingsCert.swVersion,

            "grid_ifa_nom":         settingsGeneral.ifaCalGridNomFil,
            "grid_ifa_nom_total":   MachineData.measurementUnit ? settingsGeneral.ifaCalGridNomTotFilImp : settingsGeneral.ifaCalGridNomTotFil,
            "grid_ifa_nom_avg":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridNomAvgFilImp : settingsGeneral.ifaCalGridNomAvgFil,
            "grid_ifa_nom_vel":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridNomVelFilImp : settingsGeneral.ifaCalGridNomVelFil,

            "ducy_nom":             MachineData.getFanPrimaryNominalDutyCycle(),
            "ducy_stb":             MachineData.getFanPrimaryStandbyDutyCycle(),

            "grid_dfa_nom":         settingsGeneral.dfaCalGridNomFil,
            "grid_dfa_nom_avg":     MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelFilImp : settingsGeneral.dfaCalGridNomVelFil,
            "grid_dfa_nom_total":   MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelTotFilImp : settingsGeneral.dfaCalGridNomVelTotFil,
            "grid_dfa_nom_dev":     MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelDevFilImp : settingsGeneral.dfaCalGridNomVelDevFil,
            "grid_dfa_nom_devp":    settingsGeneral.dfaCalGridNomVelDevpFil,
            "grid_dfa_nom_lowest":  MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelLowFilImp : settingsGeneral.dfaCalGridNomVelLowFil,
            "grid_dfa_nom_highest": MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelHighFilImp : settingsGeneral.dfaCalGridNomVelHighFil,
            "grid_dfa_nom_count":   MachineData.machineProfile['airflow']['dfa']['nominal']['grid']['count'],
            "grid_dfa_nom_columns": MachineData.machineProfile['airflow']['dfa']['nominal']['grid']['columns'],

            "cabinet_name":         MachineData.cabinetDisplayName
        }//

        const dataPayload = {
            "trt":  trt,
            "pftr": pftr,
            "pfcr": pfcr,
            "data": dataTestReport
        }//

        return dataPayload
    }//

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
