pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    // Exposed so consumers (e.g. the bar's ToastSystem) can render
    // notifications without owning the D-Bus server themselves.
    readonly property var server: notificationServer
    readonly property var trackedNotifications: notificationServer.trackedNotifications

    // Fallback auto-dismiss duration (ms) used when a notification does not
    // request its own timeout.
    readonly property int defaultTimeout: 6000

    NotificationServer {
        id: notificationServer

        inlineReplySupported: false
        bodySupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        bodyHyperlinksSupported: true
        actionsSupported: true
        actionIconsSupported: false
        imageSupported: true
        persistenceSupported: false
        keepOnReload: false

        onNotification: (notification) => {
            notification.tracked = true;
        }
    }
}
