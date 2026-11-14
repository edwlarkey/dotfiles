import QtQuick

// Open-menu and selected-row highlight. Caller sets the geometry.
// Bottom row is the accent's deep shade; leave 1 px below it on the menu bar
// so the bar's black line stays black.
Item {
    Rectangle {
        anchors.fill: parent
        color: Config.colors.accentBody
    }
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 1
        anchors.top: parent.top
        height: 1
        color: Config.colors.accentTop
    }
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1
        color: Config.colors.accentTop
    }
    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1
        color: Config.colors.accentBottom
    }
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: Config.colors.accentBottom
    }
}
