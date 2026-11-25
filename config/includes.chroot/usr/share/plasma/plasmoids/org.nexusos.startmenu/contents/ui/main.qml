import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root
    preferredRepresentation: compactRepresentation

    Plasma5Support.DataSource {
        id: exec
        engine: "executable"
        connectedSources: []
        onNewData: (source) => disconnectSource(source)
        function run(cmd) { connectSource(cmd) }
    }

    property var pinnedApps: [
        { name: "Files",      icon: "/usr/share/icons/NexusOS/128x128/apps/system-file-manager.png", cmd: "dolphin" },
        { name: "Browser",    icon: "/usr/share/icons/NexusOS/128x128/apps/internet-web-browser.png", cmd: "firefox-esr" },
        { name: "Terminal",   icon: "/usr/share/icons/NexusOS/128x128/apps/utilities-terminal.png", cmd: "konsole" },
        { name: "Notepad",    icon: "/usr/share/icons/NexusOS/128x128/apps/accessories-text-editor.png", cmd: "kate" },
        { name: "Calculator", icon: "/usr/share/icons/NexusOS/128x128/apps/accessories-calculator.png", cmd: "kcalc" },
        { name: "Discover",   icon: "/usr/share/icons/NexusOS/128x128/apps/plasmadiscover.png", cmd: "plasma-discover" },
        { name: "Photos",     icon: "/usr/share/icons/NexusOS/128x128/apps/org.kde.gwenview.png", cmd: "gwenview" },
        { name: "Media",      icon: "/usr/share/icons/NexusOS/128x128/apps/vlc.png", cmd: "vlc" },
        { name: "Archive",    icon: "/usr/share/icons/NexusOS/128x128/apps/org.kde.ark.png", cmd: "ark" },
        { name: "Settings",   icon: "/usr/share/icons/NexusOS/128x128/apps/preferences-system.png", cmd: "systemsettings" }
    ]

    compactRepresentation: Item {
        Layout.preferredWidth: 52
        Layout.preferredHeight: 52
        Image {
            anchors.centerIn: parent
            width: 44; height: 44
            source: "/usr/share/nexus-os/branding/nexus-logo.png"
            fillMode: Image.PreserveAspectFit
            smooth: true
            scale: ma.containsMouse ? 1.1 : 1.0
            Behavior on scale { NumberAnimation { duration: 120 } }
        }
        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.expanded = !root.expanded
        }
    }

    fullRepresentation: Item {
        Layout.preferredWidth: 500
        Layout.preferredHeight: 374
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 14

            // Search Bar
            TextField {
                id: searchBox
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                placeholderText: "Search apps, files, and settings..."
                placeholderTextColor: "#94A3B8"
                color: "#F8FAFC"
                font.family: "SF Pro Display"
                font.pixelSize: 14
                leftPadding: 16
                background: Rectangle {
                    radius: 12
                    color: "#18FFFFFF"
                    border.color: "#22FFFFFF"
                }
                Keys.onReturnPressed: {
                    if (text.length > 0) {
                        exec.run("krunner " + text)
                        root.expanded = false
                    }
                }
            }

            // Pinned Header
            RowLayout {
                Layout.fillWidth: true
                Text { text: "Pinned"; color: "#F1F5F9"; font.family: "SF Pro Display"; font.pixelSize: 13; font.bold: true }
                Item { Layout.fillWidth: true }
                Rectangle {
                    width: 74; height: 24; radius: 8; color: "#14FFFFFF"
                    Text { anchors.centerIn: parent; text: "All Apps ›"; color: "#CBD5E1"; font.family: "SF Pro Display"; font.pixelSize: 11 }
                    MouseArea { anchors.fill: parent; onClicked: { exec.run("krunner"); root.expanded = false } }
                }
            }

            // 5x2 Pinned App Grid
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 5
                rowSpacing: 12
                columnSpacing: 8
                Repeater {
                    model: root.pinnedApps
                    delegate: Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 82
                        Column {
                            anchors.centerIn: parent
                            spacing: 6
                            Image {
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: 48; height: 48
                                source: modelData.icon
                                fillMode: Image.PreserveAspectFit
                                scale: appMa.containsMouse ? 1.12 : 1.0
                                Behavior on scale { NumberAnimation { duration: 110 } }
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.name
                                color: "#F1F5F9"
                                font.family: "SF Pro Display"
                                font.pixelSize: 12
                            }
                        }
                        MouseArea {
                            id: appMa
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: { exec.run(modelData.cmd); root.expanded = false }
                        }
                    }
                }
            }

            // Footer Bar (Avatar + Power Controls)
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 46
                radius: 14
                color: "#22060B11"
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12; anchors.rightMargin: 12
                    Rectangle {
                        width: 28; height: 28; radius: 14
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#2563EB" }
                            GradientStop { position: 0.5; color: "#9333EA" }
                            GradientStop { position: 1.0; color: "#F97316" }
                        }
                        Text { anchors.centerIn: parent; text: "N"; color: "#FFFFFF"; font.bold: true; font.pixelSize: 12 }
                    }
                    Text { text: "Desktop User"; color: "#F1F5F9"; font.family: "SF Pro Display"; font.pixelSize: 13; font.weight: Font.Medium }
                    Item { Layout.fillWidth: true }
                    Row {
                        spacing: 16
                        Image { source: "/usr/share/icons/NexusOS/32x32/actions/system-lock-screen-symbolic.png"; width: 18; height: 18; MouseArea { anchors.fill: parent; onClicked: { exec.run("loginctl lock-session"); root.expanded = false } } }
                        Image { source: "/usr/share/icons/NexusOS/32x32/actions/system-suspend-symbolic.png"; width: 18; height: 18; MouseArea { anchors.fill: parent; onClicked: { exec.run("systemctl suspend"); root.expanded = false } } }
                        Image { source: "/usr/share/icons/NexusOS/32x32/actions/system-reboot-symbolic.png"; width: 18; height: 18; MouseArea { anchors.fill: parent; onClicked: { exec.run("systemctl reboot"); root.expanded = false } } }
                        Image { source: "/usr/share/icons/NexusOS/32x32/actions/system-shutdown-symbolic.png"; width: 18; height: 18; MouseArea { anchors.fill: parent; onClicked: { exec.run("systemctl poweroff"); root.expanded = false } } }
                    }
                }
            }
        }
    }
}
