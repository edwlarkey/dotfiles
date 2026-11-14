import QtQuick

Item {
    id: root

    property string title: ""
    property bool showClose: true

    signal closeClicked()

    implicitHeight: 20
    height: 20

    Rectangle {
        id: closeBox
        visible: root.showClose
        width: 13
        height: 13
        anchors.left: parent.left
        anchors.leftMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        color: Config.colors.base
        border.width: 1
        border.color: Config.colors.outline

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            width: parent.width - 1
            height: 1
            color: Config.colors.highlight
        }
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            width: 1
            height: parent.height - 1
            color: Config.colors.highlight
        }
        Rectangle {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: Config.colors.shadow
        }
        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            width: 1
            height: parent.height
            color: Config.colors.shadow
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.closeClicked()
        }
    }

    Column {
        anchors.left: root.showClose ? closeBox.right : parent.left
        anchors.right: titleText.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: root.showClose ? 8 : 6
        anchors.rightMargin: 8
        spacing: 0
        Repeater {
            model: 6
            Item {
                width: parent.width
                height: 1
                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: index % 2 === 1 ? 1 : 0
                    anchors.rightMargin: index % 2 === 0 ? 1 : 0
                    height: 1
                    color: index % 2 === 0 ? Config.colors.highlight : Config.colors.stripe
                }
            }
        }
    }

    Text {
        id: titleText
        anchors.centerIn: parent
        text: "  " + root.title + "  "
        font.family: fontCharcoal.name
        font.pixelSize: 13
        color: Config.colors.text
    }

    Column {
        anchors.left: titleText.right
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 8
        anchors.rightMargin: 6
        spacing: 0
        Repeater {
            model: 6
            Item {
                width: parent.width
                height: 1
                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: index % 2 === 1 ? 1 : 0
                    anchors.rightMargin: index % 2 === 0 ? 1 : 0
                    height: 1
                    color: index % 2 === 0 ? Config.colors.highlight : Config.colors.stripe
                }
            }
        }
    }
}
