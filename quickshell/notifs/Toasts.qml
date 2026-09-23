import Quickshell
import Quickshell.Wayland
import QtQuick

import ".."

Scope {
    Variants {
            model: Config.realScreens
        PanelWindow {
            id: toastWin
            required property var modelData
            screen: modelData
            visible: Notifications.popupNotifs.length > 0
            color: "transparent"
            exclusiveZone: 0
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "linuxplatinum-toasts"

            anchors {
                top: true
                right: true
            }
            margins {
                top: Config.bar.height + 8
                right: 8
            }

            implicitWidth: Config.notifications.toastWidth
            implicitHeight: toastCol.implicitHeight

            Column {
                id: toastCol
                width: parent.width
                spacing: 8

                Repeater {
                    model: Notifications.popupNotifs
                    Toast {}
                }
            }
        }
    }
}
