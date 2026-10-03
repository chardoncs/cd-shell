import QtQuick
import QtQuick.Layouts

Rectangle {
    color: "transparent"

    RowLayout {
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        spacing: 8
        layoutDirection: Qt.RightToLeft

        Tray {}
        PowerProfile {}
        Battery {}
        Networks {}
        PipewireDevices {}
        PerformanceStats {}
        DiskSpace {}
    }
}
