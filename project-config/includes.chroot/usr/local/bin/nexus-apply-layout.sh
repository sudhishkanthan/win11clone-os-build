#!/usr/bin/env bash
# ==============================================================================
# The Nexus OS First-Login KDE Plasma 6 Layout Script
# ==============================================================================
set -euo pipefail

readonly STAMP_FILE="${HOME}/.config/nexus-layout-applied"
readonly WALLPAPER_PATH="/usr/share/wallpapers/NexusOS/contents/images/1920x1080.jpg"

if command -v VBoxClient-all >/dev/null 2>&1; then
  VBoxClient-all >/dev/null 2>&1 || true
fi

if [[ -f "${STAMP_FILE}" ]]; then
  exit 0
fi

for _ in $(seq 1 30); do
  if gdbus introspect --session --dest org.kde.PlasmaShell --object-path /PlasmaShell >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

read -r -d '' PLASMA_SCRIPT <<'EOF' || true
var existingPanels = panels();
for (var i = 0; i < existingPanels.length; i++) {
    existingPanels[i].remove();
}

var topPill = new Panel();
topPill.location = "top";
topPill.alignment = "center";
topPill.height = 30;
topPill.floating = true;

var clock = topPill.addWidget("org.kde.plasma.digitalclock");
clock.currentConfigGroup = ["Appearance"];
clock.writeConfig("showDate", "true");
clock.writeConfig("dateFormat", "custom");
clock.writeConfig("customDateFormat", "HH:mm • ddd, MMM d");

var dock = new Panel();
dock.location = "bottom";
dock.alignment = "center";
dock.height = 64;
dock.floating = true;

var kickoff = dock.addWidget("org.kde.plasma.kickoff");
kickoff.currentConfigGroup = ["General"];
kickoff.writeConfig("icon", "distributor-logo");
kickoff.writeConfig("favoritesPortedToKAstats", "true");

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
    "applications:systemsettings.desktop"
].join(","));
tasks.writeConfig("indicateAudioStreams", "true");

dock.addWidget("org.kde.plasma.trash");

var statusPill = new Panel();
statusPill.location = "bottom";
statusPill.alignment = "right";
statusPill.height = 64;
statusPill.floating = true;

statusPill.addWidget("org.kde.plasma.systemtray");

var allDesktops = desktops();
for (var j = 0; j < allDesktops.length; j++) {
    var d = allDesktops[j];
    d.wallpaperPlugin = "org.kde.image";
    d.currentConfigGroup = ["Wallpaper", "org.kde.image", "General"];
    d.writeConfig("Image", "file:///usr/share/wallpapers/NexusOS/contents/images/1920x1080.jpg");
}
EOF

gdbus call \
  --session \
  --dest org.kde.PlasmaShell \
  --object-path /PlasmaShell \
  --method org.kde.PlasmaShell.evaluateScript \
  "${PLASMA_SCRIPT}" >/dev/null 2>&1 || true

mkdir -p "$(dirname "${STAMP_FILE}")"
touch "${STAMP_FILE}"
