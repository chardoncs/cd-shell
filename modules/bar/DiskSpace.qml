import QtQuick
import Quickshell
import qs.services
import qs.utils

Row {
    spacing: 6

    Text {
        text: ` ${Percentage.toPercentage(Disk.percentage)}`
        color: "white"
    }
}
