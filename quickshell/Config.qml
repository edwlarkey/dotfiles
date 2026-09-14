pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    //*=======================================================================*/
    // Fixed color palette (theme switching removed).
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
        None
    }

    property bool openSettingsWindow: false

    property alias settings: settingsJsonAdapter.settings
    FileView {
        path: Qt.resolvedUrl("./settings.json")
        // when changes are made on disk, reload the file's content
        watchChanges: true
        onFileChanged: reload()
        // when changes are made to properties in the adapter, save them
        onAdapterUpdated: writeAdapter()

        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                writeAdapter();
            }
        }

        JsonAdapter {
            id: settingsJsonAdapter
            property JsonObject settings: JsonObject {
                property string version: "0.1"
                property bool militaryTimeClockFormat: true
                property string systemProfileImageSource: "/home/username/Pictures/system_profile_picture.png"
                property JsonObject execCommands: JsonObject {
                    property string terminal: "kitty"
                    property string files: "nemo"
                }
                property JsonObject systemDetails: JsonObject {
                    property string osName: "Linux Distro"
                    property string osVersion: "Distro Version"
                    property string ram: "Ram"
                    property string cpu: "CPU Name"
                    property string gpu: "GPU Name"
                }
                property JsonObject bar: JsonObject {
                    property int fontSize: 12
                    property int trayIconSize: 16
                    property bool monochromeTrayIcons: true
                }
                property JsonObject macDock: JsonObject {
                    property real hiddenOpacity: 0.0
                    property int iconSize: 28
                    property int gridCols: 3
                    property var entries: [
                        {"name": "Terminal", "type": "app", "command": "kitty", "icon": "\ueb8e"},
                        {"name": "Files", "type": "folder", "path": "/home/edwlarkey", "icon": "\ue2c7"},
                        {"name": "Documents", "type": "folder", "path": "/home/edwlarkey/Documents", "icon": "\ue2c7"}
                    ]
                }
            }
        }
    }
}
