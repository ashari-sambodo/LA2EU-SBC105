import QtQuick 2.6
import QtQuick.Controls 2.0

ComboBox {
    id: control

    property color currentTextColor: "#ffffff"
    property color popupTextColor: "#ffffff"

    property color colorArrow: "#ffffff"

    property alias backgroundColor: backgroundControl.color
    property alias backgroundBorderColor: backgroundControl.border.color

    property alias backgroundPopupColor: popupBackground.color
    property alias backgroundPopupBorderColor: popupBackground.border.color


    delegate: ItemDelegate {
        width: control.width
        contentItem: Text {
            text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
            color: control.currentTextColor
            font: control.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        highlighted: control.highlightedIndex === index
    }

    indicator: Canvas {
        id: canvas
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 12
        height: 8
        contextType: "2d"

        Connections {
            target: control
            onPressedChanged: canvas.requestPaint()
        }

        onPaint: {
            context.reset();
            context.moveTo(0, 0);
            context.lineTo(width, 0);
            context.lineTo(width / 2, height);
            context.closePath();
            context.fillStyle = control.colorArrow
            context.fill();
        }
    }

    contentItem: Text {
        leftPadding: 5
        rightPadding: control.indicator.width + control.spacing

        text: control.displayText
        font: control.font
        color: "#ffffff"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        id: backgroundControl
        implicitWidth: 120
        implicitHeight: 40
        border.color: "#80808080"
        border.width: control.visualFocus ? 2 : 1
        radius: 5
        color: "#696969"
    }

    popup: Popup {
        y: control.height - 1
        width: control.width
        implicitHeight: contentItem.implicitHeight
        padding: 1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            //            model: control.popup.visible ? control.delegateModel : null
            model: control.popup.visible ? control.model : null
            currentIndex: control.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator { }

            delegate: ItemDelegate {
                width: control.width
                contentItem: Text {
                    text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                    font: control.font
                    color: control.popupTextColor
                }

                onPressed: {
                    //                    console.log("Press")
                    control.currentIndex = index
                    control.activated(index);
                    control.popup.close()
                }
            }
        }

        background: Rectangle {
            id: popupBackground
            border.color: "#C0C0C0"
            radius: 5
            color: "#696969"
        }
    }
}
