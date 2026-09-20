import QtQuick

import ".."

MenuTitle {
    id: root

    text: Notifications.count > 0 ? String(Notifications.count) : ""
    iconName: Notifications.count > 0 ? "dialog-information" : "dialog-messages"
    iconSize: Config.bar.iconSize
    pad: 8
    active: Notifications.managerOpen
    onClicked: Notifications.toggleManager()
}
