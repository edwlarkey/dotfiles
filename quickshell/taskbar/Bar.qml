import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick

import "../popups" as Popups
import ".."

Scope {
    Variants {
        model: Quickshell.screens
        Item {
            id: root
            required property var modelData
            property int currentPopup: Config.SystemPopup.None

            PanelWindow {
                id: taskbar
                screen: root.modelData
                WlrLayershell.layer: WlrLayer.Top
                WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

                anchors {
                    top: true
                    left: true
                    right: true
                }
                implicitHeight: Config.bar.height

                color: Config.colors.base

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: 1
                    color: Config.colors.highlight
                }
                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: Config.colors.outline
                }

                MenuTitle {
                    id: appleMenuButton
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    text: "\uF8FF"
                    fontFamily: fontChicagoKare.name
                    fontSize: Config.bar.fontSize + 8
                    pad: 12
                    active: root.currentPopup == Config.SystemPopup.SessionMenu
                    onClicked: {
                        if (root.currentPopup == Config.SystemPopup.None) {
                            appleMenu.openMenu();
                            root.currentPopup = Config.SystemPopup.SessionMenu;
                        } else {
                            taskbar.closeAllPopups();
                        }
                    }
                }

                Workspaces {
                    id: workspaces
                    anchors.left: appleMenuButton.right
                    anchors.leftMargin: 4
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                }

                AppMenu {
                    id: appMenuButton
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    pad: 12
                    active: root.currentPopup == Config.SystemPopup.AppSwitcher
                    onClicked: {
                        if (root.currentPopup == Config.SystemPopup.None) {
                            appSwitcher.openSwitcher();
                            root.currentPopup = Config.SystemPopup.AppSwitcher;
                        } else {
                            taskbar.closeAllPopups();
                        }
                    }
                }

                ClockWidget {
                    id: clockWidget
                    anchors.right: appMenuButton.left
                    anchors.rightMargin: 8
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                }

                SysTray {
                    id: sysTray
                    anchors.right: clockWidget.left
                    anchors.rightMargin: 8
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                }

                Popups.AppLauncher {
                    id: appLauncher
                    closeCallback: taskbar.closeAllPopups
                    menuWidth: taskbar.width / 2
                    popupWidth: 500
                    screenHeight: modelData.height
                }

                Popups.AppleMenu {
                    id: appleMenu
                    anchor.window: taskbar
                    anchor.item: appleMenuButton
                    anchor.edges: Edges.Bottom | Edges.Left
                    anchor.gravity: Edges.Bottom | Edges.Right
                    closeCallback: taskbar.closeAllPopups
                }

                Popups.AppSwitcher {
                    id: appSwitcher
                    anchor.window: taskbar
                    anchor.item: appMenuButton
                    anchor.edges: Edges.Bottom | Edges.Right
                    anchor.gravity: Edges.Bottom | Edges.Left
                    closeCallback: taskbar.closeAllPopups
                }

                function closeAllPopups() {
                    switch (root.currentPopup) {
                    case Config.SystemPopup.SessionMenu:
                        appleMenu.closeMenu();
                        break;
                    case Config.SystemPopup.AppLauncher:
                        appLauncher.closeAppLauncher();
                        break;
                    case Config.SystemPopup.AppSwitcher:
                        appSwitcher.closeSwitcher();
                        break;
                    }
                    root.currentPopup = Config.SystemPopup.None;
                }

                Scope {
                    id: appLauncherIpc
                    property string screenName: taskbar.screen.name
                    IpcHandler {
                        target: "appLauncher_" + appLauncherIpc.screenName
                        function toggleAppLauncher() {
                            if (root.currentPopup == Config.SystemPopup.None) {
                                appLauncher.openAppLauncher();
                                root.currentPopup = Config.SystemPopup.AppLauncher;
                            } else {
                                taskbar.closeAllPopups();
                            }
                        }
                    }
                }
            }

            PanelWindow {
                id: overlay
                screen: root.modelData
                color: "transparent"
                implicitHeight: screen.height
                anchors {
                    bottom: true
                    left: true
                    right: true
                }
                visible: root.currentPopup != Config.SystemPopup.None
                exclusionMode: ExclusionMode.Ignore

                MouseArea {
                    anchors.fill: parent
                    visible: overlay.visible
                    onClicked: taskbar.closeAllPopups()
                }
            }
        }
    }
}
