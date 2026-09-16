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

    function isParked(t) {
        return t && t.workspace && t.workspace.name === root.parkWorkspace;
    }

    function refresh() {
        const byClass = {};
        const tops = Hyprland.toplevels.values;
        for (let i = 0; i < tops.length; i++) {
            const t = tops[i];
            if (!t)
                continue;
            const c = classOf(t);
            const key = c || addrOf(t);
            if (!byClass[key]) {
                byClass[key] = {
                    className: c,
                    name: displayName(c),
                    windows: [],
                    parked: 0
                };
            }
            byClass[key].windows.push(t);
            if (isParked(t))
                byClass[key].parked++;
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

    function onWindow(addr, call) {
        if (!addr)
            return;
        Hyprland.dispatch('(function() for _, w in ipairs(hl.get_windows()) do if w.address == "' + addr + '" then return ' + call + ' end end return hl.dsp.no_op() end)()');
    }

    function hideAddr(addr) {
        onWindow(addr, 'hl.dsp.window.move({ window = w, workspace = "name:' + root.parkWorkspace + '", follow = false })');
    }

    function restoreAddr(addr) {
        const ws = Hyprland.focusedWorkspace;
        const dest = ws ? String(ws.id) : "1";
        onWindow(addr, 'hl.dsp.window.move({ window = w, workspace = "' + dest + '", follow = false })');
        onWindow(addr, 'hl.dsp.focus({ window = w })');
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
        const tops = Hyprland.toplevels.values;
        for (let i = 0; i < tops.length; i++) {
            if (isParked(tops[i]))
                restoreAddr(addrOf(tops[i]));
        }
        Qt.callLater(refresh);
    }

    function focusWindow(t) {
        if (!t)
            return;
        if (t.wayland)
            t.wayland.activate();
        else
            onWindow(addrOf(t), 'hl.dsp.focus({ window = w })');
    }

    function focusApp(app) {
        if (!app || !app.windows.length)
            return;
        const parked = [];
        let visible = null;
        for (let i = 0; i < app.windows.length; i++) {
            const t = app.windows[i];
            if (isParked(t))
                parked.push(addrOf(t));
            else if (!visible)
                visible = t;
        }
        root.closeSwitcher();
        for (let i = 0; i < parked.length; i++)
            restoreAddr(parked[i]);
        if (visible)
            root.focusWindow(visible);
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
                                    color: index === root.selected ? Config.colors.outline : (rowArea.containsMouse ? Config.colors.hover : "transparent")
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
                                        text: modelData.parked === modelData.windows.length ? modelData.name + " (hidden)" : modelData.name
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
                                    onClicked: {
                                        root.selected = index;
                                        root.focusApp(modelData);
                                    }
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
                                color: btnArea.pressed ? Config.colors.accent : (btnArea.containsMouse ? Config.colors.hover : Config.colors.base)
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
