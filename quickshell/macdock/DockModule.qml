import QtQuick

import ".."

Item {
    id: root

    property var dock: null
    property string tip: ""
    property bool active: false
    property int moduleWidth: dock && dock.moduleWidth ? dock.moduleWidth : 48
    property int iconSize: dock && dock.iconSize ? dock.iconSize : 28

    readonly property bool hovered: mouse.containsMouse
    readonly property bool pressed: mouse.pressed
    readonly property bool sunken: pressed || active
    readonly property color bevelLight: sunken ? Config.colors.dark : Config.colors.highlight
    readonly property color bevelMid: sunken ? Config.colors.highlight : Config.colors.shadow
    readonly property color bevelDark: sunken ? Config.colors.highlight : Config.colors.dark

    signal clicked()
    signal wheel(var event)

    width: moduleWidth
    height: parent ? parent.height : 44

    default property alias contentData: contentItem.data

    Rectangle {
        anchors.fill: parent
        color: root.sunken ? Config.colors.accent : (root.hovered ? Config.colors.hover : "transparent")
    }

    Item {
        id: contentItem
        anchors.fill: parent
        anchors.margins: 3
    }

    Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; height: 2; color: root.bevelLight }
    Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 2; color: root.bevelLight }
    Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 2; color: root.bevelDark }
    Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 2; color: root.bevelDark }
    Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.bottomMargin: 2; height: 1; color: root.bevelMid }
    Rectangle { anchors.right: parent.right; anchors.rightMargin: 2; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: root.bevelMid }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onContainsMouseChanged: {
            if (!root.dock)
                return;
            if (containsMouse && root.tip)
                root.dock.showDockTip(root, root.tip);
            else
                root.dock.hideDockTip();
        }
        onClicked: {
            if (root.dock)
                root.dock.hideDockTip();
            root.clicked();
        }
        onWheel: event => root.wheel(event)
    }

    onTipChanged: {
        if (root.hovered && root.dock && root.tip)
            root.dock.showDockTip(root, root.tip);
    }
}
