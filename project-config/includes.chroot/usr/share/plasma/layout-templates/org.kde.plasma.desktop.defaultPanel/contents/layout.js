// The Nexus OS Default Panel Layout Template
var panel = new Panel();
panel.location = "bottom";
panel.alignment = "center";
panel.lengthMode = "fit";
panel.opacity = "translucent";
panel.height = 60;
panel.floating = true;

panel.addWidget("org.nexus.startmenu");

var tasks = panel.addWidget("org.kde.plasma.icontasks");
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

panel.addWidget("org.kde.plasma.marginsseparator");
panel.addWidget("org.kde.plasma.trash");
