import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root
    preferredRepresentation: compactRepresentation
    property date now: new Date()

    Timer { interval: 1000; running: true; repeat: true; onTriggered: root.now = new Date() }

    Plasma5Support.DataSource {
        id: exec
        engine: "executable"
        connectedSources: []
        onNewData: (source) => disconnectSource(source)
        function run(cmd) { connectSource(cmd) }
    }

    compactRepresentation: Item {
        Layout.preferredWidth: 210
        Layout.preferredHeight: 32
        Text {
            anchors.centerIn: parent
            text: Qt.formatTime(root.now, "HH:mm") + "  •  " + Qt.formatDate(root.now, "ddd, MMM d")
            color: "#F8FAFC"
            font.family: "SF Pro Display"
            font.pixelSize: 14
            font.weight: Font.Medium
        }
        MouseArea { anchors.fill: parent; onClicked: root.expanded = !root.expanded }
    }

    fullRepresentation: Item {
        Layout.preferredWidth: 344
        Layout.preferredHeight: 290
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 14

            Column {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Qt.formatTime(root.now, "HH:mm")
                    color: "#FFFFFF"
                    font.family: "SF Pro Display"
                    font.pixelSize: 40
                    font.bold: true
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Qt.formatDate(root.now, "dddd, MMMM d, yyyy")
                    color: "#BAE6FD"
                    font.family: "SF Pro Display"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#20FFFFFF" }

            MonthGrid {
                Layout.fillWidth: true
                Layout.fillHeight: true
                month: root.now.getMonth()
                year: root.now.getFullYear()
                delegate: Rectangle {
                    radius: 8
                    color: model.today ? "#38BDF8" : "transparent"
                    Text {
                        anchors.centerIn: parent
                        text: model.day
                        color: model.today ? "#082F49" : (model.month === root.now.getMonth() ? "#F1F5F9" : "#475569")
                        font.family: "SF Pro Display"
                        font.pixelSize: 12
                        font.bold: model.today
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                radius: 13
                color: lockMa.containsMouse ? "#5538BDF8" : "#4238BDF8"
                border.color: "#8038BDF8"
                Row {
                    anchors.centerIn: parent
                    spacing: 10
                    Image { source: "/usr/share/icons/NexusOS/32x32/actions/system-lock-screen-symbolic.png"; width: 16; height: 16 }
                    Text { text: "Lock & Switch to Login Screen"; color: "#FFFFFF"; font.family: "SF Pro Display"; font.pixelSize: 14; font.bold: true }
                }
                MouseArea {
                    id: lockMa
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        exec.run("loginctl lock-session")
                        root.expanded = false
                    }
                }
            }
        }
    }
}
