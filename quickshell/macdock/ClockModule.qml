import Quickshell
import QtQuick
import QtQuick.Layouts

import ".."

DockModule {
    id: root

    moduleWidth: 186
    tip: "Clock"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 8

        Image {
            Layout.preferredWidth: root.iconSize
            Layout.preferredHeight: root.iconSize
            source: Quickshell.iconPath("preferences-system-time", true) || ""
            sourceSize: Qt.size(root.iconSize, root.iconSize)
        }
        Text {
            Layout.fillWidth: true
            text: Time.time
            font.family: fontCharcoal.name
            font.pixelSize: 13
            color: root.macText
            verticalAlignment: Text.AlignVCenter
        }
    }
}
