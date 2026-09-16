import Quickshell
import Quickshell.Wayland
import QtQuick

import ".."
import "../popups" as Popups

Scope {
    id: root

    property bool isExpanded: false
    property string openPopup: ""
    property bool popupOpen: openPopup !== ""
    property Item hoveredItem: null
    property string hoveredLabel: ""
    readonly property int tipSpace: 26
    readonly property int stripHeight: 44
    readonly property int moduleWidth: 48
    readonly property int iconSize: Config.macDock.iconSize

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

    function closeAllPopups() {
        if (openPopup === "volume")
            volumePopup.closeVolume();
        else if (openPopup === "battery")
            batteryPopup.closeBattery();
        else if (openPopup === "session")
            sessionPopup.closeSession();
        else
            openPopup = "";
    }

    function togglePopup(name) {
        hideDockTip();
        if (openPopup === name) {
            closeAllPopups();
            return;
        }
        if (openPopup !== "")
            closeAllPopups();
        hideTimer.stop();
        isExpanded = true;
        openPopup = name;
        if (name === "volume")
            volumePopup.openVolume();
        else if (name === "battery")
            batteryPopup.openBattery();
        else if (name === "session")
            sessionPopup.openSession();
    }

    function onPopupClosed() {
        openPopup = "";
        hideTimer.start();
    }

    PanelWindow {
        id: dock

        screen: Quickshell.screens[0]
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        anchors {
            bottom: true
            left: true
        }

        implicitHeight: root.stripHeight + root.tipSpace
        implicitWidth: contentRow.implicitWidth + pullTab.width
        exclusionMode: ExclusionMode.Ignore

        mask: Region {
            x: 0
            y: (root.isExpanded || slideAnim.running) ? 0 : root.tipSpace
            height: (root.isExpanded || slideAnim.running) ? dock.height : root.stripHeight
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
                    font.pixelSize: 12
                    color: "#000000"
                }
            }

            Item {
                id: dockContent
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: root.stripHeight
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
                        color: Config.colors.base
                    }

                    Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; height: 2; color: Config.colors.highlight }
                    Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 2; color: Config.colors.highlight }
                    Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 2; color: Config.colors.dark }
                    Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 2; color: Config.colors.dark }
                    Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.bottomMargin: 2; height: 1; color: Config.colors.shadow }
                    Rectangle { anchors.right: parent.right; anchors.rightMargin: 2; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: Config.colors.shadow }

                    Row {
                        id: contentRow
                        height: parent.height

                        Repeater {
                            model: Config.macDock.entries
                            delegate: LauncherModule {
                                dock: root
                            }
                        }

                        VolumeModule {
                            id: volSlot
                            dock: root
                            active: root.openPopup === "volume"
                            onClicked: root.togglePopup("volume")
                        }

                        BatteryModule {
                            id: batSlot
                            dock: root
                            active: root.openPopup === "battery"
                            onClicked: root.togglePopup("battery")
                        }

                        DockModule {
                            id: sessionSlot
                            dock: root
                            tip: "Special"
                            active: root.openPopup === "session"
                            onClicked: root.togglePopup("session")

                            Image {
                                anchors.centerIn: parent
                                width: sessionSlot.iconSize
                                height: sessionSlot.iconSize
                                source: Quickshell.iconPath("system-shutdown", true) || ""
                                sourceSize: Qt.size(width, height)
                            }
                        }

                        ClockModule {
                            dock: root
                        }

                        SettingsModule {
                            dock: root
                        }
                    }
                }

                Item {
                    id: pullTab
                    width: 20
                    height: parent.height

                    Rectangle {
                        anchors.fill: parent
                        color: Config.colors.base
                        radius: 5
                        Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 5; color: Config.colors.base }
                    }

                    Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.rightMargin: 3; anchors.top: parent.top; height: 2; color: Config.colors.highlight }
                    Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: 3; anchors.bottom: parent.bottom; anchors.bottomMargin: 3; width: 2; color: Config.colors.dark }
                    Rectangle { anchors.right: parent.right; anchors.rightMargin: 2; anchors.top: parent.top; anchors.topMargin: 2; anchors.bottom: parent.bottom; anchors.bottomMargin: 2; width: 1; color: Config.colors.shadow }
                    Rectangle { anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; anchors.rightMargin: 3; height: 2; color: Config.colors.dark }
                    Rectangle { anchors.bottom: parent.bottom; anchors.bottomMargin: 2; anchors.left: parent.left; anchors.right: parent.right; anchors.rightMargin: 2; height: 1; color: Config.colors.shadow }

                    Column {
                        anchors.centerIn: parent
                        spacing: 3
                        Repeater {
                            model: 3
                            Rectangle {
                                width: 6; height: 3; color: Config.colors.highlight
                                Rectangle { anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; height: 1; color: Config.colors.shadow }
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

        VolumePopup {
            id: volumePopup
            anchor.window: dock
            anchor.item: volSlot
            anchor.edges: Edges.Top | Edges.Left
            anchor.gravity: Edges.Top | Edges.Right
            audio: volSlot.audio
            sinkName: volSlot.sinkName
            closeCallback: root.onPopupClosed
        }

        BatteryPopup {
            id: batteryPopup
            anchor.window: dock
            anchor.item: batSlot
            anchor.edges: Edges.Top | Edges.Left
            anchor.gravity: Edges.Top | Edges.Right
            battery: batSlot.battery
            closeCallback: root.onPopupClosed
        }

        Popups.SessionPopup {
            id: sessionPopup
            anchor.window: dock
            anchor.item: sessionSlot
            anchor.edges: Edges.Top | Edges.Left
            anchor.gravity: Edges.Top | Edges.Right
            iconSize: Math.max(16, Math.round(root.iconSize * 0.6))
            closeCallback: root.onPopupClosed
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
            onClicked: root.closeAllPopups()
        }
    }
}
