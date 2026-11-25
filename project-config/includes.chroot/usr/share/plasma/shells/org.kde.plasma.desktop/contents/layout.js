// The Nexus OS Default Desktop Layout for KDE Plasma 6 (Light Streaks)
var existingPanels = panels();
for (var i = 0; i < existingPanels.length; i++) {
    existingPanels[i].remove();
}

// Wallpaper on all desktops
var allDesktops = desktops();
for (var j = 0; j < allDesktops.length; j++) {
    var d = allDesktops[j];
    d.wallpaperPlugin = "org.kde.image";
    d.currentConfigGroup = ["Wallpaper", "org.kde.image", "General"];
    d.writeConfig("Image", "file:///usr/share/wallpapers/NexusOS/contents/images/1920x1080.jpg");
}

// 1. TOP CENTER PILL: Single-line frosted glass time & date notch
var topPill = new Panel();
topPill.location = "top";
topPill.alignment = "center";
topPill.lengthMode = "fit";
topPill.height = 32;
topPill.floating = true;

topPill.addWidget("org.nexus.topclock");

// 2. BOTTOM FLOATING DOCK: Centered application pill
var dock = new Panel();
dock.location = "bottom";
dock.alignment = "center";
dock.lengthMode = "fit";
dock.height = 60;
dock.floating = true;

// 1st icon on dock: Standalone Nexus N Logo (Start Menu)
var kickoff = dock.addWidget("org.kde.plasma.kickoff");
kickoff.currentConfigGroup = ["General"];
kickoff.writeConfig("icon", "distributor-logo");
kickoff.writeConfig("favoritesPortedToKAstats", "true");
kickoff.reloadConfig();

// Pinned App Launchers
var tasks = dock.addWidget("org.kde.plasma.icontasks");
tasks.currentConfigGroup = ["General"];
tasks.writeConfig("launchers", [
    "applications:nexus-search.desktop",
    "applications:org.kde.dolphin.desktop",
    "applications:org.kde.falkon.desktop",
    "applications:org.kde.konsole.desktop",
    "applications:org.kde.kate.desktop",
    "applications:org.kde.kcalc.desktop",
    "applications:org.kde.discover.desktop",
    "applications:org.kde.gwenview.desktop",
    "applications:vlc.desktop",
    "applications:systemsettings.desktop"
]);
tasks.writeConfig("indicateAudioStreams", "true");
tasks.reloadConfig();

// Subtle divider + Trash Widget inside dock
dock.addWidget("org.kde.plasma.marginsseparator");
dock.addWidget("org.kde.plasma.trash");

// 3. BOTTOM RIGHT STATUS ISLAND: Wi-Fi, Volume, Battery, Power
var statusPill = new Panel();
statusPill.location = "bottom";
statusPill.alignment = "right";
statusPill.lengthMode = "fit";
statusPill.height = 60;
statusPill.floating = true;

var tray = statusPill.addWidget("org.kde.plasma.systemtray");
tray.currentConfigGroup = ["General"];
tray.writeConfig("hiddenItems", [
    "org.kde.plasma.clipboard",
    "org.kde.plasma.devicenotifier",
    "org.kde.plasma.keyboardlayout",
    "org.kde.kscreen",
    "org.kde.plasma.notifications",
    "org.kde.plasma.mediacontroller",
    "org.kde.plasma.brightness",
    "org.kde.plasma.keyboardindicator"
]);
tray.reloadConfig();

var power = statusPill.addWidget("org.kde.plasma.lock_logout");
power.currentConfigGroup = ["General"];
power.writeConfig("show_lockScreen", "false");
power.writeConfig("show_requestShutDown", "true");
power.reloadConfig();
