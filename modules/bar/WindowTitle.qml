import QtQuick

Text {
    text: truncateTitle(niri.focusedWindow?.title ?? "")
    color: "white"
    leftPadding: 10

    function truncateTitle(title: string): string {
        let output = title.slice(0, 50);
        if (output.length < title.length) {
            output += "...";
        }
        return output;
    }
}
