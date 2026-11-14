import QtQuick

// 1 px menu drop shadow. The parent is 1 px larger than the frame on the
// right and bottom; this paints into that margin.
Item {
    anchors.fill: parent
    z: 30

    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 2
        width: 1
        color: Config.colors.menuShadow
    }
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 2
        height: 1
        color: Config.colors.menuShadow
    }
}
