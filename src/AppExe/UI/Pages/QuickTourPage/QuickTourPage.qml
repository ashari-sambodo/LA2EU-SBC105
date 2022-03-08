/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Ahmad Qodri
**/

import QtQuick 2.14
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0
import ModulesCpp.RegisterExternalResources 1.0

ViewApp {
    id: viewApp
    title: "Quick Tour"
    
    background.sourceComponent: Item {}
    
    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
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
                    id: headerApp
                    anchors.fill: parent
                    title: qsTr("Quick Tour")
                }
            }
            
            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                RowLayout {
                    anchors.fill: parent
                    spacing: 5
                    
                    Item {
                        id: listViewItem
                        Layout.minimumWidth: 300
                        Layout.fillHeight: true

                        ListView {
                            id: pageIndexListView
                            anchors.fill: parent
                            orientation: ListView.Vertical
                            spacing: 5
                            clip: true
                            //                                layoutDirection: Qt.RightToLeft

                            model: [
                                //home section
                                {'title':       qsTr("Home"),
                                    'subTitle':    qsTr("Informative, and Intuitive Control Centre"),
                                    'description': qsTr("Uncompromising safety by displaying secured cabinet operating indicators and alarms. Quick control of all the main functions such as fan, brightness, sockets, service/gas fixtures, UV, and mute feature."),
                                    'link': "qrc:/UI/Pages/QuickTourPage/Fragment/HomeSectionQuickTour.qml"},

                                {'title':       qsTr("Navigation"),
                                    'subTitle':    qsTr("A Smart Touch"),
                                    'description': qsTr("Allows users to move pages using some gestures for the fastest way! Swipe Up, Down, Right, and Left to know its functions."),
                                    'link': "qrc:/UI/Pages/QuickTourPage/Fragment/GestureNavigation.qml"},

                                ///login section
                                {'title': qsTr("Login"),
                                    'subTitle':    qsTr("Manage Your Cabinet Access"),
                                    'description': qsTr("Give limited access to your cabinet by applying a username and password. Save username and password for easy login next time."),
                                    'link': "qrc:/UI/Pages/QuickTourPage/Fragment/LoginSectionQuickTour.qml"},

                                ///network section
                                {'title': qsTr("Network"),
                                    'subTitle':    qsTr("Connect and Update"),
                                    'description': qsTr("Connect your cabinet to your Workgroup Network"),
                                    'link': "qrc:/UI/Pages/QuickTourPage/Fragment/NetworkSectionQuickTour.qml"},

                                ///modBus section
                                {'title': qsTr("Remote ModBus"),
                                    'subTitle':    qsTr("Link to other Devices"),
                                    'description': qsTr("Enable user to access the cabinet remotely from other devices such as PC to control the main function with a condition. Allows transferring data log to a PC."),
                                    'link': "qrc:/UI/Pages/QuickTourPage/Fragment/ModbusSectionQuickTour.qml"},

                                ///evenlog section
                                {'title': qsTr("Logging"),
                                    'subTitle':    qsTr("Data Record and Collection Made Easy"),
                                    'description': qsTr("Check, delete, or export the data log, alarm log, or event log. Transferring data through Bluetooth or USB."),
                                    'link': "qrc:/UI/Pages/QuickTourPage/Fragment/EventLogQuickTour.qml"},

                                ///booking scheduler
                                {'title': qsTr("Booking Scheduler"),
                                    'subTitle':    qsTr("Organize Users Timetable"),
                                    'description': qsTr("Define and schedule cabinet usage for multiple users. Register, edit, cancel, delete or export the cabinet usage booking schedule through Bluetooth or USB."),
                                    'link': "qrc:/UI/Pages/QuickTourPage/Fragment/BookingScheduleQuickTour.qml"},

                                ///scheduler
                                {'title': qsTr("Fan & UV Scheduler"),
                                    'subTitle':    qsTr("Your Regular Assistant"),
                                    'description': qsTr("Help to schedule the daily or weekly UV sterilization, turn off and turn on the fan prior and after use automatically"),
                                    'link': "qrc:/UI/Pages/QuickTourPage/Fragment/UVSchedulerQuickTour.qml"},

                                ///sash standby
                                {'title': qsTr("Sash Standby"),
                                    'subTitle':    qsTr("Save Energy Up to 70%"),
                                    'description': qsTr("Move the sash window lower to the stand-by height point and save energy without compromising the product and your safety!"),
                                    'link': "qrc:/UI/Pages/QuickTourPage/Fragment/SashStandByQuickTour.qml"},

                                ///homepage Error section
                                {'title': qsTr("Airflow Fail"),
                                    'subTitle':    qsTr("Ultimate Protection Alarm"),
                                    'description': qsTr("Acoustic and visual alarms in any failure of air flows "),
                                    'link': "qrc:/UI/Pages/QuickTourPage/Fragment/ErorrAirflow.qml"},

                                ///homepage Error section
                                {'title': qsTr("Sash Unsafe"),
                                    'subTitle':    qsTr("Uncompromising Safety"),
                                    'description': qsTr("Acoustic and visual alarms in a false sash window position "),
                                    'link': "qrc:/UI/Pages/QuickTourPage/Fragment/SashUnsafeQuickTour.qml"},
                            ]

                            delegate: Rectangle {
                                id: recDelegate
                                radius: 5
                                height: pageIndexListView.currentIndex == index ?  300 : 50
                                width: listViewItem.width
                                color: pageIndexListView.currentIndex == index ? "#fafafa" : "#424242"

                                //                               width:pageIndexListView.childWidth

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 10

                                    TextApp {
                                        font.pixelSize: 25
                                        font.bold: true
                                        color: "#DDB620"
                                        text: modelData['title']
                                        width: parent.parent.width
                                        wrapMode: Text.WordWrap
                                    }//

                                    TextApp {
                                        visible: pageIndexListView.currentIndex == index ? true : false
                                        font.pixelSize: 15
                                        font.bold: true
                                        color: "black"
                                        text: modelData['subTitle']
                                        width: parent.parent.width - 10
                                        wrapMode: Text.WordWrap
                                    }//

                                    TextApp {
                                        visible: pageIndexListView.currentIndex == index ? true : false
                                        font.pixelSize: 14
                                        color: "#686868"
                                        text: modelData['description']
                                        width: parent.parent.width - 10
                                        wrapMode: Text.WordWrap
                                    }//
                                }//

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        //fragmentLoader.source = modelData['link']

                                        fragmentLoader.setSource(modelData['link'], {"autoPlay":autoplayCheckBox.checked})

                                        pageIndexListView.currentIndex = index
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

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                Rectangle {
                                    anchors.fill: parent
                                    color: "#fafafa"
                                    radius: 5

                                    Loader {
                                        id: fragmentLoader
                                        anchors.fill: parent
                                        asynchronous: true
                                        source: ""

                                        Component.onCompleted: {

                                            fragmentLoader.setSource("qrc:/UI/Pages/QuickTourPage/Fragment/HomeSectionQuickTour.qml", {"autoPlay":autoplayCheckBox.checked})
                                        }

                                        Connections {

                                            target: fragmentLoader.item

                                            function onFinished(){

                                                //if (props.stopTimer == autoplayCheckBox.checked) {

                                                if (fragmentLoader.source == "qrc:/UI/Pages/QuickTourPage/Fragment/HomeSectionQuickTour.qml" ){
                                                    fragmentLoader.setSource( "qrc:/UI/Pages/QuickTourPage/Fragment/GestureNavigation.qml", {"autoPlay":autoplayCheckBox.checked})
                                                    pageIndexListView.currentIndex = 1
                                                    //                                                    fragmentLoader.source = "qrc:/UI/Pages/QuickTourPage/Fragment/LoginSectionQuickTour.qml"
                                                    //                                                    console.log(autoplayCheckBox.checked)
                                                    //                                                    console.log("changedFrag")
                                                }

                                                else if (fragmentLoader.source == "qrc:/UI/Pages/QuickTourPage/Fragment/GestureNavigation.qml" ) {
                                                    fragmentLoader.setSource("qrc:/UI/Pages/QuickTourPage/Fragment/LoginSectionQuickTour.qml", {"autoPlay":autoplayCheckBox.checked})
                                                    pageIndexListView.currentIndex = 2
                                                    //fragmentLoader.source = "qrc:/UI/Pages/QuickTourPage/Fragment/NetworkSectionQuickTour.qml"
                                                }//

                                                else if (fragmentLoader.source == "qrc:/UI/Pages/QuickTourPage/Fragment/LoginSectionQuickTour.qml" ) {
                                                    fragmentLoader.setSource("qrc:/UI/Pages/QuickTourPage/Fragment/NetworkSectionQuickTour.qml", {"autoPlay":autoplayCheckBox.checked})
                                                    pageIndexListView.currentIndex = 3
                                                }//
                                                //fragmentLoader.source = "qrc:/UI/Pages/QuickTourPage/Fragment/NetworkSectionQuickTour.qml"

                                                else if (fragmentLoader.source == "qrc:/UI/Pages/QuickTourPage/Fragment/NetworkSectionQuickTour.qml" ) {
                                                    fragmentLoader.setSource("qrc:/UI/Pages/QuickTourPage/Fragment/ModbusSectionQuickTour.qml", {"autoPlay":autoplayCheckBox.checked})
                                                    //fragmentLoader.source = "qrc:/UI/Pages/QuickTourPage/Fragment/ModbusSectionQuickTour.qml"
                                                    pageIndexListView.currentIndex = 4

                                                }//

                                                else if (fragmentLoader.source == "qrc:/UI/Pages/QuickTourPage/Fragment/ModbusSectionQuickTour.qml" ) {
                                                    fragmentLoader.setSource("qrc:/UI/Pages/QuickTourPage/Fragment/EventLogQuickTour.qml", {"autoPlay":autoplayCheckBox.checked})
                                                    //fragmentLoader.source = "qrc:/UI/Pages/QuickTourPage/Fragment/EventLogQuickTour.qml"
                                                    pageIndexListView.currentIndex = 5
                                                }//

                                                else if (fragmentLoader.source == "qrc:/UI/Pages/QuickTourPage/Fragment/EventLogQuickTour.qml" ) {
                                                    //fragmentLoader.source = "qrc:/UI/Pages/QuickTourPage/Fragment/SashStandByQuickTour.qml"
                                                    fragmentLoader.setSource("qrc:/UI/Pages/QuickTourPage/Fragment/BookingScheduleQuickTour.qml", {"autoPlay":autoplayCheckBox.checked})
                                                    pageIndexListView.currentIndex = 6
                                                }//

                                                else if (fragmentLoader.source == "qrc:/UI/Pages/QuickTourPage/Fragment/BookingScheduleQuickTour.qml" ) {
                                                    //fragmentLoader.source = "qrc:/UI/Pages/QuickTourPage/Fragment/SashStandByQuickTour.qml"
                                                    fragmentLoader.setSource("qrc:/UI/Pages/QuickTourPage/Fragment/UVSchedulerQuickTour.qml", {"autoPlay":autoplayCheckBox.checked})
                                                    pageIndexListView.currentIndex = 7
                                                }//

                                                else if (fragmentLoader.source == "qrc:/UI/Pages/QuickTourPage/Fragment/UVSchedulerQuickTour.qml" ) {
                                                    //fragmentLoader.source = "qrc:/UI/Pages/QuickTourPage/Fragment/SashStandByQuickTour.qml"
                                                    fragmentLoader.setSource("qrc:/UI/Pages/QuickTourPage/Fragment/SashStandByQuickTour.qml", {"autoPlay":autoplayCheckBox.checked})
                                                    pageIndexListView.currentIndex = 8
                                                }//

                                                else if (fragmentLoader.source == "qrc:/UI/Pages/QuickTourPage/Fragment/SashStandByQuickTour.qml" ) {
                                                    //                                                    fragmentLoader.source = "qrc:/UI/Pages/QuickTourPage/Fragment/ErorrAirflow.qml"
                                                    fragmentLoader.setSource("qrc:/UI/Pages/QuickTourPage/Fragment/ErorrAirflow.qml", {"autoPlay":autoplayCheckBox.checked})
                                                    pageIndexListView.currentIndex = 9
                                                }//

                                                else if (fragmentLoader.source == "qrc:/UI/Pages/QuickTourPage/Fragment/ErorrAirflow.qml") {
                                                    fragmentLoader.source = "qrc:/UI/Pages/QuickTourPage/Fragment/SashUnsafeQuickTour.qml"
                                                    fragmentLoader.setSource("qrc:/UI/Pages/QuickTourPage/Fragment/SashUnsafeQuickTour.qml", {"autoPlay":autoplayCheckBox.checked})
                                                    pageIndexListView.currentIndex = 10
                                                }//
                                                //}
                                                //                                                console.log ("onFinished")
                                                //                                                console.log (fragmentLoader.source)
                                            }//
                                        }//
                                    }//

                                    BusyIndicatorApp {
                                        anchors.centerIn: parent
                                        visible: fragmentLoader.status == Loader.Loading
                                    }//
                                }//
                            }//
                        }//
                    }//
                }//
            }//
            
            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: MachineAPI.FOOTER_HEIGHT
                
                Rectangle {
                    anchors.fill: parent
                    color: "#0F2952"
                    //                    border.color: "#e3dac9"
                    //                    border.width: 1
                    radius: 5
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 5
                        
                        ButtonBarApp {
                            Layout.minimumWidth: 194
                            Layout.fillHeight: true
                            
                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")
                            
                            onClicked: {
                                var intent = IntentApp.create(uri, {})
                                finishView(intent)
                            }//
                        }//

                        Item {
                            Layout.minimumHeight: 30
                            Layout.fillWidth: true

                            CheckBox {
                                id: autoplayCheckBox
                                x: 289
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                text :qsTr("Auto play")
                                height: parent.height
                                font.pixelSize: 20
                                anchors.verticalCenterOffset: 0
                                anchors.rightMargin: 35

                                onCheckedChanged:  {

                                    fragmentLoader.item.autoPlay = checked
                                    //                                    props.autoPlayCheck = autoplayCheckBox.checked
                                    //                                    console.log("checkBox:" + props.autoPlayCheck)
                                }

                                contentItem: Text {
                                    text: autoplayCheckBox.text
                                    font: autoplayCheckBox.font
                                    opacity: enabled ? 1.0 : 0.3
                                    color: "#e3dac9"
                                    verticalAlignment: Text.AlignVCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 40
                                }//
                            }//
                        }//
                    }//
                }//
            }//
        }//

        RegisterExResources {
            id: registerExResources
        }
        
        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props
            property string serialNumber : ""

            property int pageIndicator: 0

            property bool autoPlayCheck: false
        }
        
        /// called Once but after onResume
        Component.onCompleted: {
            
        }//
        
        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible:  QtObject {

            /// onResume
            Component.onCompleted: {
                //                    //console.debug("StackView.Active");
                if(registerExResources.setResourcePath(MachineAPI.Resource_QuickTourAsset))
                {
                    console.debug("Success to set Resource_QuickTourAsset")
                    registerExResources.importResource();
                }
                else
                    console.debug("Failed to set Resource_QuickTourAsset!")

                props.serialNumber = MachineData.serialNumber
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");

                registerExResources.releaseResource();
            }
        }//
    }//
}//



/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#ffffff";height:480;width:640}
}
##^##*/
