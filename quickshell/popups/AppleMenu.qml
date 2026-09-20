import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls.Basic

import ".."
import "../utils" as Utils

PanelWindow {
    id: root
    visible: false
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    color: "transparent"

    anchors {
        top: true
        left: true
    }
    margins.top: Config.bar.height

    property var closeCallback: function () {}
    property int iconSize: Config.bar.menuIconSize
    property int fontSize: Config.bar.menuFontSize
    property string query: ""
    property int selected: 0
    property int subSelected: 0
    property int pendingIndex: -1
    property bool inSubmenu: false
    property bool grabActive: false

    readonly property bool filtering: query.trim().length > 0
    readonly property var filtered: {
        if (!filtering)
            return [];
        return Utils.AppSearch.fuzzyQuery(query).filter(a => !a.noDisplay);
    }
    readonly property var browseItems: {
        const groups = Utils.AppSearch.grouped;
        const out = [];
        const favs = Utils.AppSearch.favoriteApps(Config.bar.menuFavorites);
        for (let i = 0; i < favs.length; i++) {
            out.push({
                kind: "app",
                name: favs[i].name,
                app: favs[i]
            });
        }
        if (favs.length > 0)
            out.push({
                kind: "sep"
            });
        for (let i = 0; i < groups.length; i++) {
            out.push({
                kind: "category",
                name: groups[i].name,
                apps: groups[i].apps
            });
        }
        return out;
    }
    readonly property var items: filtering ? [] : browseItems
    readonly property int count: filtering ? filtered.length : items.length
    readonly property var selectedItem: {
        if (filtering)
            return null;
        if (items.length === 0)
            return null;
        return items[Math.max(0, Math.min(selected, items.length - 1))];
    }
    readonly property bool submenuOpen: !filtering && !!(selectedItem && selectedItem.kind === "category")
    readonly property var submenuApps: submenuOpen ? (selectedItem.apps || []) : []
    readonly property var selectedApp: {
        if (filtering)
            return count > 0 ? filtered[Math.max(0, Math.min(selected, count - 1))] : null;
        if (inSubmenu && submenuApps.length > 0)
            return submenuApps[Math.max(0, Math.min(subSelected, submenuApps.length - 1))];
        if (selectedItem && selectedItem.kind === "app")
            return selectedItem.app;
        return null;
    }
    readonly property int rowH: Math.max(26, fontSize + 12)
    readonly property int sepH: 8
    readonly property int maxRows: Config.bar.menuMaxRows
    readonly property int menuW: Config.bar.menuWidth
    readonly property int maxMenuH: Math.max(rowH * 4, (screen ? screen.height : 1080) - Config.bar.height - 8)
    readonly property int mainListH: {
        if (filtering)
            return Math.min(Math.max(filtered.length, 1), maxRows) * rowH;
        let h = 0;
        for (let i = 0; i < items.length; i++)
            h += items[i].kind === "sep" ? sepH : rowH;
        return Math.max(h, rowH);
    }
    readonly property int mainH: 6 + rowH + mainListH
    readonly property int subListH: Math.min(Math.max(submenuApps.length, 1), maxRows) * rowH
    readonly property int submenuH: Math.min(6 + subListH + 6, maxMenuH)
    readonly property int submenuY: {
        if (!submenuOpen)
            return 0;
        const y = 3 + rowH + itemOffset(selected);
        const maxY = Math.max(0, maxMenuH - submenuH);
        return Math.max(0, Math.min(y, maxY));
    }

    implicitWidth: menuW
    implicitHeight: Math.min(mainH, maxMenuH)

    HyprlandFocusGrab {
        active: root.grabActive
        windows: [root, subPopup]
        onCleared: {
            if (root.visible)
                root.closeMenu();
        }
    }

    Timer {
        id: hoverTimer
        interval: 140
        repeat: false
        onTriggered: {
            if (root.pendingIndex >= 0)
                root.applyHover(root.pendingIndex);
        }
    }

    function itemOffset(index) {
        let y = 0;
        for (let i = 0; i < index && i < items.length; i++)
            y += items[i].kind === "sep" ? sepH : rowH;
        return y;
    }

    function applyHover(index) {
        hoverTimer.stop();
        pendingIndex = -1;
        selected = index;
        inSubmenu = false;
        subSelected = 0;
    }

    function hoverMain(index) {
        if (index === selected) {
            hoverTimer.stop();
            pendingIndex = -1;
            return;
        }
        if (submenuOpen) {
            pendingIndex = index;
            hoverTimer.restart();
            return;
        }
        applyHover(index);
    }

    function openMenu() {
        query = "";
        selected = 0;
        subSelected = 0;
        pendingIndex = -1;
        inSubmenu = false;
        hoverTimer.stop();
        root.visible = true;
        openAnimation.start();
        Qt.callLater(() => {
            root.grabActive = true;
            searchInput.forceActiveFocus();
        });
    }

    function closeMenu() {
        if (!root.visible)
            return;
        if (openAnimation.running)
            openAnimation.stop();
        body.opacity = 0;
        hoverTimer.stop();
        root.grabActive = false;
        root.visible = false;
        root.inSubmenu = false;
        root.pendingIndex = -1;
        root.closeCallback();
    }

    function launchApp(app) {
        if (!app)
            return;
        root.closeMenu();
        app.execute();
    }

    function moveSelection(dir) {
        root.inSubmenu = false;
        if (root.filtering) {
            root.selected = Math.max(0, Math.min(root.filtered.length - 1, root.selected + dir));
            return;
        }
        let i = root.selected + dir;
        while (i >= 0 && i < root.items.length) {
            if (root.items[i].kind !== "sep") {
                root.selected = i;
                return;
            }
            i += dir;
        }
    }

    function moveSubSelection(dir) {
        if (root.submenuApps.length === 0)
            return;
        root.subSelected = Math.max(0, Math.min(root.submenuApps.length - 1, root.subSelected + dir));
        subList.positionViewAtIndex(root.subSelected, ListView.Contain);
    }

    function activate() {
        if (root.filtering) {
            root.launchApp(root.selectedApp);
            return;
        }
        if (root.inSubmenu) {
            root.launchApp(root.selectedApp);
            return;
        }
        const item = root.selectedItem;
        if (!item || item.kind === "sep")
            return;
        if (item.kind === "app") {
            root.launchApp(item.app);
            return;
        }
        root.inSubmenu = true;
        root.subSelected = 0;
    }

    Item {
        id: body
        anchors.fill: parent
        opacity: 0

        Rectangle {
            id: mainFrame
            width: root.menuW
            height: Math.min(root.mainH, root.maxMenuH)
            color: Config.colors.base
            Bevel {}

            Column {
                anchors.fill: parent
                anchors.margins: 3
                spacing: 0

                Item {
                    width: parent.width
                    height: root.rowH

                    TextField {
                        id: searchInput
                        anchors.fill: parent
                        anchors.leftMargin: 6
                        anchors.rightMargin: 6
                        text: root.query
                        font.family: fontCharcoal.name
                        font.pixelSize: root.fontSize
                        color: Config.colors.text
                        selectionColor: Config.colors.outline
                        selectedTextColor: Config.colors.highlight
                        selectByMouse: true
                        placeholderText: "Filter"
                        focus: true
                        background: Item {}
                        onTextChanged: {
                            root.query = text;
                            root.selected = 0;
                            root.subSelected = 0;
                            root.inSubmenu = false;
                        }
                        Keys.onEscapePressed: root.closeMenu()
                        Keys.onDownPressed: (event) => {
                            if (root.inSubmenu)
                                root.moveSubSelection(1);
                            else
                                root.moveSelection(1);
                            event.accepted = true;
                        }
                        Keys.onUpPressed: (event) => {
                            if (root.inSubmenu)
                                root.moveSubSelection(-1);
                            else
                                root.moveSelection(-1);
                            event.accepted = true;
                        }
                        Keys.onRightPressed: (event) => {
                            if (!root.filtering && root.selectedItem && root.selectedItem.kind === "category") {
                                root.inSubmenu = true;
                                root.subSelected = 0;
                                event.accepted = true;
                            }
                        }
                        Keys.onLeftPressed: (event) => {
                            if (root.inSubmenu) {
                                root.inSubmenu = false;
                                event.accepted = true;
                            }
                        }
                        Keys.onReturnPressed: root.activate()
                        Keys.onEnterPressed: root.activate()
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 1
                        color: Config.colors.shadow
                    }
                }

                Item {
                    width: parent.width
                    height: root.mainListH
                    clip: true

                ListView {
                    id: appList
                    visible: root.filtering
                    anchors.fill: parent
                    model: root.filtered
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    currentIndex: root.selected
                    highlightFollowsCurrentItem: true
                    highlightMoveDuration: 0

                    delegate: Item {
                        required property var modelData
                        required property int index
                        width: appList.width
                        height: root.rowH

                        Rectangle {
                            anchors.fill: parent
                            color: index === root.selected ? Config.colors.outline : "transparent"
                        }

                        Image {
                            id: filterIcon
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            width: root.iconSize
                            height: root.iconSize
                            source: Utils.AppSearch.getIcon(modelData.icon) || ""
                            sourceSize: Qt.size(root.iconSize, root.iconSize)
                        }
                        Text {
                            anchors.left: filterIcon.right
                            anchors.leftMargin: 8
                            anchors.right: parent.right
                            anchors.rightMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.name
                            font.family: fontCharcoal.name
                            font.pixelSize: root.fontSize
                            color: index === root.selected ? Config.colors.highlight : Config.colors.text
                            elide: Text.ElideRight
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: root.selected = index
                            onClicked: root.launchApp(modelData)
                        }
                    }
                }

                Column {
                    visible: !root.filtering
                    anchors.fill: parent

                Repeater {
                    model: root.filtering ? [] : root.items
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
                            id: browseIcon
                            visible: modelData.kind === "app"
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            width: root.iconSize
                            height: root.iconSize
                            source: modelData.kind === "app" ? (Utils.AppSearch.getIcon(modelData.app.icon) || "") : ""
                            sourceSize: Qt.size(root.iconSize, root.iconSize)
                        }

                        Text {
                            visible: modelData.kind !== "sep"
                            anchors.left: parent.left
                            anchors.leftMargin: modelData.kind === "app" ? 8 + root.iconSize + 8 : 8
                            anchors.right: parent.right
                            anchors.rightMargin: modelData.kind === "category" ? 22 : 8
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.name || ""
                            font.family: fontCharcoal.name
                            font.pixelSize: root.fontSize
                            color: index === root.selected ? Config.colors.highlight : Config.colors.text
                            elide: Text.ElideRight
                        }

                        Text {
                            visible: modelData.kind === "category"
                            anchors.right: parent.right
                            anchors.rightMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            text: "▸"
                            font.family: fontCharcoal.name
                            font.pixelSize: root.fontSize
                            color: index === root.selected ? Config.colors.highlight : Config.colors.text
                        }

                        MouseArea {
                            visible: modelData.kind !== "sep"
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: modelData.kind === "app" ? Qt.PointingHandCursor : Qt.ArrowCursor
                            onEntered: root.hoverMain(index)
                            onClicked: {
                                if (modelData.kind === "app")
                                    root.launchApp(modelData.app);
                                else {
                                    root.inSubmenu = true;
                                    root.subSelected = 0;
                                }
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
            target: body
            from: 0
            to: 1
            duration: 140
            easing.type: Easing.OutCubic
        }
    }

    PopupWindow {
        id: subPopup
        visible: root.visible && root.submenuOpen
        color: "transparent"
        grabFocus: false
        implicitWidth: root.menuW
        implicitHeight: root.submenuH
        anchor.window: root
        anchor.rect.x: root.menuW - 1
        anchor.rect.y: root.submenuY
        anchor.rect.width: 1
        anchor.rect.height: 1
        anchor.edges: Edges.Top | Edges.Left
        anchor.gravity: Edges.Bottom | Edges.Right

        Connections {
            target: root
            function onSubmenuYChanged() {
                if (subPopup.visible)
                    subPopup.anchor.updateAnchor();
            }
            function onSubmenuHChanged() {
                if (subPopup.visible)
                    subPopup.anchor.updateAnchor();
            }
        }

        Rectangle {
            id: subFrame
            anchors.fill: parent
            color: Config.colors.base
            Bevel {}

            ListView {
                id: subList
                anchors.fill: parent
                anchors.margins: 3
                model: root.submenuApps
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                interactive: root.submenuApps.length > root.maxRows
                highlightFollowsCurrentItem: false

                delegate: Item {
                    required property var modelData
                    required property int index
                    width: subList.width
                    height: root.rowH

                    Rectangle {
                        anchors.fill: parent
                        color: root.inSubmenu && index === root.subSelected ? Config.colors.outline : "transparent"
                    }

                    Image {
                        id: subIcon
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        width: root.iconSize
                        height: root.iconSize
                        source: Utils.AppSearch.getIcon(modelData.icon) || ""
                        sourceSize: Qt.size(root.iconSize, root.iconSize)
                    }
                    Text {
                        anchors.left: subIcon.right
                        anchors.leftMargin: 8
                        anchors.right: parent.right
                        anchors.rightMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.name
                        font.family: fontCharcoal.name
                        font.pixelSize: root.fontSize
                        color: root.inSubmenu && index === root.subSelected ? Config.colors.highlight : Config.colors.text
                        elide: Text.ElideRight
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: {
                            hoverTimer.stop();
                            root.pendingIndex = -1;
                            root.inSubmenu = true;
                            root.subSelected = index;
                        }
                        onClicked: root.launchApp(modelData)
                    }
                }
            }
        }
    }
}
