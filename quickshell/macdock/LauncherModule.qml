import Quickshell
import QtQuick

DockModule {
    id: root

    required property var modelData

    tip: modelData.name || ""

    onClicked: {
        if (modelData.type === "folder")
            Quickshell.execDetached(["thunar", modelData.path]);
        else
            Quickshell.execDetached([modelData.command]);
    }

    Image {
        anchors.centerIn: parent
        width: root.iconSize
        height: root.iconSize
        source: root.modelData.iconName ? (Quickshell.iconPath(root.modelData.iconName, true) || "") : ""
        sourceSize: Qt.size(width, height)
    }
}
