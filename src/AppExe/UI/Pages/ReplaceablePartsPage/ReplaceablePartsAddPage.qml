/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Ahmad Qodri
**/

import QtQuick 2.15
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.1
import Qt.labs.platform 1.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0
import ReplaceableCompRecordQmlApp 1.0

ViewApp {
    id: viewApp
    title: "Replaceable Components Record - Add"

    background.sourceComponent: Item {

    }

    content.asynchronous: true
    content.sourceComponent: ContentItemApp{
        id: contentView
        height: viewApp.height
        width: viewApp.width

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 5

            /// HEADER
            Item {
                id: headerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 60

                HeaderApp {
                    id: headerApp
                    anchors.fill: parent
                    title: qsTr("Replaceable Components Record - Add")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Loader {
                    id: fragmentLoader
                    anchors.fill: parent
                    asynchronous: true

                    Component.onCompleted: setSource("Fragments/ProfileFragment.qml", {})
                }//

                BusyPageBlockApp{
                    anchors.fill: parent
                    anchors.centerIn: parent
                    visible: fragmentLoader.status == Loader.Loading
                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 70

             BackgroundButtonBarApp {
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 5

                        ButtonBarApp {
                            Layout.minimumWidth: 194
                            Layout.fillHeight: true

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                let index = pageIndexListView.currentIndex
                                index = index - 1
                                if(index >= 0){
                                    const modelData = pageIndexListView.model
                                    fragmentLoader.setSource(modelData[index]["link"], {})

                                    pageIndexListView.currentIndex = index
                                }
                                else {
                                    props.confirmBackToClose();
                                }//
                            }//
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            ListView {
                                id: pageIndexListView
                                height: 50
                                //                                width: parent.width
                                width: Math.min(parent.width, ((childWidth + spacing) * count) - spacing)
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                orientation: ListView.Horizontal
                                spacing: 5
                                clip: true
                                //                                snapMode: ListView.SnapToItem
                                //                                preferredHighlightBegin: (pageIndexListView.width / 2) - 75
                                //                                preferredHighlightEnd: (pageIndexListView.width / 2) + 75
                                //                                highlightRangeMode: ListView.ApplyRange

                                model: [
                                    {"title": qsTr("Profile"),              "link": "Fragments/ProfileFragment.qml"},
                                    {"title": qsTr("SBC Set"),              "link": "Fragments/SbcSetFragments.qml"},
                                    {"title": qsTr("Sensors"),              "link": "Fragments/SensorsFragments.qml"},
                                    {"title": qsTr("UV & LED"),             "link": "Fragments/UVLEDFragments.qml"},
                                    {"title": qsTr("PSU"),                  "link": "Fragments/PSUFragments.qml"},
                                    {"title": qsTr("MCB & EMI Filter"),     "link": "Fragments/MCBEMIFragments.qml"},
                                    {"title": qsTr("Contact & Switches"),   "link": "Fragments/ContactSwitchesFragments.qml"},
                                    {"title": qsTr("Blower & Motor"),       "link": "Fragments/BlowerMotorFragments.qml"},
                                    {"title": qsTr("Capacitor & Inductor"), "link": "Fragments/CapInductorFragments.qml"},
                                    {"title": qsTr("Customize"),            "link": "Fragments/CustomizeFragments.qml"},
                                    {"title": qsTr("Filter"),               "link": "Fragments/FilterFragments.qml"},
                                    {"title": qsTr("Print"),                "link": "Fragments/SendRPFormFragment.qml"}
                                ]//

                                property int childWidth: 150

                                delegate: Rectangle {
                                    radius: 5
                                    height: 50
                                    color: pageIndexListView.currentIndex == index ? "#27ae60" : "#7f8c8d"
                                    width: pageIndexListView.childWidth

                                    TextApp {
                                        width: parent.width
                                        height: parent.height
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        wrapMode: Text.WordWrap
                                        text: modelData["title"]
                                        padding: 5
                                    }//

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            fragmentLoader.setSource(modelData["link"], {})
                                            pageIndexListView.currentIndex = index

                                        }//
                                    }//
                                }//

                                onCurrentIndexChanged: {
                                    if(currentIndex == count-1){
                                        const title = qsTr("RP Record - Add")
                                        const msg = qsTr("Press <b>%1</b> button to record the Replaceable Components form.").arg(addButton.text)

                                        showDialogMessage(title, msg, dialogInfo)
                                    }
                                }//
                            }//
                        }//

                        ButtonBarApp {
                            Layout.minimumWidth: 194
                            Layout.fillHeight: true
                            enabled: pageIndexListView.currentIndex != (pageIndexListView.count - 1)
                            visible: enabled
                            opacity: enabled ? 1 : 0.5

                            imageSource: "qrc:/UI/Pictures/next-step.png"
                            text: qsTr("Next")

                            onClicked: {
                                let index = pageIndexListView.currentIndex
                                index = index + 1
                                if (index < pageIndexListView.count ) {
                                    const modelData = pageIndexListView.model
                                    fragmentLoader.setSource(modelData[index]["link"], {})
                                    pageIndexListView.currentIndex = index
                                }
                            }//
                        }//
                        ButtonBarApp {
                            id: addButton
                            Layout.minimumWidth: 194
                            Layout.fillHeight: true
                            enabled: pageIndexListView.currentIndex == (pageIndexListView.count - 1)
                            visible: enabled
                            opacity: enabled ? 1 : 0.5

                            imageSource: "qrc:/UI/Pictures/add-record.png"
                            text: qsTr("Add")

                            onClicked: {
                                const message = qsTr("Ensure all data are correct!")
                                              + "<br>"
                                              + qsTr("Are you sure to add new Replaceable Components form?")
                                showDialogAsk(qsTr("RP Record - Add"),
                                              message,
                                              dialogAlert,
                                              function onAccepted(){
                                                  let date = new Date()
                                                  let dateText = Qt.formatDateTime(date, "yyyy-MM-dd")
                                                  let TimeText = Qt.formatDateTime(date, "hh:mm:ss")

                                                  if(props.getRpList(MachineAPI.RPList_Date) !== dateText)
                                                      MachineAPI.setReplaceablePartsSettings(MachineAPI.RPList_Date, dateText)
                                                  if(props.getRpList(MachineAPI.RPList_Time) !== TimeText)
                                                      MachineAPI.setReplaceablePartsSettings(MachineAPI.RPList_Time, TimeText)

                                                  MachineAPI.insertReplaceableComponentsForm()
                                                  showBusyPage(qsTr("Please wait"),
                                                               function(cycle){
                                                                   if(cycle === MachineAPI.BUSY_CYCLE_2){
                                                                       var intent = IntentApp.create(uri, {})
                                                                       finishView(intent)
                                                                   }//
                                                               })//
                                              })//
                            }//
                        }//
                    }//
                }//
            }//
        }//

        ReplaceablePartsDatabaseApp {
            id: rpApp

            property var group: [
                'sbcSet',//0
                'sensors',//1
                'uvLed',
                'psu',
                'mcbEmi',
                'contactSw',
                'bMotor',
                'capInd',
                'custom',//8
                'filter'//9
            ]//

            Component.onCompleted: {
                props.rpDatabase = database[0]
                // console.debug(props.rpDatabase['sbcSet']['1081321'])
            }
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject{
            id: props

            readonly property int itemcode: 0
            readonly property int description: 1
            readonly property int versionRev: 2
            readonly property int serialNumber: 3

            //            readonly property int profileFragmentValid: 0x0001
            //            readonly property int sbcSetFragmentValid:  0x0002
            //            readonly property int sensorsFragmentValid: 0x0004
            //            readonly property int uvLedFragmentValid:   0x0008
            //            readonly property int psuFragmentValid:     0x0010
            //            readonly property int mcbEmiFragmentValid:  0x0020
            //            readonly property int conSwitchFragmentValid: 0x0040
            //            readonly property int blowerFragmentValid:  0x0080
            //            readonly property int capIndFragmentValid:  0x0100
            //            readonly property int customFragmentValid:  0x0200
            //            readonly property int filterFragmentValid:  0x0400

            //            readonly property int dataValidBitWise: 0x07FF
            //            property int dataValid: 0

            property var rpDatabase: null

            readonly property var maxRowInTable: {
                'sbcSet'    : 15,
                'sensors'   : 5,
                'uvLed'     : 6,
                'psu'       : 5,
                'mcbEmi'    : 5,
                'contactSw' : 5,
                'bMotor'    : 5,
                'capInd'    : 5,
                'custom'    : 8,
                'filter'    : 5
            }//
            readonly property var startEnums: {
                'sbcSet'    : MachineAPI.RPList_SBCSet1Name,
                'sensors'   : MachineAPI.RPList_Sensor1Name,
                'uvLed'     : MachineAPI.RPList_UVLED1Name,
                'psu'       : MachineAPI.RPList_PSU1Name,
                'mcbEmi'    : MachineAPI.RPList_MCBEMI1Name,
                'contactSw' : MachineAPI.RPList_ContactSw1Name,
                'bMotor'    : MachineAPI.RPList_BMotor1Name,
                'capInd'    : MachineAPI.RPList_CapInd1Name,
                'custom'    : MachineAPI.RPList_Custom1Name,
                'filter'    : MachineAPI.RPList_Filter1Name
            }//

            function getRpList(index){
                if(Number.isNaN(index)) {
                    console.debug(index, "Not a Number!")
                    return
                }
                let data = MachineData.rpListLast
                //data.push(value)
                if(data.length <= index){
                    console.debug("RpList on index", index, "unavailaible!")
                    return
                }
                return data[index]
            }//

            function onNewQRCodeDataAccepted(value){
                console.debug("Incoming QRCode data:", value)
                let listParams = []
                const lengthData = String(value).split("#").length
                console.debug(lengthData)
                for(let i=0; i< lengthData; i++)
                    listParams.push(String(value).split("#")[i])

                let key1, key2
                let val1, val2
                if(lengthData == 1){
                    // For CTP Display (No '#')
                    // 1081445 CTP DISPLAY INTERFACE PCB0.7 PCBA07 2101-CDI7-00207 0221
                    key1 = String(value).split(" ")[0]

                    if(String(key1).length == 7){ //if itemcode length valid
                        console.debug(key1)
                        listParams[itemcode] = key1
                        listParams[serialNumber] = "" // Leave blank
                    }//
                }//
                else if(lengthData == 2){
                    // For Unit Model and Electrical FocusPanel
                    // Use this format in QR Code
                    // Model LA2-4S#SN 2022-002101
                    // Panel EP-A-LA2-001#SN EP.11290/22
                    key1 = String(value).split("#")[0].split(" ")[0]
                    key2 = String(value).split("#")[1].split(" ")[0]
                    val1 = String(value).split("#")[0].split(" ")[1]
                    val2 = String(value).split("#")[1].split(" ")[1]

                    const keyValid = (key1 === "Model" || key1 === "Panel") && key2 === "SN"
                    const val1Valid = true
                    const val2Valid = key1 === "Panel" ? (val2 !== "") : (val2.split("-")[0].length === 4 && val2.split("-")[1].length === 6)
                    if(keyValid && val1Valid && val2Valid){
                        addProfile(key1, val1, key2, val2)
                    }//
                    else{
                        console.debug("invalid key or value!")
                    }

                    console.debug("key1", key1, "key2", key2)
                    console.debug("val1", String(value).split("#")[0].split(" ")[1], "val2", String(value).split("#")[1].split(" ")[1])
                    return
                }//

                for(const group of rpApp.group){
                    let brk = false
                    for(let i=0; i<props.rpDatabase[group].length; i++){
                        if(props.rpDatabase[group][i]['id'] === listParams[itemcode]){
                            addPart(group, listParams[itemcode], props.rpDatabase[group][i]['desc'], listParams[versionRev], listParams[serialNumber])
                            brk = true
                            break
                        }//
                    }//
                    if(brk) break
                }//
                console.debug(listParams[itemcode], listParams[description], listParams[versionRev], listParams[serialNumber])
            }//

            function addProfile(key1, val1, key2, val2){
                console.debug("Add profile", key1, val1, key2, val2)
                if(key1 === "Model"){
                    MachineAPI.setReplaceablePartsSettings(MachineAPI.RPList_UnitModel, val1)
                    MachineAPI.setReplaceablePartsSettings(MachineAPI.RPList_UnitSerialNumber, val2)
                    MachineAPI.setSerialNumber(val2)
                }//
                else{
                    MachineAPI.setReplaceablePartsSettings(MachineAPI.RPList_ElectricalPanel, val1)
                    MachineAPI.setReplaceablePartsSettings(MachineAPI.RPList_ElectricalPanelSerialNumber, val2)
                }//
            }//

            function addPart(group, itemCode, name, version, serialNumber){
                let startEnum = startEnums[group]
                const maxRow = maxRowInTable[group]
                let savedItemCode
                let nameEmpty, itemCodeEmpty
                let addQty
                let qty, i

                if(group === rpApp.group[0])            //sbcSet //QR-Format Plain Text: "Item code#Description#Version#SN"
                {
                    for(i=0; i<maxRow; i++){
                        savedItemCode = props.getRpList(Number((startEnum+i) + (1*maxRow)))
                        nameEmpty = String(props.getRpList(Number(startEnum+i))) == String("")
                        itemCodeEmpty = String(savedItemCode) == String("")
                        addQty = String(savedItemCode) == String(itemCode)
                        console.debug("savedItemCode", savedItemCode, "new", itemCode, addQty)

                        if(nameEmpty || addQty || itemCodeEmpty){
                            if(nameEmpty || itemCodeEmpty){
                                if(nameEmpty)
                                    MachineAPI.setReplaceablePartsSettings(startEnum+i, name)
                                if(itemCodeEmpty)
                                    MachineAPI.setReplaceablePartsSettings(((startEnum+i) + (1*maxRow)), itemCode)
                            }//
                            qty = 1;
                            if(addQty){ // only increase qty if it is 0
                                const qtyTemp = Number(props.getRpList(Number(((startEnum+i) + (2*maxRow)))))
                                if(Number.isNaN(qtyTemp))
                                    qty = 0
                                else
                                    qty = qtyTemp;
                                if(!qty)
                                    qty++
                            }//
                            MachineAPI.setReplaceablePartsSettings(((startEnum+i) + (2*maxRow)), String(qty))
                            MachineAPI.setReplaceablePartsSettings(((startEnum+i) + (3*maxRow)), String(serialNumber))

                            /// Set Software version for ESCO SBC Wifi
                            if(String(itemCode) == String("1081370")){
                                MachineAPI.setReplaceablePartsSettings(((startEnum+i) + (3*maxRow)), String(MachineData.getSbcSerialNumber()))
                                const softwareVersion = Qt.application.name + " - " + Qt.application.version
                                MachineAPI.setReplaceablePartsSettings(((startEnum+i) + (4*maxRow)), String(softwareVersion))
                            }//
                            break
                        }//
                    }//
                }//
                else if(((group === rpApp.group[2])    //uvLed //QR-Format Plain Text: "Item code#Description#Version#SN"
                         || (group === rpApp.group[3])    //psu //QR-Format Plain Text: "Item code#Description#Version#SN"
                         || (group === rpApp.group[4])    //mcbEmi //QR-Format Plain Text: "Item code#Description#Version#SN"
                         || (group === rpApp.group[5])    //contactSw //QR-Format Plain Text: "Item code#Description#Version#SN"
                         || (group === rpApp.group[7])    //capInd //QR-Format Plain Text: "Item code#Description#Version#SN"
                         || (group === rpApp.group[8])))   //custom //QR-Format Plain Text: "Item code#Description#Version#SN")
                {
                    for(i=0; i<maxRow; i++){
                        savedItemCode = props.getRpList(Number((startEnum+i) + (1*maxRow)))
                        nameEmpty = String(props.getRpList(Number(startEnum+i))) == String("")
                        itemCodeEmpty = String(savedItemCode) == String("")
                        console.debug("savedItemCode", savedItemCode, "new", itemCode/*, addQty*/)

                        if(nameEmpty || /*addQty ||*/ itemCodeEmpty){
                            if(nameEmpty || itemCodeEmpty){
                                if(nameEmpty)
                                    MachineAPI.setReplaceablePartsSettings(startEnum+i, name)
                                if(itemCodeEmpty)
                                    MachineAPI.setReplaceablePartsSettings(((startEnum+i) + (1*maxRow)), itemCode)
                            }//
                            qty = 1;

                            MachineAPI.setReplaceablePartsSettings(((startEnum+i) + (2*maxRow)), String(qty))
                            MachineAPI.setReplaceablePartsSettings(((startEnum+i) + (3*maxRow)), String(serialNumber))

                            break
                        }//
                    }//
                }
                else if(group === rpApp.group[1]) //sensors //QR-Format Plain Text: "Item code#Description#Constant#SN"
                {
                    for(i=0; i<maxRow; i++){
                        savedItemCode = props.getRpList(Number((startEnum+i) + (1*maxRow)))
                        nameEmpty = String(props.getRpList(Number(startEnum+i))) == String("")
                        itemCodeEmpty = String(savedItemCode) == String("")
                        console.debug("savedItemCode", savedItemCode, "new", itemCode/*, addQty*/)

                        if(nameEmpty || /*addQty ||*/ itemCodeEmpty){
                            if(nameEmpty || itemCodeEmpty){
                                if(nameEmpty)
                                    MachineAPI.setReplaceablePartsSettings(startEnum+i, name)
                                if(itemCodeEmpty)
                                    MachineAPI.setReplaceablePartsSettings(((startEnum+i) + (1*maxRow)), itemCode)
                            }//
                            qty = 1;
                            MachineAPI.setReplaceablePartsSettings(((startEnum+i) + (2*maxRow)), String(qty))
                            MachineAPI.setReplaceablePartsSettings(((startEnum+i) + (3*maxRow)), String(serialNumber))
                            const constant = String(version)
                            MachineAPI.setReplaceablePartsSettings(((startEnum+i) + (4*maxRow)), constant)

                            break
                        }//
                    }//
                }//
                else if(group === rpApp.group[6]) //bMotor //QR-Format Plain Text: "Item code#Description#SNMotor#SNBlower"
                {
                    for(i=0; i<maxRow; i++){
                        savedItemCode = props.getRpList(Number((startEnum+i) + (1*maxRow)))
                        nameEmpty = String(props.getRpList(Number(startEnum+i))) == String("")
                        itemCodeEmpty = String(savedItemCode) == String("")
                        console.debug("savedItemCode", savedItemCode, "new", itemCode/*, addQty*/)

                        if(nameEmpty || /*addQty ||*/ itemCodeEmpty){
                            if(nameEmpty || itemCodeEmpty){
                                if(nameEmpty)
                                    MachineAPI.setReplaceablePartsSettings(startEnum+i, name)
                                if(itemCodeEmpty)
                                    MachineAPI.setReplaceablePartsSettings(((startEnum+i) + (1*maxRow)), itemCode)
                            }//
                            qty = 1;

                            MachineAPI.setReplaceablePartsSettings(((startEnum+i) + (2*maxRow)), String(qty))

                            const serialNumberMotor = String(version)
                            const serialNumberBlower = String(serialNumber)
                            MachineAPI.setReplaceablePartsSettings(((startEnum+i) + (3*maxRow)), serialNumberMotor)
                            MachineAPI.setReplaceablePartsSettings(((startEnum+i) + (4*maxRow)), serialNumberBlower)

                            break
                        }//
                    }//
                }
                else if(group === rpApp.group[9]) //filter //QR-Format Plain Text: "Item code#Description#Size#SN"
                {
                    for(i=0; i<maxRow; i++){
                        savedItemCode = props.getRpList(Number((startEnum+i) + (1*maxRow)))
                        nameEmpty = String(props.getRpList(Number(startEnum+i))) == String("")
                        itemCodeEmpty = String(savedItemCode) == String("")
                        //                        addQty = String(savedItemCode) == String(itemCode)
                        console.debug("savedItemCode", savedItemCode, "new", itemCode/*, addQty*/)

                        if(nameEmpty || /*addQty || */itemCodeEmpty){
                            if(nameEmpty || itemCodeEmpty){
                                if(nameEmpty)
                                    MachineAPI.setReplaceablePartsSettings(startEnum+i, name)
                                if(itemCodeEmpty)
                                    MachineAPI.setReplaceablePartsSettings(((startEnum+i) + (1*maxRow)), itemCode)
                            }//
                            qty = 1;
                            //                            if(addQty){
                            //                                const qtyTemp = Number(props.getRpList(Number(((startEnum+i) + (2*maxRow)))))
                            //                                if(Number.isNaN(qtyTemp))
                            //                                    qty = 0
                            //                                else
                            //                                    qty = qtyTemp;
                            //                                if(!qty)
                            //                                    qty++
                            //                            }//
                            MachineAPI.setReplaceablePartsSettings(((startEnum+i) + (2*maxRow)), String(qty))
                            //                            if(nameEmpty){
                            const size = String(version)
                            MachineAPI.setReplaceablePartsSettings(((startEnum+i) + (3*maxRow)), serialNumber)
                            MachineAPI.setReplaceablePartsSettings(((startEnum+i) + (4*maxRow)), size)
                            //                            }//
                            break
                        }//
                    }//
                }//
            }//

            function confirmBackToClose(){
                //                viewApp.showDialogAsk()
                const message = qsTr("Are you sure want to close?")
                showDialogAsk(qsTr("RP Record - Add"),
                              message,
                              dialogAlert,
                              function onAccepted(){
                                  showBusyPage(qsTr("Please wait"),
                                               function(cycle){
                                                   if(cycle === MachineAPI.BUSY_CYCLE_1){
                                                       var intent = IntentApp.create(uri, {})
                                                       finishView(intent)
                                                   }//
                                               })//
                              })//
            }//
            function confirmBackToCloseGoToHome(){
                const message = qsTr("Are you sure want to close?")
                showDialogAsk(qsTr("RP Record - Add"),
                              message,
                              dialogAlert,
                              function onAccepted(){
                                  showBusyPage(qsTr("Please wait"),
                                               function(cycle){
                                                   if(cycle === MachineAPI.BUSY_CYCLE_1){
                                                       const intent = IntentApp.create("", {})
                                                       startRootView(intent)
                                                   }//
                                               })//
                              })//
            }//
        }//

        /// called Once but after onResume
        //        Component.onCompleted: {

        //        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                /// override gesture swipe action
                /// basicly dont allow gesture shortcut to home page during calibration
                viewApp.fnSwipedFromLeftEdge = function(){
                    props.confirmBackToClose()
                }//

                viewApp.fnSwipedFromBottomEdge = function(){
                    props.confirmBackToCloseGoToHome()
                }//

                MachineAPI.setFrontEndScreenState(MachineAPI.ScreenState_ReplaceableComponent)

                console.debug("Connected")
                MachineData.keyboardStringOnAcceptedEventSignal.connect(props.onNewQRCodeDataAccepted)
            }//

            /// onPause
            Component.onDestruction: {
                console.debug("Disconnected")
                MachineData.keyboardStringOnAcceptedEventSignal.disconnect(props.onNewQRCodeDataAccepted)
                //
                MachineAPI.setFrontEndScreenState(MachineAPI.ScreenState_Other)
            }//
        }//
    }//
}//
