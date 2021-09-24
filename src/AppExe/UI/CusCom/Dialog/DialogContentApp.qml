/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.6
import QtQuick.Layouts 1.0

Item {
    id: root
    anchors.centerIn: parent
    implicitHeight: 300
    implicitWidth: 500

    property int standardButton: 0
    readonly property int standardButtonClose:      0
    readonly property int standardButtonCancelOK:   1

    property int dialogType: 0
    readonly property int dialogTypeInfo: 0
    readonly property int dialogTypeWarning: 1

    property bool visibleFeatureImage: true
    property string featureSourceImage: ""

    property alias title: titleText.text
    property string text: "Descriptions"

    //    property alias contentMessage: messageText

    property string layoutStyle: "horizontal"

    signal accepted()
    signal rejected()

    Rectangle {
        anchors.fill: parent
        color: "#6E6D6D"
        radius: 5
    }

    visible: false

    scale: visible ? 1.0 : 0.9
    Behavior on scale {
        NumberAnimation { duration: 100}
    }//

    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.minimumHeight: 40
            Layout.fillWidth: true

            Image {
                id: featureImage
                anchors.fill: parent
                source: dialogType ? "./HeaderWarningBackground" : "./HeaderBackground"
            }

            Text {
                id: titleText
                height: parent.height
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 20
                color: "#dddddd"
                font.bold: true
                text: "Title"
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Loader {
                anchors.fill: parent
                anchors.leftMargin: 5
                anchors.rightMargin: 5
                sourceComponent: layoutStyle == "vertical" ? columnStyle : rowStyle
            }

            Component {
                id: rowStyle

                RowLayout {
                    Item {
                        Layout.fillHeight: true
                        Layout.minimumWidth: 120
                        visible: visibleFeatureImage

                        Image {
                            id: featureDescImage
                            anchors.centerIn: parent
                            source: featureSourceImage.length ? featureSourceImage : (dialogType ? "./FeatureWarning" : "")
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Text {
                            id: messageText
                            //                            anchors.fill: parent
                            anchors.centerIn: parent
                            height: parent.height
                            width: Math.min(controlMaxWidthText.paintedWidth, parent.width)
                            verticalAlignment: Text.AlignVCenter
                            //                        horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WordWrap
                            font.pixelSize: 20
                            minimumPixelSize: 14
                            fontSizeMode: Text.Fit
                            color: "#dddddd"
                            //                            textFormat: Text.RichText
                            //                            text: qsTr("Text")
                            text: root.text

                            Text {
                                id: controlMaxWidthText
                                visible: false
                                text: root.text
                                font.pixelSize: 20
                            }//
                        }//
                    }//
                }//
            }//

            Component {
                id: columnStyle

                ColumnLayout {

                    Item {
                        Layout.minimumHeight: 120
                        Layout.fillWidth: true
                        visible: root.visibleFeatureImage

                        Image {
                            anchors.centerIn: parent
                            source: featureSourceImage.length ? featureSourceImage : (dialogType ? "./FeatureWarning" : "./FeaturedInfo")
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Text {
                            id: messageText
                            //                            anchors.fill: parent
                            anchors.centerIn: parent
                            height: parent.height
                            width: Math.min(controlMaxWidthText.paintedWidth, parent.width)
                            verticalAlignment: Text.AlignVCenter
                            //                        horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WordWrap
                            font.pixelSize: 20
                            minimumPixelSize: 14
                            fontSizeMode: Text.Fit
                            color: "#dddddd"
                            padding: 5
                            //                            textFormat: Text.RichText
                            //                            text: qsTr("Text")
                            text: root.text

                            Text {
                                id: controlMaxWidthText
                                visible: false
                                text: root.text
                                font.pixelSize: 20
                            }//
                        }

                        //                        Text {
                        //                            id: messageText
                        //                            anchors.fill: parent
                        //                            verticalAlignment: Text.AlignVCenter
                        //                            horizontalAlignment: Text.AlignHCenter
                        //                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        //                            font.pixelSize: 20
                        //                            color: "#dddddd"
                        //                            textFormat: Text.RichText
                        //                            //                            text: qsTr("Text")
                        //                            text: root.text
                        //                        }
                    }
                }
            }
        }

        Item {
            Layout.minimumHeight: 50
            Layout.fillWidth: true

            Loader {
                anchors.fill: parent
                sourceComponent: standardButton ? cancelOkButtonComponent : closeButtonComponent
            }
        }
    }

    /// Button Option
    Component {
        id: closeButtonComponent

        Item {

            Rectangle {
                anchors.fill: parent
                color: "#888888"
                radius: 5

                MouseArea {
                    id: rejectedMouseArea
                    anchors.fill: parent
                    onClicked: root.rejected()
                }//
            }

            Text {
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 20
                color: "#dddddd"
                text: "Close"
            }
        }
    }//

    Component {
        id: cancelOkButtonComponent

        Item {

            RowLayout {
                anchors.fill: parent
                anchors.margins: 1
                spacing: 1

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Rectangle {
                        anchors.fill: parent
                        color: "#888888"
                        radius: 5
                        opacity: rejectedMouseArea.pressed ? 0.5 : 1

                        MouseArea {
                            id: rejectedMouseArea
                            anchors.fill: parent
                            onClicked: root.rejected()
                        }//
                    }//

                    Text {
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 20
                        color: "#dddddd"
                        text: "Cancel"
                    }//

                }//

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Rectangle {
                        anchors.fill: parent
                        color: "#888888"
                        radius: 5
                        opacity: acceptedMouseArea.pressed ? 0.5 : 1

                        MouseArea {
                            id: acceptedMouseArea
                            anchors.fill: parent
                            onClicked: root.accepted()
                        }//
                    }//

                    Text {
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 20
                        color: "#dddddd"
                        text: "OK"
                    }//
                }//
            }//
        }//
    }//
}
