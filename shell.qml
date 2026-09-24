import QtQuick
import Quickshell

import qs.modules

ShellRoot {
    id: root

    LazyLoader {
        active: true
        component: Bar {}
    }
}
