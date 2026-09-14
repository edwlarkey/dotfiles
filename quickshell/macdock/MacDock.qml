import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import ".."
import "../popups" as Popups

Scope {
    id: root

    readonly property color macBase: "#c8c8c8"
    readonly property color macHighlight: "#ffffff"
    readonly property color macShadow: "#808080"
    readonly property color macDarkShadow: "#404040"
    readonly property color macText: "#000000"
    readonly property color macButtonFace: "#c8c8c8"
    readonly property color macButtonPressed: "#a8a8a8"

    property bool isExpanded: false
    property bool popupOpen: false
    property real hiddenOpacity: Config.settings.macDock ? Config.settings.macDock.hiddenOpacity : 0.0
    property Item hoveredItem: null
    property string hoveredLabel: ""
    readonly property int tipSpace: 22

    function showDockTip(item, text) {
        if (root.popupOpen || !item || !text)
            return;
        hoveredItem = item;
        hoveredLabel = text;
    }

    function hideDockTip() {
        hoveredItem = null;
        hoveredLabel = "";
    }

    readonly property var entries: [
        {"name": "Terminal", "type": "app", "command": "ghostty", "iconName": "utilities-terminal"},
        {"name": "Browser", "type": "app", "command": "firefox", "iconName": "firefox"},
        {"name": "Files", "type": "folder", "path": "/home/edwlarkey", "iconName": "system-file-manager"},
        {"name": "Documents", "type": "folder", "path": "/home/edwlarkey/Sync/docs", "iconName": "folder-documents"},
    ]

    PanelWindow {
        id: dock

        screen: Quickshell.screens[0]
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        anchors {
            bottom: true
            left: true
        }

        implicitHeight: 32 + root.tipSpace
        implicitWidth: contentRow.implicitWidth + pullTab.width
        exclusionMode: ExclusionMode.Ignore

        mask: Region {
            x: 0
            y: (root.isExpanded || slideAnim.running) ? 0 : root.tipSpace
            height: (root.isExpanded || slideAnim.running) ? dock.height : 32
            width: (root.isExpanded || slideAnim.running) ? dock.implicitWidth : pullTab.width
        }

        color: "transparent"

        Item {
            id: tipHost
            anchors.fill: parent

            Rectangle {
                id: tipBox
                visible: root.hoveredLabel !== "" && root.isExpanded
                z: 20
                x: {
                    if (!root.hoveredItem)
                        return 0;
                    const p = root.hoveredItem.mapToItem(tipHost, 0, 0);
                    return Math.max(0, Math.round(p.x + (root.hoveredItem.width - width) / 2));
                }
                y: 2
                width: tipLabel.implicitWidth + 14
                height: tipLabel.implicitHeight + 6
                color: "#ffffcc"
                border.color: "#000000"
                border.width: 1

                Text {
                    id: tipLabel
                    anchors.centerIn: parent
                    text: root.hoveredLabel
                    font.family: fontCharcoal.name
                    font.pixelSize: 11
                    color: "#000000"
                }
            }

            Item {
                id: dockContent
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 32
                clip: true

            Row {
                id: layoutRow
                height: parent.height
                x: root.isExpanded ? 0 : -contentRow.implicitWidth

                Behavior on x {
                    NumberAnimation {
                        id: slideAnim
                        duration: 220
                        easing.type: Easing.OutCubic
                    }
                }

                Item {
                    id: contentArea
                    height: parent.height
                    width: contentRow.implicitWidth

                    Rectangle {
                        anchors.fill: parent
                        color: macBase
                    }

                    Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; height: 1; color: macHighlight }
                    Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 1; color: macDarkShadow }
                    Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.bottomMargin: 1; height: 1; color: macShadow }

                    Row {
                        id: contentRow
                        height: parent.height

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

                                Image {
                                    anchors.centerIn: parent
                                    width: 22
                                    height: 22
                                    source: modelData.iconName ? (Quickshell.iconPath(modelData.iconName, true) || "") : ""
                                    sourceSize: Qt.size(width, height)
                                }

                                Rectangle { anchors.right: parent.right; anchors.rightMargin: 1; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: macShadow }
                                Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: macHighlight }

                                MouseArea {
                                    id: btnArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onContainsMouseChanged: {
                                        if (containsMouse)
                                            root.showDockTip(parent, modelData.name);
                                        else
                                            root.hideDockTip();
                                    }
                                    onClicked: {
                                        if (modelData.type === "folder") {
                                            Quickshell.execDetached(["thunar", modelData.path]);
                                        } else {
                                            Quickshell.execDetached([modelData.command]);
                                        }
                                    }
                                }
                            }
                        }

                        Item {
                            id: minSlot
                            width: 36
                            height: parent.height

                            Rectangle {
                                anchors.fill: parent
                                color: minArea.pressed || root.popupOpen ? macButtonPressed : (minArea.containsMouse ? "#b8b8b8" : "transparent")
                            }

                            Column {
                                anchors.centerIn: parent
                                spacing: 3
                                Repeater {
                                    model: 2
                                    Rectangle {
                                        width: 14
                                        height: 3
                                        color: macDarkShadow
                                        Rectangle {
                                            anchors.top: parent.top
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            height: 1
                                            color: macHighlight
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                visible: minimizedPopup.count > 0
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                anchors.margins: 2
                                width: minimizedPopup.count > 9 ? 16 : 12
                                height: 10
                                color: macDarkShadow
                                Text {
                                    anchors.centerIn: parent
                                    text: minimizedPopup.count > 9 ? "9+" : "" + minimizedPopup.count
                                    font.family: fontCharcoal.name
                                    font.pixelSize: 8
                                    color: macHighlight
                                }
                            }

                            Rectangle { anchors.right: parent.right; anchors.rightMargin: 1; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: macShadow }
                            Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: macHighlight }

                            MouseArea {
                                id: minArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onContainsMouseChanged: {
                                    if (containsMouse)
                                        root.showDockTip(minSlot, minimizedPopup.count > 0 ? "Minimized (" + minimizedPopup.count + ")" : "Minimized");
                                    else
                                        root.hideDockTip();
                                }
                                onClicked: {
                                    root.hideDockTip();
                                    if (root.popupOpen) {
                                        minimizedPopup.closeMinimized();
                                    } else {
                                        hideTimer.stop();
                                        root.isExpanded = true;
                                        root.popupOpen = true;
                                        minimizedPopup.openMinimized();
                                    }
                                }
                            }
                        }

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

                            Rectangle { anchors.right: parent.right; anchors.rightMargin: 1; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: macShadow }
                            Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: macHighlight }

                            MouseArea {
                                id: clkArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onContainsMouseChanged: {
                                    if (containsMouse)
                                        root.showDockTip(parent, "Clock");
                                    else
                                        root.hideDockTip();
                                }
                            }
                        }

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

                            Rectangle { anchors.right: parent.right; anchors.rightMargin: 1; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: macShadow }
                            Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: macHighlight }

                            MouseArea {
                                id: setArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onContainsMouseChanged: {
                                    if (containsMouse)
                                        root.showDockTip(parent, "Settings");
                                    else
                                        root.hideDockTip();
                                }
                                onClicked: {
                                    Config.openSettingsWindow = !Config.openSettingsWindow;
                                }
                            }
                        }
                    }
                }

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
        }

        Popups.MinimizedWindows {
            id: minimizedPopup
            anchor.window: dock
            anchor.item: minSlot
            anchor.edges: Edges.Bottom | Edges.Left
            anchor.gravity: Edges.Top | Edges.Right
            closeCallback: function () {
                root.popupOpen = false;
                hideTimer.start();
            }
        }

        HoverHandler {
            id: dockHover
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            onHoveredChanged: {
                if (dockHover.hovered) {
                    hideTimer.stop();
                    root.isExpanded = true;
                } else if (!root.popupOpen) {
                    root.hideDockTip();
                    hideTimer.start();
                }
            }
        }

        Timer {
            id: hideTimer
            interval: 600
            repeat: false
            onTriggered: {
                if (!dockHover.hovered && !root.popupOpen) {
                    root.isExpanded = false;
                    root.hideDockTip();
                }
            }
        }
    }

    PanelWindow {
        id: overlay
        screen: dock.screen
        color: "transparent"
        visible: root.popupOpen
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Top

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                minimizedPopup.closeMinimized();
            }
        }
    }
}
