import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#07090E"

    // Blurred Light Streaks Wallpaper
    Image {
        id: bgImg
        anchors.fill: parent
        source: "wallpaper.png"
        fillMode: Image.PreserveAspectCrop
        visible: false
    }
    MultiEffect {
        source: bgImg
        anchors.fill: bgImg
        blurEnabled: true
        blur: 0.85
        blurMax: 48
        brightness: -0.18
    }

    // Top Center Nexus OS Branding
    Row {
        anchors.top: parent.top
        anchors.topMargin: 36
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 12
        Image { source: "nexus-logo.png"; width: 28; height: 28; fillMode: Image.PreserveAspectFit }
        Image { source: "nexus-wordmark.png"; height: 18; fillMode: Image.PreserveAspectFit; anchors.verticalCenter: parent.verticalCenter }
    }

    // Giant SF Pro Display Clock & Date
    Column {
        anchors.top: parent.top
        anchors.topMargin: 120
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 6
        Text {
            id: clockText
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "SF Pro Display"
            font.pixelSize: 108
            font.weight: Font.Bold
            color: "#FFFFFF"
            text: Qt.formatTime(new Date(), "HH:mm")
        }
        Text {
            id: dateText
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "SF Pro Display"
            font.pixelSize: 22
            font.weight: Font.Medium
            color: "#DCE6F2"
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
        }
        Timer {
            interval: 1000; running: true; repeat: true
            onTriggered: {
                clockText.text = Qt.formatTime(new Date(), "HH:mm")
                dateText.text = Qt.formatDate(new Date(), "dddd, MMMM d")
            }
        }
    }

    // BOX-FREE LOGIN AREA (No card background behind password!)
    Column {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 76
        spacing: 14
        width: 300

        Rectangle {
            width: 88; height: 88; radius: 44
            anchors.horizontalCenter: parent.horizontalCenter
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#2563EB" }
                GradientStop { position: 0.5; color: "#9333EA" }
                GradientStop { position: 1.0; color: "#F97316" }
            }
            border.color: "#48FFFFFF"
            border.width: 2
            Text {
                anchors.centerIn: parent
                text: "N"
                color: "#FFFFFF"
                font.family: "SF Pro Display"
                font.pixelSize: 36
                font.weight: Font.Bold
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: userModel.lastUser || "live"
            color: "#FFFFFF"
            font.family: "SF Pro Display"
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        // Transparent outlined password pill directly on wallpaper
        TextField {
            id: passwordField
            width: 284; height: 44
            anchors.horizontalCenter: parent.horizontalCenter
            echoMode: TextInput.Password
            color: "#FFFFFF"
            font.family: "SF Pro Display"
            font.pixelSize: 16
            horizontalAlignment: TextInput.AlignHCenter
            placeholderText: "Enter password"
            placeholderTextColor: "#80FFFFFF"
            focus: true
            background: Rectangle {
                radius: 22
                color: "transparent"
                border.color: passwordField.activeFocus ? "#A0FFFFFF" : "#60FFFFFF"
                border.width: 1.5
            }
            Keys.onReturnPressed: sddm.login(userModel.lastUser || "live", passwordField.text, sessionModel.lastIndex)
            Keys.onEnterPressed: sddm.login(userModel.lastUser || "live", passwordField.text, sessionModel.lastIndex)
        }
    }

    // Bottom-Right White Symbolic Power Controls
    Row {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 48
        anchors.bottomMargin: 38
        spacing: 24
        Image {
            source: "sleep.png"; width: 24; height: 24
            MouseArea { anchors.fill: parent; onClicked: sddm.suspend() }
        }
        Image {
            source: "restart.png"; width: 24; height: 24
            MouseArea { anchors.fill: parent; onClicked: sddm.reboot() }
        }
        Image {
            source: "power.png"; width: 24; height: 24
            MouseArea { anchors.fill: parent; onClicked: sddm.powerOff() }
        }
    }
}
