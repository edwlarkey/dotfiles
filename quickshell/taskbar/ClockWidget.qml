import QtQuick
import ".."

Text {
    text: Time.time
    color: Config.colors.text
    font.pixelSize: Config.bar.fontSize + 2
    font.family: fontCharcoal.name
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter
    height: parent ? parent.height : Config.bar.height
}
