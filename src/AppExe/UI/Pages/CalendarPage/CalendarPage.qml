import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import ModulesCpp.Machine 1.0
import "../../CusCom/JS/IntentApp.js" as IntentApp

ViewApp {
    id: viewApp
    title: "Calendar"

    background.sourceComponent: Item {
        //        color: "#34495e"
    }//

    content.asynchronous: true
    content.sourceComponent: ContentItemApp{
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
                    title: qsTr("Calendar")
                }//
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                CalendarGridApp {
                    id: calendar
                    anchors.fill: parent

                    onClicked: {
                        if (props.selectDateAndReturn) {
                            let dateSelected = Qt.formatDateTime(date, "yyyy-MM-dd")
                            console.log(dateSelected)

                            var intent = IntentApp.create(uri, {"calendar":{"date": dateSelected}})
                            finishView(intent)
                        }//
                    }//
                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: MachineAPI.FOOTER_HEIGHT

                BackgroundButtonBarApp {
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
                            }//
                        }//

                        Row {
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 5

                            Rectangle {
                                height: 5
                                width: 30
                                color: "#27ae60"
                                radius: 2
                                anchors.verticalCenter: parent.verticalCenter
                            }//

                            TextApp {
                                text: qsTr("Today's date")
                            }//
                        }//
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property bool selectDateAndReturn: false
        }

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        //// Execute This Every This Screen Active/Visible/Foreground
        executeOnPageVisible: QtObject {
            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");

                const extraData = IntentApp.getExtraData(intent)

                const current = extraData['currentDate'] || false /// yyyy-MM-dd
                let currentDate = current ? new Date(current) : NaN
                //                console.log(currentDate)
                if (isNaN(currentDate)){
                    currentDate = new Date()
                }
                currentDate.setHours(0, 0, 0, 0)
                calendar.targetDate = currentDate
                calendar.targetMonth = currentDate.getMonth()
                calendar.targetYear = currentDate.getFullYear()

                const future = extraData['futureDateLimit'] || false
                let futureDateLimit = future ? new Date(future) : NaN
                //                console.log(futureDateLimit)
                if (isNaN(futureDateLimit)) {
                    futureDateLimit = new Date()
                    futureDateLimit.setDate(31)
                    futureDateLimit.setMonth(11) //DECEMBER
                    futureDateLimit.setFullYear(2050)
                }
                futureDateLimit.setHours(0, 0, 0, 0)
                calendar.futureDateLimit = futureDateLimit

                const older = extraData['olderDateLimit'] || false
                let olderDateLimit = older ? new Date(older) : NaN
                //                console.log(olderDateLimit)
                if (isNaN(olderDateLimit)) {
                    olderDateLimit = new Date()
                    olderDateLimit.setDate(31)
                    olderDateLimit.setMonth(11) //DECEMBER
                    olderDateLimit.setFullYear(2000)
                }
                olderDateLimit.setHours(0, 0, 0, 0)
                calendar.olderDateLimit = olderDateLimit

                const selectDateAndReturn = extraData['selectDateAndReturn'] || false
                props.selectDateAndReturn = selectDateAndReturn
            }//

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/
