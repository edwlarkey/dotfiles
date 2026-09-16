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
