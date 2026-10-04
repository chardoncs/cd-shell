pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: memStat

    property double percentage

    property int interval: 5000

    FileView {
        id: procMeminfo
        path: Qt.resolvedUrl("/proc/meminfo")
        onLoaded: {
            const content = this.text().split("\n");

            const memTotalLine = content[0].split(" ");
            const memAvailableLine = content[2].split(" ");

            const totalValue = parseInt(memTotalLine[memTotalLine.length - 2]);
            const availableValue = parseInt(memAvailableLine[memAvailableLine.length - 2]);

            memStat.percentage = 1 - availableValue / totalValue;
        }
        onLoadFailed: (err) => {
            console.error("mem:", err);
        }
    }

    Timer {
        interval: memStat.interval
        running: true
        repeat: true
        onTriggered: procMeminfo.reload()
    }
}
