pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import QtQuick

Singleton {
    id: root

    property bool open: false
    property int cpuPct: 0
    property int memPct: 0
    property string memText: ""
    property int diskPct: 0
    property string diskText: ""
    property string weatherText: "Weather"
    property string weatherDetail: "Open to fetch"
    property bool weatherLoading: false
    property bool vpnConnected: false
    property string vpnKind: ""
    property string vpnDetail: "Checking…"
    property string vpnState: "unknown"

    property var _cpuPrev: null

    readonly property var player: {
        const list = Mpris.players.values;
        for (let i = 0; i < list.length; i++) {
            if (list[i].isPlaying)
                return list[i];
        }
        return list.length ? list[0] : null;
    }
    readonly property bool playing: player ? player.isPlaying : false
    readonly property string trackTitle: player ? (player.trackTitle || "Unknown Title") : "Nothing playing"
    readonly property string trackArtist: player ? (player.trackArtist || "") : ""
    readonly property string trackArt: player && player.trackArtUrl ? player.trackArtUrl : ""

    function toggle() {
        if (root.open)
            close();
        else
            show();
    }

    function show() {
        root.open = true;
        refreshStats();
        refreshVpn();
        refreshWeather();
        statsTimer.start();
        vpnTimer.interval = 4000;
        vpnTimer.restart();
    }

    function close() {
        root.open = false;
        statsTimer.stop();
        vpnTimer.interval = 15000;
        vpnTimer.restart();
    }

    function refreshStats() {
        memFile.reload();
        cpuFile.reload();
        diskProc.running = false;
        diskProc.running = true;
    }

    function refreshVpn() {
        vpnProc.running = false;
        vpnProc.running = true;
    }

    function refreshWeather() {
        root.weatherLoading = true;
        root.weatherDetail = "Fetching…";
        weatherProc.running = false;
        weatherProc.running = true;
    }

    function parseMem(text) {
        let total = 0;
        let avail = 0;
        const lines = String(text || "").split("\n");
        for (let i = 0; i < lines.length; i++) {
            if (lines[i].indexOf("MemTotal:") === 0)
                total = parseInt(lines[i].replace(/[^0-9]/g, ""), 10);
            else if (lines[i].indexOf("MemAvailable:") === 0)
                avail = parseInt(lines[i].replace(/[^0-9]/g, ""), 10);
        }
        if (!total)
            return;
        const used = Math.max(0, total - avail);
        root.memPct = Math.round((used / total) * 100);
        root.memText = fmtGib(used) + " of " + fmtGib(total) + " used";
    }

    function parseCpu(text) {
        const parts = String(text || "").trim().split(/\s+/);
        if (parts.length < 5)
            return;
        const idle = (+parts[4] || 0) + (+parts[5] || 0);
        let total = 0;
        for (let i = 1; i < parts.length; i++)
            total += +parts[i] || 0;
        const prev = root._cpuPrev;
        root._cpuPrev = {
            idle: idle,
            total: total
        };
        if (!prev || total <= prev.total)
            return;
        const idleDelta = idle - prev.idle;
        const totalDelta = total - prev.total;
        root.cpuPct = Math.max(0, Math.min(100, Math.round((1 - idleDelta / totalDelta) * 100)));
    }

    function parseDisk(text) {
        const line = String(text || "").trim().split("\n").pop();
        const parts = line.trim().split(/\s+/);
        if (parts.length < 5)
            return;
        const used = +parts[2];
        const total = +parts[1];
        if (!total)
            return;
        root.diskPct = Math.round((used / total) * 100);
        root.diskText = fmtGib(used / 1024) + " of " + fmtGib(total / 1024) + " used";
    }

    function fmtGib(kib) {
        return (kib / 1048576).toFixed(1) + " GB";
    }

    function applyMullvad(raw) {
        const d = JSON.parse(raw);
        const state = String(d.state || "").toLowerCase();
        root.vpnKind = "Mullvad";
        root.vpnState = state;
        root.vpnConnected = state === "connected";
        const details = d.details || {};
        const loc = details.location || details;
        const bits = [];
        if (loc && loc.hostname)
            bits.push(loc.hostname);
        if (loc && loc.city && loc.country)
            bits.push(loc.city + ", " + loc.country);
        else if (loc && loc.country)
            bits.push(loc.country);
        if (root.vpnConnected)
            root.vpnDetail = bits.length ? bits.join(" · ") : "Connected";
        else if (state === "connecting")
            root.vpnDetail = "Connecting…";
        else
            root.vpnDetail = bits.length ? "Off · " + bits[bits.length - 1] : "Disconnected";
        return true;
    }

    function applyWg(raw) {
        const ifaces = String(raw || "").trim();
        if (!ifaces) {
            if (root.vpnKind !== "Mullvad") {
                root.vpnKind = "";
                root.vpnConnected = false;
                root.vpnState = "disconnected";
                root.vpnDetail = "Disconnected";
            }
            return;
        }
        const name = ifaces.split(/\s+/)[0];
        root.vpnKind = "WireGuard";
        root.vpnConnected = true;
        root.vpnState = "connected";
        root.vpnDetail = name;
    }

    function applyWeather(raw) {
        root.weatherLoading = false;
        try {
            const d = JSON.parse(raw);
            const cur = (d.current_condition && d.current_condition[0]) || {};
            const area = (d.nearest_area && d.nearest_area[0]) || {};
            const place = ((area.areaName && area.areaName[0] && area.areaName[0].value) || "") + ((area.region && area.region[0] && area.region[0].value) ? ", " + area.region[0].value : "");
            const desc = (cur.weatherDesc && cur.weatherDesc[0] && cur.weatherDesc[0].value) || "";
            const temp = cur.temp_F ? cur.temp_F + "°F" : (cur.temp_C ? cur.temp_C + "°C" : "");
            root.weatherText = [temp, desc].filter(s => s).join("  ") || "Weather";
            root.weatherDetail = place || "";
        } catch (e) {
            root.weatherText = "Weather unavailable";
            root.weatherDetail = "";
        }
    }

    Timer {
        id: statsTimer
        interval: 2000
        repeat: true
        onTriggered: root.refreshStats()
    }

    Timer {
        id: vpnTimer
        interval: 15000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refreshVpn()
    }

    FileView {
        id: memFile
        path: "/proc/meminfo"
        onLoaded: root.parseMem(text())
    }

    FileView {
        id: cpuFile
        path: "/proc/stat"
        onLoaded: root.parseCpu(text())
    }

    Process {
        id: diskProc
        command: ["df", "-P", "-B1", "/"]
        stdout: StdioCollector {
            onStreamFinished: root.parseDisk(text)
        }
    }

    Process {
        id: vpnProc
        command: ["mullvad", "status", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.applyMullvad(text);
                } catch (e) {
                    wgProc.running = false;
                    wgProc.running = true;
                }
            }
        }
        onExited: function (exitCode) {
            if (exitCode !== 0) {
                wgProc.running = false;
                wgProc.running = true;
            }
        }
    }

    Process {
        id: wgProc
        command: ["wg", "show", "interfaces"]
        stdout: StdioCollector {
            onStreamFinished: root.applyWg(text)
        }
        onExited: function (exitCode) {
            if (exitCode !== 0 && root.vpnKind !== "Mullvad") {
                root.vpnKind = "";
                root.vpnConnected = false;
                root.vpnState = "disconnected";
                root.vpnDetail = "Disconnected";
            }
        }
    }

    Process {
        id: weatherProc
        command: ["curl", "-sf", "--max-time", "8", "https://wttr.in/?format=j1"]
        stdout: StdioCollector {
            onStreamFinished: root.applyWeather(text)
        }
        onExited: function (exitCode) {
            if (exitCode !== 0) {
                root.weatherLoading = false;
                root.weatherText = "Weather unavailable";
                root.weatherDetail = "";
            }
        }
    }

    IpcHandler {
        target: "dashboard"
        function toggle(): void {
            root.toggle();
        }
        function open(): void {
            root.show();
        }
        function close(): void {
            root.close();
        }
    }
}
