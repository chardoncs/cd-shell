import QtQuick
import Quickshell
import qs.services

Scope {
    id: root

    PanelWindow {
        id: toastWindow

        // Notifications follow the primary screen, matching where the bar
        // loads this component (see modules/Bar.qml).
        screen: Quickshell.screens.length > 0 ? Quickshell.screens[0] : null

        anchors {
            top: true
            right: true
        }
        margins {
            top: 38 // clears the 30px bar plus a small gap
            right: 8
        }

        implicitWidth: 380
        implicitHeight: stack.childrenRect.height
        color: "transparent"
        exclusiveZone: 0
        focusable: false
        visible: stack.childrenRect.height > 0

        Column {
            id: stack

            width: parent.width
            spacing: 8

            Repeater {
                model: Notifications.trackedNotifications

                Toast {
                    required property var modelData

                    notification: modelData
                    defaultTimeout: Notifications.defaultTimeout
                    width: stack.width
                }
            }
        }
    }
}
