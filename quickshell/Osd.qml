pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick

Singleton {
    id: root

    property bool visible: false
    property string kind: "volume"
    property bool suppress: true

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource
    readonly property var sinkAudio: sink && sink.audio ? sink.audio : null
    readonly property var sourceAudio: source && source.audio ? source.audio : null

    readonly property bool volumeMuted: sinkAudio ? sinkAudio.muted : false
    readonly property real volume: sinkAudio ? sinkAudio.volume : 0
    readonly property int volumePct: Math.round(Math.max(0, Math.min(1, volume)) * 100)

    readonly property bool micMuted: sourceAudio ? sourceAudio.muted : false
    readonly property real micVolume: sourceAudio ? sourceAudio.volume : 0
    readonly property int micPct: Math.round(Math.max(0, Math.min(1, micVolume)) * 100)

    property int brightnessPct: 0
    property bool brightnessReady: false
    property bool hasBrightnessctl: false
    property string backlightDevice: ""

    readonly property bool muted: kind === "mic" ? micMuted : (kind === "volume" ? volumeMuted : false)
    readonly property int percent: {
        if (kind === "brightness")
            return brightnessPct;
        if (kind === "mic")
            return micMuted ? 0 : micPct;
        return volumeMuted ? 0 : volumePct;
    }
    readonly property string title: {
        if (kind === "brightness")
            return "Brightness";
        if (kind === "mic")
            return "Microphone";
        return "Volume";
    }
    readonly property string iconName: {
        if (kind === "brightness") {
            if (brightnessPct < 34)
                return "display-brightness-low";
            if (brightnessPct < 67)
                return "display-brightness-medium";
            return "display-brightness-high";
        }
        if (kind === "mic")
            return micMuted || micVolume <= 0 ? "microphone-sensitivity-muted" : "audio-input-microphone";
        if (volumeMuted || volume <= 0)
            return "audio-volume-muted";
        if (volume < 0.34)
            return "audio-volume-low";
        if (volume < 0.67)
            return "audio-volume-medium";
        return "audio-volume-high";
    }
    readonly property string valueText: {
        if (kind === "mic" && micMuted)
            return "Mute";
        if (kind === "volume" && volumeMuted)
            return "Mute";
        return percent + "%";
    }

    PwObjectTracker {
        objects: [root.sink, root.source].filter(n => n)
    }

    function show(kind) {
        if (root.suppress)
            return;
        root.kind = kind;
        root.visible = true;
        hideTimer.restart();
    }

    function setVolume(value) {
        if (!sinkAudio)
            return;
        sinkAudio.muted = false;
        sinkAudio.volume = Math.max(0, Math.min(1, value));
        show("volume");
    }

    function volumeUp() {
        setVolume(volume + 0.05);
    }

    function volumeDown() {
        setVolume(volume - 0.05);
    }

    function toggleMute() {
        if (!sinkAudio)
            return;
        sinkAudio.muted = !sinkAudio.muted;
        show("volume");
    }

    function setMic(value) {
        if (!sourceAudio)
            return;
        sourceAudio.muted = false;
        sourceAudio.volume = Math.max(0, Math.min(1, value));
        show("mic");
    }

    function toggleMic() {
        if (!sourceAudio)
            return;
        sourceAudio.muted = !sourceAudio.muted;
        show("mic");
    }

    function brightnessUp() {
        if (!hasBrightnessctl)
            return;
        brightnessProc.exec(["brightnessctl", "-m", "set", "10%+"]);
    }

    function brightnessDown() {
        if (!hasBrightnessctl)
            return;
        brightnessProc.exec(["brightnessctl", "-m", "set", "10%-"]);
    }

    function applyBrightnessText(raw) {
        const line = String(raw || "").trim().split("\n").pop();
        if (!line)
            return false;
        const match = line.match(/(\d+)%/);
        let pct = match ? parseInt(match[1], 10) : NaN;
        if (isNaN(pct)) {
            const parts = line.split(",");
            if (parts.length >= 5) {
                const cur = parseInt(parts[2], 10);
                const max = parseInt(parts[4], 10);
                if (max > 0)
                    pct = Math.round((cur / max) * 100);
            }
        }
        if (isNaN(pct))
            return false;
        const next = Math.max(0, Math.min(100, pct));
        const changed = next !== root.brightnessPct;
        root.brightnessPct = next;
        if (root.brightnessReady && changed)
            root.show("brightness");
        root.brightnessReady = true;
        return true;
    }

    function refreshBrightness() {
        if (!hasBrightnessctl)
            return;
        brightnessQuery.running = false;
        brightnessQuery.running = true;
    }

    Timer {
        id: bootTimer
        interval: 500
        running: true
        repeat: false
        onTriggered: root.suppress = false
    }

    Timer {
        id: hideTimer
        interval: Config.osd.timeout
        repeat: false
        onTriggered: root.visible = false
    }

    Connections {
        target: root.sinkAudio
        function onVolumeChanged() {
            root.show("volume");
        }
        function onMutedChanged() {
            root.show("volume");
        }
    }

    Connections {
        target: root.sourceAudio
        function onVolumeChanged() {
            root.show("mic");
        }
        function onMutedChanged() {
            root.show("mic");
        }
    }

    Process {
        id: brightnessProbe
        command: ["sh", "-c", "command -v brightnessctl >/dev/null && echo ctl; ls -1 /sys/class/backlight 2>/dev/null | head -n1"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = String(text || "").trim().split("\n").filter(l => l.length);
                root.hasBrightnessctl = lines.indexOf("ctl") !== -1;
                root.backlightDevice = lines.find(l => l !== "ctl") || "";
                if (root.hasBrightnessctl)
                    root.refreshBrightness();
            }
        }
    }

    Process {
        id: brightnessProc
        stdout: StdioCollector {
            onStreamFinished: {
                if (!root.applyBrightnessText(text))
                    root.refreshBrightness();
            }
        }
        onExited: function (exitCode) {
            if (exitCode !== 0)
                root.refreshBrightness();
            else
                root.show("brightness");
        }
    }

    Process {
        id: brightnessQuery
        command: ["brightnessctl", "-m"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: root.applyBrightnessText(text)
        }
    }

    FileView {
        id: brightnessFile
        printErrors: false
        preload: !!root.backlightDevice
        watchChanges: !!root.backlightDevice
        path: root.backlightDevice ? "/sys/class/backlight/" + root.backlightDevice + "/brightness" : ""
        onFileChanged: reload()
        onLoaded: {
            const cur = parseInt(text(), 10);
            const max = parseInt(brightnessMaxFile.text(), 10);
            if (!max || isNaN(cur))
                return;
            const next = Math.max(0, Math.min(100, Math.round((cur / max) * 100)));
            const changed = next !== root.brightnessPct;
            root.brightnessPct = next;
            if (root.brightnessReady && changed)
                root.show("brightness");
            root.brightnessReady = true;
        }
    }

    FileView {
        id: brightnessMaxFile
        printErrors: false
        preload: !!root.backlightDevice
        blockLoading: !!root.backlightDevice
        path: root.backlightDevice ? "/sys/class/backlight/" + root.backlightDevice + "/max_brightness" : ""
    }

    IpcHandler {
        target: "osd"
        function volumeUp(): void {
            root.volumeUp();
        }
        function volumeDown(): void {
            root.volumeDown();
        }
        function volumeMute(): void {
            root.toggleMute();
        }
        function micMute(): void {
            root.toggleMic();
        }
        function brightnessUp(): void {
            root.brightnessUp();
        }
        function brightnessDown(): void {
            root.brightnessDown();
        }
    }
}
