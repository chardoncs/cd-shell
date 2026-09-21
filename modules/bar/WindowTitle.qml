import QtQuick

Text {
    text: niri.focusedWindow?.title ?? ""
    color: "white"
    leftPadding: 10
}
