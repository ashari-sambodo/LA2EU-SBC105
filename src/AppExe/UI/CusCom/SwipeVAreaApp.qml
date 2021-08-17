import QtQuick 2.9

Flickable{
    flickableDirection: Flickable.VerticalFlick
    signal swipeUp()
    signal swipeBottom()
    property bool debugSwipe: false
    property int swipeOffset: 100
    property bool swiped: false
    onVerticalOvershootChanged: {
        if((verticalOvershoot > 0)
                && (verticalOvershoot > swipeOffset)
                && !swiped){
            if(debugSwipe) console.debug("swipe up")
            swiped = true
            swipeUp()
        }

        if((verticalOvershoot < 0)
                && (verticalOvershoot < -swipeOffset)
                && !swiped){
            if(debugSwipe) console.debug("swipe bottom")
            swiped = true
            swipeBottom()
        }
        if((verticalOvershoot == 0) && (swiped)) swiped = false
    }
}
