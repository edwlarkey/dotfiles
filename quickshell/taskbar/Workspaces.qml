import Quickshell
import Quickshell.Hyprland
import QtQuick

import ".."

Row {
    id: workspaces
    spacing: 4
    height: parent ? parent.height : Config.bar.height

    property var currentWorkspaces: {
        const all = Hyprland.workspaces.values;
        const onScreen = all.filter(w => w.monitor && w.monitor.name === taskbar.screen.name);
        return onScreen.length > 0 ? onScreen : all;
    }

    Repeater {
        model: parent.currentWorkspaces
        delegate: Item {
            id: control
            required property var modelData
            width: Config.bar.height - 4
            height: parent.height

            readonly property int focusedWorkspaceId: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : -1
            readonly property int wsId: modelData.id
            readonly property bool current: wsId == focusedWorkspaceId
            readonly property bool hovered: mouse.containsMouse

            Rectangle {
                anchors.centerIn: parent
                width: Config.bar.height - 10
                height: Config.bar.height - 12
                color: {
                    if (modelData.urgent)
                        return Config.colors.urgent;
                    if (control.hovered || control.current)
                        return Config.colors.outline;
                    return Config.colors.base;
                }
                border.width: 1
                border.color: Config.colors.outline

                Text {
                    anchors.centerIn: parent
                    text: "" + control.wsId
                    font.family: fontCharcoal.name
                    font.pixelSize: Config.bar.fontSize
                    color: (control.hovered || control.current) && !modelData.urgent ? Config.colors.highlight : Config.colors.text
                }
            }

            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch('hl.dsp.focus({ workspace = "' + control.wsId + '" })')
            }
        }
    }
}
