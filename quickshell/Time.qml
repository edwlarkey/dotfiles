pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    readonly property string time: {
        Qt.formatDateTime(clock.date, "MMM d  h:mm");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
