import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import ".."

Item {
    id: root

    required property var modelData
    property var notification: modelData
    property bool selected: false

    readonly property var actions: notification && notification.actions ? notification.actions : []

    implicitHeight: col.implicitHeight + 12
    width: parent ? parent.width : 300

    Rectangle {
        anchors.fill: parent
        color: root.selected ? Config.colors.hover : "transparent"
    }

    Column {
        id: col
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 6
        spacing: 6

        RowLayout {
            width: parent.width
            spacing: 8

            Image {
                Layout.preferredWidth: 28
                Layout.preferredHeight: 28
                Layout.alignment: Qt.AlignTop
                fillMode: Image.PreserveAspectFit
                source: Notifications.iconSource(root.notification)
                sourceSize: Qt.size(28, 28)
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    Layout.fillWidth: true
                    text: Notifications.appLabel(root.notification)
                    font.family: fontCharcoal.name
                    font.pixelSize: 11
                    color: Config.colors.dark
                    elide: Text.ElideRight
                }
                Text {
                    Layout.fillWidth: true
                    visible: root.notification && root.notification.summary.length > 0
                    text: root.notification ? root.notification.summary : ""
                    font.family: fontCharcoal.name
                    font.pixelSize: 13
                    font.bold: true
                    color: Config.colors.text
                    wrapMode: Text.Wrap
                }
                Text {
                    Layout.fillWidth: true
                    visible: root.notification && root.notification.body.length > 0
                    text: root.notification ? root.notification.body : ""
                    font.family: fontCharcoal.name
                    font.pixelSize: 12
                    color: Config.colors.text
                    wrapMode: Text.Wrap
                    maximumLineCount: 4
                    elide: Text.ElideRight
                    textFormat: Text.PlainText
                }
            }
        }

        Item {
            width: parent.width
            height: 26

            Row {
                anchors.right: parent.right
                spacing: 6

                Repeater {
                    model: root.actions
                    PlatinumButton {
                        required property var modelData
                        text: modelData.text
                        onClicked: modelData.invoke()
                    }
                }

                PlatinumButton {
                    text: "OK"
                    onClicked: {
                        if (root.notification)
                            root.notification.dismiss();
                    }
                }
            }
        }
    }
}
