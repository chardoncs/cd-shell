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

    // Notifications raised by the shell itself, e.g. connection changes. They
    // are kept apart from the server's model because those objects are owned by
    // the D-Bus service, and they render through the same toasts.
    //
    // A ListModel rather than a plain array: replacing an array makes every
    // Repeater delegate rebuild, which would restart the toasts' dismissal
    // countdown whenever one of them is removed.
    readonly property ListModel internalNotifications: ListModel {}

    readonly property int maxInternalNotifications: 4

    // Fallback auto-dismiss duration (ms) used when a notification does not
    // request its own timeout.
    readonly property int defaultTimeout: 6000

    function notify(options: var): void {
        const notification = internalNotificationComponent.createObject(root, {
            appName: options.appName ?? "",
            appIcon: options.appIcon ?? "",
            glyph: options.glyph ?? "",
            summary: options.summary ?? "",
            body: options.body ?? "",
            urgency: options.urgency ?? NotificationUrgency.Normal,
        });

        if (notification === null) {
            console.warn("failed to create internal notification");
            return;
        }

        // Keep the stack readable when several events land at once.
        while (root.internalNotifications.count >= root.maxInternalNotifications) {
            const oldest = root.internalNotifications.get(0).entry;

            if (oldest === undefined) {
                break;
            }

            oldest.dismiss();
        }

        root.internalNotifications.append({ entry: notification });
    }

    function remove(notification: var): void {
        for (var i = 0; i < root.internalNotifications.count; i++) {
            if (root.internalNotifications.get(i).entry === notification) {
                root.internalNotifications.remove(i);
                break;
            }
        }

        Qt.callLater(() => notification.destroy());
    }

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

    // Mirrors the shape of a D-Bus notification so the same Toast can render
    // both.
    Component {
        id: internalNotificationComponent

        QtObject {
            property string appName: ""
            property string appIcon: ""
            property string glyph: ""
            property string summary: ""
            property string body: ""
            property int urgency: NotificationUrgency.Normal
            property bool resident: false
            property int expireTimeout: 0
            property var actions: []

            function dismiss() {
                Notifications.remove(this);
            }
        }
    }
}
