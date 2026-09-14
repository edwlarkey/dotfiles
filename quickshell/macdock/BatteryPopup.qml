import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

import ".."

PopupWindow {
    id: root
    visible: false

    property var battery: null
    property var closeCallback: function () {}

    readonly property color macBase: "#c8c8c8"
    readonly property color macHighlight: "#ffffff"
    readonly property color macShadow: "#808080"
    readonly property color macDarkShadow: "#404040"
    readonly property real rawPct: battery ? battery.percentage : 0
    readonly property int percent: rawPct > 1 ? Math.round(rawPct) : Math.round(rawPct * 100)
    readonly property real rawHealth: battery && battery.healthSupported ? battery.healthPercentage : 0
    readonly property int healthPct: rawHealth > 1 ? Math.round(rawHealth) : Math.round(rawHealth * 100)

    implicitWidth: 176
    implicitHeight: battery && battery.healthSupported ? 92 : 76
    color: "transparent"

    function openBattery() {
        root.visible = true;
        openAnimation.start();
    }

    function closeBattery() {
        if (!root.visible)
            return;
        if (openAnimation.running)
            openAnimation.stop();
        frame.opacity = 0;
        root.visible = false;
        root.closeCallback();
    }

    function formatTime(secs) {
        if (!secs || secs <= 0)
            return "";
        const h = Math.floor(secs / 3600);
        const m = Math.floor((secs % 3600) / 60);
        if (h > 0)
            return h + "h " + m + "m";
        return m + "m";
    }

    function stateLabel() {
        if (!battery)
            return "Unknown";
        if (battery.state === UPowerDeviceState.Charging) {
            const t = formatTime(battery.timeToFull);
            return t ? "Charging · " + t : "Charging";
        }
        if (battery.state === UPowerDeviceState.Discharging) {
            const t = formatTime(battery.timeToEmpty);
            return t ? "Discharging · " + t : "Discharging";
        }
        if (battery.state === UPowerDeviceState.FullyCharged)
            return "Fully charged";
        return UPowerDeviceState.toString(battery.state);
    }

    Rectangle {
        id: frame
        opacity: 0
        anchors.fill: parent
        color: macBase

        Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; height: 1; color: macHighlight }
        Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: macHighlight }
        Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 1; color: macDarkShadow }
        Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: macDarkShadow }
        Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.bottomMargin: 1; height: 1; color: macShadow }
        Rectangle { anchors.right: parent.right; anchors.rightMargin: 1; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: macShadow }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 6

            Text {
                Layout.fillWidth: true
                text: root.percent + "%"
                font.family: fontCharcoal.name
                font.pixelSize: 18
                color: Config.colors.text
            }
            Text {
                Layout.fillWidth: true
                text: root.stateLabel()
                font.family: fontCharcoal.name
                font.pixelSize: 11
                color: Config.colors.text
            }
            Text {
                visible: root.battery && root.battery.healthSupported
                Layout.fillWidth: true
                text: "Health " + root.healthPct + "%"
                font.family: fontCharcoal.name
                font.pixelSize: 11
                color: Config.colors.text
            }
        }

        OpacityAnimator {
            id: openAnimation
            target: frame
            from: 0
            to: 1
            duration: 140
            easing.type: Easing.OutCubic
        }
    }
}
