import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root
    preferredRepresentation: compactRepresentation

    property bool wifiOn: true
    property bool btOn: true
    property bool dndOn: false
    property bool nightOn: false
    property int volumePct: 75

    Plasma5Support.DataSource {
        id: exec
        engine: "executable"
        connectedSources: []
        onNewData: (source) => disconnectSource(source)
        function run(cmd) { connectSource(cmd) }
    }

    compactRepresentation: Item {
        Layout.preferredWidth: 188
        Layout.preferredHeight: 48
        Row {
            anchors.centerIn: parent
            spacing: 20
            Image { source: "/usr/share/icons/NexusOS/32x32/status/network-wireless-signal-excellent-symbolic.png"; width: 26; height: 26 }
            Image { source: "/usr/share/icons/NexusOS/32x32/status/audio-volume-high-symbolic.png"; width: 26; height: 26 }
            Image { source: "/usr/share/icons/NexusOS/32x32/status/battery-full-symbolic.png"; width: 26; height: 26 }
            Image { source: "/usr/share/icons/NexusOS/32x32/actions/system-shutdown-symbolic.png"; width: 26; height: 26 }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: root.expanded = !root.expanded
        }
    }

    fullRepresentation: Item {
        Layout.preferredWidth: 344
        Layout.preferredHeight: 332
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // 2x2 Quick Toggle Tiles
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                rowSpacing: 10; columnSpacing: 10

                // Wi-Fi Tile
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: 54; radius: 14
                    color: root.wifiOn ? "#4438BDF8" : "#18FFFFFF"
                    border.color: root.wifiOn ? "#7738BDF8" : "#14FFFFFF"
                    RowLayout {
                        anchors.fill: parent; anchors.margins: 10; spacing: 10
                        Rectangle {
                            width: 30; height: 30; radius: 15
                            color: root.wifiOn ? "#38BDF8" : "#24FFFFFF"
                            Image { anchors.centerIn: parent; width: 16; height: 16; source: "/usr/share/icons/NexusOS/32x32/status/network-wireless-signal-excellent-symbolic.png" }
                        }
                        Column {
                            Text { text: "Wi-Fi"; color: "#F8FAFC"; font.family: "SF Pro Display"; font.pixelSize: 12; font.bold: true }
                            Text { text: root.wifiOn ? "Connected" : "Off"; color: "#CBD5E1"; font.family: "SF Pro Display"; font.pixelSize: 11 }
                        }
                    }
                    MouseArea { anchors.fill: parent; onClicked: { root.wifiOn = !root.wifiOn; exec.run("nmcli radio wifi " + (root.wifiOn ? "on" : "off")) } }
                }

                // Bluetooth Tile
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: 54; radius: 14
                    color: root.btOn ? "#4438BDF8" : "#18FFFFFF"
                    border.color: root.btOn ? "#7738BDF8" : "#14FFFFFF"
                    RowLayout {
                        anchors.fill: parent; anchors.margins: 10; spacing: 10
                        Rectangle {
                            width: 30; height: 30; radius: 15
                            color: root.btOn ? "#38BDF8" : "#24FFFFFF"
                            Image { anchors.centerIn: parent; width: 16; height: 16; source: "/usr/share/icons/NexusOS/32x32/status/bluetooth-active-symbolic.png" }
                        }
                        Column {
                            Text { text: "Bluetooth"; color: "#F8FAFC"; font.family: "SF Pro Display"; font.pixelSize: 12; font.bold: true }
                            Text { text: root.btOn ? "On" : "Off"; color: "#CBD5E1"; font.family: "SF Pro Display"; font.pixelSize: 11 }
                        }
                    }
                    MouseArea { anchors.fill: parent; onClicked: { root.btOn = !root.btOn; exec.run("bluetoothctl power " + (root.btOn ? "on" : "off")) } }
                }

                // Do Not Disturb
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: 54; radius: 14
                    color: root.dndOn ? "#4438BDF8" : "#18FFFFFF"
                    border.color: root.dndOn ? "#7738BDF8" : "#14FFFFFF"
                    RowLayout {
                        anchors.fill: parent; anchors.margins: 10; spacing: 10
                        Rectangle {
                            width: 30; height: 30; radius: 15
                            color: root.dndOn ? "#38BDF8" : "#24FFFFFF"
                            Image { anchors.centerIn: parent; width: 16; height: 16; source: "/usr/share/icons/NexusOS/32x32/status/notifications-symbolic.png" }
                        }
                        Column {
                            Text { text: "Do Not Disturb"; color: "#F8FAFC"; font.family: "SF Pro Display"; font.pixelSize: 12; font.bold: true }
                            Text { text: root.dndOn ? "On" : "Off"; color: "#CBD5E1"; font.family: "SF Pro Display"; font.pixelSize: 11 }
                        }
                    }
                    MouseArea { anchors.fill: parent; onClicked: root.dndOn = !root.dndOn }
                }

                // Night Light
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: 54; radius: 14
                    color: root.nightOn ? "#4438BDF8" : "#18FFFFFF"
                    border.color: root.nightOn ? "#7738BDF8" : "#14FFFFFF"
                    RowLayout {
                        anchors.fill: parent; anchors.margins: 10; spacing: 10
                        Rectangle {
                            width: 30; height: 30; radius: 15
                            color: root.nightOn ? "#38BDF8" : "#24FFFFFF"
                            Image { anchors.centerIn: parent; width: 16; height: 16; source: "/usr/share/icons/NexusOS/32x32/actions/system-suspend-symbolic.png" }
                        }
                        Column {
                            Text { text: "Night Light"; color: "#F8FAFC"; font.family: "SF Pro Display"; font.pixelSize: 12; font.bold: true }
                            Text { text: root.nightOn ? "On" : "Off"; color: "#CBD5E1"; font.family: "SF Pro Display"; font.pixelSize: 11 }
                        }
                    }
                    MouseArea { anchors.fill: parent; onClicked: root.nightOn = !root.nightOn }
                }
            }

            // Network Settings Shortcut
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 40; radius: 11; color: "#14FFFFFF"
                RowLayout {
                    anchors.fill: parent; anchors.leftMargin: 12; anchors.rightMargin: 12
                    Image { source: "/usr/share/icons/NexusOS/32x32/status/network-wireless-signal-excellent-symbolic.png"; width: 16; height: 16 }
                    Text { text: "Manage Wi-Fi Networks..."; color: "#F1F5F9"; font.family: "SF Pro Display"; font.pixelSize: 12; font.weight: Font.Medium }
                    Item { Layout.fillWidth: true }
                    Text { text: "›"; color: "#94A3B8"; font.pixelSize: 16 }
                }
                MouseArea { anchors.fill: parent; onClicked: { exec.run("systemsettings kcm_networkmanagement"); root.expanded = false } }
            }

            // Live Volume Slider
            RowLayout {
                Layout.fillWidth: true; spacing: 10
                Image { source: "/usr/share/icons/NexusOS/32x32/status/audio-volume-high-symbolic.png"; width: 18; height: 18 }
                Slider {
                    id: volSlider
                    Layout.fillWidth: true
                    from: 0; to: 100; value: root.volumePct
                    onMoved: {
                        root.volumePct = Math.round(value)
                        exec.run("pactl set-sink-volume @DEFAULT_SINK@ " + root.volumePct + "%")
                    }
                }
                Text { text: root.volumePct + "%"; color: "#E2E8F0"; font.family: "SF Pro Display"; font.pixelSize: 12; Layout.preferredWidth: 32 }
            }

            // Footer Power Controls
            RowLayout {
                Layout.fillWidth: true
                Rectangle {
                    height: 30; width: 78; radius: 10; color: "#18FFFFFF"
                    Row {
                        anchors.centerIn: parent; spacing: 6
                        Image { source: "/usr/share/icons/NexusOS/32x32/status/battery-full-symbolic.png"; width: 16; height: 16 }
                        Text { text: "100%"; color: "#F8FAFC"; font.family: "SF Pro Display"; font.pixelSize: 12; font.bold: true }
                    }
                }
                Item { Layout.fillWidth: true }
                Row {
                    spacing: 10
                    Rectangle { width: 30; height: 30; radius: 15; color: "#18FFFFFF"; Image { anchors.centerIn: parent; width: 15; height: 15; source: "/usr/share/icons/NexusOS/32x32/actions/system-lock-screen-symbolic.png" } MouseArea { anchors.fill: parent; onClicked: { exec.run("loginctl lock-session"); root.expanded = false } } }
                    Rectangle { width: 30; height: 30; radius: 15; color: "#18FFFFFF"; Image { anchors.centerIn: parent; width: 15; height: 15; source: "/usr/share/icons/NexusOS/32x32/actions/system-reboot-symbolic.png" } MouseArea { anchors.fill: parent; onClicked: { exec.run("systemctl reboot"); root.expanded = false } } }
                    Rectangle { width: 30; height: 30; radius: 15; color: "#48F43F5E"; Image { anchors.centerIn: parent; width: 15; height: 15; source: "/usr/share/icons/NexusOS/32x32/actions/system-shutdown-symbolic.png" } MouseArea { anchors.fill: parent; onClicked: { exec.run("systemctl poweroff"); root.expanded = false } } }
                }
            }
        }
    }
}
