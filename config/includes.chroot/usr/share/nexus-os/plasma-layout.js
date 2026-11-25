// The Nexus OS 1.0 — Pixel-Matched Plasma 6 Shell Layout (using custom Nexus QML Plasmoids)

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

// 1. TOP CENTER CLOCK NOTCH (Custom Nexus Clock & Calendar -> Lock Plasmoid)
var topNotch = new Panel();
topNotch.location = "top";
topNotch.alignment = "center";
topNotch.floating = true;
topNotch.height = 38;
topNotch.lengthMode = "fit";
topNotch.addWidget("org.nexusos.clocknotch");

// 2. BOTTOM FLOATING DOCK PILL (Custom Nexus Start Menu + Search + Pinned Apps + Trash)
var dock = new Panel();
dock.location = "bottom";
dock.alignment = "center";
dock.floating = true;
dock.height = 68;
dock.lengthMode = "fit";
dock.hiding = "none";

dock.addWidget("org.nexusos.startmenu");
dock.addWidget("org.kde.plasma.krunner");

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
    "applications:systemsettings.desktop"
]);
tasks.writeConfig("iconSpacing", 2);

dock.addWidget("org.kde.plasma.marginsseparator");
dock.addWidget("org.kde.plasma.trash");

// 3. BOTTOM-RIGHT SYSTEM TRAY PILL (Custom Translucent Wi-Fi & Quick Settings Plasmoid)
var trayPanel = new Panel();
trayPanel.location = "bottom";
trayPanel.alignment = "right";
trayPanel.floating = true;
trayPanel.height = 68;
trayPanel.lengthMode = "fit";
trayPanel.addWidget("org.nexusos.quicksettings");
