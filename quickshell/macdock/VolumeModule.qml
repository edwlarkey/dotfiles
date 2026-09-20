import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

DockModule {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var audio: sink && sink.audio ? sink.audio : null
    readonly property bool muted: audio ? audio.muted : false
    readonly property real volume: audio ? audio.volume : 0
    readonly property string sinkName: {
        if (!sink)
            return "";
        return sink.nickname || sink.description || sink.name || "";
    }
    readonly property int volumePct: Math.round(Math.max(0, Math.min(1, volume)) * 100)
    readonly property string iconName: {
        if (muted || volume <= 0)
            return "audio-volume-muted";
        if (volume < 0.34)
            return "audio-volume-low";
        if (volume < 0.67)
            return "audio-volume-medium";
        return "audio-volume-high";
    }

    tip: {
        if (!audio)
            return "Volume";
        if (muted || volume <= 0)
            return "Muted";
        return "Volume " + volumePct + "%";
    }

    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }

    function setVolume(value) {
        Osd.setVolume(value);
    }

    onWheel: event => {
        if (!audio)
            return;
        const dy = event.angleDelta.y;
        if (dy === 0)
            return;
        setVolume(volume + (dy > 0 ? 0.05 : -0.05));
        event.accepted = true;
    }

    Image {
        anchors.centerIn: parent
        width: root.iconSize
        height: root.iconSize
        source: Quickshell.iconPath(root.iconName, true) || ""
        sourceSize: Qt.size(width, height)
    }
}
