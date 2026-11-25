import QtQuick 2.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#080B12"

    property int sessionIndex: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0
    property string currentUser: userModel.lastUser !== "" ? userModel.lastUser : "nexus"

    // Pre-blurred Light Streaks wallpaper
    Image {
        id: bgImage
        anchors.fill: parent
        source: config.background ? config.background : "/usr/share/wallpapers/NexusOS/contents/images/1920x1080-blur.jpg"
        fillMode: Image.PreserveAspectCrop
        smooth: true
    }

    // Subtle dark obsidian vignette for crisp contrast
    Rectangle {
        anchors.fill: parent
        color: "#06090F"
        opacity: 0.30
    }

    // Top-center OS Logo + Name
    Row {
        anchors.top: parent.top
        anchors.topMargin: 28
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        Image {
            source: "/usr/share/pixmaps/nexus-logo.png"
            width: 22
            height: 22
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
            smooth: true
        }

        Text {
            text: "The Nexus OS"
            color: "#E2E8F0"
            font.family: "SF Pro Display"
            font.pixelSize: 15
            font.weight: Font.Medium
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // Box-free floating center stack
    Column {
        anchors.centerIn: parent
        spacing: 10
        width: 360

        // Giant Clock
        Text {
            id: clockText
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatTime(new Date(), "HH:mm")
            color: "#FFFFFF"
            font.family: "SF Pro Display"
            font.pixelSize: 78
            font.weight: Font.Bold
        }

        // Date
        Text {
            id: dateText
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            color: "#CBD5E1"
            font.family: "SF Pro Display"
            font.pixelSize: 17
            font.weight: Font.Normal
        }

        Item { width: 1; height: 22 }

        // Circular gradient avatar ("N")
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 88
            height: 88
            radius: 44
            border.width: 2
            border.color: Qt.rgba(1, 1, 1, 0.22)
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "#3B82F6" }
                GradientStop { position: 0.52; color: "#A855F7" }
                GradientStop { position: 1.0; color: "#F97316" }
            }

            Text {
                anchors.centerIn: parent
                text: "N"
                color: "#FFFFFF"
                font.family: "SF Pro Display"
                font.pixelSize: 34
                font.weight: Font.Bold
            }
        }

        Item { width: 1; height: 2 }

        // User display name
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Nexus User"
            color: "#F8FAFC"
            font.family: "SF Pro Display"
            font.pixelSize: 18
            font.weight: Font.DemiBold
        }

        Item { width: 1; height: 6 }

        // Outlined translucent password pill
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 280
            height: 44
            radius: 22
            color: Qt.rgba(12/255, 16/255, 24/255, 0.42)
            border.width: 1
            border.color: passwordInput.activeFocus ? Qt.rgba(1, 1, 1, 0.55) : Qt.rgba(1, 1, 1, 0.24)

            TextInput {
                id: passwordInput
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                verticalAlignment: TextInput.AlignVCenter
                horizontalAlignment: TextInput.AlignHCenter
                echoMode: TextInput.Password
                color: "#FFFFFF"
                font.family: "SF Pro Display"
                font.pixelSize: 15
                focus: true
                selectionColor: "#3B82F6"

                Keys.onReturnPressed: sddm.login(root.currentUser, passwordInput.text, root.sessionIndex)
                Keys.onEnterPressed: sddm.login(root.currentUser, passwordInput.text, root.sessionIndex)
            }
        }

        // Helper / Error text
        Text {
            id: statusLabel
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Enter password to unlock"
            color: "#94A3B8"
            font.family: "SF Pro Display"
            font.pixelSize: 12
        }
    }

    // Bottom-right symbolic power / reboot controls
    Row {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 28
        anchors.rightMargin: 32
        spacing: 18

        Rectangle {
            width: 34
            height: 34
            radius: 17
            color: rebootMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.14) : "transparent"
            Text {
                anchors.centerIn: parent
                text: "\u21BB"
                color: "#E2E8F0"
                font.pixelSize: 16
            }
            MouseArea {
                id: rebootMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: sddm.reboot()
            }
        }

        Rectangle {
            width: 34
            height: 34
            radius: 17
            color: powerMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.14) : "transparent"
            Text {
                anchors.centerIn: parent
                text: "\u23FB"
                color: "#E2E8F0"
                font.pixelSize: 16
            }
            MouseArea {
                id: powerMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: sddm.powerOff()
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var now = new Date()
            clockText.text = Qt.formatTime(now, "HH:mm")
            dateText.text = Qt.formatDate(now, "dddd, MMMM d")
        }
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            passwordInput.text = ""
            statusLabel.text = "Incorrect password — try again"
            statusLabel.color = "#F87171"
        }
    }
}
