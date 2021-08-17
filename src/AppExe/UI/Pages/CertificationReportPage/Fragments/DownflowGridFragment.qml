import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import Qt.labs.settings 1.1
import UI.CusCom 1.0
import ModulesCpp.Machine 1.0

import "../Components" as LocalComp

Item {

    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.minimumHeight: 50
            Layout.fillHeight: false
            Layout.fillWidth: true

            TextApp {
                text: qsTr("Downflow")
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }

            Row {
                spacing: 10
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                TextApp {
                    id: velocityTextApp
                    text: qsTr("Average") + ": "+ valueStrf

                    property string valueStrf: "0.32 m/s"
                }//

                TextApp {
                    text: "-"
                }

                TextApp {
                    id: deviationTextApp
                    text: qsTr("Max Deviation") + ": "+ valueStrf

                    property string valueStrf: "0.04 m/s (12.5%)"
                }//
            }//
        }//

        Item {
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

        Component.onCompleted: {
            jsonStringify.s2j('loaderDfaNomGrid', dfaCalGridNom)

            let dfaCalGridNomVel
            if(MachineData.measurementUnit)
                dfaCalGridNomVel = utils.strfVelocityByUnit(MachineData.measurementUnit, settings.dfaCalGridNomVelImp / 100)
            else
                dfaCalGridNomVel = utils.strfVelocityByUnit(MachineData.measurementUnit, settings.dfaCalGridNomVel / 100)

            velocityTextApp.valueStrf = dfaCalGridNomVel

            let dfaCalGridNomVelDev
            if(MachineData.measurementUnit)
                dfaCalGridNomVelDev = utils.strfVelocityByUnit(MachineData.measurementUnit, settings.dfaCalGridNomVelDevImp / 100)
            else
                dfaCalGridNomVelDev = utils.strfVelocityByUnit(MachineData.measurementUnit, settings.dfaCalGridNomVelDev / 100)

            let dfaCalGridNomVelDevp = (settings.dfaCalGridNomVelDevp / 100).toFixed(2) + "%"
            deviationTextApp.valueStrf = dfaCalGridNomVelDev + " (" + dfaCalGridNomVelDevp + ")"
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
