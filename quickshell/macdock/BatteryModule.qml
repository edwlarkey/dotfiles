import Quickshell
import Quickshell.Services.UPower
import QtQuick

DockModule {
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
    moduleWidth: present ? (dock && dock.moduleWidth ? dock.moduleWidth : 48) : 0
    tip: {
        if (!present)
            return "Battery";
        if (battery.state === UPowerDeviceState.FullyCharged)
            return "Charged " + percent + "%";
        if (charging)
            return "Charging " + percent + "%";
        return "Battery " + percent + "%";
    }

    Image {
        anchors.centerIn: parent
        width: root.iconSize
        height: root.iconSize
        source: Quickshell.iconPath(root.iconName, true) || ""
        sourceSize: Qt.size(width, height)
    }
}
