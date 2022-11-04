import QtQuick 2.14
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.1

import UI.CusCom 1.1
import ModulesCpp.Machine 1.0

import "../Components" as CusComPage

Item {
    id: control
    property bool viewOnly: false

    ColumnLayout{
        anchors.fill: parent
        Item{
            Layout.minimumHeight: 50
            Layout.fillWidth: true
            RowLayout{
                anchors.fill: parent
                spacing: 2
                Item{
                    Layout.fillHeight: true
                    Layout.minimumWidth: 50
                    TextBoxApp{
                        anchors.fill: parent
                        text: qsTr("No.")
                        boxOpacity: 1
                    }
                }
                Item{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    TextBoxApp{
                        anchors.fill: parent
                        text: props.modelColumnTitle[0]
                        boxOpacity: 1
                    }
                }
                Item{
                    Layout.fillHeight: true
                    Layout.minimumWidth: 150
                    TextBoxApp{
                        anchors.fill: parent
                        text: props.modelColumnTitle[1]
                        boxOpacity: 1
                    }
                }
                Item{
                    Layout.fillHeight: true
                    Layout.minimumWidth: 50
                    TextBoxApp{
                        anchors.fill: parent
                        text: props.modelColumnTitle[2]
                        boxOpacity: 1
                    }
                }
                Item{
                    Layout.fillHeight: true
                    Layout.minimumWidth: sn2Item.visible ? 125 : 200
                    visible: props.modelColumnTitle.length > 4
                    TextBoxApp{
                        anchors.fill: parent
                        text: props.modelColumnTitle[3]
                        boxOpacity: 1
                    }
                }
                Item{
                    id: sn2Item
                    Layout.fillHeight: true
                    Layout.minimumWidth: 125
                    visible: props.modelColumnTitle.length === 7
                    TextBoxApp{
                        anchors.fill: parent
                        text: props.modelColumnTitle[4]
                        boxOpacity: 1
                    }
                }
                Item{
                    Layout.fillHeight: true
                    Layout.minimumWidth: sn2Item.visible ? 100 : 150
                    visible: props.modelColumnTitle.length > 5
                    TextBoxApp{
                        anchors.fill: parent
                        text: sn2Item.visible ? props.modelColumnTitle[5] : props.modelColumnTitle[4]
                        boxOpacity: 1
                    }
                }
                Item{
                    Layout.fillHeight: true
                    Layout.minimumWidth: 50
                    Rectangle {
                        id: rectangle
                        width: parent.width
                        height: parent.height
                        color: "#1F95D7"
                        border.color: "#88133966"
                        border.width: 1
                        radius: 2
                    }
                    CheckBox {
                        anchors.centerIn: parent
                        //anchors.horizontalCenterOffset: -3
                        width: 40
                        height: 40
                        font.pixelSize: 20
                        checked: true
                        onCheckStateChanged: checked = true
                    }//
                }
                Rectangle{
                    Layout.fillHeight: true
                    Layout.minimumWidth: 23
                    color: "transparent"
                }
            }
        }
        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true
            RowLayout {
                anchors.fill: parent

                Flickable {
                    id: view
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    //                        anchors.fill: parent
                    //                        anchors.margins: 2
                    contentWidth: col.width
                    contentHeight: col.height
                    property real span : contentY + height
                    clip: true

                    flickableDirection: Flickable.VerticalFlick

                    ScrollBar.vertical: verticalScrollBar.scrollBar

                    Column {
                        id: col
                        spacing: 2
                        Repeater{
                            model: props.maxRow
                            CusComPage.RowItemApp {
                                width: view.width
                                height: 60
                                viewContentY: view.contentY
                                viewSpan: view.span
                                indexOnList: props.startIndex + index
                                rowNo: index + 1
                                modelColumnTitle: props.modelColumnTitle
                                viewOnly: control.viewOnly
                                onLoaded: {
                                    modelColumn = Qt.binding(function(){
                                        let model = [
                                                props.getRpList(indexOnList),
                                                props.getRpList(indexOnList+(props.maxRow*1)),
                                                props.getRpList(indexOnList+(props.maxRow*2)),
                                                props.getRpList(indexOnList+(props.maxRow*3)),
                                                Number(props.getRpList(indexOnList+(props.maxRow*4))) ? true : false
                                            ]//
                                        return model
                                    })//
                                }//
                                onPartNameAccepted: {
                                    MachineAPI.setReplaceablePartsSettings(indexOnList, value)
                                }
                                onItemCodeAccepted: {
                                    props.setItemCode(indexOnList+(props.maxRow*1), value)
                                }
                                onQuantityAccepted: {
                                    MachineAPI.setReplaceablePartsSettings(indexOnList+(props.maxRow*2), String(value))
                                }
                                onSerialNumber1Accepted: {
                                    MachineAPI.setReplaceablePartsSettings(indexOnList+(props.maxRow*3), value)
                                }
                                onSerialNumber2Accepted: {
                                }
                                onSoftwareConstAccepted: {
                                }
                                onCheckedChanged: {
                                    const strVal = value ? "1" : "0"
                                    if((props.getRpList(indexOnList+(props.maxRow*4)) === strVal )
                                            || (strVal === "0" && props.getRpList(indexOnList+(props.maxRow*4)) === "")) return
                                    MachineAPI.setReplaceablePartsSettings(indexOnList+(props.maxRow*4), (value ? "1" : "0"))
                                }
                                onInvalidInput: {
                                    showDialogMessage(modelColumn[0], qsTr("Invalid Input"), dialogAlert)
                                }
                                onItemCodePressedAndHold: {
                                    itemCodeOptionLoader.indexOnList = indexOnList
                                    itemCodeOptionLoader.active = true
                                }

                                onItemShiftUpClicked: {
                                    if(indexOnList > props.startIndex){
                                        let nowIndex = indexOnList
                                        let prevIndex = indexOnList-1

                                        const backUpName = props.getRpList(prevIndex)
                                        const backUpCode = props.getRpList(prevIndex+(props.maxRow*1))
                                        const backUpQty = props.getRpList(prevIndex+(props.maxRow*2))
                                        const backUpSN = props.getRpList(prevIndex+(props.maxRow*3))
                                        const backUpCheck =  props.getRpList(prevIndex+(props.maxRow*4))

                                        MachineAPI.setReplaceablePartsSettings(Number(prevIndex), String(props.getRpList(nowIndex)))
                                        MachineAPI.setReplaceablePartsSettings(Number(prevIndex+(props.maxRow*1)), String(props.getRpList(nowIndex+(props.maxRow*1))))
                                        MachineAPI.setReplaceablePartsSettings(Number(prevIndex+(props.maxRow*2)), String(props.getRpList(nowIndex+(props.maxRow*2))))
                                        MachineAPI.setReplaceablePartsSettings(Number(prevIndex+(props.maxRow*3)), String(props.getRpList(nowIndex+(props.maxRow*3))))
                                        MachineAPI.setReplaceablePartsSettings(Number(prevIndex+(props.maxRow*4)), String(props.getRpList(nowIndex+(props.maxRow*4))))

                                        MachineAPI.setReplaceablePartsSettings(Number(nowIndex), String(backUpName))
                                        MachineAPI.setReplaceablePartsSettings(Number(nowIndex+(props.maxRow*1)), String(backUpCode))
                                        MachineAPI.setReplaceablePartsSettings(Number(nowIndex+(props.maxRow*2)), String(backUpQty))
                                        MachineAPI.setReplaceablePartsSettings(Number(nowIndex+(props.maxRow*3)), String(backUpSN))
                                        MachineAPI.setReplaceablePartsSettings(Number(nowIndex+(props.maxRow*4)), String(backUpCheck))

                                    }//
                                }//
                                onItemShiftDownClicked: {
                                    if(indexOnList < (props.startIndex + (props.maxRow-1))){
                                        let nowIndex = indexOnList
                                        let nextIndex = indexOnList+1

                                        const backUpName = props.getRpList(nextIndex)
                                        const backUpCode = props.getRpList(nextIndex+(props.maxRow*1))
                                        const backUpQty = props.getRpList(nextIndex+(props.maxRow*2))
                                        const backUpSN = props.getRpList(nextIndex+(props.maxRow*3))
                                        const backUpCheck =  props.getRpList(nextIndex+(props.maxRow*4))

                                        MachineAPI.setReplaceablePartsSettings(Number(nextIndex), String(props.getRpList(nowIndex)))
                                        MachineAPI.setReplaceablePartsSettings(Number(nextIndex+(props.maxRow*1)), String(props.getRpList(nowIndex+(props.maxRow*1))))
                                        MachineAPI.setReplaceablePartsSettings(Number(nextIndex+(props.maxRow*2)), String(props.getRpList(nowIndex+(props.maxRow*2))))
                                        MachineAPI.setReplaceablePartsSettings(Number(nextIndex+(props.maxRow*3)), String(props.getRpList(nowIndex+(props.maxRow*3))))
                                        MachineAPI.setReplaceablePartsSettings(Number(nextIndex+(props.maxRow*4)), String(props.getRpList(nowIndex+(props.maxRow*4))))

                                        MachineAPI.setReplaceablePartsSettings(Number(nowIndex), String(backUpName))
                                        MachineAPI.setReplaceablePartsSettings(Number(nowIndex+(props.maxRow*1)), String(backUpCode))
                                        MachineAPI.setReplaceablePartsSettings(Number(nowIndex+(props.maxRow*2)), String(backUpQty))
                                        MachineAPI.setReplaceablePartsSettings(Number(nowIndex+(props.maxRow*3)), String(backUpSN))
                                        MachineAPI.setReplaceablePartsSettings(Number(nowIndex+(props.maxRow*4)), String(backUpCheck))
                                    }//
                                }//
                                onItemClearAllClicked: {
                                    MachineAPI.setReplaceablePartsSettings(Number(indexOnList), "")
                                    MachineAPI.setReplaceablePartsSettings(Number(indexOnList+(props.maxRow*1)), "")
                                    MachineAPI.setReplaceablePartsSettings(Number(indexOnList+(props.maxRow*2)), "")
                                    MachineAPI.setReplaceablePartsSettings(Number(indexOnList+(props.maxRow*3)), "")
                                    MachineAPI.setReplaceablePartsSettings(Number(indexOnList+(props.maxRow*4)), "")
                                }//
                            }//
                        }//
                    }//
                }//

                ScrollBarApp {
                    id: verticalScrollBar
                    Layout.fillHeight: true
                    Layout.minimumWidth: 20
                    Layout.fillWidth: false
                }//
            }//
        }//
    }//

    Loader{
        id: itemCodeOptionLoader
        active: false
        anchors.fill: parent

        property int indexOnList: 0

        sourceComponent: Item{
            Rectangle{
                anchors.fill: parent
                color: "#bb000000"
                MouseArea{
                    anchors.fill: parent
                    onClicked: itemCodeOptionLoader.active = false
                }//
            }//

            Rectangle{
                height: 300
                width: 500
                color: "#bb000000"
                anchors.centerIn: parent
                radius: 10
                border.width: 1
                border.color: "grey"
                ColumnLayout{
                    anchors.fill: parent
                    Item{
                        Layout.minimumHeight: 40
                        Layout.fillWidth: true
                        Rectangle{
                            anchors.fill: parent
                            color: "grey"
                            radius: 10
                            Rectangle{
                                width: parent.width
                                height: parent.height - parent.radius
                                color: "grey"
                                anchors.bottom: parent.bottom
                            }//
                        }//

                        RowLayout{
                            anchors.fill: parent
                            spacing: 10
                            Item {
                                Layout.fillHeight: true
                                Layout.minimumWidth: 100
                                TextApp{
                                    width: parent.width
                                    height: parent.height
                                    text: qsTr("Item Code")
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                TextApp{
                                    width: parent.width
                                    height: parent.height
                                    text: qsTr("Part Name")
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                        }//
                    }//
                    Item{
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        RowLayout {
                            anchors.fill: parent
                            spacing: 5
                            Item{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                ColumnLayout{
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    Flickable{
                                        id: view2
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        contentWidth: col2.width
                                        contentHeight: col2.height
                                        clip: true
                                        flickableDirection: Flickable.VerticalFlick
                                        ScrollBar.vertical: verticalScrollBar2

                                        property real span : contentY + height
                                        Column{
                                            id: col2
                                            anchors.verticalCenter: parent.verticalCenter
                                            spacing: 5
                                            Repeater{
                                                model: props.rpDatabase
                                                Rectangle{
                                                    width: view2.width
                                                    height: 40
                                                    color: "transparent"
                                                    opacity: optionRectMA.pressed ? 0.5 : 1
                                                    Row{
                                                        spacing: 10
                                                        TextApp{
                                                            height: 40
                                                            width: 100
                                                            text: modelData['id']
                                                            verticalAlignment: Text.AlignVCenter
                                                        }//
                                                        TextApp{
                                                            height: 40
                                                            width: view2.width - 110
                                                            text: modelData['desc']
                                                            verticalAlignment: Text.AlignVCenter
                                                            elide: Text.ElideRight
                                                        }//
                                                    }//
                                                    MouseArea{
                                                        id: optionRectMA
                                                        anchors.fill: parent
                                                        onClicked: {
                                                            console.debug(modelData['id'], modelData['desc'], index)

                                                            props.setItemCode(itemCodeOptionLoader.indexOnList+(props.maxRow*1),
                                                                              modelData['id'],
                                                                              false)

                                                            itemCodeOptionLoader.active = false
                                                            props.showBusy()
                                                        }//
                                                    }//
                                                }//
                                            }//
                                        }//
                                    }//
                                }//
                            }//
                            Rectangle{
                                id: verticalScrollRectangle2
                                Layout.fillHeight: true
                                Layout.minimumWidth: 10
                                color: "transparent"
                                border.color: "#E6E6E6"
                                radius: 5
                                visible: view2.contentHeight > height
                                /// Vertical ScrollBar
                                ScrollBar {
                                    id: verticalScrollBar2
                                    anchors.fill: parent
                                    orientation: Qt.Vertical
                                    policy: ScrollBar.AsNeeded

                                    contentItem: Rectangle {
                                        implicitWidth: 0
                                        implicitHeight: 5
                                        radius: width / 2
                                        color: "#E6E6E6"
                                    }//
                                }//
                            }//
                        }//
                    }
                }//
            }//
        }//
    }//

    ReplaceablePartsDatabaseApp{
        id: rpApp

        //        property var group: [
        //            'sbcSet',//0
        //            'sensors',//1
        //            'uvLed',
        //            'psu',
        //            'mcbEmi',
        //            'contactSw',
        //            'bMotor',
        //            'capInd',
        //            'custom',//8
        //            'filter'//9
        //        ]//

        Component.onCompleted: {
            props.rpDatabase = database[0]['contactSw']
        }
    }//

    QtObject{
        id: props
        readonly property int maxRow: 5
        readonly property int startIndex: MachineAPI.RPList_ContactSw1Name
        property var rpDatabase: null
        readonly property var modelColumnTitle: [
            qsTr("Part Name"),
            qsTr("Item Code"),
            qsTr("QTY"),
            qsTr("Serial Number"),
            qsTr("Check")]

        function showBusy(cycleCount){
            if(cycleCount === undefined) cycleCount = 1
            viewApp.showBusyPage(qsTr("Please wait"),
                                 function(cycle){
                                     if(cycle >= cycleCount){
                                         viewApp.closeDialog();
                                     }
                                 })
        }//

        function getRpList(index){
            let data = control.viewOnly ? MachineData.rpListSelected : MachineData.rpListLast
            //data.push(value)
            if(data.length <= index){
                console.debug("RpList on index", index, "unavailaible!")
                return
            }
            return data[index]
        }//

        function setItemCode(saveToIndex, value, force){
            if(force === undefined) force = false
            MachineAPI.setReplaceablePartsSettings(saveToIndex, value)
            let name = getRpList(Number(saveToIndex-maxRow))
            let nameEmpty = String(name) == String("")
            let itemCodeAvailableOnDatabase = false

            const resetQty = value !== getRpList(Number(saveToIndex))
            console.debug("Quantity reset:", resetQty)

            for(let i=0; i<rpDatabase.length; i++){
                if(rpDatabase[i]['id'] === value){
                    itemCodeAvailableOnDatabase = true
                    if(nameEmpty || force)
                        name = rpDatabase[i]['desc']
                    break
                }
            }//

            if((nameEmpty || force) && itemCodeAvailableOnDatabase){
                /// Set the Description Automatically
                MachineAPI.setReplaceablePartsSettings((saveToIndex-maxRow), name)
            }//
            else{
                console.debug("name: \"%1\"".arg(name))
                if(!itemCodeAvailableOnDatabase)
                    console.debug("Item code", value, "not available!")
            }//
            /// Increase The Quantity
            let qty = Number(getRpList(Number(saveToIndex+maxRow)))
            console.debug("quantity", qty)
            if(Number.isNaN(qty)){
                console.debug("Not a Number!")
                qty = 1
            }
            else{
                console.debug("increased")
                qty++
            }
            if(resetQty) qty = 1
            console.debug("set quantity", qty)

            MachineAPI.setReplaceablePartsSettings((saveToIndex+maxRow), String(qty))
        }//
    }
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
