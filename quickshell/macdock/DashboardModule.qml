import Quickshell
import QtQuick

import ".."

DockModule {
    id: root

    tip: "Dashboard"
    active: Dashboard.open

    onClicked: Dashboard.toggle()

    Image {
        anchors.centerIn: parent
        width: root.iconSize
        height: root.iconSize
        source: Quickshell.iconPath("computer", true) || ""
        sourceSize: Qt.size(width, height)
    }
}
