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
                    text: modelData.mtitle ? modelData.mtitle : ""
                    height: parent.height
                    width: parent.width
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignTop
                    color: "#dddddd"
                    font.pixelSize: 20
                }
            }
        }

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

