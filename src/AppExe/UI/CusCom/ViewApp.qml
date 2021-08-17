/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Controls 2.0

Item {
    id: control

    property string title:  ""
    property string uri:    ""
    property var    intent: null

    /// View Navigation
    signal startView(variant newIntent);
    signal startRootView(variant newIntent);
    signal screenLocked(bool locked);

    /// TouchPoint signal
    signal screenPressed()

    /// After pop the view,
    /// system need to tell the next view that the top view has finished
    /// The current view called finishView() with newIntent
    /// main stackview received the signal need to finish the view
    /// pop the current view, push the newIntent message as replacement to next view
    signal finishView(variant intent);
    /// called this on the target returned page
    signal finishViewReturned(variant newIntent);

    property alias background: backgroundLoader
    property alias content: contentLoader

    property int  stackViewStatus:              StackView.status
    property bool stackViewStatusActivating:    StackView.status == StackView.Activating
    property bool stackViewStatusActive:        StackView.status == StackView.Active
    property bool stackViewStatusDeactivating:  StackView.status == StackView.Deactivating
    property bool stackViewStatusInactive:      StackView.status == StackView.Inactive
    property bool stackViewStatusForeground:    StackView.status >= StackView.Activating

    onStackViewStatusChanged: {
        //console.debug(uri + " " + "stackViewStatus: " + stackViewStatus)

        //        switch (stackViewStatus){
        //        case StackView.Active:
        //            //console.debug(title + ".StackView.Active");
        //            break
        //        case StackView.Activating:
        //            //console.debug(title + ".StackView.Activating");
        //            break
        //        case StackView.Deactivating:
        //            //console.debug(title + ".StackView.Deactivating");
        //            break
        //        case StackView.Inactive:
        //            //console.debug(title + ".StackView.Inactive");
        //            break
        //        default:
        //            //console.debug(title + ".StackView.unknown");
        //            break
        //        }
    }

    /// Background
    Loader {
        id: backgroundLoader
        anchors.fill: parent
        sourceComponent: Rectangle{}

        /// solve binding loop when use m_pQmlEngine->retranslate();
        onLoaded: {
            contentLoader.active = true
        }//
    }//

    /// Content
    Loader {
        id: contentLoader
        anchors.fill: parent
        active: false
        visible: status == Loader.Ready
    }//

    /// Gesture
    property var fnSwipedFromLeftEdge: null
    property var fnSwipedFromRightEdge: null
    property var fnSwipedFromBottomEdge: null
    ///
    property bool enabledSwipedFromLeftEdge: true
    property bool enabledSwipedFromRightEdge: true
    property bool enabledSwipedFromBottomEdge: true
    property bool enabledSwipedFromTopEdge: true
    ///
    property bool ignoreScreenSaver: false

    /// Loading Page
    Loader {
        id: busyLoader
        anchors.fill: parent
        active: contentLoader.asynchronous
                && ((contentLoader.status == Loader.Loading)
                    || (backgroundLoader.status == Loader.Loading)
                    || (contentLoader.item.visible === false))
        sourceComponent: Item {
            Image {
                anchors.centerIn: parent
                source: "ViewApp/ViewApp_BusyIndicator.png"
                cache: true
                height: 100
                width: 100
                fillMode: Image.PreserveAspectFit
            }//
        }//
    }//

    /// Dialog
    readonly property int dialogInfo: 0
    readonly property int dialogAlert: 1
    property var dialogObject: null

    function closeDialog(){
        if(dialogObject == null) {
            //            //console.debug("dialogObject:null")
            return
        }
        if(dialogObject == undefined) {
            //            //console.debug("dialogObject:undefined")
            return
        }
        dialogObject.close()
    }

    function showDialogMessage(title, text, alert, callbackOnClosed, autoClosed, urlFeatureImage){
        closeDialog()
        let component = Qt.createComponent("DialogApp.qml");
        if (component.status === Component.Ready) {
            control.dialogObject = component.createObject(control);

            if (callbackOnClosed !== undefined) control.dialogObject.closed.connect(callbackOnClosed)

            autoClosed = autoClosed !== undefined ? autoClosed : true

            if (urlFeatureImage !== undefined) control.dialogObject.contentItem.featureSourceImage = urlFeatureImage

            control.dialogObject.anchors.fill = control
            control.dialogObject.contentItem.title = title
            control.dialogObject.contentItem.text = text
            control.dialogObject.contentItem.dialogType = alert
            control.dialogObject.contentItem.visibleFeatureImage = alert /// Dont Show feature image when the dialog not alert
            control.dialogObject.contentItem.standardButton = 0 // standardButtonClose
            control.dialogObject.autoDestroy = true
            control.dialogObject.autoClose = autoClosed
            control.dialogObject.visible = true
        }//
    }//

    function showDialogAsk(title, text, alert, callbackOnAccepted, callbackOnRejected, callbackOnClosed, autoClosed, interval){
        closeDialog()
        let component = Qt.createComponent("DialogApp.qml");
        if (component.status === Component.Ready) {
            control.dialogObject = component.createObject(control);

            if (callbackOnAccepted !== undefined) control.dialogObject.accepted.connect(callbackOnAccepted)
            if (callbackOnRejected !== undefined) control.dialogObject.rejected.connect(callbackOnRejected)
            if (callbackOnClosed !== undefined) control.dialogObject.closed.connect(callbackOnClosed)

            autoClosed = autoClosed !== undefined ? autoClosed : true
            interval = interval !== undefined ? interval : 3

            control.dialogObject.anchors.fill = control
            control.dialogObject.contentItem.title = title
            control.dialogObject.contentItem.text = text
            control.dialogObject.contentItem.dialogType = alert
            control.dialogObject.contentItem.visibleFeatureImage = alert /// Dont Show feature image when the dialog not alert
            control.dialogObject.contentItem.standardButton = 1 // standardButtonCancelOK
            control.dialogObject.autoDestroy = true
            control.dialogObject.interval = interval * 1000 //second to milisecond
            control.dialogObject.autoClose = autoClosed
            control.dialogObject.visible = true
        }//
    }//

    function showBusyPage(title, callback){
        closeDialog()
        let component = Qt.createComponent("BusyPageBlockApp.qml");
        if (component.status === Component.Ready) {
            control.dialogObject = component.createObject(control);

            if (callback !== undefined) control.dialogObject.fullRotated.connect(callback)
            if (callback !== undefined) control.dialogObject.closed.connect(function(){dialogObject.destroy()})

            control.dialogObject.anchors.fill = control
            control.dialogObject.title = title
            control.dialogObject.running = true
            control.dialogObject.visible = true
        }//
    }//

    Component.onCompleted: {
        //        console.debug("onCompleted: " + title + " : " + uri)
    }

    Component.onDestruction: {
        //console.debug("onDestruction: " + title + " : " + uri)
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
