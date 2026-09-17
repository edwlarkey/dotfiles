import Quickshell
import Quickshell.Hyprland
import QtQuick

import ".."
import "../utils" as Utils

PopupWindow {
    id: root
    visible: false

    property var closeCallback: function () {}
    property int iconSize: Config.bar.menuIconSize
    property int fontSize: Config.bar.menuFontSize
    property string parkWorkspace: "os99-minimized"
    property var apps: []
    property int selected: 0
    property bool grabActive: false

    readonly property int rowH: Math.max(26, fontSize + 12)
    readonly property int sepH: 8
    readonly property int count: items.length
    readonly property var selectedItem: count > 0 ? items[Math.max(0, Math.min(selected, count - 1))] : null
    readonly property var frontApp: {
        const t = Hyprland.activeToplevel;
        if (!t)
            return null;
        const c = classOf(t);
        for (let i = 0; i < apps.length; i++) {
            if (apps[i].className === c)
                return apps[i];
        }
        return null;
    }
    readonly property var items: {
        const out = [];
        for (let i = 0; i < apps.length; i++) {
            const a = apps[i];
            out.push({
                kind: "app",
                name: a.parked === a.windows.length ? a.name + " (hidden)" : a.name,
                app: a,
                enabled: true
            });
        }
        if (apps.length > 0)
            out.push({ kind: "sep" });
        const parked = apps.some(a => a.parked > 0);
        out.push({ kind: "action", name: "Hide", action: "hide", enabled: !!frontApp });
        out.push({ kind: "action", name: "Hide Others", action: "others", enabled: !!frontApp && apps.length > 1 });
        out.push({ kind: "action", name: "Show All", action: "show", enabled: parked });
        return out;
    }

    implicitWidth: Config.bar.menuWidth
    implicitHeight: {
        let h = 6;
        for (let i = 0; i < items.length; i++)
            h += items[i].kind === "sep" ? sepH : rowH;
        return h + 6;
    }
    color: "transparent"

    HyprlandFocusGrab {
        active: root.grabActive
        windows: [root]
        onCleared: {
            if (root.visible)
                root.closeSwitcher();
        }
    }

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
        if (selected >= items.length)
            selected = Math.max(0, items.length - 1);
    }

    function indexOfFront() {
        if (!frontApp)
            return 0;
        for (let i = 0; i < items.length; i++) {
            if (items[i].kind === "app" && items[i].app.className === frontApp.className)
                return i;
        }
        return 0;
    }

    function openSwitcher() {
        selected = 0;
        refresh();
        selected = indexOfFront();
        root.visible = true;
        openAnimation.start();
        Qt.callLater(() => {
            root.grabActive = true;
            frame.forceActiveFocus();
        });
    }

    function closeSwitcher() {
        if (!root.visible)
            return;
        if (openAnimation.running)
            openAnimation.stop();
        frame.opacity = 0;
        root.grabActive = false;
        root.visible = false;
        root.closeCallback();
    }

    function moveSelection(dir) {
        let i = selected + dir;
        while (i >= 0 && i < items.length) {
            if (items[i].kind !== "sep") {
                selected = i;
                return;
            }
            i += dir;
        }
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
    }

    function showAll() {
        const tops = Hyprland.toplevels.values;
        for (let i = 0; i < tops.length; i++) {
            if (isParked(tops[i]))
                restoreAddr(addrOf(tops[i]));
        }
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

    function activateItem(item) {
        if (!item || item.kind === "sep")
            return;
        if (item.kind === "app") {
            root.focusApp(item.app);
            return;
        }
        if (!item.enabled)
            return;
        if (item.action === "hide")
            root.hideApp(root.frontApp);
        else if (item.action === "others")
            root.hideOthers(root.frontApp);
        else
            root.showAll();
        root.closeSwitcher();
    }

    function activateSelected() {
        root.activateItem(root.selectedItem);
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
        focus: true
        Keys.onEscapePressed: root.closeSwitcher()
        Keys.onDownPressed: root.moveSelection(1)
        Keys.onUpPressed: root.moveSelection(-1)
        Keys.onReturnPressed: root.activateSelected()
        Keys.onEnterPressed: root.activateSelected()

        Bevel {}

        Column {
            anchors.fill: parent
            anchors.margins: 3
            spacing: 0

            Repeater {
                model: root.items
                delegate: Item {
                    required property var modelData
                    required property int index
                    width: parent.width
                    height: modelData.kind === "sep" ? root.sepH : root.rowH

                    Rectangle {
                        visible: modelData.kind !== "sep"
                        anchors.fill: parent
                        color: index === root.selected ? Config.colors.outline : "transparent"
                    }

                    Item {
                        visible: modelData.kind === "sep"
                        anchors.fill: parent

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: 1
                            anchors.rightMargin: 1
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: -1
                            height: 1
                            color: Config.colors.shadow
                        }
                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: 1
                            anchors.rightMargin: 1
                            anchors.verticalCenter: parent.verticalCenter
                            height: 1
                            color: Config.colors.highlight
                        }
                    }

                    Image {
                        id: appIcon
                        visible: modelData.kind === "app"
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        width: root.iconSize
                        height: root.iconSize
                        source: modelData.kind === "app" && modelData.app.className ? (Quickshell.iconPath(modelData.app.className, true) || "") : ""
                        sourceSize: Qt.size(root.iconSize, root.iconSize)
                    }

                    Text {
                        visible: modelData.kind !== "sep"
                        anchors.left: parent.left
                        anchors.leftMargin: 8 + root.iconSize + 8
                        anchors.right: parent.right
                        anchors.rightMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.name || ""
                        font.family: fontCharcoal.name
                        font.pixelSize: root.fontSize
                        color: {
                            if (modelData.kind !== "sep" && !modelData.enabled)
                                return Config.colors.shadow;
                            return index === root.selected ? Config.colors.highlight : Config.colors.text;
                        }
                        elide: Text.ElideRight
                    }

                    MouseArea {
                        visible: modelData.kind !== "sep"
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: modelData.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onEntered: root.selected = index
                        onClicked: root.activateItem(modelData)
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
