import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import ".."

RowLayout {
    id: workspaces
    spacing: 3
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter

     property bool usingHyprland: Hyprland.workspaces.values.length == 0 ? false : true

    property var currentWorkspaces: Hyprland.workspaces.values.filter(w => w.monitor && w.monitor.name == taskbar.screen.name)


    Repeater { 
        model: parent.currentWorkspaces
        //model: Hyprland.workspaces.values.filter(w => w.monitor.name == taskbar.screen.name)
        Button {
            id: control
            anchors.centerIn: parent.centerIn
            contentItem: Text {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: usingHyprland ? modelData.id : modelData.number
                font.family: fontMonaco.name
                width: 10
                height: 10
                font.pixelSize: Config.settings.bar.fontSize
                color: Config.colors.text
            }
            onPressed: event => {
                Hyprland.dispatch(`hl.dsp.focus({ workspace = "` + modelData.id +`" })`);
                event.accepted = true;
            }
            NewBorder {
                commonBorderWidth: 2
                commonBorder: false
                lBorderwidth: -2
                rBorderwidth: 0
                tBorderwidth: -4
                bBorderwidth: -1
                borderColor: Config.colors.outline
                zValue: -1
            }

            readonly property int focusedWorkspaceId: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : -1
            background: Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                border.width: 1
                border.color: Config.colors.outline
                width: 22
                height: 22
                color: {
                    if (modelData.urgent)
                        return Config.colors.urgent;
                    const id = usingHyprland ? modelData.id : modelData.number;
                    if (mouse.hovered || id == control.focusedWorkspaceId)
                        return Config.colors.shadow;
                    return Config.colors.base;
                }
            }

            HoverHandler {
                id: mouse
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                cursorShape: Qt.PointingHandCursor
            }
        }
    }
}
