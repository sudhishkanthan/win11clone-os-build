// The Nexus OS Default Desktop Layout for KDE Plasma 6
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

// 1. TOP CENTER PILL: Minimal floating time & date island
var topPill = new Panel();
topPill.location = "top";
topPill.alignment = "center";
topPill.height = 32;
topPill.floating = true;

var clock = topPill.addWidget("org.kde.plasma.digitalclock");
clock.currentConfigGroup = ["Appearance"];
clock.writeConfig("showDate", "true");
clock.writeConfig("dateFormat", "custom");
clock.writeConfig("customDateFormat", "HH:mm • ddd, MMM d");

// 2. BOTTOM FLOATING DOCK: Centered application bar
var dock = new Panel();
dock.location = "bottom";
dock.alignment = "center";
dock.height = 64;
dock.floating = true;

// Search trigger / Application Launcher
var search = dock.addWidget("org.kde.plasma.kickoff");
search.currentConfigGroup = ["General"];
search.writeConfig("icon", "edit-find");
search.writeConfig("favoritesPortedToKAstats", "true");

// Pinned App Launchers
var tasks = dock.addWidget("org.kde.plasma.icontasks");
tasks.currentConfigGroup = ["General"];
tasks.writeConfig("launchers", [
    "applications:org.kde.dolphin.desktop",
    "applications:org.kde.falkon.desktop",
    "applications:firefox-esr.desktop",
    "applications:org.kde.konsole.desktop",
    "applications:org.kde.kate.desktop",
    "applications:org.kde.kcalc.desktop",
    "applications:org.kde.plasma.discover.desktop",
    "applications:org.kde.gwenview.desktop",
    "applications:org.kde.ark.desktop",
    "applications:systemsettings.desktop"
].join(","));
tasks.writeConfig("indicateAudioStreams", "true");

// Trash Widget inside dock
dock.addWidget("org.kde.plasma.trash");

// 3. BOTTOM RIGHT STATUS ISLAND: Wi-Fi, Volume, Battery, Power
var statusPill = new Panel();
statusPill.location = "bottom";
statusPill.alignment = "right";
statusPill.height = 64;
statusPill.floating = true;

statusPill.addWidget("org.kde.plasma.systemtray");
