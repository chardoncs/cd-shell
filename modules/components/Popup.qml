import QtQuick
import Quickshell

// A dark panel that hangs below a bar item. Children are stacked into a
// column, so a window only needs to declare its rows.
PopupWindow {
    id: root

    required property var anchorItem
    property int contentWidth: 360

    // Space between the bar and the panel, so the popup does not touch it.
    readonly property int gap: 6

    default property alias contentData: contentColumn.data

    visible: false
    grabFocus: true // dismiss when clicking outside the window
    color: "transparent"

    implicitWidth: contentWidth
    implicitHeight: panel.implicitHeight

    anchor {
        item: root.anchorItem
        edges: Edges.Bottom | Edges.Right
        gravity: Edges.Bottom | Edges.Left

        // Grow the anchor rect downwards so the panel starts below the bar.
        margins {
            bottom: -root.gap
        }
    }

    Rectangle {
        id: panel

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        implicitHeight: contentColumn.implicitHeight + 24
        radius: 12
        color: "#f21b1b1b"
        border.width: 1
        border.color: "#33ffffff"

        Column {
            id: contentColumn

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: 12
                leftMargin: 12
                rightMargin: 12
            }
            spacing: 8
        }
    }
}
