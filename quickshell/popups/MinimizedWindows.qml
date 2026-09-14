import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import ".."

PopupWindow {
    id: root
    visible: false

    property var closeCallback: function () {}
    readonly property string parkWorkspace: "os99-minimized"
    property var windows: []
    property int count: windows.length

    implicitWidth: 280
    implicitHeight: 38 + 16 + (count === 0 ? 36 : Math.min(count, 8) * 28) + (count > 0 ? 36 : 0) + 8
    color: "transparent"

    function classOf(t) {
        const ipc = t.lastIpcObject || {};
        return ipc["class"] || ipc["initialClass"] || "";
    }

    function addrOf(t) {
        let a = t.address || "";
        if (a && a.indexOf("0x") !== 0)
            a = "0x" + a;
        return a;
    }

    function refresh() {
        const out = [];
        const tops = Hyprland.toplevels.values;
        for (let i = 0; i < tops.length; i++) {
            const t = tops[i];
            if (t && t.workspace && t.workspace.name === root.parkWorkspace)
                out.push(t);
        }
        windows = out;
    }

    function restore(addr) {
        if (!addr)
            return;
        Quickshell.execDetached(["os99-minimize", "restore", addr]);
        root.closeMinimized();
    }

    function restoreAll() {
        Quickshell.execDetached(["os99-minimize", "restore-all"]);
        root.closeMinimized();
    }

    function openMinimized() {
        refresh();
        root.visible = true;
        openAnimation.start();
    }

    function closeMinimized() {
        if (openAnimation.running)
            openAnimation.stop();
        frame.opacity = 0;
        root.visible = false;
        root.closeCallback();
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            const n = event.name;
            if (n === "movewindow" || n === "movewindowv2" || n === "openwindow" || n === "closewindow" || n === "windowtitlev2" || n === "createworkspace" || n === "createworkspacev2" || n === "destroyworkspace" || n === "destroyworkspacev2" || n === "activewindow" || n === "activewindowv2") {
                root.refresh();
            }
        }
    }

    Component.onCompleted: refresh()

    Rectangle {
        id: frame
        opacity: 0
        anchors.fill: parent
        color: Config.colors.base
        layer.enabled: true

        PopupWindowFrame {
            id: minimizedFrame
            windowTitle: "Minimized"
            windowTitleIcon: "\ue8bb"
            windowTitleDecorationWidth: 55

            Item {
                id: content
                anchors.fill: minimizedFrame
                anchors.margins: 12
                anchors.topMargin: 38

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 4

                    Text {
                        visible: root.count === 0
                        Layout.fillWidth: true
                        Layout.preferredHeight: 28
                        text: "Nothing is parked."
                        font.family: fontCharcoal.name
                        font.pixelSize: 12
                        color: Config.colors.text
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Flickable {
                        visible: root.count > 0
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredHeight: Math.min(root.count, 8) * 28
                        contentHeight: root.count * 28
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds

                        Column {
                            width: parent.width
                            spacing: 0

                            Repeater {
                                model: root.windows
                                delegate: Button {
                                    id: winBtn
                                    required property var modelData
                                    width: parent.width
                                    implicitHeight: 28

                                    onClicked: () => {
                                        root.restore(root.addrOf(modelData));
                                    }

                                    background: Rectangle {
                                        color: winBtn.pressed ? Config.colors.accent : (winHover.containsMouse ? Config.colors.highlight : "transparent")
                                    }

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: 6
                                        anchors.rightMargin: 6
                                        spacing: 8

                                        Image {
                                            Layout.preferredWidth: 16
                                            Layout.preferredHeight: 16
                                            source: {
                                                const c = root.classOf(modelData);
                                                return c ? (Quickshell.iconPath(c, true) || "") : "";
                                            }
                                            sourceSize: Qt.size(16, 16)
                                        }
                                        Text {
                                            Layout.fillWidth: true
                                            text: modelData.title || root.classOf(modelData) || "window"
                                            font.family: fontCharcoal.name
                                            font.pixelSize: 12
                                            color: winBtn.pressed ? Config.colors.highlight : Config.colors.text
                                            elide: Text.ElideRight
                                        }
                                    }

                                    MouseArea {
                                        id: winHover
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: winBtn.clicked()
                                    }
                                }
                            }
                        }
                    }

                    Button {
                        id: restoreAllBtn
                        visible: root.count > 0
                        Layout.fillWidth: true
                        implicitHeight: 28

                        onClicked: () => {
                            root.restoreAll();
                        }

                        background: Rectangle {
                            color: restoreAllBtn.pressed ? Config.colors.accent : (restoreAllHover.containsMouse ? Config.colors.highlight : "transparent")
                            border.width: 1
                            border.color: Config.colors.outline
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "Restore All"
                            font.family: fontCharcoal.name
                            font.pixelSize: 12
                            color: restoreAllBtn.pressed ? Config.colors.highlight : Config.colors.text
                        }

                        MouseArea {
                            id: restoreAllHover
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: restoreAllBtn.clicked()
                        }
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
