import QtQuick 2.4
import QtQuick.Controls 2.0

Item {
    id: control
    height: 200
    width: 200

    property int seconds: 0

    function init(value){
        if(value < 0) return

        let hour = Math.floor(value / 3600)
        let min = Math.floor((value / 60) % 60)
        let sec = value % 60

        hoursTumbler.currentIndex = hour
        minutesTumbler.currentIndex = min
        secondTumbler.currentIndex = sec

        seconds = value
    }

    Item {
        id: privateControls
        anchors.fill: parent

        function formatText(count, modelData) {
            var data = count === 12 ? modelData + 1 : modelData;
            return data.toString().length < 2 ? "0" + data : data;
        }//

        function combineTimeToSeconds(hours, minutes, seconds){
            return (hours * 3600) + (minutes * 60) + seconds
        }

        FontMetrics {
            id: fontMetrics
            font.pixelSize: 20
        }//

        Component {
            id: delegateComponent

            Label {
                text: privateControls.formatText(Tumbler.tumbler.count, modelData)
                opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: fontMetrics.font.pixelSize * 1.25
                font.bold: Tumbler.tumbler.currentIndex == index
                color: "#e3dac9"
            }//
        }//

        Frame {
            id: frame
            padding: 10
            anchors.centerIn: parent

            background: Rectangle {
                color: "#0F2952"
                radius: 5
                border.color: "#e3dac9"
            }//

            property bool movingStopped: !hoursTumbler.moving
                                         && !minutesTumbler.moving
                                         && !secondTumbler.moving
            onMovingStoppedChanged: {
                //                                    //console.debug("Let's generate the timer")
                let count = privateControls.combineTimeToSeconds(hoursTumbler.currentIndex,
                                                                 minutesTumbler.currentIndex,
                                                                 secondTumbler.currentIndex)
                control.seconds = count
            }
            Column{
                id: column
                spacing: 5
                TextApp {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: fontMetrics.font.pixelSize
                    text: qsTr("HH:MM:SS")
                }
                Row {
                    id: row
                    Tumbler {
                        id: hoursTumbler
                        model: 24
                        delegate: delegateComponent
                        width: 100
                    }//

                    TextApp {
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: fontMetrics.font.pixelSize
                        text: ":"
                    }

                    Tumbler {
                        id: minutesTumbler
                        model: 60
                        delegate: delegateComponent
                        width: 100
                    }//

                    TextApp {
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: fontMetrics.font.pixelSize
                        text: ":"
                    }//

                    Tumbler {
                        id: secondTumbler
                        model: 60
                        delegate: delegateComponent
                        width: 100
                    }//
                }//
            }
        }//
    }//
}//
