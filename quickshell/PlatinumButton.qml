import QtQuick

Item {
    id: root

    property string text: "OK"
    property bool defaultButton: false
    property bool enabled: true

    signal clicked()

    readonly property int faceMargin: defaultButton ? 3 : 0
    implicitWidth: Math.max(defaultButton ? 80 : 70, label.implicitWidth + 24 + faceMargin * 2)
    implicitHeight: defaultButton ? 26 : 22
    opacity: enabled ? 1 : 0.45

    Rectangle {
        visible: root.defaultButton
        anchors.fill: parent
        color: "transparent"
        border.width: 2
        border.color: Config.colors.outline
        radius: 2
    }

    Rectangle {
        id: face
        anchors.fill: parent
        anchors.margins: root.faceMargin
        color: click.pressed ? Config.colors.accent : (click.containsMouse ? Config.colors.hover : Config.colors.base)
        border.width: 1
        border.color: Config.colors.outline

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 1
            anchors.rightMargin: 1
            height: 1
            color: Config.colors.highlight
        }
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 1
            width: 1
            color: Config.colors.highlight
        }
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: Config.colors.dark
        }
        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 1
            color: Config.colors.dark
        }

        Text {
            id: label
            anchors.centerIn: parent
            text: root.text
            font.family: fontCharcoal.name
            font.pixelSize: 12
            color: Config.colors.text
        }
    }

    MouseArea {
        id: click
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.clicked()
    }
}
