import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import ".."

PopupWindow {
    id: root
    visible: false

    property int menuWidth: 0
    property var closeCallback: function () {}
    anchor.window: taskbar
    anchor.rect.x: menuWidth
    anchor.rect.y: parentWindow.implicitHeight
    implicitWidth: 220
    implicitHeight: 210
    color: "transparent"

    Rectangle {
        id: frame
        opacity: 0
        anchors.fill: parent
        color: Config.colors.base
        layer.enabled: true

        PopupWindowFrame {
            id: sessionMenuFrame
            windowTitle: "Special"
            windowTitleIcon: "\uf011"
            windowTitleDecorationWidth: 35
            
            Item {
                id: content
                anchors.fill: sessionMenuFrame
                anchors.margins: 12
                anchors.topMargin: 38

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 4
                    
                    Repeater {
                        model: [
                            {"name": "Sleep", "cmd": ["systemctl", "suspend"], "icon": "\uf186"},
                            {"name": "Restart", "cmd": ["systemctl", "reboot"], "icon": "\uf021"},
                            {"name": "Shut Down", "cmd": ["systemctl", "poweroff"], "icon": "\uf011"},
                            {"name": "Lock Screen", "cmd": ["hyprlock"], "icon": "\uf023"},
                            {"name": "Log Out", "cmd": ["hyprctl", "dispatch", "exit"], "icon": "\uf08b"}
                        ]
                        
                        delegate: Button {
                            id: actionBtn
                            Layout.fillWidth: true
                            implicitHeight: 28
                            
                            onClicked: () => {
                                root.closeCallback();
                                Quickshell.execDetached(modelData.cmd);
                            }
                            
                            background: Rectangle {
                                color: actionBtn.pressed ? Config.colors.accent : (mouseArea.containsMouse ? Config.colors.highlight : "transparent")
                            }
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                spacing: 14
                                
                                Text {
                                    font.family: iconFont.name
                                    text: modelData.icon
                                    font.pixelSize: 14
                                    color: actionBtn.pressed ? Config.colors.highlight : Config.colors.text
                                }
                                Text {
                                    text: modelData.name
                                    font.pixelSize: 14
                                    color: actionBtn.pressed ? Config.colors.highlight : Config.colors.text
                                }
                            }
                            
                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: actionBtn.clicked()
                            }
                        }
                    }
                }
            }
        }

        /*=== Animations ===*/
        OpacityAnimator {
            id: openAnimation
            target: frame
            from: 0
            to: 1
            duration: 140
            easing.type: Easing.OutCubic
        }
    }

    function openSessionMenu() {
        root.visible = true;
        openAnimation.start();
    }

    function closeSessionMenu() {
        if (openAnimation.running) {
            openAnimation.stop();
        }
        frame.opacity = 0;
        root.visible = false;
    }
}
