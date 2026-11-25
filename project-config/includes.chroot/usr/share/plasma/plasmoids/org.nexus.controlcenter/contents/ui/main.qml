import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.plasma5support 2.0 as P5Support

PlasmoidItem {
    id: root
    preferredRepresentation: compactRepresentation

    property bool wifiOn: true
    property bool btOn: true
    property bool dndOn: false
    property bool nightOn: false
    property int volumePct: 75
    property string netStatus: "Connected"
    property string activeNetName: "Wired / Home_5G"

    P5Support.DataSource {
        id: exec
        engine: "executable"
        connectedSources: []
        onNewData: function(sourceName, data) {
            var out = (data["stdout"] || "").trim()
            if (sourceName.indexOf("nmcli -t -f NAME") !== -1 && out.length > 0) {
                root.activeNetName = out.split("\n")[0].split(":")[0]
            }
            disconnectSource(sourceName)
        }
    }

    function runCmd(cmd) {
        exec.connectSource(cmd)
    }

    compactRepresentation: MouseArea {
        Layout.minimumWidth: iconRow.implicitWidth + 32
        Layout.preferredWidth: Layout.minimumWidth
        Layout.minimumHeight: 44
        Layout.preferredHeight: 44
        implicitWidth: iconRow.implicitWidth + 32
        implicitHeight: 44
        hoverEnabled: true
        onClicked: {
            root.expanded = !root.expanded
            if (root.expanded) {
                root.runCmd("nmcli -t -f NAME,TYPE,STATE con show --active")
            }
        }

        Row {
            id: iconRow
            anchors.centerIn: parent
            spacing: 16

            Image {
                source: "file:///usr/share/icons/Nexus-OS-Icons/scalable/status/wifi_signal.svg"
                width: 18; height: 18
                sourceSize.width: 18; sourceSize.height: 18
                fillMode: Image.PreserveAspectFit
                smooth: true
            }
            Image {
                source: "file:///usr/share/icons/Nexus-OS-Icons/scalable/status/volume_speaker.svg"
                width: 18; height: 18
                sourceSize.width: 18; sourceSize.height: 18
                fillMode: Image.PreserveAspectFit
                smooth: true
            }
            Image {
                source: "file:///usr/share/icons/Nexus-OS-Icons/scalable/status/battery.svg"
                width: 19; height: 19
                sourceSize.width: 19; sourceSize.height: 19
                fillMode: Image.PreserveAspectFit
                smooth: true
            }
            Image {
                source: "file:///usr/share/icons/Nexus-OS-Icons/scalable/actions/power_shutdown.svg"
                width: 18; height: 18
                sourceSize.width: 18; sourceSize.height: 18
                fillMode: Image.PreserveAspectFit
                smooth: true
            }
        }
    }

    fullRepresentation: Item {
        implicitWidth: 332
        implicitHeight: 386

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 14

            // 2x2 Quick Toggles
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: 10
                rowSpacing: 10

                // Wi-Fi tile
                Rectangle {
                    Layout.fillWidth: true
                    height: 58
                    radius: 14
                    color: root.wifiOn ? Qt.rgba(59/255, 130/255, 246/255, 0.24) : Qt.rgba(1, 1, 1, 0.06)
                    border.width: 1
                    border.color: root.wifiOn ? Qt.rgba(96/255, 165/255, 250/255, 0.45) : Qt.rgba(1, 1, 1, 0.10)

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10
                        Rectangle {
                            width: 34; height: 34; radius: 17
                            color: root.wifiOn ? "#3B82F6" : Qt.rgba(1, 1, 1, 0.10)
                            Image {
                                anchors.centerIn: parent
                                source: "file:///usr/share/icons/Nexus-OS-Icons/scalable/status/wifi_signal.svg"
                                width: 16; height: 16; sourceSize.width: 16; sourceSize.height: 16
                            }
                        }
                        Column {
                            Text { text: "Wi-Fi"; color: "#F8FAFC"; font.family: "SF Pro Display"; font.pixelSize: 12; font.weight: Font.DemiBold }
                            Text { text: root.wifiOn ? root.activeNetName : "Off"; color: "#94A3B8"; font.family: "SF Pro Display"; font.pixelSize: 10; elide: Text.ElideRight; width: 80 }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.wifiOn = !root.wifiOn
                            root.runCmd("nmcli radio wifi " + (root.wifiOn ? "on" : "off"))
                        }
                    }
                }

                // Bluetooth tile
                Rectangle {
                    Layout.fillWidth: true
                    height: 58
                    radius: 14
                    color: root.btOn ? Qt.rgba(59/255, 130/255, 246/255, 0.24) : Qt.rgba(1, 1, 1, 0.06)
                    border.width: 1
                    border.color: root.btOn ? Qt.rgba(96/255, 165/255, 250/255, 0.45) : Qt.rgba(1, 1, 1, 0.10)

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10
                        Rectangle {
                            width: 34; height: 34; radius: 17
                            color: root.btOn ? "#3B82F6" : Qt.rgba(1, 1, 1, 0.10)
                            Image {
                                anchors.centerIn: parent
                                source: "file:///usr/share/icons/Nexus-OS-Icons/scalable/status/bluetooth.svg"
                                width: 16; height: 16; sourceSize.width: 16; sourceSize.height: 16
                            }
                        }
                        Column {
                            Text { text: "Bluetooth"; color: "#F8FAFC"; font.family: "SF Pro Display"; font.pixelSize: 12; font.weight: Font.DemiBold }
                            Text { text: root.btOn ? "On" : "Off"; color: "#94A3B8"; font.family: "SF Pro Display"; font.pixelSize: 10 }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.btOn = !root.btOn
                            root.runCmd("bluetoothctl power " + (root.btOn ? "on" : "off"))
                        }
                    }
                }

                // Do Not Disturb tile
                Rectangle {
                    Layout.fillWidth: true
                    height: 58
                    radius: 14
                    color: root.dndOn ? Qt.rgba(59/255, 130/255, 246/255, 0.24) : Qt.rgba(1, 1, 1, 0.06)
                    border.width: 1
                    border.color: Qt.rgba(1, 1, 1, 0.10)

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10
                        Rectangle {
                            width: 34; height: 34; radius: 17
                            color: root.dndOn ? "#3B82F6" : Qt.rgba(1, 1, 1, 0.10)
                            Image {
                                anchors.centerIn: parent
                                source: "file:///usr/share/icons/Nexus-OS-Icons/scalable/status/do_not_disturb_bell.svg"
                                width: 16; height: 16; sourceSize.width: 16; sourceSize.height: 16
                            }
                        }
                        Column {
                            Text { text: "Do Not Disturb"; color: "#F8FAFC"; font.family: "SF Pro Display"; font.pixelSize: 11; font.weight: Font.DemiBold }
                            Text { text: root.dndOn ? "On" : "Off"; color: "#94A3B8"; font.family: "SF Pro Display"; font.pixelSize: 10 }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.dndOn = !root.dndOn
                    }
                }

                // Night Light tile
                Rectangle {
                    Layout.fillWidth: true
                    height: 58
                    radius: 14
                    color: root.nightOn ? Qt.rgba(59/255, 130/255, 246/255, 0.24) : Qt.rgba(1, 1, 1, 0.06)
                    border.width: 1
                    border.color: Qt.rgba(1, 1, 1, 0.10)

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10
                        Rectangle {
                            width: 34; height: 34; radius: 17
                            color: root.nightOn ? "#3B82F6" : Qt.rgba(1, 1, 1, 0.10)
                            Image {
                                anchors.centerIn: parent
                                source: "file:///usr/share/icons/Nexus-OS-Icons/scalable/status/night_light_moon.svg"
                                width: 16; height: 16; sourceSize.width: 16; sourceSize.height: 16
                            }
                        }
                        Column {
                            Text { text: "Night Light"; color: "#F8FAFC"; font.family: "SF Pro Display"; font.pixelSize: 11; font.weight: Font.DemiBold }
                            Text { text: root.nightOn ? "On" : "Off"; color: "#94A3B8"; font.family: "SF Pro Display"; font.pixelSize: 10 }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.nightOn = !root.nightOn
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: Qt.rgba(1, 1, 1, 0.08) }

            // Available Networks Header
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "AVAILABLE NETWORKS"
                    color: "#94A3B8"
                    font.family: "SF Pro Display"
                    font.pixelSize: 10
                    font.weight: Font.DemiBold
                    font.letterSpacing: 0.6
                }
                Item { Layout.fillWidth: true }
                Rectangle {
                    width: 68; height: 20; radius: 10
                    color: Qt.rgba(16/255, 185/255, 129/255, 0.22)
                    border.width: 1
                    border.color: Qt.rgba(52/255, 211/255, 153/255, 0.4)
                    Text {
                        anchors.centerIn: parent
                        text: root.netStatus
                        color: "#34D399"
                        font.family: "SF Pro Display"
                        font.pixelSize: 10
                        font.weight: Font.DemiBold
                    }
                }
            }

            // Network rows
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    height: 36
                    radius: 10
                    color: Qt.rgba(1, 1, 1, 0.06)
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        Image {
                            source: "file:///usr/share/icons/Nexus-OS-Icons/scalable/status/wifi_signal.svg"
                            width: 14; height: 14; sourceSize.width: 14; sourceSize.height: 14
                        }
                        Text {
                            text: root.activeNetName
                            color: "#F8FAFC"
                            font.family: "SF Pro Display"
                            font.pixelSize: 12
                            Layout.fillWidth: true
                        }
                        Text {
                            text: "\u2713"
                            color: "#38BDF8"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 34
                    radius: 10
                    color: netSettingsMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        Text {
                            text: "Open Network & Wi-Fi Settings..."
                            color: "#94A3B8"
                            font.family: "SF Pro Display"
                            font.pixelSize: 11
                            Layout.fillWidth: true
                        }
                        Text { text: "\u203A"; color: "#94A3B8"; font.pixelSize: 13 }
                    }
                    MouseArea {
                        id: netSettingsMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            root.expanded = false
                            root.runCmd("systemsettings kcm_networkmanagement &")
                        }
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: Qt.rgba(1, 1, 1, 0.08) }

            // Volume Slider
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "file:///usr/share/icons/Nexus-OS-Icons/scalable/status/volume_speaker.svg"
                    width: 15; height: 15; sourceSize.width: 15; sourceSize.height: 15
                }

                Item {
                    Layout.fillWidth: true
                    height: 20

                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        height: 5
                        radius: 2.5
                        color: Qt.rgba(1, 1, 1, 0.14)

                        Rectangle {
                            width: parent.width * (root.volumePct / 100.0)
                            height: parent.height
                            radius: 2.5
                            color: "#38BDF8"
                        }
                    }

                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        x: Math.max(0, Math.min(parent.width - width, parent.width * (root.volumePct / 100.0) - width / 2))
                        width: 14; height: 14; radius: 7
                        color: "#FFFFFF"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onPressed: function(mouse) { updateVol(mouse.x) }
                        onPositionChanged: function(mouse) { if (pressed) updateVol(mouse.x) }
                        function updateVol(mx) {
                            var pct = Math.round(Math.max(0, Math.min(100, (mx / width) * 100)))
                            root.volumePct = pct
                            root.runCmd("pactl set-sink-volume @DEFAULT_SINK@ " + pct + "% || wpctl set-volume @DEFAULT_AUDIO_SINK@ " + (pct / 100.0))
                        }
                    }
                }

                Text {
                    text: root.volumePct + "%"
                    color: "#CBD5E1"
                    font.family: "SF Pro Display"
                    font.pixelSize: 11
                    Layout.preferredWidth: 32
                    horizontalAlignment: Text.AlignRight
                }
            }

            // Bottom Battery + Power Actions
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Rectangle {
                    width: 72; height: 30; radius: 15
                    color: Qt.rgba(1, 1, 1, 0.06)
                    border.width: 1
                    border.color: Qt.rgba(1, 1, 1, 0.10)
                    Row {
                        anchors.centerIn: parent
                        spacing: 6
                        Image {
                            source: "file:///usr/share/icons/Nexus-OS-Icons/scalable/status/battery.svg"
                            width: 14; height: 14; sourceSize.width: 14; sourceSize.height: 14
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: "92%"
                            color: "#E2E8F0"
                            font.family: "SF Pro Display"
                            font.pixelSize: 11
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    width: 30; height: 30; radius: 15
                    color: lockBtn.containsMouse ? Qt.rgba(1, 1, 1, 0.14) : Qt.rgba(1, 1, 1, 0.06)
                    Text { anchors.centerIn: parent; text: "\uD83D\uDD12"; color: "#E2E8F0"; font.pixelSize: 12 }
                    MouseArea { id: lockBtn; anchors.fill: parent; hoverEnabled: true; onClicked: { root.expanded = false; root.runCmd("loginctl lock-session") } }
                }

                Rectangle {
                    width: 30; height: 30; radius: 15
                    color: rebBtn.containsMouse ? Qt.rgba(1, 1, 1, 0.14) : Qt.rgba(1, 1, 1, 0.06)
                    Text { anchors.centerIn: parent; text: "\u21BB"; color: "#E2E8F0"; font.pixelSize: 13 }
                    MouseArea { id: rebBtn; anchors.fill: parent; hoverEnabled: true; onClicked: root.runCmd("systemctl reboot") }
                }

                Rectangle {
                    width: 30; height: 30; radius: 15
                    color: pwrBtn.containsMouse ? Qt.rgba(239/255, 68/255, 68/255, 0.45) : Qt.rgba(239/255, 68/255, 68/255, 0.24)
                    border.width: 1
                    border.color: Qt.rgba(248/255, 113/255, 113/255, 0.40)
                    Text { anchors.centerIn: parent; text: "\u23FB"; color: "#FCA5A5"; font.pixelSize: 13 }
                    MouseArea { id: pwrBtn; anchors.fill: parent; hoverEnabled: true; onClicked: root.runCmd("systemctl poweroff") }
                }
            }
        }
    }
}
