import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Sensor Constant"

    background.sourceComponent: Item {}

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
                    id: headerApp
                    anchors.fill: parent
                    title: qsTr("Sensor Constant")
                }
            }

            /// BODY
            BodyItemApp {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                RowLayout{
                    anchors.fill: parent
                    spacing: 50
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Column{
                            id: parameterColumn
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter

                            TextApp{
                                text: qsTr("Current value (DF)")
                            }//

                            TextApp{
                                font.pixelSize: 18
                                text: "(" + qsTr("Tap to change") + ")"
                                color: "#aaaaaa"
                            }//

                            TextApp{
                                id: currentTextApp
                                font.pixelSize: 52
                                text: props.dfaSensorConstant
                            }//

                        }//

                        TextInput {
                            id: bufferTextInput
                            visible: false
                            text: currentTextApp.text
                            validator: IntValidator{bottom: 0; top: 99;}

                            onAccepted: {
                                //                        //console.debug("Hallo")
                                let newConstant = Number(text);
                                if(props.dfaSensorConstant !== newConstant){
                                    props.dfaSensorConstant = newConstant
                                    currentTextApp.text = newConstant
                                    setButton.visible = true
                                }
                            }//
                        }//

                        MouseArea{
                            anchors.fill: parameterColumn
                            onClicked: {
                                KeyboardOnScreenCaller.openNumpad(bufferTextInput, qsTr("Sensor Constant (DF)"))
                            }//
                        }//
                    }//
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Column{
                            id: parameterColumn2
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter

                            TextApp{
                                text: qsTr("Current value (IF)")
                            }//

                            TextApp{
                                font.pixelSize: 18
                                text: "(" + qsTr("Tap to change") + ")"
                                color: "#aaaaaa"
                            }//

                            TextApp{
                                id: currentTextApp2
                                font.pixelSize: 52
                                text: props.ifaSensorConstant
                            }//

                        }//

                        TextInput {
                            id: bufferTextInput2
                            visible: false
                            text: currentTextApp2.text
                            validator: IntValidator{bottom: 0; top: 99;}

                            onAccepted: {
                                //                        //console.debug("Hallo")
                                let newConstant = Number(text);
                                if(props.ifaSensorConstant !== newConstant){
                                    props.ifaSensorConstant = newConstant
                                    currentTextApp2.text = newConstant
                                    setButton.visible = true
                                }
                            }//
                        }//

                        MouseArea{
                            anchors.fill: parameterColumn2
                            onClicked: {
                                KeyboardOnScreenCaller.openNumpad(bufferTextInput2, qsTr("Sensor Constant (IF)"))
                            }//
                        }//
                    }//
                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: MachineAPI.FOOTER_HEIGHT

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
                            id: backButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                if (props.sensorContantHaveSet) {
                                    let intent = IntentApp.create(uri, {"pid": props.pid,
                                                                      "dfaSensorConstant": props.dfaSensorConstant,
                                                                      "ifaSensorConstant": props.ifaSensorConstant })
                                    finishView(intent);
                                } else {
                                    var intent = IntentApp.create(uri, {})
                                    finishView(intent)
                                }
                            }//
                        }//

                        ButtonBarApp {
                            id: setButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            visible: false

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Set")

                            onClicked: {
                                setButton.visible = false;

                                // Set to machine as a temporary sensor contant
                                // this required for update sesnor contant on AirflowSensor object
                                // So, AirflowSensor object can provide ADC value with current sensor constant in real-time
                                // this is not permanent, this value withh revert to original sensor constant
                                // if user not pressing the save button on _NavigationCalibratePage
                                MachineAPI.setInflowSensorConstantTemporary(props.ifaSensorConstant);
                                MachineAPI.setDownflowSensorConstantTemporary(props.dfaSensorConstant);

                                props.sensorContantHaveSet = true;

                                /// give some time space to ensure the value has updated to AirflowSensor Object
                                viewApp.showBusyPage(qsTr("Setting up..."),
                                                     function onTriggered(cycle){
                                                         if(cycle === MachineAPI.BUSY_CYCLE_1){
                                                             showDialogMessage(qsTr("Sensor Constant"),
                                                                               qsTr("Sensor constant value have been changed to %1 (DF) and %2 (IF)").arg(props.dfaSensorConstant).arg(props.ifaSensorConstant),
                                                                               dialogInfo,
                                                                               function onClosed(){
                                                                                   let intent = IntentApp.create(uri, {"pid": props.pid,
                                                                                                                     "dfaSensorConstant": props.dfaSensorConstant,
                                                                                                                     "ifaSensorConstant": props.ifaSensorConstant })
                                                                                   finishView(intent);
                                                                               })
                                                         }//
                                                     })//
                            }//
                        }//
                    }//
                }//
            }//
        }//

        /// called Once but after onResume
        Component.onCompleted: {
            let extradata = IntentApp.getExtraData(intent)
            //                    //console.debug(JSON.stringify(extradata))
            if (extradata['pid'] !== undefined) {

                props.pid = extradata['pid']

                props.dfaSensorConstant = extradata['dfaSensorConstant'] || 0
                props.ifaSensorConstant = extradata['ifaSensorConstant'] || 0
            }
        }//

        QtObject {
            id: props

            property string pid: ""

            property int dfaSensorConstant: 0
            property int ifaSensorConstant: 0

            property bool sensorContantHaveSet: false
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }//
        }//
    }//

    Component.onDestruction: {
        //        //console.debug("onDestruction")
    }
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
