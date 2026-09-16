import QtQuick

Item {
    id: root
    anchors.fill: parent
    property int size: 1
    property bool inset: false
    z: 10

    readonly property color light: inset ? Config.colors.dark : Config.colors.highlight
    readonly property color dark: inset ? Config.colors.highlight : Config.colors.dark
    readonly property color mid: Config.colors.shadow

    Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; height: root.size; color: root.light }
    Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: root.size; color: root.light }
    Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: root.size; color: root.dark }
    Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom; width: root.size; color: root.dark }
    Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.bottomMargin: root.size; height: 1; color: root.mid }
    Rectangle { anchors.right: parent.right; anchors.rightMargin: root.size; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: root.mid }
}
