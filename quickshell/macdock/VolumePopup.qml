import Quickshell
import QtQuick
import QtQuick.Layouts

import ".."

PopupWindow {
    id: root
    visible: false

    property var audio: null
    property string sinkName: ""
    property var closeCallback: function () {}

    readonly property bool muted: audio ? audio.muted : false
    readonly property real volume: audio ? audio.volume : 0
    readonly property int volumePct: Math.round(Math.max(0, Math.min(1, volume)) * 100)

    implicitWidth: 176
    implicitHeight: 78
    color: "transparent"

    function openVolume() {
        root.visible = true;
        openAnimation.start();
    }

    function closeVolume() {
        if (!root.visible)
            return;
        if (openAnimation.running)
            openAnimation.stop();
        frame.opacity = 0;
        root.visible = false;
        root.closeCallback();
    }

    function applyVolume(x, width) {
        if (!audio)
            return;
        audio.muted = false;
        audio.volume = Math.max(0, Math.min(1, x / width));
    }

    Rectangle {
        id: frame
        opacity: 0
        anchors.fill: parent
        color: Config.colors.base
        Bevel {}

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 8

            Text {
                Layout.fillWidth: true
                text: root.audio ? (root.sinkName || "Output") : "No audio device"
                font.family: fontCharcoal.name
                font.pixelSize: 11
                color: Config.colors.text
                elide: Text.ElideRight
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Rectangle {
                    Layout.preferredWidth: 28
                    Layout.preferredHeight: 22
                    color: muteArea.pressed ? Config.colors.accent : (muteArea.containsMouse ? Config.colors.hover : Config.colors.base)
                    border.width: 1
                    border.color: Config.colors.dark

                    Text {
                        anchors.centerIn: parent
                        text: root.muted ? "Off" : "On"
                        font.family: fontCharcoal.name
                        font.pixelSize: 9
                        color: Config.colors.text
                    }

                    MouseArea {
                        id: muteArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        enabled: !!root.audio
                        onClicked: root.audio.muted = !root.audio.muted
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
                    Bevel { inset: true }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: 2
                        width: Math.round((parent.width - 4) * Math.max(0, Math.min(1, root.muted ? 0 : root.volume)))
                        color: root.muted ? Config.colors.shadow : Config.colors.dark
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: !!root.audio
                        cursorShape: Qt.PointingHandCursor
                        onPressed: mouse => root.applyVolume(mouse.x, width)
                        onPositionChanged: mouse => {
                            if (pressed)
                                root.applyVolume(mouse.x, width);
                        }
                    }
                }

                Text {
                    Layout.preferredWidth: 32
                    text: root.audio ? (root.muted ? "—" : root.volumePct + "%") : "—"
                    font.family: fontCharcoal.name
                    font.pixelSize: 11
                    color: Config.colors.text
                    horizontalAlignment: Text.AlignRight
                }
            }
        }

        OpacityAnimator {
            id: openAnimation
            target: frame
            from: 0
            to: 1
            duration: 140
            easing.type: Easing.OutCubic
        }
    }
}
