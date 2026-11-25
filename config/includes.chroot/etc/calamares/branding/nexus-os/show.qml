import QtQuick 2.15
import calamares.slideshow 1.0

Presentation {
    id: presentation

    function nextSlide() {
        presentation.goToNextSlide();
    }

    Timer {
        id: advanceTimer
        interval: 6500
        running: presentation.activatedInCalamares
        repeat: true
        onTriggered: nextSlide()
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#0F131C"
            Column {
                anchors.centerIn: parent
                spacing: 18
                Image { source: "slide_desktop.png"; width: 560; height: 315; fillMode: Image.PreserveAspectFit; anchors.horizontalCenter: parent.horizontalCenter }
                Text { text: "Welcome to The Nexus OS 1.0"; color: "#FFFFFF"; font.family: "SF Pro Display"; font.pixelSize: 22; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                Text { text: "Floating frosted-glass dock, centered Start Menu, and crisp 2.5D icons."; color: "#CBD5E1"; font.family: "SF Pro Display"; font.pixelSize: 14; anchors.horizontalCenter: parent.horizontalCenter }
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#0F131C"
            Column {
                anchors.centerIn: parent
                spacing: 18
                Image { source: "slide_files.png"; width: 560; height: 315; fillMode: Image.PreserveAspectFit; anchors.horizontalCenter: parent.horizontalCenter }
                Text { text: "Fast, Focused Productivity"; color: "#FFFFFF"; font.family: "SF Pro Display"; font.pixelSize: 22; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                Text { text: "Solid dark workspaces with frosted titlebars, File Manager, Notepad, and Office support."; color: "#CBD5E1"; font.family: "SF Pro Display"; font.pixelSize: 14; anchors.horizontalCenter: parent.horizontalCenter }
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#0F131C"
            Column {
                anchors.centerIn: parent
                spacing: 18
                Image { source: "slide_settings.png"; width: 560; height: 315; fillMode: Image.PreserveAspectFit; anchors.horizontalCenter: parent.horizontalCenter }
                Text { text: "Built on Debian 13 + Windows App Ready"; color: "#FFFFFF"; font.family: "SF Pro Display"; font.pixelSize: 22; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                Text { text: "Pre-configured with Wine, Winetricks, Flatpak, and LibreOffice Calc out of the box."; color: "#CBD5E1"; font.family: "SF Pro Display"; font.pixelSize: 14; anchors.horizontalCenter: parent.horizontalCenter }
            }
        }
    }
}
