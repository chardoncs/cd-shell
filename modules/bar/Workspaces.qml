import QtQuick
import QtQuick.Layouts

Rectangle {
    color: "transparent"

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter

        Layout.fillHeight: true

        Repeater {
            model: SortFilterProxyModel {
                model: niri.workspaces
                filters: [
                    FunctionFilter {
                        component RoleData: QtObject { property string output }
                        function filter(data: RoleData): bool {
                            return data.output === bar.screen.name
                        }
                    }
                ]
            }

            Item {
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
                Layout.alignment: Qt.AlignCenter

                Rectangle {
                    anchors.centerIn: parent

                    id: indexRect
                    color: "#7f3c3c3c"
                    width: 24
                    height: 24
                    radius: 6

                    states: State {
                        name: "active"; when: isActive
                        PropertyChanges {
                            target: indexRect
                            width: 20; height: 20
                            radius: 20
                            color: "#e4e4e4"
                        }
                        PropertyChanges {
                            target: indexText
                            color: "black"
                        }
                    }

                    transitions: Transition {
                        from: "*"
                        to: "*"
                        reversible: true

                        SequentialAnimation {
                            NumberAnimation { properties: "radius,width,height"; duration: 100 }
                            ColorAnimation { duration: 100 }
                        }
                    }

                    Text {
                        id: indexText
                        anchors.centerIn: parent

                        text: index
                        color: "white"
                    }
                }
            }
        }
    }
}
