import QtQuick
import Quickshell
import Quickshell.Wayland
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

        // Niri (and other compositors) draw focused fullscreen windows above
        // the top layer, so the bar stays hidden behind them. Only the overlay
        // layer renders above fullscreen, so toasts live there while the bar
        // remains on the top layer.
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell-toast"

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

            Repeater {
                model: Notifications.internalNotifications

                // The wrapper is needed because only an inline delegate can
                // read the model's role; Toast itself is a separate component.
                Item {
                    required property var model

                    width: stack.width
                    height: toast.implicitHeight

                    Toast {
                        id: toast

                        width: parent.width
                        notification: model.entry
                        defaultTimeout: Notifications.defaultTimeout
                    }
                }
            }
        }
    }
}
