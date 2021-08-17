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
                            text: qsTr("DIM Method")
                            font.bold: true
                        }//

                        TextApp {
                            text: qsTr("Duty cycle") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0%"

                            Component.onCompleted: {
                                valueStrf = settings.ifaCalGridNomDcyFil + "%"
                            }//
                        }//

                        TextApp {
                            text: qsTr("Total") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVol = MachineData.measurementUnit ? "cfm" : "l/s"
                                valueStrf = (MachineData.measurementUnit ? settings.ifaCalGridNomTotFilImp : settings.ifaCalGridNomTotFil) + " " + meaVol
                            }//
                        }//

                        TextApp {
                            text: qsTr("Average") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVol = MachineData.measurementUnit ? "cfm" : "l/s"
                                valueStrf = (MachineData.measurementUnit ? settings.ifaCalGridNomAvgFilImp : settings.ifaCalGridNomAvgFil) + " " + meaVol

                            }//
                        }//

                        TextApp {
                            text: qsTr("Velocity") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {

                                const meaVel = MachineData.measurementUnit ? "fpm" : "m/s"
                                let vel = (MachineData.measurementUnit ? settings.ifaCalGridNomVelFilImp : settings.ifaCalGridNomVelFil)
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
                        visibleHorizontalScroll: true
                        visibleVerticalScroll: true
                    }//

                    Loader {
                        active: props.gridCountDim == 0
                        anchors.centerIn: parent
                        sourceComponent: TextApp {
                            text: qsTr("NA")
                            font.pixelSize: 32
                            //                        visible: settings.ifaCalGridNomFil.length < 10
                        }//
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
                            text: qsTr("Secondary Method")
                            font.bold: true
                        }//

                        TextApp {
                            //                            text: fieldOrFull ? qsTr("Duty cycle") + ": " + "<b>" + valueStrf + "</b>" : ""
                            text: qsTr("Duty cycle") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0%"

                            Component.onCompleted: {
                                valueStrf = settings.ifaCalGridNomDcySecFil + "%"
                            }//
                        }//

                        TextApp {
                            text: qsTr("Total") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVel = MachineData.measurementUnit ?  "fpm" : "m/s"
                                let vel = (MachineData.measurementUnit ? settings.ifaCalGridNomTotSecFilImp : settings.ifaCalGridNomTotSecFil)
                                if(MachineData.measurementUnit) vel = (vel/100).toFixed()
                                else vel = (vel/100).toFixed(2)
                                valueStrf = vel + " " + meaVel
                            }//
                        }//

                        TextApp {
                            text: qsTr("Average") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVel = MachineData.measurementUnit ?  "fpm" : "m/s"
                                let vel = (MachineData.measurementUnit ? settings.ifaCalGridNomAvgSecFilImp : settings.ifaCalGridNomAvgSecFil)
                                if(MachineData.measurementUnit) vel = (vel/100).toFixed()
                                else vel = (vel/100).toFixed(2)
                                valueStrf = vel + " " + meaVel
                            }//
                        }//

                        TextApp {
                            text: qsTr("Velocity") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVel = MachineData.measurementUnit ?  "fpm" : "m/s"
                                let vel = (MachineData.measurementUnit ? settings.ifaCalGridNomVelSecFilImp : settings.ifaCalGridNomVelSecFil)
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
                        id: loaderIfaNomSecGrid
                        anchors.fill: parent
                        visibleHorizontalScroll: true
                        visibleVerticalScroll: true
                    }//

                    Loader {
                        active: props.gridCountSec == 0
                        anchors.centerIn: parent
                        sourceComponent:TextApp {
                            anchors.centerIn: parent
                            text: qsTr("NA")
                            font.pixelSize: 32
                            //                        visible: settings.ifaCalGridNomSecFil.length < 10 //make the setting overiten, don't do this
                        }//
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
                props.gridCountDim = grid.length
                console.log("gridCountDim: " + props.gridCountDim)
                loaderIfaNomGrid.loader.setSource("../Components/AirflowGrid.qml",
                                                  {
                                                      "measureUnit": MachineData.measurementUnit,
                                                      "columns": 5,
                                                      "model": grid,
                                                      "valueMinimum": 0,
                                                      "valueMaximum": 1000,
                                                  })
                //                console.log("Nominal grid")
                jsonStringify.s2j('loaderIfaNomSecGrid', settings.ifaCalGridNomSecFil)
            }
            else if(messageObject.id === "loaderIfaNomSecGrid"){
                const grid = messageObject.data || [{}]
                //                console.log("grid-length:" + grid.length)
                //                console.log("grid:" + grid)
                props.gridCountSec = grid.length
                console.log("gridCountSec: " + props.gridCountSec)
                loaderIfaNomSecGrid.loader.setSource("../Components/AirflowGrid.qml",
                                                     {
                                                         "measureUnit": MachineData.measurementUnit,
                                                         "columns": props.gridCountSec,
                                                         "model": grid,
                                                         "valueMinimum": 0,
                                                         "valueMaximum": 1000,
                                                     })
                //                console.log("Minimum grid")
            }//
        }//
    }//

    QtObject {
        id: props

        property int gridCountDim: 0
        property int gridCountSec: 0
    }//

    Settings {
        id: settings

        property string ifaCalGridNomFil:   "[]"
        property int    ifaCalGridNomTotFil: 0
        property int    ifaCalGridNomAvgFil: 0
        property int    ifaCalGridNomVolFil: 0
        property int    ifaCalGridNomVelFil: 0
        property int    ifaCalGridNomTotFilImp: 0
        property int    ifaCalGridNomAvgFilImp: 0
        property int    ifaCalGridNomVolFilImp: 0
        property int    ifaCalGridNomVelFilImp: 0
        property int    ifaCalGridNomDcyFil: 0

        property string ifaCalGridNomSecFil:   "[]"
        property int    ifaCalGridNomTotSecFil: 0
        property int    ifaCalGridNomAvgSecFil: 0
        property int    ifaCalGridNomVelSecFil: 0
        property int    ifaCalGridNomTotSecFilImp: 0
        property int    ifaCalGridNomAvgSecFilImp: 0
        property int    ifaCalGridNomVelSecFilImp: 0
        property int    ifaCalGridNomDcySecFil: 0

        Component.onCompleted: {
            //            const jdata = {"hello": "hello", "world": "world"}
            //            jsonStringify.s2j('loaderIfaStbGrid', ifaCalGridStb)

            jsonStringify.s2j('loaderIfaNomGrid', ifaCalGridNomFil)
            //            jsonStringify.s2j('loaderIfaNomSecGrid', ifaCalGridNomSecFil)
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
