import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import ".."
import "../utils" as Utils

PopupWindow {
    id: root
    visible: false

    property var closeCallback: function () {}
    property int iconSize: Config.bar.menuIconSize
    property int fontSize: Config.bar.menuFontSize
    property string query: ""
    property int selected: 0

    readonly property var allApps: Utils.AppSearch.list.filter(a => !a.noDisplay)
    readonly property var filtered: query.trim().length === 0 ? allApps : Utils.AppSearch.fuzzyQuery(query)
    readonly property int count: filtered.length
    readonly property var selectedApp: count > 0 ? filtered[Math.max(0, Math.min(selected, count - 1))] : null
    readonly property int rowH: Math.max(26, fontSize + 12)
    readonly property int maxRows: Config.bar.menuMaxRows

    implicitWidth: Config.bar.menuWidth
    implicitHeight: 8 + rowH + 2 + Math.min(Math.max(count, 1), maxRows) * rowH + 6
    color: "transparent"

    function openMenu() {
        query = "";
        selected = 0;
        root.visible = true;
        openAnimation.start();
        searchInput.forceActiveFocus();
    }

    function closeMenu() {
        if (!root.visible)
            return;
        if (openAnimation.running)
            openAnimation.stop();
        frame.opacity = 0;
        root.visible = false;
        root.closeCallback();
    }

    function launchApp(app) {
        if (!app)
            return;
        root.closeMenu();
        app.execute();
    }

    Rectangle {
        id: frame
        opacity: 0
        anchors.fill: parent
        color: Config.colors.base

        Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; height: 1; color: Config.colors.highlight }
        Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: Config.colors.highlight }
        Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 1; color: Config.colors.outline }
        Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: Config.colors.outline }
        Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.bottomMargin: 1; height: 1; color: Config.colors.shadow }
        Rectangle { anchors.right: parent.right; anchors.rightMargin: 1; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: Config.colors.shadow }

        Column {
            anchors.fill: parent
            anchors.margins: 3
            spacing: 2

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
                    background: Item {}
                    onTextChanged: {
                        root.query = text;
                        root.selected = 0;
                    }
                    Keys.onEscapePressed: root.closeMenu()
                    Keys.onDownPressed: root.selected = Math.min(root.count - 1, root.selected + 1)
                    Keys.onUpPressed: root.selected = Math.max(0, root.selected - 1)
                    Keys.onReturnPressed: root.launchApp(root.selectedApp)
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: Config.colors.shadow
                }
            }

            ListView {
                id: appList
                width: parent.width
                height: Math.min(root.count, root.maxRows) * root.rowH
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
                        id: appIcon
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        width: root.iconSize
                        height: root.iconSize
                        source: Utils.AppSearch.getIcon(modelData.icon) || ""
                        sourceSize: Qt.size(root.iconSize, root.iconSize)
                    }
                    Text {
                        anchors.left: appIcon.right
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
