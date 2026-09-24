import QtQuick
import qs.services

Row {
    leftPadding: 6
    rightPadding: 6
    spacing: 6

    Image {
        anchors.verticalCenter: parent.verticalCenter
        source: Niri.focusedWindow?.iconPath ? "file://" + Niri.focusedWindow?.iconPath : ""
        sourceSize {
            width: 16
            height: 16
        }
        visible: Niri.focusedWindow?.iconPath !== ""
        smooth: true
    }

    Text {
        text: truncateTitle(Niri.focusedWindow?.title ?? "")
        color: "white"

        function truncateTitle(title: string): string {
            let output = title.slice(0, 50);
            if (output.length < title.length) {
                output += "...";
            }
            return output;
        }
    }
}
