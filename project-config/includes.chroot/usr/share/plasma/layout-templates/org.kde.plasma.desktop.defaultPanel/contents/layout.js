// The Nexus OS Default Panel Layout Template
var panel = new Panel();
panel.location = "bottom";
panel.alignment = "center";
panel.height = 64;
panel.floating = true;

var search = panel.addWidget("org.kde.plasma.kickoff");
search.currentConfigGroup = ["General"];
search.writeConfig("icon", "edit-find");

var tasks = panel.addWidget("org.kde.plasma.icontasks");
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

panel.addWidget("org.kde.plasma.trash");
