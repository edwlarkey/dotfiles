import Quickshell
import QtQuick

import ".."

Item {
    id: root

    property string text: ""
    property string iconName: ""
    property int iconSize: Config.bar.iconSize
    property bool active: false
    property int pad: 8
    property int maxWidth: 0
    property string fontFamily: fontCharcoal.name
    property int fontSize: Config.bar.fontSize

    readonly property bool hovered: mouse.containsMouse
    readonly property bool lit: active || hovered

    signal clicked()

    implicitWidth: {
        const iconW = root.iconName !== "" ? root.iconSize + 6 : 0;
        const textW = label.implicitWidth;
        const w = iconW + textW + pad * 2;
        return maxWidth > 0 ? Math.min(maxWidth, Math.max(pad * 2 + iconSize, w)) : Math.max(pad * 2, w);
    }
    implicitHeight: parent ? parent.height : Config.bar.height

    Rectangle {
        anchors.fill: parent
        color: root.lit ? Config.colors.outline : "transparent"
    }

    Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: root.pad
        spacing: 6

        Image {
            visible: root.iconName !== ""
            anchors.verticalCenter: parent.verticalCenter
            width: root.iconSize
            height: root.iconSize
            source: root.iconName ? (Quickshell.iconPath(root.iconName, true) || "") : ""
            sourceSize: Qt.size(width, height)
        }

        Text {
            id: label
            visible: root.text !== ""
            anchors.verticalCenter: parent.verticalCenter
            text: root.text
            font.family: root.fontFamily
            font.pixelSize: root.fontSize
            color: root.lit ? Config.colors.highlight : Config.colors.text
            elide: Text.ElideRight
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
