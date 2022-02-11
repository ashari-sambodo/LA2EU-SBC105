import QtQuick 2.2
import QtQuick.Controls 2.0

StackView {
    id: control

    replaceEnter: Transition {
        ScaleAnimator {
            from: 1.1
            to: 1
            duration: 200
            easing.type: Easing.OutCubic
        }
        //        YAnimator{
        //            from: 10
        //            to: 0
        //            duration: 200
        //            easing.type: Easing.OutCubic
        //        }
    }

    pushEnter: Transition {
        ScaleAnimator {
            from: 1.1
            to: 1
            duration: 200
            easing.type: Easing.OutCubic
        }
        //        YAnimator{
        //            from: 10
        //            to: 0
        //            duration: 200
        //            easing.type: Easing.OutCubic
        //        }
    }

    popEnter: Transition {
        ScaleAnimator {
            from: 1.1
            to: 1
            duration: 200
            easing.type: Easing.OutCubic
        }
        //        YAnimator{
        //            from: 10
        //            to: 0
        //            duration: 200
        //            easing.type: Easing.OutCubic
        //        }
    }

    popExit: Transition {}
    pushExit: Transition {}
    replaceExit: Transition {}
}
