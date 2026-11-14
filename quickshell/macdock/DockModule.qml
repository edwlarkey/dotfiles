import QtQuick

import ".."

Item {
    id: root

    property var dock: null
    property string tip: ""
    property bool active: false
    property int moduleWidth: dock && dock.moduleWidth ? dock.moduleWidth : 48
    property int iconSize: dock && dock.iconSize ? dock.iconSize : 28

    property bool menu: false

    readonly property bool hovered: mouse.containsMouse
    readonly property bool pressed: mouse.pressed
    readonly property bool sunken: pressed || active
    readonly property color face: "#c0c0c0"
    readonly property color hi: sunken ? "#808080" : "#ffffff"
    readonly property color shadeA: sunken ? "#ffffff" : "#a0a0a0"
    readonly property color shadeB: sunken ? "#ffffff" : "#808080"

    signal clicked()
    signal wheel(var event)

    width: moduleWidth + 1
    height: parent ? parent.height : 44

    default property alias contentData: contentItem.data

    Item {
        id: cell
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: root.moduleWidth

        Rectangle {
            anchors.fill: parent
            color: root.hovered && !root.sunken ? "#cccccc" : root.face
        }

        Item {
            id: contentItem
            anchors.fill: parent
            anchors.margins: 6
            anchors.rightMargin: root.menu ? 16 : 6
        }

        // Measured from a Mac OS 9 control strip: 1 px of face inside the
        // black border, a white highlight, then #a0a0a0 and #808080 on the
        // shadow edges. Doubled so it still reads at this strip height.
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: 2
            anchors.right: parent.right
            anchors.rightMargin: 6
            anchors.top: parent.top
            anchors.topMargin: 2
            height: 2
            color: root.hi
        }
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: 2
            anchors.top: parent.top
            anchors.topMargin: 2
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 6
            width: 2
            color: root.hi
        }
        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: 2
            anchors.top: parent.top
            anchors.topMargin: 4
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 4
            width: 2
            color: root.shadeA
        }
        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 2
            anchors.bottom: parent.bottom
            width: 2
            color: root.shadeB
        }
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.right: parent.right
            anchors.rightMargin: 2
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2
            height: 2
            color: root.shadeA
        }
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: 2
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 2
            color: root.shadeB
        }

        Column {
            visible: root.menu
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0
            Repeater {
                model: 7
                Rectangle {
                    readonly property int w: index < 4 ? index + 1 : 7 - index
                    width: w
                    height: 1
                    color: "#000000"
                    x: 0
                }
            }
        }
    }

    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1
        color: Config.colors.outline
    }

    MouseArea {
        id: mouse
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: root.moduleWidth
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
