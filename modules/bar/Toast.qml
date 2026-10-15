import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import qs.modules.components

Rectangle {
    id: root

    required property var notification

    // Fallback auto-dismiss duration used when the notification does not
    // request one of its own.
    property int defaultTimeout: 6000

    readonly property bool critical: notification.urgency === NotificationUrgency.Critical
    readonly property bool autoDismiss: !root.critical && !notification.resident
    readonly property int timeout: notification.expireTimeout > 0 ? Math.round(notification.expireTimeout * 1000) : root.defaultTimeout
    readonly property string appIconSource: notification.appIcon !== "" ? Quickshell.iconPath(notification.appIcon, "") : ""

    // Set once the toast starts playing its exit animation so repeated
    // dismissals (hover timeout + click) only fire once.
    property bool closing: false

    function close() {
        if (root.closing) {
            return;
        }
        root.closing = true;
        exitAnimation.start();
    }

    color: root.critical ? "#2a1616" : "#1a1a1a"
    radius: 8
    border.width: 1
    border.color: root.critical ? "#e05a5a" : "#2f2f2f"
    implicitHeight: layout.implicitHeight + 24

    opacity: 0
    scale: 0.96

    Component.onCompleted: appearAnimation.start()

    ParallelAnimation {
        id: appearAnimation

        NumberAnimation {
            target: root
            property: "opacity"
            to: 1
            duration: 160
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: root
            property: "scale"
            to: 1
            duration: 160
            easing.type: Easing.OutCubic
        }
    }

    ParallelAnimation {
        id: exitAnimation

        NumberAnimation {
            target: root
            property: "opacity"
            to: 0
            duration: 140
            easing.type: Easing.InCubic
        }
        NumberAnimation {
            target: root
            property: "scale"
            to: 0.96
            duration: 140
            easing.type: Easing.InCubic
        }

        onStopped: {
            if (root.notification) {
                root.notification.dismiss();
            }
        }
    }

    // Background click target. Declared before the content so the content's
    // own mouse areas (close/actions) sit on top of it.
    MouseArea {
        id: hoverArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.close()
    }

    // Auto-dismiss, paused while the pointer is over the toast so it can be
    // read or interacted with.
    Timer {
        running: root.autoDismiss && !hoverArea.containsMouse && !root.closing
        interval: root.timeout
        onTriggered: root.close()
    }

    ColumnLayout {
        id: layout

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 12
        }
        spacing: 6

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Image {
                id: appIcon

                visible: root.appIconSource !== ""
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                source: root.appIconSource
                sourceSize: Qt.size(20, 20)
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            Icon {
                visible: !appIcon.visible
                Layout.alignment: Qt.AlignVCenter
                font.pixelSize: 16
                text: "󰂚" // bell
            }

            Text {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                text: root.notification.appName
                color: "#9a9a9a"
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            Rectangle {
                id: closeButton

                Layout.alignment: Qt.AlignVCenter
                implicitWidth: 20
                implicitHeight: 20
                radius: 10
                color: closeArea.containsMouse ? "#3a3a3a" : "transparent"

                Icon {
                    anchors.centerIn: parent
                    font.pixelSize: 14
                    text: "󰅖" // close
                }

                MouseArea {
                    id: closeArea

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.close()
                }
            }
        }

        Text {
            Layout.fillWidth: true
            visible: text !== ""
            text: root.notification.summary
            color: "white"
            font.bold: true
            wrapMode: Text.WordWrap
        }

        Text {
            Layout.fillWidth: true
            visible: text !== ""
            text: root.notification.body
            color: "#cfcfcf"
            wrapMode: Text.WordWrap
            maximumLineCount: 12
            elide: Text.ElideRight
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 2
            spacing: 8
            visible: actionRepeater.count > 0

            Item {
                Layout.fillWidth: true
            }

            Repeater {
                id: actionRepeater

                model: root.notification.actions

                Rectangle {
                    required property var modelData

                    implicitWidth: actionLabel.implicitWidth + 20
                    implicitHeight: 24
                    radius: 6
                    color: actionArea.containsMouse ? "#3a3a3a" : "#2a2a2a"

                    Text {
                        id: actionLabel

                        anchors.centerIn: parent
                        text: modelData.text
                        color: "white"
                        font.pixelSize: 12
                    }

                    MouseArea {
                        id: actionArea

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            modelData.invoke();
                            root.close();
                        }
                    }
                }
            }
        }
    }
}
