import QtQuick
import QtQuick.Layouts

Rectangle {
    color: "transparent"

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter

        Icon {}
        Workspaces {}
        WindowTitle {}
    }
}
