import QtQuick
import Quickshell
import Niri

import "./modules"

ShellRoot {
    id: root

    Niri {
        id: niri
        Component.onCompleted: connect()

        onConnected: console.info("Conneted to Niri")
        onErrorOccurred: function (err) {
            console.error("Error:", err);
        }
    }

    LazyLoader {
        active: true
        component: Bar {}
    }
}
