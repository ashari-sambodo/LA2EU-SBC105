import QtQuick 2.0
import QtQuick.Layouts 1.0

RowLayout {
    //    anchors.fill: parent
    //    spacing: 5

    Item {
        Layout.fillHeight: true
        Layout.minimumWidth: 300

        Item {
            anchors.fill: parent

            Rectangle {
                anchors.fill: parent
                color: "#770F2952"
                radius: 5
                border.width: 1
                border.color: "gray"
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 1
                spacing: 1

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Image {
                        id: logoImage
                        anchors.fill: parent
                        anchors.margins: 5
                        fillMode: Image.PreserveAspectFit
                        source: "HeaderApp/Logo.png"
                    }//
                }//

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Text {
                        id: deviceModelText
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: "#ffffff"
                        font.pixelSize: 20
                        text: "Class II" + "<br>" + "LA2-EU"
                    }//
                }//
            }//
        }//
    }//

    Item {
        Layout.fillHeight: true
        Layout.fillWidth: true

        Rectangle {
            id: topBarStatusRectangle
            anchors.fill: parent
            radius: 5
            color: "#770F2952"
            //                            color: "red"
            border.color: "gray"
            border.width: 1

            Text {
                id: topBarStatusText
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#ffffff"
                font.pixelSize: 20
                text: "Title"
                //                                text: "WARNING: AIRFLOW IS FAIL"
            }//
        }//
    }//

    Item {
        Layout.fillHeight: true
        Layout.minimumWidth: 100

        Rectangle {
            id: topBarClockRectangle
            anchors.fill: parent
            radius: 5
            color: "#770F2952"
            //                            color: "red"
            border.color: "gray"
            border.width: 1

            Text {
                id: topBarClockText
                anchors.fill: parent
                anchors.margins: 5
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#ffffff"
                font.pixelSize: 20
                fontSizeMode: Text.Fit
                text: "12:00 PM <br> 04/06/20"
                //                                text: "WARNING: AIRFLOW IS FAIL"
            }//

            ///////////////Timer for update current clock and date
            Timer{
                id: timeDateTimer
                running: true
                interval: 10000
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    var datetime = new Date();
                    //            dateText.text = Qt.formatDateTime(datetime, "dddd\nMMM dd yyyy")
                    let date = Qt.formatDateTime(datetime, "MMM dd yyyy")

                    let timeFormatStr = "h:mm AP"
                    //                        if(m_data.timeFormat) timeFormatStr = "hh:mm AP"

                    let clock = Qt.formatDateTime(datetime, timeFormatStr)

                    topBarClockText.text = date + "<br>" + clock
                }
            }

        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:60;width:800}
}
##^##*/
