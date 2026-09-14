import Quickshell
import QtQuick
import QtQuick.Layouts

import ".."

PopupWindow {
    id: root
    visible: false

    property var closeCallback: function () {}
    property int iconSize: 16

    readonly property color macBase: "#c8c8c8"
    readonly property color macHighlight: "#ffffff"
    readonly property color macShadow: "#808080"
    readonly property color macDarkShadow: "#404040"
    readonly property var actions: [
        {"name": "Sleep", "cmd": ["systemctl", "suspend"], "iconName": "system-suspend"},
        {"name": "Restart", "cmd": ["systemctl", "reboot"], "iconName": "system-reboot"},
        {"name": "Shut Down", "cmd": ["systemctl", "poweroff"], "iconName": "system-shutdown"},
        {"name": "Log Out", "cmd": ["hyprctl", "dispatch", "exit"], "iconName": "system-log-out"}
    ]

    implicitWidth: 148
    implicitHeight: 8 + actions.length * 28
    color: "transparent"

    function openSession() {
        root.visible = true;
        openAnimation.start();
    }

    function closeSession() {
        if (!root.visible)
            return;
        if (openAnimation.running)
            openAnimation.stop();
        frame.opacity = 0;
        root.visible = false;
        root.closeCallback();
    }

    function runAction(cmd) {
        root.closeSession();
        Quickshell.execDetached(cmd);
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

        Column {
            anchors.fill: parent
            anchors.margins: 4
            spacing: 0

            Repeater {
                model: root.actions
                delegate: Item {
                    required property var modelData
                    width: parent.width
                    height: 28

                    Rectangle {
                        anchors.fill: parent
                        color: rowArea.pressed ? "#a8a8a8" : (rowArea.containsMouse ? "#b8b8b8" : "transparent")
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        spacing: 8

                        Image {
                            Layout.preferredWidth: root.iconSize
                            Layout.preferredHeight: root.iconSize
                            source: Quickshell.iconPath(modelData.iconName, true) || ""
                            sourceSize: Qt.size(root.iconSize, root.iconSize)
                        }
                        Text {
                            Layout.fillWidth: true
                            text: modelData.name
                            font.family: fontCharcoal.name
                            font.pixelSize: 12
                            color: Config.colors.text
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    MouseArea {
                        id: rowArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.runAction(modelData.cmd)
                    }
                }
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
