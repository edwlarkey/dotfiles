pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import QtQuick

import "utils" as Utils

Singleton {
    id: root

    property bool managerOpen: false
    property var popupNotifs: []

    readonly property var tracked: server.trackedNotifications
    readonly property int count: tracked ? tracked.values.length : 0

    NotificationServer {
        id: server
        actionsSupported: true
        actionIconsSupported: true
        bodySupported: true
        imageSupported: true
        persistenceSupported: true
        keepOnReload: true

        onNotification: function (n) {
            n.tracked = true;
            if (n.lastGeneration)
                return;
            root.addToast(n);
        }
    }

    function iconSource(n) {
        if (!n)
            return "";
        if (n.image && n.image.length)
            return n.image;
        if (n.appIcon && n.appIcon.length) {
            if (n.appIcon.indexOf("/") !== -1 || n.appIcon.indexOf(":") !== -1)
                return n.appIcon;
            return Quickshell.iconPath(n.appIcon, true) || "";
        }
        if (n.desktopEntry && n.desktopEntry.length)
            return Quickshell.iconPath(n.desktopEntry, true) || "";
        return Quickshell.iconPath("dialog-information", true) || "";
    }

    function appLabel(n) {
        if (!n)
            return "Notification";
        if (n.appName && n.appName.length)
            return n.appName;
        if (n.desktopEntry && n.desktopEntry.length)
            return Utils.AppSearch.nameFromId(n.desktopEntry);
        return "Notification";
    }

    function toastMs(n) {
        if (!n)
            return Config.notifications.toastTimeout;
        if (n.urgency === NotificationUrgency.Critical)
            return 0;
        const t = n.expireTimeout;
        if (t < 0)
            return 0;
        if (!t)
            return Config.notifications.toastTimeout;
        if (t > 120)
            return t;
        return t * 1000;
    }

    function addToast(n) {
        if (!n)
            return;
        let next = root.popupNotifs.filter(x => x && x.id !== n.id);
        next.unshift(n);
        if (next.length > Config.notifications.maxToasts)
            next = next.slice(0, Config.notifications.maxToasts);
        root.popupNotifs = next;
    }

    function hideToast(n) {
        root.popupNotifs = root.popupNotifs.filter(x => x && n && x.id !== n.id);
        if (n && n.transient)
            n.expire();
    }

    function dismissToast(n) {
        root.popupNotifs = root.popupNotifs.filter(x => x && n && x.id !== n.id);
        if (n)
            n.dismiss();
    }

    function toggleManager() {
        root.managerOpen = !root.managerOpen;
        if (root.managerOpen)
            root.popupNotifs = [];
    }

    function closeManager() {
        root.managerOpen = false;
    }

    function dismissAll() {
        root.popupNotifs = [];
        const vals = server.trackedNotifications.values;
        const items = [];
        for (let i = 0; i < vals.length; i++)
            items.push(vals[i]);
        for (let i = 0; i < items.length; i++)
            items[i].dismiss();
    }

    IpcHandler {
        target: "notifications"
        function toggle(): void {
            root.toggleManager();
        }
        function dismissAll(): void {
            root.dismissAll();
        }
    }
}
