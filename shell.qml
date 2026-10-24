//@ pragma UseQApplication

import QtQuick
import Quickshell

import qs.modules
import qs.services

ShellRoot {
    id: root

    // Referencing the singleton instantiates it, so network and bluetooth
    // connection changes are reported as toasts regardless of which bar
    // windows happen to be open.
    readonly property var connectionMonitor: ConnectionMonitor

    LazyLoader {
        active: true
        component: Bar {}
    }
}
