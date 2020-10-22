import QtQuick 2.0
import QtQuick.Controls 2.0

Item {
    id: root
    property string title:  ""
    property string uri:    ""
    property var    intent: null

    property string homeURL: "qrc:/UI/Pages/HomePage/HomePage.qml"

    /// View Navigation
    signal startView(variant newIntent);
    signal startRootView(variant newIntent);

    /// After pop the view,
    /// system need to tell the next view that the top view has finished
    /// The current view called finishView() with newIntent
    /// main stackview received the signal need to finish the view
    /// pop the current view, push the newIntent message as replacement to next view
    signal finishView(variant intent);
    signal finishReturnView(variant newIntent);

    /// Keyboard On Screen
    signal openKeyboard(string title);
    signal openNumpad(string title);
    property var textInputTarget
    property var funcOnKeyboardEntered: function(text){
        if(textInputTarget instanceof TextInput){
            textInputTarget.text = text
        }
    }

    property alias background: backgroundLoader
    property alias content: contentLoader

    property int stackViewStatus: StackView.status
    //    onStackViewStatusChanged: {
    //        console.log("stackViewStatus: " + stackViewStatus)

    //        switch (stackViewStatus){
    //        case StackView.Active:
    //            console.log(title + ".StackView.Active");
    //            break
    //        case StackView.Activating:
    //            console.log(title + ".StackView.Activating");
    //            break
    //        case StackView.Deactivating:
    //            console.log(title + ".StackView.Deactivating");
    //            break
    //        case StackView.Inactive:
    //            console.log(title + ".StackView.Inactive");
    //            break
    //        }
    //    }

    Loader {
        id: backgroundLoader
        anchors.fill: parent
        sourceComponent: Rectangle{

        }
    }

    Loader {
        id: contentLoader
        anchors.fill: parent
        active: backgroundLoader.status == Loader.Ready
        //        onStatusChanged: {
        //            console.log("onStatusChanged: " + status)
        //        }
    }

    Loader {
        id: busyLoader
        anchors.fill: parent
        active: contentLoader.asynchronous && (contentLoader.status == Loader.Loading)
        sourceComponent: Item {
            Image {
                anchors.centerIn: parent
                source: "ViewApp/ViewApp_BusyIndicator.png"
                cache: true
                height: 100
                width: 100
                fillMode: Image.PreserveAspectFit
            }
            //            Rectangle{
            //                id: outerRectangle
            //                anchors.centerIn: parent
            //                height: 50
            //                width: 50
            //                radius: width / 2
            //                color: "#00000000"
            //                border.color: "#ffffff"
            //                border.width: 5

            //                Rectangle {
            //                    id: innerRectangle
            //                    anchors.fill: parent
            //                    anchors.margins: 15
            //                    radius: width
            //                }

            //                Timer{
            //                    running: true
            //                    interval: 500
            //                    repeat: true
            //                    onTriggered: {
            //                        if(control){
            //                            innerRectangle.color = "#000000"
            //                            outerRectangle.border.color = "#ffffff"
            //                            control = !control
            //                        } else {
            //                            innerRectangle.color = "#ffffff"
            //                            outerRectangle.border.color = "#000000"
            //                            control = !control
            //                        }
            //                        console.log("anim")
            //                    }

            //                    property bool control: false
            //                }
            //            }
        }
    }

    Component.onCompleted: {
        //        console.log("onCompleted: " + title + " : " + uri)
    }

    Component.onDestruction: {
        //        console.log("onDestruction: " + title)
    }
}
