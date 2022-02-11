import QtQuick 2.9

Flickable{
    flickableDirection: Flickable.HorizontalFlick
    signal swipeLeft()
    signal swipeRight()
    property bool debugSwipe: false
    property int swipeOffset: 100
    property bool swiped: false
    onHorizontalOvershootChanged: {
        if((horizontalOvershoot > 0)
                && (horizontalOvershoot > swipeOffset)
                && !swiped){
            if(debugSwipe) console.debug("swipe left")
            swiped = true
            swipeLeft()
        }

        if((horizontalOvershoot < 0)
                && (horizontalOvershoot < -swipeOffset)
                && !swiped){
            if(debugSwipe) console.debug("swipe right")
            swiped = true
            swipeRight()
        }
        if((horizontalOvershoot == 0) && (swiped)) swiped = false
    }
}
