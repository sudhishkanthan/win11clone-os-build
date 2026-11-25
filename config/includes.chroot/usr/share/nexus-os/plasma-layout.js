// The Nexus OS 1.1 — Pixel-Matched Plasma 6 Shell Layout

var allDesktops = desktops();
for (var i = 0; i < allDesktops.length; i++) {
    var d = allDesktops[i];
    d.wallpaperPlugin = "org.kde.image";
    d.currentConfigGroup = ["Wallpaper", "org.kde.image", "General"];
    d.writeConfig("Image", "file:///usr/share/wallpapers/NexusOS/contents/images/1920x1080.png");
    d.writeConfig("FillMode", 2);
}

var existingPanels = panels();
for (var p = 0; p < existingPanels.length; p++) {
    existingPanels[p].remove();
}

// 1. TOP CENTER CLOCK NOTCH
var topNotch = new Panel();
topNotch.location = "top";
topNotch.alignment = "center";
topNotch.floating = true;
topNotch.height = 38;
topNotch.lengthMode = "fit";
topNotch.opacity = "translucent";
topNotch.addWidget("org.nexusos.clocknotch");

// 2. BOTTOM FLOATING DOCK PILL (Custom Peacock Start Menu + Clean Pinned Apps + Trash)
var dock = new Panel();
dock.location = "bottom";
dock.alignment = "center";
dock.floating = true;
dock.height = 68;
dock.lengthMode = "fit";
dock.hiding = "none";
dock.opacity = "translucent";

dock.addWidget("org.nexusos.startmenu");

var tasks = dock.addWidget("org.kde.plasma.icontasks");
tasks.currentConfigGroup = ["General"];
tasks.writeConfig("launchers", [
    "applications:org.kde.dolphin.desktop",
    "applications:firefox-esr.desktop",
    "applications:org.kde.konsole.desktop",
    "applications:org.kde.kate.desktop",
    "applications:org.kde.kcalc.desktop",
    "applications:org.kde.discover.desktop",
    "applications:org.kde.gwenview.desktop",
    "applications:vlc.desktop",
    "applications:org.kde.systemsettings.desktop"
]);
tasks.writeConfig("iconSpacing", 2);

dock.addWidget("org.kde.plasma.marginsseparator");
dock.addWidget("org.kde.plasma.trash");

// 3. BOTTOM-RIGHT SYSTEM TRAY PILL (Translucent Wi-Fi & Quick Settings)
var trayPanel = new Panel();
trayPanel.location = "bottom";
trayPanel.alignment = "right";
trayPanel.floating = true;
trayPanel.height = 68;
trayPanel.lengthMode = "fit";
trayPanel.opacity = "translucent";
trayPanel.addWidget("org.nexusos.quicksettings");
