import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import ".."

Scope {
    PanelWindow {
        id: win
        visible: Dashboard.open
        color: "transparent"
        exclusiveZone: 0
        exclusionMode: ExclusionMode.Normal
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
        WlrLayershell.namespace: "linuxplatinum-dashboard"

        anchors {
            top: true
            right: true
        }
        margins {
            top: 0
            right: 0
        }

        implicitWidth: Config.dashboard.width
        implicitHeight: Config.dashboard.height

        HyprlandFocusGrab {
            active: win.visible
            windows: [win]
            onCleared: {
                if (Dashboard.open)
                    Dashboard.close();
            }
        }

        Rectangle {
            id: frame
            anchors.fill: parent
            color: Config.colors.base
            Bevel {}

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 4
                spacing: 6

                PlatinumTitleBar {
                    Layout.fillWidth: true
                    title: "Dashboard"
                    onCloseClicked: Dashboard.close()
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: Config.colors.outline
                }

                Flickable {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    contentWidth: width
                    contentHeight: body.implicitHeight

                    Column {
                        id: body
                        width: parent.width
                        spacing: 8

                        Rectangle {
                            width: parent.width
                            height: mediaCol.implicitHeight + 16
                            color: Config.colors.highlight
                            border.width: 1
                            border.color: Config.colors.outline

                            Column {
                                id: mediaCol
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.margins: 8
                                spacing: 6

                                Text {
                                    text: "Now Playing"
                                    font.family: fontCharcoal.name
                                    font.pixelSize: Config.dashboard.fontSize
                                    font.bold: true
                                    color: Config.colors.text
                                }

                                RowLayout {
                                    width: parent.width
                                    spacing: 8

                                    Rectangle {
                                        Layout.preferredWidth: 48
                                        Layout.preferredHeight: 48
                                        color: Config.colors.base
                                        border.width: 1
                                        border.color: Config.colors.outline

                                        Image {
                                            anchors.fill: parent
                                            anchors.margins: 1
                                            fillMode: Image.PreserveAspectCrop
                                            source: Dashboard.trackArt
                                            visible: Dashboard.trackArt.length > 0
                                        }
                                        Text {
                                            visible: Dashboard.trackArt.length === 0
                                            anchors.centerIn: parent
                                            text: "♪"
                                            font.family: fontChicago.name
                                            font.pixelSize: Config.dashboard.fontSize + 6
                                            color: Config.colors.dark
                                        }
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 2
                                        Text {
                                            Layout.fillWidth: true
                                            text: Dashboard.trackTitle
                                            font.family: fontCharcoal.name
                                            font.pixelSize: Config.dashboard.fontSize + 1
                                            color: Config.colors.text
                                            elide: Text.ElideRight
                                        }
                                        Text {
                                            Layout.fillWidth: true
                                            visible: Dashboard.trackArtist.length > 0
                                            text: Dashboard.trackArtist
                                            font.family: fontCharcoal.name
                                            font.pixelSize: Config.dashboard.fontSize - 1
                                            color: Config.colors.dark
                                            elide: Text.ElideRight
                                        }
                                    }
                                }

                                Row {
                                    anchors.right: parent.right
                                    spacing: 6
                                    PlatinumButton {
                                        text: "Prev"
                                        enabled: !!(Dashboard.player && Dashboard.player.canGoPrevious)
                                        onClicked: Dashboard.player.previous()
                                    }
                                    PlatinumButton {
                                        text: Dashboard.playing ? "Pause" : "Play"
                                        enabled: !!(Dashboard.player && Dashboard.player.canTogglePlaying)
                                        defaultButton: true
                                        onClicked: Dashboard.player.togglePlaying()
                                    }
                                    PlatinumButton {
                                        text: "Next"
                                        enabled: !!(Dashboard.player && Dashboard.player.canGoNext)
                                        onClicked: Dashboard.player.next()
                                    }
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: weatherCol.implicitHeight + 16
                            color: Config.colors.highlight
                            border.width: 1
                            border.color: Config.colors.outline

                            Column {
                                id: weatherCol
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.margins: 8
                                spacing: 4

                                Text {
                                    text: "Weather"
                                    font.family: fontCharcoal.name
                                    font.pixelSize: Config.dashboard.fontSize
                                    font.bold: true
                                    color: Config.colors.text
                                }
                                Text {
                                    width: parent.width
                                    text: Dashboard.weatherText
                                    font.family: fontCharcoal.name
                                    font.pixelSize: Config.dashboard.fontSize + 4
                                    color: Config.colors.text
                                    wrapMode: Text.Wrap
                                }
                                Text {
                                    width: parent.width
                                    visible: Dashboard.weatherDetail.length > 0
                                    text: Dashboard.weatherDetail
                                    font.family: fontCharcoal.name
                                    font.pixelSize: Config.dashboard.fontSize - 1
                                    color: Config.colors.dark
                                    wrapMode: Text.Wrap
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: vpnCol.implicitHeight + 16
                            color: Config.colors.highlight
                            border.width: 1
                            border.color: Config.colors.outline

                            Column {
                                id: vpnCol
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.margins: 8
                                spacing: 4

                                Text {
                                    text: "VPN"
                                    font.family: fontCharcoal.name
                                    font.pixelSize: Config.dashboard.fontSize
                                    font.bold: true
                                    color: Config.colors.text
                                }
                                Text {
                                    width: parent.width
                                    text: Dashboard.vpnConnected ? ((Dashboard.vpnKind || "VPN") + " connected") : "Disconnected"
                                    font.family: fontCharcoal.name
                                    font.pixelSize: Config.dashboard.fontSize + 1
                                    color: Config.colors.text
                                }
                                Text {
                                    width: parent.width
                                    visible: Dashboard.vpnDetail.length > 0
                                    text: Dashboard.vpnDetail
                                    font.family: fontCharcoal.name
                                    font.pixelSize: Config.dashboard.fontSize - 1
                                    color: Config.colors.dark
                                    wrapMode: Text.Wrap
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: statsCol.implicitHeight + 16
                            color: Config.colors.highlight
                            border.width: 1
                            border.color: Config.colors.outline

                            Column {
                                id: statsCol
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.margins: 8
                                spacing: 10

                                Text {
                                    text: "Memory"
                                    font.family: fontCharcoal.name
                                    font.pixelSize: Config.dashboard.fontSize
                                    font.bold: true
                                    color: Config.colors.text
                                }
                                Meter {
                                    width: parent.width
                                    label: "CPU"
                                    percent: Dashboard.cpuPct
                                }
                                Meter {
                                    width: parent.width
                                    label: "RAM"
                                    percent: Dashboard.memPct
                                    detail: Dashboard.memText
                                }
                                Meter {
                                    width: parent.width
                                    label: "Disk"
                                    percent: Dashboard.diskPct
                                    detail: Dashboard.diskText
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
