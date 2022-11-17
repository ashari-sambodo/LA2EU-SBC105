import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "21 CFR Part 11"

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
                    title: qsTr("21 CFR Part 11")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column{
                    anchors.centerIn: parent
                    spacing: 15
                    Column{
                        TextApp{
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("21 CFR Part 11")
                        }
                        TextApp{
                            text: qsTr("(Electronics Records and Signatures)")
                        }
                    }
                    ComboBoxApp {
                        id: comboBox
                        width: 190
                        height: 50
                        backgroundColor: "#0F2952"
                        backgroundBorderColor: "#dddddd"
                        backgroundBorderWidth: 2
                        font.pixelSize: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        textRole: "text"

                        model: [
                            {text: qsTr("Disable"), value: 0},
                            {text: qsTr("Enable"),  value: 1}
                        ]

                        onActivated: {
                            ////console.debug(index)
                            ////console.debug(model[index].value)
                            let newValue = model[index].value
                            if(MachineData.cfr21Part11Enable !== newValue){
                                //props.elsIsEnabled = newValue

                                MachineAPI.setCFR21Part11Enable(newValue)

                                let stringEn = newValue ? qsTr("Enabled") : qsTr("Disabled")
                                const eventStr = qsTr("User: 21 CRF part 11 is %1").arg(stringEn)
                                MachineAPI.insertEventLog("%1".arg(eventStr))

                                viewApp.showBusyPage(qsTr("Setting up..."),
                                                     function onTriggered(cycle){
                                                         if(cycle >= MachineAPI.BUSY_CYCLE_1
                                                                 || Number(MachineData.cfr21Part11Enable) == Number(newValue)){
                                                             comboBox.currentIndex = newValue

                                                             viewApp.dialogObject.close()}
                                                     })//
                            }//
                        }//

                        Component.onCompleted: {
                            currentIndex = MachineData.cfr21Part11Enable
                        }
                    }//
                }
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
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int countDefault: 50
            property int count: 50
        }//

        /// One time executed after onResume
        Component.onCompleted: {

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
            }
        }//
    }//
}//
