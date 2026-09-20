import QtQuick

import ".."

Item {
    id: root

    property string label: ""
    property int percent: 0
    property string detail: ""

    implicitHeight: root.detail.length > 0 ? 60 : 46

    Text {
        id: nameLabel
        anchors.left: parent.left
        anchors.top: parent.top
        text: root.label
        font.family: fontCharcoal.name
        font.pixelSize: Config.dashboard.fontSize
        color: Config.colors.text
    }

    Text {
        anchors.right: parent.right
        anchors.verticalCenter: nameLabel.verticalCenter
        text: root.percent + "%"
        font.family: fontCharcoal.name
        font.pixelSize: Config.dashboard.fontSize
        color: Config.colors.text
    }

    Item {
        id: track
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: nameLabel.bottom
        anchors.topMargin: 4
        height: 14

        Rectangle {
            anchors.fill: parent
            color: Config.colors.shadow
        }
        Bevel {
            inset: true
        }
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 2
            width: Math.round((parent.width - 4) * Math.max(0, Math.min(1, root.percent / 100)))
            color: Config.colors.dark
        }
    }

    Text {
        visible: root.detail.length > 0
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: track.bottom
        anchors.topMargin: 2
        text: root.detail
        font.family: fontCharcoal.name
        font.pixelSize: Config.dashboard.fontSize - 2
        color: Config.colors.dark
        elide: Text.ElideRight
    }
}
