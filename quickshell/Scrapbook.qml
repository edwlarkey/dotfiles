pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool open: false
    property bool showPictures: false
    property var items: []
    property int selectedIndex: 0
    property string previewText: ""
    property string previewImage: ""

    readonly property var selected: (selectedIndex >= 0 && selectedIndex < items.length) ? items[selectedIndex] : null
    readonly property int count: items.length

    function toggle() {
        if (root.open)
            close();
        else
            show();
    }

    function show() {
        root.open = true;
        refresh();
    }

    function close() {
        root.open = false;
    }

    function refresh() {
        listProc.running = false;
        listProc.running = true;
    }

    function select(index) {
        if (index < 0 || index >= root.items.length)
            return;
        root.selectedIndex = index;
        loadPreview();
    }

    function isImagePath(text) {
        let s = String(text || "").trim();
        if (!s)
            return false;
        if (s.indexOf("[[ binary") === 0)
            return true;
        s = s.replace(/^file:\/\//, "");
        try {
            s = decodeURIComponent(s.split("?")[0]);
        } catch (e) {}
        return /\.(png|jpe?g|gif|webp|bmp|svg|avif|tiff?)$/i.test(s);
    }

    function pictureSource(text) {
        const s = String(text || "").trim();
        if (!s || s.indexOf("[[ binary") === 0)
            return "";
        if (s.indexOf("file://") === 0)
            return s;
        if (/^https?:\/\//i.test(s))
            return s;
        if (s.indexOf("/") === 0 && root.isImagePath(s))
            return "file://" + s;
        return "";
    }

    function loadPreview() {
        const item = root.selected;
        root.previewImage = "";
        root.previewText = "";
        if (!item)
            return;
        const src = root.pictureSource(item.preview);
        if (src) {
            root.previewImage = src;
            root.previewText = item.label;
            return;
        }
        if (item.picture) {
            root.previewText = item.label;
            return;
        }
        previewProc.exec(["sh", "-c", "printf '%s' " + Number(item.id) + " | cliphist decode"]);
    }

    function copySelected() {
        const item = root.selected;
        if (!item)
            return;
        Quickshell.execDetached(["sh", "-c", "printf '%s' " + Number(item.id) + " | cliphist decode | wl-copy"]);
    }

    function deleteSelected() {
        const item = root.selected;
        if (!item)
            return;
        deleteProc.exec(["sh", "-c", "printf '%s' " + Number(item.id) + " | cliphist delete"]);
    }

    function clearAll() {
        wipeProc.exec(["cliphist", "wipe"]);
    }

    function parseList(raw) {
        const lines = String(raw || "").split("\n");
        const out = [];
        const max = Config.scrapbook.maxItems;
        for (let i = 0; i < lines.length && out.length < max; i++) {
            const line = lines[i];
            const tab = line.indexOf("\t");
            if (tab < 1)
                continue;
            const id = line.slice(0, tab);
            const preview = line.slice(tab + 1);
            const binary = preview.indexOf("[[ binary") === 0;
            const picture = binary || root.isImagePath(preview);
            if (picture && !root.showPictures)
                continue;
            let label = preview.replace(/\s+/g, " ").trim();
            if (binary) {
                const m = preview.match(/\[\[ binary data ([^\]]+) \]\]/);
                label = m ? "Picture (" + m[1].trim() + ")" : "Picture";
            }
            out.push({
                id: id,
                preview: preview,
                binary: binary,
                picture: picture,
                label: label
            });
        }
        const prevId = root.selected ? root.selected.id : "";
        root.items = out;
        let next = 0;
        if (prevId) {
            for (let i = 0; i < out.length; i++) {
                if (out[i].id === prevId) {
                    next = i;
                    break;
                }
            }
        }
        root.selectedIndex = out.length ? next : 0;
        root.loadPreview();
    }

    Process {
        id: listProc
        command: ["cliphist", "list"]
        stdout: StdioCollector {
            onStreamFinished: root.parseList(text)
        }
        onExited: function (exitCode) {
            if (exitCode !== 0)
                root.parseList("");
        }
    }

    Process {
        id: previewProc
        stdout: StdioCollector {
            onStreamFinished: {
                const t = String(text || "");
                root.previewText = t.length > 4000 ? t.slice(0, 4000) + "…" : t;
            }
        }
    }

    Process {
        id: deleteProc
        onExited: root.refresh()
    }

    Process {
        id: wipeProc
        onExited: root.refresh()
    }

    Timer {
        id: refreshDebounce
        interval: 300
        repeat: false
        onTriggered: {
            if (root.open)
                root.refresh();
        }
    }

    Connections {
        target: Quickshell
        function onClipboardTextChanged() {
            refreshDebounce.restart();
        }
    }

    IpcHandler {
        target: "scrapbook"
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
