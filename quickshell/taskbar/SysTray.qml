import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import QtQuick.Effects

import ".."

Row {
    id: sysTrayRow
    spacing: 6
    height: parent ? parent.height : Config.bar.height

    Repeater {
        id: sysTray
        model: SystemTray.items

        MouseArea {
            id: trayItem
            property SystemTrayItem item: modelData
            implicitWidth: Config.bar.trayIconSize
            implicitHeight: parent.height

            onClicked: event => {
                switch (event.button) {
                case Qt.LeftButton:
                case Qt.RightButton:
                    if (item.hasMenu)
                        menu.open();
                    break;
                }
                event.accepted = true;
            }

            QsMenuAnchor {
                id: menu
                menu: trayItem.item.menu
                anchor.window: taskbar
                anchor.item: trayItem
                anchor.edges: Edges.Bottom
            }

            IconImage {
                id: trayIcon
                source: trayItem.item.icon
                anchors.centerIn: parent
                width: Config.bar.trayIconSize
                height: Config.bar.trayIconSize
                visible: false
            }
            Loader {
                anchors.fill: trayIcon
                sourceComponent: MultiEffect {
                    source: trayIcon
                    saturation: Config.bar.monochromeTrayIcons ? -1.0 : 0
                    contrast: Config.bar.monochromeTrayIcons ? 0.7 : 0.0
                    opacity: mouse.hovered || menu.visible ? 1 : 0.7
                    blurEnabled: false
                    shadowEnabled: true
                    shadowBlur: 0
                    blurMax: 1
                    shadowScale: 1
                    shadowVerticalOffset: 1
                    shadowHorizontalOffset: 1
                    shadowOpacity: 1
                    shadowColor: "black"
                }
            }
            HoverHandler {
                id: mouse
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                cursorShape: Qt.PointingHandCursor
            }
        }
    }
}
