import QtQuick 2.0
import QtQuick.Controls 2.7
import QtQuick.Layouts 1.0
import UI.CusCom 1.1
import Qt.labs.settings 1.1
import ModulesCpp.Machine 1.0

Item {

    StackView {
        id: sectionStackView
        anchors.fill: parent
        //        initialItem: printerComponent
        //        initialItem: sendServerDoneComponent

        Component.onCompleted: {
            sectionStackView.replace(connectTargetComp)
            //                        sectionStackView.push(printerComponent)
        }//
    }//

    Component {
        id: connectTargetComp

        Item {
            Column {
                anchors.centerIn: parent
                //        columnSpacing: 10
                spacing: 10
                //        columns: 1

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Server Address")
                    }//

                    TextFieldApp {
                        id: serverIpTextField
                        width: 300
                        height: 40

                        onPressed: {
                            KeyboardOnScreenCaller.openKeyboard(this,"Full Name")
                        }//

                        onAccepted: {
                            settingsCert.serverIPv4 = text
                        }//
                    }//
                }//

                ButtonBarApp {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Connect")
                    imageSource: "qrc:/UI/Pictures/upload-icon-35px.png"

                    onClicked: {
                        //                        sectionStackView.replace(printeToServerComponent); return
                        viewApp.showBusyPage(qsTr("Connecting..."), function onCallback(cycle){
                            if (cycle >= MachineAPI.BUSY_CYCLE_10){
                                /// time out after 3o second
                                viewApp.closeDialog()
                            }
                        })

                        let xhttpPrinter = new XMLHttpRequest()
                        const url2 = "http://" + settingsCert.serverIPv4 + "/printer/"
                        //console.log("XMLHttpRequest-url:" + url2)
                        xhttpPrinter.open("GET", url2, true);
                        //                                    xhttpPrinter.setRequestHeader('Content-Type', 'application/json');

                        xhttpPrinter.onreadystatechange = function(){
                            if(xhttpPrinter.readyState === XMLHttpRequest.DONE) {
                                const xstatus = xhttpPrinter.status
                                //console.log("XMLHttpRequest:" + xstatus)
                                //console.log(xstatus)
                                if(xstatus === 200) {
                                    viewApp.closeDialog()

                                    const reponseText = xhttpPrinter.responseText
                                    //console.log(reponseText)

                                    let model = JSON.parse(reponseText)
                                    model.unshift({"id":0, "name": "Tap here to select"});
                                    props.printerDevices = model

                                    sectionStackView.replace(printeToServerComponent)
                                }
                                else {
                                    //console.log(3)
                                    props.showDialogFailComServer()
                                }
                            }
                        }
                        xhttpPrinter.send()
                    }//
                }//
            }//

            Settings {
                id: settingsCert
                category: "certification"

                property string serverIPv4: "127.0.0.1:8000"

                Component.onCompleted: {
                    serverIpTextField.text = serverIPv4
                }//
            }//
        }//
    }//

    Component {
        id: printeToServerComponent

        Item {
            id: printeToServerItem

            Column {
                anchors.centerIn: parent
                //        columnSpacing: 10
                spacing: 10
                //        columns: 1

                Column {
                    spacing: 5

                    /// NOT IMPLEMENTED, IT WILL RESPONSIBE BY SERVER
                    //                    Column {
                    //                        spacing: 5

                    //                        TextApp {
                    //                            text: qsTr("Test Report Template")
                    //                        }//

                    //                        ComboBoxApp {
                    //                            id: templateTestReportCombox
                    //                            width: 300
                    //                            font.pixelSize: 20

                    //                            textRole: 'name'
                    //                            model: props.testReportTemplates

                    //                            //                            model: [
                    //                            //                                {'id': 1, 'name': "LA2-4 (NSF)"},
                    //                            //                                {'id': 1, 'name': "LA2-4 (EN)"},
                    //                            //                            ]
                    //                        }//
                    //                    }//

                    Column {
                        spacing: 5

                        TextApp {
                            text: qsTr("Printer for Test Report")
                        }//

                        ComboBoxApp {
                            id: printerForTestReportCombox
                            width: 300
                            font.pixelSize: 20

                            textRole: 'name'
                            model: props.printerDevices
                            //                            model: [
                            //                                {'id': 1, 'name': "PDF file (saved on server)"},
                            //                                {'id': 1, 'name': "Test Room - Cassete 1"},
                            //                                {'id': 1, 'name': "Test Room - Cassete 2"}
                            //                            ]
                        }//
                    }//

                    Column {
                        spacing: 5

                        TextApp {
                            text: qsTr("Printer for Certificate")
                        }//

                        ComboBoxApp {
                            id: printerForCertCombox
                            width: 300
                            font.pixelSize: 20

                            textRole: 'name'
                            model: props.printerDevices

                            //                            model: [
                            //                                {'id': 1, 'name': "PDF file (saved on server)"},
                            //                                {'id': 1, 'name': "Test Room - Cassete 1"},
                            //                                {'id': 1, 'name': "Test Room - Cassete 2"}
                            //                            ]
                        }//
                    }//
                }//

                ButtonBarApp {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Send")
                    imageSource: "qrc:/UI/Pictures/upload-icon-35px.png"

                    onClicked: {
                        //                        console.log(JSON.stringify(printeToServerItem.generatePayload("", "")))

                        if(/*!templateTestReportCombox.currentIndex ||*/ !printerForTestReportCombox.currentIndex || !printerForCertCombox.currentIndex) {
                            viewApp.showDialogMessage(qsTr("Attention!"),
                                                      qsTr("Please select the valid option for all the forms!"),
                                                      viewApp.dialogAlert)
                            return
                        }

                        viewApp.showBusyPage(qsTr("Sending..."), function onCallback(cycle){
                            if (cycle >= MachineAPI.BUSY_CYCLE_10){
                                /// time out after 3o second
                                viewApp.closeDialog()
                            }
                        })

                        //                        const template          = templateTestReportCombox.currentText
                        const printerForReport  = printerForTestReportCombox.currentText
                        const printerForCert    = printerForCertCombox.currentText

                        const varString =   printeToServerItem.generatePayload(printerForReport, printerForCert)
                        //                        //console.log("var string " + varString)

                        let xhttpPrint = new XMLHttpRequest()
                        const url = "http://" + settingsCert.serverIPv4 + "/store-and-print/"
                        //console.log("XMLHttpRequest-url:" + url)
                        xhttpPrint.open("POST", url, true);
                        xhttpPrint.setRequestHeader('Content-Type', 'application/json');

                        xhttpPrint.onreadystatechange = function(){
                            if(xhttpPrint.readyState === XMLHttpRequest.DONE) {
                                const xstatus = xhttpPrint.status
                                //                                console.log("XMLHttpRequest:" + xstatus)
                                if(xstatus === 200 || xstatus === 201) {
                                    viewApp.closeDialog()

                                    const reponseText = xhttpPrint.responseText
                                    //                                    console.log(reponseText)

                                    viewApp.closeDialog()
                                    sectionStackView.replace(sendServerDoneComponent)
                                }
                                else {
                                    //console.log(5)
                                    //                                    console.log(xhttpPrint.responseText)
                                    //                                    props.showDialogFailComServer()
                                    viewApp.closeDialog()
                                    serverResponseMessageTextArea.text = qsTr("Failed! Because") + " " + xhttpPrint.responseText
                                    serverResponseMessageItem.visible = true
                                }//
                            }//
                        }//
                        xhttpPrint.send(JSON.stringify(varString))
                    }//
                }//
            }//

            Settings {
                id: settingsGeneral

                property string machProfId: "NONE"

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
                ///______________________________________
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
                ///_______________________________________

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
                //                property int    dfaCalGridNomVelDevp:   0
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

                property string serverIPv4:         "192.168.0.18:8000"

                property string cabinetModel:       MachineData.machineModelName
                property int    cabinetSize:        MachineData.machineProfile['width']['feet']
                property string calibProc:          ""
                property string serialNumber:       ""
                property string powerRating:        "220 VAC / 50Hz"
                property int    tempRoom:           MachineData.temperatureCelcius
                property int    tempRoomImp:        utils.celciusToFahrenheit(MachineData.temperatureCelcius)
                property string pressRoom:          "1.0005"
                property string paoCons:            "0.0005"
                property string paoConsExh:         "0.0005"
                property string dfParPenet:         "0.0000"
                property string ifParPenet:         "0.0000"
                property int    noLaskin:           2
                property int    noLaskinExh:           2
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
                //
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

            function generatePayload(pftr, pfcr){

                let meaUnitStr = MachineData.measurementUnit ? 'imp' : 'metric'
                let precision = MachineData.measurementUnit ? 0 : 2
                let precisionTol = MachineData.measurementUnit ? 0 : 3

                let ifnpc = Number(MachineData.machineProfile['airflow']['ifa']['dim']["nominal"][meaUnitStr]['velocity']).toFixed(precision)
                    + " ± "
                    + Number(MachineData.machineProfile['airflow']['ifa']['dim']["nominal"][meaUnitStr]['velocityTol']).toFixed(precisionTol)
                    + " "
                    + (MachineData.measurementUnit ? "fpm" : "m/s")

                let ifmpc = Number(MachineData.machineProfile['airflow']['ifa']['dim']["minimum"][meaUnitStr]['velocity']).toFixed(precision)
                    + " ± "
                    + Number(MachineData.machineProfile['airflow']['ifa']['dim']["minimum"][meaUnitStr]['velocityTol']).toFixed(precisionTol)
                    + " "
                    + (MachineData.measurementUnit ? "fpm" : "m/s")

                let ifspc = Number(MachineData.machineProfile['airflow']['ifa']['dim']["stb"][meaUnitStr]['velocity']).toFixed(precision)
                    + " ± "
                    + Number(MachineData.machineProfile['airflow']['ifa']['dim']["stb"][meaUnitStr]['velocityTol']).toFixed(precisionTol)
                    + " "
                    + (MachineData.measurementUnit ? "fpm" : "m/s")

                let dfnpc = Number(MachineData.machineProfile['airflow']['dfa']['nominal'][meaUnitStr]['velocity']).toFixed(precision)
                    + " ± "
                    + Number(MachineData.machineProfile['airflow']['dfa']['nominal'][meaUnitStr]['velocityTol']).toFixed(precision)
                    + " "
                    + (MachineData.measurementUnit ? "fpm" : "m/s")

                let dfmnpc = Number(MachineData.machineProfile['airflow']['dfa']['minimum'][meaUnitStr]['velocity']).toFixed(precision)
                    + " ± "
                    + Number(MachineData.machineProfile['airflow']['dfa']['minimum'][meaUnitStr]['velocityTol']).toFixed(precision)
                    + " "
                    + (MachineData.measurementUnit ? "fpm" : "m/s")

                let dfmxpc = Number(MachineData.machineProfile['airflow']['dfa']['maximum'][meaUnitStr]['velocity']).toFixed(precision)
                    + " ± "
                    + Number(MachineData.machineProfile['airflow']['dfa']['maximum'][meaUnitStr]['velocityTol']).toFixed(precision)
                    + " "
                    + (MachineData.measurementUnit ? "fpm" : "m/s")

                //                console.log(ifnpc)
                //                console.log(ifmpc)
                //                console.log(ifspc)
                //                console.log(dfnpc)

                const dataTestReport = {
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

                    "room_temp":            MachineData.measurementUnit ? settingsCert.tempRoomImp : settingsCert.tempRoom,
                    "room_press":           settingsCert.pressRoom,

                    "pao_con":              settingsCert.paoCons,
                    "pao_con_exh":          settingsCert.paoConsExh,
                    "df_par_penet":         settingsCert.dfParPenet,
                    "if_par_penet":         settingsCert.ifParPenet,

                    "noz_laskin":           settingsCert.noLaskin,
                    "noz_laskin_exh":       settingsCert.noLaskinExh,
                    "damper_opening":       MachineData.measurementUnit ? settingsCert.damperOpenImp : settingsCert.damperOpen,

                    "grid_ifa_nom":         settingsGeneral.ifaCalGridNom,
                    "grid_ifa_nom_total":   MachineData.measurementUnit ? settingsGeneral.ifaCalGridNomTotImp : settingsGeneral.ifaCalGridNomTot,
                    "grid_ifa_nom_avg":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridNomAvgImp : settingsGeneral.ifaCalGridNomAvg,
                    "grid_ifa_nom_vel":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridNomVelImp : settingsGeneral.ifaCalGridNomVel,
                    "ducy_nom_ifa":         settingsGeneral.ifaCalGridNomDcy,
                    "rpm_nom_ifa":          settingsGeneral.ifaCalGridNomRpm,
                    "grid_ifa_nom_spec":    ifnpc,

                    "grid_ifa_fail":        settingsGeneral.ifaCalGridMin,
                    "grid_ifa_fail_total":  MachineData.measurementUnit ? settingsGeneral.ifaCalGridMinTotImp : settingsGeneral.ifaCalGridMinTot,
                    "grid_ifa_fail_avg":    MachineData.measurementUnit ? settingsGeneral.ifaCalGridMinAvgImp : settingsGeneral.ifaCalGridMinAvg,
                    "grid_ifa_fail_vel":    MachineData.measurementUnit ? settingsGeneral.ifaCalGridMinVelImp : settingsGeneral.ifaCalGridMinVel,
                    "ducy_fail_ifa":        settingsGeneral.ifaCalGridMinDcy,
                    "rpm_fail_ifa":         settingsGeneral.ifaCalGridMinRpm,
                    "grid_ifa_fail_spec":   ifmpc,

                    "grid_ifa_stb":         settingsGeneral.ifaCalGridStb,
                    "grid_ifa_stb_total":   MachineData.measurementUnit ? settingsGeneral.ifaCalGridStbTotImp : settingsGeneral.ifaCalGridStbTot,
                    "grid_ifa_stb_avg":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridStbAvgImp : settingsGeneral.ifaCalGridStbAvg,
                    "grid_ifa_stb_vel":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridStbVelImp : settingsGeneral.ifaCalGridStbVel,
                    "ducy_stb_ifa":         settingsGeneral.ifaCalGridStbDcy,
                    "rpm_stb_ifa":          settingsGeneral.ifaCalGridStbRpm,
                    "ducy_stb_dfa":         MachineData.getFanInflowStandbyDutyCycleFactory(),
                    "rpm_stb_dfa":          MachineData.getFanInflowStandbyRpmFactory(),
                    "grid_ifa_stb_spec":    ifspc,

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
                    "grid_dfa_nom_spec":    dfnpc,

                    "grid_dfa_fail":         settingsGeneral.dfaCalGridMin,
                    "grid_dfa_fail_avg":     MachineData.measurementUnit ? settingsGeneral.dfaCalGridMinVelImp : settingsGeneral.dfaCalGridMinVel,
                    "grid_dfa_fail_total":   MachineData.measurementUnit ? settingsGeneral.dfaCalGridMinVelTotImp : settingsGeneral.dfaCalGridMinVelTot,
                    "grid_dfa_fail_dev":     MachineData.measurementUnit ? settingsGeneral.dfaCalGridMinVelDevImp : settingsGeneral.dfaCalGridMinVelDev,
                    "grid_dfa_fail_devp":    settingsGeneral.dfaCalGridMinVelDevp,
                    "grid_dfa_fail_lowest":  MachineData.measurementUnit ? settingsGeneral.dfaCalGridMinVelLowImp : settingsGeneral.dfaCalGridMinVelLow,
                    "grid_dfa_fail_highest": MachineData.measurementUnit ? settingsGeneral.dfaCalGridMinVelHighImp : settingsGeneral.dfaCalGridMinVelHigh,
                    "grid_dfa_fail_count":   MachineData.machineProfile['airflow']['dfa']['minimum']['grid']['count'],
                    "grid_dfa_fail_columns": MachineData.machineProfile['airflow']['dfa']['minimum']['grid']['columns'],
                    "ducy_fail_dfa":         settingsGeneral.dfaCalGridMinDcy,
                    "rpm_fail_dfa":          settingsGeneral.dfaCalGridMinRpm,
                    "grid_dfa_fail_spec":    dfmnpc,

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
                    "grid_dfa_max_spec":    dfmxpc,

                    "adc_iff":              MachineData.getInflowAdcPointFactory(1),
                    "adc_ifn":              MachineData.getInflowAdcPointFactory(2),
                    "adc_ifa":              settingsCert.ifaAdcActual,
                    "adc_if0":              MachineData.getInflowAdcPointFactory(0),
                    "adc_if1":              MachineData.getInflowAdcPointFactory(1),
                    "adc_if2":              MachineData.getInflowAdcPointFactory(2),
                    "adc_range_ifa":        MachineData.getInflowAdcPointFactory(2) - MachineData.getInflowAdcPointFactory(0),

                    "adc_dff":              MachineData.getDownflowAdcPointFactory(1),
                    "adc_dfn":              MachineData.getDownflowAdcPointFactory(2),
                    "adc_dfa":              settingsCert.dfaAdcActual,
                    "adc_df0":              MachineData.getDownflowAdcPointFactory(0),
                    "adc_df1":              MachineData.getDownflowAdcPointFactory(1),
                    "adc_df2":              MachineData.getDownflowAdcPointFactory(2),
                    "adc_range_dfa":        MachineData.getDownflowAdcPointFactory(2) - MachineData.getDownflowAdcPointFactory(0),

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

                    /*                    "fan_hp":               MachineData.machineProfile['fan']['horsePower'],
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
                    "fcoa4":               Qt.md5(MachineData.machineProfile['fan']['constant']['a4'])
                }//

                const dataTestReportStringify = JSON.stringify(dataTestReport)

                const dataPayload = {
                    "pftr": pftr,
                    "pfcr": pfcr,
                    "details": dataTestReportStringify
                }//

                return dataPayload
                //                //console.log()
            }//

            Item {
                id: serverResponseMessageItem
                anchors.fill: parent
                visible: false

                Rectangle {
                    anchors.fill: parent
                    color: "#DC143C"
                    radius: 5
                }//

                ColumnLayout {
                    anchors.fill: parent

                    Rectangle {
                        Layout.minimumHeight: 30
                        Layout.fillWidth: true
                        color: "#0F2952"

                        TextApp {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("Server Response")
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        ScrollView {
                            id: view
                            anchors.fill: parent

                            TextArea {
                                id: serverResponseMessageTextArea
                                //                                    text: "TextArea\n...\n...\n...\n...\n...\n...\n"
                                font.pixelSize: 20
                                color: "#e3dac9"
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            }//
                        }//
                    }//

                    Rectangle {
                        Layout.minimumHeight: 50
                        Layout.fillWidth: true
                        color: "#0F2952"
                        opacity: serverInfoMouseArea.pressed ? 0.5 : 1

                        TextApp {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("Close")
                        }//

                        MouseArea {
                            id: serverInfoMouseArea
                            anchors.fill: parent
                            onClicked: {
                                sectionStackView.replace(connectTargetComp)
                            }//
                        }//
                    }//
                }//
            }//
        }//
    }//

    Component {
        id: sendServerDoneComponent

        Item {
            id: sendServerDoneItem

            Column {
                anchors.centerIn: parent
                spacing: 10

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "qrc:/UI/Pictures/flat-ui_printer.png"

                    Rectangle {
                        height: 10
                        width: 100
                        radius: 5
                        color: "#27ae60"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: parent.height * 0.375

                        Timer {
                            id: blinkAnimTimer
                            running: true;
                            interval: 2000
                            onTriggered: {
                                stop()
                                parent.opacity = !parent.opacity
                                interval = parent.opacity ? 2000 : 200
                                start()
                            }//
                        }//
                    }//
                }//

                Column {
                    TextApp {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Certification data has been sent to server!")
                    }//

                    TextApp {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("It will take a moment before the document actually printed.") + "<br>" +
                              qsTr("Please check on the printer's queue if necessary.")
                    }//
                }//

                TextApp {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.underline: true
                    text: qsTr("Got problem? Send again.")

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            sectionStackView.replace(connectTargetComp, StackView.PopTransition)
                        }//
                    }//
                }//
            }//
        }//
    }//

    UtilsApp{
        id: utils
    }

    QtObject {
        id: props

        property var printerDevices: [{}]
        property var testReportTemplates: [{}]

        function showDialogFailComServer(){
            viewApp.showDialogMessage(qsTr("Attention!"),
                                      qsTr("Failed to communicate with server!"), viewApp.dialogAlert)
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:640}
}
##^##*/

/*
import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import UI.CusCom 1.1

Item {
    StackView {
        id: sectionStackView
        anchors.fill: parent

        Component.onCompleted: {
            //            sectionStackView.push(addressTargetComp)
            sectionStackView.push(printerComponent)
        }//
    }//

    Component {
        id: addressTargetComp
        Item {
            Column {
                anchors.centerIn: parent
                //        columnSpacing: 10
                spacing: 10
                //        columns: 1

                Column {
                    spacing: 5
                    TextApp {
                        text: "Server IPv4"
                    }//

                    TextFieldApp {
                        width: 300
                        height: 40

                        onPressed: {
                            KeyboardOnScreenCaller.openKeyboard(this,"Full Name")
                        }//
                    }//
                }//

                ButtonBarApp {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Send")
                    imageSource: "qrc:/UI/Pictures/upload-icon-35px.png"

                    onClicked: {
                        sectionStackView.push(printerComponent)
                    }//
                }//
            }//
        }//
    }//

    Component {
        id: printerComponent
        Item {
            Column {
                anchors.centerIn: parent
                //        columnSpacing: 10
                spacing: 10
                //        columns: 1

                Row {
                    spacing: 5

                    Column {
                        spacing: 5

                        TextApp {
                            text: "Test Report to"
                        }//

                        Rectangle {
                            height: 100
                            width: 300
                            radius: 5
                            color: "transparent"
                            border.width: 2
                            border.color: "#e3dac9"

                            ListView {
                                id: reportToFirstListview
                                anchors.fill: parent
                                anchors.margins: 5
                                clip: true
                                spacing: 2

                                model: [
                                    {'id': 1, 'name': "PDF file (saved on server)"},
                                    {'id': 1, 'name': "Test Room - Cassete 1"},
                                    {'id': 1, 'name': "Test Room - Cassete 2"}
                                ]

                                delegate: Rectangle {
                                    height: 40
                                    width: parent.width
                                    color: "#0F2952"

                                    RowLayout{
                                        anchors.fill: parent
                                        anchors.margins: 5

                                        Text {
                                            text: modelData['name']
                                            verticalAlignment: Text.AlignVCenter
                                            anchors.margins: 5
                                            font.pixelSize: 20
                                            color: "#e3dac9"
                                            elide: Text.ElideMiddle

                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                        }//

                                        Rectangle {
                                            visible: reportToFirstListview.currentIndex == index
                                            radius: 10
                                            Layout.minimumHeight: 20
                                            Layout.minimumWidth: 20

                                            color: "#27ae60"
                                        }//
                                    }//

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            reportToFirstListview.currentIndex = index
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//

                    Column {
                        spacing: 5

                        TextApp {
                            text: "Cert Report to"
                        }//

                        Rectangle {
                            height: 100
                            width: 300
                            radius: 5
                            color: "transparent"
                            border.width: 2
                            border.color: "#e3dac9"

                            ListView {
                                id: reportToSecondListview
                                anchors.fill: parent
                                anchors.margins: 5
                                clip: true
                                spacing: 2

                                model: [
                                    {'id': 1, 'name': "PDF file (saved on server)"},
                                    {'id': 1, 'name': "Test Room - Cassete 1"},
                                    {'id': 1, 'name': "Test Room - Cassete 2"}
                                ]

                                delegate: Rectangle {
                                    height: 40
                                    width: parent.width
                                    color: "#0F2952"

                                    RowLayout{
                                        anchors.fill: parent
                                        anchors.margins: 5

                                        Text {
                                            text: modelData['name']
                                            verticalAlignment: Text.AlignVCenter
                                            anchors.margins: 5
                                            font.pixelSize: 20
                                            color: "#e3dac9"
                                            elide: Text.ElideMiddle

                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                        }//

                                        Rectangle {
                                            visible: reportToSecondListview.currentIndex == index
                                            radius: 10
                                            Layout.minimumHeight: 20
                                            Layout.minimumWidth: 20

                                            color: "#27ae60"
                                        }//
                                    }//

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            reportToSecondListview.currentIndex = index
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//
                }//

                ButtonBarApp {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Send")
                    imageSource: "qrc:/UI/Pictures/upload-icon-35px.png"

                    onClicked: {
                        ///called funtion on the root viewApp
                        showBusyPage(qsTr("Send to server..."), function(cycle){})
                    }//
                }//
            }//
        }//
    }//
}//
*/
