pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    property var colors: {
        "base": "#c8c8c8",
        "shadow": "#808080",
        "highlight": "#ffffff",
        "urgent": "#ff723e",
        "accent": "#a8a8a8",
        "text": "#000000",
        "outline": "#000000",
        "outlineGradientFade": "#161616"
    }

    enum SystemPopup {
        SessionMenu,
        AppLauncher,
        AppSwitcher,
        None
    }

    property bool openSettingsWindow: false
    property string version: "0.1"

    property QtObject bar: QtObject {
        property int height: 32
        property int fontSize: 14
        property int iconSize: 18
        property int trayIconSize: 20
        property bool monochromeTrayIcons: true
        property int menuFontSize: 16
        property int menuWidth: 280
        property int menuMaxRows: 18
        property int menuIconSize: 20
    }

    property QtObject macDock: QtObject {
        property int iconSize: 28
    }
}
