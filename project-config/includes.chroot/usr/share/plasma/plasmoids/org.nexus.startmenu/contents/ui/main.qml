import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.plasma5support 2.0 as P5Support

PlasmoidItem {
    id: root
    preferredRepresentation: compactRepresentation

    property string searchQuery: ""

    P5Support.DataSource {
        id: exec
        engine: "executable"
        connectedSources: []
        onNewData: function(sourceName, data) {
            disconnectSource(sourceName)
        }
    }

    function launchApp(cmd) {
        root.expanded = false
        exec.connectSource(cmd + " &")
    }

    property var pinnedApps: [
        { name: "Files",      cmd: "dolphin",         icon: "file:///usr/share/icons/Nexus-OS-Icons/128x128/apps/dolphin.png" },
        { name: "Browser",    cmd: "falkon",          icon: "file:///usr/share/icons/Nexus-OS-Icons/128x128/apps/falkon.png" },
        { name: "Terminal",   cmd: "konsole",         icon: "file:///usr/share/icons/Nexus-OS-Icons/128x128/apps/konsole.png" },
        { name: "Notepad",    cmd: "kate",            icon: "file:///usr/share/icons/Nexus-OS-Icons/128x128/apps/kate.png" },
        { name: "Calculator", cmd: "kcalc",           icon: "file:///usr/share/icons/Nexus-OS-Icons/128x128/apps/kcalc.png" },
        { name: "Discover",   cmd: "plasma-discover", icon: "file:///usr/share/icons/Nexus-OS-Icons/128x128/apps/discover.png" },
        { name: "Photos",     cmd: "gwenview",        icon: "file:///usr/share/icons/Nexus-OS-Icons/128x128/apps/gwenview.png" },
        { name: "Media",      cmd: "vlc",             icon: "file:///usr/share/icons/Nexus-OS-Icons/128x128/apps/vlc.png" },
        { name: "Archive",    cmd: "ark",             icon: "file:///usr/share/icons/Nexus-OS-Icons/128x128/apps/ark.png" },
        { name: "Settings",   cmd: "systemsettings",  icon: "file:///usr/share/icons/Nexus-OS-Icons/128x128/apps/systemsettings.png" }
    ]

    compactRepresentation: MouseArea {
        Layout.minimumWidth: 46
        Layout.preferredWidth: 46
        Layout.minimumHeight: 46
        Layout.preferredHeight: 46
        implicitWidth: 46
        implicitHeight: 46
        hoverEnabled: true
        onClicked: {
            root.expanded = !root.expanded
        }

        Image {
            anchors.centerIn: parent
            source: "file:///usr/share/pixmaps/nexus-logo.png"
            width: parent.containsMouse ? 38 : 34
            height: parent.containsMouse ? 38 : 34
            fillMode: Image.PreserveAspectFit
            smooth: true
            Behavior on width { NumberAnimation { duration: 120 } }
            Behavior on height { NumberAnimation { duration: 120 } }
        }
    }

    fullRepresentation: Item {
        implicitWidth: 460
        implicitHeight: 370

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 14

            // Search bar
            Rectangle {
                Layout.fillWidth: true
                height: 38
                radius: 12
                color: Qt.rgba(1, 1, 1, 0.06)
                border.width: 1
                border.color: searchInput.activeFocus ? Qt.rgba(96/255, 165/255, 250/255, 0.6) : Qt.rgba(1, 1, 1, 0.12)

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8

                    Text {
                        text: "\uD83D\uDD0D"
                        color: "#94A3B8"
                        font.pixelSize: 13
                    }

                    TextInput {
                        id: searchInput
                        Layout.fillWidth: true
                        color: "#F8FAFC"
                        font.family: "SF Pro Display"
                        font.pixelSize: 13
                        onTextChanged: root.searchQuery = text.toLowerCase()

                        Text {
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            text: "Search apps, files, and settings..."
                            color: "#64748B"
                            font.family: "SF Pro Display"
                            font.pixelSize: 13
                            visible: searchInput.text.length === 0
                        }
                    }
                }
            }

            // Pinned Header
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "Pinned"
                    color: "#E2E8F0"
                    font.family: "SF Pro Display"
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                }
                Item { Layout.fillWidth: true }
                Rectangle {
                    width: 68
                    height: 22
                    radius: 11
                    color: Qt.rgba(1, 1, 1, 0.08)
                    border.width: 1
                    border.color: Qt.rgba(1, 1, 1, 0.10)
                    Text {
                        anchors.centerIn: parent
                        text: "All Apps \u203A"
                        color: "#CBD5E1"
                        font.family: "SF Pro Display"
                        font.pixelSize: 11
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.launchApp("qdbus6 org.kde.krunner /App display")
                    }
                }
            }

            // 5x2 Pinned App Grid
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 5
                columnSpacing: 10
                rowSpacing: 12

                Repeater {
                    model: root.pinnedApps.filter(function(a) {
                        return root.searchQuery === "" || a.name.toLowerCase().indexOf(root.searchQuery) !== -1
                    })

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 82
                        radius: 12
                        color: itemMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.08) : "transparent"

                        Column {
                            anchors.centerIn: parent
                            spacing: 6

                            Image {
                                anchors.horizontalCenter: parent.horizontalCenter
                                source: modelData.icon
                                width: 42
                                height: 42
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.name
                                color: "#E2E8F0"
                                font.family: "SF Pro Display"
                                font.pixelSize: 11
                            }
                        }

                        MouseArea {
                            id: itemMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: root.launchApp(modelData.cmd)
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Qt.rgba(1, 1, 1, 0.08)
            }

            // Bottom User & Power Bar
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Rectangle {
                    width: 28
                    height: 28
                    radius: 14
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "#3B82F6" }
                        GradientStop { position: 0.5; color: "#A855F7" }
                        GradientStop { position: 1.0; color: "#F97316" }
                    }
                    Text {
                        anchors.centerIn: parent
                        text: "N"
                        color: "#FFFFFF"
                        font.family: "SF Pro Display"
                        font.pixelSize: 12
                        font.weight: Font.Bold
                    }
                }

                Text {
                    text: "Nexus User"
                    color: "#E2E8F0"
                    font.family: "SF Pro Display"
                    font.pixelSize: 12
                    font.weight: Font.Medium
                }

                Item { Layout.fillWidth: true }

                Repeater {
                    model: [
                        { sym: "\uD83D\uDD12", cmd: "loginctl lock-session" },
                        { sym: "\u21BB",       cmd: "systemctl reboot" },
                        { sym: "\u23FB",       cmd: "systemctl poweroff" }
                    ]
                    Rectangle {
                        width: 28
                        height: 28
                        radius: 14
                        color: pwrMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.12) : "transparent"
                        Text {
                            anchors.centerIn: parent
                            text: modelData.sym
                            color: "#CBD5E1"
                            font.pixelSize: 13
                        }
                        MouseArea {
                            id: pwrMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: root.launchApp(modelData.cmd)
                        }
                    }
                }
            }
        }
    }
}
