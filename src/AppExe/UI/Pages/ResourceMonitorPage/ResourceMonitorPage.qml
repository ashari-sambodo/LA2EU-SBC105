import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "System Monitor"

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
                    title: qsTr("System Monitor")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                //                Loader{
                //                    id: contentLoader
                //                    anchors.fill: parent
                //                    sourceComponent: Item{
                Row{
                    anchors.centerIn: parent
                    spacing: 50
                    Column{
                        id: col1
                        spacing: 10
                        TextApp{
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("CPU Usage")
                        }
                        Image{
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 110
                            height: 110
                            source: "qrc:/UI/Pictures/cpu-usage.png"
                        }
                        TextApp{
                            width: col1.width
                            text: props.resourceMonitorParams[MachineAPI.ResMon_CPU_Usage] + " %"
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                    Column{
                        id: col2
                        spacing: 10
                        //anchors.centerIn: parent
                        TextApp{
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Memory Usage")
                        }
                        Image{
                            width: 110
                            height: 110
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: "qrc:/UI/Pictures/memory-usage.png"
                        }
                        TextApp{
                            width: col2.width
                            text: props.resourceMonitorParams[MachineAPI.ResMon_Memory_Usage] + " %"
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                    Column{
                        id: col3
                        spacing: 10
                        //anchors.centerIn: parent
                        TextApp{
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("CPU Temperature")
                        }
                        Image{
                            width: 110
                            height: 110
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: "qrc:/UI/Pictures/cpu-temp.png"
                        }//
                        TextApp{
                            width: col3.width
                            text: props.getTemp(props.resourceMonitorParams[MachineAPI.ResMon_CPU_Temp]) + " %1".arg(props.degreeSymbol)
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }//
                }//
                //                    }
                //                }
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
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/next-step.png"
                            text: qsTr("Logger")

                            onClicked: {
                                const intent = IntentApp.create("qrc:/UI/Pages/ResourceMonitorPage/Pages/ResourceMonitorLogPage.qml", {})
                                startView(intent)
                            }
                        }//
                    }//
                }//
            }//
        }//

        //        Timer{
        //            interval: 1000
        //            running: true
        //            repeat: true
        //            onTriggered: {
        //                if(MachineData.resourceMonitorParamsActive){
        //                    props.resourceMonitorParams = Qt.binding(function(){return MachineData.resourceMonitorParams})
        //                    running = false
        //                }
        //                console.debug(MachineData.resourceMonitorParams)
        //            }
        //        }

        UtilsApp{
            id: utils
        }

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props
            property var resourceMonitorParams: ["00", "00", "00"]

            property string degreeSymbol: MachineData.measurementUnit ? "°F" : "°C"

            function getTemp(celsius){
                let temp = Number(celsius)
                if(MachineData.measurementUnit)
                    temp = utils.celciusToFahrenheit(temp)

                return Number(temp).toFixed(2);
            }
            //property int countDefault: 50
            //property int count: 50
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                MachineAPI.setResourceMonitorParamsActive(true)
                MachineAPI.setFrontEndScreenState(MachineAPI.ScreenState_ResourceMonitor)

                props.resourceMonitorParams = Qt.binding(function(){return MachineData.resourceMonitorParams})
                //console.debug(props.resourceMonitorParams, props.resourceMonitorParams[MachineAPI.ResMon_CPU_Usage])
                ////console.debug("StackView.Active");
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
                //                MachineAPI.setResourceMonitorParamsActive(false)
                MachineAPI.setFrontEndScreenState(MachineAPI.ScreenState_Other)
            }
        }//
    }//
}//
