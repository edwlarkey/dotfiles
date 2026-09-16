pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    property var colors: {
        "base": "#c8c8c8",
        "shadow": "#808080",
        "dark": "#404040",
        "highlight": "#ffffff",
        "hover": "#b8b8b8",
        "urgent": "#ff723e",
        "accent": "#a8a8a8",
        "text": "#000000",
        "outline": "#000000",
        "desktop": "#8c8c8c"
    }

    enum SystemPopup {
        SessionMenu,
        AppList,
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
        property var entries: [
            {"name": "Terminal", "type": "app", "command": "ghostty", "iconName": "utilities-terminal"},
            {"name": "Browser", "type": "app", "command": "firefox", "iconName": "firefox"},
            {"name": "Notes", "type": "app", "command": "obsidian", "iconName": "text-editor"},
            {"name": "Files", "type": "folder", "path": "/home/edwlarkey", "iconName": "system-file-manager"},
            {"name": "Documents", "type": "folder", "path": "/home/edwlarkey/Sync/docs", "iconName": "folder-documents"}
        ]
    }
}
