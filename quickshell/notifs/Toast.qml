import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import ".."

Rectangle {
    id: root

    required property var modelData
    property var notification: modelData

    readonly property var actions: notification && notification.actions ? notification.actions : []
    readonly property bool critical: notification && notification.urgency === NotificationUrgency.Critical
    readonly property int toastMs: Notifications.toastMs(notification)

    implicitWidth: Config.notifications.toastWidth
    implicitHeight: content.implicitHeight + 10
    color: Config.colors.base
    Bevel {}

    Timer {
        id: expireTimer
        interval: root.toastMs
        running: root.toastMs > 0
        repeat: false
        onTriggered: Notifications.hideToast(root.notification)
    }

    Connections {
        target: root.notification
        function onClosed() {
            Notifications.hideToast(root.notification);
        }
    }

    Column {
        id: content
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 4
        spacing: 6

        PlatinumTitleBar {
            width: parent.width
            title: Notifications.appLabel(root.notification)
            onCloseClicked: Notifications.hideToast(root.notification)
        }

        Rectangle {
            width: parent.width
            height: 1
            color: Config.colors.outline
        }

        RowLayout {
            width: parent.width
            spacing: 10

            Rectangle {
                Layout.preferredWidth: 36
                Layout.preferredHeight: 36
                Layout.alignment: Qt.AlignTop
                color: "transparent"

                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: Notifications.iconSource(root.notification)
                    sourceSize: Qt.size(36, 36)
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

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
                    maximumLineCount: 5
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
                        onClicked: {
                            modelData.invoke();
                            if (!root.notification.resident)
                                Notifications.hideToast(root.notification);
                        }
                    }
                }

                PlatinumButton {
                    text: "OK"
                    defaultButton: true
                    onClicked: Notifications.hideToast(root.notification)
                }
            }
        }
    }

    Rectangle {
        visible: root.critical
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 3
        color: Config.colors.urgent
    }

    HoverHandler {
        id: hover
        onHoveredChanged: {
            if (hover.hovered)
                expireTimer.stop();
            else if (root.toastMs > 0)
                expireTimer.restart();
        }
    }
}
