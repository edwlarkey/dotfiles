import Quickshell
import QtQuick

import ".."

DockModule {
    id: root

    tip: "Settings"

    onClicked: Config.openSettingsWindow = !Config.openSettingsWindow

    Image {
        anchors.centerIn: parent
        width: root.iconSize
        height: root.iconSize
        source: Quickshell.iconPath("preferences-desktop", true) || ""
        sourceSize: Qt.size(width, height)
    }
}
