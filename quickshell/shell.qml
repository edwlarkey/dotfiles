//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

/* NOTE: CHANGE THESE IF YOU WANT TO USE A DIFFERENT ICON THEME:*/
//@ pragma IconTheme nineicons-redux-v0.6
//@ pragma Env QS_ICON_THEME=nineicons-redux-v0.6

import QtQuick
import Quickshell

import "taskbar" as Taskbar
import "popups" as Popups
import "macdock" as MacDock
import "lock" as Lock
import "notifs" as Notifs
import "osd" as OsdUi
import "dashboard" as Dash

Scope {
    id: root
    FontLoader {
        id: iconFont
        source: "fonts/MaterialSymbolsSharp_Filled_36pt-Regular.ttf"
    }
    FontLoader {
        id: fontMonaco
        source: "fonts/Monaco.ttf"
    }
    FontLoader {
        id: fontCharcoal
        source: "fonts/Charcoal.ttf"
    }
    FontLoader {
        id: fontChicago
        source: "fonts/ChicagoFLF.ttf"
    }
    Taskbar.Bar {}

    MacDock.MacDock {}

    Lock.Lock {}

    Notifs.Toasts {}

    Notifs.NotificationManager {}

    OsdUi.OsdHud {}

    Dash.DashboardWindow {}

    FloatingWindow {
        id: settingsWindow
        title: "LinuxPlatinumSettingsWindow"
        reloadableId: "LinuxPlatinumSettingsWindow"
        visible: Config.openSettingsWindow
        Popups.PopupWindowFrame {
            id: settingsWindowFrame
            windowTitle: "Settings"
            windowTitleIcon: "\ue8b8"
            windowTitleDecorationWidth: (settingsWindow.width / 2) - 70

            anchors.leftMargin: -1
            anchors.bottomMargin: -1
            anchors.rightMargin: -1
            Item {
                id: content
                anchors.fill: settingsWindowFrame
                anchors.margins: 18
                anchors.topMargin: 20 + 18
                clip: true
                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    color: Config.colors.highlight
                    border.width: 1
                    border.color: Config.colors.outline
                    height: 148
                    Text {
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: fontMonaco.name
                        font.pixelSize: 28
                        text: "Linux Platinum " + Config.version
                    }
                    Text {
                        anchors.fill: parent
                        anchors.bottomMargin: 16
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom
                        font.family: fontMonaco.name
                        font.pixelSize: 12
                        text: "Version 0.1 is very early and does not yet have a proper settings menu."
                    }
                }
            }
        }
        onClosed: {
            Config.openSettingsWindow = false;
        }
    }
}
