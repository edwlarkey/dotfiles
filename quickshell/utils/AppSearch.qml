pragma Singleton
import Quickshell

Singleton {

    readonly property list<DesktopEntry> list: Array.from(DesktopEntries.applications.values).sort((a, b) => a.name.localeCompare(b.name))

    readonly property var preppedNames: list.map(a => ({
                name: Fuzzy.prepare(`${a.name} `),
                entry: a
            }))

    readonly property var preppedIcons: list.map(a => ({
                name: Fuzzy.prepare(`${a.icon} `),
                entry: a
            }))

    readonly property var categoryOrder: [
        {
            name: "Internet",
            keys: ["WebBrowser", "Email", "InstantMessaging", "Chat", "IRCClient", "Feed", "News", "Telephony", "HamRadio", "FileTransfer", "Network"]
        },
        {
            name: "Graphics",
            keys: ["2DGraphics", "3DGraphics", "RasterGraphics", "VectorGraphics", "Photography", "Scanning", "Graphics", "Viewer"]
        },
        {
            name: "Multimedia",
            keys: ["AudioVideoEditing", "Player", "Recorder", "Music", "Midi", "Mixer", "Sequencer", "Tuner", "TV", "DiscBurning", "Audio", "Video", "AudioVideo"]
        },
        {
            name: "Office",
            keys: ["WordProcessor", "Spreadsheet", "Presentation", "Calendar", "ContactManagement", "Dictionary", "ProjectManagement", "Publishing", "Finance", "Office"]
        },
        {
            name: "Development",
            keys: ["IDE", "Debugger", "GUIDesigner", "Building", "RevisionControl", "WebDevelopment", "Database", "Development"]
        },
        {
            name: "Games",
            keys: ["ActionGame", "AdventureGame", "ArcadeGame", "BoardGame", "CardGame", "KidsGame", "LogicGame", "RolePlaying", "Simulation", "SportsGame", "StrategyGame", "Emulator", "Game"]
        },
        {
            name: "Education",
            keys: ["Science", "Math", "Physics", "Chemistry", "Astronomy", "Biology", "Literature", "History", "Geography", "ArtificialIntelligence", "Education"]
        },
        {
            name: "Settings",
            keys: ["DesktopSettings", "HardwareSettings", "PackageManager", "ControlCenter", "Accessibility", "Settings"]
        },
        {
            name: "System",
            keys: ["TerminalEmulator", "Monitor", "Filesystem", "Security", "FileManager", "FileTools", "System"]
        },
        {
            name: "Utilities",
            keys: ["TextEditor", "Archiving", "Compression", "Calculator", "Clock", "Core", "Utility"]
        }
    ]

    readonly property var grouped: {
        const defs = categoryOrder;
        const buckets = {};
        const names = [];
        for (let i = 0; i < defs.length; i++) {
            buckets[defs[i].name] = [];
            names.push(defs[i].name);
        }
        buckets["Other"] = [];
        names.push("Other");
        const apps = list.filter(a => !a.noDisplay);
        for (let i = 0; i < apps.length; i++) {
            const b = bucketOf(apps[i]);
            if (!buckets[b])
                buckets[b] = [];
            buckets[b].push(apps[i]);
        }
        const out = [];
        for (let i = 0; i < names.length; i++) {
            const n = names[i];
            if (buckets[n] && buckets[n].length)
                out.push({
                    name: n,
                    apps: buckets[n]
                });
        }
        return out;
    }

    function bucketOf(entry): string {
        const cats = entry && entry.categories;
        if (!cats || cats.length === 0)
            return "Other";
        const set = {};
        for (let i = 0; i < cats.length; i++)
            set[String(cats[i])] = true;
        const defs = categoryOrder;
        for (let i = 0; i < defs.length; i++) {
            const keys = defs[i].keys;
            for (let j = 0; j < keys.length; j++) {
                if (set[keys[j]])
                    return defs[i].name;
            }
        }
        return "Other";
    }

    function findApp(id): var {
        if (!id)
            return null;
        const exact = DesktopEntries.heuristicLookup(id) || DesktopEntries.byId(id);
        if (exact && !exact.noDisplay)
            return exact;
        const lower = String(id).toLowerCase();
        for (let i = 0; i < list.length; i++) {
            const a = list[i];
            if (a.noDisplay)
                continue;
            const aid = a.id ? String(a.id).toLowerCase() : "";
            if (aid === lower || aid.endsWith("." + lower))
                return a;
            if (a.startupClass && String(a.startupClass).toLowerCase() === lower)
                return a;
            if (a.name && String(a.name).toLowerCase() === lower)
                return a;
        }
        return null;
    }

    function favoriteApps(ids): var {
        const out = [];
        const seen = {};
        const src = ids || [];
        for (let i = 0; i < src.length; i++) {
            const a = findApp(src[i]);
            if (!a)
                continue;
            const key = a.id || a.name;
            if (seen[key])
                continue;
            seen[key] = true;
            out.push(a);
        }
        return out;
    }

    function fuzzyQuery(search: string): var { // Idk why list<DesktopEntry> doesn't work
        return Fuzzy.go(search, preppedNames, {
            all: true,
            key: "name"
        }).map(r => {
            return r.obj.entry;
        });
    }

    function getIcon(iconName) {
        if (!iconName || iconName.length == 0)
            return false;
        return Quickshell.iconPath(iconName, true);
    }

    function prettyId(id) {
        if (!id)
            return "";
        const parts = String(id).split(/[. ]+/);
        const last = parts[parts.length - 1];
        if (!last)
            return "";
        return last.charAt(0).toUpperCase() + last.slice(1);
    }

    function nameFromId(id) {
        if (!id)
            return "";
        const entry = DesktopEntries.heuristicLookup(id) || DesktopEntries.byId(id);
        if (entry && entry.name)
            return entry.name;
        const lower = String(id).toLowerCase();
        for (let i = 0; i < list.length; i++) {
            const a = list[i];
            if ((a.startupClass && String(a.startupClass).toLowerCase() === lower)
                || (a.id && String(a.id).toLowerCase() === lower)
                || (a.icon && String(a.icon).toLowerCase() === lower))
                return a.name;
        }
        return prettyId(id);
    }

    function classOfToplevel(t) {
        if (!t)
            return "";
        if (t.wayland && t.wayland.appId)
            return t.wayland.appId;
        const ipc = t.lastIpcObject || {};
        return ipc["class"] || ipc["initialClass"] || "";
    }

    function nameOfToplevel(t) {
        const id = classOfToplevel(t);
        if (id)
            return nameFromId(id);
        if (t && t.title)
            return t.title;
        return "Finder";
    }
}
