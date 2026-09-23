import QtQuick
import QtQuick.Layouts

import ".."

Item {
    id: root

    required property var modelData
    required property int index
    property bool selected: Scrapbook.selectedIndex === index

    width: parent ? parent.width : 300
    height: 28

    Rectangle {
        anchors.fill: parent
        color: root.selected ? Config.colors.outline : (rowMouse.containsMouse ? Config.colors.hover : "transparent")
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 8

        Text {
            text: root.modelData && root.modelData.picture ? "◻" : "T"
            font.family: fontChicago.name
            font.pixelSize: 12
            color: root.selected ? Config.colors.highlight : Config.colors.dark
            Layout.preferredWidth: 14
        }
        Text {
            Layout.fillWidth: true
            text: root.modelData ? root.modelData.label : ""
            font.family: fontCharcoal.name
            font.pixelSize: Config.scrapbook.fontSize
            color: root.selected ? Config.colors.highlight : Config.colors.text
            elide: Text.ElideRight
        }
    }

    MouseArea {
        id: rowMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Scrapbook.select(root.index)
        onDoubleClicked: {
            Scrapbook.select(root.index);
            Scrapbook.copySelected();
        }
    }
}
