import Quickshell
import Quickshell.Hyprland
import QtQuick

import ".."
import "../utils" as Utils

MenuTitle {
    id: root

    readonly property var toplevel: Hyprland.activeToplevel
    readonly property string appClass: Utils.AppSearch.classOfToplevel(toplevel)
    readonly property string appName: Utils.AppSearch.nameOfToplevel(toplevel)

    text: appName
    iconName: appClass
    iconSize: Config.bar.iconSize
    fontSize: Config.bar.fontSize + 2
    maxWidth: 280
    pad: 12
}
