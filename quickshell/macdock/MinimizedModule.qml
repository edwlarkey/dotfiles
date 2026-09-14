import QtQuick

DockModule {
    id: root

    property int count: 0

    tip: count > 0 ? "Minimized (" + count + ")" : "Minimized"

    Column {
        anchors.centerIn: parent
        spacing: 4
        Repeater {
            model: 2
            Rectangle {
                width: 18
                height: 4
                color: root.macDarkShadow
                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1
                    color: root.macHighlight
                }
            }
        }
    }

    Rectangle {
        visible: root.count > 0
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 4
        width: root.count > 9 ? 18 : 14
        height: 12
        color: root.macDarkShadow
        Text {
            anchors.centerIn: parent
            text: root.count > 9 ? "9+" : "" + root.count
            font.family: fontCharcoal.name
            font.pixelSize: 9
            color: root.macHighlight
        }
    }
}
