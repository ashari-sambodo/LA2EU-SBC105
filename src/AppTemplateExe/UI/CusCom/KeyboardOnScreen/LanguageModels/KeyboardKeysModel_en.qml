import QtQuick 2.0

Item {

    property alias firstRowModel    : firstRowListModel
    property alias secondRowModel   : secondRowListModel
    property alias thirdRowModel    : thirdRowListModel
    property alias fourthRowModel   : fourthRowListModel

    ListModel{
        id: firstRowListModel

        ListElement{
            firstKey   : "1"
            secondKey  : "1"
            thirdKey   : "1"
        }

        ListElement{
            firstKey   : "2"
            secondKey  : "2"
            thirdKey   : "2"
        }

        ListElement{
            firstKey   : "3"
            secondKey  : "3"
            thirdKey   : "3"
        }

        ListElement{
            firstKey   : "4"
            secondKey  : "4"
            thirdKey   : "4"
        }

        ListElement{
            firstKey   : "5"
            secondKey  : "5"
            thirdKey   : "5"
        }

        ListElement{
            firstKey   : "6"
            secondKey  : "6"
            thirdKey   : "6"
        }

        ListElement{
            firstKey   : "7"
            secondKey  : "7"
            thirdKey   : "7"
        }

        ListElement{
            firstKey   : "8"
            secondKey  : "8"
            thirdKey   : "8"
        }

        ListElement{
            firstKey   : "9"
            secondKey  : "9"
            thirdKey   : "9"
        }

        ListElement{
            firstKey   : "0"
            secondKey  : "0"
            thirdKey   : "0"
        }
    }

    ListModel{
        id: secondRowListModel

        ListElement{
            firstKey   : "q"
            secondKey  : "Q"
            thirdKey   : "-"
        }

        //        ListElement{
        //            firstKey   : "ふ"
        //            secondKey  : "て"
        //            thirdKey   : "た"
        //        }

        ListElement{
            firstKey   : "w"
            secondKey  : "W"
            thirdKey   : "/"
        }

        ListElement{
            firstKey   : "e"
            secondKey  : "E"
            thirdKey   : ":"
        }

        ListElement{
            firstKey   : "r"
            secondKey  : "R"
            thirdKey   : ";"
        }

        ListElement{
            firstKey   : "t"
            secondKey  : "T"
            thirdKey   : "("
        }

        ListElement{
            firstKey   : "y"
            secondKey  : "Y"
            thirdKey   : ")"
        }

        ListElement{
            firstKey   : "u"
            secondKey  : "U"
            thirdKey   : "$"
        }

        ListElement{
            firstKey   : "i"
            secondKey  : "I"
            thirdKey   : "!"
        }

        ListElement{
            firstKey   : "o"
            secondKey  : "O"
            thirdKey   : "+"
        }

        ListElement{
            firstKey   : "p"
            secondKey  : "P"
            thirdKey   : "\""
        }
    }

    ListModel{
        id: thirdRowListModel

        ListElement{
            firstKey   : "a"
            secondKey  : "A"
            thirdKey   : "?"
        }

        ListElement{
            firstKey   : "s"
            secondKey  : "S"
            thirdKey   : "["
        }

        ListElement{
            firstKey   : "d"
            secondKey  : "D"
            thirdKey   : "="
        }

        ListElement{
            firstKey   : "f"
            secondKey  : "F"
            thirdKey   : "~"
        }

        ListElement{
            firstKey   : "g"
            secondKey  : "G"
            thirdKey   : "<"
        }

        ListElement{
            firstKey   : "h"
            secondKey  : "H"
            thirdKey   : "*"
        }

        ListElement{
            firstKey   : "j"
            secondKey  : "J"
            thirdKey   : "^"
        }

        ListElement{
            firstKey   : "k"
            secondKey  : "K"
            thirdKey   : "]"
        }

        ListElement{
            firstKey   : "l"
            secondKey  : "L"
            thirdKey   : "#"
        }

        ListElement{
            firstKey   : "m"
            secondKey  : "M"
            thirdKey   : "%"
        }
    }

    ListModel{
        id: fourthRowListModel

        ListElement{
            firstKey   : "z"
            secondKey  : "Z"
            thirdKey   : "."
        }

        ListElement{
            firstKey   : "x"
            secondKey  : "X"
            thirdKey   : ","
        }

        ListElement{
            firstKey   : "c"
            secondKey  : "C"
            thirdKey   : "@"
        }

        ListElement{
            firstKey   : "v"
            secondKey  : "V"
            thirdKey   : "|"
        }

        ListElement{
            firstKey   : "b"
            secondKey  : "B"
            thirdKey   : "\\"
        }

        ListElement{
            firstKey   : "n"
            secondKey  : "N"
            thirdKey   : "&"
        }
    }
}
