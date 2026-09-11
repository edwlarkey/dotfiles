import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import ".."

PanelWindow {
    id: root

    // Classic Mac OS 8/9 palette
    readonly property color macBase: "#c8c8c8"
    readonly property color macHighlight: "#ffffff"
    readonly property color macShadow: "#808080"
    readonly property color macDarkShadow: "#404040"
    readonly property color macText: "#000000"
    readonly property color macButtonFace: "#c8c8c8"
    readonly property color macButtonPressed: "#a8a8a8"

    property bool isExpanded: false
    property real hiddenOpacity: Config.settings.macDock ? Config.settings.macDock.hiddenOpacity : 0.0

    readonly property var entries: [
        {"name": "Terminal", "type": "app", "command": "ghostty", "iconName": "utilities-terminal"},
        {"name": "Browser", "type": "app", "command": "firefox", "iconName": "firefox"},
        {"name": "Files", "type": "folder", "path": "/home/edwlarkey", "iconName": "system-file-manager"},
        {"name": "Documents", "type": "folder", "path": "/home/edwlarkey/Sync/docs", "iconName": "folder-documents"},
    ]

    screen: Quickshell.screens[0]
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    anchors {
        bottom: true
        left: true
    }
    
    height: 32
    implicitWidth: dockContent.implicitWidth

    color: "transparent"

    Item {
        id: dockContent
        height: parent.height
        implicitWidth: layoutRow.implicitWidth
        opacity: 1.0

        Row {
            id: layoutRow
            height: parent.height

            // --- Modules Area ---
            Item {
                id: contentArea
                height: parent.height
                // Animate width between 0 (collapsed) and implicit width (expanded)
                width: root.isExpanded ? contentRow.implicitWidth : 0
                clip: true // Hide contents when width is shrinking

                Behavior on width {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    color: macBase
                }

                // Top & bottom bevels for the main strip
                Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; height: 1; color: macHighlight }
                Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 1; color: macDarkShadow }
                Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.bottomMargin: 1; height: 1; color: macShadow }

                Row {
                    id: contentRow
                    height: parent.height

                    // 1. Applications & Folders Module
                    Repeater {
                        model: root.entries
                        delegate: Item {
                            required property var modelData
                            width: 36
                            height: parent.height

                            Rectangle {
                                anchors.fill: parent
                                color: btnArea.pressed ? macButtonPressed : (btnArea.containsMouse ? "#b8b8b8" : "transparent")
                            }

                            // Application Icon
                            Image {
                                anchors.centerIn: parent
                                width: 22
                                height: 22
                                source: modelData.iconName ? (Quickshell.iconPath(modelData.iconName, true) || "") : ""
                                sourceSize: Qt.size(width, height)
                            }

                            // Separator
                            Rectangle { anchors.right: parent.right; anchors.rightMargin: 1; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: macShadow }
                            Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: macHighlight }

                            MouseArea {
                                id: btnArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (modelData.type === "folder") {
                                        Quickshell.execDetached(["thunar", modelData.path]);
                                    } else {
                                        Quickshell.execDetached(modelData.command);
                                    }
                                }
                            }
                        }
                    }

                    // 2. Clock Module
                    Item {
                        width: 150
                        height: parent.height

                        Rectangle {
                            anchors.fill: parent
                            color: clkArea.pressed ? macButtonPressed : (clkArea.containsMouse ? "#b8b8b8" : "transparent")
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            spacing: 6

                            Image {
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 16
                                source: Quickshell.iconPath("preferences-system-time", true) || ""
                                sourceSize: Qt.size(16, 16)
                            }
                            Text {
                                Layout.fillWidth: true
                                text: Time.time
                                font.family: fontCharcoal.name
                                font.pixelSize: 11
                                color: macText
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        // Separator
                        Rectangle { anchors.right: parent.right; anchors.rightMargin: 1; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: macShadow }
                        Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: macHighlight }

                        MouseArea {
                            id: clkArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                        }
                    }

                    // 3. Settings Module
                    Item {
                        width: 36
                        height: parent.height

                        Rectangle {
                            anchors.fill: parent
                            color: setArea.pressed ? macButtonPressed : (setArea.containsMouse ? "#b8b8b8" : "transparent")
                        }

                        Image {
                            anchors.centerIn: parent
                            width: 20
                            height: 20
                            source: Quickshell.iconPath("preferences-desktop", true) || ""
                            sourceSize: Qt.size(20, 20)
                        }

                        // Separator
                        Rectangle { anchors.right: parent.right; anchors.rightMargin: 1; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: macShadow }
                        Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: macHighlight }

                        MouseArea {
                            id: setArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Config.openSettingsWindow = !Config.openSettingsWindow;
                            }
                        }
                    }
                }
            }

            // --- Pull Tab ---
            Item {
                id: pullTab
                width: 16
                height: parent.height

                Rectangle {
                    anchors.fill: parent
                    color: macBase
                    radius: 4
                    Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 4; color: macBase }
                }

                Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.rightMargin: 2; anchors.top: parent.top; height: 1; color: macHighlight }
                Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: 2; anchors.bottom: parent.bottom; anchors.bottomMargin: 2; width: 1; color: macDarkShadow }
                Rectangle { anchors.right: parent.right; anchors.rightMargin: 1; anchors.top: parent.top; anchors.topMargin: 1; anchors.bottom: parent.bottom; anchors.bottomMargin: 1; width: 1; color: macShadow }
                Rectangle { anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; anchors.rightMargin: 2; height: 1; color: macDarkShadow }
                Rectangle { anchors.bottom: parent.bottom; anchors.bottomMargin: 1; anchors.left: parent.left; anchors.right: parent.right; anchors.rightMargin: 1; height: 1; color: macShadow }

                Column {
                    anchors.centerIn: parent
                    spacing: 2
                    Repeater {
                        model: 3
                        Rectangle { 
                            width: 4; height: 2; color: macHighlight
                            Rectangle { anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; height: 1; color: macShadow }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.isExpanded = !root.isExpanded
                    }
                }
            }
        }
    }

    // --- Auto-Hide Behavior ---
    HoverHandler {
        id: dockHover
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onHoveredChanged: {
            if (dockHover.hovered) {
                hideTimer.stop();
                root.isExpanded = true;
            } else {
                hideTimer.start();
            }
        }
    }

    Timer {
        id: hideTimer
        interval: 600
        repeat: false
        onTriggered: {
            if (!dockHover.containsMouse) {
                root.isExpanded = false;
            }
        }
    }
}
