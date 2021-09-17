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
    title: "Certification Report"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        x: 0
        y: 0
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
                    title: qsTr("Certification Report")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                GridView{
                    id: menuGridView
                    //                        anchors.fill: parent
                    anchors.centerIn: parent
                    /// If model lest than 4, make it centerIn of parent
                    width: count < 4 ? (count * (parent.width / 4)) : parent.width
                    height: count < 4 ? parent.height / 2 : parent.height
                    cellWidth: parent.width / 4
                    cellHeight: count < 4 ? height : height / 2
                    clip: true
                    snapMode: GridView.SnapToRow
                    flickableDirection: GridView.AutoFlickIfNeeded

                    //                        model: props.menuModel

                    //                        StackView.onStatusChanged: {
                    //                            if(StackView.status == StackView.Activating){
                    //                                model = props.menuModel
                    //                            }
                    //                        }

                    delegate: Item{
                        height: menuGridView.cellHeight
                        width: menuGridView.cellWidth
                        opacity:  iconMouseArea.pressed ? 0.5 : 1

                        ColumnLayout{
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 0

                            //                            Rectangle {
                            //                                anchors.fill: parent
                            //                            }

                            Item {
                                id: picIconItem
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                //                Rectangle{anchors.fill: parent}

                                Image {
                                    id: picIconImage
                                    source: modelData.micon ? modelData.micon : ""
                                    fillMode: Image.PreserveAspectFit
                                    anchors.fill: parent
                                }
                            }//

                            Item {
                                id: iconTextItem
                                Layout.minimumHeight: parent.height* 0.35
                                Layout.fillWidth: true

                                //                Rectangle{anchors.fill: parent}

                                Text {
                                    id: iconText
                                    text: modelData.mtitle ? modelData.mtitle : ""
                                    height: parent.height
                                    width: parent.width
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignTop
                                    color: "#dddddd"
                                    font.pixelSize: 20
                                }//
                            }//
                        }//

                        MouseArea{
                            id: iconMouseArea
                            anchors.fill: parent
                            onClicked: {
                                const intent = IntentApp.create(modelData.mlink,
                                                                {
                                                                    "fieldOrFull": modelData.fieldOrFull
                                                                })
                                finishView(intent)
                            }//
                        }//
                    }//

                    /// false = field calibration
                    /// true = factory calibration
                    model: [
                        {mtype         : "menu",
                            mtitle     : qsTr("Field Certification Summary"),
                            micon      : "qrc:/UI/Pictures/menu/cert_report_icon_field.png",
                            mlink      : "qrc:/UI/Pages/CertificationReportPage/CertificationReportPage.qml",
                            fieldOrFull: false,
                        },
                        {mtype         : "menu",
                            mtitle     : qsTr("Full Certification Summary"),
                            micon      : "qrc:/UI/Pictures/menu/cert_report_icon_full.png",
                            mlink      : "qrc:/UI/Pages/CertificationReportPage/CertificationReportPage.qml",
                            fieldOrFull: true,
                        }
                    ]//
                }//


                //                RowLayout {
                //                    anchors.fill: parent

                //                    Item {
                //                        Layout.fillHeight: true
                //                        Layout.fillWidth: true

                //                        Row {
                //                            anchors.centerIn: parent
                //                            spacing: 100

                //                            Column {
                //                                spacing: 0

                //                                Rectangle {
                //                                    width: 150
                //                                    height: 150
                //                                    color: "transparent"

                //                                    Image {
                //                                        id: tourImage
                //                                        anchors.fill: parent
                //                                        source: "qrc:/UI/Pictures/menu/Field-Calibration.png"
                //                                        fillMode: Image.PreserveAspectFit
                //                                    }//

                //                                    MouseArea {
                //                                        anchors.fill: parent

                //                                        onClicked: {
                //                                            const intent = IntentApp.create("qrc:/UI/Pages/CertificationReportPage/CertificationReportPage.qml",
                //                                                                            {
                //                                                                                "fieldCal": false
                //                                                                            })
                //                                            finishView(intent)
                //                                        }//
                //                                    }//
                //                                }//

                //                                TextApp {
                //                                    anchors.horizontalCenter: parent.horizontalCenter
                //                                    text: "Field Calibration Cert."
                //                                    //                                    font.pixelSize: 30
                //                                    //                                    font.bold: true
                //                                }//
                //                            }//

                //                            Column {
                //                                spacing: 0

                //                                Rectangle {
                //                                    width: 150
                //                                    height: 150
                //                                    color: "transparent"

                //                                    Image {
                //                                        id: diagnosImage
                //                                        anchors.fill: parent
                //                                        source: "qrc:/UI/Pictures/menu/Calibrate-Downflow-sensor.png"
                //                                        fillMode: Image.PreserveAspectFit
                //                                    }//

                //                                    MouseArea {
                //                                        anchors.fill: parent

                //                                        onClicked: {
                //                                            const intent = IntentApp.create("qrc:/UI/Pages/CertificationReportPage/CertificationReportPage.qml", {

                //                                                                                "fieldCal": true
                //                                                                            })
                //                                            finishView(intent)
                //                                        }//
                //                                    }//
                //                                }//

                //                                TextApp {
                //                                    anchors.horizontalCenter: parent.horizontalCenter
                //                                    text: "Full Calibraion Cert."
                //                                    //                                    font.pixelSize: 30
                //                                    //                                    font.bold: true
                //                                }//
                //                            }//
                //                        }//
                //                    }//
                //                }//
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

