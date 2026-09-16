import QtQuick
import ".."

Text {
    text: Time.time
    color: Config.colors.text
    font.pixelSize: Config.bar.fontSize
    font.family: fontCharcoal.name
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter
    height: parent ? parent.height : Config.bar.height
}
