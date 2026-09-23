import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import ".."

Scope {
    PanelWindow {
        id: win
        visible: Scrapbook.open
        color: "transparent"
        exclusiveZone: 0
        exclusionMode: ExclusionMode.Normal
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
        WlrLayershell.namespace: "linuxplatinum-scrapbook"

        anchors {
            bottom: true
            left: true
        }
        margins {
            bottom: 44
            left: 0
        }

        implicitWidth: Config.scrapbook.width
        implicitHeight: Config.scrapbook.height
        onVisibleChanged: if (visible) frame.forceActiveFocus()

        HyprlandFocusGrab {
            active: win.visible
            windows: [win]
            onCleared: {
                if (Scrapbook.open)
                    Scrapbook.close();
            }
        }

        Rectangle {
            id: frame
            anchors.fill: parent
            color: Config.colors.base
            focus: win.visible
            Bevel {}

            Keys.onPressed: event => {
                if (event.key === Qt.Key_Escape) {
                    Scrapbook.close();
                    event.accepted = true;
                } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    Scrapbook.copySelected();
                    event.accepted = true;
                } else if (event.key === Qt.Key_Delete || event.key === Qt.Key_Backspace) {
                    Scrapbook.deleteSelected();
                    event.accepted = true;
                } else if (event.key === Qt.Key_Down) {
                    Scrapbook.select(Scrapbook.selectedIndex + 1);
                    event.accepted = true;
                } else if (event.key === Qt.Key_Up) {
                    Scrapbook.select(Scrapbook.selectedIndex - 1);
                    event.accepted = true;
                }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 4
                spacing: 6

                PlatinumTitleBar {
                    Layout.fillWidth: true
                    title: "Scrapbook"
                    onCloseClicked: Scrapbook.close()
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: Config.colors.outline
                }

                Rectangle {
                    id: listWell
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Config.colors.highlight
                    border.width: 1
                    border.color: Config.colors.outline

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        height: 1
                        color: Config.colors.shadow
                    }
                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 1
                        color: Config.colors.shadow
                    }

                    ListView {
                        id: list
                        anchors.fill: parent
                        anchors.margins: 2
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds
                        keyNavigationEnabled: false
                        model: Scrapbook.items
                        spacing: 0
                        currentIndex: Scrapbook.selectedIndex

                        delegate: ScrapbookRow {
                            width: list.width
                        }
                    }

                    Text {
                        visible: Scrapbook.count === 0
                        anchors.centerIn: parent
                        text: "The Scrapbook is empty."
                        font.family: fontCharcoal.name
                        font.pixelSize: 13
                        color: Config.colors.dark
                    }
                }

                Rectangle {
                    id: previewWell
                    Layout.fillWidth: true
                    Layout.preferredHeight: Scrapbook.previewImage.length ? 160 : 96
                    color: Config.colors.highlight
                    border.width: 1
                    border.color: Config.colors.outline

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        height: 1
                        color: Config.colors.shadow
                    }
                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 1
                        color: Config.colors.shadow
                    }

                    Image {
                        visible: Scrapbook.previewImage.length > 0
                        anchors.fill: parent
                        anchors.margins: 4
                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                        source: Scrapbook.previewImage
                    }

                    Text {
                        visible: Scrapbook.previewImage.length === 0
                        anchors.fill: parent
                        anchors.margins: 8
                        text: Scrapbook.count === 0 ? "" : Scrapbook.previewText
                        font.family: fontCharcoal.name
                        font.pixelSize: Config.scrapbook.fontSize
                        color: Config.colors.text
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                        textFormat: Text.PlainText
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 26

                    Row {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: Scrapbook.count === 1 ? "1 clipping" : (Scrapbook.count + " clippings")
                            font.family: fontCharcoal.name
                            font.pixelSize: 12
                            color: Config.colors.text
                        }

                        Item {
                            width: picsRow.width
                            height: 26

                            Row {
                                id: picsRow
                                spacing: 6
                                anchors.verticalCenter: parent.verticalCenter

                                Rectangle {
                                    id: picsBox
                                    width: 13
                                    height: 13
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: Config.colors.highlight
                                    border.width: 1
                                    border.color: Config.colors.outline
                                    Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; height: 1; color: Config.colors.shadow }
                                    Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: Config.colors.shadow }
                                    Text {
                                        anchors.centerIn: parent
                                        visible: Scrapbook.showPictures
                                        text: "×"
                                        font.family: fontChicago.name
                                        font.pixelSize: 12
                                        color: Config.colors.text
                                    }
                                }
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Pictures"
                                    font.family: fontCharcoal.name
                                    font.pixelSize: 12
                                    color: Config.colors.text
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    Scrapbook.showPictures = !Scrapbook.showPictures;
                                    Scrapbook.refresh();
                                }
                            }
                        }
                    }

                    Row {
                        anchors.right: parent.right
                        spacing: 6

                        PlatinumButton {
                            text: "Clear"
                            enabled: Scrapbook.count > 0
                            onClicked: Scrapbook.clearAll()
                        }
                        PlatinumButton {
                            text: "Delete"
                            enabled: Scrapbook.count > 0
                            onClicked: Scrapbook.deleteSelected()
                        }
                        PlatinumButton {
                            text: "Copy"
                            defaultButton: true
                            enabled: Scrapbook.count > 0
                            onClicked: Scrapbook.copySelected()
                        }
                    }
                }
            }
        }

        Connections {
            target: Scrapbook
            function onSelectedIndexChanged() {
                list.positionViewAtIndex(Scrapbook.selectedIndex, ListView.Contain);
            }
        }
    }
}
