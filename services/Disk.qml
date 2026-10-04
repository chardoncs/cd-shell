pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: diskStat

    property double percentage

    property int interval: 20_000

    Process {
        id: dfProc
        running: true
        command: ["df", "-h"]
        stdout: StdioCollector {
            onStreamFinished: {
                const content = this.text.split("\n");
                const mainDiskLine = content[1].split(" ");
                const percentageText = mainDiskLine[mainDiskLine.length - 2];
                diskStat.percentage = parseInt(percentageText) / 100;
            }
        }
    }

    Timer {
        interval: diskStat.interval
        running: true
        repeat: true
        onTriggered: dfProc.running = true
    }
}
