import QtQuick
import QtQuick.Layouts
import Quickshell

import "./bar"

Scope {
    Variants {
        model: Quickshell.screens
        PanelWindow { // qmllint disable uncreatable-type
            id: bar
            required property var modelData

            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30
            color: "transparent"

            Backdrop {}

            RowLayout {
                anchors.fill: parent

                LeftSection {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                CenterSection {
                    Layout.fillWidth: false
                    Layout.fillHeight: true
                }
                RightSection {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
    }
}
