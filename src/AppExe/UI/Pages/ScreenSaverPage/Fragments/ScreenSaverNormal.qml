import QtQuick 2.0
import QtQuick.Layouts 1.0

import UI.CusCom 1.1
import ModulesCpp.Machine 1.0

Item {

    //    Rectangle {
    //        anchors.fill: parent
    //        color: "black"
    //    }

    Rectangle {
        id: backgroundHorizontalRect
        y: (parent.height - height) / 2
        height: parent.height / 5
        width: parent.width
        color: "#008100"

        RowLayout {
            anchors.fill: parent

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true

                Column {
                    anchors.centerIn: parent

                    TextApp {
                        color: "#bbbbbb"
                        //                        text: "Monday, 5 July 2021"
                        text: timeDateStrf

                    }//

                    TextApp {
                        color: "#bbbbbb"
                        //                        text: "1:45 PM"
                        text: timeClockStrf
                    }//
                }//
            }//

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true

                Row {
                    anchors.centerIn: parent

                    Image {
                        source: "qrc:/UI/Pictures/done-green-white.png"
                    }//

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("SAFE")
                        font.pixelSize: 36
                        font.bold: true
                        color: "#e3dac9"
                    }//
                }//
            }//

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true

                Column {
                    anchors.centerIn: parent

                    Row {
                        spacing: 5
                        Column {
                            TextApp {
                                color: "#bbbbbb"
                                text: "IF"

                            }//

                            TextApp {
                                color: "#bbbbbb"
                                text: "DF"
                            }//
                        }//

                        Column {
                            TextApp {
                                color: "#bbbbbb"
                                text: ":"

                            }//

                            TextApp {
                                color: "#bbbbbb"
                                text: ":"
                            }//
                        }//

                        Column {
                            TextApp {
                                color: "#bbbbbb"
                                text: MachineData.ifaVelocityStr
                            }//

                            TextApp {
                                color: "#bbbbbb"
                                text: MachineData.dfaVelocityStr
                            }//
                        }//
                    }//
                }//
            }//
        }//
    }//

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: {
            if (barPosition == 4){
                barPosition = 0
            }
            else {
                barPosition = barPosition + 1
            }
            backgroundHorizontalRect.y = backgroundHorizontalRect.height * barPosition
        }//
    }//

    property int barPosition: -1

    property string timeClockStrf:  ""
    property string timeDateStrf:   ""

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
            let date = Qt.formatDateTime(datetime, "dddd, dd MMM yyyy")

            let timeFormatStr = "h:mm AP"
            if (HeaderAppService.timePeriod === 24) timeFormatStr = "hh:mm"

            let clock = Qt.formatDateTime(datetime, timeFormatStr)

            timeClockStrf = clock
            timeDateStrf = date
        }//
    }//
}//



/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#000000";height:480;width:800}
}
##^##*/
