import QtQuick 2.0
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

    property alias title: titleText.text
    property alias text: messageText.text

    signal accepted()
    signal rejected()

    Rectangle {
        anchors.fill: parent
        color: "#6E6D6D"
        radius: 5
    }

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
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 20
                color: "white"
                font.bold: true
                text: "Title"
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 5
                anchors.rightMargin: 5

                Item {
                    Layout.fillHeight: true
                    Layout.minimumWidth: 120
                    visible: root.visibleFeatureImage

                    Image {
                        anchors.centerIn: parent
                        source: dialogType ? "./FeatureWarning" : "./FeaturedInfo"
                    }
                }

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Text {
                        id: messageText
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        //                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        font.pixelSize: 20
                        color: "white"
                        textFormat: Text.RichText
                        text: qsTr("Text")
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
                color: "white"
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
                        color: "white"
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
                        color: "white"
                        text: "OK"
                    }//
                }//
            }//
        }//
    }//
}
