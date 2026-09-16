import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Quickshell

Item {
    id: root
    required property var auth

    readonly property color macBase: "#c8c8c8"
    readonly property color macHighlight: "#ffffff"
    readonly property color macShadow: "#808080"
    readonly property color macDark: "#404040"

    Rectangle {
        id: dialog
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: 0
        width: 400
        height: 210
        color: root.macBase

        Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; height: 1; color: root.macHighlight }
        Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: root.macHighlight }
        Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 1; color: root.macDark }
        Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: root.macDark }
        Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.bottomMargin: 1; height: 1; color: root.macShadow }
        Rectangle { anchors.right: parent.right; anchors.rightMargin: 1; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: root.macShadow }

        Item {
            id: titleBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 4
            anchors.rightMargin: 5
            anchors.topMargin: 4
            height: 20

            Rectangle {
                id: closeBox
                width: 13
                height: 13
                anchors.left: parent.left
                anchors.leftMargin: 4
                anchors.verticalCenter: parent.verticalCenter
                color: root.macBase
                border.width: 1
                border.color: "#000000"
                Rectangle { anchors.left: parent.left; anchors.top: parent.top; width: parent.width - 1; height: 1; color: root.macHighlight }
                Rectangle { anchors.left: parent.left; anchors.top: parent.top; width: 1; height: parent.height - 1; color: root.macHighlight }
                Rectangle { anchors.left: parent.left; anchors.bottom: parent.bottom; width: parent.width; height: 1; color: root.macShadow }
                Rectangle { anchors.right: parent.right; anchors.top: parent.top; width: 1; height: parent.height; color: root.macShadow }
            }

            Column {
                anchors.left: closeBox.right
                anchors.right: titleText.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                spacing: 1
                Repeater {
                    model: 6
                    Rectangle {
                        width: parent.width
                        height: 1
                        color: index % 2 === 0 ? root.macShadow : root.macHighlight
                    }
                }
            }

            Text {
                id: titleText
                anchors.centerIn: parent
                text: "  Log in  "
                font.family: fontChicago.name
                font.pixelSize: 14
                color: "#000000"
            }

            Column {
                anchors.left: titleText.right
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 8
                anchors.rightMargin: 6
                spacing: 1
                Repeater {
                    model: 6
                    Rectangle {
                        width: parent.width
                        height: 1
                        color: index % 2 === 0 ? root.macShadow : root.macHighlight
                    }
                }
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: titleBar.bottom
            anchors.topMargin: 2
            anchors.leftMargin: 5
            anchors.rightMargin: 6
            height: 1
            color: "#000000"
        }

        Text {
            id: nameLabel
            anchors.left: parent.left
            anchors.leftMargin: 28
            anchors.top: titleBar.bottom
            anchors.topMargin: 28
            width: 72
            text: "Name:"
            font.family: fontCharcoal.name
            font.pixelSize: 13
            color: "#000000"
            horizontalAlignment: Text.AlignRight
        }

        Rectangle {
            id: nameField
            anchors.left: nameLabel.right
            anchors.leftMargin: 8
            anchors.verticalCenter: nameLabel.verticalCenter
            width: 220
            height: 22
            color: root.macHighlight
            border.width: 1
            border.color: "#000000"
            Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; height: 1; color: root.macShadow }
            Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: root.macShadow }

            Text {
                anchors.left: parent.left
                anchors.right: nameArrow.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 6
                anchors.rightMargin: 4
                text: root.auth.username
                font.family: fontCharcoal.name
                font.pixelSize: 13
                color: "#000000"
                elide: Text.ElideRight
            }

            Item {
                id: nameArrow
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: 1
                width: 18
                Rectangle { anchors.left: parent.left; width: 1; height: parent.height; color: root.macShadow }
                Canvas {
                    anchors.centerIn: parent
                    width: 9
                    height: 6
                    onPaint: {
                        const c = getContext("2d");
                        c.fillStyle = "#000000";
                        c.beginPath();
                        c.moveTo(0, 1);
                        c.lineTo(9, 1);
                        c.lineTo(4.5, 6);
                        c.closePath();
                        c.fill();
                    }
                }
            }
        }

        Text {
            id: passwordLabel
            anchors.left: nameLabel.left
            anchors.right: nameLabel.right
            anchors.top: nameLabel.bottom
            anchors.topMargin: 16
            text: "Password:"
            font.family: fontCharcoal.name
            font.pixelSize: 13
            color: "#000000"
            horizontalAlignment: Text.AlignRight
        }

        Rectangle {
            id: passwordWell
            anchors.left: nameField.left
            anchors.right: nameField.right
            anchors.verticalCenter: passwordLabel.verticalCenter
            height: 22
            color: root.macHighlight
            border.width: 1
            border.color: "#000000"
            Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; height: 1; color: root.macShadow }
            Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: root.macShadow }

            TextField {
                id: passwordField
                anchors.fill: parent
                anchors.leftMargin: 4
                anchors.rightMargin: 4
                echoMode: TextInput.Password
                passwordCharacter: "•"
                font.family: fontCharcoal.name
                font.pixelSize: 13
                color: "#000000"
                selectedTextColor: root.macHighlight
                selectionColor: "#000000"
                background: Item {}
                enabled: !root.auth.authenticating
                text: root.auth.password
                onTextChanged: root.auth.password = text
                Keys.onReturnPressed: root.auth.submit()
                Keys.onEnterPressed: root.auth.submit()
                Keys.onEscapePressed: root.auth.password = ""
            }
        }

        Item {
            id: loginBtn
            anchors.right: nameField.right
            anchors.top: passwordWell.bottom
            anchors.topMargin: 18
            width: 86
            height: 28
            enabled: !root.auth.authenticating

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.width: 2
                border.color: "#000000"
                radius: 2
            }
            Rectangle {
                id: loginFace
                anchors.fill: parent
                anchors.margins: 3
                color: loginClick.pressed ? "#a8a8a8" : root.macBase
                border.width: 1
                border.color: "#000000"
                Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; anchors.leftMargin: 1; anchors.rightMargin: 1; height: 1; color: root.macHighlight }
                Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; anchors.topMargin: 1; width: 1; color: root.macHighlight }
                Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 1; color: root.macDark }
                Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: root.macDark }
                Text {
                    anchors.centerIn: parent
                    text: "Log in"
                    font.family: fontCharcoal.name
                    font.pixelSize: 12
                    color: "#000000"
                }
            }
            MouseArea {
                id: loginClick
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.auth.submit()
            }
        }

        Text {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            anchors.bottomMargin: 12
            text: root.auth.errorText.length ? root.auth.errorText : "Type a name and password to log in to this computer."
            font.family: fontCharcoal.name
            font.pixelSize: 11
            color: "#000000"
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        SequentialAnimation {
            id: shakeAnim
            NumberAnimation { target: dialog; property: "anchors.horizontalCenterOffset"; to: 14; duration: 45 }
            NumberAnimation { target: dialog; property: "anchors.horizontalCenterOffset"; to: -14; duration: 45 }
            NumberAnimation { target: dialog; property: "anchors.horizontalCenterOffset"; to: 10; duration: 40 }
            NumberAnimation { target: dialog; property: "anchors.horizontalCenterOffset"; to: -10; duration: 40 }
            NumberAnimation { target: dialog; property: "anchors.horizontalCenterOffset"; to: 0; duration: 40 }
        }

        Connections {
            target: root.auth
            function onErrorTextChanged() {
                if (root.auth.errorText.length)
                    shakeAnim.start();
            }
        }
    }

    Component.onCompleted: passwordField.forceActiveFocus()
    onVisibleChanged: if (visible) passwordField.forceActiveFocus()
}
