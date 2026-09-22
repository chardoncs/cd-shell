import QtQuick

Row {
    leftPadding: 6
    spacing: 6

    Image {
        anchors.verticalCenter: parent.verticalCenter
        source: niri.focusedWindow?.iconPath ? "file://" + niri.focusedWindow?.iconPath : ""
        sourceSize {
            width: 16
            height: 16
        }
        visible: niri.focusedWindow?.iconPath !== ""
        smooth: true
    }

    Text {
        text: truncateTitle(niri.focusedWindow?.title ?? "")
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
