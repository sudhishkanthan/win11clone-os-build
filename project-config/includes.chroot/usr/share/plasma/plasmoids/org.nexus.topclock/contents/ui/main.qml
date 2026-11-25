import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.plasma5support 2.0 as P5Support

PlasmoidItem {
    id: root
    preferredRepresentation: compactRepresentation

    P5Support.DataSource {
        id: exec
        engine: "executable"
        connectedSources: []
        onNewData: function(sourceName, data) {
            disconnectSource(sourceName)
        }
    }

    compactRepresentation: MouseArea {
        id: compactRoot
        Layout.minimumWidth: clockLabel.implicitWidth + 32
        Layout.preferredWidth: Layout.minimumWidth
        Layout.minimumHeight: 28
        Layout.preferredHeight: 28
        implicitWidth: clockLabel.implicitWidth + 32
        implicitHeight: 28
        hoverEnabled: true
        onClicked: root.expanded = !root.expanded

        Text {
            id: clockLabel
            anchors.centerIn: parent
            text: Qt.formatDateTime(new Date(), "HH:mm  •  ddd, MMM d")
            color: "#F8FAFC"
            font.family: "SF Pro Display"
            font.pixelSize: 13
            font.weight: Font.Medium
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clockLabel.text = Qt.formatDateTime(new Date(), "HH:mm  •  ddd, MMM d")
        }
    }

    fullRepresentation: Item {
        implicitWidth: 300
        implicitHeight: 330

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            Text {
                id: bigTime
                Layout.alignment: Qt.AlignHCenter
                text: Qt.formatTime(new Date(), "HH:mm")
                color: "#FFFFFF"
                font.family: "SF Pro Display"
                font.pixelSize: 32
                font.weight: Font.Bold
            }

            Text {
                id: fullDate
                Layout.alignment: Qt.AlignHCenter
                text: Qt.formatDate(new Date(), "dddd, MMMM d, yyyy")
                color: "#94A3B8"
                font.family: "SF Pro Display"
                font.pixelSize: 13
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Qt.rgba(1, 1, 1, 0.10)
            }

            // Month calendar grid
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 7
                columnSpacing: 4
                rowSpacing: 4

                Repeater {
                    model: ["S", "M", "T", "W", "T", "F", "S"]
                    Text {
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        text: modelData
                        color: "#64748B"
                        font.family: "SF Pro Display"
                        font.pixelSize: 11
                        font.weight: Font.DemiBold
                    }
                }

                Repeater {
                    model: 31
                    Rectangle {
                        property int dayNum: index + 1
                        property bool isToday: dayNum === new Date().getDate()
                        Layout.fillWidth: true
                        height: 24
                        radius: 12
                        color: isToday ? "#3B82F6" : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: dayNum
                            color: isToday ? "#FFFFFF" : "#CBD5E1"
                            font.family: "SF Pro Display"
                            font.pixelSize: 11
                            font.weight: isToday ? Font.Bold : Font.Normal
                        }
                    }
                }
            }

            // Lock & Switch to Login Screen button
            Rectangle {
                Layout.fillWidth: true
                height: 36
                radius: 18
                color: lockMouse.containsMouse ? Qt.rgba(59/255, 130/255, 246/255, 0.35) : Qt.rgba(59/255, 130/255, 246/255, 0.22)
                border.width: 1
                border.color: Qt.rgba(96/255, 165/255, 250/255, 0.45)

                Text {
                    anchors.centerIn: parent
                    text: "Lock & Switch to Login Screen"
                    color: "#F8FAFC"
                    font.family: "SF Pro Display"
                    font.pixelSize: 12
                    font.weight: Font.Medium
                }

                MouseArea {
                    id: lockMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        root.expanded = false
                        exec.connectSource("loginctl lock-session")
                    }
                }
            }
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                var now = new Date()
                bigTime.text = Qt.formatTime(now, "HH:mm")
                fullDate.text = Qt.formatDate(now, "dddd, MMMM d, yyyy")
            }
        }
    }
}
