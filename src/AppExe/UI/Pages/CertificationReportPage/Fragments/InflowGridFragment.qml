import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.1
import UI.CusCom 1.0
import ModulesCpp.Machine 1.0

import "../Components" as LocalComp

Item {
    id: control

    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            RowLayout {
                anchors.fill: parent

                Item {
                    Layout.fillWidth: false
                    Layout.minimumWidth: 200
                    Layout.fillHeight: true

                    Column {
                        spacing: 2

                        TextApp {
                            width: 200
                            text: qsTr("Inflow Nominal")
                            font.bold: true
                        }//

                        TextApp {
                            width: 200
                            text: qsTr("Duty cycle") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0%"

                            Component.onCompleted: {
                                valueStrf = settings.ifaCalGridNomDcy + "%"
                            }//
                        }//

                        TextApp {
                            width: 200
                            text: qsTr("Total") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVol = MachineData.measurementUnit ? "cfm" : "l/s"
                                valueStrf = (MachineData.measurementUnit ? settings.ifaCalGridNomTotImp : settings.ifaCalGridNomTot) + " " + meaVol

                            }//
                        }//

                        TextApp {
                            width: 200
                            text: qsTr("Average") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVol = MachineData.measurementUnit ? "cfm" : "l/s"
                                valueStrf = (MachineData.measurementUnit ? settings.ifaCalGridNomAvgImp : settings.ifaCalGridNomAvg) + " " + meaVol

                            }//
                        }//

                        TextApp {
                            width: 200
                            text: qsTr("Velocity") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVel = MachineData.measurementUnit ? "fpm" : "m/s"
                                let vel = (MachineData.measurementUnit ? settings.ifaCalGridNomVelImp : settings.ifaCalGridNomVel)
                                if(MachineData.measurementUnit) vel = (vel/100).toFixed()
                                else vel = (vel/100).toFixed(2)
                                valueStrf = vel + " " + meaVel

                            }//
                        }//
                    }//
                }

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    LocalComp.AirflowGridWrapper {
                        id: loaderIfaNomGrid
                        anchors.fill: parent
                        visibleHorizontalScroll: false
                        visibleVerticalScroll: false
                    }//
                }//
            }//
        }//

        Rectangle {
            Layout.fillWidth: true
            Layout.minimumHeight: 1
            Layout.fillHeight: false
            color: "#e3dac9"
        }//

        Item {
            //            visible: fieldOrFull
            Layout.fillHeight: true
            Layout.fillWidth: true

            RowLayout {
                anchors.fill: parent

                Item {
                    Layout.fillWidth: false
                    Layout.minimumWidth: 200
                    Layout.fillHeight: true

                    Column {
                        spacing: 2

                        TextApp {
                            width: 200
                            text: qsTr("Inflow Minimum")
                            font.bold: true
                        }//

                        TextApp {
                            width: 200
                            text: qsTr("Duty cycle") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0%"

                            Component.onCompleted: {
                                valueStrf = settings.ifaCalGridMinDcy + "%"
                            }//
                        }//

                        TextApp {
                            width: 200
                            text: qsTr("Total") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVol = MachineData.measurementUnit ? "cfm" : "l/s"
                                valueStrf = (MachineData.measurementUnit ? settings.ifaCalGridMinTotImp : settings.ifaCalGridMinTot) + " " + meaVol
                            }//
                        }//

                        TextApp {
                            width: 200
                            text: qsTr("Average") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVol = MachineData.measurementUnit ?  "cfm" : "l/s"
                                valueStrf = (MachineData.measurementUnit ? settings.ifaCalGridMinAvgImp : settings.ifaCalGridMinAvg) + " " + meaVol

                            }//
                        }//

                        TextApp {
                            width: 200
                            text: qsTr("Velocity") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVel = MachineData.measurementUnit ?  "fpm" : "m/s"
                                let vel = (MachineData.measurementUnit ? settings.ifaCalGridMinVelImp : settings.ifaCalGridMinVel)
                                if(MachineData.measurementUnit) vel = (vel/100).toFixed()
                                else vel = (vel/100).toFixed(2)
                                valueStrf = vel + " " + meaVel

                            }//
                        }//
                    }//
                }//

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    LocalComp.AirflowGridWrapper {
                        id: loaderIfaMinGrid
                        anchors.fill: parent
                        visibleHorizontalScroll: false
                        visibleVerticalScroll: false
                    }//
                }//
            }//
        }//

        Rectangle {
            Layout.fillWidth: true
            Layout.minimumHeight: 1
            Layout.fillHeight: false
            color: "#e3dac9"
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            RowLayout {
                anchors.fill: parent

                Item {
                    Layout.fillWidth: false
                    Layout.minimumWidth: 200
                    Layout.fillHeight: true

                    Column {
                        spacing: 2

                        TextApp {
                            width: 200
                            text: qsTr("Inflow Standby")
                            font.bold: true
                        }

                        TextApp {
                            width: 200
                            text: qsTr("Duty cycle") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0%"

                            Component.onCompleted: {
                                valueStrf = settings.ifaCalGridStbDcy + "%"
                            }//
                        }//

                        TextApp {
                            width: 200
                            text: qsTr("Total") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVol = MachineData.measurementUnit ? "cfm" : "l/s"
                                valueStrf = (MachineData.measurementUnit ? settings.ifaCalGridStbTotImp : settings.ifaCalGridStbTot) + " " + meaVol
                            }
                        }

                        TextApp {
                            width: 200
                            text: qsTr("Average") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVol = MachineData.measurementUnit ? "cfm" : "l/s"
                                valueStrf = (MachineData.measurementUnit ? settings.ifaCalGridStbAvgImp : settings.ifaCalGridStbAvg) + " " + meaVol
                            }
                        }

                        TextApp {
                            width: 200
                            text: qsTr("Velocity") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVel = MachineData.measurementUnit ? "fpm" : "m/s"
                                let vel = (MachineData.measurementUnit ? settings.ifaCalGridStbVelImp : settings.ifaCalGridStbVel)
                                if(MachineData.measurementUnit) vel = (vel/100).toFixed()
                                else vel = (vel/100).toFixed(2)
                                valueStrf = vel + " " + meaVel
                            }//
                        }//
                    }//
                }//

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    LocalComp.AirflowGridWrapper {
                        id: loaderIfaStbGrid
                        anchors.fill: parent
                        visibleHorizontalScroll: false
                        visibleVerticalScroll: false
                    }//
                }//
            }//
        }//
    }//

    JsonStringifyWorkerApp {
        id: jsonStringify

        //        onEstablishedChanged: {
        //            console.log("onEstablishedChanged")
        //        }//

        onMessage: {
            //            console.debug(JSON.stringify(messageObject))

            if(messageObject.id === "loaderIfaNomGrid"){
                const grid = messageObject.data || [{}]
                loaderIfaNomGrid.loader.setSource("../Components/AirflowGrid.qml",
                                                  {
                                                      "measureUnit": MachineData.measurementUnit,
                                                      "columns": 5,
                                                      "model": grid,
                                                      "valueMinimum": 0,
                                                      "valueMaximum": 1000,
                                                  })
                //                console.log("Nominal grid")
                //                console.log(settings.ifaCalGridMin)
                jsonStringify.s2j('loaderIfaMinGrid', settings.ifaCalGridMin)
            }

            else if(messageObject.id === "loaderIfaMinGrid"){

                const grid = messageObject.data || [{}]
                loaderIfaMinGrid.loader.setSource("../Components/AirflowGrid.qml",
                                                  {
                                                      "measureUnit": MachineData.measurementUnit,
                                                      "columns": 5,
                                                      "model": grid,
                                                      "valueMinimum": 0,
                                                      "valueMaximum": 1000,
                                                  })
                //                console.log("Minimum grid")
                jsonStringify.s2j('loaderIfaStbGrid', settings.ifaCalGridStb)

            }//
            else if(messageObject.id ===  "loaderIfaStbGrid"){
                const grid = messageObject.data || [{}]
                loaderIfaStbGrid.loader.setSource("../Components/AirflowGrid.qml",
                                                  {
                                                      "measureUnit": MachineData.measurementUnit,
                                                      "columns": 5,
                                                      "model": grid,
                                                      "valueMinimum": 0,
                                                      "valueMaximum": 1000,
                                                  })
                //                console.log("std grid")
            }//
        }//
    }//

    Settings {
        id: settings

        property string ifaCalGridNom: "[]"
        property int    ifaCalGridNomTot: 0
        property int    ifaCalGridNomAvg: 0
        property int    ifaCalGridNomVol: 0
        property int    ifaCalGridNomVel: 0
        property int    ifaCalGridNomTotImp: 0
        property int    ifaCalGridNomAvgImp: 0
        property int    ifaCalGridNomVolImp: 0
        property int    ifaCalGridNomVelImp: 0
        property int    ifaCalGridNomDcy: 0

        property string ifaCalGridMin: "[]"
        property int    ifaCalGridMinTot: 0
        property int    ifaCalGridMinAvg: 0
        property int    ifaCalGridMinVol: 0
        property int    ifaCalGridMinVel: 0
        property int    ifaCalGridMinTotImp: 0
        property int    ifaCalGridMinAvgImp: 0
        property int    ifaCalGridMinVolImp: 0
        property int    ifaCalGridMinVelImp: 0
        property int    ifaCalGridMinDcy: 0

        property string ifaCalGridStb: "[]"
        property int    ifaCalGridStbTot: 0
        property int    ifaCalGridStbAvg: 0
        property int    ifaCalGridStbVol: 0
        property int    ifaCalGridStbVel: 0
        property int    ifaCalGridStbTotImp: 0
        property int    ifaCalGridStbAvgImp: 0
        property int    ifaCalGridStbVolImp: 0
        property int    ifaCalGridStbVelImp: 0
        property int    ifaCalGridStbDcy: 0

        Component.onCompleted: {
            jsonStringify.s2j('loaderIfaNomGrid', ifaCalGridNom)
            //jsonStringify.s2j('loaderIfaMinGrid', ifaCalGridMin)
            //jsonStringify.s2j('loaderIfaStbGrid', ifaCalGridStb)

        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
