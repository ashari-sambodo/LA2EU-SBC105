import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Connectify 1.0
import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Network"

    background.sourceComponent: Item {
        //        Rectangle{
        //            Component.onCompleted: {
        //                const extraData = IntentApp.getExtraData(intent)
        //                const message = extraData["backgroundBlack"] || 0
        //                if(message) color = "black"
        //            }
        //        }
    }

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
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
                    anchors.fill: parent
                    title: qsTr("Network")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                /// fragment container
                StackView {
                    id: fragmentStackView
                    anchors.fill: parent
                    initialItem: wlanNetworkConfig/*configureComponent*/
                }//
                Item{
                    id: wlanNetworkConfig
                    RowLayout {
                        anchors.fill: parent

                        Item {
                            id: leftItem
                            Layout.fillHeight: true
                            Layout.fillWidth: true


                            ColumnLayout {
                                anchors.fill: parent

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    Column {
                                        anchors.centerIn: parent

                                        Column{
                                            visible: NetworkService.connected || NetworkService.connecting
                                            spacing: 10

                                            TextApp{
                                                id: labelText
                                                text: qsTr("Connected to") + ":"

                                                states: [
                                                    State {
                                                        when: NetworkService.connecting
                                                        PropertyChanges {
                                                            target: labelText
                                                            text: qsTr("Connecting to") + ":"
                                                        }
                                                    }
                                                ]
                                            }

                                            Column {
                                                spacing: 2

                                                TextApp {
                                                    id: currentStatusText
                                                    font.pixelSize: 36
                                                    wrapMode: Text.WordWrap
                                                    fontSizeMode: Text.Fit
                                                    text: qsTr("None")

                                                    width: Math.min(controlMaxWidthText.width, leftItem.width)

                                                    Text {
                                                        visible: false
                                                        id: controlMaxWidthText
                                                        text: currentStatusText.text
                                                        font.pixelSize: 36
                                                    }//

                                                    states: [
                                                        State {
                                                            when: NetworkService.connecting
                                                            PropertyChanges {
                                                                target: currentStatusText
                                                                text: props.wifiSelectedAccessPoint
                                                            }
                                                        }
                                                        ,
                                                        State {
                                                            when: NetworkService.connected
                                                            PropertyChanges {
                                                                target: currentStatusText
                                                                text: NetworkService.connName
                                                            }
                                                        }
                                                        ,
                                                        State {
                                                            when: !NetworkService.connected
                                                            PropertyChanges {
                                                                target: currentStatusText
                                                                text: qsTr("None")
                                                            }
                                                        }
                                                    ]
                                                }//

                                                TextApp {
                                                    id: ipText
                                                    text: ""

                                                    states: [
                                                        State {
                                                            when: NetworkService.connected
                                                            PropertyChanges {
                                                                target: ipText
                                                                text: NetworkService.ipv4
                                                            }
                                                        }
                                                    ]
                                                }//

                                                TextApp {
                                                    id: forgetText
                                                    color: "gray"
                                                    visible: NetworkService.connected
                                                    text: qsTr("forget")

                                                    MouseArea {
                                                        anchors.fill: parent
                                                        onClicked: {
                                                            //                                            NetworkService.forgetConnection(NetworkService.connName)
                                                            props.forgetConnection(NetworkService.connName)
                                                        }
                                                    }//
                                                }//
                                            }//

                                            TextApp{
                                                id: macText
                                                visible: NetworkService.connected
                                                text: "MAC: %1".arg(NetworkService.wlanMacAddress)
                                            }
                                        }//
                                        Image {
                                            source: "qrc:/UI/Pictures/wifi-no-medium.png"
                                            visible: !NetworkService.connected && !NetworkService.connecting
                                        }
                                    }
                                }
                            }//
                        }//

                        Rectangle{
                            Layout.fillHeight: true
                            Layout.minimumWidth: 1
                            color:"#e3dac9"
                        }

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            ColumnLayout {
                                anchors.fill: parent

                                Rectangle{
                                    Layout.minimumHeight: 50
                                    Layout.fillWidth: true
                                    color: "#1F95D7"
                                    radius: 2

                                    TextApp {
                                        anchors.fill: parent
                                        anchors.margins: 2
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: qsTr("Available Access Point")
                                    }
                                }

                                Item {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    ListView {
                                        id: itemListView
                                        anchors.fill: parent
                                        model: NetworkService.accessPointAvailable
                                        enabled: !NetworkService.connecting && !NetworkService.scanning && !NetworkService.forgettingConn
                                        //                                    model: 5
                                        spacing: 2
                                        clip: true

                                        delegate: Item{
                                            id: listItem

                                            width: itemListView.width
                                            height: 50

                                            Rectangle {anchors.fill: parent; color: "#0F2952"}

                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                    props.wifiSelectedAccessPoint = modelData.name

                                                    if (modelData.exist === "NEW"){
                                                        if(modelData.security.length){
                                                            KeyboardOnScreenCaller.openKeyboard(passwdBufferText, qsTr("Password"))
                                                        }
                                                        else {
                                                            NetworkService.connectToNewAccessPoint(props.wifiSelectedAccessPoint)
                                                        }
                                                    }
                                                    else{
                                                        NetworkService.connectTo(props.wifiSelectedAccessPoint)
                                                    }
                                                }//
                                            }//

                                            RowLayout {
                                                anchors.fill: parent

                                                WifiSignalApp {
                                                    Layout.fillHeight: true
                                                    Layout.minimumWidth: height
                                                    security: modelData.security.length
                                                    strength: modelData.signal
                                                }//

                                                Item {
                                                    Layout.fillHeight: true
                                                    Layout.fillWidth: true

                                                    TextApp {
                                                        anchors.fill: parent
                                                        verticalAlignment: Text.AlignVCenter
                                                        text: modelData.name
                                                    }//
                                                }//

                                                TextApp {
                                                    visible: modelData.exist === "EXIST"
                                                    Layout.fillHeight: true
                                                    Layout.minimumWidth: height
                                                    text: "X"
                                                    color: "gray"
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter

                                                    MouseArea {
                                                        anchors.fill: parent
                                                        onClicked: {
                                                            props.forgetConnection(modelData.name)
                                                        }//
                                                    }//
                                                }//
                                            }//
                                        }//
                                    }//

                                    Rectangle {
                                        visible: NetworkService.scanning
                                        anchors.fill: parent
                                        color: "#AA000000"
                                        radius: 2

                                        TextApp {
                                            anchors.centerIn: parent
                                            text: qsTr("Scanning...")
                                        }//

                                        MouseArea {
                                            anchors.fill: parent
                                        }
                                    }//
                                }//
                            }//
                        }//
                    }//

                    TextInput {
                        id: passwdBufferText
                        echoMode: TextInput.Password
                        maximumLength: 20
                        visible: false

                        onAccepted: {
                            //                        console.log(text)
                            /// wifi standard password is minimum 8 characters
                            if(text.length < 8) return
                            NetworkService.connectToNewAccessPoint(props.wifiSelectedAccessPoint, text)
                        }
                    }
                }//
                Component{
                    id: wiredNetworkConfigComp
                    Item{
                        id: wiredNetworkConfigItem
                        Row{
                            spacing: 10
                            anchors.centerIn: parent
                            Column{
                                spacing: 5
                                TextApp {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: qsTr("Static Wired Connection")
                                    padding: 5
                                }//
                                Row{
                                    spacing: 5
                                    Item {
                                        height: 100
                                        width: enableSwitch.checked ? 150 : 355
                                        Rectangle {
                                            id: enableRectangle
                                            anchors.centerIn: parent
                                            width: 150
                                            height: parent.height
                                            color: "#0F2952"
                                            border.color: "#e3dac9"
                                            radius: 5
                                            states: [
                                                State{
                                                    when: enableSwitch.checked
                                                    PropertyChanges {
                                                        target: enableRectangle
                                                        color: "#1e824c"
                                                    }
                                                }
                                            ]
                                            ColumnLayout{
                                                anchors.fill: parent
                                                anchors.margins: 5

                                                TextApp {
                                                    text: enableSwitch.checked ? qsTr("Enabled") : qsTr("Disabled")
                                                }//

                                                Item {
                                                    Layout.fillHeight: true
                                                    Layout.fillWidth: true

                                                    SwitchApp{
                                                        id: enableSwitch
                                                        anchors.centerIn: parent

                                                        onCheckedChanged: {
                                                            if (!initialized) return
                                                            props.ethEn = checked
                                                        }//
                                                        Component.onCompleted: {
                                                            checked = MachineData.getEth0ConEnabled()
                                                            enableSwitch.initialized = true
                                                        }
                                                    }//
                                                }//
                                            }//
                                        }//
                                    }//
                                    Item {
                                        height: 100
                                        width: 200
                                        visible: enableSwitch.checked
                                        Rectangle {
                                            id: ipv4AddrsRectangle
                                            anchors.fill: parent
                                            color: "#880F2952"
                                            border.color: "#e3dac9"
                                            radius: 5
                                        }
                                        ColumnLayout{
                                            anchors.fill: parent
                                            anchors.margins: 5

                                            TextApp {
                                                text: qsTr("IPv4 Address")
                                            }//

                                            Item {
                                                Layout.fillHeight: true
                                                Layout.fillWidth: true
                                                TextFieldApp {
                                                    id: ipv4AddrsTextField
                                                    width: parent.width
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    horizontalAlignment: Text.AlignHCenter
                                                    text: MachineData.getEth0Ipv4Address()
                                                    placeholderText: "192.168.2.10"
                                                    validator: RegExpValidator {
                                                        regExp: /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
                                                    }

                                                    onPressed: {
                                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("IPv4 Address"))
                                                    }

                                                    onAccepted: {
                                                        let regex = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
                                                        if(text.match(regex)){
                                                            props.ipv4Address = text
                                                            //                                                            showBusyPage(qsTr("Setting up..."), function onCallback(seconds){
                                                            //                                                                if(seconds === 1) {
                                                            //                                                                    closeDialog();
                                                            //                                                                }
                                                            //                                                            })
                                                        }else{
                                                            console.debug("Regular Expression not matched!")
                                                        }
                                                    }//
                                                }////
                                            }//
                                        }//
                                    }//
                                }//
                                Item {
                                    height: 100
                                    width: 355
                                    visible: enableSwitch.checked
                                    Rectangle {
                                        id: ipv4ConNameRectangle
                                        anchors.fill: parent
                                        color: "#880F2952"
                                        border.color: "#e3dac9"
                                        radius: 5
                                    }
                                    ColumnLayout{
                                        anchors.fill: parent
                                        anchors.margins: 5

                                        TextApp {
                                            text: qsTr("IPv4 Conn Name")
                                        }//

                                        Item {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            TextFieldApp {
                                                id: ipv4ConNameTextField
                                                width: parent.width
                                                anchors.verticalCenter: parent.verticalCenter
                                                horizontalAlignment: Text.AlignHCenter
                                                text: MachineData.getEth0ConName()
                                                placeholderText: "Conn Name"

                                                onPressed: {
                                                    KeyboardOnScreenCaller.openKeyboard(this, qsTr("IPv4 Conn Name"))
                                                }
                                                onAccepted: {
                                                    props.ethConName = text
                                                }//
                                            }////
                                        }//
                                    }//
                                }//
                                Column{
                                    TextApp {
                                        property string ipv4eth: NetworkService.ipv4Eth

                                        visible: ipv4eth.length
                                        //anchors.horizontalCenter: parent.horizontalCenter
                                        text: "IPv4: %1".arg(ipv4eth)
                                        padding: 5
                                    }//

                                    TextApp {
                                        property string ipv4eth: NetworkService.ipv4Eth

                                        visible: ipv4eth.length
                                        //anchors.horizontalCenter: parent.horizontalCenter
                                        text: "MAC: %1".arg(NetworkService.eth0MacAddress)
                                        padding: 5
                                    }//
                                }//
                            }//
                        }//
                    }//
                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 70

                Rectangle {
                    anchors.fill: parent
                    color: "#0F2952"
                    //                    border.color: "#e3dac9"
                    //                    border.width: 1
                    radius: 5

                    Item {
                        anchors.fill: parent
                        anchors.margins: 5

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }
                        }//
                        Row{
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            spacing: 5
                            ButtonBarApp {
                                id: ethButton
                                width: 194
                                imageSource: fragmentStackView.depth === 1 ? "qrc:/UI/Pictures/wired-conn.png" : "qrc:/UI/Pictures/local-wifi-update.png"
                                text: fragmentStackView.depth === 1 ? qsTr("Wired Conn") : qsTr("Wireless Conn")

                                onClicked: {
                                    if(fragmentStackView.depth === 1)
                                        fragmentStackView.push(wiredNetworkConfigComp)
                                    else
                                        fragmentStackView.pop()
                                }//
                            }//
                            ButtonBarApp {
                                id: setButton1
                                width: 194
                                visible: props.ethParamHasChanged && fragmentStackView.depth === 2

                                imageSource: "qrc:/UI/Pictures/checkicon.png"
                                text: qsTr("Set")

                                onClicked: {
                                    MachineAPI.setEth0ConEnabled(props.ethEn)
                                    showBusyPage(qsTr("Setting up..."), function onCallback(cycle){
                                        if(cycle === 1){
                                            MachineAPI.setEth0ConName(props.ethConName)
                                            MachineAPI.setEth0Ipv4Address(props.ipv4Address)
                                        }
                                        if(cycle === 2) {
                                            showDialogAsk(qsTr("Restart Now"),
                                                          qsTr("You may need to restart the system to apply these changes."),
                                                          dialogAlert,
                                                          function onAccepted(){
                                                              showBusyPage(qsTr("Restart..."), function onCallback(cycle1){
                                                                  if(cycle1 === 1){
                                                                      const intent = IntentApp.create("qrc:/UI/Pages/ClosingPage/ClosingPage.qml", {})
                                                                      startRootView(intent)
                                                                  }
                                                              })
                                                          },
                                                          function onRejected(){
                                                              /// Close Network Page
                                                              var intent = IntentApp.create(uri, {"message":""})
                                                              finishView(intent)
                                                          },
                                                          function onClosed(){},
                                                          false,
                                                          undefined,
                                                          qsTr("Restart"),
                                                          qsTr("Restart Later")
                                                          )
                                        }
                                    })//
                                }//
                            }//
                            ButtonBarApp {
                                id: scanButton
                                width: 194
                                visible: fragmentStackView.depth === 1
                                enabled: !NetworkService.scanning && !NetworkService.connecting

                                imageSource: "qrc:/UI/Pictures/local-wifi-update.png"
                                text: qsTr("Scan")

                                onClicked: {
                                    NetworkService.readStatus()
                                    NetworkService.scanAccessPoint()
                                }//
                            }//
                            ButtonBarApp {
                                id: setButton
                                width: 194
                                visible: false

                                imageSource: "qrc:/UI/Pictures/checkicon.png"
                                text: qsTr("Next")

                                onClicked: {
                                    //                                currentTimeZoneText.text = currentTimeZoneText.text + "AAAA-"
                                    /// if this page called from welcome page
                                    /// show this button to making more mantap
                                    var intent = IntentApp.create(uri, {"welcomesetupdone": 1})
                                    finishView(intent)
                                }//
                            }//
                        }//
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property string wifiSelectedAccessPoint: ""
            property string ipv4Address: ""
            property string ethConName:""
            property bool ethEn: false
            property bool ethParamHasChanged: false

            onIpv4AddressChanged: checkEthParamChanges()
            onEthConNameChanged: checkEthParamChanges()
            onEthEnChanged: checkEthParamChanges()

            function checkEthParamChanges(){
                let value = false
                if(ipv4Address !== MachineData.getEth0Ipv4Address())
                    value = true
                else if(ethConName !== MachineData.getEth0ConName())
                    value = true
                else if(ethEn !== MachineData.getEth0ConEnabled())
                    value = true
                ethParamHasChanged = value
            }

            function forgetConnection(connName){
                showDialogAsk(qsTr("Network"), qsTr("Forget the connection?"), dialogAlert,
                              function onAccepted(){
                                  NetworkService.forgetConnection(connName)
                              })
            }
        }//

        /// One time executed after onResume
        Component.onCompleted: {
            //            NetworkService.init()
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                NetworkService.readStatus()
                NetworkService.scanAccessPoint()

                NetworkService.readWlanMacAddress()
                NetworkService.readEth0MacAddress()


                const extraData = IntentApp.getExtraData(intent)
                //                console.debug("extraData", extraData)
                const thisOpenedFromWelcomePage = extraData["welcomesetup"] || false
                //                console.debug("extraData[\"welcomesetup\"]", extraData["welcomesetup"])
                //                console.debug(extraData["thisOpenedFromWelcomePage"], thisOpenedFromWelcomePage)
                if(thisOpenedFromWelcomePage) {
                    setButton.visible = true
                    ethButton.visible = false

                    viewApp.enabledSwipedFromLeftEdge   = false
                    viewApp.enabledSwipedFromRightEdge  = false
                    viewApp.enabledSwipedFromBottomEdge = false
                }//

                props.ipv4Address = MachineData.getEth0Ipv4Address()
                props.ethConName = MachineData.getEth0ConName()
                props.ethEn = MachineData.getEth0ConEnabled()
            }//

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
