import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import ".."

Scope {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: hud
            required property var modelData
            screen: modelData
            visible: Osd.visible
            color: "transparent"
            exclusiveZone: 0
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "linuxplatinum-osd"

            anchors {
                bottom: true
            }
            margins {
                bottom: 72
            }

            implicitWidth: 220
            implicitHeight: 78

            Rectangle {
                id: frame
                anchors.fill: parent
                color: Config.colors.base
                opacity: Osd.visible ? 1 : 0
                Bevel {}

                Behavior on opacity {
                    NumberAnimation {
                        duration: 120
                        easing.type: Easing.OutCubic
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10

                    Image {
                        Layout.preferredWidth: 32
                        Layout.preferredHeight: 32
                        Layout.alignment: Qt.AlignVCenter
                        fillMode: Image.PreserveAspectFit
                        source: Quickshell.iconPath(Osd.iconName, true) || ""
                        sourceSize: Qt.size(32, 32)
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                Layout.fillWidth: true
                                text: Osd.title
                                font.family: fontCharcoal.name
                                font.pixelSize: 12
                                color: Config.colors.text
                                elide: Text.ElideRight
                            }
                            Text {
                                text: Osd.valueText
                                font.family: fontCharcoal.name
                                font.pixelSize: 12
                                color: Config.colors.text
                            }
                        }

                        Item {
                            id: track
                            Layout.fillWidth: true
                            Layout.preferredHeight: 14

                            Rectangle {
                                anchors.fill: parent
                                color: Config.colors.shadow
                            }
                            Bevel {
                                inset: true
                            }
                            Rectangle {
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.margins: 2
                                width: Math.round((parent.width - 4) * (Osd.muted ? 0 : Math.max(0, Math.min(1, Osd.percent / 100))))
                                color: Osd.muted ? Config.colors.shadow : Config.colors.dark
                            }
                        }
                    }
                }
            }
        }
    }
}
