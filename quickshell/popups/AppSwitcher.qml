import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import ".."
import "../utils" as Utils

PopupWindow {
    id: root
    visible: false

    property var closeCallback: function () {}
    property int iconSize: 16
    property string parkWorkspace: "os99-minimized"
    property var apps: []
    property string query: ""
    property int selected: 0

    readonly property var filtered: {
        const q = query.trim().toLowerCase();
        if (!q)
            return apps;
        return apps.filter(a => a.name.toLowerCase().indexOf(q) !== -1);
    }
    readonly property int count: filtered.length
    readonly property var selectedApp: count > 0 ? filtered[Math.max(0, Math.min(selected, count - 1))] : null

    implicitWidth: 280
    implicitHeight: 38 + 16 + 28 + 8 + Math.max(1, Math.min(count, 8)) * 24 + 8 + 28 + 12
    color: "transparent"

    function classOf(t) {
        return Utils.AppSearch.classOfToplevel(t);
    }

    function addrOf(t) {
        let a = t.address || "";
        if (a && a.indexOf("0x") !== 0)
            a = "0x" + a;
        return a;
    }

    function displayName(klass) {
        const name = Utils.AppSearch.nameFromId(klass);
        return name || "Finder";
    }

    function refresh() {
        const byClass = {};
        const tops = Hyprland.toplevels.values;
        for (let i = 0; i < tops.length; i++) {
            const t = tops[i];
            if (!t)
                continue;
            if (t.workspace && t.workspace.name === root.parkWorkspace)
                continue;
            const c = classOf(t);
            const key = c || addrOf(t);
            if (!byClass[key]) {
                byClass[key] = {
                    className: c,
                    name: displayName(c),
                    windows: []
                };
            }
            byClass[key].windows.push(t);
        }
        const out = [];
        for (const k in byClass)
            out.push(byClass[k]);
        out.sort((a, b) => a.name.localeCompare(b.name));
        apps = out;
        if (selected >= out.length)
            selected = Math.max(0, out.length - 1);
    }

    function openSwitcher() {
        query = "";
        selected = 0;
        refresh();
        root.visible = true;
        openAnimation.start();
        searchInput.forceActiveFocus();
    }

    function closeSwitcher() {
        if (!root.visible)
            return;
        if (openAnimation.running)
            openAnimation.stop();
        frame.opacity = 0;
        root.visible = false;
        root.closeCallback();
    }

    function hideAddr(addr) {
        if (!addr)
            return;
        Quickshell.execDetached(["os99-minimize", "hide", addr]);
    }

    function hideApp(app) {
        if (!app)
            return;
        for (let i = 0; i < app.windows.length; i++)
            hideAddr(addrOf(app.windows[i]));
        Qt.callLater(refresh);
    }

    function hideOthers(app) {
        if (!app)
            return;
        for (let i = 0; i < apps.length; i++) {
            if (apps[i].className === app.className)
                continue;
            for (let j = 0; j < apps[i].windows.length; j++)
                hideAddr(addrOf(apps[i].windows[j]));
        }
        Qt.callLater(refresh);
    }

    function showAll() {
        Quickshell.execDetached(["os99-minimize", "restore-all"]);
        Qt.callLater(refresh);
    }

    function focusApp(app) {
        if (!app || !app.windows.length)
            return;
        const addr = addrOf(app.windows[0]);
        root.closeSwitcher();
        if (addr)
            Hyprland.dispatch('hl.dsp.focus({ window = "' + addr + '" })');
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (!root.visible)
                return;
            const n = event.name;
            if (n === "openwindow" || n === "closewindow" || n === "activewindow" || n === "activewindowv2" || n === "movewindow" || n === "movewindowv2")
                root.refresh();
        }
    }

    Rectangle {
        id: frame
        opacity: 0
        anchors.fill: parent
        color: Config.colors.base
        layer.enabled: true

        PopupWindowFrame {
            id: managerFrame
            windowTitle: "Application Menu"
            windowTitleIcon: "\ue871"
            windowTitleDecorationWidth: 40

            Item {
                anchors.fill: managerFrame
                anchors.margins: 12
                anchors.topMargin: 38

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 8

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 24
                        color: Config.colors.highlight
                        border.width: 1
                        border.color: Config.colors.outline

                        TextField {
                            id: searchInput
                            anchors.fill: parent
                            anchors.leftMargin: 6
                            anchors.rightMargin: 6
                            text: root.query
                            font.family: fontCharcoal.name
                            font.pixelSize: 12
                            color: Config.colors.text
                            selectionColor: Config.colors.shadow
                            selectedTextColor: Config.colors.highlight
                            selectByMouse: true
                            placeholderText: "Filter"
                            background: Item {}
                            onTextChanged: {
                                root.query = text;
                                root.selected = 0;
                            }
                            Keys.onEscapePressed: root.closeSwitcher()
                            Keys.onDownPressed: root.selected = Math.min(root.count - 1, root.selected + 1)
                            Keys.onUpPressed: root.selected = Math.max(0, root.selected - 1)
                            Keys.onReturnPressed: root.focusApp(root.selectedApp)
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Config.colors.highlight
                        border.width: 1
                        border.color: Config.colors.outline
                        clip: true

                        ListView {
                            id: appList
                            anchors.fill: parent
                            anchors.margins: 1
                            model: root.filtered
                            clip: true
                            boundsBehavior: Flickable.StopAtBounds
                            currentIndex: root.selected

                            delegate: Item {
                                required property var modelData
                                required property int index
                                width: appList.width
                                height: 24

                                Rectangle {
                                    anchors.fill: parent
                                    color: index === root.selected ? Config.colors.outline : (rowArea.containsMouse ? "#d8d8d8" : "transparent")
                                }

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 6
                                    anchors.rightMargin: 6
                                    spacing: 8

                                    Image {
                                        Layout.preferredWidth: root.iconSize
                                        Layout.preferredHeight: root.iconSize
                                        source: modelData.className ? (Quickshell.iconPath(modelData.className, true) || "") : ""
                                        sourceSize: Qt.size(root.iconSize, root.iconSize)
                                    }
                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData.name
                                        font.family: fontCharcoal.name
                                        font.pixelSize: 12
                                        color: index === root.selected ? Config.colors.highlight : Config.colors.text
                                        elide: Text.ElideRight
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }

                                MouseArea {
                                    id: rowArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.selected = index
                                    onDoubleClicked: root.focusApp(modelData)
                                }
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        Repeater {
                            model: [
                                {"name": "Hide", "action": "hide"},
                                {"name": "Hide Others", "action": "others"},
                                {"name": "Show All", "action": "show"}
                            ]
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.preferredHeight: 24
                                color: btnArea.pressed ? "#a8a8a8" : (btnArea.containsMouse ? "#b8b8b8" : Config.colors.base)
                                border.width: 1
                                border.color: Config.colors.outline

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.name
                                    font.family: fontCharcoal.name
                                    font.pixelSize: 11
                                    color: Config.colors.text
                                }

                                MouseArea {
                                    id: btnArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if (modelData.action === "hide")
                                            root.hideApp(root.selectedApp);
                                        else if (modelData.action === "others")
                                            root.hideOthers(root.selectedApp);
                                        else
                                            root.showAll();
                                    }
                                }
                            }
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
