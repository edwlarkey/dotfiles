import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam
import Quickshell.Io
import QtQuick

import ".."

Scope {
    id: root

    property bool lockRequested: false
    property string password: ""
    property string errorText: ""
    property bool authenticating: false
    readonly property string username: String(Quickshell.env("USER") || "")

    function requestLock() {
        root.password = "";
        root.errorText = "";
        root.authenticating = false;
        root.lockRequested = true;
    }

    function unlock() {
        root.password = "";
        root.errorText = "";
        root.authenticating = false;
        root.lockRequested = false;
    }

    function submit() {
        if (root.authenticating)
            return;
        root.errorText = "";
        root.authenticating = true;
        if (!pam.start()) {
            root.authenticating = false;
            root.errorText = "Could not unlock.";
        }
    }

    PamContext {
        id: pam
        config: "hyprlock"
        user: root.username
        onCompleted: result => {
            root.authenticating = false;
            if (result === PamResult.Success) {
                root.unlock();
            } else if (result === PamResult.MaxTries) {
                root.password = "";
                root.errorText = "Too many attempts.";
            } else {
                root.password = "";
                root.errorText = "The password was incorrect.";
            }
        }
        onError: {
            root.authenticating = false;
            root.password = "";
            root.errorText = "Could not unlock.";
        }
        onResponseRequiredChanged: {
            if (responseRequired)
                respond(root.password);
        }
    }

    WlSessionLock {
        id: sessionLock
        locked: root.lockRequested
        onLockStateChanged: {
            if (!locked)
                root.lockRequested = false;
        }
        WlSessionLockSurface {
            color: Config.colors.desktop
            LockScreen {
                anchors.fill: parent
                auth: root
            }
        }
    }

    IpcHandler {
        target: "lock"
        function lock() {
            root.requestLock();
        }
    }
}
