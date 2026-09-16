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
        color: Config.colors.base
        Bevel {}

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
