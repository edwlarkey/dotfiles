import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import ".."

Scope {
    PanelWindow {
        id: win
        visible: Notifications.managerOpen
        color: "transparent"
        exclusiveZone: 0
        exclusionMode: ExclusionMode.Normal
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
        WlrLayershell.namespace: "linuxplatinum-notif-manager"

        anchors {
            top: true
            right: true
        }
        margins {
            top: 0
            right: 0
        }

        implicitWidth: Config.notifications.managerWidth
        implicitHeight: Config.notifications.managerHeight

        HyprlandFocusGrab {
            active: win.visible
            windows: [win]
            onCleared: {
                if (Notifications.managerOpen)
                    Notifications.closeManager();
            }
        }

        Rectangle {
            id: frame
            anchors.fill: parent
            color: Config.colors.base
            Bevel {}

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 4
                spacing: 6

                PlatinumTitleBar {
                    Layout.fillWidth: true
                    title: "Notification Manager"
                    onCloseClicked: Notifications.closeManager()
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: Config.colors.outline
                }

                Rectangle {
                    id: listWell
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Config.colors.highlight
                    border.width: 1
                    border.color: Config.colors.outline

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        height: 1
                        color: Config.colors.shadow
                    }
                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 1
                        color: Config.colors.shadow
                    }

                    ListView {
                        id: list
                        anchors.fill: parent
                        anchors.margins: 2
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds
                        model: Notifications.tracked
                        spacing: 0

                        delegate: NotificationRow {
                            width: list.width
                        }
                    }

                    Text {
                        visible: Notifications.count === 0
                        anchors.centerIn: parent
                        text: "No notifications"
                        font.family: fontCharcoal.name
                        font.pixelSize: 13
                        color: Config.colors.dark
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 26

                    PlatinumButton {
                        anchors.right: parent.right
                        text: "Clear All"
                        enabled: Notifications.count > 0
                        onClicked: Notifications.dismissAll()
                    }
                }
            }
        }
    }
}
