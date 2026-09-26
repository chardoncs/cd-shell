import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray
import qs.modules.components

Row {
    spacing: 4

    rightPadding: 10

    Repeater {
        model: SystemTray.items

        MouseArea {
            id: trayItem
            width: 24
            height: 24
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            required property var modelData

            Image {
                anchors.centerIn: parent
                width: 16
                height: 16
                source: trayItem.modelData.icon
                sourceSize: Qt.size(16, 16)
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            onClicked: (mouse) => {
                switch (mouse.button) {
                case Qt.LeftButton:
                    if (!modelData.onlyMenu) {
                        modelData.activate();
                    } else if (modelData.hasMenu) {
                        menuAnchor.open();
                    }
                    break;

                case Qt.MiddleButton:
                    modelData.secondaryActivate();
                    break;

                case Qt.RightButton:
                    menuAnchor.open();
                    break;
                }
            }

            onWheel: (ev) => {
                modelData.scroll(ev.angleData.y / 120, false);
            }

            onEntered: {
                tooltip.open();
            }

            onExited: {
                tooltip.close();
            }

            Tooltip {
                id: tooltip
                anchorItem: trayItem
                text: trayItem.modelData.tooltipTitle || trayItem.modelData.title
            }

            QsMenuAnchor {
                id: menuAnchor
                menu: trayItem.modelData.menu
                anchor {
                    window: bar
                    item: trayItem
                    edges: Edges.Bottom | Edges.Left
                }
            }
        }
    }
}
