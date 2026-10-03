import QtQuick
import Quickshell
import qs.services
import qs.utils

Row {
    spacing: 6

    Text {
        text: `CPU ${Percentage.toPercentage(CPU.overallPercentage)}`
        color: "white"
    }

    Text {
        text: "RAM 0%"
        color: "white"
    }
}
