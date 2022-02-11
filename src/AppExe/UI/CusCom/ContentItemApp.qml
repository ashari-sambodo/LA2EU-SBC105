import QtQuick 2.0

Item {
    id: control
    property bool ready: false
    Component.onCompleted: ready = true

    property alias executeOnPageVisible: executeOnLoader.sourceComponent

    //// Dont show anything before connection to machine was ready
    visible: executeOnLoader.status == Loader.Ready
    //// Execute This Every This Screen Active/Visible
    Loader {
        id: executeOnLoader
        /// stackViewStatusForeground is a global variable inside ViewApp
        active: stackViewStatusForeground && control.ready

        sourceComponent: QtObject {
            /// onResume
            Component.onCompleted: {
                // console.debug("StackView.Active");
                // onsole.debug("stackViewDepth: " + stackViewDepth)
            }//

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }

            /// PUT ANY DYNAMIC OBJECT MUST A WARE TO PAGE STATUS
            /// ANY OBJECT ON HERE WILL BE DESTROYED WHEN THIS PAGE NOT IN FOREGROUND
        }//
    }
}
