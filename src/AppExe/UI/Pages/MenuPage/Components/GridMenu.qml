import QtQuick 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

GridView{
    id: menuGridView
    cellWidth: width / 4
    cellHeight: height / 2
    clip: true
    snapMode: GridView.SnapToRow
    flickableDirection: GridView.AutoFlickIfNeeded

    signal clicked(variant type, variant link, variant sub)

    delegate: Item{
        height: menuGridView.cellHeight
        width: menuGridView.cellWidth
        opacity:  iconMouseArea.pressed ? 0.5 : 1

        ColumnLayout{
            anchors.fill: parent
            anchors.margins: 10
            spacing: 0

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
            }

            Item {
                id: iconTextItem
                Layout.minimumHeight: parent.height* 0.35
                Layout.fillWidth: true

                //                Rectangle{anchors.fill: parent}

                Text {
                    id: iconText
                    //text: modelData.mtitle ? modelData.mtitle : ""
                    height: parent.height
                    width: parent.width
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignTop
                    color: "#dddddd"
                    font.pixelSize: 20

                    Component.onCompleted: {
                        /// Do to *.mjs is not detected by lupdate
                        switch(modelData.mtitle){
                            /// OPERATOR_MENU
                        case "Experiment Timer":    text = qsTr("Experiment Timer"); break
                        case "Light Intensity":     text = qsTr("Light Intensity"); break
                        case "LCD":                 text = qsTr("LCD"); break
                        case "Clean LCD":           text = qsTr("Clean LCD"); break
                        case "Languages":           text = qsTr("Languages"); break
                        case "Booking Schedule":    text = qsTr("Booking Schedule"); break
                        case "Diagnostics":         text = qsTr("Diagnostics"); break
                        case "Data Log":            text = qsTr("Data Log"); break
                        case "Alarm Log":           text = qsTr("Alarm Log"); break
                        case "Event Log":           text = qsTr("Event Log"); break
                        case "UV Timer":            text = qsTr("UV Timer"); break
                        case "Network":             text = qsTr("Network"); break
                        case "Mute Timer":          text = qsTr("Mute Timer"); break
                        case "Fan Scheduler":       text = qsTr("Fan Scheduler"); break
                        case "UV Scheduler":        text = qsTr("UV Scheduler"); break
                            /// ADMIN_MENU
                        case "Shut down":           text = qsTr("Shut down"); break
                        case "Users":               text = qsTr("Users"); break
                        case "Cabinet Name":        text = qsTr("Cabinet Name"); break
                        case "Time Zone":           text = qsTr("Time Zone"); break
                        case "Date":                text = qsTr("Date"); break
                        case "Time":                text = qsTr("Time"); break
                        case "Fan PIN":             text = qsTr("Fan PIN"); break
                        case "Operation Mode":      text = qsTr("Operation Mode"); break
                        case "Airflow Monitor":     text = qsTr("Airflow Monitor"); break
                        case "Warmup Time":         text = qsTr("Warmup Time"); break
                        case "Post Purge Time":     text = qsTr("Post Purge Time"); break
                        case "Remote Modbus":       text = qsTr("Remote Modbus"); break
                        case "Security Level":      text = qsTr("Security Level"); break
                            /// SERVICE_MENU
                        case "Fan Speed":                   text = qsTr("Fan Speed"); break
                        case "Measurement Unit":            text = qsTr("Measurement Unit"); break
                        case "Field Sensor Calibration":    text = qsTr("Field Sensor Calibration"); break
                        case "Full Sensor Calibration":     text = qsTr("Full Sensor Calibration"); break
                        case "Built-in SEAS Alarm":         text = qsTr("Built-in SEAS Alarm"); break
                        case "Certification Reminder":      text = qsTr("Certification Reminder"); break
                        case "Certification Summary":       text = qsTr("Certification Summary"); break
                        case "Manual Input Calibration Point": text = qsTr("Manual Input Calibration Point"); break
                        case "Reset Parameters":            text = qsTr("Reset Parameters"); break
                            //// SUB RESET MENU
                        case "Reset Filter Life Meter":     text = qsTr("Reset Filter Life Meter"); break
                        case "Reset Fan Usage Meter":       text = qsTr("Reset Fan Usage Meter"); break
                        case "Reset UV Life Meter":         text = qsTr("Reset UV Life Meter"); break
                        case "Reset Sash Cycle Meter":      text = qsTr("Reset Sash Cycle Meter"); break
                            ///
                        case "RBM Com Port":                text = qsTr("RBM Com Port"); break
                        case "Fan Closed Loop Control":     text = qsTr("Fan Closed Loop Control"); break
                        case "Software Update":             text = qsTr("Software Update"); break
                        case "Shipping Setup":              text = qsTr("Shipping Setup"); break
                            /// FACTORY_MENU
                        case "Sash Motor Off Delay":        text = qsTr("Sash Motor Off Delay"); break
                        case "Serial Number":               text = qsTr("Serial Number"); break
                        case "Environmental Temperature Limit": text = qsTr("Environmental Temperature Limit"); break
                        case "ESCO Lock Service":           text = qsTr("ESCO Lock Service"); break
                        case "Auxiliary Functions":         text = qsTr("Auxiliary Functions"); break
                        case "Cabinet Model":               text = qsTr("Cabinet Model"); break
                        case "RTC Watchdog Test":           text = qsTr("RTC Watchdog Test"); break
                        case "System Information":          text = qsTr("System Information"); break

                        default: text = modelData.mtitle; break
                        }//
                    }//
                }//
            }//
        }//

        MouseArea {
            id: iconMouseArea
            anchors.fill: parent
            onClicked: {
                //CALL_SIGNAL_ON_PARENT
                if(modelData.sub){
                    //                    //console.debug(modelData.sub)
                    //                    menuGridView.parent.modelSubMenu = modelData.sub
                    menuGridView.clicked(modelData.mtype, modelData.mlink, modelData.sub)
                }
                else {
                    menuGridView.clicked(modelData.mtype, modelData.mlink, {})
                }
            }//
        }//

        //        TapHandler {
        //            onTapped: {
        //                //CALL_SIGNAL_ON_PARENT
        //                if(modelData.sub){
        //                    //                    //console.debug(modelData.sub)
        //                    //                    menuGridView.parent.modelSubMenu = modelData.sub
        //                    menuGridView.clicked(modelData.mtype, modelData.mlink, modelData.sub)
        //                }
        //                else {
        //                    menuGridView.clicked(modelData.mtype, modelData.mlink, {})
        //                }
        //            }//
        //        }//
    }//

    //    populate: Transition {
    //        NumberAnimation { properties: "scale"; from:0.8; to:1; duration: 200}
    //    }

    //    //MOVE_ROW_WITH_ANIMATION
    //    function gotoIndex(idx) {
    //        anim.running = false
    //        var pos = menuGridView.contentY;
    //        var destPos;
    //        menuGridView.positionViewAtIndex(idx, ListView.Beginning);
    //        destPos = menuGridView.contentY;
    //        anim.from = pos;
    //        anim.to = destPos;
    //        anim.running = true;
    //    }

    //    NumberAnimation { id: anim; target: menuGridView; property: "contentY"; duration: 100 }

    //    Component.onCompleted: {
    //        //console.debug("Me Created")

    //        //console.debug(menuGridView.parent.height)
    //        //console.debug(menuGridView.parent.width)
    //    }

    //    Component.onDestruction: {
    //        //console.debug("Me Decroyed")
    //    }

    //    onVisibleChanged: {
    //        //console.debug("Visible changed to " + visible)

    //        height  = parent.height
    //        width   = parent.width
    //        cellWidth = width / 5
    //        cellHeight = height / 2

    //        //console.debug("height: " + height)
    //        //console.debug("width: " + width)
    //    }

}

