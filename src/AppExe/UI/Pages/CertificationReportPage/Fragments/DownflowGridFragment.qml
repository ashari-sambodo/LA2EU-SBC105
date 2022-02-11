import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import Qt.labs.settings 1.1
import UI.CusCom 1.1
import ModulesCpp.Machine 1.0

import "../Components" as LocalComp

Item {


    ColumnLayout {
        anchors.fill: parent
        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true
            RowLayout{
                anchors.fill: parent
                Item{
                    Layout.fillHeight: true
                    Layout.minimumWidth: 300
                    Column{
                        anchors.verticalCenter: parent.verticalCenter
                        TextApp {
                            width: 300
                            text: qsTr("Downflow Nominal")
                            font.bold: true
                        }
                        TextApp {
                            id: velocityTextAppNom
                            width: 300
                            text: qsTr("Average") + ": "+ valueStrf

                            property string valueStrf: "0.32 m/s"
                        }//
                        TextApp {
                            id: deviationTextAppNom
                            width: 300
                            text: qsTr("Max Deviation") + ": "+ valueStrf

                            property string valueStrf: "0.04 m/s (12.5%)"
                        }//
                    }//
                }//
                Item{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    LocalComp.AirflowGridWrapper {
                        id: loaderDfaNomGrid
                        anchors.fill: parent
                        visibleHorizontalScroll: true
                        visibleVerticalScroll: true
                    }//
                }//
            }//
        }//
        Rectangle{
            Layout.minimumHeight: 1
            Layout.fillWidth: true
        }
        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true
            RowLayout{
                anchors.fill: parent
                Item{
                    Layout.fillHeight: true
                    Layout.minimumWidth: 300
                    Column{
                        anchors.verticalCenter: parent.verticalCenter
                        TextApp {
                            width: 300
                            text: qsTr("Downflow Minimum")
                            font.bold: true
                        }
                        TextApp {
                            id: velocityTextAppMin
                            width: 300
                            text: qsTr("Average") + ": "+ valueStrf

                            property string valueStrf: "0.32 m/s"
                        }//
                        TextApp {
                            id: deviationTextAppMin
                            width: 300
                            text: qsTr("Max Deviation") + ": "+ valueStrf

                            property string valueStrf: "0.04 m/s (12.5%)"
                        }//
                    }//
                }//
                Item{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    LocalComp.AirflowGridWrapper {
                        id: loaderDfaMinGrid
                        anchors.fill: parent
                        visibleHorizontalScroll: true
                        visibleVerticalScroll: true
                    }//
                }//
            }//
        }//
        Rectangle{
            Layout.minimumHeight: 1
            Layout.fillWidth: true
        }
        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true
            RowLayout{
                anchors.fill: parent
                Item{
                    Layout.fillHeight: true
                    Layout.minimumWidth: 300
                    Column{
                        anchors.verticalCenter: parent.verticalCenter
                        TextApp {
                            width: 300
                            text: qsTr("Downflow Maximum")
                            font.bold: true
                        }
                        TextApp {
                            id: velocityTextAppMax
                            width: 300
                            text: qsTr("Average") + ": "+ valueStrf

                            property string valueStrf: "0.32 m/s"
                        }//
                        TextApp {
                            id: deviationTextAppMax
                            width: 300
                            text: qsTr("Max Deviation") + ": "+ valueStrf

                            property string valueStrf: "0.04 m/s (12.5%)"
                        }//
                    }//
                }//
                Item{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    LocalComp.AirflowGridWrapper {
                        id: loaderDfaMaxGrid
                        anchors.fill: parent
                        visibleHorizontalScroll: true
                        visibleVerticalScroll: true
                    }//
                }//
            }//
        }//
    }//

    property bool fieldOrFull

    JsonStringifyWorkerApp {
        id: jsonStringify

        //        onEstablishedChanged: {
        //            console.log("onEstablishedChanged")
        //        }//

        onMessage: {
            //            console.debug(JSON.stringify(messageObject))

            if(messageObject.id === "loaderDfaNomGrid"){
                const grid = messageObject.data || [{}]

                let dfaCalGridNomVelHigh    =  MachineData.measurementUnit ? (settings.dfaCalGridNomVelHighImp / 100) : (settings.dfaCalGridNomVelHigh / 100)
                let dfaCalGridNomVelLow     =  MachineData.measurementUnit ? (settings.dfaCalGridNomVelLowImp / 100) : (settings.dfaCalGridNomVelLow / 100)
                let dfaCalGridNomVelDev     =  MachineData.measurementUnit ? (settings.dfaCalGridNomVelDevImp / 100) : (settings.dfaCalGridNomVelDev / 100)
                let dfaCalGridNomVelDevp    =  MachineData.measurementUnit ? (settings.dfaCalGridNomVelDevpImp / 100) : (settings.dfaCalGridNomVelDevp / 100)

                let columns = MachineData.machineProfile['airflow']['dfa']['nominal']['grid']['columns']

                loaderDfaNomGrid.loader.setSource("../Components/AirflowGrid.qml",
                                                  {
                                                      "measureUnit": MachineData.measurementUnit,
                                                      "columns": columns,
                                                      "model": grid,
                                                      "valueMinimum": dfaCalGridNomVelLow,
                                                      "valueMaximum": dfaCalGridNomVelHigh,
                                                  })
            }//
            if(messageObject.id === "loaderDfaMinGrid"){
                const grid = messageObject.data || [{}]

                let dfaCalGridMinVelHigh    =  MachineData.measurementUnit ? (settings.dfaCalGridMinVelHighImp / 100) : (settings.dfaCalGridMinVelHigh / 100)
                let dfaCalGridMinVelLow     =  MachineData.measurementUnit ? (settings.dfaCalGridMinVelLowImp / 100) : (settings.dfaCalGridMinVelLow / 100)
                let dfaCalGridMinVelDev     =  MachineData.measurementUnit ? (settings.dfaCalGridMinVelDevImp / 100) : (settings.dfaCalGridMinVelDev / 100)
                let dfaCalGridMinVelDevp    =  MachineData.measurementUnit ? (settings.dfaCalGridMinVelDevpImp / 100) : (settings.dfaCalGridMinVelDevp / 100)

                let columns = MachineData.machineProfile['airflow']['dfa']['minimum']['grid']['columns']

                loaderDfaMinGrid.loader.setSource("../Components/AirflowGrid.qml",
                                                  {
                                                      "measureUnit": MachineData.measurementUnit,
                                                      "columns": columns,
                                                      "model": grid,
                                                      "valueMinimum": dfaCalGridMinVelLow,
                                                      "valueMaximum": dfaCalGridMinVelHigh,
                                                  })
            }//
            if(messageObject.id === "loaderDfaMaxGrid"){
                const grid = messageObject.data || [{}]

                let dfaCalGridMaxVelHigh    =  MachineData.measurementUnit ? (settings.dfaCalGridMaxVelHighImp / 100) : (settings.dfaCalGridMaxVelHigh / 100)
                let dfaCalGridMaxVelLow     =  MachineData.measurementUnit ? (settings.dfaCalGridMaxVelLowImp / 100) : (settings.dfaCalGridMaxVelLow / 100)
                let dfaCalGridMaxVelDev     =  MachineData.measurementUnit ? (settings.dfaCalGridMaxVelDevImp / 100) : (settings.dfaCalGridMaxVelDev / 100)
                let dfaCalGridMaxVelDevp    =  MachineData.measurementUnit ? (settings.dfaCalGridMaxVelDevpImp / 100) : (settings.dfaCalGridMaxVelDevp / 100)

                let columns = MachineData.machineProfile['airflow']['dfa']['maximum']['grid']['columns']

                loaderDfaMaxGrid.loader.setSource("../Components/AirflowGrid.qml",
                                                  {
                                                      "measureUnit": MachineData.measurementUnit,
                                                      "columns": columns,
                                                      "model": grid,
                                                      "valueMinimum": dfaCalGridMaxVelLow,
                                                      "valueMaximum": dfaCalGridMaxVelHigh,
                                                  })
            }//
        }//
    }//

    UtilsApp {
        id: utils
    }//

    Settings {
        id: settings

        property string dfaCalGridNom:          "[]"
        property int    dfaCalGridNomVel:       0
        property int    dfaCalGridNomVelDev:    0
        property int    dfaCalGridNomVelDevp:   0
        property int    dfaCalGridNomVelHigh:   0
        property int    dfaCalGridNomVelLow:    0

        property int    dfaCalGridNomVelImp:       0
        property int    dfaCalGridNomVelDevImp:    0
        property int    dfaCalGridNomVelDevpImp:   0
        property int    dfaCalGridNomVelHighImp:   0
        property int    dfaCalGridNomVelLowImp:    0

        property string dfaCalGridMin:          "[]"
        property int    dfaCalGridMinVel:       0
        property int    dfaCalGridMinVelDev:    0
        property int    dfaCalGridMinVelDevp:   0
        property int    dfaCalGridMinVelHigh:   0
        property int    dfaCalGridMinVelLow:    0

        property int    dfaCalGridMinVelImp:       0
        property int    dfaCalGridMinVelDevImp:    0
        property int    dfaCalGridMinVelDevpImp:   0
        property int    dfaCalGridMinVelHighImp:   0
        property int    dfaCalGridMinVelLowImp:    0

        property string dfaCalGridMax:          "[]"
        property int    dfaCalGridMaxVel:       0
        property int    dfaCalGridMaxVelDev:    0
        property int    dfaCalGridMaxVelDevp:   0
        property int    dfaCalGridMaxVelHigh:   0
        property int    dfaCalGridMaxVelLow:    0

        property int    dfaCalGridMaxVelImp:       0
        property int    dfaCalGridMaxVelDevImp:    0
        property int    dfaCalGridMaxVelDevpImp:   0
        property int    dfaCalGridMaxVelHighImp:   0
        property int    dfaCalGridMaxVelLowImp:    0

        Component.onCompleted: {
            /// Nominal
            jsonStringify.s2j('loaderDfaNomGrid', dfaCalGridNom)

            let dfaCalGridNomVel
            if(MachineData.measurementUnit)
                dfaCalGridNomVel = utils.strfVelocityByUnit(MachineData.measurementUnit, settings.dfaCalGridNomVelImp / 100)
            else
                dfaCalGridNomVel = utils.strfVelocityByUnit(MachineData.measurementUnit, settings.dfaCalGridNomVel / 100)

            velocityTextAppNom.valueStrf = dfaCalGridNomVel

            let dfaCalGridNomVelDev
            if(MachineData.measurementUnit)
                dfaCalGridNomVelDev = utils.strfVelocityByUnit(MachineData.measurementUnit, settings.dfaCalGridNomVelDevImp / 100)
            else
                dfaCalGridNomVelDev = utils.strfVelocityByUnit(MachineData.measurementUnit, settings.dfaCalGridNomVelDev / 100)

            let dfaCalGridNomVelDevp = (settings.dfaCalGridNomVelDevp / 100).toFixed(2) + "%"
            deviationTextAppNom.valueStrf = dfaCalGridNomVelDev + " (" + dfaCalGridNomVelDevp + ")"

            /// Minimum
            jsonStringify.s2j('loaderDfaMinGrid', dfaCalGridMin)

            let dfaCalGridMinVel
            if(MachineData.measurementUnit)
                dfaCalGridMinVel = utils.strfVelocityByUnit(MachineData.measurementUnit, settings.dfaCalGridMinVelImp / 100)
            else
                dfaCalGridMinVel = utils.strfVelocityByUnit(MachineData.measurementUnit, settings.dfaCalGridMinVel / 100)

            velocityTextAppMin.valueStrf = dfaCalGridMinVel

            let dfaCalGridMinVelDev
            if(MachineData.measurementUnit)
                dfaCalGridMinVelDev = utils.strfVelocityByUnit(MachineData.measurementUnit, settings.dfaCalGridMinVelDevImp / 100)
            else
                dfaCalGridMinVelDev = utils.strfVelocityByUnit(MachineData.measurementUnit, settings.dfaCalGridMinVelDev / 100)

            let dfaCalGridMinVelDevp = (settings.dfaCalGridMinVelDevp / 100).toFixed(2) + "%"
            deviationTextAppMin.valueStrf = dfaCalGridMinVelDev + " (" + dfaCalGridMinVelDevp + ")"

            /// Maximum
            jsonStringify.s2j('loaderDfaMaxGrid', dfaCalGridMax)

            let dfaCalGridMaxVel
            if(MachineData.measurementUnit)
                dfaCalGridMaxVel = utils.strfVelocityByUnit(MachineData.measurementUnit, settings.dfaCalGridMaxVelImp / 100)
            else
                dfaCalGridMaxVel = utils.strfVelocityByUnit(MachineData.measurementUnit, settings.dfaCalGridMaxVel / 100)

            velocityTextAppMax.valueStrf = dfaCalGridMaxVel

            let dfaCalGridMaxVelDev
            if(MachineData.measurementUnit)
                dfaCalGridMaxVelDev = utils.strfVelocityByUnit(MachineData.measurementUnit, settings.dfaCalGridMaxVelDevImp / 100)
            else
                dfaCalGridMaxVelDev = utils.strfVelocityByUnit(MachineData.measurementUnit, settings.dfaCalGridMaxVelDev / 100)

            let dfaCalGridMaxVelDevp = (settings.dfaCalGridMaxVelDevp / 100).toFixed(2) + "%"
            deviationTextAppMax.valueStrf = dfaCalGridMaxVelDev + " (" + dfaCalGridMaxVelDevp + ")"
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
