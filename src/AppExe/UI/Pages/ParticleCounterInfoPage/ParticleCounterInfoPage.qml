/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Particle Counter Info"

    background.sourceComponent: Item {}
    //    background.sourceComponent: Rectangle {color: "gray"}

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
                    title: qsTr("Particle Counter Info")
                }//
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumWidth: parent.width * 0.3

                        Column {
                            anchors.centerIn: parent
                            spacing: 10

                            TextApp {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("Latest Reading")
                            }//

                            Rectangle {
                                anchors.horizontalCenter: parent.horizontalCenter
                                height: 120
                                width: parent.width
                                radius: 20
                                border.width: 5
                                border.color: "#130f40"
                                color: "#aa0F2952"

                                Column {
                                    anchors.centerIn: parent

                                    TextApp {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "PM2.5"
                                    }//

                                    TextApp {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        font.pixelSize: 32
                                        text: props.particleCounterPM2_5
                                    }//



                                    TextApp {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "μg/m3"
                                    }//
                                }//
                            }//

                            Row {
                                spacing: 5

                                Rectangle {
                                    height: 120
                                    width: 110
                                    radius: 20
                                    border.width: 5
                                    border.color: "#130f40"
                                    color: "#aa0F2952"

                                    Column {
                                        anchors.centerIn: parent
                                        TextApp {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: "PM1.0"
                                        }//

                                        TextApp {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            font.pixelSize: 32
                                            text: props.particleCounterPM1_0
                                        }//

                                        TextApp {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: "μg/m3"
                                        }//
                                    }//
                                }//

                                Rectangle {
                                    height: 120
                                    width: 110
                                    radius: 20
                                    border.width: 5
                                    border.color: "#130f40"
                                    color: "#aa0F2952"

                                    Column {
                                        anchors.centerIn: parent

                                        TextApp {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: "PM10"
                                        }//

                                        TextApp {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            font.pixelSize: 32
                                            text: props.particleCounterPM10
                                        }//


                                        TextApp {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: "μg/m3"
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        ColumnLayout {
                            anchors.fill: parent

                            ListView {
                                id: indicatorListview
                                Layout.fillWidth: true
                                Layout.minimumHeight: 50
                                orientation: ListView.Horizontal
                                spacing: 5
                                clip: true

                                highlightRangeMode: ListView.ApplyRange

                                model: [
                                    {"color": "#18AA00",
                                        "lable":    qsTr("PM2.5<br>0 to 12.0"),
                                        "aqi":      qsTr("Good 0 to 50"),
                                        "phe":      qsTr("Little to no risk."),
                                        "preac":    qsTr("None.")
                                    },
                                    {"color": "#f39c12",
                                        "lable": qsTr("PM2.5<br>12.1 to 35.4"),
                                        "aqi":      qsTr("Moderate 51 to 100"),
                                        "phe":      qsTr("Unusually sensitive individuals may experience respiratory symptoms."),
                                        "preac":    qsTr("Unusually sensitive people should consider reducing prolonged or heavy exertion.")
                                    },
                                    {"color": "#d35400",
                                        "lable": qsTr("PM2.5<br>35.5 to 55.4"),
                                        "aqi":      qsTr("Unhealthy for Sensitive Groups 101 to 150"),
                                        "phe":      qsTr("Increasing likelihood of respiratory symptoms in sensitive individuals, aggravation of heart or lung disease and premature mortality in persons with cardiopulmonary disease and the elderly."),
                                        "preac":    qsTr("People with respiratory or heart disease, the elderly and children should limit prolonged exertion.")
                                    },
                                    {"color": "#c0392b",
                                        "lable": qsTr("PM2.5<br>55.5 to 150.4"),
                                        "aqi":      qsTr("Unhealthy 151 to 200"),
                                        "phe":      qsTr("Increased aggravation of heart or lung disease and premature mortality in persons with cardiopulmonary disease and the elderly; increased respiratory effects in general population."),
                                        "preac":    qsTr("People with respiratory or heart disease, the elderly and children should avoid prolonged exertion; everyone else should limit prolonged exertion.")
                                    },
                                    {"color": "#A10649",
                                        "lable": qsTr("PM2.5<br>150.5 to 250.4"),
                                        "aqi":      qsTr("Very Unhealthy 201 to 3000"),
                                        "phe":      qsTr("Significant aggravation of heart or lung disease and premature mortality in persons with cardiopulmonary disease and the elderly; significant increase in respiratory effects in general population."),
                                        "preac":    qsTr("People with respiratory or heart disease, the elderly and children should avoid any outdoor activity; everyone else should avoid prolonged exertion.")
                                    },
                                    {"color": "#7E0023",
                                        "lable": qsTr("PM2.5<br>250.5 to 500.4"),
                                        "aqi":      qsTr("Hazardous 500"),
                                        "phe":      qsTr("Serious aggravation of heart or lung disease and premature mortality in persons with cardiopulmonary disease and the elderly; serious risk of respiratory effects in general population."),
                                        "preac":    qsTr("Everyone should avoid any outdoor exertion; people with respiratory or heart disease, the elderly and children should remain indoors.")
                                    }
                                ]//

                                delegate: Rectangle {
                                    width: 150
                                    height: parent.height
                                    color: modelData.color
                                    radius: 5

                                    TextApp {
                                        anchors.fill: parent
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        text: modelData.lable
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            indicatorListview.currentIndex = index
                                        }//
                                    }//
                                }//
                            }//

                            ColumnLayout {
                                id: descColumnLayout
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                Layout.margins: 5

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 1

                                    TextApp {
                                        text: qsTr("Air Quality Index")
                                        Layout.fillHeight: false
                                        font.bold: true
                                    }

                                    TextApp {
                                        Layout.alignment: Qt.AlignTop
                                        wrapMode: Text.WordWrap
                                        Layout.fillWidth: true
                                        text: indicatorListview.model[indicatorListview.currentIndex]["aqi"]
                                    }
                                }

                                Rectangle {
                                    Layout.minimumWidth: 200
                                    Layout.minimumHeight: 1
                                    color: "#e3dac9"
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 1

                                    TextApp {
                                        text: qsTr("PM2.5 Health Effects")
                                        Layout.fillHeight: false
                                        font.bold: true
                                    }

                                    TextApp {
                                        Layout.alignment: Qt.AlignTop
                                        wrapMode: Text.WordWrap
                                        Layout.fillWidth: true
                                        text: indicatorListview.model[indicatorListview.currentIndex]["phe"]
                                    }
                                }

                                Rectangle {
                                    Layout.minimumWidth: 200
                                    Layout.minimumHeight: 1
                                    color: "#e3dac9"
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 1

                                    TextApp {
                                        text: qsTr("Precautionary Actions")
                                        Layout.fillHeight: false
                                        font.bold: true
                                    }

                                    TextApp {
                                        Layout.alignment: Qt.AlignTop
                                        wrapMode: Text.WordWrap
                                        Layout.fillWidth: true
                                        text: indicatorListview.model[indicatorListview.currentIndex]["preac"]
                                    }
                                }

                                Item {
                                    Layout.fillHeight: true
                                    /// This item just for making the layout align to top
                                    /// This component will fill up the empty space
                                }
                            }
                        }//

                        Rectangle {
                            height: descColumnLayout.height + 10 /// add 5 from margin
                            width: descColumnLayout.width + 10
                            x: descColumnLayout.x - 5
                            y: descColumnLayout.y - 5
                            z: descColumnLayout.z - 1
                            color: indicatorListview.model[indicatorListview.currentIndex]["color"]
                            opacity: 0.8
                            radius: 5
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
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }
                        }//

                        Column {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter

                            TextApp {
                                text: qsTr("Table of 24-Hour PM2.5 Levels (μg/m3)")
                            }

                            TextApp {
                                text: qsTr("Source: U.S. Environmental Protection Agency")
                                font.italic: true
                                color: "gray"
                            }
                        }
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int particleCounterPM2_5:  0
            property int particleCounterPM1_0:  0
            property int particleCounterPM10:   0
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

                props.particleCounterPM2_5 = Qt.binding(function(){return MachineData.particleCounterPM2_5})
                props.particleCounterPM1_0 = Qt.binding(function(){return MachineData.particleCounterPM1_0})
                props.particleCounterPM10 = Qt.binding(function(){return MachineData.particleCounterPM10})
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/
