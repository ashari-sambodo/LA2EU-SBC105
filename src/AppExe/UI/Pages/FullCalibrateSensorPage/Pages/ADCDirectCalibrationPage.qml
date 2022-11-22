import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "ADC Calibration"

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
                    anchors.fill: parent
                    title: qsTr(viewApp.title)
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                StackView {
                    id: fragmentStackView
                    anchors.fill: parent
                    //initialItem: fragmentStabilizationComp/*calibStabilizationComp*//*fragmentResultComp*/
                }//

                //                // Started
                //                Component {
                //                    id: fragmentStartedComp

                //                    Item {
                //                        property string idname: "started"

                //                        Column{
                //                            spacing: 2
                //                            Rectangle {
                //                                color: "#80000000"
                //                                TextApp {
                //                                    text: qsTr("Ensure the values ​​listed below are correct!")
                //                                    verticalAlignment: Text.AlignVCenter
                //                                    padding: 2
                //                                }
                //                                width: childrenRect.width
                //                                height: childrenRect.height
                //                            }
                //                            Rectangle {
                //                                color: "#80000000"
                //                                TextApp {
                //                                    text: qsTr("If there is an inappropriate value, re-do airflow balancing")
                //                                    verticalAlignment: Text.AlignVCenter
                //                                    padding: 2
                //                                }
                //                                width: childrenRect.width
                //                                height: childrenRect.height
                //                            }
                //                        }

                //                        TextApp{
                //                            anchors.fill: parent
                //                            horizontalAlignment: Text.AlignHCenter
                //                            verticalAlignment: Text.AlignTop
                //                            topPadding: 100
                //                            text: qsTr("Sensor Constant: ") + props.sensorConstant + "<br>" +
                //                                  qsTr("Temperature Calibration: ") + props.temperatureActualStr
                //                        }

                //                        ColumnLayout{
                //                            anchors.fill: parent
                //                            spacing: 5

                //                            Item{
                //                                Layout.fillWidth: true
                //                                Layout.minimumHeight: 50
                //                            }

                //                            Item{
                //                                Layout.fillHeight: true
                //                                Layout.fillWidth: true
                //                                RowLayout{
                //                                    anchors.fill: parent
                //                                    spacing: 10

                //                                    //Minimum Section
                //                                    Item{
                //                                        id: rightItem
                //                                        Layout.fillHeight: true
                //                                        Layout.fillWidth: true
                //                                        ColumnLayout{
                //                                            anchors.fill: parent
                //                                            spacing: 5

                //                                            //Spacing
                //                                            Item{
                //                                                Layout.fillHeight: true
                //                                                Layout.fillWidth: true
                //                                            }

                //                                            //Fan Dcy Min
                //                                            Item{
                //                                                Layout.minimumHeight: 60
                //                                                Layout.fillWidth: true
                //                                                RowLayout{
                //                                                    anchors.fill: parent
                //                                                    spacing: 5
                //                                                    Item{
                //                                                        Layout.fillWidth: true
                //                                                        Layout.fillHeight: true
                //                                                        TextApp{
                //                                                            anchors.fill: parent
                //                                                            text: qsTr("Fan Duty Cycle Minimum")
                //                                                            verticalAlignment: Text.AlignVCenter
                //                                                            horizontalAlignment: Text.AlignRight
                //                                                            rightPadding: 20
                //                                                        }
                //                                                    }
                //                                                    Item{
                //                                                        Layout.fillHeight: true
                //                                                        Layout.minimumWidth: 130
                //                                                        TextFieldApp{
                //                                                            height: 40
                //                                                            width: 110
                //                                                            anchors.centerIn: parent
                //                                                            text: props.fanDutyCycleMinimum
                //                                                            enabled: false
                //                                                            colorBackground: "#949393"

                //                                                            TextApp {
                //                                                                anchors.right: parent.right
                //                                                                anchors.rightMargin: 5
                //                                                                verticalAlignment: Text.AlignVCenter
                //                                                                height: parent.height
                //                                                                text: "%"
                //                                                                //color: "gray"
                //                                                            }//
                //                                                        }
                //                                                    }
                //                                                }
                //                                            }//

                //                                            // IF Minimum
                //                                            Item{
                //                                                Layout.minimumHeight: 60
                //                                                Layout.fillWidth: true
                //                                                RowLayout{
                //                                                    anchors.fill: parent
                //                                                    spacing: 5
                //                                                    Item{
                //                                                        Layout.fillWidth: true
                //                                                        Layout.fillHeight: true
                //                                                        TextApp{
                //                                                            anchors.fill: parent
                //                                                            text: qsTr("Inflow Minimum")
                //                                                            verticalAlignment: Text.AlignVCenter
                //                                                            horizontalAlignment: Text.AlignRight
                //                                                            rightPadding: 20
                //                                                        }
                //                                                    }
                //                                                    Item{
                //                                                        Layout.fillHeight: true
                //                                                        Layout.minimumWidth: 130
                //                                                        TextFieldApp{
                //                                                            height: 40
                //                                                            width: 110
                //                                                            anchors.centerIn: parent
                //                                                            text: props.velocityMinStrf
                //                                                            enabled: false
                //                                                            colorBackground: "#949393"

                //                                                            TextApp {
                //                                                                anchors.right: parent.right
                //                                                                anchors.rightMargin: 5
                //                                                                verticalAlignment: Text.AlignVCenter
                //                                                                height: parent.height
                //                                                                text: props.measureUnit ? "fpm" : "m/s"
                //                                                                //color: "gray"
                //                                                            }//
                //                                                        }
                //                                                    }
                //                                                }
                //                                            }//

                //                                            // IF Alarm Point
                //                                            Item{
                //                                                Layout.minimumHeight: 60
                //                                                Layout.fillWidth: true
                //                                                RowLayout{
                //                                                    anchors.fill: parent
                //                                                    spacing: 5
                //                                                    Item{
                //                                                        Layout.fillWidth: true
                //                                                        Layout.fillHeight: true
                //                                                        TextApp{
                //                                                            anchors.fill: parent
                //                                                            text: qsTr("Inflow Fail Alarm")
                //                                                            verticalAlignment: Text.AlignVCenter
                //                                                            horizontalAlignment: Text.AlignRight
                //                                                            rightPadding: 20
                //                                                        }
                //                                                    }
                //                                                    Item{
                //                                                        Layout.fillHeight: true
                //                                                        Layout.minimumWidth: 130
                //                                                        TextFieldApp{
                //                                                            id: failAlarmTextFieldApp
                //                                                            height: 40
                //                                                            width: 110
                //                                                            anchors.centerIn: parent
                //                                                            text: props.velocityAlarmStrf//MachineData.getInflowLowLimitVelocity()

                //                                                            TextApp {
                //                                                                anchors.right: parent.right
                //                                                                anchors.rightMargin: 5
                //                                                                verticalAlignment: Text.AlignVCenter
                //                                                                height: parent.height
                //                                                                text: props.measureUnit ? "fpm" : "m/s"
                //                                                                color: "gray"
                //                                                            }//

                //                                                            onPressed: {
                //                                                                KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow Fail Alarm"))
                //                                                            }

                //                                                            onAccepted: {
                //                                                                //check value requirement < if nominal, >= if min
                //                                                                console.debug("Input Vel Alarm: " + Number(text))
                //                                                                var alarmPoint = Number(text)
                //                                                                if((alarmPoint < (props.velocity + props.acceptanceVel)) && (alarmPoint >= (props.velocityMin - props.acceptanceVel))){
                //                                                                    props.velocityAlarm = Number(text)
                //                                                                }
                //                                                                else{
                //                                                                    //Value is not valid
                //                                                                    viewApp.showDialogMessage(qsTr("Inflow Fail Alarm"),
                //                                                                                              qsTr("Value is invalid!"),
                //                                                                                              viewApp.dialogAlert,
                //                                                                                              function(){}, false)

                //                                                                    failAlarmTextFieldApp.text = props.velocityAlarmStrf
                //                                                                }
                //                                                            }
                //                                                        }
                //                                                    }
                //                                                }
                //                                            }//

                //                                            //Spacing
                //                                            Item{
                //                                                Layout.fillHeight: true
                //                                                Layout.fillWidth: true
                //                                            }
                //                                        }
                //                                    }//

                //                                    //Nominal Section
                //                                    Item{
                //                                        id: leftItem
                //                                        Layout.fillHeight: true
                //                                        Layout.fillWidth: true
                //                                        ColumnLayout{
                //                                            anchors.fill: parent
                //                                            spacing: 5

                //                                            //Spacing
                //                                            Item{
                //                                                Layout.fillHeight: true
                //                                                Layout.fillWidth: true
                //                                            }

                //                                            //Fan Dcy Nom
                //                                            Item{
                //                                                Layout.minimumHeight: 60
                //                                                Layout.fillWidth: true
                //                                                RowLayout{
                //                                                    anchors.fill: parent
                //                                                    spacing: 5
                //                                                    Item{
                //                                                        Layout.fillWidth: true
                //                                                        Layout.fillHeight: true
                //                                                        TextApp{
                //                                                            anchors.fill: parent
                //                                                            text: qsTr("Fan Duty Cycle Nominal")
                //                                                            verticalAlignment: Text.AlignVCenter
                //                                                            horizontalAlignment: Text.AlignRight
                //                                                            rightPadding: 20
                //                                                        }
                //                                                    }
                //                                                    Item{
                //                                                        Layout.fillHeight: true
                //                                                        Layout.minimumWidth: 130
                //                                                        TextFieldApp{
                //                                                            height: 40
                //                                                            width: 110
                //                                                            anchors.centerIn: parent
                //                                                            text: props.fanDutyCycleNominal
                //                                                            enabled: false
                //                                                            colorBackground: "#949393"

                //                                                            TextApp {
                //                                                                anchors.right: parent.right
                //                                                                anchors.rightMargin: 5
                //                                                                verticalAlignment: Text.AlignVCenter
                //                                                                height: parent.height
                //                                                                text: "%"
                //                                                                //color: "gray"
                //                                                            }//
                //                                                        }
                //                                                    }
                //                                                }
                //                                            }//

                //                                            // IF Nominal
                //                                            Item{
                //                                                Layout.minimumHeight: 60
                //                                                Layout.fillWidth: true
                //                                                RowLayout{
                //                                                    anchors.fill: parent
                //                                                    spacing: 5
                //                                                    Item{
                //                                                        Layout.fillWidth: true
                //                                                        Layout.fillHeight: true
                //                                                        TextApp{
                //                                                            anchors.fill: parent
                //                                                            text: qsTr("Inflow Nominal")
                //                                                            verticalAlignment: Text.AlignVCenter
                //                                                            horizontalAlignment: Text.AlignRight
                //                                                            rightPadding: 20
                //                                                        }
                //                                                    }
                //                                                    Item{
                //                                                        Layout.fillHeight: true
                //                                                        Layout.minimumWidth: 130
                //                                                        TextFieldApp{
                //                                                            height: 40
                //                                                            width: 110
                //                                                            anchors.centerIn: parent
                //                                                            text: props.velocityStrf //Ifa nominal
                //                                                            enabled: false
                //                                                            colorBackground: "#949393"

                //                                                            TextApp {
                //                                                                anchors.right: parent.right
                //                                                                anchors.rightMargin: 5
                //                                                                verticalAlignment: Text.AlignVCenter
                //                                                                height: parent.height
                //                                                                text: props.measureUnit ? "fpm" : "m/s"
                //                                                                //color: "gray"
                //                                                            }//
                //                                                        }
                //                                                    }
                //                                                }
                //                                            }//

                //                                            // DF Nominal
                //                                            Item{
                //                                                Layout.minimumHeight: 60
                //                                                Layout.fillWidth: true
                //                                                RowLayout{
                //                                                    anchors.fill: parent
                //                                                    spacing: 5
                //                                                    Item{
                //                                                        Layout.fillWidth: true
                //                                                        Layout.fillHeight: true
                //                                                        TextApp{
                //                                                            anchors.fill: parent
                //                                                            text: qsTr("Downflow Nominal")
                //                                                            verticalAlignment: Text.AlignVCenter
                //                                                            horizontalAlignment: Text.AlignRight
                //                                                            rightPadding: 20
                //                                                        }
                //                                                    }
                //                                                    Item{
                //                                                        Layout.fillHeight: true
                //                                                        Layout.minimumWidth: 130
                //                                                        TextFieldApp{
                //                                                            height: 40
                //                                                            width: 110
                //                                                            anchors.centerIn: parent
                //                                                            text: props.velocityDfaNomStrf
                //                                                            enabled: false
                //                                                            colorBackground: "#949393"

                //                                                            TextApp {
                //                                                                anchors.right: parent.right
                //                                                                anchors.rightMargin: 5
                //                                                                verticalAlignment: Text.AlignVCenter
                //                                                                height: parent.height
                //                                                                text: props.measureUnit ? "fpm" : "m/s"
                //                                                                //color: "gray"
                //                                                            }//
                //                                                        }
                //                                                    }
                //                                                }
                //                                            }//

                //                                            //Spacing
                //                                            Item{
                //                                                Layout.fillHeight: true
                //                                                Layout.fillWidth: true
                //                                            }
                //                                        }
                //                                    }//

                //                                    //Spacing
                //                                    Item{
                //                                        Layout.fillHeight: true
                //                                        Layout.minimumWidth: 65
                //                                    }
                //                                }//
                //                            }
                //                        }//
                //                    }//
                //                }//

                // Stabilizing
                Component {
                    id: fragmentStabilizationComp

                    Item {
                        property string idname: "stabilized"

                        Row{
                            Column{
                                spacing: 5
                                TextApp{
                                    leftPadding: 10
                                    topPadding: 10
                                    width: 150
                                    text: qsTr("ADC Actual")
                                }
                                TextApp{
                                    leftPadding: 10
                                    width: 150
                                    text: qsTr("Fan State")
                                }
                            }
                            Column{
                                spacing: 5
                                Row{
                                    spacing: 5
                                    TextApp{
                                        leftPadding: 10
                                        topPadding: 10
                                        text: ": " + props.adcActual
                                    }
                                    TextApp{
                                        leftPadding: 10
                                        topPadding: 10
                                        text: "(%1)".arg(props.adcHasStableCount >= 30 ? qsTr("Stable") : qsTr("Unstable"))
                                        color: props.adcHasStableCount >= 30 ? "#27AE60" : "#e74c3c"
                                    }
                                }
                                TextApp{
                                    leftPadding: 10
                                    text: ": " + props.fanDutyCycleActual + "% | " + props.fanRpmActual + " RPM"
                                }
                            }
                        }//

                        ColumnLayout{
                            anchors.fill: parent
                            spacing: 5
                            Item{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                            }

                            Item{
                                Layout.fillWidth: true
                                Layout.minimumHeight: 60
                                TextApp{
                                    anchors.fill: parent
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    text: qsTr("Stabilizing the ADC value of Airflow Sensor%1").arg(MachineData.inflowSensorConstant === 0 ? (" " + qsTr("(ESCO High End)")) : "") + "<br>" +
                                          qsTr("Please wait until progress bar is completed")
                                }
                            }//
                            Item{
                                Layout.fillWidth: true
                                Layout.minimumHeight: 25
                                ProgressBar{
                                    id: stablizingProgressBar
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    background: Rectangle {
                                        implicitWidth: 745
                                        implicitHeight: 10
                                        radius: 5
                                        clip: true
                                    }//

                                    contentItem: Item {
                                        implicitWidth: 250
                                        implicitHeight: 10

                                        Rectangle {
                                            width: stablizingProgressBar.visualPosition * parent.width
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
                                                    if(stablizingProgressBar.value === 1.0) {
                                                        //viewApp.progressBarHasFull()
                                                    }//
                                                }//
                                            }//
                                        }//
                                    }//
                                }//
                            }//
                            Item{
                                Layout.fillWidth: true
                                Layout.minimumHeight: 100
                                Item{
                                    width: stablizingProgressBar.width
                                    height: parent.height
                                    anchors.centerIn: parent
                                    Column{
                                        anchors.left: parent.left
                                        spacing: 5
                                        Rectangle{
                                            id: rectStart
                                            width: 1
                                            height: 50
                                            color: "white"
                                        }
                                        TextApp{
                                            height: 30
                                            x: rectStart.x - (width/2)
                                            //width: parent.width
                                            text: qsTr("Start")
                                            verticalAlignment: Text.AlignVCenter
                                            //horizontalAlignment: Text.AlignHCenter
                                        }
                                    }
                                    Column{
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.horizontalCenterOffset: -((parent.width/2) - ((props.timerCountDownNominal/props.timerCountDown) * parent.width))
                                        spacing: 5
                                        Rectangle{
                                            //id: rectNom
                                            width: 1
                                            height: 50
                                            color: "white"
                                            anchors.horizontalCenter: parent.horizontalCenter
                                        }
                                        TextApp{
                                            height: 30
                                            //x: rectNom.x - (width/2)
                                            //width: parent.width
                                            text: qsTr("ADC Nominal Done")
                                            verticalAlignment: Text.AlignVCenter
                                            //horizontalAlignment: Text.AlignHCenter
                                        }
                                    }
                                    Column{
                                        anchors.right: parent.right
                                        spacing: 5
                                        Rectangle{
                                            id: rectMin
                                            width: 1
                                            height: 50
                                            color: "white"
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.horizontalCenterOffset: textMin.width/2
                                        }
                                        TextApp{
                                            id: textMin
                                            height: 30
                                            x: rectMin.x - (width/2)
                                            //width: parent.width
                                            text: qsTr("ADC Minimum Done")
                                            verticalAlignment: Text.AlignVCenter
                                            //horizontalAlignment: Text.AlignHCenter
                                        }
                                    }
                                }
                            }//

//                            Item{
//                                Layout.fillWidth: true
//                                Layout.minimumHeight: 20
//                                RowLayout{
//                                    height: parent.height
//                                    width: stablizingProgressBar.width * 1.5
//                                    anchors.centerIn: parent
//                                    Item{
//                                        Layout.fillWidth: true
//                                        Layout.fillHeight: true
//                                        TextApp{
//                                            height: parent.height
//                                            width: parent.width
//                                            text: qsTr("Start")
//                                            verticalAlignment: Text.AlignVCenter
//                                            horizontalAlignment: Text.AlignHCenter
//                                        }
//                                    }

//                                    Item{
//                                        Layout.fillWidth: true
//                                        Layout.fillHeight: true
//                                        TextApp{
//                                            height: parent.height
//                                            width: parent.width
//                                            text: qsTr("ADC Nominal Done")
//                                            verticalAlignment: Text.AlignVCenter
//                                            horizontalAlignment: Text.AlignHCenter
//                                        }
//                                    }

//                                    Item{
//                                        Layout.fillWidth: true
//                                        Layout.fillHeight: true
//                                        TextApp{
//                                            height: parent.height
//                                            width: parent.width
//                                            text: qsTr("ADC Minimum Done")
//                                            verticalAlignment: Text.AlignVCenter
//                                            horizontalAlignment: Text.AlignHCenter
//                                        }
//                                    }
//                                }//
//                            }

                            Item{
                                Layout.minimumHeight: 100
                                Layout.fillWidth: true
                                Rectangle{
                                    height: 85
                                    width: 180
                                    anchors.centerIn: parent
                                    color: "#0F2952"
                                    radius: 5
                                    TextApp{
                                        anchors.fill: parent
                                        text: qsTr("Time Left:")
                                        verticalAlignment: Text.AlignTop
                                        horizontalAlignment: Text.AlignHCenter
                                        topPadding: 5
                                    }
                                    TextApp{
                                        id: waitTimeText
                                        anchors.fill: parent
                                        text: "00:00"
                                        font.pixelSize: 35
                                        verticalAlignment: Text.AlignBottom
                                        horizontalAlignment: Text.AlignHCenter
                                        bottomPadding: 5
                                        Component.onCompleted: {
                                            text = utilsApp.strfSecsToMMSS(countTimer.count)
                                        }//
                                    }
                                }
                            }//

                            Item{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                            }
                        }//

                        Timer {
                            id: countTimer
                            interval: 1000
                            running: true; repeat: true
                            onTriggered: {
                                if(count > 0) {
                                    count = count - 1
                                    waitTimeText.text = utilsApp.strfSecsToMMSS(countTimer.count)
                                    stablizingProgressBar.value = utilsApp.map(count, props.timerCountDown, 0, 0, 1)

                                    //nominal done
                                    if(count === (props.timerCountDown - props.timerCountDownNominal)){
                                        //Check if adc has not stable after timer, cancel process and quit
                                        props.saveAdcNominal = true;
                                        if((props.adcHasStableCount >= 30) && (props.adcStableReference > 0)){
                                            //props.saveAdcMinimum = true;
                                            props.adcStableReference = 0;
                                            props.adcHasStable = false;
                                            props.adcHasStableCount = 0;
                                            stableTimer.restart()
                                            props.adjustDutyCycleTo(props.fanDutyCycleMinimum)
                                        }
                                        else{
                                            props.temperatureCalib = props.temperatureActual
                                            props.temperatureCalibAdc = props.temperatureAdcActual
                                            props.temperatureCalibStrf = props.temperatureActualStr

                                            props.calibrateDone = false
                                            props.calibrationFailCode = 0x0002 //ADC Nominal Value Not Stable
                                            fragmentStackView.replace(fragmentResultComp)
                                        }
                                    }

                                    //Check adc stabiliziation after first 1m stabilization
                                    if(stableTimer.running === false){
                                        let minLimit = props.adcStableReference - props.stableCountTolerance;
                                        let maxLimit = props.adcStableReference + props.stableCountTolerance;
                                        if((props.adcActual > minLimit) && (props.adcActual < maxLimit)){
                                            console.debug("Has Stable")
                                            props.adcHasStable = true;
                                        }
                                        else{
                                            console.debug("Not Stable")
                                            props.adcStableReference = props.adcActual
                                            console.debug("Stable Reference Now: " + props.adcStableReference)
                                            props.adcHasStable = false;
                                            props.adcHasStableCount = 0;
                                        }

                                        if(props.adcHasStable){
                                            props.adcHasStableCount++;
                                            console.debug("Stable Count: " + props.adcHasStableCount)
                                        }
                                    }//

                                    /// Monitor Sash Height Real Time
                                    if(MachineData.sashWindowState !== MachineAPI.SASH_STATE_WORK_SSV){
                                        props.calibrateDone = false
                                        props.calibrationFailCode = 0x0004 //Sash position has been moved
                                        fragmentStackView.replace(fragmentResultComp)
                                    }
                                }//
                                else {
                                    running = false
                                    props.saveAdcMinimum = true
                                    if(props.adcHasStableCount >= 30){ //Nominal Stable, Calibration done
                                        props.calibrateDone = true
                                        //props.saveAdcNominal = true
                                    }
                                    else{
                                        props.calibrateDone = false
                                        props.calibrationFailCode = 0x0001 //ADC Minimum not stable
                                    }

                                    //adc value verification
                                    let adcNominalValid = (props.adcNominalResult - props.adcMinimumResult) >= 80 ? true : false
                                    if(!adcNominalValid){
                                        props.calibrateDone = false
                                        props.calibrationFailCode = 0x0003 //ADC Nominal Error
                                    }

                                    //recheck all value get here
                                    props.temperatureCalib = props.temperatureActual
                                    props.temperatureCalibAdc = props.temperatureAdcActual
                                    props.temperatureCalibStrf = props.temperatureActualStr
                                    fragmentStackView.replace(fragmentResultComp)
                                }
                            }//

                            property int count: props.timerCountDown
                        }//

                        Timer{
                            id: stableTimer
                            interval: 1000
                            running: true;
                            repeat: true
                            onTriggered: {
                                props.adcSecondCount++
                                if(props.adcSecondCount >= props.firstGetStableTime){
                                    props.adcStableReference = props.adcActual
                                    console.debug("Stable Reference First: " + props.adcStableReference)
                                    stableTimer.running = false
                                    props.adcSecondCount = 0;
                                }//
                            }//
                        }//

                        UtilsApp{
                            id: utilsApp
                        }

                        //                        Component.onCompleted: {
                        //                            setButton.visible = false
                        //                        }//
                    }//
                }//

                // Result
                Component {
                    id: fragmentResultComp

                    Item {
                        property string idname: "result"

                        RowLayout {
                            anchors.fill: parent

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                Flickable {
                                    id: resultDetailFlickable
                                    anchors.centerIn: parent
                                    height: Math.min(parent.height, resultDetailColumn.height)
                                    width: Math.min(parent.width, resultDetailColumn.width)
                                    clip: true

                                    contentWidth: resultDetailColumn.width
                                    contentHeight: resultDetailColumn.height

                                    ScrollBar.vertical: verticalScrollBar.scrollBar

                                    Column {
                                        id: resultDetailColumn
                                        spacing: 2

                                        Row{
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            Image {
                                                id: featureImage
                                                height: 100
                                                fillMode: Image.PreserveAspectFit
                                                source: "qrc:/UI/Pictures/done-green-white.png"
                                            }//

                                            TextApp{
                                                id: resultStattusText
                                                anchors.verticalCenter: parent.verticalCenter
                                                font.bold: true
                                                text: qsTr("Done")
                                            }//
                                        }

                                        TextApp{
                                            id: resultiInfoText
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            width: 400
                                            wrapMode: Text.WordWrap
                                            visible: false
                                            color: "#ff0000"
                                            padding: 5

                                            Rectangle {
                                                z: -1
                                                anchors.fill: parent
                                                radius: 5
                                                opacity: 0.5
                                            }
                                        }//

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            id: fanMinCalibRow

                                            TextApp{
                                                width: 300
                                                text: qsTr("Fan Minimum") //+ ":"
                                            }//

                                            TextApp {
                                                text: ": " + props.fanDutyCycleMinimum + "% | " + props.fanRpmMinimum + " RPM"
                                            }//
                                        }//

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            id: fanNomCalibRow

                                            TextApp{
                                                width: 300
                                                text: qsTr("Fan Nominal") //+ ":"
                                            }//

                                            TextApp {
                                                text: ": " + props.fanDutyCycleNominal + "% | " + props.fanRpmNominal + " RPM"
                                            }//
                                        }//

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row{
                                            TextApp{
                                                width: 300
                                                text: qsTr("Minimum Inflow Velocity ") //+ ":"
                                            }//

                                            TextApp {
                                                text: ": " + props.velocityMinStrf + " " + props.measureUnitStr
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row{
                                            TextApp{
                                                width: 300
                                                text: qsTr("Inflow Fail Alarm") //+ ":"
                                            }//

                                            TextApp {
                                                text: ": " + props.velocityAlarmStrf + " " + props.measureUnitStr
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row{
                                            TextApp{
                                                width: 300
                                                text: qsTr("Nominal Inflow Velocity ") //+ ":"
                                            }//

                                            TextApp {
                                                text: ": " + props.velocityStrf + " " + props.measureUnitStr
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row{
                                            TextApp{
                                                width: 300
                                                text: qsTr("Nominal Downflow Velocity") //+ ":"
                                            }//

                                            TextApp {
                                                text: ": " + props.velocityDfaNomStrf + " " + props.measureUnitStr
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            TextApp{
                                                width: 300
                                                text: qsTr("ADC Minimum") + " (IF1)" //+ ":"
                                            }//

                                            TextApp {
                                                text: ": " + props.adcMinimumResult
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            TextApp{
                                                width: 300
                                                text: qsTr("ADC Nominal") + " (IF2)" //+ ":"
                                            }//

                                            TextApp {
                                                text: ": " + props.adcNominalResult
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            id: temperatureCalibRow

                                            TextApp{
                                                width: 300
                                                text: qsTr("Temperature Calibration") //+ ":"
                                            }//

                                            TextApp {
                                                text: ": " + props.temperatureCalibStrf + " | ADC: " + props.temperatureCalibAdc
                                            }//
                                        }//

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}
                                    }//
                                }//
                            }//

                            ScrollBarApp {
                                id: verticalScrollBar
                                Layout.fillHeight: true
                                Layout.fillWidth: false
                                Layout.minimumWidth: 20
                                visible: resultDetailFlickable.contentHeight > resultDetailFlickable.height
                            }//
                        }//

                        Component.onCompleted: {
                            if (!props.calibrateDone){
                                featureImage.source = "qrc:/UI/Pictures/fail-red-white.png"
                                resultStattusText.text = qsTr("Failed")
                                resultiInfoText.visible = true
                                if(props.calibrationFailCode === 0x0001)
                                    resultiInfoText.text = qsTr("The ADC minimum value is unstable")
                                else if(props.calibrationFailCode === 0x0002)
                                    resultiInfoText.text = qsTr("The ADC nominal value is unstable")
                                else if(props.calibrationFailCode === 0x0003)
                                    resultiInfoText.text = qsTr("The required ADC range (IF2 - IF1) is ") + "80"
                                else if(props.calibrationFailCode === 0x0004)
                                    resultiInfoText.text = qsTr("The Sash height is not at working height position!")
                            }
                            else {
                                /// Save the Calibration data Immediately once done
                                {
                                    /// Temperature Calibration
                                    MachineAPI.setInflowTemperatureCalib(props.temperatureCalib, props.temperatureCalibAdc)

                                    /// Minimum
                                    MachineAPI.setInflowAdcPointFactory(MachineAPI.POINT_MINIMUM, props.adcMinimumResult)

                                    let velocityMin = props.velocityMin
                                    if(props.measurementUnit) velocityMin = Math.round(velocityMin)
                                    velocityMin = Math.round(velocityMin * 100)

                                    MachineAPI.setInflowVelocityPointFactory(MachineAPI.POINT_MINIMUM, velocityMin)
                                    MachineAPI.setDownflowVelocityPointFactory(MachineAPI.POINT_MINIMUM, 0)
                                    MachineAPI.setInflowLowLimitVelocity(velocityMin)

                                    MachineAPI.setFanPrimaryMinimumDutyCycleFactory(props.fanDutyCycleMinimum)
                                    MachineAPI.setFanPrimaryMinimumRpmFactory(props.fanRpmMinimum)

                                    /// Nominal
                                    MachineAPI.setInflowAdcPointFactory(2, props.adcNominalResult)

                                    let velocityNom = props.velocity
                                    if(props.measurementUnit) velocityNom = Math.round(velocityNom)
                                    velocityNom = Math.round(velocityNom * 100)

                                    MachineAPI.setInflowVelocityPointFactory(MachineAPI.POINT_NOMINAL, velocityNom)

                                    let velocityNomDfa = props.velocityDfaNom
                                    if(props.measurementUnit) velocityNomDfa = Math.round(velocityNomDfa)
                                    velocityNomDfa = Math.round(velocityNomDfa * 100)

                                    MachineAPI.setDownflowVelocityPointFactory(MachineAPI.POINT_NOMINAL, velocityNomDfa)

                                    MachineAPI.setFanPrimaryNominalDutyCycleFactory(props.fanDutyCycleNominal)
                                    MachineAPI.setFanPrimaryNominalRpmFactory(props.fanRpmNominal)


                                    /// clear field calibration
                                    MachineAPI.setInflowAdcPointField(0, 0, 0)
                                    MachineAPI.setInflowVelocityPointField(0, 0, 0)

                                    //Force Zero-Point to Zero
                                    MachineAPI.setInflowAdcPointFactory(MachineAPI.POINT_ZERO, 0)
                                    MachineAPI.setInflowVelocityPointFactory(MachineAPI.POINT_ZERO, 0)
                                    MachineAPI.setDownflowVelocityPointFactory(MachineAPI.POINT_ZERO, 0)

                                    /// Reset the field calibration state
                                    for(let i = 0; i < MachineAPI.CalFieldState_Total; i++)
                                        MachineAPI.setAirflowFieldCalibrationState(i, false)

                                    MachineAPI.initAirflowCalibrationStatus(MachineAPI.AF_CALIB_FACTORY);

                                    ///EVENT LOG
                                    const message = qsTr("User: Full sensor calibration")
                                                  + "("
                                                  + "ADC-IFZ: " + 0 + ", "
                                                  + "ADC-IF1: " + props.adcMinimumResult + ", "
                                                  + "ADC-IF2: " + props.adcNominalResult + ", "
                                                  + "VEL-IF1: " + (velocityMin / 100).toFixed(2) + ", "
                                                  + "VEL-IF2: " + (velocityNom / 100).toFixed(2)
                                                  + ")"
                                    MachineAPI.insertEventLog(message);
                                }//

                                viewApp.showBusyPage(qsTr("Setting up..."), function(cycle){
                                    if (cycle >= MachineAPI.BUSY_CYCLE_1) {
                                        MachineAPI.setFanState(MachineAPI.FAN_STATE_ON)
                                        viewApp.dialogObject.close()
                                    }
                                })

                                backButton.text = qsTr("Re-Do")
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

                BackgroundButtonBarApp {
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
                                if (fragmentStackView.currentItem.idname === "stabilized"){
                                    viewApp.showDialogAsk(qsTr("ADC Calibration"),
                                                          qsTr("Cancel this process?"),
                                                          viewApp.dialogAlert,
                                                          function onAccepted(){
                                                              //console.debug("Y")
                                                              showBusyPage(qsTr("Loading..."),
                                                                           function onCycle(cycle){
                                                                               if (cycle === 1){
                                                                                   viewApp.closeDialog()
                                                                                   var intent = IntentApp.create(uri, {})
                                                                                   finishView(intent)
                                                                               }
                                                                           })
                                                          })
                                    return
                                }

                                if (fragmentStackView.currentItem.idname === "result" && props.calibrateDone){
                                    viewApp.showDialogAsk(qsTr("ADC Calibration"),
                                                          qsTr("Are you sure to re-do the ADC calibration?"),
                                                          viewApp.dialogAlert,
                                                          function onAccepted(){
                                                              //console.debug("Y")
                                                              showBusyPage(qsTr("Loading..."),
                                                                           function onCycle(cycle){
                                                                               if (cycle === 1){
                                                                                   viewApp.closeDialog()
                                                                                   var intent = IntentApp.create(uri, {})
                                                                                   finishView(intent)
                                                                               }
                                                                           })
                                                          })
                                    return
                                }//

                                var intent = IntentApp.create(uri, {})
                                finishView(intent)
                            }//
                        }//

                        ButtonBarApp {
                            id: setButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            visible: props.calibrateDone

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Done")

                            onClicked: {
                                let intent = IntentApp.create(uri,
                                                              {
                                                                  "pid": props.pid,
                                                                  "failCode": props.calibrationFailCode,
                                                                  "sensorAdcMinimum": props.adcMinimumResult,
                                                                  "sensorAdcNominal": props.adcNominalResult,
                                                                  "sensorVelMinimum": props.velocityMin,
                                                                  "sensorVelLowAlarm": props.velocityAlarm,
                                                                  "sensorVelNominal": props.velocity,
                                                                  "sensorVelNominalDfa": props.velocityDfaNom,
                                                                  "fanDutyCycleNominal": props.fanDutyCycleNominal,
                                                                  "fanRpmNominal": props.fanRpmNominal,
                                                                  "fanDutyCycleMinimum": props.fanDutyCycleMinimum,
                                                                  "fanRpmMinimum": props.fanRpmMinimum,
                                                                  "temperatureCalib": props.temperatureCalib,
                                                                  "temperatureCalibAdc": props.temperatureCalibAdc
                                                              })
                                finishView(intent);
                            }//
                        }//
                    }//
                }//
            }
        }//

        QtObject {
            id: props

            property string pid: ""

            property int fanDutyCycleActual: 0
            property int fanRpmActual: 0

            property int sensorConstant: 0
            property int sensorAdcZero: 0
            property int sensorAdcMinimum: 0

            property int adcActual: 0
            property int adcMinimumResult: 0
            property int adcNominalResult: 0
            property int adcResult: 0
            property int temperatureActual: 0
            property int temperatureAdcActual: 0
            property string temperatureActualStr: "0°C"

            //
            property int adcStableReference: 0
            property bool adcHasStable: false
            property int adcSecondCount: 0
            property int firstGetStableTime: 60/timerDivider // must 1m (60)
            property int adcHasStableCount: 0

            readonly property int stableCountTolerance: 10

            property bool saveAdcMinimum: false
            property bool saveAdcNominal: false

            onSaveAdcMinimumChanged: {
                if(saveAdcMinimum === true){
                    adcMinimumResult = adcActual
                    fanRpmMinimum = fanRpmActual
                    console.debug("Adc Minimum Result: " + adcMinimumResult)
                    //Auto adjust to duty cycle nominal value
                    //props.adjustDutyCycleTo(props.fanDutyCycleNominal)
                }
            }//

            onSaveAdcNominalChanged: {
                if(saveAdcNominal === true){
                    adcNominalResult = adcActual
                    fanRpmNominal = fanRpmActual
                    console.debug("Adc Nominal Result: " + adcNominalResult)
                }
            }

            /// 0: metric, m/s
            /// 1: imperial, fpm
            property int measureUnit: 0
            property string measureUnitStr: measureUnit ? "fpm" : "m/s"
            /// Metric normally 2 digits after comma, ex: 0.30
            /// Imperial normally Zero digit after comma, ex: 60
            property int velocityDecimalPoint: measureUnit ? 0 : 2

            // Nominal
            property real velocity: 0
            property string velocityStrf: "0"
            //
            property real velocityMin: 0
            property string velocityMinStrf: "0"

            property real velocityAlarm: 0
            property string velocityAlarmStrf: "0"

            property real acceptanceVel: measureUnit ? 5 : 0.025

            onVelocityAlarmChanged: {
                velocityAlarmStrf = velocityAlarm.toFixed(velocityDecimalPoint)
            }

            property real velocityDfaNom: 0
            property string velocityDfaNomStrf: "0"

            //property int fanDutyCycleInitial: 0
            property int fanDutyCycleNominal: 0
            property int fanDutyCycleMinimum: 0

            property int fanRpmNominal: 0
            property int fanRpmMinimum: 0

            property int fanDutyCycleResult: 0
            property int fanRpmResult: 0

            property int temperatureCalib: 0
            property int temperatureCalibAdc: 0
            property string temperatureCalibStrf: ""

            property bool calibrateDone: false
            property int timerDivider: __osplatform__ ? 1 : 2
            property int timerCountDownNominal: ((MachineData.inflowSensorConstant === 0) ? 120 : 180)/timerDivider
            property int timerCountDownMinimum: ((MachineData.inflowSensorConstant === 0) ? 120 : 300)/timerDivider
            property int timerCountDown: ((MachineData.inflowSensorConstant === 0) ? 240 : 480)/timerDivider //4 min for degree C and 8 min for esco airflow sensor

            property int calibrationFailCode: 0

            function adjustDutyCycleTo(duty){
                if (fanDutyCycleActual !== duty) {
                    MachineAPI.setFanPrimaryDutyCycle(duty);
                    viewApp.showBusyPage(qsTr("Adjusting fan duty cycle..."),
                                         function onTriggered(cycle){
                                             if(cycle >= MachineAPI.BUSY_CYCLE_2){
                                                 // close this pop up dialog
                                                 viewApp.dialogObject.close()
                                             }
                                         })
                    return true
                }
                return false
            }
        }

        /// Called once but after onResume
        Component.onCompleted: {
            //if(!__osplatform__){
            //    props.timerCountDown = 30
            //}
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //console.debug("StackView.Active");
                let extradata = IntentApp.getExtraData(intent)
                //console.debug(JSON.stringify(extradata))
                if (extradata['pid'] !== undefined) {
                    //                        //console.debug(extradata['pid'])
                    props.pid = extradata['pid']

                    props.measureUnit = extradata['measureUnit']

                    props.sensorConstant = extradata['sensorConstant'] || 0

                    props.fanDutyCycleMinimum = extradata['fanDutyCycleMinimum'] || 0
                    props.fanDutyCycleNominal = extradata['fanDutyCycleNominal'] || 0

                    //Ifa min
                    let velocityIfaMinimum = extradata['sensorVelMinimum'] || 0
                    props.velocityMin = velocityIfaMinimum
                    props.velocityMinStrf = velocityIfaMinimum.toFixed(props.velocityDecimalPoint)

                    let velocityIfaAlarm = extradata['sensorVelLowAlarm'] || 0
                    props.velocityAlarm = velocityIfaAlarm
                    props.velocityAlarmStrf = velocityIfaAlarm.toFixed(props.velocityDecimalPoint)

                    //dfa nom
                    let velocityDfaNominal = extradata['sensorVelNominalDfa'] || 0
                    props.velocityDfaNom = velocityDfaNominal
                    props.velocityDfaNomStrf = velocityDfaNominal.toFixed(props.velocityDecimalPoint)

                    //ifa nom
                    let velocity = extradata['sensorVelNominal'] || 0
                    props.velocity = velocity
                    props.velocityStrf = velocity.toFixed(props.velocityDecimalPoint)
                }

                props.fanDutyCycleActual = Qt.binding(function(){ return MachineData.fanPrimaryDutyCycle })
                props.fanRpmActual = Qt.binding(function(){ return MachineData.fanPrimaryRpm })

                props.adcActual = Qt.binding(function(){ return MachineData.ifaAdcConpensation })

                props.temperatureActual = Qt.binding(function(){ return MachineData.temperature })
                props.temperatureAdcActual = Qt.binding(function(){ return MachineData.temperatureAdc })
                props.temperatureActualStr = Qt.binding(function(){ return MachineData.temperatureValueStr })

                if((props.velocityAlarm < (props.velocity + props.acceptanceVel)) && (props.velocityAlarm >= (props.velocityMin - props.acceptanceVel)) &&
                        (props.fanDutyCycleNominal > props.fanDutyCycleMinimum) && (props.velocity > props.velocityMin) &&
                        (props.velocityDfaNom > 0)){
                    //automatically adjust duty cycle to nominal value
                    if(props.adjustDutyCycleTo(props.fanDutyCycleNominal)){
                        props.timerCountDown = ((MachineData.inflowSensorConstant === 0) ? 240 : 600)/props.timerDivider //4 min for degree C and 10 min for esco airflow sensor
                        props.timerCountDownNominal = ((MachineData.inflowSensorConstant === 0) ? 120 : 300)/props.timerDivider
                        props.timerCountDownMinimum = ((MachineData.inflowSensorConstant === 0) ? 120 : 300)/props.timerDivider
                    }
                    fragmentStackView.replace(fragmentStabilizationComp)
                }
                else{
                    viewApp.showDialogMessage(qsTr("ADC Calibration"),
                                              qsTr("There is an invalid value!"),
                                              viewApp.dialogAlert,
                                              function(){}, false)
                }
            }//

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }//
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";formeditorZoom:1.25;height:480;width:800}
}
##^##*/
