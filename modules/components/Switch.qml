import QtQuick

// A small toggle. `checked` stays owned by the caller so it can be bound to a
// service, and `toggled` reports the requested new state.
Rectangle {
    id: root

    property bool checked: false
    property color accentColor: "#ac1756b5"

    signal toggled(bool checked)

    implicitWidth: 34
    implicitHeight: 18
    radius: height / 2
    color: root.checked ? root.accentColor : "#4d4d4d"
    opacity: enabled ? 1 : 0.4

    Behavior on color {
        ColorAnimation {
            duration: 120
        }
    }

    Rectangle {
        id: knob

        width: parent.height - 4
        height: width
        radius: width / 2
        y: 2
        x: root.checked ? parent.width - width - 2 : 2
        color: "white"

        Behavior on x {
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutCubic
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.enabled
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggled(!root.checked)
    }
}
