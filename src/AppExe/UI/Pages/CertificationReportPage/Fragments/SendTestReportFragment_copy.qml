import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import UI.CusCom 1.0
import Qt.labs.settings 1.1
import ModulesCpp.Machine 1.0

Item {

    StackView {
        id: sectionStackView
        anchors.fill: parent
        //        initialItem: printerComponent

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
                        viewApp.showBusyPage(qsTr("Connecting..."), function onCallback(cycle){
                            if (cycle === 30){
                                /// time out after 3o second
                                viewApp.closeDialog()
                            }
                        })


                        let xhttpTemplates = new XMLHttpRequest()
                        const url1 = "http://" + settingsCert.serverIPv4 + "/bsc/api-test-report-templates/"
                        //console.log("XMLHttpRequest-url:" + url1)
                        xhttpTemplates.open("GET", url1, true);
                        //                        xhttpTemplates.setRequestHeader('Content-Type', 'application/json');

                        xhttpTemplates.onreadystatechange = function(){
                            if(xhttpTemplates.readyState === XMLHttpRequest.DONE) {
                                const xstatus = xhttpTemplates.status
                                //console.log("XMLHttpRequest:" + xstatus)
                                if(xstatus === 200) {
                                    viewApp.closeDialog()

                                    const reponseText = xhttpTemplates.responseText
                                    //console.log(reponseText)

                                    let model = JSON.parse(reponseText)
                                    model.unshift({"id":0, "name": "Press here to select"});
                                    props.testReportTemplates = model
                                    //                                    props.testReportTemplates = JSON.parse(reponseText)

                                    let xhttpPrinter = new XMLHttpRequest()
                                    const url2 = "http://" + settingsCert.serverIPv4 + "/bsc/api-printer-devices/"
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
                                                model.unshift({"id":0, "name": "Press here to select"});
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
                                else {
                                    //console.log(1)
                                    props.showDialogFailComServer()
                                }//
                            }//
                        }//
                        xhttpTemplates.send()
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

                    Column {
                        spacing: 5

                        TextApp {
                            text: qsTr("Test Report Template")
                        }//

                        ComboBoxApp {
                            id: templateTestReportCombox
                            width: 300
                            font.pixelSize: 20

                            textRole: 'name'
                            model: props.testReportTemplates

                            //                            model: [
                            //                                {'id': 1, 'name': "LA2-4 (NSF)"},
                            //                                {'id': 1, 'name': "LA2-4 (EN)"},
                            //                            ]
                        }//
                    }//

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
                        if(!templateTestReportCombox.currentIndex || !printerForTestReportCombox.currentIndex || !printerForCertCombox.currentIndex) {
                            viewApp.showDialogMessage(qsTr("Attention!"),
                                                      qsTr("Please select the valid option for all the forms!"),
                                                      viewApp.dialogAlert)
                            return
                        }

                        viewApp.showBusyPage(qsTr("Sending..."), function onCallback(cycle){
                            if (cycle === 30){
                                /// time out after 3o second
                                viewApp.closeDialog()
                            }
                        })

                        const template          = templateTestReportCombox.currentText
                        const printerForReport  = printerForTestReportCombox.currentText
                        const printerForCert    = printerForCertCombox.currentText

                        const varString =   printeToServerItem.generatePayload(template, printerForReport, printerForCert)
                        //                        //console.log("var string " + varString)

                        let xhttpPrinter = new XMLHttpRequest()
                        const url = "http://" + settingsCert.serverIPv4 + "/bsc/api-save-print-test-reports/"
                        //console.log("XMLHttpRequest-url:" + url)
                        xhttpPrinter.open("POST", url, true);
                        xhttpPrinter.setRequestHeader('Content-Type', 'application/json');

                        xhttpPrinter.onreadystatechange = function(){
                            if(xhttpPrinter.readyState === XMLHttpRequest.DONE) {
                                const xstatus = xhttpPrinter.status
                                //console.log("XMLHttpRequest:" + xstatus)
                                //console.log(xstatus)
                                if(xstatus === 200) {
                                    viewApp.closeDialog()

                                    const reponseText = xhttpPrinter.responseText
                                    //                                    //console.log(reponseText)

                                    viewApp.closeDialog()
                                    sectionStackView.replace(sendServerDoneComponent)
                                }
                                else {
                                    //console.log(5)
                                    props.showDialogFailComServer()
                                }
                            }
                        }
                        xhttpPrinter.send(JSON.stringify(varString))
                    }//
                }//
            }//

            Settings {
                id: settingsGeneral

                property string ifaCalGridNom: "[]"
                property int    ifaCalGridNomTot: 0
                property int    ifaCalGridNomAvg: 0
                property int    ifaCalGridNomVol: 0
                property int    ifaCalGridNomVel: 0
                property int    ifaCalGridNomDcy: 0
                property int    ifaCalGridNomRpm: 0

                property string ifaCalGridMin: "[]"
                property int    ifaCalGridMinTot: 0
                property int    ifaCalGridMinAvg: 0
                property int    ifaCalGridMinVol: 0
                property int    ifaCalGridMinVel: 0
                property int    ifaCalGridMinDcy: 0
                property int    ifaCalGridMinRpm: 0

                property string ifaCalGridStb: "[]"
                property int    ifaCalGridStbTot: 0
                property int    ifaCalGridStbAvg: 0
                property int    ifaCalGridStbVol: 0
                property int    ifaCalGridStbVel: 0
                property int    ifaCalGridStbDcy: 0
                property int    ifaCalGridStbRpm: 0

                property string dfaCalGridNom:          "[]"
                property int    dfaCalGridNomVel:       0
                property int    dfaCalGridNomVelTot:    0
                property int    dfaCalGridNomVelDev:    0
                property int    dfaCalGridNomVelDevp:   0
                property int    dfaCalGridNomVelHigh:   0
                property int    dfaCalGridNomVelLow:    0
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
                property int    tempRoom:           MachineData.temperature
                property string pressRoom:          "1.0005"
                property string paoCons:            "0.0005"
                property int    noLaskin:           2
                property string    damperOpen:         "10"
                property string    damperOpenImp:         "2/5"

                property int    mvInitialFanDucy:   0
                property int    mvInitialFanRpm:    0
                property string mvInitialDfa:       "0"
                property string mvInitialIfa:       "0"
                property string mvInitialPower:     "0"

                property int    mvBlockFanDucy:     0
                property int    mvBlockFanRpm:      0
                property string mvBlockDfa:         "0"
                property string mvBlockIfa:         "0"
                property string mvBlockPower:       "0"

                property int    mvFinalFanDucy:     0
                property int    mvFinalFanRpm:      0
                property string mvFinalDfa:         "0"
                property string mvFinalIfa:         "0"

                property string sensorVdc:   "0"
                property int adcActual:      -1

                property string testerName:         ""
                property string testerSignature:    ""
                property string checkerName:        ""
                property string checkerSignature:   ""

                property string customer:           "WORLD-MTR"
                property string country:            "SINGAPORE"
                property string dateTest:           Qt.formatDate(new Date, "dd-MMM-yyyy")
                property string swVersion:          Qt.application.name + " - " + Qt.application.version
            }//

            function generatePayload(trt, pftr, pfcr){
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

                    "room_temp":            settingsCert.tempRoom,
                    "room_press":           settingsCert.pressRoom,

                    "pao_con":              settingsCert.paoCons,
                    "noz_laskin":           settingsCert.noLaskin,
                    "damper_opening":       MachineData.measurementUnit ? settingsCert.damperOpenImp : settingsCert.damperOpen,

                    "grid_ifa_nom":         settingsGeneral.ifaCalGridNom,
                    "grid_ifa_nom_total":   settingsGeneral.ifaCalGridNomTot,
                    "grid_ifa_nom_avg":     settingsGeneral.ifaCalGridNomAvg,
                    "grid_ifa_nom_vel":     settingsGeneral.ifaCalGridNomVel,
                    "ducy_nom":             settingsGeneral.ifaCalGridNomDcy,
                    "rpm_nom":              settingsGeneral.ifaCalGridNomRpm,

                    "grid_ifa_fail":        settingsGeneral.ifaCalGridMin,
                    "grid_ifa_fail_total":  settingsGeneral.ifaCalGridMinTot,
                    "grid_ifa_fail_avg":    settingsGeneral.ifaCalGridMinAvg,
                    "grid_ifa_fail_vel":    settingsGeneral.ifaCalGridMinVel,
                    "ducy_fail":            settingsGeneral.ifaCalGridMinDcy,
                    "rpm_fail":             settingsGeneral.ifaCalGridMinRpm,

                    "grid_ifa_stb":         settingsGeneral.ifaCalGridStb,
                    "grid_ifa_stb_total":   settingsGeneral.ifaCalGridStbTot,
                    "grid_ifa_stb_avg":     settingsGeneral.ifaCalGridStbAvg,
                    "grid_ifa_stb_vel":     settingsGeneral.ifaCalGridStbVel,
                    "ducy_stb":             settingsGeneral.ifaCalGridStbDcy,
                    "rpm_stb":              settingsGeneral.ifaCalGridStbRpm,

                    "grid_dfa_nom":         settingsGeneral.dfaCalGridNom,
                    "grid_dfa_nom_avg":     settingsGeneral.dfaCalGridNomVel,
                    "grid_dfa_nom_total":   settingsGeneral.dfaCalGridNomVelTot,
                    "grid_dfa_nom_dev":     settingsGeneral.dfaCalGridNomVelDev,
                    "grid_dfa_nom_devp":    settingsGeneral.dfaCalGridNomVelDevp,
                    "grid_dfa_nom_lowest":  settingsGeneral.dfaCalGridNomVelLow,
                    "grid_dfa_nom_highest": settingsGeneral.dfaCalGridNomVelHigh,
                    "grid_dfa_nom_count":   MachineData.machineProfile['airflow']['dfa']['nominal']['grid']['count'],
                    "grid_dfa_nom_columns": MachineData.machineProfile['airflow']['dfa']['nominal']['grid']['columns'],

                    "adc_iff":              MachineData.getInflowAdcPointFactory(1),
                    "adc_ifn":              MachineData.getInflowAdcPointFactory(2),
                    "adc_ifa":              settingsCert.adcActual,
                    "adc_if0":              MachineData.getInflowAdcPointFactory(0),
                    "adc_if1":              MachineData.getInflowAdcPointFactory(1),
                    "adc_if2":              MachineData.getInflowAdcPointFactory(2),
                    "adc_range":            MachineData.getInflowAdcPointFactory(2) - MachineData.getInflowAdcPointFactory(1),
                    "calib_temp_adc":       MachineData.getInflowTempCalibAdc(),
                    "calib_temp":           MachineData.getInflowTempCalib(),
                    "sensor_voltage":       settingsCert.sensorVdc,
                    "sensor_constant":      MachineData.getInflowSensorConstant(),

                    "mv_initial_ducy":      settingsCert.mvInitialFanDucy,
                    "mv_initial_rpm":       settingsCert.mvInitialFanRpm,
                    "mv_initial_downflow":  settingsCert.mvInitialDfa,
                    "mv_initial_inflow":    settingsCert.mvInitialIfa,
                    "mv_initial_power":     settingsCert.mvInitialPower,

                    "mv_blocked_ducy":      settingsCert.mvBlockFanDucy,
                    "mv_blocked_rpm":       settingsCert.mvBlockFanRpm,
                    "mv_blocked_downflow":  settingsCert.mvBlockDfa,
                    "mv_blocked_inflow":    settingsCert.mvBlockIfa,
                    "mv_blocked_power":     settingsCert.mvBlockPower,

                    "mv_final_ducy":        settingsCert.mvFinalFanDucy,
                    "mv_final_rpm":         settingsCert.mvFinalFanRpm,
                    "mv_final_downflow":    settingsCert.mvFinalDfa,
                    "mv_final_inflow":      settingsCert.mvFinalIfa,

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

                const dataPayload = {
                    "trt":  trt,
                    "pftr": pftr,
                    "pfcr": pfcr,
                    "data": dataTestReport
                }//

                //                let xhttp = new XMLHttpRequest();
                //                const url = "http://" + settingsCert.serverIPv4 + "/bsc/api-test-report-submit-print/"
                //                xhttp.open("POST", url, true);
                //                xhttp.setRequestHeader('Content-Type', 'application/json');

                //                xhttp.onreadystatechange = function() {
                //                    if (xhttp.readyState === XMLHttpRequest.DONE) {
                //                        //console.log(xhttp.status)
                //                        const responseText = xhttp.responseText
                //                        //                        const responseTextTrimed = String(responseText).trim()
                //                        //console.log(responseText)
                //                    }
                //                }

                //                let dataStr = JSON.stringify(dataPayload)
                //                //                //console.log(dataStr)
                //                xhttp.send(dataStr);

                return dataPayload
                //                //console.log()
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

    QtObject {
        id: props

        property var printerDevices: [{}]
        property var testReportTemplates: [{}]

        function showDialogFailComServer(){
            viewApp.showDialogMessage(qsTr("Attention!"),
                                      qsTr("Failed to communicate with server!"), viewApp.dialogAlert)
        }
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#c0c0c0";height:480;width:640}
}
##^##*/

/*
import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import UI.CusCom 1.0

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
