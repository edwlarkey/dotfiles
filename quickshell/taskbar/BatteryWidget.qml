import Quickshell
import Quickshell.Services.UPower
import QtQuick

import ".."

Item {
    id: root

    readonly property var battery: UPower.displayDevice
    readonly property bool present: battery && battery.ready && battery.isPresent
    readonly property real rawPct: battery ? battery.percentage : 0
    readonly property int percent: rawPct > 1 ? Math.round(rawPct) : Math.round(rawPct * 100)
    readonly property bool charging: battery && (battery.state === UPowerDeviceState.Charging || battery.state === UPowerDeviceState.FullyCharged)
    readonly property int level: Math.round(Math.max(0, Math.min(100, percent)) / 10) * 10
    readonly property string iconName: {
        const n = level.toString().padStart(3, "0");
        return charging ? "battery-" + n + "-charging" : "battery-" + n;
    }

    visible: present
    implicitWidth: present ? row.implicitWidth : 0
    implicitHeight: parent ? parent.height : Config.bar.height
    width: implicitWidth
    height: implicitHeight

    Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        Image {
            anchors.verticalCenter: parent.verticalCenter
            width: Config.bar.iconSize
            height: Config.bar.iconSize
            source: Quickshell.iconPath(root.iconName, true) || ""
            sourceSize: Qt.size(width, height)
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.percent + "%"
            color: Config.colors.text
            font.pixelSize: Config.bar.fontSize
            font.family: fontCharcoal.name
        }
    }
}
