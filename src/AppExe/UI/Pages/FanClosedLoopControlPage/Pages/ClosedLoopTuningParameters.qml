/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7

import UI.CusCom 1.0
import "../../../CusCom/JS/IntentApp.js" as IntentApp
//import Qt.labs.settings 1.0
import ModulesCpp.RegisterExternalResources 1.0
import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Closed Loop Control Tuning"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        /// just for development
        /// comment following line after release
        visible: true

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
                    title: qsTr("Closed Loop Control Tuning")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.topMargin: 5
                Layout.bottomMargin: 5
                Row{
                    anchors.centerIn: parent
                    spacing: 20
                    Column{
                        spacing: 5
                        TextApp {
                            id: textTitleDfa
                            text: qsTr("Downflow")
                        }//
                        Rectangle{
                            id: rectDfaParameters
                            height: colDfaParameters.height + 10
                            width: colDfaParameters.width + 10
                            color: "#0F2952"
                            radius: 5
                            border.color: "#e3dac9"
                            Column{
                                id: colDfaParameters
                                spacing: 5
                                anchors.centerIn: parent
                                Column{
                                    spacing: 5
                                    TextApp {
                                        id: textSubTitleDfaKp
                                        text: qsTr("Gain Proportional (Kp)")
                                    }//
                                    Row{
                                        spacing: 10
                                        TextFieldApp {
                                            id: dfaTextFieldKp
                                            width: 110
                                            height: 40
                                            //validator: IntValidator{bottom: 0; top: 10;}

                                            onPressed: {
                                                KeyboardOnScreenCaller.openNumpad(this, "%1 (%2) - ".arg(textSubTitleDfaKp.text).arg(textTitleDfa.text) + qsTr("Range %1-%2").arg(props.kpMin).arg(props.kpMax))
                                            }//
                                            onAccepted: {
                                                let value = Number(text)
                                                if(value >= props.kpMin && value <= props.kpMax){
                                                    props.dfaGainProportional = Number(value.toFixed(2))
                                                    text = props.dfaGainProportional.toFixed(2)
                                                }
                                                else{
                                                    text = props.dfaGainProportional.toFixed(2)
                                                    props.showWarningOutRange(props.kpMin, props.kpMax)
                                                }//
                                            }//
                                        }//
                                        Image{
                                            source:"qrc:/UI/Pictures/pid/small-info.png"
                                            fillMode: Image.PreserveAspectFit
                                            opacity: dfaKpInfoMa.pressed ? 0.5 : 1
                                            MouseArea{
                                                id: dfaKpInfoMa
                                                anchors.fill: parent
                                                onClicked: {
                                                    const msgTitle = textSubTitleDfaKp.text
                                                    const msg = "<i>" + qsTr("Kp is the proportional gain of proportional (P) controller. \
Term P is proportional to the current value of the error (SP-PV). \
For example, if the error is large and positive, the control output will be proportionately large and positive. \
If there is no error, there is no corrective response. \
P controller can be implemented independently without additional I and D.") + "</i>"
                                                    props.showInfo(msgTitle, msg)
                                                }//
                                            }//
                                        }//
                                    }//
                                }//
                                Column{
                                    spacing: 5
                                    TextApp {
                                        id: textSubTitleDfaKi
                                        text: qsTr("Gain Integral (Ki)")
                                    }//
                                    Row{
                                        spacing: 10
                                        TextFieldApp {
                                            id: dfaTextFieldKi
                                            width: 110
                                            height: 40
                                            //validator: IntValidator{bottom: 0; top: 1;}
                                            onPressed: {
                                                KeyboardOnScreenCaller.openNumpad(this, "%1 (%2) - ".arg(textSubTitleDfaKi.text).arg(textTitleDfa.text) + qsTr("Range %1-%2").arg(props.kiMin).arg(props.kiMax))
                                            }//
                                            onAccepted: {
                                                let value = Number(text)
                                                if(value >= props.kiMin && value <= props.kiMax){
                                                    props.dfaGainIntegral = Number(value.toFixed(2))
                                                    text = props.dfaGainIntegral.toFixed(2)
                                                }
                                                else{
                                                    text = props.dfaGainIntegral.toFixed(2)
                                                    props.showWarningOutRange(props.kiMin, props.kiMax)
                                                }
                                            }
                                        }//
                                        Image{
                                            source:"qrc:/UI/Pictures/pid/small-info.png"
                                            fillMode: Image.PreserveAspectFit
                                            opacity: dfaKiInfoMa.pressed ? 0.5 : 1
                                            MouseArea{
                                                id: dfaKiInfoMa
                                                anchors.fill: parent
                                                onClicked: {
                                                    const msgTitle = textSubTitleDfaKi.text
                                                    const msg = "<i>" + qsTr("Ki is the gain of Integral (I) controller. \
Term I accounts for past values of the error (SP−PV) and integrates them over time to produce the I term. \
The integral term seeks to eliminate the residual error by adding a control effect due to the historic cumulative value of the error. \
When the error is eliminated, the integral term will cease to grow.
I controller cannot be implemented independently, must be coupled with P.") + "</i>"
                                                    props.showInfo(msgTitle, msg)
                                                }
                                            }
                                        }
                                    }//
                                }
                                Column{
                                    spacing: 5
                                    TextApp {
                                        id: textSubTitleDfaKd
                                        text: qsTr("Gain Derivative (Kd)")
                                    }//
                                    Row{
                                        spacing: 10
                                        TextFieldApp {
                                            id: dfaTextFieldKd
                                            width: 110
                                            height: 40
                                            //validator: IntValidator{bottom: 0; top: 10;}
                                            onPressed: {
                                                KeyboardOnScreenCaller.openNumpad(this, "%1 (%2) - ".arg(textSubTitleDfaKd.text).arg(textTitleDfa.text) + qsTr("Range %1-%2").arg(props.kdMin).arg(props.kdMax))
                                            }//
                                            onAccepted: {
                                                let value = Number(text)
                                                if(value >= props.kdMin && value <= props.kdMax){
                                                    props.dfaGainDerivative = Number(value.toFixed(2))
                                                    text = props.dfaGainDerivative.toFixed(2)
                                                }
                                                else{
                                                    text = props.dfaGainDerivative.toFixed(2)
                                                    props.showWarningOutRange(props.kdMin, props.kdMax)
                                                }
                                            }//
                                        }//
                                        Image{
                                            source:"qrc:/UI/Pictures/pid/small-info.png"
                                            fillMode: Image.PreserveAspectFit
                                            opacity: dfaKdInfoMa.pressed ? 0.5 : 1
                                            MouseArea{
                                                id: dfaKdInfoMa
                                                anchors.fill: parent
                                                onClicked: {
                                                    const msgTitle = textSubTitleDfaKd.text
                                                    const msg = "<i>" + qsTr("Kd is the gain of Derivative (D) controller. \
Term D is the best estimate of the future trend of the error (SP−PV), based on its current rate of change. \
The more rate of error change, the greater the controlling or damping effect will be implemented. \
D controller cannot be implemented independently, must be coupled with P.") + "</i>"
                                                    props.showInfo(msgTitle, msg)
                                                }
                                            }//
                                        }//
                                    }//
                                }//
                                Column{
                                    spacing: 5
                                    TextApp {
                                        id: textSubTitleSpDfa
                                        text: qsTr("Setpoint (SP)")
                                    }//
                                    Row{
                                        spacing: 10
                                        TextFieldApp {
                                            id: textFieldSpDfa
                                            width: 110
                                            height: 40
                                            enabled: false
                                            colorBackground: "grey"
                                            TextApp {
                                                anchors.right: parent.right
                                                anchors.rightMargin: 5
                                                verticalAlignment: Text.AlignVCenter
                                                height: parent.height
                                                text: (MachineData.measurementUnit ? "fpm" : "m/s")
                                                //color: "gray"
                                            }//
                                        }//
                                        Image{
                                            source:"qrc:/UI/Pictures/pid/small-info.png"
                                            fillMode: Image.PreserveAspectFit
                                            opacity: dfaSpInfoMa.pressed ? 0.5 : 1
                                            MouseArea{
                                                id: dfaSpInfoMa
                                                anchors.fill: parent
                                                onClicked: {
                                                    const msgTitle = textSubTitleSpDfa.text
                                                    const msg = "<i>" + qsTr("The setpoint value for the closed-loop controller. \
The closed-loop controller will react in order to bring the Downflow velocity \
to be equal to set point value.") + "</i>"
                                                    props.showInfo(msgTitle, msg)
                                                }
                                            }
                                        }
                                    }//
                                }//
                                Column{
                                    spacing: 5
                                    TextApp {
                                        id: textSubTitlePvDfa
                                        text: qsTr("Process Variable (PV)")
                                    }//
                                    Row{
                                        spacing: 10
                                        TextFieldApp {
                                            id: textFieldPvDfa
                                            width: 110
                                            height: 40
                                            enabled: false
                                            colorBackground: "grey"
                                            Component.onCompleted: text = Qt.binding(function(){return (MachineData.dfaVelocity/100).toFixed(MachineData.measurementUnit ? 0 : 2)})
                                            TextApp {
                                                anchors.right: parent.right
                                                anchors.rightMargin: 5
                                                verticalAlignment: Text.AlignVCenter
                                                height: parent.height
                                                text: (MachineData.measurementUnit ? "fpm" : "m/s")
                                                //color: "gray"
                                            }//
                                        }//
                                        Image{
                                            source:"qrc:/UI/Pictures/pid/small-info.png"
                                            fillMode: Image.PreserveAspectFit
                                            opacity: dfaPvInfoMa.pressed ? 0.5 : 1
                                            MouseArea{
                                                id: dfaPvInfoMa
                                                anchors.fill: parent
                                                onClicked: {
                                                    const msgTitle = textSubTitlePvDfa.text
                                                    const msg = "<i>" + qsTr("The actual Downflow velocity as read by the sensor. \
This value should be ideally equal to the setpoint value otherwise there will be an error \
and the closed-loop control will react by changing its output (driving the exhaust blower) \
to remove the error.") + "</i>"
                                                    props.showInfo(msgTitle, msg)
                                                }
                                            }
                                        }
                                    }//
                                }//
                            }//
                        }//
                    }//
                    Column{
                        spacing: 5
                        TextApp {
                            id: textTitleIfa
                            text: qsTr("Inflow")
                        }//
                        Rectangle{
                            id: rectIfaParameters
                            height: colIfaParameters.height + 10
                            width: colIfaParameters.width + 10
                            color: "#0F2952"
                            radius: 5
                            border.color: "#e3dac9"
                            Column{
                                id: colIfaParameters
                                clip: true
                                spacing: 5
                                anchors.centerIn: parent
                                Column{
                                    spacing: 5
                                    TextApp {
                                        id: textSubTitleIfaKp
                                        text: qsTr("Gain Proportional (Kp)")
                                    }//
                                    Row{
                                        spacing: 10
                                        TextFieldApp {
                                            id: ifaTextFieldKp
                                            width: 110
                                            height: 40
                                            //validator: IntValidator{bottom: 0; top: 10;}

                                            onPressed: {
                                                KeyboardOnScreenCaller.openNumpad(this, "%1 (%2) - ".arg(textSubTitleIfaKp.text).arg(textTitleIfa.text) + qsTr("Range %1-%2").arg(props.kpMin).arg(props.kpMax))
                                            }//
                                            onAccepted: {
                                                let value = Number(text)
                                                if(value >= props.kpMin && value <= props.kpMax){
                                                    props.ifaGainProportional = Number(value.toFixed(2))
                                                    text = props.ifaGainProportional.toFixed(2)
                                                }
                                                else{
                                                    text = props.ifaGainProportional.toFixed(2)
                                                    props.showWarningOutRange(props.kpMin, props.kpMax)
                                                }
                                            }
                                        }//
                                        Image{
                                            source:"qrc:/UI/Pictures/pid/small-info.png"
                                            fillMode: Image.PreserveAspectFit
                                            opacity: ifaKpInfoMa.pressed ? 0.5 : 1
                                            MouseArea{
                                                id: ifaKpInfoMa
                                                anchors.fill: parent
                                                onClicked: {
                                                    const msgTitle = textSubTitleIfaKp.text
                                                    const msg = "<i>" + qsTr("Kp is the proportional gain of proportional (P) controller. \
Term P is proportional to the current value of the error (SP-PV). \
For example, if the error is large and positive, the control output will be proportionately large and positive. \
If there is no error, there is no corrective response. \
P controller can be implemented independently without additional I and D.") + "</i>"
                                                    props.showInfo(msgTitle, msg)
                                                }
                                            }
                                        }
                                    }//
                                }
                                Column{
                                    spacing: 5
                                    TextApp {
                                        id: textSubTitleIfaKi
                                        text: qsTr("Gain Integral (Ki)")
                                    }//
                                    Row{
                                        spacing: 10
                                        TextFieldApp {
                                            id: ifaTextFieldKi
                                            width: 110
                                            height: 40
                                            //validator: IntValidator{bottom: 0; top: 10;}

                                            onPressed: {
                                                KeyboardOnScreenCaller.openNumpad(this, "%1 (%2) - ".arg(textSubTitleIfaKi.text).arg(textTitleIfa.text) + qsTr("Range %1-%2").arg(props.kiMin).arg(props.kiMax))
                                            }//
                                            onAccepted: {
                                                let value = Number(text)
                                                if(value >= props.kiMin && value <= props.kiMax){
                                                    props.ifaGainIntegral = Number(value.toFixed(2))
                                                    text = props.ifaGainIntegral.toFixed(2)
                                                }
                                                else{
                                                    text = props.ifaGainIntegral.toFixed(2)
                                                    props.showWarningOutRange(props.kiMin, props.kiMax)
                                                }
                                            }
                                        }//
                                        Image{
                                            source:"qrc:/UI/Pictures/pid/small-info.png"
                                            fillMode: Image.PreserveAspectFit
                                            opacity: ifaKiInfoMa.pressed ? 0.5 : 1
                                            MouseArea{
                                                id: ifaKiInfoMa
                                                anchors.fill: parent
                                                onClicked: {
                                                    const msgTitle = textSubTitleIfaKi.text
                                                    const msg = "<i>" + qsTr("Ki is the gain of Integral (I) controller. \
Term I accounts for past values of the error (SP−PV) and integrates them over time to produce the I term. \
The integral term seeks to eliminate the residual error by adding a control effect due to the historic cumulative value of the error. \
When the error is eliminated, the integral term will cease to grow.
I controller cannot be implemented independently, must be coupled with P.") + "</i>"
                                                    props.showInfo(msgTitle, msg)
                                                }
                                            }
                                        }
                                    }//
                                }
                                Column{
                                    spacing: 5
                                    TextApp {
                                        id: textSubTitleIfaKd
                                        text: qsTr("Gain Derivative (Kd)")
                                    }//
                                    Row{
                                        spacing: 10
                                        TextFieldApp {
                                            id: ifaTextFieldKd
                                            width: 110
                                            height: 40
                                            //validator: IntValidator{bottom: 0; top: 10;}

                                            onPressed: {
                                                KeyboardOnScreenCaller.openNumpad(this, "%1 (%2) - ".arg(textSubTitleIfaKd.text).arg(textTitleIfa.text) + qsTr("Range %1-%2").arg(props.kdMin).arg(props.kdMax))
                                            }//
                                            onAccepted: {
                                                let value = Number(text)
                                                if(value >= props.kdMin && value <= props.kdMax){
                                                    props.ifaGainDerivative = Number(value.toFixed(2))
                                                    text = props.ifaGainDerivative.toFixed(2)
                                                }
                                                else{
                                                    text = props.ifaGainDerivative.toFixed(2)
                                                    props.showWarningOutRange(props.kdMin, props.kdMax)
                                                }
                                            }
                                        }//
                                        Image{
                                            source:"qrc:/UI/Pictures/pid/small-info.png"
                                            fillMode: Image.PreserveAspectFit
                                            opacity: ifaKdInfoMa.pressed ? 0.5 : 1
                                            MouseArea{
                                                id: ifaKdInfoMa
                                                anchors.fill: parent
                                                onClicked: {
                                                    const msgTitle = textSubTitleIfaKd.text
                                                    const msg = "<i>" + qsTr("Kd is the gain of Derivative (D) controller. \
Term D is the best estimate of the future trend of the error (SP−PV), based on its current rate of change. \
The more rate of error change, the greater the controlling or damping effect will be implemented. \
D controller cannot be implemented independently, must be coupled with P.") + "</i>"
                                                    props.showInfo(msgTitle, msg)
                                                }
                                            }
                                        }//
                                    }//
                                }//
                                Column{
                                    spacing: 5
                                    TextApp {
                                        id: textSubTitleSpIfa
                                        text: qsTr("Setpoint (SP)")
                                    }//
                                    Row{
                                        spacing: 10
                                        TextFieldApp {
                                            id: textFieldSpIfa
                                            width: 110
                                            height: 40
                                            enabled: false
                                            colorBackground: "grey"
                                            TextApp {
                                                anchors.right: parent.right
                                                anchors.rightMargin: 5
                                                verticalAlignment: Text.AlignVCenter
                                                height: parent.height
                                                text: (MachineData.measurementUnit ? "fpm" : "m/s")
                                                //color: "gray"
                                            }//
                                        }//
                                        Image{
                                            source:"qrc:/UI/Pictures/pid/small-info.png"
                                            fillMode: Image.PreserveAspectFit
                                            opacity: ifaSpInfoMa.pressed ? 0.5 : 1
                                            MouseArea{
                                                id: ifaSpInfoMa
                                                anchors.fill: parent
                                                onClicked: {
                                                    const msgTitle = textSubTitleSpIfa.text
                                                    const msg = "<i>" + qsTr("The setpoint value for the closed-loop controller. \
The closed-loop controller will react in order to bring the Inflow velocity \
to be equal to set point value.") + "</i>"
                                                    props.showInfo(msgTitle, msg)
                                                }
                                            }
                                        }
                                    }//
                                }//
                                Column{
                                    spacing: 5
                                    TextApp {
                                        id: textSubTitlePvIfa
                                        text: qsTr("Process Variable (PV)")
                                    }//
                                    Row{
                                        spacing: 10
                                        TextFieldApp {
                                            id: textFieldPvIfa
                                            width: 110
                                            height: 40
                                            enabled: false
                                            colorBackground: "grey"
                                            Component.onCompleted: text = Qt.binding(function(){return (MachineData.ifaVelocity/100).toFixed(MachineData.measurementUnit ? 0 : 2)})
                                            TextApp {
                                                anchors.right: parent.right
                                                anchors.rightMargin: 5
                                                verticalAlignment: Text.AlignVCenter
                                                height: parent.height
                                                text: (MachineData.measurementUnit ? "fpm" : "m/s")
                                                //color: "gray"
                                            }//
                                        }//
                                        Image{
                                            source:"qrc:/UI/Pictures/pid/small-info.png"
                                            fillMode: Image.PreserveAspectFit
                                            opacity: ifaPvInfoMa.pressed ? 0.5 : 1
                                            MouseArea{
                                                id: ifaPvInfoMa
                                                anchors.fill: parent
                                                onClicked: {
                                                    const msgTitle = textSubTitlePvIfa.text
                                                    const msg = "<i>" + qsTr("The actual Inflow velocity as read by the sensor. \
This value should be ideally equal to the setpoint value otherwise there will be an error \
and the closed-loop control will react by changing its output (driving the exhaust blower) \
to remove the error.") + "</i>"
                                                    props.showInfo(msgTitle, msg)
                                                }
                                            }
                                        }
                                    }//
                                }//
                            }//
                        }//
                    }//
                    Column{
                        spacing: 30
                        Column{
                            spacing: 5
                            TextApp {
                                id: textSubTitleTs
                                text: qsTr("Sampling Time")
                            }//
                            Row{
                                spacing: 10
                                TextFieldApp {
                                    id: textFieldTs
                                    width: 110
                                    height: 40
                                    //validator: IntValidator{bottom: 0; top: 10000;}

                                    onPressed: {
                                        KeyboardOnScreenCaller.openNumpad(this, "%1 (ms) - ".arg(textSubTitleTs.text) + qsTr("Range %1-%2").arg(props.tsMin).arg(props.tsMax))
                                    }//
                                    onAccepted: {
                                        let value = Number(text)
                                        if(value >= props.tsMin && value <= props.tsMax){
                                            props.samplingTime = value
                                            text = props.samplingTime.toFixed()
                                        }
                                        else{
                                            text = props.samplingTime.toFixed()
                                            props.showWarningOutRange(props.tsMin, props.tsMax)
                                        }
                                    }//
                                    TextApp {
                                        anchors.right: parent.right
                                        anchors.rightMargin: 5
                                        verticalAlignment: Text.AlignVCenter
                                        height: parent.height
                                        text: "ms"
                                        //color: "gray"
                                    }//
                                }//
                                Image{
                                    source:"qrc:/UI/Pictures/pid/small-info.png"
                                    fillMode: Image.PreserveAspectFit
                                    opacity: tsInfoMa.pressed ? 0.5 : 1
                                    MouseArea{
                                        id: tsInfoMa
                                        anchors.fill: parent
                                        onClicked: {
                                            const msgTitle = textSubTitleTs.text
                                            const msg = "<i>" + qsTr("The time interval for every closed-loop control change of output. \
Smaller values means faster time and more frequent change of controller output \
leading to a faster response when there are errors. Larger values means slower time \
and less frequent change of controller output leading to a slower response when there \
are errors.") + "</i>"
                                            props.showInfo(msgTitle, msg)
                                        }
                                    }//
                                }//
                            }//
                        }//
                        Rectangle {
                            id: fanBtn
                            width: 150
                            height: 100
                            color: "#0F2952"
                            border.color: "#dddddd"
                            radius: 5
                            anchors.horizontalCenter: parent.horizontalCenter
                            property int sampleCounter: 0
                            Column{
                                anchors.centerIn: parent
                                spacing: 5
                                TextApp{
                                    width: 150
                                    text: (MachineData.fanPrimaryDutyCycle || MachineData.fanInflowDutyCycle) ? qsTr("Switch Off") : qsTr("Switch On")
                                    //font.pixelSize: 16
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignHCenter
                                }
                                Image {
                                    id: fanImage
                                    source: "qrc:/UI/Pictures/controll/Fan_W.png"
                                    height: 60
                                    //                                    anchors.margins: 10
                                    //                                    anchors.fill: parent
                                    fillMode: Image.PreserveAspectFit
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    states: State {
                                        name: "stateOn"
                                        when: MachineData.fanPrimaryDutyCycle || MachineData.fanInflowDutyCycle
                                        PropertyChanges {
                                            target: fanImage
                                            source: "qrc:/UI/Pictures/controll/Fan_G.png"
                                        }//
                                    }//
                                }//
                            }//
                            MouseArea{
                                id: fanMouseArea
                                anchors.fill: parent
                                onClicked: {
                                    let msg, isTurnOn
                                    if(MachineData.fanPrimaryDutyCycle || MachineData.fanInflowDutyCycle){
                                        MachineAPI.setFanState(MachineAPI.FAN_STATE_OFF)
                                        msg = qsTr("Switching Off the Fan...")
                                        isTurnOn = 0
                                    }
                                    else{
                                        msg = qsTr("Switching On the Fan...")
                                        MachineAPI.setFanState(MachineAPI.FAN_STATE_ON)
                                        isTurnOn = 1
                                    }

                                    viewApp.showBusyPage(msg, function onTriggered(cycle){
                                        if(cycle >= 10){
                                            MachineAPI.setReadClosedLoopResponse(true)
                                            viewApp.dialogObject.close()
                                            if(isTurnOn)
                                                viewApp.showDialogMessage(qsTr("Closed Loop Control Tuning"),
                                                                          qsTr("Wait a moment until the \'Loop Response\' button appears"),
                                                                          dialogInfo)
                                        }//
                                    })//
                                }//
                            }//
                        }//

                        Column{
                            anchors.horizontalCenter: parent.horizontalCenter

                            Image{
                                id: tuneHelpIcon
                                source: "qrc:/UI/Pictures/pid/tune-help.png"
                                height: 100
                                fillMode: Image.PreserveAspectFit
                                opacity: tuneHelpMa.pressed ? 0.5 : 1
                                anchors.horizontalCenter: parent.horizontalCenter
                                MouseArea{
                                    id: tuneHelpMa
                                    anchors.fill: parent
                                    onClicked: {
                                        if(registerExResources.setResourcePath(MachineAPI.Resource_General))
                                        {
                                            //console.debug("Success to set Resource_General")
                                            registerExResources.importResource();
                                        }else{
                                            //console.debug("Failed to set Resource_General!")
                                        }
                                        var intent = IntentApp.create("qrc:/UI/Pages/FanClosedLoopControlPage/Pages/ClosedLoopTuningHelp.qml", {})
                                        startView(intent)
                                    }
                                }
                            }
                            TextApp{
                                width: 150
                                text: qsTr("Learn how to tune the parameters")
                                //font.pixelSize: 20
                                wrapMode: Text.WordWrap
                                horizontalAlignment: Text.AlignHCenter
                            }
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
                        Row{
                            spacing: 5
                            ButtonBarApp {
                                id: back
                                width: 194
                                anchors.verticalCenter: parent.verticalCenter

                                imageSource: "qrc:/UI/Pictures/back-step.png"
                                text: qsTr("Back")

                                onClicked: {
                                    var intent = IntentApp.create(uri, {"message":""})
                                    finishView(intent)
                                }
                            }//
                            ButtonBarApp {
                                id: responseBtn
                                width: 194
                                visible: false
                                anchors.verticalCenter: parent.verticalCenter
                                imageSource: "qrc:/UI/Pictures/pid/response.png"
                                text: qsTr("Loop Response")

                                onClicked: {
                                    var intent = IntentApp.create("qrc:/UI/Pages/FanClosedLoopControlPage/Pages/ClosedLoopResponse.qml",{})
                                    startView(intent)
                                }//
                            }//
                        }//
                        ButtonBarApp {
                            id: setButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            visible: props.parameterHasChanged

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Save")

                            onClicked: {
                                visible = false

                                if(props.dfaKpChanged) MachineAPI.setFanClosedLoopGainProportionalDfa(props.dfaGainProportional)
                                if(props.dfaKiChanged) MachineAPI.setFanClosedLoopGainIntegralDfa(props.dfaGainIntegral)
                                if(props.dfaKdChanged) MachineAPI.setFanClosedLoopGainDerivativeDfa(props.dfaGainDerivative)
                                if(props.ifaKpChanged) MachineAPI.setFanClosedLoopGainProportionalIfa(props.ifaGainProportional)
                                if(props.ifaKiChanged) MachineAPI.setFanClosedLoopGainIntegralIfa(props.ifaGainIntegral)
                                if(props.ifaKdChanged) MachineAPI.setFanClosedLoopGainDerivativeIfa(props.ifaGainDerivative)
                                if(props.tsChanged)    MachineAPI.setFanClosedLoopSamplingTime(props.samplingTime)

                                console.debug("dfaGainProportional", props.dfaGainProportional)
                                console.debug("dfaGainIntegral", props.dfaGainIntegral)
                                console.debug("dfaGainDerivative", props.dfaGainDerivative)
                                console.debug("ifaGainProportional", props.ifaGainProportional)
                                console.debug("ifaGainIntegral", props.ifaGainIntegral)
                                console.debug("ifaGainDerivative", props.ifaGainDerivative)
                                console.debug("samplingTime", props.samplingTime)

                                const message = qsTr("User: Closed loop paramters changed")
                                MachineAPI.insertEventLog(message)

                                showBusyPage(qsTr("Setting up..."), function(seconds){
                                    if (seconds === 3){
                                        closeDialog();
                                    }//
                                })//
                            }//
                        }//
                    }//
                }//
            }//
        }//

        RegisterExResources {
            id: registerExResources
        }

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            readonly property real kpMax: 10
            readonly property real kiMax: 3
            readonly property real kdMax: 10
            readonly property real tsMax: 10000

            readonly property real kpMin: 0
            readonly property real kiMin: 0
            readonly property real kdMin: 0
            readonly property real tsMin: 200

            //            property variant dfaActualVelocityModel: []
            //            property variant ifaActualVelocityModel: []

            property bool dfaKpChanged:    false
            property bool dfaKiChanged:    false
            property bool dfaKdChanged:    false
            property bool ifaKpChanged:    false
            property bool ifaKiChanged:    false
            property bool ifaKdChanged:    false
            property bool tsChanged   :    false
            property bool parameterHasChanged : false

            property real dfaGainProportional:   0.0
            property real dfaGainIntegral:       0.0
            property real dfaGainDerivative:      0.0
            property real ifaGainProportional:   0.0
            property real ifaGainIntegral:       0.0
            property real ifaGainDerivative:      0.0
            property int samplingTime:           1000
            property real dfaSetpoint: 0.32
            property real ifaSetpoint: 0.45

            onDfaGainProportionalChanged: {dfaGainProportional !== MachineData.getFanClosedLoopGainProportional(0)  ? dfaKpChanged = true : dfaKpChanged = false}
            onDfaGainIntegralChanged:     {dfaGainIntegral     !== MachineData.getFanClosedLoopGainIntegral(0)      ? dfaKiChanged = true : dfaKiChanged = false}
            onDfaGainDerivativeChanged:    {dfaGainDerivative  !== MachineData.getFanClosedLoopGainDerivative(0)    ? dfaKdChanged = true : dfaKdChanged = false}
            onIfaGainProportionalChanged: {ifaGainProportional !== MachineData.getFanClosedLoopGainProportional(1)  ? ifaKpChanged = true : ifaKpChanged = false}
            onIfaGainIntegralChanged:     {ifaGainIntegral     !== MachineData.getFanClosedLoopGainIntegral(1)      ? ifaKiChanged = true : ifaKiChanged = false}
            onIfaGainDerivativeChanged:    {ifaGainDerivative  !== MachineData.getFanClosedLoopGainDerivative(1)    ? ifaKdChanged = true : ifaKdChanged = false}
            onSamplingTimeChanged:        {samplingTime        !== MachineData.getFanClosedLoopSamplingTime()       ? tsChanged    = true : tsChanged    = false}

            function showWarningOutRange(lowLimit, highLimit){
                showDialogMessage(qsTr("Setting failed"),
                                  qsTr("The set value out of the allowable value limit (%1-%2)").arg(lowLimit).arg(highLimit),
                                  dialogAlert)
            }

            function showInfo(msgTitle, msg){showDialogMessage(msgTitle, msg, dialogInfo, undefined, false)}

            //Component.onCompleted: {console.debug("DELETED")}
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                props.dfaGainProportional   = MachineData.getFanClosedLoopGainProportional(0)
                props.dfaGainIntegral       = MachineData.getFanClosedLoopGainIntegral(0)
                props.dfaGainDerivative     = MachineData.getFanClosedLoopGainDerivative(0)
                props.ifaGainProportional   = MachineData.getFanClosedLoopGainProportional(1)
                props.ifaGainIntegral       = MachineData.getFanClosedLoopGainIntegral(1)
                props.ifaGainDerivative     = MachineData.getFanClosedLoopGainDerivative(1)
                props.samplingTime          = MachineData.getFanClosedLoopSamplingTime()
                props.dfaSetpoint           = MachineData.getFanClosedLoopSetpoint(0)/100
                props.ifaSetpoint           = MachineData.getFanClosedLoopSetpoint(1)/100

                dfaTextFieldKp.text = props.dfaGainProportional.toFixed(2)
                dfaTextFieldKi.text = props.dfaGainIntegral.toFixed(2)
                dfaTextFieldKd.text = props.dfaGainDerivative.toFixed(2)
                ifaTextFieldKp.text = props.ifaGainProportional.toFixed(2)
                ifaTextFieldKi.text = props.ifaGainIntegral.toFixed(2)
                ifaTextFieldKd.text = props.ifaGainDerivative.toFixed(2)
                textFieldTs.text    = props.samplingTime.toFixed()
                textFieldSpDfa.text = props.dfaSetpoint.toFixed(MachineData.measurementUnit ? 0 : 2)
                textFieldSpIfa.text = props.ifaSetpoint.toFixed(MachineData.measurementUnit ? 0 : 2)

                props.parameterHasChanged = Qt.binding(function(){
                    return props.dfaKpChanged || props.dfaKiChanged || props.dfaKdChanged || props.ifaKpChanged
                            || props.ifaKiChanged || props.ifaKdChanged || props.tsChanged})

                responseBtn.visible = Qt.binding(function(){return MachineData.closedLoopResponseStatus})
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
                //registerExResources.releaseResource();
            }
        }//
    }//
}//

