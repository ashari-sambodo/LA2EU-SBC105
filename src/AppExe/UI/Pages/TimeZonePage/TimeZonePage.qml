import QtQuick 2.4
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Time Zone"

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
                    title: qsTr("Time Zone")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout{
                    anchors.fill:parent
                    spacing:5

                    Item{
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Column{
                            id: leftContentColumn
                            anchors.centerIn: parent

                            TextApp{
                                text: qsTr("Current Time Zone") + ":"
                            }

                            TextApp{
                                id: currentTimeZoneText
                                font.pixelSize: 36
                                wrapMode: Text.WordWrap
                                text: "UTC"

                                width: Math.min(controlMaxWidthText.width, leftContentColumn.parent.width)

                                Text {
                                    visible: false
                                    id: controlMaxWidthText
                                    text: currentTimeZoneText.text
                                    font.pixelSize: 36
                                }//
                            }//
                        }//
                    }//

                    Rectangle{
                        Layout.fillHeight: true
                        Layout.minimumWidth: 1
                        color:"#e3dac9"
                    }

                    Item{
                        id: listTimeZoneItem
                        Layout.fillHeight: true
                        Layout.fillWidth: true


                        StackView {
                            id: stackView
                            anchors.fill: parent
                            clip: true
                            initialItem: timeZoneListComponent
                            //                            initialItem: ListView {
                            //                                anchors.fill: parent
                            //                                model: 20
                            //                                delegate: ItemDelegate {
                            //                                    text: modelData
                            //                                    onClicked: //console.debug("Hello")
                            //                                }
                            //                            }
                        }//

                        Component {
                            id: timeZoneListComponent

                            ColumnLayout {
                                spacing: 5

                                property alias title: itemListHeaderText.text
                                property alias model: itemListView.model

                                Rectangle{
                                    Layout.minimumHeight: 50
                                    Layout.fillWidth: true
                                    color: "#1F95D7"
                                    radius: 2

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 2

                                        Item {
                                            Layout.fillHeight: true
                                            Layout.minimumWidth: height
                                            visible: stackView.depth > 1

                                            Image {
                                                anchors.fill: parent
                                                fillMode: Image.PreserveAspectFit
                                                source: "qrc:/UI/Pictures/back-step.png"
                                            }//

                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                    stackView.pop()
                                                }//
                                            }//
                                        }//

                                        Item {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true

                                            TextApp {
                                                id: itemListHeaderText
                                                height: parent.height
                                                width: parent.width
                                                verticalAlignment: Text.AlignVCenter
                                                text: qsTr("Choose time zone") + ":"
                                                elide: Text.ElideMiddle
                                            }//
                                        }//
                                    }//
                                }//

                                ListView {
                                    id: itemListView
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    spacing: 2
                                    clip: true

                                    model: timeZoneModel.timeZone /*5*/

                                    delegate: ItemDelegate{
                                        id: listItem
                                        height: 40
                                        width: itemListView.width

                                        text: modelData.text !== undefined ? modelData.text : modelData
                                        font.pixelSize: 20

                                        background: Rectangle {
                                            anchors.fill: parent
                                            color: listItem.pressed ? "#436397" : "#0F2952"
                                            radius: 2
                                        }

                                        contentItem: Text {
                                            text: listItem.text
                                            font: listItem.font
                                            color: "#e3dac9"
                                            elide: Text.ElideMiddle
                                            verticalAlignment: Text.AlignVCenter
                                        }

                                        onClicked: {
                                            if(modelData.utc === undefined) {
                                                props.selectedLocation = modelData
                                                props.saveTimeZone()
                                            }
                                            else {
                                                props.selecetedOffset = modelData.offset
                                                props.selectedZone = modelData.text

                                                let utc = modelData.utc
                                                stackView.push(timeZoneListComponent, {"model": utc, "title": modelData.text})
                                            }//
                                        }//
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
                                //                                currentTimeZoneText.text = currentTimeZoneText.text + "AAAA-"
                                var intent = IntentApp.create(uri, {})
                                finishView(intent)
                            }//
                        }//

                        ButtonBarApp {
                            id: setButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
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
            }
        }//

        TimeZone {
            id: timeZoneModel
        }

        //// Put all private property inside here
        //// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property string selectedZone: ""
            property int    selecetedOffset: 0
            property string selectedLocation: "UTC"

            function saveTimeZone(){
                //            //console.debug(contentView.selectedZone)
                //            //console.debug(contentView.selecetedOffset)
                //            //console.debug(contentView.selectedUtc)

                /// show bussy page
                viewApp.showBusyPage(qsTr("Setting up..."),
                                     function onCycle(cycle){
                                         if (cycle === MachineAPI.BUSY_CYCLE_1) {
                                             viewApp.dialogObject.close()
                                         }//
                                     })

                /// (UTC-09:00) Alaska -> UTC-09:00
                let offsetStr = String(selectedZone.split(")")[0]).replace("(", "")
                //                //console.debug(offsetStr)

                /// Tell to machine
                let tz = selectedLocation + "#" + selecetedOffset + "#" + offsetStr
                MachineAPI.setTimeZone(tz);

                ///update View
                currentTimeZoneText.text = offsetStr + "\n" + selectedLocation
            }//
        }//

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

                /// example: Asia/Jakarta#7#UTC+07:00
                let tz = MachineData.timeZone.split("#")
                //                    //console.debug(tz)
                if (tz.length === 3) {
                    currentTimeZoneText.text = tz[2] + "\n" + tz[0]
                }

                const extraData = IntentApp.getExtraData(intent)
                const thisOpenedFromWelcomePage = extraData["walcomesetup"] || false
                if(thisOpenedFromWelcomePage) {
                    setButton.visible = true
                }
            }//

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}



/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
