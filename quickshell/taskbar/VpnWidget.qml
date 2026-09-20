import QtQuick

import ".."

MenuTitle {
    text: Dashboard.vpnConnected ? (Dashboard.vpnKind || "VPN") : ""
    iconName: Dashboard.vpnConnected ? "network-vpn" : "network-offline"
    iconSize: Config.bar.iconSize
    pad: 8
    active: Dashboard.open
    onClicked: Dashboard.toggle()
}
