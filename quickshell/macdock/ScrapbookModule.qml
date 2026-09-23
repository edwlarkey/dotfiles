import Quickshell
import QtQuick

import ".."

DockModule {
    id: root

    tip: "Scrapbook"
    active: Scrapbook.open

    onClicked: Scrapbook.toggle()

    Image {
        anchors.centerIn: parent
        width: root.iconSize
        height: root.iconSize
        source: Quickshell.iconPath("edit-paste", true) || ""
        sourceSize: Qt.size(width, height)
    }
}
