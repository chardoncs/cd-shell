pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: cpuStat
    property double overallPercentage

    property int interval: 5000
    property int snapshotPollInterval: 500

    FileView {
        id: procStatSnapshot1
        path: Qt.resolvedUrl("/proc/stat")
        onLoadFailed: (err) => {
            console.error("snapshot1:", err);
        }
    }

    FileView {
        id: procStatSnapshot2
        path: Qt.resolvedUrl("/proc/stat")
        preload: false
        onLoaded: {
            const content = this.text().split("\n");
            const contentPrior = procStatSnapshot1.text().split("\n");

            const cpuTimes = content[0].split(" ").slice(2).map((item) => parseInt(item));
            const cpuTimesPrior = contentPrior[0].split(" ").slice(2).map((item) => parseInt(item));
            const cpuTimesDelta = cpuTimes.slice(0, 9).map((item, i) => item - cpuTimesPrior[i]);

            const idleTimesDelta = cpuTimesDelta.slice(3, 5);

            const totalIdleTimesDelta = idleTimesDelta.reduce((acc, cur) => acc += cur, 0);
            const totalTimesDelta = cpuTimesDelta.reduce((acc, cur) => acc += cur, 0);

            cpuStat.overallPercentage = 1 - totalIdleTimesDelta / totalTimesDelta;
        }
        onLoadFailed: (err) => {
            console.error("snapshot2:", err);
        }
    }

    Timer {
        id: timer1
        interval: cpuStat.interval
        running: true
        repeat: true
        onTriggered: procStatSnapshot1.reload()
    }

    Timer {
        id: timer2
        interval: cpuStat.interval
        running: false
        repeat: true
        onTriggered: procStatSnapshot2.reload()
    }

    Timer {
        id: delayedTrigger
        interval: cpuStat.snapshotPollInterval
        running: true
        onTriggered: {
            timer2.start();
            procStatSnapshot2.preload = true;
        }
    }
}
