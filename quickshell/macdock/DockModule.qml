import QtQuick

Item {
    id: root

    property var dock: null
    property string tip: ""
    property bool active: false
    property int moduleWidth: dock && dock.moduleWidth ? dock.moduleWidth : 48
    property int iconSize: dock && dock.iconSize ? dock.iconSize : 28

    readonly property color macHighlight: dock ? dock.macHighlight : "#ffffff"
    readonly property color macShadow: dock ? dock.macShadow : "#808080"
    readonly property color macDarkShadow: dock ? dock.macDarkShadow : "#404040"
    readonly property color macButtonPressed: dock ? dock.macButtonPressed : "#a8a8a8"
    readonly property color macText: dock ? dock.macText : "#000000"
    readonly property bool hovered: mouse.containsMouse
    readonly property bool pressed: mouse.pressed
    readonly property bool sunken: pressed || active
    readonly property color bevelLight: sunken ? macDarkShadow : macHighlight
    readonly property color bevelMid: sunken ? macHighlight : macShadow
    readonly property color bevelDark: sunken ? macHighlight : macDarkShadow

    signal clicked()
    signal wheel(var event)

    width: moduleWidth
    height: parent ? parent.height : 44

    default property alias contentData: contentItem.data

    Rectangle {
        anchors.fill: parent
        color: root.sunken ? root.macButtonPressed : (root.hovered ? "#b8b8b8" : "transparent")
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
