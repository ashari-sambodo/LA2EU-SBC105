import QtQuick 2.0

Item {

    property bool   dissconnect: false
    property int    strength: 0
    property bool   security: false

    Image {
        id: signalImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "WifiSignalApp/wifi-25-open.png"

        states: [
            State {
                when: dissconnect
                PropertyChanges {
                    target: signalImage
                    source: "WifiSignalApp/wifi-no.png"
                }
            }
            ,
            State {
                when: security && (strength >= 70)
                PropertyChanges {
                    target: signalImage
                    source: "WifiSignalApp/wifi-100-secure.png"
                }
            }
            ,
            State {
                when: security && (strength >= 50)
                PropertyChanges {
                    target: signalImage
                    source: "WifiSignalApp/wifi-75-secure.png"
                }
            }
            ,
            State {
                when: security && (strength >= 30)
                PropertyChanges {
                    target: signalImage
                    source: "WifiSignalApp/wifi-50-secure.png"
                }
            }
            ,
            State {
                when: security
                PropertyChanges {
                    target: signalImage
                    source: "WifiSignalApp/wifi-25-secure.png"
                }
            }
            ,
            State {
                when: !security && (strength >= 70)
                PropertyChanges {
                    target: signalImage
                    source: "WifiSignalApp/wifi-100-open.png"
                }
            }
            ,
            State {
                when: !security && (strength >= 50)
                PropertyChanges {
                    target: signalImage
                    source: "WifiSignalApp/wifi-75-open.png"
                }
            }
            ,
            State {
                when: !security && (strength >= 30)
                PropertyChanges {
                    target: signalImage
                    source: "WifiSignalApp/wifi-50-open.png"
                }
            }
        ]
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:100;width:100}
}
##^##*/
